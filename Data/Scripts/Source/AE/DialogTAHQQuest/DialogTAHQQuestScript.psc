Scriptname AE:DialogTAHQQuest:DialogTAHQQuestScript extends Quest Conditional

;### Main

MiscObject Property Astra Mandatory Const Auto

;### Cycling

Container Property AE_TAHQ_Stache_Vendor_WorkContainer Auto Const Mandatory
FormList Property AE_Legendary1StarList Auto Const Mandatory
FormList Property AE_Legendary2StarList Auto Const Mandatory
FormList Property AE_Legendary3StarList Auto Const Mandatory
FormList Property AE_Legendary4StarList Mandatory Const Auto
FormList Property AE_LegendaryList Auto Const Mandatory
FormList Property AE_CyclingList Mandatory Const Auto
Message Property AE_Tutorial_Recycle Auto Const Mandatory

Bool Property RecycleTutorialShown Auto Hidden
ObjectReference Property WorkContainer Auto Hidden

Int Property Result Auto Conditional

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
    if(!abOpening)
        Actor myPlayer = Game.GetPlayer()
        UnregisterForMenuOpenCloseEvent("ContainerMenu")
        Result = WorkContainer.GetItemCount()
    Endif
EndEvent

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
    Game.FadeOutGame(true, true, 0, 0.1, true)

    Int AstraCount = RecycleItems()
    myPlayer.AddItem(Astra, AstraCount)

    WorkContainer.RemoveAllItems(myPlayer) ;Add back leftovers
    AE_CyclingList.Revert()

    Game.FadeOutGame(false, true, 0, 1.0, false)
EndFunction

;Method with the same name in ObjectReference does not work, so remade it
Int Function GetItemCountKeywords(FormList akKeywordList)
    Int i = 0
    Int Count = 0
    While i < AE_CyclingList.GetSize() && AE_CyclingList.GetAt(i)
        If(AE_CyclingList.GetAt(i).HasKeywordInFormList(akKeywordList))
            Count += 1
        Endif
        i += 1
    EndWhile
    Return Count
EndFunction

Function CleanDumpedItems(FormList akType, Int aiCountToKeep)
    Int i = 0
    Int j = 0
    While(i < AE_CyclingList.GetSize())
        If(AE_CyclingList.GetAt(i) && AE_CyclingList.GetAt(i).HasKeywordInFormList(akType))
            If(j < aiCountToKeep)
                WorkContainer.AddItem(AE_CyclingList.GetAt(i) as ObjectReference)
                j += 1
            Else
                (AE_CyclingList.GetAt(i) as ObjectReference).Delete()
            EndIf        
        EndIf
        i += 1
    EndWhile
EndFunction

Int Function DumpItems()  ;Also handles 3stars
    Int AstraCount = 0
    While WorkContainer.GetItemCount() > 0 
        ObjectReference DroppedItem = WorkContainer.DropFirstObject()
        If(!DroppedItem.HasKeywordInFormList(AE_Legendary4StarList) && DroppedItem.HasKeywordInFormList(AE_Legendary3StarList))
            DroppedItem.Delete()
            AstraCount += 1
        Else
            DroppedItem.Disable()
            AE_CyclingList.AddForm(DroppedItem)
        Endif
    EndWhile
    Return AstraCount
EndFunction

Int Function RecycleItems()
    Int AstraCount = DumpItems() 

    Int FourStarCount = GetItemCountKeywords(AE_Legendary4StarList)
    Int TwoStarCount = GetItemCountKeywords(AE_Legendary2StarList) - FourStarCount
    Int OneStarCount = GetItemCountKeywords(AE_Legendary1StarList) - FourStarCount - TwoStarCount

    Int OneStarTripletsCount = OneStarCount / 3
    AstraCount += OneStarTripletsCount
    OneStarCount -= (OneStarTripletsCount * 3)

    Int TwoStarTripletsCount = TwoStarCount / 3
    AstraCount += TwoStarTripletsCount * 2
    TwoStarCount -= (TwoStarTripletsCount * 3)

    Int FourStarTripletsCount = FourStarCount / 3
    AstraCount += FourStarTripletsCount * 4
    FourStarCount -= (FourStarTripletsCount * 3)

    Int TwoStarFourStarCombinationsCount = Math.Min(TwoStarCount as Float, FourStarCount as Float) as Int
    AstraCount += TwoStarFourStarCombinationsCount * 2
    TwoStarCount -= TwoStarFourStarCombinationsCount
    FourStarCount -= TwoStarFourStarCombinationsCount

    Int OneStarFourStarCombinationsCount = Math.Min((OneStarCount / 2) as Float, FourStarCount as Float) as Int
    AstraCount += OneStarFourStarCombinationsCount * 2
    OneStarCount -= OneStarFourStarCombinationsCount * 2
    FourStarCount -= OneStarFourStarCombinationsCount

    Int OneStarTwoStarCombinationsCount = Math.Min(OneStarCount as Float, TwoStarCount as Float) as Int
    AstraCount += OneStarTwoStarCombinationsCount
    OneStarCount -= OneStarTwoStarCombinationsCount
    TwoStarCount -= OneStarTwoStarCombinationsCount
    
    CleanDumpedItems(AE_Legendary4StarList, FourStarCount)
    CleanDumpedItems(AE_Legendary2StarList, TwoStarCount)
    CleanDumpedItems(AE_Legendary1StarList, OneStarCount)

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