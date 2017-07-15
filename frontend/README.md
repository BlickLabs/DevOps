## Frontend Projects

For this projects we use a [layout](https://github.com/BlickLabs/generator-frontend-dev) designed by 
[@AlanSanchezP](https://github.com/AlanSanchezP), all the information about the use of the layout is in the project Readme

### Deploy

All the frontend projects lives in the user ``` frontend ```, this is because if we use one user per project you will need several nvm installations

#### Setting up the project

```bash
sudo su frontend
git clone <repo_link>
```
To compile the files check [layout](https://github.com/BlickLabs/generator-frontend-dev) docs

Once the files are ready for deploy, you need nginx to serve these files

If NGINX is not installed on the server, install it

```bash
$ sudo apt-get install nginx
```

#### Setting up NGINX

```bash
sudo -s
cd /etc/nginx/
vim sites-available/<proyecto>
ln -s sites-available/<proyecto> sites-enabled/
vi sites-available/<proyecto>
```

Use this [sample](https://github.com/BlickLabs/DevOps/blob/master/resources/frontend-server) to configure NGINX

 * In line 5 put the complete path to the compiled files folder of the project
 * In line 8 put de domain for the project

Finally restart nginx 

```bash
service nginx restart
exit
```

#### Setting up the domain

Request to the project leader access to the DNS manager, and setup the records, heres an example

![records](https://assets.digitalocean.com/articles/redirect/dns_a_records.png)

### Updating Projects

For project updates.

* Pull your changes from git
* Compile the project files
* Restart nginx

```bash
sudo service nginx restart
```