# If linux src is local, try to generate commit-info
define linux-get-local-scmversion
	cd $(LINUX_DIR) && \
	rm -f .scmversion && \
	./scripts/setlocalversion --save-scmversion $(SRCDIR)
endef
LINUX_POST_RSYNC_HOOKS += linux-get-local-scmversion

# For builds with non-local sources, setup .scmversion before building
# so that we get a nice kernel release string that's visible with
# uname(1)
define linux-get-scmversion
	if ! test -f $(LINUX_DIR)/.scmversion; then \
		cd $(LINUX_DIR) && \
		commit=$$(awk 'NR == 1 && $$1 ~ /^[[:xdigit:]]{40}$$/ {print $$1}' \
			git-export.commit 2>/dev/null); \
		if test -n "$${commit}"; then \
			printf "%s%.7s\n" -g "$${commit}" > .scmversion; \
		else \
			echo "No Linux commit info available."; \
		fi; \
	fi
endef
LINUX_PRE_CONFIGURE_HOOKS += linux-get-scmversion

# We want the version info in /etc/os-release on the target, but the
# main buildroot Makefile stomps over /etc/os-release when "finalizing"
# the target.  So, install the version info into a temporary file where
# it can later be copied to /etc/os-release by a post-build script.
define linux-install-commit-info
	if test -f $(BUILD_DIR)/os-release.ad; then \
		sed -i /^AD_LINUX_VERSION=/d $(BUILD_DIR)/os-release.ad; \
	fi
	printf '%s="%s"\n' >> $(BUILD_DIR)/os-release.ad \
		AD_LINUX_VERSION \
		$$(cat $(LINUX_DIR)/include/config/kernel.release 2>/dev/null)
endef
LINUX_POST_INSTALL_TARGET_HOOKS += linux-install-commit-info
