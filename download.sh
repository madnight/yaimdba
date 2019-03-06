titles=("ratings" "episode" "basics")

for i in "${titles[@]}"
do
  wget -q https://datasets.imdbws.com/title."$i".tsv.gz && \
  gunzip title."$i".tsv.gz
done
