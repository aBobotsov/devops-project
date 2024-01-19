FROM python:3.13.0a3-alpine

WORKDIR /usr/src/app

COPY src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src/app.py .

EXPOSE 5000

CMD ["python", "app.py"]
