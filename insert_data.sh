#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get teams
    TEAM_1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    TEAM_2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

    # if winning team name not found
    if [[ -z $TEAM_1 ]]
    then
      # insert winning team name
      INSERT_T1_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_T1_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi

    # if opposing team name not found
    if [[ -z $TEAM_2 ]]
    then
      # insert opposing team name
      INSERT_T2_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_T2_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  # Get the team_id's of the 2 teams in the game
  WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # echo WIN $WINNER $WIN_ID; echo LOSE $OPPONENT $OPP_ID

  # Insert a row for each game
      INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WINNERGOALS, $OPPONENTGOALS)")
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo Inserted into games, $WINNER $WINNERGOALS vs $OPPONENTGOALS $OPPONENT
      fi
  fi

   # ✅Passing all tests
done
