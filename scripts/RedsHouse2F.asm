;wPlayerX EQU $D362
;wPlayerY EQU $D361

RedsHouse2F_Script:
    call EnableAutoTextBoxDrawing
    ld hl, RedsHouse2F_ScriptPointers
    ld a, [wRedsHouse2FCurScript]
    jp CallFunctionInTable

RedsHouse2F_ScriptPointers:
    def_script_pointers
    dw_const RedsHouse2FDefaultScript, SCRIPT_REDSHOUSE2F_DEFAULT
    dw_const RedsHouse2FNoopScript,    SCRIPT_REDSHOUSE2F_NOOP

RedsHouse2FDefaultScript:
    xor a
    ldh [hJoyHeld], a
    ld a, PLAYER_DIR_UP
    ld [wPlayerMovingDirection], a
    ld a, SCRIPT_REDSHOUSE2F_NOOP
    ld [wRedsHouse2FCurScript], a

    ; --- Test to trigger the custom event when the player is at fixed coordinates (4,6) ---
    call CheckIfCustomBattleShouldTrigger

    ret

RedsHouse2FNoopScript:
    ret

RedsHouse2F_TextPointers:
    def_text_pointers
    text_end ; unused

; Example: verify the player's position (4,6)
CheckIfCustomBattleShouldTrigger:
    ;ld a,($D361)         ; current player X coordinate
    ;cp $04                    ; compare with fixed coordinate 4
    ;jr nz, .exitCheck

    ;ld a,($D362)         ; current player Y coordinate
    ;cp $06                    ; compare with fixed coordinate 6
    ;jr nz, .exitCheck

    ; If both comparisons succeed, the player is on (4,6)
    call CustomBattleEvent
.exitCheck:
    ret

CustomBattleEvent:
    ; (Optional) Display a message or animation
    call ClearScreen

    ; --- Random opponent selection ---
    call Random                ; returns a random number in A
    and 3                    ; limit the value to 0-3
    cp 0
    jp z, .setTrainer0
    cp 1
    jp z, .setTrainer1
    cp 2
    jp z, .setTrainer2
    ; Otherwise, use value 3:
.setTrainer3:
    ld a, OPP_SAILOR         ; use constant for SAILOR
    ld [wEngagedTrainerClass], a
    ld a, 4                  ; sample "mon set" for SAILOR
    ld [wEngagedTrainerSet], a
    jr .startBattle

.setTrainer0:
    ld a, OPP_YOUNGSTER      ; use constant for YOUNGSTER
    ld [wEngagedTrainerClass], a
    ld a, 5                  ; sample "mon set" for YOUNGSTER
    ld [wEngagedTrainerSet], a
    jr .startBattle

.setTrainer1:
    ld a, OPP_BUG_CATCHER      ; use constant for BUG_CATCHER
    ld [wEngagedTrainerClass], a
    ld a, 3                  ; sample "mon set" for BUG_CATCHER
    ld [wEngagedTrainerSet], a
    jr .startBattle

.setTrainer2:
    ld a, OPP_LASS           ; use constant for LASS
    ld [wEngagedTrainerClass], a
    ld a, 2                  ; sample "mon set" for LASS

.startBattle:
    ; --- Reset de l'etat d'input (si necessaire) ---
    xor a
    ld [wJoyIgnore], a
    ld [wSimulatedJoypadStatesIndex], a
    ld [wSimulatedJoypadStatesEnd], a
    ld [wIsInBattle], a

    ; Mettre le niveau du premier Pokémon du joueur au meme niveau que le dresseur.
    ; Ici, on suppose que la valeur choisie (ex : 5 pour un jeune dresseur) est
    ; stockée dans wEngagedTrainerSet.
    ld a, [$D8C5]
    ld [$D16E], a

    ; Optionnel : ajouter un delai
    ld c, 60
    call DelayFrames

    ; Demarrer le combat
    call StartTrainerBattle
    ret

; This is an example debug routine – adjust it to match your project’s routines.
; Assume you have a routine "ConvertByteToStr" that converts the value in A to an ASCII string at a fixed buffer.
; Also assume you have a working PrintText routine to display text.

; Conversion routine: converts the value in A into a 2-digit hexadecimal string
; stored at DebugBuffer (null-terminated). Adjust if you prefer decimal.
;
; Uses a simple nibble loop (since the Game Boy doesn't have direct shift instructions).
ConvertByteToStr:
    push bc
    push de
    push hl

    ; Save original A in B for later use
    ld b, a

    ; Calculate high nibble (divide by 16)
    ld d, 0               ; This will hold our high nibble count
HighNibbleLoop:
    cp $10                ; Compare A with 16
    jr c, AfterHighNibble
    sub $10
    inc d
    jr HighNibbleLoop
AfterHighNibble:
    ; d now holds high nibble (0–15)
    ld hl, HexDigits      ; Lookup table address
    ld a, d
    add a, l            ; If your lookup table is contiguous (like "0123456789ABCDEF")
    ld a, [hl]          ; Get the ASCII digit
    ld hl, DebugBuffer
    ld [hl], a         ; Store in DebugBuffer[0]

    ; Process low nibble
    ld a, b            ; restore original A
    and $0F           ; isolate low nibble
    ld d, a           ; save low nibble in D

    ld hl, HexDigits
    ld a, d
    add a, l
    ld a, [hl]      ; Get corresponding ASCII digit
    ld hl, DebugBuffer
    inc hl
    ld [hl], a     ; Store in DebugBuffer[1]

    ; Null-terminate the string
    inc hl
    ld a, 0
    ld [hl], a

    pop hl
    pop de
    pop bc
    ret

HexDigits:
    db "0123456789ABCDEF"

; Debug routine to display the player's X and Y values.
; This is similar in spirit to how oak_speech.asm prints strings.
DebugDisplayPlayerPos:
    ; Print "X: "
    ld hl, DebugXLabel
    call PrintText

    ; Load player X coordinate in A
    ld a, ($D361)
    call ConvertByteToStr     ; converts A into string at DebugBuffer
    ld hl, DebugBuffer
    call PrintText

    ; Print " Y: "
    ld hl, DebugYLabel
    call PrintText

    ; Load player Y coordinate in A
    ld a, ($D362)
    call ConvertByteToStr
    ld hl, DebugBuffer
    call PrintText
    ret

DebugXLabel:
    db "X: ",0
DebugYLabel:
    db " Y: ",0

; Define a buffer for our number conversion (example, 4 bytes)
DebugBuffer:
    ds 4