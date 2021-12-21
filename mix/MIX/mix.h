//
//  mix.h
//  mix
//
//  Created by Sylvan Martin on 12/19/21.
//

#ifndef mix_h
#define mix_h

#include <stdint.h>
#include <stdlib.h>

#define MIX_REGISTER_A_SIZE 5
#define MIX_REGISTER_X_SIZE 5
#define MIX_REGISTER_I_SIZE 2
#define MIX_REGISTER_J_SIZE 2
#define MIX_WORD_SIZE       6
#define MIX_REGISTER_COUNT  9
#define MIX_MEMORY_SIZE     4000

#define MIX_REGISTER_A_INDEX    0
#define MIX_REGISTER_X_INDEX    1
#define MIX_REGISTER_I1_INDEX   2
#define MIX_REGISTER_I2_INDEX   3
#define MIX_REGISTER_I3_INDEX   4
#define MIX_REGISTER_I4_INDEX   5
#define MIX_REGISTER_I5_INDEX   6
#define MIX_REGISTER_I6_INDEX   7
#define MIX_REGISTER_J_INDEX    8

#define MIX_IO_UNIT_COUNT   21

#define MIX_TAPE_BLOCK_SIZE 100
#define MIX_DISK_BLOCK_SIZE 100
#define MIX_CARD_READER_BLOCK_SIZE  16
#define MIX_CARD_PUNCH_BLOCK_SIZE   16
#define MIX_LINE_PRINTER_BLOCK_SIZE 24
#define MIX_TYPEWRITER_BLOCK_SIZE   14
#define MIX_PAPER_TAPE_BLOCK_SIZE   14
  
/**
 * Retrieves the size of the register at the specified index
 */
size_t mix_register_size(int index);

/**
 * The State of a MIX computer
 */
typedef struct {
    
    // MARK: - Registers
    
    /**
     * A bit field representing the sign of each register. Bit 0 is register A, bit 1 is register X, bits 2-7 are
     * registers i1-i6
     *
     * A 1 represents a positive sign, 0 is a negative sign
     *
     * Register j does not have a sign since its sign is always positive.
     */
    uint8_t register_signs;
    
    // MARK: Register Bytes
    
    /**
     * An array of pointers to the corresponding register
     */
    uint8_t** reg_ptrs;
    
    /**
     * Overflow toggle and comparison indicator
     *
     * The most significant bit represents the overflow toggle.
     *
     * The two least significant bits represent the state of the comparison indicator, which
     * can have three possible values:
     *
     * 0: Equal
     * 1: Less
     * 2: Greater
     */
    uint8_t ov_comp;
    
    // MARK: Memory
    
    /**
     * The first byte of each word of memory represents the sign byte. If the sign contains 0, it is negative.
     * 1 is positive.
     *
     * This is a 1D array of all words in memory
     *
     * This is allocated at runtime after a call to `configure_mix`
     */
    uint8_t* memory;
    
    // MARK: - I/O Devices
    
    /**
     * Pointers to each I/O unit
     */
    uint8_t** io_unit;
    
    // MARK: I/O Units
    
    /*
     * Tape units
     */
    
    uint8_t tape0[MIX_TAPE_BLOCK_SIZE];
    uint8_t tape1[MIX_TAPE_BLOCK_SIZE];
    uint8_t tape2[MIX_TAPE_BLOCK_SIZE];
    uint8_t tape3[MIX_TAPE_BLOCK_SIZE];
    uint8_t tape4[MIX_TAPE_BLOCK_SIZE];
    uint8_t tape5[MIX_TAPE_BLOCK_SIZE];
    uint8_t tape6[MIX_TAPE_BLOCK_SIZE];
    uint8_t tape7[MIX_TAPE_BLOCK_SIZE];
    
    /*
     * Disk/drum units
     */
    
    uint8_t disk8 [MIX_TAPE_BLOCK_SIZE];
    uint8_t disk9 [MIX_TAPE_BLOCK_SIZE];
    uint8_t disk10[MIX_TAPE_BLOCK_SIZE];
    uint8_t disk11[MIX_TAPE_BLOCK_SIZE];
    uint8_t disk12[MIX_TAPE_BLOCK_SIZE];
    uint8_t disk13[MIX_TAPE_BLOCK_SIZE];
    uint8_t disk14[MIX_TAPE_BLOCK_SIZE];
    uint8_t disk15[MIX_TAPE_BLOCK_SIZE];
    
    /*
     * Card reader
     */
    uint8_t card_reader[MIX_CARD_READER_BLOCK_SIZE];
    
    /*
     * Card punch
     */
    uint8_t card_punch[MIX_CARD_PUNCH_BLOCK_SIZE];
    
    /*
     * Line printer
     */
    uint8_t line_printer[MIX_LINE_PRINTER_BLOCK_SIZE];
    
    /*
     * Typewriter terminal
     */
    uint8_t typewriter[MIX_TYPEWRITER_BLOCK_SIZE];
    
    /*
     * Paper tape
     */
    uint8_t paper_tape[MIX_PAPER_TAPE_BLOCK_SIZE];
    
} mix_t;

/**
 * Creates a new, configured, "empty," mix_t
 */
mix_t initialize_empty(void);

/**
 * Configues a MIX state to be a valid starting state with all the pointers pointing to the right stuff
 */
void configure_mix(mix_t *comp);

/**
 * Reads a sequence of bytes from the MIX memory into a buffer
 *
 * @pre ```buffer``` is already allocated to be the appropriate size
 * @pre comp is properly configured
 */
void memory_read(const uint8_t *mem, int address, int lower_index, int upper_index, uint8_t *buffer);

/**
 * Writes a sequence of bytes to the MIX memory
 *
 * @pre `input` is already allocated to be the appropriate size
 * @pre comp is properly configured
 */
void memory_write(uint8_t *mem, int address, int lower_index, int upper_index, const uint8_t *input);



#endif /* mix_h */
