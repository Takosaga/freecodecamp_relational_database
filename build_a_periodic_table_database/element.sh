#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  #if argument is an atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
    STR_LEN=${#1}
    #if argument is a symbol
    if [[ 3 > $STR_LEN ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    else
      #if argument is a name
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    fi
  fi

  #element is not in db
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    NAME=$($PSQL "Select name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")

    SYMBOL=$($PSQL "Select symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")

    TYPE=$($PSQL "SELECT type FROM properties LEFT JOIN types ON properties.type_id = types.type_id WHERE atomic_number=$ATOMIC_NUMBER")

    MASS=$($PSQL "Select atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

    MELTING=$($PSQL "Select melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

    BOILING=$($PSQL "Select boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi

else
  echo Please provide an element as an argument.
fi


