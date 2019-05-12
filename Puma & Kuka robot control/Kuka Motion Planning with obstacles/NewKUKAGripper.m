% This initializes a KUKA robot with a gripper attached. a6 = -156mm
function myrobot = NewKUKA()
    DH = [0 400 25 pi/2; 0 0 315 0; 0 0 35 pi/2; 0 365 0 -pi/2; 0 0 0 pi/2; 0 161.44 -156 0];
    link1 = Link(DH(1,:));
	link2 = Link(DH(2,:));
	link3 = Link(DH(3,:));
	link4 = Link(DH(4,:));
	link5 = Link(DH(5,:));
	link6 = Link(DH(6,:));
	myrobot = SerialLink([link1 link2 link3 link4 link5 link6]);
end