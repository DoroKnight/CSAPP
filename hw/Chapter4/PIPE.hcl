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

# Pipeline control logic
# F_stall:
bool F_stall = 
        # Conditions for a load/use hazard
        E_icode in { IMRMOVQ, IPOPQ } &&
        E_dstM in { d_srcA, d_srcB } ||
        # Stalling at fetch while ret passes through pipeline
        IRET in { D_icode, E_icode, M_icode };

# D_stall:
bool D_stall = 
        # Conditions for a load/use hazard
        E_icode in { IMRMOVQ, IPOPQ } &&
        E_dstM in { d_srcA, d_srcB }

# D_bubble:
bool D_bubble = 
        # Mispredicted branch
        (E_icode == IJXX && !e_Cnd) ||
        # Stalling at fetch while ret passes through pipeline
        # but not condition for a load/use hazard
        !(E_icode in {IMRMOVQ, IPOPQ} && E_dstM in {d_srcA, d_srcB}) &&
        IRET in {D_icode, E_icode, M_icode};

# E_bubble:
bool E_bubble = 
        # Bubble at fetch while ret passes through pipeline 
        (E_icode == IJXX && !e_Cnd) ||
        # or in condition for a load/use hazard
        E_icode in {IMRMOVQ, IPOPQ} && E_dstM in {d_srcA, d_scrB};

# set_cc:
bool set_cc =
        # Only in case of OP and no exception
        E_icode == IOPQ && 
        !m_stat in {SINS, SADR, SHLT} &&
        !W_stat in {SINS, SADR, SHLT};

# M_bubble
bool M_bubble = 
        # Only in case of exceptions
        m_stat in {SINS, SADR, SHLT} ||
        W_stat in {SINS, SADR, SHLT};

# W_stall:
bool W_stall = 
        # Only in case of W_stat is exception
        W_stat in {SINS, SADR, SHLT};