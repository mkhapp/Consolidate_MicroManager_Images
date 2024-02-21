# Consolidate_MicroManager_Images
Consolidates MicroManager images to the same folder for ease of comparison.

# *************  README  ***************
This macro set was created for Xuehua Xu in February 2024 to help her organize images taken by a basic upright microscope
controlled by MicroManager.  The MM program saves each image in a separate folder along with extra files containing metadata.
Xuehua needs to be able to access the images easily, so they need to be combined in jpeg- and tiff-specific folders within
the subdirectory.

This series of macros searches for the subfolders containing tiffs, then consolidates them (as both jpegs and tiffs) in new
subfolders.  The directory structure and the location of the consolidated files differs between the three versions.  Read
the README in each separate macro to determine which is most appropriate.  In short:

*3lvls* - only works for directories with three sublevels of folders and is of limited use  
*SameFolder* - level agnostic, saves all images into the same folder with names based on the full pathway directory  
*InSubfolders* - level agnostic, saves images into a new folder created in each sublevel  

To use any of the macros, ensure that all folders and subfolders are contained in a single directory.  Select this directory in
the first step (a pop-up window) and then wait for the program to finish. A log window will pop up with the word "Finished!"
when the program is done, if no errors occurred.
