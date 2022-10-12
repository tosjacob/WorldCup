#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games RESTART IDENTITY")

#read file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# Ignore first line
  if [[ $YEAR != "year" ]]
  then
    # Get team ids

    # Get winner_id:
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    
    # If not found:
    if [[ -z $WINNER_ID ]]
    then
      ADDED_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        
        # Echo to terminal:
        if [[ $ADDED_TEAM = "INSERT 0 1" ]]
        then
          echo Added $WINNER to teams
        fi
      
      # Get inserted WINNER_ID
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # Get opponent_id:
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    # If not found:
    if [[ -z $OPPONENT_ID ]]
    then ADDED=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

     # Get inserted OPPONENT_ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # Insert data into games table
    GAME_ID=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done