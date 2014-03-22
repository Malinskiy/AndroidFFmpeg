#!/bin/bash

echo "Fetching Android system headers"
git clone --depth=1 --branch gingerbread-release https://github.com/CyanogenMod/android_frameworks_base.git ./android-source/frameworks/base
git clone --depth=1 --branch gingerbread-release https://github.com/CyanogenMod/android_system_core.git ./android-source/system/core

echo "Fetching Android libraries for linking"

if [ ! -d "./android-libs/armeabi" ]; then
  if [ ! -f "./update-cm-7.0.3-N1-signed.zip" ]; then
    wget http://download.cyanogenmod.com/get/update-cm-7.0.3-N1-signed.zip -P./
  fi
  mkdir -p ./android-libs/armeabi
  unzip ./update-cm-7.0.3-N1-signed.zip system/lib/* -d./
  mv ./system/lib ./android-libs/armeabi
  rmdir ./system
fi