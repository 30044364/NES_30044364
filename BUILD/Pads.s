;
; File generated by cc65 v 2.19 - Git b993d88
;
	.fopt		compiler,"cc65 v 2.19 - Git b993d88"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_pal_bg
	.import		_pal_spr
	.import		_pal_col
	.import		_ppu_wait_nmi
	.import		_ppu_off
	.import		_ppu_on_all
	.import		_oam_clear
	.import		_oam_meta_spr
	.import		_pad_poll
	.import		_bank_spr
	.import		_vram_adr
	.import		_vram_write
	.import		_delay
	.import		_check_collision
	.import		_pal_fade_to
	.export		_YellowSpr
	.export		_BlueSpr
	.export		_pad1
	.export		_pad2
	.export		_collision
	.export		_BoxGuy1
	.export		_BoxGuy2
	.export		_BoxGuy3
	.export		_BoxGuy4
	.export		_text
	.export		_end_text
	.export		_end_switch
	.export		_palette_bg
	.export		_palette_sp
	.export		_draw_sprites
	.export		_movement
	.export		_test_collision
	.export		_draw_bg
	.export		_main

.segment	"DATA"

_BoxGuy1:
	.byte	$14
	.byte	$14
	.byte	$0F
	.byte	$0F
_BoxGuy2:
	.byte	$78
	.byte	$14
	.byte	$0F
	.byte	$0F
_BoxGuy3:
	.byte	$8C
	.byte	$14
	.byte	$0F
	.byte	$0F
_BoxGuy4:
	.byte	$64
	.byte	$46
	.byte	$0F
	.byte	$0F
_end_switch:
	.word	$0000

.segment	"RODATA"

_YellowSpr:
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$08
	.byte	$10
	.byte	$00
	.byte	$08
	.byte	$00
	.byte	$00
	.byte	$40
	.byte	$08
	.byte	$08
	.byte	$10
	.byte	$40
	.byte	$80
_BlueSpr:
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$01
	.byte	$00
	.byte	$08
	.byte	$10
	.byte	$01
	.byte	$08
	.byte	$00
	.byte	$00
	.byte	$41
	.byte	$08
	.byte	$08
	.byte	$10
	.byte	$41
	.byte	$80
_text:
	.byte	$43,$61,$74,$63,$68,$20,$54,$68,$65,$20,$43,$75,$6C,$70,$72,$69
	.byte	$74,$00
_end_text:
	.byte	$59,$6F,$75,$20,$43,$61,$75,$67,$68,$74,$20,$54,$68,$65,$20,$43
	.byte	$75,$6C,$70,$72,$69,$74,$00
_palette_bg:
	.byte	$00
	.byte	$0F
	.byte	$10
	.byte	$30
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
_palette_sp:
	.byte	$0F
	.byte	$0F
	.byte	$0F
	.byte	$28
	.byte	$0F
	.byte	$0F
	.byte	$0F
	.byte	$12
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00

.segment	"BSS"

.segment	"ZEROPAGE"
_pad1:
	.res	1,$00
_pad2:
	.res	1,$00
_collision:
	.res	1,$00

; ---------------------------------------------------------------
; void __near__ draw_sprites (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_draw_sprites: near

.segment	"CODE"

;
; oam_clear(); // clear all sprites
;
	jsr     _oam_clear
;
; oam_meta_spr(BoxGuy1.x, BoxGuy1.y, YellowSpr); // Player
;
	jsr     decsp2
	lda     _BoxGuy1
	ldy     #$01
	sta     (sp),y
	lda     _BoxGuy1+1
	dey
	sta     (sp),y
	lda     #<(_YellowSpr)
	ldx     #>(_YellowSpr)
	jsr     _oam_meta_spr
;
; oam_meta_spr(BoxGuy2.x, BoxGuy2.y, BlueSpr); // NPC 1
;
	jsr     decsp2
	lda     _BoxGuy2
	ldy     #$01
	sta     (sp),y
	lda     _BoxGuy2+1
	dey
	sta     (sp),y
	lda     #<(_BlueSpr)
	ldx     #>(_BlueSpr)
	jsr     _oam_meta_spr
;
; oam_meta_spr(BoxGuy3.x, BoxGuy3.y, BlueSpr); // NPC 2
;
	jsr     decsp2
	lda     _BoxGuy3
	ldy     #$01
	sta     (sp),y
	lda     _BoxGuy3+1
	dey
	sta     (sp),y
	lda     #<(_BlueSpr)
	ldx     #>(_BlueSpr)
	jsr     _oam_meta_spr
;
; oam_meta_spr(BoxGuy4.x, BoxGuy4.y, BlueSpr); // NPC 3
;
	jsr     decsp2
	lda     _BoxGuy4
	ldy     #$01
	sta     (sp),y
	lda     _BoxGuy4+1
	dey
	sta     (sp),y
	lda     #<(_BlueSpr)
	ldx     #>(_BlueSpr)
	jmp     _oam_meta_spr

.endproc

; ---------------------------------------------------------------
; void __near__ movement (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_movement: near

.segment	"CODE"

;
; if(pad1 & PAD_LEFT){
;
	lda     _pad1
	and     #$02
	beq     L000A
;
; BoxGuy1.x -= 1;
;
	dec     _BoxGuy1
;
; else if (pad1 & PAD_RIGHT){
;
	jmp     L000B
L000A:	lda     _pad1
	and     #$01
	beq     L000B
;
; BoxGuy1.x += 1;
;
	inc     _BoxGuy1
;
; if(pad1 & PAD_UP){
;
L000B:	lda     _pad1
	and     #$08
	beq     L000C
;
; BoxGuy1.y -= 1;
;
	dec     _BoxGuy1+1
;
; else if (pad1 & PAD_DOWN){
;
	jmp     L000D
L000C:	lda     _pad1
	and     #$04
	beq     L000D
;
; BoxGuy1.y += 1;
;
	inc     _BoxGuy1+1
;
; BoxGuy2.x +=1;
;
L000D:	inc     _BoxGuy2
;
; BoxGuy2.y +=1;
;
	inc     _BoxGuy2+1
;
; BoxGuy3.x -=1;
;
	dec     _BoxGuy3
;
; BoxGuy3.y -=1;
;
	dec     _BoxGuy3+1
;
; BoxGuy4.y +=1;
;
	inc     _BoxGuy4+1
;
; } 
;
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ test_collision (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_test_collision: near

.segment	"CODE"

;
; collision = check_collision(&BoxGuy1, &BoxGuy2);
;
	lda     #<(_BoxGuy1)
	ldx     #>(_BoxGuy1)
	jsr     pushax
	lda     #<(_BoxGuy2)
	ldx     #>(_BoxGuy2)
	jsr     _check_collision
	sta     _collision
;
; if (collision){
;
	lda     _collision
	beq     L0002
;
; pal_col(0,0x30); 
;
	lda     #$00
	jsr     pusha
	lda     #$30
;
; else{
;
	jmp     _pal_col
;
; pal_col(0,0x00);
;
L0002:	jsr     pusha
	jmp     _pal_col

.endproc

; ---------------------------------------------------------------
; void __near__ draw_bg (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_draw_bg: near

.segment	"CODE"

;
; ppu_off(); // turn off screen
;
	jsr     _ppu_off
;
; pal_col(0,0x0f); // set background to black
;
	lda     #$00
	jsr     pusha
	lda     #$0F
	jsr     _pal_col
;
; vram_adr(NTADR_A(7,14)); // set a start position for the text
;
	ldx     #$21
	lda     #$C7
	jsr     _vram_adr
;
; vram_write(text,sizeof(text)); // print text on the screen
;
	lda     #<(_text)
	ldx     #>(_text)
	jsr     pushax
	ldx     #$00
	lda     #$12
	jsr     _vram_write
;
; ppu_on_all(); // turn on screen
;
	jsr     _ppu_on_all
;
; pal_fade_to(0,4); // (from, to) fade in to normal
;
	lda     #$00
	jsr     pusha
	lda     #$04
	jsr     _pal_fade_to
;
; delay(100); // wait 100 frames
;
	lda     #$64
	jmp     _delay

.endproc

; ---------------------------------------------------------------
; void __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

;
; ppu_off();
;
	jsr     _ppu_off
;
; pal_bg(palette_bg);
;
	lda     #<(_palette_bg)
	ldx     #>(_palette_bg)
	jsr     _pal_bg
;
; pal_spr(palette_sp);
;
	lda     #<(_palette_sp)
	ldx     #>(_palette_sp)
	jsr     _pal_spr
;
; bank_spr(1);
;
	lda     #$01
	jsr     _bank_spr
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; draw_bg();
;
	jsr     _draw_bg
;
; ppu_wait_nmi(); // wait till beginning of the frame
;
L0002:	jsr     _ppu_wait_nmi
;
; pad1 = pad_poll(0); // read the first controller
;
	lda     #$00
	jsr     _pad_poll
	sta     _pad1
;
; if(!collision){
;
	lda     _collision
	bne     L0005
;
; movement(); // player/ NPC movement
;
	jsr     _movement
;
; test_collision(); // collision check
;
	jsr     _test_collision
;
; draw_sprites(); // draw characters and npc on screen
;
	jsr     _draw_sprites
;
; else if(end_switch == 0){
;
	jmp     L0002
L0005:	lda     _end_switch
	ora     _end_switch+1
	bne     L0002
;
; ppu_off(); // trun off screen
;
	jsr     _ppu_off
;
; oam_clear(); // clear the sprites
;
	jsr     _oam_clear
;
; pal_col(0,0x0f); // change background colour to black
;
	lda     #$00
	jsr     pusha
	lda     #$0F
	jsr     _pal_col
;
; vram_adr(NTADR_A(5,14)); // set a start position for the text
;
	ldx     #$21
	lda     #$C5
	jsr     _vram_adr
;
; vram_write(end_text,sizeof(end_text)); // print text to the screen
;
	lda     #<(_end_text)
	ldx     #>(_end_text)
	jsr     pushax
	ldx     #$00
	lda     #$17
	jsr     _vram_write
;
; ppu_on_all(); // turn on screen
;
	jsr     _ppu_on_all
;
; delay(200); // wait 200 frames
;
	lda     #$C8
	jsr     _delay
;
; pal_fade_to(4,0); // fade to black
;
	lda     #$04
	jsr     pusha
	lda     #$00
	jsr     _pal_fade_to
;
; end_switch = 1; // sets boolen to true
;
	ldx     #$00
	lda     #$01
	sta     _end_switch
	stx     _end_switch+1
;
; while (1){
;
	jmp     L0002

.endproc

