%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%please open all five matlab files
%mykuka.m, lab2.m, forward.m, inversekuka.m, deltajoint.m, FrameTransformation.m
%lab2.m is the main file to run with

%part1: operated in puma560.m

DH = [25 pi/2 400 0; 315 0 0 0; 35 pi/2 0 0; 0 -pi/2 365 0; 0 pi/2 0 0; -296.23 0 161.44 0];
myrobot=mykuka(DH);
temp = forward_kuka([pi/5 pi/3 -pi/4 pi/4 pi/3 pi/4]¡¯,kuka);
%should reture [0.1173   -0.3109    0.9432  368.9562; -0.8419   -0.5349   -0.0717  420.4832; 0.5268   -0.7856   -0.3245  120.8570; 0    0      0    1.0000]

inverse_kuka(temp,kuka);
%should reture [0.6283; 1.0472; -0.7854; 0.7854; 1.0472; 0.7854]


%part 4.2
part4_2();
%part 4.3
part4_3();
%part 4.4
drawLine();
drawCircle();
drawSimleFace();






%part 4.2
function part4_2()
delta = fminunc(@deltajoint,[0 0]);
myrobot = mykukasearch(delta);
H = [0 0 1 651.97; 0 -1 0 8.06; 0 0 1 26.73; 0 0 0 1];
q = inversekuka(H,myrobot);
setAngles(q,0.04)
end


%part 4.3
function part4_3()
p_workspace = [600; 100; 10];
p_baseframe = FrameTransformation(p_workspace);
R =[0 0 1;0 -1 0; 1 0 0 ];
H= [R p_baseframe; zeros(1,3) 1];
q = inversekuka(H,myrobot);
setangles(q,0.04);
end

function drawLine()
mysegment(620, 620, -100, 100,-1, -1,myrobot);
end

function drawCircle()
mycircle([620 0 -1],50,myrobot);
end

function drawSimleFace()
mycircle([400 0 -1],50,myrobot);
mysegment(380, 380, 25, 0,-1, -1,myrobot);
mysegment(420, 420, 25, 0,-1, -1,myrobot);
mysegment(385, 400, -20, -40,-1, -1,myrobot);
mysegment(400, 415, -40, -20,-1, -1,myrobot);
end









     
     
