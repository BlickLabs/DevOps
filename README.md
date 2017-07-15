# Blick DevOps

## Index <a name="index"></a>

* [Backend (Django)](https://github.com/BlickLabs/devops/django/blob/master/README.md)
* [Grails](https://github.com/BlickLabs/devops/grails/blob/master/README.md)
* [Frontend](https://github.com/BlickLabs/devops/blob/frontend/master/README.md)
* [Tips and General Aspects](#general-aspects)

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

Enter as `root` and create a new user.

```
CREATE DATABASE <DATABASE_NAME> CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'username'@'localhost' IDENTIFIED BY 'some_password';
GRANT ALL PRIVILEGES ON <DATABASE_NAME>.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
```