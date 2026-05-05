#!/usr/bin/env bash
set -euo pipefail

# PhoenixTW Skills Installer
# A flexible installer for AI coding agent skills

VERSION="1.0.0"
REPO="${REPO:-https://github.com/phoenixTW/skills}"
REPO_DIR="${REPO_DIR:-$HOME/.phoenixtw-skills}"
SKILLS_DIR="${SKILLS_DIR:-$REPO_DIR/skills}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Print header
print_header() {
  cat <<'EOF'
  ___  _       _   _      _
 |   \| |_ ___| |_| |_ __| |___
 | |) | '_/ _ \  _|  _/ _` / -_)
 |___/|_| \___/\__|\__\__,_\___|

EOF
}

# Check if running in the repo
check_in_repo() {
  if [[ -d "skills" && -f "README.md" ]]; then
    return 0
  fi
  return 1
}

# Discover available skills
discover_skills() {
  local skills=()

  # If running from repo root
  if check_in_repo; then
    while IFS= read -r -d '' skill_path; do
      if [[ -f "$skill_path/SKILL.md" ]]; then
        local skill_name=$(basename "$skill_path")
        local category=$(basename "$(dirname "$skill_path")")
        skills+=("$category:$skill_name:$skill_path")
      fi
    done < <(find skills -mindepth 2 -maxdepth 2 -type d -print0)
  else
    # If skills are installed in REPO_DIR
    if [[ -d "$SKILLS_DIR" ]]; then
      while IFS= read -r -d '' skill_path; do
        if [[ -f "$skill_path/SKILL.md" ]]; then
          local skill_name=$(basename "$skill_path")
          local category=$(basename "$(dirname "$skill_path")")
          skills+=("$category:$skill_name:$skill_path")
        fi
      done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -type d -print0)
    fi
  fi

  # Sort skills
  IFS=$'\n' sorted=($(sort <<<"${skills[*]}"))
  unset IFS
  printf '%s\n' "${sorted[@]}"
}

# Extract skill name from SKILL.md
extract_skill_name() {
  local skill_file="$1"
  grep -E '^name:' "$skill_file" | sed 's/name: //' | sed 's/"//g' | xargs
}

# Extract skill description from SKILL.md
extract_skill_description() {
  local skill_file="$1"
  grep -E '^description:' "$skill_file" | sed 's/description: //' | sed 's/"//g' | xargs
}

# Display available skills
display_skills() {
  local skills=("$@")

  if [[ ${#skills[@]} -eq 0 ]]; then
    log_error "No skills found to install."
    log_info "Make sure you're running this script from the PhoenixTW skills repository root."
    exit 1
  fi

  echo ""
  echo "Available skills:"
  echo ""

  local current_category=""
  for skill in "${skills[@]}"; do
    IFS=':' read -r category skill_name skill_path <<< "$skill"

    if [[ "$category" != "$current_category" ]]; then
      echo -e "${BLUE}## ${category^}${NC}"
      current_category="$category"
    fi

    local skill_file="$skill_path/SKILL.md"
    local name=$(extract_skill_name "$skill_file")
    local description=$(extract_skill_description "$skill_file")

    printf "  - %-30s %s\n" "$name" "$description"
  done
  echo ""
}

# Get common agent directories
get_agent_dirs() {
  local dirs=()

  # Check for common agent directories
  if [[ -d "$HOME/.claude" ]]; then
    dirs+=("$HOME/.claude")
  fi
  if [[ -d "$HOME/.pi" ]]; then
    dirs+=("$HOME/.pi")
  fi
  if [[ -d "$HOME/.cursor" ]]; then
    dirs+=("$HOME/.cursor")
  fi
  if [[ -d "$HOME/.codex" ]]; then
    dirs+=("$HOME/.codex")
  fi

  printf '%s\n' "${dirs[@]}"
}

# Copy skill to destination
copy_skill() {
  local skill_path="$1"
  local dest_dir="$2"

  local skill_name=$(basename "$skill_path")

  # Create destination directory
  local dest_skill_dir="$dest_dir/skills/$skill_name"
  mkdir -p "$dest_skill_dir"

  # Copy skill files
  if [[ -f "$skill_path/SKILL.md" ]]; then
    cp "$skill_path/SKILL.md" "$dest_skill_dir/SKILL.md"
    log_success "Installed: $skill_name"
  fi

  # Copy bundled resources (if any)
  for file in "$skill_path"/*.md; do
    if [[ -f "$file" && "$(basename "$file")" != "SKILL.md" ]]; then
      cp "$file" "$dest_skill_dir/"
    fi
  done
}

# Interactive selection using fzf if available, otherwise numbered menu
select_skills_interactive() {
  local skills=("$@")

  if command -v fzf &> /dev/null; then
    log_info "Using fzf for selection (Ctrl+D to deselect, Ctrl+A to select all)"
    echo ""

    local selected=()
    while IFS= read -r skill; do
      selected+=("$skill")
    done < <(printf '%s\n' "${skills[@]}" | \
      while IFS=':' read -r category skill_name skill_path; do
        local skill_file="$skill_path/SKILL.md"
        local name=$(extract_skill_name "$skill_file")
        local description=$(extract_skill_description "$skill_file")
        printf "%-30s %s\n" "$name" "$description"
      done | \
      fzf --multi --height 50% --border --prompt "Select skills to install > " --preview-window hidden)

    if [[ ${#selected[@]} -eq 0 ]]; then
      log_warn "No skills selected."
      exit 0
    fi

    printf '%s\n' "${selected[@]}"
  else
    echo ""
    log_info "Using numbered menu (fzf not found - install for better UX)"
    echo ""

    for i in "${!skills[@]}"; do
      IFS=':' read -r category skill_name skill_path <<< "${skills[$i]}"
      local skill_file="$skill_path/SKILL.md"
      local name=$(extract_skill_name "$skill_file")
      printf "%3d) %s\n" "$((i+1))" "$name"
    done

    echo ""
    echo "Enter skill numbers (comma-separated, e.g., 1,3,5 or 1-5):"
    read -r input

    local selected=()
    IFS=',' read -ra choices <<< "$input"

    for choice in "${choices[@]}"; do
      # Handle ranges (e.g., 1-5)
      if [[ "$choice" =~ ^[0-9]+-[0-9]+$ ]]; then
        local start=$(echo "$choice" | cut -d'-' -f1)
        local end=$(echo "$choice" | cut -d'-' -f2)
        for ((i=start-1; i<end; i++)); do
          if [[ $i -ge 0 && $i -lt ${#skills[@]} ]]; then
            selected+=("${skills[$i]}")
          fi
        done
      else
        # Single number
        local idx=$((choice-1))
        if [[ $idx -ge 0 && $idx -lt ${#skills[@]} ]]; then
          selected+=("${skills[$idx]}")
        fi
      fi
    done

    if [[ ${#selected[@]} -eq 0 ]]; then
      log_warn "No valid selections."
      exit 0
    fi

    printf '%s\n' "${selected[@]}"
  fi
}

# Main installation function
main() {
  print_header
  echo "PhoenixTW Skills Installer v$VERSION"
  echo ""

  # Discover skills
  local skills=()
  while IFS= read -r skill; do
    skills+=("$skill")
  done < <(discover_skills)

  # Display skills
  display_skills "${skills[@]}"

  # Select destination
  echo "Select destination directory:"
  echo ""

  local agent_dirs=($(get_agent_dirs))
  local i=1
  for dir in "${agent_dirs[@]}"; do
    echo "  $i) $dir"
    ((i++))
  done
  echo "  $i) Custom path"
  echo ""

  read -p "Enter option [1-$i]: " dest_choice

  local dest_dir=""

  if [[ "$dest_choice" =~ ^[0-9]+$ ]] && [[ $dest_choice -ge 1 ]] && [[ $dest_choice -le ${#agent_dirs[@]} ]]; then
    dest_dir="${agent_dirs[$((dest_choice-1))]}"
  elif [[ "$dest_choice" == "$i" ]]; then
    read -p "Enter custom path: " dest_dir
    dest_dir=$(eval echo "$dest_dir") # Expand ~ and env vars
  else
    log_error "Invalid selection."
    exit 1
  fi

  if [[ -z "$dest_dir" ]]; then
    log_error "No destination specified."
    exit 1
  fi

  log_info "Installing to: $dest_dir"
  echo ""

  # Select skills
  echo "How would you like to select skills?"
  echo "  1) Select individual skills"
  echo "  2) Install all skills"
  echo "  3) Install by category"
  echo ""

  read -p "Enter option [1-3]: " select_option

  local skills_to_install=()

  case $select_option in
    1)
      skills_to_install=($(select_skills_interactive "${skills[@]}"))
      ;;
    2)
      skills_to_install=("${skills[@]}")
      ;;
    3)
      echo ""
      echo "Select categories (comma-separated):"
      echo "  1) engineering"
      echo "  2) product"
      echo ""
      read -p "Enter option [1-2]: " category_choice

      local categories=()
      case $category_choice in
        1)
          categories=("engineering")
          ;;
        2)
          categories=("product")
          ;;
        ,)
          categories=("engineering" "product")
          ;;
        *)
          log_error "Invalid selection."
          exit 1
          ;;
      esac

      for category in "${categories[@]}"; do
        for skill in "${skills[@]}"; do
          if [[ "$skill" == "$category:"* ]]; then
            skills_to_install+=("$skill")
          fi
        done
      done
      ;;
    *)
      log_error "Invalid selection."
      exit 1
      ;;
  esac

  if [[ ${#skills_to_install[@]} -eq 0 ]]; then
    log_warn "No skills selected for installation."
    exit 0
  fi

  echo ""
  log_info "Installing ${#skills_to_install[@]} skill(s)..."
  echo ""

  # Install each skill
  local installed=0
  local failed=0

  for skill in "${skills_to_install[@]}"; do
    IFS=':' read -r category skill_name skill_path <<< "$skill"

    if copy_skill "$skill_path" "$dest_dir"; then
      ((installed++))
    else
      ((failed++))
    fi
  done

  echo ""
  log_success "Installation complete!"
  echo "  Installed: $installed skill(s)"
  if [[ $failed -gt 0 ]]; then
    log_warn "  Failed: $failed skill(s)"
  fi
  echo ""
  log_info "Skills installed to: $dest_dir"
  log_info "Run /setup-phoenixtw-skills in your agent to configure the skills."
}

# Run main
main "$@"
