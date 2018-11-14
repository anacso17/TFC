function valor_esperado_produtodevas = E_pva(x1, x2)

valor_esperado_produtodevas = [];
for i = 1:size(x1,1)
    for j = 1:size(x2,1)
        valor_esperado_produtodevas(i,j) = x1(i,:)*x2(j,:)';
    end
end

valor_esperado_produtodevas = valor_esperado_produtodevas/length(x1);

end