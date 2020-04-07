###############################################################################
#
# Infrastructure for nested source archives with components that can be
# copied as-is to their destination.  It includes the generic-package
# infrastructure and inherits all of its features.
#
# This file implements an infrastructure that eases development of
# package .mk files for packages where the sources come in nested
# archives, and may contain directory trees that are to be copied to
# their destination as-is. Typically the latter includes prebuilt binary
# files, and no installation routines are provided by the source
# archive.
#
# User interface variables:
#
#   FOO_INNER_SRC
#   	A space-separated list of inner source archives that should be
#   	unpacked to FOO_INNER_SRC_DIR.
#
#   For trees that can be copied as-is to their destination, these
#   variables are available:
#
#   FOO_INNER_SRC_FOR_TARGET
#   	A space-separated list of inner source archives that should be
#   	installed as-is to the target dir.
#   	These are unpacked into FOO_FOR_TARGET_DIR.
#   FOO_INNER_SRC_FOR_STAGING
#   	A space-separated list of inner source archives that should be
#   	installed as-is to the staging dir.
#   	These are unpacked to FOO_FOR_STAGING_DIR.
#   FOO_INNER_SRC_FOR_HOST
#   	A space-separated list of inner source archives that should be
#   	installed as-is to the host dir.
#   	These are unpacked to FOO_FOR_HOST_DIR.
#
#   All pathnames of the inner archives above are relative to
#   FOO_INNER_SRC_PREFIX, which is empty by default.
#
#   FOO_OUTER_SRC_EXTRACT
#       The list of outer archive members to be extracted. By default,
#       only the inner archives FOO_INNER_SRC* are extracted from the
#       outer archive. Define FOO_OUTER_SRC_EXTRACT to override this.
#       If you do, take care to include the FOO_INNER_SRC* members.
#       These are unpacked to FOO_OUTER_SRC_DIR.
#
#   FOO_OUTER_SRC_EXTRACT_EXTRA
#       An optional list of outer archive members to be extracted in
#       addition to those listed in FOO_OUTER_SRC_EXTRACT. By default
#       empty. Differs from FOO_OUTER_SRC_EXTRACT only in that files
#       listed here are unpacked to FOO_DIR. Helpful for license files,
#       which are often contained in the outer archive.
#
#   FOO_OUTER_SRC_DIR
#   	The directory the outer source archive is unpacked in.
#   	Default: FOO_DIR/_unpacked_outer_src
#
# Note that FOO_EXCLUDES and FOO_STRIP_COMPONENTS are applied to inner
# archives.
#
# User interface functions:
#
#   FOO_EXTRACT_OUTER_CMDS
#   	Extracts the archive members FOO_OUTER_SRC_EXTRACT from
#   	the outer archive FOO_SRC to FOO_OUTER_SRC_DIR.
#   	Example of use: $(FOO_EXTRACT_OUTER_CMDS)
#   FOO_EXTRACT_INNER_CMDS
#   	Extracts all inner archives FOO_INNER_SRC*.
#   	Example of use: $(FOO_EXTRACT_INNER_CMDS)
#
#   Convenience defaults:
#
#   FOO_EXTRACT_CMDS
#   	Unless defined by the package makefile, this defaults to
#   	  $(FOO_EXTRACT_OUTER_CMDS)
#   	  $(FOO_EXTRACT_INNER_CMDS)
#   FOO_INSTALL_TARGET_CMDS
#   	Unless defined by the package makefile, this defaults to
#   	  $(FOO_INSTALL_FOR_TARGET_CMDS)
#   FOO_INSTALL_STAGING_CMDS
#   	Unless defined by the package makefile, this defaults to
#   	  $(FOO_INSTALL_FOR_STAGING_CMDS)
#   HOST_FOO_INSTALL_CMDS
#   	Unless defined by the package makefile, this defaults to
#   	  $(FOO_INSTALL_FOR_HOST_CMDS)
#
###############################################################################

################################################################################
# prebuilt-nested-package-real
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################
define prebuilt-nested-package-real

$(2)_OUTER_SRC_DIR   ?= $$($(2)_DIR)/_unpacked_outer_src
$(2)_FOR_TARGET_DIR  ?= $$($(2)_DIR)/_for_target
$(2)_FOR_STAGING_DIR ?= $$($(2)_DIR)/_for_staging
$(2)_FOR_HOST_DIR    ?= $$($(2)_DIR)/_for_host

$(2)_OUTER_SRC_EXTRACT ?= $$(addprefix $$($(2)_INNER_SRC_PREFIX), \
	$$($(2)_INNER_SRC) $$($(2)_INNER_SRC_FOR_TARGET) \
	$$($(2)_INNER_SRC_FOR_STAGING) $$($(2)_INNER_SRC_FOR_HOST))

define $(2)_EXTRACT_OUTER_TO_CMDS
	$$(if $$(1),
		mkdir -p $$(2)
		$$(call suitable-extractor,$$($(2)_SOURCE)) $$(DL_DIR)/$$($(2)_SOURCE) | \
			$(TAR) -C $$(2) $$(TAR_OPTIONS) - $$(sort $$(1))
	)
endef

define $(2)_EXTRACT_OUTER_CMDS
	$$(call $(2)_EXTRACT_OUTER_TO_CMDS,$$($(2)_OUTER_SRC_EXTRACT),$$($(2)_OUTER_SRC_DIR))
	$$(call $(2)_EXTRACT_OUTER_TO_CMDS,$$($(2)_OUTER_SRC_EXTRACT_EXTRA),$$($(2)_DIR))
endef

define $(2)_EXTRACT_INNER_TO_CMDS
	$$(if $$(1),
		mkdir -p $$(2)
		$$(foreach p,$$(1),$$(call suitable-extractor,$$(p)) $$($(2)_OUTER_SRC_DIR)/$$($(2)_INNER_SRC_PREFIX)/$$(p) | \
			$$(TAR) --strip-components=$$($(2)_STRIP_COMPONENTS) \
				-C $$(2) \
				$$(foreach x,$$($(2)_EXCLUDES),--exclude='$$(x)' ) \
				$$(TAR_OPTIONS) - $$(sep))
	)
endef

define $(2)_EXTRACT_INNER_CMDS
	$$(call $(2)_EXTRACT_INNER_TO_CMDS,$$($(2)_INNER_SRC),$$($(2)_DIR))
	$$(call $(2)_EXTRACT_INNER_TO_CMDS,$$($(2)_INNER_SRC_FOR_TARGET),$$($(2)_FOR_TARGET_DIR))
	$$(call $(2)_EXTRACT_INNER_TO_CMDS,$$($(2)_INNER_SRC_FOR_STAGING),$$($(2)_FOR_STAGING_DIR))
	$$(call $(2)_EXTRACT_INNER_TO_CMDS,$$($(2)_INNER_SRC_FOR_HOST),$$($(2)_FOR_HOST_DIR))
endef

ifeq ($$(origin $(2)_EXTRACT_CMDS), undefined)
define $(2)_EXTRACT_CMDS
	$$($(2)_EXTRACT_OUTER_CMDS)
	$$($(2)_EXTRACT_INNER_CMDS)
endef
endif

define $(1)-copy-tree-to
	cd $$(1) && find . -print0 | cpio --quiet -p0dum $$(2)
endef

ifeq ($(4),target)
ifneq ($$($(2)_INNER_SRC_FOR_TARGET),)
$(2)_INSTALL_FOR_TARGET_CMDS = \
	$$(call $(1)-copy-tree-to,$$($(2)_FOR_TARGET_DIR),$$(TARGET_DIR))
endif
ifneq ($$($(2)_INNER_SRC_FOR_STAGING),)
$(2)_INSTALL_FOR_STAGING_CMDS = \
	$$(call $(1)-copy-tree-to,$$($(2)_FOR_STAGING_DIR),$$(STAGING_DIR))
endif
$(2)_INSTALL_TARGET_CMDS  ?= $$($(2)_INSTALL_FOR_TARGET_CMDS)
$(2)_INSTALL_STAGING_CMDS ?= $$($(2)_INSTALL_FOR_STAGING_CMDS)
else
ifneq ($$($(2)_INNER_SRC_FOR_HOST),)
$(2)_INSTALL_FOR_HOST_CMDS = \
	$$(call $(1)-copy-tree-to,$$($(2)_FOR_HOST_DIR),$$(HOST_DIR))
endif
$(2)_INSTALL_CMDS         ?= $$($(2)_INSTALL_FOR_HOST_CMDS)
endif

$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef
# End-of prebuilt-nested-package-real

prebuilt-nested-package = $(call prebuilt-nested-package-real,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
host-prebuilt-nested-package = $(call prebuilt-nested-package-real,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)
