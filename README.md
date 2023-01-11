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
**Normal use**

**Only Python component (.xml parser)**

If needed, the Python component can be run as a standalone script to extract contours from one Circle cvi42 workspace.

Open a new terminal and navigate to the 'parse_cvi_xml' subdirectory in the main 'Contour42' project directory using `cd path/to/dir`.


```terminl
path = GetPath;
```

### Demo
A demonstration workspace, demo.cvi42wsx, is included with this tool. The demo workspace can be found in the folder demo_data.

After installation, run the demonstration:
