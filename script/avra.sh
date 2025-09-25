echo build-avra
if [[ $(ls -A | grep .target) == '' ]]; then
    echo ${PWD##*/} > .target
fi

if [[ $2 != '' ]]; then
    name=$2
else
    name=$(cat .target)
    echo "Selecting .target => $name"
fi

name=${name%.*}

atmega_path=$(dirname $(dirname $0))


case "$1" in
    "switch")
        echo $name > .target
        echo "Switching .target => $name"
        exit 0
        ;;
    "target")
        echo $name > .target
        echo "Switching .target => $name"
        make -f $atmega_path/lib/make/makefile-avra name=$name
        exit 0
        ;;
    *)
        ;;
esac

echo "Selecting $name"
make -f $atmega_path/lib/make/makefile-avra name=$name $1
