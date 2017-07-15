# Grails

## Index<a name="index"></a> 

* [Basic Stack](#basic-stack)
* [Install Mysql and configure](#database)
* [Database Migrations](#migrations)
* [Properties externalization](#properties)
* [Preparing the environment for running/deploying](#preparing-environment)
* [AWS: Connection via SSH](#aws-ssh-connection)
* [AWS: System Service (Ubuntu)](#aws-service-ubuntu)
* [AWS: Logs](#aws-logs)

------

### Basic stack. <a name="basic-stack"></a> <sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

- Java 7/8 (Java 8 desired)
- Grails 3.1.15 (Using gradle wrapper).
- A MySQL 5.7 database.
- Eclipse (GGTS version), Netbeans, IntelliJ (15 or higher) or any advanced text editor.

### MySQL installation/configuration.<a name="database"></a> <sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

First we need to install MySQL on an empty system, we're considering an **Ubuntu/Debian AWS Machine**, this tutorial may differ considering the *NIX system to be used.
To install _MariaDB_ on your system, just type on your terminal prompt:

```bash
sudo apt-get update
sudo apt-get install mysql-server-5.7 -y
```
After configuring and setting the passwords, the install will finish. Now you need to create a user and cierralo database, access to the mysql server using the next bash clause.

```bash
sudo mysql -u root -p
```

This will ask you for the password you already set and will log you in to the MySQL server. Now it's time to create a new user to log into the database without using the sudo privileges, to do this, just follow the next SQL statements.

> Don't forget to change the username and the password on the code below!

```SQL
CREATE USER 'username'@'localhost' IDENTIFIED BY 'some_password';
GRANT ALL PRIVILEGES ON * . * TO 'username'@'localhost';
FLUSH PRIVILEGES;
CREATE DATABASE cierralo_core CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```
Logout from MySQL server and the log in using your new username.

The integration with Grails it's easier with MySQL than other DBMS (like Oracle or Postgres). In case you need a GUI for MySQL you can take a look to MySQL workbench, SQL Developer, DBeaver or DataGrip. Most of them are available to download on the internet or using your desired package manager.

### What about the groovy environment?.<a name="groovy"></a> <sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

> Apache Groovy is a powerful, optionally typed and dynamic language, with static-typing and static compilation capabilities, for the Java platform aimed at improving developer productivity thanks to a concise, familiar and easy to learn syntax. It integrates smoothly with any Java program, and immediately delivers to your application powerful features, including scripting capabilities, Domain-Specific Language authoring, runtime and compile-time meta-programming and functional programming. 

**TL;DR**. Groovy it's a programming language that compiles to Java bytecode. This interesting feature let us play with a dynamic language which can coexist with current java applications. Frameworks like Gradle, Spock, Grails or Geb are based on Groovy's features. 

We're going to be using Grails 3.* and Groovy 2.4.* If you know Java, you will be comfortable with Groovy, you can find a lot of information on the internet about the language, but if you want, here's a link to some books, they're on my [Google Drive](https://drive.google.com/open?id=0Bxlkyv50FZd6fkdiNGhWRDFEQ3FvaDZxQl9KUUtwX0t2cGtWQUN3ZkZveWNXT2piV0xYWFE).

You can take a look to the whole Groovy environment on the [next link](http://www.groovy-lang.org/ecosystem.html).

### Database Migrations.<a name="migrations"></a> <sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

The database migrations is being handled by **Flyway** using the gradle plugin, this is the first thing you must do before start working. We're planning to use this process to keep track of all the changes made to the database, the versioning process is also handled by Flyway. For further information check their [website](https://flywaydb.org/documentation/).

After entering the project, you just have to run the migrations. This command will do the changes to the tables upto the latest stable version. Consider the next 
command.

```bash
gradle flywayMigrate -Pflyway.user=YOUR_USER\
-Pflyway.schemas=cierralo_core\
-Pflyway.password=YOUR_PASSWORD\
-Pflyway.url=jdbc:mysql://localhost/cierralo_core\
-Pflyway.baselineOnMigrate=true\
-Pflyway.baselineVersion=1
```

> In case you don't have gradle installed, you can use the wrapper that is part of the project, replace **gradle** with **./gradlew**

There are so many parameters to Flyway, just read the docs. After the migration process is done, you can start working with your project.

### Properties externalization.<a name="properties"></a> <sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

Properties externalization it's a common bug on several applications, it's always easier to just generic variables or configurations for every developer or environment. We faced this issue on whilst deploying on development (just imagine the Pain in the *ss if were production!) so we decided to stop being tied to a centralized configuration and use a template.

The template file it's part of our repository, located at _grails-app/conf/application.yml.template_.

There you can find many configurations that can be used amongst any environment (localhost, sandbox/development, integration, production), it's just matter of change the information that is in upper case and use your personal or defined one.

You need to create a file called _application.yml_ inside the _conf/_ directory of your grails project and update the values you might need.

Also you can copy the _application.yml.template_ into _application.yml_ and just modify what you need.

> Don't forget to update the template if needed! 
> Consider the environments if needed (production, development)

### Preparing the environment for running/deploying.<a name="preparing-environment"></a> <sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

#### As root

1. Create a folder called `/opt/deployment/`
2. Copy the file inside the `resources` dir of this folder. The file is `grailsScript.sh`. Here's the [file](https://github.com/BlickLabs/DevOps/blob/master/resources/projectService.service)
3. Keep reading

### Operating Service for deploying a Java project at AWS (Ubuntu).<a name="aws-service-ubuntu"></a> <sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub>

We're using an AWS with Ubuntu installed. We need to follow some steps before we start playing around with the project on development or production. **_Most of this commands need to be executed as root_**.

Before we start with the service process, it's mandatory to create a symbolic link between our grails version and the _**bin/**_ directory, just copy and execute the next command on your terminal.

This will help us handling the grails executable amongst every user. Very useful for a system service.

Then we need to create an operating system service (like http servers). First a service file must be created, follow the next command.

```bash
sudo touch /lib/systemd/system/serviceName.service
```

Then we need to add some information to the service, using any text editor (vim or nano) add the next information to the file. If you need further information, check [Ubuntu's documentation](https://wiki.ubuntu.com/SystemdForUpstartUsers).

* PROJECT_HOME = Repository location
* ENVIRONMENT = env, prod
* PORT = The port that will be used
* LOG_LOCATION = /var/log/directory

```bash
[Unit]
Description=ServiceName application server

[Service]
Type=simple
ExecStart=/bin/sh -c "/opt/deployment/grailsScript.sh -h PROJECT_HOME -e ENVIRONMENT -p PORT -l LOG_LOCATION-c -a -r > /var/log/serviceName.log 2>&1"
```

This will automatically create the service on the operating system, this can help us to start/stop the service using just one command. 

> **/opt/deployment/grailsScript.sh** it's part of this repository and is a utility to deploy/run the project. Contains a basic usage, just enter to the project and type on the terminal _/opt/deployment/grailsScript.sh_ and see the help

After the service is created, we need to reload the system's daemons, this can be done using the next command.

```bash
sudo systemctl daemon-reload
```

Finally you can use the service, just type on the terminal

```bash
sudo service serviceName [start|stop|restart]
```

### AWS: Cierralo logs.<sub><sub><sub><sub>[Index](#index)</sub></sub></sub></sub><a name="aws-logs"></a>

Logback (the logging engine provided by grails) can handle several environments and logging process. For development environments, the whole stacktrace appears on the STDOUT (terminal) and also the log is appended to a file, located inside the _build/_ directory. 

The directory of the log file can be configured via System variable, if the variable does not exist, creates the log file into the build directory mentioned previously. In case you want to change the path for the logs, configure the `-l` parameter on your deployment script.

In case you need to check a log, just use the next command.

```bash
tail -f /var/log/logName.log
```

The previous log, it's the one generated by the STDOUT, useful for development/sandbox environment. The next logs are just the stacktraces generated by the application, they are clasified by date and are located into the next folder (remember that you need to configure the path if needed, the script does it for you).

```bash
tail -f /var/log/directory/logs/YYYY-MM-DD_HH-MM-<project>.log
```

Where _YYYY-MM-DD_HH-MM_ is the date you'd like to look for.

> **Don't forget that the paths must have the privileges to write!!!**