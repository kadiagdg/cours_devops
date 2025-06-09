FROM python:3.13-slim

WORKDIR /app

COPY main.py .
COPY requirements.txt .

RUN pip install -r requirements.txt

EXPOSE 8000

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["fastapi run main.py --host 0.0.0.0 --port 8000"]
