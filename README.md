# Data Engineering Local Environment

A local development environment for exploring and testing various data engineering tools and projects. This setup uses Docker and Make to simplify service management.

## Table of Contents

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
- [Project Structure](#project-structure)
- [Available Services & Tools](#available-services--tools)
- [Usage](#usage)
  - [Using the Makefile](#using-the-makefile)
  - [Direct Docker Compose Usage](#direct-docker-compose-usage)
- [Contributing](#contributing)
- [License](#license)

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed on your system:

- **Docker**: For running containerized services.
- **Docker Compose**: For defining and running multi-container Docker applications.
- **Make**: For using the Makefile to manage services.
- **Git**: For cloning the repository.

### Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/data-engineering-local.git
    cd data-engineering-local
    ```
    *(Replace `your-username` with the actual path if different)*

2.  **View available commands:**
    The Makefile provides several commands to help you manage the services. To see the list of available commands, run:
    ```bash
    make help
    ```

## Project Structure

This project is organized into directories, where each directory typically represents a specific data engineering tool or service. Inside each service directory, you'll usually find:

-   A `docker-compose.yaml` file for defining the service stack.
-   Custom `Dockerfile`(s) if the service requires a custom image (e.g., `jupyter`, `nifi`).
-   Configuration files specific to that service.

The main control script `main.sh` is used by the `Makefile` to manage these services.

## Available Services & Tools

Here's a list of the services and tools available in this environment. You can use `make list_services` to see a filtered list of directories that might be considered primary services to build or run.

-   **airflow**: A platform to programmatically author, schedule, and monitor workflows.
-   **dagster**: A data orchestrator for developing and maintaining data assets.
-   **druid**: A real-time analytics database designed for fast slice-and-dice analytics ("OLAP" queries) on large data sets.
-   **jupyter**: Provides Jupyter Notebook and JupyterLab for interactive computing.
-   **kafka**: A distributed event streaming platform.
-   **metabase**: A fast, open-source way to ask questions and learn from data.
-   **minio**: An S3-compatible object storage server.
-   **mongodb**: A NoSQL document-oriented database.
-   **mysql**: A popular open-source relational database.
-   **nifi**: An easy to use, powerful, and reliable system to process and distribute data.
-   **postgresql**: A powerful, open-source object-relational database system.
-   **prefect**: A workflow orchestration tool to build, run, and monitor data pipelines.
-   **presto**: A distributed SQL query engine for big data. (Note: Trino is a fork of Presto)
-   **trino**: A fast distributed SQL query engine for big data analytics (formerly PrestoSQL).

## Usage

### Using the Makefile

The `Makefile` provides convenient targets for managing services. Remember to set the `SERVICE` variable to specify which service you want to interact with.

-   **Show help:**
    ```bash
    make help
    ```

-   **List available service directories (filtered):**
    ```bash
    make list_services
    ```

-   **Start a service:**
    (This typically calls `docker-compose up -d` via `main.sh`)
    ```bash
    make start SERVICE=jupyter
    make start SERVICE=kafka
    ```

-   **Stop a service:**
    (This typically calls `docker-compose down` via `main.sh`)
    ```bash
    make stop SERVICE=jupyter
    ```

-   **Build a custom Docker image:**
    Some services (like `jupyter` or `nifi`) have custom Dockerfiles.
    ```bash
    make build_image SERVICE=jupyter IMAGE_NAME=my-custom-jupyter
    # If IMAGE_NAME is omitted, it defaults to the SERVICE name:
    make build_image SERVICE=nifi
    ```

### Direct Docker Compose Usage

For more fine-grained control, you can navigate to a service's directory and use `docker-compose` commands directly:

```bash
cd jupyter/
docker-compose up -d
# ... later ...
docker-compose down
cd ..
```

## Contributing

Contributions are welcome! If you have improvements, bug fixes, or new services to add:

1.  Open an issue to discuss the change.
2.  Fork the repository, make your changes, and submit a pull request.

## License

This project is licensed under the terms specified in the `LICENSE` file. Please see the `LICENSE` file for details.
