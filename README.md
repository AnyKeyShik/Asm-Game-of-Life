# Assembler Game of Life

<a href="https://github.com/AnyKeyShik/Asm-Game-of-Life/blob/master/LICENSE">
<img src ="https://img.shields.io/github/license/AnyKeyShik/Asm-Game-of-Life.svg" />
</a>
<a href="https://github.com/AnyKeyShik/Asm-Game-of-Life/stargazers">
<img src ="https://img.shields.io/github/stars/AnyKeyShik/Asm-Game-of-Life.svg" />
</a>
<a href="https://github.com/AnyKeyShik/Asm-Game-of-Life/network">
<img src ="https://img.shields.io/github/forks/AnyKeyShik/Asm-Game-of-Life.svg" />
</a>

# Getting started

#### Requirements

To compile and run this project, you will need:
* the NASM assembler
* the GNU linker
* a Linux x64 operating system

#### Implementation notes

The initial cell pattern is generated using ideas from *Middle Square Weyl Sequence RNG*, published by Bernard Widynski on 4th April 2017. 

The implementation relies on a finite grid, all cells outside the grid boundaries are considered as dead.

#### Running the code

Simply use the following commands in a terminal:
```
git clone https://github.com/AnyKeyShik/Asm-Game-of-Life.git
cd Asm-Game-of-Life
make run
```
