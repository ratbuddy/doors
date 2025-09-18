program test;
type shit = record
shitter : integer;
end;

var filex : file of shit;
   test : shit;
begin
test.shitter:=30;
assign(filex,'Weather.inf');
rewrite(filex);
write(filex,test);
close(filex);
end.