// *************  README  ***************
// This macro was created for Xuehua Xu in February 2024 to help her organize images taken
// by a basic upright microscope controlled by MicroManager.  The MM program saves each image
// in a separate folder along with extra files containing metadata.  Xuehua needs to be able
// to access the images easily, so they need to be combined in jpeg- and tiff-specific folders
// within the subdirectory.
//
// This macro searches for the subfolders containing tiffs, then saves them (as both jpegs and
// tiffs) in new subfolders containing all the jpegs/tiffs within each subdirectory.  The name
// of the image is based on the folder it is contained in.  This program requires exactly 3 levels
// of subdirectories before the folders with images are found.  It was used to generate the other
// level agnostic programs and is probably of limited use on its own.
//
// Ensure that all folders and subfolders are contained in a single directory with three sublevels.
// Select this directory in the first step (a pop-up window) and then wait for the program to
// finish. A log window will pop up with the word "Finished!" when the program was done, if
// no errors occurred.

setBatchMode(true);

Dialog.create("Choose A Folder");
Dialog.addDirectory("Images Folder", "");
Dialog.show();
path = Dialog.getString();

function SaveAsOthers(name, imagepath, jpegpath, tiffpath) {
	run("Bio-Formats Importer", "open=["+imagepath+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Enhance Contrast", "saturated=0.35");
	saveAs("Tiff", tiffpath+name+".tif");
	saveAs("Jpeg", jpegpath+name+".jpg");
	close("*");
}

dirlvl1 = getFileList(path);
for (i = 0; i < dirlvl1.length; i++) {
	dirlvl2 = getFileList(path+dirlvl1[i]);
	for (j = 0; j < dirlvl2.length; j++) {
		dirlvl3 = getFileList(path+dirlvl1[i]+dirlvl2[j]);
		File.makeDirectory(path+dirlvl1[i]+dirlvl2[j]+"1_jpegs/");
		File.makeDirectory(path+dirlvl1[i]+dirlvl2[j]+"2_tiffs/");
		for (k = 0; k < dirlvl3.length; k++) {
			dirlvl4 = getFileList(path+dirlvl1[i]+dirlvl2[j]+dirlvl3[k]);
			for (m = 0; m < dirlvl4.length; m++) {
				if (endsWith(dirlvl4[m], ".tif")) {
					SaveAsOthers(replace(dirlvl3[k], "/", ""), path+dirlvl1[i]+dirlvl2[j]+dirlvl3[k]+dirlvl4[m], path+dirlvl1[i]+dirlvl2[j]+"1_jpegs/", path+dirlvl1[i]+dirlvl2[j]+"2_tiffs/");
				}
			}
		}
	}
}

print("Finished!");