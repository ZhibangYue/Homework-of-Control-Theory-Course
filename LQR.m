% 状态空间矩阵
A = [0, 1, 0, 0; 0, 0, -2.093, 0; 0, 0, 0, 1; 0, 0, 45.3488, 0];
B = [0; 0.9302; 0; -3.4884];
C = [0, 0, 1, 0]; 
D = [0];

Q = diag([0.01 0.01 10 1]);  % 状态权重矩阵 Q
R = 0.01;  % 控制权重矩阵 R

% 计算 LQR 增益矩阵 K
[K, P, e] = lqr(A, B, Q, R);

% 查看反馈增益矩阵 K
disp(K);

% 计算闭环系统矩阵 A_cl
A_cl = A - B * K;

% 创建闭环系统状态空间模型
sys_cl = ss(A_cl, B, C, D);

opt = stepDataOptions('InputOffset', 0, 'StepAmplitude', 10);  % 设置阶跃大小为 5
t = 0:0.01:15;  % 仿真时间
x0 = [0; 0; pi/6; 0];  % 设置初始状态
initial(sys_cl, x0, t, opt);
