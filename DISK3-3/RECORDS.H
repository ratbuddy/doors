type bogus=array[1..3,1..16] of integer;
type combat_init= array [1..4] of byte;
type helper = string[75];
type uv=string[25];
type items = record
 idnum:byte;
 name:string[30];
 cost:real;
 magical:byte;
 testers:boolean;
 mindam: byte;
 maxdam:byte;
 charges:byte;
 protect:byte;
 numat:integer;
 end;

type monsters = record
name : string[20]; minhp : integer; maxhp : integer;
numat : byte; range : byte; spoints : integer;
maxdam:byte; mindam:byte; mis_mindam: byte; mis_maxdam:byte;
Level : byte; Undead : boolean; speed:byte;
Armor_Class : byte; experience:integer; GPS:INTEGER; staff:byte;
regen:byte;
drainer:boolean;
poison:byte;
end;

type monster_set = record
  armor_class:byte;
  hpsleft:array [1..10] of integer;
  numat:byte;
  range:byte;
  spoints: array [1..10] of integer;
  maxdam:byte;
  mindam:byte;
  mis_mindam:byte;
  mis_maxdam:byte;
  level:byte;
  staff:byte;
  com_loc:array [1..10] of boolean;  {True = Missile -- Melee = False}
  mis_amnt:byte;
  mel_amnt:byte;
  speed:byte;
end;

type monster_table = record
typs:combat_init;
howm:combat_init;
end;

type character = record
name           : array [1..3] of string[25];
food           : array [1..3] of byte;
experience     : array [1..3,1..2] of real;
goldpieces     : real;
outdoor        : boolean;
city           : boolean;
dungeon        : boolean;
dungeon_level  : byte;
outxact        : byte;
outyact        : byte;
outxmap        : byte;
outymap        : byte;
xactual        : byte;
yactual        : byte;
xmap           : byte;
ymap           : byte;
spells         : array [1..3] of boolean;
stats          : bogus;
idnum          : array [1..3] of byte;
equippotions   : array [1..3,1..10] of BYTE;
equipweapon    : array [1..3] of items;
equiparmor     : array [1..3] of items;
equipmis       : array [1..3] of items;
equipring      : array [1..3] of items;
status         : array [1..3] of byte;
exemptions     : array [1..50] of byte;
door_exemps    : array [1..255] of byte; {for dungeon encounters}
memory         : string[25];
total_moves    : real;
class_name     : array [1..3] of string[15];
end;

town_rec = record
city_num : byte;
num_conv : byte;
City_name: string[20];
tav_name : string[20];
gen_name : string[20];
pot_name : string[20];
price_mod : byte;
port     : boolean;
chars    : boolean;
gen      : boolean;
temple   : boolean;
x : byte;
y : byte;
end;

dun_rec = record
dwords : array [1..3] of string[3];
nilword: boolean;
dnum   : byte;
dlocx  : byte;
dlocy  : byte;
dname  : string[30];
ttoggle: byte;
xmap   : byte;
ymap   : byte;
xactual: byte;
yactual: byte;
end;

dun_room = record
dxmap:byte;
dymap:byte;
dlocx:byte;
dlocy:byte;
whatkind:combat_init;
howmany:combat_init;
toggler: byte;
special: byte;
food   : byte;
scroll : boolean;
scrollsay : helper;
amount:integer;
itemnum:byte;
quant:byte;
end;


