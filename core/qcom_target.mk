# Target-specific configuration

define ril-set-path-variant
$(call project-set-path-variant,ril,TARGET_RIL_VARIANT,hardware/$(1))
endef
define wlan-set-path-variant
$(call project-set-path-variant,wlan,TARGET_WLAN_VARIANT,hardware/qcom/$(1))
endef

# Enable DirectTrack on QCOM legacy boards
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)

    qcom_flags := -DQCOM_HARDWARE
    qcom_flags += -DQCOM_BSP
    qcom_flags += -DQTI_BSP

    TARGET_USES_QCOM_BSP := true
    TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

    TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)
    CLANG_TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    CLANG_TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)

    # Multiarch needs these too..
    2ND_TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    2ND_TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)
    2ND_CLANG_TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    2ND_CLANG_TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)

    ifeq ($(TARGET_USES_QCOM_BSP),true)
        TARGET_GLOBAL_CFLAGS += -DQCOM_BSP
        TARGET_GLOBAL_CPPFLAGS += -DQCOM_BSP
    endif

    # Enable DirectTrack for legacy targets
    ifneq ($(filter caf caf-bfam legacy,$(TARGET_QCOM_AUDIO_VARIANT)),)
        ifeq ($(BOARD_USES_LEGACY_ALSA_AUDIO),true)
            TARGET_GLOBAL_CFLAGS += -DQCOM_DIRECTTRACK
            TARGET_GLOBAL_CPPFLAGS += -DQCOM_DIRECTTRACK
        endif
    endif
$(call wlan-set-path-variant,wlan-caf)
$(call ril-set-path-variant,ril)
else
$(call wlan-set-path-variant,wlan)
$(call ril-set-path-variant,ril)
endif
