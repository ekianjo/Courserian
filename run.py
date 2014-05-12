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


def getFolderSize(folder):
    total_size = os.path.getsize(folder)
    for item in os.listdir(folder):
        itempath = os.path.join(folder, item)
        if os.path.isfile(itempath):
            total_size += os.path.getsize(itempath)
        elif os.path.isdir(itempath):
            total_size += getFolderSize(itempath)
    return total_size

#see if i cannot simplify this function...
def returnfolders(directory):
    contentdirs=[]
    for element in os.listdir(directory):
        if os.path.isdir(element):
            contentdirs.append(str(element))
    
    finalstring=""
    for element in contentdirs:
        finalstring+="> "+str(element)+" "+getFolderSize(element)+" "
    
    return finalstring
    
def returnfiles(directory):
    contentfiles=[]
    for element in os.listdir(directory):
        if os.path.isfile(element):
            contentfiles.append(str(element))
    
    finalstring=""
    for element in contentfiles:
        finalstring+=str(element)+" "+os.path.getsize(element)+" "
    
    return finalstring      

def firsttimeusage():
    if os.path.isfile("firsttime.txt"):
        return False
    else:
        with open("firsttime.txt", 'a'):
            os.utime("firsttime.txt", None)
        return True

def checkloginpass():
    if os.path.isfile("login.txt") and os.path.isfile("password.txt"):
        return True
    else:
        return False

def displaymenu():
    pass

def main():
    
    createcoursefolder()
    if firsttimeusage()==True:
        pass #display welcome message
    
    
    
    

#locate smplayer
