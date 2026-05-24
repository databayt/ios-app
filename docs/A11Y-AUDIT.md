# Accessibility Audit

> Filled during Sprint 3 of the [Production Roadmap](./epics/PRODUCTION-OVERVIEW.md). Tracks the VoiceOver + Dynamic Type + Reduce Motion + contrast pass on the 8 critical flows that gate phase E completion. Each flow has its own subsection; each subsection is filled by the auditor (use real VoiceOver on a real device — Accessibility Inspector is a secondary signal).

## Method

- **Device**: iPhone 15 Pro on iOS 18+ (matches deployment target)
- **Tools**: VoiceOver (Settings → Accessibility → VoiceOver), Accessibility Inspector (Xcode → Open Developer Tool), Dynamic Type slider (Accessibility → Display & Text Size → Larger Text → max)
- **Locales**: AR + EN, both LTR/RTL
- **Roles tested**: admin, teacher, student, guardian (one flow per role where role-specific)
- **Scoring**: per-AC checkbox; flow passes when every AC is ✅

## Critical Flows (8)

Order = sprint 3 execution. Auditor: Ali (QA). Reviewed by: Abdout.

### 1. Login (AUTH)

- [ ] VoiceOver reads every field label + value + state (focused / unfocused)
- [ ] Sign in with Apple button has `accessibilityLabel` localized
- [ ] Biometric prompt is announced (Face ID / Touch ID with role-aware reason)
- [ ] Error messages are read immediately after appearing (`UIAccessibility.post(.announcement, ...)`)
- [ ] Dynamic Type max: no clipped buttons, no overlapping text
- [ ] Reduce Motion: no parallax / spring on form submit
- **Status**: ⬜ Pending

### 2. Dashboard (DASHBOARD / HOME)

- [ ] Each tile has descriptive label (not just "Button"): "Today's classes, 4 items"
- [ ] Tile grid is traversed in reading order (LTR: left-to-right, RTL: right-to-left)
- [ ] Badge counts are read (e.g., "Notifications, 7 unread")
- [ ] Pull-to-refresh hint is read
- [ ] Dynamic Type max: tiles wrap, don't truncate
- [ ] Color contrast ≥ 4.5:1 for tile text on Liquid Glass background (both light + dark)
- **Status**: ⬜ Pending

### 3. Attendance — mark (ATTENDANCE)

- [ ] Class header announces "Class 4A, 28 students, 3 absent so far"
- [ ] Each student row: name + status + action (`accessibilityCustomActions` for Mark Present/Absent/Late)
- [ ] Bulk-mark gesture has VoiceOver alternative (custom action on header)
- [ ] Toggle states are announced ("Marked present", "Marked absent")
- [ ] Save action returns focus to header with success announcement
- **Status**: ⬜ Pending

### 4. Grade view (GRADES)

- [ ] Subject row: subject + grade + trend
- [ ] Charts have `accessibilityLabel` summarizing the trend ("Maths grade rising from B+ to A over last 3 terms")
- [ ] Grade hierarchy (subject → assessment → individual mark) navigable via rotor
- [ ] Dynamic Type max: charts remain readable or have textual fallback
- **Status**: ⬜ Pending

### 5. Message send (MESSAGING)

- [ ] Conversation list: each row reads name + last message + unread state
- [ ] Composer field has clear label, not "Text Field"
- [ ] Send button has clear label, not "Button"
- [ ] Sending state announced ("Sending", "Sent", "Failed, double-tap to retry")
- [ ] RTL: bubble alignment correct for AR text in EN conversation and vice versa
- **Status**: ⬜ Pending

### 6. Fee payment (FEES / PAY)

- [ ] Invoice row reads amount + currency + due date + status
- [ ] Apple Pay button: announces "Pay with Apple Pay"
- [ ] Stripe Card Sheet: trust Apple's built-in accessibility (sheet is a PassKit/Stripe-controlled view)
- [ ] Receipt confirmation announces ("Payment of 350 SAR successful")
- [ ] Currency reads as full word ("Saudi Riyals" not "SAR") via formatter accessibility
- **Status**: ⬜ Pending

### 7. Notification tap → deep link (NOTIF + F-PUSH)

- [ ] Notification text on Lock Screen is readable (VoiceOver outside app)
- [ ] Tapping notification with VoiceOver active triggers deep link correctly
- [ ] Destination screen announces context ("Conversation with Ali, 3 new messages")
- [ ] Back navigation returns to expected screen, not Lock Screen
- **Status**: ⬜ Pending

### 8. Profile edit (PROFILE)

- [ ] Every field labeled
- [ ] Avatar update flow: VoiceOver describes current image, options ("Take photo", "Choose from library", "Remove")
- [ ] Save button enabled-state announced ("Save, disabled — no changes" → "Save, enabled")
- [ ] Cancel flow: confirms discard if changes pending
- **Status**: ⬜ Pending

---

## Cross-cutting issues to track

Things that surface across multiple flows get logged here, fix once, retest everywhere.

| Issue | Flows affected | Fix location | Status |
|-------|----------------|--------------|--------|
| _example: SF Symbol `chevron.right` reads as "More" in some rotors_ | dashboard, messages | atom `hw-list-row.swift` chevron mirror direction | ⬜ |
| | | | |

---

## Sign-off

Phase E exit requires all 8 flows = ✅ Pending → ✅ Pass. Ali files findings as comments on the relevant `Q-A11Y-{NNN}` story in `docs/stories/`. Abdout merges fixes. Final pass = Ali re-walks all 8 flows on the post-fix TestFlight build.
