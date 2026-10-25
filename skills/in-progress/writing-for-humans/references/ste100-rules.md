# ASD-STE100 rules

Copied from [danyuchn/asd-ste100-skill](https://github.com/danyuchn/asd-ste100-skill) (`references/writing-rules.md` and the rule tables in its `SKILL.md`), MIT, see [LICENSE](../LICENSE). `writing-for-humans` writes in the upstream STE-flavored mode: structural rules in full, lexical rules as a direction. Where this file allows the em dash, unslop rule 13 wins and the em dash stays out.

## Structural rules — apply these

| Rule | Do | Don't |
|---|---|---|
| Active voice | "The agent deletes the file." | "The file is deleted (by the agent)." — unless the actor is genuinely unknown or irrelevant |
| No phrasal verbs (Rule 9.3) | "Remove the panel." / "Start the job." | "Take off the panel." / "Spin up the job." — a two-word verb has meanings the parts do not predict |
| One instruction per sentence | "Open the file. Read line 3." | "Open the file and read line 3, then check if it matches." |
| Sentence length | ≤20 words for instructions/procedures, ≤25 words for descriptions | Long compound/subordinate-clause sentences |
| No semicolons (Rule 8.1) | Split into separate sentences | Any semicolon at all — STE bans the mark outright, not only as a clause join. (Rule 8.1 permits every other standard punctuation mark. The em dash is *not* banned by STE, though it often signals a sentence that should be split.) |
| Noun clusters | ≤3 words stacked as a noun phrase ("fuel pump valve") | 4+ word noun stacks ("high pressure fuel pump inlet valve assembly") |
| No ellipsis | Keep the subject, verb, and article explicit even if it reads longer | Drop words to save space ("Files not backed up will be lost" → ambiguous which files) |
| Keep modality | "The request **may have** failed." stays "may have" | Promote a hedge to a fact ("The request failed.") or invent a certainty the source did not state |
| Paragraph limits | One topic per paragraph, ≤6 sentences | Multi-topic paragraphs |
| Lists for sequences | Use a numbered or bulleted list for 3+ steps or conditions | Bury a sequence inside one prose sentence |

## Lexical rules — direction of travel only

| Rule | Do | Don't | Why it is weaker here |
|---|---|---|---|
| One word, one meaning | Pick one verb for one action and reuse it every time (e.g. always "check", never mix "check"/"verify"/"confirm" for the same action) | Rotate synonyms for the same idea across a document | Consistency within a document is checkable. Which word is the *approved* one is not, without the dictionary. |
| One part of speech per word | "Apply oil to the valve" (oil = noun) | "Oil the valve" (oil = verb) | Whether "oil" is approved as a noun only is a dictionary fact. Prefer the noun form when both read equally well. Do not claim compliance. |
| Verb, not noun (Rule 3.7) | "Analyze the log." | "Perform an analysis of the log." — a noun form of an action makes the sentence longer and hides who acts | Rule 3.7 says "use an **approved** verb to describe an action." Preferring the verb form is safe to apply anywhere. Knowing which verb is the approved one needs the dictionary. |
| Domain terms | Keep necessary technical nouns/verbs, but define them once if not common English (STE allows a project-specific glossary beyond its base dictionary) | Use jargon without ever defining it | The glossary allowance is real STE, but the base dictionary it extends is absent. |

## Simple tenses — apply with one exception

STE permits infinitive, imperative, simple present, simple past, simple future, and past participle as adjective. It excludes present perfect and other compound forms: "we received the report", not "we have received the report".

Aircraft manuals never need present perfect, so the exclusion costs the standard nothing. Other text is not always so lucky. "The job has completed" (and its output is available now) and "the job completed" (at some past point) are different statements, and status text frequently needs the first. **Where the compound form carries information the simple form cannot — current relevance, or a hedge as in "may have failed" — keep it and flag the departure.** Elsewhere, follow the rule.

## Scan Checklist

These six habits cover most of what makes machine-written English hard to parse. Each one is mechanical: you can point at the exact word or punctuation mark that breaks the rule, with no judgment call. Scan for all six before you rewrite anything.

1. **Synonym rotation** — the same thing gets several names in one document ("the user", "the customer", "the client"). The reader cannot tell whether they are one thing or three. Fix: pick one name, use it every time.
2. **Hedge stacking** — helper verbs and qualifiers pile up until the sentence asserts nothing ("it is important to note that this may potentially help to improve"). Fix: state the claim, or delete it.
3. **Nominalization** — an action frozen into a noun ("perform an analysis of", "provides assistance to"). Fix: use the verb ("analyze", "helps").
4. **Marketing adjectives** — words that claim quality instead of showing it: seamless, robust, powerful, cutting-edge, effortless, blazing-fast. Fix: delete, or replace with the measurement that earns the claim.
5. **Run-on sentences** — several ideas joined by semicolons or em dashes. Fix: one idea per sentence.
6. **Soft phrasal verbs** — spin up, reach out, dive into, kick off. Fix: use the single plain verb (start, contact, read, begin).

## Background

The sections below summarize the public, official description of ASD-STE100 (Simplified Technical English). It paraphrases rule *categories*. It does not reproduce the standard's text or its ~900-word dictionary verbatim. For the authoritative document, request the free download at the official site.

### What ASD-STE100 Is

ASD-STE100 is a controlled natural language, first released in 1986 (as AECMA Document PSC-85-16598) by what is now ASD (the AeroSpace and Defense Industries Association of Europe). It was built at the request of European airlines — most staffed by non-native English speakers — who needed maintenance documentation that could not be misread, because a misread instruction on an aircraft can kill people. The standard is maintained by the Simplified Technical English Maintenance Group (STEMG) and has been free to download since Issue 6 (2013). The current edition is Issue 9 (January 2025).

### Structure

- **53 writing rules across 9 sections** covering word choice, grammar, sentence structure, and style.
- **A dictionary** of roughly 900 approved words, each restricted to one meaning and one part of speech, plus roughly 1,200 words to avoid with suggested replacements.
- **A terminology allowance**: organizations may define their own dictionary of approved technical nouns and verbs beyond the base ~900 words, for domain-specific vocabulary the base dictionary can't cover.

### Rule Categories (Paraphrased)

**Word choice**
- Use approved words only in their approved meaning and part of speech.
- Each word maps to exactly one meaning — don't rely on context to disambiguate a word that has several dictionary senses.
- Prefer the plainer, shorter, more common word over a formal or rare synonym.
- Use an approved verb for an action, not a noun derived from that verb (Rule 3.7).
- Do not make phrasal verbs by putting a verb and a preposition together (Rule 9.3). Their meaning is not predictable from the parts, and non-native readers and translation systems both mishandle them.

**Verb forms**
- Permitted forms: infinitive, imperative, simple present, simple past, simple future, and past participle used only as an adjective.
- No present perfect, past perfect, or other compound/auxiliary constructions. "We have received" is not allowed. "We received" is allowed.
- "-ing" forms are permitted only as a technical noun or as part of a technical noun, not as a verb form.

**Voice**
- Active voice is required for procedures and instructions.
- Passive voice is allowed only in descriptive text, and only when the actor performing the action is genuinely unknown or irrelevant to the reader.

**Sentence structure**
- One instruction per sentence.
- Maximum ~20 words per sentence for procedures and instructions. Maximum ~25 words for descriptive text.
- Do not omit sentence parts (verb, subject, article) just to shorten the sentence — the standard explicitly warns that this creates ambiguity rather than clarity.
- Noun clusters (strings of nouns stacked as a modifier) are capped at 3 words.
- Semicolons are not permitted at all (Rule 8.1): "You can use all standard English punctuation marks but not the semicolon (;)." Write separate sentences instead. Every other standard mark, including the em dash, remains permitted.

**Paragraph and document structure**
- One topic per paragraph.
- Maximum ~6 sentences per paragraph.
- Use vertical (numbered or bulleted) lists for sequences, conditions, or complex enumerations instead of burying them in prose.

**Safety instructions**
- Safety-critical instructions must open with a clear command or condition, not be buried mid-sentence.

## Sources

- [ASD-STE100 official site](https://www.asd-ste100.org/)
- [ASD-STE100 — About STE](https://www.asd-ste100.org/about_STE.html)
- [ASD Europe — Simplified Technical English](https://www.asd-europe.org/standards-specifications/simplified-technical-english/)
- [Simplified Technical English — Wikipedia](https://en.wikipedia.org/wiki/Simplified_Technical_English)
- [TechScribe — ASD-STE100 Simplified Technical English](https://www.techscribe.co.uk/techw/asd-simplified-technical-english.htm)
- [SKYbrary — Simplified Technical English (STE)](https://skybrary.aero/articles/simplified-technical-english-ste)
