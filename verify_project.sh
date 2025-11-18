#!/bin/bash

# SquashG - Xcode Project Setup Script
# This script helps verify all files are present

echo "=========================================="
echo "SquashG Project File Verification"
echo "=========================================="
echo ""

PROJECT_DIR="/Users/laurentkleeringvanbeerenbergh/Development/squash-g-ios/squash-g-ios"

# Check if directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Error: Project directory not found!"
    exit 1
fi

cd "$PROJECT_DIR"

# Count Swift files
SWIFT_COUNT=$(find . -name "*.swift" -type f | wc -l | tr -d ' ')
echo "📊 Total Swift files: $SWIFT_COUNT"
echo ""

# Check each directory
directories=("Models" "ViewModels" "Views" "Components" "Services" "LiveActivities" "Theme" "Extensions")

for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -name "*.swift" -type f | wc -l | tr -d ' ')
        echo "✅ $dir: $count files"
    else
        echo "❌ $dir: MISSING"
    fi
done

echo ""
echo "=========================================="
echo "Next Steps:"
echo "=========================================="
echo ""
echo "The Xcode project is now open. To complete setup:"
echo ""
echo "1. In Xcode, look at the Project Navigator (left sidebar)"
echo "2. You should see all folders: Models, Views, ViewModels, etc."
echo "3. If folders appear as blue folders (references) instead of yellow folders (groups):"
echo "   a. Right-click on the 'squash-g-ios' group"
echo "   b. Select 'Add Files to squash-g-ios...'"
echo "   c. Navigate to the squash-g-ios folder"
echo "   d. Select all the source folders"
echo "   e. Make sure 'Create groups' is selected"
echo "   f. Make sure 'Copy items if needed' is UNCHECKED"
echo "   g. Click 'Add'"
echo ""
echo "4. Build the project (⌘+B)"
echo "5. Run on simulator or device (⌘+R)"
echo ""
echo "If you see compilation errors, the files may not be"
echo "added to the target. Right-click each folder and ensure"
echo "'Target Membership' includes 'squash-g-ios'."
echo ""
echo "=========================================="
