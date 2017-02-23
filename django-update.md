This Guide is for distributions based on Debian
------

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
