function [total_erroCD, total_erroND, total_erroCS, total_erroNS, ...
          total_erroJ] = cenario2(nr_vezes)
% Erro m�dio de Amari em fun��o do n�mero de fontes, matrizes A aleat�rias

e = 5e-4;

total_erroCD = [];
total_erroND = [];
total_erroCS = [];
total_erroNS = [];
total_erroJ = [];
for nr_fontes = 2:10
    erroCD = [];
    erroND = [];
    erroCS = [];
    erroNS = [];
    erroJ  = [];
    for n = 1:nr_vezes
        A = randn(nr_fontes);

        erroCD = [erroCD Teste(A, 1, 1, 'uu', e, 0)];
        erroND = [erroND Teste(A, 1, 2, 'uu', e, 0)];
        erroCS = [erroCS Teste(A, 2, 1, 'uu', e, 0)];
        erroNS = [erroNS Teste(A, 2, 2, 'uu', e, 0)];
        erroJ  = [erroJ Teste(A, 3, 1, 'uu', e, 0)];
    end
    total_erroCD = [ total_erroCD ; mean(erroCD) ];
    total_erroND = [ total_erroND ; mean(erroND) ];
    total_erroCS = [ total_erroCS ; mean(erroCS) ];
    total_erroNS = [ total_erroNS ; mean(erroNS) ];
    total_erroJ  = [ total_erroJ  ; mean(erroJ)  ];
end

figure
plot(2:10, total_erroCD, '-b*', 'lineWidth', 1.5, 'MarkerFaceColor', 'b')
hold on
plot(2:10, total_erroND, '-ro', 'lineWidth', 1.5, 'MarkerFaceColor', 'r')
plot(2:10, total_erroCS, '-m^', 'lineWidth', 1.5, 'MarkerFaceColor', 'm')
plot(2:10, total_erroNS, '-gs', 'lineWidth', 1.5, 'MarkerFaceColor', 'g')
plot(2:10, total_erroJ, '-cd', 'lineWidth', 1.5, 'MarkerFaceColor', 'c')
hold off
legend('Curtose + Defla��o', 'Negentropia + Defla��o', ...
       'Curtose + Ort. Sim�trica', 'Negentropia + Ort. Sim�trica', ...
       'JADE')
end