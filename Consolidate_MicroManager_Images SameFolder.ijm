// *************  README  ***************
// This macro was created for Xuehua Xu in February 2024 to help her organize images taken
// by a basic upright microscope controlled by MicroManager.  The MM program saves each image
// in a separate folder along with extra files containing metadata.  Xuehua needs to be able
// to access the images easily, so they need to be combined in jpeg- and tiff-specific folders
// within the subdirectory.
//
// This macro creates new folders within the original directory for tiffs and jpegs.  It then
// searches through all folders and subfolders for tiffs, then saves them all together (as both
// jpegs and tiffs) in the folders contained at the beginning of the directory.  The name
// of each image is based on the full path of folders it is contained in.  This program is level
// agnostic - that is, any number of subdirectories is supported.
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

File.makeDirectory(path+"1_jpegs/");
File.makeDirectory(path+"2_tiffs/");


function SaveAsOthers(imagepath, jpegpath, tiffpath) {
	//this function saves the given image as both a jpeg and a tiff in the given paths; the
	//name of the given image is based on the complete folder-subfolder pathway.
	newname = replace(imagepath, path,"");
	newname = replace(newname, "/", "_");
	newname = replace(newname, ".ome.tif", "");
	run("Bio-Formats Importer", "open=["+imagepath+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Enhance Contrast", "saturated=0.35");
	saveAs("Tiff", tiffpath+newname+".tif");
	saveAs("Jpeg", jpegpath+newname+".jpg");
	close("*");
}

function FindTiffs(dir) {
	list = getFileList(dir);
	for (ii = 0; ii < list.length; ii++) {
		if (endsWith(list[ii], "/")) {
			FindTiffs(dir+list[ii]);
		} else {
			if (endsWith(list[ii], ".tif")) {
				SaveAsOthers(dir+list[ii], path+"1_jpegs/", path+"2_tiffs/");
			}
		}
	}
}

FindTiffs(path);

print("Finished!");