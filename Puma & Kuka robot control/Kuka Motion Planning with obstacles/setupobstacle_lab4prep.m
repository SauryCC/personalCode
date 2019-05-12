%% Prep: Repulsion force
myrobot = NewKUKAForces()
prepobs{1}.R = 100;
prepobs{1}.c = [250; 0];
prepobs{1}.rho0 = 500;
prepobs{1}.h = 300;
prepobs{1}.type = 'cyl';
tau = rep([pi/10,pi/12,pi/6,pi/2,pi/2,-pi/6],myrobot,prepobs{1})

%% Prep: Motion planning

%planeobs.type = 'plane';
%planeobs.h = 32;
%planeobs.rho0 = 0;
%setupobstacle;
%obs = [obs planeobs]; % add a plane obstacle
obs = prepobs;

kuka = NewKUKAGripper();
kuka_forces = NewKUKAForces();
P1 = [620 375 50];
P2 = [620 -375 50];
R=[0 0 1;0 -1 0;1 0 0];
H1=[R P1';zeros(1,3) 1];
H2=[R P2';zeros(1,3) 1];
q1 = inverseKUKA(H1, kuka);
q2 = inverseKUKA(H2, kuka);
% Experiment with rho
obs{1}.rho0 = 400;
% tolerance  = 0.04, alpha_att = 0.013, alpha_rep = 0.01
[qref,q] = motionplan(q1', q2', 0, 10, kuka_forces, obs, 0.04, 0.013, 0.01);

%% Prep: plot motion planning above
hold on
obs = prepobs;
%Set axes
axis([-1000 1000 -1000 1000 -100 1000])
view(-32,50)
%Plot Obstacle
plotobstacle(obs);
%Get the motion planning with the obstacles
t = linspace(0,10,300);
q = ppval(qref,t)';
plot(kuka,q);

hold off