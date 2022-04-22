FROM python:alpine
COPY . /bookstore-api
WORKDIR /bookstore-api
RUN pip install -r requirements.txt
EXPOSE 80
CMD python ./bookstore-api.py