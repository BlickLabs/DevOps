## General aspects

### Connection to servers

For the connection you need the .pem access key, you can request it to any of the members of the development team, 
for the connection, simply use the command

```bash
$ ssh -i <key.pem> user@public-ip
```

### User and role management

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

#### Databases roles

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

### Redirect www to non-www

If you want redirect users from www to a plain, non-www domain edit NGINX redirect configuration

```bash
$ sudo vi /etc/nginx/conf.d/redirect.conf
```
Add this server block

```bash
server {
    server_name www.example.com;
    return 301 $scheme://example.com$request_uri;
}
```
Save and exit. This configures Nginx to redirect requests to "www.example.com" to "example.com". 
