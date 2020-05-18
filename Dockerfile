FROM mariadb:latest

VOLUME /home/robert/projects/mount/mariadb/

RUN apt-get update 

ENV MYSQL_USER=user1 \
    MYSQL_PASSWORD=pass5 \
    MYSQL_DATABASE=db \
    MYSQL_ROOT_PASSWORD=XXX

RUN apt-get install -y vim

RUN mkdir /originaldata/ /scripts/

COPY ./kagglefiles/* /originaldata/

COPY ./initiate_db.sh /scripts/

RUN chmod 770 /scripts/initiate_db.sh

WORKDIR /

CMD /scripts/initiate_db.sh