FROM python:3.9-slim

WORKDIR /mlflow/

ARG MLFLOW_VERSION
RUN pip install --no-cache-dir mlflow==${MLFLOW_VERSION}

EXPOSE 5000

# Ref: https://github.com/mlflow/mlflow/issues/6274#issuecomment-1196106372
CMD mlflow server \
    --backend-store-uri ${BACKEND_STORE_URI} \
    --serve-artifacts \
    --host 0.0.0.0 \
    --port 5000
