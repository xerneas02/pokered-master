InitPlayerData:
InitPlayerData2:

	call Random
	ldh a, [hRandomSub]
	ld [wPlayerID], a

	call Random
	ldh a, [hRandomAdd]
	ld [wPlayerID + 1], a

	ld a, $ff
	ld [wUnusedPlayerDataByte], a

	ld hl, wPartyCount
	call InitializeEmptyList
	ld hl, wBoxCount
	call InitializeEmptyList
	ld hl, wNumBagItems
	call InitializeEmptyList
	ld hl, wNumBoxItems
	call InitializeEmptyList

DEF START_MONEY EQU $3000
	ld hl, wPlayerMoney + 1
	ld a, HIGH(START_MONEY)
	ld [hld], a
	xor a ; LOW(START_MONEY)
	ld [hli], a
	inc hl
	ld [hl], a

	ld [wMonDataLocation], a

	ld hl, wObtainedBadges
	ld [hli], a
	ASSERT wObtainedBadges + 1 == wUnusedObtainedBadges
	ld [hl], a

	ld hl, wPlayerCoins
	ld [hli], a
	ld [hl], a

	ld hl, wGameProgressFlags
	ld bc, wGameProgressFlagsEnd - wGameProgressFlags
	call FillMemory ; clear all game progress flags

	; Vider l'équipe du joueur (initialise le compteur à zéro)
	ld hl, wPartyCount
	call InitializeEmptyList

	; ----------------------------------------
	; Ajout de Charizard – Niveau 55
	ld a, CHARIZARD            ; constante pour Charizard (doit être définie)
	ld [wCurPartySpecies], a   ; définir l'espèce actuelle du Pokémon à ajouter
	ld a, 55                   ; niveau 55
	ld [wCurEnemyLevel], a     ; ici, la variable utilisée par _AddPartyMon pour le niveau
	xor a                      ; réinitialiser A pour la donnée de position dans l'équipe
	ld [wMonDataLocation], a   ; définir la position de stockage (premier emplacement disponible)
	call _AddPartyMon          ; ajouter Charizard à l'équipe

	; ----------------------------------------
	; Ajout de Raichu – Niveau 53
	ld a, RAICHU               ; constante pour Raichu
	ld [wCurPartySpecies], a
	ld a, 53                   ; niveau 53
	ld [wCurEnemyLevel], a
	xor a
	ld [wMonDataLocation], a
	call _AddPartyMon

	; ----------------------------------------
	; Ajout de Starmie – Niveau 54
	ld a, STARMIE              ; constante pour Starmie
	ld [wCurPartySpecies], a
	ld a, 54                   ; niveau 54
	ld [wCurEnemyLevel], a
	xor a
	ld [wMonDataLocation], a
	call _AddPartyMon

	; ----------------------------------------
	; Ajout de Rhydon – Niveau 56
	ld a, RHYDON               ; constante pour Rhydon
	ld [wCurPartySpecies], a
	ld a, 56                   ; niveau 56
	ld [wCurEnemyLevel], a
	xor a
	ld [wMonDataLocation], a
	call _AddPartyMon

	; ----------------------------------------
	; Ajout d'Exeggutor – Niveau 55
	ld a, EXEGGUTOR            ; constante pour Exeggutor
	ld [wCurPartySpecies], a
	ld a, 55                   ; niveau 55
	ld [wCurEnemyLevel], a
	xor a
	ld [wMonDataLocation], a
	call _AddPartyMon

	; ----------------------------------------
	; Ajout de Pidgeot – Niveau 54
	ld a, PIDGEOT              ; constante pour Pidgeot
	ld [wCurPartySpecies], a
	ld a, 54                   ; niveau 54
	ld [wCurEnemyLevel], a
	xor a
	ld [wMonDataLocation], a
	call _AddPartyMon

	jp InitializeMissableObjectsFlags

InitializeEmptyList:
	xor a ; count
	ld [hli], a
	dec a ; terminator
	ld [hl], a
	ret
