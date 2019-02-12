#!/bin/bash

# Set settings for tests
SETTINGS="../hooks/_user_defined_settings.sh"
if [ -f ${SETTINGS} ]; then
    mv $SETTINGS "${SETTINGS}.save"
fi

cat << EOF > ${SETTINGS}
### For tests ###
INTERACTIVE_MODE="disabled"
FORCE_WARNING_TO_ERROR="enabled"
#################
EOF

# Run tests
for file in *.bats; do
    echo "Run tests for $file" | cut -d'.' -f1
    bats $file
    echo ''
done

# Restore user settings
rm $SETTINGS

if [ -f "${SETTINGS}.save" ]; then
    mv  "${SETTINGS}.save" $SETTINGS
fi
