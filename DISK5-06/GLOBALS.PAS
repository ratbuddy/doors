unit globals;

interface
{$I records.h}
var player: character;
dialcnt : integer; dung_room : array [1..75] of dun_room;
ginput:char; potion_array:array [1..8] of potions;
exitter,doner,general: boolean;
stat_name: array[1..11] of string[15]; act_stats:array[1..5] of byte;
time_expander:boolean;
town_stuff : town_rec; dungeon_stuff : dun_rec;
class_name: array[1..6] of string[15];
weapon:array [0..10] of weapons;
armor:array [0..5] of armors;
magici:array [0..10] of magic_staff;
monster_array:array [1..50] of monsters; {monster 50 is a character!}
map : array [-5..85,-5..28] of char;
auto_map : array [0..79,0..24] of char;
moves : integer; modder:integer;
implementation
end.