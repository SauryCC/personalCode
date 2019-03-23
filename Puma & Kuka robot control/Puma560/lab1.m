%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%please open all five matlab files
%puma560.m, lab1.m, forward.m, part2Graph.m, inverse.m
%lab1.m is the main file to run with

%part1: operated in puma560.m

%part2:written in part2Graph.m
%part2Graph()


%part3: forward kinematics
%initial myrobot
forwardKinematics()

%part4 
%inverseKinematics()



function forwardKinematics()
    initialDH = [0 76 0 pi/2; 0 -23.65 43.23 0; 0 0 0 pi/2; 0 43.18 0 -pi/2; 0 0 0 pi/2; 0 20 0 0];
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

        %create end effector
        o = zeros(200,3);
        for i = 1:200
            joint = transpose(q(i,:));
            temp = forward(joint,myrobot);
            o(i,:) = temp(1:3,4);
        end
        %PLOTTING
        plot3(o(:,1),o(:,2),o(:,3),'r');
        hold on;
        plot(myrobot,q);
end
    

function inverseKinematics()
    initialDH = [0 76 0 pi/2; 0 -23.65 43.23 0; 0 0 0 pi/2; 0 43.18 0 -pi/2; 0 0 0 pi/2; 0 20 0 0];
    myrobot = puma560(initialDH);

   %test case passed
    %H = [cos(pi/4) -sin(pi/4) 0 20; sin(pi/4) cos(pi/4) 0 23; 0 0 1 15; 0 0 0 1];
    %the output q should be q = [ -0.0331 -1.0667 1.0283 3.1416 3.1032 0.8185];
    %define d
    dx = linspace(10,30,100);
    dy = linspace(23,30,100);
    dz = linspace(15,100,100);
    d = zeros(100,3);
    d(:,1) = transpose(dx);
    d(:,2) = transpose(dy);
    d(:,3) = transpose(dz);
    %define R
    R = [cos(pi/4) -sin(pi/4) 0; sin(pi/4) cos(pi/4) 0; 0 0 1];
    %define q
    q = zeros(100,6);
    %define H
    H = zeros(4,4);
    H(1:3,1:3) = R;
    H(4,:) = [0 0 0 1];
    for i = 1:100
        H(1:3,4) = transpose(d(i,:));
        q(i,:) = inverse(H,myrobot);
    end
    %plotting
    myrobot.plot(q)
   
    
end









     
     
