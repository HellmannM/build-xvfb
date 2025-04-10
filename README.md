# Build Xvfb on ramses (for nodes without X)

Enable non-root users to create GLX contexts on nodes without X Server.
We build Xvfb from source and then run it with llvmpipe.

## Instructions:
```
git clone https://github.com/HellmannM/build-xvfb.git
cd build-xvfb
source load-modules.sh
./build.sh
./compile-xkm.sh
./run.sh
```

## Note
Sources: [Eric Draken's blog post](https://ericdraken.com/running-xvfb-on-a-shared-host-without-x/).
