% contour42_curves.m

% Companion script to contour42.m that extracts curves from dynamic data 
% (such as pefusion) using the generated contour masks.

% Arguments to pass to function for different data types:
% 
% Quantitative Perfusion data (cvi42):
% This data type can be evaluated by calling the function with the 'QP' 
% argument. Example: contour42_curves('QP')

function contour42_curves(mode)
%%

    mode='QP';
    % Get the path to the main study folder (as defined in contour42.m header)
    disp('// Please select the main directory of the study')
    path = GetPath;
    
    % Contour masks folder
    contour_path = [path.full '/contours'];

    % Create curves folder
    curves_folder = [path.full '/curves'];
    if ~exist(curves_folder,'dir'); mkdir(curves_folder); end
    
    switch mode
        
        % QP mode
        % This mode assumes that the sub-strings 'QP', 'AIF', 'Rest' and 
        % 'Stress can be found in the 'SeriesDescription' dicom tag and 
        % therefore also in the names of the imported .mat files.
        case 'QP'
            
            % Scan path for ID folders
            study_list = dir([contour_path '/ID_*']);
            study_list = natsortfiles(study_list);
            study_names = string({study_list.name});

            % Loop over study names
            for k = 1:length(study_names)
                
                % k'th study path
                current_path = [path.full '/contours/' study_names{k}];

                    % Check if filenames contains QP, AIF, Rest, Stress
                    series_list = dir(current_path);
                    series_names = string({series_list.name});
                    
                    % Loop over series names
                    for k2 = 1:length(series_names)
                        
                        % if QP + AIF = AIF rest
                        if contains(lower(series_names{k2}), 'qp') &&...
                                contains(lower(series_names{k2}), 'aif') &&...
                                contains(lower(series_names{k2}), 'rest')

                            mask_paths(1) = string([current_path '/' series_names{k2}]);

                        % if QP + AIF = AIF stress
                        elseif contains(lower(series_names{k2}), 'qp') &&...
                                contains(lower(series_names{k2}), 'aif') &&...
                                contains(lower(series_names{k2}), 'stress')

                            mask_paths(2) = string([current_path '/' series_names{k2}]);

                        % if QP + Rest = myo rest
                        elseif contains(lower(series_names{k2}), 'qp') &&...
                                contains(lower(series_names{k2}), 'rest')

                            mask_paths(3) = string([current_path '/' series_names{k2}]);
                        
                        % if QP + Stress = myo stress
                        elseif contains(lower(series_names{k2}), 'qp') &&...
                                contains(lower(series_names{k2}), 'stress')

                            mask_paths(4) = string([current_path '/' series_names{k2}]);

                        end
                    end
            
                    % Load contour masks for each series
                    % masks{1} = AIF rest, masks{2} = AIF stress, 
                    % masks{3} = myo rest, masks{4} = myo stress 
                    for k3 = 1:length(mask_paths)
                        [~,file] = fileparts(mask_paths{k3});
                        masks{k3} = load([mask_paths{k3} '/' file ' [Contour Masks].mat']);
                    end

                    % Generate AHA segments from contour mask
                    % AHA_segments(x,y,slice,1=rest/2=stress)
                    [AHA_segments, information] = contour42_segments(masks);
                                        
                    % Generate AHA territories from AHA segments
                    AHA_territories = contour42_territories(AHA_segments);

                    % Generate additional masks
                    % As in contour42_segments.m, I assume that all the 
                    % contours are the same for each slice in the QP series.
                    % The 'index' variable controls which InstanceNumber 
                    % the masks are extracted from.

                    % Save mask data for viewing purposes
                    rest.segments = AHA_segments(:,:,:,1);
                    stress.segments = AHA_segments(:,:,:,2);
                    rest.territories = AHA_territories(:,:,:,1);
                    stress.territories = AHA_territories(:,:,:,2);
                    rest.global = information.rest.global_mask;
                    stress.global = information.stress.global_mask;
                    rest.AIF_LV = information.rest.AIF_LV;
                    stress.AIF_LV = information.stress.AIF_LV;
                    rest.AIF_RV = information.rest.AIF_RV;
                    stress.AIF_RV = information.stress.AIF_RV;
                    rest.MYO_LV = information.rest.MYO_LV;
                    stress.MYO_LV = information.stress.MYO_LV;
                    rest.MYO_RV = information.rest.MYO_RV;
                    stress.MYO_RV = information.stress.MYO_RV;
                    rest.info.RV_insertion_point = information.rest.RV_insertion_point;
                    stress.info.RV_insertion_point = information.stress.RV_insertion_point;
                    rest.info.MYO_centre_point = information.rest.MYO_centre;
                    stress.info.MYO_centre_point = information.stress.MYO_centre;
                    rest.info.phases = information.rest.phases;
                    stress.info.phases = information.stress.phases;
                    rest.info.slices = information.rest.slices;
                    stress.info.slices = information.stress.slices;
                    rest.info.index = information.rest.index;
                    stress.info.index = information.stress.index;
                    rest.info.AIF_dicom_path = erase(masks{1}.dicom_path,[path.parent '/']);
                    stress.info.AIF_dicom_path = erase(masks{2}.dicom_path,[path.parent '/']);
                    rest.info.MYO_dicom_path = erase(masks{3}.dicom_path,[path.parent '/']);
                    stress.info.MYO_dicom_path = erase(masks{4}.dicom_path,[path.parent '/']);

                    file_name = [current_path '/QP Masks [Viewing]'];
                    save([file_name,'.mat'],'rest','stress');

                    % Reformat .segments and .territories to 'logical'
                    plane = [1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3];

                    % Segments rest
                    if information.rest.slices == 3
                        avalible_segs = 16; 
                    elseif information.rest.slices == 2
                        avalible_segs = 12;
                    elseif information.rest.slices == 1
                        avalible_segs = 6; 
                    end

                    for k4 = 1:avalible_segs
                        rest_seg_current = squeeze(AHA_segments(:,:,plane(k4),1));
                        rest_segs(:,:,k4) = rest_seg_current == k4;
                    end

                    % Segments stress
                    if information.stress.slices == 3
                        avalible_segs = 16; 
                    elseif information.stress.slices == 2
                        avalible_segs = 12;
                    elseif information.stress.slices == 1
                        avalible_segs = 6; 
                    end

                    for k5 = 1:avalible_segs
                        stress_seg_current = squeeze(AHA_segments(:,:,plane(k5),2));
                        stress_segs(:,:,k5) = stress_seg_current == k5;
                    end

                    % Territories
                    for k6 = 1:3
                        rest_ter_current = squeeze(AHA_territories(:,:,:,1));
                        stress_ter_current = squeeze(AHA_territories(:,:,:,2));
                        rest_ters(:,:,:,k6) = rest_ter_current == k6;
                        stress_ters(:,:,:,k6) = stress_ter_current == k6;
                    end
                    
                    % Save mask data for distribution purposes
                    fields = {'segments','territories'};
                    rest = rmfield(rest,fields);
                    stress = rmfield(stress,fields);

                    rest.segments = rest_segs;
                    stress.segments = stress_segs;
                    rest.territories = rest_ters;
                    stress.territories = stress_ters;

                    file_name = [current_path '/QP Masks [Calculation]'];
                    save([file_name,'.mat'],'rest','stress');

                    clear rest_segs stress_segs rest_ters stress_ters

                    % Load corresponding dicom files
%                     images = dir([dicom_path '/*.dcm']);
%                     images = natsortfiles(images);
%                     for k = 1:length(images)
%                         I(:,:,k) = dicomread([images(k).folder '/' images(k).name]);
%                     end
                    
                    % contour42_conc.m % calculate [Gad] conc. maps
                    % T1(s) = TR ./ ln{ [cos(α)*S(t)-sin(α)*k] ./ [S(t)-sin(α)*k] }
                    % So long as { [cos(α)*S(t)-sin(α)*k] ./ [S(t)-sin(α)*k)] } > 0
    
                    % Extract [Gad] curves for each sub-contour

                    % Extract raw SI curves for each sub-contour (just to have)

                    % Save QP_curves.mat in main/curves/ID_N
                    % contains AIF_rest, AIF_stress, rest, stress

            end
    
        case 'other'
    
            % Another usecase - fill in code here
    end
    %%
end