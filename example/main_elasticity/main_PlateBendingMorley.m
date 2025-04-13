clc; clear; close all; 
%% Parameters
maxIt = 5;
h = zeros(maxIt,1); NT = zeros(maxIt,1);
ErrL2 = zeros(maxIt,1);
%ErrH1 = zeros(maxIt,1);

%% Generate an initial mesh
% a1 = 0; b1 = 1; a2 = 0; b2 = 1;
% Nx = 4; Ny = 4; h1 = (b1-a1)/Nx; h2 = (b2-a2)/Ny;
% [node,elem] = squaremesh([a1 b1 a2 b2],h1,h2);

grid_h = 0.4;

%% Get the PDE data
pde = PlateBendingData6;

%% Finite element method
for k = 1:maxIt
    % refine mesh
    [node, elem] = circlemesh([0, 0, 1], grid_h);
    % set boundary
    bdStruct = setboundary(node,elem);
    % solve the equation
    wh = PlateBendingMorley(node,elem,pde,bdStruct);  % signed basis functions
    %wh = PlateBendingMorley1(node,elem,pde,bdStruct); % signed edges
    % record
    NT(k) = length(wh);
    h(k) = 1/(sqrt(size(node,1))-1);
    if NT(k)<2e5
        figure(1); 
        showresult(node,elem,pde.uexact,wh);
        pause(1);
    end
    % compute error
    ErrL2(k) = getL2error_Morley(node,elem,pde.uexact,wh);
    grid_h = grid_h / 2;
end

%% Plot convergence rates and display error table
figure(2);
showrateh(h,ErrL2,'$||u-u_h||_{L^2}$');

%% Conclusion
%
% The optimal rate of convergence of the L2-norm (2nd order) is observed.