% contour42_segments.m

% Core function of contour42_curves.m that takes the original contour masks
% and generates AHA segmented contour masks utilizing the RV insertion point.

function [AHA_segments, information] = contour42_segments(masks)

    % Test if there are masks for the four expected series
    if length(masks)~=4; warning('Number of series in study not as expected'); end

    for k = 1:length(masks) % loop over each series
        
        if k == 3 || k == 4 % Only masks{k=3 and 4} contains MYO stack slices
            
            % Generate myocardial contour mask
            myocardium = masks{k}.mask.saepicardialContour -...
                                masks{k}.mask.saendocardialContour;

            % Generate MYO LV and RV masks
            MYO_LV = masks{k}.mask.saendocardialContour;
            MYO_RV = masks{k}.mask.sarvendocardialContour;

            % Generate refrence points
            RV_insertion_point = squeeze(masks{k}.mask.sacardialRefPoint)';
            MYO_centre_point = squeeze(masks{k}.mask.corPerfusionMyoCentrePoint)';

            % Calculate number of phases
            if k == 3 % rest
                phases = size(masks{1}.mask.saendocardialContour,3);
            elseif k == 4 % stress
                phases = size(masks{2}.mask.saendocardialContour,3);
            end

            % Calculate number of slices
            slices = size(masks{k}.mask.saendocardialContour,3)./phases;
            
            % Generate AHA segments
            % Here I had to make a choice wheather to calculate all 16 AHA
            % segments for each InstanceNumber, or just 16 AHA segments for
            % each series. The latter assumes that all the contours are the
            % same for each slice in the QP series. I went with the latter
            % (easier) option - see the 'index' variable in the below loop.
            
            % Stack myocardial contour masks
            for k2 = 1:slices
                index(k2) = phases.*(k2-1)+1; % control which InstanceNumber the masks are extracted from
                MYO_mask_stack(:,:,k2) = myocardium(:,:,index(k2));
                RV_insertion_point_stack(k2,:) = RV_insertion_point(index(k2),:);
                MYO_centre_point_stack(k2,:) = MYO_centre_point(index(k2),:);
                MYO_LV_mask_stack(:,:,k2) = MYO_LV(:,:,index(k2));
                MYO_RV_mask_stack(:,:,k2) = MYO_RV(:,:,index(k2));
            end
            
            % Segments calculated by sub-function
            % This step assumes the same number of rest and stress slices
            % in a study/ID. Modify if necessary.
            AHA_segments(:,:,:,k-2) = contour42_AHA(MYO_mask_stack,...
                                       RV_insertion_point_stack,...
                                         MYO_centre_point_stack,...
                                           slices);

            % Generate AIF LV and RV masks
            if k == 3 % rest
                AIF_LV = masks{1}.mask.saendocardialContour(:,:,index(1));
                AIF_RV = masks{1}.mask.sarvendocardialContour(:,:,index(1));
            elseif k == 4 % stress
                AIF_LV = masks{2}.mask.saendocardialContour(:,:,index(1));
                AIF_RV = masks{2}.mask.sarvendocardialContour(:,:,index(1));
            end

            % Output additional vars
            if k == 3
                information.rest.index = index;
                information.rest.phases = phases;
                information.rest.slices = slices;
                information.rest.RV_insertion_point = RV_insertion_point_stack;
                information.rest.MYO_centre = MYO_centre_point_stack;
                information.rest.global_mask = MYO_mask_stack;
                information.rest.AIF_LV = AIF_LV;
                information.rest.AIF_RV = AIF_RV;
                information.rest.MYO_LV = MYO_LV_mask_stack;
                information.rest.MYO_RV = MYO_RV_mask_stack;
            elseif k == 4
                information.stress.index = index;
                information.stress.phases = phases;
                information.stress.slices = slices;
                information.stress.RV_insertion_point = RV_insertion_point_stack;
                information.stress.MYO_centre = MYO_centre_point_stack;
                information.stress.global_mask = MYO_mask_stack;
                information.stress.AIF_LV = AIF_LV;
                information.stress.AIF_RV = AIF_RV;
                information.stress.MYO_LV = MYO_LV_mask_stack;
                information.stress.MYO_RV = MYO_RV_mask_stack;
            end
        end
    end
end