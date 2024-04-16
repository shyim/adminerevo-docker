# Adminerevo

## What is Adminerevo?

Adminerevo is a fork of Adminer, but it's better maintained and has more features. It's a full-featured database management tool written in PHP. Conversely to phpMyAdmin, it consist of a single file ready to deploy to the target server. Adminer is available for MySQL, MariaDB, PostgreSQL, SQLite, MS SQL, Oracle, Elasticsearch and MongoDB.

> [adminerevo.org](https://docs.adminerevo.org/)

## How to use this image

### Standalone

```console
$ docker run --link some_database:db -p 8080:8080 ghcr.io/shyim/adminerevo:latest
```

Then you can hit `http://localhost:8080` or `http://host-ip:8080` in your browser.

### ... via [`docker-compose`](https://github.com/docker/compose) or [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/)

Example `docker-compose.yml` for `adminerevo`:

```yaml
# Use root/example as user/password credentials

version: '3.1'
services:
  adminer:
    image: ghcr.io/shyim/adminerevo:latest
    restart: always
    ports:
      - 8080:8080
  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
```

### Loading plugins

This image bundles all official Adminerevo plugins. You can find the list of plugins on GitHub: https://github.com/adminerevo/adminerevo/tree/main/plugins.

To load plugins you can pass a list of filenames in `ADMINER_PLUGINS`:

```console
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_PLUGINS='tables-filter tinymce' ghcr.io/shyim/adminerevo:latest
```

If a plugin *requires* parameters to work correctly instead of adding the plugin to `ADMINER_PLUGINS`, you need to add a custom file to the container:

```console
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_PLUGINS='login-servers' ghcr.io/shyim/adminerevo:latest
Unable to load plugin file "login-servers", because it has required parameters: servers
Create a file "/var/www/html/plugins-enabled/login-servers.php" with the following contents to load the plugin:

<?php
require_once('plugins/login-servers.php');

/** Set supported servers
    * @param array array($domain) or array($domain => $description) or array($category => array())
    * @param string
    */
return new AdminerLoginServers(
    $servers = ???,
    $driver = 'server'
);
```

To load a custom plugin you can add PHP scripts that return the instance of the plugin object to `/var/www/html/plugins-enabled/`.

### Choosing a design

The image bundles all the designs that are available in the source package of adminer. You can find the list of designs on GitHub: https://github.com/adminerevo/adminerevo/tree/main/designs.

To use a bundled design you can pass its name in `ADMINER_DESIGN`:

```console
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_DESIGN='nette' ghcr.io/shyim/adminerevo:latest
```

To use a custom design you can add a file called `/var/www/html/adminer.css`.

### Usage with external server

You can specify the default host with the `ADMINER_DEFAULT_SERVER` environment variable. This is useful if you are connecting to an external server or a docker container named something other than the default `db`.

```console
docker run -p 8080:8080 -e ADMINER_DEFAULT_SERVER=mysql ghcr.io/shyim/adminerevo:latest
```

## Supported Drivers

While Adminer supports a wide range of database drivers this image only supports the following out of the box:

-	MySQL
-	PostgreSQL
-	SQLite
-	Elasticsearch

# License

View [license information](https://github.com/adminerevo/adminerevo/blob/main/LICENSE) for the software contained in this image.
