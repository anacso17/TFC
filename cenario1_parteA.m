function [total_erroCD, total_erroND, total_erroCS, total_erroNS, ...
          total_erroJADE] = cenario1_parteA(nr_vezes)
% % Para uma matriz de mistura A (2x2) arbitrária:
% - mostrar figura com distribuições (fontes, misturas, após 
%   branqueamento e após separação)
% - mostrar figura com fontes x estimativas
% - apresentar tabela com valores de erro de Amari para os métodos
%   testados

e = 5e-4;
A = [0.8 1;2 1];

erroCD = [];
erroND = [];
erroCS = [];
erroNS = [];
erroJADE = [];
erroSOBI = [];
for n = 1:nr_vezes
    erroCD = [erroCD Teste(A, 1, 1, 'uu', e, n)];
    erroND = [erroND Teste(A, 1, 2, 'uu', e, n)];
    erroCS = [erroCS Teste(A, 2, 1, 'uu', e, n)];
    erroNS = [erroNS Teste(A, 2, 2, 'uu', e, n)];
    erroJADE = [erroJADE Teste(A, 3, 1, 'uu', e, n)];
    erroSOBI = [erroSOBI Teste(A, 4, 1, 'uu', e, n)];
end
total_erroCD = [mean(erroCD) var(erroCD)];
total_erroND = [mean(erroND) var(erroND)];
total_erroCS = [mean(erroCS) var(erroCS)];
total_erroNS = [mean(erroNS) var(erroNS)];
total_erroJADE = [mean(erroJADE) var(erroJADE)];
total_erroSOBI = [mean(erroSOBI) var(erroSOBI)];
end