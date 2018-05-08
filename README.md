# docker-python3-kivy-buildozer
Docker image to build for Android your Kivy apps in Python 3. Heavily based on [bodolsog/docker-py3-kivy-buildozer](https://github.com/bodolsog/docker-py3-kivy-buildozer).
To have Buildozer with Python 3 support, we need to use the [Crystax NDK](https://www.crystax.net/android/ndk). It is downloaded during the image build.

## Usage:
- You need Docker installed: https://docs.docker.com/install/

- Clone this repository and build the image (it'll take a while):
```
# docker build -t diegodukao/python3-kivy-buildozer .
```

- Go to your project folder and start the container:
```
$ cd [project location]
# docker run --rm -it --privileged -v $PWD:/src -v /dev/bus/usb:/dev/bus/usb -v buildozer:/home/kivy diegodukao/python3-kivy-buildozer /bin/bash
```
- Explanation:
  - `--rm` - remove container after run
  - `-v $PWD:/src ` - mount current directory as `/src` in container
  - `--privileged` and `-v /dev/bus/usb:/dev/bus/usb` are needed to allow communicate between container and usb-connected Android device
  - `-v buildozer:/home/kivy` - create (if not created before) and mount `buildozer` volume to keep downloaded dependencies
  - `diegodukao/python3-kivy-buildozer` - image name

- If don't have a `buildozer.spec` file already, run `init` inside the container:
```
$ buildozer init
```
and update the generated `buildozer.spec` as described bellow.

- Update buildozer dependencies for Android (run inside the container):
```
$ buildozer android update
```

- To build the apk (run inside the container):
```
$ buildozer android debug
```
After building the apk, buildozer might give a `FileNotFoundError` when trying to copy the apk file to the current directory. Your apk file will be at `/home/kivy/android/platform/build/dists/<YOUR-APP-NAME>/bin/` inside the container. So, for example, if you built the version 0.1 of an app named AwesomeApp, to copy the apk (still inside the container):
```
$ cp /home/kivy/android/platform/build/dists/awesomeapp/bin/AwesomeApp-0.1-debug.apk .
```

## buildozer.spec

To enable py3 support your buildozer.spec need to contain `python3crystax` in requirements. CrystaX is downloaded on build image task and installed in `/opt/crystax-ndk-10.3.2/`. This location should be putt in `android.ndk_path` spec's variable.

```
# buildozer.spec

# (list) Application requirements
requirements = python3crystax,kivy

# (str) Android NDK directory (if empty, it will be automatically downloaded.)
android.ndk_path = /opt/crystax-ndk-10.3.2
```

### Additional

You can set `build_dir` to /home/kivy/ and use this location as Docker Volume to avoid re-download all dependencies each time.

```
# (str) Path to build artifact storage, absolute or relative to spec file
build_dir = /home/kivy/
```

# Note
Tested only with android for simple apps. Python3 support for buildozer and python-for-android are still in beta.
