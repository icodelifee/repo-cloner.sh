#!/bin/bash
clear
printf "Enter Your Github Username:"
read USERN
JSON=".$USERN-repos.json"
BRANCHF=".$USERN-branch.json"
#Fetches Github Api For User Repos
if [ ! -e $JSON ]
then
	printf "Getting Repository Information...\n"
	wget -q --show-progress -O $JSON https://api.github.com/users/$USERN/repos
else
	printf "Repository Information Found\n"
fi
#Checks If Jq JSON Processor Is Installed Or Not
if [ which jq &> /dev/null ]
then
	printf "Installing Dependency\n"
	sudo apt install jq
fi

#Stores And Display No Of Available Repositories
REPOS=$(curl -s https://api.github.com/users/icodelifee | jq '.public_repos')
#REPOS=$(tr ' ' '\n' < $JSON | grep name | wc -l)

echo "No Of Repositories $REPOS"

#Prints Repo Name With Index
for ((i = 0; i < $REPOS ; i++))
do
	echo "[$i] $(jq -r ".[$i].name" $JSON)"
done

printf "Enter Repo Index To Clone: "
read INDEX
REPO=$(jq -r ".[$INDEX].name" $JSON)
printf "Getting Branch Information.."
wget -q -O $BRANCHF https://api.github.com/repos/$USERN/$REPO/branches
clear
#Gets Number Of Branches From JSON
BNO=$(tr ' ' '\n' < $BRANCHF | grep name | wc -l)
printf "Branches:\n"
for ((i = 0; i < $BNO ; i++))
do
	echo "[$i] $(jq -r ".[$i].name" $BRANCHF)"
done
printf "Enter Branch To Clone :"
read BRANCHI
BRANCH=$(jq -r ".[$BRANCHI].name" $BRANCHF)
printf "Enter Location To Clone[path/to/loc] :"
read LOC
clear

printf "Cloning $(jq -r ".[$INDEX].name" $JSON)\n"
CLONEID=$(jq -r ".[$INDEX].html_url" $JSON)
git clone $CLONEID -b $BRANCH $LOC
rm $BRANCHF
