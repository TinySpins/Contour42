% contour42.m

% Tool to extract contours created using the cvi42 software for cardiac 
% magnetic resonance (CMR) imaging analysis, produced by Circle.
% The tool uses exported cvi42 workspaces to extract the contours into 
% .mat format.

% After running this script the following two scripts provide additional 
% functionality ans must be called independently:
%  - contour42_view.m enables viewing of the generated contour masks.
%  - curves42_QP.m can generate curves from dynamic Quantitative Perfusion
%    data using the generated contour masks.

% The script expects a folder stucture containing the exported cvi42 
% workspaces and dicom image data that follows the below pattern:
%
% Main folder
%  │
%  ├── workspaces
%  │   ├── ID_1
%  │   ├── ID_2
%  │   └── ID_N
%  │
%  └── dicom
%      ├── ID_1
%      │      ├── Series_1
%      │      ├── Series_2
%      │      └── Series_N
%      ├── ID_2
%      │      ├── Series_1
%      │      ├── Series_2
%      │      └── Series_N
%      └── ID_N
%             ├── ...
%             ...
%
% There must be the same number of ID/patient folders in the workspaces 
% and dicom folders. The study folders and workspaces must be named ID_...
% The workspace corresponding to a given study directory must have the same
% name for sorting purposes, e.g. workspaces/ID_1.cvi42wsx and dicom/ID_1.


% House cleaning
clear all; close all; clc;

% Get main folder path
path = GetPath;

% Create output folder
output_folder = [path.full '/contours'];
if ~exist(output_folder,'dir'); mkdir(output_folder); end

% Create temp folder
temp_folder = [path.full '/temp'];
if ~exist(temp_folder,'dir'); mkdir(temp_folder); end

% Scan the workspaces directory for XML (.cvi42wsx) workspaces
xml_list = dir([path.full '/workspaces/*.cvi42wsx']);
xml_list = natsortfiles(xml_list); % sort them according to number
xml_names = string({xml_list.name});

% Scan the dicom directory for corresponding study folders
study_list = dir([path.full '/dicom/ID_*']);
study_list = natsortfiles(study_list);
study_names = string({study_list.name});

% Verify workspaces and studies match in number and naming
if length(xml_names)~=length(study_names)
    error('Number of workpaces and studies do not match')
end
inBoth = intersect(study_names,erase(xml_names,'.cvi42wsx'));
if length(inBoth)~=length(study_names) || length(inBoth)~=length(xml_names)
    error(['One or more studies or XML files are not paired -' ...
        ' check if they are named correctly'])
end

% Parse cvi42 XML workspaces
contour42_parse(path,study_names,xml_names)

% Sort and organize the contours into friendly format
contour42_organize(path,study_names)

% Delete the temp directory to save space
status = rmdir(temp_folder, 's');