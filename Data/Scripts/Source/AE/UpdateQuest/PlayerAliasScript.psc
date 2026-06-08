Scriptname AE:UpdateQuest:PlayerAliasScript extends ReferenceAlias

Event OnPlayerLoadGame()
    (GetOwningQuest() as AE:UpdateQuest:UpdateQuestScript).Update()
EndEvent