
function [node, elem] = circlemesh(circle, h)
% CIRCLEMESH 生成圆形区域内的三角网格
%
%   [node, elem] = circlemesh(circle, h)
%
%   输入参数：
%     circle - 一个包含圆的信息的向量，格式为 [x_center, y_center, r]，
%              其中 \((x_{\text{center}}, y_{\text{center}})\) 是圆心，\(r\) 是半径。
%     h      - 节点之间的近似间距，用来控制网格的分辨率。
%
%   输出参数：
%     node - 节点坐标，大小为 N-by-2，每行表示一个节点的 \([x,y]\) 坐标。
%     elem - 三角形单元，每行包含构成一个三角形的三个节点的索引。

% 1. 创建 PDE 模型
model = createpde();

% 2. 定义圆形几何区域
%    对于一个以 $(x_c, y_c)$ 为圆心，半径为 $r$ 的圆，其几何描述可以写作：
%    \[
%      [1,\ x_{c},\ y_{c},\ r]^T
%    \]
xc = circle(1);
yc = circle(2);
r  = circle(3);

gd = [1; xc; yc; r];
% 字符串格式，几何名称可以任取
ns = char('C1');
ns = ns';
sf = 'C1';
[dl, bt] = decsg(gd, sf, ns);
geometryFromEdges(model, dl);

% 3. 利用 generateMesh 生成网格
mesh = generateMesh(model, 'Hmax', h, 'GeometricOrder', 'linear');

% 4. 提取节点和单元信息
%    mesh.Nodes 为 $2 \times N$ 的矩阵，mesh.Elements 为 $3 \times M$ 的矩阵，
%    这里进行转置使得输出格式与 squaremesh 类似
node = mesh.Nodes';
elem = mesh.Elements';

% 5. 可选：绘制网格检验结果
% figure;
% pdemesh(model);
% axis equal;
% title('圆形三角网格');
end