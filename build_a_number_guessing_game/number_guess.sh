#! /bin/bash

#Number guessing game

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))

TEST_SECRET_NUMBER=200

echo Enter your username:
read USERNAME

USER=$($PSQL "SELECT name FROM users WHERE name = '$USERNAME'")

RNG_GAME(){
  echo Guess the secret number between 1 and 1000:
  read GUESS
  TRYS=1

  while [[ $SECRET_NUMBER != $GUESS ]]
  do
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo That is not an integer, guess again:
    else
      if [ $GUESS -gt  $SECRET_NUMBER ]
      then
        echo "It's lower than that, guess again:"
      else
        echo "It's higher than that, guess again:"
      fi
    fi
    read GUESS
    ((TRYS++))
  done

  echo You guessed it in $TRYS tries. The secret number was $SECRET_NUMBER. Nice job!

  INCREASE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = $2 + 1 WHERE name = '$1' ")
  if [ $TRYS -lt $3 ]
  then
    LOWER_BEST_GAME=$($PSQL "UPDATE users SET best_game = $TRYS WHERE name = '$1' ")
  fi

}


if [[ -z $USER ]]
then
  #promt and add user not found
  echo Welcome, $USERNAME! It looks like this is your first time here.
  USER=$USERNAME
  USER_INSERT=$($PSQL "INSERT INTO users(name,games_played,best_game) VALUES('$USERNAME',0,1000)")

  RNG_GAME $USER 0 1000
else
  #gather user stats and prompt
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE name = '$USER'")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE name = '$USER'")
  echo Welcome back, $USER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.

  RNG_GAME $USER $GAMES_PLAYED $BEST_GAME
fi
