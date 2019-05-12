% Returns homogenous matrix representing position and orientation of
% the ith frame.
function H = forward(joint, robot, link)
    %for att and rep conor case
    if link == 0
        H = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    else
        alpha = robot.alpha(1:link);
        a = robot.a(1:link);
        d = robot.d(1:link);
        theta = joint;
        H = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
        for i = 1:link
            newH = [rotz(theta(i)) [0 0 0]'; [0 0 0 1]]*[eye(3) [0 0 d(i)]'; [0 0 0 1]]*[eye(3) [a(i) 0 0]'; [0 0 0 1]]*[rotx(alpha(i)) [0 0 0]'; [0 0 0 1]];
            H = H * newH;
        end
    end

end

function R = rotx(theta)
    R = [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];
end

function R = rotz(theta)
    R = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
end

function R = roty(theta)
    R = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
end