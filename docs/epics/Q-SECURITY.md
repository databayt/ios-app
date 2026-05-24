---
code: Q-SECURITY
title: Security
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: []
i18n_namespaces: []
multi_tenant: required
---

# Q-SECURITY — Security

## Goal
OWASP MASVS L1+ compliance: certificate pinning, keychain audit, jailbreak detection, screen recording prevention on sensitive screens, file data protection class audit, token rotation, penetration test pre-launch.

## Scope

**In**: Cert pinning + rotation, keychain audit, jailbreak detection, screenshot/recording prevention, file protection, token rotation policy, pen test.

**Out**: Auth flow correctness (AUTH).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| SEC-001 | Cert pinning + rotation strategy | 5 | M1 | all |
| SEC-002 | Keychain audit (no UserDefaults for tokens) | 2 | M0 | all |
| SEC-003 | Jailbreak detection + soft warning | 3 | M2 | all |
| SEC-004 | Screen recording / screenshot prevention on sensitive screens | 3 | M1 | all |
| SEC-005 | File data protection class audit | 2 | M1 | all |
| SEC-006 | Token rotation policy | 3 | M0 | all |
| SEC-007 | OWASP MASVS L1 audit | 8 | M1 | all |
| SEC-008 | Penetration test pre-launch | 5 | M2 | all |

## Cross-cutting checks
- [ ] No tokens, PII, or sensitive data in UserDefaults or unencrypted plist
- [ ] Cert pinning includes graceful fallback for rotation
- [ ] Sensitive screens (wellbeing health record, exam) prevent screenshot via private API workaround or visual blur on UIScreen.captured
- [ ] Files protected with `.completeFileProtection` where applicable

## Backend dependencies
None — security at client + server, but client-side surface here.

## Definition of Done
- [ ] OWASP MASVS L1 audit passes
- [ ] Cert pinning verified with proxy attack test
- [ ] Pen test report shows zero critical findings
- [ ] No tokens in UserDefaults
