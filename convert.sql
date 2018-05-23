.headers on
.mode csv
.output series.csv
select episodes.*, basics.primaryTitle as seriesTitle, cc.primaryTitle as episodeTitle, ratings.averageRating as rating, ratings.numVotes as votes from [title.episode] episodes INNER JOIN [title.basics] basics ON basics.tconst=episodes.parentTconst INNER JOIN [title.basics] cc ON cc.tconst=episodes.Tconst INNER JOIN [title.ratings] ratings ON ratings.tconst=episodes.tconst order by votes DESC
