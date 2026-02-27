# Algotrading Stack

Containerized infrastructure for developing and deploying algorithmic trading strategies using Docker.

Infraestructura contenerizada para desarrollar y poner en produccion estrategias de trading algoritmico usando Docker.

---

## Prerequisites / Pre-requisitos

- Docker and Docker Compose installed on a Linux machine.
- Docker y Docker Compose instalados en una maquina Linux.

Installation guides / Guias de instalacion:
- [Docker on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Docker on Windows](https://docs.docker.com/desktop/setup/install/windows-install/)

## Quick Start / Inicio Rapido

1. Clone this repository / Clonar este repositorio:
   ```bash
   git clone <repo-url> algotrading
   cd algotrading
   ```

2. Create and configure your environment file / Crear y configurar el archivo de entorno:
   ```bash
   cp .env.example .env
   # Edit .env with your values / Editar .env con tus valores
   ```

3. Run the starter script / Ejecutar el script de inicio:
   ```bash
   chmod +x starter_script.sh
   ./starter_script.sh
   ```

## Environment Variables / Variables de Entorno

See `.env.example` for all available variables with descriptions.
Consultar `.env.example` para ver todas las variables disponibles con sus descripciones.

Key variables / Variables principales:

| Variable | Description / Descripcion |
|---|---|
| `WD` | Working directory where this project resides / Directorio de trabajo donde reside el proyecto |
| `ND` | Notebooks directory accessible from containers / Directorio de notebooks accesible desde los contenedores |
| `TZ` | Timezone (e.g. `America/New_York`) / Zona horaria |
| `TWSUSERID` | Interactive Brokers Gateway username / Usuario del Gateway de IB |
| `TWSPASSWORD` | Interactive Brokers Gateway password / Password del Gateway de IB |
| `TRADING_MODE` | IB trading mode: `paper` or `live` / Modo de trading de IB |

## Services / Servicios

| Service / Servicio | URL | Description / Descripcion |
|---|---|---|
| Portainer | http://localhost:9000 | Container management UI / UI de gestion de contenedores |
| Airflow | http://localhost:8080 | Workflow orchestration / Orquestacion de workflows |
| Metabase | http://localhost:3001 | Business Intelligence dashboards / Dashboards de BI |
| Celery Flower | http://localhost:5555 | Celery task monitoring / Monitoreo de tareas Celery |
| pgAdmin | http://localhost:1234 | PostgreSQL administration / Administracion de PostgreSQL |
| MetaTrader 5 | http://localhost:3000 | MT5 web terminal (mt5linux on port 8001) / Terminal web MT5 |
| IB Gateway | vnc://localhost:5999 | Interactive Brokers Gateway via VNC |

## Architecture / Arquitectura

The stack is composed of the following containerized services:

El stack esta compuesto por los siguientes servicios contenerizados:

- **Apache Airflow** (API Server, Scheduler, DAG Processor, Triggerer, Worker, Flower) - Workflow orchestration / Orquestacion de workflows
- **PostgreSQL** (x2) - Airflow metadata DB + Master data warehouse / BD metadata de Airflow + Data warehouse principal
- **Redis** - Celery message broker
- **Metabase** - Business Intelligence platform / Plataforma de BI
- **Interactive Brokers Gateway** - IB API access / Acceso API de IB
- **MetaTrader 5** - MT5 trading platform / Plataforma de trading MT5
- **pgAdmin** - PostgreSQL web administration / Administracion web de PostgreSQL
- **Portainer** - Docker container management / Gestion de contenedores Docker
- **Nginx Reverse Proxy** - HTTP routing / Enrutamiento HTTP

## Python Libraries / Librerias Python

The `requirements.txt` files in `dockerfile_airflow/` and `dockerfile_jupyter_notebook/` include libraries for:

Los archivos `requirements.txt` en `dockerfile_airflow/` y `dockerfile_jupyter_notebook/` incluyen librerias para:

- **Data & ML**: pandas, numpy, scikit-learn, xgboost, lightgbm, statsmodels, shap
- **Backtesting**: backtrader2, vectorbt
- **Risk & Portfolio**: riskfolio-lib, quantstats, ffn, pyfolio
- **Broker APIs**: ib_insync, mt5linux, ccxt
- **Market Data**: yfinance, pandas_datareader, pandas_market_calendars
- **Visualization**: matplotlib, plotly, seaborn, mplfinance

## Container Management / Gestion de Contenedores

```bash
# Check status / Ver estado
docker-compose ps

# View logs / Ver logs
docker-compose logs -f <service-name>

# Stop all / Detener todo
docker-compose down

# Rebuild and restart / Reconstruir y reiniciar
docker-compose up -d --build
```

## Acknowledgements / Agradecimientos

- [@paduel](https://github.com/paduel) - Inspiration and initial push / Inspiracion y empujon inicial
- [@saeed349](https://github.com/saeed349) - [Microservices-Based Algorithmic Trading System](https://github.com/saeed349/Microservices-Based-Algorithmic-Trading-System)
- [@gmag11](https://github.com/gmag11) - [MetaTrader5 Docker Image](https://github.com/gmag11/MetaTrader5-Docker-Image)
