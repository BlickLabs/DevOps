# Blick DevOps

## ¿Qué voy a encontrar dentro de este repositorio?

Dentro de este repositorio, vas a encontrar convenciones en el despliegue de los proyectos actuales, tanto frontend como 
backend, y practicas recomendadas para el devops

## Aspectos Generales

### Conexion a los servidores

Para la conexión vas a nesesitar la llave .pem de acceso, puedes solicitarla a cualquiera de los miemobros del equipo de 
desarrollo, para conectarte, basata con usar el comando

```bash
$ ssh -i <llave.pem> user@public-ip
```

### Manejo de usuarios y roles

Para cada proyecto nuevo, se debe crear un nuevo usuario, este usuario va a contener los archivos del proyecto, en caso de 
ser una aplicacion, esta se debe correr bajo el nuevo usuario

Para crear un nuevo usuario

```bash
$ sudo useradd <username> -g sudo -m
$ sudo passwd <username>
$ su <username>
```

#### Contraseña de los usuarios

Por convencion, la contraseña de los usuarios estara conformada por

```
<username>_sudo
```

Por ejemplo, si el usuario se llamara ``` mike ``` la contraseña seria ``` mike_sudo ```

#### Roles en bases de datos

Tenemos aplicaciones que requieren conexion a base de datos, para estas, crearemos roles que solo tendran acceso a las bases 
de datos involucradas en el proyecto, y usaremos la misma convencion que en los usuarios del sistema

Por ejemplo, para postgresql

```bash
$ sudo su postgres
$ createdb <db_name>
$ createuser -P <db_username>
$ psql
=# GRANT ALL PRIVILEGES ON DATABASE <db_name> TO <db_username>;
=# \q
$ exit
```

## Proyectos "Frontend Only"

Se considera un projecto "frontend only" aquellos que no requieren ninguna instancia de backend, por ejemplo, un 
comingosoon, o landing pages. <br> <br>
Toda la documentacion nesesaria para la compilacion de los archivos se encuentra en este 
[Link](https://github.com/BlickLabs/generator-frontend-dev)

### Despliegue

Una vez que los archivos ya estan listos para produccion, nesesitaremos que nginx reconozca y sirva estos archivos al 
publico, configuraremos nginx de la siguiente manera

```bash
$ sudo -s
$ cd /etc/nginx/
$ vim sites-available/<proyecto>
$ ln -s sites-available/<proyecto> sites-enabled/
$ service nginx restart
$ exit
```











