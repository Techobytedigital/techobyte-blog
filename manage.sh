#!/bin/bash

project_root="${PWD}"

function firstrun_check() {

    echo ""
    read -p "Has this script been run on your machine already? (y/n): " firstrun
    echo ""

    return_value=0

    case $firstrun in
    [Yy] | [YyEeSs])
        return_value=1
        ;;
    [Nn] | [NnOo])
        return_value=0
        ;;
    *)
        echo "Invalid choice: $firstrun"
        echo ""
        echo "Please enter y/Y or n/N."

        firstrun_check
        ;;
    esac

    return $return_value

}

function firstrun() {

    # Regex to match email address
    email_regex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

    read -p "What is your domain (i.e. example.com)? " domain_name
    read -p "What email address should be used for SSL certificate? " domain_email_check
    read -p "What should your Docker network be named (i.e. blognet)? " docker_network

    nginx_ssl_path="$project_root/container_data/nginx/ssl"

    if [[ $domain_email_check =~ $email_regex ]]; then
        domain_email=$domain_email_check
    else
        echo ""
        echo "[ERROR] $domain_email_check does not appear to be a valid email."
        echo ""

        exit 1
    fi

    echo ""
    echo "[DEBUG] domain_name: $domain_name"
    echo "[DEBUG] domain_email: $domain_email"
    echo "[DEBUG] docker_network: $docker_network"
    echo "[DEBUG] project_root: $project_root"
    echo "[DEBUG] nginx_ssl_path: $nginx_ssl_path"

    certbot_vars=("$domain_name" "$domain_email" "$docker_network" "$project_root" "$nginx_ssl_path")

    for certbot_arg in "${certbot_vars[@]}"; do

        echo ""
        echo "[DEBUG] certbot_arg: $certbot_arg"

        if [[ -z "$cerbot_arg" ]]; then
            if [[ "$certbot_arg" == "$domain_name" ]]; then

                certbot_domain_flag="--domain-name=$domain_name"

                echo "[DEBUG] certbot domain flag: $certbot_domain_flag"
                echo ""

            elif [[ "$certbot_arg" == "$domain_email" ]]; then

                certbot_domain_email_flag="--domain-email=$domain_email"

                echo "[DEBUG] certbot domain email flag: $certbot_domain_email_flag"
            elif [[ "$certbot_arg" == "$docker_network" ]]; then
                certbot_docker_network_flag="--docker-network=$docker_network"

                echo "[DEBUG] certbot docker network flag: $certbot_docker_network_flag"
                echo ""
            elif [[ "$certbot_arg" == "$project_root" ]]; then
                certbot_project_root_flag="--project-root=$project_root"

                echo "[DEBUG] certbot project root dir flag: $certbot_project_root_flag"
                echo ""

            elif [[ "$certbot_arg" == "$nginx_ssl_path" ]]; then
                certbot_nginx_ssl_path_flag="--ssl-path=$nginx_ssl_path"

                echo "[DEBUG] certbot NGINX SSL dir flag: $certbot_nginx_ssl_path_flag"
                echo ""

            fi
        else
            echo ""
            echo "[ERROR] Empty variable detected. You must answer each prompt with a value."
            echo ""
            echo "[INFO] Retrying firstrun setup"
            echo ""

            firstrun
        fi

    done

    echo ""
    echo ""
    echo "[DEBUG] TEST RUN: ./install-certbot.sh"

    echo "[DEBUG] Command test print:"
    echo "  $>./install-certbot.sh $certbot_domain_flag $certbot_domain_email_flag $certbot_docker_network_flag $certbot_nginx_ssl_path_flag $certbot_project_root_flag"

    ./scripts/install-certbot.sh $certbot_domain_flag $certbot_domain_email_flag $certbot_docker_network_flag $certbot_nginx_ssl_path_flag $certbot_project_root_flag

}

function main() {

    if [[ $1 == "" ]]; then
        # Ask user if script has been run yet
        # firstrun_check
        been_run=$(firstrun_check)

        if [[ $been_run -eq 1 ]]; then
            echo "<print options menu>"
        else
            echo ""
            echo "Running first time setup"
            echo "-------------------------"

            firstrun
        fi
    fi

    for arg in "${@}"; do
        echo "[DEBUG] Arg: $arg"

        case $arg in
        -init | --initial-setup)
            echo ""
            echo "Running initial setup"
            echo ""

            firstrun
            ;;
        *)
            echo "Invalid option: $arg"
            ;;
        esac
    done
}

main "$@"
