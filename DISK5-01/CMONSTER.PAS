program cmonsters;
{This program will create a file of monsters for levels one and 2.  Damn,
not another one of these things.  Anyhow, its one big record that creates'
a DAT file.  adios 12/15/1989}
const maxinfile = 68;
type monstertype  = record
         idnum   : byte;
         name    : string[20];
         minhp   : integer;
         maxhp   : integer;
         numatt  : byte;
         range   : byte;   {percentage of a missile weapon}
         spoints : integer;
       maxdamage : byte;
       mindamage : byte;
      mis_mindam : byte;
      mis_maxdam : byte;
         level   : byte;
         undead  : boolean;
         FAB     : BOOLEAN;
      Armor_Class: byte;
      experience : integer;
      gps        : integer;
      STAFF      : BYTE;
      sp_name    : string[20];
      elf_hater  : boolean;
      regen      : byte;
      drainer    : boolean;
      end;

var monster:array [1..maxinfile] of monstertype;
    counter: integer;
    filevar: file of monstertype;
begin
for counter := 1 to maxinfile do monster[counter].name:='                    ';
for counter := 1 to maxinfile do monster[counter].idnum:=counter;
for counter:=1 to maxinfile do monster[counter].spoints:=0;
for counter:=1 to maxinfile do monster[counter].staff:=1;
for counter:=1 to maxinfile do monster[counter].undead:=false;
for counter:=1 to maxinfile do monster[counter].FAB :=false;
for counter:=1 to maxinfile do monster[counter].range:=0;
for counter:=1 to maxinfile do monster[counter].sp_name:='                    ';
for counter:=1 to maxinfile do monster[counter].elf_hater:=false;
for counter:=1 to maxinfile do monster[counter].regen:=0;
for counter:=1 to maxinfile do monster[counter].drainer:=false;
with monster[1] do begin
    name:='KOBOLD';
    minhp:=3; maxhp:=7;  numatt:=1; range:=35;
    maxdamage:=6; mindamage:=1; mis_mindam:=1; mis_maxdam:=6;
    level:=1; armor_class:=3; experience:=15; gps:=8;
    elf_hater:=true; end;

with monster[2] do begin
     name:='SPIDER';
    minhp:=3; maxhp:=8;  numatt:=1; range:=0;
    maxdamage:=6; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=1; armor_class:=3; experience:=10; gps:=5; end;

with monster[3] do begin
     name:='SKELETON';
    minhp:=3; maxhp:=7;  numatt:=1; range:=35;
    maxdamage:=6; mindamage:=1; mis_mindam:=1; mis_maxdam:=6;
    level:=1; armor_class:=5; experience:=15; gps:=10; UNDEAD:=TRUE; end;

with monster[4] do begin
     name:='ZOMBIE';
    minhp:=8; maxhp:=15; numatt:=2; range:=0;
    maxdamage:=8; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=2; armor_class:=2; experience:=25; gps:=5; UNDEAD:=TRUE; end;

with monster[5] do begin
     name:='MAD THIEF';
    minhp:=5; maxhp:=15;  numatt:=1; range:=50;
    maxdamage:=8; mindamage:=1; mis_mindam:=1; mis_maxdam:=6;
    level:=2; armor_class:=4; experience:=35; gps:=20; FAB:=TRUE; end;

with monster[6] do begin
     name:='GOBLIN';
    minhp:=3; maxhp:=10;  numatt:=1; range:=45;
    maxdamage:=8; mindamage:=1; mis_mindam:=1; mis_maxdam:=6;
    level:=1; armor_class:=4; experience:=15; gps:=10;
    elf_hater:=true; end;

with monster[7] do begin
     name:='GIANT RAT' ;
    minhp:=3; maxhp:=5;  numatt:=1; range:=0;
    maxdamage:=6; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=1; armor_class:=2; experience:=5; gps:=5; end;

with monster[8] do begin
     name:='LOWLY ELF'   ;
    minhp:=13; maxhp:=20;  numatt:=2; range:=50;
    maxdamage:=6; mindamage:=1; mis_mindam:=1; mis_maxdam:=10;
    level:=2; armor_class:=5; experience:=50; gps:=25; STAFF:=1; SPOINTS:=35;
    sp_name:='Casts Fire Dart'; end;

with monster[9] do begin
     name:='BANDIT';
    minhp:=8; maxhp:=12;  numatt:=2; range:=50;
    maxdamage:=8; mindamage:=1; mis_mindam:=1; mis_maxdam:=6;
    level:=2; armor_class:=5; experience:=35; gps:=25; fab:= TRUE; end;

with monster[10] do begin
     name:='BLACK MAGICIAN';
    minhp:=18; maxhp:=25;  numatt:=1; range:=0;
    maxdamage:=4; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=4; armor_class:=5; experience:=50; gps:=25; STAFF:=2; SPOINTS:=50;
    sp_name:='Casts Tiny Fireball';
    end;

with monster[11] do begin
     name:='LARGE SNAKE';
    minhp:=6; maxhp:=12;  numatt:=1; range:=0;
    maxdamage:=6; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=2; armor_class:=6; experience:=25; gps:=5; end;

with monster[12] do begin
     name:='HOBGOBLIN';
    minhp:=15; maxhp:=20;  numatt:=2; range:=65;
    maxdamage:=10; mindamage:=1; mis_mindam:=1; mis_maxdam:=8;
    level:=4; armor_class:=7; experience:=35; gps:=25;
    elf_hater:=true; end;

with monster[13] do begin
     name:='SKELETAL WARRIOR'  ;
    minhp:=35; maxhp:=45;  numatt:=2; range:=65;
    maxdamage:=12; mindamage:=3; mis_mindam:=3; mis_maxdam:=8;
    level:=7; armor_class:=10; experience:=75; gps:=50; UNDEAD:=TRUE; end;

with monster[14] do begin
     name:='ORC LEADER';
    minhp:=25; maxhp:=35;  numatt:=1; range:=90;
    maxdamage:=12; mindamage:=1; mis_mindam:=1; mis_maxdam:=8;
    level:=3; armor_class:=7; experience:=35; gps:=50;
    elf_hater:=true; end;

with monster[15] do begin
     name:='LIZARDMAN'           ;
    minhp:=7; maxhp:=15;  numatt:=3; range:=25;
    maxdamage:=5; mindamage:=1; mis_mindam:=1; mis_maxdam:=4;
    level:=3; armor_class:=6; experience:=35; gps:=15; end;

with monster[16] do begin
     name:='TROLL'              ;
    minhp:=60; maxhp:=70; numatt:=3; range:=0;
    maxdamage:=24; mindamage:=4; mis_mindam:=0; mis_maxdam:=0;
    level:=12; armor_class:=10; experience:=200; gps:=125; regen:=6; end;

with monster[17] do begin
     name:='GIANT'               ;
    minhp:=190; maxhp:=225;  numatt:=2; range:=35;
    maxdamage:=60; mindamage:=24; mis_mindam:=5; mis_maxdam:=20;
    level:=20; armor_class:=14; experience:=1000; gps:=500; end;

with monster[18] do begin
     name:='NEUROMANCER';
    minhp:=36; maxhp:=45;  numatt:=2; range:=0;
    maxdamage:=4; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=9; armor_class:=7; experience:=250; gps:=100; STAFF:=4; SPOINTS:=125;
    sp_name:='Casts Large Fireball'; end;

with monster[19] do begin
     name:='OGRE';
    minhp:=44; maxhp:=54;  numatt:=1; range:=25;
    maxdamage:=18; mindamage:=12; mis_mindam:=4; mis_maxdam:=10;
    level:=7; armor_class:=8; experience:=225; gps:=125; end;

with monster[20] do begin
     name:='ORC CAPTAIN';
    minhp:=54; maxhp:=65; numatt:=2; range:=85;
    maxdamage:=24; mindamage:=8; mis_mindam:=1; mis_maxdam:=10;
    level:=8; armor_class:=9; experience:=230; gps:=75;
    elf_hater:=true; end;

with monster[21] do begin
    name:='ANKHEG';
    minhp:=70; maxhp:=90; numatt:=3; range:=0;
    maxdamage:=20; mindamage:=6; mis_mindam:=0; mis_maxdam:=0;
    level:=8; armor_class:=12; experience:=400; gps:=125;
    spoints:=120; staff:=4;
    sp_name:='Spits Acid'; end;

with monster[22] do begin
     name:='FLESH GOLEM';
    minhp:=80; maxhp:=96;  numatt:=2; range:=0;
    maxdamage:=36; mindamage:=12; mis_mindam:=0; mis_maxdam:=0;
    level:=12; armor_class:=5; experience:=550; gps:=1; end;

with monster[23] do begin
     name:='STONE GOLEM';
    minhp:=125; maxhp:=150; numatt:=2; range:=0;
    maxdamage:=40; mindamage:=20; mis_mindam:=0; mis_maxdam:=0;
    level:=15; armor_class:=21; experience:=1250; gps:=1;
    regen:=4; end;

with monster[24] do begin
     name:='EVIL PRIEST';
    minhp:=100; maxhp:=120;  numatt:=3; range:=0;
    maxdamage:=40; mindamage:=8; mis_mindam:=0; mis_maxdam:=0;
    level:=17; armor_class:=15; experience:=1250; gps:=600; STAFF:=7; SPOINTS:=190;
    sp_name:='Casts Extreme Pain'; end;

with monster[25] do begin
     name:='DARK MAGICIAN';
    minhp:=65; maxhp:=85;  numatt:=1; range:=0;
    maxdamage:=8; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=12; armor_class:=7; experience:=1500; gps:=750; STAFF:=7; SPOINTS:=225;
    sp_name:='Casts a Death Spell'; end;

with monster[26] do begin
     name:='MINOTAUR';
    minhp:=70; maxhp:=85;  numatt:=3; range:=0; FAB:=TRUE;
    maxdamage:=20; mindamage:=8; mis_mindam:=0; mis_maxdam:=0;
    level:=9; armor_class:=12; experience:=250; gps:=80; end;

with monster[27] do begin
     name:='GIANT LIZARD';
    minhp:=55; maxhp:=75;  numatt:=2; range:=0;
    maxdamage:=18; mindamage:=8; mis_mindam:=0; mis_maxdam:=0;
    level:=6; armor_class:=7; experience:=300; gps:=10; end;

with monster[28] do begin
     name:='JACKAL';
    minhp:=5; maxhp:=10;  numatt:=2; range:=0;
    maxdamage:=4; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=1; armor_class:=2; experience:=5; gps:=1; end;

with monster[29] do begin
     name:='PIT FIEND';
    minhp:=1255; maxhp:=1550;  numatt:=2; range:=0; FAB:=TRUE; STAFF:=10; SPOINTS:=300;
    maxdamage:=120; mindamage:=60; mis_mindam:=0; mis_maxdam:=0;
    level:=65; armor_class:=40; experience:=32000; gps:=20000;
    sp_name:='Chants a Doom Song'; regen:=25;
    end;

with monster[30] do begin
     name:='CYCLOPS';
    minhp:=275; maxhp:=300;  numatt:=2; range:=50; regen:=5;
    maxdamage:=80; mindamage:=40; mis_mindam:=10; mis_maxdam:=80;
    level:=22; armor_class:=26; experience:=1000; gps:=10000; end;

With monster[31] do begin
     name:='HELL HOUND';
    minhp:=45; maxhp:=65; numatt:=2; range:=0;
    maxdamage:=18; mindamage:=6; mis_mindam:=0; mis_maxdam:=0;
    level:=6; armor_class:=8; experience:=125; gps:=55; staff:=2;
    spoints:=40;
    sp_name:='Breathes Fire';
    end;

With monster[32] do begin
     name:='EXPERT ARCHER';
    minhp:=160; maxhp:=200;  numatt:=4; range:=100;
    maxdamage:=30; mindamage:=15; mis_mindam:=12; mis_maxdam:=40;
    level:=20; armor_class:=17; experience:=1255; gps:=255; end;

With monster[33] do begin
     name:='AMATEUR ARCHER';
    minhp:=35; maxhp:=45;  numatt:=2; range:=100;
    maxdamage:=8; mindamage:=1; mis_mindam:=4; mis_maxdam:=12;
    level:=6; armor_class:=8; experience:=135; gps:=125; end;

With monster[34] do begin
     name:='KOBOLD LEADER';
    minhp:=10; maxhp:=18;  numatt:=2; range:=25;
    maxdamage:=8; mindamage:=3; mis_mindam:=2; mis_maxdam:=6;
    level:=2; armor_class:=4; experience:=45; gps:=35;
    elf_hater:=true; end;

With monster[35] do begin
     name:='KOBOLD CHIEF';
    minhp:=18; maxhp:=24;  numatt:=2; range:=50; elf_hater:=true;
    maxdamage:=12; mindamage:=1; mis_mindam:=1; mis_maxdam:=6;
    level:=3; armor_class:=6; experience:=125; gps:=75; end;

With monster[36] do begin
     name:='KOBOLD SHAMAN';
     minhp:=11; maxhp:=18;  numatt:=1; range:=0;
    maxdamage:=4; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=3; armor_class:=6; experience:=75; gps:=45; STAFF:=1; SPOINTS:=20;
    sp_name:='Casts Sharp Pain'; elf_hater:=true; end;

With monster[37] do begin
     name:='DWARF WARRIOR';
     minhp:=35; maxhp:=45;  numatt:=2; range:=0;
    maxdamage:=20; mindamage:=4; mis_mindam:=0; mis_maxdam:=0;
    level:=5; armor_class:=9; experience:=125; gps:=40; elf_hater:=true; end;

With monster[38] do begin
     name:='DWARF LEADER';
     minhp:=45; maxhp:=60;  numatt:=2; range:=0;
    maxdamage:=25; mindamage:=8; mis_mindam:=0; mis_maxdam:=0;
    level:=7; armor_class:=10; experience:=435; gps:=125; elf_hater:=true; end;

With monster[39] do begin
     name:='XEVIOR';
     minhp:=500; maxhp:=525;  numatt:=3; range:=0; FAB:=TRUE;
    maxdamage:=120; mindamage:=60; mis_mindam:=0; mis_maxdam:=0;
    level:=31; armor_class:=26; experience:=6000; gps:=43;
    end;

With monster[40] do begin
     name:='FIRE DRAGON';
     minhp:=225; maxhp:=250;  numatt:=6; range:=0; STAFF:=6; SPOINTS:=155;
    maxdamage:=20; mindamage:=10; mis_mindam:=0; mis_maxdam:=0;
    level:=22; armor_class:=18; experience:=2250; gps:=1000;
    sp_name:='Breathes Fire'; end;

With monster[41] do begin
     name:='DEATH ANGEL';
     minhp:=350; maxhp:=400;  numatt:=2; range:=0; STAFF:=8; SPOINTS:=300;
    maxdamage:=40; mindamage:=24; mis_mindam:=0; mis_maxdam:=0;
    level:=30; armor_class:=16; experience:=8500; gps:=666;
    sp_name:='Casts Song of Death'; drainer:=true; end;

With monster[42] do begin
     name:='BANDIT LEADER';
     minhp:=90; maxhp:=100;  numatt:=2; range:=50; FAB:=TRUE;
        maxdamage:=28; mindamage:=12; mis_mindam:=3; mis_maxdam:=15;
    level:=11; armor_class:=16; experience:=850; gps:=300; end;

With monster[43] do begin
     name:='BAT-BIRDS';
     minhp:=3; maxhp:=8;  numatt:=2; FAB:=TRUE;
        maxdamage:=4; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=1; armor_class:=5; experience:=15; gps:=1; end;

With monster[44] do begin
     name:='KILLER SHREW';
     minhp:=25; maxhp:=35;  numatt:=2; FAB:=TRUE;
        maxdamage:=15; mindamage:=2; mis_mindam:=0; mis_maxdam:=0;
    level:=4; armor_class:=7; experience:=100; gps:=25; end;

With monster[45] do begin
     name:='ORC';
     minhp:=4; maxhp:=12;  numatt:=1; FAB:=false;  range:=45;
     maxdamage:=10; mindamage:=3; mis_mindam:=1; mis_maxdam:=6;
    level:=2; armor_class:=5; experience:=25; gps:=15;
    elf_hater:=true; end;

With monster[46] do begin
     name:='BAT-BIRDS';
     minhp:=3; maxhp:=8;  numatt:=2; FAB:=TRUE;
        maxdamage:=4; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
    level:=1; armor_class:=5; experience:=15; gps:=1; end;

With monster[47] do begin
     name:='CRYPT THING';
     minhp:=35; maxhp:=44;  numatt:=1; FAB:=FALSE; undead:=true;
        maxdamage:=20; mindamage:=4; mis_mindam:=0; mis_maxdam:=0;
    level:=4; armor_class:=8; experience:=125; gps:=50;
    drainer:=true; end;

With monster[48] do begin
     name:='GUARDIAN DRUID';
     minhp:=35; maxhp:=45;  numatt:=2; range:=35; staff:=3; spoints:=60;
     maxdamage:=18; mindamage:=4; mis_mindam:=1; mis_maxdam:=4;
     sp_name:='Warp Enemy';
     level:=3; armor_class:=10; experience:=125; gps:=75; end;

With monster[49] do begin
     name:='NITE ANGEL';
     minhp:=200; maxhp:=225;  numatt:=2; FAB:=TRUE; range:=0;
        maxdamage:=60; mindamage:=15; mis_mindam:=0; mis_maxdam:=0;
    level:=14; armor_class:=18; experience:=2000; gps:=1000;
    staff:=7; spoints:=255; sp_name:='Casts "Moonshock"'; UNDEAD:=TRUE;
    end;

With monster[50] do begin
     name:='NO MONSTER'; range:=0;
     minhp:=0; maxhp:=0;  numatt:=0; FAB:=FALSE;
        maxdamage:=0; mindamage:=0; mis_mindam:=0; mis_maxdam:=0;
    level:=0; armor_class:=0; experience:=0; gps:=0; end;

With monster[51] do begin
     name:='WATER SERPENT'; range:=0;
     minhp:=55; maxhp:=65;  numatt:=1; FAB:=true;
        maxdamage:=25; mindamage:=12; mis_mindam:=0; mis_maxdam:=0;
    level:=6; armor_class:=8; experience:=200; gps:=200; end;

With monster[52] do begin
     name:='DWARVEN CLERIC'; range:=0;
     minhp:=60; maxhp:=70;  numatt:=3; FAB:=FALSE; spoints:=90;
     staff:=4; sp_name:='Spiritual Axe';
     maxdamage:=10; mindamage:=1; mis_mindam:=0; mis_maxdam:=0;
     level:=9; armor_class:=12; experience:=400; gps:=200; end;

with monster[53] do begin
     name:='WRAITH'; range:=0;
     minhp:=50; maxhp:=60; numatt:=1; FAB:=true; mis_maxdam:=0;
     mis_mindam:=0; level:=7; mindamage:=15; maxdamage:=25; undead:=true;
     armor_class:=11; experience:=600; gps:=150; regen:=3; drainer:=true; end;

with monster[54] do begin
     name:='EVIL SWORDSMAN'; numatt:=2; fab:=false; mis_maxdam:=6;
     mis_mindam:=0; range:=50; level:=12; mindamage:=4; maxdamage:=24;
     minhp:=120; maxhp:=140;
     armor_class:=14; experience:=750; gps:=250; end;

with monster[55] do begin
     name:='HUGE SPIDER'; numatt:=3; fab:=true; range:=0;
     mis_maxdam:=0; mis_mindam:=0; range:=0; level:=8; mindamage:=7;
     maxdamage:=21; armor_class:=8; experience:=300; gps:=50;
     minhp:=75; maxhp:=85; end;

with monster[56] do begin
     name:='WANTED THIEF'; numatt:=3; fab:=true; range:=75;
     mis_maxdam:=10; mis_mindam:=1; level:=5; minhp:=50; maxhp:=65;
     maxdamage:=18; mindamage:=6; armor_class:=9; experience:=650;
     gps:=50; end;
with monster[57] do begin
     name:='BARBARIAN'; numatt:=3; fab:=false; range:=15;
     mis_maxdam:=12; mis_mindam:=2; level:=12; minhp:=125; maxhp:=175;
     maxdamage:=35; mindamage:=8; armor_class:=8; experience:=600;
     gps:=75; end;

with monster[58] do begin
     name:='DWARF CAPTAIN'; numatt:=2; fab:=false; range:=15;
     mis_maxdam:=6; mis_mindam:=1; level:=12; maxdamage:=30; mindamage:=10;
     minhp:=100; maxhp:=125; elf_hater:=true;
     armor_class:=11; experience:=850;
     gps:=400; end;

with monster[59] do begin
     name:='WANDERING WITCH'; numatt:=1; range:=50;
     mis_maxdam:=4; mis_mindam:=1; level:=9; maxdamage:=4;
     mindamage:=1; armor_class:=5; spoints:=120; staff:=5;
     sp_name:='Cold Power Burst'; minhp:=50; maxhp:=55;
     gps:=575; experience:=850; end;

with monster[60] do begin
     name:='CARYATID COLUMN'; numatt:=3;  range:=25;
     mis_maxdam:=6; mis_mindam:=1; level:=8; maxdamage:=14;
     mindamage:=4; armor_class:=12; regen:=2;
     Minhp:=40; maxhp:=55;
     gps:=1; experience:=300; end;

with monster[61] do begin
     name:='PERYTON'; numatt:=2; fab:=FALSE; range:=0;
     mis_maxdam:=10; mis_mindam:=1; level:=8; maxdamage:=16;
     mindamage:=6; armor_class:=9; regen:=2;
     Minhp:=50; maxhp:=55;
     gps:=215; experience:=350; end;

with monster[62] do begin
     name:='LESSER DEMON'; numatt:=2; fab:=FALSE; range:=0;
     mis_maxdam:=15; mis_mindam:=3; level:=12; maxdamage:=20;
     mindamage:=9; armor_class:=9; regen:=2; UNDEAD:=TRUE;
     Minhp:=90; maxhp:=125; staff:=3; spoints:=60; sp_name:='Unholy Curse';
     gps:=411; experience:=750; end;

With monster[63] do begin
     name:='ELITE DWARF';
     minhp:=100; maxhp:=140;  numatt:=2; range:=25;
    maxdamage:=36; mindamage:=15; mis_mindam:=2; mis_maxdam:=16;
    level:=11; armor_class:=15; experience:=825; gps:=240; elf_hater:=true; end;

With monster[64] do begin
     name:='ELITE D. LEADER';
     minhp:=140; maxhp:=160;  numatt:=3; range:=25; staff:=0; spoints:=0;
    maxdamage:=50; mindamage:=27; mis_mindam:=12; mis_maxdam:=24;
    level:=14; armor_class:=16; experience:=1525; gps:=740; elf_hater:=true; end;

with monster[65] do begin
     name:='ELITE D. CAPTAIN'; numatt:=4; range:=50;
     mis_maxdam:=30; mis_mindam:=12; level:=18; maxdamage:=60; mindamage:=20;
     minhp:=160; maxhp:=220;  elf_hater:=true; fab:=true;
     armor_class:=19; experience:=2550;
     gps:=1200; end;

with monster[66] do begin
     name:='WATER DRAGON'; numatt:=3; range:=0;
     mis_maxdam:=30; mis_mindam:=12; level:=24; maxdamage:=80; mindamage:=40;
     minhp:=300; maxhp:=340;
     STAFF:=7; SPOINTS:=115; SP_NAME:='Breathes Steam';
     armor_class:=23; experience:=12500;
     gps:=18200; end;

with monster[67] do begin
     name:='WATER ELEMENTAL'; numatt:=2; range:=0;
     mis_maxdam:=30; mis_mindam:=12; level:=18; maxdamage:=30; mindamage:=15;
     minhp:=180; maxhp:=220;
     armor_class:=18; experience:=2500;
     gps:=1; end;

with monster[68] do begin
     name:='LADY LINDA'; numatt:=5; range:=0; FAB:=TRUE;
     mis_maxdam:=100; mis_mindam:=75; level:=40; maxdamage:=100; mindamage:=50;
     minhp:=750; maxhp:=1000;
     armor_class:=38; experience:=22500;
     gps:=32000; end;

assign(filevar,'MONSTER.DAT');
rewrite(filevar);
for counter:=1 to maxinfile do
   write(filevar,monster[counter]);
end.