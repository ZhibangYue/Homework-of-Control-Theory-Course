% 定义状态空间矩阵
A = [0, 1, 0, 0; 0, 0, -2.093, 0; 0, 0, 0, 1; 0, 0, 45.3488, 0];   % 4x4 矩阵
B = [0; 0.9302; 0; -3.4884];         % 2x1 矩阵
C = [0, 0, 1, 0];         % 1x2 矩阵
D = [0];            % 1x1 矩阵

% 创建一个新的Simulink模型，确保名称不冲突
modelName = 'pendulum3';
open_system(new_system(modelName));

% 添加 State-Space 模块
stateSpaceBlock = [modelName, '/State-Space'];
add_block('simulink/Continuous/State-Space', stateSpaceBlock);

% 设置初始状态（角度pi/6）
initialConditions = [0; 0; pi/6; 0];

% 设置 State-Space 模块的所有参数一次性
set_param(stateSpaceBlock, ...
    'A', mat2str(A), ...
    'B', mat2str(B), ...
    'C', mat2str(C), ...
    'D', mat2str(D), ...
    'X0', mat2str(initialConditions));

% 添加一个 Step 输入信号
stepBlock = [modelName, '/Step Input'];
add_block('simulink/Sources/Step', stepBlock);

% 添加一个 Scope 模块用于观察输出
scopeBlock = [modelName, '/Scope'];
add_block('simulink/Sinks/Scope', scopeBlock);

% 设置模块的位置和大小
set_param(stateSpaceBlock, 'Position', [150, 100, 300, 200]);
set_param(stepBlock, 'Position', [50, 125, 100, 175]);
set_param(scopeBlock, 'Position', [400, 100, 500, 200]);

% 连接 Step 输入到 State-Space 模块
add_line(modelName, 'Step Input/1', 'State-Space/1');

% 连接 State-Space 模块到 Scope 输出
add_line(modelName, 'State-Space/1', 'Scope/1');

% 保存并打开模型
save_system(modelName);
open_system(modelName);

set_param(modelName, 'StopTime', '1');

% 运行仿真
sim(modelName);
