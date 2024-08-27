# 《控制理论综合》课程设计

《控制理论与控制工程》是一门发展非常迅速、应用非常广泛的学科，控制理论在多领域都得到了广泛的应用。自19世纪以来，控制理论经历了以下的发展历程：

1. 经典控制理论（19世纪初-20世纪50年代）

   - 时域法
   - 根轨迹法
   - 频域法

2. 现代控制理论（20世纪60年代-）

   - 最优控制
   - 鲁棒控制
   - 非线性系统理论

3. 智能控制理论（20世纪70年代-）
   - 模糊控制
   - 多智能体
   -  神经网络

4. ...

## 体重控制问题

### 背景

人类体重的变化与热量吸收及消耗相关。每日的饮食会带来热量摄入，同时每天的呼吸、日常工作或者运动则会消耗热量。根据热量的摄入与消耗，一个人体重变化的微分方程可以粗略表达为：
$$
\frac{dm}{dt}=\frac{E_i-E_e}{7000}
$$
其中$m$表示体重，$E_i$表示热量摄入。国际单位是kJ。而一般情况下与饮食、运动相关的热量常用单位是kCal，即一千卡路里。热量的消耗用$E_e$表示。因此，每日的净热量摄入等于$E_i-E_e$，而净热量与体重的关系大概是$7000kCal\approx 1kg$脂肪。

热量摄入$E_i$来源于饮食，属于相对独立的一个变量，而消耗$E_e$可以分为两部分，即
$$
E_e=E_a+\alpha P
$$
其中$E_a$是每日额外的运动消耗，如健身消耗；而$\alpha P$表示日常消耗，$\alpha$是一个对应于不同劳动强度的系数，例如轻体力劳动者的$\alpha=1.3$，种体力劳动者的$\alpha=1.5$，重体力劳动者大概的$\alpha=1.9$。$P$是基础代谢率，它的计算很复杂且因人而异。为简化运算，可以选用 Mifflin-St Jeor 公式来估算它，误差在5%左右，其表达式为
$$
P=10m+6.25h-5a+S
$$
其中$h$表示身高，单位是cm，$a$表示年龄。$S$是一个调整系数，它和性别相关（男性：$S=5$，女性：$S=-161$）。

最终可以得到：
$$
7000\frac{dm}{dt}+10\alpha m = E_i -E_a -\alpha(6.25h-5a+S)
$$

### 1. 体重预测

要求建立控制系统，根据输入（$E_i-E_a$）及初始状态，对某一时刻的体重做出预测。

由于一个人成年后的身高和性别一般不变，而年龄的变化较为缓慢，因此$6.25h-5a+S$可视为常数，于是有				
$$
7000\frac{dm}{dt}+10\alpha m = E_i -E_a -\alpha C
$$
输入写作$u(t)=E_i-E_a$，扰动量为$d(t)=-\alpha C$，

系统的微分方程可以表示为：
$$
7000\frac{dx(t)}{dt}+10\alpha x(t)=u(t)+d(t)
$$
拉普拉斯变换求出传递函数
$$
G(s)=\frac{1}{7000s+10\alpha}
$$
建立系统如`weightlose1`所示。

### 2. 体重比例控制

#### 控制策略

- 体重大于目标值的时候，多运动，少吃饭
- 体重小于目标值的时候，少运动，多吃饭

#### 本质

根据输出调节输入，使输出与给定尽量相等。

#### 解决方案

在输入前增加比例环节，使得
$$
U(s)=K_pE(s)
$$
其中$E(s)=R(s)-X(s)$，表示偏差（error）。

建立系统如`weightlose2`所示。

#### 参数选择

系统的输出可以表示为
$$
X(s)=\frac{U(s)+D(s)+7000x_0}{7000s+10\alpha}\\=\frac{(R(s)-X(s))K_p+D(s)+7000x_0}{7000s+10\alpha}
$$
化简得：
$$
X(s)=\frac{K_pR(s)+D(s)+7000x_0}{7000s+10\alpha +K_p}
$$
给定和扰动都可视为阶跃信号，那么$R(s)=\frac{r}{s}, D(s)=-\frac{\alpha C}{s}$。

代入可得新系统的传递函数为
$$
G'(s)=\frac{X(s)}{R(s)}=\frac{K_pr-\alpha C+7000x_0s}{r(7000s+10\alpha+Kp)}
$$
为保证系统稳定，闭环系统特征方程的根应全部具有负实部。

解得根为
$$
s=-\frac{K_p+10\alpha}{7000}
$$
当$K_p>0$时，$s<0$恒成立，因此系统总是稳定的。

#### 稳态输出

既然系统是稳定的，那么当$K_p$确定时，其他条件不变的情况下，总能确定唯一稳态输出。

利用终值定理，
$$
\lim_{x\rightarrow\infin}x(t)=\lim_{s\rightarrow0}sX(s)=\frac{K_pr-\alpha C}{K_p+10\alpha}
$$

可知系统的稳态输出与$K_p、r、\alpha、C$有关。

#### 稳态误差

既然系统的稳态输出可以唯一确定，那么可以计算稳态误差检验输出与给定是否近似。

稳态误差(steady state error)记作$e_{ss}$
$$
e_{ss}=r-\lim_{x\rightarrow\infin}x(t)=r-\frac{K_pr-\alpha C}{K_p+10\alpha} \\ =\frac{10\alpha+\alpha C}{K_p+10\alpha}
$$
如果输出与给定近似相等，则有$e_{ss}\approx0$，但对于某一确定的系统，$\alpha$和$C$都是系统固有属性，其值由被控对象决定，不因$K_p$的不同而有所差异。

因此对于同一确定的系统，$K_p$不同，稳态输出则不同（稳态误差也不同）。

若要使稳态误差为0，即输出与给定完全相同，则要求$K_p\rightarrow\infin$。

但实际上$K_p\rightarrow\infin$无法实现，而且$K_p$过大会导致系统资源消耗过大，稳定裕度降低，不符合实际应用场景。

#### 动态特性

用调节时间$t_s$来表征系统的动态特性：
$$
t_s=4\tau
$$
$\tau$为时间常数，对于$G'(s)$将其化为一阶系统标准形式$G(s)=\frac{K}{\tau s+1}$，可以求得$\tau=\frac{7000}{10\alpha+K_p}$

由此可知，当$K_p$越大，$\tau$越小，调节时间越短，系统的动态响应越快。

### 3. 体重积分控制

#### 控制策略

- 当前体重与预期体重之间存在偏差，若存在正偏差，则少吃多运动，若正偏差长期存在，则继续保持
- 反之亦然
- 若偏差不存在，则停止

#### 本质

对偏差进行累计和调整，使输出能够跟随给定。

#### 解决方案

在输入前添加积分环节，使得
$$
U(s)=\frac{E(s)}{s}
$$
建立系统如`weightlose3`所示。

#### 参数选择

前置积分环节后，系统的输出变为
$$
X(s)=\frac{\frac{K_i}{s}R(s)+D(s)+7000x_0}{7000s+10\alpha +\frac{K_i}{s}}
$$
可以发现，系统由一阶系统变为二阶系统。

新的传递函数为
$$
G''(s)=\frac{K_ir-\alpha Cs+7000x_0s}{r(7000s^2+10\alpha s+K_i)}
$$
可以对特征方程使用一元二次方程求根公式，得到
$$
s_{1,2} =\frac{-\alpha\pm\sqrt{\alpha^2-280K_i}}{1400}
$$
前提是判别式$\Delta>=0$，此时若要求$s_{1,2}<0$，可知$K_i>0$即可满足，使得系统稳定。

若一元二次方程无实数解，可知共轭根的实部为$-\frac{\alpha}{1400}$，也满足稳定性要求。

#### 稳态输出

既然系统是稳定的，那么当$K_i$确定时，其他条件不变的情况下，总能确定唯一稳态输出。

利用终值定理，
$$
\lim_{x\rightarrow\infin}x(t)=\lim_{s\rightarrow0}sX(s)=\frac{K_ir}{K_i}=r
$$

可知系统天然能实现稳态跟随，不存在稳态误差。

#### 稳态误差

由上可知，积分控制显然不存在稳态误差。

#### 动态特性

由于引入了积分环节，系统变为二阶系统，这表示系统会出现振荡现象。

对于一般二阶系统，动态过程中的快速性（上升时间$t_s$）和平稳性（超调$\sigma$）往往是不可兼得的。

通常来讲，增大积分增益$K_i$，可以缩短上升时间，加快响应速度，但也会导致超调量增加。

通过观察比较比例控制和积分控制的系统输出，可以发现积分控制的系统响应速度远慢于比例控制，原因可以从控制策略上解释：比例控制是基于输出的控制，是瞬时性的；而积分控制是基于输出和给定的偏差的控制，偏差是累加性的偏差，因此需要一定时间。

积分控制的传递函数分母类似二阶系统的标准形式，但分子中存在$s$项，因此存在零点，而零点的位置不仅与系统固有属性如$\alpha、C、x_0$相关，还会受$K_i$和给定$r$的影响，考虑到零点对系统动态特性的影响，包括对闭环极点的影响（如干扰闭环主导极点、构成偶极子等），因此直接用公式计算含变量的调节时间与超调量，定量测定系统动态性能是较为困难的，实际工程中也通常使用数值仿真的方式来精确评估，而非单纯依靠理论计算。

### 4. 体重比例积分控制

#### 控制策略

结合比例控制和积分控制

#### 本质

结合比例控制和积分控制

#### 解决方案

在输入前添加比例积分环节，即一个比例环节与一个积分环节并联，使得
$$
U(s)=(K_p+\frac{K_i}{s})E(s)
$$
建立系统如`weightlose4`所示。

#### 参数选择

前置比例积分环节后，系统的输出变为
$$
X(s)=\frac{(K_p+\frac{K_i}{s})R(s)+D(s)+7000x_0}{7000s+10\alpha +(K_p+\frac{K_i}{s})}
$$
于是新的传递函数为
$$
G'''(s)=\frac{(K_p+\frac{K_i}{s})r-\alpha C+7000x_0s}{r(7000s+10\alpha+K_p+\frac{K_i}{s})}
$$
同样判断系统的稳定性，方式与积分控制类似，通过一元二次方程求根公式求取极点，结论也类似。

为使系统稳定，要求$K_p,K_i>0$，这是显然成立的。

#### 稳态输出

既然系统是稳定的，那么当$K_p,K_i$确定时，其他条件不变的情况下，总能确定唯一稳态输出。

利用终值定理，
$$
\lim_{x\rightarrow\infin}x(t)=\lim_{s\rightarrow0}sX(s)=\frac{K_ir}{K_i}=r
$$

可知系统天然能实现稳态跟随，不存在稳态误差。

可以看出比例积分控制保有了积分控制的性质。

#### 稳态误差

由上可知，比例积分控制不存在稳态误差。

#### 动态特性

观察输出可知，比例积分控制结合了比例控制和积分控制的优点，其动态特性相较于积分控制好，类似比例控制，有更快的响应速度。

实际工程中，常用的调参方法是“经验法”，因为动态特性相较于积分控制更难理论计算，通常只是定性分析。

比例部分反映的是系统的快速性，它能够对输出快速做出反应，使得系统有较快的响应速度。

积分部分反映的是系统的准确性，它通过累计偏差使输出具有跟随能力，保证系统具有较小的稳态误差。

但两者的参数选择依然有一定范围，如$K_p$过大会增大资源开销，降低系统稳定裕度，$K_i$过大会增大输出的超调，增强振荡作用。

因此在实际工程中，往往根据实际动态特性需要选择大小合适的参数，进行仿真调试，几经测试后才可以真正用在实体上。

