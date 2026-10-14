#!/usr/bin/env bash
# Black-box uptime check for navigator.dccap.org.
# Plain GET requests with no cookies, no headers beyond curl's defaults, and nothing that identifies a visitor.
# Exit 1 (the run fails and GitHub emails the repo owner) when a page is down.
set -u
BASE="https://navigator.dccap.org"
PATHS=("/" "/student/careers")
# The site stays behind a password until launch day (2026-10-15), so 401 counts
# as "up" until the end of that day in DC (04:00 UTC on 10-16). After that only 200 passes.
GATE_END=$(date -u -d "2026-10-16T04:00:00Z" +%s)
NOW=$(date -u +%s)
fail=0
for p in "${PATHS[@]}"; do
  for attempt in 1 2; do
    out=$(curl -s -o /dev/null -w "%{http_code} %{time_total}" --max-time 20 "$BASE$p")
    code=${out%% *}; secs=${out##* }
    if [ "$code" = "200" ] || { [ "$code" = "401" ] && [ "$NOW" -lt "$GATE_END" ]; }; then
      echo "UP   $p  http=$code  ${secs}s"; break
    fi
    if [ "$attempt" = "1" ]; then echo "retry $p  http=$code  ${secs}s"; sleep 30; else
      echo "DOWN $p  http=$code  ${secs}s"; fail=1; fi
  done
done
exit $fail
