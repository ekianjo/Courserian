Courserian
==========

A frontend GUI to download courses and materials from Coursera. 
Made for Pandora in the first place - and now it should also run on any GNU/Linux environment.

## Requirements

*  Yad (should be easy to install via most distros' repositories)
*  Python 2.7 (not tested on other versions). Default on Pandora SZ1.6 and beyond.
*  Coursera-dl

For Coursera-dl you can approach the install in two ways depending on what you run Courserian on:

*  On Pandora (running SZ): Put coursera-dl and its dependencies directly in the same working folder as Courserian.
*  On a Linux PC: the easy way to take care of everything for you: 

Type in a terminal:

    sudo pip install coursera-dl

And then you should be done (provided you have pip installed). 

## Usage

Once you satisfy the requirements, you simply have to run the run.sh from the working directory, usually in this fashion: 

    ./run.sh 

Note that you may need to make the run.sh file executable first: 

    sudo chmod +x run.sh
    
## Preferences

The folder by default where Coursera courses are downloaded is the one named COURSES in the working directory. You cannot change the path in the program at this stage but it's fairly easy to modify the sources to do so. 

## To Do

A lot of upcoming features are to come, such as...

*  Better defaults when playing videos.
*  Video previews (hopefully, will see how that works) running in the corner of the screen
*  Access to course information right from the application.
*  Displaying Pictures for courses titles. 
*  Logging time studying...
*  And more stuff!
