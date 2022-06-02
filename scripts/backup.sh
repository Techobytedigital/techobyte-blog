#!/bin/bash

# Options: DEBUG, INFO
DEBUG_LEVEL="DEBUG"

function print_debug() {

    if [[ $DEBUG_LEVEL == "DEBUG" ]]; then
        if [[ ! "$1" == "" ]]; then
            echo ""
            echo "[DEBUG] $1"
        fi
    fi

}

function load_env() {

    env_file=${1:-../env}

    set -a
    source <(cat .env | sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
    set +a

}

function run_blog_backup() {

    blog_backup_dir=$1

    print_debug "Backup dir: $blog_backup_dir"

    if [[ "$GHOST_BLOG_CONTAINER_NAME" == "" ]]; then
        echo ""
        echo "GHOST_BLOG_CONTAINER_NAME not set. Defaulting to 'techobyte-blog'"
        echo ""

        GHOST_BLOG_CONTAINER_NAME="techobyte-blog"
    fi

    if [[ "$GHOST_BLOG_DOCKER_NETWORK" == "" ]]; then
        echo ""
        echo "GHOST_BLOG_DOCKER_NETWORK not set. Defaulting to 'techobyte'"
        echo ""

        GHOST_BLOG_DOCKER_NETWORK="techobyte"
    fi

    if [[ "$GHOST_DB_USER" == "" ]]; then
        echo ""
        echo "GHOST_DB_USER not set. Defaulting to 'ghost'"
        echo ""

        GHOST_DB_USER="ghost"
    fi

    if [[ "$GHOST_DB_PASSWD" == "" ]]; then
        echo ""
        echo "GHOST_DB_PASSWD not set. Defaulting to 'ghost'"
        echo ""

        GHOST_DB_PASSWD="ghost"
    fi

    if [[ "$GHOST_DB_NAME" == "" ]]; then
        echo ""
        echo "GHOST_DB_NAME not set. Defaulting to 'ghost'"
        echo ""

        GHOST_DB_NAME="ghost"
    fi

    docker run --name ghost-backup -d \
        --volumes-from $GHOST_BLOG_CONTAINER_NAME \
        --network=$GHOST_BLOG_DOCKER_NETWORK \
        -e MYSQL_USER=$GHOST_DB_USER \
        -e MYSQL_PASSWORD=$GHOST_DB_PASSWD \
        -e MYSQL_DATABASE=$GHOST_DB_NAME \
        -v $blog_backup_dir:/backups \
        -v /etc/timezone:/etc/timezone:ro \
        bennetimo/ghost-backup

    docker exec ghost-backup backup

    echo ""
    echo "Files backed up to $blog_backup_dir"
    echo ""

}

function main() {

    if [ $# -eq 0 ]; then
        echo ""
        echo "No arguments detected."
    fi
    for var in "${@}"; do
        print_debug "Arg: $var"
        echo ""
    done

    # Prepare script from args
    for arg in "${@}"; do
        case $arg in
        -a | --all)
            # domain_name="${arg#*=}"
            echo "Backup all"
            # shift to next arg in the for loop, loop again
            shift
            ;;
        -b | --blog)

            run_blog_backup $backup_dir

            shift
            ;;
        -backupdir=* | --backup-directory=*)
            backup_dir="${arg#*=}"

            print_debug "Backup directory: $backup_dir"
            ;;
        -e=* | --env-file=*)
            env_file="${arg#*=}"
            load_env $env_file

            print_debug $GHOST_BLOG_URL
            ;;
        -* | --*)
            echo "Unknown option $arg"
            # exit 1
            ;;
        *) ;;

        esac
    done
}

main "$@"
