# SHIP-009: Fastlane + GitHub Actions TestFlight Pipeline

**Epic**: SHIP
**Priority**: P0
**Phase**: M0
**Status**: done
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** product team shipping every sprint
**I want** every push of a `v*` tag on `main` to build, sign, and upload to TestFlight automatically
**So that** TestFlight distribution is reproducible, audit-traced, and never bottlenecked by one engineer's local Xcode setup

## Acceptance Criteria

### AC-1: Fastlane lane
**Given** the repo has a `fastlane/` directory
**When** a developer runs `fastlane beta` locally with valid App Store Connect API key
**Then** the lane archives the app with the Release config, signs with the matched profile, and uploads to TestFlight with the current `CHANGELOG.md` excerpt as release notes

### AC-2: CI trigger
**Given** a tag matching `v*` is pushed to `main`
**When** the `.github/workflows/testflight.yml` workflow fires
**Then** GitHub Actions runs `fastlane beta` on a macOS-15 runner, completes in under 25 minutes, and the build shows up in App Store Connect within 30 minutes of the tag push

### AC-3: Secrets in GitHub environment
**Given** repo secrets are configured
**When** the workflow runs
**Then** `APP_STORE_CONNECT_API_KEY_ID`, `APP_STORE_CONNECT_API_KEY_ISSUER_ID`, `APP_STORE_CONNECT_API_KEY_CONTENT` (base64), `MATCH_PASSWORD`, and `MATCH_GIT_BASIC_AUTHORIZATION` are loaded; no plaintext credentials appear in logs

### AC-4: Match for signing
**Given** Fastlane Match is configured against a private signing repo
**When** the lane runs
**Then** profiles are pulled / created idempotently and the same certificate is reused across CI and local builds (no "another developer is using this certificate" warnings)

## Cross-Cutting Invariants
- [ ] No App Store Connect 2FA prompt during CI run (use API key, not Apple ID password)
- [ ] Build number monotonically increments (use `agvtool` or App Store Connect's latest-build query)
- [ ] Release notes pulled from `CHANGELOG.md` head and localized (AR + EN) before upload
- [ ] Crash symbols (.dSYM) uploaded to Sentry as part of the same lane (depends on OBS-001)
- [ ] Apple Pay merchant ID + APNs key documented in `docs/release/credentials.md` (paths, not secrets)

## Files
- `fastlane/Fastfile` — `beta` + `release` lanes
- `fastlane/Appfile` — bundle id, team id, App Store Connect API key path
- `fastlane/Matchfile` — match repo URL, storage mode
- `fastlane/Pluginfile` — `fastlane-plugin-sentry`, `fastlane-plugin-versioning`
- `.github/workflows/testflight.yml` — tag-triggered workflow, secrets, runner spec
- `Hogwarts.xcconfig` (new) — per-config build settings consumed by Fastlane
- `docs/release/testflight-distribution.md` — engineer-facing runbook
- `docs/release/credentials.md` — credential inventory (key IDs, profile names, no secrets)

## API Contract
- App Store Connect API (key-based auth, not Apple ID)
- No `/api/mobile/*` interaction

## i18n Keys
- (release notes pulled from `CHANGELOG.md`; no in-app strings)

## Tests
- Manual: tag `v0.0.0-test1` on a topic branch → workflow runs → TestFlight build appears
- Manual: revoke API key → workflow fails cleanly with a non-confusing error
- Manual: run `fastlane beta` locally → matches CI behavior

## Dependencies
- Depends on: [CORE-009](./CORE-009-env-config-schemes.md) (env config schemes), [OBS-001](./OBS-001-sentry-crash-reporting.md) (Sentry dSYM upload)
- Blocks: [SHIP-001](./SHIP-001-testflight-setup.md) for sustained operation (SHIP-001 covers initial TestFlight setup; SHIP-009 covers the *automation* of every subsequent release)

## Definition of Done
- [ ] AC-1..4 met
- [ ] First automated TestFlight build distributed via tag push
- [ ] Runbook in `docs/release/testflight-distribution.md` lets a new engineer ship a build without help
- [ ] Credential rotation procedure documented (what to do when an API key expires or a cert needs to be revoked)
