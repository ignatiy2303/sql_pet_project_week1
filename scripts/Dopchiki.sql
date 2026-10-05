create index idx_conracts_club_id on Contracts(club_id);
create index idx_matches_match_date on Matches(match_date);
create index idx_history_cost on Player_cost_history(player_id);

begin;
update contracts 
set salary = salary + 1000000
where player_id = 1;
savepoint salary_change;
update contracts 
set salary = salary + 5000000
where player_id = 2;
rollback to savepoint salary_change;
rollback;

create or replace view player_contracts_view as
select p.player_id, p.first_name, p.last_name, fc.name as club_name, c.start_date, c.end_date, 
c.salary, c.status from players p
join contracts c on p.player_id = c.player_id
join football_clubs fc on c.club_id = fc.club_id

select * from player_contracts_view 
where salary > 5000000
order by salary desc