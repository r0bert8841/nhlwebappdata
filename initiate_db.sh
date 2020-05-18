#!/usr/bin/env bash

# You want the first argument to be the directory of the extracted database
loc=/originaldata/

# Log into mariaDB as root user ( or any user of your choosing)
mysql -u root -pXXX <<EOF

#Once in mariaDB, create the database 
Create database if not exists nhl_kaggle;


use nhl_kaggle;

CREATE TABLE game_shifts (game_id varchar(12), player_id varchar(10), period tinyint, shift_start smallint, shift_end smallint);
load data local infile '/originaldata/game_shifts.csv' into table game_shifts
fields terminated BY ','
optionally enclosed by '\"'
lines terminated BY '\r\n'
ignore 1 lines
;
# select * from game_shifts limit 10;

CREATE TABLE game (game_id varchar(12) ,season varchar(12),type varchar(6),date_time date,date_time_GMT varchar(24),away_team_id varchar(2),home_team_id varchar(2),away_goals tinyint,home_goals tinyint,outcome varchar(24),home_rink_side_start varchar(10),venue varchar(36),venue_link varchar(50),venue_time_zone_id varchar(24),venue_time_zone_offset varchar(4),venue_time_zone_tz varchar(3));
load data local infile '/originaldata/game.csv' into table game
fields terminated BY ','
optionally enclosed by '\"'
lines terminated BY '\r\n'
ignore 1 lines
; 


CREATE TABLE game_goalie_stats(game_id varchar(12) ,player_id varchar(10),team_id varchar(2),timeOnIce smallint,assists tinyint,goals tinyint,pim tinyint,shots smallint,saves smallint,powerPlaySaves tinyint,shortHandedSaves tinyint,evenSaves tinyint,shortHandedShotsAgainst tinyint,evenShotsAgainst tinyint,powerPlayShotsAgainst tinyint,decision varchar(2),savePercentage decimal,powerPlaySavePercentage decimal,evenStrengthSavePercentage decimal);
load data local infile '/originaldata/game_goalie_stats.csv' into table game_goalie_stats
fields terminated BY ','
optionally enclosed by '\"'
lines terminated BY '\r\n'
ignore 1 lines
; 

# Have to do a find replace, for  (', assists' to be replaced by  ' assists'')
CREATE TABLE game_plays(play_id varchar(24),game_id varchar(12),play_num smallint,team_id_for varchar(2),team_id_against varchar(2),event varchar(50),secondaryType varchar(50),x smallint,y smallint,period varchar(2),periodType varchar(24),periodTime smallint,periodTimeRemaining smallint,dateTime varchar(24),goals_away tinyint,goals_home tinyint,description varchar(200),st_x smallint,st_y smallint,rink_side varchar(5));
load data local infile '/originaldata/game_plays.csv' into table game_plays
fields terminated BY ','
optionally enclosed by '\"'
lines terminated BY '\r\n'
ignore 1 lines
; 

CREATE TABLE game_plays_players(play_id varchar(24),game_id varchar(12),play_num smallint,player_id varchar(10),playerType varchar(24));
load data local infile '/originaldata/game_plays_players.csv' into table game_plays_players
fields terminated BY ','
optionally enclosed by '\"'
lines terminated BY '\r\n'
ignore 1 lines
; 


CREATE TABLE game_skater_stats(game_id varchar(12),player_id varchar(10),team_id varchar(2),timeOnIce smallint,assists tinyint,goals tinyint,shots tinyint,hits tinyint,powerPlayGoals tinyint,powerPlayAssists tinyint,penaltyMinutes tinyint,faceOffWins tinyint,faceoffTaken tinyint,takeaways tinyint,giveaways tinyint,shortHandedGoals tinyint,shortHandedAssists tinyint,blocked tinyint,plusMinus tinyint,evenTimeOnIce smallint,shortHandedTimeOnIce smallint,powerPlayTimeOnIce smallint);
load data local infile '/originaldata/game_skater_stats.csv' into table game_skater_stats
fields terminated BY ','
optionally enclosed by '\"'
lines terminated BY '\r\n'
ignore 1 lines
; 



CREATE TABLE game_teams_stats(game_id varchar(12),team_id varchar(2),HoA varchar(4),won boolean,settled_in varchar(3),head_coach varchar(36),goals tinyint,shots smallint,hits smallint,pim smallint,powerPlayOpportunities tinyint,powerPlayGoals tinyint,faceOffWinPercentage decimal,giveaways tinyint,takeaways tinyint);
load data local infile '/originaldata/game_teams_stats.csv' into table game_teams_stats
fields terminated BY ','
optionally enclosed by '\"'
lines terminated BY '\r\n'
ignore 1 lines
; 

CREATE TABLE player_info(player_id varchar(10),firstName varchar(24),lastName varchar(24),nationality varchar(24),birthCity varchar(24),primaryPosition varchar(2),birthDate date,link varchar(36));
load data local infile '/originaldata/player_info.csv' into table player_info
fields terminated BY ','
optionally enclosed by '\"'
lines terminated BY '\r\n'
ignore 1 lines
; 

CREATE TABLE team_info(team_id varchar(2),franchiseId varchar(2),shortName varchar(24),teamName varchar(24),abbreviation varchar(3),link varchar(36));
load data local infile '/originaldata/team_info.csv' into table team_info
fields terminated BY ','
optionally enclosed by '\"'
lines terminated BY '\r\n'
ignore 1 lines
; 

alter TABLE game 
add index game_index(game_id);

alter TABLE game_skater_stats 
add index game_skater_index_1(game_id,team_id,player_id);

alter TABLE player_info 
add index player_info(player_id);


Create database if not exists nhl_analytics;