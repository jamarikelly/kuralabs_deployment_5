FROM python:latest
RUN apt update && apt install git -y
RUN git clone "https://github.com/kura-labs-org/kuralabs_deployment_4.git"
WORKDIR kuralabs_deployment_4
RUN pip install -U pip
RUN pip install -r "requirements.txt"
EXPOSE 5000
ENTRYPOINT FLASK_APP=application flask run --host=0.0.0.0
