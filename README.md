# Advent of Code 2025 -- Ada


## Why Ada

This year I'm going to attempt to learn Ada via Advent of Code. Ada is not a super popular language, but it is an interesting option because it picks up on several ideas from Wirth's languages but takes things several steps further when it comes to being explicit and safe. There's no crazy fancy memory management model like Rust, but it does have a pretty sophisiticated typing system equivalent to the `NewType` feature recently added to Python typing.

There are now all sorts of extensions for OOP and other stuff in the latest versions of Ada, but at its core the langauge appears at first blush somewhat simpler and more opinionated than C++, which is sits in contrast to.


## Installing Ada

I'm using the [GNAT](https://gcc.gnu.org/wiki/GNAT) GCC-based compiler. You can install this via `sudo apt install gnat gprbuild gdb ada-reference-manual-2012` on an Ubuntu-based OS.

## Setting up VSCode

You can get the [Ada & SPARK plugin](https://marketplace.visualstudio.com/items?itemName=AdaCore.ada) via `ctrl + p` and pasting `ext install AdaCore.ada`.

## Building and running

I chose a very simple approach -- each day's code is a single file, and building/running goes like this:

```shell
gnatmake day01.adb -D obj/ -o bin/day01
./bin/day01
```

This may not be using the compiler CLI as intended, but it seems to work for now!
