#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES=$($PSQL "SELECT * FROM services;")

LIST_SERVICES() {
    echo "$SERVICES" | while read SERVICE_ID BAR NAME
    do
        echo "$SERVICE_ID) $NAME"
    done
}

SERVICE_MENU() {
    LIST_SERVICES

    read SERVICE_ID_SELECTED

    CONTINUE="What's your phone number?"
    
    case $SERVICE_ID_SELECTED in 
        1) echo $CONTINUE ;;
        2) echo $CONTINUE ;;
        3) echo $CONTINUE ;;
        *) LIST_SERVICES "No such service, try again!" ;;
    esac

    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
    if [[ -z $CUSTOMER_NAME ]]
    then
        echo "Looks like your phone is not registered..."
        echo "Enter your name:"
        read CUSTOMER_NAME
        INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE');")
    fi
    echo 'Enter the time for appointment:'
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

SERVICE_MENU
