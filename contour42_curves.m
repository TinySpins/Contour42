% contour42_curves.m

% Companion script to contour42.m that extracts curves from dynamic data 
% (such as pefusion) using the generated contour masks.

% Arguments to pass to function for different data types:
% 
% Quantitative Perfusion data (cvi42):
% This data type can be evaluated by calling the function with the 'QP' 
% argument. Example: contour42_curves('QP')

function contour42_curves(mode)

switch mode

    case 'QP'

        % Load contour masks
        

        % Load dicom data

        % Define AHA segmentation and territories from myocardial contour
        % make a sub function for calculating these masks
        % https://se.mathworks.com/matlabcentral/answers/51398-how-can-i-divide-an-image-into-sectors-with-matlab
        % https://se.mathworks.com/matlabcentral/answers/91010-do-radial-division-on-image-from-the-centroid
        
        % Calculate [Gad] concentration maps
        % T1(s) = TR ./ ln{ [cos(α)*S(t)-sin(α)*k] ./ [S(t)-sin(α)*k] }
        % So long as { [cos(α)*S(t)-sin(α)*k] ./ [S(t)-sin(α)*k)] } > 0

        % Extract [Gad] curves for each sub-contour

        % Extract raw SI curves for each sub-contour (just to have)

        % Save curves.mat

    case 'other'

        % Another usecase - fill in code here

end