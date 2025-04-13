function pde = PlateBendingData5(varargin)

% data for plate
if nargin == 0
    t = 0.1; % plate thickness (m)
    E = 10920; % Young's modulus (Nm/kg^2)
    nu = 0.3;  % Poisson's ratio
    D = E*t^3/12/(1-nu^2); % flexural rigidity
    c = 0; % 弹性耦合常数
    para = struct('t',t, 'E',E, 'nu',nu, 'D',D, 'c',c);    
end

% exact solution (we don't know)
    function val =  uexact(p)
        val = rand(size(p,1), 1);
    end

% load data (right hand side function)
    function val =  f(p)
        r = 0.5;
        in_r = 0.45;
        val = 100 * ones(size(p,1), 1) .* (vecnorm(p')' < r) .* (vecnorm(p')' > in_r);
        val = val - 10 * ones(size(p,1), 1) .* (vecnorm(p')' < in_r);
    end

% Dirichlet boundary condition
    function val = g_D(p)
        val = zeros(size(p,1), 1);
    end

% Outer-normal derivative of the exact solution in the boundary
    function val =  Dw(p)
        val = zeros(size(p,1), 1);
    end

pde = struct('para', para, 'f',@f, 'uexact',@uexact, 'g_D',@g_D, 'Dw',@Dw);
end

