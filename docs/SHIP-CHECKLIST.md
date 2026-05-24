# App Store Submission Checklist

> Filled during Sprint 4 of the [Production Roadmap](./epics/PRODUCTION-OVERVIEW.md). Treat as the final gate — every item must be checked before tapping **Submit for Review** in App Store Connect.

## Binary

- [ ] `v1.0.0-rc1` tag pushed → Fastlane workflow green ([SHIP-009](./stories/SHIP-009-fastlane-testflight-pipeline.md))
- [ ] Build number > all prior submissions
- [ ] Release config archived (not Debug)
- [ ] dSYMs uploaded to Sentry
- [ ] No `print(...)` or `dump(...)` calls in shipped code (`grep -r "^\s*print(" hogwarts/` returns 0 outside `#if DEBUG`)
- [ ] No `TODO` / `FIXME` blocking a critical-path flow
- [ ] Mock login bypass removed ([CORE-003](./stories/CORE-003-remove-mock-login-bypass.md))

## Entitlements

- [ ] `aps-environment` = `production`
- [ ] `com.apple.developer.associated-domains` includes `applinks:ed.databayt.org`
- [ ] `com.apple.developer.in-app-payments` includes `merchant.org.databayt.hogwarts` (Apple Pay)
- [ ] `com.apple.developer.authentication-services.autofill-credential-provider` (if AutoFill used)
- [ ] No `com.apple.developer.networking.HotspotConfiguration` or other entitlements we don't use

## Info.plist

- [ ] All `NS*UsageDescription` keys present + localized in EN and AR
  - `NSCameraUsageDescription` (ID card, document scan)
  - `NSPhotoLibraryUsageDescription` (avatar, attachments)
  - `NSPhotoLibraryAddUsageDescription` (save receipts)
  - `NSFaceIDUsageDescription` (biometric sign-in)
  - `NSLocationWhenInUseUsageDescription` (geo-attendance, optional)
  - `NSContactsUsageDescription` (school directory, F-INTEGRATION)
  - `NSCalendarsFullAccessUsageDescription` (EventKit add-to-calendar)
  - `NSRemindersFullAccessUsageDescription` (assignment due reminders)
- [ ] `ITSAppUsesNonExemptEncryption` = `false` (export compliance, SHIP-004)
- [ ] `CFBundleLocalizations` lists `en` and `ar`
- [ ] `UIApplicationSceneManifest` configured for iOS 18+

## Privacy Manifest (`PrivacyInfo.xcprivacy`)

Per GOV-005 audit. Every data type the app collects must be declared:

- [ ] Identifiers: DeviceID (via APNs token), UserID (after sign-in)
- [ ] Contact info: Email (for login), Name (profile display)
- [ ] User content: Messages, photos uploaded as attachments
- [ ] Identifiers + financial: Stripe / Apple Pay transactions
- [ ] Diagnostics: Sentry crash reports, MetricKit
- [ ] Required reasons API declarations: file timestamp, system boot time, disk space, user defaults (whichever we actually call)

## App Store Connect

### App information
- [ ] Bundle ID: `org.databayt.hogwarts`
- [ ] Primary category: Education
- [ ] Secondary category: Productivity
- [ ] Age rating: 4+ (no objectionable content) or 12+ (if UGC messaging considered)
- [ ] Content rights: own all content / licensed (educational materials)

### Pricing & availability
- [ ] Free (in-app purchases via Stripe for tuition, optional StoreKit for SaaS upgrades v1.1)
- [ ] Available in MENA region first; global gradually
- [ ] Pre-orders: off

### App privacy
- [ ] Privacy policy URL: `https://databayt.org/privacy`
- [ ] Terms of service URL: `https://databayt.org/terms`
- [ ] Privacy questionnaire matches PrivacyInfo.xcprivacy

### App Review information
- [ ] Demo account: `apple-review@databayt.org` (school `demo-saudi`) — coordinate with Ali
- [ ] Demo password rotated for this submission
- [ ] Sign-in note: includes demo school slug + role to demo (admin gives broadest access)
- [ ] Contact: Abdout — phone, email, time zone
- [ ] Notes: explain multi-tenant model, sharing-economy SSPL license

### Version Information (1.0.0)
- [ ] Promotional text (170 chars, EN + AR)
- [ ] Description (4000 chars, EN + AR)
- [ ] Keywords (100 chars, EN + AR)
- [ ] Support URL: `https://databayt.org/support` or `https://github.com/databayt/ios-app/issues`
- [ ] Marketing URL: `https://ed.databayt.org`
- [ ] What's New (release notes, EN + AR)

### Screenshots (SHIP-002)
- [ ] 6.7" iPhone — 5 screens × 2 locales
- [ ] 6.1" iPhone — 5 screens × 2 locales
- [ ] iPad 13" — 5 screens × 2 locales (if iPad submitted)
- [ ] App preview video (optional but recommended, 15–30s)

## Pre-flight smoke tests (TestFlight build)

- [ ] First launch → consent flow → cannot proceed without accepting (GOV-001)
- [ ] Sign in via email + password
- [ ] Sign in with Apple (AUTH-007) — links existing account by email
- [ ] Biometric unlock (AUTH-005) on subsequent launch
- [ ] Receive push from real APNs server (not sandbox)
- [ ] Send a message, receive a push for reply
- [ ] Tap message push → opens correct conversation
- [ ] Add a calendar event from a class card (INT-001)
- [ ] Make a Stripe sandbox payment (PAY-002)
- [ ] Request data export (GOV-003) → email arrives within 24h
- [ ] Delete account (GOV-004) → re-auth → confirmation → account gone, subsequent login fails
- [ ] Toggle to Arabic → entire UI flips RTL correctly
- [ ] VoiceOver navigate login + dashboard + messaging — no orphan elements

## Sign-off

- [ ] Abdout: technical review pass
- [ ] Ali: QA pass on TestFlight build with all demo accounts
- [ ] Samia: AR localization spot-check (titles, error messages, consent flow)
- [ ] Submit for Review

## Post-submission

- [ ] Phased release configured: 1% → 10% → 50% → 100% over 28 days (SHIP-006)
- [ ] Crash-free sessions ≥ 99.5% during phased ramp
- [ ] If rejected: refer to [App Review playbook](./stories/SHIP-007-app-review-submission.md), fix and resubmit within 24h
