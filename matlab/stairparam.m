function [ v_r,se_r,z_r,xi,zi ] = stairparam(x0,z0,v0_)
% Returns the result of the fminserach using start values as well as the
% pointcloud vectors.
%


%% Minimize delta for v

handle = @delta;
options = struct('MaxFunEvals',1000,'MaxIter',1000); % 'OutputFcn', @outfun,'PlotFcns',@optimplotfval
[v_r,se_r] = fminsearch(handle,v0_,options);
%disp(v_r);


%% Delta function - calculates the difference between real-z and template-z
    function [se] = delta(v)
        
      % Initialize parameters out of input vector
      
       %  h     = v(1);
       %  t     = v(2);
        h = sqrt(v(1)^2);
        t = sqrt(v(2)^2);
        dx    = sqrt(v(3)^2);
        dz    = v(4);
        theta = v(5);

        xi = cos(theta)*x0 - sin(theta)*z0;
        zi = cos(theta)*z0 + sin(theta)*x0;
        
        zi = zi + dz;
        xi = xi + dx;
        
        eta = atan2(t,h);
%         a = h/2*cos(eta);           % Parameters used for fourier transform
%         b = t/2*sin(eta);
%         L = 2*(a + b);
        a = h*cos(eta);           % Parameters used for if_else
        b = t*sin(eta);
        x1 = a;
        x2 = a + b;      
        
%%        Sum the fourier series
%         z = 0;
%         for n = 1:10
% 
%             k = 2*pi*n/L;
%             bn1 = 4*tan(eta)/L * (sin(k*x1)/k^2 - x1*cos(k*x1)/k);    
%             bn2 = -4/(tan(eta)*L) * (sin(k*x2)/k^2 - x2*cos(k*x2)/k - (sin(k*x1)/k^2 - x1*cos(k*x1)/k))...
%                   + 4*h/(2*sin(eta)*L) * (-cos(k*x2)/k + cos(k*x1)/k);
% 
%             bn = bn1 + bn2;
% 
%             zn = bn*sin(k*xi);
%             z = zn + z; 
%         end
%         z = z - cos(eta)*h/2;
%%       If_else parametrisation

        z_r = zeros(1,length(xi));        
        for it = 1:length(xi)
            n = floor(xi(it)/x2);
            if mod(xi(it),x2) < x1
                z_r(it) = xi(it)*tan(eta) - n*t/(cos(eta)) - h*sin(eta);
            else
            z_r(it) = -xi(it)/(tan(eta)) + (n+1)*h/(sin(eta)) - h*sin(eta);
            end
        end
       
        e = (zi - z_r);    % Error between pointcloud and template
        se = dot(e,e);
        
        
%         plot(xi,zi,'x');
%         axis equal tight
%         plot(xi,z_r,'o')
%         axis equal tight
    end
end
