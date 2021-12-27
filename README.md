# Compliance Tool Collection

*Misc license compliance tools in one docker image*

## Background

In our work wih license compliance we often need some basic
tools. Sometimes you are allowed to install the tools you need and
sometimes you're not. So we decided to create a docker image that
contains the tools we use on a daily basis and to create a little
script to manage the image.

We call the project [Compliance Tool collection](https://github.com/vinland-technology/compliance-tool-collection)

## Programs on the image

* [compliance-utils](https://github.com/vinland-technology/compliance-utils) (misc tools)
* [flict](https://github.com/vinland-technology/flict)
* [license-detector](http://github.com/go-enry/go-license-detector)
* [ninka](http://ninka.turingmachine.org/)
* [ort](https://github.com/oss-review-toolkit/ort)
* [reuse](https://reuse.software/)
* [scancode](https://github.com/nexB/scancode-toolkit)

Do you want more tools in the image? Create an [issue](https://github.com/vinland-technology/compliance-tool-collection/issues) at [compliance-tool-collection](https://github.com/vinland-technology/compliance-tool-collection)

# Installing

## Clone the repo

You simply clone this directory in a folder of your choice. For the
sake of this manual we're using ```~/opt/vinland```.

```
cd ~/opt/vinland
git clone https://github.com/vinland-technology/compliance-tool-collection.git
```

## Tweak your PATH variable

Add this repo's bin directory to your PATH variable. Assuming you're using bash:

```
echo "PATH=~/opt/vinland/compliance-tool-collection/bin/:\$PATH" >> ~/.bashrc
```

## Check the progress

Check your installation (so far) by making sure you can get the version:

```
compliance-tool --version
```

## Download the docker image

Download the docker image from the docker hub.

```
compliance-tool pull
```

## Check the progress

Check your installation by making sure you can get the versions from
the software in the docker image by issuing:

```
compliance-tool --versions
```

When we executed the above, it looked like this:

```
$ compliance-tool --versions
Compliance tools collections: eb78c50
 * Compliance utils:          ef25ff0
 * Flict:                     c7acb64
 * License detector:          unknown
 * Ninka:                     v1.3.2
 * Ort:                       79a687c
 * Reuse:                     0.12.1    # currently not working
 * Scancode:                  21.3.31
```

## Getting some help

```
$ compliance-tool --help
```

# Starting the programs in the docker image

You can start the program (in the docker image) directly from the
command line. Let's say you wnat to get the version for flict:

```
docker run --rm -i -t -v $(pwd):/compliance-tools sandklef/compliance-tools:0.1 flict --version
```

A bit too much to get it right? Use the script ```compliance-tool``` instead:

```
$ compliance-tool flict --version
```

Easier, but still a bit too much. If you read the manual you can add
the ```wrappers``` directory to your PATH. With this "trick" you can
invoke the programs in the docker image by using the program name
directly. So for the author of this manual the help text
(```compliance-tool --help```) said I should add the following to my
.bashrc or simply issue it every time you want to use the direct
names:

```
         PATH=/home/hesa/opt/vinland/compliance-tool-collection/wrappers:$PATH
```

Now you should be able to get the version from flict by simply typing:

```
$ flict --version
c7acb64
```

# Sharing the files with the docker image

Just running the programs and not being able to have them read and
write to your file system would be pretty useless, unless you're
satisfied with getting the version from a program.

When running the docker image (container) we're mounting the current
directory to the ```/compliance-tools``` inside docker. We've set the
```WORKDIR``` variable to the same directory so if you for example
want to run scancode on a directory called ```src``` you can issue the
following command:

```
scancode -clipe src --json src-scan.json"
```

This will scan your local directory ```src``` and store the resulting
scan (in JSON format) in a file ```src-scan.json``` in the current
directory.

# Extra utils

## Scancode wrapper

If you want to scan a directory (in the current directory) you can write:

```
scancode -clipe src --json src-scan.json"
```

Since we scan code with Scancode a lot we have a small wrapper
(```scancode-wrapper```) the does the same thing, but with the
following syntax (assuming you've added the ```wrappers``` dir to your
PATH):

```
scancode-wrapper src
```

This make it easy to scan multiple directories in the current
directory. Let's sat you want to separately scan all sub directories
in the current directory, then you can simply do this:

```
for i in $(ls); do scancode-wrapper src $i; done
```

Issue the above and you can go and have a bit for lunch and come back later.

# Reporting bugs

Create an issue at https://github.com/vinland-technology/compliance-tool-collection

# Author and Copyright

Written by [Henrik Sandklef, hesa](https://github.com/hesa)

Theese tools (not the ones in the docker image) are licensed under GPL-3.0-or-later:

```
    Copyright (c) 2021 Henrik Sandklef
    License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
    This  is  free  software: you are free to change and redistribute it.  
    There is NO WARRANTY, to the extent permitted by law.
```

# Manual - Compliance tool 

Manual (txt) here: [compliance-tools.txt](doc/compliance-tool.txt)

# Building the image

For developers only. More info here: [README](build/docker/compliance-tools/README.md)


