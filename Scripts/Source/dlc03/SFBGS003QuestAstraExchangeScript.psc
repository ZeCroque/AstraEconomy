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

;### Main

Container Property AE_TAHQ_Stache_Vendor_WorkContainer Auto Const Mandatory
ObjectReference WorkContainer

Keyword Property WeaponTypeRanged Auto Const Mandatory
FormList Property WeaponsMeleeList Auto Const Mandatory
Keyword Property ArmorTypeSpacesuitBackpack Auto Const Mandatory
Keyword Property ArmorTypeSpacesuitHelmet Auto Const Mandatory

Int Mode
Int Property Result Auto Conditional

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
    if(!abOpening)
        Actor myPlayer = Game.GetPlayer()
        UnregisterForMenuOpenCloseEvent("ContainerMenu")
        If Mode == 4
            Int AstraTotal = 0
            Int AstraCount = RecycleItems()
            While(AstraCount > 0)
                AstraTotal += AstraCount
                AstraCount = RecycleItems()
            EndWhile
            myPlayer.AddItem(Astra, AstraTotal)
            WorkContainer.RemoveAllItems(myPlayer)
        Else
            Int ItemCount = WorkContainer.GetItemCount() 
            If(ItemCount == 0)
                Result = 0
            ElseIf(ItemCount > 1)
                Result = 1
            Else
                Result = 2
                ObjectReference DroppedItem = WorkContainer.DropFirstObject()
                If DroppedItem.HasKeyword(WeaponTypeRanged) || WeaponsMeleeList.HasForm(DroppedItem)
                    ObjectMod[] FilteredLegendaryWeapon1Star = new ObjectMod[11]
                    ObjectMod[] FilteredLegendaryWeapon2Star = new ObjectMod[11]
                    ObjectMod[] FilteredLegendaryWeapon3Star = new ObjectMod[10]
                    GetLegendaryModsForWeapon(DroppedItem, FilteredLegendaryWeapon1Star, FilteredLegendaryWeapon2Star, FilteredLegendaryWeapon3Star)
                    RerollMods(DroppedItem, FilteredLegendaryWeapon1Star, FilteredLegendaryWeapon2Star, FilteredLegendaryWeapon3Star)
                ElseIf(DroppedItem.HasKeyword(ArmorTypeSpacesuitBackpack))
                    RerollMods(DroppedItem, LegendaryBackpack1Star, LegendaryBackpack2Star, LegendaryBackpack3Star)
                ElseIf(DroppedItem.HasKeyword(ArmorTypeSpacesuitHelmet))
                    RerollMods(DroppedItem, LegendaryHelmet1Star, LegendaryHelmet2Star, LegendaryHelmet3Star)
                Else
                    RerollMods(DroppedItem, LegendarySuit1Star, LegendarySuit2Star, LegendarySuit3Star)
                EndIf
                myPlayer.AddItem(DroppedItem)
            EndIf
            WorkContainer.RemoveAllItems(Game.GetPlayer())
        Endif
    EndIf
EndEvent

Function DoReroll()
    If(Mode > 0)
        If(!WorkContainer)
            WorkContainer = Game.GetPlayer().PlaceAtMe(AE_TAHQ_Stache_Vendor_WorkContainer, 1, true)
        EndIf
        RegisterForMenuOpenCloseEvent("ContainerMenu")
        WorkContainer.OpenOneWayTransferMenu(true, AE_EquipmentList)
    EndIf
EndFunction

Function DoExchange()
    If(!WorkContainer)
        WorkContainer = Game.GetPlayer().PlaceAtMe(AE_TAHQ_Stache_Vendor_WorkContainer, 1, true)
    EndIf
    Mode = 4
    RegisterForMenuOpenCloseEvent("ContainerMenu")
    WorkContainer.OpenOneWayTransferMenu(true, AE_LegendaryList)
EndFunction

;When called, checks to make sure the player has the required number of Astras, and update mode that will dialog output and be used by further entry points
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

;### Cycling

FormList Property AE_EquipmentList Auto Const Mandatory
FormList Property AE_LegendaryList Auto Const Mandatory
FormList Property AE_Legendary1StarList Auto Const Mandatory
FormList Property AE_Legendary2StarList Auto Const Mandatory
FormList Property AE_Legendary3StarList Auto Const Mandatory

ObjectReference[] Inventory

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
    If aiCountToKeep > 0
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
    EndIf
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

;### Rerolling

ObjectMod[] Property LegendaryHelmet1Star Auto Const Mandatory
ObjectMod[] Property LegendaryHelmet2Star Auto Const Mandatory
ObjectMod[] Property LegendaryHelmet3Star Auto Const Mandatory

ObjectMod[] Property LegendarySuit1Star Auto Const Mandatory
ObjectMod[] Property LegendarySuit2Star Auto Const Mandatory
ObjectMod[] Property LegendarySuit3Star Auto Const Mandatory

ObjectMod[] Property LegendaryBackpack1Star Auto Const Mandatory
ObjectMod[] Property LegendaryBackpack2Star Auto Const Mandatory
ObjectMod[] Property LegendaryBackpack3Star Auto Const Mandatory

Keyword Property WeaponTypeLaser Auto Const Mandatory
Keyword Property WeaponTypeParticleBeam Auto Const Mandatory
Keyword Property WeaponTypeShotgun Auto Const Mandatory
Keyword Property WeaponTypeExplosive Auto Const Mandatory
Keyword Property WeaponTypeToolGrip Auto Const Mandatory
Keyword Property WeaponTypeMelee Auto Const Mandatory
Keyword Property HasScope Auto Const Mandatory
Keyword Property HasScopeRecon Auto Const Mandatory
Keyword Property ma_ArcWelder Auto Const Mandatory
Keyword Property ma_Bridger Auto Const Mandatory
Keyword Property ma_Cutter Auto Const Mandatory
Keyword Property ma_MagPulse Auto Const Mandatory
Keyword Property ma_MagShear Auto Const Mandatory
Keyword Property ma_MagShot Auto Const Mandatory
Keyword Property ma_MagStorm Auto Const Mandatory
Keyword Property ma_Microgun Auto Const Mandatory
Keyword Property ma_Novablast Auto Const Mandatory
Keyword Property ma_RocketLauncher Auto Const Mandatory

ObjectMod[] Property LegendaryWeapon1Star Auto Const Mandatory
ObjectMod Property LegendaryWeapon1StarBashing Auto Const Mandatory
ObjectMod Property LegendaryWeapon1StarExtendedMag Auto Const Mandatory
ObjectMod Property LegendaryWeapon1StarInstigating Auto Const Mandatory
ObjectMod Property LegendaryWeapon1StarOxygenated Auto Const Mandatory
ObjectMod Property LegendaryWeapon1StarFurious Auto Const Mandatory
ObjectMod[] Property LegendaryWeapon2Star Auto Const Mandatory
ObjectMod Property LegendaryWeapon2StarHandloading Auto Const Mandatory
ObjectMod Property LegendaryWeapon2StarHitman Auto Const Mandatory
ObjectMod Property LegendaryWeapon2StarLacerate Auto Const Mandatory
ObjectMod Property LegendaryWeapon2StarCorrosive Auto Const Mandatory
ObjectMod Property LegendaryWeapon2StarIncendiary Auto Const Mandatory
ObjectMod Property LegendaryWeapon2StarPoison Auto Const Mandatory
ObjectMod Property LegendaryWeapon2StarRadioactive Auto Const Mandatory
ObjectMod[] Property LegendaryWeapon3Star Auto Const Mandatory
ObjectMod Property LegendaryWeapon3StarConcussive Auto Const Mandatory
ObjectMod Property LegendaryWeapon3StarDespondent Auto Const Mandatory
ObjectMod Property LegendaryWeapon3StarFrenzy Auto Const Mandatory
ObjectMod Property LegendaryWeapon3StarElemental Auto Const Mandatory
ObjectMod Property LegendaryWeapon3StarExplosive Auto Const Mandatory
ObjectMod Property LegendaryWeapon3StarOneInchPunch Auto Const Mandatory
ObjectMod Property LegendaryWeapon3StarSkipShot Auto Const Mandatory
ObjectMod Property LegendaryWeapon3StarTesla Auto Const Mandatory

Function FillArray(ObjectMod[] akArrayA, ObjectMod[] akArrayB)
    Int i = 0
    While i < akArrayB.Length
        ObjectMod tmp = akArrayB[i]
        akArrayA[i] = tmp
        i += 1
    EndWhile
EndFunction

Function GetLegendaryModsForWeapon(ObjectReference akItem, ObjectMod[] Legendary1Star, ObjectMod[] Legendary2Star, ObjectMod[] Legendary3Star)
    Int i = LegendaryWeapon1Star.Length
    FillArray(Legendary1Star, LegendaryWeapon1Star)
    If akItem.HasKeyword(WeaponTypeRanged)
        Legendary1Star[i] = LegendaryWeapon1StarBashing
        i += 1
        If !akItem.HasKeyword(ma_Cutter) && !akItem.HasKeyword(ma_Bridger)
            Legendary1Star[i] = LegendaryWeapon1StarExtendedMag
            i += 1
        EndIf
    ElseIf akItem.HasKeyword(HasScope) || akItem.HasKeyword(HasScopeRecon)
            Legendary1Star[i] = LegendaryWeapon1StarOxygenated
            i += 1
    ElseIf !akItem.HasKeyword(WeaponTypeShotgun)
        Legendary1Star[i] = LegendaryWeapon1StarInstigating
        i += 1
    ElseIf !akItem.HasKeyword(ma_RocketLauncher) &&  !akItem.HasKeyword(ma_Cutter) && !akItem.HasKeyword(ma_Bridger) &&  !akItem.HasKeyword(ma_ArcWelder)
        Legendary1Star[i] = LegendaryWeapon1StarFurious
        i += 1
    EndIf

    i = LegendaryWeapon2Star.Length
    FillArray(Legendary2Star, LegendaryWeapon2Star)
    If akItem.HasKeyword(WeaponTypeRanged)
        Legendary2Star[i] = LegendaryWeapon2StarHitman
        i += 1
    ElseIf !akItem.HasKeyword(ma_Novablast)
        Legendary2Star[i] = LegendaryWeapon2StarLacerate
        i += 1
        Legendary2Star[i] = LegendaryWeapon2StarCorrosive
        i += 1
        Legendary2Star[i] = LegendaryWeapon2StarIncendiary
        i += 1
        Legendary2Star[i] = LegendaryWeapon2StarRadioactive
        i += 1
        Legendary2Star[i] = LegendaryWeapon2StarPoison
        i += 1
    ElseIf !akItem.HasKeyword(WeaponTypeMelee) && !akItem.HasKeyword(WeaponTypeLaser) && !akItem.HasKeyword(WeaponTypeParticleBeam)
        Legendary2Star[i] = LegendaryWeapon2StarHandloading
        i += 1
    EndIf

    i = LegendaryWeapon3Star.Length
    FillArray(Legendary3Star, LegendaryWeapon3Star)
    If akItem.HasKeyword(WeaponTypeRanged)
        Legendary3Star[i] = LegendaryWeapon3StarSkipShot
        i += 1
        If !akItem.HasKeyword(ma_Novablast) && !akItem.HasKeyword(ma_MagStorm) && !akItem.HasKeyword(ma_MagShear) && !akItem.HasKeyword(ma_MagPulse)
            Legendary3Star[i] = LegendaryWeapon3StarTesla
            i += 1
        EndIf
    ElseIf !akItem.HasKeyword(ma_Novablast)
        Legendary3Star[i] = LegendaryWeapon3StarDespondent
        i += 1
        Legendary3Star[i] = LegendaryWeapon3StarFrenzy
        i += 1
        Legendary3Star[i] = LegendaryWeapon3StarElemental
        i += 1
    ElseIf !akItem.HasKeyword(ma_Microgun) && !akItem.HasKeyword(ma_MagStorm) && !akItem.HasKeyword(ma_MagShear)
        Legendary3Star[i] = LegendaryWeapon3StarConcussive
        i += 1
    ElseIf !akItem.HasKeyword(WeaponTypeMelee) && !akItem.HasKeyword(ma_RocketLauncher) && !akItem.HasKeyword(ma_Novablast) && !akItem.HasKeyword(ma_Bridger) && !akItem.HasKeyword(WeaponTypeToolGrip)  
        Legendary3Star[i] = LegendaryWeapon3StarExplosive
        i += 1
    ElseIf !akItem.HasKeyword(WeaponTypeMelee) && !akItem.HasKeyword(WeaponTypeExplosive) && !akItem.HasKeyword(ma_Microgun) && !akItem.HasKeyword(ma_MagStorm) && !akItem.HasKeyword(ma_MagShear) && !akItem.HasKeyword(ma_MagShot) && !akItem.HasKeyword(ma_MagPulse) && !akItem.HasKeyword(WeaponTypeShotgun) && !akItem.HasKeyword(WeaponTypeToolGrip)  
        Legendary3Star[i] = LegendaryWeapon3StarOneInchPunch
        i += 1
    EndIf
EndFunction

Function RerollMods(ObjectReference akItem, ObjectMod[] akMods1Star, ObjectMod[] akMods2Star, ObjectMod[] akMods3Star)
    If Mode == 1
        akItem.AttachMod(akMods1Star[Utility.RandomInt(0, akMods1Star.Length - 1)], 0)
    ElseIf Mode == 2
        akItem.AttachMod(akMods1Star[Utility.RandomInt(0, akMods1Star.Length - 1)], 0)
        akItem.AttachMod(akMods2Star[Utility.RandomInt(0, akMods2Star.Length - 1)], 0)
    Else
        akItem.AttachMod(akMods1Star[Utility.RandomInt(0, akMods1Star.Length - 1)], 0)
        akItem.AttachMod(akMods2Star[Utility.RandomInt(0, akMods2Star.Length - 1)], 0)
        akItem.AttachMod(akMods3Star[Utility.RandomInt(0, akMods3Star.Length - 1)], 0)
    Endif
EndFunction