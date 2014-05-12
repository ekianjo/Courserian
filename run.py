import os, subprocess


#yadcall

def desktoporpandora():
    if os.path.isdir("/usr/pandora"):
        runningmachine="pandora"
        yadcall="./yad"
        #locate smplayer
    else:
        runningmachine="desktop"
        yadcall="yad"

#quitprocedure

def createcoursefolder():
    if not os.path.isdir("COURSES"):
        os.makedirs("COURSES")

#see if i cannot simplify this function...
def returncontents(directory):
    contentdirs=[]
    contentfiles=[]
    for element in os.listdir(directory):
        if os.path.isdir(element):
            contentdirs.append(str(element))
        else:
            if os.path.isfile(element):
                contentfiles.append(str(element))
          

#locate smplayer
