% contour42_territories.m

% Core function of contour42_curves.m that takes the AHA segments generated
% by contour42_segments.m and generates AHA territory contour masks.

function AHA_territories = contour42_territories(AHA_segments)
    
    % Define AHA territories
    territory_index(:,1) = [1 2 7 8 13 14]; % LAD
    territory_index(:,2) = [3 4 9 10 15 nan]; % RCA
    territory_index(:,3) = [5 6 11 12 16 nan]; % LCX

    % Pre-allocate
    current = zeros(size(AHA_segments));

    % Loop through rest and stress
    for k = 1:size(AHA_segments,4)

        % Loop through slices
        for k2 = 1:size(AHA_segments,3)
            
            % Loop through territories
            for k3 = 1:3

                % Loop through segments
                for k4 = 1:length(territory_index(:,k3))

                    % Remove irrelevant segments
                    all = AHA_segments(:,:,k2,k);
                    all(all==territory_index(k4,k3)) = -1;
                    all(all>0) = 0;
                    relevant = abs(all);

                    % Add segments
                    current(:,:,k2,k) = current(:,:,k2,k) + relevant.*k3;
                    clear relevant all
                end
            end
        end
    end
    
    % Populate output
    AHA_territories = current;

end