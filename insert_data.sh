#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do 
if [[ $YEAR != year ]]
  then
  
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      #if not found
      if [[  -z $WINNER_ID ]]
         then
            #insert team
             INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
             if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
                  then
                    echo "inserted into teams, $WINNER"
               
             fi
           WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        
       fi


      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #if not found
      if [[ -z $OPPONENT_ID ]]
      then
          #insert team
                INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
             if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
                  then
                    echo "inserted into teams, $OPPONENT"
               
             fi
           OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      fi
  

    #insert games row
    INSERT_GAMES_RESULT=$($PSQL"INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
        then
            echo "inserted into games"
    fi






  fi
done
