#!/usr/bin/env bash
# Template Pollution Test - ensures marge-simpson templates stay pristine
#
# This script lives in marge-simpson/system/scripts/ but is ONLY called from
# .meta_marge/ context via a trigger wrapper. Regular users don't run this.
#
# IMPORTANT: Always checks marge-simpson/ (source), not .meta_marge/.
#
# Usage: test-templates.sh [marge-root-path]

set -e

# Auto-detect marge root if not provided
if [[ -n "$1" ]]; then
    MARGE_ROOT="$1"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # Script is at marge-simpson/system/scripts/ - go up 2 levels
    MARGE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fi

# Verify we're checking the RIGHT folder (not .meta_marge)
FOLDER_NAME="$(basename "$MARGE_ROOT")"
if [[ "$FOLDER_NAME" == ".meta_marge" ]]; then
    echo "ERROR: Test is checking .meta_marge/ instead of marge-simpson/!"
    exit 1
fi

echo ""
echo "============================================================"
echo " Template Pollution Tests (Meta-Development Guard)"
echo " Checking: $MARGE_ROOT"
echo "============================================================"
echo ""

passed=0
failed=0

test_template_clean() {
    local file_path="$1"
    local pattern="$2"
    local description="$3"
    local full_path="$MARGE_ROOT/$file_path"
    
    if [[ ! -f "$full_path" ]]; then
        echo "  [SKIP] $description - file not found"
        return 0
    fi
    
    # Strip HTML comments to avoid false positives from template instructions
    local content_no_comments
    content_no_comments=$(perl -0777 -pe 's/<!--.*?-->//gs' "$full_path" 2>/dev/null || cat "$full_path")
    
    if echo "$content_no_comments" | grep -qE "$pattern" 2>/dev/null; then
        echo "  [FAIL] $description"
        echo "         Found prohibited pattern: $pattern"
        return 1
    fi
    echo "  [PASS] $description"
    return 0
}

echo "[1/4] Checking system/tracking/assessment.md..."
if test_template_clean "system/tracking/assessment.md" '### \[MS-[0-9]{4}\]' "No real MS-#### entries"; then
    ((passed++))
else
    ((failed++))
fi

# Check Next ID is still at MS-0001 (pristine template state)
if [[ -f "$MARGE_ROOT/system/tracking/assessment.md" ]]; then
    if grep -qE "Next ID:\*{0,2}.*MS-0001" "$MARGE_ROOT/system/tracking/assessment.md" 2>/dev/null; then
        echo "  [PASS] Pristine Next ID (MS-0001)"
        ((passed++))
    else
        echo "  [FAIL] Next ID incremented (should be MS-0001)"
        ((failed++))
    fi
fi

echo ""
echo "[2/4] Checking system/tracking/tasklist.md..."
if test_template_clean "system/tracking/tasklist.md" '- \[x\] \*\*MS-[0-9]{4}' "No completed MS-#### items"; then
    ((passed++))
else
    ((failed++))
fi

echo ""
echo "[3/4] Checking system/knowledge/decisions.md..."
if test_template_clean "system/knowledge/decisions.md" '### \[D-[0-9]{3}\]' "No real D-### entries"; then
    ((passed++))
else
    ((failed++))
fi

echo ""
echo "[4/4] Checking system/knowledge/ other files..."
if test_template_clean "system/knowledge/patterns.md" '### \[P-[0-9]{3}\]' "No real P-### entries"; then
    ((passed++))
else
    ((failed++))
fi

if test_template_clean "system/knowledge/insights.md" '### \[I-[0-9]{3}\]' "No real I-### entries"; then
    ((passed++))
else
    ((failed++))
fi

if test_template_clean "system/knowledge/preferences.md" '### \[PR-[0-9]{3}\]' "No real PR-### entries"; then
    ((passed++))
else
    ((failed++))
fi

echo ""
echo "============================================================"
echo " Summary: Passed=$passed Failed=$failed"
echo "============================================================"
echo ""

if [[ $failed -gt 0 ]]; then
    echo -e "\033[31mTEMPLATE POLLUTION DETECTED!\033[0m"
    echo "Template files in marge-simpson/ must remain pristine."
    echo "Users download this expecting clean templates."
    exit 1
fi
echo -e "\033[32mAll template pollution tests passed!\033[0m"
exit 0
