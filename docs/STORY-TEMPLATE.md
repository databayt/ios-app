# Story Template (compact BMAD)

> Used by all stories under `docs/stories/`. Filename convention: `<EPIC>-<NUM>-<kebab-slug>.md`.

```markdown
# <ID>: <Title>

**Epic**: <Epic Code>
**Priority**: P0|P1|P2
**Phase**: M0|M1|M2
**Status**: pending|in-progress|review|done
**Effort**: XS|S|M|L|XL (Fibonacci 1|2|3|5|8|13)
**Roles**: [<applicable roles>]
**Multi-Tenant**: required

---

## User Story
**As a** <role>
**I want** <capability>
**So that** <value>

## Acceptance Criteria

### AC-1: <Happy path>
**Given** <state> **When** <action> **Then** <observable result>

### AC-2: <Alternate path>
...

### AC-3: <Error/edge>
...

## Cross-Cutting Invariants
- [ ] Strings localized (namespace: `<ns>`) — EN + AR pairs
- [ ] RTL-tested (screenshot in `ar`)
- [ ] `schoolId` predicate on every query
- [ ] Role gate enforced
- [ ] Audit log entry per mutation
- [ ] Entity content rendered with `entity.lang` (when applicable)

## Files to Create/Modify
- `hogwarts/features/<feature>/views/<file>.swift` — <change>
- `hogwarts/features/<feature>/viewmodels/<file>.swift` — <change>
- `hogwarts/features/<feature>/services/<file>.swift` — <change>
- `hogwarts/features/<feature>/models/<file>.swift` — <change>

## API Contract
- `<METHOD> /api/mobile/<path>` — <one-line>
  - Request (snake_case): `{ ... }`
  - Response: `{ ... }`

## i18n Keys
- `<namespace>.<screen>.<element>`

## Tests
- `HogwartsTests/<feature>/<feature>-<test>-tests.swift`
- Snapshots: AR + EN, light + dark
- Multi-tenant isolation test if mutating

## Verification
<command + expected output OR /watch URL>

## Dependencies
- **Depends on**: <story IDs>
- **Blocks**: <story IDs>

## Definition of Done
- [ ] AC met
- [ ] String parity preserved (script clean)
- [ ] RTL screenshot attached
- [ ] schoolId scope verified
- [ ] Role gate verified
- [ ] Coverage threshold met
- [ ] PR linked, reviewed, merged
```

## Naming convention

`<EPIC>-<NUM>-<kebab-slug>.md` — examples:
- `AUTH-007-sign-in-with-apple.md`
- `ATT-T-003-qr-code-scan-attendance.md`
- `MSG-026-socket-realtime-wire.md`
- `PLT-005-live-activity-class-timer.md`
