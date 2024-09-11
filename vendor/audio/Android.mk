LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.audio.service_64_override
LOCAL_MODULE_TAGS := optional
PACKAGES.$(LOCAL_MODULE).OVERRIDES := android.hardware.audio.service_64.rc
include $(BUILD_PHONY_PACKAGE)