TWRP3 Manifests
========================
Project M4 / Project U0 / Project Vee3 / Project V1

Local manifests to build TWRP 3 to L5, L7, L3II and L1II

To initialize CM11.0 Repo:

    repo init -u git://github.com/CyanogenMod/android.git -b cm-11.0 -g all,-notdefault,-darwin

To initialize Repo's:

    curl --create-dirs -L -o .repo/local_manifests/local_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/twrp-3/local_manifest.xml

To sync:

    repo sync

To initialize the environment

    . build/envsetup.sh

To build for L5:

    breakfast e610
    make recoveryimage

To build for L7:

    breakfast p700
    make recoveryimage

To build for L3 II:

    breakfast vee3
    make recoveryimage

To build for L1 II, enable variable to v1 and build:

    export TARGET_KERNEL_V1_BUILD_DEVICE=true
    breakfast vee3
    make recoveryimage
