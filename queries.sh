#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql -X --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != "winner" ]]
  then
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
    if [[ -z $winner_id ]]
    then
      result=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
      if [[ $result == "INSERT 0 1" ]]
      then
        echo "Inserted '$winner' into the teams table"
      fi
    fi

    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
    if [[ -z $opponent_id ]]
    then
      result=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      if [[ $result == "INSERT 0 1" ]]
      then
        echo "Inserted '$opponent' into the teams table"
      fi
    fi
  fi
done

cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    result=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)\
            VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")
    if [[ $result = "INSERT 0 1" ]]
    then
      echo "Inserted $winner - $opponent"
    fi
  fi
done
