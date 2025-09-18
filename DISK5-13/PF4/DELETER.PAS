program deleter;
uses common;
CONST MAX_GAME = 26;
type games = record
  names: array [1..4] of string[25];
  lastons: array [1..4,1..3] of word;
  races:array [1..4] of byte;
end;
var gamefile : file of games;
    game_var  : array [1..MAX_GAME] of games;
    count,ct2: integer;
    chx      : char;

procedure view_master;
begin
assign(gamefile,'GAMES.PIT');
{$I-} reset(gamefile); {$I+}
if IOResult<>0 then begin
    talknl(8,'GAMES.PIT is missing or damaged!');
    halt;
    end;
for count:=1 to MAX_GAME do begin
   read(gamefile,game_var[count]);
   talknl(0,'Game '+chr(count+64));
   for ct2:=1 to 4 do
     writeln('Player #',ct2,' is '+game_var[count].names[ct2]);
   if count mod 3=0 then begin pausescr; writeln; end;
 end;
close(gamefile);
end;

procedure deletera;
var hom1:char; storage: byte; fileb:file of byte; fucker:file of games;
begin
talk(4,'Which Game do you want do DELETE: (A-'+chr(MAX_GAME+64)+'): ');
onek(hom1,'0ABCDEFGHIJKLMNOPQRSTUVWXYZ');
if hom1<>'0' then begin
talk(8,'Are you sure you want to DELETE game : '+hom1+'? (Y/N): ');
  if ynq then begin
  storage:=ord(hom1)-64;
    for count:=1 to 4 do begin
     game_var[storage].names[count]:='%';
     game_var[storage].races[count]:=0;
     for ct2:=1 to 3 do
       game_var[storage].lastons[count,ct2]:=0;
    end;
  assign(fucker,'GAMES.PIT');

  rewrite(fucker);
  for count:=1 to MAX_GAME do
   write(fucker,game_var[count]);
  close(fucker);
  assign(fileb,'GAME'+hom1+'.SAV');
{$I-}  reset(fileb); {$I+}
  if IOResult=0 then begin close(fileb);  erase(fileb); end;
  assign(fileb,'MESS'+hom1+'.SAV');
{$I-}  reset(fileb); {$I+}
 if IOResult=0 then begin close(fileb); erase(fileb); end;
  end;
end;
end;

begin
ansic(0); prompt(' ');
cls;
assign(gamefile,'GAMES.PIT');
reset(gamefile);
for count:=1 to MAX_GAME do
  read(gamefile,game_var[count]);
close(gamefile);
repeat
writeln('Welcome to Pit Fiend IV Game Terminator');
writeln('Choices');
writeln('(D)elete a Game');
writeln('(Q)uit DELETER');
writeln('(V)iew all Games');
talk(3,'Choice (DQV): ');
onek(chx,'DQV');
case chx of
 'D' : deletera;
 'V' : view_master;
end;
until chx='Q'
end.
