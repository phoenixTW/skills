# Payments context

## Language

**Ledger**: The append-only record of every money movement for an account.
_Avoid_: book, money log

**Settlement Run**: The nightly job that moves cleared payments from pending to the Ledger.
_Avoid_: money pipe, batch, sweep

**Clearing Window**: The time between a payment's capture and the bank's confirmation.
_Avoid_: delay, gap
