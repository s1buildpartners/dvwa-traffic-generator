#!/bin/bash

# make sure DVWA_BASE_URL is set
if [ -z "$DVWA_BASE_URL" ]; then
    echo "Error: DVWA_BASE_URL environment variable is not set."
    echo
    echo "Usage: docker run -e DVWA_BASE_URL=http://dvwa:80 dvwa-traffic-generator"
    exit 1
fi

# configuration settings
USER_AGENT="${USER_AGENT:-"DVWATrafficGenerator/1.0"}"
INTERVAL=${INTERVAL:-60}

# list of DVWA paths to hit
PATHS=(
    "/"
    "/vulnerabilities/brute/"
    "/vulnerabilities/exec/"
    "/vulnerabilities/fi/?page=include.php"
    "/vulnerabilities/fi/?page=file1.php"
    "/vulnerabilities/fi/?page=file2.php"
    "/vulnerabilities/fi/?page=file3.php"
    "/vulnerabilities/upload/"
    "/vulnerabilities/captcha/"
    "/vulnerabilities/sqli/"
    "/vulnerabilities/sqli_blind/"
    "/vulnerabilities/weak_id/"
    "/vulnerabilities/xss_r/"
    "/vulnerabilities/xss_r/?name=TM-test#"
    "/vulnerabilities/xss_r/?name=JohnDoe#"
    "/vulnerabilities/xss_s/"
    "/vulnerabilities/javascript/"
    "/security.php"
    "/phpinfo.php"
    "/about.php"
    "/404Test"
)

echo "--- Traffic Generator Started ---"
echo
echo "Start Time:  $(date "+%Y-%m-%d %H:%M:%S")"
echo
echo "Press [CTRL+C] to stop manually."
echo "---------------------------------"

# Trap CTRL+C (SIGINT) to exit gracefully
trap "echo -e '\nScript stopped by user.'; exit 0" SIGINT

# Main Loop
while [ true ]; do
    echo "Starting batch at $(date)"

    # Loop through paths
    for path in "${PATHS[@]}"; do
        FULL_URL="${DVWA_BASE_URL}${path}"
        
        # Send request silently, follow redirects, use custom UA
        # Only output status code to keep logs clean
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -L -A "$USER_AGENT" "$FULL_URL")
        
        echo "Hit: $path [Status: $HTTP_CODE]"
        
        # Small delay between individual requests to be polite (optional)
        sleep 1 
    done

    echo "Batch complete. Sleeping for $INTERVAL seconds..."
    sleep $INTERVAL
done

echo "Exiting."
