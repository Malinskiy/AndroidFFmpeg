#!/bin/bash
#
# build_android.sh
# Copyright (c) 2012 Jacek Marchwicki
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ "$NDK" = "" ]; then
	echo NDK variable not set, exiting
	echo "Use: export NDK=/your/path/to/android-ndk"
	exit 1
fi

OS=`uname -s | tr '[A-Z]' '[a-z]'`-`uname -m`
function build_x264
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -f was copying the folder, and renaming it to "linux-x86" and now pic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export AS="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd x264
	./configure --prefix=$(pwd)/$PREFIX --host=$ARCH-linux --enable-static $ADDITIONAL_CONFIGURE_FLAG || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}

function build_amr
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd vo-amrwbenc
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}

function build_aac
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc-$COMPILER_VERSION --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd vo-aacenc
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}
function build_freetype2
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS=$OPTIMIZE_CFLAGS
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -nostdlib -lc -lm -ldl -llog"

	cd freetype2
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}
function build_ass
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS="$OPTIMIZE_CFLAGS"
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -nostdlib -lc -lm -ldl -llog"

	cd libass
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --disable-fontconfig \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make V=1 -j4 install || exit 1
	cd ..
}
function build_fribidi
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	export PATH=${PATH}:$PREBUILT/bin/
	CROSS_COMPILE=$PREBUILT/bin/$EABIARCH-
	CFLAGS="$OPTIMIZE_CFLAGS -std=gnu99"
#CFLAGS=" -I$ARM_INC -fpic -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID  -Wa,--noexecstack -MMD -MP "
	export CPPFLAGS="$CFLAGS"
	export CFLAGS="$CFLAGS"
	export CXXFLAGS="$CFLAGS"
	export CXX="${CROSS_COMPILE}g++ --sysroot=$PLATFORM"
	export CC="${CROSS_COMPILE}gcc --sysroot=$PLATFORM"
	export NM="${CROSS_COMPILE}nm"
	export STRIP="${CROSS_COMPILE}strip"
	export RANLIB="${CROSS_COMPILE}ranlib"
	export AR="${CROSS_COMPILE}ar"
	export LDFLAGS="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog"

	cd fribidi
	./configure \
	    --prefix=$(pwd)/$PREFIX \
	    --host=$ARCH-linux \
	    --disable-bin \
	    --disable-dependency-tracking \
	    --disable-shared \
	    --enable-static \
	    --with-pic \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1

	make clean || exit 1
	make -j4 install || exit 1
	cd ..
}
function build_ffmpeg
{
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	CC=$PREBUILT/bin/$EABIARCH-gcc
	CXX=$PREBUILT/bin/$EABIARCH-g++
	CROSS_PREFIX=$PREBUILT/bin/$EABIARCH-
	PKG_CONFIG=${CROSS_PREFIX}pkg-config
	if [ ! -f $PKG_CONFIG ];
	then
		cat > $PKG_CONFIG << EOF
#!/bin/bash
pkg-config \$*
EOF
		chmod u+x $PKG_CONFIG
	fi
	NM=$PREBUILT/bin/$EABIARCH-nm
	cd ffmpeg
	export PKG_CONFIG_LIBDIR=$(pwd)/$PREFIX/lib/pkgconfig/
	export PKG_CONFIG_PATH=$(pwd)/$PREFIX/lib/pkgconfig/
	./configure --target-os=linux \
	    --prefix=$PREFIX \
	    --enable-cross-compile \
	    --extra-libs="-lgcc" \
	    --arch=$ARCH \
	    --cc=$CC \
	    --cxx=$CXX \
	    --cross-prefix=$CROSS_PREFIX \
	    --nm=$NM \
	    --sysroot=$PLATFORM \
	    --extra-cflags=" -O3 -fPIC -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums  -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS" \
	    --extra-cxxflags="-fno-rtti" \
	    --disable-shared \
	    --enable-static \
	    --enable-runtime-cpudetect \
	    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog -L$PREFIX/lib -L$ANDROID_LIBS -Wl,-rpath-link,$ANDROID_LIBS -L$ANDROID_STL_LIB $CRT_BEGINOBJ" \
	    --extra-cflags=" $ANDROID_INLCLUDES -I$PREFIX/include" \
	    --disable-everything \
	    --enable-libstagefright-h264 \
	    --enable-decoder=libstagefright_h264 \
	    --enable-libvo-aacenc \
	    --enable-demuxer=mov \
	    --enable-demuxer=h264 \
	    --enable-demuxer=mpegvideo \
	    --enable-muxer=rtsp \
	    --enable-muxer=mp4 \
	    --enable-muxer=mov \
	    --enable-protocol=crypto \
	    --enable-protocol=jni \
	    --enable-protocol=file \
	    --enable-decoder=rawvideo \
	    --enable-encoder=rawvideo \
	    --enable-decoder=mpeg4 \
	    --enable-encoder=mpeg4 \
	    --enable-decoder=h264 \
	    --enable-encoder=h264 \
	    --enable-decoder=aac \
	    --enable-encoder=aac \
	    --enable-parser=h264 \
	    --enable-avformat \
	    --enable-avcodec \
	    --enable-avresample \
	    --enable-zlib \
	    --disable-doc \
	    --disable-ffplay \
	    --disable-ffmpeg \
	    --disable-ffplay \
	    --disable-ffprobe \
	    --disable-ffserver \
	    --disable-avfilter \
	    --disable-avdevice \
	    --disable-nonfree \
	    --enable-version3 \
	    --enable-memalign-hack \
	    --enable-asm \
	    $ADDITIONAL_CONFIGURE_FLAG \
	    || exit 1
	make clean || exit 1
	make -j5 install || exit 1

	cd ..
}

function build_one {
	cd ffmpeg
	PLATFORM=$NDK/platforms/$PLATFORM_VERSION/arch-$ARCH/
	#$PREBUILT/bin/$EABIARCH-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -L$PREFIX/lib  -soname $SONAME -shared -nostdlib  -z noexecstack -Bsymbolic --whole-archive --no-undefined -o $OUT_LIBRARY -lavcodec -lavformat -lavresample -lavutil -lswresample -lass -lfreetype -lfribidi -lswscale -lvo-aacenc -lvo-amrwbenc -lc -lm -lz -ldl -llog  --dynamic-linker=/system/bin/linker -zmuldefs $PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/libgcc.a || exit 1
	$PREBUILT/bin/$EABIARCH-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -L$PREFIX/lib  -L$ANDROID_LIBS -L$ANDROID_STL_LIB -soname $SONAME -shared -nostdlib  -z noexecstack -Bsymbolic --whole-archive --no-undefined -o $OUT_LIBRARY -lavcodec -lavformat -lavresample -lavutil -lswresample -lswscale -lvo-aacenc -lc -lm -lz -ldl -llog $ANDROID_STAGEFRIGHT_ADDITIONAL_LIBS $CRT_BEGINOBJ  --dynamic-linker=/system/bin/linker -zmuldefs $ANDROID_LIB_GCC || exit 1
	$PREBUILT/bin/$EABIARCH-strip -s $OUT_LIBRARY
	cd ..
}

./fetch_android_deps.sh

ANDROID_SOURCE=$(pwd)/android-source
ANDROID_INCLUDES_BASE="-I$ANDROID_SOURCE/frameworks/base/include"
ANDROID_INCLUDES_BASE="$ANDROID_INCLUDES_BASE -I$ANDROID_SOURCE/frameworks/base/include/media/stagefright/openmax"
ANDROID_INCLUDES_BASE="$ANDROID_INCLUDES_BASE -I$ANDROID_SOURCE/frameworks/native/include"
ANDROID_INCLUDES_BASE="$ANDROID_INCLUDES_BASE -I$ANDROID_SOURCE/frameworks/native/include/media/openmax"
ANDROID_INCLUDES_BASE="$ANDROID_INCLUDES_BASE -I$ANDROID_SOURCE/frameworks/av/include"
ANDROID_INCLUDES_BASE="$ANDROID_INCLUDES_BASE -I$ANDROID_SOURCE/system/core/include"
ANDROID_INCLUDES_BASE="$ANDROID_INCLUDES_BASE -I$ANDROID_SOURCE/hardware/libhardware/include"
ANDROID_STAGEFRIGHT_ADDITIONAL_LIBS="-lstagefright -lmedia -lutils -lbinder -lgnustl_shared"

#arm v5
EABIARCH=arm-linux-androideabi
ARCH=arm
ABI=armeabi
CPU=armv5
OPTIMIZE_CFLAGS="-marm -march=$CPU"
COMPILER_VERSION=4.8
ANDROID_STL_LIB="$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/libs/$ABI"
ANDROID_INLCLUDES="$ANDROID_INCLUDES_BASE -I$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/include -I$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/libs/$ABI/include"
ANDROID_LIBS=$(pwd)/android-libs/$ABI/lib
PREFIX=../ffmpeg-build/armeabi
OUT_LIBRARY=$PREFIX/libffmpeg.so
ADDITIONAL_CONFIGURE_FLAG=
SONAME=libffmpeg.so
PREBUILT=$NDK/toolchains/arm-linux-androideabi-$COMPILER_VERSION/prebuilt/$OS
CRT_BEGINOBJ="$PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/crtbegin.o $PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/crtend.o"
ANDROID_LIB_GCC="$PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/libgcc.a"
PLATFORM_VERSION=android-9
#build_amr
build_aac
#build_fribidi
#build_freetype2
#build_ass
build_ffmpeg
build_one

#x86
EABIARCH=i686-linux-android
ARCH=x86
ABI=x86
OPTIMIZE_CFLAGS="-m32"
COMPILER_VERSION=4.8
ANDROID_STL_LIB="$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/libs/$ABI"
ANDROID_INLCLUDES="$ANDROID_INCLUDES_BASE -I$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/include -I$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/libs/$ABI/include"
ANDROID_LIBS=$(pwd)/android-libs/$ABI/lib
PREFIX=../ffmpeg-build/x86
OUT_LIBRARY=$PREFIX/libffmpeg.so
ADDITIONAL_CONFIGURE_FLAG=--disable-asm
SONAME=libffmpeg.so
PREBUILT=$NDK/toolchains/x86-$COMPILER_VERSION/prebuilt/$OS
CRT_BEGINOBJ="$PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/crtbegin.o $PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/crtend.o"
PLATFORM_VERSION=android-9
#build_amr
#build_aac
#build_fribidi
#build_freetype2
#build_ass
#build_ffmpeg
#build_one

#mips
EABIARCH=mipsel-linux-android
ARCH=mips
ABI=mips
OPTIMIZE_CFLAGS="-EL -march=mips32 -mips32 -mhard-float"
COMPILER_VERSION=4.8
ANDROID_STL_LIB="$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/libs/$ABI"
ANDROID_INLCLUDES="$ANDROID_INCLUDES_BASE -I$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/include -I$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/libs/$ABI/include"
ANDROID_LIBS=$(pwd)/android-libs/$ABI/lib
PREFIX=../ffmpeg-build/mips
OUT_LIBRARY=$PREFIX/libffmpeg.so
ADDITIONAL_CONFIGURE_FLAG="--disable-mips32r2"
SONAME=libffmpeg.so
PREBUILT=$NDK/toolchains/mipsel-linux-android-$COMPILER_VERSION/prebuilt/$OS
CRT_BEGINOBJ="$PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/crtbegin.o $PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/crtend.o"
PLATFORM_VERSION=android-9
#build_amr
#build_aac
#build_fribidi
#build_freetype2
#build_ass
#build_ffmpeg
#build_one

#arm v7vfpv3
EABIARCH=arm-linux-androideabi
ARCH=arm
ABI=armeabi-v7a
CPU=armv7-a
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU "
COMPILER_VERSION=4.8
ANDROID_STL_LIB="$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/libs/$ABI"
ANDROID_INLCLUDES="$ANDROID_INCLUDES_BASE -I$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/include -I$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/libs/$ABI/include"
ANDROID_LIBS=$(pwd)/android-libs/$ABI/lib
PREFIX=../ffmpeg-build/armeabi-v7a
OUT_LIBRARY=$PREFIX/libffmpeg.so
ADDITIONAL_CONFIGURE_FLAG=
SONAME=libffmpeg.so
PREBUILT=$NDK/toolchains/arm-linux-androideabi-$COMPILER_VERSION/prebuilt/$OS
CRT_BEGINOBJ="$PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/armv7-a/crtbegin.o $PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/armv7-a/crtend.o"
ANDROID_LIB_GCC="$PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/armv7-a/libgcc.a"
PLATFORM_VERSION=android-9
#build_amr
build_aac
#build_fribidi
#build_freetype2
#build_ass
build_ffmpeg
build_one

#arm v7 + neon (neon also include vfpv3-32)
EABIARCH=arm-linux-androideabi
ARCH=arm
ABI=armeabi-v7a
CPU=armv7-a
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8 -mthumb -D__thumb__ "
COMPILER_VERSION=4.8
ANDROID_STL_LIB="$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/libs/$ABI"
ANDROID_INLCLUDES="$ANDROID_INCLUDES_BASE -I$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/include -I$NDK/sources/cxx-stl/gnu-libstdc++/$COMPILER_VERSION/libs/$ABI/include"
ANDROID_LIBS=$(pwd)/android-libs/$ABI/lib
PREFIX=../ffmpeg-build/armeabi-v7a-neon
OUT_LIBRARY=../ffmpeg-build/armeabi-v7a/libffmpeg-neon.so
ADDITIONAL_CONFIGURE_FLAG=--enable-neon
SONAME=libffmpeg-neon.so
PREBUILT=$NDK/toolchains/arm-linux-androideabi-$COMPILER_VERSION/prebuilt/$OS
CRT_BEGINOBJ="$PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/armv7-a/crtbegin.o $PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/armv7-a/crtend.o"
ANDROID_LIB_GCC="$PREBUILT/lib/gcc/$EABIARCH/$COMPILER_VERSION/armv7-a/libgcc.a"
PLATFORM_VERSION=android-9
#build_amr
build_aac
#build_fribidi
#build_freetype2
#build_ass
build_ffmpeg
build_one
