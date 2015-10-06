/*
 * emu.cpp
 *
 *  Created on: 07.06.2011
 *      Author: User
 */

#include "M16C_xx.h"
#include <srarea.hpp>
#include <frame.hpp>

static int flow;

//----------------------------------------------------------------------
void TouchArg( op_t &x, int isload ) {
  switch ( x.type ) {
    case o_near: {
        cref_t ftype = fl_JN;
        ea_t ea = toEA(cmd.cs, x.addr);
        if ( InstrIsSet(cmd.itype, CF_CALL) )
        {
          if ( !func_does_return(ea) )
            flow = false;
          ftype = fl_CN;
        }
        ua_add_cref(x.offb, ea, ftype);
      }
      break;
    case o_imm:
      if ( !isload ) break;
      op_num(cmd.ea, x.n);
      if ( isOff(uFlag, x.n) )
        ua_add_off_drefs2(x, dr_O, OOF_SIGNED);
      break;
    case o_mem: {
        ea_t ea = toEA( dataSeg( ),x.addr );
        ua_dodata2( x.offb, ea, x.dtyp );
        if ( !isload )
          doVar( ea );
        ua_add_dref( x.offb, ea, isload ? dr_R : dr_W );
      }
      break;
    default:
      break;
  }
}

//----------------------------------------------------------------------
// Emulate an instruction
// This function should:
//      - create all xrefs from the instruction
//      - perform any additional analysis of the instruction/program
//        and convert the instruction operands, create comments, etc.
//      - create stack variables
//      - analyze the delayed branches and similar constructs
// The kernel calls ana() before calling emu(), so you may be sure that
// the 'cmd' structure contains a valid and up-to-date information.
// You are not allowed to modify the 'cmd' structure.
// Upon entering this function, the 'uFlag' variable contains the flags of
// cmd.ea. If you change the characteristics of the current instruction, you
// are required to refresh 'uFlag'.
// Usually the kernel calls emu() with consecutive addresses in cmd.ea but
// you can't rely on this - for example, if the user asks to analyze an
// instruction at arbirary address, his request will be handled immediately,
// thus breaking the normal sequence of emulation.
// If you need to analyze the surroundings of the current instruction, you
// are allowed to save the contents of the 'cmd' structure and call ana().
// For example, this is a very common pattern:
//  {
//    insn_t saved = cmd;
//    if ( decode_prev_insn(cmd.ea) != BADADDR )
//    {
//      ....
//    }
//    cmd = saved;
//  }
//
// This sample emu() function is a very simple emulation engine.
int emu( ) {

//  msg( "int emu( )\n" );

  unsigned long feature = cmd.get_canon_feature( );

  if( feature & CF_USE1 ) TouchArg( cmd.Op1, 1 );
  if( feature & CF_USE2 ) TouchArg( cmd.Op2, 1 );

  if( feature & CF_CHG1 ) TouchArg( cmd.Op1, 0 );
  if( feature & CF_CHG2 ) TouchArg( cmd.Op2, 0 );

  if( !( feature & CF_STOP ) )
    ua_add_cref( 0, cmd.ea + cmd.size, fl_F);

  return 1;
}
