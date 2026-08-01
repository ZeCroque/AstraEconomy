from CIScripts import translator
from CIScripts import ba2_creator
from CIScripts import utils

def main():   
    #TODO test files, warn no thumbnail, etc..

    if utils.AskForUserConfirm("Would you like to localize the .esm?"):
        translator.Translate()
        if(not utils.AskForUserConfirm(".esm localized. Proceed to archive creation?")):
            return
    ba2_creator.CreateArchives()

if __name__ == "__main__":
    main()