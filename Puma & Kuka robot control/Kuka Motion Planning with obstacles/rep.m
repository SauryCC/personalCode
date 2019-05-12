% compute the repel field
function tau = rep(q,myrobot,obs)
    %placeholder
    tau = zeros(6,1);
    %for each link
    for i = 1:6
        %Find H and O
        H = forward(q',myrobot,i); 
        O = H(1:3,4);
        %GET xyz
        x = O(1);
        y = O(2);
        z = O(3);
        %get Jacobian 
        J = Jacobianii(myrobot, q, i);
         

        %if encountered sylinder obstacle
        if obs.type == 'cyl'
            R = obs.R;
            %if around
            if z <= obs.h
                B_pre = obs.c + R*(O(1:2) - obs.c)/norm(O(1:2) - obs.c);
                %b is closest point on obstacle to current joint
                B = [B_pre; O(3)];
                rho = O - B;
            %if  above
            else % 
                % if right above
                if norm(O(1:2) - obs.c) <= R 
                    B = [O(1:2); obs.h];
                    rho = O - B;
                %not right above
                else 
                    xc = obs.c(1); 
                    yc = obs.c(2); 
                    theta = atan2(y-yc, x-xc);
                    B = [xc + R * cos(theta); yc + R * sin(theta); obs.h];
                    rho = O - B;
                end
            end

        %if encountered plane obstacle
        elseif obs.type == 'pla'
            B = [O(1:2); obs.h];
            rho = O - B;
        end
        if norm(rho) <= obs.rho0
            F_rep = (1 / norm(rho) - 1 / obs.rho0)*(1 / norm(rho)^3) * rho;
        else
            F_rep = zeros(3,1);
        end
        tau = tau + J'  *  F_rep;
    end
    
     %find norm if tau ~= 0
    if norm(tau) ~= 0
        tau = tau / norm(tau);
    end
end

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



function Ja = Jacobianii(robot, q, link)
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