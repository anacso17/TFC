function erro = Amari(A, V, W)

P = W*V*A;
n = size(P,1);

soma1 = 0;
for i=1:1:size(P,1)
    aux = sum(abs(P(i,:)))/max(abs(P(i,:))) - 1;
    soma1 = soma1 + aux;
end

soma2 = 0;
for j=1:1:size(P,2)
    aux = sum(abs(P(:,j)))/max(abs(P(:,j))) - 1;
    soma2 = soma2 + aux;
end

erro = (soma1 + soma2)/(2*n*(n-1));

end