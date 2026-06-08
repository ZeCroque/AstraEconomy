;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname AE:Fragments:TopicInfos:TIF_AE_DialogueTAHQ_AstrasSmallAmount Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN AUTOCAST TYPE AE:AEQuestAstraExchangeScript
AE:AEQuestAstraExchangeScript kmyQuest = GetOwningQuest() as AE:AEQuestAstraExchangeScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.SetWantedXTechAmount(AE_Xtech_Small_Amount.GetValueInt())
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property SFBGS003_Astras_SmallAmount Auto Const Mandatory

GlobalVariable Property AE_XTech_Small_Amount Auto Const Mandatory
