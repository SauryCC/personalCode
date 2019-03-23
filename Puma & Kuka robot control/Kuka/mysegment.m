function [] = mysegment(xS, xE, yS, yE,zS, zE,myrobot)
%x coord form xS to xE
x = linspace(xS, xE, 100);
%y coord form yS to yE
y = linspace(yS, yE, 100);
%z coord form zS to zE
z = linspace(zS, zE, 100)-2;
%X_o is the xyz coord
X_o = [x;y;z];
%store all sets
X_set = zeros(3,100);   
%rotation matrix
R = [0, 0, 1; 0, -1, 0; 1, 0, 0];
%set up set
for i = 1:100
    X_set(:,i) = FrameTransformation(X_o(:,i));
end
% q stores all angles
q = zeros(100, 6);    
%set up q
for i = 1:100
    H = [R, X_set(:,i); zeros(1,3), 1];
    q(i,:) = inverseKuka(H, myrobot)';
end
%grapgh
for i = 1:100
    setAngles(q(i,:), 0.04);
end
end
