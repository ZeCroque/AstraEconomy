;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname AE:Fragments:TopicInfos:TIF_AE_DialogueTAHQ_AllAstras Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN AUTOCAST TYPE AE:DialogTAHQQuest:DialogTAHQQuestScript
AE:DialogTAHQQuest:DialogTAHQQuestScript kmyQuest = GetOwningQuest() as AE:DialogTAHQQuest:DialogTAHQQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.SetWantedXTechAmount(-1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property SFBGS003_Astras_LargeAmount Auto Const Mandatory
