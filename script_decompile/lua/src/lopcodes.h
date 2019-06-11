/*
** $Id: lopcodes.h,v 1.125.1.1 2007/12/27 13:02:25 roberto Exp $
** Opcodes for Lua virtual machine
** See Copyright Notice in lua.h
*/

#ifndef lopcodes_h
#define lopcodes_h

#include "llimits.h"


/*===========================================================================
  We assume that instructions are unsigned numbers.
  All instructions have an opcode in the first 6 bits.
  Instructions can have the following fields:
	`A' : 8 bits
	`B' : 9 bits
	`C' : 9 bits
	`Bx' : 18 bits (`B' and `C' together)
	`sBx' : signed Bx

  A signed argument is represented in excess K; that is, the number
  value is the unsigned value minus K. K is exactly the maximum value
  for that argument (so that -max is represented by 0, and +max is
  represented by 2*max), which is half the maximum for the corresponding
  unsigned argument.
===========================================================================*/


enum OpMode {iABC, iABx, iAsBx};  /* basic instruction format */


/*
** size and position of opcode arguments.
*/
#define SIZE_C		9
#define SIZE_B		9
#define SIZE_Bx		(SIZE_C + SIZE_B)
#define SIZE_A		8

#define SIZE_OP		6

#define POS_OP		0
#define POS_A		(POS_OP + SIZE_OP)
#define POS_C		(POS_A + SIZE_A)
#define POS_B		(POS_C + SIZE_C)
#define POS_Bx		POS_C


/*
** limits for opcode arguments.
** we use (signed) int to manipulate most arguments,
** so they must fit in LUAI_BITSINT-1 bits (-1 for sign)
*/
#if SIZE_Bx < LUAI_BITSINT-1
#define MAXARG_Bx        ((1<<SIZE_Bx)-1)
#define MAXARG_sBx        (MAXARG_Bx>>1)         /* `sBx' is signed */
#else
#define MAXARG_Bx        MAX_INT
#define MAXARG_sBx        MAX_INT
#endif


#define MAXARG_A        ((1<<SIZE_A)-1)
#define MAXARG_B        ((1<<SIZE_B)-1)
#define MAXARG_C        ((1<<SIZE_C)-1)


/* creates a mask with `n' 1 bits at position `p' */
#define MASK1(n,p)	((~((~(Instruction)0)<<n))<<p)

/* creates a mask with `n' 0 bits at position `p' */
#define MASK0(n,p)	(~MASK1(n,p))

/*
** the following macros help to manipulate instructions
*/

#define GET_OPCODE(i)	(cast(OpCode, ((i)>>POS_OP) & MASK1(SIZE_OP,0)))
#define SET_OPCODE(i,o)	((i) = (((i)&MASK0(SIZE_OP,POS_OP)) | \
		((cast(Instruction, o)<<POS_OP)&MASK1(SIZE_OP,POS_OP))))

#define GETARG_A(i)	(cast(int, ((i)>>POS_A) & MASK1(SIZE_A,0)))
#define SETARG_A(i,u)	((i) = (((i)&MASK0(SIZE_A,POS_A)) | \
		((cast(Instruction, u)<<POS_A)&MASK1(SIZE_A,POS_A))))

#define GETARG_B(i)	(cast(int, ((i)>>POS_B) & MASK1(SIZE_B,0)))
#define SETARG_B(i,b)	((i) = (((i)&MASK0(SIZE_B,POS_B)) | \
		((cast(Instruction, b)<<POS_B)&MASK1(SIZE_B,POS_B))))

#define GETARG_C(i)	(cast(int, ((i)>>POS_C) & MASK1(SIZE_C,0)))
#define SETARG_C(i,b)	((i) = (((i)&MASK0(SIZE_C,POS_C)) | \
		((cast(Instruction, b)<<POS_C)&MASK1(SIZE_C,POS_C))))

#define GETARG_Bx(i)	(cast(int, ((i)>>POS_Bx) & MASK1(SIZE_Bx,0)))
#define SETARG_Bx(i,b)	((i) = (((i)&MASK0(SIZE_Bx,POS_Bx)) | \
		((cast(Instruction, b)<<POS_Bx)&MASK1(SIZE_Bx,POS_Bx))))

#define GETARG_sBx(i)	(GETARG_Bx(i)-MAXARG_sBx)
#define SETARG_sBx(i,b)	SETARG_Bx((i),cast(unsigned int, (b)+MAXARG_sBx))


#define CREATE_ABC(o,a,b,c)	((cast(Instruction, o)<<POS_OP) \
			| (cast(Instruction, a)<<POS_A) \
			| (cast(Instruction, b)<<POS_B) \
			| (cast(Instruction, c)<<POS_C))

#define CREATE_ABx(o,a,bc)	((cast(Instruction, o)<<POS_OP) \
			| (cast(Instruction, a)<<POS_A) \
			| (cast(Instruction, bc)<<POS_Bx))


/*
** Macros to operate RK indices
*/

/* this bit 1 means constant (0 means register) */
#define BITRK		(1 << (SIZE_B - 1))

/* test whether value is a constant */
#define ISK(x)		((x) & BITRK)

/* gets the index of the constant */
#define INDEXK(r)	((int)(r) & ~BITRK)

#define MAXINDEXRK	(BITRK - 1)

/* code a constant index as a RK value */
#define RKASK(x)	((x) | BITRK)


/*
** invalid register that fits in 8 bits
*/
#define NO_REG		MAXARG_A


/*
** R(x) - register
** Kst(x) - constant (in constant table)
** RK(x) == if ISK(x) then Kst(INDEXK(x)) else R(x)
*/


/*
** grep "ORDER OP" if you change these enums
*/

typedef enum {
/*----------------------------------------------------------------------
name		args	description
------------------------------------------------------------------------*/
	OP_SUB,/*	A B C	R(A) := RK(B) - RK(C)				*/ //0x7c

	OP_GETGLOBAL = 1,/*	A Bx	R(A) := Gbl[Kst(Bx)]				*/ //0x71 true

	OP_TEST,/*	A C	if not (R(A) <=> C) then pc++			*/ //0xe4
	OP_GETTABLE,/*	A B C	R(A) := R(B)[RK(C)]				*/ //0x6c true2

	OP_LOADK = 4,/*	A Bx	R(A) := Kst(Bx)					*/ //0x71 true
	OP_LOADNIL = 5,/*	A B	R(A) := ... := R(B) := nil			*/ //0x60 true
	OP_TAILCALL = 6,/*	A B C	return R(A)(R(A+1), ... ,R(A+B-1))		*/ //0x54 true
	OP_JMP = 7,/*	sBx	pc+=sBx					*/ //0x22 true
	OP_TFORLOOP = 8,/*	A C	R(A+3), ... ,R(A+2+C) := R(A)(R(A+1), R(A+2));
							if R(A+3) ~= nil then R(A+2)=R(A+3) else pc++	*/  //0x84 true

	OP_UNM,/*	A B	R(A) := -R(B)					*/ //0x60
	OP_LEN,/*	A B	R(A) := length of R(B)				*/ //0x60
	OP_CLOSE,/*	A 	close all variables in the stack up to (>=) R(A)*/ //0x0
	OP_LE,/*	A B C	if ((RK(B) <= RK(C)) ~= A) then pc++  		*/ //0xbc

	OP_CLOSURE = 13,/*	A Bx	R(A) := closure(KPROTO[Bx], R(A), ... ,R(A+n))	*/ //0x51 true

	OP_SETTABLE,/*	A B C	R(A)[RK(B)] := RK(C)				*/ //0x3c
	OP_TESTSET,/*	A B C	if (R(B) <=> C) then R(A) := R(B) else pc++	*/ //0xe4
	OP_MOD,/*	A B C	R(A) := RK(B) % RK(C)				*/ //0x7c

	OP_GETUPVAL = 17,/*	A B	R(A) := UpValue[B]				*/ //0x50  true
	OP_FORPREP = 18,/*	A sBx	R(A)-=R(A+2); pc+=sBx				*/ //0x62 true

	OP_MUL,/*	A B C	R(A) := RK(B) * RK(C)				*/ //0x7c
	OP_NEWTABLE,/*	A B C	R(A) := {} (size = B,C)				*/ //0x54

	OP_SELF = 21,/*	A B C	R(A+1) := R(B); R(A) := R(B)[RK(C)]		*/ //0x6c true
	OP_CONCAT = 22,/*	A B C	R(A) := R(B).. ... ..R(C)			*/ //0x68 true
	OP_LOADBOOL = 23,/*	A B C	R(A) := (Bool)B; if (C) pc++			*/ //0x54 true
	OP_SETLIST = 24,/*	A B C	R(A)[(C-1)*FPF+i] := R(A+i), 1 <= i <= B	*/ //0x14 true

	OP_NOT,/*	A B	R(A) := not R(B)				*/ //0x60

	OP_RETURN = 26,/*	A B	return R(A), ... ,R(A+B-2)	(see note)	*/ //0x10 true

	OP_DIV,/*	A B C	R(A) := RK(B) / RK(C)				*/ //0x7c true2
	OP_MOVE,/*	A B	R(A) := R(B)					*/ //0x60

	OP_SETGLOBAL = 29,/*	A Bx	Gbl[Kst(Bx)] := R(A)				*/ //0x31 true

	OP_ADD,/*	A B C	R(A) := RK(B) + RK(C)				*/ //0x7c true2
	OP_EQ,/*	A B C	if ((RK(B) == RK(C)) ~= A) then pc++		*/ //0xbc true2

	OP_FORLOOP = 32,/*	A sBx	R(A)+=R(A+2);
				if R(A) <?= R(A+1) then { pc+=sBx; R(A+3)=R(A) }*/ //0x62 true

	OP_LT,/*	A B C	if ((RK(B) <  RK(C)) ~= A) then pc++  		*/ //0xbc
	OP_POW,/*	A B C	R(A) := RK(B) ^ RK(C)				*/ //0x7c

	OP_SETUPVAL = 35,/*	A B	UpValue[B] := R(A)				*/ //0x10 true
	OP_CALL = 36,/*	A B C	R(A), ... ,R(A+C-2) := R(A)(R(A+1), ... ,R(A+B-1)) */ //0x54 true
	OP_VARARG = 37/*	A B	R(A), R(A+1), ..., R(A+B-1) = vararg		*/ //0x50 true


} OpCode;


#define NUM_OPCODES	(cast(int, OP_VARARG) + 1)



/*===========================================================================
  Notes:
  (*) In OP_CALL, if (B == 0) then B = top. C is the number of returns - 1,
      and can be 0: OP_CALL then sets `top' to last_result+1, so
      next open instruction (OP_CALL, OP_RETURN, OP_SETLIST) may use `top'.

  (*) In OP_VARARG, if (B == 0) then use actual number of varargs and
      set top (like in OP_CALL with C == 0).

  (*) In OP_RETURN, if (B == 0) then return up to `top'

  (*) In OP_SETLIST, if (B == 0) then B = `top';
      if (C == 0) then next `instruction' is real C

  (*) For comparisons, A specifies what condition the test should accept
      (true or false).

  (*) All `skips' (pc++) assume that next instruction is a jump
===========================================================================*/


/*
** masks for instruction properties. The format is:
** bits 0-1: op mode
** bits 2-3: C arg mode
** bits 4-5: B arg mode
** bit 6: instruction set register A
** bit 7: operator is a test
*/  

enum OpArgMask {
  OpArgN,  /* argument is not used */
  OpArgU,  /* argument is used */
  OpArgR,  /* argument is a register or a jump offset */
  OpArgK   /* argument is a constant or register/constant */
};

LUAI_DATA const lu_byte luaP_opmodes[NUM_OPCODES];

#define getOpMode(m)	(cast(enum OpMode, luaP_opmodes[m] & 3))
#define getBMode(m)	(cast(enum OpArgMask, (luaP_opmodes[m] >> 4) & 3))
#define getCMode(m)	(cast(enum OpArgMask, (luaP_opmodes[m] >> 2) & 3))
#define testAMode(m)	(luaP_opmodes[m] & (1 << 6))
#define testTMode(m)	(luaP_opmodes[m] & (1 << 7))


LUAI_DATA const char *const luaP_opnames[NUM_OPCODES+1];  /* opcode names */


/* number of list items to accumulate before a SETLIST instruction */
#define LFIELDS_PER_FLUSH	50


#endif