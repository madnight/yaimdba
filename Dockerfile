FROM pritunl/archlinux:2018-05-19

RUN pacman -S --noconfirm python python-pip nodejs gcc

RUN pip3 install csvs-to-sqlite datasette

RUN mkdir /download
WORKDIR /download
COPY download.sh /download

RUN pacman -S --noconfirm wget

RUN bash download.sh

COPY convert.sql /download

RUN export LC_ALL=en_US.utf8 && \
    export LANG=en_US.utf8 && \
    ls -la && \
    csvs-to-sqlite *.tsv imdb.db -s $'\t' && \
    sqlite3 imdb.db < convert.sql && \
    csvs-to-sqlite series.csv series.db && \
    rm *.tsv && rm imdb.db

EXPOSE 8001

CMD export LC_ALL=en_US.utf8 && \
    export LANG=en_US.utf8 && \
    datasette serve -h 0.0.0.0 --cors --config sql_time_limit_ms:30000 series.db
