# Copyright 2023 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

QCOM_COMMON_PATH := device/qcom/common

ifeq ($(TARGET_BOARD_PLATFORM),)
$(error "TARGET_BOARD_PLATFORM is not defined yet, please define in your device makefile so it's accessible to QCOM common.")
endif

# List of QCOM targets.
MSMSTEPPE := sm6150
TRINKET := trinket

QCOM_BOARD_PLATFORMS += \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    bengal \
    crow \
    holi \
    kona \
    kalama \
    lahaina \
    lito \
    monaco \
    msm8937 \
    msm8953 \
    msm8996 \
    msm8998 \
    msmnile \
    parrot \
    sdm660 \
    sdm710 \
    sdm845 \
    taro

# List of targets that use video hardware.
MSM_VIDC_TARGET_LIST := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    kona \
    lito \
    msm8937 \
    msm8953 \
    msm8996 \
    msm8998 \
    msmnile \
    sdm660 \
    sdm710 \
    sdm845

ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19, $(TARGET_KERNEL_VERSION)))
# List of targets that use master side content protection.
MASTER_SIDE_CP_TARGET_LIST := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    bengal \
    kona \
    lito \
    msm8996 \
    msm8998 \
    msmnile \
    sdm660 \
    sdm710 \
    sdm845
endif

# Include QCOM board utilities.
include vendor/qcom/opensource/core-utils/build/utils.mk

6_1_FAMILY := \
    pineapple

# Kernel Families
5_15_FAMILY := \
    crow \
    kalama \
    monaco

5_10_FAMILY := \
    parrot \
    taro

5_4_FAMILY := \
    holi \
    lahaina

4_19_FAMILY := \
    bengal \
    kona \
    lito

4_14_FAMILY := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    msmnile

4_9_FAMILY := \
    msm8953 \
    qcs605 \
    sdm710 \
    sdm845

4_4_FAMILY := \
    msm8998 \
    sdm660

3_18_FAMILY := \
    msm8937 \
    msm8996

ifeq ($(call is-board-platform-in-list,$(6_1_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 6.1
QCOM_HARDWARE_VARIANT := sm8650
else ifeq ($(call is-board-platform-in-list,$(5_15_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.15
QCOM_HARDWARE_VARIANT := sm8550
else ifeq ($(call is-board-platform-in-list,$(5_10_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.10
QCOM_HARDWARE_VARIANT := sm8450
else ifeq ($(call is-board-platform-in-list,$(5_4_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.4
QCOM_HARDWARE_VARIANT := sm8350
else ifeq ($(call is-board-platform-in-list,$(4_19_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.19
QCOM_HARDWARE_VARIANT := sm8250
else ifeq ($(call is-board-platform-in-list,$(4_14_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.14
QCOM_HARDWARE_VARIANT := sm8150
else ifeq ($(call is-board-platform-in-list,$(4_9_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.9
QCOM_HARDWARE_VARIANT := sdm845
else ifeq ($(call is-board-platform-in-list,$(4_4_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.4
QCOM_HARDWARE_VARIANT := msm8998
else ifeq ($(call is-board-platform-in-list,$(3_18_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 3.18
QCOM_HARDWARE_VARIANT := msm8996
else
QCOM_HARDWARE_VARIANT := $(TARGET_BOARD_PLATFORM)
endif

ifeq ($(call is-board-platform-in-list,$(QCOM_BOARD_PLATFORMS)),true)
# Compatibility matrix
DEVICE_MATRIX_FILE += \
    hardware/qcom-caf/common/compatibility_matrix.xml

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix.xml

DEVICE_FRAMEWORK_MANIFEST_FILE += \
    device/qcom/qssi/framework_manifest.xml

# Opt out of 16K alignment changes
PRODUCT_MAX_PAGE_SIZE_SUPPORTED ?= 4096

# Components
include $(QCOM_COMMON_PATH)/components.mk

# Filesystem
TARGET_FS_CONFIG_GEN += $(QCOM_COMMON_PATH)/config.fs

# GPS
PRODUCT_PACKAGES += \
    libcurl

# Partition source order for Product/Build properties pickup.
PRODUCT_SYSTEM_PROPERTIES += \
    ro.product.property_source_order=odm,vendor,product,system_ext,system

# Power
ifneq ($(TARGET_PROVIDES_POWERHAL),true)
$(call inherit-product-if-exists, vendor/qcom/opensource/power/power-vendor-product.mk)
endif

# Public Libraries
PRODUCT_COPY_FILES += \
    device/qcom/qssi/public.libraries.product-qti.txt:$(TARGET_COPY_OUT_PRODUCT)/etc/public.libraries-qti.txt \
    device/qcom/qssi/public.libraries.system_ext-qti.txt:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/public.libraries-qti.txt

# SECCOMP Extensions
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/vendor/seccomp/codec2.software.ext.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.software.ext.policy \
    $(QCOM_COMMON_PATH)/vendor/seccomp/codec2.vendor.ext.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.vendor.ext.policy \
    $(QCOM_COMMON_PATH)/vendor/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    $(QCOM_COMMON_PATH)/vendor/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# Permissions
PRODUCT_COPY_FILES += \
    device/qcom/qssi/privapp-permissions-qti.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-qti.xml \
    device/qcom/qssi/privapp-permissions-qti-system-ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-qti-system-ext.xml \
    device/qcom/qssi/qti_whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/qti_whitelist.xml \
    device/qcom/qssi/qti_whitelist_system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/qti_whitelist_system_ext.xml


# QTI VNDK Framework detect
PRODUCT_PACKAGES += \
    libvndfwk_detect_jni.qti \
    libqti_vndfwk_detect \
    libvndfwk_detect_jni.qti.vendor \
    libqti_vndfwk_detect.vendor

# Trusted User Interface
PRODUCT_PACKAGES += \
    android.hidl.memory.block@1.0.vendor

# Vendor Service Manager
PRODUCT_PACKAGES += \
    vndservicemanager

# SoC
PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=QTI

# WiFi Display
PRODUCT_PACKAGES += \
    libwfdaac_vendor

endif # QCOM_BOARD_PLATFORMS
