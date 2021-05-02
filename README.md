# compliance-tools-collections
misc license compliance tools in one docker image

# Manual

```
NAME

    compliance-tool - misc license compliance tools in one docker image


SYNOPSIS

    compliance-tool [OPTION]


DESCRIPTION

    compliance-tool manages a docker image with useful license compliance tools.
    Included tools:
        flict
        license-detectork
        ninka
        ort
        reuse
        scancode

    The current directory is mounted under /compliance-tools. This is crucial to let the
    tools work on your files and directories and output result outside the
    docker container. /compliance-tools is also set as the docker WORKDIR

    When invoked under any of the following names:
        flict, license-detector, ninka, ort
        reuse, scancode
    the corresponding program (run inside) docker is invoked and the arguments
    are passed to the program.

    To ease up executing the commands you can add the directory where compliance-tool 
    is loacted to PATH. You can typically do this by adding the following to 
    your ~/.bashrc (assuming you're using bash):
         PATH=/media/hesa/53abd732-5131-495d-9ac5-c49a4ded3efa1/hesa/opt/vinland/compliance-tools-collections/wrappers:$PATH

OPTIONS

    -h, --help
          output this help text

    -v, --verbose
          enable verbose printout

    -np, --no-parallel
          do not use parallel processes when scanning (with Scancode). 
          By default all processors are used. This option is useful if 
          you want to keep scancode in the background

    --version
          output version information for this tool and the
          built in programs

    bash
          Starts a bash session in docker

    flict [ARGS]
          Starts flict with the arguments [ARGS]

    license-detector [ARGS]
          Starts license-detector with the arguments [ARGS]

    ninka [ARGS]
          Starts ninka with the arguments [ARGS]

    reuse [ARGS]
          Starts reuse with the arguments [ARGS]

    scancode [ARGS]
          Starts scancode with the arguments [ARGS]

    scancode-wrapper [DIR]
          Starts scan (Scancode) of DIR, storing result in DIR-scan.json

    pull
          Pulls the docker image sandklef/compliance-tools (0.1)
          from docker.io

EXAMPLES

    Invoke Scancode to scan directory X (in the current directory)
        compliance-tool scancode -clipe X --json X.json
    or like this (assuming you've modified the PATH variable as described above):
        scancode -clipe X --json X.json

    Invoke scancode-wrapper to scan directory X
        scancode-wrapper X

AUTHOR

    Written by Henrik Sandklef

    Please note that this is just a simple wrapper around some great programs.

COPYRIGHT

    Copyright (c) 2021 Henrik Sandklef
    License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
    This  is  free  software: you are free to change and redistribute it.  
    There is NO WARRANTY, to the extent permitted by law.


REPORTING BUGS

    Create an issue at https://github.com/vinland-technology/compliance-tools-collections

SEEL ALSO

    misc tools       - https://github.com/vinland-technology/compliance-utils
    flict            - https://github.com/vinland-technology/flict
    license-detector - http://github.com/go-enry/go-license-detector
    ninka            - http://ninka.turingmachine.org/
    ort              - https://github.com/oss-review-toolkit/ort
    reuse            - https://reuse.software/
    scancode         - https://github.com/nexB/scancode-toolkit

```
