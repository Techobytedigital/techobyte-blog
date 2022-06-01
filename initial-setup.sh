#!/bin/bash

CERTBOT_REPO="ppa:certbot/certbot"
domain_name=$2
domain_email=$1
nginx_ssl_path="./container_data/nginx/ssl/"

function install_certbot_old () {
    echo ""
    echo "Adding repository"
    echo ""

    sudo add-apt-repository $CERTBOT_REPO

    echo ""
    echo "Installing certbot & python-certbot-nginx"
    echo ""

    sudo apt install -y certbot python-certbot-nginx
}

function install_snaps () {

    echo ""
    echo "Installing snap... *sigh*"
    echo ""

    sudo apt update -y
    sudo apt install -y snapd

    sudo snap installe core
    sudo snap refresh core

}

function install_certbot () {

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

function check_installed () {

  if ! command -v $1 &> /dev/null
  then
    # Not installed
    echo "N"
  else
    echo "Y"
  fi
    
}

function copy_ssl_files () {

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
            echo  ""

            mkdir -pv $nginx_ssl_path

            echo ""
        fi
    fi 

    echo "Copying SSL files"
    echo ""

    sudo cp /etc/letsencrypt/live/$domain_name/{cert.pem,privkey.pem,,chain.pem,fullchain.pem} $nginx_ssl_path

}

function create_dirs () {

    dirs=("container_data/db" "container_data/ghost" "container_data/nginx" "container_data/nginx/ssl/")

    echo ""
    echo "Creating dirs"
    echo ""

    for dir in "${dirs[@]}"; do
        if [[ ! -d $dir ]]; then
            echo "Creating dir: $dir"

            mkdir -pv $dir

        else
            echo ""
            echo "$dir exists. Skipping"
            echo ""
        fi
    done

}

function script_finish () {

    echo ""
    echo "Ghost setup complete."
    echo ""

    echo ""
    echo "Copying example files. You need to edit these before running the stack!"
    echo ""
    read -p "Press a key to acknowledge you need to edit the files copied next before running..."
    echo ""

    if [[ ! -f .env ]]; then
        cp .env.example .env
        echo ".env.example copied to .env. Don't forget to edit this file!"
    else
        echo ""
        echo ".env already exists. Don't forget to edit this file!"
    fi

    if [[ ! -f ./container_data/nginx/blog.conf ]]; then
        cp ./container_data/nginx/blog.conf.example ./container_data/nginx/blog.conf
        echo "./container_data/nginx/blog.conf.example copied to blog.conf. Don't forget to edit this file!"
    else
        echo ""
        echo "./container_data/nginx/blog.conf already exists. Don't forget to edit this file!"
    fi

    echo ""
    echo "Once you edit the files above, run the stack with $>docker-compose up -d"
    echo ""

    echo "Once the stack is running, check https://$domain_name to see if it's running."
    echo "  NOTE: If you have not already, you need to point your domain's nameservers to"
    echo "    this server running NGINX."

    read -p "Press a key to exit..."

    exit 1

}

function main () {

    if [[ $1 == "" ]]; then
        echo ""
        echo "No email detected."
        echo ""
        read -p "Your email: " domain_email

        echo ""
        echo "No domain detected."
        echo ""
        read -p "Your domain: " domain_name

    else
        domain_email=$1
        domain_name=$2
    fi

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

        read -p "Press a key to continue..."
        sudo certbot certonly --standalone -m $domain_email -d $domain_name
    else
        echo ""
        echo "Certs exist at /etc/letsencrypt/live/$domain_name"
        echo ""
    fi

    create_dirs

    copy_ssl_files

    script_finish

}

main "${@}"