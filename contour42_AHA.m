% contour42_AHA.m

% Core function of contour42_segments.m that takes one myocardial contour,
% one RV insertion point and one MYO center point to generate 16 AHA
% segments.

function segments = contour42_AHA(MYO_mask_stack,...
                                    RV_insertion_point_stack,...
                                       MYO_centre_point_stack,...
                                           num_slices)
    % Radius for segment sector area
    radius = size(MYO_mask_stack,1)/3;

    % Preallocate
    segments = zeros(size(MYO_mask_stack));

    % Segment slice index
    slice_index(:,1) = [1 6 5 4 3 2];
    slice_index(:,2) = [7 12 11 10 9 8];
    slice_index(:,3) = [13 16 15 14 nan nan];
    
    % Loop over the myocardial slices
    for k = 1:num_slices

        % Coordinates
        x1 = MYO_centre_point_stack(k,1);           % slice center point x
        y1 = MYO_centre_point_stack(k,2);           % slice center point y
        x2 = MYO_centre_point_stack(k,1);           % slice vertical point x
        y2 = MYO_centre_point_stack(k,2) - radius;  % slice vertical point y
        x3 = RV_insertion_point_stack(k,1);         % slice RV insertion point x
        y3 = RV_insertion_point_stack(k,2);         % slice RV insertion point x

        % Lines
        L1 = [x2,y2,0] - [x1,y1,0]; % vertical line
        L2 = [x3,y3,0] - [x1,y1,0]; % centre to RV insertion line

        % Rotation angle
        rot_ang = atan2d(norm(cross(L1, L2)),...
            dot(L1, L2)); % angle between vertical and RV insertion point lines
        
        % Segment sector angles
        if k <= 2 % basal and mid-cavity slices
            ang = [0 60 120 180 240 300 360]; % 60 deg, six segments x 2
        elseif k == 3 % apical slice
            ang = [0 90 180 270 360]; % 90 deg, four segments
        end
            
        % Loop over segment angles
        for k2 = 1:(length(ang)-1)

            % Calculate segment sector
            theta = ang(k2) : 0.01 : ang(k2+1);
            x = [x1 (radius * sind(theta) + x1) x1];
            y = [y1 (-radius * cosd(theta) + y1) y1];

            % Correct for RV insertion point angle
            xrot = (x-x1)*cosd(rot_ang) + (y-y1)*sind(rot_ang) + x1;
            yrot = -(x-x1)*sind(rot_ang) + (y-y1)*cosd(rot_ang) + y1;

            % Extract k2'th segment from myocardial contour
            sector = poly2mask(xrot,yrot,size(MYO_mask_stack(:,:,k), 1),...
                                         size(MYO_mask_stack(:,:,k), 2));
            segment = MYO_mask_stack(:,:,k) .* sector .* slice_index(k2,k);
            segments(:,:,k) = segments(:,:,k) + segment;

            % Debug - show generated sector's or segments
            %imshow(segment) % or imshow(sector)
            %pause(2)
            %close all

        end
    end
end