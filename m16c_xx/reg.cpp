/*
 * reg.cpp
 *
 *  Created on: 03.06.2011
 *      Author: User
 */

#include "M16C_xx.h"
#include <diskio.hpp>
#include <entry.hpp>
#include <srarea.hpp>
#include <loader.hpp>
#include <fpro.h>
#include <ctype.h>

#define PLFM_M16C_xx  0x8001      // Renesas M16C

//----------------------------------------------------------------------
const char *M16C_xx_RegNames[ ] = {
                                    	  "R0H", "R0L",
                                    	  "R1H", "R1L",

                                    	  "R0",
                                    	  "R1",
                                    	  "R2",
                                    	  "R3",
                                    	  "R2R0",
                                    	  "R3R1",

                                    	  "A0",
                                    	  "A1",
                                    	  "A1A0",

                                    	  "FB",

                                    	  "PC",

                                    	  "INTBL",
                                    	  "INTBH",
                                    	  "INTB",

                                    	  "USP",
                                    	  "ISP",
                                    	  "SP",
                                    	  "SB",
                                    	  "FLG",

                                    	  "cs","ds" // virtual registers for code and data segments
};

//-----------------------------------------------------------------------
// The short and long names of the supported processors
// The short names must match
// the names in the module DESCRIPTION in the makefile (the
// description is copied in the offset 0x80 in the result DLL)
static const char *shnames[] = {
  "M16C_xx",
  NULL
};

static const char *lnames[] = {
  "Renesas M16C_xx",
  NULL
};

//-----------------------------------------------------------------------
//      Assembler definiton
//-----------------------------------------------------------------------
static asm_t tasm =
{
  AS_COLON|AS_N2CHR|ASH_HEXF3|ASD_DECF0|ASB_BINF3|ASO_OCTF0|AS_ONEDUP,
  0,
  "AVR Assembler",
  0,
  NULL,         // header lines
  NULL,         // no bad instructions
  ".org",       // org
  ".exit",      // end

  ";",          // comment string
  '"',          // string delimiter
  '\'',         // char delimiter
  "\"'",        // special symbols in char and string constants

  ".db",        // ascii string directive
  ".db",        // byte directive
  ".dw",        // word directive
  NULL,         // double words
  NULL,         // no qwords
  NULL,         // oword  (16 bytes)
  NULL,         // float  (4 bytes)
  NULL,         // double (8 bytes)
  NULL,         // tbyte  (10/12 bytes)
  NULL,         // packed decimal real
  NULL,         // arrays (#h,#d,#v,#s(...)
  ".byte %s",   // uninited arrays
  ".equ",       // equ
  NULL,         // 'seg' prefix (example: push seg seg001)
  NULL,         // Pointer to checkarg_preline() function.
  NULL,         // char *(*checkarg_atomprefix)(char *operand,void *res); // if !NULL, is called before each atom
  NULL,         // const char **checkarg_operations;
  NULL,         // translation to use in character and string constants.
  NULL,         // current IP (instruction pointer)
  NULL,         // func_header
  NULL,         // func_footer
  NULL,         // "public" name keyword
  NULL,         // "weak"   name keyword
  NULL,         // "extrn"  name keyword
  NULL,         // "comm" (communal variable)
  NULL,         // get_type_name
  NULL,         // "align" keyword
  '(', ')', // lbrace, rbrace
  NULL,         // mod
  "&",          // and
  "|",          // or
  "^",          // xor
  "~",          // not
  "<<",         // shl
  ">>",         // shr
  NULL,         // sizeof
};

static asm_t *asms[] = { &tasm, NULL };

ea_t sfrseg;
ea_t dataseg;

//--------------------------------------------------------------------------
static ioport_t *ports = NULL;
static size_t numports = 0;
char device[ MAXSTR ] = "";
netnode helper;

//----------------------------------------------------------------------
// The kernel event notifications
// Here you may take desired actions upon some kernel events
int idaapi notify(processor_t::idp_notify msgid, ...) {
  va_list va;
  va_start( va, msgid );   //setup args list
  int result = invoke_callbacks( HT_IDP, msgid, va );
  if ( result == 0 ) {
    result = 1;             //default success
    switch(msgid) {
      case processor_t::init:
        inf.mf = 0;       //ensure little endian!
        break;
      case processor_t::make_data: {
          ea_t ea = va_arg(va, ea_t);
          flags_t flags = va_arg(va, flags_t);
          tid_t tid = va_arg(va, tid_t);
          asize_t len = va_arg(va, asize_t);
          if (len > 4) //our d_out can only handle byte, word, dword
            result = 0; //disallow big data
        }
        break;
      case processor_t::newfile: {  // new file loaded
          // remember the ROM segment
          segment_t *s = getnseg(0);
          if ( s != NULL ) {
            set_segm_name(s, "CODE");
            //helper.altset(-1, s->startEA);
          }

          s = get_segm_by_name("SFR");
          if ( s == NULL ) {
            ea_t start = 0x0000;
            add_segm(start, start, 0x03FF, "SFR", "SFR");
            sfrseg = start;
          }
          s = get_segm_by_name("DATA");
          if ( s == NULL ) {
            ea_t start = 0x0400;
            add_segm(0x0000, start, 0x53FF, "DATA", "DATA");
            dataseg = start;
          }
//          s = get_segm_by_name("DATA");
//          if ( s == NULL ) {
//            ea_t start = (inf.maxEA + 0xFFFFF) & ~0xFFFFF;
//            add_segm(start >> 4, start, start+0x53FF, "DATA", "DATA");
//            dataseg = start;
//          }

        }
        break;
      case processor_t::newseg:    // new segment
        {
          segment_t *s = va_arg(va, segment_t *);
          set_default_dataseg( s->sel );
        }
        break;
      default:
//        msg("interr in 'int idaapi notify(processor_t::idp_notify msgid, ...)'");
        break;
      }
    }

  va_end(va);
  return result;
}

const char *find_sym(ea_t address)
{
  const ioport_t *port = find_ioport(ports, numports, address);
  return port ? port->name : NULL;
}

//--------------------------------------------------------------------------
// Opcodes of "return" instructions. This information will be used in 2 ways:
//      - if an instruction has the "return" opcode, its autogenerated label
//        will be "locret" rather than "loc".
//      - IDA will use the first "return" opcode to create empty subroutines.

/*
 * 0011 0000 0000 0000    ret
 * 0100 0000 0000 0000    reti
 */

static uchar retcode_1[] = { 0x00, 0x30 };  // ret
static uchar retcode_2[] = { 0x00, 0x40 };  // reti

static bytes_t retcodes[] = {
 { sizeof(retcode_1), retcode_1 },
 { sizeof(retcode_2), retcode_2 },
 { 0, NULL }                            // NULL terminated array
};

//-----------------------------------------------------------------------
//      Processor Definition
//-----------------------------------------------------------------------
processor_t LPH = {
                   IDP_INTERFACE_VERSION,
                   PLFM_M16C_xx,

                   PRN_HEX|PR_RNAMESOK,
//                   PR_RNAMESOK           // can use register names for byte names
//                   |PR_SEGTRANS          // segment translation is supported (codeSeg)
//                   |PR_BINMEM,           // The module creates RAM/ROM segments for binary files
//                                         // (the kernel shouldn't ask the user about their sizes and addresses)
                   8,                    // 8 bits in a byte for code segments
                   8,                    // 8 bits in a byte for other segments

                   shnames,              // array of short processor names
                                         // the short names are used to specify the processor
                                         // with the -p command line switch)
                   lnames,               // array of long processor names
                                         // the long names are used to build the processor type
                                         // selection menu

                   asms,                 // array of target assemblers

                   notify,               // the kernel event notification callback

                   header,               // generate the disassembly header
                   footer,               // generate the disassembly footer

                   segstart,             // generate a segment declaration (start of segment)
                   std_gen_segm_footer,  // generate a segment footer (end of segment)

                   NULL,                 // generate 'assume' directives

                   ana,                  // analyze an instruction and fill the 'cmd' structure
                   emu,                  // emulate an instruction

                   out,                  // generate a text representation of an instruction
                   outop,                // generate a text representation of an operand
                   intel_data,           // generate a text representation of a data item
                   NULL,                 // compare operands
                   NULL,                 // can an operand have a type?

                   qnumber(M16C_xx_RegNames),    // Number of registers
                   M16C_xx_RegNames,             // Regsiter names
                   NULL,                 // get abstract register

                   0,                    // Number of register files
                   NULL,                 // Register file names
                   NULL,                 // Register descriptions
                   NULL,                 // Pointer to CPU registers

                   rVcs,rVds,
                   0,                    // size of a segment register
                   rVcs,rVds,

                   NULL,                 // No known code start sequences
                   retcodes,

                   M16C_xx_null,
                   M16C_xx_last,
                   instructions,

                   NULL,                 // int  (*is_far_jump)(int icode);
                   NULL,                 // Translation function for offsets
                   0,                    // int tbyte_size;  -- doesn't exist
                   NULL,                 // int (*realcvt)(void *m, ushort *e, ushort swt);
                   { 0, },               // char real_width[4];
                                         // number of symbols after decimal point
                                         // 2byte float (0-does not exist)
                                         // normal float
                                         // normal double
                                         // long double
                   NULL,                 // int (*is_switch)(switch_info_t *si);
                   NULL,                 // long (*gen_map_file)(FILE *fp);
                   NULL,                 // ea_t (*extract_address)(ea_t ea,const char *string,int x);
                   NULL,                 // int (*is_sp_based)(op_t &x);
                   NULL,                 // int (*create_func_frame)(func_t *pfn);
                   NULL,                 // int (*get_frame_retsize(func_t *pfn)
                   NULL,                 // void (*gen_stkvar_def)(char *buf,const member_t *mptr,sval_t v);
                   gen_spcdef,           // Generate text representation of an item in a special segment
                   M16C_xx_REIT,         // Icode of return instruction. It is ok to give any of possible return instructions
                   NULL,                 // const char *(*set_idp_options)(const char *keyword,int value_type,const void *value);
                   NULL,                 // int (*is_align_insn)(ea_t ea);
                   NULL,                 // mvm_t *mvm;
                   0,
};
