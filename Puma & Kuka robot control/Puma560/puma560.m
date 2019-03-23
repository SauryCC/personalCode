%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%please open all five matlab files
%puma560.m, lab1.m, forward.m, part2Graph.m, inverse.m
%lab1.m is the main file to run with



% PART 1
function myrobot = puma560(DH)
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