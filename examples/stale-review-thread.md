# Stale Review Thread Fixture

Input comment:

```text
src/routes/account.ts:12 still lacks an account permission check.
```

Current code:

```ts
router.patch("/accounts/:accountId", requireUser, requireAccountEditor, updateAccount);
```

Expected classification:

```text
outdated
```

Reason:

The cited line no longer exists and the route now runs `requireAccountEditor` before `updateAccount`.
