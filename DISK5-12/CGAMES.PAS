program cgames;
uses common;
type game = record
  names: array [1..4] of string[25];
  usernum: array [1..4] of integer;
  lastons: array [1..4,1..3] of word;
end;
var game_file : file of game;
    game_ar   : array [1..26] of game;
    cnt,count : integer;
begin
for cnt:=1 to 4 do
  for count:=1 to 26 do game_ar[count].names[cnt]:='%';
assign(game_file,'GAMES.PIT');
rewrite(game_file);
for count:=1 to 26 do write(game_file,game_ar[count]);
close(game_File);
end.
