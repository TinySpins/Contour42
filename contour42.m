% Contour42.m

% Tool to extract contours created using the cvi42 software for cardiac magnetic resonance (CMR) imaging analysis, produced by Circle.
% The tool uses exported cvi42 workspaces to extract the contours into .mat format.

% The script expects a folder stucture containing the exported cvi42 workspaces and dicom image data that follows the below pattern:
%
% Main folder
%  │
%  ├── file
%  ├── file
%  ├── file
%  │
%  ├── workspaces
%  │   ├── ID_1
%  │   ├── ID_2
%  │   └── ID_N
%  │
%  └── dicom
%      ├── ID_1
%      ├── ID_2
%      └── ID_N
%
% There must be the same number of ID/patient folders in the workspaces and dicom folders.

% The script uses the following naming conventions:
% Output folder name = Contours/'Main folder'

% House cleaning
clear all; close all; clc;

% Get main folder path
path = GetPath;

% Create output folder
output_folder = [path.full '/contours'];
if ~exist(output_folder,'dir') mkdir(output_folder); end

% Create temp folder
temp_folder = [path.full '/temp'];
if ~exist(temp_folder,'dir') mkdir(temp_folder); end

% Go to script directory to execute python component
if(~isdeployed)
  cd(fileparts(which(mfilename)))
end

% Run xml parser (loop over workspaces) - have python generate a file to tell matlab that it has finished (matlab runs infinite while loop to detect the file)
% The selection of workspace needs to automated (changed per loop
% iteration) in the below code!!
for % loop over ID folders in workspace folder
    run_command = ['python ''parse_cvi_xml/parse_cvi42_xml.py'' '''...
                    path.full '/workspaces/ID_1.cvi42wsx'' '''...
                    path.full '/temp'''];
    system(run_command);
    
    % Wait for python component to finish
    filename = [path.full '/temp/status_done.txt'];
    while exist(filename)==0 
        pause(1) 
    end
    disp('test delay')
end

% Run matlab sorting into a structure (Dicom headers needed for this?)

% Export sorted .mat file for each cvi42 module and delete temp files created by xml parser

% more?

% load('/Users/chmari/Documents/Dokumenter PC/Code/python/projects/Contour42/demo_data/1.2.840.113619.2.453.5554020.7718065.28088.1614582135.369.mat')
% plot(contours.sarvendocardialContour(:,1),contours.sarvendocardialContour(:,2))