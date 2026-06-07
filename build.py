import subprocess
import os
import glob
import re

modVersionString = "1.0.0"
modVersionFloat = "1."

def GetTemplatedVarValue(name, mode):
    if name == "MOD_VERSION":
        return modVersionFloat
    elif name == "MOD_VERSION_STRING":
        return modVersionString
    elif name == "IS_AF":
        return "True" if mode else "False"
    else:
        return "undefined"

def FillTemplates(mode):
    templateFilePaths = glob.glob("./**/*.in", recursive=True)
    for templateFilePath in templateFilePaths:
        with open(templateFilePath, 'r') as file:
            fileData = file.read()
            
        matches = re.findall("\\@(.*)\\@", fileData) 
        for match in matches:
            fileData = fileData.replace("@" + match + "@", GetTemplatedVarValue(match, mode))

        with open(os.path.splitext(templateFilePath)[0], 'w') as file:
            file.write(fileData)

def Build(mode):
    compiledScriptPaths = glob.glob("./Data/Scripts/**/*.pex", recursive=True)
    for compiledScriptPath in compiledScriptPaths:
        os.remove(compiledScriptPath)
    subprocess.run(["H:/Games/steamapps/common/Starfield/Tools/Papyrus Compiler/PapyrusCompiler.exe", "AstraEconomyRelease.ppj"])

def main():
    mode = -1
    while mode != 0 and mode != 1:
        print("Enter build mode\n 0: Non-Achievement-Friendly\n 1: Achievement-Friendly")
        try :
            mode = int(input())
        except ValueError :
            print ("Not a number")
        else:
            if mode != 0 and mode != 1:
                print("Invalid value")
        print()
    FillTemplates(mode)
    Build(mode)

if __name__ == "__main__":
    main()