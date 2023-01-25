% contour42_organize.m

% Core function of contour42.m that handles the further sorting and 
% organizing of the (UID named) .mat files produced by the Python
% component.

function contour42_organize(path,study_names)

    % Deploy a waitbar to monitor progress
    f = waitbar(0, 'Preparing further processing');

    % Loop over dicom data and sort
    for k = 1:length(study_names)

        % Update waitbar
        waitbar((k-1)./length(study_names),f,['Generating contour masks' ...
                     ' from XML workspace file: ' num2str(k) ' of ' ...
                        num2str(length(study_names))]);
        
        % k'th dicom study path
        current_study_path = [path.full '/dicom/' study_names{k}];
    
        % Go to bottom of study directory tree, get series path's
        current_study_path_structure = genpath(current_study_path);
        current_study_path_structure_list = split(...
            current_study_path_structure,':');
        study_dir_structure_depth = cellfun('length',strfind(...
            current_study_path_structure_list,'/'));
        series_path_list = current_study_path_structure_list(...
            study_dir_structure_depth>=max(study_dir_structure_depth));
        
        % Dicom attrs
        attributes = {'SOPInstanceUID','InstanceNumber',...
            'SeriesDescription','Rows','Columns'};
    
        % For each series do
        for kk = 1:length(series_path_list)
            
            % Get list of slices in series
            slice_list = dir([series_path_list{kk} '/*.dcm']);
            
            % For each slice do
            for kkk = 1:length(slice_list)
                
                % Collect slice information
                info = GetDicomHeader([slice_list(kkk).folder...
                    '/' slice_list(kkk).name], attributes);
                SeriesDescription{kkk} = info.SeriesDescription;
                
                % Get contour matching slice SOPInstanceUID
                ID_folder = [path.full '/temp/' study_names{k}];
                UIDmat = load([ID_folder '/' info.SOPInstanceUID '.mat']);
                
                % Save to structure for entire series
                instance_field = ['InstanceNumber_' num2str(info.InstanceNumber)];
                UIDcontours.(instance_field) = UIDmat.contours;
                clear UIDmat
    
            end
            
            % Sort the contours/UID's according to InstanceNumber
            [~, Index] = natsort(fieldnames(UIDcontours));
            contours = orderfields(UIDcontours,Index);

            % Detect series name
            [s,~,j]=unique(SeriesDescription);
            common = s{mode(j)};
            
            % Check if all slices (dicoms) in the series have the same series
            % description. I.e. if they are of the same series.
            if ~isequal(SeriesDescription{:})
                warning(['One or more slices in the following series do ' ...
                    ['not share SeriesDescription Dicom tag with the rest ' ...
                    'of the slices: '] common])
            end
    
            % Create current series contour directory
            series_folder = [path.full '/contours/' study_names{k} '/' common];
            if ~exist(series_folder,'dir'); mkdir(series_folder); end
    
            % Save contour structure .mat to series contour directory
            file_name = [series_folder '/' common ' [Contour Polygons]'];
            dicom_path = series_path_list{kk};
            save([file_name,'.mat'],'contours','SeriesDescription','dicom_path');

            % Scan contour file for contour annotations
            temp = string();
            for kkkk = 1:length(fieldnames(contours))
                instance = ['InstanceNumber_' num2str(kkkk)];
                current = fieldnames(contours.(instance));
                temp = [temp; string(current)];
            end
            unique_annotations = unique(temp);
            blanks = cellfun(@isempty, unique_annotations);
            annotations = unique_annotations(~blanks);

            % Convert poly's to mask's and save .mat
            for k5 = 1:length(fieldnames(contours)) % each slice
                for k6 = 1:length(annotations) %each contour annotation
                    instance = ['InstanceNumber_' num2str(k5)];
                    annotation = [annotations{k6}];
                    
                    try
                        current = contours.(instance).(annotation);
                        current_mask = poly2mask(current(:,1),current(:,2),...
                                        double(info.Rows),double(info.Columns));
                    catch me
                        current_mask = zeros(double(info.Rows),double(info.Columns));
                    end

                    mask.(annotation)(:,:,k5) = current_mask;
                    
                end
            end

            % Save masks .mat to series contour directory
            file_name = [series_folder '/' common ' [Contour Masks]'];
            dicom_path = series_path_list{kk};
            save([file_name,'.mat'],'mask','SeriesDescription','dicom_path');

            % Clear some variables
            clear info SOPInstanceUID SeriesDescription mask current_mask...
                series_folder common s j UIDcontours instance_field contours
        end
    
    end

    % Close waitbar
    close(f)

end