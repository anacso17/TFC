function erroAmari = Teste(A, metodo, metrica, tipo, e, plot_flag)

%       A: Matriz de mistura
%  metodo: Método usado para encontrar multiplas fontes 
%               1 - Deflação
%               2 - Simétrico
%               3 - JADE
%               4 - SOBI
% metrica: Métrica usada para busca da matriz de separação
%               1 - Curtose
%               2 - Negentropia
%    tipo: Tipo de fontes
%            'uu' - duas fontes i. i. d. uniformes
%            'll' - duas fontes i. i. d. laplacianas
%    'ul' ou 'lu' - uma fonte uniforme e uma laplaciana
%          'sobi' - uma fonte uniforme e um sinal sonoro 'train'

% Gera as fontes com média zero e variância unitária
if strcmp(tipo, 'sobi')
    s1 = 2*sqrt(3)*rand(1, 1000) - sqrt(3);
    load train
    s2 = y(1:12:12000)';
    s = [s1;s2];
elseif size(A, 1) == 2
    if strcmp(tipo, 'uu')
        s1 = 2*sqrt(3)*rand(1, 1000) - sqrt(3);
        s2 = 2*sqrt(3)*rand(1, 1000) - sqrt(3);
    elseif strcmp(tipo, 'll')
        mu=0; sigma=1; b=sigma/sqrt(2);
        u1 = rand(1, 1000)-0.5;
        s1 = mu - b*sign(u1).*log(1-2*abs(u1));
        u2 = rand(1, 1000)-0.5;
        s2 = mu - b*sign(u2).*log(1-2*abs(u2));
    elseif strcmp(tipo, 'ul') || strcmp(tipo, 'lu')
        mu=0; sigma=1; b=sigma/sqrt(2);
        u1 = rand(1, 1000)-0.5;
        s1 = mu - b*sign(u1).*log(1-2*abs(u1));
        s2 = 2*sqrt(3)*rand(1, 1000) - sqrt(3);
    end
    s = [s1;s2];
else
    s = [];
    for k = 1:size(A,1)
        if strcmp(tipo, 'uu')
            sk = 2*sqrt(3)*rand(1, 1000) - sqrt(3);
        elseif strcmp(tipo, 'll')
            mu=0; sigma=1; u=rand(1, 1000)-0.5; b=sigma/sqrt(2);
            sk = mu - b*sign(u).*log(1-2*abs(u));
        end
        s = [s; sk];
    end
end
% ------------------------------
if (size(A, 1) == 2) && (plot_flag == 1)
    figure
    title('Distribuições conjuntas')
    subplot(2, 2, 1)
    plot(s1, s2, '.')
    title('Fontes originais')
    axis([-3 3 -3 3])
    grid on
end
% ------------------------------

% Gera as misturas
x = A*s;
x1 = x(1, :);
x2 = x(2, :);
% ------------------------------
if (size(A, 1) == 2) && (plot_flag == 1)
    subplot(2, 2, 2)
    plot(x1, x2, '.')
    title('Misturas')
    axis([-6 6 -6 6])
    grid on
end
% ------------------------------

% Branqueia os dados
[z, V] = PCA(x);
z1 = z(1, :);
z2 = z(2, :);
% ------------------------------
if (size(A, 1) == 2) && (plot_flag == 1)
    subplot(2, 2, 3)
    plot(z1, z2, '.')
    title('Misturas branqueadas')
    axis([-3 3 -3 3])
    grid on
end
% ------------------------------

% Busca W ótima
if metodo == 3
    W = jadeR(z);
elseif metodo == 4
    W = sobi(z);
else
    [W, ~] = FastICA(z, metodo, metrica, e);
end

% Calcula as estimativas das fontes
y = W*z;
y1 = y(1, :);
y2 = y(2, :);
% ------------------------------
if (size(A, 1) == 2) && (plot_flag == 1)
    subplot(2, 2, 4)
    plot(y1, y2, '.')
    title('Estimativas das fontes')
    axis([-3 3 -3 3])
    grid on
end
% ------------------------------

% Calcula erro de Amari das estimativas
erroAmari = Amari(A, V, W);

if (size(A, 1) == 2) && (plot_flag == 1)
    % Plota as fontes + estimativas pareadas adequadamente
    eq11pos = sqrt(mean((y1-s1).^2));
    eq11neg = sqrt(mean((y1+s1).^2));
    eq12pos = sqrt(mean((y2-s1).^2));
    eq12neg = sqrt(mean((y2+s1).^2));

    figure
    if min([eq11pos, eq11neg, eq12pos, eq12neg]) == eq11pos || ...
            min([eq11pos, eq11neg, eq12pos, eq12neg]) == eq11neg
        subplot(2, 2, 1); plot(s1); title('Sinal original 1'); 
        subplot(2, 2, 2); plot(y1, 'r'); title('Estimativa 1'); 
        subplot(2, 2, 3); plot(s2); title('Sinal original 2');
        subplot(2, 2, 4); plot(y2, 'r'); title('Estimativa 2');
    else
        subplot(2, 2, 1); plot(s1); title('Sinal original 1');
        subplot(2, 2, 2); plot(y2, 'r'); title('Estimativa 1'); 
        subplot(2, 2, 3); plot(s2); title('Sinal original 2');
        subplot(2, 2, 4); plot(y1, 'r'); title('Estimativa 2');
    end
end

end