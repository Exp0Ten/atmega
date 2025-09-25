echo build-atmega
unset build_path

add_build() {
    local root=$1
    local path=$2
    build_path+=($root $path)
}

root_lookup() {
    for ((i=0; i<${#build_path[*]}; i+=2)); do
        if [[ $(pwd | grep ${build_path[i]}) != '' ]]; then
            ${build_path[i+1]} $@
            exit 0
        fi
    done

    echo "E: Not in registered build subroots. Build roots: (atmega)"
    for ((i=0; i<${#build_path[*]}; i+=2)); do
        echo ${build_path[i]}
    done
    exit 1
}

atmega_path=$(dirname $(dirname $0))

add_build $atmega_path/avra $atmega_path/script/avra.sh
add_build $atmega_path/asm $atmega_path/script/asm.sh
add_build $atmega_path/code $atmega_path/script/code.sh

root_lookup $@
