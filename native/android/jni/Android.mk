LOCAL_PATH := $(call my-dir)
BULLET_PATH := $(LOCAL_PATH)/../../bullet-itself/bullet-read-only
ANE_PATH := $(LOCAL_PATH)/../../ios/BulletANE/BulletANE

### COPY FLASH RUNTIME ###

include $(CLEAR_VARS)
LOCAL_MODULE := FlashRuntime
LOCAL_SRC_FILES := FlashRuntimeExtensions.so
include $(PREBUILT_SHARED_LIBRARY)

##########################

include $(CLEAR_VARS)
LOCAL_MODULE    := bullet
LOCAL_C_INCLUDES := $(BULLET_PATH)/src $(BULLET_PATH)/src/include $(BULLET_PATH)/src/LinearMath \
                    $(BULLET_PATH)/src/BulletDynamics/Dynamics $(BULLET_PATH)/src/BulletDynamics/Character \
                    $(BULLET_PATH)/src/BulletDynamics/ConstraintSolver \
                    $(BULLET_PATH)/src/BulletCollision $(BULLET_PATH)/src/BulletCollision/BroadphaseCollision \
                    $(BULLET_PATH)/src/BulletCollision/CollisionDispatch \
                    $(BULLET_PATH)/src/BulletCollision/CollisionShapes \
                    $(BULLET_PATH)/src/BulletCollision/Gimpact \
                    $(BULLET_PATH)/src/BulletCollision/NarrowPhaseCollision \
                    $(ANE_PATH)
LOCAL_SRC_FILES := \
	$(subst $(LOCAL_PATH)/,, \
	    $(wildcard $(BULLET_PATH)/src/*.c) \
        $(wildcard $(BULLET_PATH)/src/LinearMath/*.cpp) \
        $(wildcard $(BULLET_PATH)/src/BulletDynamics/*.cpp) \
        $(wildcard $(BULLET_PATH)/src/BulletDynamics/Dynamics/*.cpp) \
        $(wildcard $(BULLET_PATH)/src/BulletDynamics/ConstraintSolver/*.cpp) \
        $(wildcard $(BULLET_PATH)/src/BulletDynamics/Character/*.cpp) \
        $(wildcard $(BULLET_PATH)/src/BulletCollision/BroadphaseCollision/*.cpp) \
        $(wildcard $(BULLET_PATH)/src/BulletCollision/CollisionDispatch/*.cpp) \
        $(wildcard $(BULLET_PATH)/src/BulletCollision/CollisionShapes/*.cpp) \
        $(wildcard $(BULLET_PATH)/src/BulletCollision/Gimpact/*.cpp) \
        $(wildcard $(BULLET_PATH)/src/BulletCollision/NarrowPhaseCollision/*.cpp) \
        $(wildcard $(ANE_PATH)/*.cpp) \
        $(wildcard $(ANE_PATH)/*.c) \
    )
LOCAL_LDLIBS := -lm -lGLESv2 -llog
LOCAL_CPPFLAGS += -frtti -fexceptions -O4
LOCAL_SHARED_LIBRARIES += FlashRuntime
LOCAL_CFLAGS := -O4
include $(BUILD_SHARED_LIBRARY)
