program crumors;
const maxrumor=75;
type rumors = record
       gibber : string[50];
     end;
var rumor :array [1..maxrumor] of rumors;
    rumorfile : file of rumors; x:integer;
begin
rumor[1].gibber:='Lady Linda is a Fraud!!';
rumor[2].gibber:='The Noze lives in a cave, he needs help!';
rumor[3].gibber:='Rumor has it that Pit Fiend 3 is coming soon??!';
rumor[4].gibber:='Angel is a young sorceress and very powerful!!';
rumor[5].gibber:='Watchout for Angels, they are usually in disguise';
rumor[6].gibber:='Iron Horse is full of hot air, do not believe him';
rumor[7].gibber:='See Raelizini!';
rumor[8].gibber:='A Dragon lives near by!!';
rumor[9].gibber:='Rumors of treasure is said to be in the desert.....';
rumor[10].gibber:='Have another drink';
rumor[11].gibber:='Gosh the Weather is hot.....';
rumor[12].gibber:='Many adventures near Carmel and Apple Valley!';
rumor[13].gibber:='Watch for Pit Fiend III -- coming soon to a BBS near you!';
rumor[14].gibber:='What, I got Beer in my ear!';
rumor[15].gibber:='Xevior has two Major Soma Factories near Scottsville';
rumor[16].gibber:='Xevior is actually a God!';
rumor[17].gibber:='Xevior is quite insane!';
rumor[18].gibber:='Who said there was going to be a Pit Fiend 3?';
rumor[19].gibber:='There are multi-level towers near Apple Valley';
rumor[20].gibber:='Mojave can''t shape change, he''s a bird';
rumor[21].gibber:='Pit Fiend casts the most powerful spells!';
rumor[22].gibber:='I saw Mojave flying towards the west!';
rumor[23].gibber:='I saw Mojave flying towards the east!';
rumor[24].gibber:='I just farted....woo wee!';
rumor[25].gibber:='Watch USA Up All Nite.... Killer shows!!';
rumor[26].gibber:='One of the gamblers loves to cheat!';
rumor[27].gibber:='Mojave''s Tower is 17 levels high!';
rumor[28].gibber:='It''s wise to talk to people, have much information';
rumor[29].gibber:='Traveling merchants are often the cheapest!';
rumor[30].gibber:='Make sure you carry plenty of food!';
rumor[31].gibber:='I personally suggest the Ring of Protection +5!';
rumor[32].gibber:='Be careful with the Teleportal Rings, DANGEROUS';
rumor[33].gibber:='Visit Lone Pine sometime, nice place...';
rumor[34].gibber:='Have you been to Scottsville, Magic Weapons!';
rumor[35].gibber:='Palm Springs is having a celebration right now!';
rumor[36].gibber:='You need a vacation, go to Palm Springs';
rumor[37].gibber:='Xevior is a good friend of Pit Fiend''s';
rumor[38].gibber:='No way.... Xevior doesn''t have 4 arms, he has 6!';
rumor[39].gibber:='Get a good Armor Class';
rumor[40].gibber:='Save us from Pit Fiend';
rumor[41].gibber:='Go visit Ladera Sometime, if you are innocent!';
rumor[42].gibber:='Drink from wells....';
rumor[43].gibber:='The Magic Mouth does not like swear words.....';
rumor[44].gibber:='Aren''t Magic Mouths cute?';
rumor[45].gibber:='Dwarves suck, and that''s final!';
rumor[46].gibber:='A Magic Fountain is in the forest!';
rumor[47].gibber:='Watch out for traps....';
rumor[48].gibber:='Kill the killers!';
rumor[49].gibber:='Becareful, Guard Posts replenish themselves!';
rumor[50].gibber:='Traps Replenish Themselves!';
assign(rumorfile,'RUMORS.DAT');
rewrite(rumorfile);
for x := 1 to maxrumor do
  write(rumorfile,rumor[x]);
close(rumorfile);

end.




