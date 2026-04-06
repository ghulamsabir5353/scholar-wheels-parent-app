# Deep Link Server Files Setup Guide

This directory contains the files needed for App Links (Android) and Universal Links (iOS) to work.

The parent app registers **two** HTTPS hosts: `api.scholarwheels.co.za` and `productionapi.scholarwheels.co.za`.  
You must upload the **same** `assetlinks.json` and `apple-app-site-association` content under `/.well-known/` on **each** host (correct `Content-Type`, HTTPS, no redirects), or Android/iOS verification will fail for the host that is missing them.

Payment return URLs generated in the app use `AppConstants.appLinksBaseUrl` (currently `https://api.scholarwheels.co.za`); the API base for REST calls is separate (`productionapi`).

## Files Required

### 1. Android App Links
**File:** `.well-known/assetlinks.json`  
**URL:** `https://api.scholarwheels.co.za/.well-known/assetlinks.json`  
**Content-Type:** `application/json`

### 2. iOS Universal Links
**File:** `.well-known/apple-app-site-association`  
**URL:** `https://api.scholarwheels.co.za/.well-known/apple-app-site-association`  
**Content-Type:** `application/json`  
**Important:** File must NOT have `.json` extension

## Server Configuration

### Nginx Configuration Example

```nginx
# Serve assetlinks.json with correct content-type
location /.well-known/assetlinks.json {
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '/path/to/assetlinks.json';
}

# Serve apple-app-site-association with correct content-type
location /.well-known/apple-app-site-association {
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '/path/to/apple-app-site-association';
}
```

### Apache Configuration Example

```apache
<Files "assetlinks.json">
    Header set Content-Type "application/json"
</Files>

<Files "apple-app-site-association">
    Header set Content-Type "application/json"
</Files>
```

### Express.js/Node.js Example

```javascript
app.get('/.well-known/assetlinks.json', (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.sendFile(path.join(__dirname, 'assetlinks.json'));
});

app.get('/.well-known/apple-app-site-association', (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.sendFile(path.join(__dirname, 'apple-app-site-association'));
});
```

## Critical Requirements

1. **Content-Type Header**: Both files MUST return `Content-Type: application/json`
2. **HTTPS Only**: Files must be accessible via HTTPS (not HTTP)
3. **No Redirects**: Files must be served directly (no 301/302 redirects)
4. **Public Access**: Files must be publicly accessible (no authentication required)
5. **No .json Extension**: iOS file must be named `apple-app-site-association` (no extension)

## Verification

Run the verification script:

```bash
./verify-deep-links.sh
```

Or manually check:

```bash
# Check Android file
curl -I https://api.scholarwheels.co.za/.well-known/assetlinks.json

# Check iOS file
curl -I https://api.scholarwheels.co.za/.well-known/apple-app-site-association

# Both should return:
# Content-Type: application/json
```

## Testing

### Android
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://api.scholarwheels.co.za/payment/success?planId=123"
```

### iOS
1. Open Safari on a physical device
2. Navigate to: `https://api.scholarwheels.co.za/payment/success?planId=123`
3. The app should open directly (not Safari)

## Troubleshooting

### Android App Links Not Working
- Verify `autoVerify="true"` in AndroidManifest.xml
- Check certificate fingerprints match exactly
- Android verification can take up to 20 minutes after app install
- Use `adb shell pm get-app-links co.za.scholarwheels.app.parent` to check verification status

### iOS Universal Links Not Working
- **Most common issue**: Content-Type must be `application/json` (not `text/plain`)
- Verify Associated Domains capability is enabled in Xcode
- Check entitlements file is included in build
- Test on physical device (not simulator)
- Long-press link if it opens in Safari
- Check app ID format: `TEAM_ID.BUNDLE_ID` (e.g., `8Z99B3DSQ9.co.za.scholarwheels.app.parent`)

## File Locations on Server

Upload files to:
```
/.well-known/assetlinks.json
/.well-known/apple-app-site-association
```

Make sure the `.well-known` directory is accessible and files are served with correct headers.
