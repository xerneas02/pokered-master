PUBLIC CustomBattleEvent

CustomBattleEvent:
    ; Eventuellement, afficher un message ou animer quelque chose
    ; call PrintCustomMessage   ; Par exemple, afficher "Quelque chose se passe..."
    ; Reinitialisation eventuelle de l'ecran ou du state
    call ClearScreen

    ; --- Selection aleatoire d'un dresseur ---
    call Random                ; retourne un nombre aleatoire dans A
    and 3                    ; limiter a 0-3
    cp 0
    jp z, .setTrainer0
    cp 1
    jp z, .setTrainer1
    cp 2
    jp z, .setTrainer2
    ; sinon, valeur 3
.setTrainer3:
    ld a, OPP_SAILOR         ; Utilise la constante defini pour SAILOR
    ld [wEngagedTrainerClass], a
    ld a, 4                  ; Exemple : "mon set" pour SAILOR
    ld [wEngagedTrainerSet], a
    jr .startBattle

.setTrainer0:
    ld a, OPP_YOUNGSTER      ; Utilise la constante pour YOUNGSTER
    ld [wEngagedTrainerClass], a
    ld a, 5                  ; Exemple : "mon set" pour YOUNGSTER
    ld [wEngagedTrainerSet], a
    jr .startBattle

.setTrainer1:
    ld a, OPP_BUG_CATCHER      ; Utilise la constante pour BUG_CATCHER
    ld [wEngagedTrainerClass], a
    ld a, 3                  ; Exemple : "mon set" pour BUG_CATCHER
    ld [wEngagedTrainerSet], a
    jr .startBattle

.setTrainer2:
    ld a, OPP_LASS           ; Utilise la constante pour LASS
    ld [wEngagedTrainerClass], a
    ld a, 2                  ; Exemple : "mon set" pour LASS

.startBattle:
    ; --- Reinitialiser l'etat d'input (si necessaire) ---
    xor a
    ld [wJoyIgnore], a
    ld [wSimulatedJoypadStatesIndex], a
    ld [wSimulatedJoypadStatesEnd], a
    ld [wIsInBattle], a          ; S'assurer que le flag de combat est reinitialise

    ; Optionnel : ajouter un delai si besoin
    ld c, 60                 ; 60 frames d'attente par exemple
    call DelayFrames

    ; Demarrer le combat
    call StartTrainerBattle
    ret