#!/bin/bash
# Cursor CLI statusline (Claude Code layout).
# Rendered above the prompt; REPLACES the built-in footer, so this also
# restores the footer's right side (approval mode + vim mode).
# Killed at timeoutMs, so keep this fast (~200ms budget).
# Config lives at $XDG_CONFIG_HOME/cursor/cli-config.json when XDG_CONFIG_HOME
# is set (NOT ~/.cursor/cli-config.json).

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH:-}"

ESC=$'\033'
RESET="${ESC}[0m"
DIM="${ESC}[2m"
RED="${ESC}[31m"
GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"
MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m"
LIGHT_GRAY="${ESC}[37m"

input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // "?"')
params=$(printf '%s' "$input" | jq -r '.model.param_summary // empty')
version=$(printf '%s' "$input" | jq -r '.version // empty')
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // "."')
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
used_pct=$(printf '%s' "$input" | jq -r '(.context_window.used_percentage // 0 | floor)')
ctx_size=$(printf '%s' "$input" | jq -r '(.context_window.context_window_size // 0 | floor)')
vim_mode=$(printf '%s' "$input" | jq -r '.vim.mode // empty')
render_width=$(printf '%s' "$input" | jq -r '(.render_width_chars // 0 | floor)')
# NB: Cursor's payload has no cost/usage-billing fields, so no money segment.

[[ "$used_pct" =~ ^[0-9]+$ ]] || used_pct=0
[[ "$ctx_size" =~ ^[0-9]+$ ]] || ctx_size=0
[[ "$render_width" =~ ^[0-9]+$ ]] || render_width=0

# Skip param summary already contained in the display name (e.g. "Kimi K3 Max" + "Max")
if [[ -n "$params" && "$model" != *"$params"* ]]; then
	model="${model} ${params}"
fi
if [[ "$ctx_size" -gt 0 && "$model" != *context* ]]; then
	if [[ "$ctx_size" -ge 1000000 ]]; then
		model="${model} ($((ctx_size / 1000000))M context)"
	elif [[ "$ctx_size" -ge 1000 ]]; then
		model="${model} ($((ctx_size / 1000))k context)"
	fi
fi

if [[ "$used_pct" -ge 75 ]]; then
	CONTEXT_COLOR="$RED"
elif [[ "$used_pct" -ge 50 ]]; then
	CONTEXT_COLOR="$YELLOW"
else
	CONTEXT_COLOR="$CYAN"
fi

# Git: branch + dirty dot + diff stats vs HEAD (~30ms here; head -1 SIGPIPE-caps status)
git_info=""
added=0
removed=0
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
	[[ -n "$branch" ]] || branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
	if [[ -n "$branch" ]]; then
		git_info=" ${branch}"
		if git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null | head -1 | grep -q .; then
			git_info="${git_info} ●"
		fi
	fi
	stats=$(git -C "$cwd" --no-optional-locks diff --numstat HEAD 2>/dev/null |
		awk '{a+=$1; d+=$2} END {printf "%d %d", a, d}')
	[[ "$stats" =~ ^[0-9]+\ [0-9]+$ ]] && read -r added removed <<<"$stats"
fi

last_prompt=""
if [[ -n "$transcript" && -f "$transcript" ]]; then
	last_prompt=$(jq -r '
		select(.role == "user")
		| .message.content
		| if type == "array" then
			[.[] | select(.type == "text") | .text] | join(" ")
		  elif type == "string" then .
		  else empty end
		| select(length > 0)
		| (capture("(?s)<user_query>\\s*(?<q>.*?)\\s*</user_query>") | .q) // .
		| gsub("\n"; " ")
		| gsub("\\s+"; " ")
	' "$transcript" 2>/dev/null | tail -n 1 | cut -c1-80)
	[[ ${#last_prompt} -eq 80 ]] && last_prompt="${last_prompt}..."
fi

# --- line 1, left side ---
line1=""
[[ -n "$git_info" ]] && line1="${GREEN}🌿${git_info}${RESET} ${DIM}│${RESET} "
line1="${line1}${MAGENTA}🤖 ${model}${RESET}"
line1="${line1} ${DIM}│${RESET} ${CONTEXT_COLOR}🧠 ${used_pct}%${RESET}"
[[ -n "$version" ]] && line1="${line1} ${DIM}│${RESET} ${LIGHT_GRAY}📦 v${version}${RESET}"
line1="${line1} ${DIM}│${RESET} 📝 ${GREEN}+${added}${RESET}${DIM}/${RESET}${RED}-${removed}${RESET}"

# --- line 1, right side: approval mode + vim mode (the superseded footer's right) ---
cfg_dir="${CURSOR_CONFIG_DIR:-}"
[[ -z "$cfg_dir" && -n "${XDG_CONFIG_HOME:-}" ]] && cfg_dir="${XDG_CONFIG_HOME}/cursor"
[[ -z "$cfg_dir" ]] && cfg_dir="${HOME}/.cursor"
approval=$(jq -r '.approvalMode // empty' "${cfg_dir}/cli-config.json" 2>/dev/null)
case "$approval" in
auto-review) approval_label="Auto-review" ;;
allowlist) approval_label="Allowlist" ;;
unrestricted) approval_label="Unrestricted" ;;
"") approval_label="" ;;
*) approval_label="${approval^}" ;;
esac
right=""
[[ -n "$approval_label" ]] && right="$approval_label"
if [[ -n "$vim_mode" ]]; then
	if [[ -n "$right" ]]; then
		right="${right} -- ${vim_mode} --"
	else
		right="-- ${vim_mode} --"
	fi
fi

if [[ -n "$right" ]]; then
	padded=""
	if [[ "$render_width" -gt 0 ]] && command -v python3 >/dev/null 2>&1; then
		plain=$(printf '%s' "$line1" | sed "s/${ESC}\[[0-9;]*m//g")
		widths=$(python3 -c '
import sys, unicodedata
def w(s): return sum(2 if unicodedata.east_asian_width(c) in ("W", "F") else 1 for c in s)
print(w(sys.argv[1]), w(sys.argv[2]))' "$plain" "$right" 2>/dev/null)
		if [[ "$widths" =~ ^([0-9]+)\ ([0-9]+)$ ]]; then
			pad=$((render_width - BASH_REMATCH[1] - BASH_REMATCH[2]))
			if [[ "$pad" -gt 1 ]]; then
				printf -v spaces '%*s' "$pad" ''
				padded="${spaces}"
			fi
		fi
	fi
	if [[ -n "$padded" ]]; then
		line1="${line1}${padded}${LIGHT_GRAY}${right}${RESET}"
	else
		line1="${line1}  ${LIGHT_GRAY}${right}${RESET}"
	fi
fi

printf '%s' "$line1"

if [[ -n "$last_prompt" ]]; then
	printf '\n%s💬 %s%s' "$LIGHT_GRAY" "$last_prompt" "$RESET"
fi
printf '\n'
exit 0
