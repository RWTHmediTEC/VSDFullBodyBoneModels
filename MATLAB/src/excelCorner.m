function corner = excelCorner(row, col)

Stringvect = ('A':'Z');
NoS = length(Stringvect);

if col<=NoS
    corner = [Stringvect(col) num2str(row)];
elseif col>NoS && col<=NoS*2
    count=col-NoS;
    corner = ['A' Stringvect(count) num2str(row)];
elseif col>NoS*2 && col<=NoS*3
    count=col-NoS*2;
    corner = ['B' Stringvect(count) num2str(row)];
elseif col>=NoS*3 && col<=NoS*4
    count=col-NoS*3;
    corner = ['C' Stringvect(count) num2str(row)];
else
    error('Count limit exceeds than what is defined, please define higher limits in code!');
end

end