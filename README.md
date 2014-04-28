Courserian
==========

A frontend GUI to download courses and materials from Coursera. 
Made for Pandora in the first place - and now it should also run on any GNU/Linux environment.

## Requirements

*  Yad (should be easy to install via most distros' repositories)
*  Python 2.7 (not tested on other versions)
*  coursera-dl in the working folder
*  coursera-dl dependencies

## Usage

Once you satisfy the requirements, you simply have to run the run.sh from the working directory, usually in this fashion: 

    ./run.sh 

Note that you may need to make the run.sh file executable first: 

    sudo chmod +x run.sh
    
## Preferences

The folder by default where Coursera courses are downloaded is the one named COURSES in the working directory. You cannot change the path in the program at this stage but it's fairly easy to modify the sources to do so. 

