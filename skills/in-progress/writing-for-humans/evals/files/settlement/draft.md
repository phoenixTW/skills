# Why the Settlement Run sometimes writes a payment twice

## Where we are

Every night, the Settlement Run moves cleared payments into the Ledger. When a bank confirms a payment late, after the Clearing Window, the Settlement Run tries again.

## What we are trying to do

We want each payment to appear in the Ledger exactly once, even when the Settlement Run tries again.

## How we get there

1. Give each payment a key made from its account and its external reference.
2. When the Settlement Run writes a payment, it updates the row with that key, or creates the row if none exists.
3. Write a script that finds and removes the duplicate rows that already exist.

## How we know it worked

An alert counts duplicate rows in the Ledger. The count stays at zero.

## Open questions and risks

If a run fails halfway, running it again may still write some payments twice. We need to test this case.
