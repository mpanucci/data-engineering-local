FROM jupyter/pyspark-notebook:spark-3.3.2

WORKDIR /home/jovyan/work/

# Enabling Delta in Notebooks
ARG DELTA_CORE_VERSION="2.2.0"
RUN pip install --no-cache-dir delta-spark==${DELTA_CORE_VERSION} && \
    fix-permissions "${HOME}" && \
    fix-permissions "${CONDA_DIR}"

# Install Poetry
USER root
RUN pip install -U pip && \
    apt-get -qq update && \
    apt install -y --no-install-recommends curl netcat apt-utils gstreamer1.0-libav libavcodec58 ffmpeg && \
    curl -sSL https://install.python-poetry.org | python3 -

# Set Spark Config
RUN echo 'spark.sql.extensions io.delta.sql.DeltaSparkSessionExtension' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.sql.catalog.spark_catalog org.apache.spark.sql.delta.catalog.DeltaCatalog' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.jars.packages org.apache.spark:spark-avro_2.12:3.4.1,io.delta:delta-core_2.12:2.4.0,org.apache.hadoop:hadoop-aws:3.3.2' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.hadoop.fs.s3a.impl org.apache.hadoop.fs.s3a.S3AFileSystem' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.hadoop.fs.s3a.path.style.access true' >> "${SPARK_HOME}/conf/spark-defaults.conf"  && \
    echo 'spark.hadoop.fs.s3a.aws.credentials.provider org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider' >> "${SPARK_HOME}/conf/spark-defaults.conf"

ENV PATH="/home/jovyan/.local/bin:$PATH"
RUN chmod 777 -R ~/.local/
RUN chown -R root:root ~/.local/

USER $NB_UID

# Trigger download of delta lake files
RUN echo "from pyspark.sql import SparkSession" > /tmp/init-delta.py && \
    echo "from delta import *" >> /tmp/init-delta.py && \
    echo "spark = configure_spark_with_delta_pip(SparkSession.builder).getOrCreate()" >> /tmp/init-delta.py && \
    python /tmp/init-delta.py && \
    rm /tmp/init-delta.py

RUN echo "from pyspark.sql import SparkSession" > /tmp/init-session.py && \
    echo "spark = SparkSession.builder.getOrCreate()" >> /tmp/init-session.py && \
    python /tmp/init-session.py && \
    rm /tmp/init-session.py     

# Config Poetry
COPY poetry.lock .
COPY pyproject.toml .
RUN poetry config virtualenvs.create false && \
    poetry install

# Install Postgres Driver
ARG DRIVER_POSTGRES_VERSION=42.6.0
ENV POST_URL https://jdbc.postgresql.org/download/postgresql-${DRIVER_POSTGRES_VERSION}.jar
RUN wget ${POST_URL} && mv postgresql-${DRIVER_POSTGRES_VERSION}.jar /home/jovyan/.ivy2/jars/
ENTRYPOINT [ "./entrypoint.sh" ]