#import PyZenity
import subprocess
from threading import Thread
import re

login=""
password=""
currentcourse=""

def getvariables():
	global login,password,currentcourse
	with open('login.txt', 'r') as f:
		login = f.readline().split("\n")[0]
		print login
	with open('password.txt', 'r') as f:
		password = f.readline().split("\n")[0]
		print password
	with open('currentcourse.txt', 'r') as f:
		currentcourse = f.readline().split("\n")[0]

def Run(command):
	proc=subprocess.Popen(command,bufsize=1,
	stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
	universal_newlines=True)
	return proc
	
def Trace(proc):
	global currentcourse
	
	while proc.poll() is None:
		line=proc.stdout.readline()
		if line:
			print "Readline", line
			m=re.search('] (.+?)% ',line)
			message=re.search("Downloading ",line)
			#httpsmessage=re.search("Starting new HTTPS connection",line)
			loggedin=re.search("Logged in on accounts.coursera.org",line)
			if m:
				found=m.group(1)
				print "I found this ",found
				found=int(found)
				found=float(found)
				print found
				proczenity.stdin.write("{0}\n".format(found))
			#if httpsmessage:
			#	proczenity.stdin.write("# Starting new HTTPS connection\n")
			if loggedin:
				proczenity.stdin.write("# Logged in on accounts.coursera.org\n")
			if message:
				if re.search(currentcourse,line):
					totalmessage=""
					message=line.split(currentcourse)
					message=message[-1]
					print message
					message=message.split("/")
					print "messagesplitted", message
					message=message[-1]
					message=message.split("\n")[0]
					message="[ "+message[:50]+"...]"
					proczenity.stdin.write("# Downloading...{0}\n".format(message))
				else:
					proczenity.stdin.write("# {0}\n".format(line))

getvariables()
					
command=["python","coursera-dl","""--path=COURSES""","-u",login,"-p",password,currentcourse]
print command
#cmd = 'zenity --width=500 --height=100 --progress --text="Downloading course... Authenticating..."'
cmd = './yad --title="Courserian" --width=500 --height=65 --progress --image="coursera-progress2.png" --image-on-top --no-buttons --window-icon=icon.png'

proczenity = subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
proc=Run(command)
Trace(proc)
