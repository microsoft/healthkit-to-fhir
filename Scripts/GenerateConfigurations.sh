#!/bin/bash

CONFIG_JSON_PATH="$1"
TEMPLATE_PATH="$2"
CONFIGURATION_CLASS_PATH="$3"

if [ ! -e "${CONFIG_JSON_PATH}" ]
then
echo "The the config json is missing."
exit 1
fi

if [ ! -e "${TEMPLATE_PATH}" ]
then
echo "The the template is missing."
exit 1
fi

if [ -z "${CONFIGURATION_CLASS_PATH}" ]
then
echo "The path to the Configurations class is missing."
exit 1
fi

# Read the pretty printed json file.
JSON=$(<${CONFIG_JSON_PATH})

# Strip out any whitespace characters (not spaces).
JSON="$( echo "$JSON" | tr -d '\011\012\015')"

# Escape double quotes.
JSON=${JSON//\"/\\\"}

# Read the template file.
TEMPLATE=$(<${TEMPLATE_PATH})

# Set the json value in the template.
TEMPLATE=${TEMPLATE//DEFAULT_CONFIG/$JSON}

# Save the template.
echo "$TEMPLATE" > "$CONFIGURATION_CLASS_PATH"

exit 0
