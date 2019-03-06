.headers on
.mode csv
.output series.csv
SELECT episodes.*,
       basics.primarytitle   AS seriesTitle,
       cc.primarytitle       AS episodeTitle,
       ratings.averagerating AS rating,
       ratings.numvotes      AS votes
FROM   [title.episode] episodes
       INNER JOIN [title.basics] basics
               ON basics.tconst = episodes.parenttconst
       INNER JOIN [title.basics] cc
               ON cc.tconst = episodes.tconst
       INNER JOIN [title.ratings] ratings
               ON ratings.tconst = episodes.tconst
ORDER  BY votes DESC
