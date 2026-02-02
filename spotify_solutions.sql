--ADVANCED SQL PROJECT - SPOTIFY
--create a table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
select * from spotify

--EDA

select count(*) from spotify

select count(distinct artist) from spotify

select count(distinct track) from spotify

select count(distinct album) from spotify

select count(distinct channel) from spotify

select count(distinct album_type) from spotify
select distinct(album_type) from spotify

select count(distinct most_played_on) from spotify
select distinct(most_played_on) from spotify

select duration_min from spotify
select max(duration_min) from spotify
select min(duration_min) from spotify

select * from spotify 
where duration_min=0

delete  from spotify 
where duration_min=0

select * from spotify
where title is null

--Business questions

--1.Retrieve the names of all tracks that have more than 1 billion streams.
select track,stream from spotify
where stream>1000000000
order by 2 desc


--2.List all albums along with their respective artists.
select distinct album,artist
from spotify
order by 1


--3.Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as Total_number_of_comments from spotify
where licensed='true'


--4.Find all tracks that belong to the album type single.
select track from spotify
where album_type='single'


--5.Count the total number of tracks by each artist
select artist,count(track) as Total_tracks
from spotify
group by 1
order by 2 desc

--6.Calculate the average danceability of tracks in each album.
select avg(danceability) as avg_danceability,album
from spotify
group by 2


--7.Find the top 5 tracks with the highest energy values.
select track,max(energy)
from spotify
group by 1
order by 2 desc
limit 5


--8.List all tracks along with their views and likes where official_video = TRUE.
select distinct track,sum(views) as total_views,sum(likes) as total_likes
from spotify
where
  official_video='true'
 group by 1
order by 2 desc


--9.For each album, calculate the total views of all associated tracks.
select album,track,
   sum(views) as total_views
from spotify
group by 1,2
order by 3 desc


--10.Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from
(select 
track,
 coalesce(sum(case when most_played_on='Youtube'then stream end),0) as streamed_on_youtube,
 coalesce(sum(case when most_played_on='Spotify'then stream end),0) as streamed_on_spotify
from spotify
group by 1) as t1
where 
   streamed_on_spotify> streamed_on_youtube
   and
   streamed_on_youtube<>0


--11.Find the top 3 most-viewed tracks for each artist using window functions.
with new_table
as
(select artist,
track,sum(views) as total_views,
dense_rank() over(partition by artist order by sum(views)desc ) as rank
from spotify
group by 1,2
order by 1,3 desc)
select * from new_table
where rank<=3


--12.Write a query to find tracks where the liveness score is above the average.
select track,
artist,
liveness
from spotify
where 
liveness>0.19367208624708637

--select avg(liveness) as avg_liveness_score from spotify


--13.Use a WITH clause to calculate the difference between the highest and lowest energy values for
--tracks in each album.
with energy_table
as(
select album,
max(energy) as highest_energy,
min(energy) as lowest_energy
from spotify
group by 1
)
select album,
highest_energy-lowest_energy as energy_diff
from energy_table
order by 2 desc

--14.Find tracks where the energy-to-liveness ratio is greater than 1.2.
select track,(energy/liveness) as ratio
from spotify
where 
(energy/liveness)> 1.2


--15.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window function
with cte
as
(
SELECT 
    track,
    views,
    SUM(likes) OVER ( ORDER BY views DESC ) AS cumulative_likes
FROM spotify
 )      
select distinct * from cte


