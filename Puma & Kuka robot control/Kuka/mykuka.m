function [myrobot] = mykuka(DH)
%MYKUKA takes in a DH (table) and outputs a robot
%
%% Inputs:    
%   DH          a 6x4 matrix representing the DH table where every row is
%               in the form [theta, d, a, alfa; ...]
%% Outputs:
%   myrobot     a model of the robot using the 
%

%% 

    link1 = Link(DH(1,:));
	link2 = Link(DH(2,:));
	link3 = Link(DH(3,:));
	link4 = Link(DH(4,:));
	link5 = Link(DH(5,:));
	link6 = Link(DH(6,:));
	myrobot = SerialLink([link1 link2 link3 link4 link5 link6]);

end

