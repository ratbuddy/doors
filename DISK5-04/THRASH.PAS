program thrash;

var xfile: file of char;
    temp1,temp2 : char;
    mapper : array [1..78,1..23] of char;
    a,b,shit1,shit2:integer;
    name:string[12];
procedure mod_file;
begin
for shit1:=1 to 23 do
 for shit2:=1 to 78 do begin
   read(xfile,mapper[shit1,shit2]);
   if ord(mapper[shit1,shit2])=127 then mapper[shit1,shit2]:='§';
   write(mapper[shit1,shit2]);
end;
close(xfile);
end;

begin
for a:= 1 to 9 do
 for b:= 1 to 9 do  begin
 temp1:=chr(a+48);
 temp2:=chr(b+48);
 name:='Wilder'+temp1+temp2+'.PIT';
assign(xfile,name);
{$I-}
reset(xfile);
{$I+}
if IOResult = 0 then begin
   mod_file;
   {rewritefile}
end;
end;

end.