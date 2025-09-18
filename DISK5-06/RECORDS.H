type helper = string[255];
type weapons = record
idnum:byte; name:string[16]; melee:boolean;
dam:integer; numat: integer;
h2h:boolean; cost:integer; magical: integer; classrest:string[6];
end;
type potions = record idnum:byte; name:string[30]; cost:real; end;
type armors = record
idnum:byte; name:string[14]; protect:integer;
cost:integer; magical:integer; class_rest:string[6];
end;
type magic_staff = record
idnum:byte; name:string[30];
damage:integer; cost:real; spcost:integer;
success:integer;
end;
type monsters = record
idnum : byte; name : string[20]; minhp : byte; maxhp : integer;
numatt : byte; range : byte; spoints : integer;
maxdam:byte; minddam:byte; mis_mindam: byte; mis_maxdam:byte; Level : byte; Undead : boolean;
FAB : boolean; Armor_Class : byte; experience : integer; GPS:INTEGER; staff:byte;
end;
type monster_table = record
mon1 : byte; mon2 : byte;  mon3 : byte; mon4 : byte; amount:byte; end;
type stairs = record
fromlevel: byte; tolevel: byte;
fromxmap : byte; toxmap : byte;
fromymap : byte; toymap: byte;
fromxloc : byte; toxloc: byte;
fromyloc : byte; toyloc : byte;
end;
type character = record
name           : string[25];
Maxhitpoints   : integer;
Act_hitpoints  : integer;
act_spellpoints: integer;
level          : byte;
numatt         : byte;
food           : byte;
goldpieces     : real;
experience     : real;
Needed_exp     : real;
ArmorClass     : integer;
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
spells         : boolean;
Class          : integer;
stats          : array [1..8] of byte;
equipweapon    : weapons;
equiparmor     : armors;
equipmis       : weapons;
equipmagic     : magic_staff;
exemptions     : array [1..50] of byte; {For Conversations -- 40-4X is pot}
door_exemps    : array [1..255] of byte; {for dungeon encounters}
memory         : string[25];
total_moves    : real;
end;

conversation = record
   name   : string[20];
   descrip: string[60];
   greeter: string[72];
   later  : string[72];
   keys   : array [1..3] of string[12];
   resp_keys:array[1..3,1..3] of string[72];
   dunno  : string[72];
   toggles:array[1..3] of byte;
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
    pot      : boolean;
    gen      : boolean;
    tav      : boolean;
    x : byte;
    y : byte;
  end;

dun_rec = record
     dwords : array [1..3] of string[3];
     dnum   : byte;
     dlocx  : byte;
     dlocy  : byte;
     dname  : string[30];
     ttoggle: byte;
     wrong  : array[1..5] of byte;
     xmap   : byte;
     ymap   : byte;
     xactual: byte;
     yactual: byte;
   end;

dun_room = record
     dxmap:byte;
     dymap:byte;
     dlocx:byte;
     dlocy: byte;
     dencount : array [1..5] of byte;
     toggler : byte;
     special : byte;
end;

