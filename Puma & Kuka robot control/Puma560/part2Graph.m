%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%please open all five matlab files
%puma560.m, lab1.m, forward.m, part2Graph.m, inverse.m
%lab1.m is the main file to run with


% PART 2
function part2Graph()
    % Define the matrix from the prelab here:
    initialDH = [0 76 0 pi/2; 0 -23.65 43.23 0; 0 0 0 pi/2; 0 43.18 0 -pi/2; 0 0 0 pi/2; 0 20 0 0];
    % Initialize new robot using initial DH
    myrobot = puma560(initialDH);
    % Initialize array of values for all 6 angles
    theta1 = linspace(0,pi,200);
    theta2 = linspace(0,pi/2,200);
    theta3 = linspace(0,pi,200);
    theta4 = linspace(pi/4,pi*3/4,200);
    theta5 = linspace(-pi/3,pi/3,200);
    theta6 = linspace(0,2*pi,200);
    % Define the sequence
    q = zeros(200,6);
    q(:,1) = transpose(theta1);
    q(:,2) = transpose(theta2);
    q(:,3) = transpose(theta3);
    q(:,4) = transpose(theta4);
    q(:,5) = transpose(theta5);
    q(:,6) = transpose(theta6);
    % Issue the plot command that was suggested on the lab
    plot(myrobot,q);
end