Scriptname AE:AEQuestCassiopeaCheckScript extends Quest

Quest Property AE_DialogueTAHQ Mandatory Const Auto

Event OnQuestInit()
    CheckCassiopea()
EndEvent

Function CheckCassiopea()
    Debug.Trace("coucou")
    Int CassiopeaVersion = 0
    CassiopeaVersion = CassiopeiaPapyrusExtender.GetCassiopeiaPapyrusExtenderVersion()
    Debug.Trace(CassiopeaVersion)
    (AE_DialogueTAHQ as AE:AEQuestAstraExchangeScript).IsCassiopeiaInstalled = CassiopeaVersion > 0
    Debug.Trace((AE_DialogueTAHQ as AE:AEQuestAstraExchangeScript).IsCassiopeiaInstalled)
EndFunction