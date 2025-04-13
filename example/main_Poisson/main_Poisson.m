clc; clear; close all; 
%% Parameters
maxIt = 6;
h = zeros(maxIt,1); NNdof = zeros(maxIt,1);
ErrL2 = zeros(maxIt,1);
ErrH1 = zeros(maxIt,1);

%% Generate an initial mesh
% a1 = 0; b1 = 1; a2 = 0; b2 = 1;
% Nx = 4; Ny = 4; h1 = (b1-a1)/Nx; h2 = (b2-a2)/Ny;
% [node,elem] = squaremesh([a1 b1 a2 b2],h1,h2);
% % 三面 Dirichlet + 一面 Neumann 边界
% bdNeumann = 'abs(x-1)<1e-4';

%% Get the PDE data
pde = Poissondata2();
grid_h = 0.4;

%% Finite element method
for k = 1:maxIt
    % refine mesh
    % [node,elem] = uniformrefine(node,elem);
    % 每次完全重建网格，逐步逼近圆形边界
    [node, elem] = circlemesh([0, 0, 1], grid_h);
    % set boundary
    % 全 Dirichlet 边界
    bdStruct = setboundary(node,elem);
    % bdStruct = setboundary(node,elem,bdNeumann);
    % level number
    option.J = k+1;
    option.solver = "direct"; % 不使用多重网格
    % solve the equation
    [uh,info] = Poisson(node,elem,pde,bdStruct,option);
    % record
    NNdof(k) = length(uh);
    h(k) = 1/(sqrt(size(node,1))-1);
    if NNdof(k) < 1e4
        figure(1); 
        showresult(node,elem,pde.uexact,uh);
        pause(1);
    end
    % compute error
    ErrL2(k) = getL2error(node,elem,pde.uexact,uh);
    ErrH1(k) = getH1error(node,elem,pde.Du,uh);
    grid_h = grid_h / 2;
end

%% Plot convergence rates and display error table
figure(2);
showrateh(h,ErrH1,ErrL2);

fprintf('\n');
disp('Table: Error')
colname = {'#Dof','h','||u-u_h||','|u-u_h|_1'};
disptable(colname,NNdof,[],h,'%0.3e',ErrL2,'%0.5e',ErrH1,'%0.5e');

%% Conclusion
%
% The optimal rate of convergence of the H1-norm (1st order), L2-norm
% (2nd order) is observed. 

figure,spy(info.kk)