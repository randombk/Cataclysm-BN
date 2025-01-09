LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := main

SDL_PATH := ../SDL2

LOCAL_C_INCLUDES := $(LOCAL_PATH)/$(SDL_PATH)/include $(LOCAL_PATH)/lua $(LOCAL_PATH)/../sqlite3

LOCAL_CPP_FEATURES := exceptions rtti

# Add your application source files here...
FILE_LIST := $(wildcard $(LOCAL_PATH)/*.cpp)
LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%)

FILE_LIST_LUA := $(wildcard $(LOCAL_PATH)/lua/*.c)
LOCAL_SRC_FILES += $(FILE_LIST_LUA:$(LOCAL_PATH)/%=%)

# Add sqlite3 amalgamation source.
# Using precompiled binaries causes crashes on some devices, so build from source instead.

# From https://sqlite.org/android/file?name=sqlite3/src/main/jni/sqlite/Android.mk&ci=tip

# Enable SQLite extensions. (Not used by cata but included to match standard distributions)
LOCAL_CFLAGS += -DSQLITE_ENABLE_FTS5 
LOCAL_CFLAGS += -DSQLITE_ENABLE_RTREE
LOCAL_CFLAGS += -DSQLITE_ENABLE_FTS3
LOCAL_CFLAGS += -DSQLITE_ENABLE_BATCH_ATOMIC_WRITE

# This is important - it causes SQLite to use memory for temp files. Since 
# Android has no globally writable temp directory, if this is not defined the
# application throws an exception when it tries to create a temp file.
#
LOCAL_CFLAGS += -DSQLITE_TEMP_STORE=3

LOCAL_SRC_FILES += $(LOCAL_PATH)/../sqlite3/sqlite3.c

LOCAL_SHARED_LIBRARIES := libhidapi SDL2 SDL2_mixer SDL2_image SDL2_ttf mpg123

LOCAL_LDLIBS := -lGLESv1_CM -lGLESv2 -ldl -llog -lz

LOCAL_CFLAGS += -DTILES=1 -DSDL_SOUND=1 -DLUA=1 -DBACKTRACE=1 -Wextra -Wall -fsigned-char -ffast-math

LOCAL_LDFLAGS += $(LOCAL_CFLAGS)

include $(BUILD_SHARED_LIBRARY)
