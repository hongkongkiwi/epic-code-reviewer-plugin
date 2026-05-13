# Expected Review: Shell Read-Only Bypass

classification: finding
severity: P1

The reviewer should report that allowing all `find` and `xargs` commands treats command builders as read-only even when they can run other programs, delete files, or write through invoked commands.

The finding should ask to keep argument-sensitive checks for `find` and `xargs`, including checks for execution flags and replacement modes.
