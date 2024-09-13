% 定义状态空间矩阵
A = [0, 1, 0, 0; 0, 0, -2.093, 0; 0, 0, 0, 1; 0, 0, 45.3488, 0];
B = [0; 0.9302; 0; -3.4884];
C = [0, 0, 1, 0]; 

Qc = ctrb(A, B);  % 计算可控性矩阵
rank_Wc = rank(Qc);  % 计算可控性矩阵的秩

if rank_Wc == size(A, 1)
    disp('系统是能控的');
else
    disp('系统不是能控的');
end

Qo = obsv(A, C);  % 计算可观性矩阵
rank_Wo = rank(Qo);  % 计算可观性矩阵的秩

if rank_Wo == size(A, 1)
    disp('系统是能观的');
else
    disp('系统不是能观的');
end

eigenvalues = eig(A);  % 计算 A 的特征值
if all(real(eigenvalues) < 0)
    disp('系统是渐近稳定的');
elseif any(real(eigenvalues) > 0)
    disp('系统是不稳定的');
else
    disp('系统是临界稳定的（存在实部为 0 的特征值）');
end