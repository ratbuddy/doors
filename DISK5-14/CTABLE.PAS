program ctable;
type table = record
name : string[25];
level : byte;
tm   : real;
WINNER: BOOLEAN;
end;

var x : integer; ftab : file of table; ftabber: array [1..750] of table;
begin
assign(ftab,'TABLE.DAT');
rewrite(ftab);
for x:=1 to 750 do begin
  ftabber[x].name:='                               ';
  ftabber[x].level:=0;
  ftabber[x].tm:=0.0;
  FTABBER[X].WINNER:=FALSE;
  write(ftab,ftabber[x]);
end;
close(ftab);
end.