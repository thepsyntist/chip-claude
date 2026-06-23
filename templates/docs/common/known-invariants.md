# Known Invariants

> Rules that must never break. Add as the project uncovers them. Each entry: one-line rule + why.

---

<!-- TODO: Capture every "this thing breaks if X" rule as it's discovered.
Example:

## Data layer

- **All timestamps stored as UTC.** Reads must parse and re-attach tzinfo. Naive datetimes in comparisons crash at midnight boundaries.

## Auth

- **Every non-public route calls `get_auth()` before any DB touch.** Missing this = unauthenticated access. Caught once in Session 4.

-->
