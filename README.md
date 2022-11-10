# Java-Docker
Como crear una aplicación Java en un contenedor Docker

Java es uno de los lenguajes más populares y es compatible con muchas aplicaciones empresariales. La ejecución de Java en máquinas locales requiere la instalación de Java IDE, Java JDK, Java JRE y requiere la configuración de rutas y variables de entorno. Esto puede parecer una tarea ardua, especialmente si solo desea ejecutar un programa simple.

Docker es una tecnología revolucionaria que permite empaquetar las aplicaciones en contenedores que incluyen todo lo necesario para que se puedan ejecutar de manera aislada. Cada contenedor almacena el código fuente de la aplicación, los archivos de configuración y todas las dependencias software que necesita permitiendo acelerar el proceso de desarrollo de las aplicaciones, facilitando la forma de distribuirlas y acelerando la automatización del despliegue en producción.

En esta práctica, analizaremos cómo ejecutar Java dentro de contenedores Docker.

Para empezar debemos aprovisionar una maquina Ubuntu Server en AWS. A continuación se adjunta manual para llevar a cabo este proceso

https://educacionadistancia.juntadeandalucia.es/centros/almeria/pluginfile.php/627678/mod_page/content/8/uso_de_aws.pdf

Después de lanzar dicha instancia, conectaremos a la misma a través de ssh usando las claves que hemos generado e instalaremos Docker

Para ello seguiremos los pasos del siguiente enlace uno a uno:

https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04

Una vez instalado y configurado los permisos necesarios, comprobamos su correcto funcionamiento con el comando:

    ubuntu@aws:~$ docker ps
    CONTAINER ID   IMAGE    COMMAND    CREATED        STATUS            PORTS    NAMES

Si en lugar de esa salida nos devuelve esta:

    Output
    docker: Cannot connect to the Docker daemon. Is the docker daemon running on this host?.
    See 'docker run --help'.

Los permisos no se aplicaron correctamente o debemos reiniciar la maquina.

Una vez esta todo correcto vamos a empezar a crear nuestra aplicación java empaquetada en un contenedor de Docker

Paso 1. Crear carpeta llamada java-app y acceder a la misma

Paso 2: Crear la aplicación Java

Utilizaremos una aplicación Java de los ejercicios realizados en los temas anteriores, como por ejemplo

Paso 3: crea el archivo Dockerfile

Eche un vistazo al archivo Dockerfile:

    FROM eclipse-temurin:latest
    WORKDIR /home/ubuntu/java-app
    COPY . /home/ubuntu/java-app
    RUN javac aplicacion.java
    CMD ["java", "aplicacion"]

En el Dockerfile anterior , hemos extraído la imagen base de Java de DockerHub . Para esta práctica vamos a trabajar con una imagen de eclipse-temurin.
Oracle ha decidido dejar de crear imágenes oficiales de Java para Docker y se recomienda usar alguna de las alternativas.

https://hub.docker.com/_/openjdk

Hemos configurado el directorio de trabajo y copiamos los archivos al directorio de trabajo. Después de eso, compilamos nuestra aplicación Java y ejecutamos el ejecutable.

En la carpeta en la que estamos, java-app debe haber 2 archivos, el archivo .java y otro llamado dockerfile.

Paso 4: Crear la imagen de Docker

Ahora, puede usar el comando de creación de nuestra imagen Docker que llamaremos java-app:

    docker build -t java-app .

Para la práctica he usado el programa del ratón versión reallizada con hilos con la implementación Runnable, devolviendo el comando anterior los siguiente:

    ubuntu@aws:~/java-app$ docker build -t java-app .
    Sending build context to Docker daemon  4.096kB
    Step 1/5 : FROM eclipse-temurin:latest
    latest: Pulling from library/eclipse-temurin
    e96e057aae67: Pull complete
    014fa72e018d: Pull complete
    e1edabaab1df: Pull complete
    24a80203ae94: Pull complete
    Digest: sha256:c08e6cabe5a01c84100b50f57e3c492e276783a6b9a937c0f1d4f1112d1b565d
    Status: Downloaded newer image for eclipse-temurin:latest
    ---> a6d8b27b4ecf
    Step 2/5 : WORKDIR /home/ubuntu/java-app
    ---> Running in 3c9eaa9a96dc
    Removing intermediate container 3c9eaa9a96dc
    ---> 6e56d9ae8a1f
    Step 3/5 : COPY . /home/ubuntu/java-app
    ---> f242c70c6db7
    Step 4/5 : RUN javac RatonSimple.java
    ---> Running in cb0856868ccf
    Removing intermediate container cb0856868ccf
    ---> 900367c8cc9b
    Step 5/5 : CMD ["java", "RatonSimple"]
    ---> Running in 0257c4730e8b
    Removing intermediate container 0257c4730e8b
    ---> 9fa2f8f0033f
    Successfully built 9fa2f8f0033f
    Successfully tagged java-app:latest

Si revisamos las imagenes creadas:

    ubuntu@aws:~/java-app$ docker images
    REPOSITORY               TAG       IMAGE ID       CREATED         SIZE
    java-app                 latest    9fa2f8f0033f   3 minutes ago   472MB
    eclipse-temurin          latest    a6d8b27b4ecf   40 hours ago    472MB

Vemos que se han creado 2 imagenes, una conteniendo JDK que se ha descargado de docker hub y la otra con JDK y la aplicación empaquetada que hemos creado con el dockerfile

Paso 5: ejecutar el contenedor de Docker

Una vez que haya creado su imagen de Docker, puede ejecutar su contenedor de Docker con el comando de ejecución de Docker. Esto ejecutará la aplicación java que veremos por el terminal:

    docker run -it --name ratonhilos java-app

