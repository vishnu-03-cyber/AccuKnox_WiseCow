FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y fortune-mod cowsay netcat bash && \
    # Create symlinks for fortune and cowsay
    ln -s /usr/games/fortune /usr/local/bin/fortune && \
    ln -s /usr/games/cowsay /usr/local/bin/cowsay && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY wisecow.sh .
RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["bash", "./wisecow.sh"]
