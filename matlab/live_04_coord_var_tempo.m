%% Robótica
%% Sistemas de Coordenadas Variantes no Tempo
% *Rotações variantes no tempo*
% 
% Para caracterizar uma rotação no espaço, utilizamos um vetor $\omega =\left(\omega_x 
% ,\omega_y ,\omega_z \right)$. A direção do vetor é o eixo de rotação, e sua 
% magnitude, a taxa de variação da rotação em torno do eixo.
% 
% A derivada de uma matriz de rotação variante no tempo é
% 
% $$R\left(t\right)=S\left(\omega \right)\dot{R} \left(t\right)$$
% 
% Onde $R\left(t\right)\in \mathrm{SO}\left(2\right)\text{ }\mathrm{ou}\text{ 
% }\mathrm{SO}\left(3\right)$ e $S\left(\omega \right)$ é uma matriz anti-simétrica, 
% que, para o caso em 3 dimensões, é:
% 
% $$S\left(\omega \right)=\left\lbrack \begin{array}{ccc}0 & -\omega_z  & 
% \omega_y \\\omega_z  & 0 & -\omega_x \\-\omega_y  & \omega_x  & 0\end{array}\right\rbrack$$

S = skew([1,2,3])
vex(S)
%% 
% *Movimento Incremental*
% 
% Dadas duas poses $\xi_0$ e $\xi_1$, nós podemos representar a diferença 
% entre elas por um vetor de 6 elementos, 3 referentes à translação e 3 referentes 
% à rotação:
% 
% $$\delta =\left\lbrack \begin{array}{c}t_1 -t_0 \\\mathrm{vex}\left({\mathit{\mathbf{R}}}_1 
% {\mathit{\mathbf{R}}}_0^T -{\mathit{\mathbf{I}}}_{3\mathrm{X3}} \right)\end{array}\right\rbrack$$
% 
%  

T0 = transl(1,2,3)*trotx(1)*troty(1)*trotz(1);
T1 = T0*transl(0.01,0.02,0.03)*trotx(0.001)*troty(0.002)*trotz(0.003)
d = tr2delta(T0, T1);
d'
delta2tr(d) * T0
%% 
% *Sistemas de Navegação Inercial*
% 
% É comum "deesnormalizar" as matrizes após sucessivas integrações em sistemas 
% de navegação inercial, por exemplo. Para realizar a normalização de matrizes:  

T0= trnorm(T0); 
%% 
% O equivalente para quatérnios da equação da derivada da rotação é a seguinte:
% 
% $$\overset{o}{q} =\frac{1}{2}\overset{o}{q} \left(\omega \right)\overset{o}{q}$$
% 
% Ao ter as 3 componentes da velocidade angular, e isso obtemos ao utilizar 
% IMUs, podemos obter o quatérnio referente ao deslocamento:

qd = UnitQuaternion.omega([1,2,3]);
%% 
% Com isso, integramos à uma frequência bem alta para obter o deslocamento 
% do frame. Tal integração desnormaliza o quatérnio, e, para normalizar o quatérnio, 
% fazemos:
% 
% $$\overset{o}{q} \left(\omega \right)'=\frac{\overset{o}{q} \left(\omega 
% \right)}{|\overset{o}{q} \left(\omega \right)|}$$
% 
% 

q = qd.unit();