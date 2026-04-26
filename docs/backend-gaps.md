# Backend Gaps Required for iOS

> Generated from epic backend dependencies. Tracks endpoints needed from `databayt/hogwarts` web team.
> Source-of-truth contract: `/Users/abdout/hogwarts/src/app/api/mobile/README.md`.

## Status Legend

- ✅ Live in production
- 🟡 Scaffolded / partial / behind feature flag
- 🔴 Not yet started — blocks corresponding iOS epic

## Priority

- **P0** — blocks M0 release
- **P1** — blocks M1 release
- **P2** — blocks M2 release
- **NEW** — does not exist on web yet, needs backend ticket

---

## P0 — Block M0

> **Tickets filed in `databayt/hogwarts`** — see #274–#279.

### Translation (NEW) — [hogwarts#274](https://github.com/databayt/hogwarts/issues/274)
- 🔴 `POST /api/mobile/translate` — translate entity content to user's app language; cache in `TranslationCache`. **NEW endpoint.**
  - Request: `{ entity_type, entity_id, target_lang }`
  - Response: `{ translated_text, cached, source_lang }`

### Account deletion (App Store requirement) — [hogwarts#275](https://github.com/databayt/hogwarts/issues/275)
- 🔴 `POST /api/mobile/account/delete` — schedule + execute account deletion per Apple App Store guideline 5.1.1(v). 30-day grace period, cascading soft-delete.

### Data export (App Store requirement) — [hogwarts#276](https://github.com/databayt/hogwarts/issues/276)
- 🔴 `GET /api/mobile/account/export` — async export job that emails user a download link. **NEW**.

### Consent — [hogwarts#277](https://github.com/databayt/hogwarts/issues/277)
- 🔴 `GET /api/mobile/consent` — list pending legal consents (TOS, Privacy, COPPA, GDPR-K).
- 🔴 `POST /api/mobile/consent/:id` — record acceptance with timestamp + device.

---

## P1 — Block M1

### Invoices — [hogwarts#279](https://github.com/databayt/hogwarts/issues/279) (P0 backend ticket)
- 🔴 `GET /api/mobile/invoices` — list invoices for current user (or current child)
- 🔴 `GET /api/mobile/invoices/:id` — invoice detail with line items
- 🔴 `GET /api/mobile/invoices/:id/pdf` — PDF download

### Payments — [hogwarts#278](https://github.com/databayt/hogwarts/issues/278) (P0 backend ticket)
- 🔴 `POST /api/mobile/payments/process` — Stripe / Apple Pay token → Charge
- 🔴 `GET /api/mobile/payments/transactions` — payment history
- 🔴 `POST /api/mobile/payments/cash` — accountant records cash payment
- 🔴 `POST /api/mobile/payments/bank-receipt` — guardian uploads bank receipt photo

### Report Cards (P1)
- 🔴 `GET /api/mobile/report-cards` — list by term
- 🔴 `GET /api/mobile/report-cards/:id` — detail
- 🔴 `GET /api/mobile/report-cards/:id/pdf` — PDF download
- 🔴 `POST /api/mobile/report-cards/:id/sign` — guardian acknowledgment

### Teacher mutations (P1)
- 🔴 `POST /api/mobile/teacher/classes/:id/grades` — grade entry
- 🔴 `POST /api/mobile/teacher/classes/:id/attendance` — attendance mark (single + bulk)
- 🔴 `GET /api/mobile/teacher/schedule` — own teaching schedule

### Online exams (P1)
- 🔴 `POST /api/mobile/exams/:id/answers` — submit answers
- 🔴 `GET /api/mobile/exams/:id/results` — results
- 🔴 `POST /api/mobile/exams/:id/violations` — violation log (app-switch, screenshot)
- 🔴 `GET /api/mobile/exams/:id/certificate` — certificate PDF

### Admin (P1)
- 🔴 `GET /api/mobile/admin/staff` — list non-teaching + teaching staff
- 🔴 `POST /api/mobile/admin/classes` — create class
- 🔴 `GET /api/mobile/admin/classes/:id` — class detail
- 🔴 `POST /api/mobile/admin/classes/:id/students` — add student to class

### Guardian (P1)
- 🔴 `POST /api/mobile/guardian/excuse` — submit attendance excuse
- 🔴 `POST /api/mobile/guardian/absence-intention` — pre-notification of absence
- 🔴 `GET /api/mobile/guardian/consent` — pending consents per child
- 🔴 `POST /api/mobile/guardian/consent/:id` — sign

### Search (NEW)
- 🔴 `GET /api/mobile/search?q=...&types=...` — universal scoped search

---

## P2 — Block M2

### Library
- 🔴 `GET /api/mobile/library/books` — catalog
- 🔴 `GET /api/mobile/library/books/:id` — book detail
- 🔴 `GET /api/mobile/library/borrowings` — my borrowings
- 🔴 `POST /api/mobile/library/holds` — place hold

### Subjects / Lessons
- 🔴 `GET /api/mobile/subjects` — catalog
- 🔴 `GET /api/mobile/subjects/:id` — detail with chapters
- 🔴 `GET /api/mobile/subjects/my-subjects` — enrolled
- 🔴 `GET /api/mobile/lessons/:id` — lesson detail (text/video/quiz)

### Stream / LMS
- 🔴 `GET /api/mobile/stream/courses` — catalog
- 🔴 `GET /api/mobile/stream/enrollments` — enrolled
- 🔴 `GET /api/mobile/stream/courses/:id/progress` — progress
- 🔴 `POST /api/mobile/stream/lessons/:id/complete` — mark complete
- 🔴 `GET /api/mobile/stream/courses/:id/certificate` — completion certificate

### Quiz game
- 🔴 `GET /api/mobile/quiz/sessions` — active sessions
- 🔴 `POST /api/mobile/quiz/sessions` — start session
- 🔴 `POST /api/mobile/quiz/sessions/:id/answers` — submit answer
- 🔴 `GET /api/mobile/quiz/leaderboard` — leaderboard

### ID Card
- 🔴 `GET /api/mobile/idcard` — current user ID card data
- 🔴 `GET /api/mobile/idcard/wallet-pass` — Apple Wallet `.pkpass`
- 🔴 `GET /api/mobile/idcard/pdf` — PDF download

### Transport
- 🔴 `GET /api/mobile/transport/route` — child's bus route
- 🔴 `GET /api/mobile/transport/route/live` — live position (websocket?)

### AI Document Processing
- 🔴 `POST /api/mobile/ai-doc/jobs` — start scan job (upload + classify)
- 🔴 `GET /api/mobile/ai-doc/jobs/:id` — poll status
- 🔴 `GET /api/mobile/ai-doc/jobs/:id/result` — extracted data

### Subscription (school SaaS billing)
- 🔴 `GET /api/mobile/subscription` — current plan
- 🔴 `POST /api/mobile/subscription/upgrade` — upgrade plan
- 🔴 `GET /api/mobile/subscription/invoices` — billing history
- 🔴 Apple IAP webhook → backend record

### Substitution
- 🔴 `POST /api/mobile/teacher/absences` — request absence
- 🔴 `POST /api/mobile/teacher/substitutions/:id/accept` — cover for colleague
- 🔴 `GET /api/mobile/admin/substitutions` — pending review

### Wellbeing
- 🔴 `GET /api/mobile/wellbeing/health` — health record
- 🔴 `GET /api/mobile/wellbeing/discipline` — disciplinary record
- 🔴 `POST /api/mobile/wellbeing/discipline/:id/appeal` — appeal

### Admission (applicant flow)
- 🔴 `POST /api/mobile/admission/apply` — start application
- 🔴 `POST /api/mobile/admission/documents` — upload doc
- 🔴 `POST /api/mobile/admission/otp` — request OTP
- 🔴 `GET /api/mobile/admission/status` — by OTP/email
- 🔴 `POST /api/mobile/admission/payment` — application fee

---

## Already Live (consume directly)

✅ All core endpoints listed in `/api/mobile/README.md` Section "Currently Implemented":
- `/auth/*` (sign-in, sign-up, reset, OTP, OAuth, refresh, logout)
- `/profile`, `/dashboard`, `/students/*`, `/attendance/*`, `/grades/*`, `/timetable/:userId`, `/announcements/*`, `/conversations/*`, `/notifications/*`, `/fees/*` (read), `/events/*`, `/guardian/*`, `/teacher/*` (read), `/admin/school`, `/admin/stats`

---

## Coordination

- File backend tickets in `databayt/hogwarts` repo with label `mobile-api`.
- Each iOS story that depends on a 🔴 endpoint must reference the backend ticket number.
- Contract-first: stub `APIClient` method on iOS, swap to live behind feature flag once backend ships.
