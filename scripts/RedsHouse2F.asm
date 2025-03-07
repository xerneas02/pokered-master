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
	
    ;ld a,[$D361]         ; current player X coordinate
	;cp $04                    ; compare with fixed coordinate 4
    ;jr nz, .exitCheck

    ;ld a,[$D362]         ; current player Y coordinate
    ;cp $06                    ; compare with fixed coordinate 6
    ;jr nz, .exitCheck

    ; If both comparisons succeed, the player is on (4,6)
    call CustomBattleEvent
.exitCheck:
    ret

CustomBattleEvent:
    ; (Optional) Display a message or animation
    call ClearScreen

   ; Randomly get a number between 0 and 4
    call Random                ; A = random number
    and 4              ; Now A is in the range 0 to 4

    jp .setRival

.setLorelei:
    ld a, OPP_LORELEI          ; LORELEI constant defined in trainer_constants.asm
    ld [wEngagedTrainerClass], a
    ld a, 1                ; sample set for Lorelei
    ld [wEngagedTrainerSet], a
    jr .startBattle

.setBruno:
    ld a, OPP_BRUNO            ; constant for Bruno
    ld [wEngagedTrainerClass], a
    ld a, 1               ; sample set for Bruno
    ld [wEngagedTrainerSet], a
    jr .startBattle

.setAgatha:
    ld a, OPP_AGATHA           ; constant for Agatha
    ld [wEngagedTrainerClass], a
    ld a, 1                ; sample set for Agatha
    ld [wEngagedTrainerSet], a
    jr .startBattle

.setLance:
    ld a, OPP_LANCE            ; constant for Lance
    ld [wEngagedTrainerClass], a
    ld a, 1                ; sample set for Lance
    ld [wEngagedTrainerSet], a
    jr .startBattle

.setRival:
    ld a, OPP_RIVAL3           ; constant for Lance
    ld [wEngagedTrainerClass], a
    ld a, 1                ; sample set for Lance
    ld [wEngagedTrainerSet], a
    jr .startBattle

.startBattle:
    ; --- Reset input state, if needed ---

    ; Clear the player's team
    

    ; Add Rattata at level 10
    ;ld a, RATTATA          ; will be defined elsewhere
    ;ld [wCurPartySpecies], a
    ;ld a, $0A              ; level 10
    ;xor a
    ;ld [wMonDataLocation], a
    ;call _AddPartyMon

    ; Add Charmander at level 10
    ;ld a, CHARMANDER       ; will be defined elsewhere
    ;ld [wCurPartySpecies], a
    ;ld a, $0A              ; level 10
    ;xor a
    ;ld [wMonDataLocation], a
    ;call _AddPartyMon

	ld c, 60
    call DelayFrames

	xor a
    ld [wJoyIgnore], a
    ld [wSimulatedJoypadStatesIndex], a
    ld [wSimulatedJoypadStatesEnd], a
    ld [wIsInBattle], a

	ld c, 60
    call DelayFrames

    ; Start the battle
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
    ld a, [$D361]
    call ConvertByteToStr     ; converts A into string at DebugBuffer
    ld hl, DebugBuffer
    call PrintText

    ; Print " Y: "
    ld hl, DebugYLabel
    call PrintText

    ; Load player Y coordinate in A
    ld a, [$D362]
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

; ClearPlayerTeam:
; Sets the player's party count to 0 (clearing the team)
ClearPlayerTeam:
    ld hl, wPartyCount
    xor a            ; set A = 0
    ld [hl], a      ; party count ← 0 (empty team)
    ret

; CopyOpponentTeamToPlayer:
; Copies all entries from the opponent team (assumed stored at wEnemyMons)
; into the player's party (wPartyMons) and updates the party count.
; PARTY_LENGTH is the number of Pokémon in the team (e.g. 6)
CopyOpponentTeamToPlayer:
    ld bc, PARTY_LENGTH   ; number of Pokémon to copy
    ld hl, wEnemyMons     ; source pointer: opponent team data (e.g., species IDs)
    ld de, wPartyMons     ; destination pointer: player's party list
CopyOppLoop:
    ld a, [hl]
    ld [de], a
    inc hl
    inc de
    dec bc
    jr nz, CopyOppLoop
    ; Update the party count with PARTY_LENGTH
    ld a, PARTY_LENGTH
    ld hl, wPartyCount
    ld [hl], a
    ret