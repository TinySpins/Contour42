% contour42_parse.m

% Core function of contour42.m that handles the call to the Python
% component doing the parsing of the cvi42 XML workspace.

function contour42_parse(path,study_names,xml_names)

    % Go to script directory to execute python component
    if(~isdeployed)
      cd(fileparts(which(mfilename)))
    end

    % Deploy a waitbar to monitor progress
    f = waitbar(0, 'Preparing to parse XML file(s)');
    
    % Loop over XML workspaces
    for k = 1:length(study_names)
        
        % Update waitbar
        waitbar((k-1)./length(study_names),f,['Parsing XML workspace file: ' ...
                    num2str(k) ' of ' num2str(length(study_names))]);

        % k'th XML workspace path
        current_xml_path = [path.full '/workspaces/' xml_names{k}];
    
        % Create study temp directory
        ID_folder = [path.full '/temp/' study_names{k}];
        if ~exist(ID_folder,'dir'); mkdir(ID_folder); end

        % Check if the workspace was already parsed, if yes then skip
        filename = [path.full '/temp/' study_names{k} '/status_done.txt'];
        if exist(filename)==0

            % Run Python component in current_xml_path
            run_command = ['python ''parse_cvi_xml/parse_cvi42_xml.py'' '''...
                current_xml_path ''' ''' path.full '/temp/' study_names{k} ''''];
            system(run_command);
        
            % Wait for Python component to finish
            while exist(filename)==0
                pause(1)
            end

        end

    end
    
    % Close waitbar
    close(f)

end