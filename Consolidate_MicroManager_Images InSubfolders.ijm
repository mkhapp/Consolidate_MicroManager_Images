// *************  README  ***************
// This macro was created for Xuehua Xu in February 2024 to help her organize images taken
// by a basic upright microscope controlled by MicroManager.  The MM program saves each image
// in a separate folder along with extra files containing metadata.  Xuehua needs to be able
// to access the images easily, so they need to be combined in jpeg- and tiff-specific folders
// within the subdirectory.
//
// This macro searches for the subfolders containing tiffs, then saves them (as both jpegs and
// tiffs) in new subfolders containing all the jpegs/tiffs within each subdirectory.  The name
// of the image is based on the folder it is contained in.  This program is level agnostic - that
// is, any number of subdirectories is supported.
//
// Ensure that all folders and subfolders are contained in a single directory.  Select this
// directory in the first step (a pop-up window) and then wait for the program to finish. A log
// window will pop up with the word "Finished!" when the program was done, if no errors occurred.


setBatchMode(true);

//allow user to select folder
Dialog.create("Choose A Folder");
Dialog.addDirectory("Images Folder", "");
Dialog.show();
path = Dialog.getString();

function SaveAsOthers(name, imagepath, jpegpath, tiffpath) {
	//takes the given image and saves it as both a tiff and a jpeg in the given folders
	run("Bio-Formats Importer", "open=["+imagepath+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Enhance Contrast", "saturated=0.35");
	saveAs("Tiff", tiffpath+name+".tif");
	saveAs("Jpeg", jpegpath+name+".jpg");
	close("*");
}

function FindTiffs(dir) {
	//finds tiffs and saves them as tiffs and jpegs within the subfolder
	list = getFileList(dir);
	for (ii = 0; ii < list.length; ii++) {
		if (endsWith(list[ii], "/")) {
			FindTiffs(dir+list[ii]);
		} else {
			if (endsWith(list[ii], ".tif")) {
				//get directory name one above folder level
				newdir = split(dir, "/");
				newdir = Array.deleteIndex(newdir, newdir.length-1);
				newdir = String.join(newdir, "/")+"/";
				
				//make jpeg and tiff folders if they don't exist yet
				if (File.exists(newdir + "1_jpegs/") == 0) {
					File.makeDirectory(newdir + "1_jpegs/");
					File.makeDirectory(newdir + "2_tiffs/");
				}
				
				//save to appropriate folders
				newname = replace(dir, newdir, "");
				newname = replace(newname, "/", "");
				SaveAsOthers(newname, dir+list[ii], newdir+"1_jpegs/", newdir+"2_tiffs/");
			}
		}
	}
}


FindTiffs(path);

print("Finished!");