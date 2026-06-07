import subprocess
import os
import re
import shutil

def replaceCKLaunchArgs(args):
    mo2IniPath = os.getenv('LOCALAPPDATA') + "\\ModOrganizer\\Starfield\\ModOrganizer.ini"
    with open(mo2IniPath, 'r') as file:
        fileData = file.read()

    matches = re.findall("(.)\\\\.*CreationKit.exe", fileData) 
    index = matches[0]

    matches = re.findall("(" + index + "\\\\arguments=)(.*)", fileData) 
    fileData = fileData.replace(matches[0][0] + matches[0][1], matches[0][0] + args)

    with open(mo2IniPath, 'w') as file:
        file.write(fileData)

def runCK():
    subprocess.run(["J:/100Install/mo2/ModOrganizer.exe", "-p", "ZZZ_AstraEconomy", "moshortcut://Starfield:Creation Kit"])

def createAllStringFiles():
    stringFiles = os.listdir("./Data/Strings")
    supportedLanguages = ["de", "es", "fr", "it", "ja", "pl", "ptbr", "zhhans"]

    for supportedLanguage in supportedLanguages:
        for stringFile in stringFiles:
            shutil.copy("./Data/Strings/" + stringFile, "./Data/Strings/" + stringFile.replace("en", supportedLanguage))

def main():
    if os.path.isdir("./Data/Strings/"):
        shutil.rmtree("./Data/Strings")
    replaceCKLaunchArgs("-TagifyPlugin:AstraEconomy.esp")
    runCK()
    replaceCKLaunchArgs("-ExportText:AstraEconomy.esp")
    runCK()
    replaceCKLaunchArgs("-CompileTextExport:AstraEconomy.esp en H:/Games/steamapps/common/Starfield/TextExport/AstraEconomy.esp")
    runCK()
    createAllStringFiles()
    replaceCKLaunchArgs("")
    runCK()
    replaceCKLaunchArgs("-DelocalizeMasterfile:AstraEconomy.esm")
    runCK()
    replaceCKLaunchArgs("")

if __name__ == "__main__":
    main()