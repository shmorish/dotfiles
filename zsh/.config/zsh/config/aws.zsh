#!/bin/zsh

# AWS CLI
alias aws='aws --color=auto'

# AWS CLI MFA Login
# 前提条件:
# ~/.aws/config に mfa_serial が設定されていること
# ~/.aws/credentials に aws_access_key_id と aws_secret_access_key が設定されていること
function aws_login_mfa() {
    local profile_name
    local profiles
    profiles=$(grep '^\[' ~/.aws/config 2>/dev/null | sed 's/^\[profile //;s/^\[//;s/\]$//' | grep -v '^default$')
    if [[ -n "$profiles" ]] && command -v fzf &>/dev/null; then
        profile_name=$(echo "$profiles" | fzf --prompt="Select AWS profile: " --height=40% --reverse)
    else
        printf 'Enter AWS profile name: ' >/dev/tty
        read -r profile_name </dev/tty
    fi
    if [[ -z "$profile_name" ]]; then
        echo "Profile name cannot be empty." >&2
        return 1
    fi
    local mfa_serial
    mfa_serial=$(aws configure get "profile.${profile_name}.mfa_serial")
    if [[ -z "$mfa_serial" ]]; then
        echo "MFA serial not found for profile '${profile_name}'." >&2
        echo "Please ensure the profile exists and has an mfa_serial configured." >&2
        return 1
    fi
    local one_time_password
    printf 'Enter MFA one-time password (%s): ' "$profile_name" >/dev/tty
    read -r one_time_password </dev/tty
    if [[ -z "$one_time_password" ]]; then
        echo "One-time password cannot be empty." >&2
        return 1
    fi
    local session_token_file=".aws_session_token.json"
    aws sts get-session-token --profile "$profile_name" --serial-number "$mfa_serial" --token-code "$one_time_password" > "$session_token_file"
    if [[ $? -ne 0 ]]; then
        echo "Failed to get session token. Please check your profile and MFA settings." >&2
        return 1
    fi
    export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' "$session_token_file")
    export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' "$session_token_file")
    export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' "$session_token_file")
    rm -f "$session_token_file"
    echo '---------------------------------------'
    aws sts get-caller-identity --profile "$profile_name"
    if [[ $? -ne 0 ]]; then
        echo "Failed to get caller identity. Please check your session token." >&2
        return 1
    else
        echo "Successfully logged in to AWS with profile '${profile_name}'." >&2
    fi
    echo '---------------------------------------'
    export AWS_PROFILE="$profile_name"
}

function aws_logout_mfa() {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_PROFILE
    echo "Logged out from AWS CLI MFA session."
}
