#!/bin/bash -e
#
#
#	./download.sh ghusername/ghproject "1234abcd"
#
#	$1 = github repo in form "user/reponame"
#	$2 = optional commit-id (default if omitted will lookup "main" current commit-id
#
#
#	TODO:
#		Things to improve next time, makybe use a truncated commit-id for the
#		 toplevel project directory names.
#		Support artifact/workflow names with spaces in, replace with _ watch $IFS
#
#
retval=0

if test -z "$GH_TOKEN"
then
	GH_HEADER_AUTH=""
	GH_HEADER_AUTH_ARGS=""
else
	GH_HEADER_AUTH="Authorization: token ${GH_TOKEN}"
	GH_HEADER_AUTH_ARGS="-H ${GH_HEADER_AUTH}"
fi

GH_REPO="$1"

branch_name="main"

if echo -n "$GH_REPO" | egrep -q "^https://github.com/"
then
	# https://github.com/github_username/tt05-project-name
	GH_REPO=$(echo -n "$GH_REPO" | sed -e 's#^https://github.com/##')
	echo GH_REPO=$GH_REPO
fi

GH_REPO_ARGS="-R ${GH_REPO}"
echo $#

if [ $# -le 1 ] || test -z "$2"
then
	CID_FULL=$(curl -s $GH_HEADER_AUTH_ARGS \
		-H "Accept: application/vnd.github.VERSION.sha" \
		"https://api.github.com/repos/${GH_REPO}/commits/${branch_name}")
	echo CID_FULL=$CID_FULL
	CID=$(echo -n "$CID_FULL" | cut -c 1-8)
	echo CID=$CID
else
	CID="$2"
fi

dir=$(echo -n "${GH_REPO}_${CID}" | tr '/\\' '__')

#echo gh run list ${GH_REPO_ARGS} --json databaseId,name,headSha,number
#gh run list ${GH_REPO_ARGS} --json databaseId,name,headSha,number | jq ".[]|select(.headSha | startswith(\"${CID}\"))"

gh_run_list=$(gh run list ${GH_REPO_ARGS} --json databaseId,name,headSha,number)

json_filtered=$(echo -n "$gh_run_list" | jq ".[]|select(.headSha | startswith(\"${CID}\"))")

echo "$dir"
[ -d "$dir" ] || mkdir -v "$dir"
cd "$dir" || exit 1

echo -n "$gh_run_list" > gh_run_list.json
echo -n "$json_filtered" > gh_actions.json

echo $json_filtered  | jq '.'

for name in $(echo $json_filtered | jq '.name' | tr -d '"')
do
	echo name=$name	# has quoted on it already

	databaseId=$(echo -n $json_filtered  | jq ". | select(.name == \"${name}\") | .databaseId" | head -n1)
	number=$(echo -n $json_filtered      | jq ". | select(.name == \"${name}\") | .number" | head -n1)
	commit_hash=$(echo -n $json_filtered | jq ". | select(.name == \"${name}\") | .headSha" | head -n1)

	if [ ! -d "${databaseId}_${name}" ]
	then
		echo -n "Downloading... ${databaseId}_${name}... "
		if gh run download  ${GH_REPO_ARGS} -D "${databaseId}_${name}" "${databaseId}"
		then
			echo "done"
		else
			retval=1
		fi
	fi
done

if [ ! -f "${branch_name}_${CID}.zip" ]
then
	# https://github.com/{username}/{projectname}/archive/{sha}.zip
	if ! wget -q -O "${branch_name}_${CID}.zip" "https://github.com/${GH_REPO}/archive/${CID}.zip"
	then
		if wget -q -O "${branch_name}_${CID}.zip" "https://github.com/${GH_REPO}/archive/${commit_hash}.zip"
		then
			echo "done"
		else
			retval=1
		fi
	else
		echo "done"
	fi
fi

exit $retval
