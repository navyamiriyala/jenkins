FROM python:3.9
COPY src/ /app/
WORKDIR /app
CMD ["python", "main.py"]
