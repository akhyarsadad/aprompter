# Paywall + SSO gate — design

## Goal

Add a free/paid split to APrompter. The login exists for exactly one reason:
let a purchase follow the person across devices and across the App Store /
Play Store boundary. It is not for cloud sync of scripts, and it is not a
general account system.

## What's gated

- Free: **1 active (non-deleted) script**, capped at **500 words** of spoken
  text. Templates, rehearsing, recording, takes, Float mode, all settings,
  and every existing feature work fully on that one script.
- Paid ("unlimited"): no script-count limit, no word cap.
- The cap counts `countWords(spokenText(body))` — the same number the
  editor's timing bar already shows — not raw character count, so it lines
  up with what the writer already sees while typing.
- **Grandfathering**: the gate only blocks *creating a new script past the
  limit* and *typing past the word cap on a script that is already over it*.
  It never hides, locks, or deletes scripts someone already had before this
  ships, even if they have more than 1 or longer than 500 words already.

## Pricing

Both a subscription and a one-time purchase, configured as store products
behind one RevenueCat entitlement (`unlimited`):
- Monthly subscription
- Yearly subscription
- Lifetime one-time purchase

Exact prices are a store-listing decision made later in App Store Connect /
Play Console, not part of this spec.

## Architecture

No custom backend. RevenueCat (`purchases_flutter`) is the system of record
for entitlement — it validates App Store/Play receipts, handles the
subscription + one-time products side by side, restore-purchases, refunds,
and billing retries. `google_sign_in` and `sign_in_with_apple` authenticate
the person; the resulting stable UID is passed to `Purchases.logIn(uid)` so
RevenueCat recognizes the same entitlement regardless of which store or
device the purchase was made on.

New dependencies: `purchases_flutter`, `google_sign_in`, `sign_in_with_apple`.

## Components

- `lib/services/auth_service.dart` — wraps Apple/Google sign-in, exposes the
  current identity (or none), calls `Purchases.logIn(uid)` /
  `Purchases.logOut()`.
- `lib/services/entitlements.dart` — wraps RevenueCat: exposes `isUnlimited`
  as a `ValueListenable<bool>`, backed by `Purchases.getCustomerInfo()` plus
  `Purchases.addCustomerInfoUpdateListener`. Also owns the pure gate
  functions (`canCreateScript`, `canExceedWordCap`) so they're unit-testable
  with zero RevenueCat/network dependency.
- `lib/screens/paywall_screen.dart` — plan picker (monthly / yearly /
  lifetime), restore-purchases button. Prompts sign-in first if the person
  isn't authenticated yet.
- `lib/screens/sign_in_screen.dart` (or a bottom sheet) — "Continue with
  Apple" / "Continue with Google" buttons.
- `home_screen.dart` — disable/intercept "+ New script" once at the script
  limit; route to sign-in → paywall instead of the template picker.
- `editor_screen.dart` — inline banner + upgrade CTA once the body crosses
  500 words on a script that was under the cap when this ships (see
  grandfathering above); never blocks typing on an already-over-cap script
  someone already owns.

## Data flow

1. App launch → `Purchases.configure(apiKey)` once (in `main()`).
2. If a sign-in was persisted from a previous session, silently
   `Purchases.logIn(uid)` again so entitlement is restored with no user
   action.
3. Hitting a limit (2nd script, or word 501 on a fresh script) → if signed
   out, show the sign-in sheet first → then the paywall sheet.
4. User picks a product → RevenueCat purchase flow → `CustomerInfo` update
   listener flips `isUnlimited` to `true` immediately → the gate lifts with
   no app restart.
5. "Restore purchases" in the paywall screen re-runs the RevenueCat restore
   flow, for reinstalls or a new device under the same signed-in identity.

## Error handling

- No network at purchase time → retryable snackbar, purchase never silently
  "succeeds" without a confirmed entitlement.
- Sign-in cancelled or denied → return to the previous screen, no state
  change, no error shown (this is a normal, frequent outcome, not a failure).
- Any RevenueCat/config problem → fails **closed** (treated as not
  unlimited), never open. A misconfigured API key must never accidentally
  unlock the app for everyone.
- Existing scripts from before this ships are never touched by the gate
  (see grandfathering).

## Testing

- `canCreateScript` / `canExceedWordCap` are pure functions over
  `(scripts, entitlement)` / `(body, entitlement)` — unit tested the same
  way as the rest of the app's 130-test suite, no network or RevenueCat
  mock needed.
- Widget tests for the home/editor gate UI (banner appears at the right
  word count, "+ New script" disabled at the right count) using a fake
  `isUnlimited` listenable, not the real RevenueCat SDK.
- Real purchases cannot be unit tested: manual verification via an App
  Store sandbox tester account and a Play Console license tester, covering
  monthly, yearly, lifetime, and restore.

## Explicitly out of scope (separate spec later)

The **import feature** (bulk import, competitor-format import, cloud/link
import) is an independent subsystem and is not part of this design. It will
get its own brainstorming pass and spec.

## Open assumptions

- "SSO" here means Sign in with Apple + Google Sign-In specifically (Apple
  is mandatory on iOS once any third-party login is offered). No email/
  password option is in scope.
- No admin/web dashboard is needed to view entitlements — RevenueCat's own
  dashboard is sufficient for this app's scale.
