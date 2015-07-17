CM11 Manifest - Project Vee3
========================
Local manifests to build Android KitKat 4.4 to L3 II Single/Dual

To initialize CM11 Repo:

    repo init -u git://github.com/CyanogenMod/android.git -b cm-11.0

To initialize Vee3 Repo's:

    curl --create-dirs -L -o .repo/local_manifests/local_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/cm-11.0/local_manifest.xml

To sync:

    repo sync

To apply patchs:

     device/lge/vee3/patches/apply.sh

To initialize the environment

    . build/envsetup.sh

To build:

    brunch vee3
