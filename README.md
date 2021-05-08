# Algotrading Stack


## Comenzando 🚀

Uno de las actividades recurrentes es armar un maquina que disponga de todos los servicios necesarios para empezar a desarrollar o poner en produccion estrategias de algotrading


### Pre-requisitos 📋

Solo tienes que tenes instalado docker en una maquina (linux, obvio)

Aqui encontraras una guia para instalar docker en Ubuntu 20.04
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04-es

Toda la instalaci[on esta armado con un stack de docker, que principalmente utiliza el comando docker-compose
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04-es

### Instalación 🔧

La instalación es muy sencilla, veamos...

1) Copiar todo el contenido en una carpeta, ejemplo 'algotrading'

2) Edita las variables del archivo .env, ya que se uilizan en el archivo docker-compose.yaml para configurar los servicios de los contenedores

    WD="directorio de trabajo, donde reside esta misma carpeta, en el ejemplo seria la ruta completa de 'algotrading'"
    
    ND="directorio donde se alojaron los notebooks y demas archivos python que seran accesibles desde los contenedores"

    TWSUSERID="usuario del gateway de Interactive broker"
    
    TWSPASSWORD="password del gateway de Interactive broker"
    
    TRADING_MODE="modalidad del gateway de Interactive broker paper o live"

    TZ="timezone del container"

3) Ejecutar el script
./starter_script.sh

### Gestión de los contenedores 🔩

Para ver el status y administrar los contenedores puedes usar el comando docker-compose o tambien la interfaz web provista por Portainer:

    * Portainer:        http://localhost:9000

La primera vez que ingreses te va a solicitar crear una password para la cuenta admin.

### Servicios incluidos ⌨️

Los diferentes servicios del stack se pueden acceder a traves:

    * Airflow:          http://localhost:8080
    * Superset:         http://localhost:8088
    * Celery Flower:    http://localhost:5555
    * Jupyter Notebook: http://localhost:8888
    * MLflow:           http://localhost:5500
    * PgAdmin:          http://localhost:1234
    * IBGateway:       via vnc: localhost:5999

## Paquetes y librerias 📦

En los archivos requirements.txt encontraras las librerias que se han incluido, he incluido entre otras:

    * psycopg2-binary
    * mlflow
    * sklearn
    * xgboost
    * IBPy2
    * ib_insync
    * backtrader
    * bs4
    * peewee
    * xlrd
    * ffn
    * pyfolio
    * quantstats
    * riskfolio-lib

Adicionalmente en el Dockerfile de Jupyter Notebook se encuentran los extensiones que se han habilitado a los notebooks.

## Agradecimientos 📢

* A @paduel por la inspiración y el empujoncito en armar este stack 🤓
* Basado en las ideas y en el trabajo de @saeed349 
https://github.com/saeed349/Microservices-Based-Algorithmic-Trading-System
* Container IBGateway desarrollado por @mgvazquez https://github.com/mgvazquez/ibgateway 


