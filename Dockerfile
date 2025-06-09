FROM ubuntu:24.04

WORKDIR /app

RUN apt-get update && apt-get install python3 python3-pip -y
RUN pip3 install fastapi uvicorn

COPY main.py .

EXPOSE 8000

CMD ["python3", "/app/app.py"]
