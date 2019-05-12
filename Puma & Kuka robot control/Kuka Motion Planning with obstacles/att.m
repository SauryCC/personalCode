% q is current angles
% q2 is desired/final angles
function tau=att(q,q2,myrobot)
    n = length(myrobot.a);
    F = zeros(3,n);
    tau = zeros(n,1);
    eta = [1 1 1 1 1 1]; % assumes 6 links
    d = 1;
    for i=1:n
        Hi = forward(q, myrobot,i);
        Hi_desired = forward(q2, myrobot, i);
        oi = Hi(1:3, 4);
        oi_desired = Hi_desired(1:3,4);
        displacement = oi-oi_desired;
        distance = norm(displacement);
        F(1:3, i) = -1*eta(i)*displacement;
        %if distance <= d
        %    F(1:3, i) = -1*eta(i)*displacement;
        %else
        %    F(1:3, i) = -1*d*displacement/distance;
        %end
        tau = tau + Jvoi(myrobot,q,i)'*F(1:3, i);
    end 
    tau = tau;
    tau = tau/norm(tau);
end

function Ja = Jvoi(robot, q, link)
    %placeholder 
    Ja = zeros(3,6);
    % find final H and O 
    Hf = forward(q, robot, link);
    Of = Hf(1:3, 4);
    %compute jacobian
    for i = 1:link
        %if i-1 = 0
        
        Hi = forward(q, robot, i-1);

        %find initial
        Oi = Hi(1:3,4);
        Zi = Hi(1:3,3);
        % puma560 is revolute
        % find Jacobian
        Ja(1:3,i) = cross(Zi,Of-Oi);
    end
end