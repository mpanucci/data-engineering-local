FROM jupyter/pyspark-notebook:spark-3.3.2

WORKDIR /home/jovyan/work/

# Enabling Delta in Notebooks
ARG DELTA_CORE_VERSION="2.2.0"
RUN pip install --no-cache-dir delta-spark==${DELTA_CORE_VERSION} && \
    fix-permissions "${HOME}" && \
    fix-permissions "${CONDA_DIR}"

# Install system dependencies, upgrade pip for root, and install Poetry for jovyan
# Running as root for apt-get and system pip upgrade
USER root
RUN apt-get -qq update && \
    apt install -y --no-install-recommends curl netcat apt-utils gstreamer1.0-libav libavcodec58 ffmpeg && \
    pip install -U pip
USER $NB_UID

# Install Poetry for the jovyan user
RUN curl -sSL https://install.python-poetry.org | python3 -

# Set Spark Config (as jovyan, assuming SPARK_HOME is writable or sudo is not needed for this)
# If SPARK_HOME/conf is not writable by jovyan, these echos will fail.
# The base image jupyter/pyspark-notebook should ensure SPARK_HOME is configured correctly.
RUN echo 'spark.sql.extensions io.delta.sql.DeltaSparkSessionExtension' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.sql.catalog.spark_catalog org.apache.spark.sql.delta.catalog.DeltaCatalog' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.jars.packages org.apache.spark:spark-avro_2.12:3.4.1,io.delta:delta-core_2.12:2.4.0,org.apache.hadoop:hadoop-aws:3.3.2' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.hadoop.fs.s3a.impl org.apache.hadoop.fs.s3a.S3AFileSystem' >> "${SPARK_HOME}/conf/spark-defaults.conf" && \
    echo 'spark.hadoop.fs.s3a.path.style.access true' >> "${SPARK_HOME}/conf/spark-defaults.conf"  && \
    echo 'spark.hadoop.fs.s3a.aws.credentials.provider org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider' >> "${SPARK_HOME}/conf/spark-defaults.conf"

ENV PATH="/home/jovyan/.local/bin:$PATH"
# The chmod 777 and chown root:root for ~/.local were problematic and likely misdirected.
# Poetry is now installed as jovyan, so /home/jovyan/.local will be owned by jovyan.
# fix-permissions in the first RUN block should handle permissions for /home/jovyan correctly.

# Trigger download of delta lake files and Spark session initialization
RUN echo "from pyspark.sql import SparkSession" > /tmp/init-delta.py && \
    echo "from delta import *" >> /tmp/init-delta.py && \
    echo "spark_delta = configure_spark_with_delta_pip(SparkSession.builder).getOrCreate()" >> /tmp/init-delta.py && \
    python /tmp/init-delta.py && \
    rm /tmp/init-delta.py && \
    echo "from pyspark.sql import SparkSession" > /tmp/init-session.py && \
    echo "spark_session = SparkSession.builder.getOrCreate()" >> /tmp/init-session.py && \
    python /tmp/init-session.py && \
    rm /tmp/init-session.py

# Config Poetry and install project dependencies
COPY poetry.lock .
COPY pyproject.toml .
RUN poetry config virtualenvs.create false && \
    poetry install && \
    # Clean up poetry cache if any, and other temp files if necessary
    rm -rf /home/jovyan/.cache/pypoetry

# Install Postgres Driver
ARG DRIVER_POSTGRES_VERSION=42.6.0
ENV POST_URL https://jdbc.postgresql.org/download/postgresql-${DRIVER_POSTGRES_VERSION}.jar
RUN wget ${POST_URL} && \
    mv postgresql-${DRIVER_POSTGRES_VERSION}.jar /home/jovyan/.ivy2/jars/ && \
    fix-permissions /home/jovyan/.ivy2
ENTRYPOINT [ "./entrypoint.sh" ]