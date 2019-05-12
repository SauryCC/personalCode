setupobstacle; % loads obs
kuka = NewKUKAGripper();
kuka_forces = NewKUKAForces();
velocity = 0.04;
%% 4.1 Initial motion planning simulation
Rd = [[0 0 1]' [0 -1 0]' [1 0 0]'];
P0 = [370; -440; 150];
P1 = [370; -440; 45]; % z_grid = 45mm
P2 = [750; -220; 225];
P3 = [620; 350; 225];
P4 = [620; 350; 65];
P5 = [370; -390; 150];
P6 = [370; -390; 45];
P7 = [620; 350; 100];
H0 = Hom(Rd, P0);
H1 = Hom(Rd, P1);
H2 = Hom(Rd, P2);
H3 = Hom(Rd, P3);
H4 = Hom(Rd, P4);
H5 = Hom(Rd, P5);
H6 = Hom(Rd, P6);
H7 = Hom(Rd, P7);
%%
clc
q0 = inverseKUKA(H0, kuka);

q1 = inverseKUKA(H1, kuka);

q2 = inverseKUKA(H2, kuka);

q3 = inverseKUKA(H3, kuka);

q4 = inverseKUKA(H4, kuka);

q5 = inverseKUKA(H5, kuka);
q6 = inverseKUKA(H6, kuka);
q7 = inverseKUKA(H7, kuka);



%%
qhome = [0 1.5708 0 0 1.5708 0]';

[qref0, dc] = motionplan(qhome', q0', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);

[qref1, dc] = motionplan(q0', q1', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);

[qref2, dc] = motionplan(q1', q2', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);

[qref3, dc] = motionplan(q2', q3', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);
[qref4, dc] = motionplan(q3', q4', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);
[qref5, dc] = motionplan(qhome', q5', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);
[qref6, dc] = motionplan(q5', q6', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);
[qref7, dc] = motionplan(q6', q7', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);


%% Plot
hold on
axis([-1000 1000 -1000 1000 -200 1000])
view(-32,50)
%Plot Obstacle
plotobstacle(obs);

%%
t = linspace(0,10,300);
q00 = ppval(qref0, t)';
q00(:,6) = linspace(qhome(6), q0(6), 300);
% plot(kuka,q00);
q01 = ppval(qref1, t)';
q01(:,6) = linspace(q0(6), q1(6), 300);
% plot(kuka,q01);
q12 = ppval(qref2, t)';
q12(:,6) = linspace(q1(6), q2(6), 300);
% plot(kuka,q12);
q23 = ppval(qref3, t)';
q23(:,6) = linspace(q2(6), q3(6), 300);
% plot(kuka,q23);
q34 = ppval(qref4, t)';
q34(:,6) = linspace(q3(6), q4(6), 300);
% plot(kuka,q23);
q05 = ppval(qref5, t)';
q05(:,6) = linspace(qhome(6), q5(6), 300);

% plot(kuka,q23);
q56 = ppval(qref6, t)';
q56(:,6) = linspace(q5(6), q6(6), 300);

% plot(kuka,q23);
q67 = ppval(qref7, t)';
q67(:,6) = linspace(q6(6), q7(6), 300);


%% on machine
velocity = .04;
% setHome(velocity);
% open
setGripper(0); 
% set to pos 1
for i=1:length(q00)
    setAngles(q00(i,:), velocity);
end


for i=1:length(q01)
    setAngles(q01(i,:), velocity);
end
setGripper(1); 
for i=1:length(q12)
    setAngles(q12(i,:), velocity);
end

for i=1:length(q23)
    setAngles(q23(i,:), velocity);
end

for i=1:length(q34)
    setAngles(q34(i,:), velocity);
end

setGripper(0); 
setHome(.04)
% set to pos 1
%%
for i=1:length(q05)
    setAngles(q05(i,:), velocity);
end


for i=1:length(q56)
    setAngles(q56(i,:), velocity);
end

for i=1:length(q67)
    setAngles(q67(i,:), velocity);
end 
setGripper(0);
setHome(.04);





