#!/bin/bash

#yad

dialog=$(yad --center --title "Login Details" --form --field="Coursera Login" --field="password":H)

login=$(echo $dialog | awk 'BEGIN {FS="|" } { print $1 }')
password=$(echo $dialog | awk 'BEGIN {FS="|" } { print $2 }')

choice=$(yad --center --title "Courserian" --list --column="Menu" "Yo this is a first entry" "yo this is a second one")
