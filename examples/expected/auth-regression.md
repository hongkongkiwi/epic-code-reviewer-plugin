# Expected Review: Auth Regression

classification: finding
severity: P1

The reviewer should report that `updateAccount` no longer calls `canEditAccount` before updating the account. The replacement comment says the permission check moved to middleware, but the diff does not prove the caller or route now installs that middleware.

The finding should ask for either restoring the local check or showing the route-level middleware in the same change.
