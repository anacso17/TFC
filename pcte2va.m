function produto = pcte2va(cte, va)

produto = 0;
for i = 1:size(cte,1)
    produto = produto + cte(i)*va(i,:);
end

end