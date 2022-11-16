# Using official python image as a parent image
FROM python:latest
RUN apt-get update && apt-get install git -y && \
    apt -y install python3-pip && \
    pip install Flask && \
    apt upgrade -y
RUN git clone https://github.com/jamarikelly/kuralabs_deployment_5.git
WORKDIR /kuralabs_deployment_5 
RUN pip install -r requirements.txt
RUN pip install gunicorn
EXPOSE 8000
ENTRYPOINT python3 -m gunicorn -w 4 application:app -b 0.0.0.0:8000
