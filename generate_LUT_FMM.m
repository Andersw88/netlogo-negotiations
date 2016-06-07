%% generate_LUT: function description
% function generate_LUT_FMM(num_locations)

num_locations = 14;
cost_map = im2double(imread('costmap2.png'));
%     cost_map = imresize(cost_map, 0.5);
%     
map_size_y = size(cost_map,1);
map_size_x = size(cost_map,2);
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

% 
% survey_locations_x = [89   136   173    27    16    52    96    66     3    58     9   180    37   124];
% survey_locations_y = [83    34     2   117   111    62    89    13    73    24    43    55    98   104];
    survey_locations_x=[ 89   136   173    27    16    52    96    66     3    58     9   180    37   124 92 18 63 113 137 75 65 49 78 33 100 82 25 148 40 23 11 135 169 28 167 2 53 43 195 67 13 173 110 95 198 36 71 55 90 88 102 128 47 6 16 45 73 191 171 21 115 4 9 84];
    survey_locations_y = [ 83    34     2   117   111    62    89    13    73    24    43    55    98   104 85 36 13 60 117 28 92 55 2 104 89 34 77 32 99 97 81 42 5 40 119 45 20 15 87 11 115 53 83 30 63 50 94 109 25 22 18 106 102 73 112 38 7 58 9 70 68 79 47 75];


num_locations = length(survey_locations_x);

base_cost = 0.1;
close all
data = zeros(map_size_y*map_size_x + 1,3);
for loc=1:num_locations 

    data(1,:) = [survey_locations_x(loc)-1, map_size_y - (survey_locations_y(loc)-1), 0];

    end_pos = [survey_locations_x(loc) survey_locations_y(loc)];

    cost_from_goal_map = FMM(end_pos, base_cost, cost_map*0.9);

    imagesc(cost_from_goal_map); hold on;
    plot(survey_locations_x, survey_locations_y, '*r');
    pause(0.001)
    for index = 1:map_size_y*map_size_x


        [start_pos_y, start_pos_x]=ind2sub(size(cost_map),index);

        if( cost_map(start_pos_y, start_pos_x) > 1)
            data(index + 1,:) = [-1 0 0];				
            continue
        end

        start_pos = [start_pos_x start_pos_y];
        [tc, p] = GD_PATH(start_pos, end_pos,  cost_from_goal_map, cost_map, base_cost);

        if numel(p) > 0
            data(index + 1,:) = [tc*10 p(1,:)-1, map_size_y-(p(2,:)-1)];
        else
            data(index + 1,:) = [-1, 0, 0];			
        end
    end
    dlmwrite (['lut_' num2str(loc) '.csv'], data);
end

