#!/bin/bash

set -e;

set -x;

xcodebuild test -destination "name=iPhone 6"  -scheme "SwiftRestful iOS" && \
xcodebuild test -destination "name=Apple TV" -scheme "SwiftRestful tvOS" && \
xcodebuild test -destination "platform=OS X" -scheme "SwiftRestful macOS"
