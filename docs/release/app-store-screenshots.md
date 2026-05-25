# App Store Screenshots — Specification

> SHIP-002. What screenshots Apple needs, how to generate them, and which flows tell the Hogwarts story.

## Quantity

Apple requires screenshots for at least one device size; supplying all three covers every device a buyer might browse on.

| Device size | Class | Resolution (pt @3x) |
|-------------|-------|---------------------|
| 6.9" iPhone | iPhone 17 Pro Max | 1320 × 2868 |
| 6.1" iPhone | iPhone 17 | 1206 × 2622 |
| 13" iPad Pro | iPad Pro 13-inch (M4) | 2064 × 2752 |

Each device size × 2 locales (en + ar) × 5 critical flows = **30 screenshots minimum**. App Store Connect allows up to 10 screenshots per device size per locale; 5 is the strongest narrative density without padding.

## Five critical flows (the story)

The screenshots tell a 5-frame story of what Hogwarts does. Order matches the App Store gallery order:

1. **Login** — Sign in with Apple + biometric prompt → "Sign in once, school-aware everywhere."
2. **Dashboard** — Role-aware home grid (admin / teacher / student / parent variants — we ship the parent variant; it's the largest install base).
3. **Attendance** — Mark/view class attendance with gamification badges → "Track attendance offline; sync when you're back online."
4. **Messages** — WhatsApp-style chat with a teacher → "Direct line to every teacher, parent-to-school messaging that works."
5. **Fees** — Fee summary with Apple Pay button → "Pay tuition in one tap, no separate website, no paper receipts."

The promo text + What's New text reference these flows by number ("1. one-tap sign-in. 2. role-aware dashboard. …") so the App Store listing reads as a coherent narrative.

## How to capture

### Automated (preferred)

```bash
scripts/capture-app-store-screenshots.sh
```

Drives the UITest target through all 5 flows × 2 locales × 3 device sizes via `xcodebuild test` with a `ScreenshotTests` XCTest case. Output: `build/screenshots/{locale}/{size}/{flow}.png`.

Per-axis override:

```bash
FLOW=dashboard scripts/capture-app-store-screenshots.sh
LOCALE=ar SIZE="iPhone 17 Pro Max" scripts/capture-app-store-screenshots.sh
```

**Pre-flight check** before running:

- TestFlight demo account is seeded with realistic data (5+ classes, 30+ students, 20+ messages, recent attendance entries, 1 paid + 1 outstanding fee)
- Simulator language matches `HOGWARTS_SCREENSHOT_LOCALE` env var
- Status bar override on (clean time `09:41`, full signal, full battery — `xcrun simctl status_bar booted override --time 9:41 --batteryLevel 100 --batteryState charged`)

### Manual fallback (when CI is unavailable)

1. Boot the relevant simulator (iPhone 17 Pro Max / iPhone 17 / iPad Pro 13")
2. Switch device language to AR or EN in Settings
3. Override status bar via `xcrun simctl status_bar` (as above)
4. Cold-launch app, drive each flow by hand
5. `xcrun simctl io booted screenshot ~/Desktop/{flow}-{locale}-{size}.png` at each beat
6. Repeat ×3 sizes ×2 locales ×5 flows = 30 images
7. Sort into `build/screenshots/{locale}/{size}/{flow}.png` directories

Manual capture takes ~90 minutes per full run. The script takes ~25.

## Frame variations per role

We ship the **parent** variant of dashboard + messages because parents are the install-volume driver. Teachers are an internal sell. If we later add a **teacher**-targeted variant for the App Store (e.g. a separate listing tier), capture an additional 5-frame set using a teacher demo account.

## Localization

- Arabic frames must be **fully RTL** — text, icons, layout, even chart axes
- Numbers in AR frames use Arabic-Indic digits (`٠١٢٣٤٥٦٧٨٩`); the in-app formatters already handle this via `Locale.current`
- Time in AR frames respects 12h / 24h based on locale preferences
- Currency renders as ر.س (or whichever the tenant's School.currency dictates) in AR; "SAR" in EN

## App Preview video (optional, recommended)

- 15–30 seconds, portrait, no narration (Apple plays muted by default)
- Walks the same 5 flows in the same order as the screenshots
- One per device size × locale (so 6 videos total) — optional but increases install rate
- Capture via `xcrun simctl io booted recordVideo ~/Desktop/{locale}-{size}.mov`, trim in QuickTime, export H.264 portrait

## Upload to App Store Connect

App Store Connect → My Apps → Hogwarts → App Store → 1.0.0 → English (U.S.) / Arabic (Saudi Arabia) → Screenshots section.

Drag-drop the matching folder from `build/screenshots/{locale}/{size}/`. Apple validates dimensions automatically; if a frame fails, the size override in the simulator was wrong.

## Iteration

The first set goes through App Review at the same time as the binary. Apple **does** fail-for-screenshots, usually citing:
- Marketing text overlay (we don't add overlays; just the rendered UI)
- Stale UI (mismatched between screenshot and current app version)
- Generic / template appearance (counter with real classroom data, not Lorem Ipsum)

Re-capture and re-upload via App Store Connect — does not require a new binary submission unless the UI itself changed.

## Cross-reference

- [`scripts/capture-app-store-screenshots.sh`](../../scripts/capture-app-store-screenshots.sh)
- [`docs/release/app-review-playbook.md`](./app-review-playbook.md)
- [`docs/SHIP-CHECKLIST.md`](../SHIP-CHECKLIST.md)
- [SHIP-002 story](../stories/SHIP-002-app-store-assets.md)
- Apple App Store Connect screenshot specifications: https://help.apple.com/app-store-connect/#/devd274dd925
