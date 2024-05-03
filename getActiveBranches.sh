#!/bin/bash

# Get all local branches
ALL_BRANCHES=$(git for-each-ref --format='%(refname:short)' refs/heads)


# Get all remote branches
REMOTE_BRANCHES=$(git for-each-ref --format='%(refname:short)' refs/remotes)
MERGED_BRANCHES=$(git branch --merged main)



# Initialize an empty string to hold the list of untracked remote branches

# Iterate over each remote branch
for remote_branch in $REMOTE_BRANCHES; do
    # Check if the remote branch exists in the local branches
    if [[ $ALL_BRANCHES != *"${remote_branch#*/}"* ]]; then
        # If it does not exist, add the remote branch to the list
        ALL_BRANCHES+=" $remote_branch"
    fi
done



FILTERED_BRANCHES=""
for branch in $ALL_BRANCHES; do
    # remove branches that are merged into main and remove main
    if [[ "$branch" == "main" || "$MERGED_BRANCHES" == *"$branch"* ]]; then
        continue
    fi
    FILTERED_BRANCHES+="$branch "
done




ACTIVE_BRANCHES=""
for branch in $FILTERED_BRANCHES; do
    # remove branches where last commit is older than a week
    last_commit_date=$(git log -1 --format=%ct "$branch")
    current_date=$(date +%s)
    diff_seconds=$((current_date - last_commit_date))
    if [ $diff_seconds -le 604800 ]; then
        ACTIVE_BRANCHES+="$branch "
    fi
done


echo -e "$ACTIVE_BRANCHES" | rev | cut -c 1- | rev
