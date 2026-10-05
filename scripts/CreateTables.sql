create table Stadiums (
	stadium_id serial primary key,
	name text not NULL, 
	city text not NULL,
	capacity int not NULL,
	opened_year int
);
create table Football_clubs (
	club_id serial primary key,
	name text not NULL,
	country text not NULL, 
	city text not NULL,
	creation_year int,
	stadium_id int references Stadiums(stadium_id)
);
create table Players (
	player_id serial primary key,
	first_name text not null,
	last_name text not null,
	birth_date date not null,
	nationality text not null,
	position text not null,
	market_value bigint
);
create table Contracts (
	contract_id serial primary key,
	player_id int references Players(player_id),
	club_id int references Football_clubs(club_id),
	start_date date not null,
	end_date date,
	salary int not null,
	status text
);
create table Competitions (
	competition_id serial primary key,
	name text not null,
	country text,
	level text,
	season text
);
create table Matches (
	match_id serial primary key,
	competition_id int references Competitions(competition_id),
	home_club_id int references Football_clubs(club_id),
	away_club_id int references Football_clubs(club_id),
	stadium_id int references Stadiums(stadium_id),
	match_date date,
	home_club_score int not null,
	away_club_score int not null,
	attendance int
);
create table Match_players (
	player_id int references Players(player_id),
	match_id int references Matches(match_id),
	minutes_played int,
	goals int default 0,
	assists int default 0,
	shots int default 0,
	yellow_cards int default 0,
	red_cards int default 0,
	primary key (player_id, match_id)
);
create table Player_cost_history (
	history_id serial primary key,
	player_id int references Players(player_id),
	market_value bigint,
	valid_from date,
	valid_to date,
	is_current bool
);

alter table Matches
alter column home_club_score drop not null;

alter table Matches
alter column away_club_score drop not null;

update stadiums 
set name = 'Estadio La Cartuja'
where stadium_id = 19;

update match_players 
set match_id = 22
where match_id = 6 and player_id in (7, 8, 9, 29, 30);

update match_players 
set match_id = 23
where match_id = 7 and player_id in (7, 8, 9, 50, 51);