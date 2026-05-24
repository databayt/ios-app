# TestFlight Distribution Guide

This guide walks you through distributing the Hogwarts iOS app via Apple's TestFlight service to beta testers.

## Prerequisites

- Apple Developer Account ($99/year) at [developer.apple.com](https://developer.apple.com)
- Xcode 15.0 or later
- Development Team ID from your Apple Developer account
- App record created in [App Store Connect](https://appstoreconnect.apple.com)

## Step 1: Create App in App Store Connect

1. Sign in to [App Store Connect](https://appstoreconnect.apple.com)
2. Click "Apps" → "+" → "New App"
3. Fill in app details:
   - **Platform**: iOS
   - **Name**: Hogwarts
   - **Primary Language**: English
   - **Bundle ID**: `org.databayt.Hogwarts`
   - **SKU**: hogwarts-school-management
   - **User Access**: Full Access

4. You may need to complete additional app information before uploading builds.

## Step 2: Configure Code Signing

### Update project.yml

Open `project.yml` and update the base settings with your Apple Developer Team ID:

```yaml
settings:
  base:
    DEVELOPMENT_TEAM: "YOUR_TEAM_ID"  # Replace with your 10-character Team ID
    CODE_SIGN_STYLE: Automatic
```

### Create Provisioning Profiles

1. In Xcode: **Window** → **Accounts** → Select your Apple ID
2. Click **Manage Certificates...**
3. Create/download:
   - **iOS Distribution** certificate (for App Store)
   - **iOS Development** certificate (for testing)

4. In Xcode: **Signing & Capabilities** tab of Hogwarts target
5. Select your Team ID
6. Xcode will automatically create provisioning profiles

## Step 3: Archive the App

### Option A: Using Provided Build Script

```bash
# Basic archive (uses automatic code signing)
./scripts/archive-for-testflight.sh

# With specific Team ID
./scripts/archive-for-testflight.sh YOUR_TEAM_ID

# With environment variable
export HOGWARTS_TEAM_ID=YOUR_TEAM_ID
./scripts/archive-for-testflight.sh
```

Build artifacts will be in the `build/` directory:
- `build/Hogwarts.xcarchive` - Archive file
- `build/Hogwarts.ipa` - App binary

### Option B: Using Xcode

1. Open `Hogwarts.xcodeproj` in Xcode
2. Select scheme: **Hogwarts** (top left)
3. Select destination: **Generic iOS Device**
4. **Product** → **Archive**
5. Wait for build to complete
6. In the Organizer window, click **Distribute App**
7. Choose **TestFlight and the App Store**
8. Follow the export wizard

## Step 4: Upload to TestFlight

### Option A: Using Xcode (Recommended)

1. After archiving, the Organizer shows your build
2. Click **Distribute App**
3. Choose **TestFlight and the App Store**
4. Select **Upload** (not Export)
5. Sign in with your Apple Developer account
6. Follow the prompts to upload

### Option B: Using Transporter

1. [Download Transporter](https://apps.apple.com/us/app/transporter/id1450874784) from App Store
2. Open Transporter
3. Sign in with your Apple Developer account
4. Click **+** or drag and drop `build/Hogwarts.ipa`
5. Click **Deliver**
6. Wait for processing (usually 5-10 minutes)

### Option C: Using Command Line

```bash
# Using xcrun altool (deprecated but still works)
xcrun altool --upload-app \
  -f build/Hogwarts.ipa \
  -t ios \
  -u YOUR_APPLE_ID \
  -p YOUR_APP_PASSWORD

# App password: Generate at https://appleid.apple.com
# Select "App-specific password" in Security section
```

## Step 5: Configure TestFlight

1. In App Store Connect, go to your app → **TestFlight** tab
2. Under "Builds", your new build will appear after processing
3. Click the build to see details

### Add Beta Testers

**Internal Testers** (team members):
1. Go to **Testers and Groups** → **Internal Testing**
2. Testers who have access to your developer account are added automatically
3. They'll receive an email invite

**External Testers** (public beta):
1. Go to **Testers and Groups** → **External Testing**
2. Click **Create Group** or select existing group
3. Add up to 10,000 external testers by email
4. Configure testing duration (max 90 days)
5. Submit for review (Apple approves within 24 hours)

### Send TestFlight Links

- **Internal testers**: Automatically notified
- **External testers**: Copy the public link from TestFlight
- Share link: `https://testflight.apple.com/join/xxxxx`

## Step 6: Monitor TestFlight

### Tester Feedback

1. Go to **Feedback** section in TestFlight
2. View crash reports, screenshots, and written feedback
3. Testers can provide feedback via TestFlight app

### Build Expiration

- TestFlight builds expire after **90 days**
- Before expiration, upload a new build for continuous testing
- Use versioning to track builds (see Version Management below)

## Version Management

### Incrementing Build Numbers

Before each TestFlight upload, update `project.yml`:

```yaml
settings:
  base:
    MARKETING_VERSION: "1.0.0"      # Public version number (1.0.0, 1.1.0, etc.)
    CURRENT_PROJECT_VERSION: "2"     # Build number (increment each upload)
```

Examples:
- Build 1 → v1.0.0 (1.0.0.1)
- Build 2 → v1.0.0 (1.0.0.2)
- Build 3 → v1.1.0 (1.1.0.1) - New feature release
- Build 4 → v1.1.0 (1.1.0.2) - Bug fix for 1.1.0

### Version in App

In your app, display the version for tester reference:

```swift
// In app settings or about screen
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
Text("Version: \(appVersion) (Build \(buildNumber))")
```

## Troubleshooting

### Build Stuck in "Processing"

- Wait up to 30 minutes
- Check your email for rejection reasons
- View details in App Store Connect → Builds section

### Code Signing Issues

```
Error: Could not find matching Team ID
```

1. Verify DEVELOPMENT_TEAM in `project.yml`
2. Run `xcodebuild -showsdks` to list available SDKs
3. Manually select team in Xcode:
   - Select project → Hogwarts target
   - **Signing & Capabilities** tab
   - Select your Team ID from dropdown

### Export Fails

```
Error: "Hogwarts" requires a provisioning profile
```

1. Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData/Hogwarts*`
2. In Xcode: **Window** → **Accounts** → Click refresh
3. Rebuild provisioning profile
4. Try archiving again

### Transporter Errors

```
ERROR ITMS-90720: Invalid Bundle Structure
```

1. Ensure `ExportOptions.plist` has correct method: `app-store`
2. Verify bundle ID matches App Store Connect
3. Use Xcode's export wizard instead (easier)

## Monitoring on Device

### Install TestFlight Build

1. Open TestFlight app on physical iPhone
2. Sign in with Apple ID (same as Apple Developer account)
3. Tap the Hogwarts build
4. Tap "Install" (may take several minutes)
5. Once installed, tap "Open"

### View Crash Logs

Testers can send feedback within TestFlight app:
1. Open app
2. Shake device (or **Settings** → **App Feedback**)
3. Fill out crash report or feedback
4. Submit

## Next Steps After TestFlight

### Submit to App Store

Once you're confident in the build:

1. In App Store Connect, go to **App Store** tab
2. Fill in screenshots, description, keywords, etc.
3. Set **Release Type**: Manual or Automatic
4. Submit for App Store review
5. Apple reviews within 24-48 hours
6. Upon approval, release to all users

### Update Version for App Store

Before submitting, update MARKETING_VERSION:

```yaml
settings:
  base:
    MARKETING_VERSION: "1.0.0"      # Matches App Store release version
    CURRENT_PROJECT_VERSION: "10"    # Much higher build number
```

## References

- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [TestFlight Beta Testing Guide](https://developer.apple.com/testflight/)
- [Xcode Archiving Guide](https://help.apple.com/xcode/mac/13.0/index.html?localeName=en#/dev8b4250b57)
- [Code Signing Guide](https://developer.apple.com/support/code-signing/)

## Support

For issues with TestFlight:
- **Apple Developer Forums**: [developer.apple.com/forums](https://developer.apple.com/forums)
- **Xcode Help**: **Help** → **Xcode Help** (in Xcode menu)
- **App Store Connect Support**: Direct message in App Store Connect app
