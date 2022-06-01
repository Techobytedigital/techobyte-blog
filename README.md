# Description

This is the repository for the [Techobyte web blog](https://techobyte.xyz), a [Ghost](https://ghost.org/) app running in `docker-compose` with an `NGINX proxy` and SSL. This was set up on a [DigitalOcean droplet](https://m.do.co/c/3d31c70052ee) running Debian. Using the linked DigitalOcean text to sign up will get you a $100 credit to start using DigitalOcean.

The `initial-setup.sh`script sets the environment up on a new host when cloning the repository. Read [instructions](#instructions) below when setting up on a new host.

## Use this repository to set up your own Ghost blog with NGINX + SSL

### Requirements

You will need:
- A domain name
  - I used [namecheap](https://namecheap.com) to buy the `techobyte.xyz` domain
- A web host
  - [DigitalOcean](https://m.do.co/c/3d31c70052ee) offers affordable "droplets" you can run docker apps on. This link will get you a $100 DigitalOcean credit to use.
  - If you use DigitalOcean, here's some info on the droplet running the Techobyte site:
    - Image: `Debian 11 x64`
    - Size:
      - 1vCPU
      - 25GB disk
    - Cost: $5/mo
- Certbot
  - I was not able to get certbot running in a container for this project.
  - Once you've provisioned a machine to host the stack (i.e. a DigitalOcean droplet), the `initial-setup.sh` script will help you install and configure Certbot.
    - Note: The `initial-setup.sh` script was written for Debian hosts. I will update it for Ubuntu eventually.


### How to convert this repository into your own Ghost site

If you want to use this repository to set up your own Ghost blog, look through the following files and make changes to remove the `Techobyte` name from your site:

- `.env`
  - Set the `GHOST_BLOG_URL=` variable in `## REQUIRED VARIABLES` to your site's URL
- `docker-compose.yml`
  - Change the `blog`: `container_name:` value from `techobyte-blog` to your site's name
  - Change the `blog-db`: `container_name:` value from `techobyte-blog_db` to something else.
    - You could use, for example, `blog-db`
- Rename the parent directory (`techobyte-blog`) to something else
  - Also remove `techobyte-blog/.git`
  - (optional) Start a new `git` repository for your site by running `$>git init` after removing the `.git` directory

# Instructions

After cloning the repository, run `$>./initial-setup.sh`. The script will ask you for an email and a domain name; whatever domain name you use here, use in `.env` and `container_data/nginx/blog.conf` (notes on this below)

Once the script is finished, you will need to edit 2 files:

- `.env`
  - Fill in the `## REQUIRED VARIABLES` section at minimum
    - Tip: For the `GHOST_DB_ROOT_PASSWORD` variable, you can generate a secure password using `openssl rand -base64 14`
  - Optionally, fill out any other variables you want to change from the default listed in `docker-compose.yml`
- `container_data/nginx/blog.conf`
  - On both lines that say `server_name example.com;`, change `example.com` to your domain name
    - i.e. if your domain is `myblog.me`, change both lines to:
      - `server_name myblog.me

# Helpful Links & Notes

## Links

- [How I run my Ghost blog on Docker, with Nginx & MariaDB](https://myedes.io/ghost-on-docker/)
  - [Companion github repo for blog post](https://github.com/mehyedes/docker-ghost)