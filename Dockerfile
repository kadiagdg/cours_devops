FROM ubuntu:24.04

WORKDIR /app

RUN apt-get update && apt-get install python3 python3-pip -y

RUN pip3 install -r requirements.txt

COPY main.py .
COPY requirements.txt .

EXPOSE 8000

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["fastapi run main.py --host 0.0.0.0 --port 8000"]
