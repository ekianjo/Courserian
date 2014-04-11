#!/bin/bash

#TODO: add icon to window - DONE
#get ret on all buttons 

#do credits - DONE
#rename some buttons DONE
#create conditions to get login and password info at beginning DONR
#update all option to make DONE
#finish delete function DONE
#make courerian logo DONE
#make condition for coursenb at the beginning DONE
#make interface a bit prettier DONE
#do real test with full course download one evening DONE
#add top picture on all screens DONE
#make zenity download box a bit smaller DONE
 
 
#for version 0.2
#save position in mplayer playback if possible
#try to optimize playback for mplayer
#add launcher for libreoffice if available
#create log
#add auto updater for coursera-dl - need git??
#put checkboxes to clarify what is opened or not
#capture logged in info from coursera-dl and pipe it
#display megabytes in zenity download bar if possible
#add jumanji and let user oepn course in browser
#check online connectivity


showvideoonly="no"
icon="--window-icon=icon.png"

quitprocedure()
{
if [ "$smplayerison" == "yes" ] ; then
  #unmount the SMPlayer PND if used
  /usr/pandora/scripts/pnd_run.sh -p "$smplayerlocation" -b "smplayer" -u &
  smplayerison="no"
fi
exit 0
}

updatecourselist() #updates the course list visible to the user
{
listofcourses=""
totalcourses=0
sizeoffolder=0
cd COURSES #goes in the COURSES folder where courses are stored

for i in $(ls -d */) #for each directory i found in that folder...
do
  totalcourses=$(( $totalcourses + 1 ))
  i=$(echo $i | awk 'BEGIN {FS="/" } { print $1 }') #reduces the path to the folder name
  #listofcourses+="$i"
  #listofcourses+=" "
  #echo "$i"
  sizeoffolder=$(du -sh "$i" | cut -f 1)
  #echo "$sizeoffolder"
  #sizeoffolder=$((sizeoffolder / 2**20))
  #echo "$sizeoffolder"
  listofcourses+="$i $sizeoffolder " #prepared for display in yad as list with 2 columns
  echo "$listofcourses"
done

cd ..
echo $listofcourses
if [ -f "lastfolder.txt" ]; then
  lastfolder=$(head -n 1 lastfolder.txt)
else
  lastfolder=""
fi
}

#pandora specific
export SDL_VIDEODRIVER="omapdss"
export SDL_OMAP_LAYER_SIZE="fullscreen"

#splash screen
./yad --width=380 --height=140 --image="coursera-large.png" --undecorated --no-buttons --borders=5 --timeout=3 --timeout-indicator=bottom --image-on-top "$icon" --on-top

if [ -f "smplayerlocation.txt" ] ; then
  smplayerlocation=$(head -n 1 smplayerlocation.txt)
  /usr/pandora/scripts/pnd_run.sh -p "$smplayerlocation" -b "smplayer" -m
  smplayerison="yes"
  echo "$smplayerlocation"
else
  "" > smplayerlocation.txt
fi

#browserlocation="/media/nite_ordina/pandora/menu/qupzilla.pnd"
#/usr/pandora/scripts/pnd_run.sh -p "$browserlocation" -b "qupbrowser" -m



#/usr/pandora/scripts/pnd_run.sh -p "$smplayerlocation" -m
#Startup script create courses folder
if [ ! -d "COURSES" ]; then
  mkdir "COURSES"
fi

./yad --title="Courserian" --borders=10 --width=500  --button="gtk-ok:0"  --text="Welcome to Courserian. Courserian is a tool to make it easy for you to download, browse and manage your Coursera lessons." "$icon" --on-top

updatecourselist
courseentry="Remove/delete a course"
browsecourse="Browse your courses"
updatecourse="Download/update your courses"


#echo "$totalcourses"
#if [ $totalcourses -eq 0 ]; then
#courseentry=""
#browsecourse=""
#updatecourse=""
#else
#fi
if [ -f "lastfolder.txt" ]; then
  lastfolder=$(head -n 1 lastfolder.txt)
else
  lastfolder=""
fi
echo "$lastfolder"

if [ -f "login.txt" ] && [ -f "password.txt" ]; then
  login=$(head -n 1 login.txt)
  password=$(head -n 1 password.txt)
  loginentry="Modify your Login details"
else
  login=""
  password=""
  loginentry="Enter your Login details"
fi

menu()
{
if [ "$login" != "" ]; then
  menutitle="Menu [ $login ]"
else
  menutitle="Menu"
fi
echo "$menutitle"

if [ $totalcourses -eq 0 ] ; then
  choice=$(./yad --center --width=300 --borders=5 --height=330 --title="Courserian" --list --column="$menutitle" "$loginentry" "Add a course to follow" "Credits" --image="coursera-small.png" --image-on-top "$icon" --button="gtk-quit:1" --on-top)
else
  #if [ "$lastfolder" != "" ]; then
  #choice=$(./yad --center --width=300 --borders=5 --height=330 --title="Courserian" --list --column="$menutitle" "$loginentry" "Add a course to follow" "$courseentry" "Last working folder" "$browsecourse" "$updatecourse" "Extras" "Credits" --image="coursera-small.png" --image-on-top --button="gtk-quit:1" "$icon" --on-top)
  #else
  choice=$(./yad --center --width=300 --borders=5 --height=330 --title="Courserian" --list --column="$menutitle" "$loginentry" "Add a course to follow" "$courseentry" "$browsecourse" "$updatecourse" "Extras" "Credits" --image="coursera-small.png" --image-on-top --button="gtk-quit:1" "$icon" --on-top)
  #fi
fi
ret=$?
if [ $ret -eq 1 ] ; then
  quitprocedure
fi
  choice=$(echo $choice | awk 'BEGIN {FS="|" } { print $1 }')
if [ "$choice" == "Add a course to follow" ]; then
  addingcourse
fi
echo $choice
if [ "$choice" == "Last working folder" ]; then
  set -- "$lastfolder" 
  IFS="/"; declare -a Array=($*) 
  #echo "${Array[@]}" 
  #echo "${Array[0]}" 
  currentfolder="${Array[1]}"
  currentfolder=${currentfolder/$'\n'/}
  materialfolder="${Array[2]}" 
  echo "$currentfolder"
  currentfolder="romanarchitecture-001"
  #echo "$materialfolder"
  #explorematerials
  explorefolder
fi

if [ "$choice" == "Enter your Login details" ] || [ "$choice" == "Modify your Login details" ]; then
  login
fi
if [ "$choice" == "Extras" ]; then
  extrasmenu
fi
if [ "$choice" == "Remove/delete a course" ]; then
  mode="delete"
  showcourses
fi
if [ "$choice" == "Browse your courses" ]; then
  showcourses
fi
if [ "$choice" == "Download/update your courses" ]; then
  updatecourselist
  if [ "$login" != "" ] && [ "$password" != "" ]; then 
    downloadcoursemenu
  else
    warnlogindetails
    menu
  fi
fi

if [ "$choice" == "Credits" ]; then
  #./yad --center --width=380 --borders=5 --height=330 --title="Courserian" --image="coursera2.png" --image-on-top --list --column="Credits" "Created by Ekianjo, 2013-2014. GPL v2 License." "Uses Coursera-dl as backend, Yad for GUI." "Released for the Alive and Kicking Coding Competition" "Logo of Courserian made with ImageJ by Ekianjo" "Created on Open Pandora. Version 0.2." --button="gtk-ok" --on-top
  ./yad --center --width=380 --borders=5 --height=330 --title="Courserian" --image="coursera2.png" --image-on-top --text-info --filename=credits.txt --html --button="gtk-ok" --on-top
  menu
fi
}

warnlogindetails()
{
./yad --center --width=200 --borders=5 --height=80 --title="Courserian" --text="You need to first enter your login details in order to download anything." "$icon" --on-top
}

extrasmenu()
{
size=${#smplayerlocation}
if [ "$size" -lt 5 ] ; then
  choice=$(./yad --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Download courses" "[Back to main menu]" "Find SMPlayer" "$icon" --button="gtk-quit:9" --on-top)
  ret=$?
  if [ $ret -eq 9 ] ; then
    quitprocedure
  fi
  choice=$(echo $choice | awk 'BEGIN {FS="|" } { print $1 }')
  if [ "$choice" == "Find SMPlayer" ]; then
    "" > smplayerlocation.txt
    for i in $(ls -d /media/*/)
    do
      echo $i
      smplayerlocation=$(head -n 1 smplayerlocation.txt)
      size=${#smplayerlocation}
      if [ "$size" -lt 5 ] ; then
        find "$i"pandora -name smplayer2_r6.pnd > smplayerlocation.txt
      fi
    done
    extrasmenu
  fi

else
  if [ "$smplayerison" == "yes" ] ; then
    choice=$(./yad --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Download courses" "[Back to main menu]" "Unmount SMPlayer" "$icon" --button="gtk-quit:9" --on-top)
    ret=$?
    if [ $ret -eq 9 ] ; then
      quitprocedure
    fi
    choice=$(echo $choice | awk 'BEGIN {FS="|" } { print $1 }')
    if [ "$choice" == "[Back to main menu]" ] ; then
      menu
    else
      if [ "$choice" == "Unmount SMPlayer" ]; then
        /usr/pandora/scripts/pnd_run.sh -p "$smplayerlocation" -b "smplayer" -u
        smplayerison="no"
        menu
      fi
    fi

  else
    choice=$(./yad --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Download courses" "[Back to main menu]" "Make SMPlayer the default player" "$icon" --button="gtk-quit:9" --on-top)
    ret=$?
    if [ $ret -eq 9 ] ; then
      quitprocedure
    fi
    choice=$(echo $choice | awk 'BEGIN {FS="|" } { print $1 }')
    if [ "$choice" == "[Back to main menu]" ] ; then
      menu
    else
      if [ "$choice" == "Make SMPlayer the default player" ]; then
        echo "$smplayerlocation"
        /usr/pandora/scripts/pnd_run.sh -p "$smplayerlocation" -b "smplayer" -m
        smplayerison="yes"
        menu
      fi
    fi
  fi
fi
#choice=$(./yad --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Download courses" "[Back to main menu]" "Find SMPlayer" "Make SMPlayer the video player" "Unmount SMPlayer" "$icon")
#choice=$(echo $choice | awk 'BEGIN {FS="|" } { print $1 }')
#if [ "$choice" == "Unmount SMPlayer" ]; then
#size=${#smplayerlocation}
#if [ "$size" -lt 5 ] ; then
#fi
#else
#fi
#fi
#fi
#fi
}

downloadcoursemenu()
{
choice=$(./yad --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Download courses" "[Back to main menu]" "Download/Update a single course" "Download/update all" "$icon" --button="gtk-quit:9" --button="Top Menu:5" --on-top)
ret=$?
if [ "$ret" -eq "9" ] ; then
  quitprocedure
fi
if [ "$ret" -eq "5" ] ; then
  menu
fi

choice=$(echo $choice | awk 'BEGIN {FS="|" } { print $1 }')
if [ "$choice" == "[Back to main menu]" ] ; then
  menu
else
if [ "$choice" == "Download/Update a single course" ]; then
  mode="download"
  showcourses
  else
    if [ "$choice" == "Download/update all" ]; then
    downloadallcourses
    fi
  fi
fi
}

downloadallcourses()
{
cd COURSES
for i in $(ls -d */)
  do
    i=$(echo $i | awk 'BEGIN {FS="/" } { print $1 }')
    currentcourse="$i"
    print "$currentcourse"
    cd ..
    downloadsingleone
    cd COURSES
  done
cd ..
menu
}

showcourses()
{
addedtext=""
echo "$mode"
if [ "$mode" == "download" ] ; then addedtext="to download" ; fi
if [ "$mode" == "delete" ] ; then addedtext="to delete" ; fi
choice=$(./yad --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Select a course $addedtext" --column="Folder Size" "[Back to main menu]" " " $listofcourses --button="gtk-quit:9" --button="Top Menu:5" "$icon" --on-top)
ret=$?
if [ "$ret" -eq "9" ] ; then
  quitprocedure
fi
choice=$(echo $choice | awk 'BEGIN {FS="|" } { print $1 }')
if [ "$choice" == "[Back to main menu]" ] || [ "$ret" -eq "5" ] ; then
  mode=""
  menu
else
  if [ "$mode" == "download" ]; then
    currentcourse="$choice"
    downloadsingleone
    mode=""
    menu
  else
    if [ "$mode" == "delete" ]; then
      currentcourse="$choice"
      deletecourseconfirm
      mode=""
      menu
    else
      currentfolder="$choice"
      explorefolder
    fi
  fi
fi
}

deletecourseconfirm()
{
echo "delete course confirm"
confirm=$(./yad --center --width=200 --borders=5  --title="Courserian" --text="Are you sure you want to delete\n the course $currentcourse ?" --button="gtk-yes:0" --button="gtk-no:1" "$icon" --on-top)
ret=$?
if [[ $ret -eq 0 ]]; then
  cd COURSES
  rm -r "$currentcourse" 
  cd ..
  updatecourselist
  mode=""
  menu
else
  mode=""
  menu
fi
}

explorefolder()
{
listoffolders=""
cd COURSES/"$currentfolder"
for i in $(ls -d */)
  do
    #echo "$i"
    i=$(echo $i | awk 'BEGIN {FS="/" } { print $1 }')
    #i=${i/$'\n'/}
    #echo "$i"
    sizeoffolder=$(du -b "$i" | cut -f 1)
    sizeoffolder=$((sizeoffolder / 2**20))
    listoffolders+="$i $sizeoffolder "
    #listoffolders+=" "
  done
cd ..
cd ..
choice=$(./yad --center --image="coursera-long.png" --image-on-top --width=700 --borders=5 --height=350 --title="Courserian" --list --column="$currentfolder > Select a subfolder" --column="Size (Mb)" "[Back to previous menu]" " " $listoffolders --button="gtk-quit:9" --button="Top Menu:5" --button="Go Up:4" "$icon" --on-top)
ret=$?
choice=$(echo $choice | awk 'BEGIN {FS="|" } { print $1 }')
if [ "$ret" -eq "9" ] ; then
  quitprocedure
fi
if [ "$ret" -eq "5" ] ; then 
  menu
fi
if [ "$choice" == "[Back to previous menu]" ] || [ "$ret" -eq "4" ] ; then
  showcourses
else
  materialfolder="$choice"
  explorematerials
fi
}

explorematerials()
{
listofmaterials=""
cd COURSES/"$currentfolder"/"$materialfolder"
for file in ./*
do
    if [[ -f $file ]]; then
      sizeoffile=$(du -b "$file" | cut -f 1)
      sizeoffile=$((sizeoffile / 2**20))
      file=${file:2}
      extension=${file: -3}
      if [[ -f ".""$file"".read" ]]; then
        viewed="Y"
      else
        viewed="_"
      fi
      if [ "$showvideoonly" == "yes" ] && [ "$extension" == "mp4" ] ; then
        listofmaterials+="$file $sizeoffile $viewed "
        #listofmaterials+=" "
      else
        if [ "$showvideoonly" == "no" ] ; then
          listofmaterials+="$file $sizeoffile $viewed "
          #listofmaterials+="$file"
          #listofmaterials+=" "
          #listofmaterials+="$sizeoffile "
        fi
      fi    
    fi
done
cd ../../..
#columntext="$currentfolder""/""$materialfolder"
materialfolderdisplay="${materialfolder//_/ }"
columntext="$currentfolder / "${materialfolderdisplay:0:50}
echo $columntext
if [ "$showvideoonly" == "no" ] ; then
  buttonvideolabel="Show Videos Only"
else
  buttonvideolabel="Show All files"
fi
choice=$(./yad --image="coursera-long.png" --image-on-top --center --width=700 --borders=5 --height=350 --title="Courserian" --list --column="$columntext" --column="Size (Mb)" --column="Viewed" "[Back to previous menu]" " " " " $listofmaterials --button="gtk-quit:9" --button="$buttonvideolabel:6" --button="Top Menu:5" --button="Go Up:4" "$icon" --on-top)
ret=$?
choice=$(echo $choice | awk 'BEGIN {FS="|" } { print $1 }')
echo $choice
if [ "$ret" -eq "9" ] ; then
  quitprocedure
fi
if [ "$ret" -eq "5" ] ; then menu ; fi
if [ "$ret" -eq "6" ] ; then 
  if [ "$showvideoonly" == "yes" ] ; then 
    showvideoonly="no" ; 
    explorematerials
  else
    showvideoonly="yes" ; 
    explorematerials
  fi
fi
if [ "$choice" == "[Back to previous menu]" ] || [ "$ret" -eq "4" ] ; then
  explorefolder
fi
extension=${choice: -3}
if [ "$extension" == "srt" ] || [ "$extension" == "txt" ] ; then
  " " > COURSES/"$currentfolder"/"$materialfolder"/".""$choice"".read"
  mousepad COURSES/"$currentfolder"/"$materialfolder"/"$choice"
  explorematerials
fi
if [ "$extension" == "pdf" ] ; then
  " " > COURSES/"$currentfolder"/"$materialfolder"/".""$choice"".read"
  evince -s COURSES/"$currentfolder"/"$materialfolder"/"$choice"
  explorematerials
fi
if [ "$extension" == "mp4" ] ; then
  if [ "$smplayerison" == "yes" ] ; then	
  " " > COURSES/"$currentfolder"/"$materialfolder"/".""$choice"".read"
  "COURSES/$currentfolder/$materialfolder" > lastfolder.txt
  /mnt/utmp/smplayer/bin/mplayer -ss 14 -framedrop -vo omapfb -autoq 6 -fs -nocache COURSES/"$currentfolder"/"$materialfolder"/"$choice" > out.txt
  #/mnt/utmp/smplayer2_r6/bin/smplayer2 COURSES/"$currentfolder"/"$materialfolder"/"$choice"
  #else
  #mplayer/bin/mplayer -vo sdl -autoq 3 -nocache -fs -framedrop COURSES/"$currentfolder"/"$materialfolder"/"$choice"
  explorematerials
  else
    " " > COURSES/"$currentfolder"/"$materialfolder"/".""$choice"".read"
    echo "COURSES/$currentfolder/$materialfolder" > lastfolder.txt
    mplayer -fs -framedrop -vo sdl COURSES/"$currentfolder"/"$materialfolder"/"$choice"
    explorematerials
  fi
fi
if [ "$extension" == "ptx" ] ; then
  explorematerials
fi
}

#LOGIN / PASSWORD
login()
{
dialog=$(./yad --center --borders=10 --title="Login Details" --form --field="Coursera Login" --text="Login info will be saved locally" --field="password":H "$icon" --on-top)
login=$(echo $dialog | awk 'BEGIN {FS="|" } { print $1 }')
password=$(echo $dialog | awk 'BEGIN {FS="|" } { print $2 }')
#save them to text file
echo $login
echo $password
if [ $login != "" ]; then
  if [ $password != "" ]; then
    loginentry="Modify your Login details"
    echo $login > login.txt
    echo $password > password.txt
  fi
else
  loginentry="Enter your Login details"
fi
menu
}

addingcourse()
{
#ADDING A COURSE
entry=$(./yad --width=400 --center --borders=10 --title="Courserian" --text="Enter the course code you wish to add.\n You can find this code or short name in the URL of your course.\n For example..." --form --field="Course Name" "$icon" --on-top)
entry=$(echo $entry | awk 'BEGIN {FS="|" } { print $1 }')
if [ "$entry" != "" ]; then
  downloadsingle
else
  updatecourselist
  menu
fi
}

#write it in currentcourse
#write it to a text file as well for courses
#make backup of the file

downloadsingle()
{
#-> after adding a course, confirm if user wants to download the associated material
answer=$(./yad --width=350 --center --borders=10 --title="Courserian" --text="You have just added the course $entry in Courserian,\n would you like to download the course contents right now ?\n\n Note that you need to have accepted the code of Honor\n for that particular course on the Coursera website first." --button="gtk-yes:0" --button="gtk-no:1" "$icon" --on-top)
ret=$?
echo "$ret"
if [[ $ret -eq 0 ]]; then
  currentcourse="$entry"
  echo $ret
  downloadsingleone
  updatecourselist
  menu
else
  mkdir COURSES/"$entry"
  updatecourselist
  #need to register somehwere the ones to download later
  menu
fi
}

#DOWNLOAD single coursepython 
downloadsingleone()
{
#./coursera-dl -u $login -p $password powerofmarkets-001 | ./yad	--text="Downloading..." --width=250 --progress --pulsate 
#./coursera-dl --path="COURSES" -u $login -p $password $currentcourse | sed 's/.*[ \t][ \t]*\([0-9][0-9]*\)%.*/\1/' | ./yad --width=500 --text="Downloading..." --progress
echo $currentcourse > currentcourse.txt
python tracker.py &
#./coursera-dl --path="COURSES" -u $login -p $password $currentcourse | sed 's/.*[ \t][ \t]*\([0-9][0-9]*\)%.*/\1/' | zenity --progress
}

#DOWNLOAD/update all courses
#python coursera-dl.py --path=$PATH -u $login -p $password $ALLCOURSES | yad --progress

menu
