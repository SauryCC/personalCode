function qref = motionplan(q0,q2,t1,t2,myrobot,obs,tol)
    %accuracy
    N = 500;
    alpha = 0.01;
    %create variable q
    q = q0;
    Qi = zeros(6,1);
    %
    for i = 1:N
        %initialize
        %find attractive force
        Fatt = att(Qi, q2, myrobot);
        Frep = 0;
        Qi = q(end, 1:6);
        %if only 1 obstacle 
        if length(obs) == 1
            %find total Frep
            newRep = rep(Qi, myrobot, obs);
            Frep = Frep + newRep;
        % if multiple obstacle
        else
            %add up each value
            for j = 1:length(obs)
                %find total Frep
                newRep = rep(Qi, myrobot, obs{j});
                Frep = Frep + newRep;
            end
        end
        
        Qnew = Qi + alpha*(Fatt' + Frep');
        %break point
        p1 = wrapTo2Pi(Qnew(1:5));
        p2 = wrapTo2Pi(q2(1:5));
        if norm(p1-p2) < tol
            fprintf("value smaller than tol");
            break
        end
    end
    %finish up
    t = linspace(t1,t2,size(q,1));
    qref = spline(t,q');
end