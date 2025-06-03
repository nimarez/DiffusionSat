FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

# (Optional) Install Python 3 and pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip --no-install-recommends && \
    pip3 install --no-cache-dir notebook && \
    rm -rf /var/lib/apt/lists/*

# Copy your application code in and set up entrypoint/cmd
COPY . /app
WORKDIR /app

# Need to pin numpy to 1.26.4 a bunch of packages below need numpy < 2.0.0
RUN pip install numpy==1.26.4
RUN pip install torch==2.2.2 torchvision==0.17.2 --index-url https://download.pytorch.org/whl/cu121
RUN pip install -e ".[torch]"  # install editable diffusers
RUN pip install -r requirements_remaining.txt

# Create a volume for model checkpoints
VOLUME ["/app/checkpoints"]

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

