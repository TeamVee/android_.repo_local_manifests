#!/bin/bash
# Generic Variables
_android_version="4.4.4"
_echo_android="KitKat"
_custom_android="cm-11.0"
_echo_custom_android="CyanogenMod"
_echo_custom_android_version="11"
# Make loop for usage of 'break' to recursive exit
while true
do
	# Check if is using 'BASH'
	if [ ! "${BASH_VERSION}" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0) Please do not use 'sh' to run this script"
		echo "$(tput setaf 2)---$(tput sgr0) Just use 'source build.sh'"
		echo "$(tput setaf 3)---$(tput sgr0) Exiting from script!"
		break
	fi

	# Check if 'repo' is installed
	if [ ! "$(which repo)" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0) You will need to install 'repo'"
		echo "$(tput setaf 2)---$(tput sgr0) Check in this link:"
		echo "$(tput setaf 3)---$(tput sgr0) <https://source.android.com/source/downloading.html>"
		echo "$(tput setaf 4)---$(tput sgr0) Exiting from script!"
		break
	fi

	# Check if 'curl' is installed
	if [ ! "$(which curl)" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0) You will need 'curl'"
		echo "$(tput setaf 2)---$(tput sgr0) Use 'sudo apt-get install curl' to install 'curl'"
		echo "$(tput setaf 3)---$(tput sgr0) Exiting from script!"
		break
	fi

	# Name of script
	echo "$(tput setaf 1)---$(tput sgr0) Live Android $_echo_android ($_android_version) - $_echo_custom_android $_echo_custom_android_version ($_custom_android) Sync and Build Script"

	# Check option of user and transform to script
	for _option in "$@"
	do
		if [[ "$_option" == "-h" || "$_option" == "--help" ]]
		then
			echo
			echo "$(tput setaf 1)---$(tput sgr0) Usage:"
			echo "$(tput setaf 2)---$(tput sgr0) -f | --force | Force redownload of Android Tree Manifest"
			echo "$(tput setaf 3)---$(tput sgr0) -h | --help  | To show this message"
			echo
			_option_help="enable"
			break
		fi
		# Force redownload of android tree
		if [[ "$_option" == "-f" || "$_option" == "--force" ]]
		then
			_option1="enable"
			_echo_option1=" force"
			_repo_forced="--force-sync"
			_echo_repo_forced1=" forced-sync"
		fi
	done

	# Exit if option is 'help'
	if [ "$_option_help" == "enable" ]
	then
		unset _option_help
		sleep 2
		break
	fi

	# Write 'default' if none option
	if [ "$_echo_option1" == "" ]
	then
		_echo_option0=" default"
	fi

	# Echo option to user
	echo "$(tput setaf 1)---$(tput sgr0) Using option:$_echo_option0$_echo_option1"
	sleep 2

	# Repo Sync
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Starting Sync of Android Tree Manifest"
	echo "$(tput setaf 2)---$(tput sgr0) $_echo_custom_android $_echo_custom_android_version ($_custom_android)"
	read -p "$(tput setaf 3)---$(tput sgr0) Press any key to continue!" -n 1

	# Device Choice
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Choose Devices Manifest to download:"
	echo "$(tput setaf 2)---$(tput sgr0) 1) MSM7x27a | LG Optimus L5/L7 (L5 NoNFC/L7 NoNFC)"
	echo "$(tput setaf 3)---$(tput sgr0) 2) Vee3 | LG Optimus L3II/L1II (L3II Single/Dual/L1II Single/Dual)"
	if ! [ "$(ls -a .repo/local_manifests/ | grep common_manifest.xml)" == "" ]
	then
		if ! [ "$(ls -a .repo/local_manifests/ | grep msm7x27a_manifest.xml)" == "" ]
		then
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 1)---$(tput sgr0) Current is: 1) L5/L7"
		elif ! [ "$(ls -a .repo/local_manifests/ | grep vee3_manifest.xml)" == "" ]
		then
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 1)---$(tput sgr0) Current is: 2) L3II/L1II"
		fi
	fi
	echo "$(tput setaf 1)---$(tput sgr0)"
	read -p "$(tput setaf 4)---$(tput sgr0) Choice (1/ 2/ or any key to exit): " -n 1 -s x
	case "$x" in
		1 ) echo "L5/L7"; _device="msm7x27a";;
		2 ) echo "L3II/L1II"; _device="vee3";;
		* ) echo "exit"; break;;
	esac

	# Remove old Manifest of Android Tree
	if [ "$_option1" == "enable" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0)"
		echo "$(tput setaf 1)---$(tput sgr0) Option 'force' found!"
		echo "$(tput setaf 2)---$(tput sgr0) Removing old Manifest before download new one"
		rm -rf .repo/manifests .repo/manifests.git .repo/manifest.xml
	fi

	# Initialization of Android Tree
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Downloading Android Tree Manifest of branch $_custom_android"
	repo init -u git://github.com/"$_echo_custom_android"/android.git -b "$_custom_android" -g all,-notdefault,-darwin
	if ! [ "$?" == "0" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0) Android Tree Manifest download failed!"
		echo "$(tput setaf 2)---$(tput sgr0) Exiting from script!"
		break
	fi

	# Device manifest download
	rm -rf .repo/local_manifests/
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Downloading $_device manifest of branch $_custom_android"
	curl -# --create-dirs -L -o .repo/local_manifests/"$_device"_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/"$_custom_android"/"$_device"_manifest.xml
	if ! [ "$?" == "0" ]
	then
		echo
		echo "$(tput setaf 1)---$(tput sgr0) Android Device Manifest download Failed!"
		echo "$(tput setaf 2)---$(tput sgr0) Exiting from script!"
		break
	fi

	# Common device manifest download
	if [[ "$_device" == "vee3" || "$_device" == "msm7x27a" ]]
	then
		echo "$(tput setaf 1)---$(tput sgr0)"
		echo "$(tput setaf 1)---$(tput sgr0) Downloading Common $_device manifest of branch $_custom_android"
		curl -# --create-dirs -L -o .repo/local_manifests/common_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/"$_custom_android"/common_manifest.xml
		if ! [ "$?" == "0" ]
		then
			echo "$(tput setaf 1)---$(tput sgr0) Android Common Device Manifest download Failed!"
			echo "$(tput setaf 2)---$(tput sgr0) Exiting from script!"
			break
		fi
	fi

	# Real 'repo sync'
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Starting Sync of:"
	echo "$(tput setaf 2)---$(tput sgr0) Android $_echo_android ($_android_version) - $_echo_custom_android $_echo_custom_android_version ($_custom_android)"
	echo "$(tput setaf 1)---$(tput sgr0) Using option:$_echo_option0_echo_repo_forced1"
	repo sync -q $_repo_forced
	if ! [ "$?" == "0" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0) Sync Failed!"
		echo "$(tput setaf 2)---$(tput sgr0) Exiting from script!"
		break
	fi

	# Builing Android
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Starting Android Building!"
	echo "$(tput setaf 2)---$(tput sgr0) $_echo_custom_android $_echo_custom_android_version ($_custom_android)"
	read -p "$(tput setaf 3)---$(tput sgr0) Press any key to continue!" -n 1

	# Initialize environment
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 4)---$(tput sgr0) Initialize the environment"
	source build/envsetup.sh
	if ! [ "$?" == "0" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0) Initialization Failed!"
		echo "$(tput setaf 2)---$(tput sgr0) Exiting from script!"
		break
	fi

	_device_failed() {
		echo "$(tput setaf 1)---$(tput sgr0) Building failed!"
		echo "$(tput setaf 2)---$(tput sgr0) Exiting from script!"
		break
	}

	# Another device choice
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) For what device you want to build:"
	if ! [ "$(ls -a device/lge/ | grep msm7x27a)" == "" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0)"
		echo "$(tput setaf 2)---$(tput sgr0) 1) LG Optimus L5 NoNFC | E610 E612 E617"
		echo "$(tput setaf 3)---$(tput sgr0) 2) LG Optimus L7 NoNFC | P700 P705"
		echo "$(tput setaf 4)---$(tput sgr0) 3) Both options above"
		echo "$(tput setaf 1)---$(tput sgr0)"
		read -p "$(tput setaf 5)---$(tput sgr0) Choice (1/2/3/ or * to exit): " -n 1 -s x
		case "$x" in
			1 ) echo "Building to L5"; _device_build1="e610";;
			2 ) echo "Building to L7"; _device_build2="p700";;
			3 ) echo "Building to L5/L7"; _device_build1="e610"; _device_build2="p700";;
			* ) echo "exit"; break;;
		esac
		if [ "$_device_build1" == "e610" ]
		then
			echo "$(tput setaf 1)---$(tput sgr0)"
			brunch e610
			if ! [ "$?" == "0" ]
			then
				_device_failed
			fi
		fi
		if [ "$_device_build2" == "p700" ]
		then
			echo "$(tput setaf 1)---$(tput sgr0)"
			brunch p700
			if ! [ "$?" == "0" ]
			then
				_device_failed
			fi
		fi
	elif ! [ "$(ls -a device/lge/ | grep vee3)" == "" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0)"
		echo "$(tput setaf 1)---$(tput sgr0) 1) LG Optimus L3II Single Dual | E425 E430 E431 E435" 
		echo "$(tput setaf 2)---$(tput sgr0) 2) LG Optimus L1II Single Dual | E410 E411 E415 E420"
		echo "$(tput setaf 3)---$(tput sgr0) 3) Both options above"
		echo "$(tput setaf 1)---$(tput sgr0)"
		read -p "$(tput setaf 4)---$(tput sgr0) Choice (1/2/3/ or * to exit): " -n 1 -s x
		case "$x" in
			1 ) echo "Building to L3II"; _device_build1="vee3";;
			2 ) echo "Building to L1II"; _device_build2="v1";;
			3 ) echo "Building to L3II/L1II"; _device_build1="vee3"; _device_build2="v1";;
			* ) echo "exit"; break;;
		esac
		echo "$(tput setaf 1)---$(tput sgr0)"
		sh device/lge/vee3/patches/apply.sh
		if [ "$_device_build1" == "vee3" ]
		then
			echo "$(tput setaf 1)---$(tput sgr0)"
			brunch vee3
			if ! [ "$?" == "0" ]
			then
				_device_failed
			fi
		fi
		if [ "$_device_build2" == "v1" ]
		then
			echo "$(tput setaf 1)---$(tput sgr0)"
			TARGET_KERNEL_V1_BUILD_DEVICE=true brunch vee3
			if ! [ "$?" == "0" ]
			then
				_device_failed
			fi
		fi
	else
		echo "$(tput setaf 1)---$(tput sgr0)"
		echo "$(tput setaf 1)---$(tput sgr0) No device folder found!"
		echo "$(tput setaf 2)---$(tput sgr0) Exiting from script!"
		break
	fi

	# Goodbye!
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Thanks for using this script!"

	# Unset variables
	unset _option _echo_option0 _option1 _echo_option1 _android_version _echo_android _device_build1
	unset _custom_android _echo_custom_android _echo_custom_android_version _device _device_build2

	# Exit
	break
done
