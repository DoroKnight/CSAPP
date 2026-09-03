# Stage: Select PC & Fetch
# f_stat:
bool f_stat = [
    f_icode == IHALT : SHLT;    // Attention: the prefix is f.
    !instr_vaild : SINS;        // Instrction is not vaild.
    imem_error = SADR;          // The memory's address is not vaild.
    1 : SAOK;                   // Default: work normally.
]

# Stage: Decode & Write back
# dst_E:
word d_dstE = [
    d_icode in { IRRMOVQ, IIRMOVQ, IOPQ } : D_rB;       // OP's destination
    d_icode in { IPUSHQ, IPOPQ, ICALL, IRET } : RREP;   // Set %rsp
    1 : RNOVE           // Don't need register.
]

# d_valA:
word d_valA = [
    D_icode in { ICALL, IJXX } : D_valP;    # Use incremented PC
    d_srcA == e_dstE : e_valE;      # Forward valE from execute
    d_srcA == m_dstM : m_valM;      # Forward valM from memory
    d_srcA == M_dstE : M_valE;      # Forward valE from memory
    d_srcA == W_dstM : W_valM;      # Forward valM from write back
    d_srcA == W_dstE : W_valE;      # Forward valE from write back
    1 : d_rvalA;    # Default: from the register rA (value of register file)
]

# d_valB:
word d_valB = [
    d_srcB == e_dstE : e_valE;      # Forward valE from execute
    d_srcB == m_dstM : m_valM;      # Forward valM from memory
    d_srcB == M_dstE : M_valE;      # Forward valE from memory
    d_srcB == W_dstM : W_valM;      # Forward valM from write back
    d_srcB == W_dstE : W_valE;      # Forward valE from write back
    1 : d_rvalB;    # Default: from the register rA (value of register file)
]

# Stat:
word Stat = [
    W_stat == SBUB : SAOK;
    1 : W_stat;
]

# Stage: memory
# m_stat:
word m_stat = [
    dmem_error : SADR;      # Data's address wrong
    1: M_stat;              # Default: inherit command's status.
]