drop table if exists spotify ;
create table spotify (
	artist	varchar(255),
	track	varchar(255),
	album	varchar(255),
	album_type	varchar(50),
	dance_ability	float,
	energy	float,
	loudness	float,
	speechiness	float,
	acousticness	float,
	instrumentalness	float,
	liveness	float,
	valence	float,
	tempo	float,
	duration_min float,	
	title	varchar(255),
	channel	varchar(255),
	track_Views	float,
	track_Likes	float,
	track_Comments	float,
	licensed	boolean,
	official_video	boolean,
	stream	float,
	energy_liveness float,	
	most_played_on varchar(50)

)


select * from spotify

-- Retrieve the names of all tracks that have more than 1 billion streams.

select track,
	stream 
	from spotify
where stream > 1000000000

-- List all albums along with their respective artists.

	select  distinct(album),
	artist
	from spotify

-- Get the total number of comments for tracks where licensed = TRUE.

select licensed,
	sum(track_comments) as "total_comments"
	from spotify
	where licensed = 'true'
	group by 1


-- Find all tracks that belong to the album type single.

select track,
	album_type
	from spotify where album_type = 'single'

-- Count the total number of tracks by each artist.

	select artist,
	count(track) as "total_tracks"
	from spotify
	group by 1
	order by 2 desc

-- Calculate the average danceability of tracks in each album.

select album,
	round(avg(dance_ability::numeric),1) as "avg_dance_ability"
	from spotify
	group by 1

-- Find the top 5 tracks with the highest energy values.

select track,
	max(energy)
	from spotify
	group by 1
	order by 2 desc
	limit 5

-- List all tracks along with their views and likes where official_video = TRUE	

select track,
	sum(track_views) as "total_views",
	sum(track_likes) as "total_likes",
	official_video
	from spotify
	where official_video = 'true'
	group by 1,4
	order by 2 desc
	limit 5
	
-- For each album, calculate the total views of all associated tracks.

select album,
	track,
	sum(track_views) as "total_views"
	from spotify
	group by 1,2
	order by 3 desc

-- Retrieve the track names that have been streamed on Spotify more than YouTube.

	select * from
	(select track,
	coalesce(sum(case when most_played_on = 'Youtube' then stream end),0)
	as "streamed_on_youtube",
	coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) 
	as "streamed_on_spotify"
	from spotify
	group by 1) as t1
	where streamed_on_spotify > streamed_on_youtube
	and 
	streamed_on_youtube <> 0
	

-- Find the top 3 most-viewed tracks for each artist using window functions.

select * from
	(select artist,
	track, 
	sum(track_views),
	rank() over(partition by artist order by sum(track_views) desc) as "ranking"
	from spotify
	group by 1,2) as t1
where ranking < 4


-- Write a query to find tracks where the liveness score is above the average.


select track,
	liveness
	from spotify
	where liveness > (select avg(liveness) from spotify )

-- Use a WITH clause to calculate the difference between the highest and 
-- lowest energy values for tracks in each album.


select album,
	max(energy) as "max_energy",
	min(energy) as "min_energy",
	max(energy) - min(energy) as "difference"
	from spotify
	group by 1
	order by 1 



	
select * from spotify




