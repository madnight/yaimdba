titles=("ratings" "episode" "basics")
# titles=("ratings" "principals" "episode" "crew" "basics" "akas")

for i in "${titles[@]}"
do
  wget -q https://datasets.imdbws.com/title."$i".tsv.gz && \
  gunzip title."$i".tsv.gz
done
