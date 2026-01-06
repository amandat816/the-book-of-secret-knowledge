#!/bin/bash
#
# Link checker script for The Book of Secret Knowledge
# This script checks all links in README.md and reports broken ones
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "  Link Checker for The Book of Secret Knowledge"
echo "================================================"
echo ""

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: curl is not installed${NC}"
    echo "Please install curl to run this script"
    exit 1
fi

# Check if README.md exists
if [ ! -f "README.md" ]; then
    echo -e "${RED}Error: README.md not found${NC}"
    echo "Please run this script from the repository root"
    exit 1
fi

# Configuration
DELAY="${LINK_CHECK_DELAY:-1}"  # Delay between requests (seconds)
TIMEOUT="${LINK_CHECK_TIMEOUT:-10}"  # Request timeout (seconds)

echo "Configuration:"
echo "  - Delay between requests: ${DELAY}s"
echo "  - Request timeout: ${TIMEOUT}s"
echo ""
echo "Extracting links from README.md..."

# Extract all HTTP(S) links from README.md
LINKS=$(sed -n 's/.*href="\([^"]*\).*/\1/p' README.md | grep -v "^#" | sort -u)
TOTAL=$(echo "$LINKS" | wc -l)

echo "Found $TOTAL unique links to check"
echo ""
echo "Checking links (this may take a while)..."
echo ""

CHECKED=0
FAILED=0
declare -a FAILED_LINKS

# Check each link
while IFS= read -r link; do
    CHECKED=$((CHECKED + 1))
    
    # Show progress
    echo -ne "Progress: $CHECKED/$TOTAL\r"
    
    # Make request and get HTTP status code
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time "$TIMEOUT" "$link" 2>/dev/null || echo "000")
    
    # Check if request was successful (2xx or 3xx status codes)
    if [[ ! "$HTTP_CODE" =~ ^[23] ]]; then
        FAILED=$((FAILED + 1))
        FAILED_LINKS+=("$link - HTTP $HTTP_CODE")
    fi
    
    # Delay between requests to avoid rate limiting
    if [ "$DELAY" -gt 0 ]; then
        sleep "$DELAY"
    fi
done <<< "$LINKS"

echo ""
echo ""
echo "================================================"
echo "  Results"
echo "================================================"
echo ""
echo "Total links checked: $TOTAL"
echo -e "Successful: ${GREEN}$((TOTAL - FAILED))${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -gt 0 ]; then
    echo "Failed links:"
    echo ""
    for failed_link in "${FAILED_LINKS[@]}"; do
        echo -e "  ${RED}✗${NC} $failed_link"
    done
    echo ""
    echo -e "${YELLOW}Note: Some links may be temporarily unavailable or behind rate limiting.${NC}"
    echo -e "${YELLOW}Links marked with * in README.md are known to be temporarily unavailable.${NC}"
    echo ""
    exit 1
else
    echo -e "${GREEN}✓ All links are working!${NC}"
    echo ""
    exit 0
fi
