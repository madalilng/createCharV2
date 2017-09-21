################### How to ###################
1. copy the whole git to openkore root directory
2. Change char to blank in control/config.txt
3. add createChar in loadPlugins_list at control/sys.txt
should look like this :

folder structure
plugins -> createChar -> createChar.pl
replace ServerType0.pm in
src -> Network -> Recieve -> ServerType0.pm

control/config.txt
#################
master International - iRO: Re:Start
server 0
username (username)
password (password)
loginPinCode
char
################

control/sys.txt
################
loadPlugins_list macro,profiles,breakTime,raiseStat,raiseSkill,map,reconnect,eventMacro,item_weight_recorder,createChar
################
