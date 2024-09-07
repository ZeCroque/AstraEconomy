*********************************
# Astra Economy
*********************************

### Index:
1. Summary
2. Mod content
3. Installation
4. Known Issues
5. Incompatibilities
6. Credits
7. Tools used
8. Licensing/Legal 
9. Other

********************************
### 1. SUMMARY

This mods changes Stache's dialog from the Tracker Alliance's HQ in order to get more specialized legendary gear instead of a totally random item, thus reducing the grind to get the legendary item you seek for.
It does basically two things :
- Stache now asks you to give him a item to modify via an inventory dialog, and will reroll the legendary effect of the wanted level (only this one, unless lower tiers weren't yet set).
- You can now trade legendary gear to Stache and it will give you Astra(s) based on the "star level" of what you gave. 3 stars in whatever combination of item <=> 1 Astra. If the "star level" of the items you gave isn't a multiple of 3, you will be given back the surplus.

That's a pretty simple mod, but I find it much more convenient than what BGS provided while not being as OP as other Legendary cycling/crafting mods out there that were breaking the gameplay loop IMHO.

Note that you cannot get legendary effects combination that were not possible in the base game, so no Peacemaker suit or explosive Arc Welder, sorry for you cheater out there :p I may add some customization options later on though, depending of the success of the mod and what the community wants, so feel free to ask in the comment section :)

It's still an early version of the mod, even though I tested it for a while on my own playthrough and so far it's been safe and sound.

PS : You may notice, before the screen fades to black when cycling items, that the said items are dropped to the ground before being processed by the mod (you hear them too). Infortunately it was the only way I got it to work, because the script function I was wanting to use, *GetItemCountKeywords*, is not working properly. If any modders there have a better solution, I'm listening!

### 2. MOD CONTENT

This mod is made of two files : 
- *AstraEconomy.esm*
- *AstraEconomy - Main.ba2*

This mod is flagged as Light file, so it won't waste a precious place in your load order.

### 3. INSTALLATION

**Automatic (Recommended)**
- Use the Mod Manager Download button. Install and enable the file(s) in your favorite mod manager (ModOrganizer2 is my personal preference).

**Manual**
- Extract the required files (cf. `2. MOD CONTENT`) from the archive to your Data folder and activate them in the in-game Creations menu

### 4. KNOWN ISSUES
None. Please let me know if you find any.

### 5. INCOMPATIBILITIES 
None that I know of. But anything editing the vanilla "DLC03:SFBGS003QuestAstraExchangeScript" script will conflict with this one.

### 6. CREDITS
- Thanks to Bethesda Softworks for this great game we all love.
- Thanks to the authors of the tools listed below
- Thanks to Redzy7 for his post on Starfield's design style for the thumbnail (https://www.reddit.com/r/Starfield/comments/15row6b/im_in_love_the_starfield_design_style_so_here_are/)
- Thanks to the Starfield's fonts authors

### 7. TOOLS USED
- Creation Kit
- SF1Edit
- Visual Studio Code
- Gimp

### 8. LICENSING/LEGAL 
If you want to modify and/or redistribute this mod, I would like to be contacted first please.

You CANNOT, by any mean, upload this mod as a Creation accessible through the in-game menu. I plan to do it myself, but I prefer to wait for community feedback before doing so.

The mod is open-source, you can find the sources here : https://github.com/ZeCroque/AstraEconomy

### 9. OTHER
**Possible improvements:**
- AI-generated voices for new dialogs
- Settings for unique/cut and/or cheaty legendary effects
- Setting to disable rerolling
- You tell me!