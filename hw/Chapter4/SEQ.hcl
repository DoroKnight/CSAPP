# Stage: Fatch
# 1. need_regids
bool need_regids = 
    icode in { IRRMOVQ, IOPQ, IPUSHQ, IPOPQ, 
               IIRMOVQ, IRMOVQ, IMRMOVQ };

# 2. need_valC
bool need_valC = icode in { IIRMOVQ, IRMMOVQ, IMRMOVQ, ICALL, IJXX };

# Stage: Decode & Write back
# 1. srcA ( Where does valA come from )
word srcA = [
    icode in { IRRMOVQ, IRMMOVQ, IOPQ, IPUSHQ } : rA;
    icode in { IPOPQ, IRET } : RRSP;
    1 : RNONE;      # Don't need register
];

# 2. srcB ( Where does valB come from )
word srcB = [
    icode in { IOPQ, IRMOVQ, IMRMOVQ} : rB;
    icode in { ICALL, IPUSHQ, IPOPQ, IRET } : RRSP;
    1 : RNONE;      # Don't need register
];

# 3. dstE ( The target register of valE )
word dstE = [
    icode == IRRMOVQ && Cnd : rB;
    icode in { IRRMOVQ, IIRMOVQ, IOPQ } : rB;       # OP's destination
    icode in { IPUSHQ, IPOPQ, ICALL, IRET } : RRSP; # Set %rsp
    1 : RNONE;      # Don't need register
];

# 4. dstM ( The target register of valM )
word dstM = [
    icode in { IMRMOVQ, IPOPQ } : rA;
    1 : RNONE;      # Don't need register
];

# Stage: Execute
# 1. aluA ( The second operator of ALU )
word aluA = [
    icode in { IRRMOVQ, IOPQ } : valA;
    icode in { IRMMOVQ, IMRMOVQ, IIRMOVQ } : valC;
    icode in { IPUSHQ, ICALL } : -8;
    icode in { IPOPQ, IRET } : 8;
    # Other instructions don't need ALU
];

# 2. aluB ( The fisrt opertor of ALU ) 
word aluB = [
    icode in { IOPQ, IRMMOVQ, IMRMOVQ, IPOPQ 
               IPUSHQ, ICALL, IRET } : valB;
    icode in { IRRMOVQ, IIRMOVQ } : 0;
    # Other instructions don't need ALU
];

# 3. alufun ( Set the OP's model )
word alufun = [
    icode == IOPQ : ifun;
    1 : ALUADD      # Default station: work as ADD
];

# 4. set_cc ( Set the CC and only set when IOPQ )
bool set_cc = icode in { IOPQ };

# Stage: Memory
# 1. mem_addr ( The address of memory )
word mem_addr = [
    icode in { IRMMOVQ, IMRMOVQ, IPUSHQ, ICALL } : valE;
    icode in { IPOPQ, IRET } : valA;
    # Other instructions don't need address
];

# 2. mem_data ( The data of memory ) 
word mem_data = [
    icode in { IMRMOVQ, IPUSHQ } : valA;
    icode in { ICALL } : valP;
    # Other instructions don't need write data.
];

# 3. mem_read ( The sign of only read memory ) 
bool mem_read = icode in { IMRMOVQ, IRET, IPOPQ };

# 4. mem_write ( The sign of only write memory )
bool mem_write = icode in { IRMMOVQ, IPUSHQ, ICALL };

# 5. Stat ( Set the mechine's state )
word Stat = [
    imem_error || dmem_error : SADR;
    !instr_vaild : SINS;
    icode == IHALT : SHLT;
    1 : SAOK;
];

# Stage: PC update
word new_pc = [
    # Call. Use instruction constant
    icode == ICALL : valC;
    # Taken branch. Use instruction constant
    icode == IJXX && Cnd : valC;
    # Completion of RET instruction. Use value from stack
    icode == IRET : valM;
    # Default : Use incremented PC
    1 : valP;
];