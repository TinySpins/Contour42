% contour42_view.m

% Companion script to contour42.m that plots the dicom files in a series
% and overlays masks of the extracted cvi42 contours, using imtool3D.m

% Currently, this tool does not sort dicom images according to slice
% dimension, but only by Instance Number dicom tag. This means that slices 
% and their masks are plotted along the 'Slice' dimension in imtool3D only.
    
% House cleaning
clear all; close all; clc;

% Get path to a contour folder:
disp('// Please select the directory of the Contour file you want to display')
disp('// The corresponding Dicom images will load automatically')
path = GetPath;

% Load the contour file
load([path.full '/' path.folder ' [Contour Masks].mat'])

% Load the Dicom series
images = dir([dicom_path '/*.dcm']);
images = natsortfiles(images);
for k = 1:length(images)
    I(:,:,k) = dicomread([images(k).folder '/' images(k).name]);
end

% Prepare masks for plotting
names = fieldnames(mask);
masks = zeros(size(I));
for k = 1:length(fieldnames(mask))
    try % exclude Points
        current_mask = mask.(names{k}) .* k;
        masks = masks + current_mask;
    catch me % handle Points
        task_name = fieldnames(mask);
        if strcmp(class(mask.(names{k})),'double') && contains(task_name{k},'Point')
            % turn point into mask and add
            for kk = 1:size(mask.(names{k}),3)
                ind = sub2ind(size(I,1,2),...
                                round(mask.(names{k})(1,2,kk)),...
                                       round(mask.(names{k})(1,1,kk)));
                blank = zeros(size(I,1,2));
                blank(ind) = 10;
                point_mask(:,:,kk) = blank;
            end
            masks = masks + point_mask;
        end
    end
end

% Display images and contour masks in Imtool3D
tool = imtool3D(I);
tool.setMask(masks)
tool.setAlpha(.3)

% Clear command window
clc;
