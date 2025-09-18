program cplayers;
uses crt;
type table = record
      name : string[25];
      points : longint;
     end;

var count,dual_c:integer;
    table_var : table;
    table_file : file of table;
    high_file  : file of integer;
begin
textcolor(WHITE);
clrscr;
writeln('Greetings and Welcome to Pit Fiend V Installer!');
writeln('What is the Maximum Number of People you have on your Board,');
writeln('in terms of user numbers?  It is suggested that you pick a ');
writeln('number, say 200 higher from the current level (depending upon ');
writeln('growth in your area..... ');
writeln('Choosing a Value to low may result in some players not being able');
writeln('to play or having to reroll the game so that they may be able to');
writeln('play.  Each user requires approximately 30 bytes of disk storage.');
write('Enter The Maximum Value Here:  ');
textcolor(yellow);
readln(dual_c);
if dual_c<50 then writeln('Hey, let''s be reasonable here!') else begin
table_var.name:='%';
table_var.points:=0;
assign(table_file,'TABLE.PIT');
rewrite(table_file);
for count:=1 to dual_c do
  write(table_file,table_var);
close(table_file);
writeln('Done Creating Table.Pit!');
writeln('Be sure to Register this, so that your BBS users');
writeln('can have more to play..... check out the installation');
writeln('Documents for details!');
writeln('Thanks again!');
writeln('and cya!');
end;
textcolor(WHITE);
end.