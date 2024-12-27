# Use a lightweight Python base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /betteropinions-app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the entire repository content
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Debug: List contents of the current directory
RUN pwd && ls -la

# Collect static files (if needed)
RUN python manage.py collectstatic --noinput

# Expose the application port
EXPOSE 8000

# Set the entry point for the application
CMD ["gunicorn", "betteropinions.wsgi:application", "--bind", "0.0.0.0:8000"]
