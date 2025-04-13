function pde = Poissondata2(varargin)

pde = struct('uexact',@uexact, 'f',@f, 'Du',@Du,  'g_D',@g_D);

% exact solution
    function val =  uexact(p)
        x = p(:,1); y = p(:,2);
        val = 1 - x.^2 - y.^2;
    end

% load data (right hand side function)
    function val =  f(p)
        val = 4 * ones(size(p,1), 1);
    end

% Derivative of the exact solution on the boundary
    function val =  Du(p)
        x = p(:,1); y = p(:,2);
        val = -2 * [x, y];
    end

% Dirichlet boundary condition
    function val = g_D(p)
        val = zeros(size(p,1), 1);
    end
end