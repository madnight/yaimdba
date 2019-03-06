FROM ubuntu:18.04

RUN apt-get update  && \
    apt-get install -y \
    gcc                \
    nodejs             \
    python3            \
    python3-pip        \
    wget

RUN pip3 install csvs-to-sqlite datasette

RUN mkdir /download
WORKDIR /download
COPY download.sh /download

RUN bash download.sh

COPY convert.sql /download

RUN apt-get install sqlite3

RUN ls

RUN export LC_ALL=C.UTF-8                 && \
    export LANG=C.UTF-8                   && \
    ls -la                                && \
    csvs-to-sqlite *.tsv imdb.db -s $'\t' && \
    sqlite3 imdb.db < convert.sql
    csvs-to-sqlite series.csv series.db   && \
    rm *.tsv && rm imdb.db

EXPOSE 8001

CMD export LC_ALL=C.UTF-8    && \
    export LANG=C.UTF-8      && \
    datasette serve -h 0.0.0.0 --cors --config sql_time_limit_ms:30000 series.db
