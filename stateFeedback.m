% 状态空间矩阵
A = [0, 1, 0, 0; 0, 0, -2.093, 0; 0, 0, 0, 1; 0, 0, 45.3488, 0];
B = [0; 0.9302; 0; -3.4884];
C = [0, 0, 1, 0]; 
D = [0];

desired_poles = [-3, -2, -15, -16];  % 期望的闭环极点

K = place(A, B, desired_poles);  % 计算反馈增益矩阵 K
% 计算闭环系统的状态矩阵 A_cl
A_cl = A - B * K;

% 创建闭环系统的状态空间模型
sys_cl = ss(A_cl, B, C, D);

% 查看闭环系统的动态特性
eig(A_cl)  % 查看闭环极点
opt = stepDataOptions('InputOffset', 0, 'StepAmplitude', 10);  % 设置阶跃大小为 5
t = 0:0.01:10;  % 仿真时间
x0 = [0; 0; pi/6; 0];  % 设置初始状态
initial(sys_cl, x0, t, opt);