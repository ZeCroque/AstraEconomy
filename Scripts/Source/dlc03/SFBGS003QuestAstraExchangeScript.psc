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

ObjectReference[] Inventory

Function GiveBackItemsOfType(FormList akType, Int aiCount) ;Rename
    If aiCount > 0
        Int i = 0
        Int j = 0
        While i < Inventory.Length && (Inventory[i])
            If(j < aiCount && Inventory[i].HasKeywordInFormList(akType))
                AstraRerollContainerRef.AddItem(Inventory[i])
                j += 1
            Else
                Inventory[i].Delete()
            EndIf
            i += 1
        EndWhile
    EndIf
EndFunction

;Method with the same name in ObjectReference does not work, so recoded it
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

Int Function DumpItems()  ;Also handles 3stars
    Inventory = new ObjectReference[Math.Min(128.0, AstraRerollContainerRef.GetItemCount() as Float) as Int]

    Int AstraCount = 0
    Int i = 0
    While AstraRerollContainerRef.GetItemCount() > 0 
        ObjectReference DroppedItem = AstraRerollContainerRef.DropFirstObject()
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

    GiveBackItemsOfType(AE_Legendary1StarList, OneStarCount)
    GiveBackItemsOfType(AE_Legendary2StarList, TwoStarCount)

    Return AstraCount
EndFunction

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
            AstraRerollContainerRef.RemoveAllItems(myPlayer)
        Else
            ObjectReference DroppedItem = AstraRerollContainerRef.DropFirstObject()
            ObjectReference SecondDroppedItem = AstraRerollContainerRef.DropFirstObject()
            If(DroppedItem)
                If(SecondDroppedItem)
                    Result = 1
                    myPlayer.AddItem(SecondDroppedItem)
                    AstraRerollContainerRef.RemoveAllItems(Game.GetPlayer())
                Else
                    Result = 2
                    If DroppedItem.HasKeyword(WeaponTypeRanged) || WeaponsMeleeList.HasForm(DroppedItem)
                        Int i = LegendaryWeapon1Star.Length
                        ObjectMod[] Legendary1Star = new ObjectMod[11]
                        FillArray(Legendary1Star, LegendaryWeapon1Star)
                        If DroppedItem.HasKeyword(WeaponTypeRanged)
                            Legendary1Star[i] = LegendaryWeapon1StarBashing
                            i += 1
                            If !DroppedItem.HasKeyword(ma_Cutter) && !DroppedItem.HasKeyword(ma_Bridger)
                                Legendary1Star[i] = LegendaryWeapon1StarExtendedMag
                                i += 1
                            EndIf
                        ElseIf DroppedItem.HasKeyword(HasScope) || DroppedItem.HasKeyword(HasScopeRecon)
                                Legendary1Star[i] = LegendaryWeapon1StarOxygenated
                                i += 1
                        ElseIf !DroppedItem.HasKeyword(WeaponTypeShotgun)
                            Legendary1Star[i] = LegendaryWeapon1StarInstigating
                            i += 1
                        ElseIf !DroppedItem.HasKeyword(ma_RocketLauncher) &&  !DroppedItem.HasKeyword(ma_Cutter) && !DroppedItem.HasKeyword(ma_Bridger) &&  !DroppedItem.HasKeyword(ma_ArcWelder)
                            Legendary1Star[i] = LegendaryWeapon1StarFurious
                            i += 1
                        EndIf

                        i = LegendaryWeapon2Star.Length
                        ObjectMod[] Legendary2Star = new ObjectMod[11]
                        FillArray(Legendary2Star, LegendaryWeapon2Star)
                        If DroppedItem.HasKeyword(WeaponTypeRanged)
                            Legendary2Star[i] = LegendaryWeapon2StarHitman
                            i += 1
                        ElseIf !DroppedItem.HasKeyword(ma_Novablast)
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
                        ElseIf !DroppedItem.HasKeyword(WeaponTypeMelee) && !DroppedItem.HasKeyword(WeaponTypeLaser) && !DroppedItem.HasKeyword(WeaponTypeParticleBeam)
                            Legendary2Star[i] = LegendaryWeapon2StarHandloading
                            i += 1
                        EndIf

                        i = LegendaryWeapon3Star.Length
                        ObjectMod[] Legendary3Star = new ObjectMod[10]
                        FillArray(Legendary3Star, LegendaryWeapon3Star)
                        If DroppedItem.HasKeyword(WeaponTypeRanged)
                            Legendary3Star[i] = LegendaryWeapon3StarSkipShot
                            i += 1
                            If !DroppedItem.HasKeyword(ma_Novablast) && !DroppedItem.HasKeyword(ma_MagStorm) && !DroppedItem.HasKeyword(ma_MagShear) && !DroppedItem.HasKeyword(ma_MagPulse)
                                Legendary3Star[i] = LegendaryWeapon3StarTesla
                                i += 1
                            EndIf
                        ElseIf !DroppedItem.HasKeyword(ma_Novablast)
                            Legendary3Star[i] = LegendaryWeapon3StarDespondent
                            i += 1
                            Legendary3Star[i] = LegendaryWeapon3StarFrenzy
                            i += 1
                            Legendary3Star[i] = LegendaryWeapon3StarElemental
                            i += 1
                        ElseIf !DroppedItem.HasKeyword(ma_Microgun) && !DroppedItem.HasKeyword(ma_MagStorm) && !DroppedItem.HasKeyword(ma_MagShear)
                            Legendary3Star[i] = LegendaryWeapon3StarConcussive
                            i += 1
                        ElseIf !DroppedItem.HasKeyword(WeaponTypeMelee) && !DroppedItem.HasKeyword(ma_RocketLauncher) && !DroppedItem.HasKeyword(ma_Novablast) && !DroppedItem.HasKeyword(ma_Bridger) && !DroppedItem.HasKeyword(WeaponTypeToolGrip)  
                            Legendary3Star[i] = LegendaryWeapon3StarExplosive
                            i += 1
                        ElseIf !DroppedItem.HasKeyword(WeaponTypeMelee) && !DroppedItem.HasKeyword(WeaponTypeExplosive) && !DroppedItem.HasKeyword(ma_Microgun) && !DroppedItem.HasKeyword(ma_MagStorm) && !DroppedItem.HasKeyword(ma_MagShear) && !DroppedItem.HasKeyword(ma_MagShot) && !DroppedItem.HasKeyword(ma_MagPulse) && !DroppedItem.HasKeyword(WeaponTypeShotgun) && !DroppedItem.HasKeyword(WeaponTypeToolGrip)  
                            Legendary3Star[i] = LegendaryWeapon3StarOneInchPunch
                            i += 1
                        EndIf

                        RerollMods(DroppedItem, Legendary1Star, Legendary2Star, Legendary3Star)
                    ElseIf(DroppedItem.HasKeyword(ArmorTypeSpacesuitBackpack))
                        RerollMods(DroppedItem, LegendaryBackpack1Star, LegendaryBackpack2Star, LegendaryBackpack3Star)
                    ElseIf(DroppedItem.HasKeyword(ArmorTypeSpacesuitHelmet))
                        RerollMods(DroppedItem, LegendaryHelmet1Star, LegendaryHelmet2Star, LegendaryHelmet3Star)
                    Else
                        RerollMods(DroppedItem, LegendarySuit1Star, LegendarySuit2Star, LegendarySuit3Star)
                    EndIf
                EndIf
                myPlayer.AddItem(DroppedItem)
            Else  
                Result = 0
            EndIf
        Endif
    EndIf
EndEvent

Function FillArray(ObjectMod[] akArrayA, ObjectMod[] akArrayB)
    Int i = 0
    While i < akArrayB.Length
        ObjectMod tmp = akArrayB[i]
        akArrayA[i] = tmp
        i += 1
    EndWhile
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

Function DoReroll()
    If(Mode > 0)
        If(!AstraRerollContainerRef)
            AstraRerollContainerRef = Game.GetPlayer().PlaceAtMe(AE_TAHQ_Stache_Vendor_WorkContainer)
        EndIf
        RegisterForMenuOpenCloseEvent("ContainerMenu")
        AstraRerollContainerRef.OpenOneWayTransferMenu(true, AE_EquipmentList)
    EndIf
EndFunction

Function DoExchange()
    If(!AstraRerollContainerRef)
        AstraRerollContainerRef = Game.GetPlayer().PlaceAtMe(AE_TAHQ_Stache_Vendor_WorkContainer)
    EndIf
    Mode = 4
    RegisterForMenuOpenCloseEvent("ContainerMenu")
    AstraRerollContainerRef.OpenOneWayTransferMenu(true, AE_LegendaryList) ;TODO legendary items list
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

ObjectMod[] Property LegendaryWeapon1Star Auto Const Mandatory

ObjectMod[] Property LegendaryWeapon2Star Auto Const Mandatory

ObjectMod[] Property LegendaryWeapon3Star Auto Const Mandatory

ObjectMod[] Property LegendaryHelmet1Star Auto Const Mandatory

ObjectMod[] Property LegendaryHelmet2Star Auto Const Mandatory

ObjectMod[] Property LegendaryHelmet3Star Auto Const Mandatory

ObjectMod[] Property LegendarySuit1Star Auto Const Mandatory

ObjectMod[] Property LegendarySuit2Star Auto Const Mandatory

ObjectMod[] Property LegendarySuit3Star Auto Const Mandatory

ObjectMod[] Property LegendaryBackpack1Star Auto Const Mandatory

ObjectMod[] Property LegendaryBackpack2Star Auto Const Mandatory

ObjectMod[] Property LegendaryBackpack3Star Auto Const Mandatory

ObjectMod Property LegendaryWeapon1StarBashing Auto Const Mandatory

ObjectMod Property LegendaryWeapon1StarExtendedMag Auto Const Mandatory

ObjectMod Property LegendaryWeapon1StarOxygenated Auto Const Mandatory

ObjectMod Property LegendaryWeapon1StarInstigating Auto Const Mandatory

ObjectMod Property LegendaryWeapon1StarFurious Auto Const Mandatory

ObjectMod Property LegendaryWeapon2StarHitman Auto Const Mandatory

ObjectMod Property LegendaryWeapon2StarLacerate Auto Const Mandatory

ObjectMod Property LegendaryWeapon2StarCorrosive Auto Const Mandatory

ObjectMod Property LegendaryWeapon2StarIncendiary Auto Const Mandatory

ObjectMod Property LegendaryWeapon2StarRadioactive Auto Const Mandatory

ObjectMod Property LegendaryWeapon2StarPoison Auto Const Mandatory

ObjectMod Property LegendaryWeapon2StarHandloading Auto Const Mandatory

ObjectMod Property LegendaryWeapon3StarSkipShot Auto Const Mandatory

ObjectMod Property LegendaryWeapon3StarTesla Auto Const Mandatory

ObjectMod Property LegendaryWeapon3StarConcussive Auto Const Mandatory

ObjectMod Property LegendaryWeapon3StarFrenzy Auto Const Mandatory

ObjectMod Property LegendaryWeapon3StarExplosive Auto Const Mandatory

ObjectMod Property LegendaryWeapon3StarOneInchPunch Auto Const Mandatory

ObjectMod Property LegendaryWeapon3StarElemental Auto Const Mandatory

Keyword Property WeaponTypeRanged Auto Const Mandatory

Keyword Property WeaponTypeMelee Auto Const Mandatory

Keyword Property HasScope Auto Const Mandatory

Keyword Property HasScopeRecon Auto Const Mandatory

Keyword Property ma_Cutter Auto Const Mandatory

Keyword Property ma_Bridger Auto Const Mandatory

Keyword Property WeaponTypeShotgun Auto Const Mandatory

Keyword Property ma_RocketLauncher Auto Const Mandatory

Keyword Property ma_ArcWelder Auto Const Mandatory

Keyword Property ma_Novablast Auto Const Mandatory

Keyword Property WeaponTypeLaser Auto Const Mandatory

Keyword Property WeaponTypeParticleBeam Auto Const Mandatory

Keyword Property ma_Microgun Auto Const Mandatory

Keyword Property ma_MagStorm Auto Const Mandatory

Keyword Property ma_MagShear Auto Const Mandatory

Keyword Property WeaponTypeToolGrip Auto Const Mandatory

Keyword Property WeaponTypeExplosive Auto Const Mandatory

Keyword Property ma_MagShot Auto Const Mandatory

Keyword Property ma_MagPulse Auto Const Mandatory

Keyword Property ArmorTypeSpacesuitBackpack Auto Const Mandatory

Keyword Property ArmorTypeSpacesuitHelmet Auto Const Mandatory

FormList Property WeaponsMeleeList Auto Const Mandatory

ObjectMod Property LegendaryWeapon3StarDespondent Auto Const Mandatory

FormList Property AE_EquipmentList Auto Const Mandatory

FormList Property AE_LegendaryList Auto Const Mandatory
FormList Property AE_Legendary1StarList Auto Const Mandatory


FormList Property AE_Legendary2StarList Auto Const Mandatory

FormList Property AE_Legendary3StarList Auto Const Mandatory
