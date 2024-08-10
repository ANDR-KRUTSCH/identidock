FROM python:3.11.9

RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi

WORKDIR /app

COPY app .

RUN pip install -r requirements.txt

USER uwsgi

EXPOSE 9090 9191

CMD ["/app/cmd.sh"]