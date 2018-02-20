%% Robótica
%% Pose em 3 dimensões
% *Matriz Ortonormal de Rotação*
% 
% R é a matriz que rotaciona $\theta$ graus em torno do eixo especificado.

    R = rotx(pi/2)
%% 
% |roty |e |rotz| realizam as rotações em torno de y e z, respectivamente. 
% Para plotar, temos:

    trplot(R)
%% 
% Podemos animar a rotação desta forma:

    tranimate(R)
%% 
% Observe que as colunas das matrizes de rotação nos dá a direção do frame 
% atual com relação ao frame antigo. Por exemplo, (1,0,0) mostra que o eixo x 
% está invariante, (0,0,1) mostra que o atual eixo y coincide com o antigo eixo 
% z e (0,-1,0) mostra que o atual eixo z corresponde ao antigo eixo y invertido.
% 
% 
% 
% *Ângulos de Euler:*
% 
% Convencionamos a rotação euleriana ZYZ:

 R = rotz(0.1) * roty(0.2) * rotz(0.3)
 R = eul2r(0.1,0.2,0.3)
%% 
% O problema inverso é determinar os ângulos a partir da matriz de rotação:

gamma = tr2eul(R)
%% 
% como o mapeamento entre os ângulos $\Gamma$e a matriz R não é biunívuco, 
% a função |tr2eul |só retorna valores positivos de $\theta$:

 R = eul2r(0.1 , -0.2, 0.3)
 gamma = tr2eul(R)
 eul2r(gamma)
%% 
% Um caso interessante é com $\theta =0$ :

 R = eul2r(0.1 , 0, 0.3)
 gamma = tr2eul(R)
%% 
% Observe que, com a omissão de $\theta$, o que temos são duas rotações 
% sucessivas em torno de $\overline{z}$.
% 
% Para a convenção _roll_, _pitch_ e _yah_, temos:

  R = rpy2r(0.1, 0.2, 0.3)
 rpy = tr2rpy(R)
%% 
% *Representação de dois vetores*

 a = [1 0 0]';
 o = [0 1 0]';
 oa2r(o, a)
%% 
% *Rotação em torno de um vetor arbitrário*
% 
%     Ao girar o frame "0" ao redor do vetor "v", $\theta$ graus, encontramos 
% a matriz R:

 [theta, v] = tr2angvec(R)
%% 
% Observe:

 [v,lambda] = eig(R)
%% 
% Uma matriz de rotação ortonormal sempre possui um par de autovalores complexos 
% e um autovalor real.
% 
% O par de autovalores complexos é da forma  $\lambda = \cos \theta \pm i 
% \sin \theta$, onde  $\theta$ é o ângulo de rotação.
% 
% O autovetor correpondente ao autovalor real é o eixo de rotação. Esse vetor 
% é *invariante* pela operação de rotação.

  R = angvec2r(pi/2, [1 0 0])
%% 
% *Quatérnios*
% 
% $$\overset{o}{q} =s<v_1 ,v_2 ,v_3 >$$

 q = UnitQuaternion(rpy2tr(0.1, 0.2 , 0.3))
%% 
% Multiplicação pelo inverso:

 q*inv(q)
%% 
% Que é a identidade, ou rotação nula.

q.R
%% 
% É a representação em termos de matrizes de rotação. Podemos visualizar 
% através de 

q.plot()
%% 
% E um vetor é rotacionado através de um quatérnio usando

q*[1 0 0]'
%% 
% *Combinando rotações e translações:*

 T = transl(1, 0, 0) * trotx(pi/2) * transl(0, 1, 0)
 trplot(T)
%% 
% Parte rotacional:

 t2r(T)
%% 
% Parte translacional:

 transl(T)'