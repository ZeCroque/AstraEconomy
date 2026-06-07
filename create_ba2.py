import json
from pathlib import Path
import subprocess
import os
import shutil
import re
import glob
import build

modName = "AstraEconomy"
modNameLowerCase = modName.lower()
archiveNameBase = modName + " - "
mainArchiveName = archiveNameBase + "Main" 
mainArchiveNameAF = modName + "_AF - Main"
modFilePathAF = "./Data/" + modName + "_AF.esm"
archiveExtension = ".ba2"
buildFolder = "./build/"

# ========================================================================

def GetVoicesFromAchList(achlist, mode, languageCode=""):
    filelist = ""
    with open(achlist, "r") as file:
        data = json.load(file)
        for f in data:        
            p = Path(f)
            if p.suffix == ".wem":
                if mode == "Xbox":
                    filelist += "Data\\Xbox\\" + str(Path(*p.parts[1:]))
                elif mode == "PS5":
                    filelist += "Data\\PS5\\" + str(Path(*p.parts[1:]))
                elif mode == "Localized":
                    filelist += "Data\\LocalizedVoices\\" + languageCode + "\\" + str(Path(*p.parts[1:]))
                else:
                    filelist += f
            else:
                filelist += f 
            filelist += "\n"
        filelist = filelist.rstrip('\n')
    return filelist

def GetFilesFromAchList(achList):
    filelist = ""
    with open(achList, "r") as file:
        data = json.load(file)
        for f in data:        
            filelist += f 
            filelist += "\n"
        filelist = filelist.rstrip('\n')
    return filelist

def InitFileList(fileListName, fileList, buildFolder):
    with open(buildFolder + fileListName, "w") as output:
        output.write(fileList)
        output.write("\n")

def AppendToFileList(fileListName, fileList, buildFolder):
    with open(buildFolder + fileListName, "a") as output:
        output.write(fileList)
        output.write("\n")

def PrepareFileListForAF(fileListName, buildFolder):
    with open(buildFolder + fileListName, 'r') as file:
        filedata = file.read()

    filedata = filedata.lower().replace(modNameLowerCase, modName + "_AF")

    with open(buildFolder + fileListName, 'w') as file:
        file.write(filedata)

def CopyFilesToBuildFolder(fileList, buildFolder, isAF=False):
    for file in fileList.splitlines():        
        dest = (buildFolder + os.path.dirname(file)).lower()        
        if isAF:        
            matches = re.findall(".*" + modNameLowerCase, dest)  
            if len(matches):
                dest = dest.replace(modNameLowerCase, modNameLowerCase + "_AF")
        matches = re.findall(".*(sound.*)", dest)  
        if(len(matches)):
            dest = buildFolder + "Data\\" + matches[0]

        os.makedirs(dest, exist_ok=True)
        shutil.copy(file, dest)

        if isAF:
            baseName = os.path.basename(file).lower()
            matches = re.findall(modNameLowerCase, baseName) 
            if len(matches):
                shutil.move(dest + "/" + baseName, dest + "/" + baseName.replace(modNameLowerCase, modName + "_AF"))

def CreateBA2(fileListName, archiveName, outputFolder):
    subprocess.run(["H:/Games/steamapps/common/Starfield/Tools/Archive2/Archive2.exe", "-s=" + fileListName, "-c=" + outputFolder + archiveName,  "-f=General", "-compression=None"], cwd='./build') 

def CreateLocalizedVoiceBA2(voiceList, voiceListPath, archiveNameBase, buildFolder, outputFolder):
    supportedLanguages = ["de", "es", "fr", "it", "ja", "pl", "ptbr", "zhhans"]
    for supportedLanguage in supportedLanguages:
        if os.path.isdir("Data\\LocalizedVoices\\" + supportedLanguage):
            fileListName = supportedLanguage + ".txt"
            CopyFilesToBuildFolder(GetVoicesFromAchList(voiceListPath, "Localized", supportedLanguage), buildFolder)
            InitFileList(fileListName, voiceList, buildFolder)
            CreateBA2(fileListName, archiveNameBase + "Voices_" + supportedLanguage + ".ba2", outputFolder)
            os.remove(buildFolder + fileListName)

def CopyESMs(outputDir):
    esmPaths = glob.glob("./Data/*.esm")
    for esmPath in esmPaths:
        shutil.copy(esmPath, outputDir + esmPath)

def CopyFOMODFiles(thumbnail, outputDir):
    fomodFiles = glob.glob("./fomod/**/*.*", recursive=True)
    for fomodFile in fomodFiles:
        if os.path.isfile(fomodFile) and Path(fomodFile).suffix != ".in":
            dest = outputDir + os.path.dirname(fomodFile)
            os.makedirs(dest, exist_ok=True)
            shutil.copy(fomodFile, dest)
    shutil.copy(thumbnail, outputDir)
    shutil.copy("readme.md", outputDir)

def CopyArtifactsToDataFolder(artifactsPath):
    artifacts = glob.glob(artifactsPath + "/Data/*")
    for artifact in artifacts:
        shutil.copy(artifact, "./Data/")

# ========================================================================

def CreateNexusArchive(mainFileList, modifiedVoiceList, vanillaVoiceList, vanillaVoiceListName):
    buildName = "Nexus"
    artifactsSubpath = "artifacts\\" + buildName + "\\"
    artifactsFullpath = buildFolder + artifactsSubpath
    fileListName = buildName + ".txt"
    outputFolder =  "output\\"
    
    # Prepare build files
    CopyFilesToBuildFolder(mainFileList, buildFolder)
    CopyFilesToBuildFolder(vanillaVoiceList, buildFolder)
    CopyFilesToBuildFolder(modifiedVoiceList, buildFolder)

    # Main build
    InitFileList(fileListName, mainFileList, buildFolder) 
    CreateBA2(fileListName, mainArchiveName + archiveExtension, artifactsSubpath + "Data\\")
    os.remove(buildFolder + fileListName)
    
    # AI Voices
    if len(modifiedVoiceList) > 0:
        InitFileList(fileListName, vanillaVoiceList, buildFolder)
        AppendToFileList(fileListName, modifiedVoiceList, buildFolder)
        CreateBA2(fileListName, archiveNameBase + "Voices_en" + archiveExtension, artifactsSubpath + "Data\\")
        os.remove(buildFolder + fileListName)

    # NO AI Voices
    if len(vanillaVoiceList) > 0:
        InitFileList(fileListName, vanillaVoiceList, buildFolder)
        CreateBA2(fileListName, archiveNameBase + "Voices_en_NO_AI" + archiveExtension, artifactsSubpath + "Data\\")
        os.remove(buildFolder + fileListName)

    # Localized voices
    if len(vanillaVoiceList) > 0:
        CreateLocalizedVoiceBA2(vanillaVoiceList, vanillaVoiceListName, archiveNameBase, buildFolder, artifactsSubpath + "Data\\")

    # Copy esms
    CopyESMs(artifactsFullpath)
    
    # Create zip
    CopyFOMODFiles("AE_Thumbnail.png", artifactsFullpath)
    
    # Output
    os.makedirs(outputFolder, exist_ok=True)
    shutil.make_archive(outputFolder + modName, 'zip', artifactsFullpath)

    # Cleanup
    shutil.rmtree(buildFolder + "Data")

def CreateCreationArchives(mainFileList, vanillaVoiceList, vanillaVoiceListName, isAF=False):
    buildName = "Creation"
    artifactsSubpath = "artifacts\\" + buildName + "\\"
    artifactsFullpath = buildFolder + artifactsSubpath
    fileListName = buildName + ".txt"
    archiveName = mainArchiveNameAF if isAF else mainArchiveName

    # Prepare common build files
    CopyFilesToBuildFolder(mainFileList, buildFolder, isAF)
    
    # Prepare file list
    InitFileList(fileListName, mainFileList, buildFolder)
    if len(vanillaVoiceList) > 0:
        AppendToFileList(fileListName, vanillaVoiceList, buildFolder) 
    if isAF:
        PrepareFileListForAF(fileListName, buildFolder)

    # PC build
    CopyFilesToBuildFolder(GetVoicesFromAchList(vanillaVoiceListName, "PC"), buildFolder, isAF)
    CreateBA2(fileListName, archiveName + archiveExtension, artifactsSubpath + "Data\\")

    # Xbox build
    CopyFilesToBuildFolder(GetVoicesFromAchList(vanillaVoiceListName, "Xbox"), buildFolder, isAF)
    CreateBA2(fileListName, archiveName + "_xbox" + archiveExtension, artifactsSubpath + "Data\\")

    # PS5 Build
    CopyFilesToBuildFolder(GetVoicesFromAchList(vanillaVoiceListName, "PS5"), buildFolder, isAF)
    CreateBA2(fileListName, archiveName + "_ps" + archiveExtension, artifactsSubpath + "Data\\")

    # Output
    CopyArtifactsToDataFolder(artifactsFullpath)
    if(isAF):
        shutil.copy("./Data/" + modName + ".esm", modFilePathAF)

    # Cleanup    
    os.remove(buildFolder + fileListName)
    shutil.rmtree(buildFolder + "Data")

def main():   
    mainFileList = GetFilesFromAchList("./Data/AE_Main.achlist")
    modifiedVoiceList = ""
    vanillaVoiceListName = "./Data/AE_Voices.achlist"
    vanillaVoiceList = GetFilesFromAchList(vanillaVoiceListName)

    if os.path.isdir(buildFolder):
        shutil.rmtree(buildFolder)

    if os.path.isfile(modFilePathAF):
        os.remove(modFilePathAF)

    # Non-AF
    build.FillTemplates(0)
    build.Build(0)
    CreateNexusArchive(mainFileList, modifiedVoiceList, vanillaVoiceList, vanillaVoiceListName)
    CreateCreationArchives(mainFileList, vanillaVoiceList, vanillaVoiceListName, False)

    # AF
    build.FillTemplates(1)
    build.Build(1)
    CreateCreationArchives(mainFileList, vanillaVoiceList, vanillaVoiceListName, True)

if __name__ == "__main__":
    main()