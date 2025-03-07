EndOfBattle:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .notLinkBattle
; link battle
	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1Status
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [wEnemyMonStatus]
	ld [hl], a
	call ClearScreen
	callfar DisplayLinkBattleVersusTextBox
	ld a, [wBattleResult]
	cp $1
	ld de, YouWinText
	jr c, .placeWinOrLoseString
	ld de, YouLoseText
	jr z, .placeWinOrLoseString
	ld de, DrawText
.placeWinOrLoseString
	hlcoord 6, 8
	call PlaceString
	ld c, 200
	call DelayFrames
	jr .evolution
.notLinkBattle
	ld a, [wBattleResult]
	and a
	jr nz, .resetVariables
	ld hl, wTotalPayDayMoney
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	jr z, .evolution ; if pay day money is 0, jump
	ld de, wPlayerMoney + 2
	ld c, $3
	predef AddBCDPredef
	ld hl, PickUpPayDayMoneyText
	call PrintText
.evolution
	xor a
	ld [wForceEvolution], a
	predef EvolutionAfterBattle
.resetVariables
	xor a
	ld [wLowHealthAlarm], a ;disable low health alarm
	ld [wChannelSoundIDs + CHAN5], a
	ld [wIsInBattle], a
	ld [wBattleType], a
	ld [wMoveMissed], a
	ld [wCurOpponent], a
	ld [wForcePlayerToChooseMon], a
	ld [wNumRunAttempts], a
	ld [wEscapedFromBattle], a
	ld hl, wPartyAndBillsPCSavedMenuItem
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wListScrollOffset], a
	ld hl, wPlayerStatsToDouble
	ld b, $18
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ld hl, wStatusFlags2
	set BIT_WILD_ENCOUNTER_COOLDOWN, [hl]
	call WaitForSoundToFinish
	call GBPalWhiteOut
	ld a, $ff
	ld [wDestinationWarpID], a

.setLorelei:
    ld a, OPP_LORELEI          ; LORELEI constant defined in trainer_constants.asm
    ld [wEngagedTrainerClass], a
    ld a, 1              ; sample set for Lorelei
    ld [wEngagedTrainerSet], a
    jr .continueBattle

.setBruno:
    ld a, OPP_BRUNO            ; constant for Bruno
    ld [wEngagedTrainerClass], a
    ld a, 1                ; sample set for Bruno
    ld [wEngagedTrainerSet], a
    jr .continueBattle

.setAgatha:
    ld a, OPP_AGATHA           ; constant for Agatha
    ld [wEngagedTrainerClass], a
    ld a, 1                ; sample set for Agatha
    ld [wEngagedTrainerSet], a
    jr .continueBattle

.setLance:
    ld a, OPP_LANCE            ; constant for Lance
    ld [wEngagedTrainerClass], a
    ld a, 1                ; sample set for Lance
    ld [wEngagedTrainerSet], a
    jr .continueBattle

.continueBattle:
    ; --- Reset input state so menu navigation works correctly ---
    xor a
    ld [wJoyIgnore], a
    ld [wSimulatedJoypadStatesIndex], a
    ld [wSimulatedJoypadStatesEnd], a

    ; --- Additional resets (example) ---
    ld [wIsInBattle], a          ; Ensure battle mode flag is cleared
    ; Optionally clear any additional input/mode flags:
    ; ld [wMenuActiveFlag], a     ; if such a flag is used for menus

    ; --- End reset ---

    ; Ajout d'un délai entre les combats
    ld c, 100      ; nombre de frames à attendre (ajustez la valeur si besoin)
    call DelayFrames

    call StartTrainerBattle
    ret
    ; --- Fin ajout ---

YouWinText:
	db "YOU WIN@"

YouLoseText:
	db "YOU LOSE@"

DrawText:
	db "  DRAW@"

PickUpPayDayMoneyText:
	text_far _PickUpPayDayMoneyText
	text_end
