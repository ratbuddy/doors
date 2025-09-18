program cplayers;
uses crt;
type table = record
      name : string[25];
      wins : word;
      losses : word;
      involved_in : char;
     end;

var dual_c,count:integer;
    table_var : table;
    table_file : file of table;
    high_file  : file of integer;
begin
textcolor(WHITE);
clrscr;
writeln('Greetings and Welcome to Pit Fiend IV Installer!');
writeln('What is the Maximum Number of People you have on your Board,');
writeln('in terms of user numbers?  It is suggested that you pick a ');
writeln('number, say 200 higher from the current level (depending upon ');
writeln('growth in your area.....');
write('Enter The Maximum Value Here:  ');
textcolor(yellow);
readln(dual_c);
if dual_c<50 then writeln('Hey, let''s be reasonable here!') else begin
table_var.name:='%';
table_var.wins:=0;
table_var.losses:=0;
table_var.involved_in:=' ';
assign(table_file,'TABLE.PIT');
rewrite(table_file);
for count:=1 to dual_c do
  write(table_file,table_var);
close(table_file);
assign(high_file,'HIGH.PIT');
rewrite(high_file);
write(high_file,count);
close(high_file);
writeln('Done Creating Table.Pit and High.Pit!');
writeln('Be sure to Register this, so that your BBS users');
writeln('can have more to play..... check out the installation');
writeln('Documents for details!');
writeln('Thanks again!');
writeln('and cya!');
end;
textcolor(WHITE);
end.