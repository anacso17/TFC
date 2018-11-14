function [z, V] = PCA(x)

% Centraliza os dados de entrada para ter média nula
x = x - repmat(mean(x, 2), 1, size(x, 2));

% Calcula a matriz de autocorrelação
Rx = E_pva(x, x);

% Calcula autovalores e autovetores. eig lista os 
% autovetores em ordem de maiores autovalores
[autovetores_d, autovalores] = eig(Rx);

% Seleciona m componentes principais
V = (autovalores^-0.5)*autovetores_d';

% Calcula as componentes principais
z = V*x;

end