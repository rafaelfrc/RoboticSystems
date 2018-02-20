%% Robótica
%% Pose em 2 dimensões
% Criação de uma pose através de uma  transformação homogênea SE(2), que translada 
% em x=1, y=2 e rotaciona em 30°:

    T1 = SE2(1,2,30*pi/180)
%% 
% Note que o argumento de ângulo é em radianos. Para plotar a transformação 
% (em azul), temos:

    axis([0 5 0 5]);
    trplot2(T1, 'frame','1','color','b')
%% 
% Vamos plotar agora a transformação de rotação nula em vermelho, sobrepondo 
% ao gráfico:

    T2 = SE2(2,1,0)
    hold on
    trplot2(T2,'frame','2', 'color','r')
%% 
% Compondo agora as poses, temos:

T3 = T1*T2
trplot2(T3,'frame','3','color','g')
%% 
% Para mostrar a não-comutatividade da operação de composição, temos:

T4 = T2*T1
trplot2(T4,'frame','4','color','c')
%% 
% Agora, vamos definir um ponto (3,2) relativo ao frame universal:

P = [3;2];
%% 
% Vamos adicionar ao gráfico:

plot_point(P,'*');
%% 
% Para determinar as coordenadas deste ponto com relação ao frame {1}, temos:
% 
% $$^{o}\mathbb{p} = ^{o}\xi_1 \dot ^{1}\mathbb{p}$$
% 
% Ou seja:
% 
% $$^{1}\mathbb{p} = (^{o}\xi_1 ^{-1})  ^{0} \mathbb{p}$$

    P1 = inv(T1) * P
%% 
% Observe que P, apesar de ser um vetor 1x2, é transformado automaticamente 
% em homogêneo ao ser multiplicado por T1, que é uma matriz 3x3.