# Expected Review: TypeScript Missing Await

classification: finding
severity: P2

The reviewer should report the missing `await` on `sendWelcomeEmail(user.email)`. An email failure can now happen after the response path continues, so the route may return success and write audit data even though the welcome-email contract failed.

The finding should ask to restore `await` or explicitly move the email send to a queued background job with tests for the new behavior.
