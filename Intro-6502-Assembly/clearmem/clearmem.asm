;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  The iNES header (contains a total of 16 bytes with the flags at $7FF0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "HEADER"
.org $7FF0
.byte $4E,$45,$53,$1A           ; 4 bytes with the characters 'N', 'E', 'S', '\n'
.byte $02                       ; PRG-ROM How many 16KB we'lll use (=32KB) -- NROM format
.byte $01                       ; CHR-ROM How many 8KB we'll use (=8KB) 
.byte %00000000                 ; Horz Mirroring, no battery, mapper 0
.byte %00000000                 ; Mapper 0, playchoice, NES 2.0
.byte $00                       ; no PRG-RAM
.byte $00                       ; NTSC TV format
.byte $00                       ; no PRG-RAM
.byte $00,$00,$00,$00,$00       ; unused padding to complete 16 bytes of header

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     PRG-ROM code located at $8000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "CODE"
.org $8000

RESET:
    sei                         ; Disables all IRQ interrupts
    cld                         ; Clear the decimal mode (unsupported by the NES)
    ldx #$FF
    txs                         ; Initialize the stack pointer at $01FF (end)
    ;; Loop all memory positions from $00 to $FF clearing them out !!!!

    lda #0                      ; Register A = 0
    ldx #$FF                    ; Register X = $FF
MemLoop:
    sta $0,x                    ; Store the value of A (zero) into $0+X
    dex                         ; X--
    bne MemLoop                 ;If X is not zero, we loop back to the MemLoop label

NMI:
    rti

IRQ:
    rti

.segment "VECTORS"
.org $FFFA
.word NMI                       ; address of the NMI handler
.word RESET                     ; address of the RESET handler
.word IRQ                       ; address of the IRQ handler
