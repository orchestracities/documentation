#
# Grab the date of the latest commit in a given remote git repo dir.
#
# Params:
# - $1: repo URL, e.g. https://github.com/orchestractities/documentation.
# - $2: git tag to checkout, e.g. 'v1.0.0'.
# - $3: target dir from where to get the latest commit date, e.g. docs.
#
# Return:
# - The committer date of the most recent commit in $3. E.g.
#   'Thu Aug 8 15:10:36 2024 +0200'
#
function commit_date_from_remote() {
    local repo_url=$1
    local tag=$2
    local commit_dir=$3
    local tmp_dir='__tmp__'

    pushd .
    mkdir "${tmp_dir}" && cd "${tmp_dir}"

    git clone --depth=1 --branch "${tag}" "${repo_url}" .
    commit_date=$(git log -n 1 --pretty=format:%cd "${commit_dir}")

    popd
    rm -rf "${tmp_dir}"

    echo ${commit_date}
}

#
# Grab the date of the latest commit in a given dir within the local
# git repo this command runs from.
#
# Params:
# - $1: target dir from where to get the latest commit date, e.g. docs.
#
# Return:
# - The committer date of the most recent commit in $1. E.g.
#   'Thu Aug 8 15:10:36 2024 +0200'
#
function commit_date() {
    local commit_dir=$1
    commit_date=$(git log -n 1 --pretty=format:%cd "${commit_dir}")
    echo ${commit_date}
}

#
# Cut a release.
# IMPORTANT: You must run this command from the repo root dir!
#
# This command does the following:
# 1. Update the first line of `docs/index.md` with the date of
#    the latest commit in the `docs` dir.
# 2. Commit the change and tag with the specified version.
# 3. Push the commit and the tag to remote.
#
# Params
# - $1: major version number, e.g. 1.
# - $2: minor version number, e.g. 0.
# - $1: patch version number, e.g. 1.
#
function release() {
    local major=$1
    local minor=$2
    local patch=$3

    local version="v${major}.${minor}.${patch}"

    local docs_dir='docs'
    local latest_doc_commit=$(commit_date "${docs_dir}")
    sed -i -e "1s/.*/$latest_doc_commit/" "${docs_dir}/index.md"

    # git add .
    echo git commit -m "release ${version}"
    echo git tag "${version}"
    # git push --tags
}

#
# Make each function defined so far callable from Bash as e.g.
# `bash ./commands.sh release 1 0 2` or `./commands.sh release 1 0 2`
# if `commands.sh` has the exec perm set.
#
$*
