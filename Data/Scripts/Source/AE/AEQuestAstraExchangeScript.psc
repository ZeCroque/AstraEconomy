Scriptname AE:AEQuestAstraExchangeScript extends Quest Conditional

;### Main

MiscObject Property Astra Mandatory Const Auto

;### Cycling

Container Property AE_TAHQ_Stache_Vendor_WorkContainer Auto Const Mandatory
ObjectReference WorkContainer

FormList Property AE_Legendary1StarList Auto Const Mandatory
FormList Property AE_Legendary2StarList Auto Const Mandatory
FormList Property AE_Legendary3StarList Auto Const Mandatory
FormList Property AE_LegendaryList Auto Const Mandatory

Message Property AE_Tutorial_Recycle Auto Const Mandatory
Bool RecycleTutorialShown = False

Int Property Result Auto Conditional

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
    if(!abOpening)
        Actor myPlayer = Game.GetPlayer()
        UnregisterForMenuOpenCloseEvent("ContainerMenu")
        Result = WorkContainer.GetItemCount()
    Endif
EndEvent

ObjectReference[] Inventory

Function StartCycling()
    If(!RecycleTutorialShown)
        RecycleTutorialShown = true
        AE_Tutorial_Recycle.Show()
    EndIf
    If(!WorkContainer)
        WorkContainer = Game.GetPlayer().PlaceAtMe(AE_TAHQ_Stache_Vendor_WorkContainer, 1, true)
    EndIf
    RegisterForMenuOpenCloseEvent("ContainerMenu")
    WorkContainer.OpenOneWayTransferMenu(true, AE_LegendaryList)
EndFunction

Function DoCycling()
    Actor myPlayer = Game.GetPlayer()
    Game.FadeOutGame(true, true, 0, 1.0, true)
    Int AstraTotal = 0
    Int AstraCount = RecycleItems()
    While(AstraCount > 0)
        AstraTotal += AstraCount
        AstraCount = RecycleItems()
    EndWhile
    myPlayer.AddItem(Astra, AstraTotal)
    WorkContainer.RemoveAllItems(myPlayer)
    Game.FadeOutGame(false, true, 0, 1.0, false)
EndFunction

;Method with the same name in ObjectReference does not work, so remade it
Int Function GetItemCountKeywords(FormList akKeywordList)
    Int i = 0
    Int Count = 0
    While i < Inventory.Length && Inventory[i]
        If(Inventory[i].HasKeywordInFormList(akKeywordList))
            Count += 1
        Endif
        i += 1
    EndWhile
    Return Count
EndFunction

Function CleanDumpedItems(FormList akType, Int aiCountToKeep)
    Int i = 0
    Int j = 0
    While i < Inventory.Length && (Inventory[i])
        If(j < aiCountToKeep && Inventory[i].HasKeywordInFormList(akType))
            WorkContainer.AddItem(Inventory[i])
            j += 1
        Else
            Inventory[i].Delete()
        EndIf
        i += 1
    EndWhile
EndFunction

Int Function DumpItems()  ;Also handles 3stars
    Inventory = new ObjectReference[Math.Min(128.0, WorkContainer.GetItemCount() as Float) as Int]

    Int AstraCount = 0
    Int i = 0
    While WorkContainer.GetItemCount() > 0 
        ObjectReference DroppedItem = WorkContainer.DropFirstObject()
        If(DroppedItem.HasKeywordInFormList(AE_Legendary3StarList))
            DroppedItem.Delete()
            AstraCount += 1
        Else
            Inventory[i] = DroppedItem
            i += 1
        Endif
    EndWhile
    Return AstraCount
EndFunction

Int Function RecycleItems()
    Int AstraCount = DumpItems() 

    Int TwoStarCount = GetItemCountKeywords(AE_Legendary2StarList)
    Int OneStarCount = GetItemCountKeywords(AE_Legendary1StarList) - TwoStarCount

    Int OneStarTripletsCount = OneStarCount / 3
    AstraCount += OneStarTripletsCount
    OneStarCount -= (OneStarTripletsCount * 3)

    Int TwoStarTripletsCount = TwoStarCount / 3
    AstraCount += TwoStarTripletsCount * 2
    TwoStarCount -= (TwoStarTripletsCount * 3)

    Int OneStarTwoStarCombinationsCount = Math.Min(OneStarCount as Float, TwoStarCount as Float) as Int
    AstraCount += OneStarTwoStarCombinationsCount
    OneStarCount -= OneStarTwoStarCombinationsCount
    TwoStarCount -= OneStarTwoStarCombinationsCount

    CleanDumpedItems(AE_Legendary1StarList, OneStarCount)
    CleanDumpedItems(AE_Legendary2StarList, TwoStarCount)

    Return AstraCount
EndFunction

;### X-Tech

MiscObject Property XTech Mandatory Const Auto

Float Property XTechCost Auto Hidden

Int XTechAmount = -1

Function SetWantedXTechAmount(Int aiAmount)
    XTechAmount = aiAmount
EndFunction

Function BuyXTech()
    If(XTechAmount < 0)    
        Int astraCount = Game.GetPlayer().GetItemCount(Astra)
        Int xTechCount = (astraCount / XTechCost) as Int
        Game.GetPlayer().AddItem(XTech, xTechCount)
        Game.GetPlayer().RemoveItem(Astra, Math.Round(xTechCount * XTechCost))
    Else
        Game.GetPlayer().AddItem(XTech, XTechAmount)
        Game.GetPlayer().RemoveItem(Astra, Math.Round(XTechAmount * XTechCost))
    EndIf
EndFunction