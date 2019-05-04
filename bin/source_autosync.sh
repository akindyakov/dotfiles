#!/usr/bin/env bash

set -e -x

SOURCE="${HOME}/source"

git_make_temporary_commit() {
  local branch="$(git branch --quiet --color=never | grep '^* ' | sed -e 's/* //g')"
  if [[ -z ${branch} ]]
    then
      echo "Could not find current branch" >&2
      exit 1
    fi

  if [[ ${branch} == "master" ]]
    then
      # temp commit in master is a bad idea
      local tmp_branch="temp_$(openssl rand -hex 4)"
      git checkout -b ${tmp_branch}
    fi
  git add .
  git commit -m "temp: Auto commit from the host: $(hostname)"
}

git_sync_all_braches() {
  local remote="${1}"
  git branch \
    | sed -e 's/* //g' \
    | while read branch
      do
        git push ${remote} ${branch}
      done
}

git_sync_origin() {
  local repo_name="${1}"
  local status="$(git status --short)"
  echo "Status: \"${status}\""
  if [[ -n "${status}" ]]
    then
      git_make_temporary_commit
    fi

  git fetch
  git remote \
    | while read remote;
      do
        if [[ "${remote}" != "origin" && "${remote}" != "upstream" ]]
          then
            git_sync_all_braches "${remote}"
          fi
      done
}

sync_repo() {
  local repo_name="${1}"
  echo "Sync repo: ${repo_name}"
  if [[ -d ".git" ]]
    then
      git_sync_origin "${repo_name}"
    fi
}

ls "${SOURCE}" \
  | while read name
    do
      if [[ -d "${SOURCE}/${name}" ]]
        then
          cd "${SOURCE}/${name}"
          sync_repo "${name}"
          cd "${OLDPWD}"
        fi
    done
