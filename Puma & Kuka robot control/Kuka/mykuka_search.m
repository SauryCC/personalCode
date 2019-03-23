%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%please open all five matlab files
%puma560.m, lab1.m, forward.m, part2Graph.m, inverse.m
%lab1.m is the main file to run with



% PART 1
function myrobot = mykuka_search(delta)
    DH = [0 400 25 pi/2; 0 0 315 0; 0 0 35 pi/2; 0 365 0 -pi/2; 0 0 0 pi/2; 0 161.44+delta(2,1) -296.23+delta(1,1) 0]
	% ith row of DH represents the set of parameters for the ith link
	link1 = Link(DH(1,:));
	link2 = Link(DH(2,:));
	link3 = Link(DH(3,:));
	link4 = Link(DH(4,:));
	link5 = Link(DH(5,:));
	link6 = Link(DH(6,:));
	myrobot = SerialLink([link1 link2 link3 link4 link5 link6]);
end

% Starting here would not be part of function, use separate script(s)?


















%part 4.4