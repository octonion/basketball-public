begin;

drop table if exists eurocup.results;

create table eurocup.results (
	game_id		      integer,
--	game_date	      date,
	year		      integer,
	team_id	      	      text,
	opponent_id	      text,
	location_id	      text,
	field		      text,
	team_score	      integer,
	opponent_score	      integer,
	game_length	      text
);

insert into eurocup.results
(game_id, year,
 team_id, opponent_id,
 location_id, field,
 team_score, opponent_score)
(
select
g.game_id,
--g.game_date,
g.year,
g.team_id as team_id,
t.team_id as opponent_id,
(case when g.field='home' then g.team_id
 else t.team_id end) as location_id,
(case when g.field='home' then 'offense_home'
 else 'defense_home' end) as field,

(case when g.field='home' then g.home_score
      else g.away_score end)
  as team_score,

(case when g.field='home' then g.away_score
      else g.home_score end) as opponent_score

from eurocup.games g
join eurocup.teams t
  on (t.year,t.team_name)=(g.year,g.opponent_name)
where
    TRUE
--and g.score is not null
--and not(g.score='')
and g.year between 2002 and 2015

union

select
g.game_id,
--g.game_date,
g.year,
t.team_id as team_id,
g.team_id as opponent_id,
(case when g.field='home' then g.team_id
 else t.team_id end) as location_id,
(case when g.field='home' then 'defense_home'
 else 'offense_home' end) as field,

(case when g.field='home' then g.away_score
      else g.home_score end) as team_score,

(case when g.field='home' then g.home_score
      else g.away_score end)
  as opponent_score

from eurocup.games g
join eurocup.teams t
  on (t.year,t.team_name)=(g.year,g.opponent_name)
where
    TRUE
--and g.score is not null
--and not(g.score='')
and g.year between 2002 and 2015
);

commit;
