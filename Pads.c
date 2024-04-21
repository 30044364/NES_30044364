/*	example code for cc65, for NES
 *  move some sprites with the controllers
 *  -also sprite vs sprite collisions
 *	using neslib
 *	Doug Fraker 2018
 */	
 
 
 
#include "LIB/neslib.h"
#include "LIB/nesdoug.h"
#include "Sprites.h" // holds our metasprite data

#pragma bss-name(push, "ZEROPAGE")

// GLOBAL VARIABLES
unsigned char pad1;
unsigned char pad2;
unsigned char collision;

#pragma bss-name(push, "BSS")

struct BoxGuy {
	unsigned char x;
	unsigned char y;
	unsigned char width;
	unsigned char height;
};

struct BoxGuy BoxGuy1 = {20,20,15,15}; // Player
struct BoxGuy BoxGuy2 = {120,20,15,15}; // NPC 1
struct BoxGuy BoxGuy3 = {140,20,15,15}; // NPC 2
struct BoxGuy BoxGuy4 = {100,70,15,15}; // NPC 3

// the width and height should be 1 less than the dimensions (16x16)
// note, I'm using the top left as the 0,0 on x,y

const unsigned char text[]="Catch The Culprit";
const unsigned char end_text[]="You Caught The Culprit";

unsigned int end_switch = 0;

const unsigned char palette_bg[]={
0x00, 0x0f, 0x10, 0x30, // gray, black, lt gray, white
0,0,0,0,
0,0,0,0,
0,0,0,0
}; 

const unsigned char palette_sp[]={
0x0f, 0x0f, 0x0f, 0x28, // black, black, yellow
0x0f, 0x0f, 0x0f, 0x12, // black, black, blue
0,0,0,0,
0,0,0,0
}; 


// PROTOTYPES
void draw_sprites(void);
void movement(void);	
void test_collision(void);
void draw_bg(void);

void main (void) {
	ppu_off();
	pal_bg(palette_bg);
	pal_spr(palette_sp);
	bank_spr(1);
	ppu_on_all();
	draw_bg();

	while (1){
		// infinite loop
		ppu_wait_nmi(); // wait till beginning of the frame
		// the sprites are pushed from a buffer to the OAM during nmi
		
		pad1 = pad_poll(0); // read the first controller
		
		if(!collision){
			movement(); // player/ NPC movement
			test_collision(); // collision check
			draw_sprites(); // draw characters and npc on screen
		}
		else if(end_switch == 0){
			ppu_off(); // trun off screen
			oam_clear(); // clear the sprites
			pal_col(0,0x0f); // change background colour to black
			vram_adr(NTADR_A(5,14)); // set a start position for the text
			vram_write(end_text,sizeof(end_text)); // print text to the screen
			ppu_on_all(); // turn on screen
			delay(200); // wait 200 frames
			pal_fade_to(4,0); // fade to black
			end_switch = 1; // sets boolen to true
		}
	}
}

void draw_bg(void){
	ppu_off(); // turn off screen
	pal_col(0,0x0f); // set background to black
	vram_adr(NTADR_A(7,14)); // set a start position for the text
	vram_write(text,sizeof(text)); // print text on the screen
	ppu_on_all(); // turn on screen
	pal_fade_to(0,4); // (from, to) fade in to normal
	delay(100); // wait 100 frames
}

void draw_sprites(void){
	oam_clear(); // clear all sprites
	oam_meta_spr(BoxGuy1.x, BoxGuy1.y, YellowSpr); // Player
	oam_meta_spr(BoxGuy2.x, BoxGuy2.y, BlueSpr); // NPC 1
	oam_meta_spr(BoxGuy3.x, BoxGuy3.y, BlueSpr); // NPC 2
	oam_meta_spr(BoxGuy4.x, BoxGuy4.y, BlueSpr); // NPC 3
}
	
void movement(void){
	// player movement control
	if(pad1 & PAD_LEFT){
		BoxGuy1.x -= 1;
	}
	else if (pad1 & PAD_RIGHT){
		BoxGuy1.x += 1;
	}
	if(pad1 & PAD_UP){
		BoxGuy1.y -= 1;
	}
	else if (pad1 & PAD_DOWN){
		BoxGuy1.y += 1;
	}

	// NPC movemnt
	BoxGuy2.x +=1;
	BoxGuy2.y +=1;
	BoxGuy3.x -=1;
	BoxGuy3.y -=1;
	BoxGuy4.y +=1;
}	


void test_collision(void){
	collision = check_collision(&BoxGuy1, &BoxGuy2);
		
	// change the BG color, if sprites are touching
	if (collision){
		pal_col(0,0x30); 
	}
	else{
		pal_col(0,0x00);
	}
}