FROM python:latest
RUN apt-get update 
RUN git clone https://github.com/jamarikelly/kuralabs_deployment_3.git
WORKDIR /kuralabs_deployment_3 
RUN pip install -r requirements.txt
EXPOSE 5000
ENTRYPOINT python3 -m gunicorn -w 4 application:app -b 0.0.0.0:5000
