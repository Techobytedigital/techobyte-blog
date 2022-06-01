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