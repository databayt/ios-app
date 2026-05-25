# App Review Submission + Appeal Playbook

> SHIP-007. How to file a Hogwarts iOS submission, how to handle a rejection, and what the recurring rejection categories are. This is a **starter playbook** — augment with real Apple-Review feedback after the first three submissions so the patterns become precise.

## Pre-submission gate

Before tapping **Submit for Review** in App Store Connect, walk every box in [`docs/SHIP-CHECKLIST.md`](../SHIP-CHECKLIST.md). The gate is "every box checked, not just most." Most rejections trace back to a missed pre-submission item.

Three items are easy to miss and burn 24h of review time:

1. **Demo account works**. Log in as `apple-review@databayt.org` on the latest TestFlight build the day you submit. If the account was rotated, update the App Review Information page.
2. **Privacy questionnaire matches `PrivacyInfo.xcprivacy`** field-for-field. Mismatches surface as 5.1.1 rejections days into review.
3. **App Preview video is < 30 seconds + portrait**. Apple silently fails the upload otherwise.

## Submission flow

```
1. Tag → TestFlight build via .github/workflows/testflight.yml         (~25 min)
2. Manual: distribute to External group in App Store Connect          (instant)
3. Manual: walk SHIP-CHECKLIST.md, fix any red boxes                  (variable)
4. Manual: App Store Connect → Hogwarts → 1.0.0 → Build → pick build  (5 min)
5. Manual: App Privacy questionnaire matches PrivacyInfo               (10 min)
6. Manual: App Review Information — demo account, contact, notes      (5 min)
7. Manual: Save → Add for Review → Submit for Review                  (1 min)
8. Wait: Apple usually responds within 24–48h. Worst case 7 days.
```

## What "rejection" looks like

App Store Connect sends an email + the **Resolution Center** thread opens in the app. Reply directly from there; don't open a separate email thread.

Apple cites a **specific guideline number** (e.g. "Guideline 5.1.1 — Legal — Data Collection and Storage"). The number is the most important signal: it tells you which playbook section below to consult.

## Recurring rejection categories

Patterns from databayt's web team submissions + cross-team mobile experience. Update this section after each Hogwarts rejection.

### 5.1.1(v) — Account creation without deletion

**Symptom**: "Your app allows users to create accounts but does not provide a way to delete them."

**Fix**: GOV-004 must be shipped + a clear in-app path to delete from `Profile → Settings → Account → Delete Account`. The path must:
- Require fresh password re-auth (not biometric / session token alone)
- Show a 14-day grace period confirmation
- Send a confirmation email with a cancellation token
- Actually delete (not just deactivate) after the grace period

**Pre-flight check**: walk the delete flow on the TestFlight build with the demo account; verify subsequent login fails.

### 5.1.1 — Data Collection mismatch

**Symptom**: "The App Privacy information you provided does not match the data your app collects."

**Fix**: Open `PrivacyInfo.xcprivacy` and App Store Connect's App Privacy questionnaire side-by-side. Reconcile:
- Every \`NSPrivacyCollectedDataType\` in the manifest → matching entry in the questionnaire
- Every \`NSPrivacyAccessedAPIType\` reason → matching API Use declaration
- "Used to Track" / "Linked to User" flags must agree

Common miss: Sentry's \`CrashData\` + \`PerformanceData\` were declared in the manifest but not in the questionnaire (or vice versa).

### 4.0 / 4.5 — Design / spam

**Symptom**: "The app does not provide significant utility or entertainment value."

**Fix**: Apple bounces apps that look like generic templates. Counter with:
- Clear value-prop in app description (specific to school management, not "a productivity app")
- App Preview video showing the actual classroom workflow
- Screenshots of real features, not marketing graphics

**Pre-flight check**: would a school admin who's never heard of Hogwarts understand what the app does from the screenshots alone? If not, redesign before submitting.

### 2.1 — Performance / crashes

**Symptom**: "The app crashed on launch" or "We were unable to log in with the demo account."

**Fix**:
- Verify demo account works on the **exact build number** Apple is reviewing (not the latest TestFlight build — the one tied to the submission)
- Check Sentry for any pre-launch crash uploaded by Apple's test session — they DO appear there
- Verify the school subdomain Apple's test account resolves to is reachable from outside Saudi Arabia (Apple reviewers are in California; backend must respond globally)

### 5.6.1 — Developer Code of Conduct (anti-patterns)

**Symptom**: Generic "your app does not comply" message, often citing dark patterns.

**Fix**: Audit for:
- Subscription / paywall that hides the "skip" button or makes cancellation hard (we don't do this, but verify)
- Misleading screenshots (must reflect real app state, not concept art)
- App description claims features the app doesn't have

### 4.5.2 — IAP required for digital content

**Symptom**: "Your app uses external mechanisms to offer in-app purchases."

**Fix**: This is the trickiest one for Hogwarts. School-tuition fee payments are **physical-world transactions** (the student attends a school in the real world) — they qualify for the "physical goods or services" exception and Stripe is acceptable. **Apple sometimes disagrees**. If rejected:
- Cite Apple's own example list (Schoology, ClassDojo, etc. all do tuition via Stripe)
- Provide the school's commercial license + the parent's tuition invoice as evidence the goods are physical
- Offer a phone call with App Review (rarely granted but signals seriousness)

If Apple still rejects, the fallback is: tuition via web only (link from app), in-app limited to viewing balances. **Do not** add Apple IAP for tuition — Apple takes 30%, which destroys the per-school unit economics.

### 5.1.5 — Location services without obvious user benefit

**Symptom**: "Your app requests location access without clear justification."

**Fix**: We don't currently request location. If GeoAttendance (M2) is later enabled:
- `NSLocationWhenInUseUsageDescription` must spell out "Used to verify you're on school grounds during attendance check-in."
- Don't request `NSLocationAlwaysAndWhenInUseUsageDescription` — when-in-use is enough for attendance.

### 3.1.1 — In-App Purchase rules (subscription side)

**Symptom**: "School subscriptions are sold outside the app."

**Fix**: For SaaS subscriptions (`SUBSCRIPTION-SAAS` epic), Apple insists IAP if the subscription is digital. Workarounds:
- Subscription management lives entirely on web — app reads status but doesn't sell
- If the app sells, must use StoreKit 2 and pay the 15–30% commission

This is a business decision, not an engineering one. Surface to Abdout before submission.

## How to respond in Resolution Center

1. **Read the entire message** before replying. Apple often asks two things in one email; missing one re-starts the clock.
2. **Cite specifics**: "We added X in build 142, please re-review." Not "fixed."
3. **Attach evidence**: screenshots of the fix, link to the relevant App Store Connect screen, the SHA of the commit.
4. **Don't argue**. If you disagree, escalate via "Request a phone call" — but only after one good-faith reply.
5. **Re-submit the SAME version + bumped build number**. Don't create a new version for a re-review; that re-starts the entire app-review queue.

## Escalation paths

When the standard reply isn't working:

1. **Phone call request** — Resolution Center → "Request a phone call". Apple usually calls within 48h.
2. **App Review Board** — formal appeal. Use sparingly; once per app per year is the unwritten budget.
3. **WWDC labs** — June each year, free 1:1 with App Review engineers. Schedule on day 1 of WWDC; slots fill in hours.

## Post-rejection retrospective

After every rejection (whether overturned or accepted), add a 3-line entry to the bottom of this file:

```
- 2026-07-12 — Build 142, rejection 5.1.1 — Demo account password expired.
  Fix: rotate demo password 24h before submission; document in SHIP-CHECKLIST.
```

The point is: the playbook gets sharper each cycle. Treat the rejection as a checklist input, not a setback.

## Cross-reference

- [`docs/SHIP-CHECKLIST.md`](../SHIP-CHECKLIST.md) — pre-flight gate
- [`docs/release/testflight-distribution.md`](./testflight-distribution.md) — how to get a build to TestFlight
- [`docs/release/release-notes-template.md`](./release-notes-template.md) — release notes pattern
- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) — the canonical Apple doc
- [App Store Connect Help](https://help.apple.com/app-store-connect/) — operational reference
