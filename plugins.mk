# Copyright (c) 2015, Erlang Solutions Ltd.
# This file is part of erlang.mk and subject to the terms of the ISC License.

.PHONY: elvis distclean-elvis

# Configuration.
ELVIS_VERSION ?= 4.1.1
ELVIS_CONFIG ?= $(CURDIR)/elvis.config

ELVIS ?= $(CURDIR)/elvis
export ELVIS

ELVIS_URL ?= https://github.com/inaka/elvis/archive/refs/tags/$(ELVIS_VERSION).tar.gz
ELVIS_OPTS ?=
ELVIS_BUILD_DIR ?= $(CURDIR)/_build
ELVIS_CODE_ARCHIVE = $(ELVIS_VERSION).tar.gz

ELVIS_REBAR3_URL ?= https://s3.amazonaws.com/rebar3/rebar3
ELVIS_REBAR3 ?= rebar3

# Core targets.

help::
	$(verbose) printf "%s\n" "" \
		"Elvis targets:" \
		"  elvis       Run Elvis using the local elvis.config or download the default otherwise"

distclean:: distclean-elvis

MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Plugin-specific targets.

$(ELVIS):
	$(verbose) mkdir -p $(ELVIS_BUILD_DIR)
	$(verbose) echo "Downloading Elvis from: "$(ELVIS_URL)
	$(verbose) $(call core_http_get,$(ELVIS_BUILD_DIR)/$(ELVIS_CODE_ARCHIVE),$(ELVIS_URL))
	$(verbose) cd $(ELVIS_BUILD_DIR) && \
		tar -xzf $(ELVIS_CODE_ARCHIVE) && \
		cd elvis-$(ELVIS_VERSION) && \
		export ELVIS_BUILD_DIR=$(ELVIS_BUILD_DIR) && \
		export ELVIS_REBAR3_URL=$(ELVIS_REBAR3_URL) && \
		export ELVIS_REBAR3=$(ELVIS_REBAR3) && \
		$(MAKEFILE_DIR)/rebar3.sh escriptize
	$(gen_verbose) cp $(ELVIS_BUILD_DIR)/elvis-$(ELVIS_VERSION)/_build/default/bin/elvis $(ELVIS)
	$(gen_verbose) [ -e $(ELVIS_CONFIG) ] || \
		cp -n $(ELVIS_BUILD_DIR)/elvis-$(ELVIS_VERSION)/elvis.config $(ELVIS_CONFIG)
	$(verbose) chmod +x $(ELVIS)
	$(verbose) rm -rf $(ELVIS_BUILD_DIR)/elvis-$(ELVIS_VERSION)
	$(verbose) rm $(ELVIS_BUILD_DIR)/$(ELVIS_CODE_ARCHIVE)
	$(verbose) rm -f $(ELVIS_BUILD_DIR)/rebar3
	$(verbose) find $(ELVIS_BUILD_DIR) -maxdepth 0 -empty -exec rmdir "{}" ";"

elvis: $(ELVIS)
	$(verbose) $(ELVIS) rock -c $(ELVIS_CONFIG) $(ELVIS_OPTS)

distclean-elvis:
	$(gen_verbose) rm -rf $(ELVIS)
