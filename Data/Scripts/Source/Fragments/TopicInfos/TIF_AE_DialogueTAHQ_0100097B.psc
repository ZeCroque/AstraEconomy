;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Fragments:TopicInfos:TIF_AE_DialogueTAHQ_0100097B Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN AUTOCAST TYPE AE:AEQuestAstraExchangeScript
AE:AEQuestAstraExchangeScript kmyQuest = GetOwningQuest() as AE:AEQuestAstraExchangeScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.AstraReroll(SFBGS003_Astras_LargeAmount.GetValueInt())
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property SFBGS003_Astras_LargeAmount Auto Const Mandatory
