Scriptname AE:UpdateQuest:UpdateQuestScript extends Quest

GlobalVariable Property AE_ModVersion Mandatory Const Auto
Quest Property AE_DialogueTAHQ Mandatory Const Auto
GlobalVariable Property AE_Astras_Small_Amount Mandatory Const Auto
GlobalVariable Property AE_Astras_Big_Amount Mandatory Const Auto
GlobalVariable Property AE_Xtech_Small_Amount Mandatory Const Auto
GlobalVariable Property AE_XTech_Big_Amount Mandatory Const Auto

Event OnQuestInit()
    Update()
EndEvent

Function Update()
    If(AE_ModVersion.GetValue() < 1.0)
        AE_DialogueTAHQ.UpdateCurrentInstanceGlobal(AE_Astras_Small_Amount)
        AE_DialogueTAHQ.UpdateCurrentInstanceGlobal(AE_Astras_Big_Amount)
        AE_DialogueTAHQ.UpdateCurrentInstanceGlobal(AE_Xtech_Small_Amount)
        AE_DialogueTAHQ.UpdateCurrentInstanceGlobal(AE_XTech_Big_Amount)
    EndIf
    AE_ModVersion.SetValue(AE:Utility:ModInfo.GetModVersion())
EndFunction
