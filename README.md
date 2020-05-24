****

![Nettsi corporate logo.png][nettsi-logo]

****

# NETTSI C++ Project Boilerplate

> `(codename: HADOUKEN)`

## Table of contents

- [NETTSI C++ Project Boilerplate](#nettsi-c-project-boilerplate)
  - [Table of contents](#table-of-contents)
  - [Preface](#preface)
  - [Author](#author)
  - [Getting started](#getting-started)
    - [Installing `hadouken` to a project](#installing-hadouken-to-a-project)
  - [Updating the boilerplate](#updating-the-boilerplate)
  - [Boilerplate manual](#boilerplate-manual)
    - [Development environment container](#development-environment-container)
      - [Installing project-specific tools to development environment container](#installing-project-specific-tools-to-development-environment-container)
        - [Method 1: Using .hadouken.bootstrap.sh](#method-1-using-hadoukenbootstrapsh)
        - [Method 2: Using .hadouken.docker-compose.extend.yml](#method-2-using-hadoukendocker-composeextendyml)
    - [Hey, wait a second, what about git?](#hey-wait-a-second-what-about-git)
    - [Tool integration modules](#tool-integration-modules)
      - [ClangFormat](#clangformat)
      - [ClangTidy](#clangtidy)
      - [CppCheck](#cppcheck)
      - [GCov/LCov](#gcovlcov)
      - [GoogleTest/GoogleMock](#googletestgooglemock)
      - [IncludeWhatYouUse (IWYU)](#includewhatyouuse-iwyu)
      - [LinkWhatYouUse (LWYU)](#linkwhatyouuse-lwyu)
      - [CCache](#ccache)
    - [Helpers](#helpers)
      - [AutoCompilationUnit](#autocompilationunit)
      - [AutoTarget](#autotarget)
        - [TYPE (required)](#type-required)
          - [EXECUTABLE](#executable)
          - [STATIC](#static)
          - [SHARED](#shared)
          - [UNIT_TEST](#unittest)
          - [INTERFACE](#interface)
          - [BENCHMARK](#benchmark)
        - [LINK (optional)](#link-optional)
        - [COMPILE_OPTIONS (optional)](#compileoptions-optional)
        - [COMPILE_DEFINITIONS (optional)](#compiledefinitions-optional)
        - [DEPENDS (optional)](#depends-optional)
        - [NAME (optional)](#name-optional)
        - [PREFIX (optional)](#prefix-optional)
        - [SUFFIX (optional)](#suffix-optional)
        - [INCLUDES (optional)](#includes-optional)
        - [PARTOF (optional)](#partof-optional)
        - [SOURCES (optional)](#sources-optional)
        - [HEADERS (optional)](#headers-optional)
        - [WITH_COVERAGE (optional)](#withcoverage-optional)
        - [EXPOSE_PROJECT_METADATA (optional)](#exposeprojectmetadata-optional)
        - [PROJECT_METADATA_PREFIX (optional)](#projectmetadataprefix-optional)
        - [NO_AUTO_COMPILATION_UNIT (optional)](#noautocompilationunit-optional)
      - [Git](#git)
        - [git_get_branch_name(DIRECTORY \<dir\>)](#gitgetbranchnamedirectory-dir)
        - [git_get_head_commit_hash(DIRECTORY \<dir\>)](#gitgetheadcommithashdirectory-dir)
        - [git_is_worktree_dirty(DIRECTORY \<dir\>)](#gitisworktreedirtydirectory-dir)
        - [git_get_config(DIRECTORY \<dir\> CONFIG_KEY \<key_to_be_retrieved\>)](#gitgetconfigdirectory-dir-configkey-keytoberetrieved)
        - [git_print_status()](#gitprintstatus)
      - [Conan](#conan)
      - [HardwareConcurrency](#hardwareconcurrency)
    - [Build variant determination](#build-variant-determination)
    - [Finders](#finders)
    - [Feature check](#feature-check)
  - [Closing words](#closing-words)
  - [References](#references)
  - [Acknowledgements](#acknowledgements)
  - [License](#license)

## Preface

`Hadouken` contains common boilerplate code between all C++ projects being developed/will be developed in NETTSI.

This guide will navigate you through the boilerplate's all features and how to use it.

****

## Author

Mustafa Kemal GILOR, Chief Software Architect (<mgilor@nettsi.com>)

****

## Getting started

Hadouken is a CMake- Bash shell script project which is created to resolve three most common problems in C++ projects, eg. tool integration, dependency resolution and environment consistency.

The name `hadouken` comes from the Street Fighter hero, Ryu's iconic fight move. It's simple, powerful and super effective against the common enemies of C++ projects. Just hadouken away all of your problems! ;)

![Ryu doing hadouken.jpg][hadouken]

Hadouken is very easy to install. You can integrate it with your project in matter of seconds. Pre-requirements for the hadouken are minimal. In order to be able to use `hadouken` in a project, the project has to be version controlled in `Git`, and the project must be a `CMake` project. There are no requirements other than that.

### Installing `hadouken` to a project

You're lucky, I've prepared a video guide illustrating this. Check out [Video tutorial: How to install hadouken on new projects?](https://gitlab.nettsi.com/internal-projects/video-tutorials/-/tree/master/hadouken) to watch it.

Hadouken is designed as to be a git submodule. First, you need to add it as a submodule to your existing git project. In order to do that, issue following command at your git project root:

```bash
    git submodule add -b master git@gitlab.nettsi.com:internal-projects/cpp-project-boilerplate.git boilerplate
```

This will add boilerplate project to your project, to boilerplate folder. `master` branch will be tracked by default. After this, run following command from terminal in your project root. The name for the submodule has to be `boilerplate`. After adding the submodule, invoke the following command at project root to setup boilerplate to your project:

```bash
    bash boilerplate/script/setup.sh
```

After running the script, your project root should have the following symbolic links, mapped to the boilerplate content:

```none
    .gitignore -> boilerplate/.gitignore
    .gitconfig -> boilerplate/.gitconfig
    .clang-format -> boilerplate/.clang-format
    .clang-tidy -> boilerplate/.clang-tidy
    .cppcheck-suppress -> boilerplate/.cppcheck-suppress
    .devcontainer -> boilerplate/.devcontainer
    .vscode -> boilerplate/.vscode
    hadouken -> boilerplate/script/hadouken.sh
```

The following hidden file(s) will be added to your project root:

```bash
.hadouken.docker-compose.extend.yml # docker-compose extension file
.hadouken-bootstrap.sh              # container post-installation script
```

If any of the file(s) specified above already exist on project root, they will not be overridden.

****

## Updating the boilerplate

Hadouken project will be separately maintained, and there will be updates. In order to update the hadouken to latest stable release, issue the following command from your project's root directory:

```bash
    ./hadouken --upgrade
```

This will upgrade the hadouken submodule from remote `master` branch. If you have done changes to your local copy of hadouken, this command will respect to that. In order to force the upgrade, add `--force` parameter to upgrade command.

```bash
    ./hadouken --upgrade --force
```

## Boilerplate manual

In this section we will cover what hadouken offers and how to use them.

### Development environment container

`Hadouken` offers a docker based development environment container, which features all neccessary utilities to satisfy the prerequisites of features offered by `Hadouken`.

The container is designed to be used with `Visual Studio Code - Remote - Containers` extension.  If you are not an Visual Studio Code user, you can still use the container manually.

While running on VSCode with `Remote - Containers` extension, the extension will automatically recognize the `Dockerfile` and `devcontainer.json` files located in `.devcontainer` folder.

![Remote-Containers notification box][vscode-docker-1]

If that is not the case, you can still open your project in development container by pressing F1 (or Ctrl + Shift + P) and selecting `Remote-Containers: Reopen in Container` menu item.

![Remote-Containers: Reopen in container][vscode-docker-2]

This will open the project in development container. In first time, the extension will automatically build the docker image from the `Dockerfile` and then install a VSCode Server equipped with extensions specified in `devcontainer.json` file. This may take a while.

To go back to local environment, select `Remote-Containers: Reopen Locally` menu item.  

Development environment is based on Debian Sid, and contains the following tools and utilities;

- Version Control System (git)
- GCC Toolchain (gcc-10, gdb)
- LLVM Toolchain (llvm-10, lldb-10, clang-10, clangd)
- Build System Utilities (make, ninja-build, autoconf, automake, libtool, m4, cmake)
- Static Analysis, Formatting, Linting, Diagnotics (clang-format-10 clang-tidy-10 iwyu cppcheck valgrind ccache)
- Unit Testing, Benchmarking (libgtest-dev, libgmock-dev)
- Code Coverage Analysis (lcov, gcovr)
- Documentation (doxygen, doxygen-doc, doxygen-latex, doxygen-doxyparse, graphviz)

#### Installing project-specific tools to development environment container

##### Method 1: Using .hadouken.bootstrap.sh

It is possible to run post-install commands in development environment container. To do that, edit the script file named `.hadouken.bootstrap.sh` at project root directory. This script file will be run when development environment container is built for first time.

 > ![exclamation-mark] You can use `apt` or `pip` to install the packages you desire. As a rule of thumb, always check whether the third party dependency is available as conan package. If so, use conan to satisfy your project's dependency.

```bash
# Project requires boost, so install it.
apt install libboost-all-dev
```

If you already built the development environment container, the container is needed to be rebuilt in order to reflect the changes. To do that, Press F1 and type `Remote-Containers: Rebuild Container` and press Enter. This will re-create the container from scratch.

##### Method 2: Using .hadouken.docker-compose.extend.yml

You can extend base `docker-compose.yml` file to add more functionality, and even more images.

### Hey, wait a second, what about git?

I asked the similar question myself and was going to implement a mechanism that exposes local git configuration and credentials to docker image, but realized that VSCode remote containers extension already does that. You can work with `git` as if you are on your local machine.

### Tool integration modules

Boilerplate provides several modules to help with external tool integration and ease of use. All tools are included in `devenv` container, so skip any installation related stuff if you are using the `devenv` container.

`<project_name>` is capitalized and non-alphanumeric characters replaced (with an underscore) version of top level project name. The term `top level` here refers to the cmake project declaration prior to hadouken module inclusion.

#### ClangFormat

Controlled by `<project_name>_TOOLCONF_USE_CLANG_FORMAT` option.

Locate `clang-format*` in environment, if available. The status will be printed to the stdout.

This feature requires at least clang-format version 10 to be present in environment.

```cmake
project(my-awesome-project)                             # Declare a new project
set(my-awesome-project_TOOLCONF_USE_CLANG_FORMAT TRUE)  # Locate clang-format and use it if available.
include(boilerplate/Hadouken.cmake)        # Use hadouken
# ClangFormat module will try to locate the clang-format executable.
# If clang-format executable is found, each target created via `make_target` function call will have an additional
# target suffixed with `.format`, which will format the target's source code when invoked.
# This `.format' target will use `.clang-format` file located in project root, which will be a symbolic link to
# hadouken project's `.clang-format` file when not specified explicitly. Hadouken's `.clang-format` file will
# format the source code according to NETTSI C++ Code Standards.
```

You can install `clang-format` by getting the desired revision of llvm project (clang-format is a part of it) <https://github.com/llvm/llvm-project> or you can get from you package manager.

Ubuntu/Debian

```bash
    sudo apt-get update
    sudo apt-get install clang-format
```

#### ClangTidy

Controlled by `<project_name>_TOOLCONF_USE_CLANG_TIDY` option.

Locate `clang-tidy*` in environment, if available. The status will be printed to the stdout.

This feature requires at least clang-format version 10 to be present in environment.

```cmake
project(my-awesome-project)                             # Declare a new project
set(my-awesome-project_TOOLCONF_USE_CLANG_TIDY TRUE)    # Locate clang-format and use it if available.
include(boilerplate/Hadouken.cmake)        # Use hadouken
# ClangTidy module will try to locate the clang-format executable.
# If clang-tidy executable is found, each target created via `make_target` function call will have an additional
# target suffixed with `.tidy`, which will tidy/lint the target's source code when invoked.
# This `.tidy' target will use `.clang-tidy` file located in project root, which will be a symbolic link to
# hadouken project's `.clang-tidy` file when not specified explicitly. Hadouken's `.clang-tidy` file will
# tidy/lint the source code according to NETTSI C++ Code Standards.
```

You can install `clang-tidy` by getting the desired revision of llvm project (clang-tidy is a part of it) <https://github.com/llvm/llvm-project> or you can get from you package manager.

Ubuntu/Debian

```bash
    sudo apt-get update
    sudo apt-get install clang-tidy
```

> ![Exclamation mark][exclamation-mark] If you are using `vscode` for development, you can install the `vscode-clangd` extension in order to be able to apply quick fixes suggested by the `clang-tidy`. `vscode-clangd` requires clang language server `clangd` to be availabe in your environment. You will need to install `clangd` separately.
>  
> For distros with apt based package managers:
>  
```bash
    sudo apt-get install clangd
```

#### CppCheck

Controlled by `<project_name>_TOOLCONF_USE_CPPCHECK` option.

Locate `cppcheck` in environment, if available. The status will be printed to the stdout.

As CMake officially supports cppcheck, 'CMAKE_CXX_CPPCHECK' variable will be set accordingly and CMake will trigger cppcheck on every source file build.

```cmake
project(my-awesome-project)                             # Declare a new project
set(my-awesome-project_TOOLCONF_USE_CPPCHECK TRUE)      # Locate cppcheck and use it if available.
include(boilerplate/Hadouken.cmake)        # Use hadouken
# No further action is required.
```

You can install `cppcheck` either by downloading it from the official site <http://cppcheck.sourceforge.net/#download> or you can get from you package manager.

Ubuntu/Debian

```bash
    sudo apt-get update
    sudo apt-get install cppcheck
```

#### GCov/LCov

Controlled by `<project_name>_TOOLCONF_USE_GCOV`, `<project_name>_TOOLCONF_USE_LCOV`, `<project_name>_TOOLCONF_USE_GCOVR` options.

Locate `gcov & lcov` in environment, if available. The status will be printed to stdout.

Code coverage is enabled per target basis. To enable code coverage target creation for a target, pass `WITH_COVERAGE` argument to `make_target` function. `WITH_COVERAGE` will cause `make_target` to create a new target named `<target_name>.lcov` (when lcov enabled and present) and `<target_name>.gcovr.xml,  <target_name>.gcovr.html` (when gcovr enabled and present) which runs code coverage analysis and generates code coverage report when run.

```cmake
project(my-awesome-project)                              # Declare a new project
set(my-awesome-project_TOOLCONF_USE_GCOV TRUE)           # Locate gcov and use it if available.
set(my-awesome-project_TOOLCONF_USE_LCOV TRUE)           # Locate lcov and use it if available.
set(my-awesome-project_TOOLCONF_USE_GCOVR TRUE)          # Locate gcovr and use it if available.
include(boilerplate/Hadouken.cmake)                      # Use hadouken

make_target(TYPE UNIT_TEST WITH_COVERAGE)
# Creates an unit test named my-awesome-project and my-awesome-project.cov coverage target.
```

You can install `gcov, lcov, gcovr` either by downloading it from their respective official sites <http://cppcheck.sourceforge.net/#download> or you can get from you package manager.

Ubuntu/Debian

```bash
    sudo apt-get update
    sudo apt-get install gcov lcov gcovr
```

Example code coverage output of an unit test is shown below(gcovr/html):
![Gcov result report][gcovr-report]

#### GoogleTest/GoogleMock

Controlled by `<project_name>_TOOLCONF_USE_GOOGLE_TEST` variable.

Locate google test & google mock in environment, if available. The status will be printed to stdout.

Helper will create a target named `<project_name>.test` which includes google test & google mock header and libraries. You can link against this target in order to create an unit test.

If you are using `make_target`, the created target will be automatically linked against the test target.

```cmake
project(my-awesome-project)
set(my-awesome-project_TOOLCONF_USE_GOOGLE_TEST TRUE)
include(boilerplate/Hadouken.cmake)        # Use hadouken
# A target named `my-awesome-project.test` will be created if google test & google mock
# are found in environment. Failure to do so results in CMake configure step failure.
```

You can install `gtest/gmock` either by downloading it from the official site <https://github.com/google/googletest/releases> or you can get from you package manager.

Ubuntu/Debian

```bash
    sudo apt-get update
    sudo apt-get install libgtest-dev libgmock-dev
```

#### IncludeWhatYouUse (IWYU)

Controlled by `<project_name>_TOOLCONF_USE_IWYU` option.

Locate `include what you use` in environment, if available. The status will be printed to stdout.

As CMake officially supports `iwyu`, `CMAKE_CXX_INCLUDE_WHAT_YOU_USE` variable will be set accordingly and CMake will trigger iwyu on every source file build.

```cmake
project(my-awesome-project)                             # Declare a new project
set(my-awesome-project_TOOLCONF_USE_IWYU TRUE)          # Locate iwyu and use it if available.
include(boilerplate/Hadouken.cmake)        # Use hadouken
# No further action is required.
```

You can install `iwyu` either by downloading it from the official site <https://include-what-you-use.org/downloads/> or you can get from you package manager.

Ubuntu/Debian

```bash
    sudo apt-get update
    sudo apt-get install iwyu
```

`iwyu` functions on specific clang version, so you also need to install that version. To determine which version is required, issue following command from the terminal;

```bash
    iwyu --version
    // Example output:
    // include-what-you-use 0.12 based on clang version 9.0.1-2
```

In the scenario above, we would need to install `clang-9`.

#### LinkWhatYouUse (LWYU)

Controlled by `<project_name>_TOOLCONF_USE_LWYU` option.

Link what you use requires no external tools. Standard toolchain linker will be used to perform this functionality.

As CMake officially supports `lwyu`, `CMAKE_LINK_WHAT_YOU_USE` variable will be set accordingly and CMake will trigger lwyu on every link action.

```cmake
project(my-awesome-project)                             # Declare a new project
set(my-awesome-project_TOOLCONF_USE_LWYU TRUE)          # Locate iwyu and use it if available.
include(boilerplate/Hadouken.cmake)        # Use hadouken
# No further action is required.
```

No extra tools required for this functionality besides the toolchain linker you are using.

#### CCache

Controlled by `<project_name>_TOOLCONF_USE_CCACHE` option.

Locate `ccache` in environment, if available. The status will be printed to the stdout.

CCache speeds up compilation times by caching the compilation artifacts, and reusing them on scenarios when re-compilation would produce the exact same artifact.

```cmake
project(my-awesome-project)                             # Declare a new project
set(my-awesome-project_TOOLCONF_USE_CCACHE TRUE)        # Locate ccache and use it if available.
include(boilerplate/Hadouken.cmake)        # Use hadouken
# No further action is required.
```

You can install ccache either by downloading it from the official site <https://ccache.dev/download.html> or you can get from you package manager.

Ubuntu/Debian

```bash
    sudo apt-get update
    sudo apt-get install ccache
```

### Helpers

Helper modules are wrappers which are used commonly in CMake based projects.

#### AutoCompilationUnit

A CMake helper module to gather the files which will be compiled for the project. Requires project folder to be structured in `include/` `src/` form. To gather compilation unit of a project, simply invoke `file_gather_compilation_unit` function at project scope. This will define 3 CMake variables in project scope.

```CMake
    ${HEADERS} # Content of the include/ folder. Paths are relative to include/ folder.
    ${SOURCES} # Content of the src/ folder. Paths are relative to src/ folder.
    ${COMPILATION_UNIT} # Content of the both include/ and src/ folders.
```

#### AutoTarget

A CMake helper module to create several CMake target types with less typing. To create a target using AutoTarget, simply invoke `make_target` function with desired arguments. The `make_target` function operates on projects, so it must be invoked after `project()` CMake command is invoked for the desired project.

All arguments are optional, except the `TYPE` argument.

The created target's compilation unit will be automatically gathered using AutoCompilationUnit module, so the project must be structured accordingly. Otherwise, you have to specify source and header files manually by populating `SOURCES` and `HEADERS` arguments.

```cmake

    make_target(TYPE <EXECUTABLE|STATIC|SHARED|UNIT_TEST|INTERFACE|BENCHMARK>
                [LINK [<target_name|library_name> ...]]
                [COMPILE_OPTIONS [<options> ...]]
                [COMPILE_DEFINITIONS[<definitions> ...]]
                [DEPENDS [<target_name> ...]]
                [SUFFIX <name_suffix>]
                [NAME <desired_name>]
                [PREFIX <name_prefix>]
                [INCLUDES [<include_path> ...]]
                [PARTOF [<target_name> ...]]
                [SOURCES [<source_path> ...]]
                [HEADERS [<header_path> ...]]
                [WITH_COVERAGE]
    )
```

##### TYPE (required)

Type of the target to be created. Possible values are;

###### EXECUTABLE

Executable target (add_executable)

###### STATIC

Static library target (add_library(STATIC))

###### SHARED

Shared library target (add_library(SHARED))

###### UNIT_TEST

Unit test target. Performs additional steps to make unit test discoverable by CTest. Also, target is automagically linked to `google test` and `google mock` libraries for convenience.

###### INTERFACE

Header-only library target (add_library(INTERFACE))

###### BENCHMARK

Benchmark target. Similar to UNIT_TEST target, target is automagically linked to `google benchmark` library for convenience.

##### LINK (optional)

The list of libraries/targets to link to the created target. The names which are target names are resolved by CMake and the actual .so/.a files will be linked according to the target type. Link target's public/interface include path also will be appended to the created target, so the public interface of the target can be used in created target's source files by using angle brackets (`<>`).

Example:

```cmake
    make_target(TYPE EXECUTABLE LINK pthread my-awesome-target)
```

##### COMPILE_OPTIONS (optional)

The list of parameters to pass to the compiler when compiling the source code of the created target.

Example:

```cmake
    make_target(TYPE STATIC COMPILE_OPTIONS -O3)
```

##### COMPILE_DEFINITIONS (optional)

The list of macro definitions to pass to the compiler when compiling the source code of the created target.

Example:

```cmake
    make_target(TYPE STATIC COMPILE_DEFINITIONS USING_HADOUKEN=1)
```

##### DEPENDS (optional)

The list of dependencies of created target. In order to satisfy dependency, the specified targets will be processed before the created target is processed.

##### NAME (optional)

The user-defined name for the created target. By default, name will be automatically determined from previous project call. If you want to give a different name, you can give by specifying this argument.

##### PREFIX (optional)

The prefix to be prepended to the created target name.

```cmake
    project(my-awesome-component)

    make_target(TYPE EXECUTABLE PREFIX test.)
    # The target name will be `test.my-awesome-component`
```

##### SUFFIX (optional)

The suffix to be appended to the created target name. Usually used to distinguish between subtypes of the same target, or target with different configurations.

```cmake
    project(my-awesome-component)

    make_target(TYPE SHARED SUFFIX .shared)
    # The target name will be `my-awesome-component.shared`
    make_target(TYPE SHARED SUFFIX .shared-pic COMPILE_OPTIONS -fPIC)
    # The target name will be `my-awesome-component.shared-pic
    make_target(TYPE STATIC SUFFIX .static)
    # The target name will be `my-awesome-component.static`
```

##### INCLUDES (optional)

List of include paths to be added to the include directory of the created target.

##### PARTOF (optional)

Reverse of DEPENDS, makes specified argument (expected to be a target) to be dependent to the created target.

Example:

```cmake

    project(my-awesome-component)

    make_target(TYPE SHARED PARTOF special-component)
    # special-component now depends on my-awesome-component

```

##### SOURCES (optional)

Extra source files to be appended to created target's sources.

##### HEADERS (optional)

Extra header files to be appended to created target's headers.

##### WITH_COVERAGE (optional)

Generate code coverage report for the project (useful for unit test targets)

##### EXPOSE_PROJECT_METADATA (optional)

Defines the following C/C++ preprocessor macros for the target created.

```C
  <prefix>MODULE_NAME
  <prefix>MODULE_DESC
  <prefix>MODULE_VERSION_MAJOR
  <prefix>MODULE_VERSION_MINOR
  <prefix>MODULE_VERSION_PATCH
  <prefix>MODULE_VERSION_TWEAK

```

The information is gathered from the `project()` info.

##### PROJECT_METADATA_PREFIX (optional)

Prefix to prepend created project metadata macros.

##### NO_AUTO_COMPILATION_UNIT (optional)

Disable automatic compilation unit gathering from include/ and src/ directories.

Prefix to prepend created project metadata macros.

#### Git

This module has several functions to invoke git functionality from CMake.

##### git_get_branch_name(DIRECTORY \<dir\>)

A function to retrieve active branch name for the project. Sets both `GIT_BRANCH_NAME` variable and `GIT_BRANCH_NAME` (global) property.

Example:

```cmake
    git_get_branch_name(DIRECTORY ${PROJECT_SOURCE_DIR})
    # ${GIT_BRANCH_NAME} now contains the branch name of the git repository in ${PROJECT_SOURCE_DIR}
    # or alternatively;
    get_property(ACTIVE_BRANCH_NAME GLOBAL PROPERTY GIT_BRANCH_NAME)
    # ${ACTIVE_BRANCH_NAME} now contains the branch name.
    # see: https://cmake.org/cmake/help/latest/command/get_property.html for further
    # information about get_property usage.
```

##### git_get_head_commit_hash(DIRECTORY \<dir\>)

A function to retrieve commit hash of the head for the git repository located in specified directory. Sets both `GIT_HEAD_COMMIT_HASH` variable and `GIT_HEAD_COMMIT_HASH` (global) property.

Example:

```cmake
    git_get_head_commit_hash(DIRECTORY ${PROJECT_SOURCE_DIR})
    # ${GIT_HEAD_COMMIT_HASH} now contains the head commit hash of the git repository in ${PROJECT_SOURCE_DIR}
    # or alternatively;
    get_property(ACTIVE_BRANCH_CH GLOBAL PROPERTY GIT_HEAD_COMMIT_HASH)
    # ${ACTIVE_BRANCH_CH} now contains the head commit hash.
```

##### git_is_worktree_dirty(DIRECTORY \<dir\>)

A function to retrieve whether current work tree for the git repository located in specified directory is dirty. Sets both `GIT_IS_WORKTREE_DIRTY` variable and `GIT_IS_WORKTREE_DIRTY` (global) property.

Example:

```cmake
    git_is_worktree_dirty(DIRECTORY ${PROJECT_SOURCE_DIR})
    # ${GIT_IS_WORKTREE_DIRTY} now contains whether worktree of the git repository in ${PROJECT_SOURCE_DIR} is dirty or not.
    # or alternatively;
    get_property(ACTIVE_BRANCH_DIRTY GLOBAL PROPERTY GIT_IS_WORKTREE_DIRTY)
    # ${ACTIVE_BRANCH_DIRTY} now contains the dirtiness status.
```

##### git_get_config(DIRECTORY \<dir\> CONFIG_KEY \<key_to_be_retrieved\>)

A function to retrieve a git configuration by its' key name. Sets both `GIT_CONFIG_VALUE` variable and `GIT_CONFIG_VALUE` (global) property.

Example:

```cmake
    git_get_config(DIRECTORY ${PROJECT_SOURCE_DIR} CONFIG_KEY user.email)
    # ${GIT_CONFIG_VALUE} now contains the user.email configuration value of the git repository located in ${PROJECT_SOURCE_DIR} folder.
    # or alternatively;
    get_property(ACTIVE_BRANCH_UEMAIL GLOBAL PROPERTY GIT_CONFIG_VALUE)
    # ${ACTIVE_BRANCH_UEMAIL} now contains the dirtiness status.
```

##### git_print_status()

Print branch, commit hash and dirtiness status of the git repository specified in DIRECTORY argument.

```cmake
    git_print_status()
    # Possible output to stdout might be:
    # [+] VCS Status
    #   Branch: master
    #   Commit: 8f14b151ec1aba749f5ac579b6f4f8209738dee5
    #   Dirty: false
```

#### Conan

Official conan module provided by JFrog. Provides `conan_cmake_run` function, which allows conan to be run from CMake.

```cmake
cmake_minimum_required(VERSION 3.16)

project(dummy)

include(boilerplate/Hadouken.cmake)

# Fetch boost 1.70.0 from conan repositories.
# Build any dependencies which are missing on repository as pre-built
# Create cmake targets for resolved dependencies
# Created dependencies can be accessed from CONAN_PKG:: target. (eg. CONAN_PKG::boost)
conan_cmake_run(REQUIRES boost/1.70.0
                BASIC_SETUP CMAKE_TARGETS
                BUILD missing)

```

#### HardwareConcurrency

A CMake module to retrieve logical core count of the machine. Sets `${HARDWARE_CONCURRENCY}` CMake variable.

### Build variant determination

This modules are designed for determining the common and compiler specific compilation parameters according to the build variant. The base functionality is provided by `BuildVariant.cmake` module, which determines the compiler (using CMakeDetermine[C/CXX]Compiler CMake modules), sets the build variant if not set by the user (default is RelWithDebugInfo), adjusts build variant specific compilation parameters, then includes the compiler specific module. Compiler-specific modules are suffixed with toolchain/compiler name and contains the distinct compilation flags for that compiler. These modules are used to enable some useful warnings, and also turn warnings into errors in release builds.

### Finders

Finders are located in `cmake/modules/find` folder. This folder is designated for CMake finders, which allows user to call `find_program` and locate executable/library/header files in environment. CMake has a quite exhaustive list of finder modules, but still lacks some. This folder will contain the finder modules which CMake does not contain.

The list of finder modules are provided below;

- FindGMock.cmake (google mock)

### Feature check

Feature check modules are located in `cmake/modules/check` folder. They're driven by `FeatureCheck.cmake` file. The purpose of a feature check module is, to determine whether a feature, a library, a header (etc..) is available in compilation environment or not. This is done by compiling a small C++ code regarding the subject. If the file compiles successfully, the subject is said to be available in the environment. Compilation is done by invoking a special CMake function named `check_cxx_source_compiles`. This function takes a source code as an argument, tries to compile it, and sets a user-named variable to indicate compilation status. An example feature check module is shown below;

```cmake
set(CMAKE_REQUIRED_QUIET true)              # Do not print anything to stdout regarding feature check
set(CMAKE_REQUIRED_LIBRARIES "-lpthread")   # Feature check dependencies (linkage against pthread is required for this scenario)

# A code which uses some of the `pthread` functions in order to determine
# whether pthread is available on the compilation environment
check_cxx_source_compiles("
    #include <pthread.h>
    extern \"C\" void* thread_proc(void* arg)
    {
    return arg;
    }
    int main(void)
    {
        pthread_mutex_t mut;
        int result = pthread_mutex_init(&mut, 0);
        if(0 == result)
        {
            result |= pthread_mutex_lock(&mut);
            result |= pthread_mutex_unlock(&mut);
            result |= pthread_mutex_trylock(&mut);
            result |= pthread_mutex_unlock(&mut);
            result |= pthread_mutex_destroy(&mut);

            pthread_t t;
            int r = pthread_create(&t, 0, &thread_proc, 0);
            // result |= r;
            if(r == 0)
            {
                //
                // If we can create a thread, then we must be able to join to it:
                //
                void* arg;
                r = pthread_join(t, &arg);
                result |= r;
            }
        }
        return result;
    }
    "
    ${PB_PARENT_PROJECT_NAME_UPPER}_FEATURE_HAS_PTHREADS
)
# <project_name>_FEATURE_HAS_PTHREADS is set to true or false after this, indicating the compilation status.
```

The result variable has a specific naming convention too. `FeatureCheck.cmake` expects the result variable to be defined in a specific way: (the actual check code is `if (NOT ${PB_PARENT_PROJECT_NAME_UPPER}_HAS_${ARG_AS_UPPER})`)

 `${PB_PARENT_PROJECT_NAME_UPPER}` is a CMake variable defined by hadouken which contains the top level project name, converted to uppercase and all non-alphanumeric characters replaced with an underscore (_). The glue `_HAS_` have to come after this. The last word should match with the feature check module (capitalized).

Feature check modules have a specific naming convention. Every feature check module file name has to start with `Check`. The letters between `Check` and `.cmake` determines the feature check module name. The user will use this name to invoke feature check functions.

To perform a feature check, invoke feature_check_assert with desired feature names.

Example:

```cmake
project(my-awesome-project)                             # Declare a new project
include(boilerplate/Hadouken.cmake)        # Use hadouken
# Check if pthreads is available on compilation environment.
# CMake configuration will result in failure if code in feature check macro fails to compile.
feature_check_assert(Pthreads)
```

You can use Pthreads as a reference when creating new feature check modules.

****

## Closing words

Hadouken will continue to evolve, and you may contribute to it. Don't hesitate to issue a PR.

[nettsi-logo]: res/img/nettsi-logo.png
[hadouken]: res/img/hadouken.jpg
[vscode-docker-1]: res/img/vscode-remote-docker-1.png
[vscode-docker-2]: res/img/vscode-remote-docker-2.png
[gcovr-report]: res/img/code-coverage-report-gcovr.png
[exclamation-mark]: res/img/symbols/info-16.png

## References

VSCode Remote Containers Documentation: <https://code.visualstudio.com/docs/remote/containers>

## Acknowledgements

* vscode developers: for creating such a flexible, versatile code editor and a huge ecosystem. <https://github.com/microsoft/vscode>
* vscode-remote-containers team: <https://github.com/microsoft/vscode-dev-containers>

## License

This project is licensed under Apache 2.0 license. See LICENSE file for license information.
