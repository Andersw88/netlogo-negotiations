%% GD_PATH: function description
function [traversal_cost, min_cost_path] = GD_PATH(start_pos, end_pos, cost_to_goal_map, cost_map, base_cost)

	position = start_pos';
	min_cost_path = [];
	neighbors = [0 -1 -1 -1  0  0  1  1  1; 0 -1  0  1 -1  1 -1  0  1 ];
    
    [ymax, xmax] = size(cost_map);

%     traversal_cost = 0;
%     iter = 0;
%     while(position(1)~=end_pos(1) || position(2)~=end_pos(2) )
%         iter = iter +1;
%     	n_x = neighbors(1,:) + position(1);
%     	n_y = neighbors(2,:) + position(2);
% 
%     	to_delete_x = find(n_x==0 | n_x >xmax);
%     	to_delete_y = find(n_y==0 | n_y >ymax);
% 
%     	to_delete = union(to_delete_x, to_delete_y);
%     	n_x(to_delete) =[];
%     	n_y(to_delete) =[];
%         [val, n_id] = min(cost_to_goal_map(sub2ind(size(cost_to_goal_map),n_y, n_x )));
% 		position = [n_x(n_id); n_y(n_id)];

	    
        minN = [];
        minCost = inf;
        for j = 1:length(neighbors)
            X = neighbors(1,j) + position(1);
            Y = neighbors(2,j) + position(2);
            if X > 0 && X <= xmax && Y > 0 && Y <= ymax
                cost = cost_to_goal_map(sub2ind(size(cost_to_goal_map),Y, X ));
                if cost < minCost
                    minCost = cost;
                    minN = neighbors(:,j);
                end
            end
        end
        min_cost_path = position + minN;

        
        traversal_cost = cost_to_goal_map(sub2ind(size(cost_to_goal_map),position(2), position(1) ));
        
        if traversal_cost > 1000
            min_cost_path = [];
            traversal_cost = -2;
        end
        
%         if iter == 1
%             min_cost_path = position;
%         end
% % 		min_cost_path = [ min_cost_path position];
% 		traversal_cost = traversal_cost + cost_map(position(2),position(1)) + base_cost;
%         if(traversal_cost < 0 || iter > 10000 )
%             min_cost_path = [];
%             traversal_cost = -2;
%             return
%         end
%     end
end
