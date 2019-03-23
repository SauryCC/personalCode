%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%please open all five matlab files
%puma560.m, lab1.m, forward.m, part2Graph.m, inverse.m
%lab1.m is the main file to run with


% PART 3
function H = forward(joint,myrobot)
    %extract data from joint
	theta1 = joint(1,1);
	theta2 = joint(2,1);
	theta3 = joint(3,1);
	theta4 = joint(4,1);
	theta5 = joint(5,1);
	theta6 = joint(6,1);
    %extract data from myrobot
	alpha1 = myrobot.alpha(1,1);
	alpha2 = myrobot.alpha(1,2);
	alpha3 = myrobot.alpha(1,3);
	alpha4 = myrobot.alpha(1,4);
	alpha5 = myrobot.alpha(1,5);
	alpha6 = myrobot.alpha(1,6);
	r1 = myrobot.a(1,1);
	r2 = myrobot.a(1,2);
	r3 = myrobot.a(1,3);
	r4 = myrobot.a(1,4);
	r5 = myrobot.a(1,5);
	r6 = myrobot.a(1,6);
	d1 = myrobot.d(1,1);
	d2 = myrobot.d(1,2);
	d3 = myrobot.d(1,3);
	d4 = myrobot.d(1,4);
	d5 = myrobot.d(1,5);
	d6 = myrobot.d(1,6);
    %call forwardA function to generate A1~A6
	A1 = forwardA(theta1,alpha1,r1,d1);
	A2 = forwardA(theta2,alpha2,r2,d2);
	A3 = forwardA(theta3,alpha3,r3,d3);
	A4 = forwardA(theta4,alpha4,r4,d4);
	A5 = forwardA(theta5,alpha5,r5,d5);
	A6 = forwardA(theta6,alpha6,r6,d6);
    %return H
	H = A1*A2*A3*A4*A5*A6;	

end

%compute An by the forward kinematics matrix
function An = forwardA(theta,alpha,r,d)
	An = [cos(theta) -sin(theta)*cos(alpha) sin(theta)*sin(alpha) r*cos(theta); sin(theta) cos(theta)*cos(alpha) -cos(theta)*sin(alpha) r*sin(theta); 0 sin(alpha) cos(alpha) d; 0 0 0 1];
end