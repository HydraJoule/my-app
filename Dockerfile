# Use Python base image
FROM python:3.10-slim

# Set working directory inside container
WORKDIR /app

# Copy everything from current folder to /app
COPY . .

# Install Flask
RUN pip install flask

# Command to run the app
CMD ["python", "app.py"]
