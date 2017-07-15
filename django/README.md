Django projects
------

## Index<a name="index"></a>

* [Prerequirements](#pre-requirements)
* [OS Requirements](#os-requirements)
* [Setting up the database](#database-setup)
* [Setting up the project](#project-setup)
* [Setting up deploy scripts](#scripts-setup)
* [Update django project](#update-django-project)


### Prerequirements.<a name="pre-requirements"></a><sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

1. Python 3.4.0
2. Git
3. Dedicated user for the app (check [general-aspects.md](https://github.com/BlickLabs/devops/blob/master/README.md#general-aspects))

### OS Requirements.<a name="os-requirements"></a><sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

Installing Dependencies

```bash
sudo apt-get install python3-pip python3-dev
```

Installing PostgreSQL dependences

```bash
sudo apt-get install postgresql postgresql-contrib libpq-dev libjpeg-dev
```

Installing the server

```bash
sudo apt-get install nginx
```

### Setting up the database.<a name="database-setup"></a><sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

```bash
sudo su postgres
createdb <db_name>
createuser -P <db_username>
psql

=# GRANT ALL PRIVILEGES ON DATABASE <db_name> TO <db_username>;
=# \q

exit
```

### Setting up the project.<a name="project-setup"></a><sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

```bash
git clone <code_repository>
pip3 install virtualenv
virtualenv -p $(which python3) ~/.venv
source ~/.venv/bin/activate
cd <project_folder>/
pip install -r requirements.txt
```

Copy the content on the .env-sample file to you ~/.bashrc, ~/.profile, or ~/.zshrcfile to create environment variables required for this project

```bash
vi ~/.bashrc
source ~/.bashrc
source ~/.venv/bin/activate
```
NOTE: Check the detail of the env variables on the project repo

To setup the database use 

```bash
./manage.py migrate
```

Create a superuser for the admin site using

```bash
./manage.py createsuperuser
```

Test running the project using

```bash
./manage.py runserver 8000
```

### Setting up deploy scripts.<a name="scripts-setup"></a><sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

Use the [deploy-sample.sh](https://github.com/BlickLabs/DevOps/blob/master/resources/deploy-sample.sh) file to setup 
up the project startup

```bash
cd ..
mkdir deploy
vim deploy/deploy.sh
chmod +x deploy/deploy.sh
cd deploy
```

Run the project using the script, everything is is correct if the process not stop

```bash
./deploy.sh
```

The next step is setup nginx use the [nginx-sample](https://github.com/BlickLabs/DevOps/blob/master/resources/nginx-sample) file

```bash
sudo -s
cd /etc/nginx/
vim sites-available/<project>
ln -s sites-available/<project> sites-enabled/
vi sites-available/<project>
sudo service nginx restart
```

#### Ubuntu 14.04

The final step is create a system service to keep running the application, it can change between OS but in this repo its a 
[sample](https://github.com/BlickLabs/DevOps/blob/master/resources/service_sample.conf)

```bash
cd /etc/init
sudo vi <project>.conf
sudo service <project> start
sudo service <project> status
```

#### Ubuntu 16.04

In case the services is on Ubuntu 16.04, we have to modify a bit the process. 
We need to create a service inside `/lib/systemd/system/` with the *ProjectName* and 
modify the next [template](https://github.com/BlickLabs/DevOps/blob/master/resources/projectService.service).

> *Don't forget to modify the ExecStart line inside the project to point to the deploy script you modified!*

### Update django project.<a name="update-django-project"></a><sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>


For update django project, locate this

The virtualenv, usually located on the user root folder as ``` .venv ```

```bash
$ source <virtualenv_folder>/bin/activate
```

The env file, usually located on the user root folder as ``` .env ```, it contains the enviroment variables required to 
run the project

```bash
$ source .env
```

If there is no env file, the env variables are located in the .bashrc file, so you dont need to load any other file

NOTE: Always load the env file after the virtualenv

Once we load the virtualenv and the env variables, go to the project folder (the manage.py file is here)

```bash
$ python manage.py migrate
$ python manage.py collectstatic
$ sudo service nginx restart
$ sudo service <project_service> restart
```