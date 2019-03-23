%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%please open all five matlab files
%puma560.m, lab1.m, forward.m, part2Graph.m, inverse.m
%lab1.m is the main file to run with


%part4
function q = inverseKuka(H,myrobot)
    %extract needed data from H & myrobot
    d = myrobot.d;
    d1 = d(1,1);
    d2 = d(1,2);
    d3 = d(1,3);
    d4 = d(1,4);
    d5 = d(1,5);
    d6 = d(1,6);
    a = myrobot.a;
    a1 = a(1,1);
    a2 = a(1,2);
    a3 = a(1,3);
    a4 = a(1,4);
    a5 = a(1,5);
    a6 = a(1,6);
    % find x,y,z by the inverse formular
    Rd = H(1:3,1:3);
    Od = H(1:3,4);
    Oc = Od - Rd*transpose([-296.23 0 d6]);  
    x = Oc(1,1);
    y = Oc(2,1);
    z = Oc(3,1);
    %compute theta 1~3 based on the prelab
    theta1 = atan2(y,x);
    temp1 = (-a2^2+(z-d1)^2+ (real(sqrt(x^2+y^2))-a1)^2-(d4^2+a3^2))/(2*a2*(sqrt(d4^2+a3^2)));
    temp= atan2(real(sqrt(1-temp1^2)),temp1);
    theta2 = atan2(z-d1,real(sqrt(x^2+y^2))-a1)+ atan2(real(sqrt(d4^2+a3^2))*sin(temp),a2+real(sqrt(d4^2+a3^2))*cos(temp));
    theta3 = pi/2 - temp - atan2(a3,d4);
    %find R03 
    joint1 = [theta1;theta2;theta3];
    R03 = forwardFirst3(joint1,myrobot);
    R36 = transpose(R03)*Rd;

    %extract needed data for calculation
    r23 = R36(2,3);
    r13 = R36(1,3);
    r33 = R36(3,3);
    r32 = R36(3,2);
    r31 = R36(3,1);
    %find theta 4~6
    theta4 = atan2(r23,r13);
    theta5 = atan2(real(sqrt(1-r33^2)),r33);
    theta6 = atan2(r32,-r31);
    q = [theta1 theta2 theta3 theta4 theta5 theta6];
    
end




%compute the forward kinematics for the first 3 joints
function R = forwardFirst3(joint,myrobot)
     %extract data from joint
	theta1 = joint(1,1);
	theta2 = joint(2,1);
	theta3 = joint(3,1);

    %extract data from myrobot
	alpha1 = myrobot.alpha(1,1);
	alpha2 = myrobot.alpha(1,2);
	alpha3 = myrobot.alpha(1,3);
	r1 = myrobot.a(1,1);
	r2 = myrobot.a(1,2);
	r3 = myrobot.a(1,3);
	d1 = myrobot.d(1,1);
	d2 = myrobot.d(1,2);
	d3 = myrobot.d(1,3);
    %call forwardA function to generate A1~A6
	A1 = forwardAR(theta1,alpha1,r1,d1);
	A2 = forwardAR(theta2,alpha2,r2,d2);
	A3 = forwardAR(theta3,alpha3,r3,d3);

    %return H
	H = A1*A2*A3;
    R = H(1:3,1:3);
    
end

%compute A by the forward kinematics matrix
function An = forwardAR(theta,alpha,r,d)
	An = [cos(theta) -sin(theta)*cos(alpha) sin(theta)*sin(alpha) r*cos(theta); sin(theta) cos(theta)*cos(alpha) -cos(theta)*sin(alpha) r*sin(theta); 0 sin(alpha) cos(alpha) d; 0 0 0 1];
end