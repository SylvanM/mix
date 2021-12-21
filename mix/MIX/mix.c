//
//  mix.c
//  mix
//
//  Created by Sylvan Martin on 12/19/21.
//

#include "mix.h"

size_t mix_register_size(int index) {
   size_t sizes[MIX_REGISTER_COUNT] = {
       MIX_REGISTER_A_SIZE,
       MIX_REGISTER_X_SIZE,
       MIX_REGISTER_I_SIZE,
       MIX_REGISTER_I_SIZE,
       MIX_REGISTER_I_SIZE,
       MIX_REGISTER_I_SIZE,
       MIX_REGISTER_I_SIZE,
       MIX_REGISTER_I_SIZE,
       MIX_REGISTER_J_SIZE,
   };
   
   return sizes[index];
}

mix_t initialize_empty(void) {
    mix_t comp = { 0 };
    configure_mix(&comp);
    return comp;
}

void configure_mix(mix_t *comp) {
    
    int i;
    
    // allocate MIX memory
    comp->memory = (uint8_t *) malloc(MIX_WORD_SIZE * MIX_MEMORY_SIZE);
    
    // allocate reg_ptrs memory
    comp->reg_ptrs = (uint8_t **) malloc(sizeof(uint8_t *) * MIX_REGISTER_COUNT);
    
    // Allocate registers
    for ( i = 0; i < MIX_REGISTER_COUNT; ++i )
        comp->reg_ptrs[i] = (uint8_t *) malloc( mix_register_size(i) );
    
    comp->io_unit = (uint8_t **) malloc(sizeof(uint8_t *) * MIX_IO_UNIT_COUNT);
    
    // Assign IO pointers
    comp->io_unit[0] = comp->tape0;
    comp->io_unit[1] = comp->tape1;
    comp->io_unit[2] = comp->tape2;
    comp->io_unit[3] = comp->tape3;
    comp->io_unit[4] = comp->tape4;
    comp->io_unit[5] = comp->tape5;
    comp->io_unit[6] = comp->tape6;
    comp->io_unit[7] = comp->tape7;
    
    comp->io_unit[8]  = comp->disk8;
    comp->io_unit[9]  = comp->disk9;
    comp->io_unit[10] = comp->disk10;
    comp->io_unit[11] = comp->disk11;
    comp->io_unit[12] = comp->disk12;
    comp->io_unit[13] = comp->disk13;
    comp->io_unit[14] = comp->disk14;
    comp->io_unit[15] = comp->disk15;
    
    comp->io_unit[16] = comp->card_reader;
    comp->io_unit[17] = comp->card_punch;
    comp->io_unit[18] = comp->line_printer;
    comp->io_unit[19] = comp->typewriter;
    comp->io_unit[20] = comp->paper_tape;
}

void memory_read(const uint8_t *mem, int address, int lower_index, int upper_index, uint8_t *buffer) {
    int memory_address_start = address * MIX_WORD_SIZE;
    int index_offset = memory_address_start + lower_index;
    int i;
    
    for ( i = index_offset; i <= memory_address_start + upper_index; ++i ) {
        buffer[i - index_offset] = mem[i];
    }
}

void memory_write(uint8_t *mem, int address, int lower_index, int upper_index, const uint8_t *input) {
    int memory_address_start = address * MIX_WORD_SIZE;
    int index_offset = memory_address_start + lower_index;
    int i;
    
    for ( i = index_offset; i <= memory_address_start + upper_index; ++i ) {
        mem[i] = input[i - index_offset];
    }
}
