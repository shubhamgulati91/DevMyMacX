#!/bin/sh

echo "Cloning user's current projects from GitHub... \c"

if [[ -z "${CHECKOUT_GITHUB_PROJECTS}" ]]; then
    echo "Nothing to clone."
    exit 1
else
  echo
fi

CURRENT_PROJECTS_DIR=$(sh -c "echo $CURRENT_PROJECTS_DIR")
GITHUB_PROJECTS_ARR=${CHECKOUT_GITHUB_PROJECTS//,/ }
for PROJECT in ${GITHUB_PROJECTS_ARR}
do
    GIT_CLONE_URL="https://github.com/$GITHUB_USERNAME/$PROJECT.git"
    CHECKOUT_DIR="$CURRENT_PROJECTS_DIR/$PROJECT"
    echo "Cloning $GIT_CLONE_URL to $CHECKOUT_DIR... \c"
    if ! test -d "${CHECKOUT_DIR}"; then
      git clone $GIT_CLONE_URL $CHECKOUT_DIR &>/dev/null
    fi
    echo "Done"
done