# Lightweight base image
FROM python:3.9.20-alpine3.20

# Set the working directory inside the container to /app
WORKDIR /app

# Copy app files to the working directory
COPY ./ /app

# Install dependencies without cache to reduce image size
# Remove requirements.txt file after installation to keep the container clean
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

# Expose port 5000 to allow external access
EXPOSE 5000

# Run the Flask application
CMD flask run --host 0.0.0.0