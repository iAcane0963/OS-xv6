
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	14010113          	addi	sp,sp,320 # 8001e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	794050ef          	jal	800057aa <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	17a080e7          	jalr	378(ra) # 800001c2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	136080e7          	jalr	310(ra) # 80006190 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1d6080e7          	jalr	470(ra) # 80006244 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	bca080e7          	jalr	-1078(ra) # 80005c54 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	00c080e7          	jalr	12(ra) # 80006100 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	064080e7          	jalr	100(ra) # 80006190 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	100080e7          	jalr	256(ra) # 80006244 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	070080e7          	jalr	112(ra) # 800001c2 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	0d6080e7          	jalr	214(ra) # 80006244 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <getfreemem>:

// 为 sysinfo 系统调用提供辅助功能：计算当前空闲的物理内存总量。
int getfreemem(void)
{
    80000178:	1101                	addi	sp,sp,-32
    8000017a:	ec06                	sd	ra,24(sp)
    8000017c:	e822                	sd	s0,16(sp)
    8000017e:	e426                	sd	s1,8(sp)
    80000180:	1000                	addi	s0,sp,32
  int count = 0;
  struct run *r;
  acquire(&kmem.lock);
    80000182:	00009497          	auipc	s1,0x9
    80000186:	eae48493          	addi	s1,s1,-338 # 80009030 <kmem>
    8000018a:	8526                	mv	a0,s1
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	004080e7          	jalr	4(ra) # 80006190 <acquire>
  r = kmem.freelist;
    80000194:	6c9c                	ld	a5,24(s1)
  // 遍历空闲链表，计算有多少个空闲页。
  while (r)
    80000196:	c785                	beqz	a5,800001be <getfreemem+0x46>
  int count = 0;
    80000198:	4481                	li	s1,0
  {
    count++;
    8000019a:	2485                	addiw	s1,s1,1
    r = r->next;
    8000019c:	639c                	ld	a5,0(a5)
  while (r)
    8000019e:	fff5                	bnez	a5,8000019a <getfreemem+0x22>
  }
  release(&kmem.lock);
    800001a0:	00009517          	auipc	a0,0x9
    800001a4:	e9050513          	addi	a0,a0,-368 # 80009030 <kmem>
    800001a8:	00006097          	auipc	ra,0x6
    800001ac:	09c080e7          	jalr	156(ra) # 80006244 <release>
  // 返回总的空闲字节数。
  return count * PGSIZE;
}
    800001b0:	00c4951b          	slliw	a0,s1,0xc
    800001b4:	60e2                	ld	ra,24(sp)
    800001b6:	6442                	ld	s0,16(sp)
    800001b8:	64a2                	ld	s1,8(sp)
    800001ba:	6105                	addi	sp,sp,32
    800001bc:	8082                	ret
  int count = 0;
    800001be:	4481                	li	s1,0
    800001c0:	b7c5                	j	800001a0 <getfreemem+0x28>

00000000800001c2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001c8:	ca19                	beqz	a2,800001de <memset+0x1c>
    800001ca:	87aa                	mv	a5,a0
    800001cc:	1602                	slli	a2,a2,0x20
    800001ce:	9201                	srli	a2,a2,0x20
    800001d0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001d8:	0785                	addi	a5,a5,1
    800001da:	fee79de3          	bne	a5,a4,800001d4 <memset+0x12>
  }
  return dst;
}
    800001de:	6422                	ld	s0,8(sp)
    800001e0:	0141                	addi	sp,sp,16
    800001e2:	8082                	ret

00000000800001e4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e4:	1141                	addi	sp,sp,-16
    800001e6:	e422                	sd	s0,8(sp)
    800001e8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ea:	ca05                	beqz	a2,8000021a <memcmp+0x36>
    800001ec:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f0:	1682                	slli	a3,a3,0x20
    800001f2:	9281                	srli	a3,a3,0x20
    800001f4:	0685                	addi	a3,a3,1
    800001f6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001f8:	00054783          	lbu	a5,0(a0)
    800001fc:	0005c703          	lbu	a4,0(a1)
    80000200:	00e79863          	bne	a5,a4,80000210 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000204:	0505                	addi	a0,a0,1
    80000206:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000208:	fed518e3          	bne	a0,a3,800001f8 <memcmp+0x14>
  }

  return 0;
    8000020c:	4501                	li	a0,0
    8000020e:	a019                	j	80000214 <memcmp+0x30>
      return *s1 - *s2;
    80000210:	40e7853b          	subw	a0,a5,a4
}
    80000214:	6422                	ld	s0,8(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret
  return 0;
    8000021a:	4501                	li	a0,0
    8000021c:	bfe5                	j	80000214 <memcmp+0x30>

000000008000021e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000021e:	1141                	addi	sp,sp,-16
    80000220:	e422                	sd	s0,8(sp)
    80000222:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000224:	c205                	beqz	a2,80000244 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000226:	02a5e263          	bltu	a1,a0,8000024a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022a:	1602                	slli	a2,a2,0x20
    8000022c:	9201                	srli	a2,a2,0x20
    8000022e:	00c587b3          	add	a5,a1,a2
{
    80000232:	872a                	mv	a4,a0
      *d++ = *s++;
    80000234:	0585                	addi	a1,a1,1
    80000236:	0705                	addi	a4,a4,1
    80000238:	fff5c683          	lbu	a3,-1(a1)
    8000023c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000240:	fef59ae3          	bne	a1,a5,80000234 <memmove+0x16>

  return dst;
}
    80000244:	6422                	ld	s0,8(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret
  if(s < d && s + n > d){
    8000024a:	02061693          	slli	a3,a2,0x20
    8000024e:	9281                	srli	a3,a3,0x20
    80000250:	00d58733          	add	a4,a1,a3
    80000254:	fce57be3          	bgeu	a0,a4,8000022a <memmove+0xc>
    d += n;
    80000258:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025a:	fff6079b          	addiw	a5,a2,-1
    8000025e:	1782                	slli	a5,a5,0x20
    80000260:	9381                	srli	a5,a5,0x20
    80000262:	fff7c793          	not	a5,a5
    80000266:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000268:	177d                	addi	a4,a4,-1
    8000026a:	16fd                	addi	a3,a3,-1
    8000026c:	00074603          	lbu	a2,0(a4)
    80000270:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000274:	fee79ae3          	bne	a5,a4,80000268 <memmove+0x4a>
    80000278:	b7f1                	j	80000244 <memmove+0x26>

000000008000027a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e406                	sd	ra,8(sp)
    8000027e:	e022                	sd	s0,0(sp)
    80000280:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000282:	00000097          	auipc	ra,0x0
    80000286:	f9c080e7          	jalr	-100(ra) # 8000021e <memmove>
}
    8000028a:	60a2                	ld	ra,8(sp)
    8000028c:	6402                	ld	s0,0(sp)
    8000028e:	0141                	addi	sp,sp,16
    80000290:	8082                	ret

0000000080000292 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000292:	1141                	addi	sp,sp,-16
    80000294:	e422                	sd	s0,8(sp)
    80000296:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000298:	ce11                	beqz	a2,800002b4 <strncmp+0x22>
    8000029a:	00054783          	lbu	a5,0(a0)
    8000029e:	cf89                	beqz	a5,800002b8 <strncmp+0x26>
    800002a0:	0005c703          	lbu	a4,0(a1)
    800002a4:	00f71a63          	bne	a4,a5,800002b8 <strncmp+0x26>
    n--, p++, q++;
    800002a8:	367d                	addiw	a2,a2,-1
    800002aa:	0505                	addi	a0,a0,1
    800002ac:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002ae:	f675                	bnez	a2,8000029a <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b0:	4501                	li	a0,0
    800002b2:	a809                	j	800002c4 <strncmp+0x32>
    800002b4:	4501                	li	a0,0
    800002b6:	a039                	j	800002c4 <strncmp+0x32>
  if(n == 0)
    800002b8:	ca09                	beqz	a2,800002ca <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002ba:	00054503          	lbu	a0,0(a0)
    800002be:	0005c783          	lbu	a5,0(a1)
    800002c2:	9d1d                	subw	a0,a0,a5
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret
    return 0;
    800002ca:	4501                	li	a0,0
    800002cc:	bfe5                	j	800002c4 <strncmp+0x32>

00000000800002ce <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002ce:	1141                	addi	sp,sp,-16
    800002d0:	e422                	sd	s0,8(sp)
    800002d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d4:	872a                	mv	a4,a0
    800002d6:	8832                	mv	a6,a2
    800002d8:	367d                	addiw	a2,a2,-1
    800002da:	01005963          	blez	a6,800002ec <strncpy+0x1e>
    800002de:	0705                	addi	a4,a4,1
    800002e0:	0005c783          	lbu	a5,0(a1)
    800002e4:	fef70fa3          	sb	a5,-1(a4)
    800002e8:	0585                	addi	a1,a1,1
    800002ea:	f7f5                	bnez	a5,800002d6 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002ec:	86ba                	mv	a3,a4
    800002ee:	00c05c63          	blez	a2,80000306 <strncpy+0x38>
    *s++ = 0;
    800002f2:	0685                	addi	a3,a3,1
    800002f4:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002f8:	fff6c793          	not	a5,a3
    800002fc:	9fb9                	addw	a5,a5,a4
    800002fe:	010787bb          	addw	a5,a5,a6
    80000302:	fef048e3          	bgtz	a5,800002f2 <strncpy+0x24>
  return os;
}
    80000306:	6422                	ld	s0,8(sp)
    80000308:	0141                	addi	sp,sp,16
    8000030a:	8082                	ret

000000008000030c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000030c:	1141                	addi	sp,sp,-16
    8000030e:	e422                	sd	s0,8(sp)
    80000310:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000312:	02c05363          	blez	a2,80000338 <safestrcpy+0x2c>
    80000316:	fff6069b          	addiw	a3,a2,-1
    8000031a:	1682                	slli	a3,a3,0x20
    8000031c:	9281                	srli	a3,a3,0x20
    8000031e:	96ae                	add	a3,a3,a1
    80000320:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000322:	00d58963          	beq	a1,a3,80000334 <safestrcpy+0x28>
    80000326:	0585                	addi	a1,a1,1
    80000328:	0785                	addi	a5,a5,1
    8000032a:	fff5c703          	lbu	a4,-1(a1)
    8000032e:	fee78fa3          	sb	a4,-1(a5)
    80000332:	fb65                	bnez	a4,80000322 <safestrcpy+0x16>
    ;
  *s = 0;
    80000334:	00078023          	sb	zero,0(a5)
  return os;
}
    80000338:	6422                	ld	s0,8(sp)
    8000033a:	0141                	addi	sp,sp,16
    8000033c:	8082                	ret

000000008000033e <strlen>:

int
strlen(const char *s)
{
    8000033e:	1141                	addi	sp,sp,-16
    80000340:	e422                	sd	s0,8(sp)
    80000342:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000344:	00054783          	lbu	a5,0(a0)
    80000348:	cf91                	beqz	a5,80000364 <strlen+0x26>
    8000034a:	0505                	addi	a0,a0,1
    8000034c:	87aa                	mv	a5,a0
    8000034e:	4685                	li	a3,1
    80000350:	9e89                	subw	a3,a3,a0
    80000352:	00f6853b          	addw	a0,a3,a5
    80000356:	0785                	addi	a5,a5,1
    80000358:	fff7c703          	lbu	a4,-1(a5)
    8000035c:	fb7d                	bnez	a4,80000352 <strlen+0x14>
    ;
  return n;
}
    8000035e:	6422                	ld	s0,8(sp)
    80000360:	0141                	addi	sp,sp,16
    80000362:	8082                	ret
  for(n = 0; s[n]; n++)
    80000364:	4501                	li	a0,0
    80000366:	bfe5                	j	8000035e <strlen+0x20>

0000000080000368 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000368:	1141                	addi	sp,sp,-16
    8000036a:	e406                	sd	ra,8(sp)
    8000036c:	e022                	sd	s0,0(sp)
    8000036e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000370:	00001097          	auipc	ra,0x1
    80000374:	af0080e7          	jalr	-1296(ra) # 80000e60 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000378:	00009717          	auipc	a4,0x9
    8000037c:	c8870713          	addi	a4,a4,-888 # 80009000 <started>
  if(cpuid() == 0){
    80000380:	c139                	beqz	a0,800003c6 <main+0x5e>
    while(started == 0)
    80000382:	431c                	lw	a5,0(a4)
    80000384:	2781                	sext.w	a5,a5
    80000386:	dff5                	beqz	a5,80000382 <main+0x1a>
      ;
    __sync_synchronize();
    80000388:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000038c:	00001097          	auipc	ra,0x1
    80000390:	ad4080e7          	jalr	-1324(ra) # 80000e60 <cpuid>
    80000394:	85aa                	mv	a1,a0
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	ca250513          	addi	a0,a0,-862 # 80008038 <etext+0x38>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	900080e7          	jalr	-1792(ra) # 80005c9e <printf>
    kvminithart();    // turn on paging
    800003a6:	00000097          	auipc	ra,0x0
    800003aa:	0d8080e7          	jalr	216(ra) # 8000047e <kvminithart>
    trapinithart();   // install kernel trap vector
    800003ae:	00001097          	auipc	ra,0x1
    800003b2:	79a080e7          	jalr	1946(ra) # 80001b48 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b6:	00005097          	auipc	ra,0x5
    800003ba:	dca080e7          	jalr	-566(ra) # 80005180 <plicinithart>
  }

  scheduler();        
    800003be:	00001097          	auipc	ra,0x1
    800003c2:	fe8080e7          	jalr	-24(ra) # 800013a6 <scheduler>
    consoleinit();
    800003c6:	00005097          	auipc	ra,0x5
    800003ca:	7a0080e7          	jalr	1952(ra) # 80005b66 <consoleinit>
    printfinit();
    800003ce:	00006097          	auipc	ra,0x6
    800003d2:	ab0080e7          	jalr	-1360(ra) # 80005e7e <printfinit>
    printf("\n");
    800003d6:	00008517          	auipc	a0,0x8
    800003da:	c7250513          	addi	a0,a0,-910 # 80008048 <etext+0x48>
    800003de:	00006097          	auipc	ra,0x6
    800003e2:	8c0080e7          	jalr	-1856(ra) # 80005c9e <printf>
    printf("xv6 kernel is booting\n");
    800003e6:	00008517          	auipc	a0,0x8
    800003ea:	c3a50513          	addi	a0,a0,-966 # 80008020 <etext+0x20>
    800003ee:	00006097          	auipc	ra,0x6
    800003f2:	8b0080e7          	jalr	-1872(ra) # 80005c9e <printf>
    printf("\n");
    800003f6:	00008517          	auipc	a0,0x8
    800003fa:	c5250513          	addi	a0,a0,-942 # 80008048 <etext+0x48>
    800003fe:	00006097          	auipc	ra,0x6
    80000402:	8a0080e7          	jalr	-1888(ra) # 80005c9e <printf>
    kinit();         // physical page allocator
    80000406:	00000097          	auipc	ra,0x0
    8000040a:	cd6080e7          	jalr	-810(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	322080e7          	jalr	802(ra) # 80000730 <kvminit>
    kvminithart();   // turn on paging
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	068080e7          	jalr	104(ra) # 8000047e <kvminithart>
    procinit();      // process table
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	992080e7          	jalr	-1646(ra) # 80000db0 <procinit>
    trapinit();      // trap vectors
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	6fa080e7          	jalr	1786(ra) # 80001b20 <trapinit>
    trapinithart();  // install kernel trap vector
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	71a080e7          	jalr	1818(ra) # 80001b48 <trapinithart>
    plicinit();      // set up interrupt controller
    80000436:	00005097          	auipc	ra,0x5
    8000043a:	d34080e7          	jalr	-716(ra) # 8000516a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	d42080e7          	jalr	-702(ra) # 80005180 <plicinithart>
    binit();         // buffer cache
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	f0e080e7          	jalr	-242(ra) # 80002354 <binit>
    iinit();         // inode table
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	59e080e7          	jalr	1438(ra) # 800029ec <iinit>
    fileinit();      // file table
    80000456:	00003097          	auipc	ra,0x3
    8000045a:	548080e7          	jalr	1352(ra) # 8000399e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000045e:	00005097          	auipc	ra,0x5
    80000462:	e44080e7          	jalr	-444(ra) # 800052a2 <virtio_disk_init>
    userinit();      // first user process
    80000466:	00001097          	auipc	ra,0x1
    8000046a:	d02080e7          	jalr	-766(ra) # 80001168 <userinit>
    __sync_synchronize();
    8000046e:	0ff0000f          	fence
    started = 1;
    80000472:	4785                	li	a5,1
    80000474:	00009717          	auipc	a4,0x9
    80000478:	b8f72623          	sw	a5,-1140(a4) # 80009000 <started>
    8000047c:	b789                	j	800003be <main+0x56>

000000008000047e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000047e:	1141                	addi	sp,sp,-16
    80000480:	e422                	sd	s0,8(sp)
    80000482:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000484:	00009797          	auipc	a5,0x9
    80000488:	b847b783          	ld	a5,-1148(a5) # 80009008 <kernel_pagetable>
    8000048c:	83b1                	srli	a5,a5,0xc
    8000048e:	577d                	li	a4,-1
    80000490:	177e                	slli	a4,a4,0x3f
    80000492:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000494:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000498:	12000073          	sfence.vma
  sfence_vma();
}
    8000049c:	6422                	ld	s0,8(sp)
    8000049e:	0141                	addi	sp,sp,16
    800004a0:	8082                	ret

00000000800004a2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004a2:	7139                	addi	sp,sp,-64
    800004a4:	fc06                	sd	ra,56(sp)
    800004a6:	f822                	sd	s0,48(sp)
    800004a8:	f426                	sd	s1,40(sp)
    800004aa:	f04a                	sd	s2,32(sp)
    800004ac:	ec4e                	sd	s3,24(sp)
    800004ae:	e852                	sd	s4,16(sp)
    800004b0:	e456                	sd	s5,8(sp)
    800004b2:	e05a                	sd	s6,0(sp)
    800004b4:	0080                	addi	s0,sp,64
    800004b6:	84aa                	mv	s1,a0
    800004b8:	89ae                	mv	s3,a1
    800004ba:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004bc:	57fd                	li	a5,-1
    800004be:	83e9                	srli	a5,a5,0x1a
    800004c0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004c2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004c4:	04b7f263          	bgeu	a5,a1,80000508 <walk+0x66>
    panic("walk");
    800004c8:	00008517          	auipc	a0,0x8
    800004cc:	b8850513          	addi	a0,a0,-1144 # 80008050 <etext+0x50>
    800004d0:	00005097          	auipc	ra,0x5
    800004d4:	784080e7          	jalr	1924(ra) # 80005c54 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004d8:	060a8663          	beqz	s5,80000544 <walk+0xa2>
    800004dc:	00000097          	auipc	ra,0x0
    800004e0:	c3c080e7          	jalr	-964(ra) # 80000118 <kalloc>
    800004e4:	84aa                	mv	s1,a0
    800004e6:	c529                	beqz	a0,80000530 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004e8:	6605                	lui	a2,0x1
    800004ea:	4581                	li	a1,0
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	cd6080e7          	jalr	-810(ra) # 800001c2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004f4:	00c4d793          	srli	a5,s1,0xc
    800004f8:	07aa                	slli	a5,a5,0xa
    800004fa:	0017e793          	ori	a5,a5,1
    800004fe:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000502:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    80000504:	036a0063          	beq	s4,s6,80000524 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000508:	0149d933          	srl	s2,s3,s4
    8000050c:	1ff97913          	andi	s2,s2,511
    80000510:	090e                	slli	s2,s2,0x3
    80000512:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000514:	00093483          	ld	s1,0(s2)
    80000518:	0014f793          	andi	a5,s1,1
    8000051c:	dfd5                	beqz	a5,800004d8 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000051e:	80a9                	srli	s1,s1,0xa
    80000520:	04b2                	slli	s1,s1,0xc
    80000522:	b7c5                	j	80000502 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000524:	00c9d513          	srli	a0,s3,0xc
    80000528:	1ff57513          	andi	a0,a0,511
    8000052c:	050e                	slli	a0,a0,0x3
    8000052e:	9526                	add	a0,a0,s1
}
    80000530:	70e2                	ld	ra,56(sp)
    80000532:	7442                	ld	s0,48(sp)
    80000534:	74a2                	ld	s1,40(sp)
    80000536:	7902                	ld	s2,32(sp)
    80000538:	69e2                	ld	s3,24(sp)
    8000053a:	6a42                	ld	s4,16(sp)
    8000053c:	6aa2                	ld	s5,8(sp)
    8000053e:	6b02                	ld	s6,0(sp)
    80000540:	6121                	addi	sp,sp,64
    80000542:	8082                	ret
        return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7ed                	j	80000530 <walk+0x8e>

0000000080000548 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000548:	57fd                	li	a5,-1
    8000054a:	83e9                	srli	a5,a5,0x1a
    8000054c:	00b7f463          	bgeu	a5,a1,80000554 <walkaddr+0xc>
    return 0;
    80000550:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000552:	8082                	ret
{
    80000554:	1141                	addi	sp,sp,-16
    80000556:	e406                	sd	ra,8(sp)
    80000558:	e022                	sd	s0,0(sp)
    8000055a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000055c:	4601                	li	a2,0
    8000055e:	00000097          	auipc	ra,0x0
    80000562:	f44080e7          	jalr	-188(ra) # 800004a2 <walk>
  if(pte == 0)
    80000566:	c105                	beqz	a0,80000586 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000568:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000056a:	0117f693          	andi	a3,a5,17
    8000056e:	4745                	li	a4,17
    return 0;
    80000570:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000572:	00e68663          	beq	a3,a4,8000057e <walkaddr+0x36>
}
    80000576:	60a2                	ld	ra,8(sp)
    80000578:	6402                	ld	s0,0(sp)
    8000057a:	0141                	addi	sp,sp,16
    8000057c:	8082                	ret
  pa = PTE2PA(*pte);
    8000057e:	00a7d513          	srli	a0,a5,0xa
    80000582:	0532                	slli	a0,a0,0xc
  return pa;
    80000584:	bfcd                	j	80000576 <walkaddr+0x2e>
    return 0;
    80000586:	4501                	li	a0,0
    80000588:	b7fd                	j	80000576 <walkaddr+0x2e>

000000008000058a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000058a:	715d                	addi	sp,sp,-80
    8000058c:	e486                	sd	ra,72(sp)
    8000058e:	e0a2                	sd	s0,64(sp)
    80000590:	fc26                	sd	s1,56(sp)
    80000592:	f84a                	sd	s2,48(sp)
    80000594:	f44e                	sd	s3,40(sp)
    80000596:	f052                	sd	s4,32(sp)
    80000598:	ec56                	sd	s5,24(sp)
    8000059a:	e85a                	sd	s6,16(sp)
    8000059c:	e45e                	sd	s7,8(sp)
    8000059e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a0:	c639                	beqz	a2,800005ee <mappages+0x64>
    800005a2:	8aaa                	mv	s5,a0
    800005a4:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005a6:	77fd                	lui	a5,0xfffff
    800005a8:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005ac:	15fd                	addi	a1,a1,-1
    800005ae:	00c589b3          	add	s3,a1,a2
    800005b2:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005b6:	8952                	mv	s2,s4
    800005b8:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005bc:	6b85                	lui	s7,0x1
    800005be:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c2:	4605                	li	a2,1
    800005c4:	85ca                	mv	a1,s2
    800005c6:	8556                	mv	a0,s5
    800005c8:	00000097          	auipc	ra,0x0
    800005cc:	eda080e7          	jalr	-294(ra) # 800004a2 <walk>
    800005d0:	cd1d                	beqz	a0,8000060e <mappages+0x84>
    if(*pte & PTE_V)
    800005d2:	611c                	ld	a5,0(a0)
    800005d4:	8b85                	andi	a5,a5,1
    800005d6:	e785                	bnez	a5,800005fe <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005d8:	80b1                	srli	s1,s1,0xc
    800005da:	04aa                	slli	s1,s1,0xa
    800005dc:	0164e4b3          	or	s1,s1,s6
    800005e0:	0014e493          	ori	s1,s1,1
    800005e4:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e6:	05390063          	beq	s2,s3,80000626 <mappages+0x9c>
    a += PGSIZE;
    800005ea:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ec:	bfc9                	j	800005be <mappages+0x34>
    panic("mappages: size");
    800005ee:	00008517          	auipc	a0,0x8
    800005f2:	a6a50513          	addi	a0,a0,-1430 # 80008058 <etext+0x58>
    800005f6:	00005097          	auipc	ra,0x5
    800005fa:	65e080e7          	jalr	1630(ra) # 80005c54 <panic>
      panic("mappages: remap");
    800005fe:	00008517          	auipc	a0,0x8
    80000602:	a6a50513          	addi	a0,a0,-1430 # 80008068 <etext+0x68>
    80000606:	00005097          	auipc	ra,0x5
    8000060a:	64e080e7          	jalr	1614(ra) # 80005c54 <panic>
      return -1;
    8000060e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000610:	60a6                	ld	ra,72(sp)
    80000612:	6406                	ld	s0,64(sp)
    80000614:	74e2                	ld	s1,56(sp)
    80000616:	7942                	ld	s2,48(sp)
    80000618:	79a2                	ld	s3,40(sp)
    8000061a:	7a02                	ld	s4,32(sp)
    8000061c:	6ae2                	ld	s5,24(sp)
    8000061e:	6b42                	ld	s6,16(sp)
    80000620:	6ba2                	ld	s7,8(sp)
    80000622:	6161                	addi	sp,sp,80
    80000624:	8082                	ret
  return 0;
    80000626:	4501                	li	a0,0
    80000628:	b7e5                	j	80000610 <mappages+0x86>

000000008000062a <kvmmap>:
{
    8000062a:	1141                	addi	sp,sp,-16
    8000062c:	e406                	sd	ra,8(sp)
    8000062e:	e022                	sd	s0,0(sp)
    80000630:	0800                	addi	s0,sp,16
    80000632:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000634:	86b2                	mv	a3,a2
    80000636:	863e                	mv	a2,a5
    80000638:	00000097          	auipc	ra,0x0
    8000063c:	f52080e7          	jalr	-174(ra) # 8000058a <mappages>
    80000640:	e509                	bnez	a0,8000064a <kvmmap+0x20>
}
    80000642:	60a2                	ld	ra,8(sp)
    80000644:	6402                	ld	s0,0(sp)
    80000646:	0141                	addi	sp,sp,16
    80000648:	8082                	ret
    panic("kvmmap");
    8000064a:	00008517          	auipc	a0,0x8
    8000064e:	a2e50513          	addi	a0,a0,-1490 # 80008078 <etext+0x78>
    80000652:	00005097          	auipc	ra,0x5
    80000656:	602080e7          	jalr	1538(ra) # 80005c54 <panic>

000000008000065a <kvmmake>:
{
    8000065a:	1101                	addi	sp,sp,-32
    8000065c:	ec06                	sd	ra,24(sp)
    8000065e:	e822                	sd	s0,16(sp)
    80000660:	e426                	sd	s1,8(sp)
    80000662:	e04a                	sd	s2,0(sp)
    80000664:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	ab2080e7          	jalr	-1358(ra) # 80000118 <kalloc>
    8000066e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000670:	6605                	lui	a2,0x1
    80000672:	4581                	li	a1,0
    80000674:	00000097          	auipc	ra,0x0
    80000678:	b4e080e7          	jalr	-1202(ra) # 800001c2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000067c:	4719                	li	a4,6
    8000067e:	6685                	lui	a3,0x1
    80000680:	10000637          	lui	a2,0x10000
    80000684:	100005b7          	lui	a1,0x10000
    80000688:	8526                	mv	a0,s1
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	fa0080e7          	jalr	-96(ra) # 8000062a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000692:	4719                	li	a4,6
    80000694:	6685                	lui	a3,0x1
    80000696:	10001637          	lui	a2,0x10001
    8000069a:	100015b7          	lui	a1,0x10001
    8000069e:	8526                	mv	a0,s1
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	f8a080e7          	jalr	-118(ra) # 8000062a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006a8:	4719                	li	a4,6
    800006aa:	004006b7          	lui	a3,0x400
    800006ae:	0c000637          	lui	a2,0xc000
    800006b2:	0c0005b7          	lui	a1,0xc000
    800006b6:	8526                	mv	a0,s1
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	f72080e7          	jalr	-142(ra) # 8000062a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c0:	00008917          	auipc	s2,0x8
    800006c4:	94090913          	addi	s2,s2,-1728 # 80008000 <etext>
    800006c8:	4729                	li	a4,10
    800006ca:	80008697          	auipc	a3,0x80008
    800006ce:	93668693          	addi	a3,a3,-1738 # 8000 <_entry-0x7fff8000>
    800006d2:	4605                	li	a2,1
    800006d4:	067e                	slli	a2,a2,0x1f
    800006d6:	85b2                	mv	a1,a2
    800006d8:	8526                	mv	a0,s1
    800006da:	00000097          	auipc	ra,0x0
    800006de:	f50080e7          	jalr	-176(ra) # 8000062a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e2:	4719                	li	a4,6
    800006e4:	46c5                	li	a3,17
    800006e6:	06ee                	slli	a3,a3,0x1b
    800006e8:	412686b3          	sub	a3,a3,s2
    800006ec:	864a                	mv	a2,s2
    800006ee:	85ca                	mv	a1,s2
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f38080e7          	jalr	-200(ra) # 8000062a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006fa:	4729                	li	a4,10
    800006fc:	6685                	lui	a3,0x1
    800006fe:	00007617          	auipc	a2,0x7
    80000702:	90260613          	addi	a2,a2,-1790 # 80007000 <_trampoline>
    80000706:	040005b7          	lui	a1,0x4000
    8000070a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000070c:	05b2                	slli	a1,a1,0xc
    8000070e:	8526                	mv	a0,s1
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f1a080e7          	jalr	-230(ra) # 8000062a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000718:	8526                	mv	a0,s1
    8000071a:	00000097          	auipc	ra,0x0
    8000071e:	600080e7          	jalr	1536(ra) # 80000d1a <proc_mapstacks>
}
    80000722:	8526                	mv	a0,s1
    80000724:	60e2                	ld	ra,24(sp)
    80000726:	6442                	ld	s0,16(sp)
    80000728:	64a2                	ld	s1,8(sp)
    8000072a:	6902                	ld	s2,0(sp)
    8000072c:	6105                	addi	sp,sp,32
    8000072e:	8082                	ret

0000000080000730 <kvminit>:
{
    80000730:	1141                	addi	sp,sp,-16
    80000732:	e406                	sd	ra,8(sp)
    80000734:	e022                	sd	s0,0(sp)
    80000736:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000738:	00000097          	auipc	ra,0x0
    8000073c:	f22080e7          	jalr	-222(ra) # 8000065a <kvmmake>
    80000740:	00009797          	auipc	a5,0x9
    80000744:	8ca7b423          	sd	a0,-1848(a5) # 80009008 <kernel_pagetable>
}
    80000748:	60a2                	ld	ra,8(sp)
    8000074a:	6402                	ld	s0,0(sp)
    8000074c:	0141                	addi	sp,sp,16
    8000074e:	8082                	ret

0000000080000750 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000750:	715d                	addi	sp,sp,-80
    80000752:	e486                	sd	ra,72(sp)
    80000754:	e0a2                	sd	s0,64(sp)
    80000756:	fc26                	sd	s1,56(sp)
    80000758:	f84a                	sd	s2,48(sp)
    8000075a:	f44e                	sd	s3,40(sp)
    8000075c:	f052                	sd	s4,32(sp)
    8000075e:	ec56                	sd	s5,24(sp)
    80000760:	e85a                	sd	s6,16(sp)
    80000762:	e45e                	sd	s7,8(sp)
    80000764:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000766:	03459793          	slli	a5,a1,0x34
    8000076a:	e795                	bnez	a5,80000796 <uvmunmap+0x46>
    8000076c:	8a2a                	mv	s4,a0
    8000076e:	892e                	mv	s2,a1
    80000770:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000772:	0632                	slli	a2,a2,0xc
    80000774:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000778:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	6b05                	lui	s6,0x1
    8000077c:	0735e263          	bltu	a1,s3,800007e0 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000780:	60a6                	ld	ra,72(sp)
    80000782:	6406                	ld	s0,64(sp)
    80000784:	74e2                	ld	s1,56(sp)
    80000786:	7942                	ld	s2,48(sp)
    80000788:	79a2                	ld	s3,40(sp)
    8000078a:	7a02                	ld	s4,32(sp)
    8000078c:	6ae2                	ld	s5,24(sp)
    8000078e:	6b42                	ld	s6,16(sp)
    80000790:	6ba2                	ld	s7,8(sp)
    80000792:	6161                	addi	sp,sp,80
    80000794:	8082                	ret
    panic("uvmunmap: not aligned");
    80000796:	00008517          	auipc	a0,0x8
    8000079a:	8ea50513          	addi	a0,a0,-1814 # 80008080 <etext+0x80>
    8000079e:	00005097          	auipc	ra,0x5
    800007a2:	4b6080e7          	jalr	1206(ra) # 80005c54 <panic>
      panic("uvmunmap: walk");
    800007a6:	00008517          	auipc	a0,0x8
    800007aa:	8f250513          	addi	a0,a0,-1806 # 80008098 <etext+0x98>
    800007ae:	00005097          	auipc	ra,0x5
    800007b2:	4a6080e7          	jalr	1190(ra) # 80005c54 <panic>
      panic("uvmunmap: not mapped");
    800007b6:	00008517          	auipc	a0,0x8
    800007ba:	8f250513          	addi	a0,a0,-1806 # 800080a8 <etext+0xa8>
    800007be:	00005097          	auipc	ra,0x5
    800007c2:	496080e7          	jalr	1174(ra) # 80005c54 <panic>
      panic("uvmunmap: not a leaf");
    800007c6:	00008517          	auipc	a0,0x8
    800007ca:	8fa50513          	addi	a0,a0,-1798 # 800080c0 <etext+0xc0>
    800007ce:	00005097          	auipc	ra,0x5
    800007d2:	486080e7          	jalr	1158(ra) # 80005c54 <panic>
    *pte = 0;
    800007d6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007da:	995a                	add	s2,s2,s6
    800007dc:	fb3972e3          	bgeu	s2,s3,80000780 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007e0:	4601                	li	a2,0
    800007e2:	85ca                	mv	a1,s2
    800007e4:	8552                	mv	a0,s4
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	cbc080e7          	jalr	-836(ra) # 800004a2 <walk>
    800007ee:	84aa                	mv	s1,a0
    800007f0:	d95d                	beqz	a0,800007a6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007f2:	6108                	ld	a0,0(a0)
    800007f4:	00157793          	andi	a5,a0,1
    800007f8:	dfdd                	beqz	a5,800007b6 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007fa:	3ff57793          	andi	a5,a0,1023
    800007fe:	fd7784e3          	beq	a5,s7,800007c6 <uvmunmap+0x76>
    if(do_free){
    80000802:	fc0a8ae3          	beqz	s5,800007d6 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000806:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000808:	0532                	slli	a0,a0,0xc
    8000080a:	00000097          	auipc	ra,0x0
    8000080e:	812080e7          	jalr	-2030(ra) # 8000001c <kfree>
    80000812:	b7d1                	j	800007d6 <uvmunmap+0x86>

0000000080000814 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000814:	1101                	addi	sp,sp,-32
    80000816:	ec06                	sd	ra,24(sp)
    80000818:	e822                	sd	s0,16(sp)
    8000081a:	e426                	sd	s1,8(sp)
    8000081c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	8fa080e7          	jalr	-1798(ra) # 80000118 <kalloc>
    80000826:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000828:	c519                	beqz	a0,80000836 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	994080e7          	jalr	-1644(ra) # 800001c2 <memset>
  return pagetable;
}
    80000836:	8526                	mv	a0,s1
    80000838:	60e2                	ld	ra,24(sp)
    8000083a:	6442                	ld	s0,16(sp)
    8000083c:	64a2                	ld	s1,8(sp)
    8000083e:	6105                	addi	sp,sp,32
    80000840:	8082                	ret

0000000080000842 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000842:	7179                	addi	sp,sp,-48
    80000844:	f406                	sd	ra,40(sp)
    80000846:	f022                	sd	s0,32(sp)
    80000848:	ec26                	sd	s1,24(sp)
    8000084a:	e84a                	sd	s2,16(sp)
    8000084c:	e44e                	sd	s3,8(sp)
    8000084e:	e052                	sd	s4,0(sp)
    80000850:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000852:	6785                	lui	a5,0x1
    80000854:	04f67863          	bgeu	a2,a5,800008a4 <uvminit+0x62>
    80000858:	8a2a                	mv	s4,a0
    8000085a:	89ae                	mv	s3,a1
    8000085c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	8ba080e7          	jalr	-1862(ra) # 80000118 <kalloc>
    80000866:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000868:	6605                	lui	a2,0x1
    8000086a:	4581                	li	a1,0
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	956080e7          	jalr	-1706(ra) # 800001c2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000874:	4779                	li	a4,30
    80000876:	86ca                	mv	a3,s2
    80000878:	6605                	lui	a2,0x1
    8000087a:	4581                	li	a1,0
    8000087c:	8552                	mv	a0,s4
    8000087e:	00000097          	auipc	ra,0x0
    80000882:	d0c080e7          	jalr	-756(ra) # 8000058a <mappages>
  memmove(mem, src, sz);
    80000886:	8626                	mv	a2,s1
    80000888:	85ce                	mv	a1,s3
    8000088a:	854a                	mv	a0,s2
    8000088c:	00000097          	auipc	ra,0x0
    80000890:	992080e7          	jalr	-1646(ra) # 8000021e <memmove>
}
    80000894:	70a2                	ld	ra,40(sp)
    80000896:	7402                	ld	s0,32(sp)
    80000898:	64e2                	ld	s1,24(sp)
    8000089a:	6942                	ld	s2,16(sp)
    8000089c:	69a2                	ld	s3,8(sp)
    8000089e:	6a02                	ld	s4,0(sp)
    800008a0:	6145                	addi	sp,sp,48
    800008a2:	8082                	ret
    panic("inituvm: more than a page");
    800008a4:	00008517          	auipc	a0,0x8
    800008a8:	83450513          	addi	a0,a0,-1996 # 800080d8 <etext+0xd8>
    800008ac:	00005097          	auipc	ra,0x5
    800008b0:	3a8080e7          	jalr	936(ra) # 80005c54 <panic>

00000000800008b4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008b4:	1101                	addi	sp,sp,-32
    800008b6:	ec06                	sd	ra,24(sp)
    800008b8:	e822                	sd	s0,16(sp)
    800008ba:	e426                	sd	s1,8(sp)
    800008bc:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008be:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c0:	00b67d63          	bgeu	a2,a1,800008da <uvmdealloc+0x26>
    800008c4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008c6:	6785                	lui	a5,0x1
    800008c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ca:	00f60733          	add	a4,a2,a5
    800008ce:	767d                	lui	a2,0xfffff
    800008d0:	8f71                	and	a4,a4,a2
    800008d2:	97ae                	add	a5,a5,a1
    800008d4:	8ff1                	and	a5,a5,a2
    800008d6:	00f76863          	bltu	a4,a5,800008e6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008da:	8526                	mv	a0,s1
    800008dc:	60e2                	ld	ra,24(sp)
    800008de:	6442                	ld	s0,16(sp)
    800008e0:	64a2                	ld	s1,8(sp)
    800008e2:	6105                	addi	sp,sp,32
    800008e4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008e6:	8f99                	sub	a5,a5,a4
    800008e8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ea:	4685                	li	a3,1
    800008ec:	0007861b          	sext.w	a2,a5
    800008f0:	85ba                	mv	a1,a4
    800008f2:	00000097          	auipc	ra,0x0
    800008f6:	e5e080e7          	jalr	-418(ra) # 80000750 <uvmunmap>
    800008fa:	b7c5                	j	800008da <uvmdealloc+0x26>

00000000800008fc <uvmalloc>:
  if(newsz < oldsz)
    800008fc:	0ab66163          	bltu	a2,a1,8000099e <uvmalloc+0xa2>
{
    80000900:	7139                	addi	sp,sp,-64
    80000902:	fc06                	sd	ra,56(sp)
    80000904:	f822                	sd	s0,48(sp)
    80000906:	f426                	sd	s1,40(sp)
    80000908:	f04a                	sd	s2,32(sp)
    8000090a:	ec4e                	sd	s3,24(sp)
    8000090c:	e852                	sd	s4,16(sp)
    8000090e:	e456                	sd	s5,8(sp)
    80000910:	0080                	addi	s0,sp,64
    80000912:	8aaa                	mv	s5,a0
    80000914:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000916:	6985                	lui	s3,0x1
    80000918:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000091a:	95ce                	add	a1,a1,s3
    8000091c:	79fd                	lui	s3,0xfffff
    8000091e:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000922:	08c9f063          	bgeu	s3,a2,800009a2 <uvmalloc+0xa6>
    80000926:	894e                	mv	s2,s3
    mem = kalloc();
    80000928:	fffff097          	auipc	ra,0xfffff
    8000092c:	7f0080e7          	jalr	2032(ra) # 80000118 <kalloc>
    80000930:	84aa                	mv	s1,a0
    if(mem == 0){
    80000932:	c51d                	beqz	a0,80000960 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000934:	6605                	lui	a2,0x1
    80000936:	4581                	li	a1,0
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	88a080e7          	jalr	-1910(ra) # 800001c2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000940:	4779                	li	a4,30
    80000942:	86a6                	mv	a3,s1
    80000944:	6605                	lui	a2,0x1
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	c40080e7          	jalr	-960(ra) # 8000058a <mappages>
    80000952:	e905                	bnez	a0,80000982 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000954:	6785                	lui	a5,0x1
    80000956:	993e                	add	s2,s2,a5
    80000958:	fd4968e3          	bltu	s2,s4,80000928 <uvmalloc+0x2c>
  return newsz;
    8000095c:	8552                	mv	a0,s4
    8000095e:	a809                	j	80000970 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000960:	864e                	mv	a2,s3
    80000962:	85ca                	mv	a1,s2
    80000964:	8556                	mv	a0,s5
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	f4e080e7          	jalr	-178(ra) # 800008b4 <uvmdealloc>
      return 0;
    8000096e:	4501                	li	a0,0
}
    80000970:	70e2                	ld	ra,56(sp)
    80000972:	7442                	ld	s0,48(sp)
    80000974:	74a2                	ld	s1,40(sp)
    80000976:	7902                	ld	s2,32(sp)
    80000978:	69e2                	ld	s3,24(sp)
    8000097a:	6a42                	ld	s4,16(sp)
    8000097c:	6aa2                	ld	s5,8(sp)
    8000097e:	6121                	addi	sp,sp,64
    80000980:	8082                	ret
      kfree(mem);
    80000982:	8526                	mv	a0,s1
    80000984:	fffff097          	auipc	ra,0xfffff
    80000988:	698080e7          	jalr	1688(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000098c:	864e                	mv	a2,s3
    8000098e:	85ca                	mv	a1,s2
    80000990:	8556                	mv	a0,s5
    80000992:	00000097          	auipc	ra,0x0
    80000996:	f22080e7          	jalr	-222(ra) # 800008b4 <uvmdealloc>
      return 0;
    8000099a:	4501                	li	a0,0
    8000099c:	bfd1                	j	80000970 <uvmalloc+0x74>
    return oldsz;
    8000099e:	852e                	mv	a0,a1
}
    800009a0:	8082                	ret
  return newsz;
    800009a2:	8532                	mv	a0,a2
    800009a4:	b7f1                	j	80000970 <uvmalloc+0x74>

00000000800009a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a6:	7179                	addi	sp,sp,-48
    800009a8:	f406                	sd	ra,40(sp)
    800009aa:	f022                	sd	s0,32(sp)
    800009ac:	ec26                	sd	s1,24(sp)
    800009ae:	e84a                	sd	s2,16(sp)
    800009b0:	e44e                	sd	s3,8(sp)
    800009b2:	e052                	sd	s4,0(sp)
    800009b4:	1800                	addi	s0,sp,48
    800009b6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009b8:	84aa                	mv	s1,a0
    800009ba:	6905                	lui	s2,0x1
    800009bc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009be:	4985                	li	s3,1
    800009c0:	a821                	j	800009d8 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009c2:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009c4:	0532                	slli	a0,a0,0xc
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	fe0080e7          	jalr	-32(ra) # 800009a6 <freewalk>
      pagetable[i] = 0;
    800009ce:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009d2:	04a1                	addi	s1,s1,8
    800009d4:	03248163          	beq	s1,s2,800009f6 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009d8:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009da:	00f57793          	andi	a5,a0,15
    800009de:	ff3782e3          	beq	a5,s3,800009c2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009e2:	8905                	andi	a0,a0,1
    800009e4:	d57d                	beqz	a0,800009d2 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009e6:	00007517          	auipc	a0,0x7
    800009ea:	71250513          	addi	a0,a0,1810 # 800080f8 <etext+0xf8>
    800009ee:	00005097          	auipc	ra,0x5
    800009f2:	266080e7          	jalr	614(ra) # 80005c54 <panic>
    }
  }
  kfree((void*)pagetable);
    800009f6:	8552                	mv	a0,s4
    800009f8:	fffff097          	auipc	ra,0xfffff
    800009fc:	624080e7          	jalr	1572(ra) # 8000001c <kfree>
}
    80000a00:	70a2                	ld	ra,40(sp)
    80000a02:	7402                	ld	s0,32(sp)
    80000a04:	64e2                	ld	s1,24(sp)
    80000a06:	6942                	ld	s2,16(sp)
    80000a08:	69a2                	ld	s3,8(sp)
    80000a0a:	6a02                	ld	s4,0(sp)
    80000a0c:	6145                	addi	sp,sp,48
    80000a0e:	8082                	ret

0000000080000a10 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a10:	1101                	addi	sp,sp,-32
    80000a12:	ec06                	sd	ra,24(sp)
    80000a14:	e822                	sd	s0,16(sp)
    80000a16:	e426                	sd	s1,8(sp)
    80000a18:	1000                	addi	s0,sp,32
    80000a1a:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a1c:	e999                	bnez	a1,80000a32 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a1e:	8526                	mv	a0,s1
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	f86080e7          	jalr	-122(ra) # 800009a6 <freewalk>
}
    80000a28:	60e2                	ld	ra,24(sp)
    80000a2a:	6442                	ld	s0,16(sp)
    80000a2c:	64a2                	ld	s1,8(sp)
    80000a2e:	6105                	addi	sp,sp,32
    80000a30:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a32:	6605                	lui	a2,0x1
    80000a34:	167d                	addi	a2,a2,-1 # fff <_entry-0x7ffff001>
    80000a36:	962e                	add	a2,a2,a1
    80000a38:	4685                	li	a3,1
    80000a3a:	8231                	srli	a2,a2,0xc
    80000a3c:	4581                	li	a1,0
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	d12080e7          	jalr	-750(ra) # 80000750 <uvmunmap>
    80000a46:	bfe1                	j	80000a1e <uvmfree+0xe>

0000000080000a48 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a48:	c679                	beqz	a2,80000b16 <uvmcopy+0xce>
{
    80000a4a:	715d                	addi	sp,sp,-80
    80000a4c:	e486                	sd	ra,72(sp)
    80000a4e:	e0a2                	sd	s0,64(sp)
    80000a50:	fc26                	sd	s1,56(sp)
    80000a52:	f84a                	sd	s2,48(sp)
    80000a54:	f44e                	sd	s3,40(sp)
    80000a56:	f052                	sd	s4,32(sp)
    80000a58:	ec56                	sd	s5,24(sp)
    80000a5a:	e85a                	sd	s6,16(sp)
    80000a5c:	e45e                	sd	s7,8(sp)
    80000a5e:	0880                	addi	s0,sp,80
    80000a60:	8b2a                	mv	s6,a0
    80000a62:	8aae                	mv	s5,a1
    80000a64:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a66:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a68:	4601                	li	a2,0
    80000a6a:	85ce                	mv	a1,s3
    80000a6c:	855a                	mv	a0,s6
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	a34080e7          	jalr	-1484(ra) # 800004a2 <walk>
    80000a76:	c531                	beqz	a0,80000ac2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a78:	6118                	ld	a4,0(a0)
    80000a7a:	00177793          	andi	a5,a4,1
    80000a7e:	cbb1                	beqz	a5,80000ad2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a80:	00a75593          	srli	a1,a4,0xa
    80000a84:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a88:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a8c:	fffff097          	auipc	ra,0xfffff
    80000a90:	68c080e7          	jalr	1676(ra) # 80000118 <kalloc>
    80000a94:	892a                	mv	s2,a0
    80000a96:	c939                	beqz	a0,80000aec <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a98:	6605                	lui	a2,0x1
    80000a9a:	85de                	mv	a1,s7
    80000a9c:	fffff097          	auipc	ra,0xfffff
    80000aa0:	782080e7          	jalr	1922(ra) # 8000021e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aa4:	8726                	mv	a4,s1
    80000aa6:	86ca                	mv	a3,s2
    80000aa8:	6605                	lui	a2,0x1
    80000aaa:	85ce                	mv	a1,s3
    80000aac:	8556                	mv	a0,s5
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	adc080e7          	jalr	-1316(ra) # 8000058a <mappages>
    80000ab6:	e515                	bnez	a0,80000ae2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ab8:	6785                	lui	a5,0x1
    80000aba:	99be                	add	s3,s3,a5
    80000abc:	fb49e6e3          	bltu	s3,s4,80000a68 <uvmcopy+0x20>
    80000ac0:	a081                	j	80000b00 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ac2:	00007517          	auipc	a0,0x7
    80000ac6:	64650513          	addi	a0,a0,1606 # 80008108 <etext+0x108>
    80000aca:	00005097          	auipc	ra,0x5
    80000ace:	18a080e7          	jalr	394(ra) # 80005c54 <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	65650513          	addi	a0,a0,1622 # 80008128 <etext+0x128>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	17a080e7          	jalr	378(ra) # 80005c54 <panic>
      kfree(mem);
    80000ae2:	854a                	mv	a0,s2
    80000ae4:	fffff097          	auipc	ra,0xfffff
    80000ae8:	538080e7          	jalr	1336(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aec:	4685                	li	a3,1
    80000aee:	00c9d613          	srli	a2,s3,0xc
    80000af2:	4581                	li	a1,0
    80000af4:	8556                	mv	a0,s5
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	c5a080e7          	jalr	-934(ra) # 80000750 <uvmunmap>
  return -1;
    80000afe:	557d                	li	a0,-1
}
    80000b00:	60a6                	ld	ra,72(sp)
    80000b02:	6406                	ld	s0,64(sp)
    80000b04:	74e2                	ld	s1,56(sp)
    80000b06:	7942                	ld	s2,48(sp)
    80000b08:	79a2                	ld	s3,40(sp)
    80000b0a:	7a02                	ld	s4,32(sp)
    80000b0c:	6ae2                	ld	s5,24(sp)
    80000b0e:	6b42                	ld	s6,16(sp)
    80000b10:	6ba2                	ld	s7,8(sp)
    80000b12:	6161                	addi	sp,sp,80
    80000b14:	8082                	ret
  return 0;
    80000b16:	4501                	li	a0,0
}
    80000b18:	8082                	ret

0000000080000b1a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b1a:	1141                	addi	sp,sp,-16
    80000b1c:	e406                	sd	ra,8(sp)
    80000b1e:	e022                	sd	s0,0(sp)
    80000b20:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b22:	4601                	li	a2,0
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	97e080e7          	jalr	-1666(ra) # 800004a2 <walk>
  if(pte == 0)
    80000b2c:	c901                	beqz	a0,80000b3c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b2e:	611c                	ld	a5,0(a0)
    80000b30:	9bbd                	andi	a5,a5,-17
    80000b32:	e11c                	sd	a5,0(a0)
}
    80000b34:	60a2                	ld	ra,8(sp)
    80000b36:	6402                	ld	s0,0(sp)
    80000b38:	0141                	addi	sp,sp,16
    80000b3a:	8082                	ret
    panic("uvmclear");
    80000b3c:	00007517          	auipc	a0,0x7
    80000b40:	60c50513          	addi	a0,a0,1548 # 80008148 <etext+0x148>
    80000b44:	00005097          	auipc	ra,0x5
    80000b48:	110080e7          	jalr	272(ra) # 80005c54 <panic>

0000000080000b4c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b4c:	c6bd                	beqz	a3,80000bba <copyout+0x6e>
{
    80000b4e:	715d                	addi	sp,sp,-80
    80000b50:	e486                	sd	ra,72(sp)
    80000b52:	e0a2                	sd	s0,64(sp)
    80000b54:	fc26                	sd	s1,56(sp)
    80000b56:	f84a                	sd	s2,48(sp)
    80000b58:	f44e                	sd	s3,40(sp)
    80000b5a:	f052                	sd	s4,32(sp)
    80000b5c:	ec56                	sd	s5,24(sp)
    80000b5e:	e85a                	sd	s6,16(sp)
    80000b60:	e45e                	sd	s7,8(sp)
    80000b62:	e062                	sd	s8,0(sp)
    80000b64:	0880                	addi	s0,sp,80
    80000b66:	8b2a                	mv	s6,a0
    80000b68:	8c2e                	mv	s8,a1
    80000b6a:	8a32                	mv	s4,a2
    80000b6c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b6e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b70:	6a85                	lui	s5,0x1
    80000b72:	a015                	j	80000b96 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b74:	9562                	add	a0,a0,s8
    80000b76:	0004861b          	sext.w	a2,s1
    80000b7a:	85d2                	mv	a1,s4
    80000b7c:	41250533          	sub	a0,a0,s2
    80000b80:	fffff097          	auipc	ra,0xfffff
    80000b84:	69e080e7          	jalr	1694(ra) # 8000021e <memmove>

    len -= n;
    80000b88:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b8c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b8e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b92:	02098263          	beqz	s3,80000bb6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b96:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b9a:	85ca                	mv	a1,s2
    80000b9c:	855a                	mv	a0,s6
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	9aa080e7          	jalr	-1622(ra) # 80000548 <walkaddr>
    if(pa0 == 0)
    80000ba6:	cd01                	beqz	a0,80000bbe <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000ba8:	418904b3          	sub	s1,s2,s8
    80000bac:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bae:	fc99f3e3          	bgeu	s3,s1,80000b74 <copyout+0x28>
    80000bb2:	84ce                	mv	s1,s3
    80000bb4:	b7c1                	j	80000b74 <copyout+0x28>
  }
  return 0;
    80000bb6:	4501                	li	a0,0
    80000bb8:	a021                	j	80000bc0 <copyout+0x74>
    80000bba:	4501                	li	a0,0
}
    80000bbc:	8082                	ret
      return -1;
    80000bbe:	557d                	li	a0,-1
}
    80000bc0:	60a6                	ld	ra,72(sp)
    80000bc2:	6406                	ld	s0,64(sp)
    80000bc4:	74e2                	ld	s1,56(sp)
    80000bc6:	7942                	ld	s2,48(sp)
    80000bc8:	79a2                	ld	s3,40(sp)
    80000bca:	7a02                	ld	s4,32(sp)
    80000bcc:	6ae2                	ld	s5,24(sp)
    80000bce:	6b42                	ld	s6,16(sp)
    80000bd0:	6ba2                	ld	s7,8(sp)
    80000bd2:	6c02                	ld	s8,0(sp)
    80000bd4:	6161                	addi	sp,sp,80
    80000bd6:	8082                	ret

0000000080000bd8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bd8:	caa5                	beqz	a3,80000c48 <copyin+0x70>
{
    80000bda:	715d                	addi	sp,sp,-80
    80000bdc:	e486                	sd	ra,72(sp)
    80000bde:	e0a2                	sd	s0,64(sp)
    80000be0:	fc26                	sd	s1,56(sp)
    80000be2:	f84a                	sd	s2,48(sp)
    80000be4:	f44e                	sd	s3,40(sp)
    80000be6:	f052                	sd	s4,32(sp)
    80000be8:	ec56                	sd	s5,24(sp)
    80000bea:	e85a                	sd	s6,16(sp)
    80000bec:	e45e                	sd	s7,8(sp)
    80000bee:	e062                	sd	s8,0(sp)
    80000bf0:	0880                	addi	s0,sp,80
    80000bf2:	8b2a                	mv	s6,a0
    80000bf4:	8a2e                	mv	s4,a1
    80000bf6:	8c32                	mv	s8,a2
    80000bf8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bfa:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bfc:	6a85                	lui	s5,0x1
    80000bfe:	a01d                	j	80000c24 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c00:	018505b3          	add	a1,a0,s8
    80000c04:	0004861b          	sext.w	a2,s1
    80000c08:	412585b3          	sub	a1,a1,s2
    80000c0c:	8552                	mv	a0,s4
    80000c0e:	fffff097          	auipc	ra,0xfffff
    80000c12:	610080e7          	jalr	1552(ra) # 8000021e <memmove>

    len -= n;
    80000c16:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c1a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c1c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c20:	02098263          	beqz	s3,80000c44 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c24:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c28:	85ca                	mv	a1,s2
    80000c2a:	855a                	mv	a0,s6
    80000c2c:	00000097          	auipc	ra,0x0
    80000c30:	91c080e7          	jalr	-1764(ra) # 80000548 <walkaddr>
    if(pa0 == 0)
    80000c34:	cd01                	beqz	a0,80000c4c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c36:	418904b3          	sub	s1,s2,s8
    80000c3a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c3c:	fc99f2e3          	bgeu	s3,s1,80000c00 <copyin+0x28>
    80000c40:	84ce                	mv	s1,s3
    80000c42:	bf7d                	j	80000c00 <copyin+0x28>
  }
  return 0;
    80000c44:	4501                	li	a0,0
    80000c46:	a021                	j	80000c4e <copyin+0x76>
    80000c48:	4501                	li	a0,0
}
    80000c4a:	8082                	ret
      return -1;
    80000c4c:	557d                	li	a0,-1
}
    80000c4e:	60a6                	ld	ra,72(sp)
    80000c50:	6406                	ld	s0,64(sp)
    80000c52:	74e2                	ld	s1,56(sp)
    80000c54:	7942                	ld	s2,48(sp)
    80000c56:	79a2                	ld	s3,40(sp)
    80000c58:	7a02                	ld	s4,32(sp)
    80000c5a:	6ae2                	ld	s5,24(sp)
    80000c5c:	6b42                	ld	s6,16(sp)
    80000c5e:	6ba2                	ld	s7,8(sp)
    80000c60:	6c02                	ld	s8,0(sp)
    80000c62:	6161                	addi	sp,sp,80
    80000c64:	8082                	ret

0000000080000c66 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c66:	c6c5                	beqz	a3,80000d0e <copyinstr+0xa8>
{
    80000c68:	715d                	addi	sp,sp,-80
    80000c6a:	e486                	sd	ra,72(sp)
    80000c6c:	e0a2                	sd	s0,64(sp)
    80000c6e:	fc26                	sd	s1,56(sp)
    80000c70:	f84a                	sd	s2,48(sp)
    80000c72:	f44e                	sd	s3,40(sp)
    80000c74:	f052                	sd	s4,32(sp)
    80000c76:	ec56                	sd	s5,24(sp)
    80000c78:	e85a                	sd	s6,16(sp)
    80000c7a:	e45e                	sd	s7,8(sp)
    80000c7c:	0880                	addi	s0,sp,80
    80000c7e:	8a2a                	mv	s4,a0
    80000c80:	8b2e                	mv	s6,a1
    80000c82:	8bb2                	mv	s7,a2
    80000c84:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c86:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c88:	6985                	lui	s3,0x1
    80000c8a:	a035                	j	80000cb6 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c8c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c90:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c92:	0017b793          	seqz	a5,a5
    80000c96:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c9a:	60a6                	ld	ra,72(sp)
    80000c9c:	6406                	ld	s0,64(sp)
    80000c9e:	74e2                	ld	s1,56(sp)
    80000ca0:	7942                	ld	s2,48(sp)
    80000ca2:	79a2                	ld	s3,40(sp)
    80000ca4:	7a02                	ld	s4,32(sp)
    80000ca6:	6ae2                	ld	s5,24(sp)
    80000ca8:	6b42                	ld	s6,16(sp)
    80000caa:	6ba2                	ld	s7,8(sp)
    80000cac:	6161                	addi	sp,sp,80
    80000cae:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cb4:	c8a9                	beqz	s1,80000d06 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cb6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cba:	85ca                	mv	a1,s2
    80000cbc:	8552                	mv	a0,s4
    80000cbe:	00000097          	auipc	ra,0x0
    80000cc2:	88a080e7          	jalr	-1910(ra) # 80000548 <walkaddr>
    if(pa0 == 0)
    80000cc6:	c131                	beqz	a0,80000d0a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cc8:	41790833          	sub	a6,s2,s7
    80000ccc:	984e                	add	a6,a6,s3
    if(n > max)
    80000cce:	0104f363          	bgeu	s1,a6,80000cd4 <copyinstr+0x6e>
    80000cd2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cd4:	955e                	add	a0,a0,s7
    80000cd6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cda:	fc080be3          	beqz	a6,80000cb0 <copyinstr+0x4a>
    80000cde:	985a                	add	a6,a6,s6
    80000ce0:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce2:	41650633          	sub	a2,a0,s6
    80000ce6:	14fd                	addi	s1,s1,-1
    80000ce8:	9b26                	add	s6,s6,s1
    80000cea:	00f60733          	add	a4,a2,a5
    80000cee:	00074703          	lbu	a4,0(a4)
    80000cf2:	df49                	beqz	a4,80000c8c <copyinstr+0x26>
        *dst = *p;
    80000cf4:	00e78023          	sb	a4,0(a5)
      --max;
    80000cf8:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cfc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cfe:	ff0796e3          	bne	a5,a6,80000cea <copyinstr+0x84>
      dst++;
    80000d02:	8b42                	mv	s6,a6
    80000d04:	b775                	j	80000cb0 <copyinstr+0x4a>
    80000d06:	4781                	li	a5,0
    80000d08:	b769                	j	80000c92 <copyinstr+0x2c>
      return -1;
    80000d0a:	557d                	li	a0,-1
    80000d0c:	b779                	j	80000c9a <copyinstr+0x34>
  int got_null = 0;
    80000d0e:	4781                	li	a5,0
  if(got_null){
    80000d10:	0017b793          	seqz	a5,a5
    80000d14:	40f00533          	neg	a0,a5
}
    80000d18:	8082                	ret

0000000080000d1a <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d1a:	7139                	addi	sp,sp,-64
    80000d1c:	fc06                	sd	ra,56(sp)
    80000d1e:	f822                	sd	s0,48(sp)
    80000d20:	f426                	sd	s1,40(sp)
    80000d22:	f04a                	sd	s2,32(sp)
    80000d24:	ec4e                	sd	s3,24(sp)
    80000d26:	e852                	sd	s4,16(sp)
    80000d28:	e456                	sd	s5,8(sp)
    80000d2a:	e05a                	sd	s6,0(sp)
    80000d2c:	0080                	addi	s0,sp,64
    80000d2e:	89aa                	mv	s3,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80000d30:	00008497          	auipc	s1,0x8
    80000d34:	75048493          	addi	s1,s1,1872 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d38:	8b26                	mv	s6,s1
    80000d3a:	00007a97          	auipc	s5,0x7
    80000d3e:	2c6a8a93          	addi	s5,s5,710 # 80008000 <etext>
    80000d42:	04000937          	lui	s2,0x4000
    80000d46:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d48:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4a:	0000ea17          	auipc	s4,0xe
    80000d4e:	336a0a13          	addi	s4,s4,822 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d52:	fffff097          	auipc	ra,0xfffff
    80000d56:	3c6080e7          	jalr	966(ra) # 80000118 <kalloc>
    80000d5a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d5c:	c131                	beqz	a0,80000da0 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d5e:	416485b3          	sub	a1,s1,s6
    80000d62:	8591                	srai	a1,a1,0x4
    80000d64:	000ab783          	ld	a5,0(s5)
    80000d68:	02f585b3          	mul	a1,a1,a5
    80000d6c:	2585                	addiw	a1,a1,1
    80000d6e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d72:	4719                	li	a4,6
    80000d74:	6685                	lui	a3,0x1
    80000d76:	40b905b3          	sub	a1,s2,a1
    80000d7a:	854e                	mv	a0,s3
    80000d7c:	00000097          	auipc	ra,0x0
    80000d80:	8ae080e7          	jalr	-1874(ra) # 8000062a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d84:	17048493          	addi	s1,s1,368
    80000d88:	fd4495e3          	bne	s1,s4,80000d52 <proc_mapstacks+0x38>
  }
}
    80000d8c:	70e2                	ld	ra,56(sp)
    80000d8e:	7442                	ld	s0,48(sp)
    80000d90:	74a2                	ld	s1,40(sp)
    80000d92:	7902                	ld	s2,32(sp)
    80000d94:	69e2                	ld	s3,24(sp)
    80000d96:	6a42                	ld	s4,16(sp)
    80000d98:	6aa2                	ld	s5,8(sp)
    80000d9a:	6b02                	ld	s6,0(sp)
    80000d9c:	6121                	addi	sp,sp,64
    80000d9e:	8082                	ret
      panic("kalloc");
    80000da0:	00007517          	auipc	a0,0x7
    80000da4:	3b850513          	addi	a0,a0,952 # 80008158 <etext+0x158>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	eac080e7          	jalr	-340(ra) # 80005c54 <panic>

0000000080000db0 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db0:	7139                	addi	sp,sp,-64
    80000db2:	fc06                	sd	ra,56(sp)
    80000db4:	f822                	sd	s0,48(sp)
    80000db6:	f426                	sd	s1,40(sp)
    80000db8:	f04a                	sd	s2,32(sp)
    80000dba:	ec4e                	sd	s3,24(sp)
    80000dbc:	e852                	sd	s4,16(sp)
    80000dbe:	e456                	sd	s5,8(sp)
    80000dc0:	e05a                	sd	s6,0(sp)
    80000dc2:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000dc4:	00007597          	auipc	a1,0x7
    80000dc8:	39c58593          	addi	a1,a1,924 # 80008160 <etext+0x160>
    80000dcc:	00008517          	auipc	a0,0x8
    80000dd0:	28450513          	addi	a0,a0,644 # 80009050 <pid_lock>
    80000dd4:	00005097          	auipc	ra,0x5
    80000dd8:	32c080e7          	jalr	812(ra) # 80006100 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ddc:	00007597          	auipc	a1,0x7
    80000de0:	38c58593          	addi	a1,a1,908 # 80008168 <etext+0x168>
    80000de4:	00008517          	auipc	a0,0x8
    80000de8:	28450513          	addi	a0,a0,644 # 80009068 <wait_lock>
    80000dec:	00005097          	auipc	ra,0x5
    80000df0:	314080e7          	jalr	788(ra) # 80006100 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df4:	00008497          	auipc	s1,0x8
    80000df8:	68c48493          	addi	s1,s1,1676 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dfc:	00007b17          	auipc	s6,0x7
    80000e00:	37cb0b13          	addi	s6,s6,892 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e04:	8aa6                	mv	s5,s1
    80000e06:	00007a17          	auipc	s4,0x7
    80000e0a:	1faa0a13          	addi	s4,s4,506 # 80008000 <etext>
    80000e0e:	04000937          	lui	s2,0x4000
    80000e12:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e14:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e16:	0000e997          	auipc	s3,0xe
    80000e1a:	26a98993          	addi	s3,s3,618 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000e1e:	85da                	mv	a1,s6
    80000e20:	8526                	mv	a0,s1
    80000e22:	00005097          	auipc	ra,0x5
    80000e26:	2de080e7          	jalr	734(ra) # 80006100 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e2a:	415487b3          	sub	a5,s1,s5
    80000e2e:	8791                	srai	a5,a5,0x4
    80000e30:	000a3703          	ld	a4,0(s4)
    80000e34:	02e787b3          	mul	a5,a5,a4
    80000e38:	2785                	addiw	a5,a5,1
    80000e3a:	00d7979b          	slliw	a5,a5,0xd
    80000e3e:	40f907b3          	sub	a5,s2,a5
    80000e42:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e44:	17048493          	addi	s1,s1,368
    80000e48:	fd349be3          	bne	s1,s3,80000e1e <procinit+0x6e>
  }
}
    80000e4c:	70e2                	ld	ra,56(sp)
    80000e4e:	7442                	ld	s0,48(sp)
    80000e50:	74a2                	ld	s1,40(sp)
    80000e52:	7902                	ld	s2,32(sp)
    80000e54:	69e2                	ld	s3,24(sp)
    80000e56:	6a42                	ld	s4,16(sp)
    80000e58:	6aa2                	ld	s5,8(sp)
    80000e5a:	6b02                	ld	s6,0(sp)
    80000e5c:	6121                	addi	sp,sp,64
    80000e5e:	8082                	ret

0000000080000e60 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e66:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e68:	2501                	sext.w	a0,a0
    80000e6a:	6422                	ld	s0,8(sp)
    80000e6c:	0141                	addi	sp,sp,16
    80000e6e:	8082                	ret

0000000080000e70 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e70:	1141                	addi	sp,sp,-16
    80000e72:	e422                	sd	s0,8(sp)
    80000e74:	0800                	addi	s0,sp,16
    80000e76:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e78:	2781                	sext.w	a5,a5
    80000e7a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e7c:	00008517          	auipc	a0,0x8
    80000e80:	20450513          	addi	a0,a0,516 # 80009080 <cpus>
    80000e84:	953e                	add	a0,a0,a5
    80000e86:	6422                	ld	s0,8(sp)
    80000e88:	0141                	addi	sp,sp,16
    80000e8a:	8082                	ret

0000000080000e8c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e8c:	1101                	addi	sp,sp,-32
    80000e8e:	ec06                	sd	ra,24(sp)
    80000e90:	e822                	sd	s0,16(sp)
    80000e92:	e426                	sd	s1,8(sp)
    80000e94:	1000                	addi	s0,sp,32
  push_off();
    80000e96:	00005097          	auipc	ra,0x5
    80000e9a:	2ae080e7          	jalr	686(ra) # 80006144 <push_off>
    80000e9e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea0:	2781                	sext.w	a5,a5
    80000ea2:	079e                	slli	a5,a5,0x7
    80000ea4:	00008717          	auipc	a4,0x8
    80000ea8:	1ac70713          	addi	a4,a4,428 # 80009050 <pid_lock>
    80000eac:	97ba                	add	a5,a5,a4
    80000eae:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb0:	00005097          	auipc	ra,0x5
    80000eb4:	334080e7          	jalr	820(ra) # 800061e4 <pop_off>
  return p;
}
    80000eb8:	8526                	mv	a0,s1
    80000eba:	60e2                	ld	ra,24(sp)
    80000ebc:	6442                	ld	s0,16(sp)
    80000ebe:	64a2                	ld	s1,8(sp)
    80000ec0:	6105                	addi	sp,sp,32
    80000ec2:	8082                	ret

0000000080000ec4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ec4:	1141                	addi	sp,sp,-16
    80000ec6:	e406                	sd	ra,8(sp)
    80000ec8:	e022                	sd	s0,0(sp)
    80000eca:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ecc:	00000097          	auipc	ra,0x0
    80000ed0:	fc0080e7          	jalr	-64(ra) # 80000e8c <myproc>
    80000ed4:	00005097          	auipc	ra,0x5
    80000ed8:	370080e7          	jalr	880(ra) # 80006244 <release>

  if (first) {
    80000edc:	00008797          	auipc	a5,0x8
    80000ee0:	a047a783          	lw	a5,-1532(a5) # 800088e0 <first.1>
    80000ee4:	eb89                	bnez	a5,80000ef6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ee6:	00001097          	auipc	ra,0x1
    80000eea:	c7a080e7          	jalr	-902(ra) # 80001b60 <usertrapret>
}
    80000eee:	60a2                	ld	ra,8(sp)
    80000ef0:	6402                	ld	s0,0(sp)
    80000ef2:	0141                	addi	sp,sp,16
    80000ef4:	8082                	ret
    first = 0;
    80000ef6:	00008797          	auipc	a5,0x8
    80000efa:	9e07a523          	sw	zero,-1558(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80000efe:	4505                	li	a0,1
    80000f00:	00002097          	auipc	ra,0x2
    80000f04:	a6c080e7          	jalr	-1428(ra) # 8000296c <fsinit>
    80000f08:	bff9                	j	80000ee6 <forkret+0x22>

0000000080000f0a <allocpid>:
allocpid() {
    80000f0a:	1101                	addi	sp,sp,-32
    80000f0c:	ec06                	sd	ra,24(sp)
    80000f0e:	e822                	sd	s0,16(sp)
    80000f10:	e426                	sd	s1,8(sp)
    80000f12:	e04a                	sd	s2,0(sp)
    80000f14:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f16:	00008917          	auipc	s2,0x8
    80000f1a:	13a90913          	addi	s2,s2,314 # 80009050 <pid_lock>
    80000f1e:	854a                	mv	a0,s2
    80000f20:	00005097          	auipc	ra,0x5
    80000f24:	270080e7          	jalr	624(ra) # 80006190 <acquire>
  pid = nextpid;
    80000f28:	00008797          	auipc	a5,0x8
    80000f2c:	9bc78793          	addi	a5,a5,-1604 # 800088e4 <nextpid>
    80000f30:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f32:	0014871b          	addiw	a4,s1,1
    80000f36:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f38:	854a                	mv	a0,s2
    80000f3a:	00005097          	auipc	ra,0x5
    80000f3e:	30a080e7          	jalr	778(ra) # 80006244 <release>
}
    80000f42:	8526                	mv	a0,s1
    80000f44:	60e2                	ld	ra,24(sp)
    80000f46:	6442                	ld	s0,16(sp)
    80000f48:	64a2                	ld	s1,8(sp)
    80000f4a:	6902                	ld	s2,0(sp)
    80000f4c:	6105                	addi	sp,sp,32
    80000f4e:	8082                	ret

0000000080000f50 <proc_pagetable>:
{
    80000f50:	1101                	addi	sp,sp,-32
    80000f52:	ec06                	sd	ra,24(sp)
    80000f54:	e822                	sd	s0,16(sp)
    80000f56:	e426                	sd	s1,8(sp)
    80000f58:	e04a                	sd	s2,0(sp)
    80000f5a:	1000                	addi	s0,sp,32
    80000f5c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f5e:	00000097          	auipc	ra,0x0
    80000f62:	8b6080e7          	jalr	-1866(ra) # 80000814 <uvmcreate>
    80000f66:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f68:	c121                	beqz	a0,80000fa8 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f6a:	4729                	li	a4,10
    80000f6c:	00006697          	auipc	a3,0x6
    80000f70:	09468693          	addi	a3,a3,148 # 80007000 <_trampoline>
    80000f74:	6605                	lui	a2,0x1
    80000f76:	040005b7          	lui	a1,0x4000
    80000f7a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f7c:	05b2                	slli	a1,a1,0xc
    80000f7e:	fffff097          	auipc	ra,0xfffff
    80000f82:	60c080e7          	jalr	1548(ra) # 8000058a <mappages>
    80000f86:	02054863          	bltz	a0,80000fb6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f8a:	4719                	li	a4,6
    80000f8c:	05893683          	ld	a3,88(s2)
    80000f90:	6605                	lui	a2,0x1
    80000f92:	020005b7          	lui	a1,0x2000
    80000f96:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f98:	05b6                	slli	a1,a1,0xd
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	fffff097          	auipc	ra,0xfffff
    80000fa0:	5ee080e7          	jalr	1518(ra) # 8000058a <mappages>
    80000fa4:	02054163          	bltz	a0,80000fc6 <proc_pagetable+0x76>
}
    80000fa8:	8526                	mv	a0,s1
    80000faa:	60e2                	ld	ra,24(sp)
    80000fac:	6442                	ld	s0,16(sp)
    80000fae:	64a2                	ld	s1,8(sp)
    80000fb0:	6902                	ld	s2,0(sp)
    80000fb2:	6105                	addi	sp,sp,32
    80000fb4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fb6:	4581                	li	a1,0
    80000fb8:	8526                	mv	a0,s1
    80000fba:	00000097          	auipc	ra,0x0
    80000fbe:	a56080e7          	jalr	-1450(ra) # 80000a10 <uvmfree>
    return 0;
    80000fc2:	4481                	li	s1,0
    80000fc4:	b7d5                	j	80000fa8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc6:	4681                	li	a3,0
    80000fc8:	4605                	li	a2,1
    80000fca:	040005b7          	lui	a1,0x4000
    80000fce:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fd0:	05b2                	slli	a1,a1,0xc
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	77c080e7          	jalr	1916(ra) # 80000750 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fdc:	4581                	li	a1,0
    80000fde:	8526                	mv	a0,s1
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	a30080e7          	jalr	-1488(ra) # 80000a10 <uvmfree>
    return 0;
    80000fe8:	4481                	li	s1,0
    80000fea:	bf7d                	j	80000fa8 <proc_pagetable+0x58>

0000000080000fec <proc_freepagetable>:
{
    80000fec:	1101                	addi	sp,sp,-32
    80000fee:	ec06                	sd	ra,24(sp)
    80000ff0:	e822                	sd	s0,16(sp)
    80000ff2:	e426                	sd	s1,8(sp)
    80000ff4:	e04a                	sd	s2,0(sp)
    80000ff6:	1000                	addi	s0,sp,32
    80000ff8:	84aa                	mv	s1,a0
    80000ffa:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ffc:	4681                	li	a3,0
    80000ffe:	4605                	li	a2,1
    80001000:	040005b7          	lui	a1,0x4000
    80001004:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001006:	05b2                	slli	a1,a1,0xc
    80001008:	fffff097          	auipc	ra,0xfffff
    8000100c:	748080e7          	jalr	1864(ra) # 80000750 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001010:	4681                	li	a3,0
    80001012:	4605                	li	a2,1
    80001014:	020005b7          	lui	a1,0x2000
    80001018:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000101a:	05b6                	slli	a1,a1,0xd
    8000101c:	8526                	mv	a0,s1
    8000101e:	fffff097          	auipc	ra,0xfffff
    80001022:	732080e7          	jalr	1842(ra) # 80000750 <uvmunmap>
  uvmfree(pagetable, sz);
    80001026:	85ca                	mv	a1,s2
    80001028:	8526                	mv	a0,s1
    8000102a:	00000097          	auipc	ra,0x0
    8000102e:	9e6080e7          	jalr	-1562(ra) # 80000a10 <uvmfree>
}
    80001032:	60e2                	ld	ra,24(sp)
    80001034:	6442                	ld	s0,16(sp)
    80001036:	64a2                	ld	s1,8(sp)
    80001038:	6902                	ld	s2,0(sp)
    8000103a:	6105                	addi	sp,sp,32
    8000103c:	8082                	ret

000000008000103e <freeproc>:
{
    8000103e:	1101                	addi	sp,sp,-32
    80001040:	ec06                	sd	ra,24(sp)
    80001042:	e822                	sd	s0,16(sp)
    80001044:	e426                	sd	s1,8(sp)
    80001046:	1000                	addi	s0,sp,32
    80001048:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000104a:	6d28                	ld	a0,88(a0)
    8000104c:	c509                	beqz	a0,80001056 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	fce080e7          	jalr	-50(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001056:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000105a:	68a8                	ld	a0,80(s1)
    8000105c:	c511                	beqz	a0,80001068 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000105e:	64ac                	ld	a1,72(s1)
    80001060:	00000097          	auipc	ra,0x0
    80001064:	f8c080e7          	jalr	-116(ra) # 80000fec <proc_freepagetable>
  p->pagetable = 0;
    80001068:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000106c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001070:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001074:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001078:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000107c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001080:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001084:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001088:	0004ac23          	sw	zero,24(s1)
}
    8000108c:	60e2                	ld	ra,24(sp)
    8000108e:	6442                	ld	s0,16(sp)
    80001090:	64a2                	ld	s1,8(sp)
    80001092:	6105                	addi	sp,sp,32
    80001094:	8082                	ret

0000000080001096 <allocproc>:
{
    80001096:	1101                	addi	sp,sp,-32
    80001098:	ec06                	sd	ra,24(sp)
    8000109a:	e822                	sd	s0,16(sp)
    8000109c:	e426                	sd	s1,8(sp)
    8000109e:	e04a                	sd	s2,0(sp)
    800010a0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a2:	00008497          	auipc	s1,0x8
    800010a6:	3de48493          	addi	s1,s1,990 # 80009480 <proc>
    800010aa:	0000e917          	auipc	s2,0xe
    800010ae:	fd690913          	addi	s2,s2,-42 # 8000f080 <tickslock>
    acquire(&p->lock);
    800010b2:	8526                	mv	a0,s1
    800010b4:	00005097          	auipc	ra,0x5
    800010b8:	0dc080e7          	jalr	220(ra) # 80006190 <acquire>
    if(p->state == UNUSED) {
    800010bc:	4c9c                	lw	a5,24(s1)
    800010be:	cf81                	beqz	a5,800010d6 <allocproc+0x40>
      release(&p->lock);
    800010c0:	8526                	mv	a0,s1
    800010c2:	00005097          	auipc	ra,0x5
    800010c6:	182080e7          	jalr	386(ra) # 80006244 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ca:	17048493          	addi	s1,s1,368
    800010ce:	ff2492e3          	bne	s1,s2,800010b2 <allocproc+0x1c>
  return 0;
    800010d2:	4481                	li	s1,0
    800010d4:	a899                	j	8000112a <allocproc+0x94>
  p->pid = allocpid();
    800010d6:	00000097          	auipc	ra,0x0
    800010da:	e34080e7          	jalr	-460(ra) # 80000f0a <allocpid>
    800010de:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e0:	4785                	li	a5,1
    800010e2:	cc9c                	sw	a5,24(s1)
  p->tracemask = 0;
    800010e4:	1604a423          	sw	zero,360(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010e8:	fffff097          	auipc	ra,0xfffff
    800010ec:	030080e7          	jalr	48(ra) # 80000118 <kalloc>
    800010f0:	892a                	mv	s2,a0
    800010f2:	eca8                	sd	a0,88(s1)
    800010f4:	c131                	beqz	a0,80001138 <allocproc+0xa2>
  p->pagetable = proc_pagetable(p);
    800010f6:	8526                	mv	a0,s1
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	e58080e7          	jalr	-424(ra) # 80000f50 <proc_pagetable>
    80001100:	892a                	mv	s2,a0
    80001102:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001104:	c531                	beqz	a0,80001150 <allocproc+0xba>
  memset(&p->context, 0, sizeof(p->context));
    80001106:	07000613          	li	a2,112
    8000110a:	4581                	li	a1,0
    8000110c:	06048513          	addi	a0,s1,96
    80001110:	fffff097          	auipc	ra,0xfffff
    80001114:	0b2080e7          	jalr	178(ra) # 800001c2 <memset>
  p->context.ra = (uint64)forkret;
    80001118:	00000797          	auipc	a5,0x0
    8000111c:	dac78793          	addi	a5,a5,-596 # 80000ec4 <forkret>
    80001120:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001122:	60bc                	ld	a5,64(s1)
    80001124:	6705                	lui	a4,0x1
    80001126:	97ba                	add	a5,a5,a4
    80001128:	f4bc                	sd	a5,104(s1)
}
    8000112a:	8526                	mv	a0,s1
    8000112c:	60e2                	ld	ra,24(sp)
    8000112e:	6442                	ld	s0,16(sp)
    80001130:	64a2                	ld	s1,8(sp)
    80001132:	6902                	ld	s2,0(sp)
    80001134:	6105                	addi	sp,sp,32
    80001136:	8082                	ret
    freeproc(p);
    80001138:	8526                	mv	a0,s1
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	f04080e7          	jalr	-252(ra) # 8000103e <freeproc>
    release(&p->lock);
    80001142:	8526                	mv	a0,s1
    80001144:	00005097          	auipc	ra,0x5
    80001148:	100080e7          	jalr	256(ra) # 80006244 <release>
    return 0;
    8000114c:	84ca                	mv	s1,s2
    8000114e:	bff1                	j	8000112a <allocproc+0x94>
    freeproc(p);
    80001150:	8526                	mv	a0,s1
    80001152:	00000097          	auipc	ra,0x0
    80001156:	eec080e7          	jalr	-276(ra) # 8000103e <freeproc>
    release(&p->lock);
    8000115a:	8526                	mv	a0,s1
    8000115c:	00005097          	auipc	ra,0x5
    80001160:	0e8080e7          	jalr	232(ra) # 80006244 <release>
    return 0;
    80001164:	84ca                	mv	s1,s2
    80001166:	b7d1                	j	8000112a <allocproc+0x94>

0000000080001168 <userinit>:
{
    80001168:	1101                	addi	sp,sp,-32
    8000116a:	ec06                	sd	ra,24(sp)
    8000116c:	e822                	sd	s0,16(sp)
    8000116e:	e426                	sd	s1,8(sp)
    80001170:	1000                	addi	s0,sp,32
  p = allocproc();
    80001172:	00000097          	auipc	ra,0x0
    80001176:	f24080e7          	jalr	-220(ra) # 80001096 <allocproc>
    8000117a:	84aa                	mv	s1,a0
  initproc = p;
    8000117c:	00008797          	auipc	a5,0x8
    80001180:	e8a7ba23          	sd	a0,-364(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001184:	03400613          	li	a2,52
    80001188:	00007597          	auipc	a1,0x7
    8000118c:	76858593          	addi	a1,a1,1896 # 800088f0 <initcode>
    80001190:	6928                	ld	a0,80(a0)
    80001192:	fffff097          	auipc	ra,0xfffff
    80001196:	6b0080e7          	jalr	1712(ra) # 80000842 <uvminit>
  p->sz = PGSIZE;
    8000119a:	6785                	lui	a5,0x1
    8000119c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000119e:	6cb8                	ld	a4,88(s1)
    800011a0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a4:	6cb8                	ld	a4,88(s1)
    800011a6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011a8:	4641                	li	a2,16
    800011aa:	00007597          	auipc	a1,0x7
    800011ae:	fd658593          	addi	a1,a1,-42 # 80008180 <etext+0x180>
    800011b2:	15848513          	addi	a0,s1,344
    800011b6:	fffff097          	auipc	ra,0xfffff
    800011ba:	156080e7          	jalr	342(ra) # 8000030c <safestrcpy>
  p->cwd = namei("/");
    800011be:	00007517          	auipc	a0,0x7
    800011c2:	fd250513          	addi	a0,a0,-46 # 80008190 <etext+0x190>
    800011c6:	00002097          	auipc	ra,0x2
    800011ca:	1d4080e7          	jalr	468(ra) # 8000339a <namei>
    800011ce:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011d2:	478d                	li	a5,3
    800011d4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d6:	8526                	mv	a0,s1
    800011d8:	00005097          	auipc	ra,0x5
    800011dc:	06c080e7          	jalr	108(ra) # 80006244 <release>
}
    800011e0:	60e2                	ld	ra,24(sp)
    800011e2:	6442                	ld	s0,16(sp)
    800011e4:	64a2                	ld	s1,8(sp)
    800011e6:	6105                	addi	sp,sp,32
    800011e8:	8082                	ret

00000000800011ea <growproc>:
{
    800011ea:	1101                	addi	sp,sp,-32
    800011ec:	ec06                	sd	ra,24(sp)
    800011ee:	e822                	sd	s0,16(sp)
    800011f0:	e426                	sd	s1,8(sp)
    800011f2:	e04a                	sd	s2,0(sp)
    800011f4:	1000                	addi	s0,sp,32
    800011f6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011f8:	00000097          	auipc	ra,0x0
    800011fc:	c94080e7          	jalr	-876(ra) # 80000e8c <myproc>
    80001200:	892a                	mv	s2,a0
  sz = p->sz;
    80001202:	652c                	ld	a1,72(a0)
    80001204:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001208:	00904f63          	bgtz	s1,80001226 <growproc+0x3c>
  } else if(n < 0){
    8000120c:	0204cc63          	bltz	s1,80001244 <growproc+0x5a>
  p->sz = sz;
    80001210:	1602                	slli	a2,a2,0x20
    80001212:	9201                	srli	a2,a2,0x20
    80001214:	04c93423          	sd	a2,72(s2)
  return 0;
    80001218:	4501                	li	a0,0
}
    8000121a:	60e2                	ld	ra,24(sp)
    8000121c:	6442                	ld	s0,16(sp)
    8000121e:	64a2                	ld	s1,8(sp)
    80001220:	6902                	ld	s2,0(sp)
    80001222:	6105                	addi	sp,sp,32
    80001224:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001226:	9e25                	addw	a2,a2,s1
    80001228:	1602                	slli	a2,a2,0x20
    8000122a:	9201                	srli	a2,a2,0x20
    8000122c:	1582                	slli	a1,a1,0x20
    8000122e:	9181                	srli	a1,a1,0x20
    80001230:	6928                	ld	a0,80(a0)
    80001232:	fffff097          	auipc	ra,0xfffff
    80001236:	6ca080e7          	jalr	1738(ra) # 800008fc <uvmalloc>
    8000123a:	0005061b          	sext.w	a2,a0
    8000123e:	fa69                	bnez	a2,80001210 <growproc+0x26>
      return -1;
    80001240:	557d                	li	a0,-1
    80001242:	bfe1                	j	8000121a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001244:	9e25                	addw	a2,a2,s1
    80001246:	1602                	slli	a2,a2,0x20
    80001248:	9201                	srli	a2,a2,0x20
    8000124a:	1582                	slli	a1,a1,0x20
    8000124c:	9181                	srli	a1,a1,0x20
    8000124e:	6928                	ld	a0,80(a0)
    80001250:	fffff097          	auipc	ra,0xfffff
    80001254:	664080e7          	jalr	1636(ra) # 800008b4 <uvmdealloc>
    80001258:	0005061b          	sext.w	a2,a0
    8000125c:	bf55                	j	80001210 <growproc+0x26>

000000008000125e <fork>:
{
    8000125e:	7139                	addi	sp,sp,-64
    80001260:	fc06                	sd	ra,56(sp)
    80001262:	f822                	sd	s0,48(sp)
    80001264:	f426                	sd	s1,40(sp)
    80001266:	f04a                	sd	s2,32(sp)
    80001268:	ec4e                	sd	s3,24(sp)
    8000126a:	e852                	sd	s4,16(sp)
    8000126c:	e456                	sd	s5,8(sp)
    8000126e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001270:	00000097          	auipc	ra,0x0
    80001274:	c1c080e7          	jalr	-996(ra) # 80000e8c <myproc>
    80001278:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	e1c080e7          	jalr	-484(ra) # 80001096 <allocproc>
    80001282:	12050063          	beqz	a0,800013a2 <fork+0x144>
    80001286:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001288:	048ab603          	ld	a2,72(s5)
    8000128c:	692c                	ld	a1,80(a0)
    8000128e:	050ab503          	ld	a0,80(s5)
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	7b6080e7          	jalr	1974(ra) # 80000a48 <uvmcopy>
    8000129a:	04054c63          	bltz	a0,800012f2 <fork+0x94>
  np->sz = p->sz;
    8000129e:	048ab783          	ld	a5,72(s5)
    800012a2:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012a6:	058ab683          	ld	a3,88(s5)
    800012aa:	87b6                	mv	a5,a3
    800012ac:	0589b703          	ld	a4,88(s3)
    800012b0:	12068693          	addi	a3,a3,288
    800012b4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b8:	6788                	ld	a0,8(a5)
    800012ba:	6b8c                	ld	a1,16(a5)
    800012bc:	6f90                	ld	a2,24(a5)
    800012be:	01073023          	sd	a6,0(a4)
    800012c2:	e708                	sd	a0,8(a4)
    800012c4:	eb0c                	sd	a1,16(a4)
    800012c6:	ef10                	sd	a2,24(a4)
    800012c8:	02078793          	addi	a5,a5,32
    800012cc:	02070713          	addi	a4,a4,32
    800012d0:	fed792e3          	bne	a5,a3,800012b4 <fork+0x56>
  np->tracemask = p->tracemask;
    800012d4:	168aa783          	lw	a5,360(s5)
    800012d8:	16f9a423          	sw	a5,360(s3)
  np->trapframe->a0 = 0;
    800012dc:	0589b783          	ld	a5,88(s3)
    800012e0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e4:	0d0a8493          	addi	s1,s5,208
    800012e8:	0d098913          	addi	s2,s3,208
    800012ec:	150a8a13          	addi	s4,s5,336
    800012f0:	a00d                	j	80001312 <fork+0xb4>
    freeproc(np);
    800012f2:	854e                	mv	a0,s3
    800012f4:	00000097          	auipc	ra,0x0
    800012f8:	d4a080e7          	jalr	-694(ra) # 8000103e <freeproc>
    release(&np->lock);
    800012fc:	854e                	mv	a0,s3
    800012fe:	00005097          	auipc	ra,0x5
    80001302:	f46080e7          	jalr	-186(ra) # 80006244 <release>
    return -1;
    80001306:	597d                	li	s2,-1
    80001308:	a059                	j	8000138e <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    8000130a:	04a1                	addi	s1,s1,8
    8000130c:	0921                	addi	s2,s2,8
    8000130e:	01448b63          	beq	s1,s4,80001324 <fork+0xc6>
    if(p->ofile[i])
    80001312:	6088                	ld	a0,0(s1)
    80001314:	d97d                	beqz	a0,8000130a <fork+0xac>
      np->ofile[i] = filedup(p->ofile[i]);
    80001316:	00002097          	auipc	ra,0x2
    8000131a:	71a080e7          	jalr	1818(ra) # 80003a30 <filedup>
    8000131e:	00a93023          	sd	a0,0(s2)
    80001322:	b7e5                	j	8000130a <fork+0xac>
  np->cwd = idup(p->cwd);
    80001324:	150ab503          	ld	a0,336(s5)
    80001328:	00002097          	auipc	ra,0x2
    8000132c:	87e080e7          	jalr	-1922(ra) # 80002ba6 <idup>
    80001330:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001334:	4641                	li	a2,16
    80001336:	158a8593          	addi	a1,s5,344
    8000133a:	15898513          	addi	a0,s3,344
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	fce080e7          	jalr	-50(ra) # 8000030c <safestrcpy>
  pid = np->pid;
    80001346:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000134a:	854e                	mv	a0,s3
    8000134c:	00005097          	auipc	ra,0x5
    80001350:	ef8080e7          	jalr	-264(ra) # 80006244 <release>
  acquire(&wait_lock);
    80001354:	00008497          	auipc	s1,0x8
    80001358:	d1448493          	addi	s1,s1,-748 # 80009068 <wait_lock>
    8000135c:	8526                	mv	a0,s1
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	e32080e7          	jalr	-462(ra) # 80006190 <acquire>
  np->parent = p;
    80001366:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000136a:	8526                	mv	a0,s1
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	ed8080e7          	jalr	-296(ra) # 80006244 <release>
  acquire(&np->lock);
    80001374:	854e                	mv	a0,s3
    80001376:	00005097          	auipc	ra,0x5
    8000137a:	e1a080e7          	jalr	-486(ra) # 80006190 <acquire>
  np->state = RUNNABLE;
    8000137e:	478d                	li	a5,3
    80001380:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001384:	854e                	mv	a0,s3
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	ebe080e7          	jalr	-322(ra) # 80006244 <release>
}
    8000138e:	854a                	mv	a0,s2
    80001390:	70e2                	ld	ra,56(sp)
    80001392:	7442                	ld	s0,48(sp)
    80001394:	74a2                	ld	s1,40(sp)
    80001396:	7902                	ld	s2,32(sp)
    80001398:	69e2                	ld	s3,24(sp)
    8000139a:	6a42                	ld	s4,16(sp)
    8000139c:	6aa2                	ld	s5,8(sp)
    8000139e:	6121                	addi	sp,sp,64
    800013a0:	8082                	ret
    return -1;
    800013a2:	597d                	li	s2,-1
    800013a4:	b7ed                	j	8000138e <fork+0x130>

00000000800013a6 <scheduler>:
{
    800013a6:	7139                	addi	sp,sp,-64
    800013a8:	fc06                	sd	ra,56(sp)
    800013aa:	f822                	sd	s0,48(sp)
    800013ac:	f426                	sd	s1,40(sp)
    800013ae:	f04a                	sd	s2,32(sp)
    800013b0:	ec4e                	sd	s3,24(sp)
    800013b2:	e852                	sd	s4,16(sp)
    800013b4:	e456                	sd	s5,8(sp)
    800013b6:	e05a                	sd	s6,0(sp)
    800013b8:	0080                	addi	s0,sp,64
    800013ba:	8792                	mv	a5,tp
  int id = r_tp();
    800013bc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013be:	00779a93          	slli	s5,a5,0x7
    800013c2:	00008717          	auipc	a4,0x8
    800013c6:	c8e70713          	addi	a4,a4,-882 # 80009050 <pid_lock>
    800013ca:	9756                	add	a4,a4,s5
    800013cc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d0:	00008717          	auipc	a4,0x8
    800013d4:	cb870713          	addi	a4,a4,-840 # 80009088 <cpus+0x8>
    800013d8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013da:	498d                	li	s3,3
        p->state = RUNNING;
    800013dc:	4b11                	li	s6,4
        c->proc = p;
    800013de:	079e                	slli	a5,a5,0x7
    800013e0:	00008a17          	auipc	s4,0x8
    800013e4:	c70a0a13          	addi	s4,s4,-912 # 80009050 <pid_lock>
    800013e8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ea:	0000e917          	auipc	s2,0xe
    800013ee:	c9690913          	addi	s2,s2,-874 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fa:	10079073          	csrw	sstatus,a5
    800013fe:	00008497          	auipc	s1,0x8
    80001402:	08248493          	addi	s1,s1,130 # 80009480 <proc>
    80001406:	a811                	j	8000141a <scheduler+0x74>
      release(&p->lock);
    80001408:	8526                	mv	a0,s1
    8000140a:	00005097          	auipc	ra,0x5
    8000140e:	e3a080e7          	jalr	-454(ra) # 80006244 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001412:	17048493          	addi	s1,s1,368
    80001416:	fd248ee3          	beq	s1,s2,800013f2 <scheduler+0x4c>
      acquire(&p->lock);
    8000141a:	8526                	mv	a0,s1
    8000141c:	00005097          	auipc	ra,0x5
    80001420:	d74080e7          	jalr	-652(ra) # 80006190 <acquire>
      if(p->state == RUNNABLE) {
    80001424:	4c9c                	lw	a5,24(s1)
    80001426:	ff3791e3          	bne	a5,s3,80001408 <scheduler+0x62>
        p->state = RUNNING;
    8000142a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000142e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001432:	06048593          	addi	a1,s1,96
    80001436:	8556                	mv	a0,s5
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	67e080e7          	jalr	1662(ra) # 80001ab6 <swtch>
        c->proc = 0;
    80001440:	020a3823          	sd	zero,48(s4)
    80001444:	b7d1                	j	80001408 <scheduler+0x62>

0000000080001446 <sched>:
{
    80001446:	7179                	addi	sp,sp,-48
    80001448:	f406                	sd	ra,40(sp)
    8000144a:	f022                	sd	s0,32(sp)
    8000144c:	ec26                	sd	s1,24(sp)
    8000144e:	e84a                	sd	s2,16(sp)
    80001450:	e44e                	sd	s3,8(sp)
    80001452:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001454:	00000097          	auipc	ra,0x0
    80001458:	a38080e7          	jalr	-1480(ra) # 80000e8c <myproc>
    8000145c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145e:	00005097          	auipc	ra,0x5
    80001462:	cb8080e7          	jalr	-840(ra) # 80006116 <holding>
    80001466:	c93d                	beqz	a0,800014dc <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001468:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000146a:	2781                	sext.w	a5,a5
    8000146c:	079e                	slli	a5,a5,0x7
    8000146e:	00008717          	auipc	a4,0x8
    80001472:	be270713          	addi	a4,a4,-1054 # 80009050 <pid_lock>
    80001476:	97ba                	add	a5,a5,a4
    80001478:	0a87a703          	lw	a4,168(a5)
    8000147c:	4785                	li	a5,1
    8000147e:	06f71763          	bne	a4,a5,800014ec <sched+0xa6>
  if(p->state == RUNNING)
    80001482:	4c98                	lw	a4,24(s1)
    80001484:	4791                	li	a5,4
    80001486:	06f70b63          	beq	a4,a5,800014fc <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001490:	efb5                	bnez	a5,8000150c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001492:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001494:	00008917          	auipc	s2,0x8
    80001498:	bbc90913          	addi	s2,s2,-1092 # 80009050 <pid_lock>
    8000149c:	2781                	sext.w	a5,a5
    8000149e:	079e                	slli	a5,a5,0x7
    800014a0:	97ca                	add	a5,a5,s2
    800014a2:	0ac7a983          	lw	s3,172(a5)
    800014a6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a8:	2781                	sext.w	a5,a5
    800014aa:	079e                	slli	a5,a5,0x7
    800014ac:	00008597          	auipc	a1,0x8
    800014b0:	bdc58593          	addi	a1,a1,-1060 # 80009088 <cpus+0x8>
    800014b4:	95be                	add	a1,a1,a5
    800014b6:	06048513          	addi	a0,s1,96
    800014ba:	00000097          	auipc	ra,0x0
    800014be:	5fc080e7          	jalr	1532(ra) # 80001ab6 <swtch>
    800014c2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c4:	2781                	sext.w	a5,a5
    800014c6:	079e                	slli	a5,a5,0x7
    800014c8:	97ca                	add	a5,a5,s2
    800014ca:	0b37a623          	sw	s3,172(a5)
}
    800014ce:	70a2                	ld	ra,40(sp)
    800014d0:	7402                	ld	s0,32(sp)
    800014d2:	64e2                	ld	s1,24(sp)
    800014d4:	6942                	ld	s2,16(sp)
    800014d6:	69a2                	ld	s3,8(sp)
    800014d8:	6145                	addi	sp,sp,48
    800014da:	8082                	ret
    panic("sched p->lock");
    800014dc:	00007517          	auipc	a0,0x7
    800014e0:	cbc50513          	addi	a0,a0,-836 # 80008198 <etext+0x198>
    800014e4:	00004097          	auipc	ra,0x4
    800014e8:	770080e7          	jalr	1904(ra) # 80005c54 <panic>
    panic("sched locks");
    800014ec:	00007517          	auipc	a0,0x7
    800014f0:	cbc50513          	addi	a0,a0,-836 # 800081a8 <etext+0x1a8>
    800014f4:	00004097          	auipc	ra,0x4
    800014f8:	760080e7          	jalr	1888(ra) # 80005c54 <panic>
    panic("sched running");
    800014fc:	00007517          	auipc	a0,0x7
    80001500:	cbc50513          	addi	a0,a0,-836 # 800081b8 <etext+0x1b8>
    80001504:	00004097          	auipc	ra,0x4
    80001508:	750080e7          	jalr	1872(ra) # 80005c54 <panic>
    panic("sched interruptible");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	cbc50513          	addi	a0,a0,-836 # 800081c8 <etext+0x1c8>
    80001514:	00004097          	auipc	ra,0x4
    80001518:	740080e7          	jalr	1856(ra) # 80005c54 <panic>

000000008000151c <yield>:
{
    8000151c:	1101                	addi	sp,sp,-32
    8000151e:	ec06                	sd	ra,24(sp)
    80001520:	e822                	sd	s0,16(sp)
    80001522:	e426                	sd	s1,8(sp)
    80001524:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	966080e7          	jalr	-1690(ra) # 80000e8c <myproc>
    8000152e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001530:	00005097          	auipc	ra,0x5
    80001534:	c60080e7          	jalr	-928(ra) # 80006190 <acquire>
  p->state = RUNNABLE;
    80001538:	478d                	li	a5,3
    8000153a:	cc9c                	sw	a5,24(s1)
  sched();
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	f0a080e7          	jalr	-246(ra) # 80001446 <sched>
  release(&p->lock);
    80001544:	8526                	mv	a0,s1
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	cfe080e7          	jalr	-770(ra) # 80006244 <release>
}
    8000154e:	60e2                	ld	ra,24(sp)
    80001550:	6442                	ld	s0,16(sp)
    80001552:	64a2                	ld	s1,8(sp)
    80001554:	6105                	addi	sp,sp,32
    80001556:	8082                	ret

0000000080001558 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001558:	7179                	addi	sp,sp,-48
    8000155a:	f406                	sd	ra,40(sp)
    8000155c:	f022                	sd	s0,32(sp)
    8000155e:	ec26                	sd	s1,24(sp)
    80001560:	e84a                	sd	s2,16(sp)
    80001562:	e44e                	sd	s3,8(sp)
    80001564:	1800                	addi	s0,sp,48
    80001566:	89aa                	mv	s3,a0
    80001568:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	922080e7          	jalr	-1758(ra) # 80000e8c <myproc>
    80001572:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001574:	00005097          	auipc	ra,0x5
    80001578:	c1c080e7          	jalr	-996(ra) # 80006190 <acquire>
  release(lk);
    8000157c:	854a                	mv	a0,s2
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	cc6080e7          	jalr	-826(ra) # 80006244 <release>

  // Go to sleep.
  p->chan = chan;
    80001586:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000158a:	4789                	li	a5,2
    8000158c:	cc9c                	sw	a5,24(s1)

  sched();
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	eb8080e7          	jalr	-328(ra) # 80001446 <sched>

  // Tidy up.
  p->chan = 0;
    80001596:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	ca8080e7          	jalr	-856(ra) # 80006244 <release>
  acquire(lk);
    800015a4:	854a                	mv	a0,s2
    800015a6:	00005097          	auipc	ra,0x5
    800015aa:	bea080e7          	jalr	-1046(ra) # 80006190 <acquire>
}
    800015ae:	70a2                	ld	ra,40(sp)
    800015b0:	7402                	ld	s0,32(sp)
    800015b2:	64e2                	ld	s1,24(sp)
    800015b4:	6942                	ld	s2,16(sp)
    800015b6:	69a2                	ld	s3,8(sp)
    800015b8:	6145                	addi	sp,sp,48
    800015ba:	8082                	ret

00000000800015bc <wait>:
{
    800015bc:	715d                	addi	sp,sp,-80
    800015be:	e486                	sd	ra,72(sp)
    800015c0:	e0a2                	sd	s0,64(sp)
    800015c2:	fc26                	sd	s1,56(sp)
    800015c4:	f84a                	sd	s2,48(sp)
    800015c6:	f44e                	sd	s3,40(sp)
    800015c8:	f052                	sd	s4,32(sp)
    800015ca:	ec56                	sd	s5,24(sp)
    800015cc:	e85a                	sd	s6,16(sp)
    800015ce:	e45e                	sd	s7,8(sp)
    800015d0:	e062                	sd	s8,0(sp)
    800015d2:	0880                	addi	s0,sp,80
    800015d4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d6:	00000097          	auipc	ra,0x0
    800015da:	8b6080e7          	jalr	-1866(ra) # 80000e8c <myproc>
    800015de:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e0:	00008517          	auipc	a0,0x8
    800015e4:	a8850513          	addi	a0,a0,-1400 # 80009068 <wait_lock>
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	ba8080e7          	jalr	-1112(ra) # 80006190 <acquire>
    havekids = 0;
    800015f0:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f2:	4a15                	li	s4,5
        havekids = 1;
    800015f4:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015f6:	0000e997          	auipc	s3,0xe
    800015fa:	a8a98993          	addi	s3,s3,-1398 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fe:	00008c17          	auipc	s8,0x8
    80001602:	a6ac0c13          	addi	s8,s8,-1430 # 80009068 <wait_lock>
    havekids = 0;
    80001606:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001608:	00008497          	auipc	s1,0x8
    8000160c:	e7848493          	addi	s1,s1,-392 # 80009480 <proc>
    80001610:	a0bd                	j	8000167e <wait+0xc2>
          pid = np->pid;
    80001612:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001616:	000b0e63          	beqz	s6,80001632 <wait+0x76>
    8000161a:	4691                	li	a3,4
    8000161c:	02c48613          	addi	a2,s1,44
    80001620:	85da                	mv	a1,s6
    80001622:	05093503          	ld	a0,80(s2)
    80001626:	fffff097          	auipc	ra,0xfffff
    8000162a:	526080e7          	jalr	1318(ra) # 80000b4c <copyout>
    8000162e:	02054563          	bltz	a0,80001658 <wait+0x9c>
          freeproc(np);
    80001632:	8526                	mv	a0,s1
    80001634:	00000097          	auipc	ra,0x0
    80001638:	a0a080e7          	jalr	-1526(ra) # 8000103e <freeproc>
          release(&np->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	c06080e7          	jalr	-1018(ra) # 80006244 <release>
          release(&wait_lock);
    80001646:	00008517          	auipc	a0,0x8
    8000164a:	a2250513          	addi	a0,a0,-1502 # 80009068 <wait_lock>
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	bf6080e7          	jalr	-1034(ra) # 80006244 <release>
          return pid;
    80001656:	a09d                	j	800016bc <wait+0x100>
            release(&np->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	bea080e7          	jalr	-1046(ra) # 80006244 <release>
            release(&wait_lock);
    80001662:	00008517          	auipc	a0,0x8
    80001666:	a0650513          	addi	a0,a0,-1530 # 80009068 <wait_lock>
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	bda080e7          	jalr	-1062(ra) # 80006244 <release>
            return -1;
    80001672:	59fd                	li	s3,-1
    80001674:	a0a1                	j	800016bc <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001676:	17048493          	addi	s1,s1,368
    8000167a:	03348463          	beq	s1,s3,800016a2 <wait+0xe6>
      if(np->parent == p){
    8000167e:	7c9c                	ld	a5,56(s1)
    80001680:	ff279be3          	bne	a5,s2,80001676 <wait+0xba>
        acquire(&np->lock);
    80001684:	8526                	mv	a0,s1
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	b0a080e7          	jalr	-1270(ra) # 80006190 <acquire>
        if(np->state == ZOMBIE){
    8000168e:	4c9c                	lw	a5,24(s1)
    80001690:	f94781e3          	beq	a5,s4,80001612 <wait+0x56>
        release(&np->lock);
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	bae080e7          	jalr	-1106(ra) # 80006244 <release>
        havekids = 1;
    8000169e:	8756                	mv	a4,s5
    800016a0:	bfd9                	j	80001676 <wait+0xba>
    if(!havekids || p->killed){
    800016a2:	c701                	beqz	a4,800016aa <wait+0xee>
    800016a4:	02892783          	lw	a5,40(s2)
    800016a8:	c79d                	beqz	a5,800016d6 <wait+0x11a>
      release(&wait_lock);
    800016aa:	00008517          	auipc	a0,0x8
    800016ae:	9be50513          	addi	a0,a0,-1602 # 80009068 <wait_lock>
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	b92080e7          	jalr	-1134(ra) # 80006244 <release>
      return -1;
    800016ba:	59fd                	li	s3,-1
}
    800016bc:	854e                	mv	a0,s3
    800016be:	60a6                	ld	ra,72(sp)
    800016c0:	6406                	ld	s0,64(sp)
    800016c2:	74e2                	ld	s1,56(sp)
    800016c4:	7942                	ld	s2,48(sp)
    800016c6:	79a2                	ld	s3,40(sp)
    800016c8:	7a02                	ld	s4,32(sp)
    800016ca:	6ae2                	ld	s5,24(sp)
    800016cc:	6b42                	ld	s6,16(sp)
    800016ce:	6ba2                	ld	s7,8(sp)
    800016d0:	6c02                	ld	s8,0(sp)
    800016d2:	6161                	addi	sp,sp,80
    800016d4:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d6:	85e2                	mv	a1,s8
    800016d8:	854a                	mv	a0,s2
    800016da:	00000097          	auipc	ra,0x0
    800016de:	e7e080e7          	jalr	-386(ra) # 80001558 <sleep>
    havekids = 0;
    800016e2:	b715                	j	80001606 <wait+0x4a>

00000000800016e4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e4:	7139                	addi	sp,sp,-64
    800016e6:	fc06                	sd	ra,56(sp)
    800016e8:	f822                	sd	s0,48(sp)
    800016ea:	f426                	sd	s1,40(sp)
    800016ec:	f04a                	sd	s2,32(sp)
    800016ee:	ec4e                	sd	s3,24(sp)
    800016f0:	e852                	sd	s4,16(sp)
    800016f2:	e456                	sd	s5,8(sp)
    800016f4:	0080                	addi	s0,sp,64
    800016f6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016f8:	00008497          	auipc	s1,0x8
    800016fc:	d8848493          	addi	s1,s1,-632 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001700:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001702:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001704:	0000e917          	auipc	s2,0xe
    80001708:	97c90913          	addi	s2,s2,-1668 # 8000f080 <tickslock>
    8000170c:	a811                	j	80001720 <wakeup+0x3c>
      }
      release(&p->lock);
    8000170e:	8526                	mv	a0,s1
    80001710:	00005097          	auipc	ra,0x5
    80001714:	b34080e7          	jalr	-1228(ra) # 80006244 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001718:	17048493          	addi	s1,s1,368
    8000171c:	03248663          	beq	s1,s2,80001748 <wakeup+0x64>
    if(p != myproc()){
    80001720:	fffff097          	auipc	ra,0xfffff
    80001724:	76c080e7          	jalr	1900(ra) # 80000e8c <myproc>
    80001728:	fea488e3          	beq	s1,a0,80001718 <wakeup+0x34>
      acquire(&p->lock);
    8000172c:	8526                	mv	a0,s1
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	a62080e7          	jalr	-1438(ra) # 80006190 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001736:	4c9c                	lw	a5,24(s1)
    80001738:	fd379be3          	bne	a5,s3,8000170e <wakeup+0x2a>
    8000173c:	709c                	ld	a5,32(s1)
    8000173e:	fd4798e3          	bne	a5,s4,8000170e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001742:	0154ac23          	sw	s5,24(s1)
    80001746:	b7e1                	j	8000170e <wakeup+0x2a>
    }
  }
}
    80001748:	70e2                	ld	ra,56(sp)
    8000174a:	7442                	ld	s0,48(sp)
    8000174c:	74a2                	ld	s1,40(sp)
    8000174e:	7902                	ld	s2,32(sp)
    80001750:	69e2                	ld	s3,24(sp)
    80001752:	6a42                	ld	s4,16(sp)
    80001754:	6aa2                	ld	s5,8(sp)
    80001756:	6121                	addi	sp,sp,64
    80001758:	8082                	ret

000000008000175a <reparent>:
{
    8000175a:	7179                	addi	sp,sp,-48
    8000175c:	f406                	sd	ra,40(sp)
    8000175e:	f022                	sd	s0,32(sp)
    80001760:	ec26                	sd	s1,24(sp)
    80001762:	e84a                	sd	s2,16(sp)
    80001764:	e44e                	sd	s3,8(sp)
    80001766:	e052                	sd	s4,0(sp)
    80001768:	1800                	addi	s0,sp,48
    8000176a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176c:	00008497          	auipc	s1,0x8
    80001770:	d1448493          	addi	s1,s1,-748 # 80009480 <proc>
      pp->parent = initproc;
    80001774:	00008a17          	auipc	s4,0x8
    80001778:	89ca0a13          	addi	s4,s4,-1892 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177c:	0000e997          	auipc	s3,0xe
    80001780:	90498993          	addi	s3,s3,-1788 # 8000f080 <tickslock>
    80001784:	a029                	j	8000178e <reparent+0x34>
    80001786:	17048493          	addi	s1,s1,368
    8000178a:	01348d63          	beq	s1,s3,800017a4 <reparent+0x4a>
    if(pp->parent == p){
    8000178e:	7c9c                	ld	a5,56(s1)
    80001790:	ff279be3          	bne	a5,s2,80001786 <reparent+0x2c>
      pp->parent = initproc;
    80001794:	000a3503          	ld	a0,0(s4)
    80001798:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000179a:	00000097          	auipc	ra,0x0
    8000179e:	f4a080e7          	jalr	-182(ra) # 800016e4 <wakeup>
    800017a2:	b7d5                	j	80001786 <reparent+0x2c>
}
    800017a4:	70a2                	ld	ra,40(sp)
    800017a6:	7402                	ld	s0,32(sp)
    800017a8:	64e2                	ld	s1,24(sp)
    800017aa:	6942                	ld	s2,16(sp)
    800017ac:	69a2                	ld	s3,8(sp)
    800017ae:	6a02                	ld	s4,0(sp)
    800017b0:	6145                	addi	sp,sp,48
    800017b2:	8082                	ret

00000000800017b4 <exit>:
{
    800017b4:	7179                	addi	sp,sp,-48
    800017b6:	f406                	sd	ra,40(sp)
    800017b8:	f022                	sd	s0,32(sp)
    800017ba:	ec26                	sd	s1,24(sp)
    800017bc:	e84a                	sd	s2,16(sp)
    800017be:	e44e                	sd	s3,8(sp)
    800017c0:	e052                	sd	s4,0(sp)
    800017c2:	1800                	addi	s0,sp,48
    800017c4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c6:	fffff097          	auipc	ra,0xfffff
    800017ca:	6c6080e7          	jalr	1734(ra) # 80000e8c <myproc>
    800017ce:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d0:	00008797          	auipc	a5,0x8
    800017d4:	8407b783          	ld	a5,-1984(a5) # 80009010 <initproc>
    800017d8:	0d050493          	addi	s1,a0,208
    800017dc:	15050913          	addi	s2,a0,336
    800017e0:	02a79363          	bne	a5,a0,80001806 <exit+0x52>
    panic("init exiting");
    800017e4:	00007517          	auipc	a0,0x7
    800017e8:	9fc50513          	addi	a0,a0,-1540 # 800081e0 <etext+0x1e0>
    800017ec:	00004097          	auipc	ra,0x4
    800017f0:	468080e7          	jalr	1128(ra) # 80005c54 <panic>
      fileclose(f);
    800017f4:	00002097          	auipc	ra,0x2
    800017f8:	28e080e7          	jalr	654(ra) # 80003a82 <fileclose>
      p->ofile[fd] = 0;
    800017fc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001800:	04a1                	addi	s1,s1,8
    80001802:	01248563          	beq	s1,s2,8000180c <exit+0x58>
    if(p->ofile[fd]){
    80001806:	6088                	ld	a0,0(s1)
    80001808:	f575                	bnez	a0,800017f4 <exit+0x40>
    8000180a:	bfdd                	j	80001800 <exit+0x4c>
  begin_op();
    8000180c:	00002097          	auipc	ra,0x2
    80001810:	daa080e7          	jalr	-598(ra) # 800035b6 <begin_op>
  iput(p->cwd);
    80001814:	1509b503          	ld	a0,336(s3)
    80001818:	00001097          	auipc	ra,0x1
    8000181c:	586080e7          	jalr	1414(ra) # 80002d9e <iput>
  end_op();
    80001820:	00002097          	auipc	ra,0x2
    80001824:	e16080e7          	jalr	-490(ra) # 80003636 <end_op>
  p->cwd = 0;
    80001828:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000182c:	00008497          	auipc	s1,0x8
    80001830:	83c48493          	addi	s1,s1,-1988 # 80009068 <wait_lock>
    80001834:	8526                	mv	a0,s1
    80001836:	00005097          	auipc	ra,0x5
    8000183a:	95a080e7          	jalr	-1702(ra) # 80006190 <acquire>
  reparent(p);
    8000183e:	854e                	mv	a0,s3
    80001840:	00000097          	auipc	ra,0x0
    80001844:	f1a080e7          	jalr	-230(ra) # 8000175a <reparent>
  wakeup(p->parent);
    80001848:	0389b503          	ld	a0,56(s3)
    8000184c:	00000097          	auipc	ra,0x0
    80001850:	e98080e7          	jalr	-360(ra) # 800016e4 <wakeup>
  acquire(&p->lock);
    80001854:	854e                	mv	a0,s3
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	93a080e7          	jalr	-1734(ra) # 80006190 <acquire>
  p->xstate = status;
    8000185e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001862:	4795                	li	a5,5
    80001864:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001868:	8526                	mv	a0,s1
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	9da080e7          	jalr	-1574(ra) # 80006244 <release>
  sched();
    80001872:	00000097          	auipc	ra,0x0
    80001876:	bd4080e7          	jalr	-1068(ra) # 80001446 <sched>
  panic("zombie exit");
    8000187a:	00007517          	auipc	a0,0x7
    8000187e:	97650513          	addi	a0,a0,-1674 # 800081f0 <etext+0x1f0>
    80001882:	00004097          	auipc	ra,0x4
    80001886:	3d2080e7          	jalr	978(ra) # 80005c54 <panic>

000000008000188a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000188a:	7179                	addi	sp,sp,-48
    8000188c:	f406                	sd	ra,40(sp)
    8000188e:	f022                	sd	s0,32(sp)
    80001890:	ec26                	sd	s1,24(sp)
    80001892:	e84a                	sd	s2,16(sp)
    80001894:	e44e                	sd	s3,8(sp)
    80001896:	1800                	addi	s0,sp,48
    80001898:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000189a:	00008497          	auipc	s1,0x8
    8000189e:	be648493          	addi	s1,s1,-1050 # 80009480 <proc>
    800018a2:	0000d997          	auipc	s3,0xd
    800018a6:	7de98993          	addi	s3,s3,2014 # 8000f080 <tickslock>
    acquire(&p->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	8e4080e7          	jalr	-1820(ra) # 80006190 <acquire>
    if(p->pid == pid){
    800018b4:	589c                	lw	a5,48(s1)
    800018b6:	01278d63          	beq	a5,s2,800018d0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	988080e7          	jalr	-1656(ra) # 80006244 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c4:	17048493          	addi	s1,s1,368
    800018c8:	ff3491e3          	bne	s1,s3,800018aa <kill+0x20>
  }
  return -1;
    800018cc:	557d                	li	a0,-1
    800018ce:	a829                	j	800018e8 <kill+0x5e>
      p->killed = 1;
    800018d0:	4785                	li	a5,1
    800018d2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d4:	4c98                	lw	a4,24(s1)
    800018d6:	4789                	li	a5,2
    800018d8:	00f70f63          	beq	a4,a5,800018f6 <kill+0x6c>
      release(&p->lock);
    800018dc:	8526                	mv	a0,s1
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	966080e7          	jalr	-1690(ra) # 80006244 <release>
      return 0;
    800018e6:	4501                	li	a0,0
}
    800018e8:	70a2                	ld	ra,40(sp)
    800018ea:	7402                	ld	s0,32(sp)
    800018ec:	64e2                	ld	s1,24(sp)
    800018ee:	6942                	ld	s2,16(sp)
    800018f0:	69a2                	ld	s3,8(sp)
    800018f2:	6145                	addi	sp,sp,48
    800018f4:	8082                	ret
        p->state = RUNNABLE;
    800018f6:	478d                	li	a5,3
    800018f8:	cc9c                	sw	a5,24(s1)
    800018fa:	b7cd                	j	800018dc <kill+0x52>

00000000800018fc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fc:	7179                	addi	sp,sp,-48
    800018fe:	f406                	sd	ra,40(sp)
    80001900:	f022                	sd	s0,32(sp)
    80001902:	ec26                	sd	s1,24(sp)
    80001904:	e84a                	sd	s2,16(sp)
    80001906:	e44e                	sd	s3,8(sp)
    80001908:	e052                	sd	s4,0(sp)
    8000190a:	1800                	addi	s0,sp,48
    8000190c:	84aa                	mv	s1,a0
    8000190e:	892e                	mv	s2,a1
    80001910:	89b2                	mv	s3,a2
    80001912:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	578080e7          	jalr	1400(ra) # 80000e8c <myproc>
  if(user_dst){
    8000191c:	c08d                	beqz	s1,8000193e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191e:	86d2                	mv	a3,s4
    80001920:	864e                	mv	a2,s3
    80001922:	85ca                	mv	a1,s2
    80001924:	6928                	ld	a0,80(a0)
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	226080e7          	jalr	550(ra) # 80000b4c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192e:	70a2                	ld	ra,40(sp)
    80001930:	7402                	ld	s0,32(sp)
    80001932:	64e2                	ld	s1,24(sp)
    80001934:	6942                	ld	s2,16(sp)
    80001936:	69a2                	ld	s3,8(sp)
    80001938:	6a02                	ld	s4,0(sp)
    8000193a:	6145                	addi	sp,sp,48
    8000193c:	8082                	ret
    memmove((char *)dst, src, len);
    8000193e:	000a061b          	sext.w	a2,s4
    80001942:	85ce                	mv	a1,s3
    80001944:	854a                	mv	a0,s2
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	8d8080e7          	jalr	-1832(ra) # 8000021e <memmove>
    return 0;
    8000194e:	8526                	mv	a0,s1
    80001950:	bff9                	j	8000192e <either_copyout+0x32>

0000000080001952 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001952:	7179                	addi	sp,sp,-48
    80001954:	f406                	sd	ra,40(sp)
    80001956:	f022                	sd	s0,32(sp)
    80001958:	ec26                	sd	s1,24(sp)
    8000195a:	e84a                	sd	s2,16(sp)
    8000195c:	e44e                	sd	s3,8(sp)
    8000195e:	e052                	sd	s4,0(sp)
    80001960:	1800                	addi	s0,sp,48
    80001962:	892a                	mv	s2,a0
    80001964:	84ae                	mv	s1,a1
    80001966:	89b2                	mv	s3,a2
    80001968:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	522080e7          	jalr	1314(ra) # 80000e8c <myproc>
  if(user_src){
    80001972:	c08d                	beqz	s1,80001994 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001974:	86d2                	mv	a3,s4
    80001976:	864e                	mv	a2,s3
    80001978:	85ca                	mv	a1,s2
    8000197a:	6928                	ld	a0,80(a0)
    8000197c:	fffff097          	auipc	ra,0xfffff
    80001980:	25c080e7          	jalr	604(ra) # 80000bd8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001984:	70a2                	ld	ra,40(sp)
    80001986:	7402                	ld	s0,32(sp)
    80001988:	64e2                	ld	s1,24(sp)
    8000198a:	6942                	ld	s2,16(sp)
    8000198c:	69a2                	ld	s3,8(sp)
    8000198e:	6a02                	ld	s4,0(sp)
    80001990:	6145                	addi	sp,sp,48
    80001992:	8082                	ret
    memmove(dst, (char*)src, len);
    80001994:	000a061b          	sext.w	a2,s4
    80001998:	85ce                	mv	a1,s3
    8000199a:	854a                	mv	a0,s2
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	882080e7          	jalr	-1918(ra) # 8000021e <memmove>
    return 0;
    800019a4:	8526                	mv	a0,s1
    800019a6:	bff9                	j	80001984 <either_copyin+0x32>

00000000800019a8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a8:	715d                	addi	sp,sp,-80
    800019aa:	e486                	sd	ra,72(sp)
    800019ac:	e0a2                	sd	s0,64(sp)
    800019ae:	fc26                	sd	s1,56(sp)
    800019b0:	f84a                	sd	s2,48(sp)
    800019b2:	f44e                	sd	s3,40(sp)
    800019b4:	f052                	sd	s4,32(sp)
    800019b6:	ec56                	sd	s5,24(sp)
    800019b8:	e85a                	sd	s6,16(sp)
    800019ba:	e45e                	sd	s7,8(sp)
    800019bc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019be:	00006517          	auipc	a0,0x6
    800019c2:	68a50513          	addi	a0,a0,1674 # 80008048 <etext+0x48>
    800019c6:	00004097          	auipc	ra,0x4
    800019ca:	2d8080e7          	jalr	728(ra) # 80005c9e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ce:	00008497          	auipc	s1,0x8
    800019d2:	c0a48493          	addi	s1,s1,-1014 # 800095d8 <proc+0x158>
    800019d6:	0000e917          	auipc	s2,0xe
    800019da:	80290913          	addi	s2,s2,-2046 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019de:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e0:	00007997          	auipc	s3,0x7
    800019e4:	82098993          	addi	s3,s3,-2016 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e8:	00007a97          	auipc	s5,0x7
    800019ec:	820a8a93          	addi	s5,s5,-2016 # 80008208 <etext+0x208>
    printf("\n");
    800019f0:	00006a17          	auipc	s4,0x6
    800019f4:	658a0a13          	addi	s4,s4,1624 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f8:	00007b97          	auipc	s7,0x7
    800019fc:	dc8b8b93          	addi	s7,s7,-568 # 800087c0 <states.0>
    80001a00:	a00d                	j	80001a22 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a02:	ed86a583          	lw	a1,-296(a3)
    80001a06:	8556                	mv	a0,s5
    80001a08:	00004097          	auipc	ra,0x4
    80001a0c:	296080e7          	jalr	662(ra) # 80005c9e <printf>
    printf("\n");
    80001a10:	8552                	mv	a0,s4
    80001a12:	00004097          	auipc	ra,0x4
    80001a16:	28c080e7          	jalr	652(ra) # 80005c9e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1a:	17048493          	addi	s1,s1,368
    80001a1e:	03248163          	beq	s1,s2,80001a40 <procdump+0x98>
    if(p->state == UNUSED)
    80001a22:	86a6                	mv	a3,s1
    80001a24:	ec04a783          	lw	a5,-320(s1)
    80001a28:	dbed                	beqz	a5,80001a1a <procdump+0x72>
      state = "???";
    80001a2a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2c:	fcfb6be3          	bltu	s6,a5,80001a02 <procdump+0x5a>
    80001a30:	1782                	slli	a5,a5,0x20
    80001a32:	9381                	srli	a5,a5,0x20
    80001a34:	078e                	slli	a5,a5,0x3
    80001a36:	97de                	add	a5,a5,s7
    80001a38:	6390                	ld	a2,0(a5)
    80001a3a:	f661                	bnez	a2,80001a02 <procdump+0x5a>
      state = "???";
    80001a3c:	864e                	mv	a2,s3
    80001a3e:	b7d1                	j	80001a02 <procdump+0x5a>
  }
}
    80001a40:	60a6                	ld	ra,72(sp)
    80001a42:	6406                	ld	s0,64(sp)
    80001a44:	74e2                	ld	s1,56(sp)
    80001a46:	7942                	ld	s2,48(sp)
    80001a48:	79a2                	ld	s3,40(sp)
    80001a4a:	7a02                	ld	s4,32(sp)
    80001a4c:	6ae2                	ld	s5,24(sp)
    80001a4e:	6b42                	ld	s6,16(sp)
    80001a50:	6ba2                	ld	s7,8(sp)
    80001a52:	6161                	addi	sp,sp,80
    80001a54:	8082                	ret

0000000080001a56 <getnproc>:

// 为 sysinfo 系统调用提供辅助功能：计算当前状态不是 UNUSED 的进程总数。
int getnproc(void)
{
    80001a56:	7179                	addi	sp,sp,-48
    80001a58:	f406                	sd	ra,40(sp)
    80001a5a:	f022                	sd	s0,32(sp)
    80001a5c:	ec26                	sd	s1,24(sp)
    80001a5e:	e84a                	sd	s2,16(sp)
    80001a60:	e44e                	sd	s3,8(sp)
    80001a62:	1800                	addi	s0,sp,48
  struct proc *p;
  int count = 0;
    80001a64:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++)
    80001a66:	00008497          	auipc	s1,0x8
    80001a6a:	a1a48493          	addi	s1,s1,-1510 # 80009480 <proc>
    80001a6e:	0000d997          	auipc	s3,0xd
    80001a72:	61298993          	addi	s3,s3,1554 # 8000f080 <tickslock>
    80001a76:	a811                	j	80001a8a <getnproc+0x34>
      count++;
      release(&p->lock);
    }
    else
    {
      release(&p->lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	00004097          	auipc	ra,0x4
    80001a7e:	7ca080e7          	jalr	1994(ra) # 80006244 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a82:	17048493          	addi	s1,s1,368
    80001a86:	03348063          	beq	s1,s3,80001aa6 <getnproc+0x50>
    acquire(&p->lock);
    80001a8a:	8526                	mv	a0,s1
    80001a8c:	00004097          	auipc	ra,0x4
    80001a90:	704080e7          	jalr	1796(ra) # 80006190 <acquire>
    if (p->state != UNUSED)
    80001a94:	4c9c                	lw	a5,24(s1)
    80001a96:	d3ed                	beqz	a5,80001a78 <getnproc+0x22>
      count++;
    80001a98:	2905                	addiw	s2,s2,1
      release(&p->lock);
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	00004097          	auipc	ra,0x4
    80001aa0:	7a8080e7          	jalr	1960(ra) # 80006244 <release>
    80001aa4:	bff9                	j	80001a82 <getnproc+0x2c>
    }
  }
  return count;
}
    80001aa6:	854a                	mv	a0,s2
    80001aa8:	70a2                	ld	ra,40(sp)
    80001aaa:	7402                	ld	s0,32(sp)
    80001aac:	64e2                	ld	s1,24(sp)
    80001aae:	6942                	ld	s2,16(sp)
    80001ab0:	69a2                	ld	s3,8(sp)
    80001ab2:	6145                	addi	sp,sp,48
    80001ab4:	8082                	ret

0000000080001ab6 <swtch>:
    80001ab6:	00153023          	sd	ra,0(a0)
    80001aba:	00253423          	sd	sp,8(a0)
    80001abe:	e900                	sd	s0,16(a0)
    80001ac0:	ed04                	sd	s1,24(a0)
    80001ac2:	03253023          	sd	s2,32(a0)
    80001ac6:	03353423          	sd	s3,40(a0)
    80001aca:	03453823          	sd	s4,48(a0)
    80001ace:	03553c23          	sd	s5,56(a0)
    80001ad2:	05653023          	sd	s6,64(a0)
    80001ad6:	05753423          	sd	s7,72(a0)
    80001ada:	05853823          	sd	s8,80(a0)
    80001ade:	05953c23          	sd	s9,88(a0)
    80001ae2:	07a53023          	sd	s10,96(a0)
    80001ae6:	07b53423          	sd	s11,104(a0)
    80001aea:	0005b083          	ld	ra,0(a1)
    80001aee:	0085b103          	ld	sp,8(a1)
    80001af2:	6980                	ld	s0,16(a1)
    80001af4:	6d84                	ld	s1,24(a1)
    80001af6:	0205b903          	ld	s2,32(a1)
    80001afa:	0285b983          	ld	s3,40(a1)
    80001afe:	0305ba03          	ld	s4,48(a1)
    80001b02:	0385ba83          	ld	s5,56(a1)
    80001b06:	0405bb03          	ld	s6,64(a1)
    80001b0a:	0485bb83          	ld	s7,72(a1)
    80001b0e:	0505bc03          	ld	s8,80(a1)
    80001b12:	0585bc83          	ld	s9,88(a1)
    80001b16:	0605bd03          	ld	s10,96(a1)
    80001b1a:	0685bd83          	ld	s11,104(a1)
    80001b1e:	8082                	ret

0000000080001b20 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b20:	1141                	addi	sp,sp,-16
    80001b22:	e406                	sd	ra,8(sp)
    80001b24:	e022                	sd	s0,0(sp)
    80001b26:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b28:	00006597          	auipc	a1,0x6
    80001b2c:	71858593          	addi	a1,a1,1816 # 80008240 <etext+0x240>
    80001b30:	0000d517          	auipc	a0,0xd
    80001b34:	55050513          	addi	a0,a0,1360 # 8000f080 <tickslock>
    80001b38:	00004097          	auipc	ra,0x4
    80001b3c:	5c8080e7          	jalr	1480(ra) # 80006100 <initlock>
}
    80001b40:	60a2                	ld	ra,8(sp)
    80001b42:	6402                	ld	s0,0(sp)
    80001b44:	0141                	addi	sp,sp,16
    80001b46:	8082                	ret

0000000080001b48 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b48:	1141                	addi	sp,sp,-16
    80001b4a:	e422                	sd	s0,8(sp)
    80001b4c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b4e:	00003797          	auipc	a5,0x3
    80001b52:	56278793          	addi	a5,a5,1378 # 800050b0 <kernelvec>
    80001b56:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b5a:	6422                	ld	s0,8(sp)
    80001b5c:	0141                	addi	sp,sp,16
    80001b5e:	8082                	ret

0000000080001b60 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b60:	1141                	addi	sp,sp,-16
    80001b62:	e406                	sd	ra,8(sp)
    80001b64:	e022                	sd	s0,0(sp)
    80001b66:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b68:	fffff097          	auipc	ra,0xfffff
    80001b6c:	324080e7          	jalr	804(ra) # 80000e8c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b70:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b74:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b76:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b7a:	00005617          	auipc	a2,0x5
    80001b7e:	48660613          	addi	a2,a2,1158 # 80007000 <_trampoline>
    80001b82:	00005697          	auipc	a3,0x5
    80001b86:	47e68693          	addi	a3,a3,1150 # 80007000 <_trampoline>
    80001b8a:	8e91                	sub	a3,a3,a2
    80001b8c:	040007b7          	lui	a5,0x4000
    80001b90:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b92:	07b2                	slli	a5,a5,0xc
    80001b94:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b96:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b9a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b9c:	180026f3          	csrr	a3,satp
    80001ba0:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba2:	6d38                	ld	a4,88(a0)
    80001ba4:	6134                	ld	a3,64(a0)
    80001ba6:	6585                	lui	a1,0x1
    80001ba8:	96ae                	add	a3,a3,a1
    80001baa:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bac:	6d38                	ld	a4,88(a0)
    80001bae:	00000697          	auipc	a3,0x0
    80001bb2:	13868693          	addi	a3,a3,312 # 80001ce6 <usertrap>
    80001bb6:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bb8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bba:	8692                	mv	a3,tp
    80001bbc:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bbe:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc2:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bc6:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bca:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bce:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bd0:	6f18                	ld	a4,24(a4)
    80001bd2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bd6:	692c                	ld	a1,80(a0)
    80001bd8:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bda:	00005717          	auipc	a4,0x5
    80001bde:	4b670713          	addi	a4,a4,1206 # 80007090 <userret>
    80001be2:	8f11                	sub	a4,a4,a2
    80001be4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001be6:	577d                	li	a4,-1
    80001be8:	177e                	slli	a4,a4,0x3f
    80001bea:	8dd9                	or	a1,a1,a4
    80001bec:	02000537          	lui	a0,0x2000
    80001bf0:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bf2:	0536                	slli	a0,a0,0xd
    80001bf4:	9782                	jalr	a5
}
    80001bf6:	60a2                	ld	ra,8(sp)
    80001bf8:	6402                	ld	s0,0(sp)
    80001bfa:	0141                	addi	sp,sp,16
    80001bfc:	8082                	ret

0000000080001bfe <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bfe:	1101                	addi	sp,sp,-32
    80001c00:	ec06                	sd	ra,24(sp)
    80001c02:	e822                	sd	s0,16(sp)
    80001c04:	e426                	sd	s1,8(sp)
    80001c06:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c08:	0000d497          	auipc	s1,0xd
    80001c0c:	47848493          	addi	s1,s1,1144 # 8000f080 <tickslock>
    80001c10:	8526                	mv	a0,s1
    80001c12:	00004097          	auipc	ra,0x4
    80001c16:	57e080e7          	jalr	1406(ra) # 80006190 <acquire>
  ticks++;
    80001c1a:	00007517          	auipc	a0,0x7
    80001c1e:	3fe50513          	addi	a0,a0,1022 # 80009018 <ticks>
    80001c22:	411c                	lw	a5,0(a0)
    80001c24:	2785                	addiw	a5,a5,1
    80001c26:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	abc080e7          	jalr	-1348(ra) # 800016e4 <wakeup>
  release(&tickslock);
    80001c30:	8526                	mv	a0,s1
    80001c32:	00004097          	auipc	ra,0x4
    80001c36:	612080e7          	jalr	1554(ra) # 80006244 <release>
}
    80001c3a:	60e2                	ld	ra,24(sp)
    80001c3c:	6442                	ld	s0,16(sp)
    80001c3e:	64a2                	ld	s1,8(sp)
    80001c40:	6105                	addi	sp,sp,32
    80001c42:	8082                	ret

0000000080001c44 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c44:	1101                	addi	sp,sp,-32
    80001c46:	ec06                	sd	ra,24(sp)
    80001c48:	e822                	sd	s0,16(sp)
    80001c4a:	e426                	sd	s1,8(sp)
    80001c4c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c4e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c52:	00074d63          	bltz	a4,80001c6c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c56:	57fd                	li	a5,-1
    80001c58:	17fe                	slli	a5,a5,0x3f
    80001c5a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c5c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c5e:	06f70363          	beq	a4,a5,80001cc4 <devintr+0x80>
  }
}
    80001c62:	60e2                	ld	ra,24(sp)
    80001c64:	6442                	ld	s0,16(sp)
    80001c66:	64a2                	ld	s1,8(sp)
    80001c68:	6105                	addi	sp,sp,32
    80001c6a:	8082                	ret
     (scause & 0xff) == 9){
    80001c6c:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c70:	46a5                	li	a3,9
    80001c72:	fed792e3          	bne	a5,a3,80001c56 <devintr+0x12>
    int irq = plic_claim();
    80001c76:	00003097          	auipc	ra,0x3
    80001c7a:	542080e7          	jalr	1346(ra) # 800051b8 <plic_claim>
    80001c7e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c80:	47a9                	li	a5,10
    80001c82:	02f50763          	beq	a0,a5,80001cb0 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c86:	4785                	li	a5,1
    80001c88:	02f50963          	beq	a0,a5,80001cba <devintr+0x76>
    return 1;
    80001c8c:	4505                	li	a0,1
    } else if(irq){
    80001c8e:	d8f1                	beqz	s1,80001c62 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c90:	85a6                	mv	a1,s1
    80001c92:	00006517          	auipc	a0,0x6
    80001c96:	5b650513          	addi	a0,a0,1462 # 80008248 <etext+0x248>
    80001c9a:	00004097          	auipc	ra,0x4
    80001c9e:	004080e7          	jalr	4(ra) # 80005c9e <printf>
      plic_complete(irq);
    80001ca2:	8526                	mv	a0,s1
    80001ca4:	00003097          	auipc	ra,0x3
    80001ca8:	538080e7          	jalr	1336(ra) # 800051dc <plic_complete>
    return 1;
    80001cac:	4505                	li	a0,1
    80001cae:	bf55                	j	80001c62 <devintr+0x1e>
      uartintr();
    80001cb0:	00004097          	auipc	ra,0x4
    80001cb4:	400080e7          	jalr	1024(ra) # 800060b0 <uartintr>
    80001cb8:	b7ed                	j	80001ca2 <devintr+0x5e>
      virtio_disk_intr();
    80001cba:	00004097          	auipc	ra,0x4
    80001cbe:	9b4080e7          	jalr	-1612(ra) # 8000566e <virtio_disk_intr>
    80001cc2:	b7c5                	j	80001ca2 <devintr+0x5e>
    if(cpuid() == 0){
    80001cc4:	fffff097          	auipc	ra,0xfffff
    80001cc8:	19c080e7          	jalr	412(ra) # 80000e60 <cpuid>
    80001ccc:	c901                	beqz	a0,80001cdc <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cce:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cd2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cd4:	14479073          	csrw	sip,a5
    return 2;
    80001cd8:	4509                	li	a0,2
    80001cda:	b761                	j	80001c62 <devintr+0x1e>
      clockintr();
    80001cdc:	00000097          	auipc	ra,0x0
    80001ce0:	f22080e7          	jalr	-222(ra) # 80001bfe <clockintr>
    80001ce4:	b7ed                	j	80001cce <devintr+0x8a>

0000000080001ce6 <usertrap>:
{
    80001ce6:	1101                	addi	sp,sp,-32
    80001ce8:	ec06                	sd	ra,24(sp)
    80001cea:	e822                	sd	s0,16(sp)
    80001cec:	e426                	sd	s1,8(sp)
    80001cee:	e04a                	sd	s2,0(sp)
    80001cf0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf6:	1007f793          	andi	a5,a5,256
    80001cfa:	e3ad                	bnez	a5,80001d5c <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cfc:	00003797          	auipc	a5,0x3
    80001d00:	3b478793          	addi	a5,a5,948 # 800050b0 <kernelvec>
    80001d04:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d08:	fffff097          	auipc	ra,0xfffff
    80001d0c:	184080e7          	jalr	388(ra) # 80000e8c <myproc>
    80001d10:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d12:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d14:	14102773          	csrr	a4,sepc
    80001d18:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d1a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d1e:	47a1                	li	a5,8
    80001d20:	04f71c63          	bne	a4,a5,80001d78 <usertrap+0x92>
    if(p->killed)
    80001d24:	551c                	lw	a5,40(a0)
    80001d26:	e3b9                	bnez	a5,80001d6c <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d28:	6cb8                	ld	a4,88(s1)
    80001d2a:	6f1c                	ld	a5,24(a4)
    80001d2c:	0791                	addi	a5,a5,4
    80001d2e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d30:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d34:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d38:	10079073          	csrw	sstatus,a5
    syscall();
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	2e0080e7          	jalr	736(ra) # 8000201c <syscall>
  if(p->killed)
    80001d44:	549c                	lw	a5,40(s1)
    80001d46:	ebc1                	bnez	a5,80001dd6 <usertrap+0xf0>
  usertrapret();
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	e18080e7          	jalr	-488(ra) # 80001b60 <usertrapret>
}
    80001d50:	60e2                	ld	ra,24(sp)
    80001d52:	6442                	ld	s0,16(sp)
    80001d54:	64a2                	ld	s1,8(sp)
    80001d56:	6902                	ld	s2,0(sp)
    80001d58:	6105                	addi	sp,sp,32
    80001d5a:	8082                	ret
    panic("usertrap: not from user mode");
    80001d5c:	00006517          	auipc	a0,0x6
    80001d60:	50c50513          	addi	a0,a0,1292 # 80008268 <etext+0x268>
    80001d64:	00004097          	auipc	ra,0x4
    80001d68:	ef0080e7          	jalr	-272(ra) # 80005c54 <panic>
      exit(-1);
    80001d6c:	557d                	li	a0,-1
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	a46080e7          	jalr	-1466(ra) # 800017b4 <exit>
    80001d76:	bf4d                	j	80001d28 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	ecc080e7          	jalr	-308(ra) # 80001c44 <devintr>
    80001d80:	892a                	mv	s2,a0
    80001d82:	c501                	beqz	a0,80001d8a <usertrap+0xa4>
  if(p->killed)
    80001d84:	549c                	lw	a5,40(s1)
    80001d86:	c3a1                	beqz	a5,80001dc6 <usertrap+0xe0>
    80001d88:	a815                	j	80001dbc <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d8a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d8e:	5890                	lw	a2,48(s1)
    80001d90:	00006517          	auipc	a0,0x6
    80001d94:	4f850513          	addi	a0,a0,1272 # 80008288 <etext+0x288>
    80001d98:	00004097          	auipc	ra,0x4
    80001d9c:	f06080e7          	jalr	-250(ra) # 80005c9e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001da4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001da8:	00006517          	auipc	a0,0x6
    80001dac:	51050513          	addi	a0,a0,1296 # 800082b8 <etext+0x2b8>
    80001db0:	00004097          	auipc	ra,0x4
    80001db4:	eee080e7          	jalr	-274(ra) # 80005c9e <printf>
    p->killed = 1;
    80001db8:	4785                	li	a5,1
    80001dba:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001dbc:	557d                	li	a0,-1
    80001dbe:	00000097          	auipc	ra,0x0
    80001dc2:	9f6080e7          	jalr	-1546(ra) # 800017b4 <exit>
  if(which_dev == 2)
    80001dc6:	4789                	li	a5,2
    80001dc8:	f8f910e3          	bne	s2,a5,80001d48 <usertrap+0x62>
    yield();
    80001dcc:	fffff097          	auipc	ra,0xfffff
    80001dd0:	750080e7          	jalr	1872(ra) # 8000151c <yield>
    80001dd4:	bf95                	j	80001d48 <usertrap+0x62>
  int which_dev = 0;
    80001dd6:	4901                	li	s2,0
    80001dd8:	b7d5                	j	80001dbc <usertrap+0xd6>

0000000080001dda <kerneltrap>:
{
    80001dda:	7179                	addi	sp,sp,-48
    80001ddc:	f406                	sd	ra,40(sp)
    80001dde:	f022                	sd	s0,32(sp)
    80001de0:	ec26                	sd	s1,24(sp)
    80001de2:	e84a                	sd	s2,16(sp)
    80001de4:	e44e                	sd	s3,8(sp)
    80001de6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dec:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001df4:	1004f793          	andi	a5,s1,256
    80001df8:	cb85                	beqz	a5,80001e28 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dfa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dfe:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e00:	ef85                	bnez	a5,80001e38 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	e42080e7          	jalr	-446(ra) # 80001c44 <devintr>
    80001e0a:	cd1d                	beqz	a0,80001e48 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e0c:	4789                	li	a5,2
    80001e0e:	06f50a63          	beq	a0,a5,80001e82 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e12:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e16:	10049073          	csrw	sstatus,s1
}
    80001e1a:	70a2                	ld	ra,40(sp)
    80001e1c:	7402                	ld	s0,32(sp)
    80001e1e:	64e2                	ld	s1,24(sp)
    80001e20:	6942                	ld	s2,16(sp)
    80001e22:	69a2                	ld	s3,8(sp)
    80001e24:	6145                	addi	sp,sp,48
    80001e26:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e28:	00006517          	auipc	a0,0x6
    80001e2c:	4b050513          	addi	a0,a0,1200 # 800082d8 <etext+0x2d8>
    80001e30:	00004097          	auipc	ra,0x4
    80001e34:	e24080e7          	jalr	-476(ra) # 80005c54 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e38:	00006517          	auipc	a0,0x6
    80001e3c:	4c850513          	addi	a0,a0,1224 # 80008300 <etext+0x300>
    80001e40:	00004097          	auipc	ra,0x4
    80001e44:	e14080e7          	jalr	-492(ra) # 80005c54 <panic>
    printf("scause %p\n", scause);
    80001e48:	85ce                	mv	a1,s3
    80001e4a:	00006517          	auipc	a0,0x6
    80001e4e:	4d650513          	addi	a0,a0,1238 # 80008320 <etext+0x320>
    80001e52:	00004097          	auipc	ra,0x4
    80001e56:	e4c080e7          	jalr	-436(ra) # 80005c9e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e5a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e5e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e62:	00006517          	auipc	a0,0x6
    80001e66:	4ce50513          	addi	a0,a0,1230 # 80008330 <etext+0x330>
    80001e6a:	00004097          	auipc	ra,0x4
    80001e6e:	e34080e7          	jalr	-460(ra) # 80005c9e <printf>
    panic("kerneltrap");
    80001e72:	00006517          	auipc	a0,0x6
    80001e76:	4d650513          	addi	a0,a0,1238 # 80008348 <etext+0x348>
    80001e7a:	00004097          	auipc	ra,0x4
    80001e7e:	dda080e7          	jalr	-550(ra) # 80005c54 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e82:	fffff097          	auipc	ra,0xfffff
    80001e86:	00a080e7          	jalr	10(ra) # 80000e8c <myproc>
    80001e8a:	d541                	beqz	a0,80001e12 <kerneltrap+0x38>
    80001e8c:	fffff097          	auipc	ra,0xfffff
    80001e90:	000080e7          	jalr	ra # 80000e8c <myproc>
    80001e94:	4d18                	lw	a4,24(a0)
    80001e96:	4791                	li	a5,4
    80001e98:	f6f71de3          	bne	a4,a5,80001e12 <kerneltrap+0x38>
    yield();
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	680080e7          	jalr	1664(ra) # 8000151c <yield>
    80001ea4:	b7bd                	j	80001e12 <kerneltrap+0x38>

0000000080001ea6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ea6:	1101                	addi	sp,sp,-32
    80001ea8:	ec06                	sd	ra,24(sp)
    80001eaa:	e822                	sd	s0,16(sp)
    80001eac:	e426                	sd	s1,8(sp)
    80001eae:	1000                	addi	s0,sp,32
    80001eb0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eb2:	fffff097          	auipc	ra,0xfffff
    80001eb6:	fda080e7          	jalr	-38(ra) # 80000e8c <myproc>
  switch (n) {
    80001eba:	4795                	li	a5,5
    80001ebc:	0497e163          	bltu	a5,s1,80001efe <argraw+0x58>
    80001ec0:	048a                	slli	s1,s1,0x2
    80001ec2:	00007717          	auipc	a4,0x7
    80001ec6:	92e70713          	addi	a4,a4,-1746 # 800087f0 <states.0+0x30>
    80001eca:	94ba                	add	s1,s1,a4
    80001ecc:	409c                	lw	a5,0(s1)
    80001ece:	97ba                	add	a5,a5,a4
    80001ed0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ed2:	6d3c                	ld	a5,88(a0)
    80001ed4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ed6:	60e2                	ld	ra,24(sp)
    80001ed8:	6442                	ld	s0,16(sp)
    80001eda:	64a2                	ld	s1,8(sp)
    80001edc:	6105                	addi	sp,sp,32
    80001ede:	8082                	ret
    return p->trapframe->a1;
    80001ee0:	6d3c                	ld	a5,88(a0)
    80001ee2:	7fa8                	ld	a0,120(a5)
    80001ee4:	bfcd                	j	80001ed6 <argraw+0x30>
    return p->trapframe->a2;
    80001ee6:	6d3c                	ld	a5,88(a0)
    80001ee8:	63c8                	ld	a0,128(a5)
    80001eea:	b7f5                	j	80001ed6 <argraw+0x30>
    return p->trapframe->a3;
    80001eec:	6d3c                	ld	a5,88(a0)
    80001eee:	67c8                	ld	a0,136(a5)
    80001ef0:	b7dd                	j	80001ed6 <argraw+0x30>
    return p->trapframe->a4;
    80001ef2:	6d3c                	ld	a5,88(a0)
    80001ef4:	6bc8                	ld	a0,144(a5)
    80001ef6:	b7c5                	j	80001ed6 <argraw+0x30>
    return p->trapframe->a5;
    80001ef8:	6d3c                	ld	a5,88(a0)
    80001efa:	6fc8                	ld	a0,152(a5)
    80001efc:	bfe9                	j	80001ed6 <argraw+0x30>
  panic("argraw");
    80001efe:	00006517          	auipc	a0,0x6
    80001f02:	45a50513          	addi	a0,a0,1114 # 80008358 <etext+0x358>
    80001f06:	00004097          	auipc	ra,0x4
    80001f0a:	d4e080e7          	jalr	-690(ra) # 80005c54 <panic>

0000000080001f0e <fetchaddr>:
{
    80001f0e:	1101                	addi	sp,sp,-32
    80001f10:	ec06                	sd	ra,24(sp)
    80001f12:	e822                	sd	s0,16(sp)
    80001f14:	e426                	sd	s1,8(sp)
    80001f16:	e04a                	sd	s2,0(sp)
    80001f18:	1000                	addi	s0,sp,32
    80001f1a:	84aa                	mv	s1,a0
    80001f1c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	f6e080e7          	jalr	-146(ra) # 80000e8c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f26:	653c                	ld	a5,72(a0)
    80001f28:	02f4f863          	bgeu	s1,a5,80001f58 <fetchaddr+0x4a>
    80001f2c:	00848713          	addi	a4,s1,8
    80001f30:	02e7e663          	bltu	a5,a4,80001f5c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f34:	46a1                	li	a3,8
    80001f36:	8626                	mv	a2,s1
    80001f38:	85ca                	mv	a1,s2
    80001f3a:	6928                	ld	a0,80(a0)
    80001f3c:	fffff097          	auipc	ra,0xfffff
    80001f40:	c9c080e7          	jalr	-868(ra) # 80000bd8 <copyin>
    80001f44:	00a03533          	snez	a0,a0
    80001f48:	40a00533          	neg	a0,a0
}
    80001f4c:	60e2                	ld	ra,24(sp)
    80001f4e:	6442                	ld	s0,16(sp)
    80001f50:	64a2                	ld	s1,8(sp)
    80001f52:	6902                	ld	s2,0(sp)
    80001f54:	6105                	addi	sp,sp,32
    80001f56:	8082                	ret
    return -1;
    80001f58:	557d                	li	a0,-1
    80001f5a:	bfcd                	j	80001f4c <fetchaddr+0x3e>
    80001f5c:	557d                	li	a0,-1
    80001f5e:	b7fd                	j	80001f4c <fetchaddr+0x3e>

0000000080001f60 <fetchstr>:
{
    80001f60:	7179                	addi	sp,sp,-48
    80001f62:	f406                	sd	ra,40(sp)
    80001f64:	f022                	sd	s0,32(sp)
    80001f66:	ec26                	sd	s1,24(sp)
    80001f68:	e84a                	sd	s2,16(sp)
    80001f6a:	e44e                	sd	s3,8(sp)
    80001f6c:	1800                	addi	s0,sp,48
    80001f6e:	892a                	mv	s2,a0
    80001f70:	84ae                	mv	s1,a1
    80001f72:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	f18080e7          	jalr	-232(ra) # 80000e8c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f7c:	86ce                	mv	a3,s3
    80001f7e:	864a                	mv	a2,s2
    80001f80:	85a6                	mv	a1,s1
    80001f82:	6928                	ld	a0,80(a0)
    80001f84:	fffff097          	auipc	ra,0xfffff
    80001f88:	ce2080e7          	jalr	-798(ra) # 80000c66 <copyinstr>
  if(err < 0)
    80001f8c:	00054763          	bltz	a0,80001f9a <fetchstr+0x3a>
  return strlen(buf);
    80001f90:	8526                	mv	a0,s1
    80001f92:	ffffe097          	auipc	ra,0xffffe
    80001f96:	3ac080e7          	jalr	940(ra) # 8000033e <strlen>
}
    80001f9a:	70a2                	ld	ra,40(sp)
    80001f9c:	7402                	ld	s0,32(sp)
    80001f9e:	64e2                	ld	s1,24(sp)
    80001fa0:	6942                	ld	s2,16(sp)
    80001fa2:	69a2                	ld	s3,8(sp)
    80001fa4:	6145                	addi	sp,sp,48
    80001fa6:	8082                	ret

0000000080001fa8 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fa8:	1101                	addi	sp,sp,-32
    80001faa:	ec06                	sd	ra,24(sp)
    80001fac:	e822                	sd	s0,16(sp)
    80001fae:	e426                	sd	s1,8(sp)
    80001fb0:	1000                	addi	s0,sp,32
    80001fb2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fb4:	00000097          	auipc	ra,0x0
    80001fb8:	ef2080e7          	jalr	-270(ra) # 80001ea6 <argraw>
    80001fbc:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fbe:	4501                	li	a0,0
    80001fc0:	60e2                	ld	ra,24(sp)
    80001fc2:	6442                	ld	s0,16(sp)
    80001fc4:	64a2                	ld	s1,8(sp)
    80001fc6:	6105                	addi	sp,sp,32
    80001fc8:	8082                	ret

0000000080001fca <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fca:	1101                	addi	sp,sp,-32
    80001fcc:	ec06                	sd	ra,24(sp)
    80001fce:	e822                	sd	s0,16(sp)
    80001fd0:	e426                	sd	s1,8(sp)
    80001fd2:	1000                	addi	s0,sp,32
    80001fd4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	ed0080e7          	jalr	-304(ra) # 80001ea6 <argraw>
    80001fde:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fe0:	4501                	li	a0,0
    80001fe2:	60e2                	ld	ra,24(sp)
    80001fe4:	6442                	ld	s0,16(sp)
    80001fe6:	64a2                	ld	s1,8(sp)
    80001fe8:	6105                	addi	sp,sp,32
    80001fea:	8082                	ret

0000000080001fec <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fec:	1101                	addi	sp,sp,-32
    80001fee:	ec06                	sd	ra,24(sp)
    80001ff0:	e822                	sd	s0,16(sp)
    80001ff2:	e426                	sd	s1,8(sp)
    80001ff4:	e04a                	sd	s2,0(sp)
    80001ff6:	1000                	addi	s0,sp,32
    80001ff8:	84ae                	mv	s1,a1
    80001ffa:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	eaa080e7          	jalr	-342(ra) # 80001ea6 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002004:	864a                	mv	a2,s2
    80002006:	85a6                	mv	a1,s1
    80002008:	00000097          	auipc	ra,0x0
    8000200c:	f58080e7          	jalr	-168(ra) # 80001f60 <fetchstr>
}
    80002010:	60e2                	ld	ra,24(sp)
    80002012:	6442                	ld	s0,16(sp)
    80002014:	64a2                	ld	s1,8(sp)
    80002016:	6902                	ld	s2,0(sp)
    80002018:	6105                	addi	sp,sp,32
    8000201a:	8082                	ret

000000008000201c <syscall>:
  "sysinfo",
};

void
syscall(void)
{
    8000201c:	7179                	addi	sp,sp,-48
    8000201e:	f406                	sd	ra,40(sp)
    80002020:	f022                	sd	s0,32(sp)
    80002022:	ec26                	sd	s1,24(sp)
    80002024:	e84a                	sd	s2,16(sp)
    80002026:	e44e                	sd	s3,8(sp)
    80002028:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	e62080e7          	jalr	-414(ra) # 80000e8c <myproc>
    80002032:	84aa                	mv	s1,a0

  // 从 trapframe 的 a7 寄存器中获取系统调用编号
  num = p->trapframe->a7;
    80002034:	05853903          	ld	s2,88(a0)
    80002038:	0a893783          	ld	a5,168(s2)
    8000203c:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002040:	37fd                	addiw	a5,a5,-1
    80002042:	4759                	li	a4,22
    80002044:	04f76863          	bltu	a4,a5,80002094 <syscall+0x78>
    80002048:	00399713          	slli	a4,s3,0x3
    8000204c:	00006797          	auipc	a5,0x6
    80002050:	7bc78793          	addi	a5,a5,1980 # 80008808 <syscalls>
    80002054:	97ba                	add	a5,a5,a4
    80002056:	639c                	ld	a5,0(a5)
    80002058:	cf95                	beqz	a5,80002094 <syscall+0x78>
    // 如果调用号有效，则从分派表中调用对应的处理函数
    p->trapframe->a0 = syscalls[num]();
    8000205a:	9782                	jalr	a5
    8000205c:	06a93823          	sd	a0,112(s2)

    // --- trace 功能的核心实现 ---
    // 检查当前进程的追踪掩码 tracemask 的第 num 位是否为1
    // (p->tracemask >> num) 将第 num 位移动到最低位
    // & 1 取出最低位的值
    if (p->tracemask >> num & 1)
    80002060:	1684a783          	lw	a5,360(s1)
    80002064:	4137d7bb          	sraw	a5,a5,s3
    80002068:	8b85                	andi	a5,a5,1
    8000206a:	c7a1                	beqz	a5,800020b2 <syscall+0x96>
    {
      // 如果该位为1，则打印追踪信息
      printf("%d: syscall %s -> %d\n",
    8000206c:	6cb8                	ld	a4,88(s1)
    8000206e:	098e                	slli	s3,s3,0x3
    80002070:	00007797          	auipc	a5,0x7
    80002074:	8b878793          	addi	a5,a5,-1864 # 80008928 <syscallnames>
    80002078:	99be                	add	s3,s3,a5
    8000207a:	7b34                	ld	a3,112(a4)
    8000207c:	0009b603          	ld	a2,0(s3)
    80002080:	588c                	lw	a1,48(s1)
    80002082:	00006517          	auipc	a0,0x6
    80002086:	2de50513          	addi	a0,a0,734 # 80008360 <etext+0x360>
    8000208a:	00004097          	auipc	ra,0x4
    8000208e:	c14080e7          	jalr	-1004(ra) # 80005c9e <printf>
    80002092:	a005                	j	800020b2 <syscall+0x96>
      p->pid, syscallnames[num], p->trapframe->a0);
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002094:	86ce                	mv	a3,s3
    80002096:	15848613          	addi	a2,s1,344
    8000209a:	588c                	lw	a1,48(s1)
    8000209c:	00006517          	auipc	a0,0x6
    800020a0:	2dc50513          	addi	a0,a0,732 # 80008378 <etext+0x378>
    800020a4:	00004097          	auipc	ra,0x4
    800020a8:	bfa080e7          	jalr	-1030(ra) # 80005c9e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020ac:	6cbc                	ld	a5,88(s1)
    800020ae:	577d                	li	a4,-1
    800020b0:	fbb8                	sd	a4,112(a5)
  }
}
    800020b2:	70a2                	ld	ra,40(sp)
    800020b4:	7402                	ld	s0,32(sp)
    800020b6:	64e2                	ld	s1,24(sp)
    800020b8:	6942                	ld	s2,16(sp)
    800020ba:	69a2                	ld	s3,8(sp)
    800020bc:	6145                	addi	sp,sp,48
    800020be:	8082                	ret

00000000800020c0 <sys_exit>:
extern int getnproc(void);
extern int getfreemem(void);

uint64
sys_exit(void)
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020c8:	fec40593          	addi	a1,s0,-20
    800020cc:	4501                	li	a0,0
    800020ce:	00000097          	auipc	ra,0x0
    800020d2:	eda080e7          	jalr	-294(ra) # 80001fa8 <argint>
    return -1;
    800020d6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d8:	00054963          	bltz	a0,800020ea <sys_exit+0x2a>
  exit(n);
    800020dc:	fec42503          	lw	a0,-20(s0)
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	6d4080e7          	jalr	1748(ra) # 800017b4 <exit>
  return 0;  // not reached
    800020e8:	4781                	li	a5,0
}
    800020ea:	853e                	mv	a0,a5
    800020ec:	60e2                	ld	ra,24(sp)
    800020ee:	6442                	ld	s0,16(sp)
    800020f0:	6105                	addi	sp,sp,32
    800020f2:	8082                	ret

00000000800020f4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020f4:	1141                	addi	sp,sp,-16
    800020f6:	e406                	sd	ra,8(sp)
    800020f8:	e022                	sd	s0,0(sp)
    800020fa:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	d90080e7          	jalr	-624(ra) # 80000e8c <myproc>
}
    80002104:	5908                	lw	a0,48(a0)
    80002106:	60a2                	ld	ra,8(sp)
    80002108:	6402                	ld	s0,0(sp)
    8000210a:	0141                	addi	sp,sp,16
    8000210c:	8082                	ret

000000008000210e <sys_fork>:

uint64
sys_fork(void)
{
    8000210e:	1141                	addi	sp,sp,-16
    80002110:	e406                	sd	ra,8(sp)
    80002112:	e022                	sd	s0,0(sp)
    80002114:	0800                	addi	s0,sp,16
  return fork();
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	148080e7          	jalr	328(ra) # 8000125e <fork>
}
    8000211e:	60a2                	ld	ra,8(sp)
    80002120:	6402                	ld	s0,0(sp)
    80002122:	0141                	addi	sp,sp,16
    80002124:	8082                	ret

0000000080002126 <sys_wait>:

uint64
sys_wait(void)
{
    80002126:	1101                	addi	sp,sp,-32
    80002128:	ec06                	sd	ra,24(sp)
    8000212a:	e822                	sd	s0,16(sp)
    8000212c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000212e:	fe840593          	addi	a1,s0,-24
    80002132:	4501                	li	a0,0
    80002134:	00000097          	auipc	ra,0x0
    80002138:	e96080e7          	jalr	-362(ra) # 80001fca <argaddr>
    8000213c:	87aa                	mv	a5,a0
    return -1;
    8000213e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002140:	0007c863          	bltz	a5,80002150 <sys_wait+0x2a>
  return wait(p);
    80002144:	fe843503          	ld	a0,-24(s0)
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	474080e7          	jalr	1140(ra) # 800015bc <wait>
}
    80002150:	60e2                	ld	ra,24(sp)
    80002152:	6442                	ld	s0,16(sp)
    80002154:	6105                	addi	sp,sp,32
    80002156:	8082                	ret

0000000080002158 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002158:	7179                	addi	sp,sp,-48
    8000215a:	f406                	sd	ra,40(sp)
    8000215c:	f022                	sd	s0,32(sp)
    8000215e:	ec26                	sd	s1,24(sp)
    80002160:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002162:	fdc40593          	addi	a1,s0,-36
    80002166:	4501                	li	a0,0
    80002168:	00000097          	auipc	ra,0x0
    8000216c:	e40080e7          	jalr	-448(ra) # 80001fa8 <argint>
    return -1;
    80002170:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002172:	00054f63          	bltz	a0,80002190 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	d16080e7          	jalr	-746(ra) # 80000e8c <myproc>
    8000217e:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002180:	fdc42503          	lw	a0,-36(s0)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	066080e7          	jalr	102(ra) # 800011ea <growproc>
    8000218c:	00054863          	bltz	a0,8000219c <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002190:	8526                	mv	a0,s1
    80002192:	70a2                	ld	ra,40(sp)
    80002194:	7402                	ld	s0,32(sp)
    80002196:	64e2                	ld	s1,24(sp)
    80002198:	6145                	addi	sp,sp,48
    8000219a:	8082                	ret
    return -1;
    8000219c:	54fd                	li	s1,-1
    8000219e:	bfcd                	j	80002190 <sys_sbrk+0x38>

00000000800021a0 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021a0:	7139                	addi	sp,sp,-64
    800021a2:	fc06                	sd	ra,56(sp)
    800021a4:	f822                	sd	s0,48(sp)
    800021a6:	f426                	sd	s1,40(sp)
    800021a8:	f04a                	sd	s2,32(sp)
    800021aa:	ec4e                	sd	s3,24(sp)
    800021ac:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021ae:	fcc40593          	addi	a1,s0,-52
    800021b2:	4501                	li	a0,0
    800021b4:	00000097          	auipc	ra,0x0
    800021b8:	df4080e7          	jalr	-524(ra) # 80001fa8 <argint>
    return -1;
    800021bc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021be:	06054563          	bltz	a0,80002228 <sys_sleep+0x88>
  acquire(&tickslock);
    800021c2:	0000d517          	auipc	a0,0xd
    800021c6:	ebe50513          	addi	a0,a0,-322 # 8000f080 <tickslock>
    800021ca:	00004097          	auipc	ra,0x4
    800021ce:	fc6080e7          	jalr	-58(ra) # 80006190 <acquire>
  ticks0 = ticks;
    800021d2:	00007917          	auipc	s2,0x7
    800021d6:	e4692903          	lw	s2,-442(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021da:	fcc42783          	lw	a5,-52(s0)
    800021de:	cf85                	beqz	a5,80002216 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021e0:	0000d997          	auipc	s3,0xd
    800021e4:	ea098993          	addi	s3,s3,-352 # 8000f080 <tickslock>
    800021e8:	00007497          	auipc	s1,0x7
    800021ec:	e3048493          	addi	s1,s1,-464 # 80009018 <ticks>
    if(myproc()->killed){
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	c9c080e7          	jalr	-868(ra) # 80000e8c <myproc>
    800021f8:	551c                	lw	a5,40(a0)
    800021fa:	ef9d                	bnez	a5,80002238 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021fc:	85ce                	mv	a1,s3
    800021fe:	8526                	mv	a0,s1
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	358080e7          	jalr	856(ra) # 80001558 <sleep>
  while(ticks - ticks0 < n){
    80002208:	409c                	lw	a5,0(s1)
    8000220a:	412787bb          	subw	a5,a5,s2
    8000220e:	fcc42703          	lw	a4,-52(s0)
    80002212:	fce7efe3          	bltu	a5,a4,800021f0 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002216:	0000d517          	auipc	a0,0xd
    8000221a:	e6a50513          	addi	a0,a0,-406 # 8000f080 <tickslock>
    8000221e:	00004097          	auipc	ra,0x4
    80002222:	026080e7          	jalr	38(ra) # 80006244 <release>
  return 0;
    80002226:	4781                	li	a5,0
}
    80002228:	853e                	mv	a0,a5
    8000222a:	70e2                	ld	ra,56(sp)
    8000222c:	7442                	ld	s0,48(sp)
    8000222e:	74a2                	ld	s1,40(sp)
    80002230:	7902                	ld	s2,32(sp)
    80002232:	69e2                	ld	s3,24(sp)
    80002234:	6121                	addi	sp,sp,64
    80002236:	8082                	ret
      release(&tickslock);
    80002238:	0000d517          	auipc	a0,0xd
    8000223c:	e4850513          	addi	a0,a0,-440 # 8000f080 <tickslock>
    80002240:	00004097          	auipc	ra,0x4
    80002244:	004080e7          	jalr	4(ra) # 80006244 <release>
      return -1;
    80002248:	57fd                	li	a5,-1
    8000224a:	bff9                	j	80002228 <sys_sleep+0x88>

000000008000224c <sys_kill>:

uint64
sys_kill(void)
{
    8000224c:	1101                	addi	sp,sp,-32
    8000224e:	ec06                	sd	ra,24(sp)
    80002250:	e822                	sd	s0,16(sp)
    80002252:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002254:	fec40593          	addi	a1,s0,-20
    80002258:	4501                	li	a0,0
    8000225a:	00000097          	auipc	ra,0x0
    8000225e:	d4e080e7          	jalr	-690(ra) # 80001fa8 <argint>
    80002262:	87aa                	mv	a5,a0
    return -1;
    80002264:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002266:	0007c863          	bltz	a5,80002276 <sys_kill+0x2a>
  return kill(pid);
    8000226a:	fec42503          	lw	a0,-20(s0)
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	61c080e7          	jalr	1564(ra) # 8000188a <kill>
}
    80002276:	60e2                	ld	ra,24(sp)
    80002278:	6442                	ld	s0,16(sp)
    8000227a:	6105                	addi	sp,sp,32
    8000227c:	8082                	ret

000000008000227e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000227e:	1101                	addi	sp,sp,-32
    80002280:	ec06                	sd	ra,24(sp)
    80002282:	e822                	sd	s0,16(sp)
    80002284:	e426                	sd	s1,8(sp)
    80002286:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002288:	0000d517          	auipc	a0,0xd
    8000228c:	df850513          	addi	a0,a0,-520 # 8000f080 <tickslock>
    80002290:	00004097          	auipc	ra,0x4
    80002294:	f00080e7          	jalr	-256(ra) # 80006190 <acquire>
  xticks = ticks;
    80002298:	00007497          	auipc	s1,0x7
    8000229c:	d804a483          	lw	s1,-640(s1) # 80009018 <ticks>
  release(&tickslock);
    800022a0:	0000d517          	auipc	a0,0xd
    800022a4:	de050513          	addi	a0,a0,-544 # 8000f080 <tickslock>
    800022a8:	00004097          	auipc	ra,0x4
    800022ac:	f9c080e7          	jalr	-100(ra) # 80006244 <release>
  return xticks;
}
    800022b0:	02049513          	slli	a0,s1,0x20
    800022b4:	9101                	srli	a0,a0,0x20
    800022b6:	60e2                	ld	ra,24(sp)
    800022b8:	6442                	ld	s0,16(sp)
    800022ba:	64a2                	ld	s1,8(sp)
    800022bc:	6105                	addi	sp,sp,32
    800022be:	8082                	ret

00000000800022c0 <sys_trace>:

uint64
sys_trace(void)
{
    800022c0:	1101                	addi	sp,sp,-32
    800022c2:	ec06                	sd	ra,24(sp)
    800022c4:	e822                	sd	s0,16(sp)
    800022c6:	1000                	addi	s0,sp,32
  int mask;
  // 从用户空间获取第一个参数（掩码）并存入 mask 变量。
  argint(0, &mask);
    800022c8:	fec40593          	addi	a1,s0,-20
    800022cc:	4501                	li	a0,0
    800022ce:	00000097          	auipc	ra,0x0
    800022d2:	cda080e7          	jalr	-806(ra) # 80001fa8 <argint>
  // 将获取到的掩码保存到当前进程的 tracemask 字段中。
  myproc()->tracemask = mask;
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	bb6080e7          	jalr	-1098(ra) # 80000e8c <myproc>
    800022de:	fec42783          	lw	a5,-20(s0)
    800022e2:	16f52423          	sw	a5,360(a0)
  // 返回0，代表系统调用成功。
  return 0;
}
    800022e6:	4501                	li	a0,0
    800022e8:	60e2                	ld	ra,24(sp)
    800022ea:	6442                	ld	s0,16(sp)
    800022ec:	6105                	addi	sp,sp,32
    800022ee:	8082                	ret

00000000800022f0 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    800022f0:	7139                	addi	sp,sp,-64
    800022f2:	fc06                	sd	ra,56(sp)
    800022f4:	f822                	sd	s0,48(sp)
    800022f6:	f426                	sd	s1,40(sp)
    800022f8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800022fa:	fffff097          	auipc	ra,0xfffff
    800022fe:	b92080e7          	jalr	-1134(ra) # 80000e8c <myproc>
    80002302:	84aa                	mv	s1,a0
  struct sysinfo st;
  uint64 addr; // 用于存储用户传入的、指向 sysinfo 结构体的指针

  // 调用辅助函数，获取空闲内存和进程数，并填充到内核的结构体中
  st.freemem = getfreemem();
    80002304:	ffffe097          	auipc	ra,0xffffe
    80002308:	e74080e7          	jalr	-396(ra) # 80000178 <getfreemem>
    8000230c:	fca43823          	sd	a0,-48(s0)
  st.nproc = getnproc();
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	746080e7          	jalr	1862(ra) # 80001a56 <getnproc>
    80002318:	fca43c23          	sd	a0,-40(s0)

  // 获取用户传入的地址参数
  if (argaddr(0, &addr) < 0)
    8000231c:	fc840593          	addi	a1,s0,-56
    80002320:	4501                	li	a0,0
    80002322:	00000097          	auipc	ra,0x0
    80002326:	ca8080e7          	jalr	-856(ra) # 80001fca <argaddr>
      return -1;
    8000232a:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0)
    8000232c:	00054e63          	bltz	a0,80002348 <sys_sysinfo+0x58>
  // 将内核中准备好的结构体内容，拷贝到用户空间指定的地址
  if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80002330:	46c1                	li	a3,16
    80002332:	fd040613          	addi	a2,s0,-48
    80002336:	fc843583          	ld	a1,-56(s0)
    8000233a:	68a8                	ld	a0,80(s1)
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	810080e7          	jalr	-2032(ra) # 80000b4c <copyout>
    80002344:	43f55793          	srai	a5,a0,0x3f
      return -1;
  return 0;
}
    80002348:	853e                	mv	a0,a5
    8000234a:	70e2                	ld	ra,56(sp)
    8000234c:	7442                	ld	s0,48(sp)
    8000234e:	74a2                	ld	s1,40(sp)
    80002350:	6121                	addi	sp,sp,64
    80002352:	8082                	ret

0000000080002354 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002354:	7179                	addi	sp,sp,-48
    80002356:	f406                	sd	ra,40(sp)
    80002358:	f022                	sd	s0,32(sp)
    8000235a:	ec26                	sd	s1,24(sp)
    8000235c:	e84a                	sd	s2,16(sp)
    8000235e:	e44e                	sd	s3,8(sp)
    80002360:	e052                	sd	s4,0(sp)
    80002362:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002364:	00006597          	auipc	a1,0x6
    80002368:	0e458593          	addi	a1,a1,228 # 80008448 <etext+0x448>
    8000236c:	0000d517          	auipc	a0,0xd
    80002370:	d2c50513          	addi	a0,a0,-724 # 8000f098 <bcache>
    80002374:	00004097          	auipc	ra,0x4
    80002378:	d8c080e7          	jalr	-628(ra) # 80006100 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000237c:	00015797          	auipc	a5,0x15
    80002380:	d1c78793          	addi	a5,a5,-740 # 80017098 <bcache+0x8000>
    80002384:	00015717          	auipc	a4,0x15
    80002388:	f7c70713          	addi	a4,a4,-132 # 80017300 <bcache+0x8268>
    8000238c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002390:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002394:	0000d497          	auipc	s1,0xd
    80002398:	d1c48493          	addi	s1,s1,-740 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000239c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000239e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023a0:	00006a17          	auipc	s4,0x6
    800023a4:	0b0a0a13          	addi	s4,s4,176 # 80008450 <etext+0x450>
    b->next = bcache.head.next;
    800023a8:	2b893783          	ld	a5,696(s2)
    800023ac:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023ae:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023b2:	85d2                	mv	a1,s4
    800023b4:	01048513          	addi	a0,s1,16
    800023b8:	00001097          	auipc	ra,0x1
    800023bc:	4bc080e7          	jalr	1212(ra) # 80003874 <initsleeplock>
    bcache.head.next->prev = b;
    800023c0:	2b893783          	ld	a5,696(s2)
    800023c4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023c6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ca:	45848493          	addi	s1,s1,1112
    800023ce:	fd349de3          	bne	s1,s3,800023a8 <binit+0x54>
  }
}
    800023d2:	70a2                	ld	ra,40(sp)
    800023d4:	7402                	ld	s0,32(sp)
    800023d6:	64e2                	ld	s1,24(sp)
    800023d8:	6942                	ld	s2,16(sp)
    800023da:	69a2                	ld	s3,8(sp)
    800023dc:	6a02                	ld	s4,0(sp)
    800023de:	6145                	addi	sp,sp,48
    800023e0:	8082                	ret

00000000800023e2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023e2:	7179                	addi	sp,sp,-48
    800023e4:	f406                	sd	ra,40(sp)
    800023e6:	f022                	sd	s0,32(sp)
    800023e8:	ec26                	sd	s1,24(sp)
    800023ea:	e84a                	sd	s2,16(sp)
    800023ec:	e44e                	sd	s3,8(sp)
    800023ee:	1800                	addi	s0,sp,48
    800023f0:	892a                	mv	s2,a0
    800023f2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023f4:	0000d517          	auipc	a0,0xd
    800023f8:	ca450513          	addi	a0,a0,-860 # 8000f098 <bcache>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	d94080e7          	jalr	-620(ra) # 80006190 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002404:	00015497          	auipc	s1,0x15
    80002408:	f4c4b483          	ld	s1,-180(s1) # 80017350 <bcache+0x82b8>
    8000240c:	00015797          	auipc	a5,0x15
    80002410:	ef478793          	addi	a5,a5,-268 # 80017300 <bcache+0x8268>
    80002414:	02f48f63          	beq	s1,a5,80002452 <bread+0x70>
    80002418:	873e                	mv	a4,a5
    8000241a:	a021                	j	80002422 <bread+0x40>
    8000241c:	68a4                	ld	s1,80(s1)
    8000241e:	02e48a63          	beq	s1,a4,80002452 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002422:	449c                	lw	a5,8(s1)
    80002424:	ff279ce3          	bne	a5,s2,8000241c <bread+0x3a>
    80002428:	44dc                	lw	a5,12(s1)
    8000242a:	ff3799e3          	bne	a5,s3,8000241c <bread+0x3a>
      b->refcnt++;
    8000242e:	40bc                	lw	a5,64(s1)
    80002430:	2785                	addiw	a5,a5,1
    80002432:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002434:	0000d517          	auipc	a0,0xd
    80002438:	c6450513          	addi	a0,a0,-924 # 8000f098 <bcache>
    8000243c:	00004097          	auipc	ra,0x4
    80002440:	e08080e7          	jalr	-504(ra) # 80006244 <release>
      acquiresleep(&b->lock);
    80002444:	01048513          	addi	a0,s1,16
    80002448:	00001097          	auipc	ra,0x1
    8000244c:	466080e7          	jalr	1126(ra) # 800038ae <acquiresleep>
      return b;
    80002450:	a8b9                	j	800024ae <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002452:	00015497          	auipc	s1,0x15
    80002456:	ef64b483          	ld	s1,-266(s1) # 80017348 <bcache+0x82b0>
    8000245a:	00015797          	auipc	a5,0x15
    8000245e:	ea678793          	addi	a5,a5,-346 # 80017300 <bcache+0x8268>
    80002462:	00f48863          	beq	s1,a5,80002472 <bread+0x90>
    80002466:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002468:	40bc                	lw	a5,64(s1)
    8000246a:	cf81                	beqz	a5,80002482 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000246c:	64a4                	ld	s1,72(s1)
    8000246e:	fee49de3          	bne	s1,a4,80002468 <bread+0x86>
  panic("bget: no buffers");
    80002472:	00006517          	auipc	a0,0x6
    80002476:	fe650513          	addi	a0,a0,-26 # 80008458 <etext+0x458>
    8000247a:	00003097          	auipc	ra,0x3
    8000247e:	7da080e7          	jalr	2010(ra) # 80005c54 <panic>
      b->dev = dev;
    80002482:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002486:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000248a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000248e:	4785                	li	a5,1
    80002490:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002492:	0000d517          	auipc	a0,0xd
    80002496:	c0650513          	addi	a0,a0,-1018 # 8000f098 <bcache>
    8000249a:	00004097          	auipc	ra,0x4
    8000249e:	daa080e7          	jalr	-598(ra) # 80006244 <release>
      acquiresleep(&b->lock);
    800024a2:	01048513          	addi	a0,s1,16
    800024a6:	00001097          	auipc	ra,0x1
    800024aa:	408080e7          	jalr	1032(ra) # 800038ae <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024ae:	409c                	lw	a5,0(s1)
    800024b0:	cb89                	beqz	a5,800024c2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024b2:	8526                	mv	a0,s1
    800024b4:	70a2                	ld	ra,40(sp)
    800024b6:	7402                	ld	s0,32(sp)
    800024b8:	64e2                	ld	s1,24(sp)
    800024ba:	6942                	ld	s2,16(sp)
    800024bc:	69a2                	ld	s3,8(sp)
    800024be:	6145                	addi	sp,sp,48
    800024c0:	8082                	ret
    virtio_disk_rw(b, 0);
    800024c2:	4581                	li	a1,0
    800024c4:	8526                	mv	a0,s1
    800024c6:	00003097          	auipc	ra,0x3
    800024ca:	f20080e7          	jalr	-224(ra) # 800053e6 <virtio_disk_rw>
    b->valid = 1;
    800024ce:	4785                	li	a5,1
    800024d0:	c09c                	sw	a5,0(s1)
  return b;
    800024d2:	b7c5                	j	800024b2 <bread+0xd0>

00000000800024d4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024d4:	1101                	addi	sp,sp,-32
    800024d6:	ec06                	sd	ra,24(sp)
    800024d8:	e822                	sd	s0,16(sp)
    800024da:	e426                	sd	s1,8(sp)
    800024dc:	1000                	addi	s0,sp,32
    800024de:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e0:	0541                	addi	a0,a0,16
    800024e2:	00001097          	auipc	ra,0x1
    800024e6:	466080e7          	jalr	1126(ra) # 80003948 <holdingsleep>
    800024ea:	cd01                	beqz	a0,80002502 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ec:	4585                	li	a1,1
    800024ee:	8526                	mv	a0,s1
    800024f0:	00003097          	auipc	ra,0x3
    800024f4:	ef6080e7          	jalr	-266(ra) # 800053e6 <virtio_disk_rw>
}
    800024f8:	60e2                	ld	ra,24(sp)
    800024fa:	6442                	ld	s0,16(sp)
    800024fc:	64a2                	ld	s1,8(sp)
    800024fe:	6105                	addi	sp,sp,32
    80002500:	8082                	ret
    panic("bwrite");
    80002502:	00006517          	auipc	a0,0x6
    80002506:	f6e50513          	addi	a0,a0,-146 # 80008470 <etext+0x470>
    8000250a:	00003097          	auipc	ra,0x3
    8000250e:	74a080e7          	jalr	1866(ra) # 80005c54 <panic>

0000000080002512 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002512:	1101                	addi	sp,sp,-32
    80002514:	ec06                	sd	ra,24(sp)
    80002516:	e822                	sd	s0,16(sp)
    80002518:	e426                	sd	s1,8(sp)
    8000251a:	e04a                	sd	s2,0(sp)
    8000251c:	1000                	addi	s0,sp,32
    8000251e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002520:	01050913          	addi	s2,a0,16
    80002524:	854a                	mv	a0,s2
    80002526:	00001097          	auipc	ra,0x1
    8000252a:	422080e7          	jalr	1058(ra) # 80003948 <holdingsleep>
    8000252e:	c92d                	beqz	a0,800025a0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002530:	854a                	mv	a0,s2
    80002532:	00001097          	auipc	ra,0x1
    80002536:	3d2080e7          	jalr	978(ra) # 80003904 <releasesleep>

  acquire(&bcache.lock);
    8000253a:	0000d517          	auipc	a0,0xd
    8000253e:	b5e50513          	addi	a0,a0,-1186 # 8000f098 <bcache>
    80002542:	00004097          	auipc	ra,0x4
    80002546:	c4e080e7          	jalr	-946(ra) # 80006190 <acquire>
  b->refcnt--;
    8000254a:	40bc                	lw	a5,64(s1)
    8000254c:	37fd                	addiw	a5,a5,-1
    8000254e:	0007871b          	sext.w	a4,a5
    80002552:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002554:	eb05                	bnez	a4,80002584 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002556:	68bc                	ld	a5,80(s1)
    80002558:	64b8                	ld	a4,72(s1)
    8000255a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000255c:	64bc                	ld	a5,72(s1)
    8000255e:	68b8                	ld	a4,80(s1)
    80002560:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002562:	00015797          	auipc	a5,0x15
    80002566:	b3678793          	addi	a5,a5,-1226 # 80017098 <bcache+0x8000>
    8000256a:	2b87b703          	ld	a4,696(a5)
    8000256e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002570:	00015717          	auipc	a4,0x15
    80002574:	d9070713          	addi	a4,a4,-624 # 80017300 <bcache+0x8268>
    80002578:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000257a:	2b87b703          	ld	a4,696(a5)
    8000257e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002580:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002584:	0000d517          	auipc	a0,0xd
    80002588:	b1450513          	addi	a0,a0,-1260 # 8000f098 <bcache>
    8000258c:	00004097          	auipc	ra,0x4
    80002590:	cb8080e7          	jalr	-840(ra) # 80006244 <release>
}
    80002594:	60e2                	ld	ra,24(sp)
    80002596:	6442                	ld	s0,16(sp)
    80002598:	64a2                	ld	s1,8(sp)
    8000259a:	6902                	ld	s2,0(sp)
    8000259c:	6105                	addi	sp,sp,32
    8000259e:	8082                	ret
    panic("brelse");
    800025a0:	00006517          	auipc	a0,0x6
    800025a4:	ed850513          	addi	a0,a0,-296 # 80008478 <etext+0x478>
    800025a8:	00003097          	auipc	ra,0x3
    800025ac:	6ac080e7          	jalr	1708(ra) # 80005c54 <panic>

00000000800025b0 <bpin>:

void
bpin(struct buf *b) {
    800025b0:	1101                	addi	sp,sp,-32
    800025b2:	ec06                	sd	ra,24(sp)
    800025b4:	e822                	sd	s0,16(sp)
    800025b6:	e426                	sd	s1,8(sp)
    800025b8:	1000                	addi	s0,sp,32
    800025ba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025bc:	0000d517          	auipc	a0,0xd
    800025c0:	adc50513          	addi	a0,a0,-1316 # 8000f098 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	bcc080e7          	jalr	-1076(ra) # 80006190 <acquire>
  b->refcnt++;
    800025cc:	40bc                	lw	a5,64(s1)
    800025ce:	2785                	addiw	a5,a5,1
    800025d0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d2:	0000d517          	auipc	a0,0xd
    800025d6:	ac650513          	addi	a0,a0,-1338 # 8000f098 <bcache>
    800025da:	00004097          	auipc	ra,0x4
    800025de:	c6a080e7          	jalr	-918(ra) # 80006244 <release>
}
    800025e2:	60e2                	ld	ra,24(sp)
    800025e4:	6442                	ld	s0,16(sp)
    800025e6:	64a2                	ld	s1,8(sp)
    800025e8:	6105                	addi	sp,sp,32
    800025ea:	8082                	ret

00000000800025ec <bunpin>:

void
bunpin(struct buf *b) {
    800025ec:	1101                	addi	sp,sp,-32
    800025ee:	ec06                	sd	ra,24(sp)
    800025f0:	e822                	sd	s0,16(sp)
    800025f2:	e426                	sd	s1,8(sp)
    800025f4:	1000                	addi	s0,sp,32
    800025f6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f8:	0000d517          	auipc	a0,0xd
    800025fc:	aa050513          	addi	a0,a0,-1376 # 8000f098 <bcache>
    80002600:	00004097          	auipc	ra,0x4
    80002604:	b90080e7          	jalr	-1136(ra) # 80006190 <acquire>
  b->refcnt--;
    80002608:	40bc                	lw	a5,64(s1)
    8000260a:	37fd                	addiw	a5,a5,-1
    8000260c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260e:	0000d517          	auipc	a0,0xd
    80002612:	a8a50513          	addi	a0,a0,-1398 # 8000f098 <bcache>
    80002616:	00004097          	auipc	ra,0x4
    8000261a:	c2e080e7          	jalr	-978(ra) # 80006244 <release>
}
    8000261e:	60e2                	ld	ra,24(sp)
    80002620:	6442                	ld	s0,16(sp)
    80002622:	64a2                	ld	s1,8(sp)
    80002624:	6105                	addi	sp,sp,32
    80002626:	8082                	ret

0000000080002628 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002628:	1101                	addi	sp,sp,-32
    8000262a:	ec06                	sd	ra,24(sp)
    8000262c:	e822                	sd	s0,16(sp)
    8000262e:	e426                	sd	s1,8(sp)
    80002630:	e04a                	sd	s2,0(sp)
    80002632:	1000                	addi	s0,sp,32
    80002634:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002636:	00d5d59b          	srliw	a1,a1,0xd
    8000263a:	00015797          	auipc	a5,0x15
    8000263e:	13a7a783          	lw	a5,314(a5) # 80017774 <sb+0x1c>
    80002642:	9dbd                	addw	a1,a1,a5
    80002644:	00000097          	auipc	ra,0x0
    80002648:	d9e080e7          	jalr	-610(ra) # 800023e2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000264c:	0074f713          	andi	a4,s1,7
    80002650:	4785                	li	a5,1
    80002652:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002656:	14ce                	slli	s1,s1,0x33
    80002658:	90d9                	srli	s1,s1,0x36
    8000265a:	00950733          	add	a4,a0,s1
    8000265e:	05874703          	lbu	a4,88(a4)
    80002662:	00e7f6b3          	and	a3,a5,a4
    80002666:	c69d                	beqz	a3,80002694 <bfree+0x6c>
    80002668:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000266a:	94aa                	add	s1,s1,a0
    8000266c:	fff7c793          	not	a5,a5
    80002670:	8ff9                	and	a5,a5,a4
    80002672:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002676:	00001097          	auipc	ra,0x1
    8000267a:	118080e7          	jalr	280(ra) # 8000378e <log_write>
  brelse(bp);
    8000267e:	854a                	mv	a0,s2
    80002680:	00000097          	auipc	ra,0x0
    80002684:	e92080e7          	jalr	-366(ra) # 80002512 <brelse>
}
    80002688:	60e2                	ld	ra,24(sp)
    8000268a:	6442                	ld	s0,16(sp)
    8000268c:	64a2                	ld	s1,8(sp)
    8000268e:	6902                	ld	s2,0(sp)
    80002690:	6105                	addi	sp,sp,32
    80002692:	8082                	ret
    panic("freeing free block");
    80002694:	00006517          	auipc	a0,0x6
    80002698:	dec50513          	addi	a0,a0,-532 # 80008480 <etext+0x480>
    8000269c:	00003097          	auipc	ra,0x3
    800026a0:	5b8080e7          	jalr	1464(ra) # 80005c54 <panic>

00000000800026a4 <balloc>:
{
    800026a4:	711d                	addi	sp,sp,-96
    800026a6:	ec86                	sd	ra,88(sp)
    800026a8:	e8a2                	sd	s0,80(sp)
    800026aa:	e4a6                	sd	s1,72(sp)
    800026ac:	e0ca                	sd	s2,64(sp)
    800026ae:	fc4e                	sd	s3,56(sp)
    800026b0:	f852                	sd	s4,48(sp)
    800026b2:	f456                	sd	s5,40(sp)
    800026b4:	f05a                	sd	s6,32(sp)
    800026b6:	ec5e                	sd	s7,24(sp)
    800026b8:	e862                	sd	s8,16(sp)
    800026ba:	e466                	sd	s9,8(sp)
    800026bc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026be:	00015797          	auipc	a5,0x15
    800026c2:	09e7a783          	lw	a5,158(a5) # 8001775c <sb+0x4>
    800026c6:	cbd1                	beqz	a5,8000275a <balloc+0xb6>
    800026c8:	8baa                	mv	s7,a0
    800026ca:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026cc:	00015b17          	auipc	s6,0x15
    800026d0:	08cb0b13          	addi	s6,s6,140 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026d6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026da:	6c89                	lui	s9,0x2
    800026dc:	a831                	j	800026f8 <balloc+0x54>
    brelse(bp);
    800026de:	854a                	mv	a0,s2
    800026e0:	00000097          	auipc	ra,0x0
    800026e4:	e32080e7          	jalr	-462(ra) # 80002512 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026e8:	015c87bb          	addw	a5,s9,s5
    800026ec:	00078a9b          	sext.w	s5,a5
    800026f0:	004b2703          	lw	a4,4(s6)
    800026f4:	06eaf363          	bgeu	s5,a4,8000275a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026f8:	41fad79b          	sraiw	a5,s5,0x1f
    800026fc:	0137d79b          	srliw	a5,a5,0x13
    80002700:	015787bb          	addw	a5,a5,s5
    80002704:	40d7d79b          	sraiw	a5,a5,0xd
    80002708:	01cb2583          	lw	a1,28(s6)
    8000270c:	9dbd                	addw	a1,a1,a5
    8000270e:	855e                	mv	a0,s7
    80002710:	00000097          	auipc	ra,0x0
    80002714:	cd2080e7          	jalr	-814(ra) # 800023e2 <bread>
    80002718:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000271a:	004b2503          	lw	a0,4(s6)
    8000271e:	000a849b          	sext.w	s1,s5
    80002722:	8662                	mv	a2,s8
    80002724:	faa4fde3          	bgeu	s1,a0,800026de <balloc+0x3a>
      m = 1 << (bi % 8);
    80002728:	41f6579b          	sraiw	a5,a2,0x1f
    8000272c:	01d7d69b          	srliw	a3,a5,0x1d
    80002730:	00c6873b          	addw	a4,a3,a2
    80002734:	00777793          	andi	a5,a4,7
    80002738:	9f95                	subw	a5,a5,a3
    8000273a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000273e:	4037571b          	sraiw	a4,a4,0x3
    80002742:	00e906b3          	add	a3,s2,a4
    80002746:	0586c683          	lbu	a3,88(a3)
    8000274a:	00d7f5b3          	and	a1,a5,a3
    8000274e:	cd91                	beqz	a1,8000276a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002750:	2605                	addiw	a2,a2,1
    80002752:	2485                	addiw	s1,s1,1
    80002754:	fd4618e3          	bne	a2,s4,80002724 <balloc+0x80>
    80002758:	b759                	j	800026de <balloc+0x3a>
  panic("balloc: out of blocks");
    8000275a:	00006517          	auipc	a0,0x6
    8000275e:	d3e50513          	addi	a0,a0,-706 # 80008498 <etext+0x498>
    80002762:	00003097          	auipc	ra,0x3
    80002766:	4f2080e7          	jalr	1266(ra) # 80005c54 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000276a:	974a                	add	a4,a4,s2
    8000276c:	8fd5                	or	a5,a5,a3
    8000276e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002772:	854a                	mv	a0,s2
    80002774:	00001097          	auipc	ra,0x1
    80002778:	01a080e7          	jalr	26(ra) # 8000378e <log_write>
        brelse(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	00000097          	auipc	ra,0x0
    80002782:	d94080e7          	jalr	-620(ra) # 80002512 <brelse>
  bp = bread(dev, bno);
    80002786:	85a6                	mv	a1,s1
    80002788:	855e                	mv	a0,s7
    8000278a:	00000097          	auipc	ra,0x0
    8000278e:	c58080e7          	jalr	-936(ra) # 800023e2 <bread>
    80002792:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002794:	40000613          	li	a2,1024
    80002798:	4581                	li	a1,0
    8000279a:	05850513          	addi	a0,a0,88
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	a24080e7          	jalr	-1500(ra) # 800001c2 <memset>
  log_write(bp);
    800027a6:	854a                	mv	a0,s2
    800027a8:	00001097          	auipc	ra,0x1
    800027ac:	fe6080e7          	jalr	-26(ra) # 8000378e <log_write>
  brelse(bp);
    800027b0:	854a                	mv	a0,s2
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	d60080e7          	jalr	-672(ra) # 80002512 <brelse>
}
    800027ba:	8526                	mv	a0,s1
    800027bc:	60e6                	ld	ra,88(sp)
    800027be:	6446                	ld	s0,80(sp)
    800027c0:	64a6                	ld	s1,72(sp)
    800027c2:	6906                	ld	s2,64(sp)
    800027c4:	79e2                	ld	s3,56(sp)
    800027c6:	7a42                	ld	s4,48(sp)
    800027c8:	7aa2                	ld	s5,40(sp)
    800027ca:	7b02                	ld	s6,32(sp)
    800027cc:	6be2                	ld	s7,24(sp)
    800027ce:	6c42                	ld	s8,16(sp)
    800027d0:	6ca2                	ld	s9,8(sp)
    800027d2:	6125                	addi	sp,sp,96
    800027d4:	8082                	ret

00000000800027d6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027d6:	7179                	addi	sp,sp,-48
    800027d8:	f406                	sd	ra,40(sp)
    800027da:	f022                	sd	s0,32(sp)
    800027dc:	ec26                	sd	s1,24(sp)
    800027de:	e84a                	sd	s2,16(sp)
    800027e0:	e44e                	sd	s3,8(sp)
    800027e2:	e052                	sd	s4,0(sp)
    800027e4:	1800                	addi	s0,sp,48
    800027e6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027e8:	47ad                	li	a5,11
    800027ea:	04b7fe63          	bgeu	a5,a1,80002846 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027ee:	ff45849b          	addiw	s1,a1,-12
    800027f2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027f6:	0ff00793          	li	a5,255
    800027fa:	0ae7e363          	bltu	a5,a4,800028a0 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027fe:	08052583          	lw	a1,128(a0)
    80002802:	c5ad                	beqz	a1,8000286c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002804:	00092503          	lw	a0,0(s2)
    80002808:	00000097          	auipc	ra,0x0
    8000280c:	bda080e7          	jalr	-1062(ra) # 800023e2 <bread>
    80002810:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002812:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002816:	02049593          	slli	a1,s1,0x20
    8000281a:	9181                	srli	a1,a1,0x20
    8000281c:	058a                	slli	a1,a1,0x2
    8000281e:	00b784b3          	add	s1,a5,a1
    80002822:	0004a983          	lw	s3,0(s1)
    80002826:	04098d63          	beqz	s3,80002880 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000282a:	8552                	mv	a0,s4
    8000282c:	00000097          	auipc	ra,0x0
    80002830:	ce6080e7          	jalr	-794(ra) # 80002512 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002834:	854e                	mv	a0,s3
    80002836:	70a2                	ld	ra,40(sp)
    80002838:	7402                	ld	s0,32(sp)
    8000283a:	64e2                	ld	s1,24(sp)
    8000283c:	6942                	ld	s2,16(sp)
    8000283e:	69a2                	ld	s3,8(sp)
    80002840:	6a02                	ld	s4,0(sp)
    80002842:	6145                	addi	sp,sp,48
    80002844:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002846:	02059493          	slli	s1,a1,0x20
    8000284a:	9081                	srli	s1,s1,0x20
    8000284c:	048a                	slli	s1,s1,0x2
    8000284e:	94aa                	add	s1,s1,a0
    80002850:	0504a983          	lw	s3,80(s1)
    80002854:	fe0990e3          	bnez	s3,80002834 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002858:	4108                	lw	a0,0(a0)
    8000285a:	00000097          	auipc	ra,0x0
    8000285e:	e4a080e7          	jalr	-438(ra) # 800026a4 <balloc>
    80002862:	0005099b          	sext.w	s3,a0
    80002866:	0534a823          	sw	s3,80(s1)
    8000286a:	b7e9                	j	80002834 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000286c:	4108                	lw	a0,0(a0)
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	e36080e7          	jalr	-458(ra) # 800026a4 <balloc>
    80002876:	0005059b          	sext.w	a1,a0
    8000287a:	08b92023          	sw	a1,128(s2)
    8000287e:	b759                	j	80002804 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002880:	00092503          	lw	a0,0(s2)
    80002884:	00000097          	auipc	ra,0x0
    80002888:	e20080e7          	jalr	-480(ra) # 800026a4 <balloc>
    8000288c:	0005099b          	sext.w	s3,a0
    80002890:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002894:	8552                	mv	a0,s4
    80002896:	00001097          	auipc	ra,0x1
    8000289a:	ef8080e7          	jalr	-264(ra) # 8000378e <log_write>
    8000289e:	b771                	j	8000282a <bmap+0x54>
  panic("bmap: out of range");
    800028a0:	00006517          	auipc	a0,0x6
    800028a4:	c1050513          	addi	a0,a0,-1008 # 800084b0 <etext+0x4b0>
    800028a8:	00003097          	auipc	ra,0x3
    800028ac:	3ac080e7          	jalr	940(ra) # 80005c54 <panic>

00000000800028b0 <iget>:
{
    800028b0:	7179                	addi	sp,sp,-48
    800028b2:	f406                	sd	ra,40(sp)
    800028b4:	f022                	sd	s0,32(sp)
    800028b6:	ec26                	sd	s1,24(sp)
    800028b8:	e84a                	sd	s2,16(sp)
    800028ba:	e44e                	sd	s3,8(sp)
    800028bc:	e052                	sd	s4,0(sp)
    800028be:	1800                	addi	s0,sp,48
    800028c0:	89aa                	mv	s3,a0
    800028c2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028c4:	00015517          	auipc	a0,0x15
    800028c8:	eb450513          	addi	a0,a0,-332 # 80017778 <itable>
    800028cc:	00004097          	auipc	ra,0x4
    800028d0:	8c4080e7          	jalr	-1852(ra) # 80006190 <acquire>
  empty = 0;
    800028d4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028d6:	00015497          	auipc	s1,0x15
    800028da:	eba48493          	addi	s1,s1,-326 # 80017790 <itable+0x18>
    800028de:	00017697          	auipc	a3,0x17
    800028e2:	94268693          	addi	a3,a3,-1726 # 80019220 <log>
    800028e6:	a039                	j	800028f4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028e8:	02090b63          	beqz	s2,8000291e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ec:	08848493          	addi	s1,s1,136
    800028f0:	02d48a63          	beq	s1,a3,80002924 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028f4:	449c                	lw	a5,8(s1)
    800028f6:	fef059e3          	blez	a5,800028e8 <iget+0x38>
    800028fa:	4098                	lw	a4,0(s1)
    800028fc:	ff3716e3          	bne	a4,s3,800028e8 <iget+0x38>
    80002900:	40d8                	lw	a4,4(s1)
    80002902:	ff4713e3          	bne	a4,s4,800028e8 <iget+0x38>
      ip->ref++;
    80002906:	2785                	addiw	a5,a5,1
    80002908:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000290a:	00015517          	auipc	a0,0x15
    8000290e:	e6e50513          	addi	a0,a0,-402 # 80017778 <itable>
    80002912:	00004097          	auipc	ra,0x4
    80002916:	932080e7          	jalr	-1742(ra) # 80006244 <release>
      return ip;
    8000291a:	8926                	mv	s2,s1
    8000291c:	a03d                	j	8000294a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000291e:	f7f9                	bnez	a5,800028ec <iget+0x3c>
    80002920:	8926                	mv	s2,s1
    80002922:	b7e9                	j	800028ec <iget+0x3c>
  if(empty == 0)
    80002924:	02090c63          	beqz	s2,8000295c <iget+0xac>
  ip->dev = dev;
    80002928:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000292c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002930:	4785                	li	a5,1
    80002932:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002936:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000293a:	00015517          	auipc	a0,0x15
    8000293e:	e3e50513          	addi	a0,a0,-450 # 80017778 <itable>
    80002942:	00004097          	auipc	ra,0x4
    80002946:	902080e7          	jalr	-1790(ra) # 80006244 <release>
}
    8000294a:	854a                	mv	a0,s2
    8000294c:	70a2                	ld	ra,40(sp)
    8000294e:	7402                	ld	s0,32(sp)
    80002950:	64e2                	ld	s1,24(sp)
    80002952:	6942                	ld	s2,16(sp)
    80002954:	69a2                	ld	s3,8(sp)
    80002956:	6a02                	ld	s4,0(sp)
    80002958:	6145                	addi	sp,sp,48
    8000295a:	8082                	ret
    panic("iget: no inodes");
    8000295c:	00006517          	auipc	a0,0x6
    80002960:	b6c50513          	addi	a0,a0,-1172 # 800084c8 <etext+0x4c8>
    80002964:	00003097          	auipc	ra,0x3
    80002968:	2f0080e7          	jalr	752(ra) # 80005c54 <panic>

000000008000296c <fsinit>:
fsinit(int dev) {
    8000296c:	7179                	addi	sp,sp,-48
    8000296e:	f406                	sd	ra,40(sp)
    80002970:	f022                	sd	s0,32(sp)
    80002972:	ec26                	sd	s1,24(sp)
    80002974:	e84a                	sd	s2,16(sp)
    80002976:	e44e                	sd	s3,8(sp)
    80002978:	1800                	addi	s0,sp,48
    8000297a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000297c:	4585                	li	a1,1
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	a64080e7          	jalr	-1436(ra) # 800023e2 <bread>
    80002986:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002988:	00015997          	auipc	s3,0x15
    8000298c:	dd098993          	addi	s3,s3,-560 # 80017758 <sb>
    80002990:	02000613          	li	a2,32
    80002994:	05850593          	addi	a1,a0,88
    80002998:	854e                	mv	a0,s3
    8000299a:	ffffe097          	auipc	ra,0xffffe
    8000299e:	884080e7          	jalr	-1916(ra) # 8000021e <memmove>
  brelse(bp);
    800029a2:	8526                	mv	a0,s1
    800029a4:	00000097          	auipc	ra,0x0
    800029a8:	b6e080e7          	jalr	-1170(ra) # 80002512 <brelse>
  if(sb.magic != FSMAGIC)
    800029ac:	0009a703          	lw	a4,0(s3)
    800029b0:	102037b7          	lui	a5,0x10203
    800029b4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029b8:	02f71263          	bne	a4,a5,800029dc <fsinit+0x70>
  initlog(dev, &sb);
    800029bc:	00015597          	auipc	a1,0x15
    800029c0:	d9c58593          	addi	a1,a1,-612 # 80017758 <sb>
    800029c4:	854a                	mv	a0,s2
    800029c6:	00001097          	auipc	ra,0x1
    800029ca:	b4c080e7          	jalr	-1204(ra) # 80003512 <initlog>
}
    800029ce:	70a2                	ld	ra,40(sp)
    800029d0:	7402                	ld	s0,32(sp)
    800029d2:	64e2                	ld	s1,24(sp)
    800029d4:	6942                	ld	s2,16(sp)
    800029d6:	69a2                	ld	s3,8(sp)
    800029d8:	6145                	addi	sp,sp,48
    800029da:	8082                	ret
    panic("invalid file system");
    800029dc:	00006517          	auipc	a0,0x6
    800029e0:	afc50513          	addi	a0,a0,-1284 # 800084d8 <etext+0x4d8>
    800029e4:	00003097          	auipc	ra,0x3
    800029e8:	270080e7          	jalr	624(ra) # 80005c54 <panic>

00000000800029ec <iinit>:
{
    800029ec:	7179                	addi	sp,sp,-48
    800029ee:	f406                	sd	ra,40(sp)
    800029f0:	f022                	sd	s0,32(sp)
    800029f2:	ec26                	sd	s1,24(sp)
    800029f4:	e84a                	sd	s2,16(sp)
    800029f6:	e44e                	sd	s3,8(sp)
    800029f8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029fa:	00006597          	auipc	a1,0x6
    800029fe:	af658593          	addi	a1,a1,-1290 # 800084f0 <etext+0x4f0>
    80002a02:	00015517          	auipc	a0,0x15
    80002a06:	d7650513          	addi	a0,a0,-650 # 80017778 <itable>
    80002a0a:	00003097          	auipc	ra,0x3
    80002a0e:	6f6080e7          	jalr	1782(ra) # 80006100 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a12:	00015497          	auipc	s1,0x15
    80002a16:	d8e48493          	addi	s1,s1,-626 # 800177a0 <itable+0x28>
    80002a1a:	00017997          	auipc	s3,0x17
    80002a1e:	81698993          	addi	s3,s3,-2026 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a22:	00006917          	auipc	s2,0x6
    80002a26:	ad690913          	addi	s2,s2,-1322 # 800084f8 <etext+0x4f8>
    80002a2a:	85ca                	mv	a1,s2
    80002a2c:	8526                	mv	a0,s1
    80002a2e:	00001097          	auipc	ra,0x1
    80002a32:	e46080e7          	jalr	-442(ra) # 80003874 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a36:	08848493          	addi	s1,s1,136
    80002a3a:	ff3498e3          	bne	s1,s3,80002a2a <iinit+0x3e>
}
    80002a3e:	70a2                	ld	ra,40(sp)
    80002a40:	7402                	ld	s0,32(sp)
    80002a42:	64e2                	ld	s1,24(sp)
    80002a44:	6942                	ld	s2,16(sp)
    80002a46:	69a2                	ld	s3,8(sp)
    80002a48:	6145                	addi	sp,sp,48
    80002a4a:	8082                	ret

0000000080002a4c <ialloc>:
{
    80002a4c:	715d                	addi	sp,sp,-80
    80002a4e:	e486                	sd	ra,72(sp)
    80002a50:	e0a2                	sd	s0,64(sp)
    80002a52:	fc26                	sd	s1,56(sp)
    80002a54:	f84a                	sd	s2,48(sp)
    80002a56:	f44e                	sd	s3,40(sp)
    80002a58:	f052                	sd	s4,32(sp)
    80002a5a:	ec56                	sd	s5,24(sp)
    80002a5c:	e85a                	sd	s6,16(sp)
    80002a5e:	e45e                	sd	s7,8(sp)
    80002a60:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a62:	00015717          	auipc	a4,0x15
    80002a66:	d0272703          	lw	a4,-766(a4) # 80017764 <sb+0xc>
    80002a6a:	4785                	li	a5,1
    80002a6c:	04e7fa63          	bgeu	a5,a4,80002ac0 <ialloc+0x74>
    80002a70:	8aaa                	mv	s5,a0
    80002a72:	8bae                	mv	s7,a1
    80002a74:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a76:	00015a17          	auipc	s4,0x15
    80002a7a:	ce2a0a13          	addi	s4,s4,-798 # 80017758 <sb>
    80002a7e:	00048b1b          	sext.w	s6,s1
    80002a82:	0044d793          	srli	a5,s1,0x4
    80002a86:	018a2583          	lw	a1,24(s4)
    80002a8a:	9dbd                	addw	a1,a1,a5
    80002a8c:	8556                	mv	a0,s5
    80002a8e:	00000097          	auipc	ra,0x0
    80002a92:	954080e7          	jalr	-1708(ra) # 800023e2 <bread>
    80002a96:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a98:	05850993          	addi	s3,a0,88
    80002a9c:	00f4f793          	andi	a5,s1,15
    80002aa0:	079a                	slli	a5,a5,0x6
    80002aa2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aa4:	00099783          	lh	a5,0(s3)
    80002aa8:	c785                	beqz	a5,80002ad0 <ialloc+0x84>
    brelse(bp);
    80002aaa:	00000097          	auipc	ra,0x0
    80002aae:	a68080e7          	jalr	-1432(ra) # 80002512 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ab2:	0485                	addi	s1,s1,1
    80002ab4:	00ca2703          	lw	a4,12(s4)
    80002ab8:	0004879b          	sext.w	a5,s1
    80002abc:	fce7e1e3          	bltu	a5,a4,80002a7e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ac0:	00006517          	auipc	a0,0x6
    80002ac4:	a4050513          	addi	a0,a0,-1472 # 80008500 <etext+0x500>
    80002ac8:	00003097          	auipc	ra,0x3
    80002acc:	18c080e7          	jalr	396(ra) # 80005c54 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ad0:	04000613          	li	a2,64
    80002ad4:	4581                	li	a1,0
    80002ad6:	854e                	mv	a0,s3
    80002ad8:	ffffd097          	auipc	ra,0xffffd
    80002adc:	6ea080e7          	jalr	1770(ra) # 800001c2 <memset>
      dip->type = type;
    80002ae0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ae4:	854a                	mv	a0,s2
    80002ae6:	00001097          	auipc	ra,0x1
    80002aea:	ca8080e7          	jalr	-856(ra) # 8000378e <log_write>
      brelse(bp);
    80002aee:	854a                	mv	a0,s2
    80002af0:	00000097          	auipc	ra,0x0
    80002af4:	a22080e7          	jalr	-1502(ra) # 80002512 <brelse>
      return iget(dev, inum);
    80002af8:	85da                	mv	a1,s6
    80002afa:	8556                	mv	a0,s5
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	db4080e7          	jalr	-588(ra) # 800028b0 <iget>
}
    80002b04:	60a6                	ld	ra,72(sp)
    80002b06:	6406                	ld	s0,64(sp)
    80002b08:	74e2                	ld	s1,56(sp)
    80002b0a:	7942                	ld	s2,48(sp)
    80002b0c:	79a2                	ld	s3,40(sp)
    80002b0e:	7a02                	ld	s4,32(sp)
    80002b10:	6ae2                	ld	s5,24(sp)
    80002b12:	6b42                	ld	s6,16(sp)
    80002b14:	6ba2                	ld	s7,8(sp)
    80002b16:	6161                	addi	sp,sp,80
    80002b18:	8082                	ret

0000000080002b1a <iupdate>:
{
    80002b1a:	1101                	addi	sp,sp,-32
    80002b1c:	ec06                	sd	ra,24(sp)
    80002b1e:	e822                	sd	s0,16(sp)
    80002b20:	e426                	sd	s1,8(sp)
    80002b22:	e04a                	sd	s2,0(sp)
    80002b24:	1000                	addi	s0,sp,32
    80002b26:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b28:	415c                	lw	a5,4(a0)
    80002b2a:	0047d79b          	srliw	a5,a5,0x4
    80002b2e:	00015597          	auipc	a1,0x15
    80002b32:	c425a583          	lw	a1,-958(a1) # 80017770 <sb+0x18>
    80002b36:	9dbd                	addw	a1,a1,a5
    80002b38:	4108                	lw	a0,0(a0)
    80002b3a:	00000097          	auipc	ra,0x0
    80002b3e:	8a8080e7          	jalr	-1880(ra) # 800023e2 <bread>
    80002b42:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b44:	05850793          	addi	a5,a0,88
    80002b48:	40c8                	lw	a0,4(s1)
    80002b4a:	893d                	andi	a0,a0,15
    80002b4c:	051a                	slli	a0,a0,0x6
    80002b4e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b50:	04449703          	lh	a4,68(s1)
    80002b54:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b58:	04649703          	lh	a4,70(s1)
    80002b5c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b60:	04849703          	lh	a4,72(s1)
    80002b64:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b68:	04a49703          	lh	a4,74(s1)
    80002b6c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b70:	44f8                	lw	a4,76(s1)
    80002b72:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b74:	03400613          	li	a2,52
    80002b78:	05048593          	addi	a1,s1,80
    80002b7c:	0531                	addi	a0,a0,12
    80002b7e:	ffffd097          	auipc	ra,0xffffd
    80002b82:	6a0080e7          	jalr	1696(ra) # 8000021e <memmove>
  log_write(bp);
    80002b86:	854a                	mv	a0,s2
    80002b88:	00001097          	auipc	ra,0x1
    80002b8c:	c06080e7          	jalr	-1018(ra) # 8000378e <log_write>
  brelse(bp);
    80002b90:	854a                	mv	a0,s2
    80002b92:	00000097          	auipc	ra,0x0
    80002b96:	980080e7          	jalr	-1664(ra) # 80002512 <brelse>
}
    80002b9a:	60e2                	ld	ra,24(sp)
    80002b9c:	6442                	ld	s0,16(sp)
    80002b9e:	64a2                	ld	s1,8(sp)
    80002ba0:	6902                	ld	s2,0(sp)
    80002ba2:	6105                	addi	sp,sp,32
    80002ba4:	8082                	ret

0000000080002ba6 <idup>:
{
    80002ba6:	1101                	addi	sp,sp,-32
    80002ba8:	ec06                	sd	ra,24(sp)
    80002baa:	e822                	sd	s0,16(sp)
    80002bac:	e426                	sd	s1,8(sp)
    80002bae:	1000                	addi	s0,sp,32
    80002bb0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bb2:	00015517          	auipc	a0,0x15
    80002bb6:	bc650513          	addi	a0,a0,-1082 # 80017778 <itable>
    80002bba:	00003097          	auipc	ra,0x3
    80002bbe:	5d6080e7          	jalr	1494(ra) # 80006190 <acquire>
  ip->ref++;
    80002bc2:	449c                	lw	a5,8(s1)
    80002bc4:	2785                	addiw	a5,a5,1
    80002bc6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bc8:	00015517          	auipc	a0,0x15
    80002bcc:	bb050513          	addi	a0,a0,-1104 # 80017778 <itable>
    80002bd0:	00003097          	auipc	ra,0x3
    80002bd4:	674080e7          	jalr	1652(ra) # 80006244 <release>
}
    80002bd8:	8526                	mv	a0,s1
    80002bda:	60e2                	ld	ra,24(sp)
    80002bdc:	6442                	ld	s0,16(sp)
    80002bde:	64a2                	ld	s1,8(sp)
    80002be0:	6105                	addi	sp,sp,32
    80002be2:	8082                	ret

0000000080002be4 <ilock>:
{
    80002be4:	1101                	addi	sp,sp,-32
    80002be6:	ec06                	sd	ra,24(sp)
    80002be8:	e822                	sd	s0,16(sp)
    80002bea:	e426                	sd	s1,8(sp)
    80002bec:	e04a                	sd	s2,0(sp)
    80002bee:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bf0:	c115                	beqz	a0,80002c14 <ilock+0x30>
    80002bf2:	84aa                	mv	s1,a0
    80002bf4:	451c                	lw	a5,8(a0)
    80002bf6:	00f05f63          	blez	a5,80002c14 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bfa:	0541                	addi	a0,a0,16
    80002bfc:	00001097          	auipc	ra,0x1
    80002c00:	cb2080e7          	jalr	-846(ra) # 800038ae <acquiresleep>
  if(ip->valid == 0){
    80002c04:	40bc                	lw	a5,64(s1)
    80002c06:	cf99                	beqz	a5,80002c24 <ilock+0x40>
}
    80002c08:	60e2                	ld	ra,24(sp)
    80002c0a:	6442                	ld	s0,16(sp)
    80002c0c:	64a2                	ld	s1,8(sp)
    80002c0e:	6902                	ld	s2,0(sp)
    80002c10:	6105                	addi	sp,sp,32
    80002c12:	8082                	ret
    panic("ilock");
    80002c14:	00006517          	auipc	a0,0x6
    80002c18:	90450513          	addi	a0,a0,-1788 # 80008518 <etext+0x518>
    80002c1c:	00003097          	auipc	ra,0x3
    80002c20:	038080e7          	jalr	56(ra) # 80005c54 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c24:	40dc                	lw	a5,4(s1)
    80002c26:	0047d79b          	srliw	a5,a5,0x4
    80002c2a:	00015597          	auipc	a1,0x15
    80002c2e:	b465a583          	lw	a1,-1210(a1) # 80017770 <sb+0x18>
    80002c32:	9dbd                	addw	a1,a1,a5
    80002c34:	4088                	lw	a0,0(s1)
    80002c36:	fffff097          	auipc	ra,0xfffff
    80002c3a:	7ac080e7          	jalr	1964(ra) # 800023e2 <bread>
    80002c3e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c40:	05850593          	addi	a1,a0,88
    80002c44:	40dc                	lw	a5,4(s1)
    80002c46:	8bbd                	andi	a5,a5,15
    80002c48:	079a                	slli	a5,a5,0x6
    80002c4a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c4c:	00059783          	lh	a5,0(a1)
    80002c50:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c54:	00259783          	lh	a5,2(a1)
    80002c58:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c5c:	00459783          	lh	a5,4(a1)
    80002c60:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c64:	00659783          	lh	a5,6(a1)
    80002c68:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c6c:	459c                	lw	a5,8(a1)
    80002c6e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c70:	03400613          	li	a2,52
    80002c74:	05b1                	addi	a1,a1,12
    80002c76:	05048513          	addi	a0,s1,80
    80002c7a:	ffffd097          	auipc	ra,0xffffd
    80002c7e:	5a4080e7          	jalr	1444(ra) # 8000021e <memmove>
    brelse(bp);
    80002c82:	854a                	mv	a0,s2
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	88e080e7          	jalr	-1906(ra) # 80002512 <brelse>
    ip->valid = 1;
    80002c8c:	4785                	li	a5,1
    80002c8e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c90:	04449783          	lh	a5,68(s1)
    80002c94:	fbb5                	bnez	a5,80002c08 <ilock+0x24>
      panic("ilock: no type");
    80002c96:	00006517          	auipc	a0,0x6
    80002c9a:	88a50513          	addi	a0,a0,-1910 # 80008520 <etext+0x520>
    80002c9e:	00003097          	auipc	ra,0x3
    80002ca2:	fb6080e7          	jalr	-74(ra) # 80005c54 <panic>

0000000080002ca6 <iunlock>:
{
    80002ca6:	1101                	addi	sp,sp,-32
    80002ca8:	ec06                	sd	ra,24(sp)
    80002caa:	e822                	sd	s0,16(sp)
    80002cac:	e426                	sd	s1,8(sp)
    80002cae:	e04a                	sd	s2,0(sp)
    80002cb0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cb2:	c905                	beqz	a0,80002ce2 <iunlock+0x3c>
    80002cb4:	84aa                	mv	s1,a0
    80002cb6:	01050913          	addi	s2,a0,16
    80002cba:	854a                	mv	a0,s2
    80002cbc:	00001097          	auipc	ra,0x1
    80002cc0:	c8c080e7          	jalr	-884(ra) # 80003948 <holdingsleep>
    80002cc4:	cd19                	beqz	a0,80002ce2 <iunlock+0x3c>
    80002cc6:	449c                	lw	a5,8(s1)
    80002cc8:	00f05d63          	blez	a5,80002ce2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ccc:	854a                	mv	a0,s2
    80002cce:	00001097          	auipc	ra,0x1
    80002cd2:	c36080e7          	jalr	-970(ra) # 80003904 <releasesleep>
}
    80002cd6:	60e2                	ld	ra,24(sp)
    80002cd8:	6442                	ld	s0,16(sp)
    80002cda:	64a2                	ld	s1,8(sp)
    80002cdc:	6902                	ld	s2,0(sp)
    80002cde:	6105                	addi	sp,sp,32
    80002ce0:	8082                	ret
    panic("iunlock");
    80002ce2:	00006517          	auipc	a0,0x6
    80002ce6:	84e50513          	addi	a0,a0,-1970 # 80008530 <etext+0x530>
    80002cea:	00003097          	auipc	ra,0x3
    80002cee:	f6a080e7          	jalr	-150(ra) # 80005c54 <panic>

0000000080002cf2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cf2:	7179                	addi	sp,sp,-48
    80002cf4:	f406                	sd	ra,40(sp)
    80002cf6:	f022                	sd	s0,32(sp)
    80002cf8:	ec26                	sd	s1,24(sp)
    80002cfa:	e84a                	sd	s2,16(sp)
    80002cfc:	e44e                	sd	s3,8(sp)
    80002cfe:	e052                	sd	s4,0(sp)
    80002d00:	1800                	addi	s0,sp,48
    80002d02:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d04:	05050493          	addi	s1,a0,80
    80002d08:	08050913          	addi	s2,a0,128
    80002d0c:	a021                	j	80002d14 <itrunc+0x22>
    80002d0e:	0491                	addi	s1,s1,4
    80002d10:	01248d63          	beq	s1,s2,80002d2a <itrunc+0x38>
    if(ip->addrs[i]){
    80002d14:	408c                	lw	a1,0(s1)
    80002d16:	dde5                	beqz	a1,80002d0e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d18:	0009a503          	lw	a0,0(s3)
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	90c080e7          	jalr	-1780(ra) # 80002628 <bfree>
      ip->addrs[i] = 0;
    80002d24:	0004a023          	sw	zero,0(s1)
    80002d28:	b7dd                	j	80002d0e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d2a:	0809a583          	lw	a1,128(s3)
    80002d2e:	e185                	bnez	a1,80002d4e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d30:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d34:	854e                	mv	a0,s3
    80002d36:	00000097          	auipc	ra,0x0
    80002d3a:	de4080e7          	jalr	-540(ra) # 80002b1a <iupdate>
}
    80002d3e:	70a2                	ld	ra,40(sp)
    80002d40:	7402                	ld	s0,32(sp)
    80002d42:	64e2                	ld	s1,24(sp)
    80002d44:	6942                	ld	s2,16(sp)
    80002d46:	69a2                	ld	s3,8(sp)
    80002d48:	6a02                	ld	s4,0(sp)
    80002d4a:	6145                	addi	sp,sp,48
    80002d4c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d4e:	0009a503          	lw	a0,0(s3)
    80002d52:	fffff097          	auipc	ra,0xfffff
    80002d56:	690080e7          	jalr	1680(ra) # 800023e2 <bread>
    80002d5a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d5c:	05850493          	addi	s1,a0,88
    80002d60:	45850913          	addi	s2,a0,1112
    80002d64:	a021                	j	80002d6c <itrunc+0x7a>
    80002d66:	0491                	addi	s1,s1,4
    80002d68:	01248b63          	beq	s1,s2,80002d7e <itrunc+0x8c>
      if(a[j])
    80002d6c:	408c                	lw	a1,0(s1)
    80002d6e:	dde5                	beqz	a1,80002d66 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d70:	0009a503          	lw	a0,0(s3)
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	8b4080e7          	jalr	-1868(ra) # 80002628 <bfree>
    80002d7c:	b7ed                	j	80002d66 <itrunc+0x74>
    brelse(bp);
    80002d7e:	8552                	mv	a0,s4
    80002d80:	fffff097          	auipc	ra,0xfffff
    80002d84:	792080e7          	jalr	1938(ra) # 80002512 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d88:	0809a583          	lw	a1,128(s3)
    80002d8c:	0009a503          	lw	a0,0(s3)
    80002d90:	00000097          	auipc	ra,0x0
    80002d94:	898080e7          	jalr	-1896(ra) # 80002628 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d98:	0809a023          	sw	zero,128(s3)
    80002d9c:	bf51                	j	80002d30 <itrunc+0x3e>

0000000080002d9e <iput>:
{
    80002d9e:	1101                	addi	sp,sp,-32
    80002da0:	ec06                	sd	ra,24(sp)
    80002da2:	e822                	sd	s0,16(sp)
    80002da4:	e426                	sd	s1,8(sp)
    80002da6:	e04a                	sd	s2,0(sp)
    80002da8:	1000                	addi	s0,sp,32
    80002daa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dac:	00015517          	auipc	a0,0x15
    80002db0:	9cc50513          	addi	a0,a0,-1588 # 80017778 <itable>
    80002db4:	00003097          	auipc	ra,0x3
    80002db8:	3dc080e7          	jalr	988(ra) # 80006190 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dbc:	4498                	lw	a4,8(s1)
    80002dbe:	4785                	li	a5,1
    80002dc0:	02f70363          	beq	a4,a5,80002de6 <iput+0x48>
  ip->ref--;
    80002dc4:	449c                	lw	a5,8(s1)
    80002dc6:	37fd                	addiw	a5,a5,-1
    80002dc8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dca:	00015517          	auipc	a0,0x15
    80002dce:	9ae50513          	addi	a0,a0,-1618 # 80017778 <itable>
    80002dd2:	00003097          	auipc	ra,0x3
    80002dd6:	472080e7          	jalr	1138(ra) # 80006244 <release>
}
    80002dda:	60e2                	ld	ra,24(sp)
    80002ddc:	6442                	ld	s0,16(sp)
    80002dde:	64a2                	ld	s1,8(sp)
    80002de0:	6902                	ld	s2,0(sp)
    80002de2:	6105                	addi	sp,sp,32
    80002de4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002de6:	40bc                	lw	a5,64(s1)
    80002de8:	dff1                	beqz	a5,80002dc4 <iput+0x26>
    80002dea:	04a49783          	lh	a5,74(s1)
    80002dee:	fbf9                	bnez	a5,80002dc4 <iput+0x26>
    acquiresleep(&ip->lock);
    80002df0:	01048913          	addi	s2,s1,16
    80002df4:	854a                	mv	a0,s2
    80002df6:	00001097          	auipc	ra,0x1
    80002dfa:	ab8080e7          	jalr	-1352(ra) # 800038ae <acquiresleep>
    release(&itable.lock);
    80002dfe:	00015517          	auipc	a0,0x15
    80002e02:	97a50513          	addi	a0,a0,-1670 # 80017778 <itable>
    80002e06:	00003097          	auipc	ra,0x3
    80002e0a:	43e080e7          	jalr	1086(ra) # 80006244 <release>
    itrunc(ip);
    80002e0e:	8526                	mv	a0,s1
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	ee2080e7          	jalr	-286(ra) # 80002cf2 <itrunc>
    ip->type = 0;
    80002e18:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e1c:	8526                	mv	a0,s1
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	cfc080e7          	jalr	-772(ra) # 80002b1a <iupdate>
    ip->valid = 0;
    80002e26:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e2a:	854a                	mv	a0,s2
    80002e2c:	00001097          	auipc	ra,0x1
    80002e30:	ad8080e7          	jalr	-1320(ra) # 80003904 <releasesleep>
    acquire(&itable.lock);
    80002e34:	00015517          	auipc	a0,0x15
    80002e38:	94450513          	addi	a0,a0,-1724 # 80017778 <itable>
    80002e3c:	00003097          	auipc	ra,0x3
    80002e40:	354080e7          	jalr	852(ra) # 80006190 <acquire>
    80002e44:	b741                	j	80002dc4 <iput+0x26>

0000000080002e46 <iunlockput>:
{
    80002e46:	1101                	addi	sp,sp,-32
    80002e48:	ec06                	sd	ra,24(sp)
    80002e4a:	e822                	sd	s0,16(sp)
    80002e4c:	e426                	sd	s1,8(sp)
    80002e4e:	1000                	addi	s0,sp,32
    80002e50:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e52:	00000097          	auipc	ra,0x0
    80002e56:	e54080e7          	jalr	-428(ra) # 80002ca6 <iunlock>
  iput(ip);
    80002e5a:	8526                	mv	a0,s1
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	f42080e7          	jalr	-190(ra) # 80002d9e <iput>
}
    80002e64:	60e2                	ld	ra,24(sp)
    80002e66:	6442                	ld	s0,16(sp)
    80002e68:	64a2                	ld	s1,8(sp)
    80002e6a:	6105                	addi	sp,sp,32
    80002e6c:	8082                	ret

0000000080002e6e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e6e:	1141                	addi	sp,sp,-16
    80002e70:	e422                	sd	s0,8(sp)
    80002e72:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e74:	411c                	lw	a5,0(a0)
    80002e76:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e78:	415c                	lw	a5,4(a0)
    80002e7a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e7c:	04451783          	lh	a5,68(a0)
    80002e80:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e84:	04a51783          	lh	a5,74(a0)
    80002e88:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e8c:	04c56783          	lwu	a5,76(a0)
    80002e90:	e99c                	sd	a5,16(a1)
}
    80002e92:	6422                	ld	s0,8(sp)
    80002e94:	0141                	addi	sp,sp,16
    80002e96:	8082                	ret

0000000080002e98 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e98:	457c                	lw	a5,76(a0)
    80002e9a:	0ed7e963          	bltu	a5,a3,80002f8c <readi+0xf4>
{
    80002e9e:	7159                	addi	sp,sp,-112
    80002ea0:	f486                	sd	ra,104(sp)
    80002ea2:	f0a2                	sd	s0,96(sp)
    80002ea4:	eca6                	sd	s1,88(sp)
    80002ea6:	e8ca                	sd	s2,80(sp)
    80002ea8:	e4ce                	sd	s3,72(sp)
    80002eaa:	e0d2                	sd	s4,64(sp)
    80002eac:	fc56                	sd	s5,56(sp)
    80002eae:	f85a                	sd	s6,48(sp)
    80002eb0:	f45e                	sd	s7,40(sp)
    80002eb2:	f062                	sd	s8,32(sp)
    80002eb4:	ec66                	sd	s9,24(sp)
    80002eb6:	e86a                	sd	s10,16(sp)
    80002eb8:	e46e                	sd	s11,8(sp)
    80002eba:	1880                	addi	s0,sp,112
    80002ebc:	8baa                	mv	s7,a0
    80002ebe:	8c2e                	mv	s8,a1
    80002ec0:	8ab2                	mv	s5,a2
    80002ec2:	84b6                	mv	s1,a3
    80002ec4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ec6:	9f35                	addw	a4,a4,a3
    return 0;
    80002ec8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eca:	0ad76063          	bltu	a4,a3,80002f6a <readi+0xd2>
  if(off + n > ip->size)
    80002ece:	00e7f463          	bgeu	a5,a4,80002ed6 <readi+0x3e>
    n = ip->size - off;
    80002ed2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed6:	0a0b0963          	beqz	s6,80002f88 <readi+0xf0>
    80002eda:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002edc:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ee0:	5cfd                	li	s9,-1
    80002ee2:	a82d                	j	80002f1c <readi+0x84>
    80002ee4:	020a1d93          	slli	s11,s4,0x20
    80002ee8:	020ddd93          	srli	s11,s11,0x20
    80002eec:	05890793          	addi	a5,s2,88
    80002ef0:	86ee                	mv	a3,s11
    80002ef2:	963e                	add	a2,a2,a5
    80002ef4:	85d6                	mv	a1,s5
    80002ef6:	8562                	mv	a0,s8
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	a04080e7          	jalr	-1532(ra) # 800018fc <either_copyout>
    80002f00:	05950d63          	beq	a0,s9,80002f5a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f04:	854a                	mv	a0,s2
    80002f06:	fffff097          	auipc	ra,0xfffff
    80002f0a:	60c080e7          	jalr	1548(ra) # 80002512 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f0e:	013a09bb          	addw	s3,s4,s3
    80002f12:	009a04bb          	addw	s1,s4,s1
    80002f16:	9aee                	add	s5,s5,s11
    80002f18:	0569f763          	bgeu	s3,s6,80002f66 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f1c:	000ba903          	lw	s2,0(s7)
    80002f20:	00a4d59b          	srliw	a1,s1,0xa
    80002f24:	855e                	mv	a0,s7
    80002f26:	00000097          	auipc	ra,0x0
    80002f2a:	8b0080e7          	jalr	-1872(ra) # 800027d6 <bmap>
    80002f2e:	0005059b          	sext.w	a1,a0
    80002f32:	854a                	mv	a0,s2
    80002f34:	fffff097          	auipc	ra,0xfffff
    80002f38:	4ae080e7          	jalr	1198(ra) # 800023e2 <bread>
    80002f3c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3e:	3ff4f613          	andi	a2,s1,1023
    80002f42:	40cd07bb          	subw	a5,s10,a2
    80002f46:	413b073b          	subw	a4,s6,s3
    80002f4a:	8a3e                	mv	s4,a5
    80002f4c:	2781                	sext.w	a5,a5
    80002f4e:	0007069b          	sext.w	a3,a4
    80002f52:	f8f6f9e3          	bgeu	a3,a5,80002ee4 <readi+0x4c>
    80002f56:	8a3a                	mv	s4,a4
    80002f58:	b771                	j	80002ee4 <readi+0x4c>
      brelse(bp);
    80002f5a:	854a                	mv	a0,s2
    80002f5c:	fffff097          	auipc	ra,0xfffff
    80002f60:	5b6080e7          	jalr	1462(ra) # 80002512 <brelse>
      tot = -1;
    80002f64:	59fd                	li	s3,-1
  }
  return tot;
    80002f66:	0009851b          	sext.w	a0,s3
}
    80002f6a:	70a6                	ld	ra,104(sp)
    80002f6c:	7406                	ld	s0,96(sp)
    80002f6e:	64e6                	ld	s1,88(sp)
    80002f70:	6946                	ld	s2,80(sp)
    80002f72:	69a6                	ld	s3,72(sp)
    80002f74:	6a06                	ld	s4,64(sp)
    80002f76:	7ae2                	ld	s5,56(sp)
    80002f78:	7b42                	ld	s6,48(sp)
    80002f7a:	7ba2                	ld	s7,40(sp)
    80002f7c:	7c02                	ld	s8,32(sp)
    80002f7e:	6ce2                	ld	s9,24(sp)
    80002f80:	6d42                	ld	s10,16(sp)
    80002f82:	6da2                	ld	s11,8(sp)
    80002f84:	6165                	addi	sp,sp,112
    80002f86:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f88:	89da                	mv	s3,s6
    80002f8a:	bff1                	j	80002f66 <readi+0xce>
    return 0;
    80002f8c:	4501                	li	a0,0
}
    80002f8e:	8082                	ret

0000000080002f90 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f90:	457c                	lw	a5,76(a0)
    80002f92:	10d7e863          	bltu	a5,a3,800030a2 <writei+0x112>
{
    80002f96:	7159                	addi	sp,sp,-112
    80002f98:	f486                	sd	ra,104(sp)
    80002f9a:	f0a2                	sd	s0,96(sp)
    80002f9c:	eca6                	sd	s1,88(sp)
    80002f9e:	e8ca                	sd	s2,80(sp)
    80002fa0:	e4ce                	sd	s3,72(sp)
    80002fa2:	e0d2                	sd	s4,64(sp)
    80002fa4:	fc56                	sd	s5,56(sp)
    80002fa6:	f85a                	sd	s6,48(sp)
    80002fa8:	f45e                	sd	s7,40(sp)
    80002faa:	f062                	sd	s8,32(sp)
    80002fac:	ec66                	sd	s9,24(sp)
    80002fae:	e86a                	sd	s10,16(sp)
    80002fb0:	e46e                	sd	s11,8(sp)
    80002fb2:	1880                	addi	s0,sp,112
    80002fb4:	8b2a                	mv	s6,a0
    80002fb6:	8c2e                	mv	s8,a1
    80002fb8:	8ab2                	mv	s5,a2
    80002fba:	8936                	mv	s2,a3
    80002fbc:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fbe:	00e687bb          	addw	a5,a3,a4
    80002fc2:	0ed7e263          	bltu	a5,a3,800030a6 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fc6:	00043737          	lui	a4,0x43
    80002fca:	0ef76063          	bltu	a4,a5,800030aa <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fce:	0c0b8863          	beqz	s7,8000309e <writei+0x10e>
    80002fd2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fd4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fd8:	5cfd                	li	s9,-1
    80002fda:	a091                	j	8000301e <writei+0x8e>
    80002fdc:	02099d93          	slli	s11,s3,0x20
    80002fe0:	020ddd93          	srli	s11,s11,0x20
    80002fe4:	05848793          	addi	a5,s1,88
    80002fe8:	86ee                	mv	a3,s11
    80002fea:	8656                	mv	a2,s5
    80002fec:	85e2                	mv	a1,s8
    80002fee:	953e                	add	a0,a0,a5
    80002ff0:	fffff097          	auipc	ra,0xfffff
    80002ff4:	962080e7          	jalr	-1694(ra) # 80001952 <either_copyin>
    80002ff8:	07950263          	beq	a0,s9,8000305c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ffc:	8526                	mv	a0,s1
    80002ffe:	00000097          	auipc	ra,0x0
    80003002:	790080e7          	jalr	1936(ra) # 8000378e <log_write>
    brelse(bp);
    80003006:	8526                	mv	a0,s1
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	50a080e7          	jalr	1290(ra) # 80002512 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003010:	01498a3b          	addw	s4,s3,s4
    80003014:	0129893b          	addw	s2,s3,s2
    80003018:	9aee                	add	s5,s5,s11
    8000301a:	057a7663          	bgeu	s4,s7,80003066 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000301e:	000b2483          	lw	s1,0(s6)
    80003022:	00a9559b          	srliw	a1,s2,0xa
    80003026:	855a                	mv	a0,s6
    80003028:	fffff097          	auipc	ra,0xfffff
    8000302c:	7ae080e7          	jalr	1966(ra) # 800027d6 <bmap>
    80003030:	0005059b          	sext.w	a1,a0
    80003034:	8526                	mv	a0,s1
    80003036:	fffff097          	auipc	ra,0xfffff
    8000303a:	3ac080e7          	jalr	940(ra) # 800023e2 <bread>
    8000303e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003040:	3ff97513          	andi	a0,s2,1023
    80003044:	40ad07bb          	subw	a5,s10,a0
    80003048:	414b873b          	subw	a4,s7,s4
    8000304c:	89be                	mv	s3,a5
    8000304e:	2781                	sext.w	a5,a5
    80003050:	0007069b          	sext.w	a3,a4
    80003054:	f8f6f4e3          	bgeu	a3,a5,80002fdc <writei+0x4c>
    80003058:	89ba                	mv	s3,a4
    8000305a:	b749                	j	80002fdc <writei+0x4c>
      brelse(bp);
    8000305c:	8526                	mv	a0,s1
    8000305e:	fffff097          	auipc	ra,0xfffff
    80003062:	4b4080e7          	jalr	1204(ra) # 80002512 <brelse>
  }

  if(off > ip->size)
    80003066:	04cb2783          	lw	a5,76(s6)
    8000306a:	0127f463          	bgeu	a5,s2,80003072 <writei+0xe2>
    ip->size = off;
    8000306e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003072:	855a                	mv	a0,s6
    80003074:	00000097          	auipc	ra,0x0
    80003078:	aa6080e7          	jalr	-1370(ra) # 80002b1a <iupdate>

  return tot;
    8000307c:	000a051b          	sext.w	a0,s4
}
    80003080:	70a6                	ld	ra,104(sp)
    80003082:	7406                	ld	s0,96(sp)
    80003084:	64e6                	ld	s1,88(sp)
    80003086:	6946                	ld	s2,80(sp)
    80003088:	69a6                	ld	s3,72(sp)
    8000308a:	6a06                	ld	s4,64(sp)
    8000308c:	7ae2                	ld	s5,56(sp)
    8000308e:	7b42                	ld	s6,48(sp)
    80003090:	7ba2                	ld	s7,40(sp)
    80003092:	7c02                	ld	s8,32(sp)
    80003094:	6ce2                	ld	s9,24(sp)
    80003096:	6d42                	ld	s10,16(sp)
    80003098:	6da2                	ld	s11,8(sp)
    8000309a:	6165                	addi	sp,sp,112
    8000309c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000309e:	8a5e                	mv	s4,s7
    800030a0:	bfc9                	j	80003072 <writei+0xe2>
    return -1;
    800030a2:	557d                	li	a0,-1
}
    800030a4:	8082                	ret
    return -1;
    800030a6:	557d                	li	a0,-1
    800030a8:	bfe1                	j	80003080 <writei+0xf0>
    return -1;
    800030aa:	557d                	li	a0,-1
    800030ac:	bfd1                	j	80003080 <writei+0xf0>

00000000800030ae <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030ae:	1141                	addi	sp,sp,-16
    800030b0:	e406                	sd	ra,8(sp)
    800030b2:	e022                	sd	s0,0(sp)
    800030b4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030b6:	4639                	li	a2,14
    800030b8:	ffffd097          	auipc	ra,0xffffd
    800030bc:	1da080e7          	jalr	474(ra) # 80000292 <strncmp>
}
    800030c0:	60a2                	ld	ra,8(sp)
    800030c2:	6402                	ld	s0,0(sp)
    800030c4:	0141                	addi	sp,sp,16
    800030c6:	8082                	ret

00000000800030c8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030c8:	7139                	addi	sp,sp,-64
    800030ca:	fc06                	sd	ra,56(sp)
    800030cc:	f822                	sd	s0,48(sp)
    800030ce:	f426                	sd	s1,40(sp)
    800030d0:	f04a                	sd	s2,32(sp)
    800030d2:	ec4e                	sd	s3,24(sp)
    800030d4:	e852                	sd	s4,16(sp)
    800030d6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030d8:	04451703          	lh	a4,68(a0)
    800030dc:	4785                	li	a5,1
    800030de:	00f71a63          	bne	a4,a5,800030f2 <dirlookup+0x2a>
    800030e2:	892a                	mv	s2,a0
    800030e4:	89ae                	mv	s3,a1
    800030e6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e8:	457c                	lw	a5,76(a0)
    800030ea:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030ec:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ee:	e79d                	bnez	a5,8000311c <dirlookup+0x54>
    800030f0:	a8a5                	j	80003168 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030f2:	00005517          	auipc	a0,0x5
    800030f6:	44650513          	addi	a0,a0,1094 # 80008538 <etext+0x538>
    800030fa:	00003097          	auipc	ra,0x3
    800030fe:	b5a080e7          	jalr	-1190(ra) # 80005c54 <panic>
      panic("dirlookup read");
    80003102:	00005517          	auipc	a0,0x5
    80003106:	44e50513          	addi	a0,a0,1102 # 80008550 <etext+0x550>
    8000310a:	00003097          	auipc	ra,0x3
    8000310e:	b4a080e7          	jalr	-1206(ra) # 80005c54 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003112:	24c1                	addiw	s1,s1,16
    80003114:	04c92783          	lw	a5,76(s2)
    80003118:	04f4f763          	bgeu	s1,a5,80003166 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000311c:	4741                	li	a4,16
    8000311e:	86a6                	mv	a3,s1
    80003120:	fc040613          	addi	a2,s0,-64
    80003124:	4581                	li	a1,0
    80003126:	854a                	mv	a0,s2
    80003128:	00000097          	auipc	ra,0x0
    8000312c:	d70080e7          	jalr	-656(ra) # 80002e98 <readi>
    80003130:	47c1                	li	a5,16
    80003132:	fcf518e3          	bne	a0,a5,80003102 <dirlookup+0x3a>
    if(de.inum == 0)
    80003136:	fc045783          	lhu	a5,-64(s0)
    8000313a:	dfe1                	beqz	a5,80003112 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000313c:	fc240593          	addi	a1,s0,-62
    80003140:	854e                	mv	a0,s3
    80003142:	00000097          	auipc	ra,0x0
    80003146:	f6c080e7          	jalr	-148(ra) # 800030ae <namecmp>
    8000314a:	f561                	bnez	a0,80003112 <dirlookup+0x4a>
      if(poff)
    8000314c:	000a0463          	beqz	s4,80003154 <dirlookup+0x8c>
        *poff = off;
    80003150:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003154:	fc045583          	lhu	a1,-64(s0)
    80003158:	00092503          	lw	a0,0(s2)
    8000315c:	fffff097          	auipc	ra,0xfffff
    80003160:	754080e7          	jalr	1876(ra) # 800028b0 <iget>
    80003164:	a011                	j	80003168 <dirlookup+0xa0>
  return 0;
    80003166:	4501                	li	a0,0
}
    80003168:	70e2                	ld	ra,56(sp)
    8000316a:	7442                	ld	s0,48(sp)
    8000316c:	74a2                	ld	s1,40(sp)
    8000316e:	7902                	ld	s2,32(sp)
    80003170:	69e2                	ld	s3,24(sp)
    80003172:	6a42                	ld	s4,16(sp)
    80003174:	6121                	addi	sp,sp,64
    80003176:	8082                	ret

0000000080003178 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003178:	711d                	addi	sp,sp,-96
    8000317a:	ec86                	sd	ra,88(sp)
    8000317c:	e8a2                	sd	s0,80(sp)
    8000317e:	e4a6                	sd	s1,72(sp)
    80003180:	e0ca                	sd	s2,64(sp)
    80003182:	fc4e                	sd	s3,56(sp)
    80003184:	f852                	sd	s4,48(sp)
    80003186:	f456                	sd	s5,40(sp)
    80003188:	f05a                	sd	s6,32(sp)
    8000318a:	ec5e                	sd	s7,24(sp)
    8000318c:	e862                	sd	s8,16(sp)
    8000318e:	e466                	sd	s9,8(sp)
    80003190:	1080                	addi	s0,sp,96
    80003192:	84aa                	mv	s1,a0
    80003194:	8aae                	mv	s5,a1
    80003196:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003198:	00054703          	lbu	a4,0(a0)
    8000319c:	02f00793          	li	a5,47
    800031a0:	02f70363          	beq	a4,a5,800031c6 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031a4:	ffffe097          	auipc	ra,0xffffe
    800031a8:	ce8080e7          	jalr	-792(ra) # 80000e8c <myproc>
    800031ac:	15053503          	ld	a0,336(a0)
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	9f6080e7          	jalr	-1546(ra) # 80002ba6 <idup>
    800031b8:	89aa                	mv	s3,a0
  while(*path == '/')
    800031ba:	02f00913          	li	s2,47
  len = path - s;
    800031be:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800031c0:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031c2:	4b85                	li	s7,1
    800031c4:	a865                	j	8000327c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031c6:	4585                	li	a1,1
    800031c8:	4505                	li	a0,1
    800031ca:	fffff097          	auipc	ra,0xfffff
    800031ce:	6e6080e7          	jalr	1766(ra) # 800028b0 <iget>
    800031d2:	89aa                	mv	s3,a0
    800031d4:	b7dd                	j	800031ba <namex+0x42>
      iunlockput(ip);
    800031d6:	854e                	mv	a0,s3
    800031d8:	00000097          	auipc	ra,0x0
    800031dc:	c6e080e7          	jalr	-914(ra) # 80002e46 <iunlockput>
      return 0;
    800031e0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031e2:	854e                	mv	a0,s3
    800031e4:	60e6                	ld	ra,88(sp)
    800031e6:	6446                	ld	s0,80(sp)
    800031e8:	64a6                	ld	s1,72(sp)
    800031ea:	6906                	ld	s2,64(sp)
    800031ec:	79e2                	ld	s3,56(sp)
    800031ee:	7a42                	ld	s4,48(sp)
    800031f0:	7aa2                	ld	s5,40(sp)
    800031f2:	7b02                	ld	s6,32(sp)
    800031f4:	6be2                	ld	s7,24(sp)
    800031f6:	6c42                	ld	s8,16(sp)
    800031f8:	6ca2                	ld	s9,8(sp)
    800031fa:	6125                	addi	sp,sp,96
    800031fc:	8082                	ret
      iunlock(ip);
    800031fe:	854e                	mv	a0,s3
    80003200:	00000097          	auipc	ra,0x0
    80003204:	aa6080e7          	jalr	-1370(ra) # 80002ca6 <iunlock>
      return ip;
    80003208:	bfe9                	j	800031e2 <namex+0x6a>
      iunlockput(ip);
    8000320a:	854e                	mv	a0,s3
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	c3a080e7          	jalr	-966(ra) # 80002e46 <iunlockput>
      return 0;
    80003214:	89e6                	mv	s3,s9
    80003216:	b7f1                	j	800031e2 <namex+0x6a>
  len = path - s;
    80003218:	40b48633          	sub	a2,s1,a1
    8000321c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003220:	099c5463          	bge	s8,s9,800032a8 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003224:	4639                	li	a2,14
    80003226:	8552                	mv	a0,s4
    80003228:	ffffd097          	auipc	ra,0xffffd
    8000322c:	ff6080e7          	jalr	-10(ra) # 8000021e <memmove>
  while(*path == '/')
    80003230:	0004c783          	lbu	a5,0(s1)
    80003234:	01279763          	bne	a5,s2,80003242 <namex+0xca>
    path++;
    80003238:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000323a:	0004c783          	lbu	a5,0(s1)
    8000323e:	ff278de3          	beq	a5,s2,80003238 <namex+0xc0>
    ilock(ip);
    80003242:	854e                	mv	a0,s3
    80003244:	00000097          	auipc	ra,0x0
    80003248:	9a0080e7          	jalr	-1632(ra) # 80002be4 <ilock>
    if(ip->type != T_DIR){
    8000324c:	04499783          	lh	a5,68(s3)
    80003250:	f97793e3          	bne	a5,s7,800031d6 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003254:	000a8563          	beqz	s5,8000325e <namex+0xe6>
    80003258:	0004c783          	lbu	a5,0(s1)
    8000325c:	d3cd                	beqz	a5,800031fe <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000325e:	865a                	mv	a2,s6
    80003260:	85d2                	mv	a1,s4
    80003262:	854e                	mv	a0,s3
    80003264:	00000097          	auipc	ra,0x0
    80003268:	e64080e7          	jalr	-412(ra) # 800030c8 <dirlookup>
    8000326c:	8caa                	mv	s9,a0
    8000326e:	dd51                	beqz	a0,8000320a <namex+0x92>
    iunlockput(ip);
    80003270:	854e                	mv	a0,s3
    80003272:	00000097          	auipc	ra,0x0
    80003276:	bd4080e7          	jalr	-1068(ra) # 80002e46 <iunlockput>
    ip = next;
    8000327a:	89e6                	mv	s3,s9
  while(*path == '/')
    8000327c:	0004c783          	lbu	a5,0(s1)
    80003280:	05279763          	bne	a5,s2,800032ce <namex+0x156>
    path++;
    80003284:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003286:	0004c783          	lbu	a5,0(s1)
    8000328a:	ff278de3          	beq	a5,s2,80003284 <namex+0x10c>
  if(*path == 0)
    8000328e:	c79d                	beqz	a5,800032bc <namex+0x144>
    path++;
    80003290:	85a6                	mv	a1,s1
  len = path - s;
    80003292:	8cda                	mv	s9,s6
    80003294:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003296:	01278963          	beq	a5,s2,800032a8 <namex+0x130>
    8000329a:	dfbd                	beqz	a5,80003218 <namex+0xa0>
    path++;
    8000329c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000329e:	0004c783          	lbu	a5,0(s1)
    800032a2:	ff279ce3          	bne	a5,s2,8000329a <namex+0x122>
    800032a6:	bf8d                	j	80003218 <namex+0xa0>
    memmove(name, s, len);
    800032a8:	2601                	sext.w	a2,a2
    800032aa:	8552                	mv	a0,s4
    800032ac:	ffffd097          	auipc	ra,0xffffd
    800032b0:	f72080e7          	jalr	-142(ra) # 8000021e <memmove>
    name[len] = 0;
    800032b4:	9cd2                	add	s9,s9,s4
    800032b6:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032ba:	bf9d                	j	80003230 <namex+0xb8>
  if(nameiparent){
    800032bc:	f20a83e3          	beqz	s5,800031e2 <namex+0x6a>
    iput(ip);
    800032c0:	854e                	mv	a0,s3
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	adc080e7          	jalr	-1316(ra) # 80002d9e <iput>
    return 0;
    800032ca:	4981                	li	s3,0
    800032cc:	bf19                	j	800031e2 <namex+0x6a>
  if(*path == 0)
    800032ce:	d7fd                	beqz	a5,800032bc <namex+0x144>
  while(*path != '/' && *path != 0)
    800032d0:	0004c783          	lbu	a5,0(s1)
    800032d4:	85a6                	mv	a1,s1
    800032d6:	b7d1                	j	8000329a <namex+0x122>

00000000800032d8 <dirlink>:
{
    800032d8:	7139                	addi	sp,sp,-64
    800032da:	fc06                	sd	ra,56(sp)
    800032dc:	f822                	sd	s0,48(sp)
    800032de:	f426                	sd	s1,40(sp)
    800032e0:	f04a                	sd	s2,32(sp)
    800032e2:	ec4e                	sd	s3,24(sp)
    800032e4:	e852                	sd	s4,16(sp)
    800032e6:	0080                	addi	s0,sp,64
    800032e8:	892a                	mv	s2,a0
    800032ea:	8a2e                	mv	s4,a1
    800032ec:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032ee:	4601                	li	a2,0
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	dd8080e7          	jalr	-552(ra) # 800030c8 <dirlookup>
    800032f8:	e93d                	bnez	a0,8000336e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032fa:	04c92483          	lw	s1,76(s2)
    800032fe:	c49d                	beqz	s1,8000332c <dirlink+0x54>
    80003300:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003302:	4741                	li	a4,16
    80003304:	86a6                	mv	a3,s1
    80003306:	fc040613          	addi	a2,s0,-64
    8000330a:	4581                	li	a1,0
    8000330c:	854a                	mv	a0,s2
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	b8a080e7          	jalr	-1142(ra) # 80002e98 <readi>
    80003316:	47c1                	li	a5,16
    80003318:	06f51163          	bne	a0,a5,8000337a <dirlink+0xa2>
    if(de.inum == 0)
    8000331c:	fc045783          	lhu	a5,-64(s0)
    80003320:	c791                	beqz	a5,8000332c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003322:	24c1                	addiw	s1,s1,16
    80003324:	04c92783          	lw	a5,76(s2)
    80003328:	fcf4ede3          	bltu	s1,a5,80003302 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000332c:	4639                	li	a2,14
    8000332e:	85d2                	mv	a1,s4
    80003330:	fc240513          	addi	a0,s0,-62
    80003334:	ffffd097          	auipc	ra,0xffffd
    80003338:	f9a080e7          	jalr	-102(ra) # 800002ce <strncpy>
  de.inum = inum;
    8000333c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003340:	4741                	li	a4,16
    80003342:	86a6                	mv	a3,s1
    80003344:	fc040613          	addi	a2,s0,-64
    80003348:	4581                	li	a1,0
    8000334a:	854a                	mv	a0,s2
    8000334c:	00000097          	auipc	ra,0x0
    80003350:	c44080e7          	jalr	-956(ra) # 80002f90 <writei>
    80003354:	872a                	mv	a4,a0
    80003356:	47c1                	li	a5,16
  return 0;
    80003358:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000335a:	02f71863          	bne	a4,a5,8000338a <dirlink+0xb2>
}
    8000335e:	70e2                	ld	ra,56(sp)
    80003360:	7442                	ld	s0,48(sp)
    80003362:	74a2                	ld	s1,40(sp)
    80003364:	7902                	ld	s2,32(sp)
    80003366:	69e2                	ld	s3,24(sp)
    80003368:	6a42                	ld	s4,16(sp)
    8000336a:	6121                	addi	sp,sp,64
    8000336c:	8082                	ret
    iput(ip);
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	a30080e7          	jalr	-1488(ra) # 80002d9e <iput>
    return -1;
    80003376:	557d                	li	a0,-1
    80003378:	b7dd                	j	8000335e <dirlink+0x86>
      panic("dirlink read");
    8000337a:	00005517          	auipc	a0,0x5
    8000337e:	1e650513          	addi	a0,a0,486 # 80008560 <etext+0x560>
    80003382:	00003097          	auipc	ra,0x3
    80003386:	8d2080e7          	jalr	-1838(ra) # 80005c54 <panic>
    panic("dirlink");
    8000338a:	00005517          	auipc	a0,0x5
    8000338e:	2de50513          	addi	a0,a0,734 # 80008668 <etext+0x668>
    80003392:	00003097          	auipc	ra,0x3
    80003396:	8c2080e7          	jalr	-1854(ra) # 80005c54 <panic>

000000008000339a <namei>:

struct inode*
namei(char *path)
{
    8000339a:	1101                	addi	sp,sp,-32
    8000339c:	ec06                	sd	ra,24(sp)
    8000339e:	e822                	sd	s0,16(sp)
    800033a0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033a2:	fe040613          	addi	a2,s0,-32
    800033a6:	4581                	li	a1,0
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	dd0080e7          	jalr	-560(ra) # 80003178 <namex>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret

00000000800033b8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033b8:	1141                	addi	sp,sp,-16
    800033ba:	e406                	sd	ra,8(sp)
    800033bc:	e022                	sd	s0,0(sp)
    800033be:	0800                	addi	s0,sp,16
    800033c0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033c2:	4585                	li	a1,1
    800033c4:	00000097          	auipc	ra,0x0
    800033c8:	db4080e7          	jalr	-588(ra) # 80003178 <namex>
}
    800033cc:	60a2                	ld	ra,8(sp)
    800033ce:	6402                	ld	s0,0(sp)
    800033d0:	0141                	addi	sp,sp,16
    800033d2:	8082                	ret

00000000800033d4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033d4:	1101                	addi	sp,sp,-32
    800033d6:	ec06                	sd	ra,24(sp)
    800033d8:	e822                	sd	s0,16(sp)
    800033da:	e426                	sd	s1,8(sp)
    800033dc:	e04a                	sd	s2,0(sp)
    800033de:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033e0:	00016917          	auipc	s2,0x16
    800033e4:	e4090913          	addi	s2,s2,-448 # 80019220 <log>
    800033e8:	01892583          	lw	a1,24(s2)
    800033ec:	02892503          	lw	a0,40(s2)
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	ff2080e7          	jalr	-14(ra) # 800023e2 <bread>
    800033f8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033fa:	02c92683          	lw	a3,44(s2)
    800033fe:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003400:	02d05763          	blez	a3,8000342e <write_head+0x5a>
    80003404:	00016797          	auipc	a5,0x16
    80003408:	e4c78793          	addi	a5,a5,-436 # 80019250 <log+0x30>
    8000340c:	05c50713          	addi	a4,a0,92
    80003410:	36fd                	addiw	a3,a3,-1
    80003412:	1682                	slli	a3,a3,0x20
    80003414:	9281                	srli	a3,a3,0x20
    80003416:	068a                	slli	a3,a3,0x2
    80003418:	00016617          	auipc	a2,0x16
    8000341c:	e3c60613          	addi	a2,a2,-452 # 80019254 <log+0x34>
    80003420:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003422:	4390                	lw	a2,0(a5)
    80003424:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003426:	0791                	addi	a5,a5,4
    80003428:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000342a:	fed79ce3          	bne	a5,a3,80003422 <write_head+0x4e>
  }
  bwrite(buf);
    8000342e:	8526                	mv	a0,s1
    80003430:	fffff097          	auipc	ra,0xfffff
    80003434:	0a4080e7          	jalr	164(ra) # 800024d4 <bwrite>
  brelse(buf);
    80003438:	8526                	mv	a0,s1
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	0d8080e7          	jalr	216(ra) # 80002512 <brelse>
}
    80003442:	60e2                	ld	ra,24(sp)
    80003444:	6442                	ld	s0,16(sp)
    80003446:	64a2                	ld	s1,8(sp)
    80003448:	6902                	ld	s2,0(sp)
    8000344a:	6105                	addi	sp,sp,32
    8000344c:	8082                	ret

000000008000344e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000344e:	00016797          	auipc	a5,0x16
    80003452:	dfe7a783          	lw	a5,-514(a5) # 8001924c <log+0x2c>
    80003456:	0af05d63          	blez	a5,80003510 <install_trans+0xc2>
{
    8000345a:	7139                	addi	sp,sp,-64
    8000345c:	fc06                	sd	ra,56(sp)
    8000345e:	f822                	sd	s0,48(sp)
    80003460:	f426                	sd	s1,40(sp)
    80003462:	f04a                	sd	s2,32(sp)
    80003464:	ec4e                	sd	s3,24(sp)
    80003466:	e852                	sd	s4,16(sp)
    80003468:	e456                	sd	s5,8(sp)
    8000346a:	e05a                	sd	s6,0(sp)
    8000346c:	0080                	addi	s0,sp,64
    8000346e:	8b2a                	mv	s6,a0
    80003470:	00016a97          	auipc	s5,0x16
    80003474:	de0a8a93          	addi	s5,s5,-544 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003478:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000347a:	00016997          	auipc	s3,0x16
    8000347e:	da698993          	addi	s3,s3,-602 # 80019220 <log>
    80003482:	a00d                	j	800034a4 <install_trans+0x56>
    brelse(lbuf);
    80003484:	854a                	mv	a0,s2
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	08c080e7          	jalr	140(ra) # 80002512 <brelse>
    brelse(dbuf);
    8000348e:	8526                	mv	a0,s1
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	082080e7          	jalr	130(ra) # 80002512 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003498:	2a05                	addiw	s4,s4,1
    8000349a:	0a91                	addi	s5,s5,4
    8000349c:	02c9a783          	lw	a5,44(s3)
    800034a0:	04fa5e63          	bge	s4,a5,800034fc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a4:	0189a583          	lw	a1,24(s3)
    800034a8:	014585bb          	addw	a1,a1,s4
    800034ac:	2585                	addiw	a1,a1,1
    800034ae:	0289a503          	lw	a0,40(s3)
    800034b2:	fffff097          	auipc	ra,0xfffff
    800034b6:	f30080e7          	jalr	-208(ra) # 800023e2 <bread>
    800034ba:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034bc:	000aa583          	lw	a1,0(s5)
    800034c0:	0289a503          	lw	a0,40(s3)
    800034c4:	fffff097          	auipc	ra,0xfffff
    800034c8:	f1e080e7          	jalr	-226(ra) # 800023e2 <bread>
    800034cc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034ce:	40000613          	li	a2,1024
    800034d2:	05890593          	addi	a1,s2,88
    800034d6:	05850513          	addi	a0,a0,88
    800034da:	ffffd097          	auipc	ra,0xffffd
    800034de:	d44080e7          	jalr	-700(ra) # 8000021e <memmove>
    bwrite(dbuf);  // write dst to disk
    800034e2:	8526                	mv	a0,s1
    800034e4:	fffff097          	auipc	ra,0xfffff
    800034e8:	ff0080e7          	jalr	-16(ra) # 800024d4 <bwrite>
    if(recovering == 0)
    800034ec:	f80b1ce3          	bnez	s6,80003484 <install_trans+0x36>
      bunpin(dbuf);
    800034f0:	8526                	mv	a0,s1
    800034f2:	fffff097          	auipc	ra,0xfffff
    800034f6:	0fa080e7          	jalr	250(ra) # 800025ec <bunpin>
    800034fa:	b769                	j	80003484 <install_trans+0x36>
}
    800034fc:	70e2                	ld	ra,56(sp)
    800034fe:	7442                	ld	s0,48(sp)
    80003500:	74a2                	ld	s1,40(sp)
    80003502:	7902                	ld	s2,32(sp)
    80003504:	69e2                	ld	s3,24(sp)
    80003506:	6a42                	ld	s4,16(sp)
    80003508:	6aa2                	ld	s5,8(sp)
    8000350a:	6b02                	ld	s6,0(sp)
    8000350c:	6121                	addi	sp,sp,64
    8000350e:	8082                	ret
    80003510:	8082                	ret

0000000080003512 <initlog>:
{
    80003512:	7179                	addi	sp,sp,-48
    80003514:	f406                	sd	ra,40(sp)
    80003516:	f022                	sd	s0,32(sp)
    80003518:	ec26                	sd	s1,24(sp)
    8000351a:	e84a                	sd	s2,16(sp)
    8000351c:	e44e                	sd	s3,8(sp)
    8000351e:	1800                	addi	s0,sp,48
    80003520:	892a                	mv	s2,a0
    80003522:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003524:	00016497          	auipc	s1,0x16
    80003528:	cfc48493          	addi	s1,s1,-772 # 80019220 <log>
    8000352c:	00005597          	auipc	a1,0x5
    80003530:	04458593          	addi	a1,a1,68 # 80008570 <etext+0x570>
    80003534:	8526                	mv	a0,s1
    80003536:	00003097          	auipc	ra,0x3
    8000353a:	bca080e7          	jalr	-1078(ra) # 80006100 <initlock>
  log.start = sb->logstart;
    8000353e:	0149a583          	lw	a1,20(s3)
    80003542:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003544:	0109a783          	lw	a5,16(s3)
    80003548:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000354a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000354e:	854a                	mv	a0,s2
    80003550:	fffff097          	auipc	ra,0xfffff
    80003554:	e92080e7          	jalr	-366(ra) # 800023e2 <bread>
  log.lh.n = lh->n;
    80003558:	4d34                	lw	a3,88(a0)
    8000355a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000355c:	02d05563          	blez	a3,80003586 <initlog+0x74>
    80003560:	05c50793          	addi	a5,a0,92
    80003564:	00016717          	auipc	a4,0x16
    80003568:	cec70713          	addi	a4,a4,-788 # 80019250 <log+0x30>
    8000356c:	36fd                	addiw	a3,a3,-1
    8000356e:	1682                	slli	a3,a3,0x20
    80003570:	9281                	srli	a3,a3,0x20
    80003572:	068a                	slli	a3,a3,0x2
    80003574:	06050613          	addi	a2,a0,96
    80003578:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000357a:	4390                	lw	a2,0(a5)
    8000357c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000357e:	0791                	addi	a5,a5,4
    80003580:	0711                	addi	a4,a4,4
    80003582:	fed79ce3          	bne	a5,a3,8000357a <initlog+0x68>
  brelse(buf);
    80003586:	fffff097          	auipc	ra,0xfffff
    8000358a:	f8c080e7          	jalr	-116(ra) # 80002512 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000358e:	4505                	li	a0,1
    80003590:	00000097          	auipc	ra,0x0
    80003594:	ebe080e7          	jalr	-322(ra) # 8000344e <install_trans>
  log.lh.n = 0;
    80003598:	00016797          	auipc	a5,0x16
    8000359c:	ca07aa23          	sw	zero,-844(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800035a0:	00000097          	auipc	ra,0x0
    800035a4:	e34080e7          	jalr	-460(ra) # 800033d4 <write_head>
}
    800035a8:	70a2                	ld	ra,40(sp)
    800035aa:	7402                	ld	s0,32(sp)
    800035ac:	64e2                	ld	s1,24(sp)
    800035ae:	6942                	ld	s2,16(sp)
    800035b0:	69a2                	ld	s3,8(sp)
    800035b2:	6145                	addi	sp,sp,48
    800035b4:	8082                	ret

00000000800035b6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035b6:	1101                	addi	sp,sp,-32
    800035b8:	ec06                	sd	ra,24(sp)
    800035ba:	e822                	sd	s0,16(sp)
    800035bc:	e426                	sd	s1,8(sp)
    800035be:	e04a                	sd	s2,0(sp)
    800035c0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035c2:	00016517          	auipc	a0,0x16
    800035c6:	c5e50513          	addi	a0,a0,-930 # 80019220 <log>
    800035ca:	00003097          	auipc	ra,0x3
    800035ce:	bc6080e7          	jalr	-1082(ra) # 80006190 <acquire>
  while(1){
    if(log.committing){
    800035d2:	00016497          	auipc	s1,0x16
    800035d6:	c4e48493          	addi	s1,s1,-946 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035da:	4979                	li	s2,30
    800035dc:	a039                	j	800035ea <begin_op+0x34>
      sleep(&log, &log.lock);
    800035de:	85a6                	mv	a1,s1
    800035e0:	8526                	mv	a0,s1
    800035e2:	ffffe097          	auipc	ra,0xffffe
    800035e6:	f76080e7          	jalr	-138(ra) # 80001558 <sleep>
    if(log.committing){
    800035ea:	50dc                	lw	a5,36(s1)
    800035ec:	fbed                	bnez	a5,800035de <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ee:	509c                	lw	a5,32(s1)
    800035f0:	0017871b          	addiw	a4,a5,1
    800035f4:	0007069b          	sext.w	a3,a4
    800035f8:	0027179b          	slliw	a5,a4,0x2
    800035fc:	9fb9                	addw	a5,a5,a4
    800035fe:	0017979b          	slliw	a5,a5,0x1
    80003602:	54d8                	lw	a4,44(s1)
    80003604:	9fb9                	addw	a5,a5,a4
    80003606:	00f95963          	bge	s2,a5,80003618 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000360a:	85a6                	mv	a1,s1
    8000360c:	8526                	mv	a0,s1
    8000360e:	ffffe097          	auipc	ra,0xffffe
    80003612:	f4a080e7          	jalr	-182(ra) # 80001558 <sleep>
    80003616:	bfd1                	j	800035ea <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003618:	00016517          	auipc	a0,0x16
    8000361c:	c0850513          	addi	a0,a0,-1016 # 80019220 <log>
    80003620:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003622:	00003097          	auipc	ra,0x3
    80003626:	c22080e7          	jalr	-990(ra) # 80006244 <release>
      break;
    }
  }
}
    8000362a:	60e2                	ld	ra,24(sp)
    8000362c:	6442                	ld	s0,16(sp)
    8000362e:	64a2                	ld	s1,8(sp)
    80003630:	6902                	ld	s2,0(sp)
    80003632:	6105                	addi	sp,sp,32
    80003634:	8082                	ret

0000000080003636 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003636:	7139                	addi	sp,sp,-64
    80003638:	fc06                	sd	ra,56(sp)
    8000363a:	f822                	sd	s0,48(sp)
    8000363c:	f426                	sd	s1,40(sp)
    8000363e:	f04a                	sd	s2,32(sp)
    80003640:	ec4e                	sd	s3,24(sp)
    80003642:	e852                	sd	s4,16(sp)
    80003644:	e456                	sd	s5,8(sp)
    80003646:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003648:	00016497          	auipc	s1,0x16
    8000364c:	bd848493          	addi	s1,s1,-1064 # 80019220 <log>
    80003650:	8526                	mv	a0,s1
    80003652:	00003097          	auipc	ra,0x3
    80003656:	b3e080e7          	jalr	-1218(ra) # 80006190 <acquire>
  log.outstanding -= 1;
    8000365a:	509c                	lw	a5,32(s1)
    8000365c:	37fd                	addiw	a5,a5,-1
    8000365e:	0007891b          	sext.w	s2,a5
    80003662:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003664:	50dc                	lw	a5,36(s1)
    80003666:	e7b9                	bnez	a5,800036b4 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003668:	04091e63          	bnez	s2,800036c4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000366c:	00016497          	auipc	s1,0x16
    80003670:	bb448493          	addi	s1,s1,-1100 # 80019220 <log>
    80003674:	4785                	li	a5,1
    80003676:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003678:	8526                	mv	a0,s1
    8000367a:	00003097          	auipc	ra,0x3
    8000367e:	bca080e7          	jalr	-1078(ra) # 80006244 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003682:	54dc                	lw	a5,44(s1)
    80003684:	06f04763          	bgtz	a5,800036f2 <end_op+0xbc>
    acquire(&log.lock);
    80003688:	00016497          	auipc	s1,0x16
    8000368c:	b9848493          	addi	s1,s1,-1128 # 80019220 <log>
    80003690:	8526                	mv	a0,s1
    80003692:	00003097          	auipc	ra,0x3
    80003696:	afe080e7          	jalr	-1282(ra) # 80006190 <acquire>
    log.committing = 0;
    8000369a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000369e:	8526                	mv	a0,s1
    800036a0:	ffffe097          	auipc	ra,0xffffe
    800036a4:	044080e7          	jalr	68(ra) # 800016e4 <wakeup>
    release(&log.lock);
    800036a8:	8526                	mv	a0,s1
    800036aa:	00003097          	auipc	ra,0x3
    800036ae:	b9a080e7          	jalr	-1126(ra) # 80006244 <release>
}
    800036b2:	a03d                	j	800036e0 <end_op+0xaa>
    panic("log.committing");
    800036b4:	00005517          	auipc	a0,0x5
    800036b8:	ec450513          	addi	a0,a0,-316 # 80008578 <etext+0x578>
    800036bc:	00002097          	auipc	ra,0x2
    800036c0:	598080e7          	jalr	1432(ra) # 80005c54 <panic>
    wakeup(&log);
    800036c4:	00016497          	auipc	s1,0x16
    800036c8:	b5c48493          	addi	s1,s1,-1188 # 80019220 <log>
    800036cc:	8526                	mv	a0,s1
    800036ce:	ffffe097          	auipc	ra,0xffffe
    800036d2:	016080e7          	jalr	22(ra) # 800016e4 <wakeup>
  release(&log.lock);
    800036d6:	8526                	mv	a0,s1
    800036d8:	00003097          	auipc	ra,0x3
    800036dc:	b6c080e7          	jalr	-1172(ra) # 80006244 <release>
}
    800036e0:	70e2                	ld	ra,56(sp)
    800036e2:	7442                	ld	s0,48(sp)
    800036e4:	74a2                	ld	s1,40(sp)
    800036e6:	7902                	ld	s2,32(sp)
    800036e8:	69e2                	ld	s3,24(sp)
    800036ea:	6a42                	ld	s4,16(sp)
    800036ec:	6aa2                	ld	s5,8(sp)
    800036ee:	6121                	addi	sp,sp,64
    800036f0:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f2:	00016a97          	auipc	s5,0x16
    800036f6:	b5ea8a93          	addi	s5,s5,-1186 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036fa:	00016a17          	auipc	s4,0x16
    800036fe:	b26a0a13          	addi	s4,s4,-1242 # 80019220 <log>
    80003702:	018a2583          	lw	a1,24(s4)
    80003706:	012585bb          	addw	a1,a1,s2
    8000370a:	2585                	addiw	a1,a1,1
    8000370c:	028a2503          	lw	a0,40(s4)
    80003710:	fffff097          	auipc	ra,0xfffff
    80003714:	cd2080e7          	jalr	-814(ra) # 800023e2 <bread>
    80003718:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000371a:	000aa583          	lw	a1,0(s5)
    8000371e:	028a2503          	lw	a0,40(s4)
    80003722:	fffff097          	auipc	ra,0xfffff
    80003726:	cc0080e7          	jalr	-832(ra) # 800023e2 <bread>
    8000372a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000372c:	40000613          	li	a2,1024
    80003730:	05850593          	addi	a1,a0,88
    80003734:	05848513          	addi	a0,s1,88
    80003738:	ffffd097          	auipc	ra,0xffffd
    8000373c:	ae6080e7          	jalr	-1306(ra) # 8000021e <memmove>
    bwrite(to);  // write the log
    80003740:	8526                	mv	a0,s1
    80003742:	fffff097          	auipc	ra,0xfffff
    80003746:	d92080e7          	jalr	-622(ra) # 800024d4 <bwrite>
    brelse(from);
    8000374a:	854e                	mv	a0,s3
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	dc6080e7          	jalr	-570(ra) # 80002512 <brelse>
    brelse(to);
    80003754:	8526                	mv	a0,s1
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	dbc080e7          	jalr	-580(ra) # 80002512 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000375e:	2905                	addiw	s2,s2,1
    80003760:	0a91                	addi	s5,s5,4
    80003762:	02ca2783          	lw	a5,44(s4)
    80003766:	f8f94ee3          	blt	s2,a5,80003702 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000376a:	00000097          	auipc	ra,0x0
    8000376e:	c6a080e7          	jalr	-918(ra) # 800033d4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003772:	4501                	li	a0,0
    80003774:	00000097          	auipc	ra,0x0
    80003778:	cda080e7          	jalr	-806(ra) # 8000344e <install_trans>
    log.lh.n = 0;
    8000377c:	00016797          	auipc	a5,0x16
    80003780:	ac07a823          	sw	zero,-1328(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003784:	00000097          	auipc	ra,0x0
    80003788:	c50080e7          	jalr	-944(ra) # 800033d4 <write_head>
    8000378c:	bdf5                	j	80003688 <end_op+0x52>

000000008000378e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000378e:	1101                	addi	sp,sp,-32
    80003790:	ec06                	sd	ra,24(sp)
    80003792:	e822                	sd	s0,16(sp)
    80003794:	e426                	sd	s1,8(sp)
    80003796:	e04a                	sd	s2,0(sp)
    80003798:	1000                	addi	s0,sp,32
    8000379a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000379c:	00016917          	auipc	s2,0x16
    800037a0:	a8490913          	addi	s2,s2,-1404 # 80019220 <log>
    800037a4:	854a                	mv	a0,s2
    800037a6:	00003097          	auipc	ra,0x3
    800037aa:	9ea080e7          	jalr	-1558(ra) # 80006190 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037ae:	02c92603          	lw	a2,44(s2)
    800037b2:	47f5                	li	a5,29
    800037b4:	06c7c563          	blt	a5,a2,8000381e <log_write+0x90>
    800037b8:	00016797          	auipc	a5,0x16
    800037bc:	a847a783          	lw	a5,-1404(a5) # 8001923c <log+0x1c>
    800037c0:	37fd                	addiw	a5,a5,-1
    800037c2:	04f65e63          	bge	a2,a5,8000381e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037c6:	00016797          	auipc	a5,0x16
    800037ca:	a7a7a783          	lw	a5,-1414(a5) # 80019240 <log+0x20>
    800037ce:	06f05063          	blez	a5,8000382e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037d2:	4781                	li	a5,0
    800037d4:	06c05563          	blez	a2,8000383e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d8:	44cc                	lw	a1,12(s1)
    800037da:	00016717          	auipc	a4,0x16
    800037de:	a7670713          	addi	a4,a4,-1418 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037e2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e4:	4314                	lw	a3,0(a4)
    800037e6:	04b68c63          	beq	a3,a1,8000383e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037ea:	2785                	addiw	a5,a5,1
    800037ec:	0711                	addi	a4,a4,4
    800037ee:	fef61be3          	bne	a2,a5,800037e4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037f2:	0621                	addi	a2,a2,8
    800037f4:	060a                	slli	a2,a2,0x2
    800037f6:	00016797          	auipc	a5,0x16
    800037fa:	a2a78793          	addi	a5,a5,-1494 # 80019220 <log>
    800037fe:	963e                	add	a2,a2,a5
    80003800:	44dc                	lw	a5,12(s1)
    80003802:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003804:	8526                	mv	a0,s1
    80003806:	fffff097          	auipc	ra,0xfffff
    8000380a:	daa080e7          	jalr	-598(ra) # 800025b0 <bpin>
    log.lh.n++;
    8000380e:	00016717          	auipc	a4,0x16
    80003812:	a1270713          	addi	a4,a4,-1518 # 80019220 <log>
    80003816:	575c                	lw	a5,44(a4)
    80003818:	2785                	addiw	a5,a5,1
    8000381a:	d75c                	sw	a5,44(a4)
    8000381c:	a835                	j	80003858 <log_write+0xca>
    panic("too big a transaction");
    8000381e:	00005517          	auipc	a0,0x5
    80003822:	d6a50513          	addi	a0,a0,-662 # 80008588 <etext+0x588>
    80003826:	00002097          	auipc	ra,0x2
    8000382a:	42e080e7          	jalr	1070(ra) # 80005c54 <panic>
    panic("log_write outside of trans");
    8000382e:	00005517          	auipc	a0,0x5
    80003832:	d7250513          	addi	a0,a0,-654 # 800085a0 <etext+0x5a0>
    80003836:	00002097          	auipc	ra,0x2
    8000383a:	41e080e7          	jalr	1054(ra) # 80005c54 <panic>
  log.lh.block[i] = b->blockno;
    8000383e:	00878713          	addi	a4,a5,8
    80003842:	00271693          	slli	a3,a4,0x2
    80003846:	00016717          	auipc	a4,0x16
    8000384a:	9da70713          	addi	a4,a4,-1574 # 80019220 <log>
    8000384e:	9736                	add	a4,a4,a3
    80003850:	44d4                	lw	a3,12(s1)
    80003852:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003854:	faf608e3          	beq	a2,a5,80003804 <log_write+0x76>
  }
  release(&log.lock);
    80003858:	00016517          	auipc	a0,0x16
    8000385c:	9c850513          	addi	a0,a0,-1592 # 80019220 <log>
    80003860:	00003097          	auipc	ra,0x3
    80003864:	9e4080e7          	jalr	-1564(ra) # 80006244 <release>
}
    80003868:	60e2                	ld	ra,24(sp)
    8000386a:	6442                	ld	s0,16(sp)
    8000386c:	64a2                	ld	s1,8(sp)
    8000386e:	6902                	ld	s2,0(sp)
    80003870:	6105                	addi	sp,sp,32
    80003872:	8082                	ret

0000000080003874 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003874:	1101                	addi	sp,sp,-32
    80003876:	ec06                	sd	ra,24(sp)
    80003878:	e822                	sd	s0,16(sp)
    8000387a:	e426                	sd	s1,8(sp)
    8000387c:	e04a                	sd	s2,0(sp)
    8000387e:	1000                	addi	s0,sp,32
    80003880:	84aa                	mv	s1,a0
    80003882:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003884:	00005597          	auipc	a1,0x5
    80003888:	d3c58593          	addi	a1,a1,-708 # 800085c0 <etext+0x5c0>
    8000388c:	0521                	addi	a0,a0,8
    8000388e:	00003097          	auipc	ra,0x3
    80003892:	872080e7          	jalr	-1934(ra) # 80006100 <initlock>
  lk->name = name;
    80003896:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000389a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000389e:	0204a423          	sw	zero,40(s1)
}
    800038a2:	60e2                	ld	ra,24(sp)
    800038a4:	6442                	ld	s0,16(sp)
    800038a6:	64a2                	ld	s1,8(sp)
    800038a8:	6902                	ld	s2,0(sp)
    800038aa:	6105                	addi	sp,sp,32
    800038ac:	8082                	ret

00000000800038ae <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038ae:	1101                	addi	sp,sp,-32
    800038b0:	ec06                	sd	ra,24(sp)
    800038b2:	e822                	sd	s0,16(sp)
    800038b4:	e426                	sd	s1,8(sp)
    800038b6:	e04a                	sd	s2,0(sp)
    800038b8:	1000                	addi	s0,sp,32
    800038ba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038bc:	00850913          	addi	s2,a0,8
    800038c0:	854a                	mv	a0,s2
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	8ce080e7          	jalr	-1842(ra) # 80006190 <acquire>
  while (lk->locked) {
    800038ca:	409c                	lw	a5,0(s1)
    800038cc:	cb89                	beqz	a5,800038de <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038ce:	85ca                	mv	a1,s2
    800038d0:	8526                	mv	a0,s1
    800038d2:	ffffe097          	auipc	ra,0xffffe
    800038d6:	c86080e7          	jalr	-890(ra) # 80001558 <sleep>
  while (lk->locked) {
    800038da:	409c                	lw	a5,0(s1)
    800038dc:	fbed                	bnez	a5,800038ce <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038de:	4785                	li	a5,1
    800038e0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038e2:	ffffd097          	auipc	ra,0xffffd
    800038e6:	5aa080e7          	jalr	1450(ra) # 80000e8c <myproc>
    800038ea:	591c                	lw	a5,48(a0)
    800038ec:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ee:	854a                	mv	a0,s2
    800038f0:	00003097          	auipc	ra,0x3
    800038f4:	954080e7          	jalr	-1708(ra) # 80006244 <release>
}
    800038f8:	60e2                	ld	ra,24(sp)
    800038fa:	6442                	ld	s0,16(sp)
    800038fc:	64a2                	ld	s1,8(sp)
    800038fe:	6902                	ld	s2,0(sp)
    80003900:	6105                	addi	sp,sp,32
    80003902:	8082                	ret

0000000080003904 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003904:	1101                	addi	sp,sp,-32
    80003906:	ec06                	sd	ra,24(sp)
    80003908:	e822                	sd	s0,16(sp)
    8000390a:	e426                	sd	s1,8(sp)
    8000390c:	e04a                	sd	s2,0(sp)
    8000390e:	1000                	addi	s0,sp,32
    80003910:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003912:	00850913          	addi	s2,a0,8
    80003916:	854a                	mv	a0,s2
    80003918:	00003097          	auipc	ra,0x3
    8000391c:	878080e7          	jalr	-1928(ra) # 80006190 <acquire>
  lk->locked = 0;
    80003920:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003924:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003928:	8526                	mv	a0,s1
    8000392a:	ffffe097          	auipc	ra,0xffffe
    8000392e:	dba080e7          	jalr	-582(ra) # 800016e4 <wakeup>
  release(&lk->lk);
    80003932:	854a                	mv	a0,s2
    80003934:	00003097          	auipc	ra,0x3
    80003938:	910080e7          	jalr	-1776(ra) # 80006244 <release>
}
    8000393c:	60e2                	ld	ra,24(sp)
    8000393e:	6442                	ld	s0,16(sp)
    80003940:	64a2                	ld	s1,8(sp)
    80003942:	6902                	ld	s2,0(sp)
    80003944:	6105                	addi	sp,sp,32
    80003946:	8082                	ret

0000000080003948 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003948:	7179                	addi	sp,sp,-48
    8000394a:	f406                	sd	ra,40(sp)
    8000394c:	f022                	sd	s0,32(sp)
    8000394e:	ec26                	sd	s1,24(sp)
    80003950:	e84a                	sd	s2,16(sp)
    80003952:	e44e                	sd	s3,8(sp)
    80003954:	1800                	addi	s0,sp,48
    80003956:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003958:	00850913          	addi	s2,a0,8
    8000395c:	854a                	mv	a0,s2
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	832080e7          	jalr	-1998(ra) # 80006190 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003966:	409c                	lw	a5,0(s1)
    80003968:	ef99                	bnez	a5,80003986 <holdingsleep+0x3e>
    8000396a:	4481                	li	s1,0
  release(&lk->lk);
    8000396c:	854a                	mv	a0,s2
    8000396e:	00003097          	auipc	ra,0x3
    80003972:	8d6080e7          	jalr	-1834(ra) # 80006244 <release>
  return r;
}
    80003976:	8526                	mv	a0,s1
    80003978:	70a2                	ld	ra,40(sp)
    8000397a:	7402                	ld	s0,32(sp)
    8000397c:	64e2                	ld	s1,24(sp)
    8000397e:	6942                	ld	s2,16(sp)
    80003980:	69a2                	ld	s3,8(sp)
    80003982:	6145                	addi	sp,sp,48
    80003984:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003986:	0284a983          	lw	s3,40(s1)
    8000398a:	ffffd097          	auipc	ra,0xffffd
    8000398e:	502080e7          	jalr	1282(ra) # 80000e8c <myproc>
    80003992:	5904                	lw	s1,48(a0)
    80003994:	413484b3          	sub	s1,s1,s3
    80003998:	0014b493          	seqz	s1,s1
    8000399c:	bfc1                	j	8000396c <holdingsleep+0x24>

000000008000399e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000399e:	1141                	addi	sp,sp,-16
    800039a0:	e406                	sd	ra,8(sp)
    800039a2:	e022                	sd	s0,0(sp)
    800039a4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039a6:	00005597          	auipc	a1,0x5
    800039aa:	c2a58593          	addi	a1,a1,-982 # 800085d0 <etext+0x5d0>
    800039ae:	00016517          	auipc	a0,0x16
    800039b2:	9ba50513          	addi	a0,a0,-1606 # 80019368 <ftable>
    800039b6:	00002097          	auipc	ra,0x2
    800039ba:	74a080e7          	jalr	1866(ra) # 80006100 <initlock>
}
    800039be:	60a2                	ld	ra,8(sp)
    800039c0:	6402                	ld	s0,0(sp)
    800039c2:	0141                	addi	sp,sp,16
    800039c4:	8082                	ret

00000000800039c6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039c6:	1101                	addi	sp,sp,-32
    800039c8:	ec06                	sd	ra,24(sp)
    800039ca:	e822                	sd	s0,16(sp)
    800039cc:	e426                	sd	s1,8(sp)
    800039ce:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039d0:	00016517          	auipc	a0,0x16
    800039d4:	99850513          	addi	a0,a0,-1640 # 80019368 <ftable>
    800039d8:	00002097          	auipc	ra,0x2
    800039dc:	7b8080e7          	jalr	1976(ra) # 80006190 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e0:	00016497          	auipc	s1,0x16
    800039e4:	9a048493          	addi	s1,s1,-1632 # 80019380 <ftable+0x18>
    800039e8:	00017717          	auipc	a4,0x17
    800039ec:	93870713          	addi	a4,a4,-1736 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039f0:	40dc                	lw	a5,4(s1)
    800039f2:	cf99                	beqz	a5,80003a10 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f4:	02848493          	addi	s1,s1,40
    800039f8:	fee49ce3          	bne	s1,a4,800039f0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039fc:	00016517          	auipc	a0,0x16
    80003a00:	96c50513          	addi	a0,a0,-1684 # 80019368 <ftable>
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	840080e7          	jalr	-1984(ra) # 80006244 <release>
  return 0;
    80003a0c:	4481                	li	s1,0
    80003a0e:	a819                	j	80003a24 <filealloc+0x5e>
      f->ref = 1;
    80003a10:	4785                	li	a5,1
    80003a12:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a14:	00016517          	auipc	a0,0x16
    80003a18:	95450513          	addi	a0,a0,-1708 # 80019368 <ftable>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	828080e7          	jalr	-2008(ra) # 80006244 <release>
}
    80003a24:	8526                	mv	a0,s1
    80003a26:	60e2                	ld	ra,24(sp)
    80003a28:	6442                	ld	s0,16(sp)
    80003a2a:	64a2                	ld	s1,8(sp)
    80003a2c:	6105                	addi	sp,sp,32
    80003a2e:	8082                	ret

0000000080003a30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a30:	1101                	addi	sp,sp,-32
    80003a32:	ec06                	sd	ra,24(sp)
    80003a34:	e822                	sd	s0,16(sp)
    80003a36:	e426                	sd	s1,8(sp)
    80003a38:	1000                	addi	s0,sp,32
    80003a3a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a3c:	00016517          	auipc	a0,0x16
    80003a40:	92c50513          	addi	a0,a0,-1748 # 80019368 <ftable>
    80003a44:	00002097          	auipc	ra,0x2
    80003a48:	74c080e7          	jalr	1868(ra) # 80006190 <acquire>
  if(f->ref < 1)
    80003a4c:	40dc                	lw	a5,4(s1)
    80003a4e:	02f05263          	blez	a5,80003a72 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a52:	2785                	addiw	a5,a5,1
    80003a54:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a56:	00016517          	auipc	a0,0x16
    80003a5a:	91250513          	addi	a0,a0,-1774 # 80019368 <ftable>
    80003a5e:	00002097          	auipc	ra,0x2
    80003a62:	7e6080e7          	jalr	2022(ra) # 80006244 <release>
  return f;
}
    80003a66:	8526                	mv	a0,s1
    80003a68:	60e2                	ld	ra,24(sp)
    80003a6a:	6442                	ld	s0,16(sp)
    80003a6c:	64a2                	ld	s1,8(sp)
    80003a6e:	6105                	addi	sp,sp,32
    80003a70:	8082                	ret
    panic("filedup");
    80003a72:	00005517          	auipc	a0,0x5
    80003a76:	b6650513          	addi	a0,a0,-1178 # 800085d8 <etext+0x5d8>
    80003a7a:	00002097          	auipc	ra,0x2
    80003a7e:	1da080e7          	jalr	474(ra) # 80005c54 <panic>

0000000080003a82 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a82:	7139                	addi	sp,sp,-64
    80003a84:	fc06                	sd	ra,56(sp)
    80003a86:	f822                	sd	s0,48(sp)
    80003a88:	f426                	sd	s1,40(sp)
    80003a8a:	f04a                	sd	s2,32(sp)
    80003a8c:	ec4e                	sd	s3,24(sp)
    80003a8e:	e852                	sd	s4,16(sp)
    80003a90:	e456                	sd	s5,8(sp)
    80003a92:	0080                	addi	s0,sp,64
    80003a94:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a96:	00016517          	auipc	a0,0x16
    80003a9a:	8d250513          	addi	a0,a0,-1838 # 80019368 <ftable>
    80003a9e:	00002097          	auipc	ra,0x2
    80003aa2:	6f2080e7          	jalr	1778(ra) # 80006190 <acquire>
  if(f->ref < 1)
    80003aa6:	40dc                	lw	a5,4(s1)
    80003aa8:	06f05163          	blez	a5,80003b0a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003aac:	37fd                	addiw	a5,a5,-1
    80003aae:	0007871b          	sext.w	a4,a5
    80003ab2:	c0dc                	sw	a5,4(s1)
    80003ab4:	06e04363          	bgtz	a4,80003b1a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ab8:	0004a903          	lw	s2,0(s1)
    80003abc:	0094ca83          	lbu	s5,9(s1)
    80003ac0:	0104ba03          	ld	s4,16(s1)
    80003ac4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ac8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003acc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ad0:	00016517          	auipc	a0,0x16
    80003ad4:	89850513          	addi	a0,a0,-1896 # 80019368 <ftable>
    80003ad8:	00002097          	auipc	ra,0x2
    80003adc:	76c080e7          	jalr	1900(ra) # 80006244 <release>

  if(ff.type == FD_PIPE){
    80003ae0:	4785                	li	a5,1
    80003ae2:	04f90d63          	beq	s2,a5,80003b3c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ae6:	3979                	addiw	s2,s2,-2
    80003ae8:	4785                	li	a5,1
    80003aea:	0527e063          	bltu	a5,s2,80003b2a <fileclose+0xa8>
    begin_op();
    80003aee:	00000097          	auipc	ra,0x0
    80003af2:	ac8080e7          	jalr	-1336(ra) # 800035b6 <begin_op>
    iput(ff.ip);
    80003af6:	854e                	mv	a0,s3
    80003af8:	fffff097          	auipc	ra,0xfffff
    80003afc:	2a6080e7          	jalr	678(ra) # 80002d9e <iput>
    end_op();
    80003b00:	00000097          	auipc	ra,0x0
    80003b04:	b36080e7          	jalr	-1226(ra) # 80003636 <end_op>
    80003b08:	a00d                	j	80003b2a <fileclose+0xa8>
    panic("fileclose");
    80003b0a:	00005517          	auipc	a0,0x5
    80003b0e:	ad650513          	addi	a0,a0,-1322 # 800085e0 <etext+0x5e0>
    80003b12:	00002097          	auipc	ra,0x2
    80003b16:	142080e7          	jalr	322(ra) # 80005c54 <panic>
    release(&ftable.lock);
    80003b1a:	00016517          	auipc	a0,0x16
    80003b1e:	84e50513          	addi	a0,a0,-1970 # 80019368 <ftable>
    80003b22:	00002097          	auipc	ra,0x2
    80003b26:	722080e7          	jalr	1826(ra) # 80006244 <release>
  }
}
    80003b2a:	70e2                	ld	ra,56(sp)
    80003b2c:	7442                	ld	s0,48(sp)
    80003b2e:	74a2                	ld	s1,40(sp)
    80003b30:	7902                	ld	s2,32(sp)
    80003b32:	69e2                	ld	s3,24(sp)
    80003b34:	6a42                	ld	s4,16(sp)
    80003b36:	6aa2                	ld	s5,8(sp)
    80003b38:	6121                	addi	sp,sp,64
    80003b3a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b3c:	85d6                	mv	a1,s5
    80003b3e:	8552                	mv	a0,s4
    80003b40:	00000097          	auipc	ra,0x0
    80003b44:	34c080e7          	jalr	844(ra) # 80003e8c <pipeclose>
    80003b48:	b7cd                	j	80003b2a <fileclose+0xa8>

0000000080003b4a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b4a:	715d                	addi	sp,sp,-80
    80003b4c:	e486                	sd	ra,72(sp)
    80003b4e:	e0a2                	sd	s0,64(sp)
    80003b50:	fc26                	sd	s1,56(sp)
    80003b52:	f84a                	sd	s2,48(sp)
    80003b54:	f44e                	sd	s3,40(sp)
    80003b56:	0880                	addi	s0,sp,80
    80003b58:	84aa                	mv	s1,a0
    80003b5a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b5c:	ffffd097          	auipc	ra,0xffffd
    80003b60:	330080e7          	jalr	816(ra) # 80000e8c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b64:	409c                	lw	a5,0(s1)
    80003b66:	37f9                	addiw	a5,a5,-2
    80003b68:	4705                	li	a4,1
    80003b6a:	04f76763          	bltu	a4,a5,80003bb8 <filestat+0x6e>
    80003b6e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b70:	6c88                	ld	a0,24(s1)
    80003b72:	fffff097          	auipc	ra,0xfffff
    80003b76:	072080e7          	jalr	114(ra) # 80002be4 <ilock>
    stati(f->ip, &st);
    80003b7a:	fb840593          	addi	a1,s0,-72
    80003b7e:	6c88                	ld	a0,24(s1)
    80003b80:	fffff097          	auipc	ra,0xfffff
    80003b84:	2ee080e7          	jalr	750(ra) # 80002e6e <stati>
    iunlock(f->ip);
    80003b88:	6c88                	ld	a0,24(s1)
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	11c080e7          	jalr	284(ra) # 80002ca6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b92:	46e1                	li	a3,24
    80003b94:	fb840613          	addi	a2,s0,-72
    80003b98:	85ce                	mv	a1,s3
    80003b9a:	05093503          	ld	a0,80(s2)
    80003b9e:	ffffd097          	auipc	ra,0xffffd
    80003ba2:	fae080e7          	jalr	-82(ra) # 80000b4c <copyout>
    80003ba6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003baa:	60a6                	ld	ra,72(sp)
    80003bac:	6406                	ld	s0,64(sp)
    80003bae:	74e2                	ld	s1,56(sp)
    80003bb0:	7942                	ld	s2,48(sp)
    80003bb2:	79a2                	ld	s3,40(sp)
    80003bb4:	6161                	addi	sp,sp,80
    80003bb6:	8082                	ret
  return -1;
    80003bb8:	557d                	li	a0,-1
    80003bba:	bfc5                	j	80003baa <filestat+0x60>

0000000080003bbc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bbc:	7179                	addi	sp,sp,-48
    80003bbe:	f406                	sd	ra,40(sp)
    80003bc0:	f022                	sd	s0,32(sp)
    80003bc2:	ec26                	sd	s1,24(sp)
    80003bc4:	e84a                	sd	s2,16(sp)
    80003bc6:	e44e                	sd	s3,8(sp)
    80003bc8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bca:	00854783          	lbu	a5,8(a0)
    80003bce:	c3d5                	beqz	a5,80003c72 <fileread+0xb6>
    80003bd0:	84aa                	mv	s1,a0
    80003bd2:	89ae                	mv	s3,a1
    80003bd4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bd6:	411c                	lw	a5,0(a0)
    80003bd8:	4705                	li	a4,1
    80003bda:	04e78963          	beq	a5,a4,80003c2c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bde:	470d                	li	a4,3
    80003be0:	04e78d63          	beq	a5,a4,80003c3a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003be4:	4709                	li	a4,2
    80003be6:	06e79e63          	bne	a5,a4,80003c62 <fileread+0xa6>
    ilock(f->ip);
    80003bea:	6d08                	ld	a0,24(a0)
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	ff8080e7          	jalr	-8(ra) # 80002be4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bf4:	874a                	mv	a4,s2
    80003bf6:	5094                	lw	a3,32(s1)
    80003bf8:	864e                	mv	a2,s3
    80003bfa:	4585                	li	a1,1
    80003bfc:	6c88                	ld	a0,24(s1)
    80003bfe:	fffff097          	auipc	ra,0xfffff
    80003c02:	29a080e7          	jalr	666(ra) # 80002e98 <readi>
    80003c06:	892a                	mv	s2,a0
    80003c08:	00a05563          	blez	a0,80003c12 <fileread+0x56>
      f->off += r;
    80003c0c:	509c                	lw	a5,32(s1)
    80003c0e:	9fa9                	addw	a5,a5,a0
    80003c10:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c12:	6c88                	ld	a0,24(s1)
    80003c14:	fffff097          	auipc	ra,0xfffff
    80003c18:	092080e7          	jalr	146(ra) # 80002ca6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c1c:	854a                	mv	a0,s2
    80003c1e:	70a2                	ld	ra,40(sp)
    80003c20:	7402                	ld	s0,32(sp)
    80003c22:	64e2                	ld	s1,24(sp)
    80003c24:	6942                	ld	s2,16(sp)
    80003c26:	69a2                	ld	s3,8(sp)
    80003c28:	6145                	addi	sp,sp,48
    80003c2a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c2c:	6908                	ld	a0,16(a0)
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	3c0080e7          	jalr	960(ra) # 80003fee <piperead>
    80003c36:	892a                	mv	s2,a0
    80003c38:	b7d5                	j	80003c1c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c3a:	02451783          	lh	a5,36(a0)
    80003c3e:	03079693          	slli	a3,a5,0x30
    80003c42:	92c1                	srli	a3,a3,0x30
    80003c44:	4725                	li	a4,9
    80003c46:	02d76863          	bltu	a4,a3,80003c76 <fileread+0xba>
    80003c4a:	0792                	slli	a5,a5,0x4
    80003c4c:	00015717          	auipc	a4,0x15
    80003c50:	67c70713          	addi	a4,a4,1660 # 800192c8 <devsw>
    80003c54:	97ba                	add	a5,a5,a4
    80003c56:	639c                	ld	a5,0(a5)
    80003c58:	c38d                	beqz	a5,80003c7a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c5a:	4505                	li	a0,1
    80003c5c:	9782                	jalr	a5
    80003c5e:	892a                	mv	s2,a0
    80003c60:	bf75                	j	80003c1c <fileread+0x60>
    panic("fileread");
    80003c62:	00005517          	auipc	a0,0x5
    80003c66:	98e50513          	addi	a0,a0,-1650 # 800085f0 <etext+0x5f0>
    80003c6a:	00002097          	auipc	ra,0x2
    80003c6e:	fea080e7          	jalr	-22(ra) # 80005c54 <panic>
    return -1;
    80003c72:	597d                	li	s2,-1
    80003c74:	b765                	j	80003c1c <fileread+0x60>
      return -1;
    80003c76:	597d                	li	s2,-1
    80003c78:	b755                	j	80003c1c <fileread+0x60>
    80003c7a:	597d                	li	s2,-1
    80003c7c:	b745                	j	80003c1c <fileread+0x60>

0000000080003c7e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c7e:	715d                	addi	sp,sp,-80
    80003c80:	e486                	sd	ra,72(sp)
    80003c82:	e0a2                	sd	s0,64(sp)
    80003c84:	fc26                	sd	s1,56(sp)
    80003c86:	f84a                	sd	s2,48(sp)
    80003c88:	f44e                	sd	s3,40(sp)
    80003c8a:	f052                	sd	s4,32(sp)
    80003c8c:	ec56                	sd	s5,24(sp)
    80003c8e:	e85a                	sd	s6,16(sp)
    80003c90:	e45e                	sd	s7,8(sp)
    80003c92:	e062                	sd	s8,0(sp)
    80003c94:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c96:	00954783          	lbu	a5,9(a0)
    80003c9a:	10078663          	beqz	a5,80003da6 <filewrite+0x128>
    80003c9e:	892a                	mv	s2,a0
    80003ca0:	8aae                	mv	s5,a1
    80003ca2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ca4:	411c                	lw	a5,0(a0)
    80003ca6:	4705                	li	a4,1
    80003ca8:	02e78263          	beq	a5,a4,80003ccc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cac:	470d                	li	a4,3
    80003cae:	02e78663          	beq	a5,a4,80003cda <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cb2:	4709                	li	a4,2
    80003cb4:	0ee79163          	bne	a5,a4,80003d96 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cb8:	0ac05d63          	blez	a2,80003d72 <filewrite+0xf4>
    int i = 0;
    80003cbc:	4981                	li	s3,0
    80003cbe:	6b05                	lui	s6,0x1
    80003cc0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cc4:	6b85                	lui	s7,0x1
    80003cc6:	c00b8b9b          	addiw	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cca:	a861                	j	80003d62 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ccc:	6908                	ld	a0,16(a0)
    80003cce:	00000097          	auipc	ra,0x0
    80003cd2:	22e080e7          	jalr	558(ra) # 80003efc <pipewrite>
    80003cd6:	8a2a                	mv	s4,a0
    80003cd8:	a045                	j	80003d78 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cda:	02451783          	lh	a5,36(a0)
    80003cde:	03079693          	slli	a3,a5,0x30
    80003ce2:	92c1                	srli	a3,a3,0x30
    80003ce4:	4725                	li	a4,9
    80003ce6:	0cd76263          	bltu	a4,a3,80003daa <filewrite+0x12c>
    80003cea:	0792                	slli	a5,a5,0x4
    80003cec:	00015717          	auipc	a4,0x15
    80003cf0:	5dc70713          	addi	a4,a4,1500 # 800192c8 <devsw>
    80003cf4:	97ba                	add	a5,a5,a4
    80003cf6:	679c                	ld	a5,8(a5)
    80003cf8:	cbdd                	beqz	a5,80003dae <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cfa:	4505                	li	a0,1
    80003cfc:	9782                	jalr	a5
    80003cfe:	8a2a                	mv	s4,a0
    80003d00:	a8a5                	j	80003d78 <filewrite+0xfa>
    80003d02:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	8b0080e7          	jalr	-1872(ra) # 800035b6 <begin_op>
      ilock(f->ip);
    80003d0e:	01893503          	ld	a0,24(s2)
    80003d12:	fffff097          	auipc	ra,0xfffff
    80003d16:	ed2080e7          	jalr	-302(ra) # 80002be4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d1a:	8762                	mv	a4,s8
    80003d1c:	02092683          	lw	a3,32(s2)
    80003d20:	01598633          	add	a2,s3,s5
    80003d24:	4585                	li	a1,1
    80003d26:	01893503          	ld	a0,24(s2)
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	266080e7          	jalr	614(ra) # 80002f90 <writei>
    80003d32:	84aa                	mv	s1,a0
    80003d34:	00a05763          	blez	a0,80003d42 <filewrite+0xc4>
        f->off += r;
    80003d38:	02092783          	lw	a5,32(s2)
    80003d3c:	9fa9                	addw	a5,a5,a0
    80003d3e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d42:	01893503          	ld	a0,24(s2)
    80003d46:	fffff097          	auipc	ra,0xfffff
    80003d4a:	f60080e7          	jalr	-160(ra) # 80002ca6 <iunlock>
      end_op();
    80003d4e:	00000097          	auipc	ra,0x0
    80003d52:	8e8080e7          	jalr	-1816(ra) # 80003636 <end_op>

      if(r != n1){
    80003d56:	009c1f63          	bne	s8,s1,80003d74 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d5a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d5e:	0149db63          	bge	s3,s4,80003d74 <filewrite+0xf6>
      int n1 = n - i;
    80003d62:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d66:	84be                	mv	s1,a5
    80003d68:	2781                	sext.w	a5,a5
    80003d6a:	f8fb5ce3          	bge	s6,a5,80003d02 <filewrite+0x84>
    80003d6e:	84de                	mv	s1,s7
    80003d70:	bf49                	j	80003d02 <filewrite+0x84>
    int i = 0;
    80003d72:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d74:	013a1f63          	bne	s4,s3,80003d92 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d78:	8552                	mv	a0,s4
    80003d7a:	60a6                	ld	ra,72(sp)
    80003d7c:	6406                	ld	s0,64(sp)
    80003d7e:	74e2                	ld	s1,56(sp)
    80003d80:	7942                	ld	s2,48(sp)
    80003d82:	79a2                	ld	s3,40(sp)
    80003d84:	7a02                	ld	s4,32(sp)
    80003d86:	6ae2                	ld	s5,24(sp)
    80003d88:	6b42                	ld	s6,16(sp)
    80003d8a:	6ba2                	ld	s7,8(sp)
    80003d8c:	6c02                	ld	s8,0(sp)
    80003d8e:	6161                	addi	sp,sp,80
    80003d90:	8082                	ret
    ret = (i == n ? n : -1);
    80003d92:	5a7d                	li	s4,-1
    80003d94:	b7d5                	j	80003d78 <filewrite+0xfa>
    panic("filewrite");
    80003d96:	00005517          	auipc	a0,0x5
    80003d9a:	86a50513          	addi	a0,a0,-1942 # 80008600 <etext+0x600>
    80003d9e:	00002097          	auipc	ra,0x2
    80003da2:	eb6080e7          	jalr	-330(ra) # 80005c54 <panic>
    return -1;
    80003da6:	5a7d                	li	s4,-1
    80003da8:	bfc1                	j	80003d78 <filewrite+0xfa>
      return -1;
    80003daa:	5a7d                	li	s4,-1
    80003dac:	b7f1                	j	80003d78 <filewrite+0xfa>
    80003dae:	5a7d                	li	s4,-1
    80003db0:	b7e1                	j	80003d78 <filewrite+0xfa>

0000000080003db2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003db2:	7179                	addi	sp,sp,-48
    80003db4:	f406                	sd	ra,40(sp)
    80003db6:	f022                	sd	s0,32(sp)
    80003db8:	ec26                	sd	s1,24(sp)
    80003dba:	e84a                	sd	s2,16(sp)
    80003dbc:	e44e                	sd	s3,8(sp)
    80003dbe:	e052                	sd	s4,0(sp)
    80003dc0:	1800                	addi	s0,sp,48
    80003dc2:	84aa                	mv	s1,a0
    80003dc4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dc6:	0005b023          	sd	zero,0(a1)
    80003dca:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	bf8080e7          	jalr	-1032(ra) # 800039c6 <filealloc>
    80003dd6:	e088                	sd	a0,0(s1)
    80003dd8:	c551                	beqz	a0,80003e64 <pipealloc+0xb2>
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	bec080e7          	jalr	-1044(ra) # 800039c6 <filealloc>
    80003de2:	00aa3023          	sd	a0,0(s4)
    80003de6:	c92d                	beqz	a0,80003e58 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003de8:	ffffc097          	auipc	ra,0xffffc
    80003dec:	330080e7          	jalr	816(ra) # 80000118 <kalloc>
    80003df0:	892a                	mv	s2,a0
    80003df2:	c125                	beqz	a0,80003e52 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003df4:	4985                	li	s3,1
    80003df6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dfa:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dfe:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e02:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e06:	00004597          	auipc	a1,0x4
    80003e0a:	5aa58593          	addi	a1,a1,1450 # 800083b0 <etext+0x3b0>
    80003e0e:	00002097          	auipc	ra,0x2
    80003e12:	2f2080e7          	jalr	754(ra) # 80006100 <initlock>
  (*f0)->type = FD_PIPE;
    80003e16:	609c                	ld	a5,0(s1)
    80003e18:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e1c:	609c                	ld	a5,0(s1)
    80003e1e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e22:	609c                	ld	a5,0(s1)
    80003e24:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e28:	609c                	ld	a5,0(s1)
    80003e2a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e2e:	000a3783          	ld	a5,0(s4)
    80003e32:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e36:	000a3783          	ld	a5,0(s4)
    80003e3a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e3e:	000a3783          	ld	a5,0(s4)
    80003e42:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e46:	000a3783          	ld	a5,0(s4)
    80003e4a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e4e:	4501                	li	a0,0
    80003e50:	a025                	j	80003e78 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e52:	6088                	ld	a0,0(s1)
    80003e54:	e501                	bnez	a0,80003e5c <pipealloc+0xaa>
    80003e56:	a039                	j	80003e64 <pipealloc+0xb2>
    80003e58:	6088                	ld	a0,0(s1)
    80003e5a:	c51d                	beqz	a0,80003e88 <pipealloc+0xd6>
    fileclose(*f0);
    80003e5c:	00000097          	auipc	ra,0x0
    80003e60:	c26080e7          	jalr	-986(ra) # 80003a82 <fileclose>
  if(*f1)
    80003e64:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e68:	557d                	li	a0,-1
  if(*f1)
    80003e6a:	c799                	beqz	a5,80003e78 <pipealloc+0xc6>
    fileclose(*f1);
    80003e6c:	853e                	mv	a0,a5
    80003e6e:	00000097          	auipc	ra,0x0
    80003e72:	c14080e7          	jalr	-1004(ra) # 80003a82 <fileclose>
  return -1;
    80003e76:	557d                	li	a0,-1
}
    80003e78:	70a2                	ld	ra,40(sp)
    80003e7a:	7402                	ld	s0,32(sp)
    80003e7c:	64e2                	ld	s1,24(sp)
    80003e7e:	6942                	ld	s2,16(sp)
    80003e80:	69a2                	ld	s3,8(sp)
    80003e82:	6a02                	ld	s4,0(sp)
    80003e84:	6145                	addi	sp,sp,48
    80003e86:	8082                	ret
  return -1;
    80003e88:	557d                	li	a0,-1
    80003e8a:	b7fd                	j	80003e78 <pipealloc+0xc6>

0000000080003e8c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e8c:	1101                	addi	sp,sp,-32
    80003e8e:	ec06                	sd	ra,24(sp)
    80003e90:	e822                	sd	s0,16(sp)
    80003e92:	e426                	sd	s1,8(sp)
    80003e94:	e04a                	sd	s2,0(sp)
    80003e96:	1000                	addi	s0,sp,32
    80003e98:	84aa                	mv	s1,a0
    80003e9a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e9c:	00002097          	auipc	ra,0x2
    80003ea0:	2f4080e7          	jalr	756(ra) # 80006190 <acquire>
  if(writable){
    80003ea4:	02090d63          	beqz	s2,80003ede <pipeclose+0x52>
    pi->writeopen = 0;
    80003ea8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eac:	21848513          	addi	a0,s1,536
    80003eb0:	ffffe097          	auipc	ra,0xffffe
    80003eb4:	834080e7          	jalr	-1996(ra) # 800016e4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eb8:	2204b783          	ld	a5,544(s1)
    80003ebc:	eb95                	bnez	a5,80003ef0 <pipeclose+0x64>
    release(&pi->lock);
    80003ebe:	8526                	mv	a0,s1
    80003ec0:	00002097          	auipc	ra,0x2
    80003ec4:	384080e7          	jalr	900(ra) # 80006244 <release>
    kfree((char*)pi);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	ffffc097          	auipc	ra,0xffffc
    80003ece:	152080e7          	jalr	338(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ed2:	60e2                	ld	ra,24(sp)
    80003ed4:	6442                	ld	s0,16(sp)
    80003ed6:	64a2                	ld	s1,8(sp)
    80003ed8:	6902                	ld	s2,0(sp)
    80003eda:	6105                	addi	sp,sp,32
    80003edc:	8082                	ret
    pi->readopen = 0;
    80003ede:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ee2:	21c48513          	addi	a0,s1,540
    80003ee6:	ffffd097          	auipc	ra,0xffffd
    80003eea:	7fe080e7          	jalr	2046(ra) # 800016e4 <wakeup>
    80003eee:	b7e9                	j	80003eb8 <pipeclose+0x2c>
    release(&pi->lock);
    80003ef0:	8526                	mv	a0,s1
    80003ef2:	00002097          	auipc	ra,0x2
    80003ef6:	352080e7          	jalr	850(ra) # 80006244 <release>
}
    80003efa:	bfe1                	j	80003ed2 <pipeclose+0x46>

0000000080003efc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003efc:	711d                	addi	sp,sp,-96
    80003efe:	ec86                	sd	ra,88(sp)
    80003f00:	e8a2                	sd	s0,80(sp)
    80003f02:	e4a6                	sd	s1,72(sp)
    80003f04:	e0ca                	sd	s2,64(sp)
    80003f06:	fc4e                	sd	s3,56(sp)
    80003f08:	f852                	sd	s4,48(sp)
    80003f0a:	f456                	sd	s5,40(sp)
    80003f0c:	f05a                	sd	s6,32(sp)
    80003f0e:	ec5e                	sd	s7,24(sp)
    80003f10:	e862                	sd	s8,16(sp)
    80003f12:	1080                	addi	s0,sp,96
    80003f14:	84aa                	mv	s1,a0
    80003f16:	8aae                	mv	s5,a1
    80003f18:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f1a:	ffffd097          	auipc	ra,0xffffd
    80003f1e:	f72080e7          	jalr	-142(ra) # 80000e8c <myproc>
    80003f22:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f24:	8526                	mv	a0,s1
    80003f26:	00002097          	auipc	ra,0x2
    80003f2a:	26a080e7          	jalr	618(ra) # 80006190 <acquire>
  while(i < n){
    80003f2e:	0b405363          	blez	s4,80003fd4 <pipewrite+0xd8>
  int i = 0;
    80003f32:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f34:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f36:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f3a:	21c48b93          	addi	s7,s1,540
    80003f3e:	a089                	j	80003f80 <pipewrite+0x84>
      release(&pi->lock);
    80003f40:	8526                	mv	a0,s1
    80003f42:	00002097          	auipc	ra,0x2
    80003f46:	302080e7          	jalr	770(ra) # 80006244 <release>
      return -1;
    80003f4a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f4c:	854a                	mv	a0,s2
    80003f4e:	60e6                	ld	ra,88(sp)
    80003f50:	6446                	ld	s0,80(sp)
    80003f52:	64a6                	ld	s1,72(sp)
    80003f54:	6906                	ld	s2,64(sp)
    80003f56:	79e2                	ld	s3,56(sp)
    80003f58:	7a42                	ld	s4,48(sp)
    80003f5a:	7aa2                	ld	s5,40(sp)
    80003f5c:	7b02                	ld	s6,32(sp)
    80003f5e:	6be2                	ld	s7,24(sp)
    80003f60:	6c42                	ld	s8,16(sp)
    80003f62:	6125                	addi	sp,sp,96
    80003f64:	8082                	ret
      wakeup(&pi->nread);
    80003f66:	8562                	mv	a0,s8
    80003f68:	ffffd097          	auipc	ra,0xffffd
    80003f6c:	77c080e7          	jalr	1916(ra) # 800016e4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f70:	85a6                	mv	a1,s1
    80003f72:	855e                	mv	a0,s7
    80003f74:	ffffd097          	auipc	ra,0xffffd
    80003f78:	5e4080e7          	jalr	1508(ra) # 80001558 <sleep>
  while(i < n){
    80003f7c:	05495d63          	bge	s2,s4,80003fd6 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f80:	2204a783          	lw	a5,544(s1)
    80003f84:	dfd5                	beqz	a5,80003f40 <pipewrite+0x44>
    80003f86:	0289a783          	lw	a5,40(s3)
    80003f8a:	fbdd                	bnez	a5,80003f40 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f8c:	2184a783          	lw	a5,536(s1)
    80003f90:	21c4a703          	lw	a4,540(s1)
    80003f94:	2007879b          	addiw	a5,a5,512
    80003f98:	fcf707e3          	beq	a4,a5,80003f66 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f9c:	4685                	li	a3,1
    80003f9e:	01590633          	add	a2,s2,s5
    80003fa2:	faf40593          	addi	a1,s0,-81
    80003fa6:	0509b503          	ld	a0,80(s3)
    80003faa:	ffffd097          	auipc	ra,0xffffd
    80003fae:	c2e080e7          	jalr	-978(ra) # 80000bd8 <copyin>
    80003fb2:	03650263          	beq	a0,s6,80003fd6 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fb6:	21c4a783          	lw	a5,540(s1)
    80003fba:	0017871b          	addiw	a4,a5,1
    80003fbe:	20e4ae23          	sw	a4,540(s1)
    80003fc2:	1ff7f793          	andi	a5,a5,511
    80003fc6:	97a6                	add	a5,a5,s1
    80003fc8:	faf44703          	lbu	a4,-81(s0)
    80003fcc:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fd0:	2905                	addiw	s2,s2,1
    80003fd2:	b76d                	j	80003f7c <pipewrite+0x80>
  int i = 0;
    80003fd4:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fd6:	21848513          	addi	a0,s1,536
    80003fda:	ffffd097          	auipc	ra,0xffffd
    80003fde:	70a080e7          	jalr	1802(ra) # 800016e4 <wakeup>
  release(&pi->lock);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	00002097          	auipc	ra,0x2
    80003fe8:	260080e7          	jalr	608(ra) # 80006244 <release>
  return i;
    80003fec:	b785                	j	80003f4c <pipewrite+0x50>

0000000080003fee <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fee:	715d                	addi	sp,sp,-80
    80003ff0:	e486                	sd	ra,72(sp)
    80003ff2:	e0a2                	sd	s0,64(sp)
    80003ff4:	fc26                	sd	s1,56(sp)
    80003ff6:	f84a                	sd	s2,48(sp)
    80003ff8:	f44e                	sd	s3,40(sp)
    80003ffa:	f052                	sd	s4,32(sp)
    80003ffc:	ec56                	sd	s5,24(sp)
    80003ffe:	e85a                	sd	s6,16(sp)
    80004000:	0880                	addi	s0,sp,80
    80004002:	84aa                	mv	s1,a0
    80004004:	892e                	mv	s2,a1
    80004006:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004008:	ffffd097          	auipc	ra,0xffffd
    8000400c:	e84080e7          	jalr	-380(ra) # 80000e8c <myproc>
    80004010:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004012:	8526                	mv	a0,s1
    80004014:	00002097          	auipc	ra,0x2
    80004018:	17c080e7          	jalr	380(ra) # 80006190 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000401c:	2184a703          	lw	a4,536(s1)
    80004020:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004024:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004028:	02f71463          	bne	a4,a5,80004050 <piperead+0x62>
    8000402c:	2244a783          	lw	a5,548(s1)
    80004030:	c385                	beqz	a5,80004050 <piperead+0x62>
    if(pr->killed){
    80004032:	028a2783          	lw	a5,40(s4)
    80004036:	ebc1                	bnez	a5,800040c6 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004038:	85a6                	mv	a1,s1
    8000403a:	854e                	mv	a0,s3
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	51c080e7          	jalr	1308(ra) # 80001558 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004044:	2184a703          	lw	a4,536(s1)
    80004048:	21c4a783          	lw	a5,540(s1)
    8000404c:	fef700e3          	beq	a4,a5,8000402c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004050:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004052:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004054:	05505363          	blez	s5,8000409a <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004058:	2184a783          	lw	a5,536(s1)
    8000405c:	21c4a703          	lw	a4,540(s1)
    80004060:	02f70d63          	beq	a4,a5,8000409a <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004064:	0017871b          	addiw	a4,a5,1
    80004068:	20e4ac23          	sw	a4,536(s1)
    8000406c:	1ff7f793          	andi	a5,a5,511
    80004070:	97a6                	add	a5,a5,s1
    80004072:	0187c783          	lbu	a5,24(a5)
    80004076:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000407a:	4685                	li	a3,1
    8000407c:	fbf40613          	addi	a2,s0,-65
    80004080:	85ca                	mv	a1,s2
    80004082:	050a3503          	ld	a0,80(s4)
    80004086:	ffffd097          	auipc	ra,0xffffd
    8000408a:	ac6080e7          	jalr	-1338(ra) # 80000b4c <copyout>
    8000408e:	01650663          	beq	a0,s6,8000409a <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004092:	2985                	addiw	s3,s3,1
    80004094:	0905                	addi	s2,s2,1
    80004096:	fd3a91e3          	bne	s5,s3,80004058 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000409a:	21c48513          	addi	a0,s1,540
    8000409e:	ffffd097          	auipc	ra,0xffffd
    800040a2:	646080e7          	jalr	1606(ra) # 800016e4 <wakeup>
  release(&pi->lock);
    800040a6:	8526                	mv	a0,s1
    800040a8:	00002097          	auipc	ra,0x2
    800040ac:	19c080e7          	jalr	412(ra) # 80006244 <release>
  return i;
}
    800040b0:	854e                	mv	a0,s3
    800040b2:	60a6                	ld	ra,72(sp)
    800040b4:	6406                	ld	s0,64(sp)
    800040b6:	74e2                	ld	s1,56(sp)
    800040b8:	7942                	ld	s2,48(sp)
    800040ba:	79a2                	ld	s3,40(sp)
    800040bc:	7a02                	ld	s4,32(sp)
    800040be:	6ae2                	ld	s5,24(sp)
    800040c0:	6b42                	ld	s6,16(sp)
    800040c2:	6161                	addi	sp,sp,80
    800040c4:	8082                	ret
      release(&pi->lock);
    800040c6:	8526                	mv	a0,s1
    800040c8:	00002097          	auipc	ra,0x2
    800040cc:	17c080e7          	jalr	380(ra) # 80006244 <release>
      return -1;
    800040d0:	59fd                	li	s3,-1
    800040d2:	bff9                	j	800040b0 <piperead+0xc2>

00000000800040d4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040d4:	de010113          	addi	sp,sp,-544
    800040d8:	20113c23          	sd	ra,536(sp)
    800040dc:	20813823          	sd	s0,528(sp)
    800040e0:	20913423          	sd	s1,520(sp)
    800040e4:	21213023          	sd	s2,512(sp)
    800040e8:	ffce                	sd	s3,504(sp)
    800040ea:	fbd2                	sd	s4,496(sp)
    800040ec:	f7d6                	sd	s5,488(sp)
    800040ee:	f3da                	sd	s6,480(sp)
    800040f0:	efde                	sd	s7,472(sp)
    800040f2:	ebe2                	sd	s8,464(sp)
    800040f4:	e7e6                	sd	s9,456(sp)
    800040f6:	e3ea                	sd	s10,448(sp)
    800040f8:	ff6e                	sd	s11,440(sp)
    800040fa:	1400                	addi	s0,sp,544
    800040fc:	892a                	mv	s2,a0
    800040fe:	dea43423          	sd	a0,-536(s0)
    80004102:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004106:	ffffd097          	auipc	ra,0xffffd
    8000410a:	d86080e7          	jalr	-634(ra) # 80000e8c <myproc>
    8000410e:	84aa                	mv	s1,a0

  begin_op();
    80004110:	fffff097          	auipc	ra,0xfffff
    80004114:	4a6080e7          	jalr	1190(ra) # 800035b6 <begin_op>

  if((ip = namei(path)) == 0){
    80004118:	854a                	mv	a0,s2
    8000411a:	fffff097          	auipc	ra,0xfffff
    8000411e:	280080e7          	jalr	640(ra) # 8000339a <namei>
    80004122:	c93d                	beqz	a0,80004198 <exec+0xc4>
    80004124:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	abe080e7          	jalr	-1346(ra) # 80002be4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000412e:	04000713          	li	a4,64
    80004132:	4681                	li	a3,0
    80004134:	e5040613          	addi	a2,s0,-432
    80004138:	4581                	li	a1,0
    8000413a:	8556                	mv	a0,s5
    8000413c:	fffff097          	auipc	ra,0xfffff
    80004140:	d5c080e7          	jalr	-676(ra) # 80002e98 <readi>
    80004144:	04000793          	li	a5,64
    80004148:	00f51a63          	bne	a0,a5,8000415c <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000414c:	e5042703          	lw	a4,-432(s0)
    80004150:	464c47b7          	lui	a5,0x464c4
    80004154:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004158:	04f70663          	beq	a4,a5,800041a4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000415c:	8556                	mv	a0,s5
    8000415e:	fffff097          	auipc	ra,0xfffff
    80004162:	ce8080e7          	jalr	-792(ra) # 80002e46 <iunlockput>
    end_op();
    80004166:	fffff097          	auipc	ra,0xfffff
    8000416a:	4d0080e7          	jalr	1232(ra) # 80003636 <end_op>
  }
  return -1;
    8000416e:	557d                	li	a0,-1
}
    80004170:	21813083          	ld	ra,536(sp)
    80004174:	21013403          	ld	s0,528(sp)
    80004178:	20813483          	ld	s1,520(sp)
    8000417c:	20013903          	ld	s2,512(sp)
    80004180:	79fe                	ld	s3,504(sp)
    80004182:	7a5e                	ld	s4,496(sp)
    80004184:	7abe                	ld	s5,488(sp)
    80004186:	7b1e                	ld	s6,480(sp)
    80004188:	6bfe                	ld	s7,472(sp)
    8000418a:	6c5e                	ld	s8,464(sp)
    8000418c:	6cbe                	ld	s9,456(sp)
    8000418e:	6d1e                	ld	s10,448(sp)
    80004190:	7dfa                	ld	s11,440(sp)
    80004192:	22010113          	addi	sp,sp,544
    80004196:	8082                	ret
    end_op();
    80004198:	fffff097          	auipc	ra,0xfffff
    8000419c:	49e080e7          	jalr	1182(ra) # 80003636 <end_op>
    return -1;
    800041a0:	557d                	li	a0,-1
    800041a2:	b7f9                	j	80004170 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041a4:	8526                	mv	a0,s1
    800041a6:	ffffd097          	auipc	ra,0xffffd
    800041aa:	daa080e7          	jalr	-598(ra) # 80000f50 <proc_pagetable>
    800041ae:	8b2a                	mv	s6,a0
    800041b0:	d555                	beqz	a0,8000415c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b2:	e7042783          	lw	a5,-400(s0)
    800041b6:	e8845703          	lhu	a4,-376(s0)
    800041ba:	c735                	beqz	a4,80004226 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041bc:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041be:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041c2:	6a05                	lui	s4,0x1
    800041c4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041c8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041cc:	6d85                	lui	s11,0x1
    800041ce:	7d7d                	lui	s10,0xfffff
    800041d0:	ac1d                	j	80004406 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041d2:	00004517          	auipc	a0,0x4
    800041d6:	43e50513          	addi	a0,a0,1086 # 80008610 <etext+0x610>
    800041da:	00002097          	auipc	ra,0x2
    800041de:	a7a080e7          	jalr	-1414(ra) # 80005c54 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041e2:	874a                	mv	a4,s2
    800041e4:	009c86bb          	addw	a3,s9,s1
    800041e8:	4581                	li	a1,0
    800041ea:	8556                	mv	a0,s5
    800041ec:	fffff097          	auipc	ra,0xfffff
    800041f0:	cac080e7          	jalr	-852(ra) # 80002e98 <readi>
    800041f4:	2501                	sext.w	a0,a0
    800041f6:	1aa91863          	bne	s2,a0,800043a6 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041fa:	009d84bb          	addw	s1,s11,s1
    800041fe:	013d09bb          	addw	s3,s10,s3
    80004202:	1f74f263          	bgeu	s1,s7,800043e6 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004206:	02049593          	slli	a1,s1,0x20
    8000420a:	9181                	srli	a1,a1,0x20
    8000420c:	95e2                	add	a1,a1,s8
    8000420e:	855a                	mv	a0,s6
    80004210:	ffffc097          	auipc	ra,0xffffc
    80004214:	338080e7          	jalr	824(ra) # 80000548 <walkaddr>
    80004218:	862a                	mv	a2,a0
    if(pa == 0)
    8000421a:	dd45                	beqz	a0,800041d2 <exec+0xfe>
      n = PGSIZE;
    8000421c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000421e:	fd49f2e3          	bgeu	s3,s4,800041e2 <exec+0x10e>
      n = sz - i;
    80004222:	894e                	mv	s2,s3
    80004224:	bf7d                	j	800041e2 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004226:	4481                	li	s1,0
  iunlockput(ip);
    80004228:	8556                	mv	a0,s5
    8000422a:	fffff097          	auipc	ra,0xfffff
    8000422e:	c1c080e7          	jalr	-996(ra) # 80002e46 <iunlockput>
  end_op();
    80004232:	fffff097          	auipc	ra,0xfffff
    80004236:	404080e7          	jalr	1028(ra) # 80003636 <end_op>
  p = myproc();
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	c52080e7          	jalr	-942(ra) # 80000e8c <myproc>
    80004242:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004244:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004248:	6785                	lui	a5,0x1
    8000424a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000424c:	94be                	add	s1,s1,a5
    8000424e:	77fd                	lui	a5,0xfffff
    80004250:	8fe5                	and	a5,a5,s1
    80004252:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004256:	6609                	lui	a2,0x2
    80004258:	963e                	add	a2,a2,a5
    8000425a:	85be                	mv	a1,a5
    8000425c:	855a                	mv	a0,s6
    8000425e:	ffffc097          	auipc	ra,0xffffc
    80004262:	69e080e7          	jalr	1694(ra) # 800008fc <uvmalloc>
    80004266:	8c2a                	mv	s8,a0
  ip = 0;
    80004268:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000426a:	12050e63          	beqz	a0,800043a6 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000426e:	75f9                	lui	a1,0xffffe
    80004270:	95aa                	add	a1,a1,a0
    80004272:	855a                	mv	a0,s6
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	8a6080e7          	jalr	-1882(ra) # 80000b1a <uvmclear>
  stackbase = sp - PGSIZE;
    8000427c:	7afd                	lui	s5,0xfffff
    8000427e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004280:	df043783          	ld	a5,-528(s0)
    80004284:	6388                	ld	a0,0(a5)
    80004286:	c925                	beqz	a0,800042f6 <exec+0x222>
    80004288:	e9040993          	addi	s3,s0,-368
    8000428c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004290:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004292:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004294:	ffffc097          	auipc	ra,0xffffc
    80004298:	0aa080e7          	jalr	170(ra) # 8000033e <strlen>
    8000429c:	0015079b          	addiw	a5,a0,1
    800042a0:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042a4:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042a8:	13596363          	bltu	s2,s5,800043ce <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042ac:	df043d83          	ld	s11,-528(s0)
    800042b0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042b4:	8552                	mv	a0,s4
    800042b6:	ffffc097          	auipc	ra,0xffffc
    800042ba:	088080e7          	jalr	136(ra) # 8000033e <strlen>
    800042be:	0015069b          	addiw	a3,a0,1
    800042c2:	8652                	mv	a2,s4
    800042c4:	85ca                	mv	a1,s2
    800042c6:	855a                	mv	a0,s6
    800042c8:	ffffd097          	auipc	ra,0xffffd
    800042cc:	884080e7          	jalr	-1916(ra) # 80000b4c <copyout>
    800042d0:	10054363          	bltz	a0,800043d6 <exec+0x302>
    ustack[argc] = sp;
    800042d4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042d8:	0485                	addi	s1,s1,1
    800042da:	008d8793          	addi	a5,s11,8
    800042de:	def43823          	sd	a5,-528(s0)
    800042e2:	008db503          	ld	a0,8(s11)
    800042e6:	c911                	beqz	a0,800042fa <exec+0x226>
    if(argc >= MAXARG)
    800042e8:	09a1                	addi	s3,s3,8
    800042ea:	fb3c95e3          	bne	s9,s3,80004294 <exec+0x1c0>
  sz = sz1;
    800042ee:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042f2:	4a81                	li	s5,0
    800042f4:	a84d                	j	800043a6 <exec+0x2d2>
  sp = sz;
    800042f6:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042f8:	4481                	li	s1,0
  ustack[argc] = 0;
    800042fa:	00349793          	slli	a5,s1,0x3
    800042fe:	f9040713          	addi	a4,s0,-112
    80004302:	97ba                	add	a5,a5,a4
    80004304:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd8cc0>
  sp -= (argc+1) * sizeof(uint64);
    80004308:	00148693          	addi	a3,s1,1
    8000430c:	068e                	slli	a3,a3,0x3
    8000430e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004312:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004316:	01597663          	bgeu	s2,s5,80004322 <exec+0x24e>
  sz = sz1;
    8000431a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000431e:	4a81                	li	s5,0
    80004320:	a059                	j	800043a6 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004322:	e9040613          	addi	a2,s0,-368
    80004326:	85ca                	mv	a1,s2
    80004328:	855a                	mv	a0,s6
    8000432a:	ffffd097          	auipc	ra,0xffffd
    8000432e:	822080e7          	jalr	-2014(ra) # 80000b4c <copyout>
    80004332:	0a054663          	bltz	a0,800043de <exec+0x30a>
  p->trapframe->a1 = sp;
    80004336:	058bb783          	ld	a5,88(s7)
    8000433a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000433e:	de843783          	ld	a5,-536(s0)
    80004342:	0007c703          	lbu	a4,0(a5)
    80004346:	cf11                	beqz	a4,80004362 <exec+0x28e>
    80004348:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000434a:	02f00693          	li	a3,47
    8000434e:	a039                	j	8000435c <exec+0x288>
      last = s+1;
    80004350:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004354:	0785                	addi	a5,a5,1
    80004356:	fff7c703          	lbu	a4,-1(a5)
    8000435a:	c701                	beqz	a4,80004362 <exec+0x28e>
    if(*s == '/')
    8000435c:	fed71ce3          	bne	a4,a3,80004354 <exec+0x280>
    80004360:	bfc5                	j	80004350 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004362:	4641                	li	a2,16
    80004364:	de843583          	ld	a1,-536(s0)
    80004368:	158b8513          	addi	a0,s7,344
    8000436c:	ffffc097          	auipc	ra,0xffffc
    80004370:	fa0080e7          	jalr	-96(ra) # 8000030c <safestrcpy>
  oldpagetable = p->pagetable;
    80004374:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004378:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000437c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004380:	058bb783          	ld	a5,88(s7)
    80004384:	e6843703          	ld	a4,-408(s0)
    80004388:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000438a:	058bb783          	ld	a5,88(s7)
    8000438e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004392:	85ea                	mv	a1,s10
    80004394:	ffffd097          	auipc	ra,0xffffd
    80004398:	c58080e7          	jalr	-936(ra) # 80000fec <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000439c:	0004851b          	sext.w	a0,s1
    800043a0:	bbc1                	j	80004170 <exec+0x9c>
    800043a2:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043a6:	df843583          	ld	a1,-520(s0)
    800043aa:	855a                	mv	a0,s6
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	c40080e7          	jalr	-960(ra) # 80000fec <proc_freepagetable>
  if(ip){
    800043b4:	da0a94e3          	bnez	s5,8000415c <exec+0x88>
  return -1;
    800043b8:	557d                	li	a0,-1
    800043ba:	bb5d                	j	80004170 <exec+0x9c>
    800043bc:	de943c23          	sd	s1,-520(s0)
    800043c0:	b7dd                	j	800043a6 <exec+0x2d2>
    800043c2:	de943c23          	sd	s1,-520(s0)
    800043c6:	b7c5                	j	800043a6 <exec+0x2d2>
    800043c8:	de943c23          	sd	s1,-520(s0)
    800043cc:	bfe9                	j	800043a6 <exec+0x2d2>
  sz = sz1;
    800043ce:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043d2:	4a81                	li	s5,0
    800043d4:	bfc9                	j	800043a6 <exec+0x2d2>
  sz = sz1;
    800043d6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043da:	4a81                	li	s5,0
    800043dc:	b7e9                	j	800043a6 <exec+0x2d2>
  sz = sz1;
    800043de:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043e2:	4a81                	li	s5,0
    800043e4:	b7c9                	j	800043a6 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043e6:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ea:	e0843783          	ld	a5,-504(s0)
    800043ee:	0017869b          	addiw	a3,a5,1
    800043f2:	e0d43423          	sd	a3,-504(s0)
    800043f6:	e0043783          	ld	a5,-512(s0)
    800043fa:	0387879b          	addiw	a5,a5,56
    800043fe:	e8845703          	lhu	a4,-376(s0)
    80004402:	e2e6d3e3          	bge	a3,a4,80004228 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004406:	2781                	sext.w	a5,a5
    80004408:	e0f43023          	sd	a5,-512(s0)
    8000440c:	03800713          	li	a4,56
    80004410:	86be                	mv	a3,a5
    80004412:	e1840613          	addi	a2,s0,-488
    80004416:	4581                	li	a1,0
    80004418:	8556                	mv	a0,s5
    8000441a:	fffff097          	auipc	ra,0xfffff
    8000441e:	a7e080e7          	jalr	-1410(ra) # 80002e98 <readi>
    80004422:	03800793          	li	a5,56
    80004426:	f6f51ee3          	bne	a0,a5,800043a2 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000442a:	e1842783          	lw	a5,-488(s0)
    8000442e:	4705                	li	a4,1
    80004430:	fae79de3          	bne	a5,a4,800043ea <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004434:	e4043603          	ld	a2,-448(s0)
    80004438:	e3843783          	ld	a5,-456(s0)
    8000443c:	f8f660e3          	bltu	a2,a5,800043bc <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004440:	e2843783          	ld	a5,-472(s0)
    80004444:	963e                	add	a2,a2,a5
    80004446:	f6f66ee3          	bltu	a2,a5,800043c2 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000444a:	85a6                	mv	a1,s1
    8000444c:	855a                	mv	a0,s6
    8000444e:	ffffc097          	auipc	ra,0xffffc
    80004452:	4ae080e7          	jalr	1198(ra) # 800008fc <uvmalloc>
    80004456:	dea43c23          	sd	a0,-520(s0)
    8000445a:	d53d                	beqz	a0,800043c8 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000445c:	e2843c03          	ld	s8,-472(s0)
    80004460:	de043783          	ld	a5,-544(s0)
    80004464:	00fc77b3          	and	a5,s8,a5
    80004468:	ff9d                	bnez	a5,800043a6 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000446a:	e2042c83          	lw	s9,-480(s0)
    8000446e:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004472:	f60b8ae3          	beqz	s7,800043e6 <exec+0x312>
    80004476:	89de                	mv	s3,s7
    80004478:	4481                	li	s1,0
    8000447a:	b371                	j	80004206 <exec+0x132>

000000008000447c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000447c:	7179                	addi	sp,sp,-48
    8000447e:	f406                	sd	ra,40(sp)
    80004480:	f022                	sd	s0,32(sp)
    80004482:	ec26                	sd	s1,24(sp)
    80004484:	e84a                	sd	s2,16(sp)
    80004486:	1800                	addi	s0,sp,48
    80004488:	892e                	mv	s2,a1
    8000448a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000448c:	fdc40593          	addi	a1,s0,-36
    80004490:	ffffe097          	auipc	ra,0xffffe
    80004494:	b18080e7          	jalr	-1256(ra) # 80001fa8 <argint>
    80004498:	04054063          	bltz	a0,800044d8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000449c:	fdc42703          	lw	a4,-36(s0)
    800044a0:	47bd                	li	a5,15
    800044a2:	02e7ed63          	bltu	a5,a4,800044dc <argfd+0x60>
    800044a6:	ffffd097          	auipc	ra,0xffffd
    800044aa:	9e6080e7          	jalr	-1562(ra) # 80000e8c <myproc>
    800044ae:	fdc42703          	lw	a4,-36(s0)
    800044b2:	01a70793          	addi	a5,a4,26
    800044b6:	078e                	slli	a5,a5,0x3
    800044b8:	953e                	add	a0,a0,a5
    800044ba:	611c                	ld	a5,0(a0)
    800044bc:	c395                	beqz	a5,800044e0 <argfd+0x64>
    return -1;
  if(pfd)
    800044be:	00090463          	beqz	s2,800044c6 <argfd+0x4a>
    *pfd = fd;
    800044c2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044c6:	4501                	li	a0,0
  if(pf)
    800044c8:	c091                	beqz	s1,800044cc <argfd+0x50>
    *pf = f;
    800044ca:	e09c                	sd	a5,0(s1)
}
    800044cc:	70a2                	ld	ra,40(sp)
    800044ce:	7402                	ld	s0,32(sp)
    800044d0:	64e2                	ld	s1,24(sp)
    800044d2:	6942                	ld	s2,16(sp)
    800044d4:	6145                	addi	sp,sp,48
    800044d6:	8082                	ret
    return -1;
    800044d8:	557d                	li	a0,-1
    800044da:	bfcd                	j	800044cc <argfd+0x50>
    return -1;
    800044dc:	557d                	li	a0,-1
    800044de:	b7fd                	j	800044cc <argfd+0x50>
    800044e0:	557d                	li	a0,-1
    800044e2:	b7ed                	j	800044cc <argfd+0x50>

00000000800044e4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044e4:	1101                	addi	sp,sp,-32
    800044e6:	ec06                	sd	ra,24(sp)
    800044e8:	e822                	sd	s0,16(sp)
    800044ea:	e426                	sd	s1,8(sp)
    800044ec:	1000                	addi	s0,sp,32
    800044ee:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044f0:	ffffd097          	auipc	ra,0xffffd
    800044f4:	99c080e7          	jalr	-1636(ra) # 80000e8c <myproc>
    800044f8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044fa:	0d050793          	addi	a5,a0,208
    800044fe:	4501                	li	a0,0
    80004500:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004502:	6398                	ld	a4,0(a5)
    80004504:	cb19                	beqz	a4,8000451a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004506:	2505                	addiw	a0,a0,1
    80004508:	07a1                	addi	a5,a5,8
    8000450a:	fed51ce3          	bne	a0,a3,80004502 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000450e:	557d                	li	a0,-1
}
    80004510:	60e2                	ld	ra,24(sp)
    80004512:	6442                	ld	s0,16(sp)
    80004514:	64a2                	ld	s1,8(sp)
    80004516:	6105                	addi	sp,sp,32
    80004518:	8082                	ret
      p->ofile[fd] = f;
    8000451a:	01a50793          	addi	a5,a0,26
    8000451e:	078e                	slli	a5,a5,0x3
    80004520:	963e                	add	a2,a2,a5
    80004522:	e204                	sd	s1,0(a2)
      return fd;
    80004524:	b7f5                	j	80004510 <fdalloc+0x2c>

0000000080004526 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004526:	715d                	addi	sp,sp,-80
    80004528:	e486                	sd	ra,72(sp)
    8000452a:	e0a2                	sd	s0,64(sp)
    8000452c:	fc26                	sd	s1,56(sp)
    8000452e:	f84a                	sd	s2,48(sp)
    80004530:	f44e                	sd	s3,40(sp)
    80004532:	f052                	sd	s4,32(sp)
    80004534:	ec56                	sd	s5,24(sp)
    80004536:	0880                	addi	s0,sp,80
    80004538:	89ae                	mv	s3,a1
    8000453a:	8ab2                	mv	s5,a2
    8000453c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000453e:	fb040593          	addi	a1,s0,-80
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	e76080e7          	jalr	-394(ra) # 800033b8 <nameiparent>
    8000454a:	892a                	mv	s2,a0
    8000454c:	12050e63          	beqz	a0,80004688 <create+0x162>
    return 0;

  ilock(dp);
    80004550:	ffffe097          	auipc	ra,0xffffe
    80004554:	694080e7          	jalr	1684(ra) # 80002be4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004558:	4601                	li	a2,0
    8000455a:	fb040593          	addi	a1,s0,-80
    8000455e:	854a                	mv	a0,s2
    80004560:	fffff097          	auipc	ra,0xfffff
    80004564:	b68080e7          	jalr	-1176(ra) # 800030c8 <dirlookup>
    80004568:	84aa                	mv	s1,a0
    8000456a:	c921                	beqz	a0,800045ba <create+0x94>
    iunlockput(dp);
    8000456c:	854a                	mv	a0,s2
    8000456e:	fffff097          	auipc	ra,0xfffff
    80004572:	8d8080e7          	jalr	-1832(ra) # 80002e46 <iunlockput>
    ilock(ip);
    80004576:	8526                	mv	a0,s1
    80004578:	ffffe097          	auipc	ra,0xffffe
    8000457c:	66c080e7          	jalr	1644(ra) # 80002be4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004580:	2981                	sext.w	s3,s3
    80004582:	4789                	li	a5,2
    80004584:	02f99463          	bne	s3,a5,800045ac <create+0x86>
    80004588:	0444d783          	lhu	a5,68(s1)
    8000458c:	37f9                	addiw	a5,a5,-2
    8000458e:	17c2                	slli	a5,a5,0x30
    80004590:	93c1                	srli	a5,a5,0x30
    80004592:	4705                	li	a4,1
    80004594:	00f76c63          	bltu	a4,a5,800045ac <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004598:	8526                	mv	a0,s1
    8000459a:	60a6                	ld	ra,72(sp)
    8000459c:	6406                	ld	s0,64(sp)
    8000459e:	74e2                	ld	s1,56(sp)
    800045a0:	7942                	ld	s2,48(sp)
    800045a2:	79a2                	ld	s3,40(sp)
    800045a4:	7a02                	ld	s4,32(sp)
    800045a6:	6ae2                	ld	s5,24(sp)
    800045a8:	6161                	addi	sp,sp,80
    800045aa:	8082                	ret
    iunlockput(ip);
    800045ac:	8526                	mv	a0,s1
    800045ae:	fffff097          	auipc	ra,0xfffff
    800045b2:	898080e7          	jalr	-1896(ra) # 80002e46 <iunlockput>
    return 0;
    800045b6:	4481                	li	s1,0
    800045b8:	b7c5                	j	80004598 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045ba:	85ce                	mv	a1,s3
    800045bc:	00092503          	lw	a0,0(s2)
    800045c0:	ffffe097          	auipc	ra,0xffffe
    800045c4:	48c080e7          	jalr	1164(ra) # 80002a4c <ialloc>
    800045c8:	84aa                	mv	s1,a0
    800045ca:	c521                	beqz	a0,80004612 <create+0xec>
  ilock(ip);
    800045cc:	ffffe097          	auipc	ra,0xffffe
    800045d0:	618080e7          	jalr	1560(ra) # 80002be4 <ilock>
  ip->major = major;
    800045d4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045d8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045dc:	4a05                	li	s4,1
    800045de:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045e2:	8526                	mv	a0,s1
    800045e4:	ffffe097          	auipc	ra,0xffffe
    800045e8:	536080e7          	jalr	1334(ra) # 80002b1a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045ec:	2981                	sext.w	s3,s3
    800045ee:	03498a63          	beq	s3,s4,80004622 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045f2:	40d0                	lw	a2,4(s1)
    800045f4:	fb040593          	addi	a1,s0,-80
    800045f8:	854a                	mv	a0,s2
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	cde080e7          	jalr	-802(ra) # 800032d8 <dirlink>
    80004602:	06054b63          	bltz	a0,80004678 <create+0x152>
  iunlockput(dp);
    80004606:	854a                	mv	a0,s2
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	83e080e7          	jalr	-1986(ra) # 80002e46 <iunlockput>
  return ip;
    80004610:	b761                	j	80004598 <create+0x72>
    panic("create: ialloc");
    80004612:	00004517          	auipc	a0,0x4
    80004616:	01e50513          	addi	a0,a0,30 # 80008630 <etext+0x630>
    8000461a:	00001097          	auipc	ra,0x1
    8000461e:	63a080e7          	jalr	1594(ra) # 80005c54 <panic>
    dp->nlink++;  // for ".."
    80004622:	04a95783          	lhu	a5,74(s2)
    80004626:	2785                	addiw	a5,a5,1
    80004628:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000462c:	854a                	mv	a0,s2
    8000462e:	ffffe097          	auipc	ra,0xffffe
    80004632:	4ec080e7          	jalr	1260(ra) # 80002b1a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004636:	40d0                	lw	a2,4(s1)
    80004638:	00004597          	auipc	a1,0x4
    8000463c:	00858593          	addi	a1,a1,8 # 80008640 <etext+0x640>
    80004640:	8526                	mv	a0,s1
    80004642:	fffff097          	auipc	ra,0xfffff
    80004646:	c96080e7          	jalr	-874(ra) # 800032d8 <dirlink>
    8000464a:	00054f63          	bltz	a0,80004668 <create+0x142>
    8000464e:	00492603          	lw	a2,4(s2)
    80004652:	00004597          	auipc	a1,0x4
    80004656:	ff658593          	addi	a1,a1,-10 # 80008648 <etext+0x648>
    8000465a:	8526                	mv	a0,s1
    8000465c:	fffff097          	auipc	ra,0xfffff
    80004660:	c7c080e7          	jalr	-900(ra) # 800032d8 <dirlink>
    80004664:	f80557e3          	bgez	a0,800045f2 <create+0xcc>
      panic("create dots");
    80004668:	00004517          	auipc	a0,0x4
    8000466c:	fe850513          	addi	a0,a0,-24 # 80008650 <etext+0x650>
    80004670:	00001097          	auipc	ra,0x1
    80004674:	5e4080e7          	jalr	1508(ra) # 80005c54 <panic>
    panic("create: dirlink");
    80004678:	00004517          	auipc	a0,0x4
    8000467c:	fe850513          	addi	a0,a0,-24 # 80008660 <etext+0x660>
    80004680:	00001097          	auipc	ra,0x1
    80004684:	5d4080e7          	jalr	1492(ra) # 80005c54 <panic>
    return 0;
    80004688:	84aa                	mv	s1,a0
    8000468a:	b739                	j	80004598 <create+0x72>

000000008000468c <sys_dup>:
{
    8000468c:	7179                	addi	sp,sp,-48
    8000468e:	f406                	sd	ra,40(sp)
    80004690:	f022                	sd	s0,32(sp)
    80004692:	ec26                	sd	s1,24(sp)
    80004694:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004696:	fd840613          	addi	a2,s0,-40
    8000469a:	4581                	li	a1,0
    8000469c:	4501                	li	a0,0
    8000469e:	00000097          	auipc	ra,0x0
    800046a2:	dde080e7          	jalr	-546(ra) # 8000447c <argfd>
    return -1;
    800046a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046a8:	02054363          	bltz	a0,800046ce <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046ac:	fd843503          	ld	a0,-40(s0)
    800046b0:	00000097          	auipc	ra,0x0
    800046b4:	e34080e7          	jalr	-460(ra) # 800044e4 <fdalloc>
    800046b8:	84aa                	mv	s1,a0
    return -1;
    800046ba:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046bc:	00054963          	bltz	a0,800046ce <sys_dup+0x42>
  filedup(f);
    800046c0:	fd843503          	ld	a0,-40(s0)
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	36c080e7          	jalr	876(ra) # 80003a30 <filedup>
  return fd;
    800046cc:	87a6                	mv	a5,s1
}
    800046ce:	853e                	mv	a0,a5
    800046d0:	70a2                	ld	ra,40(sp)
    800046d2:	7402                	ld	s0,32(sp)
    800046d4:	64e2                	ld	s1,24(sp)
    800046d6:	6145                	addi	sp,sp,48
    800046d8:	8082                	ret

00000000800046da <sys_read>:
{
    800046da:	7179                	addi	sp,sp,-48
    800046dc:	f406                	sd	ra,40(sp)
    800046de:	f022                	sd	s0,32(sp)
    800046e0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e2:	fe840613          	addi	a2,s0,-24
    800046e6:	4581                	li	a1,0
    800046e8:	4501                	li	a0,0
    800046ea:	00000097          	auipc	ra,0x0
    800046ee:	d92080e7          	jalr	-622(ra) # 8000447c <argfd>
    return -1;
    800046f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f4:	04054163          	bltz	a0,80004736 <sys_read+0x5c>
    800046f8:	fe440593          	addi	a1,s0,-28
    800046fc:	4509                	li	a0,2
    800046fe:	ffffe097          	auipc	ra,0xffffe
    80004702:	8aa080e7          	jalr	-1878(ra) # 80001fa8 <argint>
    return -1;
    80004706:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004708:	02054763          	bltz	a0,80004736 <sys_read+0x5c>
    8000470c:	fd840593          	addi	a1,s0,-40
    80004710:	4505                	li	a0,1
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	8b8080e7          	jalr	-1864(ra) # 80001fca <argaddr>
    return -1;
    8000471a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471c:	00054d63          	bltz	a0,80004736 <sys_read+0x5c>
  return fileread(f, p, n);
    80004720:	fe442603          	lw	a2,-28(s0)
    80004724:	fd843583          	ld	a1,-40(s0)
    80004728:	fe843503          	ld	a0,-24(s0)
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	490080e7          	jalr	1168(ra) # 80003bbc <fileread>
    80004734:	87aa                	mv	a5,a0
}
    80004736:	853e                	mv	a0,a5
    80004738:	70a2                	ld	ra,40(sp)
    8000473a:	7402                	ld	s0,32(sp)
    8000473c:	6145                	addi	sp,sp,48
    8000473e:	8082                	ret

0000000080004740 <sys_write>:
{
    80004740:	7179                	addi	sp,sp,-48
    80004742:	f406                	sd	ra,40(sp)
    80004744:	f022                	sd	s0,32(sp)
    80004746:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004748:	fe840613          	addi	a2,s0,-24
    8000474c:	4581                	li	a1,0
    8000474e:	4501                	li	a0,0
    80004750:	00000097          	auipc	ra,0x0
    80004754:	d2c080e7          	jalr	-724(ra) # 8000447c <argfd>
    return -1;
    80004758:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000475a:	04054163          	bltz	a0,8000479c <sys_write+0x5c>
    8000475e:	fe440593          	addi	a1,s0,-28
    80004762:	4509                	li	a0,2
    80004764:	ffffe097          	auipc	ra,0xffffe
    80004768:	844080e7          	jalr	-1980(ra) # 80001fa8 <argint>
    return -1;
    8000476c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476e:	02054763          	bltz	a0,8000479c <sys_write+0x5c>
    80004772:	fd840593          	addi	a1,s0,-40
    80004776:	4505                	li	a0,1
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	852080e7          	jalr	-1966(ra) # 80001fca <argaddr>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004782:	00054d63          	bltz	a0,8000479c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004786:	fe442603          	lw	a2,-28(s0)
    8000478a:	fd843583          	ld	a1,-40(s0)
    8000478e:	fe843503          	ld	a0,-24(s0)
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	4ec080e7          	jalr	1260(ra) # 80003c7e <filewrite>
    8000479a:	87aa                	mv	a5,a0
}
    8000479c:	853e                	mv	a0,a5
    8000479e:	70a2                	ld	ra,40(sp)
    800047a0:	7402                	ld	s0,32(sp)
    800047a2:	6145                	addi	sp,sp,48
    800047a4:	8082                	ret

00000000800047a6 <sys_close>:
{
    800047a6:	1101                	addi	sp,sp,-32
    800047a8:	ec06                	sd	ra,24(sp)
    800047aa:	e822                	sd	s0,16(sp)
    800047ac:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047ae:	fe040613          	addi	a2,s0,-32
    800047b2:	fec40593          	addi	a1,s0,-20
    800047b6:	4501                	li	a0,0
    800047b8:	00000097          	auipc	ra,0x0
    800047bc:	cc4080e7          	jalr	-828(ra) # 8000447c <argfd>
    return -1;
    800047c0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047c2:	02054463          	bltz	a0,800047ea <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047c6:	ffffc097          	auipc	ra,0xffffc
    800047ca:	6c6080e7          	jalr	1734(ra) # 80000e8c <myproc>
    800047ce:	fec42783          	lw	a5,-20(s0)
    800047d2:	07e9                	addi	a5,a5,26
    800047d4:	078e                	slli	a5,a5,0x3
    800047d6:	97aa                	add	a5,a5,a0
    800047d8:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047dc:	fe043503          	ld	a0,-32(s0)
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	2a2080e7          	jalr	674(ra) # 80003a82 <fileclose>
  return 0;
    800047e8:	4781                	li	a5,0
}
    800047ea:	853e                	mv	a0,a5
    800047ec:	60e2                	ld	ra,24(sp)
    800047ee:	6442                	ld	s0,16(sp)
    800047f0:	6105                	addi	sp,sp,32
    800047f2:	8082                	ret

00000000800047f4 <sys_fstat>:
{
    800047f4:	1101                	addi	sp,sp,-32
    800047f6:	ec06                	sd	ra,24(sp)
    800047f8:	e822                	sd	s0,16(sp)
    800047fa:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047fc:	fe840613          	addi	a2,s0,-24
    80004800:	4581                	li	a1,0
    80004802:	4501                	li	a0,0
    80004804:	00000097          	auipc	ra,0x0
    80004808:	c78080e7          	jalr	-904(ra) # 8000447c <argfd>
    return -1;
    8000480c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000480e:	02054563          	bltz	a0,80004838 <sys_fstat+0x44>
    80004812:	fe040593          	addi	a1,s0,-32
    80004816:	4505                	li	a0,1
    80004818:	ffffd097          	auipc	ra,0xffffd
    8000481c:	7b2080e7          	jalr	1970(ra) # 80001fca <argaddr>
    return -1;
    80004820:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004822:	00054b63          	bltz	a0,80004838 <sys_fstat+0x44>
  return filestat(f, st);
    80004826:	fe043583          	ld	a1,-32(s0)
    8000482a:	fe843503          	ld	a0,-24(s0)
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	31c080e7          	jalr	796(ra) # 80003b4a <filestat>
    80004836:	87aa                	mv	a5,a0
}
    80004838:	853e                	mv	a0,a5
    8000483a:	60e2                	ld	ra,24(sp)
    8000483c:	6442                	ld	s0,16(sp)
    8000483e:	6105                	addi	sp,sp,32
    80004840:	8082                	ret

0000000080004842 <sys_link>:
{
    80004842:	7169                	addi	sp,sp,-304
    80004844:	f606                	sd	ra,296(sp)
    80004846:	f222                	sd	s0,288(sp)
    80004848:	ee26                	sd	s1,280(sp)
    8000484a:	ea4a                	sd	s2,272(sp)
    8000484c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000484e:	08000613          	li	a2,128
    80004852:	ed040593          	addi	a1,s0,-304
    80004856:	4501                	li	a0,0
    80004858:	ffffd097          	auipc	ra,0xffffd
    8000485c:	794080e7          	jalr	1940(ra) # 80001fec <argstr>
    return -1;
    80004860:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004862:	10054e63          	bltz	a0,8000497e <sys_link+0x13c>
    80004866:	08000613          	li	a2,128
    8000486a:	f5040593          	addi	a1,s0,-176
    8000486e:	4505                	li	a0,1
    80004870:	ffffd097          	auipc	ra,0xffffd
    80004874:	77c080e7          	jalr	1916(ra) # 80001fec <argstr>
    return -1;
    80004878:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000487a:	10054263          	bltz	a0,8000497e <sys_link+0x13c>
  begin_op();
    8000487e:	fffff097          	auipc	ra,0xfffff
    80004882:	d38080e7          	jalr	-712(ra) # 800035b6 <begin_op>
  if((ip = namei(old)) == 0){
    80004886:	ed040513          	addi	a0,s0,-304
    8000488a:	fffff097          	auipc	ra,0xfffff
    8000488e:	b10080e7          	jalr	-1264(ra) # 8000339a <namei>
    80004892:	84aa                	mv	s1,a0
    80004894:	c551                	beqz	a0,80004920 <sys_link+0xde>
  ilock(ip);
    80004896:	ffffe097          	auipc	ra,0xffffe
    8000489a:	34e080e7          	jalr	846(ra) # 80002be4 <ilock>
  if(ip->type == T_DIR){
    8000489e:	04449703          	lh	a4,68(s1)
    800048a2:	4785                	li	a5,1
    800048a4:	08f70463          	beq	a4,a5,8000492c <sys_link+0xea>
  ip->nlink++;
    800048a8:	04a4d783          	lhu	a5,74(s1)
    800048ac:	2785                	addiw	a5,a5,1
    800048ae:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048b2:	8526                	mv	a0,s1
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	266080e7          	jalr	614(ra) # 80002b1a <iupdate>
  iunlock(ip);
    800048bc:	8526                	mv	a0,s1
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	3e8080e7          	jalr	1000(ra) # 80002ca6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048c6:	fd040593          	addi	a1,s0,-48
    800048ca:	f5040513          	addi	a0,s0,-176
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	aea080e7          	jalr	-1302(ra) # 800033b8 <nameiparent>
    800048d6:	892a                	mv	s2,a0
    800048d8:	c935                	beqz	a0,8000494c <sys_link+0x10a>
  ilock(dp);
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	30a080e7          	jalr	778(ra) # 80002be4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048e2:	00092703          	lw	a4,0(s2)
    800048e6:	409c                	lw	a5,0(s1)
    800048e8:	04f71d63          	bne	a4,a5,80004942 <sys_link+0x100>
    800048ec:	40d0                	lw	a2,4(s1)
    800048ee:	fd040593          	addi	a1,s0,-48
    800048f2:	854a                	mv	a0,s2
    800048f4:	fffff097          	auipc	ra,0xfffff
    800048f8:	9e4080e7          	jalr	-1564(ra) # 800032d8 <dirlink>
    800048fc:	04054363          	bltz	a0,80004942 <sys_link+0x100>
  iunlockput(dp);
    80004900:	854a                	mv	a0,s2
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	544080e7          	jalr	1348(ra) # 80002e46 <iunlockput>
  iput(ip);
    8000490a:	8526                	mv	a0,s1
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	492080e7          	jalr	1170(ra) # 80002d9e <iput>
  end_op();
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	d22080e7          	jalr	-734(ra) # 80003636 <end_op>
  return 0;
    8000491c:	4781                	li	a5,0
    8000491e:	a085                	j	8000497e <sys_link+0x13c>
    end_op();
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	d16080e7          	jalr	-746(ra) # 80003636 <end_op>
    return -1;
    80004928:	57fd                	li	a5,-1
    8000492a:	a891                	j	8000497e <sys_link+0x13c>
    iunlockput(ip);
    8000492c:	8526                	mv	a0,s1
    8000492e:	ffffe097          	auipc	ra,0xffffe
    80004932:	518080e7          	jalr	1304(ra) # 80002e46 <iunlockput>
    end_op();
    80004936:	fffff097          	auipc	ra,0xfffff
    8000493a:	d00080e7          	jalr	-768(ra) # 80003636 <end_op>
    return -1;
    8000493e:	57fd                	li	a5,-1
    80004940:	a83d                	j	8000497e <sys_link+0x13c>
    iunlockput(dp);
    80004942:	854a                	mv	a0,s2
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	502080e7          	jalr	1282(ra) # 80002e46 <iunlockput>
  ilock(ip);
    8000494c:	8526                	mv	a0,s1
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	296080e7          	jalr	662(ra) # 80002be4 <ilock>
  ip->nlink--;
    80004956:	04a4d783          	lhu	a5,74(s1)
    8000495a:	37fd                	addiw	a5,a5,-1
    8000495c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004960:	8526                	mv	a0,s1
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	1b8080e7          	jalr	440(ra) # 80002b1a <iupdate>
  iunlockput(ip);
    8000496a:	8526                	mv	a0,s1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	4da080e7          	jalr	1242(ra) # 80002e46 <iunlockput>
  end_op();
    80004974:	fffff097          	auipc	ra,0xfffff
    80004978:	cc2080e7          	jalr	-830(ra) # 80003636 <end_op>
  return -1;
    8000497c:	57fd                	li	a5,-1
}
    8000497e:	853e                	mv	a0,a5
    80004980:	70b2                	ld	ra,296(sp)
    80004982:	7412                	ld	s0,288(sp)
    80004984:	64f2                	ld	s1,280(sp)
    80004986:	6952                	ld	s2,272(sp)
    80004988:	6155                	addi	sp,sp,304
    8000498a:	8082                	ret

000000008000498c <sys_unlink>:
{
    8000498c:	7151                	addi	sp,sp,-240
    8000498e:	f586                	sd	ra,232(sp)
    80004990:	f1a2                	sd	s0,224(sp)
    80004992:	eda6                	sd	s1,216(sp)
    80004994:	e9ca                	sd	s2,208(sp)
    80004996:	e5ce                	sd	s3,200(sp)
    80004998:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000499a:	08000613          	li	a2,128
    8000499e:	f3040593          	addi	a1,s0,-208
    800049a2:	4501                	li	a0,0
    800049a4:	ffffd097          	auipc	ra,0xffffd
    800049a8:	648080e7          	jalr	1608(ra) # 80001fec <argstr>
    800049ac:	18054163          	bltz	a0,80004b2e <sys_unlink+0x1a2>
  begin_op();
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	c06080e7          	jalr	-1018(ra) # 800035b6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049b8:	fb040593          	addi	a1,s0,-80
    800049bc:	f3040513          	addi	a0,s0,-208
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	9f8080e7          	jalr	-1544(ra) # 800033b8 <nameiparent>
    800049c8:	84aa                	mv	s1,a0
    800049ca:	c979                	beqz	a0,80004aa0 <sys_unlink+0x114>
  ilock(dp);
    800049cc:	ffffe097          	auipc	ra,0xffffe
    800049d0:	218080e7          	jalr	536(ra) # 80002be4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049d4:	00004597          	auipc	a1,0x4
    800049d8:	c6c58593          	addi	a1,a1,-916 # 80008640 <etext+0x640>
    800049dc:	fb040513          	addi	a0,s0,-80
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	6ce080e7          	jalr	1742(ra) # 800030ae <namecmp>
    800049e8:	14050a63          	beqz	a0,80004b3c <sys_unlink+0x1b0>
    800049ec:	00004597          	auipc	a1,0x4
    800049f0:	c5c58593          	addi	a1,a1,-932 # 80008648 <etext+0x648>
    800049f4:	fb040513          	addi	a0,s0,-80
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	6b6080e7          	jalr	1718(ra) # 800030ae <namecmp>
    80004a00:	12050e63          	beqz	a0,80004b3c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a04:	f2c40613          	addi	a2,s0,-212
    80004a08:	fb040593          	addi	a1,s0,-80
    80004a0c:	8526                	mv	a0,s1
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	6ba080e7          	jalr	1722(ra) # 800030c8 <dirlookup>
    80004a16:	892a                	mv	s2,a0
    80004a18:	12050263          	beqz	a0,80004b3c <sys_unlink+0x1b0>
  ilock(ip);
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	1c8080e7          	jalr	456(ra) # 80002be4 <ilock>
  if(ip->nlink < 1)
    80004a24:	04a91783          	lh	a5,74(s2)
    80004a28:	08f05263          	blez	a5,80004aac <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a2c:	04491703          	lh	a4,68(s2)
    80004a30:	4785                	li	a5,1
    80004a32:	08f70563          	beq	a4,a5,80004abc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a36:	4641                	li	a2,16
    80004a38:	4581                	li	a1,0
    80004a3a:	fc040513          	addi	a0,s0,-64
    80004a3e:	ffffb097          	auipc	ra,0xffffb
    80004a42:	784080e7          	jalr	1924(ra) # 800001c2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a46:	4741                	li	a4,16
    80004a48:	f2c42683          	lw	a3,-212(s0)
    80004a4c:	fc040613          	addi	a2,s0,-64
    80004a50:	4581                	li	a1,0
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	53c080e7          	jalr	1340(ra) # 80002f90 <writei>
    80004a5c:	47c1                	li	a5,16
    80004a5e:	0af51563          	bne	a0,a5,80004b08 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a62:	04491703          	lh	a4,68(s2)
    80004a66:	4785                	li	a5,1
    80004a68:	0af70863          	beq	a4,a5,80004b18 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a6c:	8526                	mv	a0,s1
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	3d8080e7          	jalr	984(ra) # 80002e46 <iunlockput>
  ip->nlink--;
    80004a76:	04a95783          	lhu	a5,74(s2)
    80004a7a:	37fd                	addiw	a5,a5,-1
    80004a7c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a80:	854a                	mv	a0,s2
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	098080e7          	jalr	152(ra) # 80002b1a <iupdate>
  iunlockput(ip);
    80004a8a:	854a                	mv	a0,s2
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	3ba080e7          	jalr	954(ra) # 80002e46 <iunlockput>
  end_op();
    80004a94:	fffff097          	auipc	ra,0xfffff
    80004a98:	ba2080e7          	jalr	-1118(ra) # 80003636 <end_op>
  return 0;
    80004a9c:	4501                	li	a0,0
    80004a9e:	a84d                	j	80004b50 <sys_unlink+0x1c4>
    end_op();
    80004aa0:	fffff097          	auipc	ra,0xfffff
    80004aa4:	b96080e7          	jalr	-1130(ra) # 80003636 <end_op>
    return -1;
    80004aa8:	557d                	li	a0,-1
    80004aaa:	a05d                	j	80004b50 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aac:	00004517          	auipc	a0,0x4
    80004ab0:	bc450513          	addi	a0,a0,-1084 # 80008670 <etext+0x670>
    80004ab4:	00001097          	auipc	ra,0x1
    80004ab8:	1a0080e7          	jalr	416(ra) # 80005c54 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004abc:	04c92703          	lw	a4,76(s2)
    80004ac0:	02000793          	li	a5,32
    80004ac4:	f6e7f9e3          	bgeu	a5,a4,80004a36 <sys_unlink+0xaa>
    80004ac8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004acc:	4741                	li	a4,16
    80004ace:	86ce                	mv	a3,s3
    80004ad0:	f1840613          	addi	a2,s0,-232
    80004ad4:	4581                	li	a1,0
    80004ad6:	854a                	mv	a0,s2
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	3c0080e7          	jalr	960(ra) # 80002e98 <readi>
    80004ae0:	47c1                	li	a5,16
    80004ae2:	00f51b63          	bne	a0,a5,80004af8 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ae6:	f1845783          	lhu	a5,-232(s0)
    80004aea:	e7a1                	bnez	a5,80004b32 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aec:	29c1                	addiw	s3,s3,16
    80004aee:	04c92783          	lw	a5,76(s2)
    80004af2:	fcf9ede3          	bltu	s3,a5,80004acc <sys_unlink+0x140>
    80004af6:	b781                	j	80004a36 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004af8:	00004517          	auipc	a0,0x4
    80004afc:	b9050513          	addi	a0,a0,-1136 # 80008688 <etext+0x688>
    80004b00:	00001097          	auipc	ra,0x1
    80004b04:	154080e7          	jalr	340(ra) # 80005c54 <panic>
    panic("unlink: writei");
    80004b08:	00004517          	auipc	a0,0x4
    80004b0c:	b9850513          	addi	a0,a0,-1128 # 800086a0 <etext+0x6a0>
    80004b10:	00001097          	auipc	ra,0x1
    80004b14:	144080e7          	jalr	324(ra) # 80005c54 <panic>
    dp->nlink--;
    80004b18:	04a4d783          	lhu	a5,74(s1)
    80004b1c:	37fd                	addiw	a5,a5,-1
    80004b1e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b22:	8526                	mv	a0,s1
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	ff6080e7          	jalr	-10(ra) # 80002b1a <iupdate>
    80004b2c:	b781                	j	80004a6c <sys_unlink+0xe0>
    return -1;
    80004b2e:	557d                	li	a0,-1
    80004b30:	a005                	j	80004b50 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b32:	854a                	mv	a0,s2
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	312080e7          	jalr	786(ra) # 80002e46 <iunlockput>
  iunlockput(dp);
    80004b3c:	8526                	mv	a0,s1
    80004b3e:	ffffe097          	auipc	ra,0xffffe
    80004b42:	308080e7          	jalr	776(ra) # 80002e46 <iunlockput>
  end_op();
    80004b46:	fffff097          	auipc	ra,0xfffff
    80004b4a:	af0080e7          	jalr	-1296(ra) # 80003636 <end_op>
  return -1;
    80004b4e:	557d                	li	a0,-1
}
    80004b50:	70ae                	ld	ra,232(sp)
    80004b52:	740e                	ld	s0,224(sp)
    80004b54:	64ee                	ld	s1,216(sp)
    80004b56:	694e                	ld	s2,208(sp)
    80004b58:	69ae                	ld	s3,200(sp)
    80004b5a:	616d                	addi	sp,sp,240
    80004b5c:	8082                	ret

0000000080004b5e <sys_open>:

uint64
sys_open(void)
{
    80004b5e:	7131                	addi	sp,sp,-192
    80004b60:	fd06                	sd	ra,184(sp)
    80004b62:	f922                	sd	s0,176(sp)
    80004b64:	f526                	sd	s1,168(sp)
    80004b66:	f14a                	sd	s2,160(sp)
    80004b68:	ed4e                	sd	s3,152(sp)
    80004b6a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b6c:	08000613          	li	a2,128
    80004b70:	f5040593          	addi	a1,s0,-176
    80004b74:	4501                	li	a0,0
    80004b76:	ffffd097          	auipc	ra,0xffffd
    80004b7a:	476080e7          	jalr	1142(ra) # 80001fec <argstr>
    return -1;
    80004b7e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b80:	0c054163          	bltz	a0,80004c42 <sys_open+0xe4>
    80004b84:	f4c40593          	addi	a1,s0,-180
    80004b88:	4505                	li	a0,1
    80004b8a:	ffffd097          	auipc	ra,0xffffd
    80004b8e:	41e080e7          	jalr	1054(ra) # 80001fa8 <argint>
    80004b92:	0a054863          	bltz	a0,80004c42 <sys_open+0xe4>

  begin_op();
    80004b96:	fffff097          	auipc	ra,0xfffff
    80004b9a:	a20080e7          	jalr	-1504(ra) # 800035b6 <begin_op>

  if(omode & O_CREATE){
    80004b9e:	f4c42783          	lw	a5,-180(s0)
    80004ba2:	2007f793          	andi	a5,a5,512
    80004ba6:	cbdd                	beqz	a5,80004c5c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ba8:	4681                	li	a3,0
    80004baa:	4601                	li	a2,0
    80004bac:	4589                	li	a1,2
    80004bae:	f5040513          	addi	a0,s0,-176
    80004bb2:	00000097          	auipc	ra,0x0
    80004bb6:	974080e7          	jalr	-1676(ra) # 80004526 <create>
    80004bba:	892a                	mv	s2,a0
    if(ip == 0){
    80004bbc:	c959                	beqz	a0,80004c52 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bbe:	04491703          	lh	a4,68(s2)
    80004bc2:	478d                	li	a5,3
    80004bc4:	00f71763          	bne	a4,a5,80004bd2 <sys_open+0x74>
    80004bc8:	04695703          	lhu	a4,70(s2)
    80004bcc:	47a5                	li	a5,9
    80004bce:	0ce7ec63          	bltu	a5,a4,80004ca6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bd2:	fffff097          	auipc	ra,0xfffff
    80004bd6:	df4080e7          	jalr	-524(ra) # 800039c6 <filealloc>
    80004bda:	89aa                	mv	s3,a0
    80004bdc:	10050263          	beqz	a0,80004ce0 <sys_open+0x182>
    80004be0:	00000097          	auipc	ra,0x0
    80004be4:	904080e7          	jalr	-1788(ra) # 800044e4 <fdalloc>
    80004be8:	84aa                	mv	s1,a0
    80004bea:	0e054663          	bltz	a0,80004cd6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bee:	04491703          	lh	a4,68(s2)
    80004bf2:	478d                	li	a5,3
    80004bf4:	0cf70463          	beq	a4,a5,80004cbc <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bf8:	4789                	li	a5,2
    80004bfa:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bfe:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c02:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c06:	f4c42783          	lw	a5,-180(s0)
    80004c0a:	0017c713          	xori	a4,a5,1
    80004c0e:	8b05                	andi	a4,a4,1
    80004c10:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c14:	0037f713          	andi	a4,a5,3
    80004c18:	00e03733          	snez	a4,a4
    80004c1c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c20:	4007f793          	andi	a5,a5,1024
    80004c24:	c791                	beqz	a5,80004c30 <sys_open+0xd2>
    80004c26:	04491703          	lh	a4,68(s2)
    80004c2a:	4789                	li	a5,2
    80004c2c:	08f70f63          	beq	a4,a5,80004cca <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c30:	854a                	mv	a0,s2
    80004c32:	ffffe097          	auipc	ra,0xffffe
    80004c36:	074080e7          	jalr	116(ra) # 80002ca6 <iunlock>
  end_op();
    80004c3a:	fffff097          	auipc	ra,0xfffff
    80004c3e:	9fc080e7          	jalr	-1540(ra) # 80003636 <end_op>

  return fd;
}
    80004c42:	8526                	mv	a0,s1
    80004c44:	70ea                	ld	ra,184(sp)
    80004c46:	744a                	ld	s0,176(sp)
    80004c48:	74aa                	ld	s1,168(sp)
    80004c4a:	790a                	ld	s2,160(sp)
    80004c4c:	69ea                	ld	s3,152(sp)
    80004c4e:	6129                	addi	sp,sp,192
    80004c50:	8082                	ret
      end_op();
    80004c52:	fffff097          	auipc	ra,0xfffff
    80004c56:	9e4080e7          	jalr	-1564(ra) # 80003636 <end_op>
      return -1;
    80004c5a:	b7e5                	j	80004c42 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c5c:	f5040513          	addi	a0,s0,-176
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	73a080e7          	jalr	1850(ra) # 8000339a <namei>
    80004c68:	892a                	mv	s2,a0
    80004c6a:	c905                	beqz	a0,80004c9a <sys_open+0x13c>
    ilock(ip);
    80004c6c:	ffffe097          	auipc	ra,0xffffe
    80004c70:	f78080e7          	jalr	-136(ra) # 80002be4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c74:	04491703          	lh	a4,68(s2)
    80004c78:	4785                	li	a5,1
    80004c7a:	f4f712e3          	bne	a4,a5,80004bbe <sys_open+0x60>
    80004c7e:	f4c42783          	lw	a5,-180(s0)
    80004c82:	dba1                	beqz	a5,80004bd2 <sys_open+0x74>
      iunlockput(ip);
    80004c84:	854a                	mv	a0,s2
    80004c86:	ffffe097          	auipc	ra,0xffffe
    80004c8a:	1c0080e7          	jalr	448(ra) # 80002e46 <iunlockput>
      end_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	9a8080e7          	jalr	-1624(ra) # 80003636 <end_op>
      return -1;
    80004c96:	54fd                	li	s1,-1
    80004c98:	b76d                	j	80004c42 <sys_open+0xe4>
      end_op();
    80004c9a:	fffff097          	auipc	ra,0xfffff
    80004c9e:	99c080e7          	jalr	-1636(ra) # 80003636 <end_op>
      return -1;
    80004ca2:	54fd                	li	s1,-1
    80004ca4:	bf79                	j	80004c42 <sys_open+0xe4>
    iunlockput(ip);
    80004ca6:	854a                	mv	a0,s2
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	19e080e7          	jalr	414(ra) # 80002e46 <iunlockput>
    end_op();
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	986080e7          	jalr	-1658(ra) # 80003636 <end_op>
    return -1;
    80004cb8:	54fd                	li	s1,-1
    80004cba:	b761                	j	80004c42 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cbc:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cc0:	04691783          	lh	a5,70(s2)
    80004cc4:	02f99223          	sh	a5,36(s3)
    80004cc8:	bf2d                	j	80004c02 <sys_open+0xa4>
    itrunc(ip);
    80004cca:	854a                	mv	a0,s2
    80004ccc:	ffffe097          	auipc	ra,0xffffe
    80004cd0:	026080e7          	jalr	38(ra) # 80002cf2 <itrunc>
    80004cd4:	bfb1                	j	80004c30 <sys_open+0xd2>
      fileclose(f);
    80004cd6:	854e                	mv	a0,s3
    80004cd8:	fffff097          	auipc	ra,0xfffff
    80004cdc:	daa080e7          	jalr	-598(ra) # 80003a82 <fileclose>
    iunlockput(ip);
    80004ce0:	854a                	mv	a0,s2
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	164080e7          	jalr	356(ra) # 80002e46 <iunlockput>
    end_op();
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	94c080e7          	jalr	-1716(ra) # 80003636 <end_op>
    return -1;
    80004cf2:	54fd                	li	s1,-1
    80004cf4:	b7b9                	j	80004c42 <sys_open+0xe4>

0000000080004cf6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cf6:	7175                	addi	sp,sp,-144
    80004cf8:	e506                	sd	ra,136(sp)
    80004cfa:	e122                	sd	s0,128(sp)
    80004cfc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	8b8080e7          	jalr	-1864(ra) # 800035b6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d06:	08000613          	li	a2,128
    80004d0a:	f7040593          	addi	a1,s0,-144
    80004d0e:	4501                	li	a0,0
    80004d10:	ffffd097          	auipc	ra,0xffffd
    80004d14:	2dc080e7          	jalr	732(ra) # 80001fec <argstr>
    80004d18:	02054963          	bltz	a0,80004d4a <sys_mkdir+0x54>
    80004d1c:	4681                	li	a3,0
    80004d1e:	4601                	li	a2,0
    80004d20:	4585                	li	a1,1
    80004d22:	f7040513          	addi	a0,s0,-144
    80004d26:	00000097          	auipc	ra,0x0
    80004d2a:	800080e7          	jalr	-2048(ra) # 80004526 <create>
    80004d2e:	cd11                	beqz	a0,80004d4a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	116080e7          	jalr	278(ra) # 80002e46 <iunlockput>
  end_op();
    80004d38:	fffff097          	auipc	ra,0xfffff
    80004d3c:	8fe080e7          	jalr	-1794(ra) # 80003636 <end_op>
  return 0;
    80004d40:	4501                	li	a0,0
}
    80004d42:	60aa                	ld	ra,136(sp)
    80004d44:	640a                	ld	s0,128(sp)
    80004d46:	6149                	addi	sp,sp,144
    80004d48:	8082                	ret
    end_op();
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	8ec080e7          	jalr	-1812(ra) # 80003636 <end_op>
    return -1;
    80004d52:	557d                	li	a0,-1
    80004d54:	b7fd                	j	80004d42 <sys_mkdir+0x4c>

0000000080004d56 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d56:	7135                	addi	sp,sp,-160
    80004d58:	ed06                	sd	ra,152(sp)
    80004d5a:	e922                	sd	s0,144(sp)
    80004d5c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	858080e7          	jalr	-1960(ra) # 800035b6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d66:	08000613          	li	a2,128
    80004d6a:	f7040593          	addi	a1,s0,-144
    80004d6e:	4501                	li	a0,0
    80004d70:	ffffd097          	auipc	ra,0xffffd
    80004d74:	27c080e7          	jalr	636(ra) # 80001fec <argstr>
    80004d78:	04054a63          	bltz	a0,80004dcc <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d7c:	f6c40593          	addi	a1,s0,-148
    80004d80:	4505                	li	a0,1
    80004d82:	ffffd097          	auipc	ra,0xffffd
    80004d86:	226080e7          	jalr	550(ra) # 80001fa8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d8a:	04054163          	bltz	a0,80004dcc <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d8e:	f6840593          	addi	a1,s0,-152
    80004d92:	4509                	li	a0,2
    80004d94:	ffffd097          	auipc	ra,0xffffd
    80004d98:	214080e7          	jalr	532(ra) # 80001fa8 <argint>
     argint(1, &major) < 0 ||
    80004d9c:	02054863          	bltz	a0,80004dcc <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004da0:	f6841683          	lh	a3,-152(s0)
    80004da4:	f6c41603          	lh	a2,-148(s0)
    80004da8:	458d                	li	a1,3
    80004daa:	f7040513          	addi	a0,s0,-144
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	778080e7          	jalr	1912(ra) # 80004526 <create>
     argint(2, &minor) < 0 ||
    80004db6:	c919                	beqz	a0,80004dcc <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004db8:	ffffe097          	auipc	ra,0xffffe
    80004dbc:	08e080e7          	jalr	142(ra) # 80002e46 <iunlockput>
  end_op();
    80004dc0:	fffff097          	auipc	ra,0xfffff
    80004dc4:	876080e7          	jalr	-1930(ra) # 80003636 <end_op>
  return 0;
    80004dc8:	4501                	li	a0,0
    80004dca:	a031                	j	80004dd6 <sys_mknod+0x80>
    end_op();
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	86a080e7          	jalr	-1942(ra) # 80003636 <end_op>
    return -1;
    80004dd4:	557d                	li	a0,-1
}
    80004dd6:	60ea                	ld	ra,152(sp)
    80004dd8:	644a                	ld	s0,144(sp)
    80004dda:	610d                	addi	sp,sp,160
    80004ddc:	8082                	ret

0000000080004dde <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dde:	7135                	addi	sp,sp,-160
    80004de0:	ed06                	sd	ra,152(sp)
    80004de2:	e922                	sd	s0,144(sp)
    80004de4:	e526                	sd	s1,136(sp)
    80004de6:	e14a                	sd	s2,128(sp)
    80004de8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dea:	ffffc097          	auipc	ra,0xffffc
    80004dee:	0a2080e7          	jalr	162(ra) # 80000e8c <myproc>
    80004df2:	892a                	mv	s2,a0
  
  begin_op();
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	7c2080e7          	jalr	1986(ra) # 800035b6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dfc:	08000613          	li	a2,128
    80004e00:	f6040593          	addi	a1,s0,-160
    80004e04:	4501                	li	a0,0
    80004e06:	ffffd097          	auipc	ra,0xffffd
    80004e0a:	1e6080e7          	jalr	486(ra) # 80001fec <argstr>
    80004e0e:	04054b63          	bltz	a0,80004e64 <sys_chdir+0x86>
    80004e12:	f6040513          	addi	a0,s0,-160
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	584080e7          	jalr	1412(ra) # 8000339a <namei>
    80004e1e:	84aa                	mv	s1,a0
    80004e20:	c131                	beqz	a0,80004e64 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e22:	ffffe097          	auipc	ra,0xffffe
    80004e26:	dc2080e7          	jalr	-574(ra) # 80002be4 <ilock>
  if(ip->type != T_DIR){
    80004e2a:	04449703          	lh	a4,68(s1)
    80004e2e:	4785                	li	a5,1
    80004e30:	04f71063          	bne	a4,a5,80004e70 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e34:	8526                	mv	a0,s1
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	e70080e7          	jalr	-400(ra) # 80002ca6 <iunlock>
  iput(p->cwd);
    80004e3e:	15093503          	ld	a0,336(s2)
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	f5c080e7          	jalr	-164(ra) # 80002d9e <iput>
  end_op();
    80004e4a:	ffffe097          	auipc	ra,0xffffe
    80004e4e:	7ec080e7          	jalr	2028(ra) # 80003636 <end_op>
  p->cwd = ip;
    80004e52:	14993823          	sd	s1,336(s2)
  return 0;
    80004e56:	4501                	li	a0,0
}
    80004e58:	60ea                	ld	ra,152(sp)
    80004e5a:	644a                	ld	s0,144(sp)
    80004e5c:	64aa                	ld	s1,136(sp)
    80004e5e:	690a                	ld	s2,128(sp)
    80004e60:	610d                	addi	sp,sp,160
    80004e62:	8082                	ret
    end_op();
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	7d2080e7          	jalr	2002(ra) # 80003636 <end_op>
    return -1;
    80004e6c:	557d                	li	a0,-1
    80004e6e:	b7ed                	j	80004e58 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e70:	8526                	mv	a0,s1
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	fd4080e7          	jalr	-44(ra) # 80002e46 <iunlockput>
    end_op();
    80004e7a:	ffffe097          	auipc	ra,0xffffe
    80004e7e:	7bc080e7          	jalr	1980(ra) # 80003636 <end_op>
    return -1;
    80004e82:	557d                	li	a0,-1
    80004e84:	bfd1                	j	80004e58 <sys_chdir+0x7a>

0000000080004e86 <sys_exec>:

uint64
sys_exec(void)
{
    80004e86:	7145                	addi	sp,sp,-464
    80004e88:	e786                	sd	ra,456(sp)
    80004e8a:	e3a2                	sd	s0,448(sp)
    80004e8c:	ff26                	sd	s1,440(sp)
    80004e8e:	fb4a                	sd	s2,432(sp)
    80004e90:	f74e                	sd	s3,424(sp)
    80004e92:	f352                	sd	s4,416(sp)
    80004e94:	ef56                	sd	s5,408(sp)
    80004e96:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e98:	08000613          	li	a2,128
    80004e9c:	f4040593          	addi	a1,s0,-192
    80004ea0:	4501                	li	a0,0
    80004ea2:	ffffd097          	auipc	ra,0xffffd
    80004ea6:	14a080e7          	jalr	330(ra) # 80001fec <argstr>
    return -1;
    80004eaa:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004eac:	0c054a63          	bltz	a0,80004f80 <sys_exec+0xfa>
    80004eb0:	e3840593          	addi	a1,s0,-456
    80004eb4:	4505                	li	a0,1
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	114080e7          	jalr	276(ra) # 80001fca <argaddr>
    80004ebe:	0c054163          	bltz	a0,80004f80 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ec2:	10000613          	li	a2,256
    80004ec6:	4581                	li	a1,0
    80004ec8:	e4040513          	addi	a0,s0,-448
    80004ecc:	ffffb097          	auipc	ra,0xffffb
    80004ed0:	2f6080e7          	jalr	758(ra) # 800001c2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ed4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ed8:	89a6                	mv	s3,s1
    80004eda:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004edc:	02000a13          	li	s4,32
    80004ee0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ee4:	00391793          	slli	a5,s2,0x3
    80004ee8:	e3040593          	addi	a1,s0,-464
    80004eec:	e3843503          	ld	a0,-456(s0)
    80004ef0:	953e                	add	a0,a0,a5
    80004ef2:	ffffd097          	auipc	ra,0xffffd
    80004ef6:	01c080e7          	jalr	28(ra) # 80001f0e <fetchaddr>
    80004efa:	02054a63          	bltz	a0,80004f2e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004efe:	e3043783          	ld	a5,-464(s0)
    80004f02:	c3b9                	beqz	a5,80004f48 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f04:	ffffb097          	auipc	ra,0xffffb
    80004f08:	214080e7          	jalr	532(ra) # 80000118 <kalloc>
    80004f0c:	85aa                	mv	a1,a0
    80004f0e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f12:	cd11                	beqz	a0,80004f2e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f14:	6605                	lui	a2,0x1
    80004f16:	e3043503          	ld	a0,-464(s0)
    80004f1a:	ffffd097          	auipc	ra,0xffffd
    80004f1e:	046080e7          	jalr	70(ra) # 80001f60 <fetchstr>
    80004f22:	00054663          	bltz	a0,80004f2e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f26:	0905                	addi	s2,s2,1
    80004f28:	09a1                	addi	s3,s3,8
    80004f2a:	fb491be3          	bne	s2,s4,80004ee0 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f2e:	10048913          	addi	s2,s1,256
    80004f32:	6088                	ld	a0,0(s1)
    80004f34:	c529                	beqz	a0,80004f7e <sys_exec+0xf8>
    kfree(argv[i]);
    80004f36:	ffffb097          	auipc	ra,0xffffb
    80004f3a:	0e6080e7          	jalr	230(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f3e:	04a1                	addi	s1,s1,8
    80004f40:	ff2499e3          	bne	s1,s2,80004f32 <sys_exec+0xac>
  return -1;
    80004f44:	597d                	li	s2,-1
    80004f46:	a82d                	j	80004f80 <sys_exec+0xfa>
      argv[i] = 0;
    80004f48:	0a8e                	slli	s5,s5,0x3
    80004f4a:	fc040793          	addi	a5,s0,-64
    80004f4e:	9abe                	add	s5,s5,a5
    80004f50:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8c40>
  int ret = exec(path, argv);
    80004f54:	e4040593          	addi	a1,s0,-448
    80004f58:	f4040513          	addi	a0,s0,-192
    80004f5c:	fffff097          	auipc	ra,0xfffff
    80004f60:	178080e7          	jalr	376(ra) # 800040d4 <exec>
    80004f64:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f66:	10048993          	addi	s3,s1,256
    80004f6a:	6088                	ld	a0,0(s1)
    80004f6c:	c911                	beqz	a0,80004f80 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f6e:	ffffb097          	auipc	ra,0xffffb
    80004f72:	0ae080e7          	jalr	174(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f76:	04a1                	addi	s1,s1,8
    80004f78:	ff3499e3          	bne	s1,s3,80004f6a <sys_exec+0xe4>
    80004f7c:	a011                	j	80004f80 <sys_exec+0xfa>
  return -1;
    80004f7e:	597d                	li	s2,-1
}
    80004f80:	854a                	mv	a0,s2
    80004f82:	60be                	ld	ra,456(sp)
    80004f84:	641e                	ld	s0,448(sp)
    80004f86:	74fa                	ld	s1,440(sp)
    80004f88:	795a                	ld	s2,432(sp)
    80004f8a:	79ba                	ld	s3,424(sp)
    80004f8c:	7a1a                	ld	s4,416(sp)
    80004f8e:	6afa                	ld	s5,408(sp)
    80004f90:	6179                	addi	sp,sp,464
    80004f92:	8082                	ret

0000000080004f94 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f94:	7139                	addi	sp,sp,-64
    80004f96:	fc06                	sd	ra,56(sp)
    80004f98:	f822                	sd	s0,48(sp)
    80004f9a:	f426                	sd	s1,40(sp)
    80004f9c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f9e:	ffffc097          	auipc	ra,0xffffc
    80004fa2:	eee080e7          	jalr	-274(ra) # 80000e8c <myproc>
    80004fa6:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fa8:	fd840593          	addi	a1,s0,-40
    80004fac:	4501                	li	a0,0
    80004fae:	ffffd097          	auipc	ra,0xffffd
    80004fb2:	01c080e7          	jalr	28(ra) # 80001fca <argaddr>
    return -1;
    80004fb6:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fb8:	0e054063          	bltz	a0,80005098 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fbc:	fc840593          	addi	a1,s0,-56
    80004fc0:	fd040513          	addi	a0,s0,-48
    80004fc4:	fffff097          	auipc	ra,0xfffff
    80004fc8:	dee080e7          	jalr	-530(ra) # 80003db2 <pipealloc>
    return -1;
    80004fcc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fce:	0c054563          	bltz	a0,80005098 <sys_pipe+0x104>
  fd0 = -1;
    80004fd2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fd6:	fd043503          	ld	a0,-48(s0)
    80004fda:	fffff097          	auipc	ra,0xfffff
    80004fde:	50a080e7          	jalr	1290(ra) # 800044e4 <fdalloc>
    80004fe2:	fca42223          	sw	a0,-60(s0)
    80004fe6:	08054c63          	bltz	a0,8000507e <sys_pipe+0xea>
    80004fea:	fc843503          	ld	a0,-56(s0)
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	4f6080e7          	jalr	1270(ra) # 800044e4 <fdalloc>
    80004ff6:	fca42023          	sw	a0,-64(s0)
    80004ffa:	06054863          	bltz	a0,8000506a <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ffe:	4691                	li	a3,4
    80005000:	fc440613          	addi	a2,s0,-60
    80005004:	fd843583          	ld	a1,-40(s0)
    80005008:	68a8                	ld	a0,80(s1)
    8000500a:	ffffc097          	auipc	ra,0xffffc
    8000500e:	b42080e7          	jalr	-1214(ra) # 80000b4c <copyout>
    80005012:	02054063          	bltz	a0,80005032 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005016:	4691                	li	a3,4
    80005018:	fc040613          	addi	a2,s0,-64
    8000501c:	fd843583          	ld	a1,-40(s0)
    80005020:	0591                	addi	a1,a1,4
    80005022:	68a8                	ld	a0,80(s1)
    80005024:	ffffc097          	auipc	ra,0xffffc
    80005028:	b28080e7          	jalr	-1240(ra) # 80000b4c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000502c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000502e:	06055563          	bgez	a0,80005098 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005032:	fc442783          	lw	a5,-60(s0)
    80005036:	07e9                	addi	a5,a5,26
    80005038:	078e                	slli	a5,a5,0x3
    8000503a:	97a6                	add	a5,a5,s1
    8000503c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005040:	fc042503          	lw	a0,-64(s0)
    80005044:	0569                	addi	a0,a0,26
    80005046:	050e                	slli	a0,a0,0x3
    80005048:	9526                	add	a0,a0,s1
    8000504a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000504e:	fd043503          	ld	a0,-48(s0)
    80005052:	fffff097          	auipc	ra,0xfffff
    80005056:	a30080e7          	jalr	-1488(ra) # 80003a82 <fileclose>
    fileclose(wf);
    8000505a:	fc843503          	ld	a0,-56(s0)
    8000505e:	fffff097          	auipc	ra,0xfffff
    80005062:	a24080e7          	jalr	-1500(ra) # 80003a82 <fileclose>
    return -1;
    80005066:	57fd                	li	a5,-1
    80005068:	a805                	j	80005098 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000506a:	fc442783          	lw	a5,-60(s0)
    8000506e:	0007c863          	bltz	a5,8000507e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005072:	01a78513          	addi	a0,a5,26
    80005076:	050e                	slli	a0,a0,0x3
    80005078:	9526                	add	a0,a0,s1
    8000507a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000507e:	fd043503          	ld	a0,-48(s0)
    80005082:	fffff097          	auipc	ra,0xfffff
    80005086:	a00080e7          	jalr	-1536(ra) # 80003a82 <fileclose>
    fileclose(wf);
    8000508a:	fc843503          	ld	a0,-56(s0)
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	9f4080e7          	jalr	-1548(ra) # 80003a82 <fileclose>
    return -1;
    80005096:	57fd                	li	a5,-1
}
    80005098:	853e                	mv	a0,a5
    8000509a:	70e2                	ld	ra,56(sp)
    8000509c:	7442                	ld	s0,48(sp)
    8000509e:	74a2                	ld	s1,40(sp)
    800050a0:	6121                	addi	sp,sp,64
    800050a2:	8082                	ret
	...

00000000800050b0 <kernelvec>:
    800050b0:	7111                	addi	sp,sp,-256
    800050b2:	e006                	sd	ra,0(sp)
    800050b4:	e40a                	sd	sp,8(sp)
    800050b6:	e80e                	sd	gp,16(sp)
    800050b8:	ec12                	sd	tp,24(sp)
    800050ba:	f016                	sd	t0,32(sp)
    800050bc:	f41a                	sd	t1,40(sp)
    800050be:	f81e                	sd	t2,48(sp)
    800050c0:	fc22                	sd	s0,56(sp)
    800050c2:	e0a6                	sd	s1,64(sp)
    800050c4:	e4aa                	sd	a0,72(sp)
    800050c6:	e8ae                	sd	a1,80(sp)
    800050c8:	ecb2                	sd	a2,88(sp)
    800050ca:	f0b6                	sd	a3,96(sp)
    800050cc:	f4ba                	sd	a4,104(sp)
    800050ce:	f8be                	sd	a5,112(sp)
    800050d0:	fcc2                	sd	a6,120(sp)
    800050d2:	e146                	sd	a7,128(sp)
    800050d4:	e54a                	sd	s2,136(sp)
    800050d6:	e94e                	sd	s3,144(sp)
    800050d8:	ed52                	sd	s4,152(sp)
    800050da:	f156                	sd	s5,160(sp)
    800050dc:	f55a                	sd	s6,168(sp)
    800050de:	f95e                	sd	s7,176(sp)
    800050e0:	fd62                	sd	s8,184(sp)
    800050e2:	e1e6                	sd	s9,192(sp)
    800050e4:	e5ea                	sd	s10,200(sp)
    800050e6:	e9ee                	sd	s11,208(sp)
    800050e8:	edf2                	sd	t3,216(sp)
    800050ea:	f1f6                	sd	t4,224(sp)
    800050ec:	f5fa                	sd	t5,232(sp)
    800050ee:	f9fe                	sd	t6,240(sp)
    800050f0:	cebfc0ef          	jal	80001dda <kerneltrap>
    800050f4:	6082                	ld	ra,0(sp)
    800050f6:	6122                	ld	sp,8(sp)
    800050f8:	61c2                	ld	gp,16(sp)
    800050fa:	7282                	ld	t0,32(sp)
    800050fc:	7322                	ld	t1,40(sp)
    800050fe:	73c2                	ld	t2,48(sp)
    80005100:	7462                	ld	s0,56(sp)
    80005102:	6486                	ld	s1,64(sp)
    80005104:	6526                	ld	a0,72(sp)
    80005106:	65c6                	ld	a1,80(sp)
    80005108:	6666                	ld	a2,88(sp)
    8000510a:	7686                	ld	a3,96(sp)
    8000510c:	7726                	ld	a4,104(sp)
    8000510e:	77c6                	ld	a5,112(sp)
    80005110:	7866                	ld	a6,120(sp)
    80005112:	688a                	ld	a7,128(sp)
    80005114:	692a                	ld	s2,136(sp)
    80005116:	69ca                	ld	s3,144(sp)
    80005118:	6a6a                	ld	s4,152(sp)
    8000511a:	7a8a                	ld	s5,160(sp)
    8000511c:	7b2a                	ld	s6,168(sp)
    8000511e:	7bca                	ld	s7,176(sp)
    80005120:	7c6a                	ld	s8,184(sp)
    80005122:	6c8e                	ld	s9,192(sp)
    80005124:	6d2e                	ld	s10,200(sp)
    80005126:	6dce                	ld	s11,208(sp)
    80005128:	6e6e                	ld	t3,216(sp)
    8000512a:	7e8e                	ld	t4,224(sp)
    8000512c:	7f2e                	ld	t5,232(sp)
    8000512e:	7fce                	ld	t6,240(sp)
    80005130:	6111                	addi	sp,sp,256
    80005132:	10200073          	sret
    80005136:	00000013          	nop
    8000513a:	00000013          	nop
    8000513e:	0001                	nop

0000000080005140 <timervec>:
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	e10c                	sd	a1,0(a0)
    80005146:	e510                	sd	a2,8(a0)
    80005148:	e914                	sd	a3,16(a0)
    8000514a:	6d0c                	ld	a1,24(a0)
    8000514c:	7110                	ld	a2,32(a0)
    8000514e:	6194                	ld	a3,0(a1)
    80005150:	96b2                	add	a3,a3,a2
    80005152:	e194                	sd	a3,0(a1)
    80005154:	4589                	li	a1,2
    80005156:	14459073          	csrw	sip,a1
    8000515a:	6914                	ld	a3,16(a0)
    8000515c:	6510                	ld	a2,8(a0)
    8000515e:	610c                	ld	a1,0(a0)
    80005160:	34051573          	csrrw	a0,mscratch,a0
    80005164:	30200073          	mret
	...

000000008000516a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000516a:	1141                	addi	sp,sp,-16
    8000516c:	e422                	sd	s0,8(sp)
    8000516e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005170:	0c0007b7          	lui	a5,0xc000
    80005174:	4705                	li	a4,1
    80005176:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005178:	c3d8                	sw	a4,4(a5)
}
    8000517a:	6422                	ld	s0,8(sp)
    8000517c:	0141                	addi	sp,sp,16
    8000517e:	8082                	ret

0000000080005180 <plicinithart>:

void
plicinithart(void)
{
    80005180:	1141                	addi	sp,sp,-16
    80005182:	e406                	sd	ra,8(sp)
    80005184:	e022                	sd	s0,0(sp)
    80005186:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005188:	ffffc097          	auipc	ra,0xffffc
    8000518c:	cd8080e7          	jalr	-808(ra) # 80000e60 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005190:	0085171b          	slliw	a4,a0,0x8
    80005194:	0c0027b7          	lui	a5,0xc002
    80005198:	97ba                	add	a5,a5,a4
    8000519a:	40200713          	li	a4,1026
    8000519e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051a2:	00d5151b          	slliw	a0,a0,0xd
    800051a6:	0c2017b7          	lui	a5,0xc201
    800051aa:	953e                	add	a0,a0,a5
    800051ac:	00052023          	sw	zero,0(a0)
}
    800051b0:	60a2                	ld	ra,8(sp)
    800051b2:	6402                	ld	s0,0(sp)
    800051b4:	0141                	addi	sp,sp,16
    800051b6:	8082                	ret

00000000800051b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051b8:	1141                	addi	sp,sp,-16
    800051ba:	e406                	sd	ra,8(sp)
    800051bc:	e022                	sd	s0,0(sp)
    800051be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051c0:	ffffc097          	auipc	ra,0xffffc
    800051c4:	ca0080e7          	jalr	-864(ra) # 80000e60 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051c8:	00d5179b          	slliw	a5,a0,0xd
    800051cc:	0c201537          	lui	a0,0xc201
    800051d0:	953e                	add	a0,a0,a5
  return irq;
}
    800051d2:	4148                	lw	a0,4(a0)
    800051d4:	60a2                	ld	ra,8(sp)
    800051d6:	6402                	ld	s0,0(sp)
    800051d8:	0141                	addi	sp,sp,16
    800051da:	8082                	ret

00000000800051dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051dc:	1101                	addi	sp,sp,-32
    800051de:	ec06                	sd	ra,24(sp)
    800051e0:	e822                	sd	s0,16(sp)
    800051e2:	e426                	sd	s1,8(sp)
    800051e4:	1000                	addi	s0,sp,32
    800051e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051e8:	ffffc097          	auipc	ra,0xffffc
    800051ec:	c78080e7          	jalr	-904(ra) # 80000e60 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051f0:	00d5151b          	slliw	a0,a0,0xd
    800051f4:	0c2017b7          	lui	a5,0xc201
    800051f8:	97aa                	add	a5,a5,a0
    800051fa:	c3c4                	sw	s1,4(a5)
}
    800051fc:	60e2                	ld	ra,24(sp)
    800051fe:	6442                	ld	s0,16(sp)
    80005200:	64a2                	ld	s1,8(sp)
    80005202:	6105                	addi	sp,sp,32
    80005204:	8082                	ret

0000000080005206 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005206:	1141                	addi	sp,sp,-16
    80005208:	e406                	sd	ra,8(sp)
    8000520a:	e022                	sd	s0,0(sp)
    8000520c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000520e:	479d                	li	a5,7
    80005210:	06a7c963          	blt	a5,a0,80005282 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005214:	00016797          	auipc	a5,0x16
    80005218:	dec78793          	addi	a5,a5,-532 # 8001b000 <disk>
    8000521c:	00a78733          	add	a4,a5,a0
    80005220:	6789                	lui	a5,0x2
    80005222:	97ba                	add	a5,a5,a4
    80005224:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005228:	e7ad                	bnez	a5,80005292 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000522a:	00451793          	slli	a5,a0,0x4
    8000522e:	00018717          	auipc	a4,0x18
    80005232:	dd270713          	addi	a4,a4,-558 # 8001d000 <disk+0x2000>
    80005236:	6314                	ld	a3,0(a4)
    80005238:	96be                	add	a3,a3,a5
    8000523a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000523e:	6314                	ld	a3,0(a4)
    80005240:	96be                	add	a3,a3,a5
    80005242:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005246:	6314                	ld	a3,0(a4)
    80005248:	96be                	add	a3,a3,a5
    8000524a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000524e:	6318                	ld	a4,0(a4)
    80005250:	97ba                	add	a5,a5,a4
    80005252:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005256:	00016797          	auipc	a5,0x16
    8000525a:	daa78793          	addi	a5,a5,-598 # 8001b000 <disk>
    8000525e:	97aa                	add	a5,a5,a0
    80005260:	6509                	lui	a0,0x2
    80005262:	953e                	add	a0,a0,a5
    80005264:	4785                	li	a5,1
    80005266:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000526a:	00018517          	auipc	a0,0x18
    8000526e:	dae50513          	addi	a0,a0,-594 # 8001d018 <disk+0x2018>
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	472080e7          	jalr	1138(ra) # 800016e4 <wakeup>
}
    8000527a:	60a2                	ld	ra,8(sp)
    8000527c:	6402                	ld	s0,0(sp)
    8000527e:	0141                	addi	sp,sp,16
    80005280:	8082                	ret
    panic("free_desc 1");
    80005282:	00003517          	auipc	a0,0x3
    80005286:	42e50513          	addi	a0,a0,1070 # 800086b0 <etext+0x6b0>
    8000528a:	00001097          	auipc	ra,0x1
    8000528e:	9ca080e7          	jalr	-1590(ra) # 80005c54 <panic>
    panic("free_desc 2");
    80005292:	00003517          	auipc	a0,0x3
    80005296:	42e50513          	addi	a0,a0,1070 # 800086c0 <etext+0x6c0>
    8000529a:	00001097          	auipc	ra,0x1
    8000529e:	9ba080e7          	jalr	-1606(ra) # 80005c54 <panic>

00000000800052a2 <virtio_disk_init>:
{
    800052a2:	1101                	addi	sp,sp,-32
    800052a4:	ec06                	sd	ra,24(sp)
    800052a6:	e822                	sd	s0,16(sp)
    800052a8:	e426                	sd	s1,8(sp)
    800052aa:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052ac:	00003597          	auipc	a1,0x3
    800052b0:	42458593          	addi	a1,a1,1060 # 800086d0 <etext+0x6d0>
    800052b4:	00018517          	auipc	a0,0x18
    800052b8:	e7450513          	addi	a0,a0,-396 # 8001d128 <disk+0x2128>
    800052bc:	00001097          	auipc	ra,0x1
    800052c0:	e44080e7          	jalr	-444(ra) # 80006100 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052c4:	100017b7          	lui	a5,0x10001
    800052c8:	4398                	lw	a4,0(a5)
    800052ca:	2701                	sext.w	a4,a4
    800052cc:	747277b7          	lui	a5,0x74727
    800052d0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052d4:	0ef71163          	bne	a4,a5,800053b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052d8:	100017b7          	lui	a5,0x10001
    800052dc:	43dc                	lw	a5,4(a5)
    800052de:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052e0:	4705                	li	a4,1
    800052e2:	0ce79a63          	bne	a5,a4,800053b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052e6:	100017b7          	lui	a5,0x10001
    800052ea:	479c                	lw	a5,8(a5)
    800052ec:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052ee:	4709                	li	a4,2
    800052f0:	0ce79363          	bne	a5,a4,800053b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052f4:	100017b7          	lui	a5,0x10001
    800052f8:	47d8                	lw	a4,12(a5)
    800052fa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052fc:	554d47b7          	lui	a5,0x554d4
    80005300:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005304:	0af71963          	bne	a4,a5,800053b6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005308:	100017b7          	lui	a5,0x10001
    8000530c:	4705                	li	a4,1
    8000530e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005310:	470d                	li	a4,3
    80005312:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005314:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005316:	c7ffe737          	lui	a4,0xc7ffe
    8000531a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000531e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005320:	2701                	sext.w	a4,a4
    80005322:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005324:	472d                	li	a4,11
    80005326:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005328:	473d                	li	a4,15
    8000532a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000532c:	6705                	lui	a4,0x1
    8000532e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005330:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005334:	5bdc                	lw	a5,52(a5)
    80005336:	2781                	sext.w	a5,a5
  if(max == 0)
    80005338:	c7d9                	beqz	a5,800053c6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000533a:	471d                	li	a4,7
    8000533c:	08f77d63          	bgeu	a4,a5,800053d6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005340:	100014b7          	lui	s1,0x10001
    80005344:	47a1                	li	a5,8
    80005346:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005348:	6609                	lui	a2,0x2
    8000534a:	4581                	li	a1,0
    8000534c:	00016517          	auipc	a0,0x16
    80005350:	cb450513          	addi	a0,a0,-844 # 8001b000 <disk>
    80005354:	ffffb097          	auipc	ra,0xffffb
    80005358:	e6e080e7          	jalr	-402(ra) # 800001c2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000535c:	00016717          	auipc	a4,0x16
    80005360:	ca470713          	addi	a4,a4,-860 # 8001b000 <disk>
    80005364:	00c75793          	srli	a5,a4,0xc
    80005368:	2781                	sext.w	a5,a5
    8000536a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000536c:	00018797          	auipc	a5,0x18
    80005370:	c9478793          	addi	a5,a5,-876 # 8001d000 <disk+0x2000>
    80005374:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005376:	00016717          	auipc	a4,0x16
    8000537a:	d0a70713          	addi	a4,a4,-758 # 8001b080 <disk+0x80>
    8000537e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005380:	00017717          	auipc	a4,0x17
    80005384:	c8070713          	addi	a4,a4,-896 # 8001c000 <disk+0x1000>
    80005388:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000538a:	4705                	li	a4,1
    8000538c:	00e78c23          	sb	a4,24(a5)
    80005390:	00e78ca3          	sb	a4,25(a5)
    80005394:	00e78d23          	sb	a4,26(a5)
    80005398:	00e78da3          	sb	a4,27(a5)
    8000539c:	00e78e23          	sb	a4,28(a5)
    800053a0:	00e78ea3          	sb	a4,29(a5)
    800053a4:	00e78f23          	sb	a4,30(a5)
    800053a8:	00e78fa3          	sb	a4,31(a5)
}
    800053ac:	60e2                	ld	ra,24(sp)
    800053ae:	6442                	ld	s0,16(sp)
    800053b0:	64a2                	ld	s1,8(sp)
    800053b2:	6105                	addi	sp,sp,32
    800053b4:	8082                	ret
    panic("could not find virtio disk");
    800053b6:	00003517          	auipc	a0,0x3
    800053ba:	32a50513          	addi	a0,a0,810 # 800086e0 <etext+0x6e0>
    800053be:	00001097          	auipc	ra,0x1
    800053c2:	896080e7          	jalr	-1898(ra) # 80005c54 <panic>
    panic("virtio disk has no queue 0");
    800053c6:	00003517          	auipc	a0,0x3
    800053ca:	33a50513          	addi	a0,a0,826 # 80008700 <etext+0x700>
    800053ce:	00001097          	auipc	ra,0x1
    800053d2:	886080e7          	jalr	-1914(ra) # 80005c54 <panic>
    panic("virtio disk max queue too short");
    800053d6:	00003517          	auipc	a0,0x3
    800053da:	34a50513          	addi	a0,a0,842 # 80008720 <etext+0x720>
    800053de:	00001097          	auipc	ra,0x1
    800053e2:	876080e7          	jalr	-1930(ra) # 80005c54 <panic>

00000000800053e6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053e6:	7119                	addi	sp,sp,-128
    800053e8:	fc86                	sd	ra,120(sp)
    800053ea:	f8a2                	sd	s0,112(sp)
    800053ec:	f4a6                	sd	s1,104(sp)
    800053ee:	f0ca                	sd	s2,96(sp)
    800053f0:	ecce                	sd	s3,88(sp)
    800053f2:	e8d2                	sd	s4,80(sp)
    800053f4:	e4d6                	sd	s5,72(sp)
    800053f6:	e0da                	sd	s6,64(sp)
    800053f8:	fc5e                	sd	s7,56(sp)
    800053fa:	f862                	sd	s8,48(sp)
    800053fc:	f466                	sd	s9,40(sp)
    800053fe:	f06a                	sd	s10,32(sp)
    80005400:	ec6e                	sd	s11,24(sp)
    80005402:	0100                	addi	s0,sp,128
    80005404:	8aaa                	mv	s5,a0
    80005406:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005408:	00c52c83          	lw	s9,12(a0)
    8000540c:	001c9c9b          	slliw	s9,s9,0x1
    80005410:	1c82                	slli	s9,s9,0x20
    80005412:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005416:	00018517          	auipc	a0,0x18
    8000541a:	d1250513          	addi	a0,a0,-750 # 8001d128 <disk+0x2128>
    8000541e:	00001097          	auipc	ra,0x1
    80005422:	d72080e7          	jalr	-654(ra) # 80006190 <acquire>
  for(int i = 0; i < 3; i++){
    80005426:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005428:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000542a:	00016c17          	auipc	s8,0x16
    8000542e:	bd6c0c13          	addi	s8,s8,-1066 # 8001b000 <disk>
    80005432:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005434:	4b0d                	li	s6,3
    80005436:	a0ad                	j	800054a0 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005438:	00fc0733          	add	a4,s8,a5
    8000543c:	975e                	add	a4,a4,s7
    8000543e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005442:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005444:	0207c563          	bltz	a5,8000546e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005448:	2905                	addiw	s2,s2,1
    8000544a:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    8000544c:	19690d63          	beq	s2,s6,800055e6 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80005450:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005452:	00018717          	auipc	a4,0x18
    80005456:	bc670713          	addi	a4,a4,-1082 # 8001d018 <disk+0x2018>
    8000545a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000545c:	00074683          	lbu	a3,0(a4)
    80005460:	fee1                	bnez	a3,80005438 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005462:	2785                	addiw	a5,a5,1
    80005464:	0705                	addi	a4,a4,1
    80005466:	fe979be3          	bne	a5,s1,8000545c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000546a:	57fd                	li	a5,-1
    8000546c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000546e:	01205d63          	blez	s2,80005488 <virtio_disk_rw+0xa2>
    80005472:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005474:	000a2503          	lw	a0,0(s4)
    80005478:	00000097          	auipc	ra,0x0
    8000547c:	d8e080e7          	jalr	-626(ra) # 80005206 <free_desc>
      for(int j = 0; j < i; j++)
    80005480:	2d85                	addiw	s11,s11,1
    80005482:	0a11                	addi	s4,s4,4
    80005484:	ffb918e3          	bne	s2,s11,80005474 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005488:	00018597          	auipc	a1,0x18
    8000548c:	ca058593          	addi	a1,a1,-864 # 8001d128 <disk+0x2128>
    80005490:	00018517          	auipc	a0,0x18
    80005494:	b8850513          	addi	a0,a0,-1144 # 8001d018 <disk+0x2018>
    80005498:	ffffc097          	auipc	ra,0xffffc
    8000549c:	0c0080e7          	jalr	192(ra) # 80001558 <sleep>
  for(int i = 0; i < 3; i++){
    800054a0:	f8040a13          	addi	s4,s0,-128
{
    800054a4:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800054a6:	894e                	mv	s2,s3
    800054a8:	b765                	j	80005450 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054aa:	00018697          	auipc	a3,0x18
    800054ae:	b566b683          	ld	a3,-1194(a3) # 8001d000 <disk+0x2000>
    800054b2:	96ba                	add	a3,a3,a4
    800054b4:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054b8:	00016817          	auipc	a6,0x16
    800054bc:	b4880813          	addi	a6,a6,-1208 # 8001b000 <disk>
    800054c0:	00018697          	auipc	a3,0x18
    800054c4:	b4068693          	addi	a3,a3,-1216 # 8001d000 <disk+0x2000>
    800054c8:	6290                	ld	a2,0(a3)
    800054ca:	963a                	add	a2,a2,a4
    800054cc:	00c65583          	lhu	a1,12(a2)
    800054d0:	0015e593          	ori	a1,a1,1
    800054d4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800054d8:	f8842603          	lw	a2,-120(s0)
    800054dc:	628c                	ld	a1,0(a3)
    800054de:	972e                	add	a4,a4,a1
    800054e0:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054e4:	20050593          	addi	a1,a0,512
    800054e8:	0592                	slli	a1,a1,0x4
    800054ea:	95c2                	add	a1,a1,a6
    800054ec:	577d                	li	a4,-1
    800054ee:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054f2:	00461713          	slli	a4,a2,0x4
    800054f6:	6290                	ld	a2,0(a3)
    800054f8:	963a                	add	a2,a2,a4
    800054fa:	03078793          	addi	a5,a5,48
    800054fe:	97c2                	add	a5,a5,a6
    80005500:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80005502:	629c                	ld	a5,0(a3)
    80005504:	97ba                	add	a5,a5,a4
    80005506:	4605                	li	a2,1
    80005508:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000550a:	629c                	ld	a5,0(a3)
    8000550c:	97ba                	add	a5,a5,a4
    8000550e:	4809                	li	a6,2
    80005510:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005514:	629c                	ld	a5,0(a3)
    80005516:	973e                	add	a4,a4,a5
    80005518:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000551c:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005520:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005524:	6698                	ld	a4,8(a3)
    80005526:	00275783          	lhu	a5,2(a4)
    8000552a:	8b9d                	andi	a5,a5,7
    8000552c:	0786                	slli	a5,a5,0x1
    8000552e:	97ba                	add	a5,a5,a4
    80005530:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80005534:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005538:	6698                	ld	a4,8(a3)
    8000553a:	00275783          	lhu	a5,2(a4)
    8000553e:	2785                	addiw	a5,a5,1
    80005540:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005544:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005548:	100017b7          	lui	a5,0x10001
    8000554c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005550:	004aa783          	lw	a5,4(s5)
    80005554:	02c79163          	bne	a5,a2,80005576 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005558:	00018917          	auipc	s2,0x18
    8000555c:	bd090913          	addi	s2,s2,-1072 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005560:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005562:	85ca                	mv	a1,s2
    80005564:	8556                	mv	a0,s5
    80005566:	ffffc097          	auipc	ra,0xffffc
    8000556a:	ff2080e7          	jalr	-14(ra) # 80001558 <sleep>
  while(b->disk == 1) {
    8000556e:	004aa783          	lw	a5,4(s5)
    80005572:	fe9788e3          	beq	a5,s1,80005562 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005576:	f8042903          	lw	s2,-128(s0)
    8000557a:	20090793          	addi	a5,s2,512
    8000557e:	00479713          	slli	a4,a5,0x4
    80005582:	00016797          	auipc	a5,0x16
    80005586:	a7e78793          	addi	a5,a5,-1410 # 8001b000 <disk>
    8000558a:	97ba                	add	a5,a5,a4
    8000558c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005590:	00018997          	auipc	s3,0x18
    80005594:	a7098993          	addi	s3,s3,-1424 # 8001d000 <disk+0x2000>
    80005598:	00491713          	slli	a4,s2,0x4
    8000559c:	0009b783          	ld	a5,0(s3)
    800055a0:	97ba                	add	a5,a5,a4
    800055a2:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055a6:	854a                	mv	a0,s2
    800055a8:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055ac:	00000097          	auipc	ra,0x0
    800055b0:	c5a080e7          	jalr	-934(ra) # 80005206 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055b4:	8885                	andi	s1,s1,1
    800055b6:	f0ed                	bnez	s1,80005598 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055b8:	00018517          	auipc	a0,0x18
    800055bc:	b7050513          	addi	a0,a0,-1168 # 8001d128 <disk+0x2128>
    800055c0:	00001097          	auipc	ra,0x1
    800055c4:	c84080e7          	jalr	-892(ra) # 80006244 <release>
}
    800055c8:	70e6                	ld	ra,120(sp)
    800055ca:	7446                	ld	s0,112(sp)
    800055cc:	74a6                	ld	s1,104(sp)
    800055ce:	7906                	ld	s2,96(sp)
    800055d0:	69e6                	ld	s3,88(sp)
    800055d2:	6a46                	ld	s4,80(sp)
    800055d4:	6aa6                	ld	s5,72(sp)
    800055d6:	6b06                	ld	s6,64(sp)
    800055d8:	7be2                	ld	s7,56(sp)
    800055da:	7c42                	ld	s8,48(sp)
    800055dc:	7ca2                	ld	s9,40(sp)
    800055de:	7d02                	ld	s10,32(sp)
    800055e0:	6de2                	ld	s11,24(sp)
    800055e2:	6109                	addi	sp,sp,128
    800055e4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055e6:	f8042503          	lw	a0,-128(s0)
    800055ea:	20050793          	addi	a5,a0,512
    800055ee:	0792                	slli	a5,a5,0x4
  if(write)
    800055f0:	00016817          	auipc	a6,0x16
    800055f4:	a1080813          	addi	a6,a6,-1520 # 8001b000 <disk>
    800055f8:	00f80733          	add	a4,a6,a5
    800055fc:	01a036b3          	snez	a3,s10
    80005600:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80005604:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005608:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000560c:	7679                	lui	a2,0xffffe
    8000560e:	963e                	add	a2,a2,a5
    80005610:	00018697          	auipc	a3,0x18
    80005614:	9f068693          	addi	a3,a3,-1552 # 8001d000 <disk+0x2000>
    80005618:	6298                	ld	a4,0(a3)
    8000561a:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000561c:	0a878593          	addi	a1,a5,168
    80005620:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005622:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005624:	6298                	ld	a4,0(a3)
    80005626:	9732                	add	a4,a4,a2
    80005628:	45c1                	li	a1,16
    8000562a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000562c:	6298                	ld	a4,0(a3)
    8000562e:	9732                	add	a4,a4,a2
    80005630:	4585                	li	a1,1
    80005632:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005636:	f8442703          	lw	a4,-124(s0)
    8000563a:	628c                	ld	a1,0(a3)
    8000563c:	962e                	add	a2,a2,a1
    8000563e:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005642:	0712                	slli	a4,a4,0x4
    80005644:	6290                	ld	a2,0(a3)
    80005646:	963a                	add	a2,a2,a4
    80005648:	058a8593          	addi	a1,s5,88
    8000564c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000564e:	6294                	ld	a3,0(a3)
    80005650:	96ba                	add	a3,a3,a4
    80005652:	40000613          	li	a2,1024
    80005656:	c690                	sw	a2,8(a3)
  if(write)
    80005658:	e40d19e3          	bnez	s10,800054aa <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000565c:	00018697          	auipc	a3,0x18
    80005660:	9a46b683          	ld	a3,-1628(a3) # 8001d000 <disk+0x2000>
    80005664:	96ba                	add	a3,a3,a4
    80005666:	4609                	li	a2,2
    80005668:	00c69623          	sh	a2,12(a3)
    8000566c:	b5b1                	j	800054b8 <virtio_disk_rw+0xd2>

000000008000566e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000566e:	1101                	addi	sp,sp,-32
    80005670:	ec06                	sd	ra,24(sp)
    80005672:	e822                	sd	s0,16(sp)
    80005674:	e426                	sd	s1,8(sp)
    80005676:	e04a                	sd	s2,0(sp)
    80005678:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000567a:	00018517          	auipc	a0,0x18
    8000567e:	aae50513          	addi	a0,a0,-1362 # 8001d128 <disk+0x2128>
    80005682:	00001097          	auipc	ra,0x1
    80005686:	b0e080e7          	jalr	-1266(ra) # 80006190 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000568a:	10001737          	lui	a4,0x10001
    8000568e:	533c                	lw	a5,96(a4)
    80005690:	8b8d                	andi	a5,a5,3
    80005692:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005694:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005698:	00018797          	auipc	a5,0x18
    8000569c:	96878793          	addi	a5,a5,-1688 # 8001d000 <disk+0x2000>
    800056a0:	6b94                	ld	a3,16(a5)
    800056a2:	0207d703          	lhu	a4,32(a5)
    800056a6:	0026d783          	lhu	a5,2(a3)
    800056aa:	06f70163          	beq	a4,a5,8000570c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ae:	00016917          	auipc	s2,0x16
    800056b2:	95290913          	addi	s2,s2,-1710 # 8001b000 <disk>
    800056b6:	00018497          	auipc	s1,0x18
    800056ba:	94a48493          	addi	s1,s1,-1718 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056be:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056c2:	6898                	ld	a4,16(s1)
    800056c4:	0204d783          	lhu	a5,32(s1)
    800056c8:	8b9d                	andi	a5,a5,7
    800056ca:	078e                	slli	a5,a5,0x3
    800056cc:	97ba                	add	a5,a5,a4
    800056ce:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056d0:	20078713          	addi	a4,a5,512
    800056d4:	0712                	slli	a4,a4,0x4
    800056d6:	974a                	add	a4,a4,s2
    800056d8:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056dc:	e731                	bnez	a4,80005728 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056de:	20078793          	addi	a5,a5,512
    800056e2:	0792                	slli	a5,a5,0x4
    800056e4:	97ca                	add	a5,a5,s2
    800056e6:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056e8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056ec:	ffffc097          	auipc	ra,0xffffc
    800056f0:	ff8080e7          	jalr	-8(ra) # 800016e4 <wakeup>

    disk.used_idx += 1;
    800056f4:	0204d783          	lhu	a5,32(s1)
    800056f8:	2785                	addiw	a5,a5,1
    800056fa:	17c2                	slli	a5,a5,0x30
    800056fc:	93c1                	srli	a5,a5,0x30
    800056fe:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005702:	6898                	ld	a4,16(s1)
    80005704:	00275703          	lhu	a4,2(a4)
    80005708:	faf71be3          	bne	a4,a5,800056be <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000570c:	00018517          	auipc	a0,0x18
    80005710:	a1c50513          	addi	a0,a0,-1508 # 8001d128 <disk+0x2128>
    80005714:	00001097          	auipc	ra,0x1
    80005718:	b30080e7          	jalr	-1232(ra) # 80006244 <release>
}
    8000571c:	60e2                	ld	ra,24(sp)
    8000571e:	6442                	ld	s0,16(sp)
    80005720:	64a2                	ld	s1,8(sp)
    80005722:	6902                	ld	s2,0(sp)
    80005724:	6105                	addi	sp,sp,32
    80005726:	8082                	ret
      panic("virtio_disk_intr status");
    80005728:	00003517          	auipc	a0,0x3
    8000572c:	01850513          	addi	a0,a0,24 # 80008740 <etext+0x740>
    80005730:	00000097          	auipc	ra,0x0
    80005734:	524080e7          	jalr	1316(ra) # 80005c54 <panic>

0000000080005738 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005738:	1141                	addi	sp,sp,-16
    8000573a:	e422                	sd	s0,8(sp)
    8000573c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000573e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005742:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005746:	0037979b          	slliw	a5,a5,0x3
    8000574a:	02004737          	lui	a4,0x2004
    8000574e:	97ba                	add	a5,a5,a4
    80005750:	0200c737          	lui	a4,0x200c
    80005754:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005758:	000f4637          	lui	a2,0xf4
    8000575c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005760:	95b2                	add	a1,a1,a2
    80005762:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005764:	00269713          	slli	a4,a3,0x2
    80005768:	9736                	add	a4,a4,a3
    8000576a:	00371693          	slli	a3,a4,0x3
    8000576e:	00019717          	auipc	a4,0x19
    80005772:	89270713          	addi	a4,a4,-1902 # 8001e000 <timer_scratch>
    80005776:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005778:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000577a:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000577c:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005780:	00000797          	auipc	a5,0x0
    80005784:	9c078793          	addi	a5,a5,-1600 # 80005140 <timervec>
    80005788:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000578c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005790:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005794:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005798:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000579c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057a0:	30479073          	csrw	mie,a5
}
    800057a4:	6422                	ld	s0,8(sp)
    800057a6:	0141                	addi	sp,sp,16
    800057a8:	8082                	ret

00000000800057aa <start>:
{
    800057aa:	1141                	addi	sp,sp,-16
    800057ac:	e406                	sd	ra,8(sp)
    800057ae:	e022                	sd	s0,0(sp)
    800057b0:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057b2:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057b6:	7779                	lui	a4,0xffffe
    800057b8:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057bc:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057be:	6705                	lui	a4,0x1
    800057c0:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057c4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c6:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057ca:	ffffb797          	auipc	a5,0xffffb
    800057ce:	b9e78793          	addi	a5,a5,-1122 # 80000368 <main>
    800057d2:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057d6:	4781                	li	a5,0
    800057d8:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057dc:	67c1                	lui	a5,0x10
    800057de:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057e0:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057e4:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057e8:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057ec:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057f0:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057f4:	57fd                	li	a5,-1
    800057f6:	83a9                	srli	a5,a5,0xa
    800057f8:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057fc:	47bd                	li	a5,15
    800057fe:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005802:	00000097          	auipc	ra,0x0
    80005806:	f36080e7          	jalr	-202(ra) # 80005738 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000580a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000580e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005810:	823e                	mv	tp,a5
  asm volatile("mret");
    80005812:	30200073          	mret
}
    80005816:	60a2                	ld	ra,8(sp)
    80005818:	6402                	ld	s0,0(sp)
    8000581a:	0141                	addi	sp,sp,16
    8000581c:	8082                	ret

000000008000581e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000581e:	715d                	addi	sp,sp,-80
    80005820:	e486                	sd	ra,72(sp)
    80005822:	e0a2                	sd	s0,64(sp)
    80005824:	fc26                	sd	s1,56(sp)
    80005826:	f84a                	sd	s2,48(sp)
    80005828:	f44e                	sd	s3,40(sp)
    8000582a:	f052                	sd	s4,32(sp)
    8000582c:	ec56                	sd	s5,24(sp)
    8000582e:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005830:	04c05663          	blez	a2,8000587c <consolewrite+0x5e>
    80005834:	8a2a                	mv	s4,a0
    80005836:	84ae                	mv	s1,a1
    80005838:	89b2                	mv	s3,a2
    8000583a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000583c:	5afd                	li	s5,-1
    8000583e:	4685                	li	a3,1
    80005840:	8626                	mv	a2,s1
    80005842:	85d2                	mv	a1,s4
    80005844:	fbf40513          	addi	a0,s0,-65
    80005848:	ffffc097          	auipc	ra,0xffffc
    8000584c:	10a080e7          	jalr	266(ra) # 80001952 <either_copyin>
    80005850:	01550c63          	beq	a0,s5,80005868 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005854:	fbf44503          	lbu	a0,-65(s0)
    80005858:	00000097          	auipc	ra,0x0
    8000585c:	77a080e7          	jalr	1914(ra) # 80005fd2 <uartputc>
  for(i = 0; i < n; i++){
    80005860:	2905                	addiw	s2,s2,1
    80005862:	0485                	addi	s1,s1,1
    80005864:	fd299de3          	bne	s3,s2,8000583e <consolewrite+0x20>
  }

  return i;
}
    80005868:	854a                	mv	a0,s2
    8000586a:	60a6                	ld	ra,72(sp)
    8000586c:	6406                	ld	s0,64(sp)
    8000586e:	74e2                	ld	s1,56(sp)
    80005870:	7942                	ld	s2,48(sp)
    80005872:	79a2                	ld	s3,40(sp)
    80005874:	7a02                	ld	s4,32(sp)
    80005876:	6ae2                	ld	s5,24(sp)
    80005878:	6161                	addi	sp,sp,80
    8000587a:	8082                	ret
  for(i = 0; i < n; i++){
    8000587c:	4901                	li	s2,0
    8000587e:	b7ed                	j	80005868 <consolewrite+0x4a>

0000000080005880 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005880:	7159                	addi	sp,sp,-112
    80005882:	f486                	sd	ra,104(sp)
    80005884:	f0a2                	sd	s0,96(sp)
    80005886:	eca6                	sd	s1,88(sp)
    80005888:	e8ca                	sd	s2,80(sp)
    8000588a:	e4ce                	sd	s3,72(sp)
    8000588c:	e0d2                	sd	s4,64(sp)
    8000588e:	fc56                	sd	s5,56(sp)
    80005890:	f85a                	sd	s6,48(sp)
    80005892:	f45e                	sd	s7,40(sp)
    80005894:	f062                	sd	s8,32(sp)
    80005896:	ec66                	sd	s9,24(sp)
    80005898:	e86a                	sd	s10,16(sp)
    8000589a:	1880                	addi	s0,sp,112
    8000589c:	8aaa                	mv	s5,a0
    8000589e:	8a2e                	mv	s4,a1
    800058a0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058a2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058a6:	00021517          	auipc	a0,0x21
    800058aa:	89a50513          	addi	a0,a0,-1894 # 80026140 <cons>
    800058ae:	00001097          	auipc	ra,0x1
    800058b2:	8e2080e7          	jalr	-1822(ra) # 80006190 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058b6:	00021497          	auipc	s1,0x21
    800058ba:	88a48493          	addi	s1,s1,-1910 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058be:	00021917          	auipc	s2,0x21
    800058c2:	91a90913          	addi	s2,s2,-1766 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058c6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058c8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058ca:	4ca9                	li	s9,10
  while(n > 0){
    800058cc:	07305863          	blez	s3,8000593c <consoleread+0xbc>
    while(cons.r == cons.w){
    800058d0:	0984a783          	lw	a5,152(s1)
    800058d4:	09c4a703          	lw	a4,156(s1)
    800058d8:	02f71463          	bne	a4,a5,80005900 <consoleread+0x80>
      if(myproc()->killed){
    800058dc:	ffffb097          	auipc	ra,0xffffb
    800058e0:	5b0080e7          	jalr	1456(ra) # 80000e8c <myproc>
    800058e4:	551c                	lw	a5,40(a0)
    800058e6:	e7b5                	bnez	a5,80005952 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800058e8:	85a6                	mv	a1,s1
    800058ea:	854a                	mv	a0,s2
    800058ec:	ffffc097          	auipc	ra,0xffffc
    800058f0:	c6c080e7          	jalr	-916(ra) # 80001558 <sleep>
    while(cons.r == cons.w){
    800058f4:	0984a783          	lw	a5,152(s1)
    800058f8:	09c4a703          	lw	a4,156(s1)
    800058fc:	fef700e3          	beq	a4,a5,800058dc <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005900:	0017871b          	addiw	a4,a5,1
    80005904:	08e4ac23          	sw	a4,152(s1)
    80005908:	07f7f713          	andi	a4,a5,127
    8000590c:	9726                	add	a4,a4,s1
    8000590e:	01874703          	lbu	a4,24(a4)
    80005912:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005916:	077d0563          	beq	s10,s7,80005980 <consoleread+0x100>
    cbuf = c;
    8000591a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000591e:	4685                	li	a3,1
    80005920:	f9f40613          	addi	a2,s0,-97
    80005924:	85d2                	mv	a1,s4
    80005926:	8556                	mv	a0,s5
    80005928:	ffffc097          	auipc	ra,0xffffc
    8000592c:	fd4080e7          	jalr	-44(ra) # 800018fc <either_copyout>
    80005930:	01850663          	beq	a0,s8,8000593c <consoleread+0xbc>
    dst++;
    80005934:	0a05                	addi	s4,s4,1
    --n;
    80005936:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005938:	f99d1ae3          	bne	s10,s9,800058cc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000593c:	00021517          	auipc	a0,0x21
    80005940:	80450513          	addi	a0,a0,-2044 # 80026140 <cons>
    80005944:	00001097          	auipc	ra,0x1
    80005948:	900080e7          	jalr	-1792(ra) # 80006244 <release>

  return target - n;
    8000594c:	413b053b          	subw	a0,s6,s3
    80005950:	a811                	j	80005964 <consoleread+0xe4>
        release(&cons.lock);
    80005952:	00020517          	auipc	a0,0x20
    80005956:	7ee50513          	addi	a0,a0,2030 # 80026140 <cons>
    8000595a:	00001097          	auipc	ra,0x1
    8000595e:	8ea080e7          	jalr	-1814(ra) # 80006244 <release>
        return -1;
    80005962:	557d                	li	a0,-1
}
    80005964:	70a6                	ld	ra,104(sp)
    80005966:	7406                	ld	s0,96(sp)
    80005968:	64e6                	ld	s1,88(sp)
    8000596a:	6946                	ld	s2,80(sp)
    8000596c:	69a6                	ld	s3,72(sp)
    8000596e:	6a06                	ld	s4,64(sp)
    80005970:	7ae2                	ld	s5,56(sp)
    80005972:	7b42                	ld	s6,48(sp)
    80005974:	7ba2                	ld	s7,40(sp)
    80005976:	7c02                	ld	s8,32(sp)
    80005978:	6ce2                	ld	s9,24(sp)
    8000597a:	6d42                	ld	s10,16(sp)
    8000597c:	6165                	addi	sp,sp,112
    8000597e:	8082                	ret
      if(n < target){
    80005980:	0009871b          	sext.w	a4,s3
    80005984:	fb677ce3          	bgeu	a4,s6,8000593c <consoleread+0xbc>
        cons.r--;
    80005988:	00021717          	auipc	a4,0x21
    8000598c:	84f72823          	sw	a5,-1968(a4) # 800261d8 <cons+0x98>
    80005990:	b775                	j	8000593c <consoleread+0xbc>

0000000080005992 <consputc>:
{
    80005992:	1141                	addi	sp,sp,-16
    80005994:	e406                	sd	ra,8(sp)
    80005996:	e022                	sd	s0,0(sp)
    80005998:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000599a:	10000793          	li	a5,256
    8000599e:	00f50a63          	beq	a0,a5,800059b2 <consputc+0x20>
    uartputc_sync(c);
    800059a2:	00000097          	auipc	ra,0x0
    800059a6:	55e080e7          	jalr	1374(ra) # 80005f00 <uartputc_sync>
}
    800059aa:	60a2                	ld	ra,8(sp)
    800059ac:	6402                	ld	s0,0(sp)
    800059ae:	0141                	addi	sp,sp,16
    800059b0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059b2:	4521                	li	a0,8
    800059b4:	00000097          	auipc	ra,0x0
    800059b8:	54c080e7          	jalr	1356(ra) # 80005f00 <uartputc_sync>
    800059bc:	02000513          	li	a0,32
    800059c0:	00000097          	auipc	ra,0x0
    800059c4:	540080e7          	jalr	1344(ra) # 80005f00 <uartputc_sync>
    800059c8:	4521                	li	a0,8
    800059ca:	00000097          	auipc	ra,0x0
    800059ce:	536080e7          	jalr	1334(ra) # 80005f00 <uartputc_sync>
    800059d2:	bfe1                	j	800059aa <consputc+0x18>

00000000800059d4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059d4:	1101                	addi	sp,sp,-32
    800059d6:	ec06                	sd	ra,24(sp)
    800059d8:	e822                	sd	s0,16(sp)
    800059da:	e426                	sd	s1,8(sp)
    800059dc:	e04a                	sd	s2,0(sp)
    800059de:	1000                	addi	s0,sp,32
    800059e0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059e2:	00020517          	auipc	a0,0x20
    800059e6:	75e50513          	addi	a0,a0,1886 # 80026140 <cons>
    800059ea:	00000097          	auipc	ra,0x0
    800059ee:	7a6080e7          	jalr	1958(ra) # 80006190 <acquire>

  switch(c){
    800059f2:	47d5                	li	a5,21
    800059f4:	0af48663          	beq	s1,a5,80005aa0 <consoleintr+0xcc>
    800059f8:	0297ca63          	blt	a5,s1,80005a2c <consoleintr+0x58>
    800059fc:	47a1                	li	a5,8
    800059fe:	0ef48763          	beq	s1,a5,80005aec <consoleintr+0x118>
    80005a02:	47c1                	li	a5,16
    80005a04:	10f49a63          	bne	s1,a5,80005b18 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a08:	ffffc097          	auipc	ra,0xffffc
    80005a0c:	fa0080e7          	jalr	-96(ra) # 800019a8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a10:	00020517          	auipc	a0,0x20
    80005a14:	73050513          	addi	a0,a0,1840 # 80026140 <cons>
    80005a18:	00001097          	auipc	ra,0x1
    80005a1c:	82c080e7          	jalr	-2004(ra) # 80006244 <release>
}
    80005a20:	60e2                	ld	ra,24(sp)
    80005a22:	6442                	ld	s0,16(sp)
    80005a24:	64a2                	ld	s1,8(sp)
    80005a26:	6902                	ld	s2,0(sp)
    80005a28:	6105                	addi	sp,sp,32
    80005a2a:	8082                	ret
  switch(c){
    80005a2c:	07f00793          	li	a5,127
    80005a30:	0af48e63          	beq	s1,a5,80005aec <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a34:	00020717          	auipc	a4,0x20
    80005a38:	70c70713          	addi	a4,a4,1804 # 80026140 <cons>
    80005a3c:	0a072783          	lw	a5,160(a4)
    80005a40:	09872703          	lw	a4,152(a4)
    80005a44:	9f99                	subw	a5,a5,a4
    80005a46:	07f00713          	li	a4,127
    80005a4a:	fcf763e3          	bltu	a4,a5,80005a10 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a4e:	47b5                	li	a5,13
    80005a50:	0cf48763          	beq	s1,a5,80005b1e <consoleintr+0x14a>
      consputc(c);
    80005a54:	8526                	mv	a0,s1
    80005a56:	00000097          	auipc	ra,0x0
    80005a5a:	f3c080e7          	jalr	-196(ra) # 80005992 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a5e:	00020797          	auipc	a5,0x20
    80005a62:	6e278793          	addi	a5,a5,1762 # 80026140 <cons>
    80005a66:	0a07a703          	lw	a4,160(a5)
    80005a6a:	0017069b          	addiw	a3,a4,1
    80005a6e:	0006861b          	sext.w	a2,a3
    80005a72:	0ad7a023          	sw	a3,160(a5)
    80005a76:	07f77713          	andi	a4,a4,127
    80005a7a:	97ba                	add	a5,a5,a4
    80005a7c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a80:	47a9                	li	a5,10
    80005a82:	0cf48563          	beq	s1,a5,80005b4c <consoleintr+0x178>
    80005a86:	4791                	li	a5,4
    80005a88:	0cf48263          	beq	s1,a5,80005b4c <consoleintr+0x178>
    80005a8c:	00020797          	auipc	a5,0x20
    80005a90:	74c7a783          	lw	a5,1868(a5) # 800261d8 <cons+0x98>
    80005a94:	0807879b          	addiw	a5,a5,128
    80005a98:	f6f61ce3          	bne	a2,a5,80005a10 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a9c:	863e                	mv	a2,a5
    80005a9e:	a07d                	j	80005b4c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aa0:	00020717          	auipc	a4,0x20
    80005aa4:	6a070713          	addi	a4,a4,1696 # 80026140 <cons>
    80005aa8:	0a072783          	lw	a5,160(a4)
    80005aac:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ab0:	00020497          	auipc	s1,0x20
    80005ab4:	69048493          	addi	s1,s1,1680 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005ab8:	4929                	li	s2,10
    80005aba:	f4f70be3          	beq	a4,a5,80005a10 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005abe:	37fd                	addiw	a5,a5,-1
    80005ac0:	07f7f713          	andi	a4,a5,127
    80005ac4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ac6:	01874703          	lbu	a4,24(a4)
    80005aca:	f52703e3          	beq	a4,s2,80005a10 <consoleintr+0x3c>
      cons.e--;
    80005ace:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ad2:	10000513          	li	a0,256
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	ebc080e7          	jalr	-324(ra) # 80005992 <consputc>
    while(cons.e != cons.w &&
    80005ade:	0a04a783          	lw	a5,160(s1)
    80005ae2:	09c4a703          	lw	a4,156(s1)
    80005ae6:	fcf71ce3          	bne	a4,a5,80005abe <consoleintr+0xea>
    80005aea:	b71d                	j	80005a10 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005aec:	00020717          	auipc	a4,0x20
    80005af0:	65470713          	addi	a4,a4,1620 # 80026140 <cons>
    80005af4:	0a072783          	lw	a5,160(a4)
    80005af8:	09c72703          	lw	a4,156(a4)
    80005afc:	f0f70ae3          	beq	a4,a5,80005a10 <consoleintr+0x3c>
      cons.e--;
    80005b00:	37fd                	addiw	a5,a5,-1
    80005b02:	00020717          	auipc	a4,0x20
    80005b06:	6cf72f23          	sw	a5,1758(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b0a:	10000513          	li	a0,256
    80005b0e:	00000097          	auipc	ra,0x0
    80005b12:	e84080e7          	jalr	-380(ra) # 80005992 <consputc>
    80005b16:	bded                	j	80005a10 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b18:	ee048ce3          	beqz	s1,80005a10 <consoleintr+0x3c>
    80005b1c:	bf21                	j	80005a34 <consoleintr+0x60>
      consputc(c);
    80005b1e:	4529                	li	a0,10
    80005b20:	00000097          	auipc	ra,0x0
    80005b24:	e72080e7          	jalr	-398(ra) # 80005992 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b28:	00020797          	auipc	a5,0x20
    80005b2c:	61878793          	addi	a5,a5,1560 # 80026140 <cons>
    80005b30:	0a07a703          	lw	a4,160(a5)
    80005b34:	0017069b          	addiw	a3,a4,1
    80005b38:	0006861b          	sext.w	a2,a3
    80005b3c:	0ad7a023          	sw	a3,160(a5)
    80005b40:	07f77713          	andi	a4,a4,127
    80005b44:	97ba                	add	a5,a5,a4
    80005b46:	4729                	li	a4,10
    80005b48:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b4c:	00020797          	auipc	a5,0x20
    80005b50:	68c7a823          	sw	a2,1680(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b54:	00020517          	auipc	a0,0x20
    80005b58:	68450513          	addi	a0,a0,1668 # 800261d8 <cons+0x98>
    80005b5c:	ffffc097          	auipc	ra,0xffffc
    80005b60:	b88080e7          	jalr	-1144(ra) # 800016e4 <wakeup>
    80005b64:	b575                	j	80005a10 <consoleintr+0x3c>

0000000080005b66 <consoleinit>:

void
consoleinit(void)
{
    80005b66:	1141                	addi	sp,sp,-16
    80005b68:	e406                	sd	ra,8(sp)
    80005b6a:	e022                	sd	s0,0(sp)
    80005b6c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b6e:	00003597          	auipc	a1,0x3
    80005b72:	bea58593          	addi	a1,a1,-1046 # 80008758 <etext+0x758>
    80005b76:	00020517          	auipc	a0,0x20
    80005b7a:	5ca50513          	addi	a0,a0,1482 # 80026140 <cons>
    80005b7e:	00000097          	auipc	ra,0x0
    80005b82:	582080e7          	jalr	1410(ra) # 80006100 <initlock>

  uartinit();
    80005b86:	00000097          	auipc	ra,0x0
    80005b8a:	32a080e7          	jalr	810(ra) # 80005eb0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b8e:	00013797          	auipc	a5,0x13
    80005b92:	73a78793          	addi	a5,a5,1850 # 800192c8 <devsw>
    80005b96:	00000717          	auipc	a4,0x0
    80005b9a:	cea70713          	addi	a4,a4,-790 # 80005880 <consoleread>
    80005b9e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ba0:	00000717          	auipc	a4,0x0
    80005ba4:	c7e70713          	addi	a4,a4,-898 # 8000581e <consolewrite>
    80005ba8:	ef98                	sd	a4,24(a5)
}
    80005baa:	60a2                	ld	ra,8(sp)
    80005bac:	6402                	ld	s0,0(sp)
    80005bae:	0141                	addi	sp,sp,16
    80005bb0:	8082                	ret

0000000080005bb2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bb2:	7179                	addi	sp,sp,-48
    80005bb4:	f406                	sd	ra,40(sp)
    80005bb6:	f022                	sd	s0,32(sp)
    80005bb8:	ec26                	sd	s1,24(sp)
    80005bba:	e84a                	sd	s2,16(sp)
    80005bbc:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bbe:	c219                	beqz	a2,80005bc4 <printint+0x12>
    80005bc0:	08054663          	bltz	a0,80005c4c <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bc4:	2501                	sext.w	a0,a0
    80005bc6:	4881                	li	a7,0
    80005bc8:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bcc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bce:	2581                	sext.w	a1,a1
    80005bd0:	00003617          	auipc	a2,0x3
    80005bd4:	cf860613          	addi	a2,a2,-776 # 800088c8 <digits>
    80005bd8:	883a                	mv	a6,a4
    80005bda:	2705                	addiw	a4,a4,1
    80005bdc:	02b577bb          	remuw	a5,a0,a1
    80005be0:	1782                	slli	a5,a5,0x20
    80005be2:	9381                	srli	a5,a5,0x20
    80005be4:	97b2                	add	a5,a5,a2
    80005be6:	0007c783          	lbu	a5,0(a5)
    80005bea:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bee:	0005079b          	sext.w	a5,a0
    80005bf2:	02b5553b          	divuw	a0,a0,a1
    80005bf6:	0685                	addi	a3,a3,1
    80005bf8:	feb7f0e3          	bgeu	a5,a1,80005bd8 <printint+0x26>

  if(sign)
    80005bfc:	00088b63          	beqz	a7,80005c12 <printint+0x60>
    buf[i++] = '-';
    80005c00:	fe040793          	addi	a5,s0,-32
    80005c04:	973e                	add	a4,a4,a5
    80005c06:	02d00793          	li	a5,45
    80005c0a:	fef70823          	sb	a5,-16(a4)
    80005c0e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c12:	02e05763          	blez	a4,80005c40 <printint+0x8e>
    80005c16:	fd040793          	addi	a5,s0,-48
    80005c1a:	00e784b3          	add	s1,a5,a4
    80005c1e:	fff78913          	addi	s2,a5,-1
    80005c22:	993a                	add	s2,s2,a4
    80005c24:	377d                	addiw	a4,a4,-1
    80005c26:	1702                	slli	a4,a4,0x20
    80005c28:	9301                	srli	a4,a4,0x20
    80005c2a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c2e:	fff4c503          	lbu	a0,-1(s1)
    80005c32:	00000097          	auipc	ra,0x0
    80005c36:	d60080e7          	jalr	-672(ra) # 80005992 <consputc>
  while(--i >= 0)
    80005c3a:	14fd                	addi	s1,s1,-1
    80005c3c:	ff2499e3          	bne	s1,s2,80005c2e <printint+0x7c>
}
    80005c40:	70a2                	ld	ra,40(sp)
    80005c42:	7402                	ld	s0,32(sp)
    80005c44:	64e2                	ld	s1,24(sp)
    80005c46:	6942                	ld	s2,16(sp)
    80005c48:	6145                	addi	sp,sp,48
    80005c4a:	8082                	ret
    x = -xx;
    80005c4c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c50:	4885                	li	a7,1
    x = -xx;
    80005c52:	bf9d                	j	80005bc8 <printint+0x16>

0000000080005c54 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c54:	1101                	addi	sp,sp,-32
    80005c56:	ec06                	sd	ra,24(sp)
    80005c58:	e822                	sd	s0,16(sp)
    80005c5a:	e426                	sd	s1,8(sp)
    80005c5c:	1000                	addi	s0,sp,32
    80005c5e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c60:	00020797          	auipc	a5,0x20
    80005c64:	5a07a023          	sw	zero,1440(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c68:	00003517          	auipc	a0,0x3
    80005c6c:	af850513          	addi	a0,a0,-1288 # 80008760 <etext+0x760>
    80005c70:	00000097          	auipc	ra,0x0
    80005c74:	02e080e7          	jalr	46(ra) # 80005c9e <printf>
  printf(s);
    80005c78:	8526                	mv	a0,s1
    80005c7a:	00000097          	auipc	ra,0x0
    80005c7e:	024080e7          	jalr	36(ra) # 80005c9e <printf>
  printf("\n");
    80005c82:	00002517          	auipc	a0,0x2
    80005c86:	3c650513          	addi	a0,a0,966 # 80008048 <etext+0x48>
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	014080e7          	jalr	20(ra) # 80005c9e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c92:	4785                	li	a5,1
    80005c94:	00003717          	auipc	a4,0x3
    80005c98:	38f72423          	sw	a5,904(a4) # 8000901c <panicked>
  for(;;)
    80005c9c:	a001                	j	80005c9c <panic+0x48>

0000000080005c9e <printf>:
{
    80005c9e:	7131                	addi	sp,sp,-192
    80005ca0:	fc86                	sd	ra,120(sp)
    80005ca2:	f8a2                	sd	s0,112(sp)
    80005ca4:	f4a6                	sd	s1,104(sp)
    80005ca6:	f0ca                	sd	s2,96(sp)
    80005ca8:	ecce                	sd	s3,88(sp)
    80005caa:	e8d2                	sd	s4,80(sp)
    80005cac:	e4d6                	sd	s5,72(sp)
    80005cae:	e0da                	sd	s6,64(sp)
    80005cb0:	fc5e                	sd	s7,56(sp)
    80005cb2:	f862                	sd	s8,48(sp)
    80005cb4:	f466                	sd	s9,40(sp)
    80005cb6:	f06a                	sd	s10,32(sp)
    80005cb8:	ec6e                	sd	s11,24(sp)
    80005cba:	0100                	addi	s0,sp,128
    80005cbc:	8a2a                	mv	s4,a0
    80005cbe:	e40c                	sd	a1,8(s0)
    80005cc0:	e810                	sd	a2,16(s0)
    80005cc2:	ec14                	sd	a3,24(s0)
    80005cc4:	f018                	sd	a4,32(s0)
    80005cc6:	f41c                	sd	a5,40(s0)
    80005cc8:	03043823          	sd	a6,48(s0)
    80005ccc:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cd0:	00020d97          	auipc	s11,0x20
    80005cd4:	530dad83          	lw	s11,1328(s11) # 80026200 <pr+0x18>
  if(locking)
    80005cd8:	020d9b63          	bnez	s11,80005d0e <printf+0x70>
  if (fmt == 0)
    80005cdc:	040a0263          	beqz	s4,80005d20 <printf+0x82>
  va_start(ap, fmt);
    80005ce0:	00840793          	addi	a5,s0,8
    80005ce4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ce8:	000a4503          	lbu	a0,0(s4)
    80005cec:	14050f63          	beqz	a0,80005e4a <printf+0x1ac>
    80005cf0:	4981                	li	s3,0
    if(c != '%'){
    80005cf2:	02500a93          	li	s5,37
    switch(c){
    80005cf6:	07000b93          	li	s7,112
  consputc('x');
    80005cfa:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cfc:	00003b17          	auipc	s6,0x3
    80005d00:	bccb0b13          	addi	s6,s6,-1076 # 800088c8 <digits>
    switch(c){
    80005d04:	07300c93          	li	s9,115
    80005d08:	06400c13          	li	s8,100
    80005d0c:	a82d                	j	80005d46 <printf+0xa8>
    acquire(&pr.lock);
    80005d0e:	00020517          	auipc	a0,0x20
    80005d12:	4da50513          	addi	a0,a0,1242 # 800261e8 <pr>
    80005d16:	00000097          	auipc	ra,0x0
    80005d1a:	47a080e7          	jalr	1146(ra) # 80006190 <acquire>
    80005d1e:	bf7d                	j	80005cdc <printf+0x3e>
    panic("null fmt");
    80005d20:	00003517          	auipc	a0,0x3
    80005d24:	a5050513          	addi	a0,a0,-1456 # 80008770 <etext+0x770>
    80005d28:	00000097          	auipc	ra,0x0
    80005d2c:	f2c080e7          	jalr	-212(ra) # 80005c54 <panic>
      consputc(c);
    80005d30:	00000097          	auipc	ra,0x0
    80005d34:	c62080e7          	jalr	-926(ra) # 80005992 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d38:	2985                	addiw	s3,s3,1
    80005d3a:	013a07b3          	add	a5,s4,s3
    80005d3e:	0007c503          	lbu	a0,0(a5)
    80005d42:	10050463          	beqz	a0,80005e4a <printf+0x1ac>
    if(c != '%'){
    80005d46:	ff5515e3          	bne	a0,s5,80005d30 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d4a:	2985                	addiw	s3,s3,1
    80005d4c:	013a07b3          	add	a5,s4,s3
    80005d50:	0007c783          	lbu	a5,0(a5)
    80005d54:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d58:	cbed                	beqz	a5,80005e4a <printf+0x1ac>
    switch(c){
    80005d5a:	05778a63          	beq	a5,s7,80005dae <printf+0x110>
    80005d5e:	02fbf663          	bgeu	s7,a5,80005d8a <printf+0xec>
    80005d62:	09978863          	beq	a5,s9,80005df2 <printf+0x154>
    80005d66:	07800713          	li	a4,120
    80005d6a:	0ce79563          	bne	a5,a4,80005e34 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d6e:	f8843783          	ld	a5,-120(s0)
    80005d72:	00878713          	addi	a4,a5,8
    80005d76:	f8e43423          	sd	a4,-120(s0)
    80005d7a:	4605                	li	a2,1
    80005d7c:	85ea                	mv	a1,s10
    80005d7e:	4388                	lw	a0,0(a5)
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	e32080e7          	jalr	-462(ra) # 80005bb2 <printint>
      break;
    80005d88:	bf45                	j	80005d38 <printf+0x9a>
    switch(c){
    80005d8a:	09578f63          	beq	a5,s5,80005e28 <printf+0x18a>
    80005d8e:	0b879363          	bne	a5,s8,80005e34 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d92:	f8843783          	ld	a5,-120(s0)
    80005d96:	00878713          	addi	a4,a5,8
    80005d9a:	f8e43423          	sd	a4,-120(s0)
    80005d9e:	4605                	li	a2,1
    80005da0:	45a9                	li	a1,10
    80005da2:	4388                	lw	a0,0(a5)
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	e0e080e7          	jalr	-498(ra) # 80005bb2 <printint>
      break;
    80005dac:	b771                	j	80005d38 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dae:	f8843783          	ld	a5,-120(s0)
    80005db2:	00878713          	addi	a4,a5,8
    80005db6:	f8e43423          	sd	a4,-120(s0)
    80005dba:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005dbe:	03000513          	li	a0,48
    80005dc2:	00000097          	auipc	ra,0x0
    80005dc6:	bd0080e7          	jalr	-1072(ra) # 80005992 <consputc>
  consputc('x');
    80005dca:	07800513          	li	a0,120
    80005dce:	00000097          	auipc	ra,0x0
    80005dd2:	bc4080e7          	jalr	-1084(ra) # 80005992 <consputc>
    80005dd6:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dd8:	03c95793          	srli	a5,s2,0x3c
    80005ddc:	97da                	add	a5,a5,s6
    80005dde:	0007c503          	lbu	a0,0(a5)
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	bb0080e7          	jalr	-1104(ra) # 80005992 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dea:	0912                	slli	s2,s2,0x4
    80005dec:	34fd                	addiw	s1,s1,-1
    80005dee:	f4ed                	bnez	s1,80005dd8 <printf+0x13a>
    80005df0:	b7a1                	j	80005d38 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005df2:	f8843783          	ld	a5,-120(s0)
    80005df6:	00878713          	addi	a4,a5,8
    80005dfa:	f8e43423          	sd	a4,-120(s0)
    80005dfe:	6384                	ld	s1,0(a5)
    80005e00:	cc89                	beqz	s1,80005e1a <printf+0x17c>
      for(; *s; s++)
    80005e02:	0004c503          	lbu	a0,0(s1)
    80005e06:	d90d                	beqz	a0,80005d38 <printf+0x9a>
        consputc(*s);
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	b8a080e7          	jalr	-1142(ra) # 80005992 <consputc>
      for(; *s; s++)
    80005e10:	0485                	addi	s1,s1,1
    80005e12:	0004c503          	lbu	a0,0(s1)
    80005e16:	f96d                	bnez	a0,80005e08 <printf+0x16a>
    80005e18:	b705                	j	80005d38 <printf+0x9a>
        s = "(null)";
    80005e1a:	00003497          	auipc	s1,0x3
    80005e1e:	94e48493          	addi	s1,s1,-1714 # 80008768 <etext+0x768>
      for(; *s; s++)
    80005e22:	02800513          	li	a0,40
    80005e26:	b7cd                	j	80005e08 <printf+0x16a>
      consputc('%');
    80005e28:	8556                	mv	a0,s5
    80005e2a:	00000097          	auipc	ra,0x0
    80005e2e:	b68080e7          	jalr	-1176(ra) # 80005992 <consputc>
      break;
    80005e32:	b719                	j	80005d38 <printf+0x9a>
      consputc('%');
    80005e34:	8556                	mv	a0,s5
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	b5c080e7          	jalr	-1188(ra) # 80005992 <consputc>
      consputc(c);
    80005e3e:	8526                	mv	a0,s1
    80005e40:	00000097          	auipc	ra,0x0
    80005e44:	b52080e7          	jalr	-1198(ra) # 80005992 <consputc>
      break;
    80005e48:	bdc5                	j	80005d38 <printf+0x9a>
  if(locking)
    80005e4a:	020d9163          	bnez	s11,80005e6c <printf+0x1ce>
}
    80005e4e:	70e6                	ld	ra,120(sp)
    80005e50:	7446                	ld	s0,112(sp)
    80005e52:	74a6                	ld	s1,104(sp)
    80005e54:	7906                	ld	s2,96(sp)
    80005e56:	69e6                	ld	s3,88(sp)
    80005e58:	6a46                	ld	s4,80(sp)
    80005e5a:	6aa6                	ld	s5,72(sp)
    80005e5c:	6b06                	ld	s6,64(sp)
    80005e5e:	7be2                	ld	s7,56(sp)
    80005e60:	7c42                	ld	s8,48(sp)
    80005e62:	7ca2                	ld	s9,40(sp)
    80005e64:	7d02                	ld	s10,32(sp)
    80005e66:	6de2                	ld	s11,24(sp)
    80005e68:	6129                	addi	sp,sp,192
    80005e6a:	8082                	ret
    release(&pr.lock);
    80005e6c:	00020517          	auipc	a0,0x20
    80005e70:	37c50513          	addi	a0,a0,892 # 800261e8 <pr>
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	3d0080e7          	jalr	976(ra) # 80006244 <release>
}
    80005e7c:	bfc9                	j	80005e4e <printf+0x1b0>

0000000080005e7e <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e7e:	1101                	addi	sp,sp,-32
    80005e80:	ec06                	sd	ra,24(sp)
    80005e82:	e822                	sd	s0,16(sp)
    80005e84:	e426                	sd	s1,8(sp)
    80005e86:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e88:	00020497          	auipc	s1,0x20
    80005e8c:	36048493          	addi	s1,s1,864 # 800261e8 <pr>
    80005e90:	00003597          	auipc	a1,0x3
    80005e94:	8f058593          	addi	a1,a1,-1808 # 80008780 <etext+0x780>
    80005e98:	8526                	mv	a0,s1
    80005e9a:	00000097          	auipc	ra,0x0
    80005e9e:	266080e7          	jalr	614(ra) # 80006100 <initlock>
  pr.locking = 1;
    80005ea2:	4785                	li	a5,1
    80005ea4:	cc9c                	sw	a5,24(s1)
}
    80005ea6:	60e2                	ld	ra,24(sp)
    80005ea8:	6442                	ld	s0,16(sp)
    80005eaa:	64a2                	ld	s1,8(sp)
    80005eac:	6105                	addi	sp,sp,32
    80005eae:	8082                	ret

0000000080005eb0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005eb0:	1141                	addi	sp,sp,-16
    80005eb2:	e406                	sd	ra,8(sp)
    80005eb4:	e022                	sd	s0,0(sp)
    80005eb6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005eb8:	100007b7          	lui	a5,0x10000
    80005ebc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ec0:	f8000713          	li	a4,-128
    80005ec4:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ec8:	470d                	li	a4,3
    80005eca:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ece:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ed2:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ed6:	469d                	li	a3,7
    80005ed8:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005edc:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ee0:	00003597          	auipc	a1,0x3
    80005ee4:	8a858593          	addi	a1,a1,-1880 # 80008788 <etext+0x788>
    80005ee8:	00020517          	auipc	a0,0x20
    80005eec:	32050513          	addi	a0,a0,800 # 80026208 <uart_tx_lock>
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	210080e7          	jalr	528(ra) # 80006100 <initlock>
}
    80005ef8:	60a2                	ld	ra,8(sp)
    80005efa:	6402                	ld	s0,0(sp)
    80005efc:	0141                	addi	sp,sp,16
    80005efe:	8082                	ret

0000000080005f00 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f00:	1101                	addi	sp,sp,-32
    80005f02:	ec06                	sd	ra,24(sp)
    80005f04:	e822                	sd	s0,16(sp)
    80005f06:	e426                	sd	s1,8(sp)
    80005f08:	1000                	addi	s0,sp,32
    80005f0a:	84aa                	mv	s1,a0
  push_off();
    80005f0c:	00000097          	auipc	ra,0x0
    80005f10:	238080e7          	jalr	568(ra) # 80006144 <push_off>

  if(panicked){
    80005f14:	00003797          	auipc	a5,0x3
    80005f18:	1087a783          	lw	a5,264(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f1c:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f20:	c391                	beqz	a5,80005f24 <uartputc_sync+0x24>
    for(;;)
    80005f22:	a001                	j	80005f22 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f24:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f28:	0207f793          	andi	a5,a5,32
    80005f2c:	dfe5                	beqz	a5,80005f24 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f2e:	0ff4f513          	zext.b	a0,s1
    80005f32:	100007b7          	lui	a5,0x10000
    80005f36:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	2aa080e7          	jalr	682(ra) # 800061e4 <pop_off>
}
    80005f42:	60e2                	ld	ra,24(sp)
    80005f44:	6442                	ld	s0,16(sp)
    80005f46:	64a2                	ld	s1,8(sp)
    80005f48:	6105                	addi	sp,sp,32
    80005f4a:	8082                	ret

0000000080005f4c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f4c:	00003797          	auipc	a5,0x3
    80005f50:	0d47b783          	ld	a5,212(a5) # 80009020 <uart_tx_r>
    80005f54:	00003717          	auipc	a4,0x3
    80005f58:	0d473703          	ld	a4,212(a4) # 80009028 <uart_tx_w>
    80005f5c:	06f70a63          	beq	a4,a5,80005fd0 <uartstart+0x84>
{
    80005f60:	7139                	addi	sp,sp,-64
    80005f62:	fc06                	sd	ra,56(sp)
    80005f64:	f822                	sd	s0,48(sp)
    80005f66:	f426                	sd	s1,40(sp)
    80005f68:	f04a                	sd	s2,32(sp)
    80005f6a:	ec4e                	sd	s3,24(sp)
    80005f6c:	e852                	sd	s4,16(sp)
    80005f6e:	e456                	sd	s5,8(sp)
    80005f70:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f72:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f76:	00020a17          	auipc	s4,0x20
    80005f7a:	292a0a13          	addi	s4,s4,658 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f7e:	00003497          	auipc	s1,0x3
    80005f82:	0a248493          	addi	s1,s1,162 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f86:	00003997          	auipc	s3,0x3
    80005f8a:	0a298993          	addi	s3,s3,162 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f8e:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f92:	02077713          	andi	a4,a4,32
    80005f96:	c705                	beqz	a4,80005fbe <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f98:	01f7f713          	andi	a4,a5,31
    80005f9c:	9752                	add	a4,a4,s4
    80005f9e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fa2:	0785                	addi	a5,a5,1
    80005fa4:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fa6:	8526                	mv	a0,s1
    80005fa8:	ffffb097          	auipc	ra,0xffffb
    80005fac:	73c080e7          	jalr	1852(ra) # 800016e4 <wakeup>
    
    WriteReg(THR, c);
    80005fb0:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fb4:	609c                	ld	a5,0(s1)
    80005fb6:	0009b703          	ld	a4,0(s3)
    80005fba:	fcf71ae3          	bne	a4,a5,80005f8e <uartstart+0x42>
  }
}
    80005fbe:	70e2                	ld	ra,56(sp)
    80005fc0:	7442                	ld	s0,48(sp)
    80005fc2:	74a2                	ld	s1,40(sp)
    80005fc4:	7902                	ld	s2,32(sp)
    80005fc6:	69e2                	ld	s3,24(sp)
    80005fc8:	6a42                	ld	s4,16(sp)
    80005fca:	6aa2                	ld	s5,8(sp)
    80005fcc:	6121                	addi	sp,sp,64
    80005fce:	8082                	ret
    80005fd0:	8082                	ret

0000000080005fd2 <uartputc>:
{
    80005fd2:	7179                	addi	sp,sp,-48
    80005fd4:	f406                	sd	ra,40(sp)
    80005fd6:	f022                	sd	s0,32(sp)
    80005fd8:	ec26                	sd	s1,24(sp)
    80005fda:	e84a                	sd	s2,16(sp)
    80005fdc:	e44e                	sd	s3,8(sp)
    80005fde:	e052                	sd	s4,0(sp)
    80005fe0:	1800                	addi	s0,sp,48
    80005fe2:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005fe4:	00020517          	auipc	a0,0x20
    80005fe8:	22450513          	addi	a0,a0,548 # 80026208 <uart_tx_lock>
    80005fec:	00000097          	auipc	ra,0x0
    80005ff0:	1a4080e7          	jalr	420(ra) # 80006190 <acquire>
  if(panicked){
    80005ff4:	00003797          	auipc	a5,0x3
    80005ff8:	0287a783          	lw	a5,40(a5) # 8000901c <panicked>
    80005ffc:	c391                	beqz	a5,80006000 <uartputc+0x2e>
    for(;;)
    80005ffe:	a001                	j	80005ffe <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006000:	00003717          	auipc	a4,0x3
    80006004:	02873703          	ld	a4,40(a4) # 80009028 <uart_tx_w>
    80006008:	00003797          	auipc	a5,0x3
    8000600c:	0187b783          	ld	a5,24(a5) # 80009020 <uart_tx_r>
    80006010:	02078793          	addi	a5,a5,32
    80006014:	02e79b63          	bne	a5,a4,8000604a <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006018:	00020997          	auipc	s3,0x20
    8000601c:	1f098993          	addi	s3,s3,496 # 80026208 <uart_tx_lock>
    80006020:	00003497          	auipc	s1,0x3
    80006024:	00048493          	mv	s1,s1
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006028:	00003917          	auipc	s2,0x3
    8000602c:	00090913          	mv	s2,s2
      sleep(&uart_tx_r, &uart_tx_lock);
    80006030:	85ce                	mv	a1,s3
    80006032:	8526                	mv	a0,s1
    80006034:	ffffb097          	auipc	ra,0xffffb
    80006038:	524080e7          	jalr	1316(ra) # 80001558 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000603c:	00093703          	ld	a4,0(s2) # 80009028 <uart_tx_w>
    80006040:	609c                	ld	a5,0(s1)
    80006042:	02078793          	addi	a5,a5,32
    80006046:	fee785e3          	beq	a5,a4,80006030 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000604a:	00020497          	auipc	s1,0x20
    8000604e:	1be48493          	addi	s1,s1,446 # 80026208 <uart_tx_lock>
    80006052:	01f77793          	andi	a5,a4,31
    80006056:	97a6                	add	a5,a5,s1
    80006058:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000605c:	0705                	addi	a4,a4,1
    8000605e:	00003797          	auipc	a5,0x3
    80006062:	fce7b523          	sd	a4,-54(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006066:	00000097          	auipc	ra,0x0
    8000606a:	ee6080e7          	jalr	-282(ra) # 80005f4c <uartstart>
      release(&uart_tx_lock);
    8000606e:	8526                	mv	a0,s1
    80006070:	00000097          	auipc	ra,0x0
    80006074:	1d4080e7          	jalr	468(ra) # 80006244 <release>
}
    80006078:	70a2                	ld	ra,40(sp)
    8000607a:	7402                	ld	s0,32(sp)
    8000607c:	64e2                	ld	s1,24(sp)
    8000607e:	6942                	ld	s2,16(sp)
    80006080:	69a2                	ld	s3,8(sp)
    80006082:	6a02                	ld	s4,0(sp)
    80006084:	6145                	addi	sp,sp,48
    80006086:	8082                	ret

0000000080006088 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006088:	1141                	addi	sp,sp,-16
    8000608a:	e422                	sd	s0,8(sp)
    8000608c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000608e:	100007b7          	lui	a5,0x10000
    80006092:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006096:	8b85                	andi	a5,a5,1
    80006098:	cb91                	beqz	a5,800060ac <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000609a:	100007b7          	lui	a5,0x10000
    8000609e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060a2:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
    800060a6:	6422                	ld	s0,8(sp)
    800060a8:	0141                	addi	sp,sp,16
    800060aa:	8082                	ret
    return -1;
    800060ac:	557d                	li	a0,-1
    800060ae:	bfe5                	j	800060a6 <uartgetc+0x1e>

00000000800060b0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060b0:	1101                	addi	sp,sp,-32
    800060b2:	ec06                	sd	ra,24(sp)
    800060b4:	e822                	sd	s0,16(sp)
    800060b6:	e426                	sd	s1,8(sp)
    800060b8:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060ba:	54fd                	li	s1,-1
    800060bc:	a029                	j	800060c6 <uartintr+0x16>
      break;
    consoleintr(c);
    800060be:	00000097          	auipc	ra,0x0
    800060c2:	916080e7          	jalr	-1770(ra) # 800059d4 <consoleintr>
    int c = uartgetc();
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	fc2080e7          	jalr	-62(ra) # 80006088 <uartgetc>
    if(c == -1)
    800060ce:	fe9518e3          	bne	a0,s1,800060be <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060d2:	00020497          	auipc	s1,0x20
    800060d6:	13648493          	addi	s1,s1,310 # 80026208 <uart_tx_lock>
    800060da:	8526                	mv	a0,s1
    800060dc:	00000097          	auipc	ra,0x0
    800060e0:	0b4080e7          	jalr	180(ra) # 80006190 <acquire>
  uartstart();
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	e68080e7          	jalr	-408(ra) # 80005f4c <uartstart>
  release(&uart_tx_lock);
    800060ec:	8526                	mv	a0,s1
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	156080e7          	jalr	342(ra) # 80006244 <release>
}
    800060f6:	60e2                	ld	ra,24(sp)
    800060f8:	6442                	ld	s0,16(sp)
    800060fa:	64a2                	ld	s1,8(sp)
    800060fc:	6105                	addi	sp,sp,32
    800060fe:	8082                	ret

0000000080006100 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006100:	1141                	addi	sp,sp,-16
    80006102:	e422                	sd	s0,8(sp)
    80006104:	0800                	addi	s0,sp,16
  lk->name = name;
    80006106:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006108:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000610c:	00053823          	sd	zero,16(a0)
}
    80006110:	6422                	ld	s0,8(sp)
    80006112:	0141                	addi	sp,sp,16
    80006114:	8082                	ret

0000000080006116 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006116:	411c                	lw	a5,0(a0)
    80006118:	e399                	bnez	a5,8000611e <holding+0x8>
    8000611a:	4501                	li	a0,0
  return r;
}
    8000611c:	8082                	ret
{
    8000611e:	1101                	addi	sp,sp,-32
    80006120:	ec06                	sd	ra,24(sp)
    80006122:	e822                	sd	s0,16(sp)
    80006124:	e426                	sd	s1,8(sp)
    80006126:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006128:	6904                	ld	s1,16(a0)
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	d46080e7          	jalr	-698(ra) # 80000e70 <mycpu>
    80006132:	40a48533          	sub	a0,s1,a0
    80006136:	00153513          	seqz	a0,a0
}
    8000613a:	60e2                	ld	ra,24(sp)
    8000613c:	6442                	ld	s0,16(sp)
    8000613e:	64a2                	ld	s1,8(sp)
    80006140:	6105                	addi	sp,sp,32
    80006142:	8082                	ret

0000000080006144 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006144:	1101                	addi	sp,sp,-32
    80006146:	ec06                	sd	ra,24(sp)
    80006148:	e822                	sd	s0,16(sp)
    8000614a:	e426                	sd	s1,8(sp)
    8000614c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000614e:	100024f3          	csrr	s1,sstatus
    80006152:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006156:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006158:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000615c:	ffffb097          	auipc	ra,0xffffb
    80006160:	d14080e7          	jalr	-748(ra) # 80000e70 <mycpu>
    80006164:	5d3c                	lw	a5,120(a0)
    80006166:	cf89                	beqz	a5,80006180 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006168:	ffffb097          	auipc	ra,0xffffb
    8000616c:	d08080e7          	jalr	-760(ra) # 80000e70 <mycpu>
    80006170:	5d3c                	lw	a5,120(a0)
    80006172:	2785                	addiw	a5,a5,1
    80006174:	dd3c                	sw	a5,120(a0)
}
    80006176:	60e2                	ld	ra,24(sp)
    80006178:	6442                	ld	s0,16(sp)
    8000617a:	64a2                	ld	s1,8(sp)
    8000617c:	6105                	addi	sp,sp,32
    8000617e:	8082                	ret
    mycpu()->intena = old;
    80006180:	ffffb097          	auipc	ra,0xffffb
    80006184:	cf0080e7          	jalr	-784(ra) # 80000e70 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006188:	8085                	srli	s1,s1,0x1
    8000618a:	8885                	andi	s1,s1,1
    8000618c:	dd64                	sw	s1,124(a0)
    8000618e:	bfe9                	j	80006168 <push_off+0x24>

0000000080006190 <acquire>:
{
    80006190:	1101                	addi	sp,sp,-32
    80006192:	ec06                	sd	ra,24(sp)
    80006194:	e822                	sd	s0,16(sp)
    80006196:	e426                	sd	s1,8(sp)
    80006198:	1000                	addi	s0,sp,32
    8000619a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000619c:	00000097          	auipc	ra,0x0
    800061a0:	fa8080e7          	jalr	-88(ra) # 80006144 <push_off>
  if(holding(lk))
    800061a4:	8526                	mv	a0,s1
    800061a6:	00000097          	auipc	ra,0x0
    800061aa:	f70080e7          	jalr	-144(ra) # 80006116 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ae:	4705                	li	a4,1
  if(holding(lk))
    800061b0:	e115                	bnez	a0,800061d4 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061b2:	87ba                	mv	a5,a4
    800061b4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061b8:	2781                	sext.w	a5,a5
    800061ba:	ffe5                	bnez	a5,800061b2 <acquire+0x22>
  __sync_synchronize();
    800061bc:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061c0:	ffffb097          	auipc	ra,0xffffb
    800061c4:	cb0080e7          	jalr	-848(ra) # 80000e70 <mycpu>
    800061c8:	e888                	sd	a0,16(s1)
}
    800061ca:	60e2                	ld	ra,24(sp)
    800061cc:	6442                	ld	s0,16(sp)
    800061ce:	64a2                	ld	s1,8(sp)
    800061d0:	6105                	addi	sp,sp,32
    800061d2:	8082                	ret
    panic("acquire");
    800061d4:	00002517          	auipc	a0,0x2
    800061d8:	5bc50513          	addi	a0,a0,1468 # 80008790 <etext+0x790>
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	a78080e7          	jalr	-1416(ra) # 80005c54 <panic>

00000000800061e4 <pop_off>:

void
pop_off(void)
{
    800061e4:	1141                	addi	sp,sp,-16
    800061e6:	e406                	sd	ra,8(sp)
    800061e8:	e022                	sd	s0,0(sp)
    800061ea:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061ec:	ffffb097          	auipc	ra,0xffffb
    800061f0:	c84080e7          	jalr	-892(ra) # 80000e70 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061f4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061f8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800061fa:	e78d                	bnez	a5,80006224 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061fc:	5d3c                	lw	a5,120(a0)
    800061fe:	02f05b63          	blez	a5,80006234 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006202:	37fd                	addiw	a5,a5,-1
    80006204:	0007871b          	sext.w	a4,a5
    80006208:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000620a:	eb09                	bnez	a4,8000621c <pop_off+0x38>
    8000620c:	5d7c                	lw	a5,124(a0)
    8000620e:	c799                	beqz	a5,8000621c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006210:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006214:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006218:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000621c:	60a2                	ld	ra,8(sp)
    8000621e:	6402                	ld	s0,0(sp)
    80006220:	0141                	addi	sp,sp,16
    80006222:	8082                	ret
    panic("pop_off - interruptible");
    80006224:	00002517          	auipc	a0,0x2
    80006228:	57450513          	addi	a0,a0,1396 # 80008798 <etext+0x798>
    8000622c:	00000097          	auipc	ra,0x0
    80006230:	a28080e7          	jalr	-1496(ra) # 80005c54 <panic>
    panic("pop_off");
    80006234:	00002517          	auipc	a0,0x2
    80006238:	57c50513          	addi	a0,a0,1404 # 800087b0 <etext+0x7b0>
    8000623c:	00000097          	auipc	ra,0x0
    80006240:	a18080e7          	jalr	-1512(ra) # 80005c54 <panic>

0000000080006244 <release>:
{
    80006244:	1101                	addi	sp,sp,-32
    80006246:	ec06                	sd	ra,24(sp)
    80006248:	e822                	sd	s0,16(sp)
    8000624a:	e426                	sd	s1,8(sp)
    8000624c:	1000                	addi	s0,sp,32
    8000624e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006250:	00000097          	auipc	ra,0x0
    80006254:	ec6080e7          	jalr	-314(ra) # 80006116 <holding>
    80006258:	c115                	beqz	a0,8000627c <release+0x38>
  lk->cpu = 0;
    8000625a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000625e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006262:	0f50000f          	fence	iorw,ow
    80006266:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	f7a080e7          	jalr	-134(ra) # 800061e4 <pop_off>
}
    80006272:	60e2                	ld	ra,24(sp)
    80006274:	6442                	ld	s0,16(sp)
    80006276:	64a2                	ld	s1,8(sp)
    80006278:	6105                	addi	sp,sp,32
    8000627a:	8082                	ret
    panic("release");
    8000627c:	00002517          	auipc	a0,0x2
    80006280:	53c50513          	addi	a0,a0,1340 # 800087b8 <etext+0x7b8>
    80006284:	00000097          	auipc	ra,0x0
    80006288:	9d0080e7          	jalr	-1584(ra) # 80005c54 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
