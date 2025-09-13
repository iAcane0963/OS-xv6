	.text

	/*
         * thread_switch(struct context *old, struct context *new);
         * old: a0, new: a1
         * 保存旧线程的寄存器，恢复新线程的寄存器。
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */

	/* 将 callee-saved 寄存器和返回地址 ra 保存到 old context 结构体中 */
	sd ra, 0(a0)   // 保存返回地址 (return address)
	sd sp, 8(a0)   // 保存栈指针 (stack pointer)
	sd s0, 16(a0)  // 保存 s0-s11 寄存器
	sd s1, 24(a0)
	sd s2, 32(a0)
	sd s3, 40(a0)
	sd s4, 48(a0)
	sd s5, 56(a0)
	sd s6, 64(a0)
	sd s7, 72(a0)
	sd s8, 80(a0)
	sd s9, 88(a0)
	sd s10, 96(a0)
	sd s11, 104(a0)

	/* 从 new context 结构体中恢复寄存器 */
	ld ra, 0(a1)   // 恢复返回地址
	ld sp, 8(a1)   // 恢复栈指针
	ld s0, 16(a1)  // 恢复 s0-s11 寄存器
	ld s1, 24(a1)
	ld s2, 32(a1)
	ld s3, 40(a1)
	ld s4, 48(a1)
	ld s5, 56(a1)
	ld s6, 64(a1)
	ld s7, 72(a1)
	ld s8, 80(a1)
	ld s9, 88(a1)
	ld s10, 96(a1)
	ld s11, 104(a1)

	ret    /* 返回到恢复的 ra 寄存器所指向的地址 */
