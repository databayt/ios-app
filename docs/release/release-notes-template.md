# Release Notes Template

> Copy this template for each release. The TestFlight workflow at
> `.github/workflows/testflight.yml` parses the **EN section** below as
> the TestFlight changelog if the git tag has no annotation body.
> Annotated tags (`git tag -a v1.0.0-rc1 -m "$(cat notes.txt)"`) override
> the template — preferred for one-off releases.

## Process

1. Copy this file to `docs/release/v{version}.md` (e.g. `v1.0.0-rc1.md`)
2. Fill in EN + AR sections with the actual changes
3. Create an annotated tag: `git tag -a v1.0.0-rc1 -m "$(cat docs/release/v1.0.0-rc1.md | sed -n '/^## EN/,/^## AR/p' | sed '1d;$d')"`
4. `git push origin v1.0.0-rc1` — the `testflight.yml` workflow takes over

## Length limits

- TestFlight changelog: 4000 chars per locale
- App Store "What's New": 4000 chars per locale
- Keep individual bullets to one line so the iOS Apple App Store dialog
  renders cleanly on a 5.5" iPhone

---

## EN

### New
- _What you can do for the first time. User-facing only — no internal refactors._

### Improved
- _What got faster, clearer, or more accessible._

### Fixed
- _Bugs that no longer reproduce, in user-visible terms._

### Known issues
- _Bugs we know about, with workarounds where possible._

---

## AR

### الجديد
- _ما يمكنك فعله للمرة الأولى._

### تحسينات
- _ما أصبح أسرع، أوضح، أو أكثر إتاحة._

### إصلاحات
- _أخطاء لم تعد تحدث، بمصطلحات يفهمها المستخدم._

### مشكلات معروفة
- _أخطاء نعلم بها، مع حلول بديلة حيث أمكن._

---

## Tone

- Direct, action-led, no jargon
- "You can now…" beats "The app now lets you…"
- Match the iOS App Store tone — concise, end-user friendly, no acronyms
- AR translation mirrors EN line-for-line; if a feature has no clean AR
  rendering, surface it to Samia for a polish pass before the tag fires

## Excluded

Things to **not** include in release notes:

- Internal refactors that don't change behavior
- Test infrastructure changes
- Documentation-only updates
- CI / pipeline changes
- Story IDs or PR numbers (those belong in the changelog)
