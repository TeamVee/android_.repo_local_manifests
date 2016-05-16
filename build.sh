#!/bin/bash
# Generic Variables
_android_version="5.1.1"
_echo_android="LolliPop"
_custom_android="cm-12.1"
_echo_custom_android="CyanogenMod"
_echo_custom_android_version="12.1"
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
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 1)---$(tput sgr0) Usage:"
			echo "$(tput setaf 2)---$(tput sgr0) -h    | --help   | To show this message"
			echo "$(tput setaf 3)---$(tput sgr0) -f    | --force  | Force redownload of Android Tree Manifest"
			echo "$(tput setaf 4)---$(tput sgr0) -b    | --bypass | To bypass message 'Press any key'"
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 2)---$(tput sgr0) -l5   | --e610   | To build only for L5/e610"
			echo "$(tput setaf 3)---$(tput sgr0) -l7   | --p700   | To build only for L7/p700"
			echo "$(tput setaf 4)---$(tput sgr0) -gen1 | --gen1   | To build for L5 and L7"
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 2)---$(tput sgr0) -l3ii | --vee3   | To build only for L3II/vee3"
			echo "$(tput setaf 3)---$(tput sgr0) -l1ii | --v1     | To build only for L1II/v1"
			echo "$(tput setaf 4)---$(tput sgr0) -gen2 | --gen2   | To build for L3II and L1II"
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 1)---$(tput sgr0) Tip: Use '-b' if using one of options above"
			_option_help="enable"
			break
		fi
		# Force redownload of android tree
		if [[ "$_option" == "-f" || "$_option" == "--force" ]]
		then
			_option1="enable"
			_echo_option1=" force"
			_repo_forced="--force-sync"
			_echo_repo_forced=" force-sync"
		fi
		# Choose device before choose
		if ! [ "$_device" == "vee3" ]
		then
			if [[ "$_option" == "-l5" || "$_option" == "--e610" ]]
			then
				_option2="enable"
				_echo_option2=" l5-only"
				_device="msm7x27a"
				_device_build="e610"
			fi
			if [[ "$_option" == "-l7" || "$_option" == "--p700" ]]
			then
				_option2="enable"
				_echo_option2=" l7-only"
				_device="msm7x27a"
				_device_build="p700"
			fi
			if [[ "$_option" == "-gen1" || "$_option" == "--gen1" ]]
			then
				_option2="enable"
				_echo_option2=" l5-and-l7"
				_device="msm7x27a"
				_device_build="e610-p700"
			fi
		fi
		if ! [ "$_device" == "msm7x27a" ]
		then
			if [[ "$_option" == "-l3ii" || "$_option" == "--vee3" ]]
			then
				_option2="enable"
				_echo_option2=" l3ii-only"
				_device="vee3"
				_device_build="vee3"
			fi
			if [[ "$_option" == "-l1ii" || "$_option" == "--v1" ]]
			then
				_option2="enable"
				_echo_option2=" l1ii-only"
				_device="vee3"
				_device_build="v1"
			fi
			if [[ "$_option" == "-gen2" || "$_option" == "--gen2" ]]
			then
				_option2="enable"
				_echo_option2=" l3ii-and-l1ii"
				_device="vee3"
				_device_build="vee3-v1"
			fi
		fi
		# Force redownload of android tree
		if [[ "$_option" == "-b" || "$_option" == "--bypass" ]]
		then
			_option3="enable"
			_echo_option3=" bypass"
		fi
	done

	_if_fail_break() {
		echo "$(tput setaf 1)---$(tput sgr0)"
		$1
		if ! [ "$?" == "0" ]
		then
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 1)---$(tput sgr0) Something failed!"
			echo "$(tput setaf 2)---$(tput sgr0) Exiting from script!"
			_unset
			break
		fi
	}

	_unset(){
		unset _option _option1 _echo_option1 _option2 _echo_option2 _option3 _echo_option3
		unset _android_version _echo_android _custom_android _echo_custom_android _echo_custom_android_version
		unset _repo_forced _echo_repo_forced _device _device_build
	}

	# Exit if option is 'help'
	if [ "$_option_help" == "enable" ]
	then
		unset _option_help
		break
	fi

	# Echo option to user
	echo "$(tput setaf 1)---$(tput sgr0) Using option: default$_echo_option1$_echo_option2$_echo_option3"
	sleep 2

	# Repo Sync
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Starting Sync of Android Tree Manifest"
	echo "$(tput setaf 2)---$(tput sgr0) $_echo_custom_android $_echo_custom_android_version ($_custom_android)"
	if [ "$_option3" == "enable" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0)"
		echo "$(tput setaf 1)---$(tput sgr0) Option 'bypass' found!"
		echo "$(tput setaf 2)---$(tput sgr0) Resuming without ask!"
	else
		read -p "$(tput setaf 3)---$(tput sgr0) Press any key to continue!" -n 1
	fi

	# Device Choice
	if [ "$_option2" == "enable" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0)"
		echo "$(tput setaf 1)---$(tput sgr0) Option '$_device' found!"
		echo "$(tput setaf 2)---$(tput sgr0) Using $_device manifest without ask!"
	else
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
	fi

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
	_if_fail_break "repo init -u git://github.com/"$_echo_custom_android"/android.git -b "$_custom_android" -g all,-notdefault,-darwin"

	# Device manifest download
	rm -rf .repo/local_manifests/
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Downloading $_device manifest of branch $_custom_android"
	_if_fail_break "curl -# --create-dirs -L -o .repo/local_manifests/"$_device"_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/"$_custom_android"/"$_device"_manifest.xml"

	# Common device manifest download
	if [[ "$_device" == "vee3" || "$_device" == "msm7x27a" ]]
	then
		echo "$(tput setaf 1)---$(tput sgr0)"
		echo "$(tput setaf 1)---$(tput sgr0) Downloading Common $_device manifest of branch $_custom_android"
		_if_fail_break "curl -# --create-dirs -L -o .repo/local_manifests/common_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/"$_custom_android"/common_manifest.xml"
	fi

	# Real 'repo sync'
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Starting Sync of:"
	echo "$(tput setaf 2)---$(tput sgr0) Android $_echo_android ($_android_version) - $_echo_custom_android $_echo_custom_android_version ($_custom_android)"
	echo "$(tput setaf 1)---$(tput sgr0) Using option: default$_echo_repo_forced"
	_if_fail_break "repo sync -q $_repo_forced"

	# Builing Android
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) Starting Android Building!"
	echo "$(tput setaf 2)---$(tput sgr0) $_echo_custom_android $_echo_custom_android_version ($_custom_android)"
	if [ "$_option3" == "enable" ]
	then
		echo "$(tput setaf 1)---$(tput sgr0)"
		echo "$(tput setaf 1)---$(tput sgr0) Option 'bypass' found!"
		echo "$(tput setaf 2)---$(tput sgr0) Resuming without ask!"
	else
		read -p "$(tput setaf 3)---$(tput sgr0) Press any key to continue!" -n 1
	fi

	# Initialize environment
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 4)---$(tput sgr0) Initialize the environment"
	_if_fail_break "source build/envsetup.sh"

	# Another device choice
	echo "$(tput setaf 1)---$(tput sgr0)"
	echo "$(tput setaf 1)---$(tput sgr0) For what device you want to build:"
	if ! [ "$(ls -a device/lge/ | grep msm7x27a)" == "" ]
	then
		then
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 1)---$(tput sgr0) Option$_echo_option2 found!"
			echo "$(tput setaf 2)---$(tput sgr0) Using $_device_build device without ask!"
		else
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 2)---$(tput sgr0) 1) LG Optimus L5 NoNFC | E610 E612 E617"
			echo "$(tput setaf 3)---$(tput sgr0) 2) LG Optimus L7 NoNFC | P700 P705"
			echo "$(tput setaf 4)---$(tput sgr0) 3) Both options above"
			echo "$(tput setaf 1)---$(tput sgr0)"
			read -p "$(tput setaf 5)---$(tput sgr0) Choice (1/2/3/ or * to exit): " -n 1 -s x
			case "$x" in
				1 ) echo "Building to L5"; _device_build="e610";;
				2 ) echo "Building to L7"; _device_build="p700";;
				3 ) echo "Building to L5/L7"; _device_build="e610-p700";;
				* ) echo "exit"; break;;
			esac
		fi
		echo "$(tput setaf 1)---$(tput sgr0)"
		sh device/lge/msm7x27a/patches/apply.sh
		if [ "$_device_build" == "e610" ]
		then
			_if_fail_break "brunch e610"
		fi
		if [ "$_device_build" == "p700" ]
		then
			_if_fail_break "brunch p700"
		fi
		if [ "$_device_build" == "e610-p700" ]
		then
			_if_fail_break "brunch e610"
			_if_fail_break "brunch p700"
		fi
	elif ! [ "$(ls -a device/lge/ | grep vee3)" == "" ]
	then
		if [ "$_option2" == "enable" ]
		then
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 1)---$(tput sgr0) Option$_echo_option2 found!"
			echo "$(tput setaf 2)---$(tput sgr0) Using $_device_build device without ask!"
		else
			echo "$(tput setaf 1)---$(tput sgr0)"
			echo "$(tput setaf 1)---$(tput sgr0) 1) LG Optimus L3II Single Dual | E425 E430 E431 E435"
			echo "$(tput setaf 2)---$(tput sgr0) 2) LG Optimus L1II Single Dual | E410 E411 E415 E420"
			echo "$(tput setaf 3)---$(tput sgr0) 3) Both options above"
			echo "$(tput setaf 1)---$(tput sgr0)"
			read -p "$(tput setaf 4)---$(tput sgr0) Choice (1/2/3/ or * to exit): " -n 1 -s x
			case "$x" in
				1 ) echo "Building to L3II"; _device_build="vee3";;
				2 ) echo "Building to L1II"; _device_build="v1";;
				3 ) echo "Building to L3II/L1II"; _device_build="vee3-v1";;
				* ) echo "exit"; break;;
			esac
		fi
		echo "$(tput setaf 1)---$(tput sgr0)"
		sh device/lge/vee3/patches/apply.sh
		if [ "$_device_build" == "vee3" ]
		then
			export TARGET_KERNEL_V1_BUILD_DEVICE=false
			_if_fail_break "brunch vee3"
			unset TARGET_KERNEL_V1_BUILD_DEVICE
		fi
		if [ "$_device_build" == "v1" ]
		then
			export TARGET_KERNEL_V1_BUILD_DEVICE=true
			_if_fail_break "brunch vee3"
			unset TARGET_KERNEL_V1_BUILD_DEVICE
		fi
		if [ "$_device_build" == "vee3-v1" ]
		then
			export TARGET_KERNEL_V1_BUILD_DEVICE=false
			_if_fail_break "brunch vee3"
			export TARGET_KERNEL_V1_BUILD_DEVICE=true
			_if_fail_break "brunch vee3"
			unset TARGET_KERNEL_V1_BUILD_DEVICE
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
	_unset

	# Exit
	break
done
