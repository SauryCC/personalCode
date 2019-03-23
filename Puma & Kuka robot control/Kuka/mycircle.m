function [] = mycircle(pos,radius,myrobot)
%store angle
theta = linspace(0, 2*pi, 100);
%new x
x = radius * cos(theta) + pos(1);
%new y
y = radius * sin(theta) + pos(2);
%new z
%-3 to set z axis lower
z = linspace(pos(3), pos(3), 100)-3;
%X is the position matrix
X_o = [x;y;z];
%X_set stores position matrix
X_set = zeros(3,100);  
%rotation matrix
R = [0, 0, 1; 0, -1, 0; 1, 0, 0];
%set up X_set
for i = 1:100
    X_set(:,i) = FrameTransformation(X_o(:,i));
end
%q stores theta 1to6 angles
q = zeros(100, 6);    
%set up H
for i = 1:100
    H = [R, X_set(:,i); zeros(1,3), 1];
    q(i,:) = inverseKuka(H, myrobot)';
end

%graph
for i = 1:100
    setAngles(q(i,:), 0.04);
end
end

