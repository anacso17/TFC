function [total_erroCD, total_erroND, total_erroCS, total_erroNS, ...
          total_erroJ] = cenario1_parteB(nr_vezes, tipo_fontes)
% Parte B: matrizes A aleatoriamente geradas
% - tabela de erro de Amari (médio + desvio padrão) para cada método
% - Detalhe: considerar 3 possibilidades (no caso, linhas da matriz) -> 
%   uniforme, laplaciana e uma de cada tipo

e = 5e-4;

erroCD = [];
erroND = [];
erroCS = [];
erroNS = [];
erroJ = [];
for n = 1:nr_vezes
    A = randn(2);
    
    erroCD = [erroCD Teste(A, 1, 1, tipo_fontes, e, 0)];
    erroND = [erroND Teste(A, 1, 2, tipo_fontes, e, 0)];
    erroCS = [erroCS Teste(A, 2, 1, tipo_fontes, e, 0)];
    erroNS = [erroNS Teste(A, 2, 2, tipo_fontes, e, 0)];
    erroJ = [erroJ Teste(A, 3, 1, tipo_fontes, e, 0)];
end
total_erroCD = [mean(erroCD) var(erroCD)];
total_erroND = [mean(erroND) var(erroND)];
total_erroCS = [mean(erroCS) var(erroCS)];
total_erroNS = [mean(erroNS) var(erroNS)];
total_erroJ = [mean(erroJ) var(erroJ)];
end