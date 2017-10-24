# Instalación de un Wordpress dedicado

* Acceder al servidor: (es necesario contar con el archivo pem)

```bash
ssh -i ~/.ssh/amazon_keys/blick.pem ubuntu@sandbox.static.getmore.mx -o ServerAliveI
nterval=60
```

* Crear un usuario en el sistema operativo, se recomienda que el usuario tenga el mismo nombre que el proyecto

```bash
sudo useradd <NOMBRE_PROYECTO_O_BLOG> -g sudo -m
sudo passwd <NOMBRE_PROYECTO_O_BLOG>
su <NOMBRE_PROYECTO_O_BLOG>
```

* Instalar dependencias de php (en caso de ser necesarias)

```bash
sudo apt-get install build-essential php-fpm php-mysql php-mcrypt php-cli php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc
```

* Instalar nginx (en caso de ser necesario)

```bash
sudo apt-get install nginx
```

* _Como el usuario logeado_, crear carpeta en `home` para blog

```bash
mkdir -p ~/blog
```

* _Como el usuario logeado_, Entrar a la carpeta de blog

```bash
cd ~/blog
```

* _Como el usuario logeado_, Descargar Wordpress

```bash
curl -O https://wordpress.org/latest.tar.gz
```

* _Como el usuario logeado_, Descomprimir Wordpress

```bash
tar xzvf latest.tar.gz
```

* _Como el usuario logeado_, Crear el archivo de configuración de wordpress (tomando el que viene como ejemplo dentro del proyecto)

```bash
cp wordpress/wp-config-sample.php wordpress/wp-config.php
```

* _Como el usuario logeado_, Crear carpeta de upgrade de wordpress

```bash
mkdir wordpress/wp-content/upgrade
```

* Crear usuario en la base de datos

> Este proceso se tiene que hacer en el gestor de MySQL que le corresponda, revisar Accesos a servidores en caso de ser necesario. * NO OLVIDES CAMBIAR <NOMBRE_PROYECTO_O_BLOG> por la información correspondiente!! *

```sql
CREATE DATABASE wordpress_<NOMBRE_PROYECTO_O_BLOG>;

CREATE USER 'wordpress_user_<NOMBRE_PROYECTO_O_BLOG>'@'%' IDENTIFIED BY '<PASSWORD>';
GRANT ALL PRIVILEGES ON wordpress_<NOMBRE_PROYECTO_O_BLOG>.* TO 'wordpress_user_<NOMBRE_PROYECTO_O_BLOG>'@'%';

FLUSH PRIVILEGES;
``` 

* Obtener el SALT seguro de Wordpress, desde una pestaña nueva en tu terminal, ejecuta el siguiente comando.

```bash
curl -s https://api.wordpress.org/secret-key/1.1/salt/
```
* _Como el usuario logeado_, Copiar el contenido del SALT seguro en el archivo de wp-config.php

> Es necesario sobreescribir la configuración existente.

* _Como el usuario logeado_, Configurar la base de datos en el archivo de wp-config.php

> Agregar los valores del usuario/base de datos/servidor, donde se creó todo previamente.

* Generar archivo de Nginx para que pueda cargar el sitio de wordpress

> *Este proceso se debe generar como super usuario!*

```bash
touch /etc/nginx/sites-enabled/project-<NOMBRE_PROYECTO_O_BLOG>
```

* Incluir el siguiente contenido en el archivo recien creado.

> *Este proceso se debe generar como super usuario!*

> *No olvides cambiar las rutas correspondientes del proyecto!*

> *No olvides agregar los dominios correspondientes, son los que se encuentran en el bloque de `server_name`* 

```nginx
server {
	listen 80;
    listen [::]:80 ipv6only=off;
    server_name <NOMBRE_DOMINIO_1> <NOMBRE_DOMINIO_2>;

    root /home/<NOMBRE_PROYECTO_O_BLOG>/blog/wordpress;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ /favicon.ico {
        access_log off;
        log_not_found off;
    }

    location ~ \.php$ {        
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }

    location ~ /\.ht {
    	deny all;
    }

    access_log  /var/log/nginx/$host-access.log;
}

```

* Verifica la configuración de Nginx, en caso de que falle, habrá que corregirla.

> *Este proceso se debe generar como super usuario!*

```bash
nginx -t
```

* Recarga Nginx 

> *Este proceso se debe generar como super usuario!*

```bash
service nginx reload
```

* Configura los DNS para que apunten al servidor correspondiente

> Revisa el inventario para saber que servidores son los que tienen instalado PHP o bien, usa la IP de la instancia que guardará a wordpress

* Accede al sitio mediante la URL que le corresponde y termina de configurar Wordpress.
