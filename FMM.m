function [cost_from_goal_map] = FMM(end_pos, base_cost, cost_map)
	
	method = 'fm';
	% method = 'dijkstra';
	niter = Inf;

% 	obstacle = max(max(cost_map))*0.7;
% 	cost_map(cost_map>=obstacle) = 10e8; 
    

	[y_size, x_size] = size(cost_map);
	n=max(x_size, y_size);
	W = ones(n)*10e8;

	W( (n-y_size)/2+1 : (n-y_size)/2 + y_size , (n-x_size)/2 +1 : (n-x_size)/2 + x_size ) = base_cost + cost_map;

	end_pos=end_pos + [(n-x_size)/2, (n-y_size)/2];
	
	neigh = [[1;0] [-1;0] [0;1] [0;-1]];
	% boundary = @(x)mod(x-1,n)+1;
	boundary = @(x)x.*(x<=n & x>0) + (2-x).*(x<=0) + (2*n-x).*(x>n);
	ind2sub1 = @(k)[rem(k-1, n)+1; (k - rem(k-1, n) - 1)/n + 1]; 
	sub2ind1 = @(u)(u(2)-1)*n+u(1);
	Neigh = @(k,i)sub2ind1( boundary(ind2sub1(k)+neigh(:,i)) );

	I = sub2ind1(end_pos(2:-1:1));
	
	%%
	% Initialize the distance to \(+\infty\), excepted for the boundary conditions.

	D = zeros(n)+Inf; % current distance
	D(I) = 0; 


	%%
	% Initialize the state to 0 (unexplored), excepted for the boundary point to \(1\)
	% (front).

	S = zeros(n);
	S(I) = 1; % open

	%%
	% Run!

	iter = 0;
	while not(isempty(I)) && iter<=niter
		iter = iter+1;
		% pop from stack
		[tmp,j] = sort(D(I)); j = j(1);
		i = I(j); I(j) = [];
		% declare dead
		S(i) = -1; 
		% The list of the four neighbors
		J = [Neigh(i,1); Neigh(i,2); Neigh(i,3); Neigh(i,4)];
		% Remove those that are dead
		J(S(J)==-1) = [];
		% Add them to the front
		J1 = J(S(J)==0);
		I = [I; J1];
		S(J1) = 1;
		% update neighbor values
		for j=J'
			dx = min( D([Neigh(j,1) Neigh(j,2)]) );
			dy = min( D([Neigh(j,3) Neigh(j,4)]) ); 
			switch method
				case 'dijkstra'
					% Dijkstra update
					D(j) = min(dx+W(j), dy+W(j));
				case 'fm'
					% FM update	
					Delta = 2*W(j) - (dx-dy)^2;
					if Delta>=0
						D(j) = (dx+dy+sqrt(Delta))/2;
					else
						D(j) = min(dx+W(j), dy+W(j));
					end
				otherwise
					error('Only dijstra and fm are allowed.');
			end
		end
	% displ = @(D)cos(2*pi*5*D/max(D(:)));
	%clf;
    end
	cost_from_goal_map = ones(size(cost_map));
	cost_from_goal_map(:) = D( (n-y_size)/2+1 : (n-y_size)/2 + y_size , (n-x_size)/2 +1 : (n-x_size)/2 + x_size);
end