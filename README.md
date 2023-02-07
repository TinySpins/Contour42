## Contour42
Extract contours created using the [Circle cvi42 CMR software](https://www.circlecvi.com/).


### Overview
Contour42 utilizes Matlab and Python to extract contours created using the Circle cvi42 software for cardiac magnetic resonance (CMR) imaging analysis. The tool uses exported cvi42 XML workspaces to extract the contours into `.mat` format for Matlab.

The tool currently supports up to Circle cvi42 software version 5.13


### Terms of use
The code is provided under the GNU General Public License. Please review the included license file before altering and distributing the code.
Note that the Python component of this tool is a fork of another project, and is provided seperately under the Apache-2.0 License. The Python component and its corresponding license file can be found in the 'parse_cvi_xml' directory.


### Prerequisites
- An exported Circle cvi42 workspace XML with file extension .cvi42wsx
- Matlab (requires Matlab R2022b or newer)
- Python 3 (tested with Python 3.7.7)
#### Required Python packages
- numpy
- scipy
#### Required Matlab FEX packages
- [Natural-Order Filename Sort](https://se.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort) (Version 3.4.4)
- [imtool3D](https://se.mathworks.com/matlabcentral/fileexchange/74761-imtool3d_td) (Version 1.0.4)
#### How to export a Circle cvi42 XML workspace
Open cvi42. Open a study. If there are no contours defined for any of the series in the study, draw some contours, then save the workspace.
To export the workspace as XML, click on 'Workspace' in the top menu, select 'Export Workspace' in the drop down menu. Fill in a proper name for the workspace. In the 'Save as type:' field, select `Cvi42 XML Workspace (*.cvi42wsx)`. Click 'Save'.
Note that it is important to export workspaces in the `.cvi42wsx` format. The `.cvi42ws` format is in binary, and will not work.


### Usage
#### Normal use
Place the 'Contour42' project directory in you Matlab path, and open the `contour42.m` file in Matlab. Run the script.

When prompted by the GUI, select a main working directory containing the following subdirectories (adhere strictly to the naming scheme):
- workspaces (directory containing your workspaces, e.g. study_1, study_2...)
- dicom (directory containing subdirectories, e.g.: study_1, study_2... Each subdirectory contains further subdirectories for each series for which we want to extract contours)

Note that the tool uses the Dicom UID to match the slices for all entries in the 'dicom' directory to Dicom UID's in the workspace XML files. Hence, there will only be an output contour for a particular slice, if its Dicom UID can be found in both the XML workspace and 'dicom' directory files.

Any produced .mat files containing cvi42 contours will be saved in an automatically created 'contours' directory in the main working directory.
#### Only Python component (.xml parser)
If needed, the Python component can be run as a standalone script to extract contours from one Circle cvi42 XML workspace. This will produce a .mat file for each slice in the workspace with a contour, in the designated output directory. The naming convention for these files are the Dicom UID of the respective slices/images, which can be found in the Dicom headers of the corresponding images/slices.

Open a new terminal and navigate to the 'parse_cvi_xml' subdirectory in the main 'Contour42' project directory using `cd path/to/dir`. This directory contains the standalone Python component of the tool: `parse_cvi42_xml.py`.

Run the script in the terminal by executing `python parse_cvi42_xml.py xml_path output_path`.
- `xml_path` is the path to the cvi42 xml file. For example: `/Users/Username/Desktop/Folder/workspace.cvi42wsx`.
- `output_path` is the path where the produced .mat files will be saved. For example: `/Users/Username/Desktop/Folder/Output`.