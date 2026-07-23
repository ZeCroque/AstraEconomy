;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname AE:Fragments:Scenes:SF_AE_DialogueTAHQ_Stache_TL_BuyXTech Extends Scene Hidden Const

;BEGIN FRAGMENT Fragment_Phase_04_Begin
Function Fragment_Phase_04_Begin()
;BEGIN AUTOCAST TYPE AE:DialogTAHQQuest:DialogTAHQQuestScript
AE:DialogTAHQQuest:DialogTAHQQuestScript kmyQuest = GetOwningQuest() as AE:DialogTAHQQuest:DialogTAHQQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.BuyXTech()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
