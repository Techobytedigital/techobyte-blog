#!/bin/bash

# Options: DEBUG, INFO
DEBUG_LEVEL="DEBUG"

function print_debug() {

    if [[ $DEBUG_LEVEL == "DEBUG" ]]; then
        echo ""
        echo "[DEBUG] $1"
    fi

}

function install_snaps() {

    echo ""
    echo "Installing snap... *sigh*"
    echo ""

    sudo apt update -y
    sudo apt install -y snapd

    sudo snap installe core
    sudo snap refresh core

}

function install_certbot() {

    echo ""
    echo "Installing certbot snap"
    echo ""
    echo "Removing old certbot"
    echo ""

    sudo apt remove -y certbot

    sudo snap install --classic certbot

    echo ""
    echo "Creating certbot alias"
    sudo ln -s /snap/bin/certbot /usr/bin/certbot

}

function check_installed() {

    if ! command -v $1 &>/dev/null; then
        # Not installed
        echo "N"
    else
        echo "Y"
    fi

}

function copy_ssl_files() {

    # $1=domain_name, $2=nginx_ssl_path

    if [[ $domain_name == "" ]]; then
        echo "[ERROR]: Domain name cannot be empty."
        echo ""
    else
        if [[ -d $nginx_ssl_path ]]; then
            echo ""
        else
            echo "[ERROR]: Nginx SSL path does not exist."
            echo "Path: $nginx_ssl_path"

            echo ""
            echo "Creating path $nginx_ssl_path"
            echo ""

            mkdir -pv $nginx_ssl_path

            echo ""
        fi
    fi

    echo "Copying SSL files"
    echo ""

    sudo cp -r /etc/letsencrypt/live/$domain_name/{cert.pem,privkey.pem,,chain.pem,fullchain.pem} $nginx_ssl_path

}

function main() {

    CERTBOT_REPO="ppa:certbot/certbot"
    domain_name=""
    domain_email=""
    docker_network=""
    project_root=""

    for var in "${@}"; do
        print_debug "Arg: $var"
        echo ""
    done

    # Prepare script from args
    for arg in "${@}"; do
        case $arg in
        -domain=* | --domain-name=*)
            domain_name="${arg#*=}"

            # shift to next arg in the for loop, loop again
            shift
            ;;
        -email=* | --domain-email=*)
            domain_email="${arg#*=}"

            shift
            ;;
        -root=* | --project-root=*)
            project_root="${arg#*=}"

            shift
            ;;
        -network=* | --docker-network=*)
            docker_network="${arg#*=}"

            shift
            ;;
        -sslpath=* | --ssl-path=*)
            nginx_ssl_path="${arg#*=}"

            shift
            ;;
        -projectroot=* | --project-root=*)
            project_root="${arg#=*}"

            shift
            ;;
        -* | --*)
            echo "Unknown option $arg"
            exit 1
            ;;
        *) ;;

        esac
    done

    nginx_ssl_path="$project_root/container_data/nginx/ssl/"

    echo ""
    print_debug "domain_name: $domain_name"
    print_debug "domain_email: $domain_email"
    print_debug "project_root: $project_root"
    print_debug "nginx_ssl_path: $nginx_ssl_path"
    print_debug "docker_network: $docker_network"

    snap_installed=$(check_installed snap)
    certbot_installed=$(check_installed certbot)

    if [[ $snap_installed == "N" ]]; then
        echo ""
        echo "Installing snapd"
        read -p "Press a key to continue..."

        install_snaps
    else
        echo ""
        echo "snapd installed. Skipping"
        echo ""
    fi

    if [[ $certbot_installed == "N" ]]; then
        echo ""
        echo "Installing certbot"
        read -p "Press a key to continue..."

        install_certbot
    else
        echo ""
        echo "certbot installed. Skipping"
        echo ""
    fi

    if [[ ! -d /etc/letsencrypt/live/$domain_name ]]; then
        echo ""
        echo "Registering certbot"
        echo ""
        echo "Command:"
        echo "  $>sudo certbot certonly --standalone -m $domain_email -d $domain_name"

        sudo certbot certonly --standalone -m $domain_email -d $domain_name || echo "[ERROR] Certbot couldn't run. This might be because an app is running on port ${GHOST_WEB_PORT:-80}"
    else
        echo ""
        echo "Certs exist at /etc/letsencrypt/live/$domain_name"
        echo ""
    fi

    echo ""
    echo "Creating docker network: $docker_network if it does not exist."
    echo ""
    docker network inspect $docker_network >/dev/null 2>&1 ||
        docker network create --driver bridge $docker_network

    copy_ssl_files $domain_name $nginx_ssl_path

}

main "${@}"
