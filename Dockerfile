FROM archlinux:base

RUN                                            \
    pacman -Sy --noconfirm                  && \
    pacman -S --noconfirm archlinux-keyring && \
    pacman -Su --noconfirm                  && \
    pacman-db-upgrade                       && \
    trust extract-compat                    && \
    pacman -S --noconfirm                      \
    python                                     \
    python-pip                                 \
    wget                                       \
    nodejs                                     \
    gcc                                     && \
    pip3 install                               \
    csvs-to-sqlite                             \
    setuptools                                 \
    datasette                               && \
    mkdir /download

WORKDIR /download
COPY download.sh /download
RUN bash download.sh
COPY convert.sql /download
RUN export LC_ALL=en_US.utf8              && \
    export LANG=en_US.utf8                && \
    ls -la                                && \
    csvs-to-sqlite *.tsv imdb.db -s $'\t' && \
    sqlite3 imdb.db < convert.sql         && \
    csvs-to-sqlite series.csv series.db   && \
    rm *.tsv                              && \
    rm imdb.db

EXPOSE 8001

CMD export LC_ALL=en_US.utf8      && \
    export LANG=en_US.utf8        && \
    datasette serve                  \
    -h 0.0.0.0                       \
    --cors                           \
    --config sql_time_limit_ms:30000 \
    series.db
