% contour42_view.m

% Companion script to contour42.m that plots the dicom files in a series
% and overlays masks of the extracted cvi42 contours, using imtool3D.m
    
% House cleaning
clear all; close all; clc;

% Get path to a contour folder:
disp('// Please select the directory of the contour file you want to display')
disp('// The corresponding Dicom images will load automatically')
path = GetPath;

% Load the contour file
load([path.full '/' path.folder ' [Contour Masks].mat'])

% Load the Dicom series (use dicomreadVolume instead!!!!)
images = dir([dicom_path '/*.dcm']);
images = natsortfiles(images);
for k = 1:length(images)
    I(:,:,k) = dicomread([images(k).folder '/' images(k).name]);
end

% Prepare masks for plotting
names = fieldnames(mask);
masks = zeros(size(mask.(names{1})));
for k = 1:length(fieldnames(mask))
    current_mask = mask.(names{k}) .* k;
    masks = masks + current_mask;
end

% Display images and contour masks in Imtool3D
tool = imtool3D(I);
tool.setMask(masks)
tool.setAlpha(.1)
tool.setMaskColor(jet(max(masks(:))+1))

% Clear command window
clc;


