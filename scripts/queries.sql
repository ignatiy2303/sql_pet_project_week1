select 
c.contract_id,
p.first_name,
p.last_name,
fc.name as club,
c.start_date, 
c.end_date,
c.salary,
c.status
from Contracts c 
join Players p on c.player_id = p.player_id 
join Football_clubs fc on c.club_id = fc.club_id
order by salary desc
limit 10;

select 
p.first_name,
p.last_name, 
fc.name 
from PLayers p
join Contracts c on c.player_id = p.player_id 
join Football_clubs fc on fc.club_id = c.club_id 
where fc.name = 'Barcelona'

select 
p.nationality,
round(avg(salary),2) as average_salary
from PLayers p
join Contracts c on c.player_id = p.player_id 
group by p.nationality
order by average_salary desc
limit 3

select 
p.nationality,
count(p.nationality) as count_nationality
from PLayers p
join Contracts c on c.player_id = p.player_id 
group by p.nationality
having count(p.nationality) > 3
order by count_nationality desc

select 
p.first_name,
p.last_name,
fc.name,
c.salary,
c.end_date
from players p
inner join contracts c on c.player_id = p.player_id
inner join football_clubs fc on fc.club_id = c.club_id 
order by salary desc

select 
fc.name,
count(c.player_id) as count_players
from football_clubs fc 
left join contracts c on c.club_id = fc.club_id 
group by fc.name

select * from contracts c
right join players p on p.player_id = c.player_id

select * from players p
full join player_cost_history pch on pch.player_id = p.player_id

select p.first_name, p.last_name, p.market_value from players p
where p.market_value > (
	select avg(p.market_value) from players p
	)

select p.first_name, p.last_name from players p 
join contracts c on c.player_id = p.player_id
where c.club_id in (
	select m.home_club_id from matches m 
	join competitions comp on comp.competition_id = m.competition_id 
	where comp.name = 'UEFA Champions League' and m.attendance is not null
	union 
	select m.away_club_id from matches m 
	join competitions comp on comp.competition_id = m.competition_id 
	where comp.name = 'UEFA Champions League' and m.attendance is not null
)

select p.first_name, p.last_name from players p 
join contracts c on c.player_id = p.player_id 
where c.salary > any (
	select c.salary from contracts c
	join football_clubs fc on fc.club_id = c.club_id 
	where fc.name = 'CSKA'
)

select p.first_name, p.last_name from players p 
join contracts c on c.player_id = p.player_id 
where c.salary > all (
	select c.salary from contracts c
	join football_clubs fc on fc.club_id = c.club_id 
	where fc.name = 'Galatasaray'
)

select fc.name from football_clubs fc 
where exists (
	select 1 from contracts c
	join players p on p.player_id = c.player_id
	where c.club_id = fc.club_id and p.market_value > '50000000'
)

select fc.name from football_clubs fc
join contracts c on fc.club_id = c.club_id 
group by fc.name
having avg(salary) > (
	select avg(c.salary) from contracts c
)

select distinct fc.name, p.first_name, p.last_name, c1.salary from contracts c1
join contracts c2 on c2.club_id = c1.club_id and c1.salary > c2.salary
join players p on p.player_id = c1.player_id 
join football_clubs fc on fc.club_id = c1.club_id 
order by salary desc

select fc.name, p.first_name, p.last_name, c.salary,
row_number() over(partition by fc.name order by c.salary) as rank from players p
join contracts c on c.player_id = p.player_id 
join football_clubs fc on fc.club_id = c.club_id 

select fc.name, p.first_name, p.last_name, c.salary,
round(avg(c.salary) over(partition by fc.name),2) as rank from players p
join contracts c on c.player_id = p.player_id 
join football_clubs fc on fc.club_id = c.club_id 

with club_salary as (
	select fc.name, round(avg(c.salary),2) as avg_salary from football_clubs fc 
	join contracts c on c.club_id = fc.club_id 
	group by fc.name
)
select * from club_salary 
where avg_salary > '10000000'

with recursive match_queue as (
	select match_id, 1 as match_number from matches 
	where match_id = (select min(match_id) from matches)
	union all
	select m.match_id, mq.match_number + 1 from match_queue mq
	join matches m on m.match_id = (
		select min(m.match_id)
		from matches m
		where m.match_id > mq.match_id
	)
)
select mq.match_number, m.match_id, m.match_date, m.home_club_score, m.away_club_score 
from match_queue mq
join matches m on m.match_id = mq.match_id
order by match_number

