;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Fragments:TopicInfos:TIF_SFBGS003_DialogueTAHQ_0100080C Extends TopicInfo Hidden Const

;BEGIN FRAGMENT Fragment_End
Function Fragment_End(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN AUTOCAST TYPE dlc03:sfbgs003questastraexchangescript
dlc03:sfbgs003questastraexchangescript kmyQuest = GetOwningQuest() as dlc03:sfbgs003questastraexchangescript
;END AUTOCAST
;BEGIN CODE
kmyQuest.DoExchange()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
