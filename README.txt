################### How to ###################
1. saveAS plugins/createChar/createChar.pl
2. Change char to blank on control/config.txt
3. add createChar in loadPlugins_list at control/sys.txt
should look like this :

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
