function [W, Iteracoes] = FastICA(z, metodo, metrica, e)

% Método:  1 - Deflação
%          2 - Simétrico
% Métrica: 1 - Curtose
%          2 - Negentropia

% Define a função g a ser usada para negentropia
g = @(x) x.*exp(-x.^2/2);
g_der = @(x) (1 - x.^2).*exp(-x.^2/2);

if metodo == 1  % Deflação
    Iteracoes = [];
    W = eye(size(z,1));

    for p = 1:size(z,1)
        i = 0;
 
        % Escolha um w randômicamente
        w_p = W(p, :);
 
        while 1
            % Faz um passo em w
            if metrica == 1  % Curtose
                w_p = E_pva(z,pcte2va(w_p',z).^3)' - 3*w_p;
            elseif metrica == 2  % Negentropia
                aux1 = g(pcte2va(w_p',z));
                aux2 = g_der(pcte2va(w_p',z));
                w_p = E_pva(z,aux1)' - w_p*mean(aux2);
            end

            % Ortogonaliza em relação aos w existentes
            if p > 1
                for j = 1:size(W,1)-1
                    w_p = w_p - (dot(w_p, W(j,:))/dot(w_p, w_p))*w_p;
                end
            end
 
            % Normaliza w
            w_p = w_p/norm(w_p);

            i = i + 1;
            % Verifica convergência
            if ((dot(W(p,:), w_p) > (1 - e)) && (dot(W(p,:), w_p) < (1 + e))) || ...
                    ((dot(W(p,:), w_p) > (-1 - e)) && (dot(W(p,:), w_p) < (-1 + e))) || ...
                    i >= 100
                W(p,:) = w_p;
                break
            else
                W(p,:) = w_p;
            end
            
        end
        Iteracoes(p) = i;
    end

elseif metodo == 2  % Simétrico
    % Escolha todas as w randômicamente
    W = eye(size(z,1));

    % Ortogonaliza W
    W = ((W*W')^(-0.5))*W;

    i = 0;
    while 1
        W_old = W;

        % Para o número de fontes
        for p = 1:size(z,1)
            % Faz um passo em w
            if metrica == 1  % Curtose
                W(p,:) = E_pva(z,pcte2va(W(p,:)',z).^3)' - 3*W(p,:);
            elseif metrica == 2  % Negentropia
                aux1 = g(pcte2va(W(p,:)',z));
                aux2 = g_der(pcte2va(W(p,:)',z));
                W(p,:) = E_pva(z,aux1)' - W(p,:)*mean(aux2);
            end
        end
 
        % Faz uma ortogonalização de W
        W = ((W*W')^(-0.5))*W;

        % verificar covergência
        conv = 0;
        for c = 1:size(W,2)
            if ((dot(W(c,:), W_old(c,:)) > (1 - e)) && (dot(W(c,:), W_old(c,:)) < (1 + e))) || ...
                    ((dot(W(c,:), W_old(c,:)) > (-1 - e)) && (dot(W(c,:), W_old(c,:)) < (-1 + e)))
                conv = conv + 1;
            end
        end
        i = i + 1;
        if (conv == 2) || (i >= 100)
            break
        end
    end
    Iteracoes = i;
end

end