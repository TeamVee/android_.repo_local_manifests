CM11 Manifests
========================
Project M4 / Project V1 / Project Vee3

Local manifests to build Android KitKat 4.4 to L5, L1II and L3II

To initialize CM11 Repo:

    repo init -u git://github.com/CyanogenMod/android.git -b cm-11.0 -g all,-notdefault,-darwin

To initialize Repo's:

    curl --create-dirs -L -o .repo/local_manifests/local_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/cm-11.0/local_manifest.xml

To sync:

    repo sync

To apply patchs:

     device/lge/vee-common/patches/apply.sh

To initialize the environment

    . build/envsetup.sh

To build for L5:

    brunch m4

To build for L1 II:

    brunch v1

To build for L3 II:

    brunch vee3
