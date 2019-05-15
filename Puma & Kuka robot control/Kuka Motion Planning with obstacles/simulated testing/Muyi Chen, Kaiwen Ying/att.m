%compute tau
function tau = att(qi,qf,myrobot)
    %placeholder
    Fatt = zeros(3,6);
    tau = zeros(6,1);
    temp = [1 1 1 1 1 1]; % assumes 6 links
    %for each link
    for i = 1:6
        %for link 1 to link i
        H = forward(qi, myrobot,i);
        O = H(1:3, 4);
        Hf = forward(qf, myrobot, i);
        Of = Hf(1:3,4);
        d = O-Of;
        %attract force
        Fatt(1:3, i) = -1*temp(i)*d;
        %find tau y jacobian
        tau =  Jacobiani(myrobot,qi,i)'* Fatt(1:3,i)+ tau ;
    end 
    %normalize
    tau = (tau/norm(tau));
end

%find jacobian of certain link
function Ja = Jacobiani(robot, q, link)
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