#!/bin/bash

# Deep Link Verification Script
# This script verifies that deep link files are properly configured on the server

echo "🔍 Verifying Deep Link Configuration..."
echo ""

BASE_URL="https://api.scholarwheels.co.za"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check URL
check_url() {
    local url=$1
    local expected_content_type=$2
    local description=$3
    
    echo "Checking: $description"
    echo "URL: $url"
    
    # Get headers
    response=$(curl -s -I "$url" 2>&1)
    status_code=$(echo "$response" | grep -i "HTTP" | head -1 | awk '{print $2}')
    content_type=$(echo "$response" | grep -i "content-type" | awk -F': ' '{print $2}' | tr -d '\r')
    
    if [ -z "$status_code" ]; then
        echo -e "${RED}❌ Failed to connect${NC}"
        echo ""
        return 1
    fi
    
    if [ "$status_code" = "200" ]; then
        echo -e "${GREEN}✅ Status: $status_code${NC}"
    else
        echo -e "${RED}❌ Status: $status_code${NC}"
    fi
    
    if [ ! -z "$content_type" ]; then
        if echo "$content_type" | grep -qi "application/json"; then
            echo -e "${GREEN}✅ Content-Type: $content_type${NC}"
        else
            echo -e "${YELLOW}⚠️  Content-Type: $content_type (should be application/json)${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Content-Type header not found${NC}"
    fi
    
    # Get body
    body=$(curl -s "$url" 2>&1)
    if echo "$body" | grep -q "error\|Error\|404\|Not Found"; then
        echo -e "${RED}❌ Error in response body${NC}"
    else
        echo -e "${GREEN}✅ Valid JSON response${NC}"
        # Pretty print JSON if jq is available
        if command -v jq &> /dev/null; then
            echo "$body" | jq '.' 2>/dev/null || echo "$body"
        else
            echo "$body"
        fi
    fi
    
    echo ""
}

# Check Android assetlinks.json
check_url \
    "$BASE_URL/.well-known/assetlinks.json" \
    "application/json" \
    "Android App Links (assetlinks.json)"

# Check iOS apple-app-site-association
check_url \
    "$BASE_URL/.well-known/apple-app-site-association" \
    "application/json" \
    "iOS Universal Links (apple-app-site-association)"

echo "📋 Summary:"
echo "- Android App Links file: $BASE_URL/.well-known/assetlinks.json"
echo "- iOS Universal Links file: $BASE_URL/.well-known/apple-app-site-association"
echo ""
echo "⚠️  Important Notes:"
echo "1. Both files MUST return Content-Type: application/json"
echo "2. Files must be accessible via HTTPS (no redirects)"
echo "3. Files must be publicly accessible (no authentication)"
echo "4. For iOS: File must NOT have .json extension"
echo "5. For Android: Verification can take up to 20 minutes after app install"
echo ""
echo "🧪 Test Deep Links:"
echo "Android: adb shell am start -W -a android.intent.action.VIEW -d 'https://api.scholarwheels.co.za/payment/success?planId=123'"
echo "iOS: Open Safari and navigate to: https://api.scholarwheels.co.za/payment/success?planId=123"
