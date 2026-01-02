# Algotrading Stack


## Comenzando 🚀

Uno de las actividades recurrentes es armar un maquina que disponga de todos los servicios necesarios para empezar a desarrollar o poner en produccion estrategias de algotrading, el objetivo de este proyecto es proveer toda la infraestructura necesaria sin necesidad de instalar software o componentes locales sino a traves de un entorno contenerizado y virtualizado con la tecnologia provista por docker.

### Pre-requisitos 📋

Solo tienes que tenes instalado docker en una maquina (linux, obvio)

Aqui encontraras una guia para instalar docker en Ubuntu 20.04
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04-es

Si insistes con Windows, quizas esta guia te pueda ayudar
https://www.simplilearn.com/tutorials/docker-tutorial/install-docker-on-windows

Luego toda la instalación esta armada con un stack completo e integrado de docker, que utiliza partir de utilizar comando docker-compose arma todo el stack de microservicios

### Instalación 🔧

La instalación es muy sencilla, veamos...

1) Copiar todo el contenido en una carpeta, ejemplo 'algotrading'

2) Edita las variables del archivo .env, ya que se uilizan en el archivo docker-compose.yaml para configurar los servicios de los contenedores

    WD="directorio de trabajo, donde reside esta misma carpeta, en el ejemplo seria la ruta completa de 'algotrading'"
    
    ND="directorio donde se alojaron los notebooks y demas archivos python que seran accesibles desde los contenedores"

    TWSUSERID="usuario del gateway de Interactive Brokers"
    
    TWSPASSWORD="password del gateway de Interactive Brokers"
    
    TRADING_MODE="modalidad del gateway de Interactive Brokers paper o live"

    TZ="timezone del gateway de Interactive Brokers"

    CUSTOM_USER="usuario de Metatrader Web"

    PASSWORD="password de Metatrader Web, si se deja en blanco entonces no se pedira autenticacion"

3) Debes crear la network algotrading_stack_default en docker con la subnet correspondiente para asignar las IPs correspondientes a cada servicio

4) Ejecutar el script
./starter_script.sh

### Gestión de los contenedores 🔩

Para ver el status y administrar los contenedores puedes usar el comando docker-compose o tambien la interfaz web provista por Portainer:

    * Portainer:        http://localhost:9000

La primera vez que ingreses te va a solicitar crear una password para la cuenta admin, y luego tendras acceso a la gestión y administracion de los contenedores, acceder a las consolas de los mismos, monitorear recursos y status de los servicios.

### Servicios incluidos ⌨️

Los diferentes servicios del stack se pueden acceder a traves:

    * Airflow:          http://localhost:8080
    * Mwtabase:         http://localhost:3001
    * Celery Flower:    http://localhost:5555
    * PgAdmin:          http://localhost:1234
    * Metatrader        http://localhost:3000 
                        mt5linux via host localhost port 8001
    * IBGateway         via vnc localhost:5999

## Paquetes y librerias 📦

En los archivos requirements.txt encontraras las librerias que se han incluido, he incluido entre otras:

    * sklearn
    * xgboost
    * ib_insync
    * backtrader2 (fork de backtrader con bugfixes)
    * vectorbt
    * ffn
    * pyfolio
    * quantstats
    * riskfolio-lib
    * mt5linux

## Agradecimientos 📢

* A @paduel por la inspiración y el empujoncito en armar este stack 🤓
* Basado en las ideas y en el trabajo de @saeed349 
https://github.com/saeed349/Microservices-Based-Algorithmic-Trading-System
* Para Metatrader he integrado la imagen desarrollada por @gmag11
https://github.com/gmag11/MetaTrader5-Docker-Image



