This Guide is for distributions based on Debian
------

##<a name="index"></a> Index

* [Prerequirements](#pre-requirements)
* [OS Requirements](#os-requirements)
* [Setting up the database](#database-setup)
* [Setting up the project](#project-setup)
* [Setting up deploy scripts](#scripts-setup)

###<a name="pre-requirements"></a> Prerequirements.<sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

1. Python 3.4.0
2. Git
3. Dedicated user for the app (check [general-aspects.md](https://github.com/BlickLabs/devops/blob/master/general-aspects.md))

###<a name="os-requirements"></a> OS Requirements.<sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

Installing Dependencies

```bash
$ sudo apt-get install python3-pip python3-dev
```

Installing PostgreSQL dependences

```bash
$ sudo apt-get install postgresql postgresql-contrib libpq-dev libjpeg-dev
```

Installing the server

```bash
$ sudo apt-get install nginx
```

###<a name="database-setup"></a> Setting up the database.<sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

```bash
$ sudo su postgres
$ createdb <db_name>
$ createuser -P <db_username>
$ psql
=# GRANT ALL PRIVILEGES ON DATABASE <db_name> TO <db_username>;
=# \q
$ $ exit
```

###<a name="project-setup"></a> Setting up the project.<sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

```bash
$ git clone <code_repository>
$ pip3 install virtualenv
$ virtualenv -p $(which python3) ~/.venv
$ source ~/.venv/bin/activate
$ cd <project_folder>/
$ pip install -r requirements.txt
```

Copy the content on the .env-sample file to you ~/.bashrc, ~/.profile, or ~/.zshrcfile to create environment variables required for this project

```bash
$ vi ~/.bashrc
$ source ~/.bashrc
$ source ~/.venv/bin/activate
```
NOTE: Check the detail of the env variables on the project repo

To setup the database use 

```bash
$ ./manage.py migrate
```

Create a superuser for the admin site using

```bash
$ ./manage.py createsuperuser
```

Test running the project using

```bash
$ ./manage.py runserver 8000
```

###<a name="scripts-setup"></a> Setting up deploy scripts.<sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

Use the [deploy-sample.sh](https://github.com/BlickLabs/devops/blob/master/deploy-sample.sh) file to setup 
up the project startup

```bash
$ cd ..
$ mkdir deploy
$ vim deploy/deploy.sh
$ chmod +x deploy/deploy.sh
$ cd deploy
```

Run the project using the script, everything is is correct if the process not stop

```bash
$ ./deploy.sh
```

The next step is setup nginx use the [nginx-sample](https://github.com/BlickLabs/devops/tree/master) file

```bash
$ sudo -s
$ cd /etc/nginx/
$ vim sites-available/<project>
$ ln -s sites-available/<project> sites-enabled/
$ vi sites-available/<project>
$ sudo service nginx restart
```

The final step is create a system service to keep running the application, it can change between OS but in this repo its a 
[sample](https://github.com/BlickLabs/devops/blob/master/service_sample.conf)

```bash
$ cd /etc/init
$ sudo vi <project>.conf
$ sudo service <project> start
$ sudo service <project> status
```

Now we have the application running :)



