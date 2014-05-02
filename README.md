Courserian
==========

A frontend GUI to download courses and materials from Coursera. 
Made for Pandora in the first place - and now it should also run on any GNU/Linux environment.

## Requirements

*  Yad (should be easy to install via most distros' repositories)
*  Python 2.7 (not tested on other versions)
*  Coursera-dl 

For coursera-dl there are two ways you can do it:
*  Put coursera-dl and its dependencies directly in the same working folder as Courserian.
*  OR the easy way to take care of everything for you: 

    sudo pip install coursera-dl

And then you should be done. 

## Usage

Once you satisfy the requirements, you simply have to run the run.sh from the working directory, usually in this fashion: 

    ./run.sh 

Note that you may need to make the run.sh file executable first: 

    sudo chmod +x run.sh
    
## Preferences

The folder by default where Coursera courses are downloaded is the one named COURSES in the working directory. You cannot change the path in the program at this stage but it's fairly easy to modify the sources to do so. 

