%% Robótica
%% Trajetórias
% *Trajetórias unidimensionais suaves:*
% 
% Geração de uma trajetória polinomial de grau 5:

figure
s = tpoly(0,1,50);
plot(s)
xlabel('amostras de tempo')
ylabel('deslocamento')
%% 
% O vetor s é uma trajetória suave de 50 elementos que sai do ponto zero 
% até o ponto 1.
% 
% Para obter a velocidade e a aceleração, temos os seguintes argumentos:

figure 
[s,sd,sdd] = tpoly(0, 1, 50);
plot(sd)
xlabel('amostras de tempo')
ylabel('velocidade')
plot(sdd)
xlabel('amostras de tempo')
ylabel('aceleração')
%% 
% Com velocidade inicial de 0.5 e final de 0:

figure
[s_final,sd_final,sdd_final] = tpoly(0, 1, 50, 0.5, 0);
subplot(3,1,1,gca)
plot(s_final)
xlabel('amostras de tempo')
ylabel('deslocamento')
subplot(3,1,2)
plot(sd_final)
xlabel('amostras de tempo')
ylabel('velocidade')
subplot(3,1,3)
plot(sdd_final)
xlabel('amostras de tempo')
ylabel('aceleração')
%% 
% Observe o overshoot da função posição nesse caso. Esse é um problema típico 
% de funções polinomiais, e, nesse caso, utilizamos a função trapezoidal de velocidade, 
% bastante utilizada em _<http://www.ti.com/lit/an/sprabq6/sprabq6.pdf drives>:_

figure
[s_trap,sd_trap,sdd_trap] = lspb(0, 1, 50);
subplot(3,1,1,gca)
plot(s_trap)
xlabel('amostras de tempo')
ylabel('deslocamento')
subplot(3,1,2)
plot(sd_trap)
xlabel('amostras de tempo')
ylabel('velocidade')
subplot(3,1,3)
plot(sdd_trap)
xlabel('amostras de tempo')
ylabel('aceleração')

%% 
% Perceba que a função velocidade é suave, mas a aceleração não é. A velocidade 
% máxima desta função é

 max(sd_trap)
%% 
% É possível setar uma velocidade diferente através de um quarto argumento:

s = lspb(0, 1, 50, 0.025);
%% 
% *Caso multimensional:*
% 
% Para mover do ponto (0, 2) para o ponto (1, -1) em 50 passos, temos:

figure
x = mtraj(@tpoly, [0 2], [1 -1], 50);
x = mtraj(@lspb, [0 2], [1 -1], 50);
plot(x)
legend({'eixo 1','eixo 2'})
title('Caso bidimensional')
xlabel('Amostras')
ylabel('Posição')
%% 
% *Trajetórias multi-segmentadas:*
% 
% Os pontos intermediários estão armazenados no array |via|, e os argumentos 
% para a função |mstraj| são os seguintes:
% 
% * Máxima velocidade por eixo
% * Duração de cada segmento
% * Coordenadas iniciais dos eixos
% * Período de amostragem
% * Tempo de aceleração

via = [ 4,1; 4,4; 5,2; 2,5 ];
q = mstraj(via, [2,1], [], [4,1], 0.05, 0);
plot(q)
legend({'eixo 1','eixo 2'})
title('Trajetórias multi-segmentadas')
xlabel('Tempo')
ylabel('Posição')
%% 
% *Interpolação de Orientação em 3D:*
% 
% Definimos duas orientações:

 R0 = rotz(-1) * roty(-1);
 R1 = rotz(1) * roty(1);
 
%% 
% Por causa das restrições do espaço das rotações, não é possível interpolar 
% as matrizes nesta representação.  Encontramos então as orientações rpy:

 rpy0 = tr2rpy(R0);
 rpy1 = tr2rpy(R1);
%% 
% O próxio comando cria uma trajetória de R0 a R1 em 50 passos:

  rpy = mtraj(@tpoly, rpy0, rpy1, 50);
  title('Orientação em 3D - Roll, Pitch e Yah')
  tranimate( rpy2tr(rpy))
%% 
% A desvantagem dessa representação é que o movimento parece descoordenado 
% quando as orientações estão muito próximas da singularidade. Usando quatérnios, 
% temos:

 q0 = UnitQuaternion(R0);
 q1 = UnitQuaternion(R1);
 q = interp(q0, q1, [0:49]'/49);
 title('Orientação em 3D - Quatérnios')
 tranimate(q.T) 
%% 
% O modo como| interp |funciona é através de interpolação esférica.
% 
% 
% 
%  *Movimento Cartesiano*
% 
% Observe as seguintes poses: T1 é a origem do movimento e T2, seu objetivo: 

 T0 = transl(0.4, 0.2, 0) * trotx(pi);
 T1 = transl(-0.4, -0.2, 0.3) * troty(pi/2)*trotz(-pi/2);
%% 
% Imagine a distãncia entre T1 e T2 normalizadas entre $s\in \left\lbrack 
% 0,1\right\rbrack$. Então, a pose intermediária, isto é, a pose para que s = 
% 0.5 é a seguinte:

trinterp(T0, T1, 0.5)
%% 
%  Uma trajetória de 50 passos entre as poses é criada dessa forma:

 Ts = trinterp(T0, T1, [0:49]/49);
%% 
% A estrutura de| Ts |é a seguinte:

about(Ts)
%% 
% Ora, os primeiro índices se referem à transformação, e o terceiro, ao 
% tempo.
% 
% Assim, a primeira pose pode ser referenciada assim:

Ts(:,:,1)
%% 
% Podemos plotar a transformação desta forma:

figure
subplot(1,2,1,gca)
P = transl(Ts);
rpy = tr2rpy(Ts);
plot(P);
legend({'x','y','z'})
xlabel('amostras de tempo')
ylabel('posição')
subplot(1,2,2)
plot(rpy);
xlabel('amostras de tempo')
legend({'roll','pitch','yah'})
ylabel('orientação')
%% 
% Note que form plotadas poses intermediárias.  Para obter uma trajetória 
% suave, fazemos o seguinte:

Ts = trinterp(T0, T1, lspb(0,1, 50) );
figure
subplot(1,2,1,gca)
P = transl(Ts);
rpy = tr2rpy(Ts);
plot(P);
legend({'x','y','z'})
xlabel('amostras de tempo')
ylabel('posição')
subplot(1,2,2)
plot(rpy);
xlabel('amostras de tempo')
legend({'roll','pitch','yah'})
ylabel('orientação')
%% 
% O comando anterior pode ser substituído por

 Ts = ctraj(T0, T1, 50);