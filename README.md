# smartFRITZctl
Command line tools for accessing AVM FRITZ!Box devices.

[![Build Status](https://travis-ci.org/pi/smartFRITZctl.svg)](https://travis-ci.org/pi/smartFRITZctl)

### Configuration
    % ./smartFRITZctl --configure

### Home Automation
List all available devices:

    % ./smartFRITZctl --home-devices

Turn on electrical switch:

    % ./smartFRITZctl --home-switch-on <AIN>

Turn off electrical switch:

    % ./smartFRITZctl --home-switch-off <AIN>

Toggle electrical switch:

    % ./smartFRITZctl --home-switch-toggle <AIN>

