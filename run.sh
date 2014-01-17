#!/bin/bash

#yad

yad --title="Courserian" --width=500  --button="gtk-ok:0"  --text="Welcome to Courserian. Courserian is a tool to make it easy for you to download, browse and manage your Coursera lessons."

choice=$(yad --center --title="Courserian" --list --column="Menu" "Enter your Login details" "Add a course" "Remove/delete a course" "Browse your courses" "Download/update your courses")

#LOGIN / PASSWORD
dialog=$(yad --center --title="Login Details" --form --field="Coursera Login" --field="password":H)
login=$(echo $dialog | awk 'BEGIN {FS="|" } { print $1 }')
password=$(echo $dialog | awk 'BEGIN {FS="|" } { print $2 }')

#ADDING A COURSE
entry=$(yad --center --title="Courserian" --text="Enter the course code you wish to add. You can find this code or short name in the URL of your course. For example..." --form --field="Course Name")
