Manifest for Android MarshMallow / CyanogenMod 13.0
====================================
Project M4|L5 / Project U0|L7 / Project V1|L1II / Project Vee3|L3II

---

Automatic Way:

script to download manifests, sync repo  and build:

    curl --create-dirs -L -o build.sh -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/cm-13.0/build.sh

To use:

    source build.sh

---

Manual Way:

To initialize CyanogenMod 13.0 Repo:

    repo init -u git://github.com/CyanogenMod/android.git -b cm-13.0 -g all,-notdefault,-darwin

---

To initialize Common Manifest for all devices:

    curl --create-dirs -L -o .repo/local_manifests/common_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/cm-13.0/common_manifest.xml

---

To initialize Manifest for L5/L7 devices:

    curl --create-dirs -L -o .repo/local_manifests/msm7x27a_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/cm-13.0/msm7x27a_manifest.xml

---

To initialize Manifest for L1II/L3II devices:

    curl --create-dirs -L -o .repo/local_manifests/vee3_manifest.xml -O -L https://raw.github.com/TeamVee/android_.repo_local_manifests/cm-13.0/vee3_manifest.xml

---

# Never use 'L5/L7' Manifest with 'L1II/L3II' Manifest

---

Sync the repo:

    repo sync

---

Initialize the environment:

    source build/envsetup.sh

---

Apply patchs for all devices:

    repopick 144710 144831 144976

---

To build for L5:

    brunch e610

---

To build for L7:

    brunch p700

---

To build for L1II:

    TARGET_KERNEL_V1_BUILD_DEVICE=true brunch vee3

To build for L3II:

    brunch vee3
