FROM python:3.9
COPY main.py /app/
WORKDIR /app
CMD ["python", "main.py"]
