% contour42_curves.m

% Companion script to contour42.m that extracts curves from dynamic data 
% (such as pefusion) using the generated contour masks.

% Arguments to pass to function for different data types:
% 
% Quantitative Perfusion data:
% This data type can be evaluated by calling the function with the 'QP' 
% argument. Example: contour42_curves('QP')
% 

function contour42_curves(mode)

switch mode

    case 'QP'

        % Load contour masks

        % Load dicom data

        % Define AHA segmentation and territories from myocardial contour
        % make a sub function for calculating these masks

        % Extract raw SI curves for each sub-contour

        % Calculate corresponding [Gad] concentration curves

        % Save curves.mat

    case 'other'

        % Another usecase - fill in code here

end