setupobstacle; % loads obs
kuka = NewKUKAGripper();
kuka_forces = NewKUKAForces();
%% 4.1 Initial motion planning simulation
Rd = [[0 0 1]' [0 -1 0]' [1 0 0]'];
P0 = [370; -440; 150];
P1 = [370; -440; 45]; % z_grid = 45mm
P2 = [750; -220; 225];
P3 = [620; 350; 225];
H0 = Homo(Rd, P0);
H1 = Homo(Rd, P1);
H2 = Homo(Rd, P2);
H3 = Homo(Rd, P3);
q0 = inverseKUKA(H0, kuka);
q1 = inverseKUKA(H1, kuka);
q2 = inverseKUKA(H2, kuka);
q3 = inverseKUKA(H3, kuka);
%%
[qref1, dc] = motionplan(q0', q1', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);
[qref2, dc] = motionplan(q1', q2', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);
[qref3, dc] = motionplan(q2', q3', 0, 10, kuka_forces, obs, 0.05, 0.01, 0.01);

%% Plot
hold on
axis([-1000 1000 -1000 1000 -200 1000])
view(-32,50)
%Plot Obstacle
plotobstacle(obs);
t = linspace(0,10,300);
%q = ppval(qref1, t)';
%plot(kuka,q);
q = ppval(qref2, t)';
plot(kuka,q);
q = ppval(qref3, t)';
plot(kuka,q);





function H=Homo(R, o)
    H = [R o; 0 0 0 1];
end