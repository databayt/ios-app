# TestFlight Distribution Runbook

> SHIP-001 + SHIP-009. How to ship a build to TestFlight from scratch.
> Read this once before the first release; subsequent releases are
> just steps 4–6.

## What's automated

Push a tag matching `v*` on `main` and the workflow at
`.github/workflows/testflight.yml`:

1. Regenerates the Xcode project via `xcodegen`
2. Pulls signing certs via Fastlane Match (private signing repo)
3. Archives Release config
4. Uploads to TestFlight via Pilot using the App Store Connect API key
5. Pushes dSYMs to Sentry so symbolicated crashes show up alongside the build
6. (optional) Posts to Slack if `SLACK_URL` is set

What's still human:

- Inviting external testers + filling the External Test Information page in App Store Connect (one-time per release stream)
- Tagging the correct commit with the correct semantic version
- Writing the release notes (see `release-notes-template.md`)

## Pre-flight (one-time, before the first build)

### 1. App Store Connect API Key

App Store Connect → Users & Access → Keys → "+"

- **Name**: `hogwarts-ios-ci`
- **Access**: App Manager
- Download the `.p8` file. **You cannot re-download** — save it in 1Password.

Note the **Key ID** (10 chars, e.g. `ABCDEF1234`) and **Issuer ID** (a UUID).

### 2. Base64 the key

```bash
base64 -i AuthKey_ABCDEF1234.p8 | tr -d '\n' | pbcopy
```

### 3. Match signing repo

Create a private GitHub repo for signing certs:

```bash
gh repo create databayt/ios-signing --private \
  --description "Match-managed iOS certificates — DO NOT MAKE PUBLIC"
```

Generate a Personal Access Token with `repo` scope. Base64-encode `username:token`:

```bash
echo -n "abdout:ghp_yourTokenHere" | base64
```

That base64 string is `MATCH_GIT_BASIC_AUTHORIZATION`.

Pick a strong password for encrypting the certs in the repo (`MATCH_PASSWORD`). Save in 1Password.

Locally:

```bash
cd ~/ios-app
bundle exec fastlane match appstore --git_url https://github.com/databayt/ios-signing.git
```

Fastlane will create the distribution cert + profile and push encrypted copies to the signing repo.

### 4. GitHub Actions secrets

Repo Settings → Secrets and variables → Actions → New repository secret. Add all of:

| Secret | Value |
|--------|-------|
| `APP_STORE_CONNECT_API_KEY_ID` | 10-char Key ID from step 1 |
| `APP_STORE_CONNECT_API_KEY_ISSUER_ID` | UUID from step 1 |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | Base64 of `.p8` from step 2 |
| `MATCH_GIT_URL` | `https://github.com/databayt/ios-signing.git` |
| `MATCH_PASSWORD` | Strong password from step 3 |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Base64 from step 3 |
| `FASTLANE_APPLE_ID` | `abdout@databayt.org` (or whichever Apple ID owns the cert) |
| `DEVELOPMENT_TEAM` | Apple Developer team ID (10-char) |
| `ITC_TEAM_ID` | App Store Connect team ID (often the same digits as DEVELOPMENT_TEAM, sometimes different) |
| `SENTRY_AUTH_TOKEN` | Sentry internal integration token with `project:releases` scope |
| `SLACK_URL` *(optional)* | Slack webhook for build-success notifications |

### 5. App Store Connect app shell

App Store Connect → My Apps → "+" → New App

- **Platform**: iOS
- **Name**: `Hogwarts`
- **Primary language**: English (U.S.)
- **Bundle ID**: `org.databayt.Hogwarts` (select from the list — must already exist in Apple Developer portal)
- **SKU**: `org-databayt-hogwarts`
- **User Access**: Full Access

Fill the privacy questionnaire to match `PrivacyInfo.xcprivacy` (10 collected data types).

### 6. Demo account for App Review

Create `apple-review@databayt.org` on `demo.databayt.org` school. Password rotates per submission — add to the App Review Information section in App Store Connect when filing for review.

## Per-release (the actual cadence)

### 1. Branch + verify CI

```bash
git checkout main
git pull
git checkout -b release/v1.0.0-rc1
xcodegen generate
xcodebuild test -scheme Hogwarts -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.4' | xcbeautify
```

All tests green? Continue.

### 2. Write release notes

Copy `release-notes-template.md` to `docs/release/v1.0.0-rc1.md`. Fill EN + AR sections.

### 3. Tag (annotated)

```bash
# Extract just the EN bullets into the tag annotation so TestFlight gets clean changelog
tag_body=$(awk '/^## EN/{flag=1; next} /^## AR/{flag=0} flag' docs/release/v1.0.0-rc1.md)
git tag -a v1.0.0-rc1 -m "$tag_body"
git push origin v1.0.0-rc1
```

### 4. Watch the workflow

```bash
gh run watch --repo databayt/ios-app
```

Average run: ~20 min on macos-15. If it fails, see "Troubleshooting" below.

### 5. Approve external test access (one-time per Test Information change)

App Store Connect → Apps → Hogwarts → TestFlight → External Testing → fill **Test Information** (description, feedback email, marketing URL). Submit for Apple Beta App Review. Approval usually < 24h.

### 6. Distribute

App Store Connect → TestFlight → Builds → pick the new build → add it to the External group (or distribute via public link if configured).

Notify testers via the App Store Connect invite, **plus** post the changelog in the team Slack `#ios-betas` channel.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `Missing required env vars: APP_STORE_CONNECT_API_KEY_CONTENT` | Secret not set or empty | Set the secret in GitHub Actions; values can't have trailing newlines |
| `Another developer is using this certificate` warning | Two CI runs trying to refresh certs | `match` lane has `readonly: true` so this shouldn't happen — investigate before adding `force_for_new_devices: true` |
| `No appropriate visible windows` during archive | Xcode version mismatch | `xcodebuild -version` should report 26.x; if not, `sudo xcode-select -s /Applications/Xcode_26.app` |
| TestFlight build "Missing Compliance" red badge | `ITSAppUsesNonExemptEncryption` not set | Already set to `false` in `project.yml` — re-generate the project |
| Sentry "No DSYM uploaded" warning | `SENTRY_AUTH_TOKEN` secret missing or wrong scope | Token needs `project:releases` scope, not just `event:write` |
| Build number conflict on TestFlight | Tag pushed twice with same SHA | Delete the conflicting build in App Store Connect; tag with `-rc2` next time |
| Pilot rejected for "missing privacy" | `PrivacyInfo.xcprivacy` and App Store Connect questionnaire don't match | Audit both, align field-by-field |

## Credential rotation

- **API Key** expires when revoked. Rotate annually: revoke old key in App Store Connect → generate new → update `APP_STORE_CONNECT_API_KEY_*` secrets → run a test build.
- **Match password** rotates when an engineer leaves the team with access. Run `fastlane match nuke distribution` + re-init.
- **Personal access token** for the Match repo rotates annually or whenever the engineer's GitHub access changes.
- **Sentry token** rotates whenever the Sentry integration is replaced.

Each rotation requires a test build to verify before tagging the next release.

## Cross-reference

- `fastlane/Fastfile` — lane source
- `.github/workflows/testflight.yml` — CI workflow
- `docs/release/release-notes-template.md` — release notes template
- `docs/SHIP-CHECKLIST.md` — App Store submission checklist (for when we promote from TestFlight to public)
- [SHIP epic](../epics/SHIP.md), [SHIP-009 story](../stories/SHIP-009-fastlane-testflight-pipeline.md)
