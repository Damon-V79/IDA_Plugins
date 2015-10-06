/*
 * M16C_xx.h
 *
 *  Created on: 07.06.2011
 *      Author: User
 */

#ifndef M16C_XX_H_
#define M16C_XX_H_

#include <windows.h>
#include <winuser.h>
#include <string.h>
#include <limits.h>
#include <idaidp.hpp>
#include "ins.hpp"

// ash.uflag bit meanings:

#define UAS_PSAM        0x0001          // PseudoSam: use funny form of
                                        // equ for intmem
#define UAS_SECT        0x0002          // Segments are named .SECTION
#define UAS_NOSEG       0x0004          // No 'segment' directives
#define UAS_NOBIT       0x0008          // No bit.# names, use bit_#
#define UAS_SELSG       0x0010          // Segment should be selected by its name
#define UAS_EQCLN       0x0020          // ':' in EQU directives
#define UAS_AUBIT       0x0040          // Don't use BIT directives -
                                        // assembler generates bit names itself
#define UAS_CDSEG       0x0080          // Only DSEG,CSEG,XSEG
#define UAS_NODS        0x0100          // No .DS directives in Code segment
#define UAS_NOENS       0x0200          // don't specify start addr in the .end directive
#define UAS_PBIT        0x0400          // assembler knows about predefined bits
#define UAS_PBYTNODEF   0x0800          // do not define predefined byte names

//------------------------------------------------------------------------
// Registers
enum M16C_xx_Regs {
	  rR0H = 0, rR0L,
	  rR1H, rR1L,

	  rR0,
	  rR1,
	  rR2,
	  rR3,
	  rR2R0,
	  rR3R1,

	  rA0,
	  rA1,
	  rA1A0,

	  rFB,

	  rPC,

	  rINTBL,
	  rINTBH,
	  rINTB,

	  rUSP,
	  rISP,
	  rSP,
	  rSB,
	  rFLG,

	  rVcs, rVds            // these 2 registers are required by the IDA kernel
};

extern ea_t dataseg;

ea_t calc_code_mem(ea_t ea);
ea_t calc_data_mem(ea_t ea);

const char *find_sym(ea_t address);

void idaapi   header(void);
void idaapi   footer(void);

void idaapi   segstart(ea_t ea);

int  idaapi   ana(void);
int  idaapi   emu(void);
void idaapi   out(void);
bool idaapi   outop(op_t &op);

void idaapi   holtek_data(ea_t ea);

#endif /* M16C_XX_H_ */
