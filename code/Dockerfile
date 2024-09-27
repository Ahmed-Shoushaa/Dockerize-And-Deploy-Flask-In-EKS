FROM python:3.9.20-alpine3.20

WORKDIR /app

COPY ./ /app

RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

# Expose port 5000
EXPOSE 5000

CMD flask run --host 0.0.0.0