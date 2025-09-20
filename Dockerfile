FROM ubuntu:20.04

# install dependencies
RUN apt-get update && \
    apt-get install -y fortune-mod cowsay netcat && \
    rm -rf /var/lib/apt/lists/*

# set working dir
WORKDIR /app

# copy the script
COPY wisecow.sh .

# make script executable
RUN chmod +x wisecow.sh

# expose app port
EXPOSE 4499

# run the app
CMD ["./wisecow.sh"]
