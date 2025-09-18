type table = record
name : string[25]; dun_lvl : byte; class:integer; level: byte; end;
type helper= string[80]; hectic = string[30];

type weapons = record
idnum:string[3]; name:string[20]; melee:boolean;
missile:boolean;dam:integer; numat: integer;
h2h:boolean; cost:integer; magical: integer; classrest:string[6];
end;
type potions = record idnum:byte; name:string[30]; cost:real; end;
type armors = record
idnum:string[3]; name:string[20]; protect:integer;
movemod:integer; cost:integer; magical:integer; class_rest:string[6];
end;
type magic_staff = record
idnum:string[3]; name:string[30];
damage:integer; cost:real; spcost:integer;
success:integer;
end;
type monsters = record
idnum : byte; name : string[20]; minhp : byte; maxhp : integer;
numatt : byte; range : byte; spoints : integer;
maxdam:byte; minddam:byte; mis_mindam: byte; mis_maxdam:byte; Level : byte; Undead : boolean;
FAB : boolean; Armor_Class : byte; experience : integer; GPS:INTEGER; staff:byte;
sp_name:string[20]; elf_hater : boolean; regen:byte; end;

type monster_table = record
mon1 : byte; mon2 : byte;  mon3 : byte; mon4 : byte; amount:byte; end;
type stairs = record
fromlevel: byte; tolevel: byte;
fromxmap : byte; toxmap : byte;
fromymap : byte; toymap: byte;
fromxloc : byte; toxloc: byte;
fromyloc : byte; toyloc : byte;
end;
type junker = record
name : string[20]; words : str; end;
type character_location = record
num : integer;
dungeon_level : integer;
xmaps : integer;
ymaps : integer;
xloc  : integer;
yloc  : integer;
end;

type character = record
name           : string[25];
Maxhitpoints   : integer;
Act_hitpoints  : integer;
act_spellpoints: integer;
level          : byte;
numatt         : byte;
goldpieces     : real;
experience     : real;
Needed_exp     : real;
ArmorClass     : integer;
dungeon_level  : byte;
xactual        : byte;
yactual        : byte;
xmap           : byte;
ymap           : byte;
spells         : boolean;
Class          : integer;
stats          : array [1..8] of byte;
bank           : real;
equipweapon    : weapons;
equiparmor     : armors;
equipshield    : armors;
equipmis       : weapons;
equipmagic     : magic_staff;
exemptions     : array [1..50] of byte;
end;