Scriptname DLC03:SFBGS003QuestAstraExchangeScript extends Quest Conditional

GlobalVariable Property SFBGS003_Astras_SmallAmount Mandatory Const Auto
GlobalVariable Property SFBGS003_Astras_MedAmount Mandatory Const Auto
GlobalVariable Property SFBGS003_Astras_LargeAmount Mandatory Const Auto
Message Property SFBGS003_AstrasErrorMSG Mandatory Const Auto
MiscObject Property Astra Mandatory Const Auto
LeveledItem Property SFBGS003_LL_Astras_1Star Mandatory Const Auto
LeveledItem Property SFBGS003_LL_Astras_2Star Mandatory Const Auto
LeveledItem Property SFBGS003_LL_Astras_3Star Mandatory Const Auto

Guard AstraExchangeDataGuard ProtectsFunctionLogic

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
    if(!abOpening)
        Debug.Trace("nvdkj")
        Actor myPlayer = Game.GetPlayer()
        UnregisterForMenuOpenCloseEvent("ContainerMenu")
        ObjectReference DroppedItem = AstraRerollContainerRef.DropFirstObject()
        ObjectReference SecondDroppedItem = AstraRerollContainerRef.DropFirstObject()
        If(DroppedItem)
            If(SecondDroppedItem)
                Debug.Trace("Too many item")
                Result = 1
                myPlayer.AddItem(SecondDroppedItem, 1, true)
                AstraRerollContainerRef.RemoveAllItems(Game.GetPlayer())
            Else
                Debug.Trace(DroppedItem)
                DroppedItem.AttachMod(LegendaryMod, 0)
                Result = 2
            EndIf
            myPlayer.AddItem(DroppedItem, 1, true)
        Else  
            Debug.Trace("No item")
            Result = 0
        EndIf
    endif
EndEvent

Function DoExchange()
    If(Mode > 0)
        If(!AstraRerollContainerRef)
            AstraRerollContainerRef = Game.GetPlayer().PlaceAtMe(AE_TAHQ_Stache_Vendor_WorkContainer)
        EndIf
        RegisterForMenuOpenCloseEvent("ContainerMenu")
        AstraRerollContainerRef.OpenOneWayTransferMenu(true)
    EndIf
EndFunction

;When called, checks to make sure the player has the required number of Astras, then gives the appropriate level of of item.
Function AstraExchange(Int aiAstras)
    LockGuard AstraExchangeDataGuard
        Actor myPlayer = Game.GetPlayer()
        If myPlayer.GetItemCount(Astra) >= aiAstras
            If aiAstras == SFBGS003_Astras_SmallAmount.GetValue()
                Mode = 1
            ElseIf aiAstras == SFBGS003_Astras_MedAmount.GetValue()
                Mode = 2
            ElseIf aiAstras == SFBGS003_Astras_LargeAmount.GetValue()
                Mode = 3
            EndIf
        Else
            Mode = 0
            SFBGS003_AstrasErrorMSG.Show()
        EndIf
    EndLockGuard
EndFunction

Container Property AE_TAHQ_Stache_Vendor_WorkContainer Auto Const Mandatory
ObjectReference Property AstraRerollContainerRef Auto
Int Property Result Auto Conditional
Int Property Mode Auto

ObjectMod Property LegendaryMod Auto Const Mandatory
