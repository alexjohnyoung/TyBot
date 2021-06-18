# TyBot
Lua bot made for the Garry's Mod gamemode Trouble in Terrorist Town
![Menu](https://i.ibb.co/m4yGRWQ/tybconfig-menu.png)
![Config](https://i.ibb.co/R0YF5PN/tybconfig-config.png)

### Installation
##### Move script to garrysmod/lua directory and use lua_openscript_cl tyb.lua or use an external Lua loader
## Features
---
## Command List
##### The bot will iterate through the following commands and select a correct command to run depending on the current environment
|Name|Use|
|----|---|
|aimbot|Aimbotting players
|followplayer|Following players|
|meshmove|Moving on the mesh|
|identifybody|Identifying unidentified bodies|
|findweapon|Finding weapons
---
## Aimbot
#### Autoshoot
##### Variable to set whether the Aimbot should shoot once conditions are met without user input
#### Line of Sight
##### Variable to set whether the Aimbot should only track targets it can see
#### Target Same Team
##### Variable to set whether the Aimbot should target the same team
#### Target Fellow Traitors
##### Variable to set whether the Aimbot should target traitors as a traitor
#### Target Aiming At Me
##### Variable to set whether the Aimbot should target players aiming at it
#### Only Aimbot as Traitor
##### Variable to set whether the Aimbot should only be active as a traitor
---
## Mesh
#### TyBot can create mesh data dynamically by observing other player movement, or statically from a mesh file (located in data/tyb/mapdata)
##### If there is no mesh file for the current map, the meshmove command will be added to the command list after 100 valid player positions are recorded and if **Load Mesh Command** is enabled
##### Statically, mesh files must be named after the map and include a JSON stored table of Vectors around the map
##### If a mesh file for the current map exists, TyBot will use that mesh data and the meshmove command will be added to the command list
#### Included is a dump_waypoints.lua file for this purpose
---
## Traitor
#### Kill as Traitor
##### Variable used to determine whether to attempt to kill other lone players as traitor
#### Flare Gun After Kill
##### Variable used to determine whether or not traitor kill victims should be flaregunned after
---
## Misc
#### Emergency Mode
##### Variable used to determine whether or not it should attack players in close proximity who have recently lost ammo after losing health
#### Attempt Unstuck
##### TyBot can attempt to unstuck itself if found in the same position by moving to nearby doors / mesh / random button press
#### Setting Saving
##### All settings are saved to data/tyb/settings.txt to be used on load in JSON format
#### Enable Announce
##### Variable used to determine whether or not the current command and runtime should output in chat
#### Block Screen Capture
##### Screen capture addons blocked by making render.Capture do nothing
#### Deactivate on Low Karma
##### Variable used to determine whether or not to deactivate on low karma
#### Random Jumps
##### Variable used to determine whether or not to use random jumps (more of a crouch duck to weird the hitbox up)
#### Random Angles
##### Variable used to determine whether or not it should use random angles
#### Flashlight Spam
##### Variable used to determine whether or not it should spam flashlight
#### Force Close Panels
##### Variable used to determine whether or not to force close DFrame panels created with vgui.Create
#### Use Radio
##### Variable used to determine whether or not to use radio commands
