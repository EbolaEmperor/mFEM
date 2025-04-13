function pde = PlateBendingData4(varargin)

% data for plate
if nargin == 0
    t = 0.1; % plate thickness (m)
    E = 10920; % Young's modulus (Nm/kg^2)
    nu = 0.3;  % Poisson's ratio
    D = E*t^3/12/(1-nu^2); % flexural rigidity
    c = 0; % 弹性耦合常数
    para = struct('t',t, 'E',E, 'nu',nu, 'D',D, 'c',c);    
end

% exact solution
    function val =  uexact(p)
        x = p(:,1); y = p(:,2);
        val = (1 - x.^2 - y.^2).^2;
    end

% load data (right hand side function)
    function val =  f(p)
        val = 64 * ones(size(p,1), 1);
    end

% Derivative of the exact solution on the boundary
    function val =  Dw(p)
        val = zeros(size(p,1), 2);
    end

% Dirichlet boundary condition
    function val = g_D(p)
        val = zeros(size(p,1), 1);
    end

pde = struct('para', para, 'f',@f, 'uexact',@uexact, 'g_D',@g_D, 'Dw',@Dw);
end