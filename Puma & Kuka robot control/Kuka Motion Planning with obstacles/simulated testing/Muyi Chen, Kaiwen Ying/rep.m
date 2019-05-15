% compute the repel field
function tau = rep(q,myrobot,obs)
    %placeholder
    tau = zeros(6,1);
    %for each link
    for i = 1:6
        %Find H and O
        H = forward(q',myrobot,i); 
        O = H(1:3,4); 
        %get Jacobian 
        J = Jacobiani(myrobot, q, i);
        %if encountered sphere obstacle 
        if obs.type == 'sph'
            c = obs.c;
            r = obs.R;
            % B is the Euclidien shortest dis
            B = c + r*(O-c) / norm(O-c);
            gradient = (O-B) / norm(O-B);
            rho = norm(O-B);
        %if encountered cylinder obstacle 
        elseif obs.type == 'cyl'
            o = O(1:2);
            c = obs.c;
            r = obs.R;
            %B(1) and B(2)
            
            
            
            Bi = c + r*(o-c) / norm(o-c);
            % B is the Euclidien shortest dis
            B = [Bi;O(3)];
            gradient = (O-B)/norm(O-B);
            rho = norm(O-B);
        end
        % max ramge of repulsive force: rho0  
        if rho <= obs.rho0
            Frep = (1/rho - 1/obs.rho0)*(1/rho^2)*gradient;
        else
            % 0 force
            Frep = [0;0;0];
        end

        tau = tau + J' * Frep;
    end
    
    %find norm if tau ~= 0
    if norm(tau) ~= 0
        tau = tau/norm(tau);
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