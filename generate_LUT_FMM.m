%% generate_LUT: function description
% function generate_LUT_FMM(num_locations)

    num_locations = 14
	cost_map = im2double(imread('costmap2.png'));
%     cost_map = imresize(cost_map, 0.5);
%     
% 	map_size_y = size(cost_map,1);
% 	map_size_x = size(cost_map,2);
% 
% 	survey_locations_x = ones(1,num_locations);
% 	survey_locations_y = ones(1,num_locations);
% 
% 
% 	good_locations = 0;
% 
% 	while( good_locations < num_locations )
% 		candidate_x = floor( rand * map_size_x) + 1; %because octave indexing starts at 1
% 		candidate_y = floor( rand * map_size_y) + 1; %because octave indexing starts at 1
% 
% 		if( cost_map(candidate_y, candidate_x) < 0.5 )	
% 			if(good_locations == 0 | ( min(abs( [survey_locations_x(1:good_locations)-candidate_x; survey_locations_y(1:good_locations)-candidate_y]))) > (min(map_size_y, map_size_x)*0.045)  )
% 				good_locations = good_locations + 1;
% 				survey_locations_x(good_locations) = candidate_x;
% 				survey_locations_y(good_locations) = candidate_y;
%             end
%             
%         end
%     end
    
    survey_locations_x = [89   136   173    27    16    52    96    66     3    58     9   180    37   124];
    survey_locations_y = [83    34     2   117   111    62    89    13    73    24    43    55    98   104];
    
    



	base_cost = 1;
	close all
    data = zeros(map_size_y*map_size_x + 1,5);
	for loc=1:num_locations 
	
        data(1,:) = [survey_locations_x(loc)-1, map_size_y - (survey_locations_y(loc)-1), 0, 0, 0];
% 		dlmwrite (['lut_' num2str(loc) '.csv'], [survey_locations_x(loc)-1 survey_locations_y(loc)-1 0 0 0]);

% 		figure(loc)
% 		imshow(cost_map);
% 		hold on
% 		plot(survey_locations_x, survey_locations_y, '*r');
% 		pause(0.001)
        
        end_pos = [survey_locations_x(loc) survey_locations_y(loc)];

        cost_from_goal_map = FMM(end_pos, base_cost, 10*cost_map);
        
%         figure(1)
		imagesc(cost_from_goal_map.^-0.1); hold on;
        plot(survey_locations_x, survey_locations_y, '*r');
        pause(0.001)
        for index = 1:map_size_y*map_size_x

			%start_pos_x = floor(index/(map_size_y))
		 	%start_pos_y = index - map_size_y*(start_pos_x)
            
            [start_pos_y, start_pos_x]=ind2sub(size(cost_map),index);
            
		 	if( cost_map(start_pos_y, start_pos_x) > 0.9)
                data(index + 1,:) = [start_pos_x-1 map_size_y-(start_pos_y) -1 0 0];
% 		 		dlmwrite (['lut_' num2str(loc) '.csv'], [start_pos_x-1 start_pos_y-1 -1 0 0], '-append');				
		 		continue
		 	end

		 	start_pos = [start_pos_x start_pos_y];
		%	tc = 0; p=start_pos';
            [tc, p] = GD_PATH(start_pos, end_pos,  cost_from_goal_map, 10*cost_map, base_cost);
            
		    if numel(p) > 0
                data(index + 1,:) = [start_pos_x-1, map_size_y-(start_pos_y), tc p(1,:)-1, map_size_y-(p(2,:)-1)];
% 		 		dlmwrite (['lut_' num2str(loc) '.csv'], [start_pos_x-1 start_pos_y-1 tc p(1,:), p(2,:)], '-append');
            else
                data(index + 1,:) = [start_pos_x-1, map_size_y-(start_pos_y), -1, 0, 0];
% 		 		dlmwrite (['lut_' num2str(loc) '.csv'], [start_pos_x-1 start_pos_y-1 -1 0 0], '-append');				
	        end
        end
        dlmwrite (['lut_' num2str(loc) '.csv'], data);
    end
    
% end
