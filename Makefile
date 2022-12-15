PROJECT = dosp
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.1.0

DEPS = cowboy
dep_cowboy_commit = 2.9.0

DEPS += mochiweb
dep_mochiweb_commit = main

DEP_PLUGINS = cowboy

BUILD_DEPS += relx
include erlang.mk
