from CIScripts import translator
from CIScripts import ba2_creator
from CIScripts import utils
from CIScripts import mod_info
import os

def main():   
    if utils.AskForUserConfirm("Would you like to localize the .esm?"):
        translator.Translate()
        if(not utils.AskForUserConfirm(".esm localized. Proceed to archive creation?")):
            return

    if(os.path.isfile(mod_info.config.modShortName + "_Thumbnail.png") or utils.AskForUserConfirm("Thumbnail file not found. Proceed anyway?")):
        ba2_creator.CreateArchives()

if __name__ == "__main__":
    main()