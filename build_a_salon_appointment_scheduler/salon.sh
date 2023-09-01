#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c "

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo -e "Welcome to My Salon, how can I help you?\n"
  fi
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SERVICES 1 ;;
    2) SERVICES 2 ;;
    3) SERVICES 3 ;;
    4) SERVICES 4 ;;
    5) SERVICES 5 ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

SERVICES() {
  SERVICE_ID=$1
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$1")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ //')

  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'" )

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # get appointment time
  echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED,$CUSTOMER_NAME?"
  read SERVICE_TIME

  # insert appointment time
  INSERT_APPOINTMENT_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID,$SERVICE_ID,'$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU