@echo off

set name="Pads"

set path=%path%;..\bin\

set CC65_HOME=..\

\cc65\bin\cc65 -Oirs %name%.c --add-source
\cc65\bin\ca65 crt0.s
\cc65\bin\ca65 %name%.s -g

\cc65\bin\ld65 -C nrom_32k_vert.cfg -o %name%.nes crt0.o %name%.o nes.lib -Ln %name%.labels --dbgfile %name%.dbg

del *.o

move /Y $name%.labels BUILD\ 
move /Y %name%.s BUILD\ 
move /Y %name%.nes BUILD\ 
move /Y %name%.dbg BUILD\
