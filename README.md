CM11 Manifests - Project Vee
========================
Project V1 / Project Vee3 / Project Vee7
Local manifests to build Android KitKat 4.4 to L1II, L3II and L7II
To initialize CM11 Repo:

    repo init -u git://github.com/CyanogenMod/android.git -b cm-11.0 -g all,-notdefault,-darwin

To initialize Vee3 Repo's:

    curl --create-dirs -L -o .repo/local_manifests/local_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/cm-11.0/local_manifest.xml

To sync:

    repo sync

To apply patchs:

     device/lge/vee-common/patches/apply.sh

To initialize the environment

    . build/envsetup.sh

To build for v1 (Not Work - To be BringUp):

    brunch v1

To build for vee3:

    brunch vee3

To build for vee7 (Not Work - To be BringUp):

    brunch vee7
