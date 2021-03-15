#!/bin/bash
SINCE_DATE=$(date +'%Y-%m-%d' -d "$INPUT_DAYS day ago")
HTTP_OK=200
OUTFILE=/tmp/result
# this is used to check repo for commits
REPO_URL=https://api.github.com/repos/$INPUT_REPO

# if there is a specific path in input, check for that path
PATH_QUERY=""
if [ ! -z "$INPUT_PATH" ]; then
  for p in $INPUT_PATH; do
    PATH_QUERY="$PATH_QUERY&path=$p"
    echo "adding path $p"
  done
  echo "checking commits on $INPUT_REPO since $SINCE_DATE at path $INPUT_PATH"
else
  echo "checking commits on $INPUT_REPO since $SINCE_DATE"
fi

STATUS=$(curl -sLo "$OUTFILE" \
 --write-out "%{http_code}" \
 -H"Authorization: token $INPUT_TOKEN" \
 "$REPO_URL/commits?sha=$INPUT_REF&since=$SINCE_DATE&per_page=1$PATH_QUERY")

if [ "$STATUS" -ne "$HTTP_OK" ]; then
  echo "checking commits for $INPUT_REPO. Expected $HTTP_OK. Got $STATUS"
  exit 1
fi

# since the per page is set to 1, this is a yes/no indicator
HAS_COMMITS=$(jq length "$OUTFILE")
echo "::set-output name=has-commits::$HAS_COMMITS"
