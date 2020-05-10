# Multiple Wordpress Sites Deployment on Single Host

![](https://img.shields.io/badge/Wordpress-FPM-purple.svg)
![](https://img.shields.io/badge/language-PHP-orange.svg)
![](https://img.shields.io/badge/platform-Docker-lightgrey.svg)
[![](https://img.shields.io/badge/Traefik-v2.x-blue.svg)](https://containo.us/traefik/)
![](https://img.shields.io/badge/license-MIT-000000.svg)

## Main Docker images used in this repo

- alphacodinghub/wordpress-fpm: latest Wordpress release with PHP7 and PHP-FPM7, and with Redis driver installed for Wordpress Redis Object Cache plugin
- nginx: to serve as the web server for Wordpress
- mariadb: to serve as the database server for Wordpress
- redis: to serve Redis Object Cache plugin

## Easy deployment of multiple wordpress sites on single VPS

In order to use this repo, you will need to have [the Docker app management tool set](https://github.com/alphacodinghub/traefik-docker-manager) installed on the host. The tool set provides a set of efficient tools to deploy, manage and monitoring Docker apps.

With this repo, you will be able to deplot multiple Wordpress sites on single host very easily.

> The only file you need to customize is `.env-template`, which sets some environment varialbles. In this file, you **MUST** change the below five environment variables to your own values. All other environment variables are optional. The five environment variables are:

- APP_DOMAIN: the main domain you own for deploying WP sites, e.g. `example.com`.
- DB_ROOT_PASSWORD: the root password of the Database.
- DB_NAME: the database name. This database is used for Wordpress.
- DB_USER: the user name of the above database for Wordpress to access the database.
- DB_PASSWORD: the database password for Wordpress to access the database.

## Deploy a Wordpress site

To deploy a Wordpress website on your VPS, follow the below steps:

### Step 1: Clone the repo to your VPS

```
git clone https://github.com/alphacodinghub/wordpress-fpm.git
cd wordpress-fpm
```

### Step 2: Customize the environment variables

Edit the file `.env-template` and set appropriate values.

### Step 3: Deploy a Wordpress site

Assume you want to deploy your Wordpress site in the folder `/app`, and you name this Wordpress site as `myblog`. Run the below command in the repo folder:

```
bash ./wp-deploy.sh /app/  myblog
```

The above command will install a Wordpress site in the folder `/app`. You can access the site via:

```
https://myblog.example.com
```

> Note: please replace `example.com` with your own domain.

To deploy more Wordpress sites, just repeat Step 3.

### Step 4: Set up the Redis Object Cache plugin

Follow the below steps to set up the Wordpress Redis Object Cache plugin:

- Log into your wordpress site and enter the Dashboard.
- Add new plugin on your Dashboard, find the Redis Object Cache plugin. Click the `Install Now` button to install the plugin.

![Install](https://github.com/alphacodinghub/wordpress-fpm/blob/master/images/1-install.png)

- After installing the plugin, click the `Activate` button to activate the plugin.

![Activate](https://github.com/alphacodinghub/wordpress-fpm/blob/master/images/2-activate.png)

- Go to the `Installed Plugins` from the dashboard. Click `Settings` under the `Redis Object Cache`.

![Settins](https://github.com/alphacodinghub/wordpress-fpm/blob/master/images/3-settings.png)

- On the `Settind` screen, you will notice that the "Status" is `Disabled`. Click the `Enable Object Cache` button.

![Enable ROC](https://github.com/alphacodinghub/wordpress-fpm/blob/master/images/4-enable.png)

- When the screen is updated you will find the "Status" has changed to `Connected`.

![Connected](https://github.com/alphacodinghub/wordpress-fpm/blob/master/images/5-connected.png)
