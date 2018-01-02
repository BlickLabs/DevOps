# Blick DevOps

## Index <a name="index"></a>

* [Django](https://github.com/BlickLabs/DevOps/tree/master/django)
* [Grails](https://github.com/BlickLabs/DevOps/tree/master/grails)
* [Frontend](https://github.com/BlickLabs/DevOps/tree/master/frontend)
* [Tips and General Aspects](#general-aspects)
* [Common problems](#common-problems)

### Tips and General Aspects<a name="general-aspects"></a>

#### Connection to servers

For the connection you need the *.pem* access key, you can request it to any of the members of the development team, for the connection, simply use the command

```bash
$ ssh -i <key.pem> user@public-ip -o ServerAliveInterval=60
```

> The -o ServerAliveInterval helps us to keep the connection alive and avoid killed sessions by the server!

#### User and role management

For each new project, a user must be created, this user will contain the project files, and the application, should be run under the new user

To add a new user

```bash
$ sudo useradd <username> -g sudo -m
$ sudo passwd <username>
$ su <username>
```

#### User Password

By convention, the users' password will be made up of

```
<username>_sudo
```

For example, if the username is  ``` mike ``` the password is ``` mike_sudo ```

#### Databases roles (PostgreSQL)

Create a database role using the same convention in system users

For example, to postgresql

```bash
$ sudo su postgres
$ createdb <db_name>
$ createuser -P <db_username>
$ psql
=# GRANT ALL PRIVILEGES ON DATABASE <db_name> TO <db_username>;
=# \q
$ exit
```

#### Redirect www to non-www

If you want redirect users from www to a plain, non-www domain edit NGINX redirect configuration

```bash
sudo vi /etc/nginx/conf.d/redirect.conf
```
Add this server block

```bash
server {
    server_name www.example.com;
    return 301 $scheme://example.com$request_uri;
}
```
Save and exit. This configures Nginx to redirect requests to "www.example.com" to "example.com". 

#### Database roles (MySQL)

Enter as `root` to MySQL and create a new user.

```
CREATE DATABASE <DATABASE_NAME> CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'username'@'localhost' IDENTIFIED BY 'some_password';
GRANT ALL PRIVILEGES ON <DATABASE_NAME>.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
```

#### Create a swap partition

> As root!

- https://stackoverflow.com/a/17174672

You can add a 1 GB swap to your instance with these commands:
```bash
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024
sudo mkswap /swapfile
sudo chmod 600 /swapfile
sudo swapon /swapfile
```
To enable it by default after reboot, add this line to /etc/fstab:

```bash
/swapfile swap swap defaults 0 0

```

#### Configure swapiness

- https://askubuntu.com/questions/103915/how-do-i-configure-swappiness

#### Install java (Ubuntu 16.04)

- https://www.digitalocean.com/community/tutorials/instalar-java-en-ubuntu-con-apt-get-es

#### Generate SSH Keys

- https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/

#### Remove file extension via Nginx

http://cobwwweb.com/remove-html-extension-and-trailing-slash-in-nginx-config

### Common problems<a name="common-problems"></a>

#### Commit.js 

You might have an issue with the `generator` when you're trying to deploy. In case the error is related with `commit` you should paste the next [file](https://raw.githubusercontent.com/BlickLabs/DevOps/master/resources/commit.js) inside your `node_modules` directory, considering the next route `node_modules/gift/lib/commit.js`
> **_the route might change too!_**.
