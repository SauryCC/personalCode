%3.1
%Get initial joints
initialDH = [0 76 0 pi/2; 0 -23.65 43.23 0; 0 0 0 pi/2; 0 43.18 0 -pi/2; 0 0 0 pi/2; 0 20 0 0];
myrobot = puma560(initialDH);

H1 = eul2tr([0 pi pi/2]);
H1(1:3,4) = 100*[-1;3;3]/4;
q1 = inverse(H1,myrobot);

%Get final joints
H2 = eul2tr([0 pi -pi/2]);
H2(1:3,4) = 100*[3;-1;2]/4;
q2 = inverse(H2,myrobot);

%Get torques to apply on individual joints
tau = att(q1,q2,myrobot)
%tau matches example output


%3.2
qref = motionplan(q1,q2,0,10,myrobot,[],0.01);
t=linspace(0,10,300);
q = ppval(qref,t)';
plot(myrobot,q)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot shows it converges

%3.3
setupobstacle
q3 = 0.9*q1+0.1*q2;
tau1 = rep(q3,myrobot,obs{1});
q = [pi/2 pi 1.2*pi 0 0 0];
tau2 = rep(q,myrobot,obs{6})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% output matches example 


setupobstacle
hold on
view(-32,50)
plotobstacle(obs);
qref = motionplan(q1,q2,0,10,myrobot,obs,0.01);
t=linspace(0,10,300);
q = ppval(qref,t)';
plot(myrobot,q);
hold off




function R = roty(theta)
    R = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
end