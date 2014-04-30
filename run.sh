#!/bin/bash

#license info to add

#TODO: 
#get ret on all buttons 

#for version 0.2
#try to optimize playback for mplayer
#create log -> NEED TO DEFINE SCOPE OF THE LOG
#put checkboxes to clarify what is opened or not > DONE
#capture logged in info from coursera-dl and pipe it > HALF DONE
#display megabytes in zenity download bar if possible > DONE
#check online connectivity > DRAFTED, SEE IF IT WORKS
#add jumanji and let user open course in browser 
#add launcher for libreoffice if available
#add version number variable # DRAFTED, need to be checked again

#EN PLUS...
#add duration of each video and create a file with the video name that has the time value
#save position in mplayer playback if possible
#add auto updater for coursera-dl - need git??
#automatically check if updated videos are available?
#add what is coursera entry in the menu
#add option to open excel files and word and ppt files in libreoffice
#try to add preview function
#add PC mode, not just Pandora, as well as system detection - see if $yad="./yad" or yad works -STARTED

#Initial parameters
showvideoonly="no" #confirms if only the videos are displayed in the list of content
icon="--window-icon=icon.png" #icon used for yad windozs
version=0.2 #version number
globalcoursesfolder="COURSES"

loadglobalcoursesfoldervariable()
{
  #load the text file it it exists and default to COURSES otherwise
  echo "yo man"
}

changefolder()
{
$globalcoursesfolder=$yadcall --file --directory
 #put stuff here to change folder 
 #save folder in text file
}

creditsfile()
{
#to create a new credits text file to be used by credits function - TO TEST
if [ ! -f "creditsnew.txt" ]; then
  credits="Courserian by Ekianjo \n Version "$version""
  printf "$credits" > creditsnew.txt 
else
  credits=$(cat creditsnew.txt)
  if [[ "$credits" == *$version* ]]; then
    echo "the file is cool, contains the right credits info"
  else
    credits="Courserian by Ekianjo \n Version \n "$version""
    printf "$credits" > creditsnew.txt 
  fi
fi
}

#to be used for logging activity within courserian
timerstart()
{
START=$(date +%s.%N)
}

timerstop()
{
END=$(date +%s.%N)
#DIFF=$(echo "$END - $START" | bc) 
}

#need to test if this works
checkonline()
{
  #found on https://stackoverflow.com/questions/17291233/how-to-check-internet-access-using-bash-script-in-linux
wget -q --tries=10 --timeout=20 -O - http://google.com > /dev/null
if [[ $? -eq 0 ]]; then
        online="on"
        echo "online status is $online"
else
        online="off"
        echo "online status is $online"
fi
}

#need to test if this works
desktoporpandora()
{
if [ ! -d "/usr/pandora/" ]; then
  runningmachine="desktop"
  yadcall="yad"
  echo "you are running Courserian on desktop"
else
  runningmachine="pandora"
  yadcall="./yad"
  echo "you are running Courserian on Pandora"
  locatesmplayer
fi
}

#not sure if it works, to try
previewvideo()
{
mplayer -ontop -zoom -x 500 -y 300 -geometry 30%:30% video_file &
}

quitprocedure()
{
if [ "$runningmachine" == "pandora" ] ; then
  if [ "$smplayerison" == "yes" ] ; then
    #unmount the SMPlayer PND if used
    /usr/pandora/scripts/pnd_run.sh -p "$smplayerlocation" -b "smplayer" -u &
    smplayerison="no"
  fi
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
  sizeoffolder=$(du -sh "$i" | cut -f 1)
  #sizeoffolder=$((sizeoffolder / 2**20))
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



locatesmplayer()
{
if [ -f "smplayerlocation.txt" ] ; then
  smplayerlocation=$(head -n 1 smplayerlocation.txt)
  /usr/pandora/scripts/pnd_run.sh -p "$smplayerlocation" -b "smplayer" -m
  smplayerison="yes"
  echo "$smplayerlocation"
else
  "" > smplayerlocation.txt ##probably should not actually create the file!!!
fi
}

#browserlocation="/media/nite_ordina/pandora/menu/qupzilla.pnd"
#/usr/pandora/scripts/pnd_run.sh -p "$browserlocation" -b "qupbrowser" -m
#/usr/pandora/scripts/pnd_run.sh -p "$smplayerlocation" -m

coursesfolder()
{
#Startup script create courses folder
if [ ! -d "COURSES" ]; then
  mkdir "COURSES" #creates folder for first time if not there
fi
}

firststartcheck()
{
#first message. Ideally should not appear twice. to test if it works 
if [ ! -f "firststart.txt" ] ; then
  #./yad --title="Courserian" --borders=10 --width=500  --button="gtk-ok:0"  --text="Welcome to Courserian. Courserian is a tool to make it easy for you to download, browse and manage your Coursera lessons." "$icon" --on-top
$yadcall --title="Courserian" --borders=10 --width=500  --button="gtk-ok:0"  --text="Welcome to Courserian. Courserian is a tool to make it easy for you to download, browse and manage your Coursera lessons." "$icon" --on-top
  
else
  touch firststart.txt #should create a file without content
fi
}

startupscript()
{
courseentry="Remove/delete a course"
browsecourse="Browse your courses"
updatecourse="Download/update your courses"

#last folder function does not work somehow...
if [ -f "lastfolder.txt" ]; then
  lastfolder=$(head -n 1 lastfolder.txt)
else
  lastfolder=""
fi
echo "$lastfolder"

#test for login
if [ -f "login.txt" ] && [ -f "password.txt" ]; then
  login=$(head -n 1 login.txt)
  password=$(head -n 1 password.txt)
  loginentry="Modify your Login details"
else
  login=""
  password=""
  loginentry="Enter your Login details"
fi
}

menu()
{
if [ "$login" != "" ]; then
  menutitle="Menu [ $login ]" #display your porfile name is login is registered
else
  menutitle="Menu"
fi
echo "$menutitle"

if [ $totalcourses -eq 0 ] ; then
  choice=$($yadcall --center --width=300 --borders=5 --height=330 --title="Courserian" --list --column="$menutitle" "$loginentry" "Add a course to follow" "Credits" --image="coursera-small.png" --image-on-top "$icon" --button="gtk-quit:1" --on-top)
else
  #if [ "$lastfolder" != "" ]; then
  #choice=$(./yad --center --width=300 --borders=5 --height=330 --title="Courserian" --list --column="$menutitle" "$loginentry" "Add a course to follow" "$courseentry" "Last working folder" "$browsecourse" "$updatecourse" "Extras" "Credits" --image="coursera-small.png" --image-on-top --button="gtk-quit:1" "$icon" --on-top)
  #else
  
  #Need to ADD CONDITION FOR DESKTOP AND PANDORA DIFFERENCES
  choice=$($yadcall --center --width=300 --borders=5 --height=330 --title="Courserian" --list --column="$menutitle" "$loginentry" "Add a course to follow" "$courseentry" "$browsecourse" "$updatecourse" "Extras" "Credits" --image="coursera-small.png" --image-on-top --button="gtk-quit:1" "$icon" --on-top)
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

if [ "$choice" == "Last working folder" ]; then  #not working yet
  set -- "$lastfolder" 
  IFS="/"; declare -a Array=($*) 
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
  $yadcall --center --width=380 --borders=5 --height=330 --title="Courserian" --image="coursera2.png" --image-on-top --text-info --filename=creditsnew.txt --button="gtk-ok" --on-top
  menu
fi
}

warnlogindetails()
{
$yadcall --center --width=200 --borders=5 --height=80 --title="Courserian" --text="You need to first enter your login details in order to download anything." "$icon" --on-top
}

extrasmenu()
{
size=${#smplayerlocation}
if [ "$size" -lt 5 ] ; then
  choice=$($yadcall --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Download courses" "[Back to main menu]" "Find SMPlayer" "$icon" --button="gtk-quit:9" --on-top)
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
    choice=$($yadcall --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Download courses" "[Back to main menu]" "Unmount SMPlayer" "$icon" --button="gtk-quit:9" --on-top)
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
    choice=$($yadcall --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Download courses" "[Back to main menu]" "Make SMPlayer the default player" "$icon" --button="gtk-quit:9" --on-top)
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
choice=$($yadcall --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Download courses" "[Back to main menu]" "Download/Update a single course" "Download/update all" "$icon" --button="gtk-quit:9" --button="Top Menu:5" --on-top)
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

downloadallcourses() #download all courses one after the other
{
cd COURSES
currentcourse=""
for i in $(ls -d */)
  do
    i=$(echo $i | awk 'BEGIN {FS="/" } { print $1 }')
    $currentcourse+="$i "
  done
cd ..
checkonline
downloadsingleone
cd COURSES
cd ..
menu
}

showcourses()
{
addedtext=""
echo "$mode"
if [ "$mode" == "download" ] ; then addedtext="to download" ; fi
if [ "$mode" == "delete" ] ; then addedtext="to delete" ; fi
choice=$($yadcall --center --image="coursera-small.png" --image-on-top --width=300 --borders=5 --height=300 --title="Courserian" --list --column="Select a course $addedtext" --column="Folder Size" "[Back to main menu]" " " $listofcourses --button="gtk-quit:9" --button="Top Menu:5" "$icon" --on-top)
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
    checkonline
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

calculateduration()
{
#to test, not active yet
mplayer -vo null -ao null -frames 0 -identify "$@" 2>/dev/null |
        sed -ne '/^ID_/ {
                          s/[]()|&;<>`'"'"'\\!$" []/\\&/g;p
                        }'
}

deletecourseconfirm()
{
echo "delete course confirm"
confirm=$($yadcall --center --width=200 --borders=5  --title="Courserian" --text="Are you sure you want to delete\n the course $currentcourse ?" --button="gtk-yes:0" --button="gtk-no:1" "$icon" --on-top)
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
    sizeoffolder=$(du -b "$i" | cut -f 1)
    sizeoffolder=$((sizeoffolder / 2**20))
    listoffolders+="$i $sizeoffolder "
    #listoffolders+=" "
  done
cd ..
cd ..
choice=$($yadcall --center --image="coursera-long.png" --image-on-top --width=700 --borders=5 --height=350 --title="Courserian" --list --column="$currentfolder > Select a subfolder" --column="Size (Mb)" "[Back to previous menu]" " " $listoffolders --button="gtk-quit:9" --button="Top Menu:5" --button="Go Up:4" "$icon" --on-top)
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
choice=$($yadcall --image="coursera-long.png" --image-on-top --center --width=700 --borders=5 --height=350 --title="Courserian" --list --column="$columntext" --column="Size (Mb)" --column="Viewed" "[Back to previous menu]" " " " " $listofmaterials --button="gtk-quit:9" --button="$buttonvideolabel:6" --button="Top Menu:5" --button="Go Up:4" "$icon" --on-top)
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
  if [ "$runningmachine" == "pandora" ] ; then
    mousepad COURSES/"$currentfolder"/"$materialfolder"/"$choice"
  else
    xdg-open COURSES/"$currentfolder"/"$materialfolder"/"$choice"
  fi
  explorematerials
fi
if [ "$extension" == "pdf" ] ; then
  " " > COURSES/"$currentfolder"/"$materialfolder"/".""$choice"".read"
  if [ "$runningmachine" == "pandora" ] ; then
    evince -s COURSES/"$currentfolder"/"$materialfolder"/"$choice"
  else
    xdg-open COURSES/"$currentfolder"/"$materialfolder"/"$choice"
  fi
  explorematerials
fi
if [ "$extension" == "mp4" ] ; then

  " " > COURSES/"$currentfolder"/"$materialfolder"/".""$choice"".read"

  if [ "$runningmachine" == "pandora" ] ; then
    if [ "$smplayerison" == "yes" ] ; then	
      "COURSES/$currentfolder/$materialfolder" > lastfolder.txt
      /mnt/utmp/smplayer/bin/mplayer -ss 14 -framedrop -vo omapfb -autoq 6 -fs -nocache COURSES/"$currentfolder"/"$materialfolder"/"$choice" > out.txt
      #/mnt/utmp/smplayer2_r6/bin/smplayer2 COURSES/"$currentfolder"/"$materialfolder"/"$choice"
      #else
      #mplayer/bin/mplayer -vo sdl -autoq 3 -nocache -fs -framedrop COURSES/"$currentfolder"/"$materialfolder"/"$choice"
    else
      echo "COURSES/$currentfolder/$materialfolder" > lastfolder.txt
      mplayer -fs -framedrop -vo sdl COURSES/"$currentfolder"/"$materialfolder"/"$choice"
    fi
  else
    xdg-open COURSES/"$currentfolder"/"$materialfolder"/"$choice"
  fi
explorematerials
fi
if [ "$extension" == "ptx" ] ; then
  explorematerials
fi
}

#LOGIN / PASSWORD
login()
{
dialog=$($yadcall --center --borders=10 --title="Login Details" --form --field="Coursera Login" --text="Login info will be saved locally" --field="password":H "$icon" --on-top)
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
entry=$($yadcall --width=400 --center --borders=10 --title="Courserian" --text="Enter the course code you wish to add.\n You can find this code or short name in the URL of your course.\n For example..." --form --field="Course Name" "$icon" --on-top)
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
answer=$($yadcall --width=350 --center --borders=10 --title="Courserian" --text="You have just added the course $entry in Courserian,\n would you like to download the course contents right now ?\n\n Note that you need to have accepted the code of Honor\n for that particular course on the Coursera website first." --button="gtk-yes:0" --button="gtk-no:1" "$icon" --on-top)
ret=$?
echo "$ret"
if [[ $ret -eq 0 ]]; then
  currentcourse="$entry"
  echo $ret
  checkonline
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

splashscreen()
{
  $yadcall --width=380 --height=140 --image="coursera-large.png" --undecorated --no-buttons --borders=5 --timeout=3 --timeout-indicator=bottom --image-on-top "$icon" --on-top
}
#DOWNLOAD single coursepython 
downloadsingleone()
{
echo $currentcourse > currentcourse.txt
python tracker.py & #this script takes care of displaying the progress bar. Not sure how I can do it the same way in bash...
}

#FULL PROGRAM FLOW BELOW---------------------------------------

#pandora specific for drivers (not sure if it actually makes much difference)
export SDL_VIDEODRIVER="omapdss"
export SDL_OMAP_LAYER_SIZE="fullscreen"

creditsfile
desktoporpandora
coursesfolder
updatecourselist
firststartcheck
startupscript
#./yad --width=380 --height=140 --image="coursera-large.png" --undecorated --no-buttons --borders=5 --timeout=3 --timeout-indicator=bottom --image-on-top "$icon" --on-top
splashscreen
menu
