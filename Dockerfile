FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9-alpine3.14
LABEL description="Hello SAS"

ADD ./entrypoint.sh /entrypoint.sh
ADD ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
WORKDIR /src
COPY ./src /src

ENTRYPOINT [ "/entrypoint.sh" ]
