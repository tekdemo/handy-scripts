handy-scripts
=============

Some random scripts I've accumulated over the course of time to make my life easier



.bashrc
=======
The pretty obvious must have for \*nix geeks. 
Mine contains several cool tricks
- Defines multiple colors for use in terminal scripts
- disables case sensitivity on tab autocomplete
- improves history for use in multiple terminal windows
- allows history filtering through partially completed inputs
- calls [STDERRED](https://github.com/sickill/stderred), which makes error text easier to spot
- Handy universal unzip function
- Prompt mods
	- Change colors of user and hostname depending on the system, to help with multi-system administration
	- Alerts user when laptop battery low, with colors (slightly broken)
	- Includes git branch and status.

mineserver
==========
Ancient, probably no longer functioning script. Posted because it contains some of the performance tweaks I set up. 
I had configured the server to run from a ramdisk, with a differential disk sync every 3 minutes. 
The cool thing that this did is 

1. Gave a 10x performance boost, since Minecraft was heavily disk bound
2. made recovery from griefing or crashes very, very simple, and cheap (1000 "full" backups was only 5-10x the world size)

Since these techniques are pretty universally cool, I thought I'd share.
