# Role Matrix

> All 8 roles are first-class. Every story declares its role audience.

## Roles

| Code | Name | schoolId required | iOS pilot | Description |
|------|------|-------------------|-----------|-------------|
| `DEVELOPER` | Platform admin | no | **out of scope** | SaaS-level admin (databayt staff). Use the web. App detects + redirects. |
| `ADMIN` | School admin | yes | M0 | Full school control — students, classes, staff, school settings, announcements. |
| `TEACHER` | Teacher | yes | M0 | Classroom operations — attendance, grading, schedule, messages. |
| `STUDENT` | Student | yes | M0 | Self-service — timetable, grades, attendance, messages, fees, ID. |
| `GUARDIAN` | Guardian / parent | yes | M0 | Read-only on linked children + write access for excuses, payments, consent. |
| `ACCOUNTANT` | Accountant | yes | M1 | Fees, invoices, payments, refunds, finance reports. |
| `STAFF` | Non-teaching staff | yes | M2 | Schedule, payroll slip, leave, notices. Reuses TEACHER infra. |
| `USER` | Pre-school applicant | no (then yes after enroll) | M2 | Public admission flow — apply, status, schedule visit. |

## Role-Gated Features (high level)

| Feature | DEV | ADM | TCH | STU | GRD | ACC | STF | USR |
|---------|-----|-----|-----|-----|-----|-----|-----|-----|
| Auth | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Onboarding | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Profile / Settings | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Notifications | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Announcements (read) | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Announcements (author) | ✓ | ✓ | ✓ | — | — | — | — | — |
| Messaging | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Timetable | — | ✓ | ✓ | ✓ | ✓ (children) | — | ✓ | — |
| Attendance (view own) | — | — | — | ✓ | ✓ (children) | — | — | — |
| Attendance (mark) | — | ✓ | ✓ | — | — | — | — | — |
| Attendance (excuse) | — | ✓ | ✓ | — | ✓ (children) | — | — | — |
| Grades (view) | — | ✓ | ✓ | ✓ | ✓ (children) | — | — | — |
| Grades (entry) | — | — | ✓ | — | — | — | — | — |
| Report cards | — | ✓ | ✓ | ✓ | ✓ (children) | — | — | — |
| Exams (take) | — | — | — | ✓ | — | — | — | — |
| Exams (author/grade) | — | — | ✓ | — | — | — | — | — |
| Assignments (submit) | — | — | — | ✓ | — | — | — | — |
| Assignments (author/grade) | — | — | ✓ | — | — | — | — | — |
| Fees (view) | — | ✓ | — | ✓ | ✓ (children) | ✓ | — | — |
| Fees (pay) | — | — | — | — | ✓ | — | — | — |
| Fees (record cash) | — | ✓ | — | — | — | ✓ | — | — |
| Invoices | — | ✓ | — | — | ✓ | ✓ | — | — |
| Events (view/RSVP) | — | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Events (author) | — | ✓ | — | — | — | — | — | — |
| Library | — | ✓ | ✓ | ✓ | — | — | — | — |
| Subjects | — | ✓ | ✓ | ✓ | — | — | — | — |
| Stream / LMS | — | ✓ | ✓ | ✓ | — | — | — | — |
| Quiz game | — | — | — | ✓ | — | — | — | — |
| ID card | — | ✓ | ✓ | ✓ | — | ✓ | ✓ | — |
| Children list | — | — | — | — | ✓ | — | — | — |
| Consent forms | — | ✓ | — | — | ✓ | — | — | — |
| Substitution | — | ✓ | ✓ | — | — | — | ✓ | — |
| Wellbeing (own) | — | — | — | ✓ | — | — | — | — |
| Wellbeing (children) | — | ✓ | ✓ | — | ✓ | — | — | — |
| AI doc scan | — | — | — | — | ✓ | — | — | — |
| School subscription | — | ✓ | — | — | — | — | — | — |
| Admission apply | — | — | — | — | — | — | — | ✓ |
| Transport | — | ✓ | — | — | ✓ | — | — | — |
| Admin: school info | — | ✓ | — | — | — | — | — | — |
| Admin: students CRUD | — | ✓ | — | — | — | — | — | — |
| Admin: staff | — | ✓ | — | — | — | — | — | — |
| Admin: classes | — | ✓ | — | — | — | — | — | — |
| Admin: stats | — | ✓ | — | — | — | — | — | — |

✓ = full access  · — = no access  · (children) = scoped to linked child  · (own) = scoped to self

## Authorization (client-side)

```swift
// hogwarts/core/auth/authorization.swift
enum Permission: String {
    case attendanceMark = "attendance.mark"
    case feePay = "fee.pay"
    case announcementAuthor = "announcement.author"
    // ...
}

extension UserRole {
    func can(_ permission: Permission) -> Bool {
        switch (self, permission) {
        case (.teacher, .attendanceMark), (.admin, .attendanceMark): return true
        case (.guardian, .feePay): return true
        case (.admin, .announcementAuthor), (.teacher, .announcementAuthor): return true
        // ...
        default: return false
        }
    }
}
```

Server is the authoritative gate. Client guards UX.

## Role Switching

Some users hold multiple roles in one school (rare — e.g., a teacher who is also a parent). UX:
- One role active at a time
- Switch via Profile → Switch Role
- Each switch re-queries `/mobile/profile` to refresh permissions
- Multi-school multi-role: separate session per (school, role)

## Verification (per story)

- [ ] Frontmatter `roles: [...]` lists every role that sees the screen
- [ ] Authorization check at the entry point (page-level)
- [ ] UI elements (buttons, menu items) hidden for non-permitted roles
- [ ] Server returns 403 for the missing-role case (test exists)
