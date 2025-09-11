
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00022117          	auipc	sp,0x22
    80000004:	14010113          	addi	sp,sp,320 # 80022140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	744050ef          	jal	8000575a <start>

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
    80000030:	0002a797          	auipc	a5,0x2a
    80000034:	21078793          	addi	a5,a5,528 # 8002a240 <end>
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
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

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
    8000008e:	bf4080e7          	jalr	-1036(ra) # 80005c7e <panic>

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
    800000e8:	f3c58593          	addi	a1,a1,-196 # 80008020 <etext+0x20>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	00c080e7          	jalr	12(ra) # 80006100 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002a517          	auipc	a0,0x2a
    80000104:	14050513          	addi	a0,a0,320 # 8002a240 <end>
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
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
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

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1c>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x12>
  }
  return dst;
}
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a0:	ca05                	beqz	a2,800001d0 <memcmp+0x36>
    800001a2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a6:	1682                	slli	a3,a3,0x20
    800001a8:	9281                	srli	a3,a3,0x20
    800001aa:	0685                	addi	a3,a3,1
    800001ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	0005c703          	lbu	a4,0(a1)
    800001b6:	00e79863          	bne	a5,a4,800001c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001ba:	0505                	addi	a0,a0,1
    800001bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001be:	fed518e3          	bne	a0,a3,800001ae <memcmp+0x14>
  }

  return 0;
    800001c2:	4501                	li	a0,0
    800001c4:	a019                	j	800001ca <memcmp+0x30>
      return *s1 - *s2;
    800001c6:	40e7853b          	subw	a0,a5,a4
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
  return 0;
    800001d0:	4501                	li	a0,0
    800001d2:	bfe5                	j	800001ca <memcmp+0x30>

00000000800001d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001da:	c205                	beqz	a2,800001fa <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001dc:	02a5e263          	bltu	a1,a0,80000200 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e0:	1602                	slli	a2,a2,0x20
    800001e2:	9201                	srli	a2,a2,0x20
    800001e4:	00c587b3          	add	a5,a1,a2
{
    800001e8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ea:	0585                	addi	a1,a1,1
    800001ec:	0705                	addi	a4,a4,1
    800001ee:	fff5c683          	lbu	a3,-1(a1)
    800001f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f6:	fef59ae3          	bne	a1,a5,800001ea <memmove+0x16>

  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
  if(s < d && s + n > d){
    80000200:	02061693          	slli	a3,a2,0x20
    80000204:	9281                	srli	a3,a3,0x20
    80000206:	00d58733          	add	a4,a1,a3
    8000020a:	fce57be3          	bgeu	a0,a4,800001e0 <memmove+0xc>
    d += n;
    8000020e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000210:	fff6079b          	addiw	a5,a2,-1
    80000214:	1782                	slli	a5,a5,0x20
    80000216:	9381                	srli	a5,a5,0x20
    80000218:	fff7c793          	not	a5,a5
    8000021c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021e:	177d                	addi	a4,a4,-1
    80000220:	16fd                	addi	a3,a3,-1
    80000222:	00074603          	lbu	a2,0(a4)
    80000226:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022a:	fee79ae3          	bne	a5,a4,8000021e <memmove+0x4a>
    8000022e:	b7f1                	j	800001fa <memmove+0x26>

0000000080000230 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e406                	sd	ra,8(sp)
    80000234:	e022                	sd	s0,0(sp)
    80000236:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f9c080e7          	jalr	-100(ra) # 800001d4 <memmove>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e422                	sd	s0,8(sp)
    8000024c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000024e:	ce11                	beqz	a2,8000026a <strncmp+0x22>
    80000250:	00054783          	lbu	a5,0(a0)
    80000254:	cf89                	beqz	a5,8000026e <strncmp+0x26>
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00f71a63          	bne	a4,a5,8000026e <strncmp+0x26>
    n--, p++, q++;
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000264:	f675                	bnez	a2,80000250 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000266:	4501                	li	a0,0
    80000268:	a809                	j	8000027a <strncmp+0x32>
    8000026a:	4501                	li	a0,0
    8000026c:	a039                	j	8000027a <strncmp+0x32>
  if(n == 0)
    8000026e:	ca09                	beqz	a2,80000280 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
    return 0;
    80000280:	4501                	li	a0,0
    80000282:	bfe5                	j	8000027a <strncmp+0x32>

0000000080000284 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028a:	872a                	mv	a4,a0
    8000028c:	8832                	mv	a6,a2
    8000028e:	367d                	addiw	a2,a2,-1
    80000290:	01005963          	blez	a6,800002a2 <strncpy+0x1e>
    80000294:	0705                	addi	a4,a4,1
    80000296:	0005c783          	lbu	a5,0(a1)
    8000029a:	fef70fa3          	sb	a5,-1(a4)
    8000029e:	0585                	addi	a1,a1,1
    800002a0:	f7f5                	bnez	a5,8000028c <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a2:	86ba                	mv	a3,a4
    800002a4:	00c05c63          	blez	a2,800002bc <strncpy+0x38>
    *s++ = 0;
    800002a8:	0685                	addi	a3,a3,1
    800002aa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ae:	fff6c793          	not	a5,a3
    800002b2:	9fb9                	addw	a5,a5,a4
    800002b4:	010787bb          	addw	a5,a5,a6
    800002b8:	fef048e3          	bgtz	a5,800002a8 <strncpy+0x24>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	4685                	li	a3,1
    80000306:	9e89                	subw	a3,a3,a0
    80000308:	00f6853b          	addw	a0,a3,a5
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff7c703          	lbu	a4,-1(a5)
    80000312:	fb7d                	bnez	a4,80000308 <strlen+0x14>
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	af0080e7          	jalr	-1296(ra) # 80000e16 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00009717          	auipc	a4,0x9
    80000332:	cd270713          	addi	a4,a4,-814 # 80009000 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	ad4080e7          	jalr	-1324(ra) # 80000e16 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cfc50513          	addi	a0,a0,-772 # 80008048 <etext+0x48>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	97c080e7          	jalr	-1668(ra) # 80005cd0 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	73c080e7          	jalr	1852(ra) # 80001aa0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	dc4080e7          	jalr	-572(ra) # 80005130 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fea080e7          	jalr	-22(ra) # 8000135e <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	79a080e7          	jalr	1946(ra) # 80005b16 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	880080e7          	jalr	-1920(ra) # 80005c04 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	c9c50513          	addi	a0,a0,-868 # 80008028 <etext+0x28>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	93c080e7          	jalr	-1732(ra) # 80005cd0 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c9450513          	addi	a0,a0,-876 # 80008030 <etext+0x30>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	92c080e7          	jalr	-1748(ra) # 80005cd0 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c7c50513          	addi	a0,a0,-900 # 80008028 <etext+0x28>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	91c080e7          	jalr	-1764(ra) # 80005cd0 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d20080e7          	jalr	-736(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	322080e7          	jalr	802(ra) # 800006e6 <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	992080e7          	jalr	-1646(ra) # 80000d66 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	69c080e7          	jalr	1692(ra) # 80001a78 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6bc080e7          	jalr	1724(ra) # 80001aa0 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	d2e080e7          	jalr	-722(ra) # 8000511a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d3c080e7          	jalr	-708(ra) # 80005130 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	f06080e7          	jalr	-250(ra) # 80002302 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	596080e7          	jalr	1430(ra) # 8000299a <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	540080e7          	jalr	1344(ra) # 8000394c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	e3e080e7          	jalr	-450(ra) # 80005252 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d0c080e7          	jalr	-756(ra) # 80001128 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00009717          	auipc	a4,0x9
    8000042e:	bcf72b23          	sw	a5,-1066(a4) # 80009000 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043a:	00009797          	auipc	a5,0x9
    8000043e:	bce7b783          	ld	a5,-1074(a5) # 80009008 <kernel_pagetable>
    80000442:	83b1                	srli	a5,a5,0xc
    80000444:	577d                	li	a4,-1
    80000446:	177e                	slli	a4,a4,0x3f
    80000448:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000044e:	12000073          	sfence.vma
  sfence_vma();
}
    80000452:	6422                	ld	s0,8(sp)
    80000454:	0141                	addi	sp,sp,16
    80000456:	8082                	ret

0000000080000458 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000458:	7139                	addi	sp,sp,-64
    8000045a:	fc06                	sd	ra,56(sp)
    8000045c:	f822                	sd	s0,48(sp)
    8000045e:	f426                	sd	s1,40(sp)
    80000460:	f04a                	sd	s2,32(sp)
    80000462:	ec4e                	sd	s3,24(sp)
    80000464:	e852                	sd	s4,16(sp)
    80000466:	e456                	sd	s5,8(sp)
    80000468:	e05a                	sd	s6,0(sp)
    8000046a:	0080                	addi	s0,sp,64
    8000046c:	84aa                	mv	s1,a0
    8000046e:	89ae                	mv	s3,a1
    80000470:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000472:	57fd                	li	a5,-1
    80000474:	83e9                	srli	a5,a5,0x1a
    80000476:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000478:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047a:	04b7f263          	bgeu	a5,a1,800004be <walk+0x66>
    panic("walk");
    8000047e:	00008517          	auipc	a0,0x8
    80000482:	be250513          	addi	a0,a0,-1054 # 80008060 <etext+0x60>
    80000486:	00005097          	auipc	ra,0x5
    8000048a:	7f8080e7          	jalr	2040(ra) # 80005c7e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000048e:	060a8663          	beqz	s5,800004fa <walk+0xa2>
    80000492:	00000097          	auipc	ra,0x0
    80000496:	c86080e7          	jalr	-890(ra) # 80000118 <kalloc>
    8000049a:	84aa                	mv	s1,a0
    8000049c:	c529                	beqz	a0,800004e6 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000049e:	6605                	lui	a2,0x1
    800004a0:	4581                	li	a1,0
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	cd6080e7          	jalr	-810(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004aa:	00c4d793          	srli	a5,s1,0xc
    800004ae:	07aa                	slli	a5,a5,0xa
    800004b0:	0017e793          	ori	a5,a5,1
    800004b4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b8:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd4db7>
    800004ba:	036a0063          	beq	s4,s6,800004da <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004be:	0149d933          	srl	s2,s3,s4
    800004c2:	1ff97913          	andi	s2,s2,511
    800004c6:	090e                	slli	s2,s2,0x3
    800004c8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ca:	00093483          	ld	s1,0(s2)
    800004ce:	0014f793          	andi	a5,s1,1
    800004d2:	dfd5                	beqz	a5,8000048e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d4:	80a9                	srli	s1,s1,0xa
    800004d6:	04b2                	slli	s1,s1,0xc
    800004d8:	b7c5                	j	800004b8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004da:	00c9d513          	srli	a0,s3,0xc
    800004de:	1ff57513          	andi	a0,a0,511
    800004e2:	050e                	slli	a0,a0,0x3
    800004e4:	9526                	add	a0,a0,s1
}
    800004e6:	70e2                	ld	ra,56(sp)
    800004e8:	7442                	ld	s0,48(sp)
    800004ea:	74a2                	ld	s1,40(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	69e2                	ld	s3,24(sp)
    800004f0:	6a42                	ld	s4,16(sp)
    800004f2:	6aa2                	ld	s5,8(sp)
    800004f4:	6b02                	ld	s6,0(sp)
    800004f6:	6121                	addi	sp,sp,64
    800004f8:	8082                	ret
        return 0;
    800004fa:	4501                	li	a0,0
    800004fc:	b7ed                	j	800004e6 <walk+0x8e>

00000000800004fe <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004fe:	57fd                	li	a5,-1
    80000500:	83e9                	srli	a5,a5,0x1a
    80000502:	00b7f463          	bgeu	a5,a1,8000050a <walkaddr+0xc>
    return 0;
    80000506:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000508:	8082                	ret
{
    8000050a:	1141                	addi	sp,sp,-16
    8000050c:	e406                	sd	ra,8(sp)
    8000050e:	e022                	sd	s0,0(sp)
    80000510:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000512:	4601                	li	a2,0
    80000514:	00000097          	auipc	ra,0x0
    80000518:	f44080e7          	jalr	-188(ra) # 80000458 <walk>
  if(pte == 0)
    8000051c:	c105                	beqz	a0,8000053c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000051e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000520:	0117f693          	andi	a3,a5,17
    80000524:	4745                	li	a4,17
    return 0;
    80000526:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000528:	00e68663          	beq	a3,a4,80000534 <walkaddr+0x36>
}
    8000052c:	60a2                	ld	ra,8(sp)
    8000052e:	6402                	ld	s0,0(sp)
    80000530:	0141                	addi	sp,sp,16
    80000532:	8082                	ret
  pa = PTE2PA(*pte);
    80000534:	00a7d513          	srli	a0,a5,0xa
    80000538:	0532                	slli	a0,a0,0xc
  return pa;
    8000053a:	bfcd                	j	8000052c <walkaddr+0x2e>
    return 0;
    8000053c:	4501                	li	a0,0
    8000053e:	b7fd                	j	8000052c <walkaddr+0x2e>

0000000080000540 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000540:	715d                	addi	sp,sp,-80
    80000542:	e486                	sd	ra,72(sp)
    80000544:	e0a2                	sd	s0,64(sp)
    80000546:	fc26                	sd	s1,56(sp)
    80000548:	f84a                	sd	s2,48(sp)
    8000054a:	f44e                	sd	s3,40(sp)
    8000054c:	f052                	sd	s4,32(sp)
    8000054e:	ec56                	sd	s5,24(sp)
    80000550:	e85a                	sd	s6,16(sp)
    80000552:	e45e                	sd	s7,8(sp)
    80000554:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000556:	c639                	beqz	a2,800005a4 <mappages+0x64>
    80000558:	8aaa                	mv	s5,a0
    8000055a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055c:	77fd                	lui	a5,0xfffff
    8000055e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000562:	15fd                	addi	a1,a1,-1
    80000564:	00c589b3          	add	s3,a1,a2
    80000568:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000056c:	8952                	mv	s2,s4
    8000056e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000572:	6b85                	lui	s7,0x1
    80000574:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000578:	4605                	li	a2,1
    8000057a:	85ca                	mv	a1,s2
    8000057c:	8556                	mv	a0,s5
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	eda080e7          	jalr	-294(ra) # 80000458 <walk>
    80000586:	cd1d                	beqz	a0,800005c4 <mappages+0x84>
    if(*pte & PTE_V)
    80000588:	611c                	ld	a5,0(a0)
    8000058a:	8b85                	andi	a5,a5,1
    8000058c:	e785                	bnez	a5,800005b4 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000058e:	80b1                	srli	s1,s1,0xc
    80000590:	04aa                	slli	s1,s1,0xa
    80000592:	0164e4b3          	or	s1,s1,s6
    80000596:	0014e493          	ori	s1,s1,1
    8000059a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059c:	05390063          	beq	s2,s3,800005dc <mappages+0x9c>
    a += PGSIZE;
    800005a0:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a2:	bfc9                	j	80000574 <mappages+0x34>
    panic("mappages: size");
    800005a4:	00008517          	auipc	a0,0x8
    800005a8:	ac450513          	addi	a0,a0,-1340 # 80008068 <etext+0x68>
    800005ac:	00005097          	auipc	ra,0x5
    800005b0:	6d2080e7          	jalr	1746(ra) # 80005c7e <panic>
      panic("mappages: remap");
    800005b4:	00008517          	auipc	a0,0x8
    800005b8:	ac450513          	addi	a0,a0,-1340 # 80008078 <etext+0x78>
    800005bc:	00005097          	auipc	ra,0x5
    800005c0:	6c2080e7          	jalr	1730(ra) # 80005c7e <panic>
      return -1;
    800005c4:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c6:	60a6                	ld	ra,72(sp)
    800005c8:	6406                	ld	s0,64(sp)
    800005ca:	74e2                	ld	s1,56(sp)
    800005cc:	7942                	ld	s2,48(sp)
    800005ce:	79a2                	ld	s3,40(sp)
    800005d0:	7a02                	ld	s4,32(sp)
    800005d2:	6ae2                	ld	s5,24(sp)
    800005d4:	6b42                	ld	s6,16(sp)
    800005d6:	6ba2                	ld	s7,8(sp)
    800005d8:	6161                	addi	sp,sp,80
    800005da:	8082                	ret
  return 0;
    800005dc:	4501                	li	a0,0
    800005de:	b7e5                	j	800005c6 <mappages+0x86>

00000000800005e0 <kvmmap>:
{
    800005e0:	1141                	addi	sp,sp,-16
    800005e2:	e406                	sd	ra,8(sp)
    800005e4:	e022                	sd	s0,0(sp)
    800005e6:	0800                	addi	s0,sp,16
    800005e8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ea:	86b2                	mv	a3,a2
    800005ec:	863e                	mv	a2,a5
    800005ee:	00000097          	auipc	ra,0x0
    800005f2:	f52080e7          	jalr	-174(ra) # 80000540 <mappages>
    800005f6:	e509                	bnez	a0,80000600 <kvmmap+0x20>
}
    800005f8:	60a2                	ld	ra,8(sp)
    800005fa:	6402                	ld	s0,0(sp)
    800005fc:	0141                	addi	sp,sp,16
    800005fe:	8082                	ret
    panic("kvmmap");
    80000600:	00008517          	auipc	a0,0x8
    80000604:	a8850513          	addi	a0,a0,-1400 # 80008088 <etext+0x88>
    80000608:	00005097          	auipc	ra,0x5
    8000060c:	676080e7          	jalr	1654(ra) # 80005c7e <panic>

0000000080000610 <kvmmake>:
{
    80000610:	1101                	addi	sp,sp,-32
    80000612:	ec06                	sd	ra,24(sp)
    80000614:	e822                	sd	s0,16(sp)
    80000616:	e426                	sd	s1,8(sp)
    80000618:	e04a                	sd	s2,0(sp)
    8000061a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	afc080e7          	jalr	-1284(ra) # 80000118 <kalloc>
    80000624:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000626:	6605                	lui	a2,0x1
    80000628:	4581                	li	a1,0
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	b4e080e7          	jalr	-1202(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000632:	4719                	li	a4,6
    80000634:	6685                	lui	a3,0x1
    80000636:	10000637          	lui	a2,0x10000
    8000063a:	100005b7          	lui	a1,0x10000
    8000063e:	8526                	mv	a0,s1
    80000640:	00000097          	auipc	ra,0x0
    80000644:	fa0080e7          	jalr	-96(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000648:	4719                	li	a4,6
    8000064a:	6685                	lui	a3,0x1
    8000064c:	10001637          	lui	a2,0x10001
    80000650:	100015b7          	lui	a1,0x10001
    80000654:	8526                	mv	a0,s1
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	f8a080e7          	jalr	-118(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000065e:	4719                	li	a4,6
    80000660:	004006b7          	lui	a3,0x400
    80000664:	0c000637          	lui	a2,0xc000
    80000668:	0c0005b7          	lui	a1,0xc000
    8000066c:	8526                	mv	a0,s1
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	f72080e7          	jalr	-142(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000676:	00008917          	auipc	s2,0x8
    8000067a:	98a90913          	addi	s2,s2,-1654 # 80008000 <etext>
    8000067e:	4729                	li	a4,10
    80000680:	80008697          	auipc	a3,0x80008
    80000684:	98068693          	addi	a3,a3,-1664 # 8000 <_entry-0x7fff8000>
    80000688:	4605                	li	a2,1
    8000068a:	067e                	slli	a2,a2,0x1f
    8000068c:	85b2                	mv	a1,a2
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f50080e7          	jalr	-176(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000698:	4719                	li	a4,6
    8000069a:	46c5                	li	a3,17
    8000069c:	06ee                	slli	a3,a3,0x1b
    8000069e:	412686b3          	sub	a3,a3,s2
    800006a2:	864a                	mv	a2,s2
    800006a4:	85ca                	mv	a1,s2
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f38080e7          	jalr	-200(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b0:	4729                	li	a4,10
    800006b2:	6685                	lui	a3,0x1
    800006b4:	00007617          	auipc	a2,0x7
    800006b8:	94c60613          	addi	a2,a2,-1716 # 80007000 <_trampoline>
    800006bc:	040005b7          	lui	a1,0x4000
    800006c0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c2:	05b2                	slli	a1,a1,0xc
    800006c4:	8526                	mv	a0,s1
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	f1a080e7          	jalr	-230(ra) # 800005e0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006ce:	8526                	mv	a0,s1
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	600080e7          	jalr	1536(ra) # 80000cd0 <proc_mapstacks>
}
    800006d8:	8526                	mv	a0,s1
    800006da:	60e2                	ld	ra,24(sp)
    800006dc:	6442                	ld	s0,16(sp)
    800006de:	64a2                	ld	s1,8(sp)
    800006e0:	6902                	ld	s2,0(sp)
    800006e2:	6105                	addi	sp,sp,32
    800006e4:	8082                	ret

00000000800006e6 <kvminit>:
{
    800006e6:	1141                	addi	sp,sp,-16
    800006e8:	e406                	sd	ra,8(sp)
    800006ea:	e022                	sd	s0,0(sp)
    800006ec:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	f22080e7          	jalr	-222(ra) # 80000610 <kvmmake>
    800006f6:	00009797          	auipc	a5,0x9
    800006fa:	90a7b923          	sd	a0,-1774(a5) # 80009008 <kernel_pagetable>
}
    800006fe:	60a2                	ld	ra,8(sp)
    80000700:	6402                	ld	s0,0(sp)
    80000702:	0141                	addi	sp,sp,16
    80000704:	8082                	ret

0000000080000706 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000706:	715d                	addi	sp,sp,-80
    80000708:	e486                	sd	ra,72(sp)
    8000070a:	e0a2                	sd	s0,64(sp)
    8000070c:	fc26                	sd	s1,56(sp)
    8000070e:	f84a                	sd	s2,48(sp)
    80000710:	f44e                	sd	s3,40(sp)
    80000712:	f052                	sd	s4,32(sp)
    80000714:	ec56                	sd	s5,24(sp)
    80000716:	e85a                	sd	s6,16(sp)
    80000718:	e45e                	sd	s7,8(sp)
    8000071a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071c:	03459793          	slli	a5,a1,0x34
    80000720:	e795                	bnez	a5,8000074c <uvmunmap+0x46>
    80000722:	8a2a                	mv	s4,a0
    80000724:	892e                	mv	s2,a1
    80000726:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	0632                	slli	a2,a2,0xc
    8000072a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000072e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	6b05                	lui	s6,0x1
    80000732:	0735e263          	bltu	a1,s3,80000796 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000736:	60a6                	ld	ra,72(sp)
    80000738:	6406                	ld	s0,64(sp)
    8000073a:	74e2                	ld	s1,56(sp)
    8000073c:	7942                	ld	s2,48(sp)
    8000073e:	79a2                	ld	s3,40(sp)
    80000740:	7a02                	ld	s4,32(sp)
    80000742:	6ae2                	ld	s5,24(sp)
    80000744:	6b42                	ld	s6,16(sp)
    80000746:	6ba2                	ld	s7,8(sp)
    80000748:	6161                	addi	sp,sp,80
    8000074a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074c:	00008517          	auipc	a0,0x8
    80000750:	94450513          	addi	a0,a0,-1724 # 80008090 <etext+0x90>
    80000754:	00005097          	auipc	ra,0x5
    80000758:	52a080e7          	jalr	1322(ra) # 80005c7e <panic>
      panic("uvmunmap: walk");
    8000075c:	00008517          	auipc	a0,0x8
    80000760:	94c50513          	addi	a0,a0,-1716 # 800080a8 <etext+0xa8>
    80000764:	00005097          	auipc	ra,0x5
    80000768:	51a080e7          	jalr	1306(ra) # 80005c7e <panic>
      panic("uvmunmap: not mapped");
    8000076c:	00008517          	auipc	a0,0x8
    80000770:	94c50513          	addi	a0,a0,-1716 # 800080b8 <etext+0xb8>
    80000774:	00005097          	auipc	ra,0x5
    80000778:	50a080e7          	jalr	1290(ra) # 80005c7e <panic>
      panic("uvmunmap: not a leaf");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	95450513          	addi	a0,a0,-1708 # 800080d0 <etext+0xd0>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	4fa080e7          	jalr	1274(ra) # 80005c7e <panic>
    *pte = 0;
    8000078c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000790:	995a                	add	s2,s2,s6
    80000792:	fb3972e3          	bgeu	s2,s3,80000736 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000796:	4601                	li	a2,0
    80000798:	85ca                	mv	a1,s2
    8000079a:	8552                	mv	a0,s4
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	cbc080e7          	jalr	-836(ra) # 80000458 <walk>
    800007a4:	84aa                	mv	s1,a0
    800007a6:	d95d                	beqz	a0,8000075c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007a8:	6108                	ld	a0,0(a0)
    800007aa:	00157793          	andi	a5,a0,1
    800007ae:	dfdd                	beqz	a5,8000076c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b0:	3ff57793          	andi	a5,a0,1023
    800007b4:	fd7784e3          	beq	a5,s7,8000077c <uvmunmap+0x76>
    if(do_free){
    800007b8:	fc0a8ae3          	beqz	s5,8000078c <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007be:	0532                	slli	a0,a0,0xc
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	85c080e7          	jalr	-1956(ra) # 8000001c <kfree>
    800007c8:	b7d1                	j	8000078c <uvmunmap+0x86>

00000000800007ca <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ca:	1101                	addi	sp,sp,-32
    800007cc:	ec06                	sd	ra,24(sp)
    800007ce:	e822                	sd	s0,16(sp)
    800007d0:	e426                	sd	s1,8(sp)
    800007d2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	944080e7          	jalr	-1724(ra) # 80000118 <kalloc>
    800007dc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007de:	c519                	beqz	a0,800007ec <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e0:	6605                	lui	a2,0x1
    800007e2:	4581                	li	a1,0
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	994080e7          	jalr	-1644(ra) # 80000178 <memset>
  return pagetable;
}
    800007ec:	8526                	mv	a0,s1
    800007ee:	60e2                	ld	ra,24(sp)
    800007f0:	6442                	ld	s0,16(sp)
    800007f2:	64a2                	ld	s1,8(sp)
    800007f4:	6105                	addi	sp,sp,32
    800007f6:	8082                	ret

00000000800007f8 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f8:	7179                	addi	sp,sp,-48
    800007fa:	f406                	sd	ra,40(sp)
    800007fc:	f022                	sd	s0,32(sp)
    800007fe:	ec26                	sd	s1,24(sp)
    80000800:	e84a                	sd	s2,16(sp)
    80000802:	e44e                	sd	s3,8(sp)
    80000804:	e052                	sd	s4,0(sp)
    80000806:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000808:	6785                	lui	a5,0x1
    8000080a:	04f67863          	bgeu	a2,a5,8000085a <uvminit+0x62>
    8000080e:	8a2a                	mv	s4,a0
    80000810:	89ae                	mv	s3,a1
    80000812:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000814:	00000097          	auipc	ra,0x0
    80000818:	904080e7          	jalr	-1788(ra) # 80000118 <kalloc>
    8000081c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000081e:	6605                	lui	a2,0x1
    80000820:	4581                	li	a1,0
    80000822:	00000097          	auipc	ra,0x0
    80000826:	956080e7          	jalr	-1706(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082a:	4779                	li	a4,30
    8000082c:	86ca                	mv	a3,s2
    8000082e:	6605                	lui	a2,0x1
    80000830:	4581                	li	a1,0
    80000832:	8552                	mv	a0,s4
    80000834:	00000097          	auipc	ra,0x0
    80000838:	d0c080e7          	jalr	-756(ra) # 80000540 <mappages>
  memmove(mem, src, sz);
    8000083c:	8626                	mv	a2,s1
    8000083e:	85ce                	mv	a1,s3
    80000840:	854a                	mv	a0,s2
    80000842:	00000097          	auipc	ra,0x0
    80000846:	992080e7          	jalr	-1646(ra) # 800001d4 <memmove>
}
    8000084a:	70a2                	ld	ra,40(sp)
    8000084c:	7402                	ld	s0,32(sp)
    8000084e:	64e2                	ld	s1,24(sp)
    80000850:	6942                	ld	s2,16(sp)
    80000852:	69a2                	ld	s3,8(sp)
    80000854:	6a02                	ld	s4,0(sp)
    80000856:	6145                	addi	sp,sp,48
    80000858:	8082                	ret
    panic("inituvm: more than a page");
    8000085a:	00008517          	auipc	a0,0x8
    8000085e:	88e50513          	addi	a0,a0,-1906 # 800080e8 <etext+0xe8>
    80000862:	00005097          	auipc	ra,0x5
    80000866:	41c080e7          	jalr	1052(ra) # 80005c7e <panic>

000000008000086a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086a:	1101                	addi	sp,sp,-32
    8000086c:	ec06                	sd	ra,24(sp)
    8000086e:	e822                	sd	s0,16(sp)
    80000870:	e426                	sd	s1,8(sp)
    80000872:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000874:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000876:	00b67d63          	bgeu	a2,a1,80000890 <uvmdealloc+0x26>
    8000087a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087c:	6785                	lui	a5,0x1
    8000087e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000880:	00f60733          	add	a4,a2,a5
    80000884:	767d                	lui	a2,0xfffff
    80000886:	8f71                	and	a4,a4,a2
    80000888:	97ae                	add	a5,a5,a1
    8000088a:	8ff1                	and	a5,a5,a2
    8000088c:	00f76863          	bltu	a4,a5,8000089c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000890:	8526                	mv	a0,s1
    80000892:	60e2                	ld	ra,24(sp)
    80000894:	6442                	ld	s0,16(sp)
    80000896:	64a2                	ld	s1,8(sp)
    80000898:	6105                	addi	sp,sp,32
    8000089a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089c:	8f99                	sub	a5,a5,a4
    8000089e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a0:	4685                	li	a3,1
    800008a2:	0007861b          	sext.w	a2,a5
    800008a6:	85ba                	mv	a1,a4
    800008a8:	00000097          	auipc	ra,0x0
    800008ac:	e5e080e7          	jalr	-418(ra) # 80000706 <uvmunmap>
    800008b0:	b7c5                	j	80000890 <uvmdealloc+0x26>

00000000800008b2 <uvmalloc>:
  if(newsz < oldsz)
    800008b2:	0ab66163          	bltu	a2,a1,80000954 <uvmalloc+0xa2>
{
    800008b6:	7139                	addi	sp,sp,-64
    800008b8:	fc06                	sd	ra,56(sp)
    800008ba:	f822                	sd	s0,48(sp)
    800008bc:	f426                	sd	s1,40(sp)
    800008be:	f04a                	sd	s2,32(sp)
    800008c0:	ec4e                	sd	s3,24(sp)
    800008c2:	e852                	sd	s4,16(sp)
    800008c4:	e456                	sd	s5,8(sp)
    800008c6:	0080                	addi	s0,sp,64
    800008c8:	8aaa                	mv	s5,a0
    800008ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008cc:	6985                	lui	s3,0x1
    800008ce:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800008d0:	95ce                	add	a1,a1,s3
    800008d2:	79fd                	lui	s3,0xfffff
    800008d4:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d8:	08c9f063          	bgeu	s3,a2,80000958 <uvmalloc+0xa6>
    800008dc:	894e                	mv	s2,s3
    mem = kalloc();
    800008de:	00000097          	auipc	ra,0x0
    800008e2:	83a080e7          	jalr	-1990(ra) # 80000118 <kalloc>
    800008e6:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e8:	c51d                	beqz	a0,80000916 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ea:	6605                	lui	a2,0x1
    800008ec:	4581                	li	a1,0
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	88a080e7          	jalr	-1910(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f6:	4779                	li	a4,30
    800008f8:	86a6                	mv	a3,s1
    800008fa:	6605                	lui	a2,0x1
    800008fc:	85ca                	mv	a1,s2
    800008fe:	8556                	mv	a0,s5
    80000900:	00000097          	auipc	ra,0x0
    80000904:	c40080e7          	jalr	-960(ra) # 80000540 <mappages>
    80000908:	e905                	bnez	a0,80000938 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090a:	6785                	lui	a5,0x1
    8000090c:	993e                	add	s2,s2,a5
    8000090e:	fd4968e3          	bltu	s2,s4,800008de <uvmalloc+0x2c>
  return newsz;
    80000912:	8552                	mv	a0,s4
    80000914:	a809                	j	80000926 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000916:	864e                	mv	a2,s3
    80000918:	85ca                	mv	a1,s2
    8000091a:	8556                	mv	a0,s5
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	f4e080e7          	jalr	-178(ra) # 8000086a <uvmdealloc>
      return 0;
    80000924:	4501                	li	a0,0
}
    80000926:	70e2                	ld	ra,56(sp)
    80000928:	7442                	ld	s0,48(sp)
    8000092a:	74a2                	ld	s1,40(sp)
    8000092c:	7902                	ld	s2,32(sp)
    8000092e:	69e2                	ld	s3,24(sp)
    80000930:	6a42                	ld	s4,16(sp)
    80000932:	6aa2                	ld	s5,8(sp)
    80000934:	6121                	addi	sp,sp,64
    80000936:	8082                	ret
      kfree(mem);
    80000938:	8526                	mv	a0,s1
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	6e2080e7          	jalr	1762(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000942:	864e                	mv	a2,s3
    80000944:	85ca                	mv	a1,s2
    80000946:	8556                	mv	a0,s5
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	f22080e7          	jalr	-222(ra) # 8000086a <uvmdealloc>
      return 0;
    80000950:	4501                	li	a0,0
    80000952:	bfd1                	j	80000926 <uvmalloc+0x74>
    return oldsz;
    80000954:	852e                	mv	a0,a1
}
    80000956:	8082                	ret
  return newsz;
    80000958:	8532                	mv	a0,a2
    8000095a:	b7f1                	j	80000926 <uvmalloc+0x74>

000000008000095c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095c:	7179                	addi	sp,sp,-48
    8000095e:	f406                	sd	ra,40(sp)
    80000960:	f022                	sd	s0,32(sp)
    80000962:	ec26                	sd	s1,24(sp)
    80000964:	e84a                	sd	s2,16(sp)
    80000966:	e44e                	sd	s3,8(sp)
    80000968:	e052                	sd	s4,0(sp)
    8000096a:	1800                	addi	s0,sp,48
    8000096c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000096e:	84aa                	mv	s1,a0
    80000970:	6905                	lui	s2,0x1
    80000972:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000974:	4985                	li	s3,1
    80000976:	a821                	j	8000098e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000978:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000097a:	0532                	slli	a0,a0,0xc
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	fe0080e7          	jalr	-32(ra) # 8000095c <freewalk>
      pagetable[i] = 0;
    80000984:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000988:	04a1                	addi	s1,s1,8
    8000098a:	03248163          	beq	s1,s2,800009ac <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000098e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000990:	00f57793          	andi	a5,a0,15
    80000994:	ff3782e3          	beq	a5,s3,80000978 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000998:	8905                	andi	a0,a0,1
    8000099a:	d57d                	beqz	a0,80000988 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000099c:	00007517          	auipc	a0,0x7
    800009a0:	76c50513          	addi	a0,a0,1900 # 80008108 <etext+0x108>
    800009a4:	00005097          	auipc	ra,0x5
    800009a8:	2da080e7          	jalr	730(ra) # 80005c7e <panic>
    }
  }
  kfree((void*)pagetable);
    800009ac:	8552                	mv	a0,s4
    800009ae:	fffff097          	auipc	ra,0xfffff
    800009b2:	66e080e7          	jalr	1646(ra) # 8000001c <kfree>
}
    800009b6:	70a2                	ld	ra,40(sp)
    800009b8:	7402                	ld	s0,32(sp)
    800009ba:	64e2                	ld	s1,24(sp)
    800009bc:	6942                	ld	s2,16(sp)
    800009be:	69a2                	ld	s3,8(sp)
    800009c0:	6a02                	ld	s4,0(sp)
    800009c2:	6145                	addi	sp,sp,48
    800009c4:	8082                	ret

00000000800009c6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c6:	1101                	addi	sp,sp,-32
    800009c8:	ec06                	sd	ra,24(sp)
    800009ca:	e822                	sd	s0,16(sp)
    800009cc:	e426                	sd	s1,8(sp)
    800009ce:	1000                	addi	s0,sp,32
    800009d0:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d2:	e999                	bnez	a1,800009e8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	f86080e7          	jalr	-122(ra) # 8000095c <freewalk>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009e8:	6605                	lui	a2,0x1
    800009ea:	167d                	addi	a2,a2,-1 # fff <_entry-0x7ffff001>
    800009ec:	962e                	add	a2,a2,a1
    800009ee:	4685                	li	a3,1
    800009f0:	8231                	srli	a2,a2,0xc
    800009f2:	4581                	li	a1,0
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	d12080e7          	jalr	-750(ra) # 80000706 <uvmunmap>
    800009fc:	bfe1                	j	800009d4 <uvmfree+0xe>

00000000800009fe <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009fe:	c679                	beqz	a2,80000acc <uvmcopy+0xce>
{
    80000a00:	715d                	addi	sp,sp,-80
    80000a02:	e486                	sd	ra,72(sp)
    80000a04:	e0a2                	sd	s0,64(sp)
    80000a06:	fc26                	sd	s1,56(sp)
    80000a08:	f84a                	sd	s2,48(sp)
    80000a0a:	f44e                	sd	s3,40(sp)
    80000a0c:	f052                	sd	s4,32(sp)
    80000a0e:	ec56                	sd	s5,24(sp)
    80000a10:	e85a                	sd	s6,16(sp)
    80000a12:	e45e                	sd	s7,8(sp)
    80000a14:	0880                	addi	s0,sp,80
    80000a16:	8b2a                	mv	s6,a0
    80000a18:	8aae                	mv	s5,a1
    80000a1a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a1c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a1e:	4601                	li	a2,0
    80000a20:	85ce                	mv	a1,s3
    80000a22:	855a                	mv	a0,s6
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	a34080e7          	jalr	-1484(ra) # 80000458 <walk>
    80000a2c:	c531                	beqz	a0,80000a78 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a2e:	6118                	ld	a4,0(a0)
    80000a30:	00177793          	andi	a5,a4,1
    80000a34:	cbb1                	beqz	a5,80000a88 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a36:	00a75593          	srli	a1,a4,0xa
    80000a3a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a3e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a42:	fffff097          	auipc	ra,0xfffff
    80000a46:	6d6080e7          	jalr	1750(ra) # 80000118 <kalloc>
    80000a4a:	892a                	mv	s2,a0
    80000a4c:	c939                	beqz	a0,80000aa2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a4e:	6605                	lui	a2,0x1
    80000a50:	85de                	mv	a1,s7
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	782080e7          	jalr	1922(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a5a:	8726                	mv	a4,s1
    80000a5c:	86ca                	mv	a3,s2
    80000a5e:	6605                	lui	a2,0x1
    80000a60:	85ce                	mv	a1,s3
    80000a62:	8556                	mv	a0,s5
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	adc080e7          	jalr	-1316(ra) # 80000540 <mappages>
    80000a6c:	e515                	bnez	a0,80000a98 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	6785                	lui	a5,0x1
    80000a70:	99be                	add	s3,s3,a5
    80000a72:	fb49e6e3          	bltu	s3,s4,80000a1e <uvmcopy+0x20>
    80000a76:	a081                	j	80000ab6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a78:	00007517          	auipc	a0,0x7
    80000a7c:	6a050513          	addi	a0,a0,1696 # 80008118 <etext+0x118>
    80000a80:	00005097          	auipc	ra,0x5
    80000a84:	1fe080e7          	jalr	510(ra) # 80005c7e <panic>
      panic("uvmcopy: page not present");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	6b050513          	addi	a0,a0,1712 # 80008138 <etext+0x138>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	1ee080e7          	jalr	494(ra) # 80005c7e <panic>
      kfree(mem);
    80000a98:	854a                	mv	a0,s2
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	582080e7          	jalr	1410(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa2:	4685                	li	a3,1
    80000aa4:	00c9d613          	srli	a2,s3,0xc
    80000aa8:	4581                	li	a1,0
    80000aaa:	8556                	mv	a0,s5
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	c5a080e7          	jalr	-934(ra) # 80000706 <uvmunmap>
  return -1;
    80000ab4:	557d                	li	a0,-1
}
    80000ab6:	60a6                	ld	ra,72(sp)
    80000ab8:	6406                	ld	s0,64(sp)
    80000aba:	74e2                	ld	s1,56(sp)
    80000abc:	7942                	ld	s2,48(sp)
    80000abe:	79a2                	ld	s3,40(sp)
    80000ac0:	7a02                	ld	s4,32(sp)
    80000ac2:	6ae2                	ld	s5,24(sp)
    80000ac4:	6b42                	ld	s6,16(sp)
    80000ac6:	6ba2                	ld	s7,8(sp)
    80000ac8:	6161                	addi	sp,sp,80
    80000aca:	8082                	ret
  return 0;
    80000acc:	4501                	li	a0,0
}
    80000ace:	8082                	ret

0000000080000ad0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad0:	1141                	addi	sp,sp,-16
    80000ad2:	e406                	sd	ra,8(sp)
    80000ad4:	e022                	sd	s0,0(sp)
    80000ad6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ad8:	4601                	li	a2,0
    80000ada:	00000097          	auipc	ra,0x0
    80000ade:	97e080e7          	jalr	-1666(ra) # 80000458 <walk>
  if(pte == 0)
    80000ae2:	c901                	beqz	a0,80000af2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ae4:	611c                	ld	a5,0(a0)
    80000ae6:	9bbd                	andi	a5,a5,-17
    80000ae8:	e11c                	sd	a5,0(a0)
}
    80000aea:	60a2                	ld	ra,8(sp)
    80000aec:	6402                	ld	s0,0(sp)
    80000aee:	0141                	addi	sp,sp,16
    80000af0:	8082                	ret
    panic("uvmclear");
    80000af2:	00007517          	auipc	a0,0x7
    80000af6:	66650513          	addi	a0,a0,1638 # 80008158 <etext+0x158>
    80000afa:	00005097          	auipc	ra,0x5
    80000afe:	184080e7          	jalr	388(ra) # 80005c7e <panic>

0000000080000b02 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b02:	c6bd                	beqz	a3,80000b70 <copyout+0x6e>
{
    80000b04:	715d                	addi	sp,sp,-80
    80000b06:	e486                	sd	ra,72(sp)
    80000b08:	e0a2                	sd	s0,64(sp)
    80000b0a:	fc26                	sd	s1,56(sp)
    80000b0c:	f84a                	sd	s2,48(sp)
    80000b0e:	f44e                	sd	s3,40(sp)
    80000b10:	f052                	sd	s4,32(sp)
    80000b12:	ec56                	sd	s5,24(sp)
    80000b14:	e85a                	sd	s6,16(sp)
    80000b16:	e45e                	sd	s7,8(sp)
    80000b18:	e062                	sd	s8,0(sp)
    80000b1a:	0880                	addi	s0,sp,80
    80000b1c:	8b2a                	mv	s6,a0
    80000b1e:	8c2e                	mv	s8,a1
    80000b20:	8a32                	mv	s4,a2
    80000b22:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b24:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b26:	6a85                	lui	s5,0x1
    80000b28:	a015                	j	80000b4c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b2a:	9562                	add	a0,a0,s8
    80000b2c:	0004861b          	sext.w	a2,s1
    80000b30:	85d2                	mv	a1,s4
    80000b32:	41250533          	sub	a0,a0,s2
    80000b36:	fffff097          	auipc	ra,0xfffff
    80000b3a:	69e080e7          	jalr	1694(ra) # 800001d4 <memmove>

    len -= n;
    80000b3e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b42:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b44:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b48:	02098263          	beqz	s3,80000b6c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b4c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b50:	85ca                	mv	a1,s2
    80000b52:	855a                	mv	a0,s6
    80000b54:	00000097          	auipc	ra,0x0
    80000b58:	9aa080e7          	jalr	-1622(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000b5c:	cd01                	beqz	a0,80000b74 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b5e:	418904b3          	sub	s1,s2,s8
    80000b62:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b64:	fc99f3e3          	bgeu	s3,s1,80000b2a <copyout+0x28>
    80000b68:	84ce                	mv	s1,s3
    80000b6a:	b7c1                	j	80000b2a <copyout+0x28>
  }
  return 0;
    80000b6c:	4501                	li	a0,0
    80000b6e:	a021                	j	80000b76 <copyout+0x74>
    80000b70:	4501                	li	a0,0
}
    80000b72:	8082                	ret
      return -1;
    80000b74:	557d                	li	a0,-1
}
    80000b76:	60a6                	ld	ra,72(sp)
    80000b78:	6406                	ld	s0,64(sp)
    80000b7a:	74e2                	ld	s1,56(sp)
    80000b7c:	7942                	ld	s2,48(sp)
    80000b7e:	79a2                	ld	s3,40(sp)
    80000b80:	7a02                	ld	s4,32(sp)
    80000b82:	6ae2                	ld	s5,24(sp)
    80000b84:	6b42                	ld	s6,16(sp)
    80000b86:	6ba2                	ld	s7,8(sp)
    80000b88:	6c02                	ld	s8,0(sp)
    80000b8a:	6161                	addi	sp,sp,80
    80000b8c:	8082                	ret

0000000080000b8e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b8e:	caa5                	beqz	a3,80000bfe <copyin+0x70>
{
    80000b90:	715d                	addi	sp,sp,-80
    80000b92:	e486                	sd	ra,72(sp)
    80000b94:	e0a2                	sd	s0,64(sp)
    80000b96:	fc26                	sd	s1,56(sp)
    80000b98:	f84a                	sd	s2,48(sp)
    80000b9a:	f44e                	sd	s3,40(sp)
    80000b9c:	f052                	sd	s4,32(sp)
    80000b9e:	ec56                	sd	s5,24(sp)
    80000ba0:	e85a                	sd	s6,16(sp)
    80000ba2:	e45e                	sd	s7,8(sp)
    80000ba4:	e062                	sd	s8,0(sp)
    80000ba6:	0880                	addi	s0,sp,80
    80000ba8:	8b2a                	mv	s6,a0
    80000baa:	8a2e                	mv	s4,a1
    80000bac:	8c32                	mv	s8,a2
    80000bae:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb2:	6a85                	lui	s5,0x1
    80000bb4:	a01d                	j	80000bda <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bb6:	018505b3          	add	a1,a0,s8
    80000bba:	0004861b          	sext.w	a2,s1
    80000bbe:	412585b3          	sub	a1,a1,s2
    80000bc2:	8552                	mv	a0,s4
    80000bc4:	fffff097          	auipc	ra,0xfffff
    80000bc8:	610080e7          	jalr	1552(ra) # 800001d4 <memmove>

    len -= n;
    80000bcc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bd6:	02098263          	beqz	s3,80000bfa <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bda:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bde:	85ca                	mv	a1,s2
    80000be0:	855a                	mv	a0,s6
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	91c080e7          	jalr	-1764(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000bea:	cd01                	beqz	a0,80000c02 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bec:	418904b3          	sub	s1,s2,s8
    80000bf0:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf2:	fc99f2e3          	bgeu	s3,s1,80000bb6 <copyin+0x28>
    80000bf6:	84ce                	mv	s1,s3
    80000bf8:	bf7d                	j	80000bb6 <copyin+0x28>
  }
  return 0;
    80000bfa:	4501                	li	a0,0
    80000bfc:	a021                	j	80000c04 <copyin+0x76>
    80000bfe:	4501                	li	a0,0
}
    80000c00:	8082                	ret
      return -1;
    80000c02:	557d                	li	a0,-1
}
    80000c04:	60a6                	ld	ra,72(sp)
    80000c06:	6406                	ld	s0,64(sp)
    80000c08:	74e2                	ld	s1,56(sp)
    80000c0a:	7942                	ld	s2,48(sp)
    80000c0c:	79a2                	ld	s3,40(sp)
    80000c0e:	7a02                	ld	s4,32(sp)
    80000c10:	6ae2                	ld	s5,24(sp)
    80000c12:	6b42                	ld	s6,16(sp)
    80000c14:	6ba2                	ld	s7,8(sp)
    80000c16:	6c02                	ld	s8,0(sp)
    80000c18:	6161                	addi	sp,sp,80
    80000c1a:	8082                	ret

0000000080000c1c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c1c:	c6c5                	beqz	a3,80000cc4 <copyinstr+0xa8>
{
    80000c1e:	715d                	addi	sp,sp,-80
    80000c20:	e486                	sd	ra,72(sp)
    80000c22:	e0a2                	sd	s0,64(sp)
    80000c24:	fc26                	sd	s1,56(sp)
    80000c26:	f84a                	sd	s2,48(sp)
    80000c28:	f44e                	sd	s3,40(sp)
    80000c2a:	f052                	sd	s4,32(sp)
    80000c2c:	ec56                	sd	s5,24(sp)
    80000c2e:	e85a                	sd	s6,16(sp)
    80000c30:	e45e                	sd	s7,8(sp)
    80000c32:	0880                	addi	s0,sp,80
    80000c34:	8a2a                	mv	s4,a0
    80000c36:	8b2e                	mv	s6,a1
    80000c38:	8bb2                	mv	s7,a2
    80000c3a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c3c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c3e:	6985                	lui	s3,0x1
    80000c40:	a035                	j	80000c6c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c42:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c46:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c48:	0017b793          	seqz	a5,a5
    80000c4c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c50:	60a6                	ld	ra,72(sp)
    80000c52:	6406                	ld	s0,64(sp)
    80000c54:	74e2                	ld	s1,56(sp)
    80000c56:	7942                	ld	s2,48(sp)
    80000c58:	79a2                	ld	s3,40(sp)
    80000c5a:	7a02                	ld	s4,32(sp)
    80000c5c:	6ae2                	ld	s5,24(sp)
    80000c5e:	6b42                	ld	s6,16(sp)
    80000c60:	6ba2                	ld	s7,8(sp)
    80000c62:	6161                	addi	sp,sp,80
    80000c64:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c66:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6a:	c8a9                	beqz	s1,80000cbc <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c6c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c70:	85ca                	mv	a1,s2
    80000c72:	8552                	mv	a0,s4
    80000c74:	00000097          	auipc	ra,0x0
    80000c78:	88a080e7          	jalr	-1910(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000c7c:	c131                	beqz	a0,80000cc0 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c7e:	41790833          	sub	a6,s2,s7
    80000c82:	984e                	add	a6,a6,s3
    if(n > max)
    80000c84:	0104f363          	bgeu	s1,a6,80000c8a <copyinstr+0x6e>
    80000c88:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8a:	955e                	add	a0,a0,s7
    80000c8c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c90:	fc080be3          	beqz	a6,80000c66 <copyinstr+0x4a>
    80000c94:	985a                	add	a6,a6,s6
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	14fd                	addi	s1,s1,-1
    80000c9e:	9b26                	add	s6,s6,s1
    80000ca0:	00f60733          	add	a4,a2,a5
    80000ca4:	00074703          	lbu	a4,0(a4)
    80000ca8:	df49                	beqz	a4,80000c42 <copyinstr+0x26>
        *dst = *p;
    80000caa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cae:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb4:	ff0796e3          	bne	a5,a6,80000ca0 <copyinstr+0x84>
      dst++;
    80000cb8:	8b42                	mv	s6,a6
    80000cba:	b775                	j	80000c66 <copyinstr+0x4a>
    80000cbc:	4781                	li	a5,0
    80000cbe:	b769                	j	80000c48 <copyinstr+0x2c>
      return -1;
    80000cc0:	557d                	li	a0,-1
    80000cc2:	b779                	j	80000c50 <copyinstr+0x34>
  int got_null = 0;
    80000cc4:	4781                	li	a5,0
  if(got_null){
    80000cc6:	0017b793          	seqz	a5,a5
    80000cca:	40f00533          	neg	a0,a5
}
    80000cce:	8082                	ret

0000000080000cd0 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd0:	7139                	addi	sp,sp,-64
    80000cd2:	fc06                	sd	ra,56(sp)
    80000cd4:	f822                	sd	s0,48(sp)
    80000cd6:	f426                	sd	s1,40(sp)
    80000cd8:	f04a                	sd	s2,32(sp)
    80000cda:	ec4e                	sd	s3,24(sp)
    80000cdc:	e852                	sd	s4,16(sp)
    80000cde:	e456                	sd	s5,8(sp)
    80000ce0:	e05a                	sd	s6,0(sp)
    80000ce2:	0080                	addi	s0,sp,64
    80000ce4:	89aa                	mv	s3,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce6:	00008497          	auipc	s1,0x8
    80000cea:	79a48493          	addi	s1,s1,1946 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cee:	8b26                	mv	s6,s1
    80000cf0:	00007a97          	auipc	s5,0x7
    80000cf4:	310a8a93          	addi	s5,s5,784 # 80008000 <etext>
    80000cf8:	04000937          	lui	s2,0x4000
    80000cfc:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000cfe:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d00:	00013a17          	auipc	s4,0x13
    80000d04:	f80a0a13          	addi	s4,s4,-128 # 80013c80 <tickslock>
    char *pa = kalloc();
    80000d08:	fffff097          	auipc	ra,0xfffff
    80000d0c:	410080e7          	jalr	1040(ra) # 80000118 <kalloc>
    80000d10:	862a                	mv	a2,a0
    if(pa == 0)
    80000d12:	c131                	beqz	a0,80000d56 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d14:	416485b3          	sub	a1,s1,s6
    80000d18:	8595                	srai	a1,a1,0x5
    80000d1a:	000ab783          	ld	a5,0(s5)
    80000d1e:	02f585b3          	mul	a1,a1,a5
    80000d22:	2585                	addiw	a1,a1,1
    80000d24:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d28:	4719                	li	a4,6
    80000d2a:	6685                	lui	a3,0x1
    80000d2c:	40b905b3          	sub	a1,s2,a1
    80000d30:	854e                	mv	a0,s3
    80000d32:	00000097          	auipc	ra,0x0
    80000d36:	8ae080e7          	jalr	-1874(ra) # 800005e0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3a:	2a048493          	addi	s1,s1,672
    80000d3e:	fd4495e3          	bne	s1,s4,80000d08 <proc_mapstacks+0x38>
  }
}
    80000d42:	70e2                	ld	ra,56(sp)
    80000d44:	7442                	ld	s0,48(sp)
    80000d46:	74a2                	ld	s1,40(sp)
    80000d48:	7902                	ld	s2,32(sp)
    80000d4a:	69e2                	ld	s3,24(sp)
    80000d4c:	6a42                	ld	s4,16(sp)
    80000d4e:	6aa2                	ld	s5,8(sp)
    80000d50:	6b02                	ld	s6,0(sp)
    80000d52:	6121                	addi	sp,sp,64
    80000d54:	8082                	ret
      panic("kalloc");
    80000d56:	00007517          	auipc	a0,0x7
    80000d5a:	41250513          	addi	a0,a0,1042 # 80008168 <etext+0x168>
    80000d5e:	00005097          	auipc	ra,0x5
    80000d62:	f20080e7          	jalr	-224(ra) # 80005c7e <panic>

0000000080000d66 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d66:	7139                	addi	sp,sp,-64
    80000d68:	fc06                	sd	ra,56(sp)
    80000d6a:	f822                	sd	s0,48(sp)
    80000d6c:	f426                	sd	s1,40(sp)
    80000d6e:	f04a                	sd	s2,32(sp)
    80000d70:	ec4e                	sd	s3,24(sp)
    80000d72:	e852                	sd	s4,16(sp)
    80000d74:	e456                	sd	s5,8(sp)
    80000d76:	e05a                	sd	s6,0(sp)
    80000d78:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000d7a:	00007597          	auipc	a1,0x7
    80000d7e:	3f658593          	addi	a1,a1,1014 # 80008170 <etext+0x170>
    80000d82:	00008517          	auipc	a0,0x8
    80000d86:	2ce50513          	addi	a0,a0,718 # 80009050 <pid_lock>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	376080e7          	jalr	886(ra) # 80006100 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d92:	00007597          	auipc	a1,0x7
    80000d96:	3e658593          	addi	a1,a1,998 # 80008178 <etext+0x178>
    80000d9a:	00008517          	auipc	a0,0x8
    80000d9e:	2ce50513          	addi	a0,a0,718 # 80009068 <wait_lock>
    80000da2:	00005097          	auipc	ra,0x5
    80000da6:	35e080e7          	jalr	862(ra) # 80006100 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000daa:	00008497          	auipc	s1,0x8
    80000dae:	6d648493          	addi	s1,s1,1750 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db2:	00007b17          	auipc	s6,0x7
    80000db6:	3d6b0b13          	addi	s6,s6,982 # 80008188 <etext+0x188>
      p->kstack = KSTACK((int) (p - proc));
    80000dba:	8aa6                	mv	s5,s1
    80000dbc:	00007a17          	auipc	s4,0x7
    80000dc0:	244a0a13          	addi	s4,s4,580 # 80008000 <etext>
    80000dc4:	04000937          	lui	s2,0x4000
    80000dc8:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dca:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dcc:	00013997          	auipc	s3,0x13
    80000dd0:	eb498993          	addi	s3,s3,-332 # 80013c80 <tickslock>
      initlock(&p->lock, "proc");
    80000dd4:	85da                	mv	a1,s6
    80000dd6:	8526                	mv	a0,s1
    80000dd8:	00005097          	auipc	ra,0x5
    80000ddc:	328080e7          	jalr	808(ra) # 80006100 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de0:	415487b3          	sub	a5,s1,s5
    80000de4:	8795                	srai	a5,a5,0x5
    80000de6:	000a3703          	ld	a4,0(s4)
    80000dea:	02e787b3          	mul	a5,a5,a4
    80000dee:	2785                	addiw	a5,a5,1
    80000df0:	00d7979b          	slliw	a5,a5,0xd
    80000df4:	40f907b3          	sub	a5,s2,a5
    80000df8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	2a048493          	addi	s1,s1,672
    80000dfe:	fd349be3          	bne	s1,s3,80000dd4 <procinit+0x6e>
  }
}
    80000e02:	70e2                	ld	ra,56(sp)
    80000e04:	7442                	ld	s0,48(sp)
    80000e06:	74a2                	ld	s1,40(sp)
    80000e08:	7902                	ld	s2,32(sp)
    80000e0a:	69e2                	ld	s3,24(sp)
    80000e0c:	6a42                	ld	s4,16(sp)
    80000e0e:	6aa2                	ld	s5,8(sp)
    80000e10:	6b02                	ld	s6,0(sp)
    80000e12:	6121                	addi	sp,sp,64
    80000e14:	8082                	ret

0000000080000e16 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e16:	1141                	addi	sp,sp,-16
    80000e18:	e422                	sd	s0,8(sp)
    80000e1a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e1e:	2501                	sext.w	a0,a0
    80000e20:	6422                	ld	s0,8(sp)
    80000e22:	0141                	addi	sp,sp,16
    80000e24:	8082                	ret

0000000080000e26 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
    80000e2c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e2e:	2781                	sext.w	a5,a5
    80000e30:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e32:	00008517          	auipc	a0,0x8
    80000e36:	24e50513          	addi	a0,a0,590 # 80009080 <cpus>
    80000e3a:	953e                	add	a0,a0,a5
    80000e3c:	6422                	ld	s0,8(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret

0000000080000e42 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e42:	1101                	addi	sp,sp,-32
    80000e44:	ec06                	sd	ra,24(sp)
    80000e46:	e822                	sd	s0,16(sp)
    80000e48:	e426                	sd	s1,8(sp)
    80000e4a:	1000                	addi	s0,sp,32
  push_off();
    80000e4c:	00005097          	auipc	ra,0x5
    80000e50:	2f8080e7          	jalr	760(ra) # 80006144 <push_off>
    80000e54:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e56:	2781                	sext.w	a5,a5
    80000e58:	079e                	slli	a5,a5,0x7
    80000e5a:	00008717          	auipc	a4,0x8
    80000e5e:	1f670713          	addi	a4,a4,502 # 80009050 <pid_lock>
    80000e62:	97ba                	add	a5,a5,a4
    80000e64:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e66:	00005097          	auipc	ra,0x5
    80000e6a:	37e080e7          	jalr	894(ra) # 800061e4 <pop_off>
  return p;
}
    80000e6e:	8526                	mv	a0,s1
    80000e70:	60e2                	ld	ra,24(sp)
    80000e72:	6442                	ld	s0,16(sp)
    80000e74:	64a2                	ld	s1,8(sp)
    80000e76:	6105                	addi	sp,sp,32
    80000e78:	8082                	ret

0000000080000e7a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7a:	1141                	addi	sp,sp,-16
    80000e7c:	e406                	sd	ra,8(sp)
    80000e7e:	e022                	sd	s0,0(sp)
    80000e80:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e82:	00000097          	auipc	ra,0x0
    80000e86:	fc0080e7          	jalr	-64(ra) # 80000e42 <myproc>
    80000e8a:	00005097          	auipc	ra,0x5
    80000e8e:	3ba080e7          	jalr	954(ra) # 80006244 <release>

  if (first) {
    80000e92:	00008797          	auipc	a5,0x8
    80000e96:	9ae7a783          	lw	a5,-1618(a5) # 80008840 <first.1>
    80000e9a:	eb89                	bnez	a5,80000eac <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	c1c080e7          	jalr	-996(ra) # 80001ab8 <usertrapret>
}
    80000ea4:	60a2                	ld	ra,8(sp)
    80000ea6:	6402                	ld	s0,0(sp)
    80000ea8:	0141                	addi	sp,sp,16
    80000eaa:	8082                	ret
    first = 0;
    80000eac:	00008797          	auipc	a5,0x8
    80000eb0:	9807aa23          	sw	zero,-1644(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000eb4:	4505                	li	a0,1
    80000eb6:	00002097          	auipc	ra,0x2
    80000eba:	a64080e7          	jalr	-1436(ra) # 8000291a <fsinit>
    80000ebe:	bff9                	j	80000e9c <forkret+0x22>

0000000080000ec0 <allocpid>:
allocpid() {
    80000ec0:	1101                	addi	sp,sp,-32
    80000ec2:	ec06                	sd	ra,24(sp)
    80000ec4:	e822                	sd	s0,16(sp)
    80000ec6:	e426                	sd	s1,8(sp)
    80000ec8:	e04a                	sd	s2,0(sp)
    80000eca:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ecc:	00008917          	auipc	s2,0x8
    80000ed0:	18490913          	addi	s2,s2,388 # 80009050 <pid_lock>
    80000ed4:	854a                	mv	a0,s2
    80000ed6:	00005097          	auipc	ra,0x5
    80000eda:	2ba080e7          	jalr	698(ra) # 80006190 <acquire>
  pid = nextpid;
    80000ede:	00008797          	auipc	a5,0x8
    80000ee2:	96678793          	addi	a5,a5,-1690 # 80008844 <nextpid>
    80000ee6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ee8:	0014871b          	addiw	a4,s1,1
    80000eec:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000eee:	854a                	mv	a0,s2
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	354080e7          	jalr	852(ra) # 80006244 <release>
}
    80000ef8:	8526                	mv	a0,s1
    80000efa:	60e2                	ld	ra,24(sp)
    80000efc:	6442                	ld	s0,16(sp)
    80000efe:	64a2                	ld	s1,8(sp)
    80000f00:	6902                	ld	s2,0(sp)
    80000f02:	6105                	addi	sp,sp,32
    80000f04:	8082                	ret

0000000080000f06 <proc_pagetable>:
{
    80000f06:	1101                	addi	sp,sp,-32
    80000f08:	ec06                	sd	ra,24(sp)
    80000f0a:	e822                	sd	s0,16(sp)
    80000f0c:	e426                	sd	s1,8(sp)
    80000f0e:	e04a                	sd	s2,0(sp)
    80000f10:	1000                	addi	s0,sp,32
    80000f12:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f14:	00000097          	auipc	ra,0x0
    80000f18:	8b6080e7          	jalr	-1866(ra) # 800007ca <uvmcreate>
    80000f1c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f1e:	c121                	beqz	a0,80000f5e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f20:	4729                	li	a4,10
    80000f22:	00006697          	auipc	a3,0x6
    80000f26:	0de68693          	addi	a3,a3,222 # 80007000 <_trampoline>
    80000f2a:	6605                	lui	a2,0x1
    80000f2c:	040005b7          	lui	a1,0x4000
    80000f30:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f32:	05b2                	slli	a1,a1,0xc
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	60c080e7          	jalr	1548(ra) # 80000540 <mappages>
    80000f3c:	02054863          	bltz	a0,80000f6c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f40:	4719                	li	a4,6
    80000f42:	05893683          	ld	a3,88(s2)
    80000f46:	6605                	lui	a2,0x1
    80000f48:	020005b7          	lui	a1,0x2000
    80000f4c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f4e:	05b6                	slli	a1,a1,0xd
    80000f50:	8526                	mv	a0,s1
    80000f52:	fffff097          	auipc	ra,0xfffff
    80000f56:	5ee080e7          	jalr	1518(ra) # 80000540 <mappages>
    80000f5a:	02054163          	bltz	a0,80000f7c <proc_pagetable+0x76>
}
    80000f5e:	8526                	mv	a0,s1
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6902                	ld	s2,0(sp)
    80000f68:	6105                	addi	sp,sp,32
    80000f6a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6c:	4581                	li	a1,0
    80000f6e:	8526                	mv	a0,s1
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	a56080e7          	jalr	-1450(ra) # 800009c6 <uvmfree>
    return 0;
    80000f78:	4481                	li	s1,0
    80000f7a:	b7d5                	j	80000f5e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7c:	4681                	li	a3,0
    80000f7e:	4605                	li	a2,1
    80000f80:	040005b7          	lui	a1,0x4000
    80000f84:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f86:	05b2                	slli	a1,a1,0xc
    80000f88:	8526                	mv	a0,s1
    80000f8a:	fffff097          	auipc	ra,0xfffff
    80000f8e:	77c080e7          	jalr	1916(ra) # 80000706 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f92:	4581                	li	a1,0
    80000f94:	8526                	mv	a0,s1
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	a30080e7          	jalr	-1488(ra) # 800009c6 <uvmfree>
    return 0;
    80000f9e:	4481                	li	s1,0
    80000fa0:	bf7d                	j	80000f5e <proc_pagetable+0x58>

0000000080000fa2 <proc_freepagetable>:
{
    80000fa2:	1101                	addi	sp,sp,-32
    80000fa4:	ec06                	sd	ra,24(sp)
    80000fa6:	e822                	sd	s0,16(sp)
    80000fa8:	e426                	sd	s1,8(sp)
    80000faa:	e04a                	sd	s2,0(sp)
    80000fac:	1000                	addi	s0,sp,32
    80000fae:	84aa                	mv	s1,a0
    80000fb0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb2:	4681                	li	a3,0
    80000fb4:	4605                	li	a2,1
    80000fb6:	040005b7          	lui	a1,0x4000
    80000fba:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fbc:	05b2                	slli	a1,a1,0xc
    80000fbe:	fffff097          	auipc	ra,0xfffff
    80000fc2:	748080e7          	jalr	1864(ra) # 80000706 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc6:	4681                	li	a3,0
    80000fc8:	4605                	li	a2,1
    80000fca:	020005b7          	lui	a1,0x2000
    80000fce:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd0:	05b6                	slli	a1,a1,0xd
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	732080e7          	jalr	1842(ra) # 80000706 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fdc:	85ca                	mv	a1,s2
    80000fde:	8526                	mv	a0,s1
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	9e6080e7          	jalr	-1562(ra) # 800009c6 <uvmfree>
}
    80000fe8:	60e2                	ld	ra,24(sp)
    80000fea:	6442                	ld	s0,16(sp)
    80000fec:	64a2                	ld	s1,8(sp)
    80000fee:	6902                	ld	s2,0(sp)
    80000ff0:	6105                	addi	sp,sp,32
    80000ff2:	8082                	ret

0000000080000ff4 <freeproc>:
{
    80000ff4:	1101                	addi	sp,sp,-32
    80000ff6:	ec06                	sd	ra,24(sp)
    80000ff8:	e822                	sd	s0,16(sp)
    80000ffa:	e426                	sd	s1,8(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001000:	6d28                	ld	a0,88(a0)
    80001002:	c509                	beqz	a0,8000100c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001004:	fffff097          	auipc	ra,0xfffff
    80001008:	018080e7          	jalr	24(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001010:	68a8                	ld	a0,80(s1)
    80001012:	c511                	beqz	a0,8000101e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001014:	64ac                	ld	a1,72(s1)
    80001016:	00000097          	auipc	ra,0x0
    8000101a:	f8c080e7          	jalr	-116(ra) # 80000fa2 <proc_freepagetable>
  p->pagetable = 0;
    8000101e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001022:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001026:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000102e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001032:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001036:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000103e:	0004ac23          	sw	zero,24(s1)
}
    80001042:	60e2                	ld	ra,24(sp)
    80001044:	6442                	ld	s0,16(sp)
    80001046:	64a2                	ld	s1,8(sp)
    80001048:	6105                	addi	sp,sp,32
    8000104a:	8082                	ret

000000008000104c <allocproc>:
{
    8000104c:	1101                	addi	sp,sp,-32
    8000104e:	ec06                	sd	ra,24(sp)
    80001050:	e822                	sd	s0,16(sp)
    80001052:	e426                	sd	s1,8(sp)
    80001054:	e04a                	sd	s2,0(sp)
    80001056:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001058:	00008497          	auipc	s1,0x8
    8000105c:	42848493          	addi	s1,s1,1064 # 80009480 <proc>
    80001060:	00013917          	auipc	s2,0x13
    80001064:	c2090913          	addi	s2,s2,-992 # 80013c80 <tickslock>
    acquire(&p->lock);
    80001068:	8526                	mv	a0,s1
    8000106a:	00005097          	auipc	ra,0x5
    8000106e:	126080e7          	jalr	294(ra) # 80006190 <acquire>
    if(p->state == UNUSED) {
    80001072:	4c9c                	lw	a5,24(s1)
    80001074:	cf81                	beqz	a5,8000108c <allocproc+0x40>
      release(&p->lock);
    80001076:	8526                	mv	a0,s1
    80001078:	00005097          	auipc	ra,0x5
    8000107c:	1cc080e7          	jalr	460(ra) # 80006244 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001080:	2a048493          	addi	s1,s1,672
    80001084:	ff2492e3          	bne	s1,s2,80001068 <allocproc+0x1c>
  return 0;
    80001088:	4481                	li	s1,0
    8000108a:	a085                	j	800010ea <allocproc+0x9e>
  p->pid = allocpid();
    8000108c:	00000097          	auipc	ra,0x0
    80001090:	e34080e7          	jalr	-460(ra) # 80000ec0 <allocpid>
    80001094:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001096:	4785                	li	a5,1
    80001098:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000109a:	fffff097          	auipc	ra,0xfffff
    8000109e:	07e080e7          	jalr	126(ra) # 80000118 <kalloc>
    800010a2:	892a                	mv	s2,a0
    800010a4:	eca8                	sd	a0,88(s1)
    800010a6:	c929                	beqz	a0,800010f8 <allocproc+0xac>
  p->pagetable = proc_pagetable(p);
    800010a8:	8526                	mv	a0,s1
    800010aa:	00000097          	auipc	ra,0x0
    800010ae:	e5c080e7          	jalr	-420(ra) # 80000f06 <proc_pagetable>
    800010b2:	892a                	mv	s2,a0
    800010b4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010b6:	cd29                	beqz	a0,80001110 <allocproc+0xc4>
  memset(&p->context, 0, sizeof(p->context));
    800010b8:	07000613          	li	a2,112
    800010bc:	4581                	li	a1,0
    800010be:	06048513          	addi	a0,s1,96
    800010c2:	fffff097          	auipc	ra,0xfffff
    800010c6:	0b6080e7          	jalr	182(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010ca:	00000797          	auipc	a5,0x0
    800010ce:	db078793          	addi	a5,a5,-592 # 80000e7a <forkret>
    800010d2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010d4:	60bc                	ld	a5,64(s1)
    800010d6:	6705                	lui	a4,0x1
    800010d8:	97ba                	add	a5,a5,a4
    800010da:	f4bc                	sd	a5,104(s1)
  p->alarmticks = 0;
    800010dc:	1604a623          	sw	zero,364(s1)
  p->alarminterval = 0;
    800010e0:	1604a423          	sw	zero,360(s1)
  p->sigreturned = 1;
    800010e4:	4785                	li	a5,1
    800010e6:	28f4ac23          	sw	a5,664(s1)
}
    800010ea:	8526                	mv	a0,s1
    800010ec:	60e2                	ld	ra,24(sp)
    800010ee:	6442                	ld	s0,16(sp)
    800010f0:	64a2                	ld	s1,8(sp)
    800010f2:	6902                	ld	s2,0(sp)
    800010f4:	6105                	addi	sp,sp,32
    800010f6:	8082                	ret
    freeproc(p);
    800010f8:	8526                	mv	a0,s1
    800010fa:	00000097          	auipc	ra,0x0
    800010fe:	efa080e7          	jalr	-262(ra) # 80000ff4 <freeproc>
    release(&p->lock);
    80001102:	8526                	mv	a0,s1
    80001104:	00005097          	auipc	ra,0x5
    80001108:	140080e7          	jalr	320(ra) # 80006244 <release>
    return 0;
    8000110c:	84ca                	mv	s1,s2
    8000110e:	bff1                	j	800010ea <allocproc+0x9e>
    freeproc(p);
    80001110:	8526                	mv	a0,s1
    80001112:	00000097          	auipc	ra,0x0
    80001116:	ee2080e7          	jalr	-286(ra) # 80000ff4 <freeproc>
    release(&p->lock);
    8000111a:	8526                	mv	a0,s1
    8000111c:	00005097          	auipc	ra,0x5
    80001120:	128080e7          	jalr	296(ra) # 80006244 <release>
    return 0;
    80001124:	84ca                	mv	s1,s2
    80001126:	b7d1                	j	800010ea <allocproc+0x9e>

0000000080001128 <userinit>:
{
    80001128:	1101                	addi	sp,sp,-32
    8000112a:	ec06                	sd	ra,24(sp)
    8000112c:	e822                	sd	s0,16(sp)
    8000112e:	e426                	sd	s1,8(sp)
    80001130:	1000                	addi	s0,sp,32
  p = allocproc();
    80001132:	00000097          	auipc	ra,0x0
    80001136:	f1a080e7          	jalr	-230(ra) # 8000104c <allocproc>
    8000113a:	84aa                	mv	s1,a0
  initproc = p;
    8000113c:	00008797          	auipc	a5,0x8
    80001140:	eca7ba23          	sd	a0,-300(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001144:	03400613          	li	a2,52
    80001148:	00007597          	auipc	a1,0x7
    8000114c:	70858593          	addi	a1,a1,1800 # 80008850 <initcode>
    80001150:	6928                	ld	a0,80(a0)
    80001152:	fffff097          	auipc	ra,0xfffff
    80001156:	6a6080e7          	jalr	1702(ra) # 800007f8 <uvminit>
  p->sz = PGSIZE;
    8000115a:	6785                	lui	a5,0x1
    8000115c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000115e:	6cb8                	ld	a4,88(s1)
    80001160:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001164:	6cb8                	ld	a4,88(s1)
    80001166:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001168:	4641                	li	a2,16
    8000116a:	00007597          	auipc	a1,0x7
    8000116e:	02658593          	addi	a1,a1,38 # 80008190 <etext+0x190>
    80001172:	15848513          	addi	a0,s1,344
    80001176:	fffff097          	auipc	ra,0xfffff
    8000117a:	14c080e7          	jalr	332(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    8000117e:	00007517          	auipc	a0,0x7
    80001182:	02250513          	addi	a0,a0,34 # 800081a0 <etext+0x1a0>
    80001186:	00002097          	auipc	ra,0x2
    8000118a:	1c2080e7          	jalr	450(ra) # 80003348 <namei>
    8000118e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001192:	478d                	li	a5,3
    80001194:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001196:	8526                	mv	a0,s1
    80001198:	00005097          	auipc	ra,0x5
    8000119c:	0ac080e7          	jalr	172(ra) # 80006244 <release>
}
    800011a0:	60e2                	ld	ra,24(sp)
    800011a2:	6442                	ld	s0,16(sp)
    800011a4:	64a2                	ld	s1,8(sp)
    800011a6:	6105                	addi	sp,sp,32
    800011a8:	8082                	ret

00000000800011aa <growproc>:
{
    800011aa:	1101                	addi	sp,sp,-32
    800011ac:	ec06                	sd	ra,24(sp)
    800011ae:	e822                	sd	s0,16(sp)
    800011b0:	e426                	sd	s1,8(sp)
    800011b2:	e04a                	sd	s2,0(sp)
    800011b4:	1000                	addi	s0,sp,32
    800011b6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011b8:	00000097          	auipc	ra,0x0
    800011bc:	c8a080e7          	jalr	-886(ra) # 80000e42 <myproc>
    800011c0:	892a                	mv	s2,a0
  sz = p->sz;
    800011c2:	652c                	ld	a1,72(a0)
    800011c4:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011c8:	00904f63          	bgtz	s1,800011e6 <growproc+0x3c>
  } else if(n < 0){
    800011cc:	0204cc63          	bltz	s1,80001204 <growproc+0x5a>
  p->sz = sz;
    800011d0:	1602                	slli	a2,a2,0x20
    800011d2:	9201                	srli	a2,a2,0x20
    800011d4:	04c93423          	sd	a2,72(s2)
  return 0;
    800011d8:	4501                	li	a0,0
}
    800011da:	60e2                	ld	ra,24(sp)
    800011dc:	6442                	ld	s0,16(sp)
    800011de:	64a2                	ld	s1,8(sp)
    800011e0:	6902                	ld	s2,0(sp)
    800011e2:	6105                	addi	sp,sp,32
    800011e4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011e6:	9e25                	addw	a2,a2,s1
    800011e8:	1602                	slli	a2,a2,0x20
    800011ea:	9201                	srli	a2,a2,0x20
    800011ec:	1582                	slli	a1,a1,0x20
    800011ee:	9181                	srli	a1,a1,0x20
    800011f0:	6928                	ld	a0,80(a0)
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	6c0080e7          	jalr	1728(ra) # 800008b2 <uvmalloc>
    800011fa:	0005061b          	sext.w	a2,a0
    800011fe:	fa69                	bnez	a2,800011d0 <growproc+0x26>
      return -1;
    80001200:	557d                	li	a0,-1
    80001202:	bfe1                	j	800011da <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001204:	9e25                	addw	a2,a2,s1
    80001206:	1602                	slli	a2,a2,0x20
    80001208:	9201                	srli	a2,a2,0x20
    8000120a:	1582                	slli	a1,a1,0x20
    8000120c:	9181                	srli	a1,a1,0x20
    8000120e:	6928                	ld	a0,80(a0)
    80001210:	fffff097          	auipc	ra,0xfffff
    80001214:	65a080e7          	jalr	1626(ra) # 8000086a <uvmdealloc>
    80001218:	0005061b          	sext.w	a2,a0
    8000121c:	bf55                	j	800011d0 <growproc+0x26>

000000008000121e <fork>:
{
    8000121e:	7139                	addi	sp,sp,-64
    80001220:	fc06                	sd	ra,56(sp)
    80001222:	f822                	sd	s0,48(sp)
    80001224:	f426                	sd	s1,40(sp)
    80001226:	f04a                	sd	s2,32(sp)
    80001228:	ec4e                	sd	s3,24(sp)
    8000122a:	e852                	sd	s4,16(sp)
    8000122c:	e456                	sd	s5,8(sp)
    8000122e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001230:	00000097          	auipc	ra,0x0
    80001234:	c12080e7          	jalr	-1006(ra) # 80000e42 <myproc>
    80001238:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000123a:	00000097          	auipc	ra,0x0
    8000123e:	e12080e7          	jalr	-494(ra) # 8000104c <allocproc>
    80001242:	10050c63          	beqz	a0,8000135a <fork+0x13c>
    80001246:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001248:	048ab603          	ld	a2,72(s5)
    8000124c:	692c                	ld	a1,80(a0)
    8000124e:	050ab503          	ld	a0,80(s5)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	7ac080e7          	jalr	1964(ra) # 800009fe <uvmcopy>
    8000125a:	04054863          	bltz	a0,800012aa <fork+0x8c>
  np->sz = p->sz;
    8000125e:	048ab783          	ld	a5,72(s5)
    80001262:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001266:	058ab683          	ld	a3,88(s5)
    8000126a:	87b6                	mv	a5,a3
    8000126c:	058a3703          	ld	a4,88(s4)
    80001270:	12068693          	addi	a3,a3,288
    80001274:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001278:	6788                	ld	a0,8(a5)
    8000127a:	6b8c                	ld	a1,16(a5)
    8000127c:	6f90                	ld	a2,24(a5)
    8000127e:	01073023          	sd	a6,0(a4)
    80001282:	e708                	sd	a0,8(a4)
    80001284:	eb0c                	sd	a1,16(a4)
    80001286:	ef10                	sd	a2,24(a4)
    80001288:	02078793          	addi	a5,a5,32
    8000128c:	02070713          	addi	a4,a4,32
    80001290:	fed792e3          	bne	a5,a3,80001274 <fork+0x56>
  np->trapframe->a0 = 0;
    80001294:	058a3783          	ld	a5,88(s4)
    80001298:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000129c:	0d0a8493          	addi	s1,s5,208
    800012a0:	0d0a0913          	addi	s2,s4,208
    800012a4:	150a8993          	addi	s3,s5,336
    800012a8:	a00d                	j	800012ca <fork+0xac>
    freeproc(np);
    800012aa:	8552                	mv	a0,s4
    800012ac:	00000097          	auipc	ra,0x0
    800012b0:	d48080e7          	jalr	-696(ra) # 80000ff4 <freeproc>
    release(&np->lock);
    800012b4:	8552                	mv	a0,s4
    800012b6:	00005097          	auipc	ra,0x5
    800012ba:	f8e080e7          	jalr	-114(ra) # 80006244 <release>
    return -1;
    800012be:	597d                	li	s2,-1
    800012c0:	a059                	j	80001346 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012c2:	04a1                	addi	s1,s1,8
    800012c4:	0921                	addi	s2,s2,8
    800012c6:	01348b63          	beq	s1,s3,800012dc <fork+0xbe>
    if(p->ofile[i])
    800012ca:	6088                	ld	a0,0(s1)
    800012cc:	d97d                	beqz	a0,800012c2 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ce:	00002097          	auipc	ra,0x2
    800012d2:	710080e7          	jalr	1808(ra) # 800039de <filedup>
    800012d6:	00a93023          	sd	a0,0(s2)
    800012da:	b7e5                	j	800012c2 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012dc:	150ab503          	ld	a0,336(s5)
    800012e0:	00002097          	auipc	ra,0x2
    800012e4:	874080e7          	jalr	-1932(ra) # 80002b54 <idup>
    800012e8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012ec:	4641                	li	a2,16
    800012ee:	158a8593          	addi	a1,s5,344
    800012f2:	158a0513          	addi	a0,s4,344
    800012f6:	fffff097          	auipc	ra,0xfffff
    800012fa:	fcc080e7          	jalr	-52(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012fe:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001302:	8552                	mv	a0,s4
    80001304:	00005097          	auipc	ra,0x5
    80001308:	f40080e7          	jalr	-192(ra) # 80006244 <release>
  acquire(&wait_lock);
    8000130c:	00008497          	auipc	s1,0x8
    80001310:	d5c48493          	addi	s1,s1,-676 # 80009068 <wait_lock>
    80001314:	8526                	mv	a0,s1
    80001316:	00005097          	auipc	ra,0x5
    8000131a:	e7a080e7          	jalr	-390(ra) # 80006190 <acquire>
  np->parent = p;
    8000131e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001322:	8526                	mv	a0,s1
    80001324:	00005097          	auipc	ra,0x5
    80001328:	f20080e7          	jalr	-224(ra) # 80006244 <release>
  acquire(&np->lock);
    8000132c:	8552                	mv	a0,s4
    8000132e:	00005097          	auipc	ra,0x5
    80001332:	e62080e7          	jalr	-414(ra) # 80006190 <acquire>
  np->state = RUNNABLE;
    80001336:	478d                	li	a5,3
    80001338:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000133c:	8552                	mv	a0,s4
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	f06080e7          	jalr	-250(ra) # 80006244 <release>
}
    80001346:	854a                	mv	a0,s2
    80001348:	70e2                	ld	ra,56(sp)
    8000134a:	7442                	ld	s0,48(sp)
    8000134c:	74a2                	ld	s1,40(sp)
    8000134e:	7902                	ld	s2,32(sp)
    80001350:	69e2                	ld	s3,24(sp)
    80001352:	6a42                	ld	s4,16(sp)
    80001354:	6aa2                	ld	s5,8(sp)
    80001356:	6121                	addi	sp,sp,64
    80001358:	8082                	ret
    return -1;
    8000135a:	597d                	li	s2,-1
    8000135c:	b7ed                	j	80001346 <fork+0x128>

000000008000135e <scheduler>:
{
    8000135e:	7139                	addi	sp,sp,-64
    80001360:	fc06                	sd	ra,56(sp)
    80001362:	f822                	sd	s0,48(sp)
    80001364:	f426                	sd	s1,40(sp)
    80001366:	f04a                	sd	s2,32(sp)
    80001368:	ec4e                	sd	s3,24(sp)
    8000136a:	e852                	sd	s4,16(sp)
    8000136c:	e456                	sd	s5,8(sp)
    8000136e:	e05a                	sd	s6,0(sp)
    80001370:	0080                	addi	s0,sp,64
    80001372:	8792                	mv	a5,tp
  int id = r_tp();
    80001374:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001376:	00779a93          	slli	s5,a5,0x7
    8000137a:	00008717          	auipc	a4,0x8
    8000137e:	cd670713          	addi	a4,a4,-810 # 80009050 <pid_lock>
    80001382:	9756                	add	a4,a4,s5
    80001384:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001388:	00008717          	auipc	a4,0x8
    8000138c:	d0070713          	addi	a4,a4,-768 # 80009088 <cpus+0x8>
    80001390:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001392:	498d                	li	s3,3
        p->state = RUNNING;
    80001394:	4b11                	li	s6,4
        c->proc = p;
    80001396:	079e                	slli	a5,a5,0x7
    80001398:	00008a17          	auipc	s4,0x8
    8000139c:	cb8a0a13          	addi	s4,s4,-840 # 80009050 <pid_lock>
    800013a0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013a2:	00013917          	auipc	s2,0x13
    800013a6:	8de90913          	addi	s2,s2,-1826 # 80013c80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013b2:	10079073          	csrw	sstatus,a5
    800013b6:	00008497          	auipc	s1,0x8
    800013ba:	0ca48493          	addi	s1,s1,202 # 80009480 <proc>
    800013be:	a811                	j	800013d2 <scheduler+0x74>
      release(&p->lock);
    800013c0:	8526                	mv	a0,s1
    800013c2:	00005097          	auipc	ra,0x5
    800013c6:	e82080e7          	jalr	-382(ra) # 80006244 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ca:	2a048493          	addi	s1,s1,672
    800013ce:	fd248ee3          	beq	s1,s2,800013aa <scheduler+0x4c>
      acquire(&p->lock);
    800013d2:	8526                	mv	a0,s1
    800013d4:	00005097          	auipc	ra,0x5
    800013d8:	dbc080e7          	jalr	-580(ra) # 80006190 <acquire>
      if(p->state == RUNNABLE) {
    800013dc:	4c9c                	lw	a5,24(s1)
    800013de:	ff3791e3          	bne	a5,s3,800013c0 <scheduler+0x62>
        p->state = RUNNING;
    800013e2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013e6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013ea:	06048593          	addi	a1,s1,96
    800013ee:	8556                	mv	a0,s5
    800013f0:	00000097          	auipc	ra,0x0
    800013f4:	61e080e7          	jalr	1566(ra) # 80001a0e <swtch>
        c->proc = 0;
    800013f8:	020a3823          	sd	zero,48(s4)
    800013fc:	b7d1                	j	800013c0 <scheduler+0x62>

00000000800013fe <sched>:
{
    800013fe:	7179                	addi	sp,sp,-48
    80001400:	f406                	sd	ra,40(sp)
    80001402:	f022                	sd	s0,32(sp)
    80001404:	ec26                	sd	s1,24(sp)
    80001406:	e84a                	sd	s2,16(sp)
    80001408:	e44e                	sd	s3,8(sp)
    8000140a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	a36080e7          	jalr	-1482(ra) # 80000e42 <myproc>
    80001414:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001416:	00005097          	auipc	ra,0x5
    8000141a:	d00080e7          	jalr	-768(ra) # 80006116 <holding>
    8000141e:	c93d                	beqz	a0,80001494 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001420:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001422:	2781                	sext.w	a5,a5
    80001424:	079e                	slli	a5,a5,0x7
    80001426:	00008717          	auipc	a4,0x8
    8000142a:	c2a70713          	addi	a4,a4,-982 # 80009050 <pid_lock>
    8000142e:	97ba                	add	a5,a5,a4
    80001430:	0a87a703          	lw	a4,168(a5)
    80001434:	4785                	li	a5,1
    80001436:	06f71763          	bne	a4,a5,800014a4 <sched+0xa6>
  if(p->state == RUNNING)
    8000143a:	4c98                	lw	a4,24(s1)
    8000143c:	4791                	li	a5,4
    8000143e:	06f70b63          	beq	a4,a5,800014b4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001442:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001446:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001448:	efb5                	bnez	a5,800014c4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000144c:	00008917          	auipc	s2,0x8
    80001450:	c0490913          	addi	s2,s2,-1020 # 80009050 <pid_lock>
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	97ca                	add	a5,a5,s2
    8000145a:	0ac7a983          	lw	s3,172(a5)
    8000145e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001460:	2781                	sext.w	a5,a5
    80001462:	079e                	slli	a5,a5,0x7
    80001464:	00008597          	auipc	a1,0x8
    80001468:	c2458593          	addi	a1,a1,-988 # 80009088 <cpus+0x8>
    8000146c:	95be                	add	a1,a1,a5
    8000146e:	06048513          	addi	a0,s1,96
    80001472:	00000097          	auipc	ra,0x0
    80001476:	59c080e7          	jalr	1436(ra) # 80001a0e <swtch>
    8000147a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000147c:	2781                	sext.w	a5,a5
    8000147e:	079e                	slli	a5,a5,0x7
    80001480:	97ca                	add	a5,a5,s2
    80001482:	0b37a623          	sw	s3,172(a5)
}
    80001486:	70a2                	ld	ra,40(sp)
    80001488:	7402                	ld	s0,32(sp)
    8000148a:	64e2                	ld	s1,24(sp)
    8000148c:	6942                	ld	s2,16(sp)
    8000148e:	69a2                	ld	s3,8(sp)
    80001490:	6145                	addi	sp,sp,48
    80001492:	8082                	ret
    panic("sched p->lock");
    80001494:	00007517          	auipc	a0,0x7
    80001498:	d1450513          	addi	a0,a0,-748 # 800081a8 <etext+0x1a8>
    8000149c:	00004097          	auipc	ra,0x4
    800014a0:	7e2080e7          	jalr	2018(ra) # 80005c7e <panic>
    panic("sched locks");
    800014a4:	00007517          	auipc	a0,0x7
    800014a8:	d1450513          	addi	a0,a0,-748 # 800081b8 <etext+0x1b8>
    800014ac:	00004097          	auipc	ra,0x4
    800014b0:	7d2080e7          	jalr	2002(ra) # 80005c7e <panic>
    panic("sched running");
    800014b4:	00007517          	auipc	a0,0x7
    800014b8:	d1450513          	addi	a0,a0,-748 # 800081c8 <etext+0x1c8>
    800014bc:	00004097          	auipc	ra,0x4
    800014c0:	7c2080e7          	jalr	1986(ra) # 80005c7e <panic>
    panic("sched interruptible");
    800014c4:	00007517          	auipc	a0,0x7
    800014c8:	d1450513          	addi	a0,a0,-748 # 800081d8 <etext+0x1d8>
    800014cc:	00004097          	auipc	ra,0x4
    800014d0:	7b2080e7          	jalr	1970(ra) # 80005c7e <panic>

00000000800014d4 <yield>:
{
    800014d4:	1101                	addi	sp,sp,-32
    800014d6:	ec06                	sd	ra,24(sp)
    800014d8:	e822                	sd	s0,16(sp)
    800014da:	e426                	sd	s1,8(sp)
    800014dc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	964080e7          	jalr	-1692(ra) # 80000e42 <myproc>
    800014e6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	ca8080e7          	jalr	-856(ra) # 80006190 <acquire>
  p->state = RUNNABLE;
    800014f0:	478d                	li	a5,3
    800014f2:	cc9c                	sw	a5,24(s1)
  sched();
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	f0a080e7          	jalr	-246(ra) # 800013fe <sched>
  release(&p->lock);
    800014fc:	8526                	mv	a0,s1
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	d46080e7          	jalr	-698(ra) # 80006244 <release>
}
    80001506:	60e2                	ld	ra,24(sp)
    80001508:	6442                	ld	s0,16(sp)
    8000150a:	64a2                	ld	s1,8(sp)
    8000150c:	6105                	addi	sp,sp,32
    8000150e:	8082                	ret

0000000080001510 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001510:	7179                	addi	sp,sp,-48
    80001512:	f406                	sd	ra,40(sp)
    80001514:	f022                	sd	s0,32(sp)
    80001516:	ec26                	sd	s1,24(sp)
    80001518:	e84a                	sd	s2,16(sp)
    8000151a:	e44e                	sd	s3,8(sp)
    8000151c:	1800                	addi	s0,sp,48
    8000151e:	89aa                	mv	s3,a0
    80001520:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001522:	00000097          	auipc	ra,0x0
    80001526:	920080e7          	jalr	-1760(ra) # 80000e42 <myproc>
    8000152a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	c64080e7          	jalr	-924(ra) # 80006190 <acquire>
  release(lk);
    80001534:	854a                	mv	a0,s2
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	d0e080e7          	jalr	-754(ra) # 80006244 <release>

  // Go to sleep.
  p->chan = chan;
    8000153e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001542:	4789                	li	a5,2
    80001544:	cc9c                	sw	a5,24(s1)

  sched();
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	eb8080e7          	jalr	-328(ra) # 800013fe <sched>

  // Tidy up.
  p->chan = 0;
    8000154e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001552:	8526                	mv	a0,s1
    80001554:	00005097          	auipc	ra,0x5
    80001558:	cf0080e7          	jalr	-784(ra) # 80006244 <release>
  acquire(lk);
    8000155c:	854a                	mv	a0,s2
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	c32080e7          	jalr	-974(ra) # 80006190 <acquire>
}
    80001566:	70a2                	ld	ra,40(sp)
    80001568:	7402                	ld	s0,32(sp)
    8000156a:	64e2                	ld	s1,24(sp)
    8000156c:	6942                	ld	s2,16(sp)
    8000156e:	69a2                	ld	s3,8(sp)
    80001570:	6145                	addi	sp,sp,48
    80001572:	8082                	ret

0000000080001574 <wait>:
{
    80001574:	715d                	addi	sp,sp,-80
    80001576:	e486                	sd	ra,72(sp)
    80001578:	e0a2                	sd	s0,64(sp)
    8000157a:	fc26                	sd	s1,56(sp)
    8000157c:	f84a                	sd	s2,48(sp)
    8000157e:	f44e                	sd	s3,40(sp)
    80001580:	f052                	sd	s4,32(sp)
    80001582:	ec56                	sd	s5,24(sp)
    80001584:	e85a                	sd	s6,16(sp)
    80001586:	e45e                	sd	s7,8(sp)
    80001588:	e062                	sd	s8,0(sp)
    8000158a:	0880                	addi	s0,sp,80
    8000158c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	8b4080e7          	jalr	-1868(ra) # 80000e42 <myproc>
    80001596:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001598:	00008517          	auipc	a0,0x8
    8000159c:	ad050513          	addi	a0,a0,-1328 # 80009068 <wait_lock>
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	bf0080e7          	jalr	-1040(ra) # 80006190 <acquire>
    havekids = 0;
    800015a8:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015aa:	4a15                	li	s4,5
        havekids = 1;
    800015ac:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015ae:	00012997          	auipc	s3,0x12
    800015b2:	6d298993          	addi	s3,s3,1746 # 80013c80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015b6:	00008c17          	auipc	s8,0x8
    800015ba:	ab2c0c13          	addi	s8,s8,-1358 # 80009068 <wait_lock>
    havekids = 0;
    800015be:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015c0:	00008497          	auipc	s1,0x8
    800015c4:	ec048493          	addi	s1,s1,-320 # 80009480 <proc>
    800015c8:	a0bd                	j	80001636 <wait+0xc2>
          pid = np->pid;
    800015ca:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015ce:	000b0e63          	beqz	s6,800015ea <wait+0x76>
    800015d2:	4691                	li	a3,4
    800015d4:	02c48613          	addi	a2,s1,44
    800015d8:	85da                	mv	a1,s6
    800015da:	05093503          	ld	a0,80(s2)
    800015de:	fffff097          	auipc	ra,0xfffff
    800015e2:	524080e7          	jalr	1316(ra) # 80000b02 <copyout>
    800015e6:	02054563          	bltz	a0,80001610 <wait+0x9c>
          freeproc(np);
    800015ea:	8526                	mv	a0,s1
    800015ec:	00000097          	auipc	ra,0x0
    800015f0:	a08080e7          	jalr	-1528(ra) # 80000ff4 <freeproc>
          release(&np->lock);
    800015f4:	8526                	mv	a0,s1
    800015f6:	00005097          	auipc	ra,0x5
    800015fa:	c4e080e7          	jalr	-946(ra) # 80006244 <release>
          release(&wait_lock);
    800015fe:	00008517          	auipc	a0,0x8
    80001602:	a6a50513          	addi	a0,a0,-1430 # 80009068 <wait_lock>
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	c3e080e7          	jalr	-962(ra) # 80006244 <release>
          return pid;
    8000160e:	a09d                	j	80001674 <wait+0x100>
            release(&np->lock);
    80001610:	8526                	mv	a0,s1
    80001612:	00005097          	auipc	ra,0x5
    80001616:	c32080e7          	jalr	-974(ra) # 80006244 <release>
            release(&wait_lock);
    8000161a:	00008517          	auipc	a0,0x8
    8000161e:	a4e50513          	addi	a0,a0,-1458 # 80009068 <wait_lock>
    80001622:	00005097          	auipc	ra,0x5
    80001626:	c22080e7          	jalr	-990(ra) # 80006244 <release>
            return -1;
    8000162a:	59fd                	li	s3,-1
    8000162c:	a0a1                	j	80001674 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000162e:	2a048493          	addi	s1,s1,672
    80001632:	03348463          	beq	s1,s3,8000165a <wait+0xe6>
      if(np->parent == p){
    80001636:	7c9c                	ld	a5,56(s1)
    80001638:	ff279be3          	bne	a5,s2,8000162e <wait+0xba>
        acquire(&np->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	b52080e7          	jalr	-1198(ra) # 80006190 <acquire>
        if(np->state == ZOMBIE){
    80001646:	4c9c                	lw	a5,24(s1)
    80001648:	f94781e3          	beq	a5,s4,800015ca <wait+0x56>
        release(&np->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	bf6080e7          	jalr	-1034(ra) # 80006244 <release>
        havekids = 1;
    80001656:	8756                	mv	a4,s5
    80001658:	bfd9                	j	8000162e <wait+0xba>
    if(!havekids || p->killed){
    8000165a:	c701                	beqz	a4,80001662 <wait+0xee>
    8000165c:	02892783          	lw	a5,40(s2)
    80001660:	c79d                	beqz	a5,8000168e <wait+0x11a>
      release(&wait_lock);
    80001662:	00008517          	auipc	a0,0x8
    80001666:	a0650513          	addi	a0,a0,-1530 # 80009068 <wait_lock>
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	bda080e7          	jalr	-1062(ra) # 80006244 <release>
      return -1;
    80001672:	59fd                	li	s3,-1
}
    80001674:	854e                	mv	a0,s3
    80001676:	60a6                	ld	ra,72(sp)
    80001678:	6406                	ld	s0,64(sp)
    8000167a:	74e2                	ld	s1,56(sp)
    8000167c:	7942                	ld	s2,48(sp)
    8000167e:	79a2                	ld	s3,40(sp)
    80001680:	7a02                	ld	s4,32(sp)
    80001682:	6ae2                	ld	s5,24(sp)
    80001684:	6b42                	ld	s6,16(sp)
    80001686:	6ba2                	ld	s7,8(sp)
    80001688:	6c02                	ld	s8,0(sp)
    8000168a:	6161                	addi	sp,sp,80
    8000168c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000168e:	85e2                	mv	a1,s8
    80001690:	854a                	mv	a0,s2
    80001692:	00000097          	auipc	ra,0x0
    80001696:	e7e080e7          	jalr	-386(ra) # 80001510 <sleep>
    havekids = 0;
    8000169a:	b715                	j	800015be <wait+0x4a>

000000008000169c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000169c:	7139                	addi	sp,sp,-64
    8000169e:	fc06                	sd	ra,56(sp)
    800016a0:	f822                	sd	s0,48(sp)
    800016a2:	f426                	sd	s1,40(sp)
    800016a4:	f04a                	sd	s2,32(sp)
    800016a6:	ec4e                	sd	s3,24(sp)
    800016a8:	e852                	sd	s4,16(sp)
    800016aa:	e456                	sd	s5,8(sp)
    800016ac:	0080                	addi	s0,sp,64
    800016ae:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016b0:	00008497          	auipc	s1,0x8
    800016b4:	dd048493          	addi	s1,s1,-560 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016b8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ba:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016bc:	00012917          	auipc	s2,0x12
    800016c0:	5c490913          	addi	s2,s2,1476 # 80013c80 <tickslock>
    800016c4:	a811                	j	800016d8 <wakeup+0x3c>
      }
      release(&p->lock);
    800016c6:	8526                	mv	a0,s1
    800016c8:	00005097          	auipc	ra,0x5
    800016cc:	b7c080e7          	jalr	-1156(ra) # 80006244 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d0:	2a048493          	addi	s1,s1,672
    800016d4:	03248663          	beq	s1,s2,80001700 <wakeup+0x64>
    if(p != myproc()){
    800016d8:	fffff097          	auipc	ra,0xfffff
    800016dc:	76a080e7          	jalr	1898(ra) # 80000e42 <myproc>
    800016e0:	fea488e3          	beq	s1,a0,800016d0 <wakeup+0x34>
      acquire(&p->lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	aaa080e7          	jalr	-1366(ra) # 80006190 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016ee:	4c9c                	lw	a5,24(s1)
    800016f0:	fd379be3          	bne	a5,s3,800016c6 <wakeup+0x2a>
    800016f4:	709c                	ld	a5,32(s1)
    800016f6:	fd4798e3          	bne	a5,s4,800016c6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016fa:	0154ac23          	sw	s5,24(s1)
    800016fe:	b7e1                	j	800016c6 <wakeup+0x2a>
    }
  }
}
    80001700:	70e2                	ld	ra,56(sp)
    80001702:	7442                	ld	s0,48(sp)
    80001704:	74a2                	ld	s1,40(sp)
    80001706:	7902                	ld	s2,32(sp)
    80001708:	69e2                	ld	s3,24(sp)
    8000170a:	6a42                	ld	s4,16(sp)
    8000170c:	6aa2                	ld	s5,8(sp)
    8000170e:	6121                	addi	sp,sp,64
    80001710:	8082                	ret

0000000080001712 <reparent>:
{
    80001712:	7179                	addi	sp,sp,-48
    80001714:	f406                	sd	ra,40(sp)
    80001716:	f022                	sd	s0,32(sp)
    80001718:	ec26                	sd	s1,24(sp)
    8000171a:	e84a                	sd	s2,16(sp)
    8000171c:	e44e                	sd	s3,8(sp)
    8000171e:	e052                	sd	s4,0(sp)
    80001720:	1800                	addi	s0,sp,48
    80001722:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001724:	00008497          	auipc	s1,0x8
    80001728:	d5c48493          	addi	s1,s1,-676 # 80009480 <proc>
      pp->parent = initproc;
    8000172c:	00008a17          	auipc	s4,0x8
    80001730:	8e4a0a13          	addi	s4,s4,-1820 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001734:	00012997          	auipc	s3,0x12
    80001738:	54c98993          	addi	s3,s3,1356 # 80013c80 <tickslock>
    8000173c:	a029                	j	80001746 <reparent+0x34>
    8000173e:	2a048493          	addi	s1,s1,672
    80001742:	01348d63          	beq	s1,s3,8000175c <reparent+0x4a>
    if(pp->parent == p){
    80001746:	7c9c                	ld	a5,56(s1)
    80001748:	ff279be3          	bne	a5,s2,8000173e <reparent+0x2c>
      pp->parent = initproc;
    8000174c:	000a3503          	ld	a0,0(s4)
    80001750:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001752:	00000097          	auipc	ra,0x0
    80001756:	f4a080e7          	jalr	-182(ra) # 8000169c <wakeup>
    8000175a:	b7d5                	j	8000173e <reparent+0x2c>
}
    8000175c:	70a2                	ld	ra,40(sp)
    8000175e:	7402                	ld	s0,32(sp)
    80001760:	64e2                	ld	s1,24(sp)
    80001762:	6942                	ld	s2,16(sp)
    80001764:	69a2                	ld	s3,8(sp)
    80001766:	6a02                	ld	s4,0(sp)
    80001768:	6145                	addi	sp,sp,48
    8000176a:	8082                	ret

000000008000176c <exit>:
{
    8000176c:	7179                	addi	sp,sp,-48
    8000176e:	f406                	sd	ra,40(sp)
    80001770:	f022                	sd	s0,32(sp)
    80001772:	ec26                	sd	s1,24(sp)
    80001774:	e84a                	sd	s2,16(sp)
    80001776:	e44e                	sd	s3,8(sp)
    80001778:	e052                	sd	s4,0(sp)
    8000177a:	1800                	addi	s0,sp,48
    8000177c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000177e:	fffff097          	auipc	ra,0xfffff
    80001782:	6c4080e7          	jalr	1732(ra) # 80000e42 <myproc>
    80001786:	89aa                	mv	s3,a0
  if(p == initproc)
    80001788:	00008797          	auipc	a5,0x8
    8000178c:	8887b783          	ld	a5,-1912(a5) # 80009010 <initproc>
    80001790:	0d050493          	addi	s1,a0,208
    80001794:	15050913          	addi	s2,a0,336
    80001798:	02a79363          	bne	a5,a0,800017be <exit+0x52>
    panic("init exiting");
    8000179c:	00007517          	auipc	a0,0x7
    800017a0:	a5450513          	addi	a0,a0,-1452 # 800081f0 <etext+0x1f0>
    800017a4:	00004097          	auipc	ra,0x4
    800017a8:	4da080e7          	jalr	1242(ra) # 80005c7e <panic>
      fileclose(f);
    800017ac:	00002097          	auipc	ra,0x2
    800017b0:	284080e7          	jalr	644(ra) # 80003a30 <fileclose>
      p->ofile[fd] = 0;
    800017b4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017b8:	04a1                	addi	s1,s1,8
    800017ba:	01248563          	beq	s1,s2,800017c4 <exit+0x58>
    if(p->ofile[fd]){
    800017be:	6088                	ld	a0,0(s1)
    800017c0:	f575                	bnez	a0,800017ac <exit+0x40>
    800017c2:	bfdd                	j	800017b8 <exit+0x4c>
  begin_op();
    800017c4:	00002097          	auipc	ra,0x2
    800017c8:	da0080e7          	jalr	-608(ra) # 80003564 <begin_op>
  iput(p->cwd);
    800017cc:	1509b503          	ld	a0,336(s3)
    800017d0:	00001097          	auipc	ra,0x1
    800017d4:	57c080e7          	jalr	1404(ra) # 80002d4c <iput>
  end_op();
    800017d8:	00002097          	auipc	ra,0x2
    800017dc:	e0c080e7          	jalr	-500(ra) # 800035e4 <end_op>
  p->cwd = 0;
    800017e0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017e4:	00008497          	auipc	s1,0x8
    800017e8:	88448493          	addi	s1,s1,-1916 # 80009068 <wait_lock>
    800017ec:	8526                	mv	a0,s1
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	9a2080e7          	jalr	-1630(ra) # 80006190 <acquire>
  reparent(p);
    800017f6:	854e                	mv	a0,s3
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	f1a080e7          	jalr	-230(ra) # 80001712 <reparent>
  wakeup(p->parent);
    80001800:	0389b503          	ld	a0,56(s3)
    80001804:	00000097          	auipc	ra,0x0
    80001808:	e98080e7          	jalr	-360(ra) # 8000169c <wakeup>
  acquire(&p->lock);
    8000180c:	854e                	mv	a0,s3
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	982080e7          	jalr	-1662(ra) # 80006190 <acquire>
  p->xstate = status;
    80001816:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000181a:	4795                	li	a5,5
    8000181c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001820:	8526                	mv	a0,s1
    80001822:	00005097          	auipc	ra,0x5
    80001826:	a22080e7          	jalr	-1502(ra) # 80006244 <release>
  sched();
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	bd4080e7          	jalr	-1068(ra) # 800013fe <sched>
  panic("zombie exit");
    80001832:	00007517          	auipc	a0,0x7
    80001836:	9ce50513          	addi	a0,a0,-1586 # 80008200 <etext+0x200>
    8000183a:	00004097          	auipc	ra,0x4
    8000183e:	444080e7          	jalr	1092(ra) # 80005c7e <panic>

0000000080001842 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001842:	7179                	addi	sp,sp,-48
    80001844:	f406                	sd	ra,40(sp)
    80001846:	f022                	sd	s0,32(sp)
    80001848:	ec26                	sd	s1,24(sp)
    8000184a:	e84a                	sd	s2,16(sp)
    8000184c:	e44e                	sd	s3,8(sp)
    8000184e:	1800                	addi	s0,sp,48
    80001850:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001852:	00008497          	auipc	s1,0x8
    80001856:	c2e48493          	addi	s1,s1,-978 # 80009480 <proc>
    8000185a:	00012997          	auipc	s3,0x12
    8000185e:	42698993          	addi	s3,s3,1062 # 80013c80 <tickslock>
    acquire(&p->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	92c080e7          	jalr	-1748(ra) # 80006190 <acquire>
    if(p->pid == pid){
    8000186c:	589c                	lw	a5,48(s1)
    8000186e:	01278d63          	beq	a5,s2,80001888 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	9d0080e7          	jalr	-1584(ra) # 80006244 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000187c:	2a048493          	addi	s1,s1,672
    80001880:	ff3491e3          	bne	s1,s3,80001862 <kill+0x20>
  }
  return -1;
    80001884:	557d                	li	a0,-1
    80001886:	a829                	j	800018a0 <kill+0x5e>
      p->killed = 1;
    80001888:	4785                	li	a5,1
    8000188a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000188c:	4c98                	lw	a4,24(s1)
    8000188e:	4789                	li	a5,2
    80001890:	00f70f63          	beq	a4,a5,800018ae <kill+0x6c>
      release(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	9ae080e7          	jalr	-1618(ra) # 80006244 <release>
      return 0;
    8000189e:	4501                	li	a0,0
}
    800018a0:	70a2                	ld	ra,40(sp)
    800018a2:	7402                	ld	s0,32(sp)
    800018a4:	64e2                	ld	s1,24(sp)
    800018a6:	6942                	ld	s2,16(sp)
    800018a8:	69a2                	ld	s3,8(sp)
    800018aa:	6145                	addi	sp,sp,48
    800018ac:	8082                	ret
        p->state = RUNNABLE;
    800018ae:	478d                	li	a5,3
    800018b0:	cc9c                	sw	a5,24(s1)
    800018b2:	b7cd                	j	80001894 <kill+0x52>

00000000800018b4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018b4:	7179                	addi	sp,sp,-48
    800018b6:	f406                	sd	ra,40(sp)
    800018b8:	f022                	sd	s0,32(sp)
    800018ba:	ec26                	sd	s1,24(sp)
    800018bc:	e84a                	sd	s2,16(sp)
    800018be:	e44e                	sd	s3,8(sp)
    800018c0:	e052                	sd	s4,0(sp)
    800018c2:	1800                	addi	s0,sp,48
    800018c4:	84aa                	mv	s1,a0
    800018c6:	892e                	mv	s2,a1
    800018c8:	89b2                	mv	s3,a2
    800018ca:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018cc:	fffff097          	auipc	ra,0xfffff
    800018d0:	576080e7          	jalr	1398(ra) # 80000e42 <myproc>
  if(user_dst){
    800018d4:	c08d                	beqz	s1,800018f6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018d6:	86d2                	mv	a3,s4
    800018d8:	864e                	mv	a2,s3
    800018da:	85ca                	mv	a1,s2
    800018dc:	6928                	ld	a0,80(a0)
    800018de:	fffff097          	auipc	ra,0xfffff
    800018e2:	224080e7          	jalr	548(ra) # 80000b02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018e6:	70a2                	ld	ra,40(sp)
    800018e8:	7402                	ld	s0,32(sp)
    800018ea:	64e2                	ld	s1,24(sp)
    800018ec:	6942                	ld	s2,16(sp)
    800018ee:	69a2                	ld	s3,8(sp)
    800018f0:	6a02                	ld	s4,0(sp)
    800018f2:	6145                	addi	sp,sp,48
    800018f4:	8082                	ret
    memmove((char *)dst, src, len);
    800018f6:	000a061b          	sext.w	a2,s4
    800018fa:	85ce                	mv	a1,s3
    800018fc:	854a                	mv	a0,s2
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	8d6080e7          	jalr	-1834(ra) # 800001d4 <memmove>
    return 0;
    80001906:	8526                	mv	a0,s1
    80001908:	bff9                	j	800018e6 <either_copyout+0x32>

000000008000190a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000190a:	7179                	addi	sp,sp,-48
    8000190c:	f406                	sd	ra,40(sp)
    8000190e:	f022                	sd	s0,32(sp)
    80001910:	ec26                	sd	s1,24(sp)
    80001912:	e84a                	sd	s2,16(sp)
    80001914:	e44e                	sd	s3,8(sp)
    80001916:	e052                	sd	s4,0(sp)
    80001918:	1800                	addi	s0,sp,48
    8000191a:	892a                	mv	s2,a0
    8000191c:	84ae                	mv	s1,a1
    8000191e:	89b2                	mv	s3,a2
    80001920:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001922:	fffff097          	auipc	ra,0xfffff
    80001926:	520080e7          	jalr	1312(ra) # 80000e42 <myproc>
  if(user_src){
    8000192a:	c08d                	beqz	s1,8000194c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000192c:	86d2                	mv	a3,s4
    8000192e:	864e                	mv	a2,s3
    80001930:	85ca                	mv	a1,s2
    80001932:	6928                	ld	a0,80(a0)
    80001934:	fffff097          	auipc	ra,0xfffff
    80001938:	25a080e7          	jalr	602(ra) # 80000b8e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000193c:	70a2                	ld	ra,40(sp)
    8000193e:	7402                	ld	s0,32(sp)
    80001940:	64e2                	ld	s1,24(sp)
    80001942:	6942                	ld	s2,16(sp)
    80001944:	69a2                	ld	s3,8(sp)
    80001946:	6a02                	ld	s4,0(sp)
    80001948:	6145                	addi	sp,sp,48
    8000194a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000194c:	000a061b          	sext.w	a2,s4
    80001950:	85ce                	mv	a1,s3
    80001952:	854a                	mv	a0,s2
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	880080e7          	jalr	-1920(ra) # 800001d4 <memmove>
    return 0;
    8000195c:	8526                	mv	a0,s1
    8000195e:	bff9                	j	8000193c <either_copyin+0x32>

0000000080001960 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001960:	715d                	addi	sp,sp,-80
    80001962:	e486                	sd	ra,72(sp)
    80001964:	e0a2                	sd	s0,64(sp)
    80001966:	fc26                	sd	s1,56(sp)
    80001968:	f84a                	sd	s2,48(sp)
    8000196a:	f44e                	sd	s3,40(sp)
    8000196c:	f052                	sd	s4,32(sp)
    8000196e:	ec56                	sd	s5,24(sp)
    80001970:	e85a                	sd	s6,16(sp)
    80001972:	e45e                	sd	s7,8(sp)
    80001974:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001976:	00006517          	auipc	a0,0x6
    8000197a:	6b250513          	addi	a0,a0,1714 # 80008028 <etext+0x28>
    8000197e:	00004097          	auipc	ra,0x4
    80001982:	352080e7          	jalr	850(ra) # 80005cd0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001986:	00008497          	auipc	s1,0x8
    8000198a:	c5248493          	addi	s1,s1,-942 # 800095d8 <proc+0x158>
    8000198e:	00012917          	auipc	s2,0x12
    80001992:	44a90913          	addi	s2,s2,1098 # 80013dd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001996:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001998:	00007997          	auipc	s3,0x7
    8000199c:	87898993          	addi	s3,s3,-1928 # 80008210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    800019a0:	00007a97          	auipc	s5,0x7
    800019a4:	878a8a93          	addi	s5,s5,-1928 # 80008218 <etext+0x218>
    printf("\n");
    800019a8:	00006a17          	auipc	s4,0x6
    800019ac:	680a0a13          	addi	s4,s4,1664 # 80008028 <etext+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019b0:	00007b97          	auipc	s7,0x7
    800019b4:	d68b8b93          	addi	s7,s7,-664 # 80008718 <states.0>
    800019b8:	a00d                	j	800019da <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ba:	ed86a583          	lw	a1,-296(a3)
    800019be:	8556                	mv	a0,s5
    800019c0:	00004097          	auipc	ra,0x4
    800019c4:	310080e7          	jalr	784(ra) # 80005cd0 <printf>
    printf("\n");
    800019c8:	8552                	mv	a0,s4
    800019ca:	00004097          	auipc	ra,0x4
    800019ce:	306080e7          	jalr	774(ra) # 80005cd0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d2:	2a048493          	addi	s1,s1,672
    800019d6:	03248163          	beq	s1,s2,800019f8 <procdump+0x98>
    if(p->state == UNUSED)
    800019da:	86a6                	mv	a3,s1
    800019dc:	ec04a783          	lw	a5,-320(s1)
    800019e0:	dbed                	beqz	a5,800019d2 <procdump+0x72>
      state = "???";
    800019e2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e4:	fcfb6be3          	bltu	s6,a5,800019ba <procdump+0x5a>
    800019e8:	1782                	slli	a5,a5,0x20
    800019ea:	9381                	srli	a5,a5,0x20
    800019ec:	078e                	slli	a5,a5,0x3
    800019ee:	97de                	add	a5,a5,s7
    800019f0:	6390                	ld	a2,0(a5)
    800019f2:	f661                	bnez	a2,800019ba <procdump+0x5a>
      state = "???";
    800019f4:	864e                	mv	a2,s3
    800019f6:	b7d1                	j	800019ba <procdump+0x5a>
  }
}
    800019f8:	60a6                	ld	ra,72(sp)
    800019fa:	6406                	ld	s0,64(sp)
    800019fc:	74e2                	ld	s1,56(sp)
    800019fe:	7942                	ld	s2,48(sp)
    80001a00:	79a2                	ld	s3,40(sp)
    80001a02:	7a02                	ld	s4,32(sp)
    80001a04:	6ae2                	ld	s5,24(sp)
    80001a06:	6b42                	ld	s6,16(sp)
    80001a08:	6ba2                	ld	s7,8(sp)
    80001a0a:	6161                	addi	sp,sp,80
    80001a0c:	8082                	ret

0000000080001a0e <swtch>:
    80001a0e:	00153023          	sd	ra,0(a0)
    80001a12:	00253423          	sd	sp,8(a0)
    80001a16:	e900                	sd	s0,16(a0)
    80001a18:	ed04                	sd	s1,24(a0)
    80001a1a:	03253023          	sd	s2,32(a0)
    80001a1e:	03353423          	sd	s3,40(a0)
    80001a22:	03453823          	sd	s4,48(a0)
    80001a26:	03553c23          	sd	s5,56(a0)
    80001a2a:	05653023          	sd	s6,64(a0)
    80001a2e:	05753423          	sd	s7,72(a0)
    80001a32:	05853823          	sd	s8,80(a0)
    80001a36:	05953c23          	sd	s9,88(a0)
    80001a3a:	07a53023          	sd	s10,96(a0)
    80001a3e:	07b53423          	sd	s11,104(a0)
    80001a42:	0005b083          	ld	ra,0(a1)
    80001a46:	0085b103          	ld	sp,8(a1)
    80001a4a:	6980                	ld	s0,16(a1)
    80001a4c:	6d84                	ld	s1,24(a1)
    80001a4e:	0205b903          	ld	s2,32(a1)
    80001a52:	0285b983          	ld	s3,40(a1)
    80001a56:	0305ba03          	ld	s4,48(a1)
    80001a5a:	0385ba83          	ld	s5,56(a1)
    80001a5e:	0405bb03          	ld	s6,64(a1)
    80001a62:	0485bb83          	ld	s7,72(a1)
    80001a66:	0505bc03          	ld	s8,80(a1)
    80001a6a:	0585bc83          	ld	s9,88(a1)
    80001a6e:	0605bd03          	ld	s10,96(a1)
    80001a72:	0685bd83          	ld	s11,104(a1)
    80001a76:	8082                	ret

0000000080001a78 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a78:	1141                	addi	sp,sp,-16
    80001a7a:	e406                	sd	ra,8(sp)
    80001a7c:	e022                	sd	s0,0(sp)
    80001a7e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a80:	00006597          	auipc	a1,0x6
    80001a84:	7d058593          	addi	a1,a1,2000 # 80008250 <etext+0x250>
    80001a88:	00012517          	auipc	a0,0x12
    80001a8c:	1f850513          	addi	a0,a0,504 # 80013c80 <tickslock>
    80001a90:	00004097          	auipc	ra,0x4
    80001a94:	670080e7          	jalr	1648(ra) # 80006100 <initlock>
}
    80001a98:	60a2                	ld	ra,8(sp)
    80001a9a:	6402                	ld	s0,0(sp)
    80001a9c:	0141                	addi	sp,sp,16
    80001a9e:	8082                	ret

0000000080001aa0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aa0:	1141                	addi	sp,sp,-16
    80001aa2:	e422                	sd	s0,8(sp)
    80001aa4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa6:	00003797          	auipc	a5,0x3
    80001aaa:	5ba78793          	addi	a5,a5,1466 # 80005060 <kernelvec>
    80001aae:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ab2:	6422                	ld	s0,8(sp)
    80001ab4:	0141                	addi	sp,sp,16
    80001ab6:	8082                	ret

0000000080001ab8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ab8:	1141                	addi	sp,sp,-16
    80001aba:	e406                	sd	ra,8(sp)
    80001abc:	e022                	sd	s0,0(sp)
    80001abe:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ac0:	fffff097          	auipc	ra,0xfffff
    80001ac4:	382080e7          	jalr	898(ra) # 80000e42 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001acc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ace:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ad2:	00005617          	auipc	a2,0x5
    80001ad6:	52e60613          	addi	a2,a2,1326 # 80007000 <_trampoline>
    80001ada:	00005697          	auipc	a3,0x5
    80001ade:	52668693          	addi	a3,a3,1318 # 80007000 <_trampoline>
    80001ae2:	8e91                	sub	a3,a3,a2
    80001ae4:	040007b7          	lui	a5,0x4000
    80001ae8:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001aea:	07b2                	slli	a5,a5,0xc
    80001aec:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aee:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001af2:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001af4:	180026f3          	csrr	a3,satp
    80001af8:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001afa:	6d38                	ld	a4,88(a0)
    80001afc:	6134                	ld	a3,64(a0)
    80001afe:	6585                	lui	a1,0x1
    80001b00:	96ae                	add	a3,a3,a1
    80001b02:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b04:	6d38                	ld	a4,88(a0)
    80001b06:	00000697          	auipc	a3,0x0
    80001b0a:	13868693          	addi	a3,a3,312 # 80001c3e <usertrap>
    80001b0e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b10:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b12:	8692                	mv	a3,tp
    80001b14:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b16:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b1a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b1e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b22:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b26:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b28:	6f18                	ld	a4,24(a4)
    80001b2a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b2e:	692c                	ld	a1,80(a0)
    80001b30:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b32:	00005717          	auipc	a4,0x5
    80001b36:	55e70713          	addi	a4,a4,1374 # 80007090 <userret>
    80001b3a:	8f11                	sub	a4,a4,a2
    80001b3c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b3e:	577d                	li	a4,-1
    80001b40:	177e                	slli	a4,a4,0x3f
    80001b42:	8dd9                	or	a1,a1,a4
    80001b44:	02000537          	lui	a0,0x2000
    80001b48:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b4a:	0536                	slli	a0,a0,0xd
    80001b4c:	9782                	jalr	a5
}
    80001b4e:	60a2                	ld	ra,8(sp)
    80001b50:	6402                	ld	s0,0(sp)
    80001b52:	0141                	addi	sp,sp,16
    80001b54:	8082                	ret

0000000080001b56 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b56:	1101                	addi	sp,sp,-32
    80001b58:	ec06                	sd	ra,24(sp)
    80001b5a:	e822                	sd	s0,16(sp)
    80001b5c:	e426                	sd	s1,8(sp)
    80001b5e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b60:	00012497          	auipc	s1,0x12
    80001b64:	12048493          	addi	s1,s1,288 # 80013c80 <tickslock>
    80001b68:	8526                	mv	a0,s1
    80001b6a:	00004097          	auipc	ra,0x4
    80001b6e:	626080e7          	jalr	1574(ra) # 80006190 <acquire>
  ticks++;
    80001b72:	00007517          	auipc	a0,0x7
    80001b76:	4a650513          	addi	a0,a0,1190 # 80009018 <ticks>
    80001b7a:	411c                	lw	a5,0(a0)
    80001b7c:	2785                	addiw	a5,a5,1
    80001b7e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b80:	00000097          	auipc	ra,0x0
    80001b84:	b1c080e7          	jalr	-1252(ra) # 8000169c <wakeup>
  release(&tickslock);
    80001b88:	8526                	mv	a0,s1
    80001b8a:	00004097          	auipc	ra,0x4
    80001b8e:	6ba080e7          	jalr	1722(ra) # 80006244 <release>
}
    80001b92:	60e2                	ld	ra,24(sp)
    80001b94:	6442                	ld	s0,16(sp)
    80001b96:	64a2                	ld	s1,8(sp)
    80001b98:	6105                	addi	sp,sp,32
    80001b9a:	8082                	ret

0000000080001b9c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b9c:	1101                	addi	sp,sp,-32
    80001b9e:	ec06                	sd	ra,24(sp)
    80001ba0:	e822                	sd	s0,16(sp)
    80001ba2:	e426                	sd	s1,8(sp)
    80001ba4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001baa:	00074d63          	bltz	a4,80001bc4 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bae:	57fd                	li	a5,-1
    80001bb0:	17fe                	slli	a5,a5,0x3f
    80001bb2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bb4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bb6:	06f70363          	beq	a4,a5,80001c1c <devintr+0x80>
  }
}
    80001bba:	60e2                	ld	ra,24(sp)
    80001bbc:	6442                	ld	s0,16(sp)
    80001bbe:	64a2                	ld	s1,8(sp)
    80001bc0:	6105                	addi	sp,sp,32
    80001bc2:	8082                	ret
     (scause & 0xff) == 9){
    80001bc4:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001bc8:	46a5                	li	a3,9
    80001bca:	fed792e3          	bne	a5,a3,80001bae <devintr+0x12>
    int irq = plic_claim();
    80001bce:	00003097          	auipc	ra,0x3
    80001bd2:	59a080e7          	jalr	1434(ra) # 80005168 <plic_claim>
    80001bd6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bd8:	47a9                	li	a5,10
    80001bda:	02f50763          	beq	a0,a5,80001c08 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bde:	4785                	li	a5,1
    80001be0:	02f50963          	beq	a0,a5,80001c12 <devintr+0x76>
    return 1;
    80001be4:	4505                	li	a0,1
    } else if(irq){
    80001be6:	d8f1                	beqz	s1,80001bba <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001be8:	85a6                	mv	a1,s1
    80001bea:	00006517          	auipc	a0,0x6
    80001bee:	66e50513          	addi	a0,a0,1646 # 80008258 <etext+0x258>
    80001bf2:	00004097          	auipc	ra,0x4
    80001bf6:	0de080e7          	jalr	222(ra) # 80005cd0 <printf>
      plic_complete(irq);
    80001bfa:	8526                	mv	a0,s1
    80001bfc:	00003097          	auipc	ra,0x3
    80001c00:	590080e7          	jalr	1424(ra) # 8000518c <plic_complete>
    return 1;
    80001c04:	4505                	li	a0,1
    80001c06:	bf55                	j	80001bba <devintr+0x1e>
      uartintr();
    80001c08:	00004097          	auipc	ra,0x4
    80001c0c:	4a8080e7          	jalr	1192(ra) # 800060b0 <uartintr>
    80001c10:	b7ed                	j	80001bfa <devintr+0x5e>
      virtio_disk_intr();
    80001c12:	00004097          	auipc	ra,0x4
    80001c16:	a0c080e7          	jalr	-1524(ra) # 8000561e <virtio_disk_intr>
    80001c1a:	b7c5                	j	80001bfa <devintr+0x5e>
    if(cpuid() == 0){
    80001c1c:	fffff097          	auipc	ra,0xfffff
    80001c20:	1fa080e7          	jalr	506(ra) # 80000e16 <cpuid>
    80001c24:	c901                	beqz	a0,80001c34 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c26:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c2a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c2c:	14479073          	csrw	sip,a5
    return 2;
    80001c30:	4509                	li	a0,2
    80001c32:	b761                	j	80001bba <devintr+0x1e>
      clockintr();
    80001c34:	00000097          	auipc	ra,0x0
    80001c38:	f22080e7          	jalr	-222(ra) # 80001b56 <clockintr>
    80001c3c:	b7ed                	j	80001c26 <devintr+0x8a>

0000000080001c3e <usertrap>:
{
    80001c3e:	1101                	addi	sp,sp,-32
    80001c40:	ec06                	sd	ra,24(sp)
    80001c42:	e822                	sd	s0,16(sp)
    80001c44:	e426                	sd	s1,8(sp)
    80001c46:	e04a                	sd	s2,0(sp)
    80001c48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c4a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c4e:	1007f793          	andi	a5,a5,256
    80001c52:	e3ad                	bnez	a5,80001cb4 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c54:	00003797          	auipc	a5,0x3
    80001c58:	40c78793          	addi	a5,a5,1036 # 80005060 <kernelvec>
    80001c5c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	1e2080e7          	jalr	482(ra) # 80000e42 <myproc>
    80001c68:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c6a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c6c:	14102773          	csrr	a4,sepc
    80001c70:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c72:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c76:	47a1                	li	a5,8
    80001c78:	04f71c63          	bne	a4,a5,80001cd0 <usertrap+0x92>
    if(p->killed)
    80001c7c:	551c                	lw	a5,40(a0)
    80001c7e:	e3b9                	bnez	a5,80001cc4 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c80:	6cb8                	ld	a4,88(s1)
    80001c82:	6f1c                	ld	a5,24(a4)
    80001c84:	0791                	addi	a5,a5,4
    80001c86:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c88:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c8c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c90:	10079073          	csrw	sstatus,a5
    syscall();
    80001c94:	00000097          	auipc	ra,0x0
    80001c98:	348080e7          	jalr	840(ra) # 80001fdc <syscall>
  if(p->killed)
    80001c9c:	549c                	lw	a5,40(s1)
    80001c9e:	efc5                	bnez	a5,80001d56 <usertrap+0x118>
  usertrapret();
    80001ca0:	00000097          	auipc	ra,0x0
    80001ca4:	e18080e7          	jalr	-488(ra) # 80001ab8 <usertrapret>
}
    80001ca8:	60e2                	ld	ra,24(sp)
    80001caa:	6442                	ld	s0,16(sp)
    80001cac:	64a2                	ld	s1,8(sp)
    80001cae:	6902                	ld	s2,0(sp)
    80001cb0:	6105                	addi	sp,sp,32
    80001cb2:	8082                	ret
    panic("usertrap: not from user mode");
    80001cb4:	00006517          	auipc	a0,0x6
    80001cb8:	5c450513          	addi	a0,a0,1476 # 80008278 <etext+0x278>
    80001cbc:	00004097          	auipc	ra,0x4
    80001cc0:	fc2080e7          	jalr	-62(ra) # 80005c7e <panic>
      exit(-1);
    80001cc4:	557d                	li	a0,-1
    80001cc6:	00000097          	auipc	ra,0x0
    80001cca:	aa6080e7          	jalr	-1370(ra) # 8000176c <exit>
    80001cce:	bf4d                	j	80001c80 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	ecc080e7          	jalr	-308(ra) # 80001b9c <devintr>
    80001cd8:	892a                	mv	s2,a0
    80001cda:	c501                	beqz	a0,80001ce2 <usertrap+0xa4>
  if(p->killed)
    80001cdc:	549c                	lw	a5,40(s1)
    80001cde:	c3a1                	beqz	a5,80001d1e <usertrap+0xe0>
    80001ce0:	a815                	j	80001d14 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ce2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ce6:	5890                	lw	a2,48(s1)
    80001ce8:	00006517          	auipc	a0,0x6
    80001cec:	5b050513          	addi	a0,a0,1456 # 80008298 <etext+0x298>
    80001cf0:	00004097          	auipc	ra,0x4
    80001cf4:	fe0080e7          	jalr	-32(ra) # 80005cd0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cf8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cfc:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d00:	00006517          	auipc	a0,0x6
    80001d04:	5c850513          	addi	a0,a0,1480 # 800082c8 <etext+0x2c8>
    80001d08:	00004097          	auipc	ra,0x4
    80001d0c:	fc8080e7          	jalr	-56(ra) # 80005cd0 <printf>
    p->killed = 1;
    80001d10:	4785                	li	a5,1
    80001d12:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d14:	557d                	li	a0,-1
    80001d16:	00000097          	auipc	ra,0x0
    80001d1a:	a56080e7          	jalr	-1450(ra) # 8000176c <exit>
  if(which_dev == 2)
    80001d1e:	4789                	li	a5,2
    80001d20:	f8f910e3          	bne	s2,a5,80001ca0 <usertrap+0x62>
    p->alarmticks += 1;
    80001d24:	16c4a783          	lw	a5,364(s1)
    80001d28:	2785                	addiw	a5,a5,1
    80001d2a:	0007871b          	sext.w	a4,a5
    80001d2e:	16f4a623          	sw	a5,364(s1)
    if ((p->alarmticks >= p->alarminterval) && (p->alarminterval > 0))
    80001d32:	1684a783          	lw	a5,360(s1)
    80001d36:	00f74b63          	blt	a4,a5,80001d4c <usertrap+0x10e>
    80001d3a:	00f05963          	blez	a5,80001d4c <usertrap+0x10e>
      p->alarmticks = 0;
    80001d3e:	1604a623          	sw	zero,364(s1)
      if (p->sigreturned == 1)
    80001d42:	2984a703          	lw	a4,664(s1)
    80001d46:	4785                	li	a5,1
    80001d48:	00f70963          	beq	a4,a5,80001d5a <usertrap+0x11c>
    yield();
    80001d4c:	fffff097          	auipc	ra,0xfffff
    80001d50:	788080e7          	jalr	1928(ra) # 800014d4 <yield>
    80001d54:	b7b1                	j	80001ca0 <usertrap+0x62>
  int which_dev = 0;
    80001d56:	4901                	li	s2,0
    80001d58:	bf75                	j	80001d14 <usertrap+0xd6>
        p->alarmtrapframe = *(p->trapframe);
    80001d5a:	0584b803          	ld	a6,88(s1)
    80001d5e:	87c2                	mv	a5,a6
    80001d60:	17848713          	addi	a4,s1,376
    80001d64:	12080893          	addi	a7,a6,288
    80001d68:	6388                	ld	a0,0(a5)
    80001d6a:	678c                	ld	a1,8(a5)
    80001d6c:	6b90                	ld	a2,16(a5)
    80001d6e:	6f94                	ld	a3,24(a5)
    80001d70:	e308                	sd	a0,0(a4)
    80001d72:	e70c                	sd	a1,8(a4)
    80001d74:	eb10                	sd	a2,16(a4)
    80001d76:	ef14                	sd	a3,24(a4)
    80001d78:	02078793          	addi	a5,a5,32
    80001d7c:	02070713          	addi	a4,a4,32
    80001d80:	ff1794e3          	bne	a5,a7,80001d68 <usertrap+0x12a>
        p->trapframe->epc = (uint64)p->alarmhandler;
    80001d84:	1704b783          	ld	a5,368(s1)
    80001d88:	00f83c23          	sd	a5,24(a6)
        p->sigreturned = 0;
    80001d8c:	2804ac23          	sw	zero,664(s1)
        usertrapret();
    80001d90:	00000097          	auipc	ra,0x0
    80001d94:	d28080e7          	jalr	-728(ra) # 80001ab8 <usertrapret>
    80001d98:	bf55                	j	80001d4c <usertrap+0x10e>

0000000080001d9a <kerneltrap>:
{
    80001d9a:	7179                	addi	sp,sp,-48
    80001d9c:	f406                	sd	ra,40(sp)
    80001d9e:	f022                	sd	s0,32(sp)
    80001da0:	ec26                	sd	s1,24(sp)
    80001da2:	e84a                	sd	s2,16(sp)
    80001da4:	e44e                	sd	s3,8(sp)
    80001da6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dac:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001db4:	1004f793          	andi	a5,s1,256
    80001db8:	cb85                	beqz	a5,80001de8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dbe:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dc0:	ef85                	bnez	a5,80001df8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dc2:	00000097          	auipc	ra,0x0
    80001dc6:	dda080e7          	jalr	-550(ra) # 80001b9c <devintr>
    80001dca:	cd1d                	beqz	a0,80001e08 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dcc:	4789                	li	a5,2
    80001dce:	06f50a63          	beq	a0,a5,80001e42 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dd2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd6:	10049073          	csrw	sstatus,s1
}
    80001dda:	70a2                	ld	ra,40(sp)
    80001ddc:	7402                	ld	s0,32(sp)
    80001dde:	64e2                	ld	s1,24(sp)
    80001de0:	6942                	ld	s2,16(sp)
    80001de2:	69a2                	ld	s3,8(sp)
    80001de4:	6145                	addi	sp,sp,48
    80001de6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de8:	00006517          	auipc	a0,0x6
    80001dec:	50050513          	addi	a0,a0,1280 # 800082e8 <etext+0x2e8>
    80001df0:	00004097          	auipc	ra,0x4
    80001df4:	e8e080e7          	jalr	-370(ra) # 80005c7e <panic>
    panic("kerneltrap: interrupts enabled");
    80001df8:	00006517          	auipc	a0,0x6
    80001dfc:	51850513          	addi	a0,a0,1304 # 80008310 <etext+0x310>
    80001e00:	00004097          	auipc	ra,0x4
    80001e04:	e7e080e7          	jalr	-386(ra) # 80005c7e <panic>
    printf("scause %p\n", scause);
    80001e08:	85ce                	mv	a1,s3
    80001e0a:	00006517          	auipc	a0,0x6
    80001e0e:	52650513          	addi	a0,a0,1318 # 80008330 <etext+0x330>
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	ebe080e7          	jalr	-322(ra) # 80005cd0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e1a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e1e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e22:	00006517          	auipc	a0,0x6
    80001e26:	51e50513          	addi	a0,a0,1310 # 80008340 <etext+0x340>
    80001e2a:	00004097          	auipc	ra,0x4
    80001e2e:	ea6080e7          	jalr	-346(ra) # 80005cd0 <printf>
    panic("kerneltrap");
    80001e32:	00006517          	auipc	a0,0x6
    80001e36:	52650513          	addi	a0,a0,1318 # 80008358 <etext+0x358>
    80001e3a:	00004097          	auipc	ra,0x4
    80001e3e:	e44080e7          	jalr	-444(ra) # 80005c7e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	000080e7          	jalr	ra # 80000e42 <myproc>
    80001e4a:	d541                	beqz	a0,80001dd2 <kerneltrap+0x38>
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	ff6080e7          	jalr	-10(ra) # 80000e42 <myproc>
    80001e54:	4d18                	lw	a4,24(a0)
    80001e56:	4791                	li	a5,4
    80001e58:	f6f71de3          	bne	a4,a5,80001dd2 <kerneltrap+0x38>
    yield();
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	678080e7          	jalr	1656(ra) # 800014d4 <yield>
    80001e64:	b7bd                	j	80001dd2 <kerneltrap+0x38>

0000000080001e66 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e66:	1101                	addi	sp,sp,-32
    80001e68:	ec06                	sd	ra,24(sp)
    80001e6a:	e822                	sd	s0,16(sp)
    80001e6c:	e426                	sd	s1,8(sp)
    80001e6e:	1000                	addi	s0,sp,32
    80001e70:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	fd0080e7          	jalr	-48(ra) # 80000e42 <myproc>
  switch (n) {
    80001e7a:	4795                	li	a5,5
    80001e7c:	0497e163          	bltu	a5,s1,80001ebe <argraw+0x58>
    80001e80:	048a                	slli	s1,s1,0x2
    80001e82:	00007717          	auipc	a4,0x7
    80001e86:	8c670713          	addi	a4,a4,-1850 # 80008748 <states.0+0x30>
    80001e8a:	94ba                	add	s1,s1,a4
    80001e8c:	409c                	lw	a5,0(s1)
    80001e8e:	97ba                	add	a5,a5,a4
    80001e90:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e92:	6d3c                	ld	a5,88(a0)
    80001e94:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e96:	60e2                	ld	ra,24(sp)
    80001e98:	6442                	ld	s0,16(sp)
    80001e9a:	64a2                	ld	s1,8(sp)
    80001e9c:	6105                	addi	sp,sp,32
    80001e9e:	8082                	ret
    return p->trapframe->a1;
    80001ea0:	6d3c                	ld	a5,88(a0)
    80001ea2:	7fa8                	ld	a0,120(a5)
    80001ea4:	bfcd                	j	80001e96 <argraw+0x30>
    return p->trapframe->a2;
    80001ea6:	6d3c                	ld	a5,88(a0)
    80001ea8:	63c8                	ld	a0,128(a5)
    80001eaa:	b7f5                	j	80001e96 <argraw+0x30>
    return p->trapframe->a3;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	67c8                	ld	a0,136(a5)
    80001eb0:	b7dd                	j	80001e96 <argraw+0x30>
    return p->trapframe->a4;
    80001eb2:	6d3c                	ld	a5,88(a0)
    80001eb4:	6bc8                	ld	a0,144(a5)
    80001eb6:	b7c5                	j	80001e96 <argraw+0x30>
    return p->trapframe->a5;
    80001eb8:	6d3c                	ld	a5,88(a0)
    80001eba:	6fc8                	ld	a0,152(a5)
    80001ebc:	bfe9                	j	80001e96 <argraw+0x30>
  panic("argraw");
    80001ebe:	00006517          	auipc	a0,0x6
    80001ec2:	4aa50513          	addi	a0,a0,1194 # 80008368 <etext+0x368>
    80001ec6:	00004097          	auipc	ra,0x4
    80001eca:	db8080e7          	jalr	-584(ra) # 80005c7e <panic>

0000000080001ece <fetchaddr>:
{
    80001ece:	1101                	addi	sp,sp,-32
    80001ed0:	ec06                	sd	ra,24(sp)
    80001ed2:	e822                	sd	s0,16(sp)
    80001ed4:	e426                	sd	s1,8(sp)
    80001ed6:	e04a                	sd	s2,0(sp)
    80001ed8:	1000                	addi	s0,sp,32
    80001eda:	84aa                	mv	s1,a0
    80001edc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	f64080e7          	jalr	-156(ra) # 80000e42 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ee6:	653c                	ld	a5,72(a0)
    80001ee8:	02f4f863          	bgeu	s1,a5,80001f18 <fetchaddr+0x4a>
    80001eec:	00848713          	addi	a4,s1,8
    80001ef0:	02e7e663          	bltu	a5,a4,80001f1c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ef4:	46a1                	li	a3,8
    80001ef6:	8626                	mv	a2,s1
    80001ef8:	85ca                	mv	a1,s2
    80001efa:	6928                	ld	a0,80(a0)
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	c92080e7          	jalr	-878(ra) # 80000b8e <copyin>
    80001f04:	00a03533          	snez	a0,a0
    80001f08:	40a00533          	neg	a0,a0
}
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	64a2                	ld	s1,8(sp)
    80001f12:	6902                	ld	s2,0(sp)
    80001f14:	6105                	addi	sp,sp,32
    80001f16:	8082                	ret
    return -1;
    80001f18:	557d                	li	a0,-1
    80001f1a:	bfcd                	j	80001f0c <fetchaddr+0x3e>
    80001f1c:	557d                	li	a0,-1
    80001f1e:	b7fd                	j	80001f0c <fetchaddr+0x3e>

0000000080001f20 <fetchstr>:
{
    80001f20:	7179                	addi	sp,sp,-48
    80001f22:	f406                	sd	ra,40(sp)
    80001f24:	f022                	sd	s0,32(sp)
    80001f26:	ec26                	sd	s1,24(sp)
    80001f28:	e84a                	sd	s2,16(sp)
    80001f2a:	e44e                	sd	s3,8(sp)
    80001f2c:	1800                	addi	s0,sp,48
    80001f2e:	892a                	mv	s2,a0
    80001f30:	84ae                	mv	s1,a1
    80001f32:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	f0e080e7          	jalr	-242(ra) # 80000e42 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f3c:	86ce                	mv	a3,s3
    80001f3e:	864a                	mv	a2,s2
    80001f40:	85a6                	mv	a1,s1
    80001f42:	6928                	ld	a0,80(a0)
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	cd8080e7          	jalr	-808(ra) # 80000c1c <copyinstr>
  if(err < 0)
    80001f4c:	00054763          	bltz	a0,80001f5a <fetchstr+0x3a>
  return strlen(buf);
    80001f50:	8526                	mv	a0,s1
    80001f52:	ffffe097          	auipc	ra,0xffffe
    80001f56:	3a2080e7          	jalr	930(ra) # 800002f4 <strlen>
}
    80001f5a:	70a2                	ld	ra,40(sp)
    80001f5c:	7402                	ld	s0,32(sp)
    80001f5e:	64e2                	ld	s1,24(sp)
    80001f60:	6942                	ld	s2,16(sp)
    80001f62:	69a2                	ld	s3,8(sp)
    80001f64:	6145                	addi	sp,sp,48
    80001f66:	8082                	ret

0000000080001f68 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f68:	1101                	addi	sp,sp,-32
    80001f6a:	ec06                	sd	ra,24(sp)
    80001f6c:	e822                	sd	s0,16(sp)
    80001f6e:	e426                	sd	s1,8(sp)
    80001f70:	1000                	addi	s0,sp,32
    80001f72:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f74:	00000097          	auipc	ra,0x0
    80001f78:	ef2080e7          	jalr	-270(ra) # 80001e66 <argraw>
    80001f7c:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f7e:	4501                	li	a0,0
    80001f80:	60e2                	ld	ra,24(sp)
    80001f82:	6442                	ld	s0,16(sp)
    80001f84:	64a2                	ld	s1,8(sp)
    80001f86:	6105                	addi	sp,sp,32
    80001f88:	8082                	ret

0000000080001f8a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f8a:	1101                	addi	sp,sp,-32
    80001f8c:	ec06                	sd	ra,24(sp)
    80001f8e:	e822                	sd	s0,16(sp)
    80001f90:	e426                	sd	s1,8(sp)
    80001f92:	1000                	addi	s0,sp,32
    80001f94:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f96:	00000097          	auipc	ra,0x0
    80001f9a:	ed0080e7          	jalr	-304(ra) # 80001e66 <argraw>
    80001f9e:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fa0:	4501                	li	a0,0
    80001fa2:	60e2                	ld	ra,24(sp)
    80001fa4:	6442                	ld	s0,16(sp)
    80001fa6:	64a2                	ld	s1,8(sp)
    80001fa8:	6105                	addi	sp,sp,32
    80001faa:	8082                	ret

0000000080001fac <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fac:	1101                	addi	sp,sp,-32
    80001fae:	ec06                	sd	ra,24(sp)
    80001fb0:	e822                	sd	s0,16(sp)
    80001fb2:	e426                	sd	s1,8(sp)
    80001fb4:	e04a                	sd	s2,0(sp)
    80001fb6:	1000                	addi	s0,sp,32
    80001fb8:	84ae                	mv	s1,a1
    80001fba:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	eaa080e7          	jalr	-342(ra) # 80001e66 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fc4:	864a                	mv	a2,s2
    80001fc6:	85a6                	mv	a1,s1
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	f58080e7          	jalr	-168(ra) # 80001f20 <fetchstr>
}
    80001fd0:	60e2                	ld	ra,24(sp)
    80001fd2:	6442                	ld	s0,16(sp)
    80001fd4:	64a2                	ld	s1,8(sp)
    80001fd6:	6902                	ld	s2,0(sp)
    80001fd8:	6105                	addi	sp,sp,32
    80001fda:	8082                	ret

0000000080001fdc <syscall>:
[SYS_sigreturn]   sys_sigreturn,
};

void
syscall(void)
{
    80001fdc:	1101                	addi	sp,sp,-32
    80001fde:	ec06                	sd	ra,24(sp)
    80001fe0:	e822                	sd	s0,16(sp)
    80001fe2:	e426                	sd	s1,8(sp)
    80001fe4:	e04a                	sd	s2,0(sp)
    80001fe6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fe8:	fffff097          	auipc	ra,0xfffff
    80001fec:	e5a080e7          	jalr	-422(ra) # 80000e42 <myproc>
    80001ff0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ff2:	05853903          	ld	s2,88(a0)
    80001ff6:	0a893783          	ld	a5,168(s2)
    80001ffa:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001ffe:	37fd                	addiw	a5,a5,-1
    80002000:	4759                	li	a4,22
    80002002:	00f76f63          	bltu	a4,a5,80002020 <syscall+0x44>
    80002006:	00369713          	slli	a4,a3,0x3
    8000200a:	00006797          	auipc	a5,0x6
    8000200e:	75678793          	addi	a5,a5,1878 # 80008760 <syscalls>
    80002012:	97ba                	add	a5,a5,a4
    80002014:	639c                	ld	a5,0(a5)
    80002016:	c789                	beqz	a5,80002020 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002018:	9782                	jalr	a5
    8000201a:	06a93823          	sd	a0,112(s2)
    8000201e:	a839                	j	8000203c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002020:	15848613          	addi	a2,s1,344
    80002024:	588c                	lw	a1,48(s1)
    80002026:	00006517          	auipc	a0,0x6
    8000202a:	34a50513          	addi	a0,a0,842 # 80008370 <etext+0x370>
    8000202e:	00004097          	auipc	ra,0x4
    80002032:	ca2080e7          	jalr	-862(ra) # 80005cd0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002036:	6cbc                	ld	a5,88(s1)
    80002038:	577d                	li	a4,-1
    8000203a:	fbb8                	sd	a4,112(a5)
  }
}
    8000203c:	60e2                	ld	ra,24(sp)
    8000203e:	6442                	ld	s0,16(sp)
    80002040:	64a2                	ld	s1,8(sp)
    80002042:	6902                	ld	s2,0(sp)
    80002044:	6105                	addi	sp,sp,32
    80002046:	8082                	ret

0000000080002048 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002048:	1101                	addi	sp,sp,-32
    8000204a:	ec06                	sd	ra,24(sp)
    8000204c:	e822                	sd	s0,16(sp)
    8000204e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002050:	fec40593          	addi	a1,s0,-20
    80002054:	4501                	li	a0,0
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	f12080e7          	jalr	-238(ra) # 80001f68 <argint>
    return -1;
    8000205e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002060:	00054963          	bltz	a0,80002072 <sys_exit+0x2a>
  exit(n);
    80002064:	fec42503          	lw	a0,-20(s0)
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	704080e7          	jalr	1796(ra) # 8000176c <exit>
  return 0;  // not reached
    80002070:	4781                	li	a5,0
}
    80002072:	853e                	mv	a0,a5
    80002074:	60e2                	ld	ra,24(sp)
    80002076:	6442                	ld	s0,16(sp)
    80002078:	6105                	addi	sp,sp,32
    8000207a:	8082                	ret

000000008000207c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000207c:	1141                	addi	sp,sp,-16
    8000207e:	e406                	sd	ra,8(sp)
    80002080:	e022                	sd	s0,0(sp)
    80002082:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	dbe080e7          	jalr	-578(ra) # 80000e42 <myproc>
}
    8000208c:	5908                	lw	a0,48(a0)
    8000208e:	60a2                	ld	ra,8(sp)
    80002090:	6402                	ld	s0,0(sp)
    80002092:	0141                	addi	sp,sp,16
    80002094:	8082                	ret

0000000080002096 <sys_fork>:

uint64
sys_fork(void)
{
    80002096:	1141                	addi	sp,sp,-16
    80002098:	e406                	sd	ra,8(sp)
    8000209a:	e022                	sd	s0,0(sp)
    8000209c:	0800                	addi	s0,sp,16
  return fork();
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	180080e7          	jalr	384(ra) # 8000121e <fork>
}
    800020a6:	60a2                	ld	ra,8(sp)
    800020a8:	6402                	ld	s0,0(sp)
    800020aa:	0141                	addi	sp,sp,16
    800020ac:	8082                	ret

00000000800020ae <sys_wait>:

uint64
sys_wait(void)
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020b6:	fe840593          	addi	a1,s0,-24
    800020ba:	4501                	li	a0,0
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	ece080e7          	jalr	-306(ra) # 80001f8a <argaddr>
    800020c4:	87aa                	mv	a5,a0
    return -1;
    800020c6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020c8:	0007c863          	bltz	a5,800020d8 <sys_wait+0x2a>
  return wait(p);
    800020cc:	fe843503          	ld	a0,-24(s0)
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	4a4080e7          	jalr	1188(ra) # 80001574 <wait>
}
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	6105                	addi	sp,sp,32
    800020de:	8082                	ret

00000000800020e0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020e0:	7179                	addi	sp,sp,-48
    800020e2:	f406                	sd	ra,40(sp)
    800020e4:	f022                	sd	s0,32(sp)
    800020e6:	ec26                	sd	s1,24(sp)
    800020e8:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020ea:	fdc40593          	addi	a1,s0,-36
    800020ee:	4501                	li	a0,0
    800020f0:	00000097          	auipc	ra,0x0
    800020f4:	e78080e7          	jalr	-392(ra) # 80001f68 <argint>
    return -1;
    800020f8:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    800020fa:	00054f63          	bltz	a0,80002118 <sys_sbrk+0x38>
  addr = myproc()->sz;
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	d44080e7          	jalr	-700(ra) # 80000e42 <myproc>
    80002106:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002108:	fdc42503          	lw	a0,-36(s0)
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	09e080e7          	jalr	158(ra) # 800011aa <growproc>
    80002114:	00054863          	bltz	a0,80002124 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002118:	8526                	mv	a0,s1
    8000211a:	70a2                	ld	ra,40(sp)
    8000211c:	7402                	ld	s0,32(sp)
    8000211e:	64e2                	ld	s1,24(sp)
    80002120:	6145                	addi	sp,sp,48
    80002122:	8082                	ret
    return -1;
    80002124:	54fd                	li	s1,-1
    80002126:	bfcd                	j	80002118 <sys_sbrk+0x38>

0000000080002128 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002128:	7139                	addi	sp,sp,-64
    8000212a:	fc06                	sd	ra,56(sp)
    8000212c:	f822                	sd	s0,48(sp)
    8000212e:	f426                	sd	s1,40(sp)
    80002130:	f04a                	sd	s2,32(sp)
    80002132:	ec4e                	sd	s3,24(sp)
    80002134:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;
  backtrace();
    80002136:	00004097          	auipc	ra,0x4
    8000213a:	b00080e7          	jalr	-1280(ra) # 80005c36 <backtrace>

  if(argint(0, &n) < 0)
    8000213e:	fcc40593          	addi	a1,s0,-52
    80002142:	4501                	li	a0,0
    80002144:	00000097          	auipc	ra,0x0
    80002148:	e24080e7          	jalr	-476(ra) # 80001f68 <argint>
    return -1;
    8000214c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000214e:	06054563          	bltz	a0,800021b8 <sys_sleep+0x90>
  acquire(&tickslock);
    80002152:	00012517          	auipc	a0,0x12
    80002156:	b2e50513          	addi	a0,a0,-1234 # 80013c80 <tickslock>
    8000215a:	00004097          	auipc	ra,0x4
    8000215e:	036080e7          	jalr	54(ra) # 80006190 <acquire>
  ticks0 = ticks;
    80002162:	00007917          	auipc	s2,0x7
    80002166:	eb692903          	lw	s2,-330(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000216a:	fcc42783          	lw	a5,-52(s0)
    8000216e:	cf85                	beqz	a5,800021a6 <sys_sleep+0x7e>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002170:	00012997          	auipc	s3,0x12
    80002174:	b1098993          	addi	s3,s3,-1264 # 80013c80 <tickslock>
    80002178:	00007497          	auipc	s1,0x7
    8000217c:	ea048493          	addi	s1,s1,-352 # 80009018 <ticks>
    if(myproc()->killed){
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	cc2080e7          	jalr	-830(ra) # 80000e42 <myproc>
    80002188:	551c                	lw	a5,40(a0)
    8000218a:	ef9d                	bnez	a5,800021c8 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    8000218c:	85ce                	mv	a1,s3
    8000218e:	8526                	mv	a0,s1
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	380080e7          	jalr	896(ra) # 80001510 <sleep>
  while(ticks - ticks0 < n){
    80002198:	409c                	lw	a5,0(s1)
    8000219a:	412787bb          	subw	a5,a5,s2
    8000219e:	fcc42703          	lw	a4,-52(s0)
    800021a2:	fce7efe3          	bltu	a5,a4,80002180 <sys_sleep+0x58>
  }
  release(&tickslock);
    800021a6:	00012517          	auipc	a0,0x12
    800021aa:	ada50513          	addi	a0,a0,-1318 # 80013c80 <tickslock>
    800021ae:	00004097          	auipc	ra,0x4
    800021b2:	096080e7          	jalr	150(ra) # 80006244 <release>
  return 0;
    800021b6:	4781                	li	a5,0
}
    800021b8:	853e                	mv	a0,a5
    800021ba:	70e2                	ld	ra,56(sp)
    800021bc:	7442                	ld	s0,48(sp)
    800021be:	74a2                	ld	s1,40(sp)
    800021c0:	7902                	ld	s2,32(sp)
    800021c2:	69e2                	ld	s3,24(sp)
    800021c4:	6121                	addi	sp,sp,64
    800021c6:	8082                	ret
      release(&tickslock);
    800021c8:	00012517          	auipc	a0,0x12
    800021cc:	ab850513          	addi	a0,a0,-1352 # 80013c80 <tickslock>
    800021d0:	00004097          	auipc	ra,0x4
    800021d4:	074080e7          	jalr	116(ra) # 80006244 <release>
      return -1;
    800021d8:	57fd                	li	a5,-1
    800021da:	bff9                	j	800021b8 <sys_sleep+0x90>

00000000800021dc <sys_kill>:

uint64
sys_kill(void)
{
    800021dc:	1101                	addi	sp,sp,-32
    800021de:	ec06                	sd	ra,24(sp)
    800021e0:	e822                	sd	s0,16(sp)
    800021e2:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021e4:	fec40593          	addi	a1,s0,-20
    800021e8:	4501                	li	a0,0
    800021ea:	00000097          	auipc	ra,0x0
    800021ee:	d7e080e7          	jalr	-642(ra) # 80001f68 <argint>
    800021f2:	87aa                	mv	a5,a0
    return -1;
    800021f4:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021f6:	0007c863          	bltz	a5,80002206 <sys_kill+0x2a>
  return kill(pid);
    800021fa:	fec42503          	lw	a0,-20(s0)
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	644080e7          	jalr	1604(ra) # 80001842 <kill>
}
    80002206:	60e2                	ld	ra,24(sp)
    80002208:	6442                	ld	s0,16(sp)
    8000220a:	6105                	addi	sp,sp,32
    8000220c:	8082                	ret

000000008000220e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000220e:	1101                	addi	sp,sp,-32
    80002210:	ec06                	sd	ra,24(sp)
    80002212:	e822                	sd	s0,16(sp)
    80002214:	e426                	sd	s1,8(sp)
    80002216:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002218:	00012517          	auipc	a0,0x12
    8000221c:	a6850513          	addi	a0,a0,-1432 # 80013c80 <tickslock>
    80002220:	00004097          	auipc	ra,0x4
    80002224:	f70080e7          	jalr	-144(ra) # 80006190 <acquire>
  xticks = ticks;
    80002228:	00007497          	auipc	s1,0x7
    8000222c:	df04a483          	lw	s1,-528(s1) # 80009018 <ticks>
  release(&tickslock);
    80002230:	00012517          	auipc	a0,0x12
    80002234:	a5050513          	addi	a0,a0,-1456 # 80013c80 <tickslock>
    80002238:	00004097          	auipc	ra,0x4
    8000223c:	00c080e7          	jalr	12(ra) # 80006244 <release>
  return xticks;
}
    80002240:	02049513          	slli	a0,s1,0x20
    80002244:	9101                	srli	a0,a0,0x20
    80002246:	60e2                	ld	ra,24(sp)
    80002248:	6442                	ld	s0,16(sp)
    8000224a:	64a2                	ld	s1,8(sp)
    8000224c:	6105                	addi	sp,sp,32
    8000224e:	8082                	ret

0000000080002250 <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    80002250:	7179                	addi	sp,sp,-48
    80002252:	f406                	sd	ra,40(sp)
    80002254:	f022                	sd	s0,32(sp)
    80002256:	ec26                	sd	s1,24(sp)
    80002258:	1800                	addi	s0,sp,48
	int ticks;
	uint64 handler;
	struct proc *p = myproc();
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	be8080e7          	jalr	-1048(ra) # 80000e42 <myproc>
    80002262:	84aa                	mv	s1,a0
	if(argint(0, &ticks) < 0 || argaddr(1, &handler) < 0)
    80002264:	fdc40593          	addi	a1,s0,-36
    80002268:	4501                	li	a0,0
    8000226a:	00000097          	auipc	ra,0x0
    8000226e:	cfe080e7          	jalr	-770(ra) # 80001f68 <argint>
	return -1;
    80002272:	57fd                	li	a5,-1
	if(argint(0, &ticks) < 0 || argaddr(1, &handler) < 0)
    80002274:	02054663          	bltz	a0,800022a0 <sys_sigalarm+0x50>
    80002278:	fd040593          	addi	a1,s0,-48
    8000227c:	4505                	li	a0,1
    8000227e:	00000097          	auipc	ra,0x0
    80002282:	d0c080e7          	jalr	-756(ra) # 80001f8a <argaddr>
    80002286:	02054363          	bltz	a0,800022ac <sys_sigalarm+0x5c>
	p->alarminterval = ticks;
    8000228a:	fdc42783          	lw	a5,-36(s0)
    8000228e:	16f4a423          	sw	a5,360(s1)
	p->alarmhandler = (void (*)())handler;
    80002292:	fd043783          	ld	a5,-48(s0)
    80002296:	16f4b823          	sd	a5,368(s1)
	p->alarmticks = 0;
    8000229a:	1604a623          	sw	zero,364(s1)
	return 0;
    8000229e:	4781                	li	a5,0
}
    800022a0:	853e                	mv	a0,a5
    800022a2:	70a2                	ld	ra,40(sp)
    800022a4:	7402                	ld	s0,32(sp)
    800022a6:	64e2                	ld	s1,24(sp)
    800022a8:	6145                	addi	sp,sp,48
    800022aa:	8082                	ret
	return -1;
    800022ac:	57fd                	li	a5,-1
    800022ae:	bfcd                	j	800022a0 <sys_sigalarm+0x50>

00000000800022b0 <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    800022b0:	1141                	addi	sp,sp,-16
    800022b2:	e406                	sd	ra,8(sp)
    800022b4:	e022                	sd	s0,0(sp)
    800022b6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	b8a080e7          	jalr	-1142(ra) # 80000e42 <myproc>
  p->sigreturned = 1;
    800022c0:	4785                	li	a5,1
    800022c2:	28f52c23          	sw	a5,664(a0)
  *(p->trapframe) = p->alarmtrapframe;
    800022c6:	17850793          	addi	a5,a0,376
    800022ca:	6d38                	ld	a4,88(a0)
    800022cc:	29850513          	addi	a0,a0,664
    800022d0:	0007b803          	ld	a6,0(a5)
    800022d4:	678c                	ld	a1,8(a5)
    800022d6:	6b90                	ld	a2,16(a5)
    800022d8:	6f94                	ld	a3,24(a5)
    800022da:	01073023          	sd	a6,0(a4)
    800022de:	e70c                	sd	a1,8(a4)
    800022e0:	eb10                	sd	a2,16(a4)
    800022e2:	ef14                	sd	a3,24(a4)
    800022e4:	02078793          	addi	a5,a5,32
    800022e8:	02070713          	addi	a4,a4,32
    800022ec:	fea792e3          	bne	a5,a0,800022d0 <sys_sigreturn+0x20>
  usertrapret();
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	7c8080e7          	jalr	1992(ra) # 80001ab8 <usertrapret>
  return 0;
}
    800022f8:	4501                	li	a0,0
    800022fa:	60a2                	ld	ra,8(sp)
    800022fc:	6402                	ld	s0,0(sp)
    800022fe:	0141                	addi	sp,sp,16
    80002300:	8082                	ret

0000000080002302 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002302:	7179                	addi	sp,sp,-48
    80002304:	f406                	sd	ra,40(sp)
    80002306:	f022                	sd	s0,32(sp)
    80002308:	ec26                	sd	s1,24(sp)
    8000230a:	e84a                	sd	s2,16(sp)
    8000230c:	e44e                	sd	s3,8(sp)
    8000230e:	e052                	sd	s4,0(sp)
    80002310:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002312:	00006597          	auipc	a1,0x6
    80002316:	07e58593          	addi	a1,a1,126 # 80008390 <etext+0x390>
    8000231a:	00012517          	auipc	a0,0x12
    8000231e:	97e50513          	addi	a0,a0,-1666 # 80013c98 <bcache>
    80002322:	00004097          	auipc	ra,0x4
    80002326:	dde080e7          	jalr	-546(ra) # 80006100 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000232a:	0001a797          	auipc	a5,0x1a
    8000232e:	96e78793          	addi	a5,a5,-1682 # 8001bc98 <bcache+0x8000>
    80002332:	0001a717          	auipc	a4,0x1a
    80002336:	bce70713          	addi	a4,a4,-1074 # 8001bf00 <bcache+0x8268>
    8000233a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000233e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002342:	00012497          	auipc	s1,0x12
    80002346:	96e48493          	addi	s1,s1,-1682 # 80013cb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000234a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000234c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000234e:	00006a17          	auipc	s4,0x6
    80002352:	04aa0a13          	addi	s4,s4,74 # 80008398 <etext+0x398>
    b->next = bcache.head.next;
    80002356:	2b893783          	ld	a5,696(s2)
    8000235a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000235c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002360:	85d2                	mv	a1,s4
    80002362:	01048513          	addi	a0,s1,16
    80002366:	00001097          	auipc	ra,0x1
    8000236a:	4bc080e7          	jalr	1212(ra) # 80003822 <initsleeplock>
    bcache.head.next->prev = b;
    8000236e:	2b893783          	ld	a5,696(s2)
    80002372:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002374:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002378:	45848493          	addi	s1,s1,1112
    8000237c:	fd349de3          	bne	s1,s3,80002356 <binit+0x54>
  }
}
    80002380:	70a2                	ld	ra,40(sp)
    80002382:	7402                	ld	s0,32(sp)
    80002384:	64e2                	ld	s1,24(sp)
    80002386:	6942                	ld	s2,16(sp)
    80002388:	69a2                	ld	s3,8(sp)
    8000238a:	6a02                	ld	s4,0(sp)
    8000238c:	6145                	addi	sp,sp,48
    8000238e:	8082                	ret

0000000080002390 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002390:	7179                	addi	sp,sp,-48
    80002392:	f406                	sd	ra,40(sp)
    80002394:	f022                	sd	s0,32(sp)
    80002396:	ec26                	sd	s1,24(sp)
    80002398:	e84a                	sd	s2,16(sp)
    8000239a:	e44e                	sd	s3,8(sp)
    8000239c:	1800                	addi	s0,sp,48
    8000239e:	892a                	mv	s2,a0
    800023a0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023a2:	00012517          	auipc	a0,0x12
    800023a6:	8f650513          	addi	a0,a0,-1802 # 80013c98 <bcache>
    800023aa:	00004097          	auipc	ra,0x4
    800023ae:	de6080e7          	jalr	-538(ra) # 80006190 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023b2:	0001a497          	auipc	s1,0x1a
    800023b6:	b9e4b483          	ld	s1,-1122(s1) # 8001bf50 <bcache+0x82b8>
    800023ba:	0001a797          	auipc	a5,0x1a
    800023be:	b4678793          	addi	a5,a5,-1210 # 8001bf00 <bcache+0x8268>
    800023c2:	02f48f63          	beq	s1,a5,80002400 <bread+0x70>
    800023c6:	873e                	mv	a4,a5
    800023c8:	a021                	j	800023d0 <bread+0x40>
    800023ca:	68a4                	ld	s1,80(s1)
    800023cc:	02e48a63          	beq	s1,a4,80002400 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023d0:	449c                	lw	a5,8(s1)
    800023d2:	ff279ce3          	bne	a5,s2,800023ca <bread+0x3a>
    800023d6:	44dc                	lw	a5,12(s1)
    800023d8:	ff3799e3          	bne	a5,s3,800023ca <bread+0x3a>
      b->refcnt++;
    800023dc:	40bc                	lw	a5,64(s1)
    800023de:	2785                	addiw	a5,a5,1
    800023e0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023e2:	00012517          	auipc	a0,0x12
    800023e6:	8b650513          	addi	a0,a0,-1866 # 80013c98 <bcache>
    800023ea:	00004097          	auipc	ra,0x4
    800023ee:	e5a080e7          	jalr	-422(ra) # 80006244 <release>
      acquiresleep(&b->lock);
    800023f2:	01048513          	addi	a0,s1,16
    800023f6:	00001097          	auipc	ra,0x1
    800023fa:	466080e7          	jalr	1126(ra) # 8000385c <acquiresleep>
      return b;
    800023fe:	a8b9                	j	8000245c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002400:	0001a497          	auipc	s1,0x1a
    80002404:	b484b483          	ld	s1,-1208(s1) # 8001bf48 <bcache+0x82b0>
    80002408:	0001a797          	auipc	a5,0x1a
    8000240c:	af878793          	addi	a5,a5,-1288 # 8001bf00 <bcache+0x8268>
    80002410:	00f48863          	beq	s1,a5,80002420 <bread+0x90>
    80002414:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002416:	40bc                	lw	a5,64(s1)
    80002418:	cf81                	beqz	a5,80002430 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000241a:	64a4                	ld	s1,72(s1)
    8000241c:	fee49de3          	bne	s1,a4,80002416 <bread+0x86>
  panic("bget: no buffers");
    80002420:	00006517          	auipc	a0,0x6
    80002424:	f8050513          	addi	a0,a0,-128 # 800083a0 <etext+0x3a0>
    80002428:	00004097          	auipc	ra,0x4
    8000242c:	856080e7          	jalr	-1962(ra) # 80005c7e <panic>
      b->dev = dev;
    80002430:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002434:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002438:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000243c:	4785                	li	a5,1
    8000243e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002440:	00012517          	auipc	a0,0x12
    80002444:	85850513          	addi	a0,a0,-1960 # 80013c98 <bcache>
    80002448:	00004097          	auipc	ra,0x4
    8000244c:	dfc080e7          	jalr	-516(ra) # 80006244 <release>
      acquiresleep(&b->lock);
    80002450:	01048513          	addi	a0,s1,16
    80002454:	00001097          	auipc	ra,0x1
    80002458:	408080e7          	jalr	1032(ra) # 8000385c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000245c:	409c                	lw	a5,0(s1)
    8000245e:	cb89                	beqz	a5,80002470 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002460:	8526                	mv	a0,s1
    80002462:	70a2                	ld	ra,40(sp)
    80002464:	7402                	ld	s0,32(sp)
    80002466:	64e2                	ld	s1,24(sp)
    80002468:	6942                	ld	s2,16(sp)
    8000246a:	69a2                	ld	s3,8(sp)
    8000246c:	6145                	addi	sp,sp,48
    8000246e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002470:	4581                	li	a1,0
    80002472:	8526                	mv	a0,s1
    80002474:	00003097          	auipc	ra,0x3
    80002478:	f22080e7          	jalr	-222(ra) # 80005396 <virtio_disk_rw>
    b->valid = 1;
    8000247c:	4785                	li	a5,1
    8000247e:	c09c                	sw	a5,0(s1)
  return b;
    80002480:	b7c5                	j	80002460 <bread+0xd0>

0000000080002482 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002482:	1101                	addi	sp,sp,-32
    80002484:	ec06                	sd	ra,24(sp)
    80002486:	e822                	sd	s0,16(sp)
    80002488:	e426                	sd	s1,8(sp)
    8000248a:	1000                	addi	s0,sp,32
    8000248c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000248e:	0541                	addi	a0,a0,16
    80002490:	00001097          	auipc	ra,0x1
    80002494:	466080e7          	jalr	1126(ra) # 800038f6 <holdingsleep>
    80002498:	cd01                	beqz	a0,800024b0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000249a:	4585                	li	a1,1
    8000249c:	8526                	mv	a0,s1
    8000249e:	00003097          	auipc	ra,0x3
    800024a2:	ef8080e7          	jalr	-264(ra) # 80005396 <virtio_disk_rw>
}
    800024a6:	60e2                	ld	ra,24(sp)
    800024a8:	6442                	ld	s0,16(sp)
    800024aa:	64a2                	ld	s1,8(sp)
    800024ac:	6105                	addi	sp,sp,32
    800024ae:	8082                	ret
    panic("bwrite");
    800024b0:	00006517          	auipc	a0,0x6
    800024b4:	f0850513          	addi	a0,a0,-248 # 800083b8 <etext+0x3b8>
    800024b8:	00003097          	auipc	ra,0x3
    800024bc:	7c6080e7          	jalr	1990(ra) # 80005c7e <panic>

00000000800024c0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024c0:	1101                	addi	sp,sp,-32
    800024c2:	ec06                	sd	ra,24(sp)
    800024c4:	e822                	sd	s0,16(sp)
    800024c6:	e426                	sd	s1,8(sp)
    800024c8:	e04a                	sd	s2,0(sp)
    800024ca:	1000                	addi	s0,sp,32
    800024cc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ce:	01050913          	addi	s2,a0,16
    800024d2:	854a                	mv	a0,s2
    800024d4:	00001097          	auipc	ra,0x1
    800024d8:	422080e7          	jalr	1058(ra) # 800038f6 <holdingsleep>
    800024dc:	c92d                	beqz	a0,8000254e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024de:	854a                	mv	a0,s2
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	3d2080e7          	jalr	978(ra) # 800038b2 <releasesleep>

  acquire(&bcache.lock);
    800024e8:	00011517          	auipc	a0,0x11
    800024ec:	7b050513          	addi	a0,a0,1968 # 80013c98 <bcache>
    800024f0:	00004097          	auipc	ra,0x4
    800024f4:	ca0080e7          	jalr	-864(ra) # 80006190 <acquire>
  b->refcnt--;
    800024f8:	40bc                	lw	a5,64(s1)
    800024fa:	37fd                	addiw	a5,a5,-1
    800024fc:	0007871b          	sext.w	a4,a5
    80002500:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002502:	eb05                	bnez	a4,80002532 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002504:	68bc                	ld	a5,80(s1)
    80002506:	64b8                	ld	a4,72(s1)
    80002508:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000250a:	64bc                	ld	a5,72(s1)
    8000250c:	68b8                	ld	a4,80(s1)
    8000250e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002510:	00019797          	auipc	a5,0x19
    80002514:	78878793          	addi	a5,a5,1928 # 8001bc98 <bcache+0x8000>
    80002518:	2b87b703          	ld	a4,696(a5)
    8000251c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000251e:	0001a717          	auipc	a4,0x1a
    80002522:	9e270713          	addi	a4,a4,-1566 # 8001bf00 <bcache+0x8268>
    80002526:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002528:	2b87b703          	ld	a4,696(a5)
    8000252c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000252e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002532:	00011517          	auipc	a0,0x11
    80002536:	76650513          	addi	a0,a0,1894 # 80013c98 <bcache>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	d0a080e7          	jalr	-758(ra) # 80006244 <release>
}
    80002542:	60e2                	ld	ra,24(sp)
    80002544:	6442                	ld	s0,16(sp)
    80002546:	64a2                	ld	s1,8(sp)
    80002548:	6902                	ld	s2,0(sp)
    8000254a:	6105                	addi	sp,sp,32
    8000254c:	8082                	ret
    panic("brelse");
    8000254e:	00006517          	auipc	a0,0x6
    80002552:	e7250513          	addi	a0,a0,-398 # 800083c0 <etext+0x3c0>
    80002556:	00003097          	auipc	ra,0x3
    8000255a:	728080e7          	jalr	1832(ra) # 80005c7e <panic>

000000008000255e <bpin>:

void
bpin(struct buf *b) {
    8000255e:	1101                	addi	sp,sp,-32
    80002560:	ec06                	sd	ra,24(sp)
    80002562:	e822                	sd	s0,16(sp)
    80002564:	e426                	sd	s1,8(sp)
    80002566:	1000                	addi	s0,sp,32
    80002568:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000256a:	00011517          	auipc	a0,0x11
    8000256e:	72e50513          	addi	a0,a0,1838 # 80013c98 <bcache>
    80002572:	00004097          	auipc	ra,0x4
    80002576:	c1e080e7          	jalr	-994(ra) # 80006190 <acquire>
  b->refcnt++;
    8000257a:	40bc                	lw	a5,64(s1)
    8000257c:	2785                	addiw	a5,a5,1
    8000257e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002580:	00011517          	auipc	a0,0x11
    80002584:	71850513          	addi	a0,a0,1816 # 80013c98 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	cbc080e7          	jalr	-836(ra) # 80006244 <release>
}
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	64a2                	ld	s1,8(sp)
    80002596:	6105                	addi	sp,sp,32
    80002598:	8082                	ret

000000008000259a <bunpin>:

void
bunpin(struct buf *b) {
    8000259a:	1101                	addi	sp,sp,-32
    8000259c:	ec06                	sd	ra,24(sp)
    8000259e:	e822                	sd	s0,16(sp)
    800025a0:	e426                	sd	s1,8(sp)
    800025a2:	1000                	addi	s0,sp,32
    800025a4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025a6:	00011517          	auipc	a0,0x11
    800025aa:	6f250513          	addi	a0,a0,1778 # 80013c98 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	be2080e7          	jalr	-1054(ra) # 80006190 <acquire>
  b->refcnt--;
    800025b6:	40bc                	lw	a5,64(s1)
    800025b8:	37fd                	addiw	a5,a5,-1
    800025ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025bc:	00011517          	auipc	a0,0x11
    800025c0:	6dc50513          	addi	a0,a0,1756 # 80013c98 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	c80080e7          	jalr	-896(ra) # 80006244 <release>
}
    800025cc:	60e2                	ld	ra,24(sp)
    800025ce:	6442                	ld	s0,16(sp)
    800025d0:	64a2                	ld	s1,8(sp)
    800025d2:	6105                	addi	sp,sp,32
    800025d4:	8082                	ret

00000000800025d6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025d6:	1101                	addi	sp,sp,-32
    800025d8:	ec06                	sd	ra,24(sp)
    800025da:	e822                	sd	s0,16(sp)
    800025dc:	e426                	sd	s1,8(sp)
    800025de:	e04a                	sd	s2,0(sp)
    800025e0:	1000                	addi	s0,sp,32
    800025e2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025e4:	00d5d59b          	srliw	a1,a1,0xd
    800025e8:	0001a797          	auipc	a5,0x1a
    800025ec:	d8c7a783          	lw	a5,-628(a5) # 8001c374 <sb+0x1c>
    800025f0:	9dbd                	addw	a1,a1,a5
    800025f2:	00000097          	auipc	ra,0x0
    800025f6:	d9e080e7          	jalr	-610(ra) # 80002390 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025fa:	0074f713          	andi	a4,s1,7
    800025fe:	4785                	li	a5,1
    80002600:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002604:	14ce                	slli	s1,s1,0x33
    80002606:	90d9                	srli	s1,s1,0x36
    80002608:	00950733          	add	a4,a0,s1
    8000260c:	05874703          	lbu	a4,88(a4)
    80002610:	00e7f6b3          	and	a3,a5,a4
    80002614:	c69d                	beqz	a3,80002642 <bfree+0x6c>
    80002616:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002618:	94aa                	add	s1,s1,a0
    8000261a:	fff7c793          	not	a5,a5
    8000261e:	8ff9                	and	a5,a5,a4
    80002620:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002624:	00001097          	auipc	ra,0x1
    80002628:	118080e7          	jalr	280(ra) # 8000373c <log_write>
  brelse(bp);
    8000262c:	854a                	mv	a0,s2
    8000262e:	00000097          	auipc	ra,0x0
    80002632:	e92080e7          	jalr	-366(ra) # 800024c0 <brelse>
}
    80002636:	60e2                	ld	ra,24(sp)
    80002638:	6442                	ld	s0,16(sp)
    8000263a:	64a2                	ld	s1,8(sp)
    8000263c:	6902                	ld	s2,0(sp)
    8000263e:	6105                	addi	sp,sp,32
    80002640:	8082                	ret
    panic("freeing free block");
    80002642:	00006517          	auipc	a0,0x6
    80002646:	d8650513          	addi	a0,a0,-634 # 800083c8 <etext+0x3c8>
    8000264a:	00003097          	auipc	ra,0x3
    8000264e:	634080e7          	jalr	1588(ra) # 80005c7e <panic>

0000000080002652 <balloc>:
{
    80002652:	711d                	addi	sp,sp,-96
    80002654:	ec86                	sd	ra,88(sp)
    80002656:	e8a2                	sd	s0,80(sp)
    80002658:	e4a6                	sd	s1,72(sp)
    8000265a:	e0ca                	sd	s2,64(sp)
    8000265c:	fc4e                	sd	s3,56(sp)
    8000265e:	f852                	sd	s4,48(sp)
    80002660:	f456                	sd	s5,40(sp)
    80002662:	f05a                	sd	s6,32(sp)
    80002664:	ec5e                	sd	s7,24(sp)
    80002666:	e862                	sd	s8,16(sp)
    80002668:	e466                	sd	s9,8(sp)
    8000266a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000266c:	0001a797          	auipc	a5,0x1a
    80002670:	cf07a783          	lw	a5,-784(a5) # 8001c35c <sb+0x4>
    80002674:	cbd1                	beqz	a5,80002708 <balloc+0xb6>
    80002676:	8baa                	mv	s7,a0
    80002678:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000267a:	0001ab17          	auipc	s6,0x1a
    8000267e:	cdeb0b13          	addi	s6,s6,-802 # 8001c358 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002682:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002684:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002686:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002688:	6c89                	lui	s9,0x2
    8000268a:	a831                	j	800026a6 <balloc+0x54>
    brelse(bp);
    8000268c:	854a                	mv	a0,s2
    8000268e:	00000097          	auipc	ra,0x0
    80002692:	e32080e7          	jalr	-462(ra) # 800024c0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002696:	015c87bb          	addw	a5,s9,s5
    8000269a:	00078a9b          	sext.w	s5,a5
    8000269e:	004b2703          	lw	a4,4(s6)
    800026a2:	06eaf363          	bgeu	s5,a4,80002708 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026a6:	41fad79b          	sraiw	a5,s5,0x1f
    800026aa:	0137d79b          	srliw	a5,a5,0x13
    800026ae:	015787bb          	addw	a5,a5,s5
    800026b2:	40d7d79b          	sraiw	a5,a5,0xd
    800026b6:	01cb2583          	lw	a1,28(s6)
    800026ba:	9dbd                	addw	a1,a1,a5
    800026bc:	855e                	mv	a0,s7
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	cd2080e7          	jalr	-814(ra) # 80002390 <bread>
    800026c6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026c8:	004b2503          	lw	a0,4(s6)
    800026cc:	000a849b          	sext.w	s1,s5
    800026d0:	8662                	mv	a2,s8
    800026d2:	faa4fde3          	bgeu	s1,a0,8000268c <balloc+0x3a>
      m = 1 << (bi % 8);
    800026d6:	41f6579b          	sraiw	a5,a2,0x1f
    800026da:	01d7d69b          	srliw	a3,a5,0x1d
    800026de:	00c6873b          	addw	a4,a3,a2
    800026e2:	00777793          	andi	a5,a4,7
    800026e6:	9f95                	subw	a5,a5,a3
    800026e8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026ec:	4037571b          	sraiw	a4,a4,0x3
    800026f0:	00e906b3          	add	a3,s2,a4
    800026f4:	0586c683          	lbu	a3,88(a3)
    800026f8:	00d7f5b3          	and	a1,a5,a3
    800026fc:	cd91                	beqz	a1,80002718 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026fe:	2605                	addiw	a2,a2,1
    80002700:	2485                	addiw	s1,s1,1
    80002702:	fd4618e3          	bne	a2,s4,800026d2 <balloc+0x80>
    80002706:	b759                	j	8000268c <balloc+0x3a>
  panic("balloc: out of blocks");
    80002708:	00006517          	auipc	a0,0x6
    8000270c:	cd850513          	addi	a0,a0,-808 # 800083e0 <etext+0x3e0>
    80002710:	00003097          	auipc	ra,0x3
    80002714:	56e080e7          	jalr	1390(ra) # 80005c7e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002718:	974a                	add	a4,a4,s2
    8000271a:	8fd5                	or	a5,a5,a3
    8000271c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002720:	854a                	mv	a0,s2
    80002722:	00001097          	auipc	ra,0x1
    80002726:	01a080e7          	jalr	26(ra) # 8000373c <log_write>
        brelse(bp);
    8000272a:	854a                	mv	a0,s2
    8000272c:	00000097          	auipc	ra,0x0
    80002730:	d94080e7          	jalr	-620(ra) # 800024c0 <brelse>
  bp = bread(dev, bno);
    80002734:	85a6                	mv	a1,s1
    80002736:	855e                	mv	a0,s7
    80002738:	00000097          	auipc	ra,0x0
    8000273c:	c58080e7          	jalr	-936(ra) # 80002390 <bread>
    80002740:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002742:	40000613          	li	a2,1024
    80002746:	4581                	li	a1,0
    80002748:	05850513          	addi	a0,a0,88
    8000274c:	ffffe097          	auipc	ra,0xffffe
    80002750:	a2c080e7          	jalr	-1492(ra) # 80000178 <memset>
  log_write(bp);
    80002754:	854a                	mv	a0,s2
    80002756:	00001097          	auipc	ra,0x1
    8000275a:	fe6080e7          	jalr	-26(ra) # 8000373c <log_write>
  brelse(bp);
    8000275e:	854a                	mv	a0,s2
    80002760:	00000097          	auipc	ra,0x0
    80002764:	d60080e7          	jalr	-672(ra) # 800024c0 <brelse>
}
    80002768:	8526                	mv	a0,s1
    8000276a:	60e6                	ld	ra,88(sp)
    8000276c:	6446                	ld	s0,80(sp)
    8000276e:	64a6                	ld	s1,72(sp)
    80002770:	6906                	ld	s2,64(sp)
    80002772:	79e2                	ld	s3,56(sp)
    80002774:	7a42                	ld	s4,48(sp)
    80002776:	7aa2                	ld	s5,40(sp)
    80002778:	7b02                	ld	s6,32(sp)
    8000277a:	6be2                	ld	s7,24(sp)
    8000277c:	6c42                	ld	s8,16(sp)
    8000277e:	6ca2                	ld	s9,8(sp)
    80002780:	6125                	addi	sp,sp,96
    80002782:	8082                	ret

0000000080002784 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002784:	7179                	addi	sp,sp,-48
    80002786:	f406                	sd	ra,40(sp)
    80002788:	f022                	sd	s0,32(sp)
    8000278a:	ec26                	sd	s1,24(sp)
    8000278c:	e84a                	sd	s2,16(sp)
    8000278e:	e44e                	sd	s3,8(sp)
    80002790:	e052                	sd	s4,0(sp)
    80002792:	1800                	addi	s0,sp,48
    80002794:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002796:	47ad                	li	a5,11
    80002798:	04b7fe63          	bgeu	a5,a1,800027f4 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000279c:	ff45849b          	addiw	s1,a1,-12
    800027a0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027a4:	0ff00793          	li	a5,255
    800027a8:	0ae7e363          	bltu	a5,a4,8000284e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027ac:	08052583          	lw	a1,128(a0)
    800027b0:	c5ad                	beqz	a1,8000281a <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027b2:	00092503          	lw	a0,0(s2)
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	bda080e7          	jalr	-1062(ra) # 80002390 <bread>
    800027be:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027c0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027c4:	02049593          	slli	a1,s1,0x20
    800027c8:	9181                	srli	a1,a1,0x20
    800027ca:	058a                	slli	a1,a1,0x2
    800027cc:	00b784b3          	add	s1,a5,a1
    800027d0:	0004a983          	lw	s3,0(s1)
    800027d4:	04098d63          	beqz	s3,8000282e <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027d8:	8552                	mv	a0,s4
    800027da:	00000097          	auipc	ra,0x0
    800027de:	ce6080e7          	jalr	-794(ra) # 800024c0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027e2:	854e                	mv	a0,s3
    800027e4:	70a2                	ld	ra,40(sp)
    800027e6:	7402                	ld	s0,32(sp)
    800027e8:	64e2                	ld	s1,24(sp)
    800027ea:	6942                	ld	s2,16(sp)
    800027ec:	69a2                	ld	s3,8(sp)
    800027ee:	6a02                	ld	s4,0(sp)
    800027f0:	6145                	addi	sp,sp,48
    800027f2:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800027f4:	02059493          	slli	s1,a1,0x20
    800027f8:	9081                	srli	s1,s1,0x20
    800027fa:	048a                	slli	s1,s1,0x2
    800027fc:	94aa                	add	s1,s1,a0
    800027fe:	0504a983          	lw	s3,80(s1)
    80002802:	fe0990e3          	bnez	s3,800027e2 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002806:	4108                	lw	a0,0(a0)
    80002808:	00000097          	auipc	ra,0x0
    8000280c:	e4a080e7          	jalr	-438(ra) # 80002652 <balloc>
    80002810:	0005099b          	sext.w	s3,a0
    80002814:	0534a823          	sw	s3,80(s1)
    80002818:	b7e9                	j	800027e2 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000281a:	4108                	lw	a0,0(a0)
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	e36080e7          	jalr	-458(ra) # 80002652 <balloc>
    80002824:	0005059b          	sext.w	a1,a0
    80002828:	08b92023          	sw	a1,128(s2)
    8000282c:	b759                	j	800027b2 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000282e:	00092503          	lw	a0,0(s2)
    80002832:	00000097          	auipc	ra,0x0
    80002836:	e20080e7          	jalr	-480(ra) # 80002652 <balloc>
    8000283a:	0005099b          	sext.w	s3,a0
    8000283e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002842:	8552                	mv	a0,s4
    80002844:	00001097          	auipc	ra,0x1
    80002848:	ef8080e7          	jalr	-264(ra) # 8000373c <log_write>
    8000284c:	b771                	j	800027d8 <bmap+0x54>
  panic("bmap: out of range");
    8000284e:	00006517          	auipc	a0,0x6
    80002852:	baa50513          	addi	a0,a0,-1110 # 800083f8 <etext+0x3f8>
    80002856:	00003097          	auipc	ra,0x3
    8000285a:	428080e7          	jalr	1064(ra) # 80005c7e <panic>

000000008000285e <iget>:
{
    8000285e:	7179                	addi	sp,sp,-48
    80002860:	f406                	sd	ra,40(sp)
    80002862:	f022                	sd	s0,32(sp)
    80002864:	ec26                	sd	s1,24(sp)
    80002866:	e84a                	sd	s2,16(sp)
    80002868:	e44e                	sd	s3,8(sp)
    8000286a:	e052                	sd	s4,0(sp)
    8000286c:	1800                	addi	s0,sp,48
    8000286e:	89aa                	mv	s3,a0
    80002870:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002872:	0001a517          	auipc	a0,0x1a
    80002876:	b0650513          	addi	a0,a0,-1274 # 8001c378 <itable>
    8000287a:	00004097          	auipc	ra,0x4
    8000287e:	916080e7          	jalr	-1770(ra) # 80006190 <acquire>
  empty = 0;
    80002882:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002884:	0001a497          	auipc	s1,0x1a
    80002888:	b0c48493          	addi	s1,s1,-1268 # 8001c390 <itable+0x18>
    8000288c:	0001b697          	auipc	a3,0x1b
    80002890:	59468693          	addi	a3,a3,1428 # 8001de20 <log>
    80002894:	a039                	j	800028a2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002896:	02090b63          	beqz	s2,800028cc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000289a:	08848493          	addi	s1,s1,136
    8000289e:	02d48a63          	beq	s1,a3,800028d2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028a2:	449c                	lw	a5,8(s1)
    800028a4:	fef059e3          	blez	a5,80002896 <iget+0x38>
    800028a8:	4098                	lw	a4,0(s1)
    800028aa:	ff3716e3          	bne	a4,s3,80002896 <iget+0x38>
    800028ae:	40d8                	lw	a4,4(s1)
    800028b0:	ff4713e3          	bne	a4,s4,80002896 <iget+0x38>
      ip->ref++;
    800028b4:	2785                	addiw	a5,a5,1
    800028b6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028b8:	0001a517          	auipc	a0,0x1a
    800028bc:	ac050513          	addi	a0,a0,-1344 # 8001c378 <itable>
    800028c0:	00004097          	auipc	ra,0x4
    800028c4:	984080e7          	jalr	-1660(ra) # 80006244 <release>
      return ip;
    800028c8:	8926                	mv	s2,s1
    800028ca:	a03d                	j	800028f8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028cc:	f7f9                	bnez	a5,8000289a <iget+0x3c>
    800028ce:	8926                	mv	s2,s1
    800028d0:	b7e9                	j	8000289a <iget+0x3c>
  if(empty == 0)
    800028d2:	02090c63          	beqz	s2,8000290a <iget+0xac>
  ip->dev = dev;
    800028d6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028da:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028de:	4785                	li	a5,1
    800028e0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028e4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028e8:	0001a517          	auipc	a0,0x1a
    800028ec:	a9050513          	addi	a0,a0,-1392 # 8001c378 <itable>
    800028f0:	00004097          	auipc	ra,0x4
    800028f4:	954080e7          	jalr	-1708(ra) # 80006244 <release>
}
    800028f8:	854a                	mv	a0,s2
    800028fa:	70a2                	ld	ra,40(sp)
    800028fc:	7402                	ld	s0,32(sp)
    800028fe:	64e2                	ld	s1,24(sp)
    80002900:	6942                	ld	s2,16(sp)
    80002902:	69a2                	ld	s3,8(sp)
    80002904:	6a02                	ld	s4,0(sp)
    80002906:	6145                	addi	sp,sp,48
    80002908:	8082                	ret
    panic("iget: no inodes");
    8000290a:	00006517          	auipc	a0,0x6
    8000290e:	b0650513          	addi	a0,a0,-1274 # 80008410 <etext+0x410>
    80002912:	00003097          	auipc	ra,0x3
    80002916:	36c080e7          	jalr	876(ra) # 80005c7e <panic>

000000008000291a <fsinit>:
fsinit(int dev) {
    8000291a:	7179                	addi	sp,sp,-48
    8000291c:	f406                	sd	ra,40(sp)
    8000291e:	f022                	sd	s0,32(sp)
    80002920:	ec26                	sd	s1,24(sp)
    80002922:	e84a                	sd	s2,16(sp)
    80002924:	e44e                	sd	s3,8(sp)
    80002926:	1800                	addi	s0,sp,48
    80002928:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000292a:	4585                	li	a1,1
    8000292c:	00000097          	auipc	ra,0x0
    80002930:	a64080e7          	jalr	-1436(ra) # 80002390 <bread>
    80002934:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002936:	0001a997          	auipc	s3,0x1a
    8000293a:	a2298993          	addi	s3,s3,-1502 # 8001c358 <sb>
    8000293e:	02000613          	li	a2,32
    80002942:	05850593          	addi	a1,a0,88
    80002946:	854e                	mv	a0,s3
    80002948:	ffffe097          	auipc	ra,0xffffe
    8000294c:	88c080e7          	jalr	-1908(ra) # 800001d4 <memmove>
  brelse(bp);
    80002950:	8526                	mv	a0,s1
    80002952:	00000097          	auipc	ra,0x0
    80002956:	b6e080e7          	jalr	-1170(ra) # 800024c0 <brelse>
  if(sb.magic != FSMAGIC)
    8000295a:	0009a703          	lw	a4,0(s3)
    8000295e:	102037b7          	lui	a5,0x10203
    80002962:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002966:	02f71263          	bne	a4,a5,8000298a <fsinit+0x70>
  initlog(dev, &sb);
    8000296a:	0001a597          	auipc	a1,0x1a
    8000296e:	9ee58593          	addi	a1,a1,-1554 # 8001c358 <sb>
    80002972:	854a                	mv	a0,s2
    80002974:	00001097          	auipc	ra,0x1
    80002978:	b4c080e7          	jalr	-1204(ra) # 800034c0 <initlog>
}
    8000297c:	70a2                	ld	ra,40(sp)
    8000297e:	7402                	ld	s0,32(sp)
    80002980:	64e2                	ld	s1,24(sp)
    80002982:	6942                	ld	s2,16(sp)
    80002984:	69a2                	ld	s3,8(sp)
    80002986:	6145                	addi	sp,sp,48
    80002988:	8082                	ret
    panic("invalid file system");
    8000298a:	00006517          	auipc	a0,0x6
    8000298e:	a9650513          	addi	a0,a0,-1386 # 80008420 <etext+0x420>
    80002992:	00003097          	auipc	ra,0x3
    80002996:	2ec080e7          	jalr	748(ra) # 80005c7e <panic>

000000008000299a <iinit>:
{
    8000299a:	7179                	addi	sp,sp,-48
    8000299c:	f406                	sd	ra,40(sp)
    8000299e:	f022                	sd	s0,32(sp)
    800029a0:	ec26                	sd	s1,24(sp)
    800029a2:	e84a                	sd	s2,16(sp)
    800029a4:	e44e                	sd	s3,8(sp)
    800029a6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029a8:	00006597          	auipc	a1,0x6
    800029ac:	a9058593          	addi	a1,a1,-1392 # 80008438 <etext+0x438>
    800029b0:	0001a517          	auipc	a0,0x1a
    800029b4:	9c850513          	addi	a0,a0,-1592 # 8001c378 <itable>
    800029b8:	00003097          	auipc	ra,0x3
    800029bc:	748080e7          	jalr	1864(ra) # 80006100 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029c0:	0001a497          	auipc	s1,0x1a
    800029c4:	9e048493          	addi	s1,s1,-1568 # 8001c3a0 <itable+0x28>
    800029c8:	0001b997          	auipc	s3,0x1b
    800029cc:	46898993          	addi	s3,s3,1128 # 8001de30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029d0:	00006917          	auipc	s2,0x6
    800029d4:	a7090913          	addi	s2,s2,-1424 # 80008440 <etext+0x440>
    800029d8:	85ca                	mv	a1,s2
    800029da:	8526                	mv	a0,s1
    800029dc:	00001097          	auipc	ra,0x1
    800029e0:	e46080e7          	jalr	-442(ra) # 80003822 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029e4:	08848493          	addi	s1,s1,136
    800029e8:	ff3498e3          	bne	s1,s3,800029d8 <iinit+0x3e>
}
    800029ec:	70a2                	ld	ra,40(sp)
    800029ee:	7402                	ld	s0,32(sp)
    800029f0:	64e2                	ld	s1,24(sp)
    800029f2:	6942                	ld	s2,16(sp)
    800029f4:	69a2                	ld	s3,8(sp)
    800029f6:	6145                	addi	sp,sp,48
    800029f8:	8082                	ret

00000000800029fa <ialloc>:
{
    800029fa:	715d                	addi	sp,sp,-80
    800029fc:	e486                	sd	ra,72(sp)
    800029fe:	e0a2                	sd	s0,64(sp)
    80002a00:	fc26                	sd	s1,56(sp)
    80002a02:	f84a                	sd	s2,48(sp)
    80002a04:	f44e                	sd	s3,40(sp)
    80002a06:	f052                	sd	s4,32(sp)
    80002a08:	ec56                	sd	s5,24(sp)
    80002a0a:	e85a                	sd	s6,16(sp)
    80002a0c:	e45e                	sd	s7,8(sp)
    80002a0e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a10:	0001a717          	auipc	a4,0x1a
    80002a14:	95472703          	lw	a4,-1708(a4) # 8001c364 <sb+0xc>
    80002a18:	4785                	li	a5,1
    80002a1a:	04e7fa63          	bgeu	a5,a4,80002a6e <ialloc+0x74>
    80002a1e:	8aaa                	mv	s5,a0
    80002a20:	8bae                	mv	s7,a1
    80002a22:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a24:	0001aa17          	auipc	s4,0x1a
    80002a28:	934a0a13          	addi	s4,s4,-1740 # 8001c358 <sb>
    80002a2c:	00048b1b          	sext.w	s6,s1
    80002a30:	0044d793          	srli	a5,s1,0x4
    80002a34:	018a2583          	lw	a1,24(s4)
    80002a38:	9dbd                	addw	a1,a1,a5
    80002a3a:	8556                	mv	a0,s5
    80002a3c:	00000097          	auipc	ra,0x0
    80002a40:	954080e7          	jalr	-1708(ra) # 80002390 <bread>
    80002a44:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a46:	05850993          	addi	s3,a0,88
    80002a4a:	00f4f793          	andi	a5,s1,15
    80002a4e:	079a                	slli	a5,a5,0x6
    80002a50:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a52:	00099783          	lh	a5,0(s3)
    80002a56:	c785                	beqz	a5,80002a7e <ialloc+0x84>
    brelse(bp);
    80002a58:	00000097          	auipc	ra,0x0
    80002a5c:	a68080e7          	jalr	-1432(ra) # 800024c0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a60:	0485                	addi	s1,s1,1
    80002a62:	00ca2703          	lw	a4,12(s4)
    80002a66:	0004879b          	sext.w	a5,s1
    80002a6a:	fce7e1e3          	bltu	a5,a4,80002a2c <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a6e:	00006517          	auipc	a0,0x6
    80002a72:	9da50513          	addi	a0,a0,-1574 # 80008448 <etext+0x448>
    80002a76:	00003097          	auipc	ra,0x3
    80002a7a:	208080e7          	jalr	520(ra) # 80005c7e <panic>
      memset(dip, 0, sizeof(*dip));
    80002a7e:	04000613          	li	a2,64
    80002a82:	4581                	li	a1,0
    80002a84:	854e                	mv	a0,s3
    80002a86:	ffffd097          	auipc	ra,0xffffd
    80002a8a:	6f2080e7          	jalr	1778(ra) # 80000178 <memset>
      dip->type = type;
    80002a8e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a92:	854a                	mv	a0,s2
    80002a94:	00001097          	auipc	ra,0x1
    80002a98:	ca8080e7          	jalr	-856(ra) # 8000373c <log_write>
      brelse(bp);
    80002a9c:	854a                	mv	a0,s2
    80002a9e:	00000097          	auipc	ra,0x0
    80002aa2:	a22080e7          	jalr	-1502(ra) # 800024c0 <brelse>
      return iget(dev, inum);
    80002aa6:	85da                	mv	a1,s6
    80002aa8:	8556                	mv	a0,s5
    80002aaa:	00000097          	auipc	ra,0x0
    80002aae:	db4080e7          	jalr	-588(ra) # 8000285e <iget>
}
    80002ab2:	60a6                	ld	ra,72(sp)
    80002ab4:	6406                	ld	s0,64(sp)
    80002ab6:	74e2                	ld	s1,56(sp)
    80002ab8:	7942                	ld	s2,48(sp)
    80002aba:	79a2                	ld	s3,40(sp)
    80002abc:	7a02                	ld	s4,32(sp)
    80002abe:	6ae2                	ld	s5,24(sp)
    80002ac0:	6b42                	ld	s6,16(sp)
    80002ac2:	6ba2                	ld	s7,8(sp)
    80002ac4:	6161                	addi	sp,sp,80
    80002ac6:	8082                	ret

0000000080002ac8 <iupdate>:
{
    80002ac8:	1101                	addi	sp,sp,-32
    80002aca:	ec06                	sd	ra,24(sp)
    80002acc:	e822                	sd	s0,16(sp)
    80002ace:	e426                	sd	s1,8(sp)
    80002ad0:	e04a                	sd	s2,0(sp)
    80002ad2:	1000                	addi	s0,sp,32
    80002ad4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ad6:	415c                	lw	a5,4(a0)
    80002ad8:	0047d79b          	srliw	a5,a5,0x4
    80002adc:	0001a597          	auipc	a1,0x1a
    80002ae0:	8945a583          	lw	a1,-1900(a1) # 8001c370 <sb+0x18>
    80002ae4:	9dbd                	addw	a1,a1,a5
    80002ae6:	4108                	lw	a0,0(a0)
    80002ae8:	00000097          	auipc	ra,0x0
    80002aec:	8a8080e7          	jalr	-1880(ra) # 80002390 <bread>
    80002af0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002af2:	05850793          	addi	a5,a0,88
    80002af6:	40c8                	lw	a0,4(s1)
    80002af8:	893d                	andi	a0,a0,15
    80002afa:	051a                	slli	a0,a0,0x6
    80002afc:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002afe:	04449703          	lh	a4,68(s1)
    80002b02:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b06:	04649703          	lh	a4,70(s1)
    80002b0a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b0e:	04849703          	lh	a4,72(s1)
    80002b12:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b16:	04a49703          	lh	a4,74(s1)
    80002b1a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b1e:	44f8                	lw	a4,76(s1)
    80002b20:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b22:	03400613          	li	a2,52
    80002b26:	05048593          	addi	a1,s1,80
    80002b2a:	0531                	addi	a0,a0,12
    80002b2c:	ffffd097          	auipc	ra,0xffffd
    80002b30:	6a8080e7          	jalr	1704(ra) # 800001d4 <memmove>
  log_write(bp);
    80002b34:	854a                	mv	a0,s2
    80002b36:	00001097          	auipc	ra,0x1
    80002b3a:	c06080e7          	jalr	-1018(ra) # 8000373c <log_write>
  brelse(bp);
    80002b3e:	854a                	mv	a0,s2
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	980080e7          	jalr	-1664(ra) # 800024c0 <brelse>
}
    80002b48:	60e2                	ld	ra,24(sp)
    80002b4a:	6442                	ld	s0,16(sp)
    80002b4c:	64a2                	ld	s1,8(sp)
    80002b4e:	6902                	ld	s2,0(sp)
    80002b50:	6105                	addi	sp,sp,32
    80002b52:	8082                	ret

0000000080002b54 <idup>:
{
    80002b54:	1101                	addi	sp,sp,-32
    80002b56:	ec06                	sd	ra,24(sp)
    80002b58:	e822                	sd	s0,16(sp)
    80002b5a:	e426                	sd	s1,8(sp)
    80002b5c:	1000                	addi	s0,sp,32
    80002b5e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b60:	0001a517          	auipc	a0,0x1a
    80002b64:	81850513          	addi	a0,a0,-2024 # 8001c378 <itable>
    80002b68:	00003097          	auipc	ra,0x3
    80002b6c:	628080e7          	jalr	1576(ra) # 80006190 <acquire>
  ip->ref++;
    80002b70:	449c                	lw	a5,8(s1)
    80002b72:	2785                	addiw	a5,a5,1
    80002b74:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b76:	0001a517          	auipc	a0,0x1a
    80002b7a:	80250513          	addi	a0,a0,-2046 # 8001c378 <itable>
    80002b7e:	00003097          	auipc	ra,0x3
    80002b82:	6c6080e7          	jalr	1734(ra) # 80006244 <release>
}
    80002b86:	8526                	mv	a0,s1
    80002b88:	60e2                	ld	ra,24(sp)
    80002b8a:	6442                	ld	s0,16(sp)
    80002b8c:	64a2                	ld	s1,8(sp)
    80002b8e:	6105                	addi	sp,sp,32
    80002b90:	8082                	ret

0000000080002b92 <ilock>:
{
    80002b92:	1101                	addi	sp,sp,-32
    80002b94:	ec06                	sd	ra,24(sp)
    80002b96:	e822                	sd	s0,16(sp)
    80002b98:	e426                	sd	s1,8(sp)
    80002b9a:	e04a                	sd	s2,0(sp)
    80002b9c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b9e:	c115                	beqz	a0,80002bc2 <ilock+0x30>
    80002ba0:	84aa                	mv	s1,a0
    80002ba2:	451c                	lw	a5,8(a0)
    80002ba4:	00f05f63          	blez	a5,80002bc2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002ba8:	0541                	addi	a0,a0,16
    80002baa:	00001097          	auipc	ra,0x1
    80002bae:	cb2080e7          	jalr	-846(ra) # 8000385c <acquiresleep>
  if(ip->valid == 0){
    80002bb2:	40bc                	lw	a5,64(s1)
    80002bb4:	cf99                	beqz	a5,80002bd2 <ilock+0x40>
}
    80002bb6:	60e2                	ld	ra,24(sp)
    80002bb8:	6442                	ld	s0,16(sp)
    80002bba:	64a2                	ld	s1,8(sp)
    80002bbc:	6902                	ld	s2,0(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret
    panic("ilock");
    80002bc2:	00006517          	auipc	a0,0x6
    80002bc6:	89e50513          	addi	a0,a0,-1890 # 80008460 <etext+0x460>
    80002bca:	00003097          	auipc	ra,0x3
    80002bce:	0b4080e7          	jalr	180(ra) # 80005c7e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bd2:	40dc                	lw	a5,4(s1)
    80002bd4:	0047d79b          	srliw	a5,a5,0x4
    80002bd8:	00019597          	auipc	a1,0x19
    80002bdc:	7985a583          	lw	a1,1944(a1) # 8001c370 <sb+0x18>
    80002be0:	9dbd                	addw	a1,a1,a5
    80002be2:	4088                	lw	a0,0(s1)
    80002be4:	fffff097          	auipc	ra,0xfffff
    80002be8:	7ac080e7          	jalr	1964(ra) # 80002390 <bread>
    80002bec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bee:	05850593          	addi	a1,a0,88
    80002bf2:	40dc                	lw	a5,4(s1)
    80002bf4:	8bbd                	andi	a5,a5,15
    80002bf6:	079a                	slli	a5,a5,0x6
    80002bf8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bfa:	00059783          	lh	a5,0(a1)
    80002bfe:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c02:	00259783          	lh	a5,2(a1)
    80002c06:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c0a:	00459783          	lh	a5,4(a1)
    80002c0e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c12:	00659783          	lh	a5,6(a1)
    80002c16:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c1a:	459c                	lw	a5,8(a1)
    80002c1c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c1e:	03400613          	li	a2,52
    80002c22:	05b1                	addi	a1,a1,12
    80002c24:	05048513          	addi	a0,s1,80
    80002c28:	ffffd097          	auipc	ra,0xffffd
    80002c2c:	5ac080e7          	jalr	1452(ra) # 800001d4 <memmove>
    brelse(bp);
    80002c30:	854a                	mv	a0,s2
    80002c32:	00000097          	auipc	ra,0x0
    80002c36:	88e080e7          	jalr	-1906(ra) # 800024c0 <brelse>
    ip->valid = 1;
    80002c3a:	4785                	li	a5,1
    80002c3c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c3e:	04449783          	lh	a5,68(s1)
    80002c42:	fbb5                	bnez	a5,80002bb6 <ilock+0x24>
      panic("ilock: no type");
    80002c44:	00006517          	auipc	a0,0x6
    80002c48:	82450513          	addi	a0,a0,-2012 # 80008468 <etext+0x468>
    80002c4c:	00003097          	auipc	ra,0x3
    80002c50:	032080e7          	jalr	50(ra) # 80005c7e <panic>

0000000080002c54 <iunlock>:
{
    80002c54:	1101                	addi	sp,sp,-32
    80002c56:	ec06                	sd	ra,24(sp)
    80002c58:	e822                	sd	s0,16(sp)
    80002c5a:	e426                	sd	s1,8(sp)
    80002c5c:	e04a                	sd	s2,0(sp)
    80002c5e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c60:	c905                	beqz	a0,80002c90 <iunlock+0x3c>
    80002c62:	84aa                	mv	s1,a0
    80002c64:	01050913          	addi	s2,a0,16
    80002c68:	854a                	mv	a0,s2
    80002c6a:	00001097          	auipc	ra,0x1
    80002c6e:	c8c080e7          	jalr	-884(ra) # 800038f6 <holdingsleep>
    80002c72:	cd19                	beqz	a0,80002c90 <iunlock+0x3c>
    80002c74:	449c                	lw	a5,8(s1)
    80002c76:	00f05d63          	blez	a5,80002c90 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c7a:	854a                	mv	a0,s2
    80002c7c:	00001097          	auipc	ra,0x1
    80002c80:	c36080e7          	jalr	-970(ra) # 800038b2 <releasesleep>
}
    80002c84:	60e2                	ld	ra,24(sp)
    80002c86:	6442                	ld	s0,16(sp)
    80002c88:	64a2                	ld	s1,8(sp)
    80002c8a:	6902                	ld	s2,0(sp)
    80002c8c:	6105                	addi	sp,sp,32
    80002c8e:	8082                	ret
    panic("iunlock");
    80002c90:	00005517          	auipc	a0,0x5
    80002c94:	7e850513          	addi	a0,a0,2024 # 80008478 <etext+0x478>
    80002c98:	00003097          	auipc	ra,0x3
    80002c9c:	fe6080e7          	jalr	-26(ra) # 80005c7e <panic>

0000000080002ca0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ca0:	7179                	addi	sp,sp,-48
    80002ca2:	f406                	sd	ra,40(sp)
    80002ca4:	f022                	sd	s0,32(sp)
    80002ca6:	ec26                	sd	s1,24(sp)
    80002ca8:	e84a                	sd	s2,16(sp)
    80002caa:	e44e                	sd	s3,8(sp)
    80002cac:	e052                	sd	s4,0(sp)
    80002cae:	1800                	addi	s0,sp,48
    80002cb0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cb2:	05050493          	addi	s1,a0,80
    80002cb6:	08050913          	addi	s2,a0,128
    80002cba:	a021                	j	80002cc2 <itrunc+0x22>
    80002cbc:	0491                	addi	s1,s1,4
    80002cbe:	01248d63          	beq	s1,s2,80002cd8 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cc2:	408c                	lw	a1,0(s1)
    80002cc4:	dde5                	beqz	a1,80002cbc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cc6:	0009a503          	lw	a0,0(s3)
    80002cca:	00000097          	auipc	ra,0x0
    80002cce:	90c080e7          	jalr	-1780(ra) # 800025d6 <bfree>
      ip->addrs[i] = 0;
    80002cd2:	0004a023          	sw	zero,0(s1)
    80002cd6:	b7dd                	j	80002cbc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cd8:	0809a583          	lw	a1,128(s3)
    80002cdc:	e185                	bnez	a1,80002cfc <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cde:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ce2:	854e                	mv	a0,s3
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	de4080e7          	jalr	-540(ra) # 80002ac8 <iupdate>
}
    80002cec:	70a2                	ld	ra,40(sp)
    80002cee:	7402                	ld	s0,32(sp)
    80002cf0:	64e2                	ld	s1,24(sp)
    80002cf2:	6942                	ld	s2,16(sp)
    80002cf4:	69a2                	ld	s3,8(sp)
    80002cf6:	6a02                	ld	s4,0(sp)
    80002cf8:	6145                	addi	sp,sp,48
    80002cfa:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cfc:	0009a503          	lw	a0,0(s3)
    80002d00:	fffff097          	auipc	ra,0xfffff
    80002d04:	690080e7          	jalr	1680(ra) # 80002390 <bread>
    80002d08:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d0a:	05850493          	addi	s1,a0,88
    80002d0e:	45850913          	addi	s2,a0,1112
    80002d12:	a021                	j	80002d1a <itrunc+0x7a>
    80002d14:	0491                	addi	s1,s1,4
    80002d16:	01248b63          	beq	s1,s2,80002d2c <itrunc+0x8c>
      if(a[j])
    80002d1a:	408c                	lw	a1,0(s1)
    80002d1c:	dde5                	beqz	a1,80002d14 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d1e:	0009a503          	lw	a0,0(s3)
    80002d22:	00000097          	auipc	ra,0x0
    80002d26:	8b4080e7          	jalr	-1868(ra) # 800025d6 <bfree>
    80002d2a:	b7ed                	j	80002d14 <itrunc+0x74>
    brelse(bp);
    80002d2c:	8552                	mv	a0,s4
    80002d2e:	fffff097          	auipc	ra,0xfffff
    80002d32:	792080e7          	jalr	1938(ra) # 800024c0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d36:	0809a583          	lw	a1,128(s3)
    80002d3a:	0009a503          	lw	a0,0(s3)
    80002d3e:	00000097          	auipc	ra,0x0
    80002d42:	898080e7          	jalr	-1896(ra) # 800025d6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d46:	0809a023          	sw	zero,128(s3)
    80002d4a:	bf51                	j	80002cde <itrunc+0x3e>

0000000080002d4c <iput>:
{
    80002d4c:	1101                	addi	sp,sp,-32
    80002d4e:	ec06                	sd	ra,24(sp)
    80002d50:	e822                	sd	s0,16(sp)
    80002d52:	e426                	sd	s1,8(sp)
    80002d54:	e04a                	sd	s2,0(sp)
    80002d56:	1000                	addi	s0,sp,32
    80002d58:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d5a:	00019517          	auipc	a0,0x19
    80002d5e:	61e50513          	addi	a0,a0,1566 # 8001c378 <itable>
    80002d62:	00003097          	auipc	ra,0x3
    80002d66:	42e080e7          	jalr	1070(ra) # 80006190 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d6a:	4498                	lw	a4,8(s1)
    80002d6c:	4785                	li	a5,1
    80002d6e:	02f70363          	beq	a4,a5,80002d94 <iput+0x48>
  ip->ref--;
    80002d72:	449c                	lw	a5,8(s1)
    80002d74:	37fd                	addiw	a5,a5,-1
    80002d76:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d78:	00019517          	auipc	a0,0x19
    80002d7c:	60050513          	addi	a0,a0,1536 # 8001c378 <itable>
    80002d80:	00003097          	auipc	ra,0x3
    80002d84:	4c4080e7          	jalr	1220(ra) # 80006244 <release>
}
    80002d88:	60e2                	ld	ra,24(sp)
    80002d8a:	6442                	ld	s0,16(sp)
    80002d8c:	64a2                	ld	s1,8(sp)
    80002d8e:	6902                	ld	s2,0(sp)
    80002d90:	6105                	addi	sp,sp,32
    80002d92:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d94:	40bc                	lw	a5,64(s1)
    80002d96:	dff1                	beqz	a5,80002d72 <iput+0x26>
    80002d98:	04a49783          	lh	a5,74(s1)
    80002d9c:	fbf9                	bnez	a5,80002d72 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d9e:	01048913          	addi	s2,s1,16
    80002da2:	854a                	mv	a0,s2
    80002da4:	00001097          	auipc	ra,0x1
    80002da8:	ab8080e7          	jalr	-1352(ra) # 8000385c <acquiresleep>
    release(&itable.lock);
    80002dac:	00019517          	auipc	a0,0x19
    80002db0:	5cc50513          	addi	a0,a0,1484 # 8001c378 <itable>
    80002db4:	00003097          	auipc	ra,0x3
    80002db8:	490080e7          	jalr	1168(ra) # 80006244 <release>
    itrunc(ip);
    80002dbc:	8526                	mv	a0,s1
    80002dbe:	00000097          	auipc	ra,0x0
    80002dc2:	ee2080e7          	jalr	-286(ra) # 80002ca0 <itrunc>
    ip->type = 0;
    80002dc6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dca:	8526                	mv	a0,s1
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	cfc080e7          	jalr	-772(ra) # 80002ac8 <iupdate>
    ip->valid = 0;
    80002dd4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dd8:	854a                	mv	a0,s2
    80002dda:	00001097          	auipc	ra,0x1
    80002dde:	ad8080e7          	jalr	-1320(ra) # 800038b2 <releasesleep>
    acquire(&itable.lock);
    80002de2:	00019517          	auipc	a0,0x19
    80002de6:	59650513          	addi	a0,a0,1430 # 8001c378 <itable>
    80002dea:	00003097          	auipc	ra,0x3
    80002dee:	3a6080e7          	jalr	934(ra) # 80006190 <acquire>
    80002df2:	b741                	j	80002d72 <iput+0x26>

0000000080002df4 <iunlockput>:
{
    80002df4:	1101                	addi	sp,sp,-32
    80002df6:	ec06                	sd	ra,24(sp)
    80002df8:	e822                	sd	s0,16(sp)
    80002dfa:	e426                	sd	s1,8(sp)
    80002dfc:	1000                	addi	s0,sp,32
    80002dfe:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e00:	00000097          	auipc	ra,0x0
    80002e04:	e54080e7          	jalr	-428(ra) # 80002c54 <iunlock>
  iput(ip);
    80002e08:	8526                	mv	a0,s1
    80002e0a:	00000097          	auipc	ra,0x0
    80002e0e:	f42080e7          	jalr	-190(ra) # 80002d4c <iput>
}
    80002e12:	60e2                	ld	ra,24(sp)
    80002e14:	6442                	ld	s0,16(sp)
    80002e16:	64a2                	ld	s1,8(sp)
    80002e18:	6105                	addi	sp,sp,32
    80002e1a:	8082                	ret

0000000080002e1c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e1c:	1141                	addi	sp,sp,-16
    80002e1e:	e422                	sd	s0,8(sp)
    80002e20:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e22:	411c                	lw	a5,0(a0)
    80002e24:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e26:	415c                	lw	a5,4(a0)
    80002e28:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e2a:	04451783          	lh	a5,68(a0)
    80002e2e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e32:	04a51783          	lh	a5,74(a0)
    80002e36:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e3a:	04c56783          	lwu	a5,76(a0)
    80002e3e:	e99c                	sd	a5,16(a1)
}
    80002e40:	6422                	ld	s0,8(sp)
    80002e42:	0141                	addi	sp,sp,16
    80002e44:	8082                	ret

0000000080002e46 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e46:	457c                	lw	a5,76(a0)
    80002e48:	0ed7e963          	bltu	a5,a3,80002f3a <readi+0xf4>
{
    80002e4c:	7159                	addi	sp,sp,-112
    80002e4e:	f486                	sd	ra,104(sp)
    80002e50:	f0a2                	sd	s0,96(sp)
    80002e52:	eca6                	sd	s1,88(sp)
    80002e54:	e8ca                	sd	s2,80(sp)
    80002e56:	e4ce                	sd	s3,72(sp)
    80002e58:	e0d2                	sd	s4,64(sp)
    80002e5a:	fc56                	sd	s5,56(sp)
    80002e5c:	f85a                	sd	s6,48(sp)
    80002e5e:	f45e                	sd	s7,40(sp)
    80002e60:	f062                	sd	s8,32(sp)
    80002e62:	ec66                	sd	s9,24(sp)
    80002e64:	e86a                	sd	s10,16(sp)
    80002e66:	e46e                	sd	s11,8(sp)
    80002e68:	1880                	addi	s0,sp,112
    80002e6a:	8baa                	mv	s7,a0
    80002e6c:	8c2e                	mv	s8,a1
    80002e6e:	8ab2                	mv	s5,a2
    80002e70:	84b6                	mv	s1,a3
    80002e72:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e74:	9f35                	addw	a4,a4,a3
    return 0;
    80002e76:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e78:	0ad76063          	bltu	a4,a3,80002f18 <readi+0xd2>
  if(off + n > ip->size)
    80002e7c:	00e7f463          	bgeu	a5,a4,80002e84 <readi+0x3e>
    n = ip->size - off;
    80002e80:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e84:	0a0b0963          	beqz	s6,80002f36 <readi+0xf0>
    80002e88:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e8a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e8e:	5cfd                	li	s9,-1
    80002e90:	a82d                	j	80002eca <readi+0x84>
    80002e92:	020a1d93          	slli	s11,s4,0x20
    80002e96:	020ddd93          	srli	s11,s11,0x20
    80002e9a:	05890793          	addi	a5,s2,88
    80002e9e:	86ee                	mv	a3,s11
    80002ea0:	963e                	add	a2,a2,a5
    80002ea2:	85d6                	mv	a1,s5
    80002ea4:	8562                	mv	a0,s8
    80002ea6:	fffff097          	auipc	ra,0xfffff
    80002eaa:	a0e080e7          	jalr	-1522(ra) # 800018b4 <either_copyout>
    80002eae:	05950d63          	beq	a0,s9,80002f08 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eb2:	854a                	mv	a0,s2
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	60c080e7          	jalr	1548(ra) # 800024c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ebc:	013a09bb          	addw	s3,s4,s3
    80002ec0:	009a04bb          	addw	s1,s4,s1
    80002ec4:	9aee                	add	s5,s5,s11
    80002ec6:	0569f763          	bgeu	s3,s6,80002f14 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002eca:	000ba903          	lw	s2,0(s7)
    80002ece:	00a4d59b          	srliw	a1,s1,0xa
    80002ed2:	855e                	mv	a0,s7
    80002ed4:	00000097          	auipc	ra,0x0
    80002ed8:	8b0080e7          	jalr	-1872(ra) # 80002784 <bmap>
    80002edc:	0005059b          	sext.w	a1,a0
    80002ee0:	854a                	mv	a0,s2
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	4ae080e7          	jalr	1198(ra) # 80002390 <bread>
    80002eea:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eec:	3ff4f613          	andi	a2,s1,1023
    80002ef0:	40cd07bb          	subw	a5,s10,a2
    80002ef4:	413b073b          	subw	a4,s6,s3
    80002ef8:	8a3e                	mv	s4,a5
    80002efa:	2781                	sext.w	a5,a5
    80002efc:	0007069b          	sext.w	a3,a4
    80002f00:	f8f6f9e3          	bgeu	a3,a5,80002e92 <readi+0x4c>
    80002f04:	8a3a                	mv	s4,a4
    80002f06:	b771                	j	80002e92 <readi+0x4c>
      brelse(bp);
    80002f08:	854a                	mv	a0,s2
    80002f0a:	fffff097          	auipc	ra,0xfffff
    80002f0e:	5b6080e7          	jalr	1462(ra) # 800024c0 <brelse>
      tot = -1;
    80002f12:	59fd                	li	s3,-1
  }
  return tot;
    80002f14:	0009851b          	sext.w	a0,s3
}
    80002f18:	70a6                	ld	ra,104(sp)
    80002f1a:	7406                	ld	s0,96(sp)
    80002f1c:	64e6                	ld	s1,88(sp)
    80002f1e:	6946                	ld	s2,80(sp)
    80002f20:	69a6                	ld	s3,72(sp)
    80002f22:	6a06                	ld	s4,64(sp)
    80002f24:	7ae2                	ld	s5,56(sp)
    80002f26:	7b42                	ld	s6,48(sp)
    80002f28:	7ba2                	ld	s7,40(sp)
    80002f2a:	7c02                	ld	s8,32(sp)
    80002f2c:	6ce2                	ld	s9,24(sp)
    80002f2e:	6d42                	ld	s10,16(sp)
    80002f30:	6da2                	ld	s11,8(sp)
    80002f32:	6165                	addi	sp,sp,112
    80002f34:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f36:	89da                	mv	s3,s6
    80002f38:	bff1                	j	80002f14 <readi+0xce>
    return 0;
    80002f3a:	4501                	li	a0,0
}
    80002f3c:	8082                	ret

0000000080002f3e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f3e:	457c                	lw	a5,76(a0)
    80002f40:	10d7e863          	bltu	a5,a3,80003050 <writei+0x112>
{
    80002f44:	7159                	addi	sp,sp,-112
    80002f46:	f486                	sd	ra,104(sp)
    80002f48:	f0a2                	sd	s0,96(sp)
    80002f4a:	eca6                	sd	s1,88(sp)
    80002f4c:	e8ca                	sd	s2,80(sp)
    80002f4e:	e4ce                	sd	s3,72(sp)
    80002f50:	e0d2                	sd	s4,64(sp)
    80002f52:	fc56                	sd	s5,56(sp)
    80002f54:	f85a                	sd	s6,48(sp)
    80002f56:	f45e                	sd	s7,40(sp)
    80002f58:	f062                	sd	s8,32(sp)
    80002f5a:	ec66                	sd	s9,24(sp)
    80002f5c:	e86a                	sd	s10,16(sp)
    80002f5e:	e46e                	sd	s11,8(sp)
    80002f60:	1880                	addi	s0,sp,112
    80002f62:	8b2a                	mv	s6,a0
    80002f64:	8c2e                	mv	s8,a1
    80002f66:	8ab2                	mv	s5,a2
    80002f68:	8936                	mv	s2,a3
    80002f6a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f6c:	00e687bb          	addw	a5,a3,a4
    80002f70:	0ed7e263          	bltu	a5,a3,80003054 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f74:	00043737          	lui	a4,0x43
    80002f78:	0ef76063          	bltu	a4,a5,80003058 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f7c:	0c0b8863          	beqz	s7,8000304c <writei+0x10e>
    80002f80:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f82:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f86:	5cfd                	li	s9,-1
    80002f88:	a091                	j	80002fcc <writei+0x8e>
    80002f8a:	02099d93          	slli	s11,s3,0x20
    80002f8e:	020ddd93          	srli	s11,s11,0x20
    80002f92:	05848793          	addi	a5,s1,88
    80002f96:	86ee                	mv	a3,s11
    80002f98:	8656                	mv	a2,s5
    80002f9a:	85e2                	mv	a1,s8
    80002f9c:	953e                	add	a0,a0,a5
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	96c080e7          	jalr	-1684(ra) # 8000190a <either_copyin>
    80002fa6:	07950263          	beq	a0,s9,8000300a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002faa:	8526                	mv	a0,s1
    80002fac:	00000097          	auipc	ra,0x0
    80002fb0:	790080e7          	jalr	1936(ra) # 8000373c <log_write>
    brelse(bp);
    80002fb4:	8526                	mv	a0,s1
    80002fb6:	fffff097          	auipc	ra,0xfffff
    80002fba:	50a080e7          	jalr	1290(ra) # 800024c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fbe:	01498a3b          	addw	s4,s3,s4
    80002fc2:	0129893b          	addw	s2,s3,s2
    80002fc6:	9aee                	add	s5,s5,s11
    80002fc8:	057a7663          	bgeu	s4,s7,80003014 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fcc:	000b2483          	lw	s1,0(s6)
    80002fd0:	00a9559b          	srliw	a1,s2,0xa
    80002fd4:	855a                	mv	a0,s6
    80002fd6:	fffff097          	auipc	ra,0xfffff
    80002fda:	7ae080e7          	jalr	1966(ra) # 80002784 <bmap>
    80002fde:	0005059b          	sext.w	a1,a0
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	3ac080e7          	jalr	940(ra) # 80002390 <bread>
    80002fec:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fee:	3ff97513          	andi	a0,s2,1023
    80002ff2:	40ad07bb          	subw	a5,s10,a0
    80002ff6:	414b873b          	subw	a4,s7,s4
    80002ffa:	89be                	mv	s3,a5
    80002ffc:	2781                	sext.w	a5,a5
    80002ffe:	0007069b          	sext.w	a3,a4
    80003002:	f8f6f4e3          	bgeu	a3,a5,80002f8a <writei+0x4c>
    80003006:	89ba                	mv	s3,a4
    80003008:	b749                	j	80002f8a <writei+0x4c>
      brelse(bp);
    8000300a:	8526                	mv	a0,s1
    8000300c:	fffff097          	auipc	ra,0xfffff
    80003010:	4b4080e7          	jalr	1204(ra) # 800024c0 <brelse>
  }

  if(off > ip->size)
    80003014:	04cb2783          	lw	a5,76(s6)
    80003018:	0127f463          	bgeu	a5,s2,80003020 <writei+0xe2>
    ip->size = off;
    8000301c:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003020:	855a                	mv	a0,s6
    80003022:	00000097          	auipc	ra,0x0
    80003026:	aa6080e7          	jalr	-1370(ra) # 80002ac8 <iupdate>

  return tot;
    8000302a:	000a051b          	sext.w	a0,s4
}
    8000302e:	70a6                	ld	ra,104(sp)
    80003030:	7406                	ld	s0,96(sp)
    80003032:	64e6                	ld	s1,88(sp)
    80003034:	6946                	ld	s2,80(sp)
    80003036:	69a6                	ld	s3,72(sp)
    80003038:	6a06                	ld	s4,64(sp)
    8000303a:	7ae2                	ld	s5,56(sp)
    8000303c:	7b42                	ld	s6,48(sp)
    8000303e:	7ba2                	ld	s7,40(sp)
    80003040:	7c02                	ld	s8,32(sp)
    80003042:	6ce2                	ld	s9,24(sp)
    80003044:	6d42                	ld	s10,16(sp)
    80003046:	6da2                	ld	s11,8(sp)
    80003048:	6165                	addi	sp,sp,112
    8000304a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000304c:	8a5e                	mv	s4,s7
    8000304e:	bfc9                	j	80003020 <writei+0xe2>
    return -1;
    80003050:	557d                	li	a0,-1
}
    80003052:	8082                	ret
    return -1;
    80003054:	557d                	li	a0,-1
    80003056:	bfe1                	j	8000302e <writei+0xf0>
    return -1;
    80003058:	557d                	li	a0,-1
    8000305a:	bfd1                	j	8000302e <writei+0xf0>

000000008000305c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000305c:	1141                	addi	sp,sp,-16
    8000305e:	e406                	sd	ra,8(sp)
    80003060:	e022                	sd	s0,0(sp)
    80003062:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003064:	4639                	li	a2,14
    80003066:	ffffd097          	auipc	ra,0xffffd
    8000306a:	1e2080e7          	jalr	482(ra) # 80000248 <strncmp>
}
    8000306e:	60a2                	ld	ra,8(sp)
    80003070:	6402                	ld	s0,0(sp)
    80003072:	0141                	addi	sp,sp,16
    80003074:	8082                	ret

0000000080003076 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003076:	7139                	addi	sp,sp,-64
    80003078:	fc06                	sd	ra,56(sp)
    8000307a:	f822                	sd	s0,48(sp)
    8000307c:	f426                	sd	s1,40(sp)
    8000307e:	f04a                	sd	s2,32(sp)
    80003080:	ec4e                	sd	s3,24(sp)
    80003082:	e852                	sd	s4,16(sp)
    80003084:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003086:	04451703          	lh	a4,68(a0)
    8000308a:	4785                	li	a5,1
    8000308c:	00f71a63          	bne	a4,a5,800030a0 <dirlookup+0x2a>
    80003090:	892a                	mv	s2,a0
    80003092:	89ae                	mv	s3,a1
    80003094:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003096:	457c                	lw	a5,76(a0)
    80003098:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000309a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000309c:	e79d                	bnez	a5,800030ca <dirlookup+0x54>
    8000309e:	a8a5                	j	80003116 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030a0:	00005517          	auipc	a0,0x5
    800030a4:	3e050513          	addi	a0,a0,992 # 80008480 <etext+0x480>
    800030a8:	00003097          	auipc	ra,0x3
    800030ac:	bd6080e7          	jalr	-1066(ra) # 80005c7e <panic>
      panic("dirlookup read");
    800030b0:	00005517          	auipc	a0,0x5
    800030b4:	3e850513          	addi	a0,a0,1000 # 80008498 <etext+0x498>
    800030b8:	00003097          	auipc	ra,0x3
    800030bc:	bc6080e7          	jalr	-1082(ra) # 80005c7e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c0:	24c1                	addiw	s1,s1,16
    800030c2:	04c92783          	lw	a5,76(s2)
    800030c6:	04f4f763          	bgeu	s1,a5,80003114 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030ca:	4741                	li	a4,16
    800030cc:	86a6                	mv	a3,s1
    800030ce:	fc040613          	addi	a2,s0,-64
    800030d2:	4581                	li	a1,0
    800030d4:	854a                	mv	a0,s2
    800030d6:	00000097          	auipc	ra,0x0
    800030da:	d70080e7          	jalr	-656(ra) # 80002e46 <readi>
    800030de:	47c1                	li	a5,16
    800030e0:	fcf518e3          	bne	a0,a5,800030b0 <dirlookup+0x3a>
    if(de.inum == 0)
    800030e4:	fc045783          	lhu	a5,-64(s0)
    800030e8:	dfe1                	beqz	a5,800030c0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030ea:	fc240593          	addi	a1,s0,-62
    800030ee:	854e                	mv	a0,s3
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	f6c080e7          	jalr	-148(ra) # 8000305c <namecmp>
    800030f8:	f561                	bnez	a0,800030c0 <dirlookup+0x4a>
      if(poff)
    800030fa:	000a0463          	beqz	s4,80003102 <dirlookup+0x8c>
        *poff = off;
    800030fe:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003102:	fc045583          	lhu	a1,-64(s0)
    80003106:	00092503          	lw	a0,0(s2)
    8000310a:	fffff097          	auipc	ra,0xfffff
    8000310e:	754080e7          	jalr	1876(ra) # 8000285e <iget>
    80003112:	a011                	j	80003116 <dirlookup+0xa0>
  return 0;
    80003114:	4501                	li	a0,0
}
    80003116:	70e2                	ld	ra,56(sp)
    80003118:	7442                	ld	s0,48(sp)
    8000311a:	74a2                	ld	s1,40(sp)
    8000311c:	7902                	ld	s2,32(sp)
    8000311e:	69e2                	ld	s3,24(sp)
    80003120:	6a42                	ld	s4,16(sp)
    80003122:	6121                	addi	sp,sp,64
    80003124:	8082                	ret

0000000080003126 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003126:	711d                	addi	sp,sp,-96
    80003128:	ec86                	sd	ra,88(sp)
    8000312a:	e8a2                	sd	s0,80(sp)
    8000312c:	e4a6                	sd	s1,72(sp)
    8000312e:	e0ca                	sd	s2,64(sp)
    80003130:	fc4e                	sd	s3,56(sp)
    80003132:	f852                	sd	s4,48(sp)
    80003134:	f456                	sd	s5,40(sp)
    80003136:	f05a                	sd	s6,32(sp)
    80003138:	ec5e                	sd	s7,24(sp)
    8000313a:	e862                	sd	s8,16(sp)
    8000313c:	e466                	sd	s9,8(sp)
    8000313e:	1080                	addi	s0,sp,96
    80003140:	84aa                	mv	s1,a0
    80003142:	8aae                	mv	s5,a1
    80003144:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003146:	00054703          	lbu	a4,0(a0)
    8000314a:	02f00793          	li	a5,47
    8000314e:	02f70363          	beq	a4,a5,80003174 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003152:	ffffe097          	auipc	ra,0xffffe
    80003156:	cf0080e7          	jalr	-784(ra) # 80000e42 <myproc>
    8000315a:	15053503          	ld	a0,336(a0)
    8000315e:	00000097          	auipc	ra,0x0
    80003162:	9f6080e7          	jalr	-1546(ra) # 80002b54 <idup>
    80003166:	89aa                	mv	s3,a0
  while(*path == '/')
    80003168:	02f00913          	li	s2,47
  len = path - s;
    8000316c:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000316e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003170:	4b85                	li	s7,1
    80003172:	a865                	j	8000322a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003174:	4585                	li	a1,1
    80003176:	4505                	li	a0,1
    80003178:	fffff097          	auipc	ra,0xfffff
    8000317c:	6e6080e7          	jalr	1766(ra) # 8000285e <iget>
    80003180:	89aa                	mv	s3,a0
    80003182:	b7dd                	j	80003168 <namex+0x42>
      iunlockput(ip);
    80003184:	854e                	mv	a0,s3
    80003186:	00000097          	auipc	ra,0x0
    8000318a:	c6e080e7          	jalr	-914(ra) # 80002df4 <iunlockput>
      return 0;
    8000318e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003190:	854e                	mv	a0,s3
    80003192:	60e6                	ld	ra,88(sp)
    80003194:	6446                	ld	s0,80(sp)
    80003196:	64a6                	ld	s1,72(sp)
    80003198:	6906                	ld	s2,64(sp)
    8000319a:	79e2                	ld	s3,56(sp)
    8000319c:	7a42                	ld	s4,48(sp)
    8000319e:	7aa2                	ld	s5,40(sp)
    800031a0:	7b02                	ld	s6,32(sp)
    800031a2:	6be2                	ld	s7,24(sp)
    800031a4:	6c42                	ld	s8,16(sp)
    800031a6:	6ca2                	ld	s9,8(sp)
    800031a8:	6125                	addi	sp,sp,96
    800031aa:	8082                	ret
      iunlock(ip);
    800031ac:	854e                	mv	a0,s3
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	aa6080e7          	jalr	-1370(ra) # 80002c54 <iunlock>
      return ip;
    800031b6:	bfe9                	j	80003190 <namex+0x6a>
      iunlockput(ip);
    800031b8:	854e                	mv	a0,s3
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	c3a080e7          	jalr	-966(ra) # 80002df4 <iunlockput>
      return 0;
    800031c2:	89e6                	mv	s3,s9
    800031c4:	b7f1                	j	80003190 <namex+0x6a>
  len = path - s;
    800031c6:	40b48633          	sub	a2,s1,a1
    800031ca:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800031ce:	099c5463          	bge	s8,s9,80003256 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031d2:	4639                	li	a2,14
    800031d4:	8552                	mv	a0,s4
    800031d6:	ffffd097          	auipc	ra,0xffffd
    800031da:	ffe080e7          	jalr	-2(ra) # 800001d4 <memmove>
  while(*path == '/')
    800031de:	0004c783          	lbu	a5,0(s1)
    800031e2:	01279763          	bne	a5,s2,800031f0 <namex+0xca>
    path++;
    800031e6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031e8:	0004c783          	lbu	a5,0(s1)
    800031ec:	ff278de3          	beq	a5,s2,800031e6 <namex+0xc0>
    ilock(ip);
    800031f0:	854e                	mv	a0,s3
    800031f2:	00000097          	auipc	ra,0x0
    800031f6:	9a0080e7          	jalr	-1632(ra) # 80002b92 <ilock>
    if(ip->type != T_DIR){
    800031fa:	04499783          	lh	a5,68(s3)
    800031fe:	f97793e3          	bne	a5,s7,80003184 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003202:	000a8563          	beqz	s5,8000320c <namex+0xe6>
    80003206:	0004c783          	lbu	a5,0(s1)
    8000320a:	d3cd                	beqz	a5,800031ac <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000320c:	865a                	mv	a2,s6
    8000320e:	85d2                	mv	a1,s4
    80003210:	854e                	mv	a0,s3
    80003212:	00000097          	auipc	ra,0x0
    80003216:	e64080e7          	jalr	-412(ra) # 80003076 <dirlookup>
    8000321a:	8caa                	mv	s9,a0
    8000321c:	dd51                	beqz	a0,800031b8 <namex+0x92>
    iunlockput(ip);
    8000321e:	854e                	mv	a0,s3
    80003220:	00000097          	auipc	ra,0x0
    80003224:	bd4080e7          	jalr	-1068(ra) # 80002df4 <iunlockput>
    ip = next;
    80003228:	89e6                	mv	s3,s9
  while(*path == '/')
    8000322a:	0004c783          	lbu	a5,0(s1)
    8000322e:	05279763          	bne	a5,s2,8000327c <namex+0x156>
    path++;
    80003232:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003234:	0004c783          	lbu	a5,0(s1)
    80003238:	ff278de3          	beq	a5,s2,80003232 <namex+0x10c>
  if(*path == 0)
    8000323c:	c79d                	beqz	a5,8000326a <namex+0x144>
    path++;
    8000323e:	85a6                	mv	a1,s1
  len = path - s;
    80003240:	8cda                	mv	s9,s6
    80003242:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003244:	01278963          	beq	a5,s2,80003256 <namex+0x130>
    80003248:	dfbd                	beqz	a5,800031c6 <namex+0xa0>
    path++;
    8000324a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000324c:	0004c783          	lbu	a5,0(s1)
    80003250:	ff279ce3          	bne	a5,s2,80003248 <namex+0x122>
    80003254:	bf8d                	j	800031c6 <namex+0xa0>
    memmove(name, s, len);
    80003256:	2601                	sext.w	a2,a2
    80003258:	8552                	mv	a0,s4
    8000325a:	ffffd097          	auipc	ra,0xffffd
    8000325e:	f7a080e7          	jalr	-134(ra) # 800001d4 <memmove>
    name[len] = 0;
    80003262:	9cd2                	add	s9,s9,s4
    80003264:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003268:	bf9d                	j	800031de <namex+0xb8>
  if(nameiparent){
    8000326a:	f20a83e3          	beqz	s5,80003190 <namex+0x6a>
    iput(ip);
    8000326e:	854e                	mv	a0,s3
    80003270:	00000097          	auipc	ra,0x0
    80003274:	adc080e7          	jalr	-1316(ra) # 80002d4c <iput>
    return 0;
    80003278:	4981                	li	s3,0
    8000327a:	bf19                	j	80003190 <namex+0x6a>
  if(*path == 0)
    8000327c:	d7fd                	beqz	a5,8000326a <namex+0x144>
  while(*path != '/' && *path != 0)
    8000327e:	0004c783          	lbu	a5,0(s1)
    80003282:	85a6                	mv	a1,s1
    80003284:	b7d1                	j	80003248 <namex+0x122>

0000000080003286 <dirlink>:
{
    80003286:	7139                	addi	sp,sp,-64
    80003288:	fc06                	sd	ra,56(sp)
    8000328a:	f822                	sd	s0,48(sp)
    8000328c:	f426                	sd	s1,40(sp)
    8000328e:	f04a                	sd	s2,32(sp)
    80003290:	ec4e                	sd	s3,24(sp)
    80003292:	e852                	sd	s4,16(sp)
    80003294:	0080                	addi	s0,sp,64
    80003296:	892a                	mv	s2,a0
    80003298:	8a2e                	mv	s4,a1
    8000329a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000329c:	4601                	li	a2,0
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	dd8080e7          	jalr	-552(ra) # 80003076 <dirlookup>
    800032a6:	e93d                	bnez	a0,8000331c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a8:	04c92483          	lw	s1,76(s2)
    800032ac:	c49d                	beqz	s1,800032da <dirlink+0x54>
    800032ae:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032b0:	4741                	li	a4,16
    800032b2:	86a6                	mv	a3,s1
    800032b4:	fc040613          	addi	a2,s0,-64
    800032b8:	4581                	li	a1,0
    800032ba:	854a                	mv	a0,s2
    800032bc:	00000097          	auipc	ra,0x0
    800032c0:	b8a080e7          	jalr	-1142(ra) # 80002e46 <readi>
    800032c4:	47c1                	li	a5,16
    800032c6:	06f51163          	bne	a0,a5,80003328 <dirlink+0xa2>
    if(de.inum == 0)
    800032ca:	fc045783          	lhu	a5,-64(s0)
    800032ce:	c791                	beqz	a5,800032da <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d0:	24c1                	addiw	s1,s1,16
    800032d2:	04c92783          	lw	a5,76(s2)
    800032d6:	fcf4ede3          	bltu	s1,a5,800032b0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032da:	4639                	li	a2,14
    800032dc:	85d2                	mv	a1,s4
    800032de:	fc240513          	addi	a0,s0,-62
    800032e2:	ffffd097          	auipc	ra,0xffffd
    800032e6:	fa2080e7          	jalr	-94(ra) # 80000284 <strncpy>
  de.inum = inum;
    800032ea:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ee:	4741                	li	a4,16
    800032f0:	86a6                	mv	a3,s1
    800032f2:	fc040613          	addi	a2,s0,-64
    800032f6:	4581                	li	a1,0
    800032f8:	854a                	mv	a0,s2
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	c44080e7          	jalr	-956(ra) # 80002f3e <writei>
    80003302:	872a                	mv	a4,a0
    80003304:	47c1                	li	a5,16
  return 0;
    80003306:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003308:	02f71863          	bne	a4,a5,80003338 <dirlink+0xb2>
}
    8000330c:	70e2                	ld	ra,56(sp)
    8000330e:	7442                	ld	s0,48(sp)
    80003310:	74a2                	ld	s1,40(sp)
    80003312:	7902                	ld	s2,32(sp)
    80003314:	69e2                	ld	s3,24(sp)
    80003316:	6a42                	ld	s4,16(sp)
    80003318:	6121                	addi	sp,sp,64
    8000331a:	8082                	ret
    iput(ip);
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	a30080e7          	jalr	-1488(ra) # 80002d4c <iput>
    return -1;
    80003324:	557d                	li	a0,-1
    80003326:	b7dd                	j	8000330c <dirlink+0x86>
      panic("dirlink read");
    80003328:	00005517          	auipc	a0,0x5
    8000332c:	18050513          	addi	a0,a0,384 # 800084a8 <etext+0x4a8>
    80003330:	00003097          	auipc	ra,0x3
    80003334:	94e080e7          	jalr	-1714(ra) # 80005c7e <panic>
    panic("dirlink");
    80003338:	00005517          	auipc	a0,0x5
    8000333c:	28050513          	addi	a0,a0,640 # 800085b8 <etext+0x5b8>
    80003340:	00003097          	auipc	ra,0x3
    80003344:	93e080e7          	jalr	-1730(ra) # 80005c7e <panic>

0000000080003348 <namei>:

struct inode*
namei(char *path)
{
    80003348:	1101                	addi	sp,sp,-32
    8000334a:	ec06                	sd	ra,24(sp)
    8000334c:	e822                	sd	s0,16(sp)
    8000334e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003350:	fe040613          	addi	a2,s0,-32
    80003354:	4581                	li	a1,0
    80003356:	00000097          	auipc	ra,0x0
    8000335a:	dd0080e7          	jalr	-560(ra) # 80003126 <namex>
}
    8000335e:	60e2                	ld	ra,24(sp)
    80003360:	6442                	ld	s0,16(sp)
    80003362:	6105                	addi	sp,sp,32
    80003364:	8082                	ret

0000000080003366 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003366:	1141                	addi	sp,sp,-16
    80003368:	e406                	sd	ra,8(sp)
    8000336a:	e022                	sd	s0,0(sp)
    8000336c:	0800                	addi	s0,sp,16
    8000336e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003370:	4585                	li	a1,1
    80003372:	00000097          	auipc	ra,0x0
    80003376:	db4080e7          	jalr	-588(ra) # 80003126 <namex>
}
    8000337a:	60a2                	ld	ra,8(sp)
    8000337c:	6402                	ld	s0,0(sp)
    8000337e:	0141                	addi	sp,sp,16
    80003380:	8082                	ret

0000000080003382 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003382:	1101                	addi	sp,sp,-32
    80003384:	ec06                	sd	ra,24(sp)
    80003386:	e822                	sd	s0,16(sp)
    80003388:	e426                	sd	s1,8(sp)
    8000338a:	e04a                	sd	s2,0(sp)
    8000338c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000338e:	0001b917          	auipc	s2,0x1b
    80003392:	a9290913          	addi	s2,s2,-1390 # 8001de20 <log>
    80003396:	01892583          	lw	a1,24(s2)
    8000339a:	02892503          	lw	a0,40(s2)
    8000339e:	fffff097          	auipc	ra,0xfffff
    800033a2:	ff2080e7          	jalr	-14(ra) # 80002390 <bread>
    800033a6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033a8:	02c92683          	lw	a3,44(s2)
    800033ac:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033ae:	02d05763          	blez	a3,800033dc <write_head+0x5a>
    800033b2:	0001b797          	auipc	a5,0x1b
    800033b6:	a9e78793          	addi	a5,a5,-1378 # 8001de50 <log+0x30>
    800033ba:	05c50713          	addi	a4,a0,92
    800033be:	36fd                	addiw	a3,a3,-1
    800033c0:	1682                	slli	a3,a3,0x20
    800033c2:	9281                	srli	a3,a3,0x20
    800033c4:	068a                	slli	a3,a3,0x2
    800033c6:	0001b617          	auipc	a2,0x1b
    800033ca:	a8e60613          	addi	a2,a2,-1394 # 8001de54 <log+0x34>
    800033ce:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033d0:	4390                	lw	a2,0(a5)
    800033d2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033d4:	0791                	addi	a5,a5,4
    800033d6:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800033d8:	fed79ce3          	bne	a5,a3,800033d0 <write_head+0x4e>
  }
  bwrite(buf);
    800033dc:	8526                	mv	a0,s1
    800033de:	fffff097          	auipc	ra,0xfffff
    800033e2:	0a4080e7          	jalr	164(ra) # 80002482 <bwrite>
  brelse(buf);
    800033e6:	8526                	mv	a0,s1
    800033e8:	fffff097          	auipc	ra,0xfffff
    800033ec:	0d8080e7          	jalr	216(ra) # 800024c0 <brelse>
}
    800033f0:	60e2                	ld	ra,24(sp)
    800033f2:	6442                	ld	s0,16(sp)
    800033f4:	64a2                	ld	s1,8(sp)
    800033f6:	6902                	ld	s2,0(sp)
    800033f8:	6105                	addi	sp,sp,32
    800033fa:	8082                	ret

00000000800033fc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033fc:	0001b797          	auipc	a5,0x1b
    80003400:	a507a783          	lw	a5,-1456(a5) # 8001de4c <log+0x2c>
    80003404:	0af05d63          	blez	a5,800034be <install_trans+0xc2>
{
    80003408:	7139                	addi	sp,sp,-64
    8000340a:	fc06                	sd	ra,56(sp)
    8000340c:	f822                	sd	s0,48(sp)
    8000340e:	f426                	sd	s1,40(sp)
    80003410:	f04a                	sd	s2,32(sp)
    80003412:	ec4e                	sd	s3,24(sp)
    80003414:	e852                	sd	s4,16(sp)
    80003416:	e456                	sd	s5,8(sp)
    80003418:	e05a                	sd	s6,0(sp)
    8000341a:	0080                	addi	s0,sp,64
    8000341c:	8b2a                	mv	s6,a0
    8000341e:	0001ba97          	auipc	s5,0x1b
    80003422:	a32a8a93          	addi	s5,s5,-1486 # 8001de50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003426:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003428:	0001b997          	auipc	s3,0x1b
    8000342c:	9f898993          	addi	s3,s3,-1544 # 8001de20 <log>
    80003430:	a00d                	j	80003452 <install_trans+0x56>
    brelse(lbuf);
    80003432:	854a                	mv	a0,s2
    80003434:	fffff097          	auipc	ra,0xfffff
    80003438:	08c080e7          	jalr	140(ra) # 800024c0 <brelse>
    brelse(dbuf);
    8000343c:	8526                	mv	a0,s1
    8000343e:	fffff097          	auipc	ra,0xfffff
    80003442:	082080e7          	jalr	130(ra) # 800024c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003446:	2a05                	addiw	s4,s4,1
    80003448:	0a91                	addi	s5,s5,4
    8000344a:	02c9a783          	lw	a5,44(s3)
    8000344e:	04fa5e63          	bge	s4,a5,800034aa <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003452:	0189a583          	lw	a1,24(s3)
    80003456:	014585bb          	addw	a1,a1,s4
    8000345a:	2585                	addiw	a1,a1,1
    8000345c:	0289a503          	lw	a0,40(s3)
    80003460:	fffff097          	auipc	ra,0xfffff
    80003464:	f30080e7          	jalr	-208(ra) # 80002390 <bread>
    80003468:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000346a:	000aa583          	lw	a1,0(s5)
    8000346e:	0289a503          	lw	a0,40(s3)
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	f1e080e7          	jalr	-226(ra) # 80002390 <bread>
    8000347a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000347c:	40000613          	li	a2,1024
    80003480:	05890593          	addi	a1,s2,88
    80003484:	05850513          	addi	a0,a0,88
    80003488:	ffffd097          	auipc	ra,0xffffd
    8000348c:	d4c080e7          	jalr	-692(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003490:	8526                	mv	a0,s1
    80003492:	fffff097          	auipc	ra,0xfffff
    80003496:	ff0080e7          	jalr	-16(ra) # 80002482 <bwrite>
    if(recovering == 0)
    8000349a:	f80b1ce3          	bnez	s6,80003432 <install_trans+0x36>
      bunpin(dbuf);
    8000349e:	8526                	mv	a0,s1
    800034a0:	fffff097          	auipc	ra,0xfffff
    800034a4:	0fa080e7          	jalr	250(ra) # 8000259a <bunpin>
    800034a8:	b769                	j	80003432 <install_trans+0x36>
}
    800034aa:	70e2                	ld	ra,56(sp)
    800034ac:	7442                	ld	s0,48(sp)
    800034ae:	74a2                	ld	s1,40(sp)
    800034b0:	7902                	ld	s2,32(sp)
    800034b2:	69e2                	ld	s3,24(sp)
    800034b4:	6a42                	ld	s4,16(sp)
    800034b6:	6aa2                	ld	s5,8(sp)
    800034b8:	6b02                	ld	s6,0(sp)
    800034ba:	6121                	addi	sp,sp,64
    800034bc:	8082                	ret
    800034be:	8082                	ret

00000000800034c0 <initlog>:
{
    800034c0:	7179                	addi	sp,sp,-48
    800034c2:	f406                	sd	ra,40(sp)
    800034c4:	f022                	sd	s0,32(sp)
    800034c6:	ec26                	sd	s1,24(sp)
    800034c8:	e84a                	sd	s2,16(sp)
    800034ca:	e44e                	sd	s3,8(sp)
    800034cc:	1800                	addi	s0,sp,48
    800034ce:	892a                	mv	s2,a0
    800034d0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034d2:	0001b497          	auipc	s1,0x1b
    800034d6:	94e48493          	addi	s1,s1,-1714 # 8001de20 <log>
    800034da:	00005597          	auipc	a1,0x5
    800034de:	fde58593          	addi	a1,a1,-34 # 800084b8 <etext+0x4b8>
    800034e2:	8526                	mv	a0,s1
    800034e4:	00003097          	auipc	ra,0x3
    800034e8:	c1c080e7          	jalr	-996(ra) # 80006100 <initlock>
  log.start = sb->logstart;
    800034ec:	0149a583          	lw	a1,20(s3)
    800034f0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034f2:	0109a783          	lw	a5,16(s3)
    800034f6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034f8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034fc:	854a                	mv	a0,s2
    800034fe:	fffff097          	auipc	ra,0xfffff
    80003502:	e92080e7          	jalr	-366(ra) # 80002390 <bread>
  log.lh.n = lh->n;
    80003506:	4d34                	lw	a3,88(a0)
    80003508:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000350a:	02d05563          	blez	a3,80003534 <initlog+0x74>
    8000350e:	05c50793          	addi	a5,a0,92
    80003512:	0001b717          	auipc	a4,0x1b
    80003516:	93e70713          	addi	a4,a4,-1730 # 8001de50 <log+0x30>
    8000351a:	36fd                	addiw	a3,a3,-1
    8000351c:	1682                	slli	a3,a3,0x20
    8000351e:	9281                	srli	a3,a3,0x20
    80003520:	068a                	slli	a3,a3,0x2
    80003522:	06050613          	addi	a2,a0,96
    80003526:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003528:	4390                	lw	a2,0(a5)
    8000352a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000352c:	0791                	addi	a5,a5,4
    8000352e:	0711                	addi	a4,a4,4
    80003530:	fed79ce3          	bne	a5,a3,80003528 <initlog+0x68>
  brelse(buf);
    80003534:	fffff097          	auipc	ra,0xfffff
    80003538:	f8c080e7          	jalr	-116(ra) # 800024c0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000353c:	4505                	li	a0,1
    8000353e:	00000097          	auipc	ra,0x0
    80003542:	ebe080e7          	jalr	-322(ra) # 800033fc <install_trans>
  log.lh.n = 0;
    80003546:	0001b797          	auipc	a5,0x1b
    8000354a:	9007a323          	sw	zero,-1786(a5) # 8001de4c <log+0x2c>
  write_head(); // clear the log
    8000354e:	00000097          	auipc	ra,0x0
    80003552:	e34080e7          	jalr	-460(ra) # 80003382 <write_head>
}
    80003556:	70a2                	ld	ra,40(sp)
    80003558:	7402                	ld	s0,32(sp)
    8000355a:	64e2                	ld	s1,24(sp)
    8000355c:	6942                	ld	s2,16(sp)
    8000355e:	69a2                	ld	s3,8(sp)
    80003560:	6145                	addi	sp,sp,48
    80003562:	8082                	ret

0000000080003564 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003564:	1101                	addi	sp,sp,-32
    80003566:	ec06                	sd	ra,24(sp)
    80003568:	e822                	sd	s0,16(sp)
    8000356a:	e426                	sd	s1,8(sp)
    8000356c:	e04a                	sd	s2,0(sp)
    8000356e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003570:	0001b517          	auipc	a0,0x1b
    80003574:	8b050513          	addi	a0,a0,-1872 # 8001de20 <log>
    80003578:	00003097          	auipc	ra,0x3
    8000357c:	c18080e7          	jalr	-1000(ra) # 80006190 <acquire>
  while(1){
    if(log.committing){
    80003580:	0001b497          	auipc	s1,0x1b
    80003584:	8a048493          	addi	s1,s1,-1888 # 8001de20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003588:	4979                	li	s2,30
    8000358a:	a039                	j	80003598 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000358c:	85a6                	mv	a1,s1
    8000358e:	8526                	mv	a0,s1
    80003590:	ffffe097          	auipc	ra,0xffffe
    80003594:	f80080e7          	jalr	-128(ra) # 80001510 <sleep>
    if(log.committing){
    80003598:	50dc                	lw	a5,36(s1)
    8000359a:	fbed                	bnez	a5,8000358c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000359c:	509c                	lw	a5,32(s1)
    8000359e:	0017871b          	addiw	a4,a5,1
    800035a2:	0007069b          	sext.w	a3,a4
    800035a6:	0027179b          	slliw	a5,a4,0x2
    800035aa:	9fb9                	addw	a5,a5,a4
    800035ac:	0017979b          	slliw	a5,a5,0x1
    800035b0:	54d8                	lw	a4,44(s1)
    800035b2:	9fb9                	addw	a5,a5,a4
    800035b4:	00f95963          	bge	s2,a5,800035c6 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035b8:	85a6                	mv	a1,s1
    800035ba:	8526                	mv	a0,s1
    800035bc:	ffffe097          	auipc	ra,0xffffe
    800035c0:	f54080e7          	jalr	-172(ra) # 80001510 <sleep>
    800035c4:	bfd1                	j	80003598 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035c6:	0001b517          	auipc	a0,0x1b
    800035ca:	85a50513          	addi	a0,a0,-1958 # 8001de20 <log>
    800035ce:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035d0:	00003097          	auipc	ra,0x3
    800035d4:	c74080e7          	jalr	-908(ra) # 80006244 <release>
      break;
    }
  }
}
    800035d8:	60e2                	ld	ra,24(sp)
    800035da:	6442                	ld	s0,16(sp)
    800035dc:	64a2                	ld	s1,8(sp)
    800035de:	6902                	ld	s2,0(sp)
    800035e0:	6105                	addi	sp,sp,32
    800035e2:	8082                	ret

00000000800035e4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035e4:	7139                	addi	sp,sp,-64
    800035e6:	fc06                	sd	ra,56(sp)
    800035e8:	f822                	sd	s0,48(sp)
    800035ea:	f426                	sd	s1,40(sp)
    800035ec:	f04a                	sd	s2,32(sp)
    800035ee:	ec4e                	sd	s3,24(sp)
    800035f0:	e852                	sd	s4,16(sp)
    800035f2:	e456                	sd	s5,8(sp)
    800035f4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035f6:	0001b497          	auipc	s1,0x1b
    800035fa:	82a48493          	addi	s1,s1,-2006 # 8001de20 <log>
    800035fe:	8526                	mv	a0,s1
    80003600:	00003097          	auipc	ra,0x3
    80003604:	b90080e7          	jalr	-1136(ra) # 80006190 <acquire>
  log.outstanding -= 1;
    80003608:	509c                	lw	a5,32(s1)
    8000360a:	37fd                	addiw	a5,a5,-1
    8000360c:	0007891b          	sext.w	s2,a5
    80003610:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003612:	50dc                	lw	a5,36(s1)
    80003614:	e7b9                	bnez	a5,80003662 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003616:	04091e63          	bnez	s2,80003672 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000361a:	0001b497          	auipc	s1,0x1b
    8000361e:	80648493          	addi	s1,s1,-2042 # 8001de20 <log>
    80003622:	4785                	li	a5,1
    80003624:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003626:	8526                	mv	a0,s1
    80003628:	00003097          	auipc	ra,0x3
    8000362c:	c1c080e7          	jalr	-996(ra) # 80006244 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003630:	54dc                	lw	a5,44(s1)
    80003632:	06f04763          	bgtz	a5,800036a0 <end_op+0xbc>
    acquire(&log.lock);
    80003636:	0001a497          	auipc	s1,0x1a
    8000363a:	7ea48493          	addi	s1,s1,2026 # 8001de20 <log>
    8000363e:	8526                	mv	a0,s1
    80003640:	00003097          	auipc	ra,0x3
    80003644:	b50080e7          	jalr	-1200(ra) # 80006190 <acquire>
    log.committing = 0;
    80003648:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000364c:	8526                	mv	a0,s1
    8000364e:	ffffe097          	auipc	ra,0xffffe
    80003652:	04e080e7          	jalr	78(ra) # 8000169c <wakeup>
    release(&log.lock);
    80003656:	8526                	mv	a0,s1
    80003658:	00003097          	auipc	ra,0x3
    8000365c:	bec080e7          	jalr	-1044(ra) # 80006244 <release>
}
    80003660:	a03d                	j	8000368e <end_op+0xaa>
    panic("log.committing");
    80003662:	00005517          	auipc	a0,0x5
    80003666:	e5e50513          	addi	a0,a0,-418 # 800084c0 <etext+0x4c0>
    8000366a:	00002097          	auipc	ra,0x2
    8000366e:	614080e7          	jalr	1556(ra) # 80005c7e <panic>
    wakeup(&log);
    80003672:	0001a497          	auipc	s1,0x1a
    80003676:	7ae48493          	addi	s1,s1,1966 # 8001de20 <log>
    8000367a:	8526                	mv	a0,s1
    8000367c:	ffffe097          	auipc	ra,0xffffe
    80003680:	020080e7          	jalr	32(ra) # 8000169c <wakeup>
  release(&log.lock);
    80003684:	8526                	mv	a0,s1
    80003686:	00003097          	auipc	ra,0x3
    8000368a:	bbe080e7          	jalr	-1090(ra) # 80006244 <release>
}
    8000368e:	70e2                	ld	ra,56(sp)
    80003690:	7442                	ld	s0,48(sp)
    80003692:	74a2                	ld	s1,40(sp)
    80003694:	7902                	ld	s2,32(sp)
    80003696:	69e2                	ld	s3,24(sp)
    80003698:	6a42                	ld	s4,16(sp)
    8000369a:	6aa2                	ld	s5,8(sp)
    8000369c:	6121                	addi	sp,sp,64
    8000369e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a0:	0001aa97          	auipc	s5,0x1a
    800036a4:	7b0a8a93          	addi	s5,s5,1968 # 8001de50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036a8:	0001aa17          	auipc	s4,0x1a
    800036ac:	778a0a13          	addi	s4,s4,1912 # 8001de20 <log>
    800036b0:	018a2583          	lw	a1,24(s4)
    800036b4:	012585bb          	addw	a1,a1,s2
    800036b8:	2585                	addiw	a1,a1,1
    800036ba:	028a2503          	lw	a0,40(s4)
    800036be:	fffff097          	auipc	ra,0xfffff
    800036c2:	cd2080e7          	jalr	-814(ra) # 80002390 <bread>
    800036c6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036c8:	000aa583          	lw	a1,0(s5)
    800036cc:	028a2503          	lw	a0,40(s4)
    800036d0:	fffff097          	auipc	ra,0xfffff
    800036d4:	cc0080e7          	jalr	-832(ra) # 80002390 <bread>
    800036d8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036da:	40000613          	li	a2,1024
    800036de:	05850593          	addi	a1,a0,88
    800036e2:	05848513          	addi	a0,s1,88
    800036e6:	ffffd097          	auipc	ra,0xffffd
    800036ea:	aee080e7          	jalr	-1298(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    800036ee:	8526                	mv	a0,s1
    800036f0:	fffff097          	auipc	ra,0xfffff
    800036f4:	d92080e7          	jalr	-622(ra) # 80002482 <bwrite>
    brelse(from);
    800036f8:	854e                	mv	a0,s3
    800036fa:	fffff097          	auipc	ra,0xfffff
    800036fe:	dc6080e7          	jalr	-570(ra) # 800024c0 <brelse>
    brelse(to);
    80003702:	8526                	mv	a0,s1
    80003704:	fffff097          	auipc	ra,0xfffff
    80003708:	dbc080e7          	jalr	-580(ra) # 800024c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000370c:	2905                	addiw	s2,s2,1
    8000370e:	0a91                	addi	s5,s5,4
    80003710:	02ca2783          	lw	a5,44(s4)
    80003714:	f8f94ee3          	blt	s2,a5,800036b0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003718:	00000097          	auipc	ra,0x0
    8000371c:	c6a080e7          	jalr	-918(ra) # 80003382 <write_head>
    install_trans(0); // Now install writes to home locations
    80003720:	4501                	li	a0,0
    80003722:	00000097          	auipc	ra,0x0
    80003726:	cda080e7          	jalr	-806(ra) # 800033fc <install_trans>
    log.lh.n = 0;
    8000372a:	0001a797          	auipc	a5,0x1a
    8000372e:	7207a123          	sw	zero,1826(a5) # 8001de4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003732:	00000097          	auipc	ra,0x0
    80003736:	c50080e7          	jalr	-944(ra) # 80003382 <write_head>
    8000373a:	bdf5                	j	80003636 <end_op+0x52>

000000008000373c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000373c:	1101                	addi	sp,sp,-32
    8000373e:	ec06                	sd	ra,24(sp)
    80003740:	e822                	sd	s0,16(sp)
    80003742:	e426                	sd	s1,8(sp)
    80003744:	e04a                	sd	s2,0(sp)
    80003746:	1000                	addi	s0,sp,32
    80003748:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000374a:	0001a917          	auipc	s2,0x1a
    8000374e:	6d690913          	addi	s2,s2,1750 # 8001de20 <log>
    80003752:	854a                	mv	a0,s2
    80003754:	00003097          	auipc	ra,0x3
    80003758:	a3c080e7          	jalr	-1476(ra) # 80006190 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000375c:	02c92603          	lw	a2,44(s2)
    80003760:	47f5                	li	a5,29
    80003762:	06c7c563          	blt	a5,a2,800037cc <log_write+0x90>
    80003766:	0001a797          	auipc	a5,0x1a
    8000376a:	6d67a783          	lw	a5,1750(a5) # 8001de3c <log+0x1c>
    8000376e:	37fd                	addiw	a5,a5,-1
    80003770:	04f65e63          	bge	a2,a5,800037cc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003774:	0001a797          	auipc	a5,0x1a
    80003778:	6cc7a783          	lw	a5,1740(a5) # 8001de40 <log+0x20>
    8000377c:	06f05063          	blez	a5,800037dc <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003780:	4781                	li	a5,0
    80003782:	06c05563          	blez	a2,800037ec <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003786:	44cc                	lw	a1,12(s1)
    80003788:	0001a717          	auipc	a4,0x1a
    8000378c:	6c870713          	addi	a4,a4,1736 # 8001de50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003790:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003792:	4314                	lw	a3,0(a4)
    80003794:	04b68c63          	beq	a3,a1,800037ec <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003798:	2785                	addiw	a5,a5,1
    8000379a:	0711                	addi	a4,a4,4
    8000379c:	fef61be3          	bne	a2,a5,80003792 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037a0:	0621                	addi	a2,a2,8
    800037a2:	060a                	slli	a2,a2,0x2
    800037a4:	0001a797          	auipc	a5,0x1a
    800037a8:	67c78793          	addi	a5,a5,1660 # 8001de20 <log>
    800037ac:	963e                	add	a2,a2,a5
    800037ae:	44dc                	lw	a5,12(s1)
    800037b0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037b2:	8526                	mv	a0,s1
    800037b4:	fffff097          	auipc	ra,0xfffff
    800037b8:	daa080e7          	jalr	-598(ra) # 8000255e <bpin>
    log.lh.n++;
    800037bc:	0001a717          	auipc	a4,0x1a
    800037c0:	66470713          	addi	a4,a4,1636 # 8001de20 <log>
    800037c4:	575c                	lw	a5,44(a4)
    800037c6:	2785                	addiw	a5,a5,1
    800037c8:	d75c                	sw	a5,44(a4)
    800037ca:	a835                	j	80003806 <log_write+0xca>
    panic("too big a transaction");
    800037cc:	00005517          	auipc	a0,0x5
    800037d0:	d0450513          	addi	a0,a0,-764 # 800084d0 <etext+0x4d0>
    800037d4:	00002097          	auipc	ra,0x2
    800037d8:	4aa080e7          	jalr	1194(ra) # 80005c7e <panic>
    panic("log_write outside of trans");
    800037dc:	00005517          	auipc	a0,0x5
    800037e0:	d0c50513          	addi	a0,a0,-756 # 800084e8 <etext+0x4e8>
    800037e4:	00002097          	auipc	ra,0x2
    800037e8:	49a080e7          	jalr	1178(ra) # 80005c7e <panic>
  log.lh.block[i] = b->blockno;
    800037ec:	00878713          	addi	a4,a5,8
    800037f0:	00271693          	slli	a3,a4,0x2
    800037f4:	0001a717          	auipc	a4,0x1a
    800037f8:	62c70713          	addi	a4,a4,1580 # 8001de20 <log>
    800037fc:	9736                	add	a4,a4,a3
    800037fe:	44d4                	lw	a3,12(s1)
    80003800:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003802:	faf608e3          	beq	a2,a5,800037b2 <log_write+0x76>
  }
  release(&log.lock);
    80003806:	0001a517          	auipc	a0,0x1a
    8000380a:	61a50513          	addi	a0,a0,1562 # 8001de20 <log>
    8000380e:	00003097          	auipc	ra,0x3
    80003812:	a36080e7          	jalr	-1482(ra) # 80006244 <release>
}
    80003816:	60e2                	ld	ra,24(sp)
    80003818:	6442                	ld	s0,16(sp)
    8000381a:	64a2                	ld	s1,8(sp)
    8000381c:	6902                	ld	s2,0(sp)
    8000381e:	6105                	addi	sp,sp,32
    80003820:	8082                	ret

0000000080003822 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003822:	1101                	addi	sp,sp,-32
    80003824:	ec06                	sd	ra,24(sp)
    80003826:	e822                	sd	s0,16(sp)
    80003828:	e426                	sd	s1,8(sp)
    8000382a:	e04a                	sd	s2,0(sp)
    8000382c:	1000                	addi	s0,sp,32
    8000382e:	84aa                	mv	s1,a0
    80003830:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003832:	00005597          	auipc	a1,0x5
    80003836:	cd658593          	addi	a1,a1,-810 # 80008508 <etext+0x508>
    8000383a:	0521                	addi	a0,a0,8
    8000383c:	00003097          	auipc	ra,0x3
    80003840:	8c4080e7          	jalr	-1852(ra) # 80006100 <initlock>
  lk->name = name;
    80003844:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003848:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000384c:	0204a423          	sw	zero,40(s1)
}
    80003850:	60e2                	ld	ra,24(sp)
    80003852:	6442                	ld	s0,16(sp)
    80003854:	64a2                	ld	s1,8(sp)
    80003856:	6902                	ld	s2,0(sp)
    80003858:	6105                	addi	sp,sp,32
    8000385a:	8082                	ret

000000008000385c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000385c:	1101                	addi	sp,sp,-32
    8000385e:	ec06                	sd	ra,24(sp)
    80003860:	e822                	sd	s0,16(sp)
    80003862:	e426                	sd	s1,8(sp)
    80003864:	e04a                	sd	s2,0(sp)
    80003866:	1000                	addi	s0,sp,32
    80003868:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000386a:	00850913          	addi	s2,a0,8
    8000386e:	854a                	mv	a0,s2
    80003870:	00003097          	auipc	ra,0x3
    80003874:	920080e7          	jalr	-1760(ra) # 80006190 <acquire>
  while (lk->locked) {
    80003878:	409c                	lw	a5,0(s1)
    8000387a:	cb89                	beqz	a5,8000388c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000387c:	85ca                	mv	a1,s2
    8000387e:	8526                	mv	a0,s1
    80003880:	ffffe097          	auipc	ra,0xffffe
    80003884:	c90080e7          	jalr	-880(ra) # 80001510 <sleep>
  while (lk->locked) {
    80003888:	409c                	lw	a5,0(s1)
    8000388a:	fbed                	bnez	a5,8000387c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000388c:	4785                	li	a5,1
    8000388e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003890:	ffffd097          	auipc	ra,0xffffd
    80003894:	5b2080e7          	jalr	1458(ra) # 80000e42 <myproc>
    80003898:	591c                	lw	a5,48(a0)
    8000389a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000389c:	854a                	mv	a0,s2
    8000389e:	00003097          	auipc	ra,0x3
    800038a2:	9a6080e7          	jalr	-1626(ra) # 80006244 <release>
}
    800038a6:	60e2                	ld	ra,24(sp)
    800038a8:	6442                	ld	s0,16(sp)
    800038aa:	64a2                	ld	s1,8(sp)
    800038ac:	6902                	ld	s2,0(sp)
    800038ae:	6105                	addi	sp,sp,32
    800038b0:	8082                	ret

00000000800038b2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038b2:	1101                	addi	sp,sp,-32
    800038b4:	ec06                	sd	ra,24(sp)
    800038b6:	e822                	sd	s0,16(sp)
    800038b8:	e426                	sd	s1,8(sp)
    800038ba:	e04a                	sd	s2,0(sp)
    800038bc:	1000                	addi	s0,sp,32
    800038be:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c0:	00850913          	addi	s2,a0,8
    800038c4:	854a                	mv	a0,s2
    800038c6:	00003097          	auipc	ra,0x3
    800038ca:	8ca080e7          	jalr	-1846(ra) # 80006190 <acquire>
  lk->locked = 0;
    800038ce:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038d6:	8526                	mv	a0,s1
    800038d8:	ffffe097          	auipc	ra,0xffffe
    800038dc:	dc4080e7          	jalr	-572(ra) # 8000169c <wakeup>
  release(&lk->lk);
    800038e0:	854a                	mv	a0,s2
    800038e2:	00003097          	auipc	ra,0x3
    800038e6:	962080e7          	jalr	-1694(ra) # 80006244 <release>
}
    800038ea:	60e2                	ld	ra,24(sp)
    800038ec:	6442                	ld	s0,16(sp)
    800038ee:	64a2                	ld	s1,8(sp)
    800038f0:	6902                	ld	s2,0(sp)
    800038f2:	6105                	addi	sp,sp,32
    800038f4:	8082                	ret

00000000800038f6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038f6:	7179                	addi	sp,sp,-48
    800038f8:	f406                	sd	ra,40(sp)
    800038fa:	f022                	sd	s0,32(sp)
    800038fc:	ec26                	sd	s1,24(sp)
    800038fe:	e84a                	sd	s2,16(sp)
    80003900:	e44e                	sd	s3,8(sp)
    80003902:	1800                	addi	s0,sp,48
    80003904:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003906:	00850913          	addi	s2,a0,8
    8000390a:	854a                	mv	a0,s2
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	884080e7          	jalr	-1916(ra) # 80006190 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003914:	409c                	lw	a5,0(s1)
    80003916:	ef99                	bnez	a5,80003934 <holdingsleep+0x3e>
    80003918:	4481                	li	s1,0
  release(&lk->lk);
    8000391a:	854a                	mv	a0,s2
    8000391c:	00003097          	auipc	ra,0x3
    80003920:	928080e7          	jalr	-1752(ra) # 80006244 <release>
  return r;
}
    80003924:	8526                	mv	a0,s1
    80003926:	70a2                	ld	ra,40(sp)
    80003928:	7402                	ld	s0,32(sp)
    8000392a:	64e2                	ld	s1,24(sp)
    8000392c:	6942                	ld	s2,16(sp)
    8000392e:	69a2                	ld	s3,8(sp)
    80003930:	6145                	addi	sp,sp,48
    80003932:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003934:	0284a983          	lw	s3,40(s1)
    80003938:	ffffd097          	auipc	ra,0xffffd
    8000393c:	50a080e7          	jalr	1290(ra) # 80000e42 <myproc>
    80003940:	5904                	lw	s1,48(a0)
    80003942:	413484b3          	sub	s1,s1,s3
    80003946:	0014b493          	seqz	s1,s1
    8000394a:	bfc1                	j	8000391a <holdingsleep+0x24>

000000008000394c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000394c:	1141                	addi	sp,sp,-16
    8000394e:	e406                	sd	ra,8(sp)
    80003950:	e022                	sd	s0,0(sp)
    80003952:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003954:	00005597          	auipc	a1,0x5
    80003958:	bc458593          	addi	a1,a1,-1084 # 80008518 <etext+0x518>
    8000395c:	0001a517          	auipc	a0,0x1a
    80003960:	60c50513          	addi	a0,a0,1548 # 8001df68 <ftable>
    80003964:	00002097          	auipc	ra,0x2
    80003968:	79c080e7          	jalr	1948(ra) # 80006100 <initlock>
}
    8000396c:	60a2                	ld	ra,8(sp)
    8000396e:	6402                	ld	s0,0(sp)
    80003970:	0141                	addi	sp,sp,16
    80003972:	8082                	ret

0000000080003974 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003974:	1101                	addi	sp,sp,-32
    80003976:	ec06                	sd	ra,24(sp)
    80003978:	e822                	sd	s0,16(sp)
    8000397a:	e426                	sd	s1,8(sp)
    8000397c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000397e:	0001a517          	auipc	a0,0x1a
    80003982:	5ea50513          	addi	a0,a0,1514 # 8001df68 <ftable>
    80003986:	00003097          	auipc	ra,0x3
    8000398a:	80a080e7          	jalr	-2038(ra) # 80006190 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000398e:	0001a497          	auipc	s1,0x1a
    80003992:	5f248493          	addi	s1,s1,1522 # 8001df80 <ftable+0x18>
    80003996:	0001b717          	auipc	a4,0x1b
    8000399a:	58a70713          	addi	a4,a4,1418 # 8001ef20 <ftable+0xfb8>
    if(f->ref == 0){
    8000399e:	40dc                	lw	a5,4(s1)
    800039a0:	cf99                	beqz	a5,800039be <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039a2:	02848493          	addi	s1,s1,40
    800039a6:	fee49ce3          	bne	s1,a4,8000399e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039aa:	0001a517          	auipc	a0,0x1a
    800039ae:	5be50513          	addi	a0,a0,1470 # 8001df68 <ftable>
    800039b2:	00003097          	auipc	ra,0x3
    800039b6:	892080e7          	jalr	-1902(ra) # 80006244 <release>
  return 0;
    800039ba:	4481                	li	s1,0
    800039bc:	a819                	j	800039d2 <filealloc+0x5e>
      f->ref = 1;
    800039be:	4785                	li	a5,1
    800039c0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039c2:	0001a517          	auipc	a0,0x1a
    800039c6:	5a650513          	addi	a0,a0,1446 # 8001df68 <ftable>
    800039ca:	00003097          	auipc	ra,0x3
    800039ce:	87a080e7          	jalr	-1926(ra) # 80006244 <release>
}
    800039d2:	8526                	mv	a0,s1
    800039d4:	60e2                	ld	ra,24(sp)
    800039d6:	6442                	ld	s0,16(sp)
    800039d8:	64a2                	ld	s1,8(sp)
    800039da:	6105                	addi	sp,sp,32
    800039dc:	8082                	ret

00000000800039de <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039de:	1101                	addi	sp,sp,-32
    800039e0:	ec06                	sd	ra,24(sp)
    800039e2:	e822                	sd	s0,16(sp)
    800039e4:	e426                	sd	s1,8(sp)
    800039e6:	1000                	addi	s0,sp,32
    800039e8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039ea:	0001a517          	auipc	a0,0x1a
    800039ee:	57e50513          	addi	a0,a0,1406 # 8001df68 <ftable>
    800039f2:	00002097          	auipc	ra,0x2
    800039f6:	79e080e7          	jalr	1950(ra) # 80006190 <acquire>
  if(f->ref < 1)
    800039fa:	40dc                	lw	a5,4(s1)
    800039fc:	02f05263          	blez	a5,80003a20 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a00:	2785                	addiw	a5,a5,1
    80003a02:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a04:	0001a517          	auipc	a0,0x1a
    80003a08:	56450513          	addi	a0,a0,1380 # 8001df68 <ftable>
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	838080e7          	jalr	-1992(ra) # 80006244 <release>
  return f;
}
    80003a14:	8526                	mv	a0,s1
    80003a16:	60e2                	ld	ra,24(sp)
    80003a18:	6442                	ld	s0,16(sp)
    80003a1a:	64a2                	ld	s1,8(sp)
    80003a1c:	6105                	addi	sp,sp,32
    80003a1e:	8082                	ret
    panic("filedup");
    80003a20:	00005517          	auipc	a0,0x5
    80003a24:	b0050513          	addi	a0,a0,-1280 # 80008520 <etext+0x520>
    80003a28:	00002097          	auipc	ra,0x2
    80003a2c:	256080e7          	jalr	598(ra) # 80005c7e <panic>

0000000080003a30 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a30:	7139                	addi	sp,sp,-64
    80003a32:	fc06                	sd	ra,56(sp)
    80003a34:	f822                	sd	s0,48(sp)
    80003a36:	f426                	sd	s1,40(sp)
    80003a38:	f04a                	sd	s2,32(sp)
    80003a3a:	ec4e                	sd	s3,24(sp)
    80003a3c:	e852                	sd	s4,16(sp)
    80003a3e:	e456                	sd	s5,8(sp)
    80003a40:	0080                	addi	s0,sp,64
    80003a42:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a44:	0001a517          	auipc	a0,0x1a
    80003a48:	52450513          	addi	a0,a0,1316 # 8001df68 <ftable>
    80003a4c:	00002097          	auipc	ra,0x2
    80003a50:	744080e7          	jalr	1860(ra) # 80006190 <acquire>
  if(f->ref < 1)
    80003a54:	40dc                	lw	a5,4(s1)
    80003a56:	06f05163          	blez	a5,80003ab8 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a5a:	37fd                	addiw	a5,a5,-1
    80003a5c:	0007871b          	sext.w	a4,a5
    80003a60:	c0dc                	sw	a5,4(s1)
    80003a62:	06e04363          	bgtz	a4,80003ac8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a66:	0004a903          	lw	s2,0(s1)
    80003a6a:	0094ca83          	lbu	s5,9(s1)
    80003a6e:	0104ba03          	ld	s4,16(s1)
    80003a72:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a76:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a7a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a7e:	0001a517          	auipc	a0,0x1a
    80003a82:	4ea50513          	addi	a0,a0,1258 # 8001df68 <ftable>
    80003a86:	00002097          	auipc	ra,0x2
    80003a8a:	7be080e7          	jalr	1982(ra) # 80006244 <release>

  if(ff.type == FD_PIPE){
    80003a8e:	4785                	li	a5,1
    80003a90:	04f90d63          	beq	s2,a5,80003aea <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a94:	3979                	addiw	s2,s2,-2
    80003a96:	4785                	li	a5,1
    80003a98:	0527e063          	bltu	a5,s2,80003ad8 <fileclose+0xa8>
    begin_op();
    80003a9c:	00000097          	auipc	ra,0x0
    80003aa0:	ac8080e7          	jalr	-1336(ra) # 80003564 <begin_op>
    iput(ff.ip);
    80003aa4:	854e                	mv	a0,s3
    80003aa6:	fffff097          	auipc	ra,0xfffff
    80003aaa:	2a6080e7          	jalr	678(ra) # 80002d4c <iput>
    end_op();
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	b36080e7          	jalr	-1226(ra) # 800035e4 <end_op>
    80003ab6:	a00d                	j	80003ad8 <fileclose+0xa8>
    panic("fileclose");
    80003ab8:	00005517          	auipc	a0,0x5
    80003abc:	a7050513          	addi	a0,a0,-1424 # 80008528 <etext+0x528>
    80003ac0:	00002097          	auipc	ra,0x2
    80003ac4:	1be080e7          	jalr	446(ra) # 80005c7e <panic>
    release(&ftable.lock);
    80003ac8:	0001a517          	auipc	a0,0x1a
    80003acc:	4a050513          	addi	a0,a0,1184 # 8001df68 <ftable>
    80003ad0:	00002097          	auipc	ra,0x2
    80003ad4:	774080e7          	jalr	1908(ra) # 80006244 <release>
  }
}
    80003ad8:	70e2                	ld	ra,56(sp)
    80003ada:	7442                	ld	s0,48(sp)
    80003adc:	74a2                	ld	s1,40(sp)
    80003ade:	7902                	ld	s2,32(sp)
    80003ae0:	69e2                	ld	s3,24(sp)
    80003ae2:	6a42                	ld	s4,16(sp)
    80003ae4:	6aa2                	ld	s5,8(sp)
    80003ae6:	6121                	addi	sp,sp,64
    80003ae8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003aea:	85d6                	mv	a1,s5
    80003aec:	8552                	mv	a0,s4
    80003aee:	00000097          	auipc	ra,0x0
    80003af2:	34c080e7          	jalr	844(ra) # 80003e3a <pipeclose>
    80003af6:	b7cd                	j	80003ad8 <fileclose+0xa8>

0000000080003af8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003af8:	715d                	addi	sp,sp,-80
    80003afa:	e486                	sd	ra,72(sp)
    80003afc:	e0a2                	sd	s0,64(sp)
    80003afe:	fc26                	sd	s1,56(sp)
    80003b00:	f84a                	sd	s2,48(sp)
    80003b02:	f44e                	sd	s3,40(sp)
    80003b04:	0880                	addi	s0,sp,80
    80003b06:	84aa                	mv	s1,a0
    80003b08:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b0a:	ffffd097          	auipc	ra,0xffffd
    80003b0e:	338080e7          	jalr	824(ra) # 80000e42 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b12:	409c                	lw	a5,0(s1)
    80003b14:	37f9                	addiw	a5,a5,-2
    80003b16:	4705                	li	a4,1
    80003b18:	04f76763          	bltu	a4,a5,80003b66 <filestat+0x6e>
    80003b1c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b1e:	6c88                	ld	a0,24(s1)
    80003b20:	fffff097          	auipc	ra,0xfffff
    80003b24:	072080e7          	jalr	114(ra) # 80002b92 <ilock>
    stati(f->ip, &st);
    80003b28:	fb840593          	addi	a1,s0,-72
    80003b2c:	6c88                	ld	a0,24(s1)
    80003b2e:	fffff097          	auipc	ra,0xfffff
    80003b32:	2ee080e7          	jalr	750(ra) # 80002e1c <stati>
    iunlock(f->ip);
    80003b36:	6c88                	ld	a0,24(s1)
    80003b38:	fffff097          	auipc	ra,0xfffff
    80003b3c:	11c080e7          	jalr	284(ra) # 80002c54 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b40:	46e1                	li	a3,24
    80003b42:	fb840613          	addi	a2,s0,-72
    80003b46:	85ce                	mv	a1,s3
    80003b48:	05093503          	ld	a0,80(s2)
    80003b4c:	ffffd097          	auipc	ra,0xffffd
    80003b50:	fb6080e7          	jalr	-74(ra) # 80000b02 <copyout>
    80003b54:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b58:	60a6                	ld	ra,72(sp)
    80003b5a:	6406                	ld	s0,64(sp)
    80003b5c:	74e2                	ld	s1,56(sp)
    80003b5e:	7942                	ld	s2,48(sp)
    80003b60:	79a2                	ld	s3,40(sp)
    80003b62:	6161                	addi	sp,sp,80
    80003b64:	8082                	ret
  return -1;
    80003b66:	557d                	li	a0,-1
    80003b68:	bfc5                	j	80003b58 <filestat+0x60>

0000000080003b6a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b6a:	7179                	addi	sp,sp,-48
    80003b6c:	f406                	sd	ra,40(sp)
    80003b6e:	f022                	sd	s0,32(sp)
    80003b70:	ec26                	sd	s1,24(sp)
    80003b72:	e84a                	sd	s2,16(sp)
    80003b74:	e44e                	sd	s3,8(sp)
    80003b76:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b78:	00854783          	lbu	a5,8(a0)
    80003b7c:	c3d5                	beqz	a5,80003c20 <fileread+0xb6>
    80003b7e:	84aa                	mv	s1,a0
    80003b80:	89ae                	mv	s3,a1
    80003b82:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b84:	411c                	lw	a5,0(a0)
    80003b86:	4705                	li	a4,1
    80003b88:	04e78963          	beq	a5,a4,80003bda <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b8c:	470d                	li	a4,3
    80003b8e:	04e78d63          	beq	a5,a4,80003be8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b92:	4709                	li	a4,2
    80003b94:	06e79e63          	bne	a5,a4,80003c10 <fileread+0xa6>
    ilock(f->ip);
    80003b98:	6d08                	ld	a0,24(a0)
    80003b9a:	fffff097          	auipc	ra,0xfffff
    80003b9e:	ff8080e7          	jalr	-8(ra) # 80002b92 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ba2:	874a                	mv	a4,s2
    80003ba4:	5094                	lw	a3,32(s1)
    80003ba6:	864e                	mv	a2,s3
    80003ba8:	4585                	li	a1,1
    80003baa:	6c88                	ld	a0,24(s1)
    80003bac:	fffff097          	auipc	ra,0xfffff
    80003bb0:	29a080e7          	jalr	666(ra) # 80002e46 <readi>
    80003bb4:	892a                	mv	s2,a0
    80003bb6:	00a05563          	blez	a0,80003bc0 <fileread+0x56>
      f->off += r;
    80003bba:	509c                	lw	a5,32(s1)
    80003bbc:	9fa9                	addw	a5,a5,a0
    80003bbe:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bc0:	6c88                	ld	a0,24(s1)
    80003bc2:	fffff097          	auipc	ra,0xfffff
    80003bc6:	092080e7          	jalr	146(ra) # 80002c54 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bca:	854a                	mv	a0,s2
    80003bcc:	70a2                	ld	ra,40(sp)
    80003bce:	7402                	ld	s0,32(sp)
    80003bd0:	64e2                	ld	s1,24(sp)
    80003bd2:	6942                	ld	s2,16(sp)
    80003bd4:	69a2                	ld	s3,8(sp)
    80003bd6:	6145                	addi	sp,sp,48
    80003bd8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bda:	6908                	ld	a0,16(a0)
    80003bdc:	00000097          	auipc	ra,0x0
    80003be0:	3c0080e7          	jalr	960(ra) # 80003f9c <piperead>
    80003be4:	892a                	mv	s2,a0
    80003be6:	b7d5                	j	80003bca <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003be8:	02451783          	lh	a5,36(a0)
    80003bec:	03079693          	slli	a3,a5,0x30
    80003bf0:	92c1                	srli	a3,a3,0x30
    80003bf2:	4725                	li	a4,9
    80003bf4:	02d76863          	bltu	a4,a3,80003c24 <fileread+0xba>
    80003bf8:	0792                	slli	a5,a5,0x4
    80003bfa:	0001a717          	auipc	a4,0x1a
    80003bfe:	2ce70713          	addi	a4,a4,718 # 8001dec8 <devsw>
    80003c02:	97ba                	add	a5,a5,a4
    80003c04:	639c                	ld	a5,0(a5)
    80003c06:	c38d                	beqz	a5,80003c28 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c08:	4505                	li	a0,1
    80003c0a:	9782                	jalr	a5
    80003c0c:	892a                	mv	s2,a0
    80003c0e:	bf75                	j	80003bca <fileread+0x60>
    panic("fileread");
    80003c10:	00005517          	auipc	a0,0x5
    80003c14:	92850513          	addi	a0,a0,-1752 # 80008538 <etext+0x538>
    80003c18:	00002097          	auipc	ra,0x2
    80003c1c:	066080e7          	jalr	102(ra) # 80005c7e <panic>
    return -1;
    80003c20:	597d                	li	s2,-1
    80003c22:	b765                	j	80003bca <fileread+0x60>
      return -1;
    80003c24:	597d                	li	s2,-1
    80003c26:	b755                	j	80003bca <fileread+0x60>
    80003c28:	597d                	li	s2,-1
    80003c2a:	b745                	j	80003bca <fileread+0x60>

0000000080003c2c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c2c:	715d                	addi	sp,sp,-80
    80003c2e:	e486                	sd	ra,72(sp)
    80003c30:	e0a2                	sd	s0,64(sp)
    80003c32:	fc26                	sd	s1,56(sp)
    80003c34:	f84a                	sd	s2,48(sp)
    80003c36:	f44e                	sd	s3,40(sp)
    80003c38:	f052                	sd	s4,32(sp)
    80003c3a:	ec56                	sd	s5,24(sp)
    80003c3c:	e85a                	sd	s6,16(sp)
    80003c3e:	e45e                	sd	s7,8(sp)
    80003c40:	e062                	sd	s8,0(sp)
    80003c42:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c44:	00954783          	lbu	a5,9(a0)
    80003c48:	10078663          	beqz	a5,80003d54 <filewrite+0x128>
    80003c4c:	892a                	mv	s2,a0
    80003c4e:	8aae                	mv	s5,a1
    80003c50:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c52:	411c                	lw	a5,0(a0)
    80003c54:	4705                	li	a4,1
    80003c56:	02e78263          	beq	a5,a4,80003c7a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c5a:	470d                	li	a4,3
    80003c5c:	02e78663          	beq	a5,a4,80003c88 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c60:	4709                	li	a4,2
    80003c62:	0ee79163          	bne	a5,a4,80003d44 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c66:	0ac05d63          	blez	a2,80003d20 <filewrite+0xf4>
    int i = 0;
    80003c6a:	4981                	li	s3,0
    80003c6c:	6b05                	lui	s6,0x1
    80003c6e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c72:	6b85                	lui	s7,0x1
    80003c74:	c00b8b9b          	addiw	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c78:	a861                	j	80003d10 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c7a:	6908                	ld	a0,16(a0)
    80003c7c:	00000097          	auipc	ra,0x0
    80003c80:	22e080e7          	jalr	558(ra) # 80003eaa <pipewrite>
    80003c84:	8a2a                	mv	s4,a0
    80003c86:	a045                	j	80003d26 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c88:	02451783          	lh	a5,36(a0)
    80003c8c:	03079693          	slli	a3,a5,0x30
    80003c90:	92c1                	srli	a3,a3,0x30
    80003c92:	4725                	li	a4,9
    80003c94:	0cd76263          	bltu	a4,a3,80003d58 <filewrite+0x12c>
    80003c98:	0792                	slli	a5,a5,0x4
    80003c9a:	0001a717          	auipc	a4,0x1a
    80003c9e:	22e70713          	addi	a4,a4,558 # 8001dec8 <devsw>
    80003ca2:	97ba                	add	a5,a5,a4
    80003ca4:	679c                	ld	a5,8(a5)
    80003ca6:	cbdd                	beqz	a5,80003d5c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ca8:	4505                	li	a0,1
    80003caa:	9782                	jalr	a5
    80003cac:	8a2a                	mv	s4,a0
    80003cae:	a8a5                	j	80003d26 <filewrite+0xfa>
    80003cb0:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cb4:	00000097          	auipc	ra,0x0
    80003cb8:	8b0080e7          	jalr	-1872(ra) # 80003564 <begin_op>
      ilock(f->ip);
    80003cbc:	01893503          	ld	a0,24(s2)
    80003cc0:	fffff097          	auipc	ra,0xfffff
    80003cc4:	ed2080e7          	jalr	-302(ra) # 80002b92 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cc8:	8762                	mv	a4,s8
    80003cca:	02092683          	lw	a3,32(s2)
    80003cce:	01598633          	add	a2,s3,s5
    80003cd2:	4585                	li	a1,1
    80003cd4:	01893503          	ld	a0,24(s2)
    80003cd8:	fffff097          	auipc	ra,0xfffff
    80003cdc:	266080e7          	jalr	614(ra) # 80002f3e <writei>
    80003ce0:	84aa                	mv	s1,a0
    80003ce2:	00a05763          	blez	a0,80003cf0 <filewrite+0xc4>
        f->off += r;
    80003ce6:	02092783          	lw	a5,32(s2)
    80003cea:	9fa9                	addw	a5,a5,a0
    80003cec:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cf0:	01893503          	ld	a0,24(s2)
    80003cf4:	fffff097          	auipc	ra,0xfffff
    80003cf8:	f60080e7          	jalr	-160(ra) # 80002c54 <iunlock>
      end_op();
    80003cfc:	00000097          	auipc	ra,0x0
    80003d00:	8e8080e7          	jalr	-1816(ra) # 800035e4 <end_op>

      if(r != n1){
    80003d04:	009c1f63          	bne	s8,s1,80003d22 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d08:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d0c:	0149db63          	bge	s3,s4,80003d22 <filewrite+0xf6>
      int n1 = n - i;
    80003d10:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d14:	84be                	mv	s1,a5
    80003d16:	2781                	sext.w	a5,a5
    80003d18:	f8fb5ce3          	bge	s6,a5,80003cb0 <filewrite+0x84>
    80003d1c:	84de                	mv	s1,s7
    80003d1e:	bf49                	j	80003cb0 <filewrite+0x84>
    int i = 0;
    80003d20:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d22:	013a1f63          	bne	s4,s3,80003d40 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d26:	8552                	mv	a0,s4
    80003d28:	60a6                	ld	ra,72(sp)
    80003d2a:	6406                	ld	s0,64(sp)
    80003d2c:	74e2                	ld	s1,56(sp)
    80003d2e:	7942                	ld	s2,48(sp)
    80003d30:	79a2                	ld	s3,40(sp)
    80003d32:	7a02                	ld	s4,32(sp)
    80003d34:	6ae2                	ld	s5,24(sp)
    80003d36:	6b42                	ld	s6,16(sp)
    80003d38:	6ba2                	ld	s7,8(sp)
    80003d3a:	6c02                	ld	s8,0(sp)
    80003d3c:	6161                	addi	sp,sp,80
    80003d3e:	8082                	ret
    ret = (i == n ? n : -1);
    80003d40:	5a7d                	li	s4,-1
    80003d42:	b7d5                	j	80003d26 <filewrite+0xfa>
    panic("filewrite");
    80003d44:	00005517          	auipc	a0,0x5
    80003d48:	80450513          	addi	a0,a0,-2044 # 80008548 <etext+0x548>
    80003d4c:	00002097          	auipc	ra,0x2
    80003d50:	f32080e7          	jalr	-206(ra) # 80005c7e <panic>
    return -1;
    80003d54:	5a7d                	li	s4,-1
    80003d56:	bfc1                	j	80003d26 <filewrite+0xfa>
      return -1;
    80003d58:	5a7d                	li	s4,-1
    80003d5a:	b7f1                	j	80003d26 <filewrite+0xfa>
    80003d5c:	5a7d                	li	s4,-1
    80003d5e:	b7e1                	j	80003d26 <filewrite+0xfa>

0000000080003d60 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d60:	7179                	addi	sp,sp,-48
    80003d62:	f406                	sd	ra,40(sp)
    80003d64:	f022                	sd	s0,32(sp)
    80003d66:	ec26                	sd	s1,24(sp)
    80003d68:	e84a                	sd	s2,16(sp)
    80003d6a:	e44e                	sd	s3,8(sp)
    80003d6c:	e052                	sd	s4,0(sp)
    80003d6e:	1800                	addi	s0,sp,48
    80003d70:	84aa                	mv	s1,a0
    80003d72:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d74:	0005b023          	sd	zero,0(a1)
    80003d78:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	bf8080e7          	jalr	-1032(ra) # 80003974 <filealloc>
    80003d84:	e088                	sd	a0,0(s1)
    80003d86:	c551                	beqz	a0,80003e12 <pipealloc+0xb2>
    80003d88:	00000097          	auipc	ra,0x0
    80003d8c:	bec080e7          	jalr	-1044(ra) # 80003974 <filealloc>
    80003d90:	00aa3023          	sd	a0,0(s4)
    80003d94:	c92d                	beqz	a0,80003e06 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d96:	ffffc097          	auipc	ra,0xffffc
    80003d9a:	382080e7          	jalr	898(ra) # 80000118 <kalloc>
    80003d9e:	892a                	mv	s2,a0
    80003da0:	c125                	beqz	a0,80003e00 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003da2:	4985                	li	s3,1
    80003da4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003da8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dac:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003db0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003db4:	00004597          	auipc	a1,0x4
    80003db8:	7a458593          	addi	a1,a1,1956 # 80008558 <etext+0x558>
    80003dbc:	00002097          	auipc	ra,0x2
    80003dc0:	344080e7          	jalr	836(ra) # 80006100 <initlock>
  (*f0)->type = FD_PIPE;
    80003dc4:	609c                	ld	a5,0(s1)
    80003dc6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dca:	609c                	ld	a5,0(s1)
    80003dcc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dd0:	609c                	ld	a5,0(s1)
    80003dd2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dd6:	609c                	ld	a5,0(s1)
    80003dd8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ddc:	000a3783          	ld	a5,0(s4)
    80003de0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003de4:	000a3783          	ld	a5,0(s4)
    80003de8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003dec:	000a3783          	ld	a5,0(s4)
    80003df0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003df4:	000a3783          	ld	a5,0(s4)
    80003df8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003dfc:	4501                	li	a0,0
    80003dfe:	a025                	j	80003e26 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e00:	6088                	ld	a0,0(s1)
    80003e02:	e501                	bnez	a0,80003e0a <pipealloc+0xaa>
    80003e04:	a039                	j	80003e12 <pipealloc+0xb2>
    80003e06:	6088                	ld	a0,0(s1)
    80003e08:	c51d                	beqz	a0,80003e36 <pipealloc+0xd6>
    fileclose(*f0);
    80003e0a:	00000097          	auipc	ra,0x0
    80003e0e:	c26080e7          	jalr	-986(ra) # 80003a30 <fileclose>
  if(*f1)
    80003e12:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e16:	557d                	li	a0,-1
  if(*f1)
    80003e18:	c799                	beqz	a5,80003e26 <pipealloc+0xc6>
    fileclose(*f1);
    80003e1a:	853e                	mv	a0,a5
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	c14080e7          	jalr	-1004(ra) # 80003a30 <fileclose>
  return -1;
    80003e24:	557d                	li	a0,-1
}
    80003e26:	70a2                	ld	ra,40(sp)
    80003e28:	7402                	ld	s0,32(sp)
    80003e2a:	64e2                	ld	s1,24(sp)
    80003e2c:	6942                	ld	s2,16(sp)
    80003e2e:	69a2                	ld	s3,8(sp)
    80003e30:	6a02                	ld	s4,0(sp)
    80003e32:	6145                	addi	sp,sp,48
    80003e34:	8082                	ret
  return -1;
    80003e36:	557d                	li	a0,-1
    80003e38:	b7fd                	j	80003e26 <pipealloc+0xc6>

0000000080003e3a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e3a:	1101                	addi	sp,sp,-32
    80003e3c:	ec06                	sd	ra,24(sp)
    80003e3e:	e822                	sd	s0,16(sp)
    80003e40:	e426                	sd	s1,8(sp)
    80003e42:	e04a                	sd	s2,0(sp)
    80003e44:	1000                	addi	s0,sp,32
    80003e46:	84aa                	mv	s1,a0
    80003e48:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e4a:	00002097          	auipc	ra,0x2
    80003e4e:	346080e7          	jalr	838(ra) # 80006190 <acquire>
  if(writable){
    80003e52:	02090d63          	beqz	s2,80003e8c <pipeclose+0x52>
    pi->writeopen = 0;
    80003e56:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e5a:	21848513          	addi	a0,s1,536
    80003e5e:	ffffe097          	auipc	ra,0xffffe
    80003e62:	83e080e7          	jalr	-1986(ra) # 8000169c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e66:	2204b783          	ld	a5,544(s1)
    80003e6a:	eb95                	bnez	a5,80003e9e <pipeclose+0x64>
    release(&pi->lock);
    80003e6c:	8526                	mv	a0,s1
    80003e6e:	00002097          	auipc	ra,0x2
    80003e72:	3d6080e7          	jalr	982(ra) # 80006244 <release>
    kfree((char*)pi);
    80003e76:	8526                	mv	a0,s1
    80003e78:	ffffc097          	auipc	ra,0xffffc
    80003e7c:	1a4080e7          	jalr	420(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e80:	60e2                	ld	ra,24(sp)
    80003e82:	6442                	ld	s0,16(sp)
    80003e84:	64a2                	ld	s1,8(sp)
    80003e86:	6902                	ld	s2,0(sp)
    80003e88:	6105                	addi	sp,sp,32
    80003e8a:	8082                	ret
    pi->readopen = 0;
    80003e8c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e90:	21c48513          	addi	a0,s1,540
    80003e94:	ffffe097          	auipc	ra,0xffffe
    80003e98:	808080e7          	jalr	-2040(ra) # 8000169c <wakeup>
    80003e9c:	b7e9                	j	80003e66 <pipeclose+0x2c>
    release(&pi->lock);
    80003e9e:	8526                	mv	a0,s1
    80003ea0:	00002097          	auipc	ra,0x2
    80003ea4:	3a4080e7          	jalr	932(ra) # 80006244 <release>
}
    80003ea8:	bfe1                	j	80003e80 <pipeclose+0x46>

0000000080003eaa <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eaa:	711d                	addi	sp,sp,-96
    80003eac:	ec86                	sd	ra,88(sp)
    80003eae:	e8a2                	sd	s0,80(sp)
    80003eb0:	e4a6                	sd	s1,72(sp)
    80003eb2:	e0ca                	sd	s2,64(sp)
    80003eb4:	fc4e                	sd	s3,56(sp)
    80003eb6:	f852                	sd	s4,48(sp)
    80003eb8:	f456                	sd	s5,40(sp)
    80003eba:	f05a                	sd	s6,32(sp)
    80003ebc:	ec5e                	sd	s7,24(sp)
    80003ebe:	e862                	sd	s8,16(sp)
    80003ec0:	1080                	addi	s0,sp,96
    80003ec2:	84aa                	mv	s1,a0
    80003ec4:	8aae                	mv	s5,a1
    80003ec6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ec8:	ffffd097          	auipc	ra,0xffffd
    80003ecc:	f7a080e7          	jalr	-134(ra) # 80000e42 <myproc>
    80003ed0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ed2:	8526                	mv	a0,s1
    80003ed4:	00002097          	auipc	ra,0x2
    80003ed8:	2bc080e7          	jalr	700(ra) # 80006190 <acquire>
  while(i < n){
    80003edc:	0b405363          	blez	s4,80003f82 <pipewrite+0xd8>
  int i = 0;
    80003ee0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ee2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ee4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ee8:	21c48b93          	addi	s7,s1,540
    80003eec:	a089                	j	80003f2e <pipewrite+0x84>
      release(&pi->lock);
    80003eee:	8526                	mv	a0,s1
    80003ef0:	00002097          	auipc	ra,0x2
    80003ef4:	354080e7          	jalr	852(ra) # 80006244 <release>
      return -1;
    80003ef8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003efa:	854a                	mv	a0,s2
    80003efc:	60e6                	ld	ra,88(sp)
    80003efe:	6446                	ld	s0,80(sp)
    80003f00:	64a6                	ld	s1,72(sp)
    80003f02:	6906                	ld	s2,64(sp)
    80003f04:	79e2                	ld	s3,56(sp)
    80003f06:	7a42                	ld	s4,48(sp)
    80003f08:	7aa2                	ld	s5,40(sp)
    80003f0a:	7b02                	ld	s6,32(sp)
    80003f0c:	6be2                	ld	s7,24(sp)
    80003f0e:	6c42                	ld	s8,16(sp)
    80003f10:	6125                	addi	sp,sp,96
    80003f12:	8082                	ret
      wakeup(&pi->nread);
    80003f14:	8562                	mv	a0,s8
    80003f16:	ffffd097          	auipc	ra,0xffffd
    80003f1a:	786080e7          	jalr	1926(ra) # 8000169c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f1e:	85a6                	mv	a1,s1
    80003f20:	855e                	mv	a0,s7
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	5ee080e7          	jalr	1518(ra) # 80001510 <sleep>
  while(i < n){
    80003f2a:	05495d63          	bge	s2,s4,80003f84 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f2e:	2204a783          	lw	a5,544(s1)
    80003f32:	dfd5                	beqz	a5,80003eee <pipewrite+0x44>
    80003f34:	0289a783          	lw	a5,40(s3)
    80003f38:	fbdd                	bnez	a5,80003eee <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f3a:	2184a783          	lw	a5,536(s1)
    80003f3e:	21c4a703          	lw	a4,540(s1)
    80003f42:	2007879b          	addiw	a5,a5,512
    80003f46:	fcf707e3          	beq	a4,a5,80003f14 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f4a:	4685                	li	a3,1
    80003f4c:	01590633          	add	a2,s2,s5
    80003f50:	faf40593          	addi	a1,s0,-81
    80003f54:	0509b503          	ld	a0,80(s3)
    80003f58:	ffffd097          	auipc	ra,0xffffd
    80003f5c:	c36080e7          	jalr	-970(ra) # 80000b8e <copyin>
    80003f60:	03650263          	beq	a0,s6,80003f84 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f64:	21c4a783          	lw	a5,540(s1)
    80003f68:	0017871b          	addiw	a4,a5,1
    80003f6c:	20e4ae23          	sw	a4,540(s1)
    80003f70:	1ff7f793          	andi	a5,a5,511
    80003f74:	97a6                	add	a5,a5,s1
    80003f76:	faf44703          	lbu	a4,-81(s0)
    80003f7a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f7e:	2905                	addiw	s2,s2,1
    80003f80:	b76d                	j	80003f2a <pipewrite+0x80>
  int i = 0;
    80003f82:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f84:	21848513          	addi	a0,s1,536
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	714080e7          	jalr	1812(ra) # 8000169c <wakeup>
  release(&pi->lock);
    80003f90:	8526                	mv	a0,s1
    80003f92:	00002097          	auipc	ra,0x2
    80003f96:	2b2080e7          	jalr	690(ra) # 80006244 <release>
  return i;
    80003f9a:	b785                	j	80003efa <pipewrite+0x50>

0000000080003f9c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f9c:	715d                	addi	sp,sp,-80
    80003f9e:	e486                	sd	ra,72(sp)
    80003fa0:	e0a2                	sd	s0,64(sp)
    80003fa2:	fc26                	sd	s1,56(sp)
    80003fa4:	f84a                	sd	s2,48(sp)
    80003fa6:	f44e                	sd	s3,40(sp)
    80003fa8:	f052                	sd	s4,32(sp)
    80003faa:	ec56                	sd	s5,24(sp)
    80003fac:	e85a                	sd	s6,16(sp)
    80003fae:	0880                	addi	s0,sp,80
    80003fb0:	84aa                	mv	s1,a0
    80003fb2:	892e                	mv	s2,a1
    80003fb4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fb6:	ffffd097          	auipc	ra,0xffffd
    80003fba:	e8c080e7          	jalr	-372(ra) # 80000e42 <myproc>
    80003fbe:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fc0:	8526                	mv	a0,s1
    80003fc2:	00002097          	auipc	ra,0x2
    80003fc6:	1ce080e7          	jalr	462(ra) # 80006190 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fca:	2184a703          	lw	a4,536(s1)
    80003fce:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fd2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fd6:	02f71463          	bne	a4,a5,80003ffe <piperead+0x62>
    80003fda:	2244a783          	lw	a5,548(s1)
    80003fde:	c385                	beqz	a5,80003ffe <piperead+0x62>
    if(pr->killed){
    80003fe0:	028a2783          	lw	a5,40(s4)
    80003fe4:	ebc1                	bnez	a5,80004074 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fe6:	85a6                	mv	a1,s1
    80003fe8:	854e                	mv	a0,s3
    80003fea:	ffffd097          	auipc	ra,0xffffd
    80003fee:	526080e7          	jalr	1318(ra) # 80001510 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff2:	2184a703          	lw	a4,536(s1)
    80003ff6:	21c4a783          	lw	a5,540(s1)
    80003ffa:	fef700e3          	beq	a4,a5,80003fda <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ffe:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004000:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004002:	05505363          	blez	s5,80004048 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004006:	2184a783          	lw	a5,536(s1)
    8000400a:	21c4a703          	lw	a4,540(s1)
    8000400e:	02f70d63          	beq	a4,a5,80004048 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004012:	0017871b          	addiw	a4,a5,1
    80004016:	20e4ac23          	sw	a4,536(s1)
    8000401a:	1ff7f793          	andi	a5,a5,511
    8000401e:	97a6                	add	a5,a5,s1
    80004020:	0187c783          	lbu	a5,24(a5)
    80004024:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004028:	4685                	li	a3,1
    8000402a:	fbf40613          	addi	a2,s0,-65
    8000402e:	85ca                	mv	a1,s2
    80004030:	050a3503          	ld	a0,80(s4)
    80004034:	ffffd097          	auipc	ra,0xffffd
    80004038:	ace080e7          	jalr	-1330(ra) # 80000b02 <copyout>
    8000403c:	01650663          	beq	a0,s6,80004048 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004040:	2985                	addiw	s3,s3,1
    80004042:	0905                	addi	s2,s2,1
    80004044:	fd3a91e3          	bne	s5,s3,80004006 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004048:	21c48513          	addi	a0,s1,540
    8000404c:	ffffd097          	auipc	ra,0xffffd
    80004050:	650080e7          	jalr	1616(ra) # 8000169c <wakeup>
  release(&pi->lock);
    80004054:	8526                	mv	a0,s1
    80004056:	00002097          	auipc	ra,0x2
    8000405a:	1ee080e7          	jalr	494(ra) # 80006244 <release>
  return i;
}
    8000405e:	854e                	mv	a0,s3
    80004060:	60a6                	ld	ra,72(sp)
    80004062:	6406                	ld	s0,64(sp)
    80004064:	74e2                	ld	s1,56(sp)
    80004066:	7942                	ld	s2,48(sp)
    80004068:	79a2                	ld	s3,40(sp)
    8000406a:	7a02                	ld	s4,32(sp)
    8000406c:	6ae2                	ld	s5,24(sp)
    8000406e:	6b42                	ld	s6,16(sp)
    80004070:	6161                	addi	sp,sp,80
    80004072:	8082                	ret
      release(&pi->lock);
    80004074:	8526                	mv	a0,s1
    80004076:	00002097          	auipc	ra,0x2
    8000407a:	1ce080e7          	jalr	462(ra) # 80006244 <release>
      return -1;
    8000407e:	59fd                	li	s3,-1
    80004080:	bff9                	j	8000405e <piperead+0xc2>

0000000080004082 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004082:	de010113          	addi	sp,sp,-544
    80004086:	20113c23          	sd	ra,536(sp)
    8000408a:	20813823          	sd	s0,528(sp)
    8000408e:	20913423          	sd	s1,520(sp)
    80004092:	21213023          	sd	s2,512(sp)
    80004096:	ffce                	sd	s3,504(sp)
    80004098:	fbd2                	sd	s4,496(sp)
    8000409a:	f7d6                	sd	s5,488(sp)
    8000409c:	f3da                	sd	s6,480(sp)
    8000409e:	efde                	sd	s7,472(sp)
    800040a0:	ebe2                	sd	s8,464(sp)
    800040a2:	e7e6                	sd	s9,456(sp)
    800040a4:	e3ea                	sd	s10,448(sp)
    800040a6:	ff6e                	sd	s11,440(sp)
    800040a8:	1400                	addi	s0,sp,544
    800040aa:	892a                	mv	s2,a0
    800040ac:	dea43423          	sd	a0,-536(s0)
    800040b0:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	d8e080e7          	jalr	-626(ra) # 80000e42 <myproc>
    800040bc:	84aa                	mv	s1,a0

  begin_op();
    800040be:	fffff097          	auipc	ra,0xfffff
    800040c2:	4a6080e7          	jalr	1190(ra) # 80003564 <begin_op>

  if((ip = namei(path)) == 0){
    800040c6:	854a                	mv	a0,s2
    800040c8:	fffff097          	auipc	ra,0xfffff
    800040cc:	280080e7          	jalr	640(ra) # 80003348 <namei>
    800040d0:	c93d                	beqz	a0,80004146 <exec+0xc4>
    800040d2:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040d4:	fffff097          	auipc	ra,0xfffff
    800040d8:	abe080e7          	jalr	-1346(ra) # 80002b92 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040dc:	04000713          	li	a4,64
    800040e0:	4681                	li	a3,0
    800040e2:	e5040613          	addi	a2,s0,-432
    800040e6:	4581                	li	a1,0
    800040e8:	8556                	mv	a0,s5
    800040ea:	fffff097          	auipc	ra,0xfffff
    800040ee:	d5c080e7          	jalr	-676(ra) # 80002e46 <readi>
    800040f2:	04000793          	li	a5,64
    800040f6:	00f51a63          	bne	a0,a5,8000410a <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800040fa:	e5042703          	lw	a4,-432(s0)
    800040fe:	464c47b7          	lui	a5,0x464c4
    80004102:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004106:	04f70663          	beq	a4,a5,80004152 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000410a:	8556                	mv	a0,s5
    8000410c:	fffff097          	auipc	ra,0xfffff
    80004110:	ce8080e7          	jalr	-792(ra) # 80002df4 <iunlockput>
    end_op();
    80004114:	fffff097          	auipc	ra,0xfffff
    80004118:	4d0080e7          	jalr	1232(ra) # 800035e4 <end_op>
  }
  return -1;
    8000411c:	557d                	li	a0,-1
}
    8000411e:	21813083          	ld	ra,536(sp)
    80004122:	21013403          	ld	s0,528(sp)
    80004126:	20813483          	ld	s1,520(sp)
    8000412a:	20013903          	ld	s2,512(sp)
    8000412e:	79fe                	ld	s3,504(sp)
    80004130:	7a5e                	ld	s4,496(sp)
    80004132:	7abe                	ld	s5,488(sp)
    80004134:	7b1e                	ld	s6,480(sp)
    80004136:	6bfe                	ld	s7,472(sp)
    80004138:	6c5e                	ld	s8,464(sp)
    8000413a:	6cbe                	ld	s9,456(sp)
    8000413c:	6d1e                	ld	s10,448(sp)
    8000413e:	7dfa                	ld	s11,440(sp)
    80004140:	22010113          	addi	sp,sp,544
    80004144:	8082                	ret
    end_op();
    80004146:	fffff097          	auipc	ra,0xfffff
    8000414a:	49e080e7          	jalr	1182(ra) # 800035e4 <end_op>
    return -1;
    8000414e:	557d                	li	a0,-1
    80004150:	b7f9                	j	8000411e <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004152:	8526                	mv	a0,s1
    80004154:	ffffd097          	auipc	ra,0xffffd
    80004158:	db2080e7          	jalr	-590(ra) # 80000f06 <proc_pagetable>
    8000415c:	8b2a                	mv	s6,a0
    8000415e:	d555                	beqz	a0,8000410a <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004160:	e7042783          	lw	a5,-400(s0)
    80004164:	e8845703          	lhu	a4,-376(s0)
    80004168:	c735                	beqz	a4,800041d4 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000416a:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000416c:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004170:	6a05                	lui	s4,0x1
    80004172:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004176:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000417a:	6d85                	lui	s11,0x1
    8000417c:	7d7d                	lui	s10,0xfffff
    8000417e:	ac1d                	j	800043b4 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004180:	00004517          	auipc	a0,0x4
    80004184:	3e050513          	addi	a0,a0,992 # 80008560 <etext+0x560>
    80004188:	00002097          	auipc	ra,0x2
    8000418c:	af6080e7          	jalr	-1290(ra) # 80005c7e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004190:	874a                	mv	a4,s2
    80004192:	009c86bb          	addw	a3,s9,s1
    80004196:	4581                	li	a1,0
    80004198:	8556                	mv	a0,s5
    8000419a:	fffff097          	auipc	ra,0xfffff
    8000419e:	cac080e7          	jalr	-852(ra) # 80002e46 <readi>
    800041a2:	2501                	sext.w	a0,a0
    800041a4:	1aa91863          	bne	s2,a0,80004354 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041a8:	009d84bb          	addw	s1,s11,s1
    800041ac:	013d09bb          	addw	s3,s10,s3
    800041b0:	1f74f263          	bgeu	s1,s7,80004394 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    800041b4:	02049593          	slli	a1,s1,0x20
    800041b8:	9181                	srli	a1,a1,0x20
    800041ba:	95e2                	add	a1,a1,s8
    800041bc:	855a                	mv	a0,s6
    800041be:	ffffc097          	auipc	ra,0xffffc
    800041c2:	340080e7          	jalr	832(ra) # 800004fe <walkaddr>
    800041c6:	862a                	mv	a2,a0
    if(pa == 0)
    800041c8:	dd45                	beqz	a0,80004180 <exec+0xfe>
      n = PGSIZE;
    800041ca:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800041cc:	fd49f2e3          	bgeu	s3,s4,80004190 <exec+0x10e>
      n = sz - i;
    800041d0:	894e                	mv	s2,s3
    800041d2:	bf7d                	j	80004190 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041d4:	4481                	li	s1,0
  iunlockput(ip);
    800041d6:	8556                	mv	a0,s5
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	c1c080e7          	jalr	-996(ra) # 80002df4 <iunlockput>
  end_op();
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	404080e7          	jalr	1028(ra) # 800035e4 <end_op>
  p = myproc();
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	c5a080e7          	jalr	-934(ra) # 80000e42 <myproc>
    800041f0:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800041f2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041f6:	6785                	lui	a5,0x1
    800041f8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800041fa:	94be                	add	s1,s1,a5
    800041fc:	77fd                	lui	a5,0xfffff
    800041fe:	8fe5                	and	a5,a5,s1
    80004200:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004204:	6609                	lui	a2,0x2
    80004206:	963e                	add	a2,a2,a5
    80004208:	85be                	mv	a1,a5
    8000420a:	855a                	mv	a0,s6
    8000420c:	ffffc097          	auipc	ra,0xffffc
    80004210:	6a6080e7          	jalr	1702(ra) # 800008b2 <uvmalloc>
    80004214:	8c2a                	mv	s8,a0
  ip = 0;
    80004216:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004218:	12050e63          	beqz	a0,80004354 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000421c:	75f9                	lui	a1,0xffffe
    8000421e:	95aa                	add	a1,a1,a0
    80004220:	855a                	mv	a0,s6
    80004222:	ffffd097          	auipc	ra,0xffffd
    80004226:	8ae080e7          	jalr	-1874(ra) # 80000ad0 <uvmclear>
  stackbase = sp - PGSIZE;
    8000422a:	7afd                	lui	s5,0xfffff
    8000422c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000422e:	df043783          	ld	a5,-528(s0)
    80004232:	6388                	ld	a0,0(a5)
    80004234:	c925                	beqz	a0,800042a4 <exec+0x222>
    80004236:	e9040993          	addi	s3,s0,-368
    8000423a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000423e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004240:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004242:	ffffc097          	auipc	ra,0xffffc
    80004246:	0b2080e7          	jalr	178(ra) # 800002f4 <strlen>
    8000424a:	0015079b          	addiw	a5,a0,1
    8000424e:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004252:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004256:	13596363          	bltu	s2,s5,8000437c <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000425a:	df043d83          	ld	s11,-528(s0)
    8000425e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004262:	8552                	mv	a0,s4
    80004264:	ffffc097          	auipc	ra,0xffffc
    80004268:	090080e7          	jalr	144(ra) # 800002f4 <strlen>
    8000426c:	0015069b          	addiw	a3,a0,1
    80004270:	8652                	mv	a2,s4
    80004272:	85ca                	mv	a1,s2
    80004274:	855a                	mv	a0,s6
    80004276:	ffffd097          	auipc	ra,0xffffd
    8000427a:	88c080e7          	jalr	-1908(ra) # 80000b02 <copyout>
    8000427e:	10054363          	bltz	a0,80004384 <exec+0x302>
    ustack[argc] = sp;
    80004282:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004286:	0485                	addi	s1,s1,1
    80004288:	008d8793          	addi	a5,s11,8
    8000428c:	def43823          	sd	a5,-528(s0)
    80004290:	008db503          	ld	a0,8(s11)
    80004294:	c911                	beqz	a0,800042a8 <exec+0x226>
    if(argc >= MAXARG)
    80004296:	09a1                	addi	s3,s3,8
    80004298:	fb3c95e3          	bne	s9,s3,80004242 <exec+0x1c0>
  sz = sz1;
    8000429c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042a0:	4a81                	li	s5,0
    800042a2:	a84d                	j	80004354 <exec+0x2d2>
  sp = sz;
    800042a4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042a6:	4481                	li	s1,0
  ustack[argc] = 0;
    800042a8:	00349793          	slli	a5,s1,0x3
    800042ac:	f9040713          	addi	a4,s0,-112
    800042b0:	97ba                	add	a5,a5,a4
    800042b2:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd4cc0>
  sp -= (argc+1) * sizeof(uint64);
    800042b6:	00148693          	addi	a3,s1,1
    800042ba:	068e                	slli	a3,a3,0x3
    800042bc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042c0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042c4:	01597663          	bgeu	s2,s5,800042d0 <exec+0x24e>
  sz = sz1;
    800042c8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042cc:	4a81                	li	s5,0
    800042ce:	a059                	j	80004354 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042d0:	e9040613          	addi	a2,s0,-368
    800042d4:	85ca                	mv	a1,s2
    800042d6:	855a                	mv	a0,s6
    800042d8:	ffffd097          	auipc	ra,0xffffd
    800042dc:	82a080e7          	jalr	-2006(ra) # 80000b02 <copyout>
    800042e0:	0a054663          	bltz	a0,8000438c <exec+0x30a>
  p->trapframe->a1 = sp;
    800042e4:	058bb783          	ld	a5,88(s7)
    800042e8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042ec:	de843783          	ld	a5,-536(s0)
    800042f0:	0007c703          	lbu	a4,0(a5)
    800042f4:	cf11                	beqz	a4,80004310 <exec+0x28e>
    800042f6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042f8:	02f00693          	li	a3,47
    800042fc:	a039                	j	8000430a <exec+0x288>
      last = s+1;
    800042fe:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004302:	0785                	addi	a5,a5,1
    80004304:	fff7c703          	lbu	a4,-1(a5)
    80004308:	c701                	beqz	a4,80004310 <exec+0x28e>
    if(*s == '/')
    8000430a:	fed71ce3          	bne	a4,a3,80004302 <exec+0x280>
    8000430e:	bfc5                	j	800042fe <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004310:	4641                	li	a2,16
    80004312:	de843583          	ld	a1,-536(s0)
    80004316:	158b8513          	addi	a0,s7,344
    8000431a:	ffffc097          	auipc	ra,0xffffc
    8000431e:	fa8080e7          	jalr	-88(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004322:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004326:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000432a:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000432e:	058bb783          	ld	a5,88(s7)
    80004332:	e6843703          	ld	a4,-408(s0)
    80004336:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004338:	058bb783          	ld	a5,88(s7)
    8000433c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004340:	85ea                	mv	a1,s10
    80004342:	ffffd097          	auipc	ra,0xffffd
    80004346:	c60080e7          	jalr	-928(ra) # 80000fa2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000434a:	0004851b          	sext.w	a0,s1
    8000434e:	bbc1                	j	8000411e <exec+0x9c>
    80004350:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004354:	df843583          	ld	a1,-520(s0)
    80004358:	855a                	mv	a0,s6
    8000435a:	ffffd097          	auipc	ra,0xffffd
    8000435e:	c48080e7          	jalr	-952(ra) # 80000fa2 <proc_freepagetable>
  if(ip){
    80004362:	da0a94e3          	bnez	s5,8000410a <exec+0x88>
  return -1;
    80004366:	557d                	li	a0,-1
    80004368:	bb5d                	j	8000411e <exec+0x9c>
    8000436a:	de943c23          	sd	s1,-520(s0)
    8000436e:	b7dd                	j	80004354 <exec+0x2d2>
    80004370:	de943c23          	sd	s1,-520(s0)
    80004374:	b7c5                	j	80004354 <exec+0x2d2>
    80004376:	de943c23          	sd	s1,-520(s0)
    8000437a:	bfe9                	j	80004354 <exec+0x2d2>
  sz = sz1;
    8000437c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004380:	4a81                	li	s5,0
    80004382:	bfc9                	j	80004354 <exec+0x2d2>
  sz = sz1;
    80004384:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004388:	4a81                	li	s5,0
    8000438a:	b7e9                	j	80004354 <exec+0x2d2>
  sz = sz1;
    8000438c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004390:	4a81                	li	s5,0
    80004392:	b7c9                	j	80004354 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004394:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004398:	e0843783          	ld	a5,-504(s0)
    8000439c:	0017869b          	addiw	a3,a5,1
    800043a0:	e0d43423          	sd	a3,-504(s0)
    800043a4:	e0043783          	ld	a5,-512(s0)
    800043a8:	0387879b          	addiw	a5,a5,56
    800043ac:	e8845703          	lhu	a4,-376(s0)
    800043b0:	e2e6d3e3          	bge	a3,a4,800041d6 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043b4:	2781                	sext.w	a5,a5
    800043b6:	e0f43023          	sd	a5,-512(s0)
    800043ba:	03800713          	li	a4,56
    800043be:	86be                	mv	a3,a5
    800043c0:	e1840613          	addi	a2,s0,-488
    800043c4:	4581                	li	a1,0
    800043c6:	8556                	mv	a0,s5
    800043c8:	fffff097          	auipc	ra,0xfffff
    800043cc:	a7e080e7          	jalr	-1410(ra) # 80002e46 <readi>
    800043d0:	03800793          	li	a5,56
    800043d4:	f6f51ee3          	bne	a0,a5,80004350 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    800043d8:	e1842783          	lw	a5,-488(s0)
    800043dc:	4705                	li	a4,1
    800043de:	fae79de3          	bne	a5,a4,80004398 <exec+0x316>
    if(ph.memsz < ph.filesz)
    800043e2:	e4043603          	ld	a2,-448(s0)
    800043e6:	e3843783          	ld	a5,-456(s0)
    800043ea:	f8f660e3          	bltu	a2,a5,8000436a <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043ee:	e2843783          	ld	a5,-472(s0)
    800043f2:	963e                	add	a2,a2,a5
    800043f4:	f6f66ee3          	bltu	a2,a5,80004370 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043f8:	85a6                	mv	a1,s1
    800043fa:	855a                	mv	a0,s6
    800043fc:	ffffc097          	auipc	ra,0xffffc
    80004400:	4b6080e7          	jalr	1206(ra) # 800008b2 <uvmalloc>
    80004404:	dea43c23          	sd	a0,-520(s0)
    80004408:	d53d                	beqz	a0,80004376 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000440a:	e2843c03          	ld	s8,-472(s0)
    8000440e:	de043783          	ld	a5,-544(s0)
    80004412:	00fc77b3          	and	a5,s8,a5
    80004416:	ff9d                	bnez	a5,80004354 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004418:	e2042c83          	lw	s9,-480(s0)
    8000441c:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004420:	f60b8ae3          	beqz	s7,80004394 <exec+0x312>
    80004424:	89de                	mv	s3,s7
    80004426:	4481                	li	s1,0
    80004428:	b371                	j	800041b4 <exec+0x132>

000000008000442a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000442a:	7179                	addi	sp,sp,-48
    8000442c:	f406                	sd	ra,40(sp)
    8000442e:	f022                	sd	s0,32(sp)
    80004430:	ec26                	sd	s1,24(sp)
    80004432:	e84a                	sd	s2,16(sp)
    80004434:	1800                	addi	s0,sp,48
    80004436:	892e                	mv	s2,a1
    80004438:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000443a:	fdc40593          	addi	a1,s0,-36
    8000443e:	ffffe097          	auipc	ra,0xffffe
    80004442:	b2a080e7          	jalr	-1238(ra) # 80001f68 <argint>
    80004446:	04054063          	bltz	a0,80004486 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000444a:	fdc42703          	lw	a4,-36(s0)
    8000444e:	47bd                	li	a5,15
    80004450:	02e7ed63          	bltu	a5,a4,8000448a <argfd+0x60>
    80004454:	ffffd097          	auipc	ra,0xffffd
    80004458:	9ee080e7          	jalr	-1554(ra) # 80000e42 <myproc>
    8000445c:	fdc42703          	lw	a4,-36(s0)
    80004460:	01a70793          	addi	a5,a4,26
    80004464:	078e                	slli	a5,a5,0x3
    80004466:	953e                	add	a0,a0,a5
    80004468:	611c                	ld	a5,0(a0)
    8000446a:	c395                	beqz	a5,8000448e <argfd+0x64>
    return -1;
  if(pfd)
    8000446c:	00090463          	beqz	s2,80004474 <argfd+0x4a>
    *pfd = fd;
    80004470:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004474:	4501                	li	a0,0
  if(pf)
    80004476:	c091                	beqz	s1,8000447a <argfd+0x50>
    *pf = f;
    80004478:	e09c                	sd	a5,0(s1)
}
    8000447a:	70a2                	ld	ra,40(sp)
    8000447c:	7402                	ld	s0,32(sp)
    8000447e:	64e2                	ld	s1,24(sp)
    80004480:	6942                	ld	s2,16(sp)
    80004482:	6145                	addi	sp,sp,48
    80004484:	8082                	ret
    return -1;
    80004486:	557d                	li	a0,-1
    80004488:	bfcd                	j	8000447a <argfd+0x50>
    return -1;
    8000448a:	557d                	li	a0,-1
    8000448c:	b7fd                	j	8000447a <argfd+0x50>
    8000448e:	557d                	li	a0,-1
    80004490:	b7ed                	j	8000447a <argfd+0x50>

0000000080004492 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004492:	1101                	addi	sp,sp,-32
    80004494:	ec06                	sd	ra,24(sp)
    80004496:	e822                	sd	s0,16(sp)
    80004498:	e426                	sd	s1,8(sp)
    8000449a:	1000                	addi	s0,sp,32
    8000449c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000449e:	ffffd097          	auipc	ra,0xffffd
    800044a2:	9a4080e7          	jalr	-1628(ra) # 80000e42 <myproc>
    800044a6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044a8:	0d050793          	addi	a5,a0,208
    800044ac:	4501                	li	a0,0
    800044ae:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044b0:	6398                	ld	a4,0(a5)
    800044b2:	cb19                	beqz	a4,800044c8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044b4:	2505                	addiw	a0,a0,1
    800044b6:	07a1                	addi	a5,a5,8
    800044b8:	fed51ce3          	bne	a0,a3,800044b0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044bc:	557d                	li	a0,-1
}
    800044be:	60e2                	ld	ra,24(sp)
    800044c0:	6442                	ld	s0,16(sp)
    800044c2:	64a2                	ld	s1,8(sp)
    800044c4:	6105                	addi	sp,sp,32
    800044c6:	8082                	ret
      p->ofile[fd] = f;
    800044c8:	01a50793          	addi	a5,a0,26
    800044cc:	078e                	slli	a5,a5,0x3
    800044ce:	963e                	add	a2,a2,a5
    800044d0:	e204                	sd	s1,0(a2)
      return fd;
    800044d2:	b7f5                	j	800044be <fdalloc+0x2c>

00000000800044d4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044d4:	715d                	addi	sp,sp,-80
    800044d6:	e486                	sd	ra,72(sp)
    800044d8:	e0a2                	sd	s0,64(sp)
    800044da:	fc26                	sd	s1,56(sp)
    800044dc:	f84a                	sd	s2,48(sp)
    800044de:	f44e                	sd	s3,40(sp)
    800044e0:	f052                	sd	s4,32(sp)
    800044e2:	ec56                	sd	s5,24(sp)
    800044e4:	0880                	addi	s0,sp,80
    800044e6:	89ae                	mv	s3,a1
    800044e8:	8ab2                	mv	s5,a2
    800044ea:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044ec:	fb040593          	addi	a1,s0,-80
    800044f0:	fffff097          	auipc	ra,0xfffff
    800044f4:	e76080e7          	jalr	-394(ra) # 80003366 <nameiparent>
    800044f8:	892a                	mv	s2,a0
    800044fa:	12050e63          	beqz	a0,80004636 <create+0x162>
    return 0;

  ilock(dp);
    800044fe:	ffffe097          	auipc	ra,0xffffe
    80004502:	694080e7          	jalr	1684(ra) # 80002b92 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004506:	4601                	li	a2,0
    80004508:	fb040593          	addi	a1,s0,-80
    8000450c:	854a                	mv	a0,s2
    8000450e:	fffff097          	auipc	ra,0xfffff
    80004512:	b68080e7          	jalr	-1176(ra) # 80003076 <dirlookup>
    80004516:	84aa                	mv	s1,a0
    80004518:	c921                	beqz	a0,80004568 <create+0x94>
    iunlockput(dp);
    8000451a:	854a                	mv	a0,s2
    8000451c:	fffff097          	auipc	ra,0xfffff
    80004520:	8d8080e7          	jalr	-1832(ra) # 80002df4 <iunlockput>
    ilock(ip);
    80004524:	8526                	mv	a0,s1
    80004526:	ffffe097          	auipc	ra,0xffffe
    8000452a:	66c080e7          	jalr	1644(ra) # 80002b92 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000452e:	2981                	sext.w	s3,s3
    80004530:	4789                	li	a5,2
    80004532:	02f99463          	bne	s3,a5,8000455a <create+0x86>
    80004536:	0444d783          	lhu	a5,68(s1)
    8000453a:	37f9                	addiw	a5,a5,-2
    8000453c:	17c2                	slli	a5,a5,0x30
    8000453e:	93c1                	srli	a5,a5,0x30
    80004540:	4705                	li	a4,1
    80004542:	00f76c63          	bltu	a4,a5,8000455a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004546:	8526                	mv	a0,s1
    80004548:	60a6                	ld	ra,72(sp)
    8000454a:	6406                	ld	s0,64(sp)
    8000454c:	74e2                	ld	s1,56(sp)
    8000454e:	7942                	ld	s2,48(sp)
    80004550:	79a2                	ld	s3,40(sp)
    80004552:	7a02                	ld	s4,32(sp)
    80004554:	6ae2                	ld	s5,24(sp)
    80004556:	6161                	addi	sp,sp,80
    80004558:	8082                	ret
    iunlockput(ip);
    8000455a:	8526                	mv	a0,s1
    8000455c:	fffff097          	auipc	ra,0xfffff
    80004560:	898080e7          	jalr	-1896(ra) # 80002df4 <iunlockput>
    return 0;
    80004564:	4481                	li	s1,0
    80004566:	b7c5                	j	80004546 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004568:	85ce                	mv	a1,s3
    8000456a:	00092503          	lw	a0,0(s2)
    8000456e:	ffffe097          	auipc	ra,0xffffe
    80004572:	48c080e7          	jalr	1164(ra) # 800029fa <ialloc>
    80004576:	84aa                	mv	s1,a0
    80004578:	c521                	beqz	a0,800045c0 <create+0xec>
  ilock(ip);
    8000457a:	ffffe097          	auipc	ra,0xffffe
    8000457e:	618080e7          	jalr	1560(ra) # 80002b92 <ilock>
  ip->major = major;
    80004582:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004586:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000458a:	4a05                	li	s4,1
    8000458c:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004590:	8526                	mv	a0,s1
    80004592:	ffffe097          	auipc	ra,0xffffe
    80004596:	536080e7          	jalr	1334(ra) # 80002ac8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000459a:	2981                	sext.w	s3,s3
    8000459c:	03498a63          	beq	s3,s4,800045d0 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045a0:	40d0                	lw	a2,4(s1)
    800045a2:	fb040593          	addi	a1,s0,-80
    800045a6:	854a                	mv	a0,s2
    800045a8:	fffff097          	auipc	ra,0xfffff
    800045ac:	cde080e7          	jalr	-802(ra) # 80003286 <dirlink>
    800045b0:	06054b63          	bltz	a0,80004626 <create+0x152>
  iunlockput(dp);
    800045b4:	854a                	mv	a0,s2
    800045b6:	fffff097          	auipc	ra,0xfffff
    800045ba:	83e080e7          	jalr	-1986(ra) # 80002df4 <iunlockput>
  return ip;
    800045be:	b761                	j	80004546 <create+0x72>
    panic("create: ialloc");
    800045c0:	00004517          	auipc	a0,0x4
    800045c4:	fc050513          	addi	a0,a0,-64 # 80008580 <etext+0x580>
    800045c8:	00001097          	auipc	ra,0x1
    800045cc:	6b6080e7          	jalr	1718(ra) # 80005c7e <panic>
    dp->nlink++;  // for ".."
    800045d0:	04a95783          	lhu	a5,74(s2)
    800045d4:	2785                	addiw	a5,a5,1
    800045d6:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045da:	854a                	mv	a0,s2
    800045dc:	ffffe097          	auipc	ra,0xffffe
    800045e0:	4ec080e7          	jalr	1260(ra) # 80002ac8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045e4:	40d0                	lw	a2,4(s1)
    800045e6:	00004597          	auipc	a1,0x4
    800045ea:	faa58593          	addi	a1,a1,-86 # 80008590 <etext+0x590>
    800045ee:	8526                	mv	a0,s1
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	c96080e7          	jalr	-874(ra) # 80003286 <dirlink>
    800045f8:	00054f63          	bltz	a0,80004616 <create+0x142>
    800045fc:	00492603          	lw	a2,4(s2)
    80004600:	00004597          	auipc	a1,0x4
    80004604:	f9858593          	addi	a1,a1,-104 # 80008598 <etext+0x598>
    80004608:	8526                	mv	a0,s1
    8000460a:	fffff097          	auipc	ra,0xfffff
    8000460e:	c7c080e7          	jalr	-900(ra) # 80003286 <dirlink>
    80004612:	f80557e3          	bgez	a0,800045a0 <create+0xcc>
      panic("create dots");
    80004616:	00004517          	auipc	a0,0x4
    8000461a:	f8a50513          	addi	a0,a0,-118 # 800085a0 <etext+0x5a0>
    8000461e:	00001097          	auipc	ra,0x1
    80004622:	660080e7          	jalr	1632(ra) # 80005c7e <panic>
    panic("create: dirlink");
    80004626:	00004517          	auipc	a0,0x4
    8000462a:	f8a50513          	addi	a0,a0,-118 # 800085b0 <etext+0x5b0>
    8000462e:	00001097          	auipc	ra,0x1
    80004632:	650080e7          	jalr	1616(ra) # 80005c7e <panic>
    return 0;
    80004636:	84aa                	mv	s1,a0
    80004638:	b739                	j	80004546 <create+0x72>

000000008000463a <sys_dup>:
{
    8000463a:	7179                	addi	sp,sp,-48
    8000463c:	f406                	sd	ra,40(sp)
    8000463e:	f022                	sd	s0,32(sp)
    80004640:	ec26                	sd	s1,24(sp)
    80004642:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004644:	fd840613          	addi	a2,s0,-40
    80004648:	4581                	li	a1,0
    8000464a:	4501                	li	a0,0
    8000464c:	00000097          	auipc	ra,0x0
    80004650:	dde080e7          	jalr	-546(ra) # 8000442a <argfd>
    return -1;
    80004654:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004656:	02054363          	bltz	a0,8000467c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000465a:	fd843503          	ld	a0,-40(s0)
    8000465e:	00000097          	auipc	ra,0x0
    80004662:	e34080e7          	jalr	-460(ra) # 80004492 <fdalloc>
    80004666:	84aa                	mv	s1,a0
    return -1;
    80004668:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000466a:	00054963          	bltz	a0,8000467c <sys_dup+0x42>
  filedup(f);
    8000466e:	fd843503          	ld	a0,-40(s0)
    80004672:	fffff097          	auipc	ra,0xfffff
    80004676:	36c080e7          	jalr	876(ra) # 800039de <filedup>
  return fd;
    8000467a:	87a6                	mv	a5,s1
}
    8000467c:	853e                	mv	a0,a5
    8000467e:	70a2                	ld	ra,40(sp)
    80004680:	7402                	ld	s0,32(sp)
    80004682:	64e2                	ld	s1,24(sp)
    80004684:	6145                	addi	sp,sp,48
    80004686:	8082                	ret

0000000080004688 <sys_read>:
{
    80004688:	7179                	addi	sp,sp,-48
    8000468a:	f406                	sd	ra,40(sp)
    8000468c:	f022                	sd	s0,32(sp)
    8000468e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004690:	fe840613          	addi	a2,s0,-24
    80004694:	4581                	li	a1,0
    80004696:	4501                	li	a0,0
    80004698:	00000097          	auipc	ra,0x0
    8000469c:	d92080e7          	jalr	-622(ra) # 8000442a <argfd>
    return -1;
    800046a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a2:	04054163          	bltz	a0,800046e4 <sys_read+0x5c>
    800046a6:	fe440593          	addi	a1,s0,-28
    800046aa:	4509                	li	a0,2
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	8bc080e7          	jalr	-1860(ra) # 80001f68 <argint>
    return -1;
    800046b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046b6:	02054763          	bltz	a0,800046e4 <sys_read+0x5c>
    800046ba:	fd840593          	addi	a1,s0,-40
    800046be:	4505                	li	a0,1
    800046c0:	ffffe097          	auipc	ra,0xffffe
    800046c4:	8ca080e7          	jalr	-1846(ra) # 80001f8a <argaddr>
    return -1;
    800046c8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ca:	00054d63          	bltz	a0,800046e4 <sys_read+0x5c>
  return fileread(f, p, n);
    800046ce:	fe442603          	lw	a2,-28(s0)
    800046d2:	fd843583          	ld	a1,-40(s0)
    800046d6:	fe843503          	ld	a0,-24(s0)
    800046da:	fffff097          	auipc	ra,0xfffff
    800046de:	490080e7          	jalr	1168(ra) # 80003b6a <fileread>
    800046e2:	87aa                	mv	a5,a0
}
    800046e4:	853e                	mv	a0,a5
    800046e6:	70a2                	ld	ra,40(sp)
    800046e8:	7402                	ld	s0,32(sp)
    800046ea:	6145                	addi	sp,sp,48
    800046ec:	8082                	ret

00000000800046ee <sys_write>:
{
    800046ee:	7179                	addi	sp,sp,-48
    800046f0:	f406                	sd	ra,40(sp)
    800046f2:	f022                	sd	s0,32(sp)
    800046f4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f6:	fe840613          	addi	a2,s0,-24
    800046fa:	4581                	li	a1,0
    800046fc:	4501                	li	a0,0
    800046fe:	00000097          	auipc	ra,0x0
    80004702:	d2c080e7          	jalr	-724(ra) # 8000442a <argfd>
    return -1;
    80004706:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004708:	04054163          	bltz	a0,8000474a <sys_write+0x5c>
    8000470c:	fe440593          	addi	a1,s0,-28
    80004710:	4509                	li	a0,2
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	856080e7          	jalr	-1962(ra) # 80001f68 <argint>
    return -1;
    8000471a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471c:	02054763          	bltz	a0,8000474a <sys_write+0x5c>
    80004720:	fd840593          	addi	a1,s0,-40
    80004724:	4505                	li	a0,1
    80004726:	ffffe097          	auipc	ra,0xffffe
    8000472a:	864080e7          	jalr	-1948(ra) # 80001f8a <argaddr>
    return -1;
    8000472e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004730:	00054d63          	bltz	a0,8000474a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004734:	fe442603          	lw	a2,-28(s0)
    80004738:	fd843583          	ld	a1,-40(s0)
    8000473c:	fe843503          	ld	a0,-24(s0)
    80004740:	fffff097          	auipc	ra,0xfffff
    80004744:	4ec080e7          	jalr	1260(ra) # 80003c2c <filewrite>
    80004748:	87aa                	mv	a5,a0
}
    8000474a:	853e                	mv	a0,a5
    8000474c:	70a2                	ld	ra,40(sp)
    8000474e:	7402                	ld	s0,32(sp)
    80004750:	6145                	addi	sp,sp,48
    80004752:	8082                	ret

0000000080004754 <sys_close>:
{
    80004754:	1101                	addi	sp,sp,-32
    80004756:	ec06                	sd	ra,24(sp)
    80004758:	e822                	sd	s0,16(sp)
    8000475a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000475c:	fe040613          	addi	a2,s0,-32
    80004760:	fec40593          	addi	a1,s0,-20
    80004764:	4501                	li	a0,0
    80004766:	00000097          	auipc	ra,0x0
    8000476a:	cc4080e7          	jalr	-828(ra) # 8000442a <argfd>
    return -1;
    8000476e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004770:	02054463          	bltz	a0,80004798 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004774:	ffffc097          	auipc	ra,0xffffc
    80004778:	6ce080e7          	jalr	1742(ra) # 80000e42 <myproc>
    8000477c:	fec42783          	lw	a5,-20(s0)
    80004780:	07e9                	addi	a5,a5,26
    80004782:	078e                	slli	a5,a5,0x3
    80004784:	97aa                	add	a5,a5,a0
    80004786:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000478a:	fe043503          	ld	a0,-32(s0)
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	2a2080e7          	jalr	674(ra) # 80003a30 <fileclose>
  return 0;
    80004796:	4781                	li	a5,0
}
    80004798:	853e                	mv	a0,a5
    8000479a:	60e2                	ld	ra,24(sp)
    8000479c:	6442                	ld	s0,16(sp)
    8000479e:	6105                	addi	sp,sp,32
    800047a0:	8082                	ret

00000000800047a2 <sys_fstat>:
{
    800047a2:	1101                	addi	sp,sp,-32
    800047a4:	ec06                	sd	ra,24(sp)
    800047a6:	e822                	sd	s0,16(sp)
    800047a8:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047aa:	fe840613          	addi	a2,s0,-24
    800047ae:	4581                	li	a1,0
    800047b0:	4501                	li	a0,0
    800047b2:	00000097          	auipc	ra,0x0
    800047b6:	c78080e7          	jalr	-904(ra) # 8000442a <argfd>
    return -1;
    800047ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047bc:	02054563          	bltz	a0,800047e6 <sys_fstat+0x44>
    800047c0:	fe040593          	addi	a1,s0,-32
    800047c4:	4505                	li	a0,1
    800047c6:	ffffd097          	auipc	ra,0xffffd
    800047ca:	7c4080e7          	jalr	1988(ra) # 80001f8a <argaddr>
    return -1;
    800047ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047d0:	00054b63          	bltz	a0,800047e6 <sys_fstat+0x44>
  return filestat(f, st);
    800047d4:	fe043583          	ld	a1,-32(s0)
    800047d8:	fe843503          	ld	a0,-24(s0)
    800047dc:	fffff097          	auipc	ra,0xfffff
    800047e0:	31c080e7          	jalr	796(ra) # 80003af8 <filestat>
    800047e4:	87aa                	mv	a5,a0
}
    800047e6:	853e                	mv	a0,a5
    800047e8:	60e2                	ld	ra,24(sp)
    800047ea:	6442                	ld	s0,16(sp)
    800047ec:	6105                	addi	sp,sp,32
    800047ee:	8082                	ret

00000000800047f0 <sys_link>:
{
    800047f0:	7169                	addi	sp,sp,-304
    800047f2:	f606                	sd	ra,296(sp)
    800047f4:	f222                	sd	s0,288(sp)
    800047f6:	ee26                	sd	s1,280(sp)
    800047f8:	ea4a                	sd	s2,272(sp)
    800047fa:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047fc:	08000613          	li	a2,128
    80004800:	ed040593          	addi	a1,s0,-304
    80004804:	4501                	li	a0,0
    80004806:	ffffd097          	auipc	ra,0xffffd
    8000480a:	7a6080e7          	jalr	1958(ra) # 80001fac <argstr>
    return -1;
    8000480e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004810:	10054e63          	bltz	a0,8000492c <sys_link+0x13c>
    80004814:	08000613          	li	a2,128
    80004818:	f5040593          	addi	a1,s0,-176
    8000481c:	4505                	li	a0,1
    8000481e:	ffffd097          	auipc	ra,0xffffd
    80004822:	78e080e7          	jalr	1934(ra) # 80001fac <argstr>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004828:	10054263          	bltz	a0,8000492c <sys_link+0x13c>
  begin_op();
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	d38080e7          	jalr	-712(ra) # 80003564 <begin_op>
  if((ip = namei(old)) == 0){
    80004834:	ed040513          	addi	a0,s0,-304
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	b10080e7          	jalr	-1264(ra) # 80003348 <namei>
    80004840:	84aa                	mv	s1,a0
    80004842:	c551                	beqz	a0,800048ce <sys_link+0xde>
  ilock(ip);
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	34e080e7          	jalr	846(ra) # 80002b92 <ilock>
  if(ip->type == T_DIR){
    8000484c:	04449703          	lh	a4,68(s1)
    80004850:	4785                	li	a5,1
    80004852:	08f70463          	beq	a4,a5,800048da <sys_link+0xea>
  ip->nlink++;
    80004856:	04a4d783          	lhu	a5,74(s1)
    8000485a:	2785                	addiw	a5,a5,1
    8000485c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004860:	8526                	mv	a0,s1
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	266080e7          	jalr	614(ra) # 80002ac8 <iupdate>
  iunlock(ip);
    8000486a:	8526                	mv	a0,s1
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	3e8080e7          	jalr	1000(ra) # 80002c54 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004874:	fd040593          	addi	a1,s0,-48
    80004878:	f5040513          	addi	a0,s0,-176
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	aea080e7          	jalr	-1302(ra) # 80003366 <nameiparent>
    80004884:	892a                	mv	s2,a0
    80004886:	c935                	beqz	a0,800048fa <sys_link+0x10a>
  ilock(dp);
    80004888:	ffffe097          	auipc	ra,0xffffe
    8000488c:	30a080e7          	jalr	778(ra) # 80002b92 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004890:	00092703          	lw	a4,0(s2)
    80004894:	409c                	lw	a5,0(s1)
    80004896:	04f71d63          	bne	a4,a5,800048f0 <sys_link+0x100>
    8000489a:	40d0                	lw	a2,4(s1)
    8000489c:	fd040593          	addi	a1,s0,-48
    800048a0:	854a                	mv	a0,s2
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	9e4080e7          	jalr	-1564(ra) # 80003286 <dirlink>
    800048aa:	04054363          	bltz	a0,800048f0 <sys_link+0x100>
  iunlockput(dp);
    800048ae:	854a                	mv	a0,s2
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	544080e7          	jalr	1348(ra) # 80002df4 <iunlockput>
  iput(ip);
    800048b8:	8526                	mv	a0,s1
    800048ba:	ffffe097          	auipc	ra,0xffffe
    800048be:	492080e7          	jalr	1170(ra) # 80002d4c <iput>
  end_op();
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	d22080e7          	jalr	-734(ra) # 800035e4 <end_op>
  return 0;
    800048ca:	4781                	li	a5,0
    800048cc:	a085                	j	8000492c <sys_link+0x13c>
    end_op();
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	d16080e7          	jalr	-746(ra) # 800035e4 <end_op>
    return -1;
    800048d6:	57fd                	li	a5,-1
    800048d8:	a891                	j	8000492c <sys_link+0x13c>
    iunlockput(ip);
    800048da:	8526                	mv	a0,s1
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	518080e7          	jalr	1304(ra) # 80002df4 <iunlockput>
    end_op();
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	d00080e7          	jalr	-768(ra) # 800035e4 <end_op>
    return -1;
    800048ec:	57fd                	li	a5,-1
    800048ee:	a83d                	j	8000492c <sys_link+0x13c>
    iunlockput(dp);
    800048f0:	854a                	mv	a0,s2
    800048f2:	ffffe097          	auipc	ra,0xffffe
    800048f6:	502080e7          	jalr	1282(ra) # 80002df4 <iunlockput>
  ilock(ip);
    800048fa:	8526                	mv	a0,s1
    800048fc:	ffffe097          	auipc	ra,0xffffe
    80004900:	296080e7          	jalr	662(ra) # 80002b92 <ilock>
  ip->nlink--;
    80004904:	04a4d783          	lhu	a5,74(s1)
    80004908:	37fd                	addiw	a5,a5,-1
    8000490a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000490e:	8526                	mv	a0,s1
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	1b8080e7          	jalr	440(ra) # 80002ac8 <iupdate>
  iunlockput(ip);
    80004918:	8526                	mv	a0,s1
    8000491a:	ffffe097          	auipc	ra,0xffffe
    8000491e:	4da080e7          	jalr	1242(ra) # 80002df4 <iunlockput>
  end_op();
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	cc2080e7          	jalr	-830(ra) # 800035e4 <end_op>
  return -1;
    8000492a:	57fd                	li	a5,-1
}
    8000492c:	853e                	mv	a0,a5
    8000492e:	70b2                	ld	ra,296(sp)
    80004930:	7412                	ld	s0,288(sp)
    80004932:	64f2                	ld	s1,280(sp)
    80004934:	6952                	ld	s2,272(sp)
    80004936:	6155                	addi	sp,sp,304
    80004938:	8082                	ret

000000008000493a <sys_unlink>:
{
    8000493a:	7151                	addi	sp,sp,-240
    8000493c:	f586                	sd	ra,232(sp)
    8000493e:	f1a2                	sd	s0,224(sp)
    80004940:	eda6                	sd	s1,216(sp)
    80004942:	e9ca                	sd	s2,208(sp)
    80004944:	e5ce                	sd	s3,200(sp)
    80004946:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004948:	08000613          	li	a2,128
    8000494c:	f3040593          	addi	a1,s0,-208
    80004950:	4501                	li	a0,0
    80004952:	ffffd097          	auipc	ra,0xffffd
    80004956:	65a080e7          	jalr	1626(ra) # 80001fac <argstr>
    8000495a:	18054163          	bltz	a0,80004adc <sys_unlink+0x1a2>
  begin_op();
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	c06080e7          	jalr	-1018(ra) # 80003564 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004966:	fb040593          	addi	a1,s0,-80
    8000496a:	f3040513          	addi	a0,s0,-208
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	9f8080e7          	jalr	-1544(ra) # 80003366 <nameiparent>
    80004976:	84aa                	mv	s1,a0
    80004978:	c979                	beqz	a0,80004a4e <sys_unlink+0x114>
  ilock(dp);
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	218080e7          	jalr	536(ra) # 80002b92 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004982:	00004597          	auipc	a1,0x4
    80004986:	c0e58593          	addi	a1,a1,-1010 # 80008590 <etext+0x590>
    8000498a:	fb040513          	addi	a0,s0,-80
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	6ce080e7          	jalr	1742(ra) # 8000305c <namecmp>
    80004996:	14050a63          	beqz	a0,80004aea <sys_unlink+0x1b0>
    8000499a:	00004597          	auipc	a1,0x4
    8000499e:	bfe58593          	addi	a1,a1,-1026 # 80008598 <etext+0x598>
    800049a2:	fb040513          	addi	a0,s0,-80
    800049a6:	ffffe097          	auipc	ra,0xffffe
    800049aa:	6b6080e7          	jalr	1718(ra) # 8000305c <namecmp>
    800049ae:	12050e63          	beqz	a0,80004aea <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049b2:	f2c40613          	addi	a2,s0,-212
    800049b6:	fb040593          	addi	a1,s0,-80
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	6ba080e7          	jalr	1722(ra) # 80003076 <dirlookup>
    800049c4:	892a                	mv	s2,a0
    800049c6:	12050263          	beqz	a0,80004aea <sys_unlink+0x1b0>
  ilock(ip);
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	1c8080e7          	jalr	456(ra) # 80002b92 <ilock>
  if(ip->nlink < 1)
    800049d2:	04a91783          	lh	a5,74(s2)
    800049d6:	08f05263          	blez	a5,80004a5a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049da:	04491703          	lh	a4,68(s2)
    800049de:	4785                	li	a5,1
    800049e0:	08f70563          	beq	a4,a5,80004a6a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049e4:	4641                	li	a2,16
    800049e6:	4581                	li	a1,0
    800049e8:	fc040513          	addi	a0,s0,-64
    800049ec:	ffffb097          	auipc	ra,0xffffb
    800049f0:	78c080e7          	jalr	1932(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049f4:	4741                	li	a4,16
    800049f6:	f2c42683          	lw	a3,-212(s0)
    800049fa:	fc040613          	addi	a2,s0,-64
    800049fe:	4581                	li	a1,0
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	53c080e7          	jalr	1340(ra) # 80002f3e <writei>
    80004a0a:	47c1                	li	a5,16
    80004a0c:	0af51563          	bne	a0,a5,80004ab6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a10:	04491703          	lh	a4,68(s2)
    80004a14:	4785                	li	a5,1
    80004a16:	0af70863          	beq	a4,a5,80004ac6 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	3d8080e7          	jalr	984(ra) # 80002df4 <iunlockput>
  ip->nlink--;
    80004a24:	04a95783          	lhu	a5,74(s2)
    80004a28:	37fd                	addiw	a5,a5,-1
    80004a2a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a2e:	854a                	mv	a0,s2
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	098080e7          	jalr	152(ra) # 80002ac8 <iupdate>
  iunlockput(ip);
    80004a38:	854a                	mv	a0,s2
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	3ba080e7          	jalr	954(ra) # 80002df4 <iunlockput>
  end_op();
    80004a42:	fffff097          	auipc	ra,0xfffff
    80004a46:	ba2080e7          	jalr	-1118(ra) # 800035e4 <end_op>
  return 0;
    80004a4a:	4501                	li	a0,0
    80004a4c:	a84d                	j	80004afe <sys_unlink+0x1c4>
    end_op();
    80004a4e:	fffff097          	auipc	ra,0xfffff
    80004a52:	b96080e7          	jalr	-1130(ra) # 800035e4 <end_op>
    return -1;
    80004a56:	557d                	li	a0,-1
    80004a58:	a05d                	j	80004afe <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a5a:	00004517          	auipc	a0,0x4
    80004a5e:	b6650513          	addi	a0,a0,-1178 # 800085c0 <etext+0x5c0>
    80004a62:	00001097          	auipc	ra,0x1
    80004a66:	21c080e7          	jalr	540(ra) # 80005c7e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a6a:	04c92703          	lw	a4,76(s2)
    80004a6e:	02000793          	li	a5,32
    80004a72:	f6e7f9e3          	bgeu	a5,a4,800049e4 <sys_unlink+0xaa>
    80004a76:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a7a:	4741                	li	a4,16
    80004a7c:	86ce                	mv	a3,s3
    80004a7e:	f1840613          	addi	a2,s0,-232
    80004a82:	4581                	li	a1,0
    80004a84:	854a                	mv	a0,s2
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	3c0080e7          	jalr	960(ra) # 80002e46 <readi>
    80004a8e:	47c1                	li	a5,16
    80004a90:	00f51b63          	bne	a0,a5,80004aa6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a94:	f1845783          	lhu	a5,-232(s0)
    80004a98:	e7a1                	bnez	a5,80004ae0 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a9a:	29c1                	addiw	s3,s3,16
    80004a9c:	04c92783          	lw	a5,76(s2)
    80004aa0:	fcf9ede3          	bltu	s3,a5,80004a7a <sys_unlink+0x140>
    80004aa4:	b781                	j	800049e4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004aa6:	00004517          	auipc	a0,0x4
    80004aaa:	b3250513          	addi	a0,a0,-1230 # 800085d8 <etext+0x5d8>
    80004aae:	00001097          	auipc	ra,0x1
    80004ab2:	1d0080e7          	jalr	464(ra) # 80005c7e <panic>
    panic("unlink: writei");
    80004ab6:	00004517          	auipc	a0,0x4
    80004aba:	b3a50513          	addi	a0,a0,-1222 # 800085f0 <etext+0x5f0>
    80004abe:	00001097          	auipc	ra,0x1
    80004ac2:	1c0080e7          	jalr	448(ra) # 80005c7e <panic>
    dp->nlink--;
    80004ac6:	04a4d783          	lhu	a5,74(s1)
    80004aca:	37fd                	addiw	a5,a5,-1
    80004acc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ad0:	8526                	mv	a0,s1
    80004ad2:	ffffe097          	auipc	ra,0xffffe
    80004ad6:	ff6080e7          	jalr	-10(ra) # 80002ac8 <iupdate>
    80004ada:	b781                	j	80004a1a <sys_unlink+0xe0>
    return -1;
    80004adc:	557d                	li	a0,-1
    80004ade:	a005                	j	80004afe <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ae0:	854a                	mv	a0,s2
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	312080e7          	jalr	786(ra) # 80002df4 <iunlockput>
  iunlockput(dp);
    80004aea:	8526                	mv	a0,s1
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	308080e7          	jalr	776(ra) # 80002df4 <iunlockput>
  end_op();
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	af0080e7          	jalr	-1296(ra) # 800035e4 <end_op>
  return -1;
    80004afc:	557d                	li	a0,-1
}
    80004afe:	70ae                	ld	ra,232(sp)
    80004b00:	740e                	ld	s0,224(sp)
    80004b02:	64ee                	ld	s1,216(sp)
    80004b04:	694e                	ld	s2,208(sp)
    80004b06:	69ae                	ld	s3,200(sp)
    80004b08:	616d                	addi	sp,sp,240
    80004b0a:	8082                	ret

0000000080004b0c <sys_open>:

uint64
sys_open(void)
{
    80004b0c:	7131                	addi	sp,sp,-192
    80004b0e:	fd06                	sd	ra,184(sp)
    80004b10:	f922                	sd	s0,176(sp)
    80004b12:	f526                	sd	s1,168(sp)
    80004b14:	f14a                	sd	s2,160(sp)
    80004b16:	ed4e                	sd	s3,152(sp)
    80004b18:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b1a:	08000613          	li	a2,128
    80004b1e:	f5040593          	addi	a1,s0,-176
    80004b22:	4501                	li	a0,0
    80004b24:	ffffd097          	auipc	ra,0xffffd
    80004b28:	488080e7          	jalr	1160(ra) # 80001fac <argstr>
    return -1;
    80004b2c:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b2e:	0c054163          	bltz	a0,80004bf0 <sys_open+0xe4>
    80004b32:	f4c40593          	addi	a1,s0,-180
    80004b36:	4505                	li	a0,1
    80004b38:	ffffd097          	auipc	ra,0xffffd
    80004b3c:	430080e7          	jalr	1072(ra) # 80001f68 <argint>
    80004b40:	0a054863          	bltz	a0,80004bf0 <sys_open+0xe4>

  begin_op();
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	a20080e7          	jalr	-1504(ra) # 80003564 <begin_op>

  if(omode & O_CREATE){
    80004b4c:	f4c42783          	lw	a5,-180(s0)
    80004b50:	2007f793          	andi	a5,a5,512
    80004b54:	cbdd                	beqz	a5,80004c0a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b56:	4681                	li	a3,0
    80004b58:	4601                	li	a2,0
    80004b5a:	4589                	li	a1,2
    80004b5c:	f5040513          	addi	a0,s0,-176
    80004b60:	00000097          	auipc	ra,0x0
    80004b64:	974080e7          	jalr	-1676(ra) # 800044d4 <create>
    80004b68:	892a                	mv	s2,a0
    if(ip == 0){
    80004b6a:	c959                	beqz	a0,80004c00 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b6c:	04491703          	lh	a4,68(s2)
    80004b70:	478d                	li	a5,3
    80004b72:	00f71763          	bne	a4,a5,80004b80 <sys_open+0x74>
    80004b76:	04695703          	lhu	a4,70(s2)
    80004b7a:	47a5                	li	a5,9
    80004b7c:	0ce7ec63          	bltu	a5,a4,80004c54 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b80:	fffff097          	auipc	ra,0xfffff
    80004b84:	df4080e7          	jalr	-524(ra) # 80003974 <filealloc>
    80004b88:	89aa                	mv	s3,a0
    80004b8a:	10050263          	beqz	a0,80004c8e <sys_open+0x182>
    80004b8e:	00000097          	auipc	ra,0x0
    80004b92:	904080e7          	jalr	-1788(ra) # 80004492 <fdalloc>
    80004b96:	84aa                	mv	s1,a0
    80004b98:	0e054663          	bltz	a0,80004c84 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b9c:	04491703          	lh	a4,68(s2)
    80004ba0:	478d                	li	a5,3
    80004ba2:	0cf70463          	beq	a4,a5,80004c6a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ba6:	4789                	li	a5,2
    80004ba8:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bac:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bb0:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bb4:	f4c42783          	lw	a5,-180(s0)
    80004bb8:	0017c713          	xori	a4,a5,1
    80004bbc:	8b05                	andi	a4,a4,1
    80004bbe:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bc2:	0037f713          	andi	a4,a5,3
    80004bc6:	00e03733          	snez	a4,a4
    80004bca:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bce:	4007f793          	andi	a5,a5,1024
    80004bd2:	c791                	beqz	a5,80004bde <sys_open+0xd2>
    80004bd4:	04491703          	lh	a4,68(s2)
    80004bd8:	4789                	li	a5,2
    80004bda:	08f70f63          	beq	a4,a5,80004c78 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bde:	854a                	mv	a0,s2
    80004be0:	ffffe097          	auipc	ra,0xffffe
    80004be4:	074080e7          	jalr	116(ra) # 80002c54 <iunlock>
  end_op();
    80004be8:	fffff097          	auipc	ra,0xfffff
    80004bec:	9fc080e7          	jalr	-1540(ra) # 800035e4 <end_op>

  return fd;
}
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	70ea                	ld	ra,184(sp)
    80004bf4:	744a                	ld	s0,176(sp)
    80004bf6:	74aa                	ld	s1,168(sp)
    80004bf8:	790a                	ld	s2,160(sp)
    80004bfa:	69ea                	ld	s3,152(sp)
    80004bfc:	6129                	addi	sp,sp,192
    80004bfe:	8082                	ret
      end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	9e4080e7          	jalr	-1564(ra) # 800035e4 <end_op>
      return -1;
    80004c08:	b7e5                	j	80004bf0 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c0a:	f5040513          	addi	a0,s0,-176
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	73a080e7          	jalr	1850(ra) # 80003348 <namei>
    80004c16:	892a                	mv	s2,a0
    80004c18:	c905                	beqz	a0,80004c48 <sys_open+0x13c>
    ilock(ip);
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	f78080e7          	jalr	-136(ra) # 80002b92 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c22:	04491703          	lh	a4,68(s2)
    80004c26:	4785                	li	a5,1
    80004c28:	f4f712e3          	bne	a4,a5,80004b6c <sys_open+0x60>
    80004c2c:	f4c42783          	lw	a5,-180(s0)
    80004c30:	dba1                	beqz	a5,80004b80 <sys_open+0x74>
      iunlockput(ip);
    80004c32:	854a                	mv	a0,s2
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	1c0080e7          	jalr	448(ra) # 80002df4 <iunlockput>
      end_op();
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	9a8080e7          	jalr	-1624(ra) # 800035e4 <end_op>
      return -1;
    80004c44:	54fd                	li	s1,-1
    80004c46:	b76d                	j	80004bf0 <sys_open+0xe4>
      end_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	99c080e7          	jalr	-1636(ra) # 800035e4 <end_op>
      return -1;
    80004c50:	54fd                	li	s1,-1
    80004c52:	bf79                	j	80004bf0 <sys_open+0xe4>
    iunlockput(ip);
    80004c54:	854a                	mv	a0,s2
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	19e080e7          	jalr	414(ra) # 80002df4 <iunlockput>
    end_op();
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	986080e7          	jalr	-1658(ra) # 800035e4 <end_op>
    return -1;
    80004c66:	54fd                	li	s1,-1
    80004c68:	b761                	j	80004bf0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c6a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c6e:	04691783          	lh	a5,70(s2)
    80004c72:	02f99223          	sh	a5,36(s3)
    80004c76:	bf2d                	j	80004bb0 <sys_open+0xa4>
    itrunc(ip);
    80004c78:	854a                	mv	a0,s2
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	026080e7          	jalr	38(ra) # 80002ca0 <itrunc>
    80004c82:	bfb1                	j	80004bde <sys_open+0xd2>
      fileclose(f);
    80004c84:	854e                	mv	a0,s3
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	daa080e7          	jalr	-598(ra) # 80003a30 <fileclose>
    iunlockput(ip);
    80004c8e:	854a                	mv	a0,s2
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	164080e7          	jalr	356(ra) # 80002df4 <iunlockput>
    end_op();
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	94c080e7          	jalr	-1716(ra) # 800035e4 <end_op>
    return -1;
    80004ca0:	54fd                	li	s1,-1
    80004ca2:	b7b9                	j	80004bf0 <sys_open+0xe4>

0000000080004ca4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ca4:	7175                	addi	sp,sp,-144
    80004ca6:	e506                	sd	ra,136(sp)
    80004ca8:	e122                	sd	s0,128(sp)
    80004caa:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	8b8080e7          	jalr	-1864(ra) # 80003564 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cb4:	08000613          	li	a2,128
    80004cb8:	f7040593          	addi	a1,s0,-144
    80004cbc:	4501                	li	a0,0
    80004cbe:	ffffd097          	auipc	ra,0xffffd
    80004cc2:	2ee080e7          	jalr	750(ra) # 80001fac <argstr>
    80004cc6:	02054963          	bltz	a0,80004cf8 <sys_mkdir+0x54>
    80004cca:	4681                	li	a3,0
    80004ccc:	4601                	li	a2,0
    80004cce:	4585                	li	a1,1
    80004cd0:	f7040513          	addi	a0,s0,-144
    80004cd4:	00000097          	auipc	ra,0x0
    80004cd8:	800080e7          	jalr	-2048(ra) # 800044d4 <create>
    80004cdc:	cd11                	beqz	a0,80004cf8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	116080e7          	jalr	278(ra) # 80002df4 <iunlockput>
  end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	8fe080e7          	jalr	-1794(ra) # 800035e4 <end_op>
  return 0;
    80004cee:	4501                	li	a0,0
}
    80004cf0:	60aa                	ld	ra,136(sp)
    80004cf2:	640a                	ld	s0,128(sp)
    80004cf4:	6149                	addi	sp,sp,144
    80004cf6:	8082                	ret
    end_op();
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	8ec080e7          	jalr	-1812(ra) # 800035e4 <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	b7fd                	j	80004cf0 <sys_mkdir+0x4c>

0000000080004d04 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d04:	7135                	addi	sp,sp,-160
    80004d06:	ed06                	sd	ra,152(sp)
    80004d08:	e922                	sd	s0,144(sp)
    80004d0a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d0c:	fffff097          	auipc	ra,0xfffff
    80004d10:	858080e7          	jalr	-1960(ra) # 80003564 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d14:	08000613          	li	a2,128
    80004d18:	f7040593          	addi	a1,s0,-144
    80004d1c:	4501                	li	a0,0
    80004d1e:	ffffd097          	auipc	ra,0xffffd
    80004d22:	28e080e7          	jalr	654(ra) # 80001fac <argstr>
    80004d26:	04054a63          	bltz	a0,80004d7a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d2a:	f6c40593          	addi	a1,s0,-148
    80004d2e:	4505                	li	a0,1
    80004d30:	ffffd097          	auipc	ra,0xffffd
    80004d34:	238080e7          	jalr	568(ra) # 80001f68 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d38:	04054163          	bltz	a0,80004d7a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d3c:	f6840593          	addi	a1,s0,-152
    80004d40:	4509                	li	a0,2
    80004d42:	ffffd097          	auipc	ra,0xffffd
    80004d46:	226080e7          	jalr	550(ra) # 80001f68 <argint>
     argint(1, &major) < 0 ||
    80004d4a:	02054863          	bltz	a0,80004d7a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d4e:	f6841683          	lh	a3,-152(s0)
    80004d52:	f6c41603          	lh	a2,-148(s0)
    80004d56:	458d                	li	a1,3
    80004d58:	f7040513          	addi	a0,s0,-144
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	778080e7          	jalr	1912(ra) # 800044d4 <create>
     argint(2, &minor) < 0 ||
    80004d64:	c919                	beqz	a0,80004d7a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d66:	ffffe097          	auipc	ra,0xffffe
    80004d6a:	08e080e7          	jalr	142(ra) # 80002df4 <iunlockput>
  end_op();
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	876080e7          	jalr	-1930(ra) # 800035e4 <end_op>
  return 0;
    80004d76:	4501                	li	a0,0
    80004d78:	a031                	j	80004d84 <sys_mknod+0x80>
    end_op();
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	86a080e7          	jalr	-1942(ra) # 800035e4 <end_op>
    return -1;
    80004d82:	557d                	li	a0,-1
}
    80004d84:	60ea                	ld	ra,152(sp)
    80004d86:	644a                	ld	s0,144(sp)
    80004d88:	610d                	addi	sp,sp,160
    80004d8a:	8082                	ret

0000000080004d8c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d8c:	7135                	addi	sp,sp,-160
    80004d8e:	ed06                	sd	ra,152(sp)
    80004d90:	e922                	sd	s0,144(sp)
    80004d92:	e526                	sd	s1,136(sp)
    80004d94:	e14a                	sd	s2,128(sp)
    80004d96:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	0aa080e7          	jalr	170(ra) # 80000e42 <myproc>
    80004da0:	892a                	mv	s2,a0
  
  begin_op();
    80004da2:	ffffe097          	auipc	ra,0xffffe
    80004da6:	7c2080e7          	jalr	1986(ra) # 80003564 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004daa:	08000613          	li	a2,128
    80004dae:	f6040593          	addi	a1,s0,-160
    80004db2:	4501                	li	a0,0
    80004db4:	ffffd097          	auipc	ra,0xffffd
    80004db8:	1f8080e7          	jalr	504(ra) # 80001fac <argstr>
    80004dbc:	04054b63          	bltz	a0,80004e12 <sys_chdir+0x86>
    80004dc0:	f6040513          	addi	a0,s0,-160
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	584080e7          	jalr	1412(ra) # 80003348 <namei>
    80004dcc:	84aa                	mv	s1,a0
    80004dce:	c131                	beqz	a0,80004e12 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dd0:	ffffe097          	auipc	ra,0xffffe
    80004dd4:	dc2080e7          	jalr	-574(ra) # 80002b92 <ilock>
  if(ip->type != T_DIR){
    80004dd8:	04449703          	lh	a4,68(s1)
    80004ddc:	4785                	li	a5,1
    80004dde:	04f71063          	bne	a4,a5,80004e1e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004de2:	8526                	mv	a0,s1
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	e70080e7          	jalr	-400(ra) # 80002c54 <iunlock>
  iput(p->cwd);
    80004dec:	15093503          	ld	a0,336(s2)
    80004df0:	ffffe097          	auipc	ra,0xffffe
    80004df4:	f5c080e7          	jalr	-164(ra) # 80002d4c <iput>
  end_op();
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	7ec080e7          	jalr	2028(ra) # 800035e4 <end_op>
  p->cwd = ip;
    80004e00:	14993823          	sd	s1,336(s2)
  return 0;
    80004e04:	4501                	li	a0,0
}
    80004e06:	60ea                	ld	ra,152(sp)
    80004e08:	644a                	ld	s0,144(sp)
    80004e0a:	64aa                	ld	s1,136(sp)
    80004e0c:	690a                	ld	s2,128(sp)
    80004e0e:	610d                	addi	sp,sp,160
    80004e10:	8082                	ret
    end_op();
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	7d2080e7          	jalr	2002(ra) # 800035e4 <end_op>
    return -1;
    80004e1a:	557d                	li	a0,-1
    80004e1c:	b7ed                	j	80004e06 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e1e:	8526                	mv	a0,s1
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	fd4080e7          	jalr	-44(ra) # 80002df4 <iunlockput>
    end_op();
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	7bc080e7          	jalr	1980(ra) # 800035e4 <end_op>
    return -1;
    80004e30:	557d                	li	a0,-1
    80004e32:	bfd1                	j	80004e06 <sys_chdir+0x7a>

0000000080004e34 <sys_exec>:

uint64
sys_exec(void)
{
    80004e34:	7145                	addi	sp,sp,-464
    80004e36:	e786                	sd	ra,456(sp)
    80004e38:	e3a2                	sd	s0,448(sp)
    80004e3a:	ff26                	sd	s1,440(sp)
    80004e3c:	fb4a                	sd	s2,432(sp)
    80004e3e:	f74e                	sd	s3,424(sp)
    80004e40:	f352                	sd	s4,416(sp)
    80004e42:	ef56                	sd	s5,408(sp)
    80004e44:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e46:	08000613          	li	a2,128
    80004e4a:	f4040593          	addi	a1,s0,-192
    80004e4e:	4501                	li	a0,0
    80004e50:	ffffd097          	auipc	ra,0xffffd
    80004e54:	15c080e7          	jalr	348(ra) # 80001fac <argstr>
    return -1;
    80004e58:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e5a:	0c054a63          	bltz	a0,80004f2e <sys_exec+0xfa>
    80004e5e:	e3840593          	addi	a1,s0,-456
    80004e62:	4505                	li	a0,1
    80004e64:	ffffd097          	auipc	ra,0xffffd
    80004e68:	126080e7          	jalr	294(ra) # 80001f8a <argaddr>
    80004e6c:	0c054163          	bltz	a0,80004f2e <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e70:	10000613          	li	a2,256
    80004e74:	4581                	li	a1,0
    80004e76:	e4040513          	addi	a0,s0,-448
    80004e7a:	ffffb097          	auipc	ra,0xffffb
    80004e7e:	2fe080e7          	jalr	766(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e82:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e86:	89a6                	mv	s3,s1
    80004e88:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e8a:	02000a13          	li	s4,32
    80004e8e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e92:	00391793          	slli	a5,s2,0x3
    80004e96:	e3040593          	addi	a1,s0,-464
    80004e9a:	e3843503          	ld	a0,-456(s0)
    80004e9e:	953e                	add	a0,a0,a5
    80004ea0:	ffffd097          	auipc	ra,0xffffd
    80004ea4:	02e080e7          	jalr	46(ra) # 80001ece <fetchaddr>
    80004ea8:	02054a63          	bltz	a0,80004edc <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004eac:	e3043783          	ld	a5,-464(s0)
    80004eb0:	c3b9                	beqz	a5,80004ef6 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eb2:	ffffb097          	auipc	ra,0xffffb
    80004eb6:	266080e7          	jalr	614(ra) # 80000118 <kalloc>
    80004eba:	85aa                	mv	a1,a0
    80004ebc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ec0:	cd11                	beqz	a0,80004edc <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ec2:	6605                	lui	a2,0x1
    80004ec4:	e3043503          	ld	a0,-464(s0)
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	058080e7          	jalr	88(ra) # 80001f20 <fetchstr>
    80004ed0:	00054663          	bltz	a0,80004edc <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004ed4:	0905                	addi	s2,s2,1
    80004ed6:	09a1                	addi	s3,s3,8
    80004ed8:	fb491be3          	bne	s2,s4,80004e8e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004edc:	10048913          	addi	s2,s1,256
    80004ee0:	6088                	ld	a0,0(s1)
    80004ee2:	c529                	beqz	a0,80004f2c <sys_exec+0xf8>
    kfree(argv[i]);
    80004ee4:	ffffb097          	auipc	ra,0xffffb
    80004ee8:	138080e7          	jalr	312(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eec:	04a1                	addi	s1,s1,8
    80004eee:	ff2499e3          	bne	s1,s2,80004ee0 <sys_exec+0xac>
  return -1;
    80004ef2:	597d                	li	s2,-1
    80004ef4:	a82d                	j	80004f2e <sys_exec+0xfa>
      argv[i] = 0;
    80004ef6:	0a8e                	slli	s5,s5,0x3
    80004ef8:	fc040793          	addi	a5,s0,-64
    80004efc:	9abe                	add	s5,s5,a5
    80004efe:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd4c40>
  int ret = exec(path, argv);
    80004f02:	e4040593          	addi	a1,s0,-448
    80004f06:	f4040513          	addi	a0,s0,-192
    80004f0a:	fffff097          	auipc	ra,0xfffff
    80004f0e:	178080e7          	jalr	376(ra) # 80004082 <exec>
    80004f12:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f14:	10048993          	addi	s3,s1,256
    80004f18:	6088                	ld	a0,0(s1)
    80004f1a:	c911                	beqz	a0,80004f2e <sys_exec+0xfa>
    kfree(argv[i]);
    80004f1c:	ffffb097          	auipc	ra,0xffffb
    80004f20:	100080e7          	jalr	256(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f24:	04a1                	addi	s1,s1,8
    80004f26:	ff3499e3          	bne	s1,s3,80004f18 <sys_exec+0xe4>
    80004f2a:	a011                	j	80004f2e <sys_exec+0xfa>
  return -1;
    80004f2c:	597d                	li	s2,-1
}
    80004f2e:	854a                	mv	a0,s2
    80004f30:	60be                	ld	ra,456(sp)
    80004f32:	641e                	ld	s0,448(sp)
    80004f34:	74fa                	ld	s1,440(sp)
    80004f36:	795a                	ld	s2,432(sp)
    80004f38:	79ba                	ld	s3,424(sp)
    80004f3a:	7a1a                	ld	s4,416(sp)
    80004f3c:	6afa                	ld	s5,408(sp)
    80004f3e:	6179                	addi	sp,sp,464
    80004f40:	8082                	ret

0000000080004f42 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f42:	7139                	addi	sp,sp,-64
    80004f44:	fc06                	sd	ra,56(sp)
    80004f46:	f822                	sd	s0,48(sp)
    80004f48:	f426                	sd	s1,40(sp)
    80004f4a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f4c:	ffffc097          	auipc	ra,0xffffc
    80004f50:	ef6080e7          	jalr	-266(ra) # 80000e42 <myproc>
    80004f54:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f56:	fd840593          	addi	a1,s0,-40
    80004f5a:	4501                	li	a0,0
    80004f5c:	ffffd097          	auipc	ra,0xffffd
    80004f60:	02e080e7          	jalr	46(ra) # 80001f8a <argaddr>
    return -1;
    80004f64:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f66:	0e054063          	bltz	a0,80005046 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f6a:	fc840593          	addi	a1,s0,-56
    80004f6e:	fd040513          	addi	a0,s0,-48
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	dee080e7          	jalr	-530(ra) # 80003d60 <pipealloc>
    return -1;
    80004f7a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f7c:	0c054563          	bltz	a0,80005046 <sys_pipe+0x104>
  fd0 = -1;
    80004f80:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f84:	fd043503          	ld	a0,-48(s0)
    80004f88:	fffff097          	auipc	ra,0xfffff
    80004f8c:	50a080e7          	jalr	1290(ra) # 80004492 <fdalloc>
    80004f90:	fca42223          	sw	a0,-60(s0)
    80004f94:	08054c63          	bltz	a0,8000502c <sys_pipe+0xea>
    80004f98:	fc843503          	ld	a0,-56(s0)
    80004f9c:	fffff097          	auipc	ra,0xfffff
    80004fa0:	4f6080e7          	jalr	1270(ra) # 80004492 <fdalloc>
    80004fa4:	fca42023          	sw	a0,-64(s0)
    80004fa8:	06054863          	bltz	a0,80005018 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fac:	4691                	li	a3,4
    80004fae:	fc440613          	addi	a2,s0,-60
    80004fb2:	fd843583          	ld	a1,-40(s0)
    80004fb6:	68a8                	ld	a0,80(s1)
    80004fb8:	ffffc097          	auipc	ra,0xffffc
    80004fbc:	b4a080e7          	jalr	-1206(ra) # 80000b02 <copyout>
    80004fc0:	02054063          	bltz	a0,80004fe0 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fc4:	4691                	li	a3,4
    80004fc6:	fc040613          	addi	a2,s0,-64
    80004fca:	fd843583          	ld	a1,-40(s0)
    80004fce:	0591                	addi	a1,a1,4
    80004fd0:	68a8                	ld	a0,80(s1)
    80004fd2:	ffffc097          	auipc	ra,0xffffc
    80004fd6:	b30080e7          	jalr	-1232(ra) # 80000b02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fda:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fdc:	06055563          	bgez	a0,80005046 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fe0:	fc442783          	lw	a5,-60(s0)
    80004fe4:	07e9                	addi	a5,a5,26
    80004fe6:	078e                	slli	a5,a5,0x3
    80004fe8:	97a6                	add	a5,a5,s1
    80004fea:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fee:	fc042503          	lw	a0,-64(s0)
    80004ff2:	0569                	addi	a0,a0,26
    80004ff4:	050e                	slli	a0,a0,0x3
    80004ff6:	9526                	add	a0,a0,s1
    80004ff8:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004ffc:	fd043503          	ld	a0,-48(s0)
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	a30080e7          	jalr	-1488(ra) # 80003a30 <fileclose>
    fileclose(wf);
    80005008:	fc843503          	ld	a0,-56(s0)
    8000500c:	fffff097          	auipc	ra,0xfffff
    80005010:	a24080e7          	jalr	-1500(ra) # 80003a30 <fileclose>
    return -1;
    80005014:	57fd                	li	a5,-1
    80005016:	a805                	j	80005046 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005018:	fc442783          	lw	a5,-60(s0)
    8000501c:	0007c863          	bltz	a5,8000502c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005020:	01a78513          	addi	a0,a5,26
    80005024:	050e                	slli	a0,a0,0x3
    80005026:	9526                	add	a0,a0,s1
    80005028:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000502c:	fd043503          	ld	a0,-48(s0)
    80005030:	fffff097          	auipc	ra,0xfffff
    80005034:	a00080e7          	jalr	-1536(ra) # 80003a30 <fileclose>
    fileclose(wf);
    80005038:	fc843503          	ld	a0,-56(s0)
    8000503c:	fffff097          	auipc	ra,0xfffff
    80005040:	9f4080e7          	jalr	-1548(ra) # 80003a30 <fileclose>
    return -1;
    80005044:	57fd                	li	a5,-1
}
    80005046:	853e                	mv	a0,a5
    80005048:	70e2                	ld	ra,56(sp)
    8000504a:	7442                	ld	s0,48(sp)
    8000504c:	74a2                	ld	s1,40(sp)
    8000504e:	6121                	addi	sp,sp,64
    80005050:	8082                	ret
	...

0000000080005060 <kernelvec>:
    80005060:	7111                	addi	sp,sp,-256
    80005062:	e006                	sd	ra,0(sp)
    80005064:	e40a                	sd	sp,8(sp)
    80005066:	e80e                	sd	gp,16(sp)
    80005068:	ec12                	sd	tp,24(sp)
    8000506a:	f016                	sd	t0,32(sp)
    8000506c:	f41a                	sd	t1,40(sp)
    8000506e:	f81e                	sd	t2,48(sp)
    80005070:	fc22                	sd	s0,56(sp)
    80005072:	e0a6                	sd	s1,64(sp)
    80005074:	e4aa                	sd	a0,72(sp)
    80005076:	e8ae                	sd	a1,80(sp)
    80005078:	ecb2                	sd	a2,88(sp)
    8000507a:	f0b6                	sd	a3,96(sp)
    8000507c:	f4ba                	sd	a4,104(sp)
    8000507e:	f8be                	sd	a5,112(sp)
    80005080:	fcc2                	sd	a6,120(sp)
    80005082:	e146                	sd	a7,128(sp)
    80005084:	e54a                	sd	s2,136(sp)
    80005086:	e94e                	sd	s3,144(sp)
    80005088:	ed52                	sd	s4,152(sp)
    8000508a:	f156                	sd	s5,160(sp)
    8000508c:	f55a                	sd	s6,168(sp)
    8000508e:	f95e                	sd	s7,176(sp)
    80005090:	fd62                	sd	s8,184(sp)
    80005092:	e1e6                	sd	s9,192(sp)
    80005094:	e5ea                	sd	s10,200(sp)
    80005096:	e9ee                	sd	s11,208(sp)
    80005098:	edf2                	sd	t3,216(sp)
    8000509a:	f1f6                	sd	t4,224(sp)
    8000509c:	f5fa                	sd	t5,232(sp)
    8000509e:	f9fe                	sd	t6,240(sp)
    800050a0:	cfbfc0ef          	jal	80001d9a <kerneltrap>
    800050a4:	6082                	ld	ra,0(sp)
    800050a6:	6122                	ld	sp,8(sp)
    800050a8:	61c2                	ld	gp,16(sp)
    800050aa:	7282                	ld	t0,32(sp)
    800050ac:	7322                	ld	t1,40(sp)
    800050ae:	73c2                	ld	t2,48(sp)
    800050b0:	7462                	ld	s0,56(sp)
    800050b2:	6486                	ld	s1,64(sp)
    800050b4:	6526                	ld	a0,72(sp)
    800050b6:	65c6                	ld	a1,80(sp)
    800050b8:	6666                	ld	a2,88(sp)
    800050ba:	7686                	ld	a3,96(sp)
    800050bc:	7726                	ld	a4,104(sp)
    800050be:	77c6                	ld	a5,112(sp)
    800050c0:	7866                	ld	a6,120(sp)
    800050c2:	688a                	ld	a7,128(sp)
    800050c4:	692a                	ld	s2,136(sp)
    800050c6:	69ca                	ld	s3,144(sp)
    800050c8:	6a6a                	ld	s4,152(sp)
    800050ca:	7a8a                	ld	s5,160(sp)
    800050cc:	7b2a                	ld	s6,168(sp)
    800050ce:	7bca                	ld	s7,176(sp)
    800050d0:	7c6a                	ld	s8,184(sp)
    800050d2:	6c8e                	ld	s9,192(sp)
    800050d4:	6d2e                	ld	s10,200(sp)
    800050d6:	6dce                	ld	s11,208(sp)
    800050d8:	6e6e                	ld	t3,216(sp)
    800050da:	7e8e                	ld	t4,224(sp)
    800050dc:	7f2e                	ld	t5,232(sp)
    800050de:	7fce                	ld	t6,240(sp)
    800050e0:	6111                	addi	sp,sp,256
    800050e2:	10200073          	sret
    800050e6:	00000013          	nop
    800050ea:	00000013          	nop
    800050ee:	0001                	nop

00000000800050f0 <timervec>:
    800050f0:	34051573          	csrrw	a0,mscratch,a0
    800050f4:	e10c                	sd	a1,0(a0)
    800050f6:	e510                	sd	a2,8(a0)
    800050f8:	e914                	sd	a3,16(a0)
    800050fa:	6d0c                	ld	a1,24(a0)
    800050fc:	7110                	ld	a2,32(a0)
    800050fe:	6194                	ld	a3,0(a1)
    80005100:	96b2                	add	a3,a3,a2
    80005102:	e194                	sd	a3,0(a1)
    80005104:	4589                	li	a1,2
    80005106:	14459073          	csrw	sip,a1
    8000510a:	6914                	ld	a3,16(a0)
    8000510c:	6510                	ld	a2,8(a0)
    8000510e:	610c                	ld	a1,0(a0)
    80005110:	34051573          	csrrw	a0,mscratch,a0
    80005114:	30200073          	mret
	...

000000008000511a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000511a:	1141                	addi	sp,sp,-16
    8000511c:	e422                	sd	s0,8(sp)
    8000511e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005120:	0c0007b7          	lui	a5,0xc000
    80005124:	4705                	li	a4,1
    80005126:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005128:	c3d8                	sw	a4,4(a5)
}
    8000512a:	6422                	ld	s0,8(sp)
    8000512c:	0141                	addi	sp,sp,16
    8000512e:	8082                	ret

0000000080005130 <plicinithart>:

void
plicinithart(void)
{
    80005130:	1141                	addi	sp,sp,-16
    80005132:	e406                	sd	ra,8(sp)
    80005134:	e022                	sd	s0,0(sp)
    80005136:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	cde080e7          	jalr	-802(ra) # 80000e16 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005140:	0085171b          	slliw	a4,a0,0x8
    80005144:	0c0027b7          	lui	a5,0xc002
    80005148:	97ba                	add	a5,a5,a4
    8000514a:	40200713          	li	a4,1026
    8000514e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005152:	00d5151b          	slliw	a0,a0,0xd
    80005156:	0c2017b7          	lui	a5,0xc201
    8000515a:	953e                	add	a0,a0,a5
    8000515c:	00052023          	sw	zero,0(a0)
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	addi	sp,sp,16
    80005166:	8082                	ret

0000000080005168 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005168:	1141                	addi	sp,sp,-16
    8000516a:	e406                	sd	ra,8(sp)
    8000516c:	e022                	sd	s0,0(sp)
    8000516e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	ca6080e7          	jalr	-858(ra) # 80000e16 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005178:	00d5179b          	slliw	a5,a0,0xd
    8000517c:	0c201537          	lui	a0,0xc201
    80005180:	953e                	add	a0,a0,a5
  return irq;
}
    80005182:	4148                	lw	a0,4(a0)
    80005184:	60a2                	ld	ra,8(sp)
    80005186:	6402                	ld	s0,0(sp)
    80005188:	0141                	addi	sp,sp,16
    8000518a:	8082                	ret

000000008000518c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000518c:	1101                	addi	sp,sp,-32
    8000518e:	ec06                	sd	ra,24(sp)
    80005190:	e822                	sd	s0,16(sp)
    80005192:	e426                	sd	s1,8(sp)
    80005194:	1000                	addi	s0,sp,32
    80005196:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	c7e080e7          	jalr	-898(ra) # 80000e16 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051a0:	00d5151b          	slliw	a0,a0,0xd
    800051a4:	0c2017b7          	lui	a5,0xc201
    800051a8:	97aa                	add	a5,a5,a0
    800051aa:	c3c4                	sw	s1,4(a5)
}
    800051ac:	60e2                	ld	ra,24(sp)
    800051ae:	6442                	ld	s0,16(sp)
    800051b0:	64a2                	ld	s1,8(sp)
    800051b2:	6105                	addi	sp,sp,32
    800051b4:	8082                	ret

00000000800051b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051b6:	1141                	addi	sp,sp,-16
    800051b8:	e406                	sd	ra,8(sp)
    800051ba:	e022                	sd	s0,0(sp)
    800051bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051be:	479d                	li	a5,7
    800051c0:	06a7c963          	blt	a5,a0,80005232 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051c4:	0001a797          	auipc	a5,0x1a
    800051c8:	e3c78793          	addi	a5,a5,-452 # 8001f000 <disk>
    800051cc:	00a78733          	add	a4,a5,a0
    800051d0:	6789                	lui	a5,0x2
    800051d2:	97ba                	add	a5,a5,a4
    800051d4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051d8:	e7ad                	bnez	a5,80005242 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051da:	00451793          	slli	a5,a0,0x4
    800051de:	0001c717          	auipc	a4,0x1c
    800051e2:	e2270713          	addi	a4,a4,-478 # 80021000 <disk+0x2000>
    800051e6:	6314                	ld	a3,0(a4)
    800051e8:	96be                	add	a3,a3,a5
    800051ea:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051ee:	6314                	ld	a3,0(a4)
    800051f0:	96be                	add	a3,a3,a5
    800051f2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051f6:	6314                	ld	a3,0(a4)
    800051f8:	96be                	add	a3,a3,a5
    800051fa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051fe:	6318                	ld	a4,0(a4)
    80005200:	97ba                	add	a5,a5,a4
    80005202:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005206:	0001a797          	auipc	a5,0x1a
    8000520a:	dfa78793          	addi	a5,a5,-518 # 8001f000 <disk>
    8000520e:	97aa                	add	a5,a5,a0
    80005210:	6509                	lui	a0,0x2
    80005212:	953e                	add	a0,a0,a5
    80005214:	4785                	li	a5,1
    80005216:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000521a:	0001c517          	auipc	a0,0x1c
    8000521e:	dfe50513          	addi	a0,a0,-514 # 80021018 <disk+0x2018>
    80005222:	ffffc097          	auipc	ra,0xffffc
    80005226:	47a080e7          	jalr	1146(ra) # 8000169c <wakeup>
}
    8000522a:	60a2                	ld	ra,8(sp)
    8000522c:	6402                	ld	s0,0(sp)
    8000522e:	0141                	addi	sp,sp,16
    80005230:	8082                	ret
    panic("free_desc 1");
    80005232:	00003517          	auipc	a0,0x3
    80005236:	3ce50513          	addi	a0,a0,974 # 80008600 <etext+0x600>
    8000523a:	00001097          	auipc	ra,0x1
    8000523e:	a44080e7          	jalr	-1468(ra) # 80005c7e <panic>
    panic("free_desc 2");
    80005242:	00003517          	auipc	a0,0x3
    80005246:	3ce50513          	addi	a0,a0,974 # 80008610 <etext+0x610>
    8000524a:	00001097          	auipc	ra,0x1
    8000524e:	a34080e7          	jalr	-1484(ra) # 80005c7e <panic>

0000000080005252 <virtio_disk_init>:
{
    80005252:	1101                	addi	sp,sp,-32
    80005254:	ec06                	sd	ra,24(sp)
    80005256:	e822                	sd	s0,16(sp)
    80005258:	e426                	sd	s1,8(sp)
    8000525a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000525c:	00003597          	auipc	a1,0x3
    80005260:	3c458593          	addi	a1,a1,964 # 80008620 <etext+0x620>
    80005264:	0001c517          	auipc	a0,0x1c
    80005268:	ec450513          	addi	a0,a0,-316 # 80021128 <disk+0x2128>
    8000526c:	00001097          	auipc	ra,0x1
    80005270:	e94080e7          	jalr	-364(ra) # 80006100 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005274:	100017b7          	lui	a5,0x10001
    80005278:	4398                	lw	a4,0(a5)
    8000527a:	2701                	sext.w	a4,a4
    8000527c:	747277b7          	lui	a5,0x74727
    80005280:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005284:	0ef71163          	bne	a4,a5,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005288:	100017b7          	lui	a5,0x10001
    8000528c:	43dc                	lw	a5,4(a5)
    8000528e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005290:	4705                	li	a4,1
    80005292:	0ce79a63          	bne	a5,a4,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005296:	100017b7          	lui	a5,0x10001
    8000529a:	479c                	lw	a5,8(a5)
    8000529c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000529e:	4709                	li	a4,2
    800052a0:	0ce79363          	bne	a5,a4,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052a4:	100017b7          	lui	a5,0x10001
    800052a8:	47d8                	lw	a4,12(a5)
    800052aa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ac:	554d47b7          	lui	a5,0x554d4
    800052b0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052b4:	0af71963          	bne	a4,a5,80005366 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b8:	100017b7          	lui	a5,0x10001
    800052bc:	4705                	li	a4,1
    800052be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c0:	470d                	li	a4,3
    800052c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052c4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052c6:	c7ffe737          	lui	a4,0xc7ffe
    800052ca:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd451f>
    800052ce:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052d0:	2701                	sext.w	a4,a4
    800052d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d4:	472d                	li	a4,11
    800052d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d8:	473d                	li	a4,15
    800052da:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052dc:	6705                	lui	a4,0x1
    800052de:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052e0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052e4:	5bdc                	lw	a5,52(a5)
    800052e6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052e8:	c7d9                	beqz	a5,80005376 <virtio_disk_init+0x124>
  if(max < NUM)
    800052ea:	471d                	li	a4,7
    800052ec:	08f77d63          	bgeu	a4,a5,80005386 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052f0:	100014b7          	lui	s1,0x10001
    800052f4:	47a1                	li	a5,8
    800052f6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052f8:	6609                	lui	a2,0x2
    800052fa:	4581                	li	a1,0
    800052fc:	0001a517          	auipc	a0,0x1a
    80005300:	d0450513          	addi	a0,a0,-764 # 8001f000 <disk>
    80005304:	ffffb097          	auipc	ra,0xffffb
    80005308:	e74080e7          	jalr	-396(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000530c:	0001a717          	auipc	a4,0x1a
    80005310:	cf470713          	addi	a4,a4,-780 # 8001f000 <disk>
    80005314:	00c75793          	srli	a5,a4,0xc
    80005318:	2781                	sext.w	a5,a5
    8000531a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000531c:	0001c797          	auipc	a5,0x1c
    80005320:	ce478793          	addi	a5,a5,-796 # 80021000 <disk+0x2000>
    80005324:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005326:	0001a717          	auipc	a4,0x1a
    8000532a:	d5a70713          	addi	a4,a4,-678 # 8001f080 <disk+0x80>
    8000532e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005330:	0001b717          	auipc	a4,0x1b
    80005334:	cd070713          	addi	a4,a4,-816 # 80020000 <disk+0x1000>
    80005338:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000533a:	4705                	li	a4,1
    8000533c:	00e78c23          	sb	a4,24(a5)
    80005340:	00e78ca3          	sb	a4,25(a5)
    80005344:	00e78d23          	sb	a4,26(a5)
    80005348:	00e78da3          	sb	a4,27(a5)
    8000534c:	00e78e23          	sb	a4,28(a5)
    80005350:	00e78ea3          	sb	a4,29(a5)
    80005354:	00e78f23          	sb	a4,30(a5)
    80005358:	00e78fa3          	sb	a4,31(a5)
}
    8000535c:	60e2                	ld	ra,24(sp)
    8000535e:	6442                	ld	s0,16(sp)
    80005360:	64a2                	ld	s1,8(sp)
    80005362:	6105                	addi	sp,sp,32
    80005364:	8082                	ret
    panic("could not find virtio disk");
    80005366:	00003517          	auipc	a0,0x3
    8000536a:	2ca50513          	addi	a0,a0,714 # 80008630 <etext+0x630>
    8000536e:	00001097          	auipc	ra,0x1
    80005372:	910080e7          	jalr	-1776(ra) # 80005c7e <panic>
    panic("virtio disk has no queue 0");
    80005376:	00003517          	auipc	a0,0x3
    8000537a:	2da50513          	addi	a0,a0,730 # 80008650 <etext+0x650>
    8000537e:	00001097          	auipc	ra,0x1
    80005382:	900080e7          	jalr	-1792(ra) # 80005c7e <panic>
    panic("virtio disk max queue too short");
    80005386:	00003517          	auipc	a0,0x3
    8000538a:	2ea50513          	addi	a0,a0,746 # 80008670 <etext+0x670>
    8000538e:	00001097          	auipc	ra,0x1
    80005392:	8f0080e7          	jalr	-1808(ra) # 80005c7e <panic>

0000000080005396 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005396:	7119                	addi	sp,sp,-128
    80005398:	fc86                	sd	ra,120(sp)
    8000539a:	f8a2                	sd	s0,112(sp)
    8000539c:	f4a6                	sd	s1,104(sp)
    8000539e:	f0ca                	sd	s2,96(sp)
    800053a0:	ecce                	sd	s3,88(sp)
    800053a2:	e8d2                	sd	s4,80(sp)
    800053a4:	e4d6                	sd	s5,72(sp)
    800053a6:	e0da                	sd	s6,64(sp)
    800053a8:	fc5e                	sd	s7,56(sp)
    800053aa:	f862                	sd	s8,48(sp)
    800053ac:	f466                	sd	s9,40(sp)
    800053ae:	f06a                	sd	s10,32(sp)
    800053b0:	ec6e                	sd	s11,24(sp)
    800053b2:	0100                	addi	s0,sp,128
    800053b4:	8aaa                	mv	s5,a0
    800053b6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053b8:	00c52c83          	lw	s9,12(a0)
    800053bc:	001c9c9b          	slliw	s9,s9,0x1
    800053c0:	1c82                	slli	s9,s9,0x20
    800053c2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053c6:	0001c517          	auipc	a0,0x1c
    800053ca:	d6250513          	addi	a0,a0,-670 # 80021128 <disk+0x2128>
    800053ce:	00001097          	auipc	ra,0x1
    800053d2:	dc2080e7          	jalr	-574(ra) # 80006190 <acquire>
  for(int i = 0; i < 3; i++){
    800053d6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053d8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053da:	0001ac17          	auipc	s8,0x1a
    800053de:	c26c0c13          	addi	s8,s8,-986 # 8001f000 <disk>
    800053e2:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800053e4:	4b0d                	li	s6,3
    800053e6:	a0ad                	j	80005450 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800053e8:	00fc0733          	add	a4,s8,a5
    800053ec:	975e                	add	a4,a4,s7
    800053ee:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053f2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053f4:	0207c563          	bltz	a5,8000541e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053f8:	2905                	addiw	s2,s2,1
    800053fa:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800053fc:	19690d63          	beq	s2,s6,80005596 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80005400:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005402:	0001c717          	auipc	a4,0x1c
    80005406:	c1670713          	addi	a4,a4,-1002 # 80021018 <disk+0x2018>
    8000540a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000540c:	00074683          	lbu	a3,0(a4)
    80005410:	fee1                	bnez	a3,800053e8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005412:	2785                	addiw	a5,a5,1
    80005414:	0705                	addi	a4,a4,1
    80005416:	fe979be3          	bne	a5,s1,8000540c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000541a:	57fd                	li	a5,-1
    8000541c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000541e:	01205d63          	blez	s2,80005438 <virtio_disk_rw+0xa2>
    80005422:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005424:	000a2503          	lw	a0,0(s4)
    80005428:	00000097          	auipc	ra,0x0
    8000542c:	d8e080e7          	jalr	-626(ra) # 800051b6 <free_desc>
      for(int j = 0; j < i; j++)
    80005430:	2d85                	addiw	s11,s11,1
    80005432:	0a11                	addi	s4,s4,4
    80005434:	ffb918e3          	bne	s2,s11,80005424 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005438:	0001c597          	auipc	a1,0x1c
    8000543c:	cf058593          	addi	a1,a1,-784 # 80021128 <disk+0x2128>
    80005440:	0001c517          	auipc	a0,0x1c
    80005444:	bd850513          	addi	a0,a0,-1064 # 80021018 <disk+0x2018>
    80005448:	ffffc097          	auipc	ra,0xffffc
    8000544c:	0c8080e7          	jalr	200(ra) # 80001510 <sleep>
  for(int i = 0; i < 3; i++){
    80005450:	f8040a13          	addi	s4,s0,-128
{
    80005454:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005456:	894e                	mv	s2,s3
    80005458:	b765                	j	80005400 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000545a:	0001c697          	auipc	a3,0x1c
    8000545e:	ba66b683          	ld	a3,-1114(a3) # 80021000 <disk+0x2000>
    80005462:	96ba                	add	a3,a3,a4
    80005464:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005468:	0001a817          	auipc	a6,0x1a
    8000546c:	b9880813          	addi	a6,a6,-1128 # 8001f000 <disk>
    80005470:	0001c697          	auipc	a3,0x1c
    80005474:	b9068693          	addi	a3,a3,-1136 # 80021000 <disk+0x2000>
    80005478:	6290                	ld	a2,0(a3)
    8000547a:	963a                	add	a2,a2,a4
    8000547c:	00c65583          	lhu	a1,12(a2)
    80005480:	0015e593          	ori	a1,a1,1
    80005484:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005488:	f8842603          	lw	a2,-120(s0)
    8000548c:	628c                	ld	a1,0(a3)
    8000548e:	972e                	add	a4,a4,a1
    80005490:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005494:	20050593          	addi	a1,a0,512
    80005498:	0592                	slli	a1,a1,0x4
    8000549a:	95c2                	add	a1,a1,a6
    8000549c:	577d                	li	a4,-1
    8000549e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054a2:	00461713          	slli	a4,a2,0x4
    800054a6:	6290                	ld	a2,0(a3)
    800054a8:	963a                	add	a2,a2,a4
    800054aa:	03078793          	addi	a5,a5,48
    800054ae:	97c2                	add	a5,a5,a6
    800054b0:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800054b2:	629c                	ld	a5,0(a3)
    800054b4:	97ba                	add	a5,a5,a4
    800054b6:	4605                	li	a2,1
    800054b8:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054ba:	629c                	ld	a5,0(a3)
    800054bc:	97ba                	add	a5,a5,a4
    800054be:	4809                	li	a6,2
    800054c0:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800054c4:	629c                	ld	a5,0(a3)
    800054c6:	973e                	add	a4,a4,a5
    800054c8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054cc:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800054d0:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054d4:	6698                	ld	a4,8(a3)
    800054d6:	00275783          	lhu	a5,2(a4)
    800054da:	8b9d                	andi	a5,a5,7
    800054dc:	0786                	slli	a5,a5,0x1
    800054de:	97ba                	add	a5,a5,a4
    800054e0:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800054e4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054e8:	6698                	ld	a4,8(a3)
    800054ea:	00275783          	lhu	a5,2(a4)
    800054ee:	2785                	addiw	a5,a5,1
    800054f0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054f4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054f8:	100017b7          	lui	a5,0x10001
    800054fc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005500:	004aa783          	lw	a5,4(s5)
    80005504:	02c79163          	bne	a5,a2,80005526 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005508:	0001c917          	auipc	s2,0x1c
    8000550c:	c2090913          	addi	s2,s2,-992 # 80021128 <disk+0x2128>
  while(b->disk == 1) {
    80005510:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005512:	85ca                	mv	a1,s2
    80005514:	8556                	mv	a0,s5
    80005516:	ffffc097          	auipc	ra,0xffffc
    8000551a:	ffa080e7          	jalr	-6(ra) # 80001510 <sleep>
  while(b->disk == 1) {
    8000551e:	004aa783          	lw	a5,4(s5)
    80005522:	fe9788e3          	beq	a5,s1,80005512 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005526:	f8042903          	lw	s2,-128(s0)
    8000552a:	20090793          	addi	a5,s2,512
    8000552e:	00479713          	slli	a4,a5,0x4
    80005532:	0001a797          	auipc	a5,0x1a
    80005536:	ace78793          	addi	a5,a5,-1330 # 8001f000 <disk>
    8000553a:	97ba                	add	a5,a5,a4
    8000553c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005540:	0001c997          	auipc	s3,0x1c
    80005544:	ac098993          	addi	s3,s3,-1344 # 80021000 <disk+0x2000>
    80005548:	00491713          	slli	a4,s2,0x4
    8000554c:	0009b783          	ld	a5,0(s3)
    80005550:	97ba                	add	a5,a5,a4
    80005552:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005556:	854a                	mv	a0,s2
    80005558:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000555c:	00000097          	auipc	ra,0x0
    80005560:	c5a080e7          	jalr	-934(ra) # 800051b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005564:	8885                	andi	s1,s1,1
    80005566:	f0ed                	bnez	s1,80005548 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005568:	0001c517          	auipc	a0,0x1c
    8000556c:	bc050513          	addi	a0,a0,-1088 # 80021128 <disk+0x2128>
    80005570:	00001097          	auipc	ra,0x1
    80005574:	cd4080e7          	jalr	-812(ra) # 80006244 <release>
}
    80005578:	70e6                	ld	ra,120(sp)
    8000557a:	7446                	ld	s0,112(sp)
    8000557c:	74a6                	ld	s1,104(sp)
    8000557e:	7906                	ld	s2,96(sp)
    80005580:	69e6                	ld	s3,88(sp)
    80005582:	6a46                	ld	s4,80(sp)
    80005584:	6aa6                	ld	s5,72(sp)
    80005586:	6b06                	ld	s6,64(sp)
    80005588:	7be2                	ld	s7,56(sp)
    8000558a:	7c42                	ld	s8,48(sp)
    8000558c:	7ca2                	ld	s9,40(sp)
    8000558e:	7d02                	ld	s10,32(sp)
    80005590:	6de2                	ld	s11,24(sp)
    80005592:	6109                	addi	sp,sp,128
    80005594:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005596:	f8042503          	lw	a0,-128(s0)
    8000559a:	20050793          	addi	a5,a0,512
    8000559e:	0792                	slli	a5,a5,0x4
  if(write)
    800055a0:	0001a817          	auipc	a6,0x1a
    800055a4:	a6080813          	addi	a6,a6,-1440 # 8001f000 <disk>
    800055a8:	00f80733          	add	a4,a6,a5
    800055ac:	01a036b3          	snez	a3,s10
    800055b0:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800055b4:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055b8:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055bc:	7679                	lui	a2,0xffffe
    800055be:	963e                	add	a2,a2,a5
    800055c0:	0001c697          	auipc	a3,0x1c
    800055c4:	a4068693          	addi	a3,a3,-1472 # 80021000 <disk+0x2000>
    800055c8:	6298                	ld	a4,0(a3)
    800055ca:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055cc:	0a878593          	addi	a1,a5,168
    800055d0:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055d2:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055d4:	6298                	ld	a4,0(a3)
    800055d6:	9732                	add	a4,a4,a2
    800055d8:	45c1                	li	a1,16
    800055da:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055dc:	6298                	ld	a4,0(a3)
    800055de:	9732                	add	a4,a4,a2
    800055e0:	4585                	li	a1,1
    800055e2:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055e6:	f8442703          	lw	a4,-124(s0)
    800055ea:	628c                	ld	a1,0(a3)
    800055ec:	962e                	add	a2,a2,a1
    800055ee:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd3dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800055f2:	0712                	slli	a4,a4,0x4
    800055f4:	6290                	ld	a2,0(a3)
    800055f6:	963a                	add	a2,a2,a4
    800055f8:	058a8593          	addi	a1,s5,88
    800055fc:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055fe:	6294                	ld	a3,0(a3)
    80005600:	96ba                	add	a3,a3,a4
    80005602:	40000613          	li	a2,1024
    80005606:	c690                	sw	a2,8(a3)
  if(write)
    80005608:	e40d19e3          	bnez	s10,8000545a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000560c:	0001c697          	auipc	a3,0x1c
    80005610:	9f46b683          	ld	a3,-1548(a3) # 80021000 <disk+0x2000>
    80005614:	96ba                	add	a3,a3,a4
    80005616:	4609                	li	a2,2
    80005618:	00c69623          	sh	a2,12(a3)
    8000561c:	b5b1                	j	80005468 <virtio_disk_rw+0xd2>

000000008000561e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000561e:	1101                	addi	sp,sp,-32
    80005620:	ec06                	sd	ra,24(sp)
    80005622:	e822                	sd	s0,16(sp)
    80005624:	e426                	sd	s1,8(sp)
    80005626:	e04a                	sd	s2,0(sp)
    80005628:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000562a:	0001c517          	auipc	a0,0x1c
    8000562e:	afe50513          	addi	a0,a0,-1282 # 80021128 <disk+0x2128>
    80005632:	00001097          	auipc	ra,0x1
    80005636:	b5e080e7          	jalr	-1186(ra) # 80006190 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000563a:	10001737          	lui	a4,0x10001
    8000563e:	533c                	lw	a5,96(a4)
    80005640:	8b8d                	andi	a5,a5,3
    80005642:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005644:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005648:	0001c797          	auipc	a5,0x1c
    8000564c:	9b878793          	addi	a5,a5,-1608 # 80021000 <disk+0x2000>
    80005650:	6b94                	ld	a3,16(a5)
    80005652:	0207d703          	lhu	a4,32(a5)
    80005656:	0026d783          	lhu	a5,2(a3)
    8000565a:	06f70163          	beq	a4,a5,800056bc <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000565e:	0001a917          	auipc	s2,0x1a
    80005662:	9a290913          	addi	s2,s2,-1630 # 8001f000 <disk>
    80005666:	0001c497          	auipc	s1,0x1c
    8000566a:	99a48493          	addi	s1,s1,-1638 # 80021000 <disk+0x2000>
    __sync_synchronize();
    8000566e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005672:	6898                	ld	a4,16(s1)
    80005674:	0204d783          	lhu	a5,32(s1)
    80005678:	8b9d                	andi	a5,a5,7
    8000567a:	078e                	slli	a5,a5,0x3
    8000567c:	97ba                	add	a5,a5,a4
    8000567e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005680:	20078713          	addi	a4,a5,512
    80005684:	0712                	slli	a4,a4,0x4
    80005686:	974a                	add	a4,a4,s2
    80005688:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000568c:	e731                	bnez	a4,800056d8 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000568e:	20078793          	addi	a5,a5,512
    80005692:	0792                	slli	a5,a5,0x4
    80005694:	97ca                	add	a5,a5,s2
    80005696:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005698:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000569c:	ffffc097          	auipc	ra,0xffffc
    800056a0:	000080e7          	jalr	ra # 8000169c <wakeup>

    disk.used_idx += 1;
    800056a4:	0204d783          	lhu	a5,32(s1)
    800056a8:	2785                	addiw	a5,a5,1
    800056aa:	17c2                	slli	a5,a5,0x30
    800056ac:	93c1                	srli	a5,a5,0x30
    800056ae:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056b2:	6898                	ld	a4,16(s1)
    800056b4:	00275703          	lhu	a4,2(a4)
    800056b8:	faf71be3          	bne	a4,a5,8000566e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056bc:	0001c517          	auipc	a0,0x1c
    800056c0:	a6c50513          	addi	a0,a0,-1428 # 80021128 <disk+0x2128>
    800056c4:	00001097          	auipc	ra,0x1
    800056c8:	b80080e7          	jalr	-1152(ra) # 80006244 <release>
}
    800056cc:	60e2                	ld	ra,24(sp)
    800056ce:	6442                	ld	s0,16(sp)
    800056d0:	64a2                	ld	s1,8(sp)
    800056d2:	6902                	ld	s2,0(sp)
    800056d4:	6105                	addi	sp,sp,32
    800056d6:	8082                	ret
      panic("virtio_disk_intr status");
    800056d8:	00003517          	auipc	a0,0x3
    800056dc:	fb850513          	addi	a0,a0,-72 # 80008690 <etext+0x690>
    800056e0:	00000097          	auipc	ra,0x0
    800056e4:	59e080e7          	jalr	1438(ra) # 80005c7e <panic>

00000000800056e8 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056e8:	1141                	addi	sp,sp,-16
    800056ea:	e422                	sd	s0,8(sp)
    800056ec:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056ee:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056f2:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056f6:	0037979b          	slliw	a5,a5,0x3
    800056fa:	02004737          	lui	a4,0x2004
    800056fe:	97ba                	add	a5,a5,a4
    80005700:	0200c737          	lui	a4,0x200c
    80005704:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005708:	000f4637          	lui	a2,0xf4
    8000570c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005710:	95b2                	add	a1,a1,a2
    80005712:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005714:	00269713          	slli	a4,a3,0x2
    80005718:	9736                	add	a4,a4,a3
    8000571a:	00371693          	slli	a3,a4,0x3
    8000571e:	0001d717          	auipc	a4,0x1d
    80005722:	8e270713          	addi	a4,a4,-1822 # 80022000 <timer_scratch>
    80005726:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005728:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000572a:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000572c:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005730:	00000797          	auipc	a5,0x0
    80005734:	9c078793          	addi	a5,a5,-1600 # 800050f0 <timervec>
    80005738:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000573c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005740:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005744:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005748:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000574c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005750:	30479073          	csrw	mie,a5
}
    80005754:	6422                	ld	s0,8(sp)
    80005756:	0141                	addi	sp,sp,16
    80005758:	8082                	ret

000000008000575a <start>:
{
    8000575a:	1141                	addi	sp,sp,-16
    8000575c:	e406                	sd	ra,8(sp)
    8000575e:	e022                	sd	s0,0(sp)
    80005760:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005762:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005766:	7779                	lui	a4,0xffffe
    80005768:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd45bf>
    8000576c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000576e:	6705                	lui	a4,0x1
    80005770:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005774:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005776:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000577a:	ffffb797          	auipc	a5,0xffffb
    8000577e:	ba478793          	addi	a5,a5,-1116 # 8000031e <main>
    80005782:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005786:	4781                	li	a5,0
    80005788:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000578c:	67c1                	lui	a5,0x10
    8000578e:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005790:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005794:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005798:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000579c:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057a0:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057a4:	57fd                	li	a5,-1
    800057a6:	83a9                	srli	a5,a5,0xa
    800057a8:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057ac:	47bd                	li	a5,15
    800057ae:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057b2:	00000097          	auipc	ra,0x0
    800057b6:	f36080e7          	jalr	-202(ra) # 800056e8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057ba:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057be:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057c0:	823e                	mv	tp,a5
  asm volatile("mret");
    800057c2:	30200073          	mret
}
    800057c6:	60a2                	ld	ra,8(sp)
    800057c8:	6402                	ld	s0,0(sp)
    800057ca:	0141                	addi	sp,sp,16
    800057cc:	8082                	ret

00000000800057ce <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057ce:	715d                	addi	sp,sp,-80
    800057d0:	e486                	sd	ra,72(sp)
    800057d2:	e0a2                	sd	s0,64(sp)
    800057d4:	fc26                	sd	s1,56(sp)
    800057d6:	f84a                	sd	s2,48(sp)
    800057d8:	f44e                	sd	s3,40(sp)
    800057da:	f052                	sd	s4,32(sp)
    800057dc:	ec56                	sd	s5,24(sp)
    800057de:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057e0:	04c05663          	blez	a2,8000582c <consolewrite+0x5e>
    800057e4:	8a2a                	mv	s4,a0
    800057e6:	84ae                	mv	s1,a1
    800057e8:	89b2                	mv	s3,a2
    800057ea:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057ec:	5afd                	li	s5,-1
    800057ee:	4685                	li	a3,1
    800057f0:	8626                	mv	a2,s1
    800057f2:	85d2                	mv	a1,s4
    800057f4:	fbf40513          	addi	a0,s0,-65
    800057f8:	ffffc097          	auipc	ra,0xffffc
    800057fc:	112080e7          	jalr	274(ra) # 8000190a <either_copyin>
    80005800:	01550c63          	beq	a0,s5,80005818 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005804:	fbf44503          	lbu	a0,-65(s0)
    80005808:	00000097          	auipc	ra,0x0
    8000580c:	7ca080e7          	jalr	1994(ra) # 80005fd2 <uartputc>
  for(i = 0; i < n; i++){
    80005810:	2905                	addiw	s2,s2,1
    80005812:	0485                	addi	s1,s1,1
    80005814:	fd299de3          	bne	s3,s2,800057ee <consolewrite+0x20>
  }

  return i;
}
    80005818:	854a                	mv	a0,s2
    8000581a:	60a6                	ld	ra,72(sp)
    8000581c:	6406                	ld	s0,64(sp)
    8000581e:	74e2                	ld	s1,56(sp)
    80005820:	7942                	ld	s2,48(sp)
    80005822:	79a2                	ld	s3,40(sp)
    80005824:	7a02                	ld	s4,32(sp)
    80005826:	6ae2                	ld	s5,24(sp)
    80005828:	6161                	addi	sp,sp,80
    8000582a:	8082                	ret
  for(i = 0; i < n; i++){
    8000582c:	4901                	li	s2,0
    8000582e:	b7ed                	j	80005818 <consolewrite+0x4a>

0000000080005830 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005830:	7159                	addi	sp,sp,-112
    80005832:	f486                	sd	ra,104(sp)
    80005834:	f0a2                	sd	s0,96(sp)
    80005836:	eca6                	sd	s1,88(sp)
    80005838:	e8ca                	sd	s2,80(sp)
    8000583a:	e4ce                	sd	s3,72(sp)
    8000583c:	e0d2                	sd	s4,64(sp)
    8000583e:	fc56                	sd	s5,56(sp)
    80005840:	f85a                	sd	s6,48(sp)
    80005842:	f45e                	sd	s7,40(sp)
    80005844:	f062                	sd	s8,32(sp)
    80005846:	ec66                	sd	s9,24(sp)
    80005848:	e86a                	sd	s10,16(sp)
    8000584a:	1880                	addi	s0,sp,112
    8000584c:	8aaa                	mv	s5,a0
    8000584e:	8a2e                	mv	s4,a1
    80005850:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005852:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005856:	00025517          	auipc	a0,0x25
    8000585a:	8ea50513          	addi	a0,a0,-1814 # 8002a140 <cons>
    8000585e:	00001097          	auipc	ra,0x1
    80005862:	932080e7          	jalr	-1742(ra) # 80006190 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005866:	00025497          	auipc	s1,0x25
    8000586a:	8da48493          	addi	s1,s1,-1830 # 8002a140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000586e:	00025917          	auipc	s2,0x25
    80005872:	96a90913          	addi	s2,s2,-1686 # 8002a1d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005876:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005878:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000587a:	4ca9                	li	s9,10
  while(n > 0){
    8000587c:	07305863          	blez	s3,800058ec <consoleread+0xbc>
    while(cons.r == cons.w){
    80005880:	0984a783          	lw	a5,152(s1)
    80005884:	09c4a703          	lw	a4,156(s1)
    80005888:	02f71463          	bne	a4,a5,800058b0 <consoleread+0x80>
      if(myproc()->killed){
    8000588c:	ffffb097          	auipc	ra,0xffffb
    80005890:	5b6080e7          	jalr	1462(ra) # 80000e42 <myproc>
    80005894:	551c                	lw	a5,40(a0)
    80005896:	e7b5                	bnez	a5,80005902 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005898:	85a6                	mv	a1,s1
    8000589a:	854a                	mv	a0,s2
    8000589c:	ffffc097          	auipc	ra,0xffffc
    800058a0:	c74080e7          	jalr	-908(ra) # 80001510 <sleep>
    while(cons.r == cons.w){
    800058a4:	0984a783          	lw	a5,152(s1)
    800058a8:	09c4a703          	lw	a4,156(s1)
    800058ac:	fef700e3          	beq	a4,a5,8000588c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058b0:	0017871b          	addiw	a4,a5,1
    800058b4:	08e4ac23          	sw	a4,152(s1)
    800058b8:	07f7f713          	andi	a4,a5,127
    800058bc:	9726                	add	a4,a4,s1
    800058be:	01874703          	lbu	a4,24(a4)
    800058c2:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800058c6:	077d0563          	beq	s10,s7,80005930 <consoleread+0x100>
    cbuf = c;
    800058ca:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058ce:	4685                	li	a3,1
    800058d0:	f9f40613          	addi	a2,s0,-97
    800058d4:	85d2                	mv	a1,s4
    800058d6:	8556                	mv	a0,s5
    800058d8:	ffffc097          	auipc	ra,0xffffc
    800058dc:	fdc080e7          	jalr	-36(ra) # 800018b4 <either_copyout>
    800058e0:	01850663          	beq	a0,s8,800058ec <consoleread+0xbc>
    dst++;
    800058e4:	0a05                	addi	s4,s4,1
    --n;
    800058e6:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800058e8:	f99d1ae3          	bne	s10,s9,8000587c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058ec:	00025517          	auipc	a0,0x25
    800058f0:	85450513          	addi	a0,a0,-1964 # 8002a140 <cons>
    800058f4:	00001097          	auipc	ra,0x1
    800058f8:	950080e7          	jalr	-1712(ra) # 80006244 <release>

  return target - n;
    800058fc:	413b053b          	subw	a0,s6,s3
    80005900:	a811                	j	80005914 <consoleread+0xe4>
        release(&cons.lock);
    80005902:	00025517          	auipc	a0,0x25
    80005906:	83e50513          	addi	a0,a0,-1986 # 8002a140 <cons>
    8000590a:	00001097          	auipc	ra,0x1
    8000590e:	93a080e7          	jalr	-1734(ra) # 80006244 <release>
        return -1;
    80005912:	557d                	li	a0,-1
}
    80005914:	70a6                	ld	ra,104(sp)
    80005916:	7406                	ld	s0,96(sp)
    80005918:	64e6                	ld	s1,88(sp)
    8000591a:	6946                	ld	s2,80(sp)
    8000591c:	69a6                	ld	s3,72(sp)
    8000591e:	6a06                	ld	s4,64(sp)
    80005920:	7ae2                	ld	s5,56(sp)
    80005922:	7b42                	ld	s6,48(sp)
    80005924:	7ba2                	ld	s7,40(sp)
    80005926:	7c02                	ld	s8,32(sp)
    80005928:	6ce2                	ld	s9,24(sp)
    8000592a:	6d42                	ld	s10,16(sp)
    8000592c:	6165                	addi	sp,sp,112
    8000592e:	8082                	ret
      if(n < target){
    80005930:	0009871b          	sext.w	a4,s3
    80005934:	fb677ce3          	bgeu	a4,s6,800058ec <consoleread+0xbc>
        cons.r--;
    80005938:	00025717          	auipc	a4,0x25
    8000593c:	8af72023          	sw	a5,-1888(a4) # 8002a1d8 <cons+0x98>
    80005940:	b775                	j	800058ec <consoleread+0xbc>

0000000080005942 <consputc>:
{
    80005942:	1141                	addi	sp,sp,-16
    80005944:	e406                	sd	ra,8(sp)
    80005946:	e022                	sd	s0,0(sp)
    80005948:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000594a:	10000793          	li	a5,256
    8000594e:	00f50a63          	beq	a0,a5,80005962 <consputc+0x20>
    uartputc_sync(c);
    80005952:	00000097          	auipc	ra,0x0
    80005956:	5ae080e7          	jalr	1454(ra) # 80005f00 <uartputc_sync>
}
    8000595a:	60a2                	ld	ra,8(sp)
    8000595c:	6402                	ld	s0,0(sp)
    8000595e:	0141                	addi	sp,sp,16
    80005960:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005962:	4521                	li	a0,8
    80005964:	00000097          	auipc	ra,0x0
    80005968:	59c080e7          	jalr	1436(ra) # 80005f00 <uartputc_sync>
    8000596c:	02000513          	li	a0,32
    80005970:	00000097          	auipc	ra,0x0
    80005974:	590080e7          	jalr	1424(ra) # 80005f00 <uartputc_sync>
    80005978:	4521                	li	a0,8
    8000597a:	00000097          	auipc	ra,0x0
    8000597e:	586080e7          	jalr	1414(ra) # 80005f00 <uartputc_sync>
    80005982:	bfe1                	j	8000595a <consputc+0x18>

0000000080005984 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005984:	1101                	addi	sp,sp,-32
    80005986:	ec06                	sd	ra,24(sp)
    80005988:	e822                	sd	s0,16(sp)
    8000598a:	e426                	sd	s1,8(sp)
    8000598c:	e04a                	sd	s2,0(sp)
    8000598e:	1000                	addi	s0,sp,32
    80005990:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005992:	00024517          	auipc	a0,0x24
    80005996:	7ae50513          	addi	a0,a0,1966 # 8002a140 <cons>
    8000599a:	00000097          	auipc	ra,0x0
    8000599e:	7f6080e7          	jalr	2038(ra) # 80006190 <acquire>

  switch(c){
    800059a2:	47d5                	li	a5,21
    800059a4:	0af48663          	beq	s1,a5,80005a50 <consoleintr+0xcc>
    800059a8:	0297ca63          	blt	a5,s1,800059dc <consoleintr+0x58>
    800059ac:	47a1                	li	a5,8
    800059ae:	0ef48763          	beq	s1,a5,80005a9c <consoleintr+0x118>
    800059b2:	47c1                	li	a5,16
    800059b4:	10f49a63          	bne	s1,a5,80005ac8 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059b8:	ffffc097          	auipc	ra,0xffffc
    800059bc:	fa8080e7          	jalr	-88(ra) # 80001960 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059c0:	00024517          	auipc	a0,0x24
    800059c4:	78050513          	addi	a0,a0,1920 # 8002a140 <cons>
    800059c8:	00001097          	auipc	ra,0x1
    800059cc:	87c080e7          	jalr	-1924(ra) # 80006244 <release>
}
    800059d0:	60e2                	ld	ra,24(sp)
    800059d2:	6442                	ld	s0,16(sp)
    800059d4:	64a2                	ld	s1,8(sp)
    800059d6:	6902                	ld	s2,0(sp)
    800059d8:	6105                	addi	sp,sp,32
    800059da:	8082                	ret
  switch(c){
    800059dc:	07f00793          	li	a5,127
    800059e0:	0af48e63          	beq	s1,a5,80005a9c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059e4:	00024717          	auipc	a4,0x24
    800059e8:	75c70713          	addi	a4,a4,1884 # 8002a140 <cons>
    800059ec:	0a072783          	lw	a5,160(a4)
    800059f0:	09872703          	lw	a4,152(a4)
    800059f4:	9f99                	subw	a5,a5,a4
    800059f6:	07f00713          	li	a4,127
    800059fa:	fcf763e3          	bltu	a4,a5,800059c0 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800059fe:	47b5                	li	a5,13
    80005a00:	0cf48763          	beq	s1,a5,80005ace <consoleintr+0x14a>
      consputc(c);
    80005a04:	8526                	mv	a0,s1
    80005a06:	00000097          	auipc	ra,0x0
    80005a0a:	f3c080e7          	jalr	-196(ra) # 80005942 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a0e:	00024797          	auipc	a5,0x24
    80005a12:	73278793          	addi	a5,a5,1842 # 8002a140 <cons>
    80005a16:	0a07a703          	lw	a4,160(a5)
    80005a1a:	0017069b          	addiw	a3,a4,1
    80005a1e:	0006861b          	sext.w	a2,a3
    80005a22:	0ad7a023          	sw	a3,160(a5)
    80005a26:	07f77713          	andi	a4,a4,127
    80005a2a:	97ba                	add	a5,a5,a4
    80005a2c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a30:	47a9                	li	a5,10
    80005a32:	0cf48563          	beq	s1,a5,80005afc <consoleintr+0x178>
    80005a36:	4791                	li	a5,4
    80005a38:	0cf48263          	beq	s1,a5,80005afc <consoleintr+0x178>
    80005a3c:	00024797          	auipc	a5,0x24
    80005a40:	79c7a783          	lw	a5,1948(a5) # 8002a1d8 <cons+0x98>
    80005a44:	0807879b          	addiw	a5,a5,128
    80005a48:	f6f61ce3          	bne	a2,a5,800059c0 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a4c:	863e                	mv	a2,a5
    80005a4e:	a07d                	j	80005afc <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a50:	00024717          	auipc	a4,0x24
    80005a54:	6f070713          	addi	a4,a4,1776 # 8002a140 <cons>
    80005a58:	0a072783          	lw	a5,160(a4)
    80005a5c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a60:	00024497          	auipc	s1,0x24
    80005a64:	6e048493          	addi	s1,s1,1760 # 8002a140 <cons>
    while(cons.e != cons.w &&
    80005a68:	4929                	li	s2,10
    80005a6a:	f4f70be3          	beq	a4,a5,800059c0 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a6e:	37fd                	addiw	a5,a5,-1
    80005a70:	07f7f713          	andi	a4,a5,127
    80005a74:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a76:	01874703          	lbu	a4,24(a4)
    80005a7a:	f52703e3          	beq	a4,s2,800059c0 <consoleintr+0x3c>
      cons.e--;
    80005a7e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a82:	10000513          	li	a0,256
    80005a86:	00000097          	auipc	ra,0x0
    80005a8a:	ebc080e7          	jalr	-324(ra) # 80005942 <consputc>
    while(cons.e != cons.w &&
    80005a8e:	0a04a783          	lw	a5,160(s1)
    80005a92:	09c4a703          	lw	a4,156(s1)
    80005a96:	fcf71ce3          	bne	a4,a5,80005a6e <consoleintr+0xea>
    80005a9a:	b71d                	j	800059c0 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a9c:	00024717          	auipc	a4,0x24
    80005aa0:	6a470713          	addi	a4,a4,1700 # 8002a140 <cons>
    80005aa4:	0a072783          	lw	a5,160(a4)
    80005aa8:	09c72703          	lw	a4,156(a4)
    80005aac:	f0f70ae3          	beq	a4,a5,800059c0 <consoleintr+0x3c>
      cons.e--;
    80005ab0:	37fd                	addiw	a5,a5,-1
    80005ab2:	00024717          	auipc	a4,0x24
    80005ab6:	72f72723          	sw	a5,1838(a4) # 8002a1e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005aba:	10000513          	li	a0,256
    80005abe:	00000097          	auipc	ra,0x0
    80005ac2:	e84080e7          	jalr	-380(ra) # 80005942 <consputc>
    80005ac6:	bded                	j	800059c0 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ac8:	ee048ce3          	beqz	s1,800059c0 <consoleintr+0x3c>
    80005acc:	bf21                	j	800059e4 <consoleintr+0x60>
      consputc(c);
    80005ace:	4529                	li	a0,10
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	e72080e7          	jalr	-398(ra) # 80005942 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ad8:	00024797          	auipc	a5,0x24
    80005adc:	66878793          	addi	a5,a5,1640 # 8002a140 <cons>
    80005ae0:	0a07a703          	lw	a4,160(a5)
    80005ae4:	0017069b          	addiw	a3,a4,1
    80005ae8:	0006861b          	sext.w	a2,a3
    80005aec:	0ad7a023          	sw	a3,160(a5)
    80005af0:	07f77713          	andi	a4,a4,127
    80005af4:	97ba                	add	a5,a5,a4
    80005af6:	4729                	li	a4,10
    80005af8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005afc:	00024797          	auipc	a5,0x24
    80005b00:	6ec7a023          	sw	a2,1760(a5) # 8002a1dc <cons+0x9c>
        wakeup(&cons.r);
    80005b04:	00024517          	auipc	a0,0x24
    80005b08:	6d450513          	addi	a0,a0,1748 # 8002a1d8 <cons+0x98>
    80005b0c:	ffffc097          	auipc	ra,0xffffc
    80005b10:	b90080e7          	jalr	-1136(ra) # 8000169c <wakeup>
    80005b14:	b575                	j	800059c0 <consoleintr+0x3c>

0000000080005b16 <consoleinit>:

void
consoleinit(void)
{
    80005b16:	1141                	addi	sp,sp,-16
    80005b18:	e406                	sd	ra,8(sp)
    80005b1a:	e022                	sd	s0,0(sp)
    80005b1c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b1e:	00003597          	auipc	a1,0x3
    80005b22:	b8a58593          	addi	a1,a1,-1142 # 800086a8 <etext+0x6a8>
    80005b26:	00024517          	auipc	a0,0x24
    80005b2a:	61a50513          	addi	a0,a0,1562 # 8002a140 <cons>
    80005b2e:	00000097          	auipc	ra,0x0
    80005b32:	5d2080e7          	jalr	1490(ra) # 80006100 <initlock>

  uartinit();
    80005b36:	00000097          	auipc	ra,0x0
    80005b3a:	37a080e7          	jalr	890(ra) # 80005eb0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b3e:	00018797          	auipc	a5,0x18
    80005b42:	38a78793          	addi	a5,a5,906 # 8001dec8 <devsw>
    80005b46:	00000717          	auipc	a4,0x0
    80005b4a:	cea70713          	addi	a4,a4,-790 # 80005830 <consoleread>
    80005b4e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b50:	00000717          	auipc	a4,0x0
    80005b54:	c7e70713          	addi	a4,a4,-898 # 800057ce <consolewrite>
    80005b58:	ef98                	sd	a4,24(a5)
}
    80005b5a:	60a2                	ld	ra,8(sp)
    80005b5c:	6402                	ld	s0,0(sp)
    80005b5e:	0141                	addi	sp,sp,16
    80005b60:	8082                	ret

0000000080005b62 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b62:	7179                	addi	sp,sp,-48
    80005b64:	f406                	sd	ra,40(sp)
    80005b66:	f022                	sd	s0,32(sp)
    80005b68:	ec26                	sd	s1,24(sp)
    80005b6a:	e84a                	sd	s2,16(sp)
    80005b6c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b6e:	c219                	beqz	a2,80005b74 <printint+0x12>
    80005b70:	08054663          	bltz	a0,80005bfc <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005b74:	2501                	sext.w	a0,a0
    80005b76:	4881                	li	a7,0
    80005b78:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b7c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b7e:	2581                	sext.w	a1,a1
    80005b80:	00003617          	auipc	a2,0x3
    80005b84:	ca060613          	addi	a2,a2,-864 # 80008820 <digits>
    80005b88:	883a                	mv	a6,a4
    80005b8a:	2705                	addiw	a4,a4,1
    80005b8c:	02b577bb          	remuw	a5,a0,a1
    80005b90:	1782                	slli	a5,a5,0x20
    80005b92:	9381                	srli	a5,a5,0x20
    80005b94:	97b2                	add	a5,a5,a2
    80005b96:	0007c783          	lbu	a5,0(a5)
    80005b9a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b9e:	0005079b          	sext.w	a5,a0
    80005ba2:	02b5553b          	divuw	a0,a0,a1
    80005ba6:	0685                	addi	a3,a3,1
    80005ba8:	feb7f0e3          	bgeu	a5,a1,80005b88 <printint+0x26>

  if(sign)
    80005bac:	00088b63          	beqz	a7,80005bc2 <printint+0x60>
    buf[i++] = '-';
    80005bb0:	fe040793          	addi	a5,s0,-32
    80005bb4:	973e                	add	a4,a4,a5
    80005bb6:	02d00793          	li	a5,45
    80005bba:	fef70823          	sb	a5,-16(a4)
    80005bbe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bc2:	02e05763          	blez	a4,80005bf0 <printint+0x8e>
    80005bc6:	fd040793          	addi	a5,s0,-48
    80005bca:	00e784b3          	add	s1,a5,a4
    80005bce:	fff78913          	addi	s2,a5,-1
    80005bd2:	993a                	add	s2,s2,a4
    80005bd4:	377d                	addiw	a4,a4,-1
    80005bd6:	1702                	slli	a4,a4,0x20
    80005bd8:	9301                	srli	a4,a4,0x20
    80005bda:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bde:	fff4c503          	lbu	a0,-1(s1)
    80005be2:	00000097          	auipc	ra,0x0
    80005be6:	d60080e7          	jalr	-672(ra) # 80005942 <consputc>
  while(--i >= 0)
    80005bea:	14fd                	addi	s1,s1,-1
    80005bec:	ff2499e3          	bne	s1,s2,80005bde <printint+0x7c>
}
    80005bf0:	70a2                	ld	ra,40(sp)
    80005bf2:	7402                	ld	s0,32(sp)
    80005bf4:	64e2                	ld	s1,24(sp)
    80005bf6:	6942                	ld	s2,16(sp)
    80005bf8:	6145                	addi	sp,sp,48
    80005bfa:	8082                	ret
    x = -xx;
    80005bfc:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c00:	4885                	li	a7,1
    x = -xx;
    80005c02:	bf9d                	j	80005b78 <printint+0x16>

0000000080005c04 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005c04:	1101                	addi	sp,sp,-32
    80005c06:	ec06                	sd	ra,24(sp)
    80005c08:	e822                	sd	s0,16(sp)
    80005c0a:	e426                	sd	s1,8(sp)
    80005c0c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005c0e:	00024497          	auipc	s1,0x24
    80005c12:	5da48493          	addi	s1,s1,1498 # 8002a1e8 <pr>
    80005c16:	00003597          	auipc	a1,0x3
    80005c1a:	a9a58593          	addi	a1,a1,-1382 # 800086b0 <etext+0x6b0>
    80005c1e:	8526                	mv	a0,s1
    80005c20:	00000097          	auipc	ra,0x0
    80005c24:	4e0080e7          	jalr	1248(ra) # 80006100 <initlock>
  pr.locking = 1;
    80005c28:	4785                	li	a5,1
    80005c2a:	cc9c                	sw	a5,24(s1)
}
    80005c2c:	60e2                	ld	ra,24(sp)
    80005c2e:	6442                	ld	s0,16(sp)
    80005c30:	64a2                	ld	s1,8(sp)
    80005c32:	6105                	addi	sp,sp,32
    80005c34:	8082                	ret

0000000080005c36 <backtrace>:

void
backtrace(void)
{
    80005c36:	7179                	addi	sp,sp,-48
    80005c38:	f406                	sd	ra,40(sp)
    80005c3a:	f022                	sd	s0,32(sp)
    80005c3c:	ec26                	sd	s1,24(sp)
    80005c3e:	e84a                	sd	s2,16(sp)
    80005c40:	e44e                	sd	s3,8(sp)
    80005c42:	1800                	addi	s0,sp,48

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80005c44:	84a2                	mv	s1,s0
  uint64 fp_address = r_fp();
  while(fp_address != PGROUNDDOWN(fp_address)) {
    80005c46:	03449793          	slli	a5,s1,0x34
    80005c4a:	c39d                	beqz	a5,80005c70 <backtrace+0x3a>
    printf("%p\n", *(uint64*)(fp_address-8));
    80005c4c:	00003997          	auipc	s3,0x3
    80005c50:	a6c98993          	addi	s3,s3,-1428 # 800086b8 <etext+0x6b8>
  while(fp_address != PGROUNDDOWN(fp_address)) {
    80005c54:	797d                	lui	s2,0xfffff
    printf("%p\n", *(uint64*)(fp_address-8));
    80005c56:	ff84b583          	ld	a1,-8(s1)
    80005c5a:	854e                	mv	a0,s3
    80005c5c:	00000097          	auipc	ra,0x0
    80005c60:	074080e7          	jalr	116(ra) # 80005cd0 <printf>
    fp_address = *(uint64*)(fp_address - 16);
    80005c64:	ff04b483          	ld	s1,-16(s1)
  while(fp_address != PGROUNDDOWN(fp_address)) {
    80005c68:	0124f7b3          	and	a5,s1,s2
    80005c6c:	fe9795e3          	bne	a5,s1,80005c56 <backtrace+0x20>
  }
}
    80005c70:	70a2                	ld	ra,40(sp)
    80005c72:	7402                	ld	s0,32(sp)
    80005c74:	64e2                	ld	s1,24(sp)
    80005c76:	6942                	ld	s2,16(sp)
    80005c78:	69a2                	ld	s3,8(sp)
    80005c7a:	6145                	addi	sp,sp,48
    80005c7c:	8082                	ret

0000000080005c7e <panic>:
{
    80005c7e:	1101                	addi	sp,sp,-32
    80005c80:	ec06                	sd	ra,24(sp)
    80005c82:	e822                	sd	s0,16(sp)
    80005c84:	e426                	sd	s1,8(sp)
    80005c86:	1000                	addi	s0,sp,32
    80005c88:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c8a:	00024797          	auipc	a5,0x24
    80005c8e:	5607ab23          	sw	zero,1398(a5) # 8002a200 <pr+0x18>
  printf("panic: ");
    80005c92:	00003517          	auipc	a0,0x3
    80005c96:	a2e50513          	addi	a0,a0,-1490 # 800086c0 <etext+0x6c0>
    80005c9a:	00000097          	auipc	ra,0x0
    80005c9e:	036080e7          	jalr	54(ra) # 80005cd0 <printf>
  printf(s);
    80005ca2:	8526                	mv	a0,s1
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	02c080e7          	jalr	44(ra) # 80005cd0 <printf>
  printf("\n");
    80005cac:	00002517          	auipc	a0,0x2
    80005cb0:	37c50513          	addi	a0,a0,892 # 80008028 <etext+0x28>
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	01c080e7          	jalr	28(ra) # 80005cd0 <printf>
  backtrace();
    80005cbc:	00000097          	auipc	ra,0x0
    80005cc0:	f7a080e7          	jalr	-134(ra) # 80005c36 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005cc4:	4785                	li	a5,1
    80005cc6:	00003717          	auipc	a4,0x3
    80005cca:	34f72b23          	sw	a5,854(a4) # 8000901c <panicked>
  for(;;)
    80005cce:	a001                	j	80005cce <panic+0x50>

0000000080005cd0 <printf>:
{
    80005cd0:	7131                	addi	sp,sp,-192
    80005cd2:	fc86                	sd	ra,120(sp)
    80005cd4:	f8a2                	sd	s0,112(sp)
    80005cd6:	f4a6                	sd	s1,104(sp)
    80005cd8:	f0ca                	sd	s2,96(sp)
    80005cda:	ecce                	sd	s3,88(sp)
    80005cdc:	e8d2                	sd	s4,80(sp)
    80005cde:	e4d6                	sd	s5,72(sp)
    80005ce0:	e0da                	sd	s6,64(sp)
    80005ce2:	fc5e                	sd	s7,56(sp)
    80005ce4:	f862                	sd	s8,48(sp)
    80005ce6:	f466                	sd	s9,40(sp)
    80005ce8:	f06a                	sd	s10,32(sp)
    80005cea:	ec6e                	sd	s11,24(sp)
    80005cec:	0100                	addi	s0,sp,128
    80005cee:	8a2a                	mv	s4,a0
    80005cf0:	e40c                	sd	a1,8(s0)
    80005cf2:	e810                	sd	a2,16(s0)
    80005cf4:	ec14                	sd	a3,24(s0)
    80005cf6:	f018                	sd	a4,32(s0)
    80005cf8:	f41c                	sd	a5,40(s0)
    80005cfa:	03043823          	sd	a6,48(s0)
    80005cfe:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d02:	00024d97          	auipc	s11,0x24
    80005d06:	4fedad83          	lw	s11,1278(s11) # 8002a200 <pr+0x18>
  if(locking)
    80005d0a:	020d9b63          	bnez	s11,80005d40 <printf+0x70>
  if (fmt == 0)
    80005d0e:	040a0263          	beqz	s4,80005d52 <printf+0x82>
  va_start(ap, fmt);
    80005d12:	00840793          	addi	a5,s0,8
    80005d16:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d1a:	000a4503          	lbu	a0,0(s4)
    80005d1e:	14050f63          	beqz	a0,80005e7c <printf+0x1ac>
    80005d22:	4981                	li	s3,0
    if(c != '%'){
    80005d24:	02500a93          	li	s5,37
    switch(c){
    80005d28:	07000b93          	li	s7,112
  consputc('x');
    80005d2c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d2e:	00003b17          	auipc	s6,0x3
    80005d32:	af2b0b13          	addi	s6,s6,-1294 # 80008820 <digits>
    switch(c){
    80005d36:	07300c93          	li	s9,115
    80005d3a:	06400c13          	li	s8,100
    80005d3e:	a82d                	j	80005d78 <printf+0xa8>
    acquire(&pr.lock);
    80005d40:	00024517          	auipc	a0,0x24
    80005d44:	4a850513          	addi	a0,a0,1192 # 8002a1e8 <pr>
    80005d48:	00000097          	auipc	ra,0x0
    80005d4c:	448080e7          	jalr	1096(ra) # 80006190 <acquire>
    80005d50:	bf7d                	j	80005d0e <printf+0x3e>
    panic("null fmt");
    80005d52:	00003517          	auipc	a0,0x3
    80005d56:	97e50513          	addi	a0,a0,-1666 # 800086d0 <etext+0x6d0>
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	f24080e7          	jalr	-220(ra) # 80005c7e <panic>
      consputc(c);
    80005d62:	00000097          	auipc	ra,0x0
    80005d66:	be0080e7          	jalr	-1056(ra) # 80005942 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d6a:	2985                	addiw	s3,s3,1
    80005d6c:	013a07b3          	add	a5,s4,s3
    80005d70:	0007c503          	lbu	a0,0(a5)
    80005d74:	10050463          	beqz	a0,80005e7c <printf+0x1ac>
    if(c != '%'){
    80005d78:	ff5515e3          	bne	a0,s5,80005d62 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d7c:	2985                	addiw	s3,s3,1
    80005d7e:	013a07b3          	add	a5,s4,s3
    80005d82:	0007c783          	lbu	a5,0(a5)
    80005d86:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d8a:	cbed                	beqz	a5,80005e7c <printf+0x1ac>
    switch(c){
    80005d8c:	05778a63          	beq	a5,s7,80005de0 <printf+0x110>
    80005d90:	02fbf663          	bgeu	s7,a5,80005dbc <printf+0xec>
    80005d94:	09978863          	beq	a5,s9,80005e24 <printf+0x154>
    80005d98:	07800713          	li	a4,120
    80005d9c:	0ce79563          	bne	a5,a4,80005e66 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005da0:	f8843783          	ld	a5,-120(s0)
    80005da4:	00878713          	addi	a4,a5,8
    80005da8:	f8e43423          	sd	a4,-120(s0)
    80005dac:	4605                	li	a2,1
    80005dae:	85ea                	mv	a1,s10
    80005db0:	4388                	lw	a0,0(a5)
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	db0080e7          	jalr	-592(ra) # 80005b62 <printint>
      break;
    80005dba:	bf45                	j	80005d6a <printf+0x9a>
    switch(c){
    80005dbc:	09578f63          	beq	a5,s5,80005e5a <printf+0x18a>
    80005dc0:	0b879363          	bne	a5,s8,80005e66 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005dc4:	f8843783          	ld	a5,-120(s0)
    80005dc8:	00878713          	addi	a4,a5,8
    80005dcc:	f8e43423          	sd	a4,-120(s0)
    80005dd0:	4605                	li	a2,1
    80005dd2:	45a9                	li	a1,10
    80005dd4:	4388                	lw	a0,0(a5)
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	d8c080e7          	jalr	-628(ra) # 80005b62 <printint>
      break;
    80005dde:	b771                	j	80005d6a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005de0:	f8843783          	ld	a5,-120(s0)
    80005de4:	00878713          	addi	a4,a5,8
    80005de8:	f8e43423          	sd	a4,-120(s0)
    80005dec:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005df0:	03000513          	li	a0,48
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	b4e080e7          	jalr	-1202(ra) # 80005942 <consputc>
  consputc('x');
    80005dfc:	07800513          	li	a0,120
    80005e00:	00000097          	auipc	ra,0x0
    80005e04:	b42080e7          	jalr	-1214(ra) # 80005942 <consputc>
    80005e08:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e0a:	03c95793          	srli	a5,s2,0x3c
    80005e0e:	97da                	add	a5,a5,s6
    80005e10:	0007c503          	lbu	a0,0(a5)
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	b2e080e7          	jalr	-1234(ra) # 80005942 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e1c:	0912                	slli	s2,s2,0x4
    80005e1e:	34fd                	addiw	s1,s1,-1
    80005e20:	f4ed                	bnez	s1,80005e0a <printf+0x13a>
    80005e22:	b7a1                	j	80005d6a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e24:	f8843783          	ld	a5,-120(s0)
    80005e28:	00878713          	addi	a4,a5,8
    80005e2c:	f8e43423          	sd	a4,-120(s0)
    80005e30:	6384                	ld	s1,0(a5)
    80005e32:	cc89                	beqz	s1,80005e4c <printf+0x17c>
      for(; *s; s++)
    80005e34:	0004c503          	lbu	a0,0(s1)
    80005e38:	d90d                	beqz	a0,80005d6a <printf+0x9a>
        consputc(*s);
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	b08080e7          	jalr	-1272(ra) # 80005942 <consputc>
      for(; *s; s++)
    80005e42:	0485                	addi	s1,s1,1
    80005e44:	0004c503          	lbu	a0,0(s1)
    80005e48:	f96d                	bnez	a0,80005e3a <printf+0x16a>
    80005e4a:	b705                	j	80005d6a <printf+0x9a>
        s = "(null)";
    80005e4c:	00003497          	auipc	s1,0x3
    80005e50:	87c48493          	addi	s1,s1,-1924 # 800086c8 <etext+0x6c8>
      for(; *s; s++)
    80005e54:	02800513          	li	a0,40
    80005e58:	b7cd                	j	80005e3a <printf+0x16a>
      consputc('%');
    80005e5a:	8556                	mv	a0,s5
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	ae6080e7          	jalr	-1306(ra) # 80005942 <consputc>
      break;
    80005e64:	b719                	j	80005d6a <printf+0x9a>
      consputc('%');
    80005e66:	8556                	mv	a0,s5
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	ada080e7          	jalr	-1318(ra) # 80005942 <consputc>
      consputc(c);
    80005e70:	8526                	mv	a0,s1
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	ad0080e7          	jalr	-1328(ra) # 80005942 <consputc>
      break;
    80005e7a:	bdc5                	j	80005d6a <printf+0x9a>
  if(locking)
    80005e7c:	020d9163          	bnez	s11,80005e9e <printf+0x1ce>
}
    80005e80:	70e6                	ld	ra,120(sp)
    80005e82:	7446                	ld	s0,112(sp)
    80005e84:	74a6                	ld	s1,104(sp)
    80005e86:	7906                	ld	s2,96(sp)
    80005e88:	69e6                	ld	s3,88(sp)
    80005e8a:	6a46                	ld	s4,80(sp)
    80005e8c:	6aa6                	ld	s5,72(sp)
    80005e8e:	6b06                	ld	s6,64(sp)
    80005e90:	7be2                	ld	s7,56(sp)
    80005e92:	7c42                	ld	s8,48(sp)
    80005e94:	7ca2                	ld	s9,40(sp)
    80005e96:	7d02                	ld	s10,32(sp)
    80005e98:	6de2                	ld	s11,24(sp)
    80005e9a:	6129                	addi	sp,sp,192
    80005e9c:	8082                	ret
    release(&pr.lock);
    80005e9e:	00024517          	auipc	a0,0x24
    80005ea2:	34a50513          	addi	a0,a0,842 # 8002a1e8 <pr>
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	39e080e7          	jalr	926(ra) # 80006244 <release>
}
    80005eae:	bfc9                	j	80005e80 <printf+0x1b0>

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
    80005ee4:	80058593          	addi	a1,a1,-2048 # 800086e0 <etext+0x6e0>
    80005ee8:	00024517          	auipc	a0,0x24
    80005eec:	32050513          	addi	a0,a0,800 # 8002a208 <uart_tx_lock>
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
    80005f76:	00024a17          	auipc	s4,0x24
    80005f7a:	292a0a13          	addi	s4,s4,658 # 8002a208 <uart_tx_lock>
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
    80005fac:	6f4080e7          	jalr	1780(ra) # 8000169c <wakeup>
    
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
    80005fe4:	00024517          	auipc	a0,0x24
    80005fe8:	22450513          	addi	a0,a0,548 # 8002a208 <uart_tx_lock>
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
    80006018:	00024997          	auipc	s3,0x24
    8000601c:	1f098993          	addi	s3,s3,496 # 8002a208 <uart_tx_lock>
    80006020:	00003497          	auipc	s1,0x3
    80006024:	00048493          	mv	s1,s1
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006028:	00003917          	auipc	s2,0x3
    8000602c:	00090913          	mv	s2,s2
      sleep(&uart_tx_r, &uart_tx_lock);
    80006030:	85ce                	mv	a1,s3
    80006032:	8526                	mv	a0,s1
    80006034:	ffffb097          	auipc	ra,0xffffb
    80006038:	4dc080e7          	jalr	1244(ra) # 80001510 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000603c:	00093703          	ld	a4,0(s2) # 80009028 <uart_tx_w>
    80006040:	609c                	ld	a5,0(s1)
    80006042:	02078793          	addi	a5,a5,32
    80006046:	fee785e3          	beq	a5,a4,80006030 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000604a:	00024497          	auipc	s1,0x24
    8000604e:	1be48493          	addi	s1,s1,446 # 8002a208 <uart_tx_lock>
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
    800060c2:	8c6080e7          	jalr	-1850(ra) # 80005984 <consoleintr>
    int c = uartgetc();
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	fc2080e7          	jalr	-62(ra) # 80006088 <uartgetc>
    if(c == -1)
    800060ce:	fe9518e3          	bne	a0,s1,800060be <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060d2:	00024497          	auipc	s1,0x24
    800060d6:	13648493          	addi	s1,s1,310 # 8002a208 <uart_tx_lock>
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
    8000612e:	cfc080e7          	jalr	-772(ra) # 80000e26 <mycpu>
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
    80006160:	cca080e7          	jalr	-822(ra) # 80000e26 <mycpu>
    80006164:	5d3c                	lw	a5,120(a0)
    80006166:	cf89                	beqz	a5,80006180 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006168:	ffffb097          	auipc	ra,0xffffb
    8000616c:	cbe080e7          	jalr	-834(ra) # 80000e26 <mycpu>
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
    80006184:	ca6080e7          	jalr	-858(ra) # 80000e26 <mycpu>
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
    800061c4:	c66080e7          	jalr	-922(ra) # 80000e26 <mycpu>
    800061c8:	e888                	sd	a0,16(s1)
}
    800061ca:	60e2                	ld	ra,24(sp)
    800061cc:	6442                	ld	s0,16(sp)
    800061ce:	64a2                	ld	s1,8(sp)
    800061d0:	6105                	addi	sp,sp,32
    800061d2:	8082                	ret
    panic("acquire");
    800061d4:	00002517          	auipc	a0,0x2
    800061d8:	51450513          	addi	a0,a0,1300 # 800086e8 <etext+0x6e8>
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	aa2080e7          	jalr	-1374(ra) # 80005c7e <panic>

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
    800061f0:	c3a080e7          	jalr	-966(ra) # 80000e26 <mycpu>
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
    80006228:	4cc50513          	addi	a0,a0,1228 # 800086f0 <etext+0x6f0>
    8000622c:	00000097          	auipc	ra,0x0
    80006230:	a52080e7          	jalr	-1454(ra) # 80005c7e <panic>
    panic("pop_off");
    80006234:	00002517          	auipc	a0,0x2
    80006238:	4d450513          	addi	a0,a0,1236 # 80008708 <etext+0x708>
    8000623c:	00000097          	auipc	ra,0x0
    80006240:	a42080e7          	jalr	-1470(ra) # 80005c7e <panic>

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
    80006280:	49450513          	addi	a0,a0,1172 # 80008710 <etext+0x710>
    80006284:	00000097          	auipc	ra,0x0
    80006288:	9fa080e7          	jalr	-1542(ra) # 80005c7e <panic>
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
