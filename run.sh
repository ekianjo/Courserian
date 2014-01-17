#!/bin/bash

#yad

yad --title="Courserian" --width=500  --button="gtk-ok:0"  --text="Welcome to Courserian. Courserian is a tool to make it easy for you to download, browse and manage your Coursera lessons."

#make condition that if no login is registered, first menu text is "enter" if not "modify"
#make condition that if no course registered, "remove delete course is not displayed"
choice=$(yad --center --title="Courserian" --list --column="Menu" "Enter your Login details" "Add a course" "Remove/delete a course" "Browse your courses" "Download/update your courses")

#LOGIN / PASSWORD
dialog=$(yad --center --title="Login Details" --form --field="Coursera Login" --field="password":H)
login=$(echo $dialog | awk 'BEGIN {FS="|" } { print $1 }')
password=$(echo $dialog | awk 'BEGIN {FS="|" } { print $2 }')
#save them to text file

#ADDING A COURSE
entry=$(yad --center --title="Courserian" --text="Enter the course code you wish to add. You can find this code or short name in the URL of your course. For example..." --form --field="Course Name")

#write it in currentcourse
#write it to a text file as well for courses
#make backup of the file


#-> after adding a course, confirm if user wants to download the associated material
answer=$(yad --center --title="Courserian" --text="You have just added $entry in Courserian, would you like to download the course contents right now ? Note that you need to have accepted the code of Honor for that particular course on the Coursera website first." --button=gtk-yes:0 --button=gtk-no:1)
if [ $answer=0 ]; then
  #download now ->
fi

#DOWNLOAD single course
python coursera-dl.py --path=$PATH -u $login -p $password $SINGLECOURSE | yad --progress

#DOWNLOAD/update all courses
python coursera-dl.py --path=$PATH -u $login -p $password $ALLCOURSES | yad --progress

#REMOVING a COURSE
#list courses added from text file
#yad select course to remove
#remove it from the text file
#remove it from backup

#BROWSE YOUR COURSES
#Add bouton "Back to Menu" "arrow up" 
#display a list of courses -> clicking on it goes in directory mode
#when reach file with video extension, open with mplayer
#file with .srt -> open with mousepad
#pdf -> open with evince
ext=$("$name" | awk -F'.' '{print $1}')
if [ "$ext"=".mp4" ]; then
    mplayer FILE
fi


