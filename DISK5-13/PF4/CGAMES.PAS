program cgames;
type games = record
      names: array [1..4] of string[25];
      lastons: array [1..4,1..3] of word;
      races: array [1..4] of byte;
    end;
var game_file : file of games;
    game_var : games;
    count,cnt2:byte;

begin
for count:=1 to 4 do begin
  game_var.names[count]:='%';
  game_var.races[count]:=0;
  for cnt2:=1 to 3 do
     game_var.lastons[count,cnt2]:=0;
end;
assign(game_file,'GAMES.PIT');
rewrite(game_file);
for count:=1 to 26 do
 write(game_file,game_var);
close(game_file);
end.