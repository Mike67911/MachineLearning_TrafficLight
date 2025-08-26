FROM cityflowproject/cityflow:latest

# Set working directory inside container
WORKDIR /app

# Copy your project files into container
COPY . /app

# Install Python dependencies if needed (optional)
# RUN pip install -r requirements.txt

# Default command: run your main script
CMD ["python3", "scripts/run_simulation.py"]