FROM python:latest
RUN apt update && apt install git -y
RUN git clone "https://github.com/kura-labs-org/kuralabs_deployment_4.git"
WORKDIR /app
COPY . /app
RUN pip install -r "requirements.txt"
EXPOSE 5000
CMD ["python3", "application.py"]
