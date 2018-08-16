#!/bin/bash

# Rebuild function
rebuild_image () {
	branch_name=$1
	cd $HOME/pyconjp-2018-$branch_name
	docker-compose build --no-cache
	docker-compose down
	docker-compose up -d
}


# Prune image function
prune_images () {
	docker image prune -f
}


# Check update
check_update () {
	local pyconweb_repo="https://github.com/pyconjp/pycon.jp.2018.git"
	local dev_branch="dev"
	local master_branch="master"
	case "$1" in 
		master )
			local branch_name="$master_branch"
			;;
		* )
			local branch_name="$dev_branch"
			;;
	esac		

	if [ -d "$HOME/src/pycon.jp.2018" ]; then
		cd $HOME/src/pycon.jp.2018
		git checkout -f $branch_name
		git fetch origin
		result=`git diff origin/$branch_name`
		if [ "$result" != "" ]; then
			rebuild_image $branch_name
			git pull
		fi
	else
		mkdir $HOME/src
		cd $HOME/src
		git clone $pyconweb_repo
		rebuild_image $branch_name
	fi

}


# main
if [ "$#" == 0 ]; then
	check_update dev
	check_update master
	prune_images
else
	case "$1" in
		"master" )
			check_update master
			prune_images
			;;
		"dev" )
			check_update dev
			prune_images
			;;
		"prune" )
			prune_images
			;;
		"all" )
			check_update dev
			check_update master
			prune_images
			;;
		"rebuild-all" )
			rebuild_image master
			rebuild_image dev
			prune_images
			;;
		* )
			echo "Usage: `basename $0` [master|dev|prune]"
			;;
	esac
fi
