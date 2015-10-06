/*
 * HT4xRxx.cpp
 *
 *  Created on: 07.06.2011
 *      Author: User
 */

#include "M16C_xx.h"
#include <frame.hpp>
#include <srarea.hpp>
#include <struct.hpp>
#include <entry.hpp>

extern const char *M16C_xx_RegNames[];

//----------------------------------------------------------------------
ea_t calc_code_mem(ea_t ea) {
	return toEA(cmd.cs, ea);
}

//----------------------------------------------------------------------
ea_t calc_data_mem(ea_t ea) {
	return dataseg;
}

//----------------------------------------------------------------------
void header() {
	MakeLine("My header line");
}

//----------------------------------------------------------------------
void footer() {
	MakeLine("My footer line");
}

//----------------------------------------------------------------------
void segstart(ea_t ea) {
}

//----------------------------------------------------------------------
// generate a text representation of an instruction
// the information about the instruction is in the 'cmd' structure
void out() {
	char str[MAXSTR];  //MAXSTR is an IDA define from pro.h
	init_output_buffer(str, sizeof(str));

	OutMnem(12);       //first we output the mnemonic

	outop(cmd.Op1);

	if (cmd.Op2.type != o_void ) {
		out_symbol(',');
		out_symbol(' ');
	}

	outop(cmd.Op2);

	if (cmd.Op3.type != o_void ) {
		out_symbol(',');
		out_symbol(' ');
	}

	outop(cmd.Op3);

	term_output_buffer();
	gl_comm = 1;      //we want comments!
	MakeLine(str);    //output the line with default indentation
}

//----------------------------------------------------------------------
static void out_bad_address(ea_t addr) {
	out_tagon(COLOR_ERROR);
	OutLong(addr, 16);
	out_tagoff(COLOR_ERROR);
	QueueMark(Q_noName, cmd.ea);
}

//----------------------------------------------------------------------
// generate the text representation of an operand
bool idaapi outop(op_t &x) {
	ea_t ea;

	switch (x.type) {
		case o_void:
			return 0;
		case o_imm: {
				uint32_t flags = OOFS_IFSIGN | OOF_NUMBER;

				out_symbol('#');
				switch (x.dtyp) {
					case dt_word:
						flags |= OOFW_16;
						break;
					case dt_dword:
						flags |= OOFW_32;
						break;
					default:
						flags |= OOF_SIGNED | OOFW_8;
						break;
				}
				OutValue(x, flags);
			}
			break;
		case o_displ:
			{  //then there is an argument to print
				switch (x.dtyp) {
					case dt_byte:
						OutValue(x, OOF_SIGNED | OOF_NUMBER | OOFW_8);
						break;
					case dt_word:
						OutValue(x, OOF_SIGNED | OOF_NUMBER | OOFW_16);
						break;
					default:
						ea = toEA(cmd.cs, x.addr);
						if (!out_name_expr(x, ea, x.addr))
							out_bad_address(x.addr);
						break;
				}
				out_symbol('[');
				out_register(M16C_xx_RegNames[x.reg]);
				out_symbol(']');
			}
			break;
		case o_phrase:
			out_symbol('[');
			out_register(M16C_xx_RegNames[x.reg]);
			out_symbol(']');
			break;
		case o_near:
			ea = toEA(cmd.cs, x.addr);
			if (!out_name_expr(x, ea, x.addr))
				out_bad_address(x.addr);
			break;
		case o_mem:
			ea = toEA(dataSeg(), x.addr);
			if (!out_name_expr(x, ea, x.addr))
				out_bad_address(x.addr);
			break;
		case o_reg:
			out_register(M16C_xx_RegNames[x.reg]);
			break;
		default:
			warning("out: %a: bad optype %d", cmd.ea, x.type);
		break;
	}


	return true;
}
