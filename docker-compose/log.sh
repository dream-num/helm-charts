#!/bin/bash

DOCKER_COMPOSE="docker compose"
$DOCKER_COMPOSE version &>/dev/null
if [ $? -ne 0 ]; then
    DOCKER_COMPOSE="docker-compose"
    $DOCKER_COMPOSE version &>/dev/null
    if [ $? -ne 0 ]; then
        echo "need docker compose."
        exit 1
    fi
fi

minutes=1
time_period="$minutes minutes"
hours=6
log_dir="cat-logs"
server="all"
trace_id=""

mkdir -p $log_dir

export TZ=UTC

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

function _stdin {
    # default values are already set; allow user to override
    # read -p "Enter minutes period (integer, default: $minutes): " input_minutes
    # if [[ -n "$input_minutes" && "$input_minutes" =~ ^[0-9]+$  ]]; then
    #     minutes="$input_minutes"
    #     time_period="$minutes minutes"
    # fi

    read -p "$(echo -e "${GREEN}Enter hours to search back (integer, default $hours): ${NC}")" input_hours
    if [[ -n "$input_hours" && "$input_hours" =~ ^[0-9]+$ ]]; then
        hours="$input_hours"
    fi

    read -p "$(echo -e "${GREEN}Enter trace-id to search back (string, optional): ${NC}")" input_trace_id
    if [[ -n "$input_trace_id" ]]; then
        trace_id="$input_trace_id"
    fi

    echo
    echo -e "${BLUE}Select server to cat logs:${NC}"
    server_options=("all" "collaboration-server" "universer" "exchange" "univer-ssc")
    PS3="$(echo -e "${GREEN}Choose server (number): ${NC}")"
    select opt in "${server_options[@]}"; do
        if [[ -z "$opt" ]]; then
            break
        fi
        server="$opt"
        break
    done

    echo "Using time_period='$time_period', hours=$hours, server='$server'"
}


function log_collaboration_server_loop {
    loop_error_log_file="$log_dir/collaboration-server-loop-error.log"
    
    echo "======================================"
    echo "🛠️  Start recording Collaboration Server Loop Error logs..."
    echo "======================================"

    end_time=$(date +"%Y-%m-%dT%H:%M:%S")

    for i in $(seq 0 $hours); do
        start_time=$(date -d "$i hours ago" +"%Y-%m-%dT%H:%M:%S")
        next_time=$(date -d "$((i+1)) hours ago" +"%Y-%m-%dT%H:%M:%S")
        
        echo "Checking: $next_time to $start_time (UTC)"
        log_output=$($DOCKER_COMPOSE logs --since "$next_time" --until "$start_time" -t collaboration-server 2>&1 | grep -m 1 "\[Error\] _logOriginTransform")
        # log_output="collaboration-server-2  | 2025-11-12T08:04:01.858705793Z [Nest] 18  - 11/05/2025, 3:04:01 AM   DEBUG [ClsModule] ClsGuard will be automatically mounted, throw error;"

        if echo "$log_output" | grep -q "\[Error\] _logOriginTransform"; then
            echo "✅ Found error log!"
            echo "======================================"
            
            # Use awk to precisely parse container info
            echo "$log_output" | awk '
            function extract_container(line) {
                # Match logs format: container  | log message
                if (match(line, /^([a-zA-Z0-9_.-]+)[[:space:]]+\|[[:space:]]/)) {
                    container = substr(line, RSTART, RLENGTH-1)
                    gsub(/[[:space:]]+$/, "", container)  # Remove trailing spaces
                    return container
                }
                else {
                    return "unknown-container"
                }
            }
            
            function extract_timestamp(line) {
                # Match ISO timestamp format: 2025-11-05T03:04:01.858705793Z
                if (match(line, /[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}/)) {
                    return substr(line, RSTART, RLENGTH)
                }
                else {
                    return ""
                }
            }

            /_logOriginTransform/ {
                container = extract_container($0)
                timestamp = extract_timestamp($0)
                
                # Output format: container timestamp
                print container timestamp
            }' | while IFS='|' read -r container timestamp; do
                echo "🟥 Container: $container"
                echo "⏰ Time: $timestamp"
                echo "--------------------------------------"
                
                # If timestamp is valid, fetch full logs 1 minute around the error
                if [[ -n "$timestamp" && "$timestamp" != "null" ]]; then
                    echo "🔍 Fetch full logs ${time_period} around the error time..."
                    
                    # Calculate time range (1 minute before and after error)
                    error_time=$timestamp
                    if [[ $? -eq 0 ]]; then
                        log_start=$(date -d "$error_time $time_period ago" +"%Y-%m-%dT%H:%M:%SZ")
                        log_end=$(date -d "$error_time $time_period" +"%Y-%m-%dT%H:%M:%SZ")
                        
                        echo "📅 Log time range: $log_start to $log_end"
                        echo "--------------------------------------"
                        
                        # Get full logs for that container
                        $DOCKER_COMPOSE logs -t --since "$log_start" --until "$log_end" collaboration-server 2>&1 | grep "$container" > $loop_error_log_file
                        sed -i '/_logCurrent/{n;d;}' $loop_error_log_file
                        sed -i '/_logCurrent/d' $loop_error_log_file
                        echo "--------------------------------------"
                        echo "📄 Full log file: $loop_error_log_file"

                        return 0
                    else
                        echo "❌ Failed to parse time format"
                        return 1
                    fi
                else
                    echo "❌ No valid timestamp extracted"
                    return 1
                fi
                
                echo "======================================"
            done

            return 1
        fi
    done
}


function log_collaboration_server_throw {
    throw_error_log_file="$log_dir/throw-error.log"
    
    echo "======================================"
    echo "🛠️  Start recording Collaboration Server Throw Error logs..."
    echo "======================================"

    
    end_time=$(date +"%Y-%m-%dT%H:%M:%S")

    for i in $(seq 0 $hours); do
        start_time=$(date -d "$i hours ago" +"%Y-%m-%dT%H:%M:%S")
        next_time=$(date -d "$((i+1)) hours ago" +"%Y-%m-%dT%H:%M:%S")
        
        echo "Checking: $next_time to $start_time (UTC)"
        log_output=$($DOCKER_COMPOSE logs --since "$next_time" --until "$start_time" -t collaboration-server 2>&1 | grep -m 1 "throw error;")
        # log_output=$(echo 'collaboration-server-2  | 2025-11-12T08:20:01.858705793Z [Nest] 18  - 11/05/2025, 3:04:01 AM   DEBUG [ClsModule] ClsGuard will be automatically mounted, throw error;' | grep "throw error;")

        if echo "$log_output" | grep -q "throw error;"; then
            echo "✅ Found error log!"
            echo "======================================"
            
            # Use awk to precisely parse container info
            echo "$log_output" | awk '
            function extract_container(line) {
                # Match logs format: container  | log message
                if (match(line, /^([a-zA-Z0-9_.-]+)[[:space:]]+\|[[:space:]]/)) {
                    container = substr(line, RSTART, RLENGTH-1)
                    gsub(/[[:space:]]+$/, "", container)  # Remove trailing spaces
                    return container
                }
                else {
                    return "unknown-container"
                }
            }
            
            function extract_timestamp(line) {
                # Match ISO timestamp format: 2025-11-05T03:04:01.858705793Z
                if (match(line, /[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}/)) {
                    return substr(line, RSTART, RLENGTH)
                }
                else {
                    return ""
                }
            }

            /throw error;/ {
                container = extract_container($0)
                timestamp = extract_timestamp($0)
                
                # Output format: container timestamp
                print container timestamp
            }' | while IFS='|' read -r container timestamp; do
                echo "🟥 Container: $container"
                echo "⏰ Time: $timestamp"
                echo "--------------------------------------"
                
                # If timestamp is valid, fetch full logs 1 minute around the error
                if [[ -n "$timestamp" && "$timestamp" != "null" ]]; then
                    echo "🔍 Fetch full logs ${time_period} around the error time..."
                    
                    # Calculate time range (1 minute before and after error)
                    error_time=$timestamp
                    if [[ $? -eq 0 ]]; then
                        log_start=$(date -d "$error_time $time_period ago" +"%Y-%m-%dT%H:%M:%SZ")
                        log_end=$(date -d "$error_time $time_period" +"%Y-%m-%dT%H:%M:%SZ")
                        
                        echo "📅 Log time range: $log_start to $log_end"
                        echo "--------------------------------------"
                        
                        # Get full logs for that container
                        $DOCKER_COMPOSE logs -t --since "$log_start" --until "$log_end" collaboration-server 2>&1 | grep "$container" > $throw_error_log_file
                        echo "--------------------------------------"
                        echo "📄 Full log file: $throw_error_log_file"

                        return 0
                    else
                        echo "❌ Failed to parse time format"
                        return 1
                    fi
                else
                    echo "❌ No valid timestamp extracted"
                    return 1
                fi
                
                echo "======================================"
            done

            return 1
        fi
    done
}


function log_collaboration_server_error {
    error_log_file="$log_dir/collaboration-server-error.log"

    _m=$((hours * 60))

    echo "======================================"
    echo "🛠️  Start recording Collaboration Server Error logs..."
    echo "======================================"

    if [[ -n "$trace_id" ]]; then
        $DOCKER_COMPOSE logs -t --since "$_m" collaboration-server 2>&1 | grep "$trace_id" > $error_log_file
    else
        $DOCKER_COMPOSE logs -t --since "$_m" collaboration-server 2>&1 | grep "\[Error\]" > $error_log_file
    fi

    echo "📄 Full log file: $error_log_file"
}


function log_universer_error {
    error_log_file="$log_dir/universer-error.log"

    _m=$((hours * 60))

    echo "======================================"
    echo "🛠️  Start recording Universer Error logs..."
    echo "======================================"

    if [[ -n "$trace_id" ]]; then
        $DOCKER_COMPOSE logs -t --since "$_m" universer 2>&1 | grep "$trace_id" > $error_log_file
    else
        $DOCKER_COMPOSE logs -t --since "$_m" universer 2>&1 | grep "ERROR" > $error_log_file
    fi

    echo "📄 Full log file: $error_log_file"
}


function log_exchange_error {
    error_log_file="$log_dir/exchange-error.log"

    _m=$((hours * 60))

    echo "======================================"
    echo "🛠️  Start recording Exchange Error logs..."
    echo "======================================"

    if [[ -n "$trace_id" ]]; then
        $DOCKER_COMPOSE logs -t --since "$_m" univer-worker-exchange 2>&1 | grep "$trace_id" | grep -v "too_many_pings" > $error_log_file
    else
        $DOCKER_COMPOSE logs -t --since "$_m" univer-worker-exchange 2>&1 | grep "ERROR" | grep -v "too_many_pings" > $error_log_file
    fi

    echo "📄 Full log file: $error_log_file"

    return 0
}


function log_univer_ssc_error {
    error_log_file="$log_dir/univer-ssc-error.log"

    _m=$((hours * 60))

    echo "======================================"
    echo "🛠️  Start recording Universer SSC Error logs..."
    echo "======================================"

    if [[ -n "$trace_id" ]]; then
        $DOCKER_COMPOSE logs -t --since "$_m" ssc-server 2>&1 | grep "$trace_id" > $error_log_file
    else
        $DOCKER_COMPOSE logs -t --since "$_m" ssc-server 2>&1 | grep "\[Error\]" > $error_log_file
    fi

    echo "📄 Full log file: $error_log_file"

    return 0
}


function main {
    # Prompt user for inputs before running searches
    _stdin

    echo

    if [[ $server == "all" || $server == "collaboration-server" ]]; then
        if log_collaboration_server_loop; then
            echo "✅ Recorded collaboration-server the latest loop error log"
        else
            echo "✗ No collaboration-server loop error logs found in the last $hours hours"
        fi

        echo

        if log_collaboration_server_throw; then
            echo "✅ Recorded collaboration-server the latest throw error log"
        else
            echo "✗ No collaboration-server throw error logs found in the last $hours hours"
        fi

        echo


        if log_collaboration_server_error; then
            echo "✅ Recorded collaboration-server error log"
        else
            echo "✗ No collaboration-server error logs found in the last $hours hours"
        fi
    fi

    echo

    if [[ $server == "all" || $server == "universer" ]]; then
        if log_universer_error; then
            echo "✅ Recorded universer error log"
        else
            echo "✗ No universer error logs found in the last $hours hours"
        fi
    fi

    echo

    if [[ $server == "all" || $server == "exchange" ]]; then
        if log_exchange_error; then
            echo "✅ Recorded exchange error log"
        else
            echo "✗ No exchange error logs found in the last $hours hours"
        fi
    fi

    echo

    if [[ $server == "all" || $server == "univer-ssc" ]]; then
        if log_univer_ssc_error; then
            echo "✅ Recorded univer-ssc error log"
        else
            echo "✗ No univer-ssc error logs found in the last $hours hours"
        fi
    fi
}


main
