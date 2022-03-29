FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9-alpine3.14
LABEL description="Hello SAS"
LABEL version="0.0.1"

WORKDIR /src
COPY ./requirements /requirements
RUN pip install -r /requirements/development.txt
ENTRYPOINT [ "/start-reload.sh" ]
