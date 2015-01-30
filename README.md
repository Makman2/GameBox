GameBox
=======

A virtual console designed for the Raspberry Pi!

Clone and Build
---------------

To clone this repo, use the `--recursive` flag in your git clone command (since
this project uses submodules):

```shell
git clone --recursive https://github.com/Makman2/GameBox
```

If you already have cloned this repo, you can initialize submodules via:

```shell
git submodule update --init --recursive
```

After this you are ready to go. Just `cd` into the project folder and build it
with `make debug` or `make release`. The executables are located in the
directories inside `/build`.
