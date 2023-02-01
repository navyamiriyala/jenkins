FROM python:3.9
RUN apt-get update && apt-get install -y git
COPY src/ /app/
WORKDIR /app
CMD ["python", "main.py"]
