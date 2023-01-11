## Contour42
Extract contours created using the [Circle cvi42 CMR software](https://www.circlecvi.com/).


### Overview
Contour42 utilizes Matlab and Python to extract contours created using the cvi42 software for cardiac magnetic resonance (CMR) imaging analysis, produced by Circle. The tool uses exported cvi42 workspaces to extract the contours into .mat format for Matlab.

The tool currently supports up to Circle cvi42 software version 5.13


### Terms of use


### Prerequisites
- An exported Circle cvi42 workspace with file extension .cvi42wsx
- Matlab
- Python 3


### Installation

#### Install Python

#### Install required packages

#### Install the tool


### Usage
### Normal use

### Only Python component (.xml parser)
If needed, the Python component can be run as a standalone script to extract contours from one Circle cvi42 workspace. This will produce a .mat file for each slice in the workspace with a contour, in the designated output folder. The naming convention for these files are the Dicom UID of the respective slices/images, which can be found in the Dicom headers of the corresponding images/slices.

Open a new terminal and navigate to the 'parse_cvi_xml' subdirectory in the main 'Contour42' project directory using `cd path/to/dir`. This folder contains the standalone Python component of the tool: `parse_cvi42_xml.py`.

Run the script in the terminal by executing `python parse_cvi42_xml.py xml_path output_path`.
- `xml_path` is the path to the cvi42 xml file. 
    For example `/Users/Username/Desktop/Folder/workspace.cvi42wsx`.
- `output_path` is the path where the produced .mat files will be saved. For example `/Users/Username/Desktop/Folder/Output`.


### Demo
A demonstration workspace, demo.cvi42wsx, is included with this tool. The demo workspace can be found in the folder demo_data.

After installation, run the demonstration:
