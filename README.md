# elvis.mk
3rd party erlang.mk plug-in for Elvis

## Contact Us
If you find any **bugs** or have a **problem** while using this library, please
[open an issue](https://github.com/inaka/elvis.mk/issues/new) in this repo
(or a pull request :)).

And you can check all of our open-source projects at [inaka.github.io](http://inaka.github.io).

## Usage

In order to include this plugin in your project you just need to add the
following in your Makefile:

```make
BUILD_DEPS = elvis_mk

dep_elvis_mk = git https://github.com/inaka/elvis.mk.git 1.1.1

DEP_PLUGINS = elvis_mk
```
## Extra config

- `ELVIS_VERSION` - the Elvis version to build and use
  - defaults to `1.1.0`
  - the version must be a tag in the [Elvis repo](https://github.com/inaka/elvis)
  - that Elvis version must compile with the installed Erlang / OTP
  - don't forget to do `make distclean-elvis` after changing the version
- `ELVIS_REBAR3` - path to the Rebar3 executable to build Elvis with
  - defaults to `rebar3`
  - if this command is not found Rebar 3 will be downloaded from `ELVIS_REBAR3_URL`
- `ELVIS_REBAR3_URL`
  - defaults to `https://s3.amazonaws.com/rebar3/rebar3`

For even more extras use the force, [read the source](plugins.mk).

## Help

Run `make help` in order to check what targets are available for
`elvis.mk`.

## Example

For example you can run `make elvis`:

```make
Loading files...
Loading src/your_module.erl
Applying rules...
# src/your_module.erl [FAIL]
  - operator_spaces
    - Missing space after "," on line 27
Loading files...
Loading Makefile
Applying rules...
# Makefile [OK]
Loading files...
Loading elvis.config
Applying rules...
# elvis.config [OK]
make: *** [elvis] Error 1
```
