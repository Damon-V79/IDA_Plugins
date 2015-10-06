/*
 * ins.hpp
 *
 *  Created on: 03.06.2011
 *      Author: User
 */

#ifndef INS_HPP_
#define INS_HPP_

extern instruc_t instructions[];

enum opcodes {
  M16C_xx_null = 0,

  M16C_xx_ABS_B_DEST,                       /* 001 */
  M16C_xx_ABS_W_DEST,                       /* 002 */
  M16C_xx_ADC_B_IMM8_DEST,                  /* 003 */
  M16C_xx_ADC_W_IMM16_DEST,                 /* 004 */
  M16C_xx_ADC_B_SRC_DEST,                   /* 005 */
  M16C_xx_ADC_W_SRC_DEST,                   /* 006 */
  M16C_xx_ADCF_B_DEST,                      /* 007 */
  M16C_xx_ADCF_W_DEST,                      /* 008 */
  M16C_xx_ADD_B_G_IMM8_DEST,                /* 009 */
  M16C_xx_ADD_W_G_IMM16_DEST,               /* 010 */
  M16C_xx_ADD_B_Q_IMM4_DEST,                /* 011 */
  M16C_xx_ADD_W_Q_IMM4_DEST,                /* 012 */
  M16C_xx_ADD_B_S_IMM8_DEST,                /* 013 */
  M16C_xx_ADD_B_G_SRC_DEST,                 /* 014 */
  M16C_xx_ADD_W_G_SRC_DEST,                 /* 015 */
  M16C_xx_ADD_B_S_SRC_R0L_R0H,              /* 016 */
  M16C_xx_ADD_B_G_IMM8_SP,                  /* 017 */
  M16C_xx_ADD_W_G_IMM16_SP,                 /* 018 */
  M16C_xx_ADD_B_Q_IMM4_SP,                  /* 019 */
  M16C_xx_ADJNZ_B_IMM4_DEST_LABEL,          /* 020 */
  M16C_xx_ADJNZ_W_IMM4_DEST_LABEL,          /* 021 */
  M16C_xx_AND_B_G_IMM8_DEST,                /* 022 */
  M16C_xx_AND_W_G_IMM16_DEST,               /* 023 */
  M16C_xx_AND_B_S_IMM8_DEST,                /* 024 */
  M16C_xx_AND_B_G_SRC_DEST,                 /* 025 */
  M16C_xx_AND_W_G_SRC_DEST,                 /* 026 */
  M16C_xx_AND_B_S_SRC_R0L_R0H,              /* 027 */
  M16C_xx_BAND_SRC,                         /* 028 */
  M16C_xx_BCLR_G_DEST,                      /* 029 */
  M16C_xx_BCLR_S_BIT_BASE_11_SB,            /* 030 */
  M16C_xx_BMC_DEST,                         /* 031 */
  M16C_xx_BMGTU_DEST,                       /* 032 */
  M16C_xx_BMZ_DEST,                         /* 033 */
  M16C_xx_BMN_DEST,                         /* 034 */
  M16C_xx_BMLE_DEST,                        /* 035 */
  M16C_xx_BMO_DEST,                         /* 036 */
  M16C_xx_BMGE_DEST,                        /* 037 */
  M16C_xx_BMNC_DEST,                        /* 038 */
  M16C_xx_BMLEU_DEST,                       /* 039 */
  M16C_xx_BMNZ_DEST,                        /* 040 */
  M16C_xx_BMPZ_DEST,                        /* 041 */
  M16C_xx_BMGT_DEST,                        /* 042 */
  M16C_xx_BMNO_DEST,                        /* 043 */
  M16C_xx_BMLT_DEST,                        /* 044 */
  M16C_xx_BMC_C,                            /* 045 */
  M16C_xx_BMGTU_C,                          /* 046 */
  M16C_xx_BMZ_C,                            /* 047 */
  M16C_xx_BMN_C,                            /* 048 */
  M16C_xx_BMNC_C,                           /* 049 */
  M16C_xx_BMLEU_C,                          /* 050 */
  M16C_xx_BMNZ_C,                           /* 051 */
  M16C_xx_BMPZ_C,                           /* 052 */
  M16C_xx_BMLE_C,                           /* 053 */
  M16C_xx_BMGO_C,                           /* 054 */
  M16C_xx_BMGE_C,                           /* 055 */
  M16C_xx_BMGT_C,                           /* 056 */
  M16C_xx_BMNO_C,                           /* 057 */
  M16C_xx_BMLT_C,                           /* 058 */
  M16C_xx_BNAND_SRC,                        /* 059 */
  M16C_xx_BNOR_SRC,                         /* 060 */
  M16C_xx_BNOT_G_DEST,                      /* 061 */
  M16C_xx_BNOT_S_BIT_BASE_11_SB,            /* 062 */
  M16C_xx_BNTST_SRC,                        /* 063 */
  M16C_xx_BNXOR_SRC,                        /* 064 */
  M16C_xx_BOR_SRC,                          /* 065 */
  M16C_xx_BRK,                              /* 066 */
  M16C_xx_BSET_G_DEST,                      /* 067 */
  M16C_xx_BSET_S_BIT_BASE_11_SB,            /* 068 */
  M16C_xx_BTST_G_SRC,                       /* 069 */
  M16C_xx_BTST_S_BIT_BASE_11_SB,            /* 070 */
  M16C_xx_BTSTC_DEST,                       /* 071 */
  M16C_xx_BTSTS_DEST,                       /* 072 */
  M16C_xx_BXOR_SRC,                         /* 073 */
  M16C_xx_CMP_B_G_IMM8_DEST,                /* 074 */
  M16C_xx_CMP_W_G_IMM16_DEST,               /* 075 */
  M16C_xx_CMP_B_Q_IMM4_DEST,                /* 076 */
  M16C_xx_CMP_W_Q_IMM4_DEST,                /* 077 */
  M16C_xx_CMP_B_S_IMM8_DEST,                /* 078 */
  M16C_xx_CMP_B_G_SRC_DEST,                 /* 079 */
  M16C_xx_CMP_W_G_SRC_DEST,                 /* 070 */
  M16C_xx_CMP_B_S_SRC_R0L_R0H,              /* 081 */
  M16C_xx_DADC_B_IMM8_R0L,                  /* 082 */
  M16C_xx_DADC_W_IMM16_R0,                  /* 083 */
  M16C_xx_DADC_B_R0H_R0L,                   /* 084 */
  M16C_xx_DADC_W_R1_R0,                     /* 085 */
  M16C_xx_DADD_B_IMM8_R0L,                  /* 086 */
  M16C_xx_DADD_W_IMM16_R0,                  /* 087 */
  M16C_xx_DADD_B_R0H_R0L,                   /* 088 */
  M16C_xx_DADD_W_R1_R0,                     /* 089 */
  M16C_xx_DEC_B_DEST,                       /* 080 */
  M16C_xx_DEC_W_A0,                         /* 091 */
  M16C_xx_DEC_W_A1,                         /* 092 */
  M16C_xx_DIV_B_IMM8,                       /* 093 */
  M16C_xx_DIV_W_IMM16,                      /* 094 */
  M16C_xx_DIV_B_SRC,                        /* 095 */
  M16C_xx_DIV_W_SRC,                        /* 096 */
  M16C_xx_DIVU_B_IMM8,                      /* 097 */
  M16C_xx_DIVU_W_IMM16,                     /* 098 */
  M16C_xx_DIVU_B_SRC,                       /* 099 */
  M16C_xx_DIVU_W_SRC,                       /* 100 */
  M16C_xx_DIVX_B_IMM8,                      /* 101 */
  M16C_xx_DIVX_W_IMM8,                      /* 102 */
  M16C_xx_DIVX_B_SRC,                       /* 103 */
  M16C_xx_DIVX_W_SRC,                       /* 104 */
  M16C_xx_DSBB_B_IMM8_R0L,                  /* 105 */
  M16C_xx_DSBB_W_IMM16_R0,                  /* 106 */
  M16C_xx_DSBB_B_R0H_R0L,                   /* 107 */
  M16C_xx_DSBB_W_R1_R0,                     /* 108 */
  M16C_xx_DSUB_B_IMM8_R0L,                  /* 109 */
  M16C_xx_DSUB_W_IMM16_R0,                  /* 110 */
  M16C_xx_DSUB_B_R0H_R0L,                   /* 111 */
  M16C_xx_DSUB_W_R1_R0,                     /* 112 */
  M16C_xx_ENTER_IMM8,                       /* 113 */
  M16C_xx_EXITD,                            /* 114 */
  M16C_xx_EXTS_B_DEST,                      /* 115 */
  M16C_xx_EXTS_W_R0,                        /* 116 */
  M16C_xx_FCLR_C,                           /* 117 */
  M16C_xx_FCLR_D,                           /* 118 */
  M16C_xx_FCLR_Z,                           /* 119 */
  M16C_xx_FCLR_S,                           /* 120 */
  M16C_xx_FCLR_B,                           /* 121 */
  M16C_xx_FCLR_O,                           /* 122 */
  M16C_xx_FCLR_I,                           /* 123 */
  M16C_xx_FCLR_U,                           /* 124 */
  M16C_xx_FSET_C,                           /* 125 */
  M16C_xx_FSET_D,                           /* 126 */
  M16C_xx_FSET_Z,                           /* 127 */
  M16C_xx_FSET_S,                           /* 128 */
  M16C_xx_FSET_B,                           /* 129 */
  M16C_xx_FSET_O,                           /* 130 */
  M16C_xx_FSET_I,                           /* 131 */
  M16C_xx_FSET_U,                           /* 132 */
  M16C_xx_INC_B_DEST,                       /* 133 */
  M16C_xx_INC_W_A0,                         /* 134 */
  M16C_xx_INC_W_A1,                         /* 135 */
  M16C_xx_INT_IMM,                          /* 136 */
  M16C_xx_INTO,                             /* 137 */
  M16C_xx_JC_LABEL,                         /* 138 */
  M16C_xx_JGTU_LABEL,                       /* 139 */
  M16C_xx_JZ_LABEL,                         /* 140 */
  M16C_xx_JN_LABEL,                         /* 141 */
  M16C_xx_JNC_LABEL,                        /* 142 */
  M16C_xx_JLEU_LABEL,                       /* 143 */
  M16C_xx_JNZ_LABEL,                        /* 144 */
  M16C_xx_JPZ_LABEL,                        /* 145 */
  M16C_xx_JLE_LABEL,                        /* 146 */
  M16C_xx_JO_LABEL,                         /* 147 */
  M16C_xx_JGE_LABEL,                        /* 148 */
  M16C_xx_JGT_LABEL,                        /* 149 */
  M16C_xx_JNO_LABEL,                        /* 150 */
  M16C_xx_JLT_LABEL,                        /* 151 */
  M16C_xx_JMP_S_LABEL,                      /* 152 */
  M16C_xx_JMP_B_LABEL,                      /* 153 */
  M16C_xx_JMP_W_LABEL,                      /* 154 */
  M16C_xx_JMP_A_LABEL,                      /* 155 */
  M16C_xx_JMPI_W_SRC,                       /* 156 */
  M16C_xx_JMPI_A_SRC,                       /* 157 */
  M16C_xx_JMPS_IMM8,                        /* 158 */
  M16C_xx_JSR_W_LABEL,                      /* 159 */
  M16C_xx_JSR_A_LABEL,                      /* 160 */
  M16C_xx_JSRI_W_SRC,                       /* 161 */
  M16C_xx_JSRI_A_SRC,                       /* 162 */
  M16C_xx_JSRS_IMM8,                        /* 163 */
  M16C_xx_LDC_IMM16_INTBL,                  /* 164 */
  M16C_xx_LDC_IMM16_INTBH,                  /* 165 */
  M16C_xx_LDC_IMM16_FLG,                    /* 166 */
  M16C_xx_LDC_IMM16_ISP,                    /* 167 */
  M16C_xx_LDC_IMM16_SP,                     /* 168 */
  M16C_xx_LDC_IMM16_SB,                     /* 169 */
  M16C_xx_LDC_IMM16_FB,                     /* 170 */
  M16C_xx_LDC_SRC_DEST,                     /* 171 */
  M16C_xx_LDCTX_ABS16_ABS20,                /* 172 */
  M16C_xx_LDE_B_ABS20_DEST,                 /* 173 */
  M16C_xx_LDE_W_ABS20_DEST,                 /* 174 */
  M16C_xx_LDE_B_DSP_20_A0_DEST,             /* 175 */
  M16C_xx_LDE_W_DSP_20_A0_DEST,             /* 176 */
  M16C_xx_LDE_B_A0A1_DEST,                  /* 177 */
  M16C_xx_LDE_W_A0A1_DEST,                  /* 178 */
  M16C_xx_LDINTB_IMM1_IMM2,                 /* 179 */
  M16C_xx_LDIPL_IMM,                        /* 180 */
  M16C_xx_MOV_B_G_IMM8_DEST,                /* 181 */
  M16C_xx_MOV_W_G_IMM8_DEST,                /* 182 */
  M16C_xx_MOV_B_Q_IMM4_DEST,                /* 183 */
  M16C_xx_MOV_W_Q_IMM4_DEST,                /* 184 */
  M16C_xx_MOV_B_S_IMM8_DEST,                /* 185 */
  M16C_xx_MOV_B_S_IMM8_A0,                  /* 186 */
  M16C_xx_MOV_B_S_IMM8_A1,                  /* 187 */
  M16C_xx_MOV_W_S_IMM16_A0,                 /* 188 */
  M16C_xx_MOV_W_S_IMM16_A1,                 /* 189 */
  M16C_xx_MOV_B_Z_0_DEST,                   /* 190 */
  M16C_xx_MOV_B_G_SRC_DEST,                 /* 191 */
  M16C_xx_MOV_W_G_SRC_DEST,                 /* 191a ;-) */
  M16C_xx_MOV_B_S_SRC_A0,                   /* 192 */
  M16C_xx_MOV_B_S_SRC_A1,                   /* 193 */
  M16C_xx_MOV_B_S_R0L_DEST,                 /* 194 */
  M16C_xx_MOV_B_S_R0H_DEST,                 /* 195 */
  M16C_xx_MOV_B_S_SRC_R0L,                  /* 196 */
  M16C_xx_MOV_B_S_SRC_R0H,                  /* 197 */
  M16C_xx_MOV_B_G_DSP_8_SP_DEST,            /* 198 */
  M16C_xx_MOV_W_G_DSP_8_SP_DEST,            /* 199 */
  M16C_xx_MOV_B_G_SRC_DSP_8_SP,             /* 200 */
  M16C_xx_MOV_W_G_SRC_DSP_8_SP,             /* 201 */
  M16C_xx_MOVA_SRC_DEST,                    /* 202 */
  M16C_xx_MOVLL_R0L_DEST,                   /* 203 */
  M16C_xx_MOVLH_R0L_DEST,                   /* 204 */
  M16C_xx_MOVHL_R0L_DEST,                   /* 205 */
  M16C_xx_MOVHH_R0L_DEST,                   /* 206 */
  M16C_xx_MOVLL_DEST_R0L,                   /* 207 */
  M16C_xx_MOVLH_DEST_R0L,                   /* 208 */
  M16C_xx_MOVHL_DEST_R0L,                   /* 209 */
  M16C_xx_MOVHH_DEST_R0L,                   /* 210 */
  M16C_xx_MUL_B_IMM8_DEST,                  /* 211 */
  M16C_xx_MUL_W_IMM16_DEST,                 /* 212 */
  M16C_xx_MUL_B_SRC_DEST,                   /* 213 */
  M16C_xx_MUL_W_SRC_DEST,                   /* 214 */
  M16C_xx_MULU_B_IMM8_DEST,                 /* 215 */
  M16C_xx_MULU_W_IMM16_DEST,                /* 216 */
  M16C_xx_MULU_B_SRC_DEST,                  /* 217 */
  M16C_xx_MULU_W_SRC_DEST,                  /* 218 */
  M16C_xx_NEG_B_DEST,                       /* 219 */
  M16C_xx_NEG_W_DEST,                       /* 220 */
  M16C_xx_NOP,                              /* 221 */
  M16C_xx_NOT_B_G_DEST,                     /* 222 */
  M16C_xx_NOT_W_G_DEST,                     /* 223 */
  M16C_xx_NOT_B_S_DEST,                     /* 224 */
  M16C_xx_OR_B_G_IMM8_DEST,                 /* 225 */
  M16C_xx_OR_W_G_IMM8_DEST,                 /* 226 */
  M16C_xx_OR_B_S_IMM8_DEST,                 /* 227 */
  M16C_xx_OR_B_G_SRC_DEST,                  /* 228 */
  M16C_xx_OR_B_S_SRC_R0L_R0H,               /* 229 */
  M16C_xx_POP_B_G_DEST,                     /* 230 */
  M16C_xx_POP_W_G_DEST,                     /* 231 */
  M16C_xx_POP_B_S_DEST,                     /* 232 */
  M16C_xx_POP_W_S_DEST,                     /* 233 */
  M16C_xx_POPC_DEST,                        /* 234 */
  M16C_xx_POPM_DEST,                        /* 235 */
  M16C_xx_PUSH_B_G_IMM8,                    /* 236 */
  M16C_xx_PUSH_W_G_IMM16,                   /* 237 */
  M16C_xx_PUSH_B_G_SRC,                     /* 238 */
  M16C_xx_PUSH_W_G_SRC,                     /* 239 */
  M16C_xx_PUSH_B_S_SRC,                     /* 240 */
  M16C_xx_PUSH_W_S_SRC,                     /* 241 */
  M16C_xx_PUSHA_SRC,                        /* 242 */
  M16C_xx_PUSHC_SRC,                        /* 243 */
  M16C_xx_PUSHM_SRC,                        /* 244 */
  M16C_xx_REIT,                             /* 245 */
  M16C_xx_RMPA_B,                           /* 246 */
  M16C_xx_RMPA_W,                           /* 247 */
  M16C_xx_ROLC_B_DEST,                      /* 248 */
  M16C_xx_ROLC_W_DEST,                      /* 249 */
  M16C_xx_RORC_B_DEST,                      /* 250 */
  M16C_xx_RORC_W_DEST,                      /* 251 */
  M16C_xx_ROT_B_IMM4_DEST,                  /* 252 */
  M16C_xx_ROT_W_IMM4_DEST,                  /* 253 */
  M16C_xx_ROT_B_R1H_DEST,                   /* 254 */
  M16C_xx_ROT_W_R1H_DEST,                   /* 255 */
  M16C_xx_RTS,                              /* 256 */
  M16C_xx_SBB_B_IMM8_DEST,                  /* 257 */
  M16C_xx_SBB_W_IMM16_DEST,                 /* 258 */
  M16C_xx_SBB_B_SRC_DEST,                   /* 259 */
  M16C_xx_SBB_W_SRC_DEST,                   /* 260 */
  M16C_xx_SBJNZ_B_IMM4_DEST_LABEL,          /* 261 */
  M16C_xx_SBJNZ_W_IMM4_DEST_LABEL,          /* 262 */
  M16C_xx_SHA_B_IMM4_DEST,                  /* 263 */
  M16C_xx_SHA_W_IMM4_DEST,                  /* 264 */
  M16C_xx_SHA_B_R1H_DEST,                   /* 265 */
  M16C_xx_SHA_W_R1H_DEST,                   /* 266 */
  M16C_xx_SHA_L_IMM4_DEST,                  /* 267 */
  M16C_xx_SHA_L_R1H_DEST,                   /* 268 */
  M16C_xx_SHL_B_IMM4_DEST,                  /* 269 */
  M16C_xx_SHL_W_IMM4_DEST,                  /* 270 */
  M16C_xx_SHL_B_R1H_DEST,                   /* 271 */
  M16C_xx_SHL_W_R1H_DEST,                   /* 272 */
  M16C_xx_SHL_L_IMM4_DEST,                  /* 273 */
  M16C_xx_SHL_L_R1H_DEST,                   /* 274 */
  M16C_xx_SMOVB_B,                          /* 275 */
  M16C_xx_SMOVB_W,                          /* 276 */
  M16C_xx_SMOVF_B,                          /* 277 */
  M16C_xx_SMOVF_W,                          /* 278 */
  M16C_xx_SSTR_B,                           /* 279 */
  M16C_xx_SSTR_W,                           /* 280 */
  M16C_xx_STC_SRC_DEST,                     /* 281 */
  M16C_xx_STC_PC_DEST,                      /* 282 */
  M16C_xx_STCTX_ABS16_ABS20,                /* 283 */
  M16C_xx_STE_B_SRC_ABS20,                  /* 284 */
  M16C_xx_STE_W_SRC_ABS20,                  /* 285 */
  M16C_xx_STE_B_SRC_DSP_20_A0,              /* 286 */
  M16C_xx_STE_W_SRC_DSP_20_A0,              /* 287 */
  M16C_xx_STE_B_SRC_A0A1,                   /* 288 */
  M16C_xx_STE_W_SRC_A0A1,                   /* 288a ;-) */
  M16C_xx_STNZ_IMM8_DEST,                   /* 289 */
  M16C_xx_STZ_IMM8_DEST,                    /* 290 */
  M16C_xx_STZX_IMM81_IMM82_DEST,            /* 291 */
  M16C_xx_SUB_B_G_IMM8_DEST,                /* 292 */
  M16C_xx_SUB_W_G_IMM16_DEST,               /* 293 */
  M16C_xx_SUB_B_S_IMM8_DEST,                /* 294 */
  M16C_xx_SUB_B_G_SRC_DEST,                 /* 295 */
  M16C_xx_SUB_W_G_SRC_DEST,                 /* 296 */
  M16C_xx_SUB_B_S_SRC_R0L_R0H,              /* 297 */
  M16C_xx_TST_B_IMM8_DEST,                  /* 298 */
  M16C_xx_TST_W_IMM16_DEST,                 /* 299 */
  M16C_xx_TST_B_SRC_DEST,                   /* 300 */
  M16C_xx_TST_W_SRC_DEST,                   /* 301 */
  M16C_xx_UND,                              /* 302 */
  M16C_xx_WAIT,                             /* 303 */
  M16C_xx_XCHG_B_SRC_DEST,                  /* 304 */
  M16C_xx_XCHG_W_SRC_DEST,                  /* 305 */
  M16C_xx_XOR_B_IMM8_DEST,                  /* 306 */
  M16C_xx_XOR_W_IMM16_DEST,                 /* 307 */
  M16C_xx_XOR_B_SRC_DEST,                   /* 308 */
  M16C_xx_XOR_W_SRC_DEST,                   /* 309 */

  M16C_xx_last
};

#endif /* INS_HPP_ */