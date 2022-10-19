#!/usr/bin/env sh

if [ ! -x $ELVIS_REBAR3 ] && [ -z "$(command -v $ELVIS_REBAR3)" ]; then
    mkdir -p "$ELVIS_BUILD_DIR"
    echo "Downloading Rebar3 from: "$ELVIS_REBAR3_URL
    curl -sLfo "$ELVIS_BUILD_DIR/rebar3" "$ELVIS_REBAR3_URL"
    chmod +x "$ELVIS_BUILD_DIR/rebar3"
    "$ELVIS_BUILD_DIR/rebar3" $@
else
    echo "Using Rebar3: "$ELVIS_REBAR3
    "$ELVIS_REBAR3" $@
fi
