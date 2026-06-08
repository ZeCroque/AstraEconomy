Scriptname AE:GameplayOptionManagerQuest extends Quest

GameplayOption Property AE_XTechCost Mandatory Const Auto
GlobalVariable Property AE_Astras_Small_Amount Mandatory Const Auto
GlobalVariable Property AE_Astras_Big_Amount Mandatory Const Auto
GlobalVariable Property AE_Xtech_Small_Amount Mandatory Const Auto
GlobalVariable Property AE_XTech_Big_Amount Mandatory Const Auto
Quest Property AE_DialogueTAHQ Mandatory Const Auto

Event OnQuestInit()
    RegisterForGameplayOptionChangedEvent()

    AE:AEQuestAstraExchangeScript astraExchangeScript = AE_DialogueTAHQ as AE:AEQuestAstraExchangeScript
    astraExchangeScript.XTechCost = 0.5
EndEvent

Event OnGameplayOptionChanged(GameplayOption[] aChangedOptions)
    Int optionIndex = aChangedOptions.Find(AE_XTechCost)
    If(optionIndex != -1)
        AE:AEQuestAstraExchangeScript astraExchangeScript = AE_DialogueTAHQ as AE:AEQuestAstraExchangeScript

        If(aChangedOptions[optionIndex].GetValue() == 0)
            astraExchangeScript.XTechCost = 5
            AE_Astras_Small_Amount.SetValueInt(5)
            AE_Astras_Big_Amount.SetValueInt(15)
        ElseIf(aChangedOptions[optionIndex].GetValue() == 1)
            astraExchangeScript.XTechCost = 3
            AE_Astras_Small_Amount.SetValueInt(3)
            AE_Astras_Big_Amount.SetValueInt(15)
        ElseIf(aChangedOptions[optionIndex].GetValue() == 2)
            astraExchangeScript.XTechCost = 1
            AE_Astras_Small_Amount.SetValueInt(1)
            AE_Astras_Big_Amount.SetValueInt(10)
        ElseIf(aChangedOptions[optionIndex].GetValue() == 3)
            astraExchangeScript.XTechCost = 0.5
            AE_Astras_Small_Amount.SetValueInt(1)
            AE_Astras_Big_Amount.SetValueInt(10)
        ElseIf(aChangedOptions[optionIndex].GetValue() == 4)
            astraExchangeScript.XTechCost = 0.3
            AE_Astras_Small_Amount.SetValueInt(1)
            AE_Astras_Big_Amount.SetValueInt(9)
        EndIf

        AE_Xtech_Small_Amount.SetValue(Math.Round(AE_Astras_Small_Amount.GetValue() / astraExchangeScript.XTechCost))
        AE_Xtech_Big_Amount.SetValue(Math.Round(AE_Astras_Big_Amount.GetValue() / astraExchangeScript.XTechCost))

        AE_DialogueTAHQ.UpdateCurrentInstanceGlobal(AE_Astras_Small_Amount)
        AE_DialogueTAHQ.UpdateCurrentInstanceGlobal(AE_Astras_Big_Amount)
        AE_DialogueTAHQ.UpdateCurrentInstanceGlobal(AE_Xtech_Small_Amount)
        AE_DialogueTAHQ.UpdateCurrentInstanceGlobal(AE_XTech_Big_Amount)
    EndIf
EndEvent