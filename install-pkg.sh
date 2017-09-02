#!/bin/sh

rootpath=$1

#ls -l "$rootpath"

pushd "$rootpath" > /dev/null

find . -type f -name '*.dmg' -exec sh -c '
  for file do
    echo "$file"
 
    yes | hdiutil attach -mountpoint right_here "$file" > /dev/null

    if [ $? -eq 1 ]; then
        continue;
    fi

    pushd right_here > /dev/null

    sudo installer -store -pkg *.pkg -target / >/dev/null 2>&1

    popd > /dev/null

    until hdiutil detach right_here >/dev/null 2>&1; do
        # echo "try again."
        sleep 1
    done

    # diff "$file" "/some/other/path/$file"

    echo "done."
    # read line </dev/tty
  done
' sh {} +

