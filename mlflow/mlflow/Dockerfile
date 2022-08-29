FROM python:3-slim

WORKDIR /mlflow/

ARG MLFLOW_VERSION
RUN pip install --no-cache-dir mlflow==${MLFLOW_VERSION}

EXPOSE 5000

CMD mlflow server --backend-store-uri ${BACKEND_URI} --default-artifact-root ${ARTIFACT_ROOT} --host 0.0.0.0 --port 5000