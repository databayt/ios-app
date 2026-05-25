import XCTest

/// SHIP-002 — Drives the 5 critical flows so the screenshot capture
/// script can pull rendered PNGs out of the XCResult bundle.
///
/// Wired by `scripts/capture-app-store-screenshots.sh`, which sets:
///   - `HOGWARTS_SCREENSHOT_LOCALE` (en | ar)
///   - `HOGWARTS_SCREENSHOT_FLOWS`  (space-separated list — login dashboard attendance messages fees)
///
/// The actual flow navigation is best-effort: every step waits a bounded
/// duration and skips silently if the expected element doesn't appear,
/// so screenshot capture still produces SOMETHING even if a flow's
/// accessibility identifiers haven't been wired yet. Where this happens,
/// the next iteration tightens the test by adding identifiers in the
/// matching feature view.
final class ScreenshotTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = true
        app = XCUIApplication()

        // Forward the script's env into the app so AppDelegate can:
        //   - swap to the screenshot demo account
        //   - force the locale before any string lookup
        //   - skip the consent / biometric gates
        app.launchEnvironment = [
            "HOGWARTS_SCREENSHOT_MODE": "1",
            "HOGWARTS_SCREENSHOT_LOCALE": ProcessInfo.processInfo.environment["HOGWARTS_SCREENSHOT_LOCALE"] ?? "en"
        ]
        app.launchArguments = [
            "--uitesting",
            "--screenshot-mode",
            "-AppleLanguages", "(\(app.launchEnvironment["HOGWARTS_SCREENSHOT_LOCALE"] ?? "en"))",
            "-AppleLocale", app.launchEnvironment["HOGWARTS_SCREENSHOT_LOCALE"] == "ar" ? "ar_SA" : "en_US"
        ]
    }

    /// The script invokes this single test. It internally walks every
    /// flow listed in `HOGWARTS_SCREENSHOT_FLOWS` and attaches a
    /// screenshot per flow to the test result bundle.
    func testCaptureAllFlows() throws {
        app.launch()

        let flows = (ProcessInfo.processInfo.environment["HOGWARTS_SCREENSHOT_FLOWS"] ?? "login dashboard attendance messages fees")
            .split(separator: " ")
            .map(String.init)

        for flow in flows {
            switch flow {
            case "login":      captureLogin()
            case "dashboard":  captureDashboard()
            case "attendance": captureAttendance()
            case "messages":   captureMessages()
            case "fees":       captureFees()
            default:
                XCTFail("Unknown flow: \(flow)")
            }
        }
    }

    // MARK: - Flow drivers
    // Each navigates best-effort then attaches a screenshot. Missing
    // accessibility identifiers degrade to "snapshot whatever is on
    // screen" rather than fail outright — keeps capture unblocked
    // while iterating on identifier coverage.

    private func captureLogin() {
        // If already signed in (demo account), sign out first so the
        // screenshot reflects the login screen.
        if app.tabBars.firstMatch.waitForExistence(timeout: 3) {
            navigateToProfile()
            app.buttons["a11y.profile.signOut"].firstMatchTap(timeout: 3)
        }
        _ = app.textFields.firstMatch.waitForExistence(timeout: 10)
        attach(named: "01-login")
    }

    private func captureDashboard() {
        ensureSignedIn()
        guard let dashboardTab = tab(at: 0) else { return }
        dashboardTab.tap()
        Thread.sleep(forTimeInterval: 0.8)
        attach(named: "02-dashboard")
    }

    private func captureAttendance() {
        ensureSignedIn()
        // Attendance lives behind a home-grid tile on the dashboard;
        // fall back to a tab if the tile-tap isn't wired.
        guard let dashboardTab = tab(at: 0) else { return }
        dashboardTab.tap()
        let attendanceTile = app.buttons["a11y.home.tile.attendance"].firstMatch
        if attendanceTile.waitForExistence(timeout: 3) {
            attendanceTile.tap()
            Thread.sleep(forTimeInterval: 1.0)
        }
        attach(named: "03-attendance")
    }

    private func captureMessages() {
        ensureSignedIn()
        guard let messagesTab = tab(at: 2) else { return }
        messagesTab.tap()
        Thread.sleep(forTimeInterval: 0.8)
        // If a first conversation is visible, tap into it for the
        // money-shot of the WhatsApp-style chat — otherwise show the list.
        let firstRow = app.cells.firstMatch
        if firstRow.waitForExistence(timeout: 2) {
            firstRow.tap()
            Thread.sleep(forTimeInterval: 0.8)
        }
        attach(named: "04-messages")
    }

    private func captureFees() {
        ensureSignedIn()
        guard let dashboardTab = tab(at: 0) else { return }
        dashboardTab.tap()
        let feesTile = app.buttons["a11y.home.tile.fees"].firstMatch
        if feesTile.waitForExistence(timeout: 3) {
            feesTile.tap()
            Thread.sleep(forTimeInterval: 1.0)
        }
        attach(named: "05-fees")
    }

    // MARK: - Helpers

    private func ensureSignedIn() {
        if app.tabBars.firstMatch.waitForExistence(timeout: 3) { return }
        // Fast-path login via demo account (assumes HOGWARTS_SCREENSHOT_MODE
        // wires AppDelegate to seed credentials).
        let emailField = app.textFields.firstMatch
        if emailField.waitForExistence(timeout: 5) {
            emailField.tap()
            emailField.typeText("apple-review@databayt.org")
            let passwordField = app.secureTextFields.firstMatch
            if passwordField.waitForExistence(timeout: 2) {
                passwordField.tap()
                passwordField.typeText("ReviewerDemo!2026")
            }
            app.buttons["a11y.login.submit"].firstMatchTap(timeout: 3)
        }
        _ = app.tabBars.firstMatch.waitForExistence(timeout: 15)
    }

    private func navigateToProfile() {
        guard let profileTab = tab(at: 4) else { return }
        profileTab.tap()
        Thread.sleep(forTimeInterval: 0.5)
    }

    private func tab(at index: Int) -> XCUIElement? {
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else { return nil }
        let button = tabBar.buttons.element(boundBy: index)
        return button.isHittable ? button : nil
    }

    private func attach(named name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

// MARK: - XCUIElement convenience

private extension XCUIElement {
    /// Tap if the element appears within `timeout`; otherwise no-op.
    /// Lets the screenshot driver tolerate missing a11y identifiers.
    func firstMatchTap(timeout: TimeInterval) {
        if waitForExistence(timeout: timeout) {
            tap()
        }
    }
}
