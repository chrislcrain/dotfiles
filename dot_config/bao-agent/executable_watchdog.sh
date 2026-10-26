#!/bin/bash
# Restart the bao agent when its token is dead. Run every 5 minutes by
# launchd (Library/LaunchAgents/dev.cc-live.bao-agent-watchdog.plist).
#
# Why: the agent renews its 24h token on a timer that does not advance while
# the Mac sleeps, so on a laptop the token can reach its 24h TTL before the
# first renewal fires. The agent then retries template reads into "permission
# denied" for minutes before exiting and being relaunched (seen daily,
# 2026-10-23..25). This catches that and restarts it at once.
#
# Restarts ONLY on a 403 from bao, never on a network error: bao is
# tailnet-only, and restarting into an unreachable server is the thrash
# agent.hcl's template_config exists to avoid.

set -uo pipefail

ADDR="https://bao.tail5d7bcc.ts.net"
LABEL="dev.cc-live.bao-agent"
TOKEN_FILE="$HOME/.vault-token"
GRACE_SECONDS=120

log() { echo "$(date '+%Y-%m-%dT%H:%M:%S%z') $*"; }

# A token written in the last two minutes belongs to an agent that has just
# authenticated; give it time rather than restarting it mid-start.
if [[ -f "$TOKEN_FILE" ]]; then
  age=$(( $(date +%s) - $(stat -f %m "$TOKEN_FILE") ))
  (( age < GRACE_SECONDS )) && exit 0
fi

out=$(/opt/homebrew/bin/bao token lookup -address="$ADDR" -format=json 2>&1)
rc=$?
(( rc == 0 )) && exit 0

if grep -q "Code: 403" <<<"$out"; then
  log "token rejected (403); restarting $LABEL"
  launchctl kickstart -k "gui/$(id -u)/$LABEL"
fi
# Anything else (offline, DNS, bao down) is not the agent's fault: leave it.
exit 0
