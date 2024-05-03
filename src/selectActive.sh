#!/bin/bash
script_dir=$(dirname "$0")
git fetch origin

IFS=' ' read -ra ACTIVE_BRANCHES <<< $("$script_dir"/getActiveBranches.sh)
AUTHORS=()
MESSAGES=()

# Iterate over each branch in the array
for branch in "${ACTIVE_BRANCHES[@]}"; do
    # Perform operations on each branch
    AUTHORS+=("$(git log -1 --pretty=format:'%an' $branch)")
    MESSAGES+=("$(git log -1 --pretty=format:'%s' $branch)")
done

printf "\e[38;2;44;78;128m%-25s %-40s %-60s\n\e[0m" "User" "Branch" "Message"
for ((i=0; i<${#ACTIVE_BRANCHES[@]}; i++)); do
    if (( i % 2 == 0 )); then
        # Color FC4100
        printf "\e[38;2;252;65;0m%-25s %-40s %-60s\n\e[0m" "${AUTHORS[$i]}" "${ACTIVE_BRANCHES[$i]}" "${MESSAGES[$i]}"
    else
        # Color FFC55A
        printf "\e[38;2;255;197;90m%-25s %-40s %-60s\n\e[0m" "${AUTHORS[$i]}" "${ACTIVE_BRANCHES[$i]}" "${MESSAGES[$i]}"
    fi
done
printf "%s\n" "----------------------------------------"

echo "Select branch:"
IFS=","; BRANCH_CSV="${ACTIVE_BRANCHES[*]}"; unset IFS
if SELECTED_BRANCH=$("$script_dir"/selectFromList.sh "$BRANCH_CSV" | sed 's/origin\///'); then

read -p "Checkout $SELECTED_BRANCH? (Y/n): " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    git checkout -b "$SELECTED_BRANCH" --track origin/"$SELECTED_BRANCH" || git checkout "$SELECTED_BRANCH"
    exit 0
else
    echo "Exiting..."
    exit 1
fi

    exit 1
fi

