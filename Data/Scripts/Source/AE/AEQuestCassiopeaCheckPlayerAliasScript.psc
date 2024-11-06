Scriptname AE:AEQuestCassiopeaCheckPlayerAliasScript extends ReferenceAlias

Quest Property AE_CassiopeaCheck Mandatory Const Auto

Event OnPlayerLoadGame()
    (AE_CassiopeaCheck as AEQuestCassiopeaCheckScript).CheckCassiopea()
EndEvent