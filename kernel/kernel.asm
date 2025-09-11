
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
    80000016:	0d5050ef          	jal	800058ea <start>

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
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	276080e7          	jalr	630(ra) # 800062d0 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	316080e7          	jalr	790(ra) # 80006384 <release>
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
    8000008e:	d0a080e7          	jalr	-758(ra) # 80005d94 <panic>

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
    800000f8:	14c080e7          	jalr	332(ra) # 80006240 <initlock>
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
    80000130:	1a4080e7          	jalr	420(ra) # 800062d0 <acquire>
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
    80000148:	240080e7          	jalr	576(ra) # 80006384 <release>

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
    80000172:	216080e7          	jalr	534(ra) # 80006384 <release>
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
    8000032a:	c00080e7          	jalr	-1024(ra) # 80000f26 <cpuid>
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
    80000346:	be4080e7          	jalr	-1052(ra) # 80000f26 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cfc50513          	addi	a0,a0,-772 # 80008048 <etext+0x48>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	a8a080e7          	jalr	-1398(ra) # 80005dde <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	8c4080e7          	jalr	-1852(ra) # 80001c28 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	f54080e7          	jalr	-172(ra) # 800052c0 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	172080e7          	jalr	370(ra) # 800014e6 <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	92a080e7          	jalr	-1750(ra) # 80005ca6 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	c3a080e7          	jalr	-966(ra) # 80005fbe <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	c9c50513          	addi	a0,a0,-868 # 80008028 <etext+0x28>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	a4a080e7          	jalr	-1462(ra) # 80005dde <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c9450513          	addi	a0,a0,-876 # 80008030 <etext+0x30>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	a3a080e7          	jalr	-1478(ra) # 80005dde <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c7c50513          	addi	a0,a0,-900 # 80008028 <etext+0x28>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	a2a080e7          	jalr	-1494(ra) # 80005dde <printf>
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
    800003d8:	aa4080e7          	jalr	-1372(ra) # 80000e78 <procinit>
    trapinit();      // trap vectors
    800003dc:	00002097          	auipc	ra,0x2
    800003e0:	824080e7          	jalr	-2012(ra) # 80001c00 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	844080e7          	jalr	-1980(ra) # 80001c28 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	ebe080e7          	jalr	-322(ra) # 800052aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	ecc080e7          	jalr	-308(ra) # 800052c0 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	07e080e7          	jalr	126(ra) # 8000247a <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	70e080e7          	jalr	1806(ra) # 80002b12 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	6b8080e7          	jalr	1720(ra) # 80003ac4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	fce080e7          	jalr	-50(ra) # 800053e2 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	e94080e7          	jalr	-364(ra) # 800012b0 <userinit>
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
    80000486:	00006097          	auipc	ra,0x6
    8000048a:	90e080e7          	jalr	-1778(ra) # 80005d94 <panic>
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
    800004b8:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
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
    800005b0:	7e8080e7          	jalr	2024(ra) # 80005d94 <panic>
      panic("mappages: remap");
    800005b4:	00008517          	auipc	a0,0x8
    800005b8:	ac450513          	addi	a0,a0,-1340 # 80008078 <etext+0x78>
    800005bc:	00005097          	auipc	ra,0x5
    800005c0:	7d8080e7          	jalr	2008(ra) # 80005d94 <panic>
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
    8000060c:	78c080e7          	jalr	1932(ra) # 80005d94 <panic>

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
    800006d4:	714080e7          	jalr	1812(ra) # 80000de4 <proc_mapstacks>
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
    80000758:	640080e7          	jalr	1600(ra) # 80005d94 <panic>
      panic("uvmunmap: walk");
    8000075c:	00008517          	auipc	a0,0x8
    80000760:	94c50513          	addi	a0,a0,-1716 # 800080a8 <etext+0xa8>
    80000764:	00005097          	auipc	ra,0x5
    80000768:	630080e7          	jalr	1584(ra) # 80005d94 <panic>
      panic("uvmunmap: not mapped");
    8000076c:	00008517          	auipc	a0,0x8
    80000770:	94c50513          	addi	a0,a0,-1716 # 800080b8 <etext+0xb8>
    80000774:	00005097          	auipc	ra,0x5
    80000778:	620080e7          	jalr	1568(ra) # 80005d94 <panic>
      panic("uvmunmap: not a leaf");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	95450513          	addi	a0,a0,-1708 # 800080d0 <etext+0xd0>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	610080e7          	jalr	1552(ra) # 80005d94 <panic>
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
    80000866:	532080e7          	jalr	1330(ra) # 80005d94 <panic>

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
    800009a8:	3f0080e7          	jalr	1008(ra) # 80005d94 <panic>
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
    80000a84:	314080e7          	jalr	788(ra) # 80005d94 <panic>
      panic("uvmcopy: page not present");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	6b050513          	addi	a0,a0,1712 # 80008138 <etext+0x138>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	304080e7          	jalr	772(ra) # 80005d94 <panic>
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
    80000afe:	29a080e7          	jalr	666(ra) # 80005d94 <panic>

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

0000000080000cd0 <vmprintwalk>:

// A function that prints the contents of a page table.

void
vmprintwalk(pagetable_t pagetable, int depth)
{
    80000cd0:	7159                	addi	sp,sp,-112
    80000cd2:	f486                	sd	ra,104(sp)
    80000cd4:	f0a2                	sd	s0,96(sp)
    80000cd6:	eca6                	sd	s1,88(sp)
    80000cd8:	e8ca                	sd	s2,80(sp)
    80000cda:	e4ce                	sd	s3,72(sp)
    80000cdc:	e0d2                	sd	s4,64(sp)
    80000cde:	fc56                	sd	s5,56(sp)
    80000ce0:	f85a                	sd	s6,48(sp)
    80000ce2:	f45e                	sd	s7,40(sp)
    80000ce4:	f062                	sd	s8,32(sp)
    80000ce6:	ec66                	sd	s9,24(sp)
    80000ce8:	e86a                	sd	s10,16(sp)
    80000cea:	e46e                	sd	s11,8(sp)
    80000cec:	1880                	addi	s0,sp,112
    80000cee:	89ae                	mv	s3,a1
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000cf0:	8b2a                	mv	s6,a0
    80000cf2:	4a01                	li	s4,0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000cf4:	4c05                	li	s8,1
      uint64 child = PTE2PA(pte);
      vmprintwalk((pagetable_t)child, depth+1);
    } else if(pte & PTE_V){
      for (int n = 0; n < depth; n++)
        printf(" ..");
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000cf6:	00007c97          	auipc	s9,0x7
    80000cfa:	47ac8c93          	addi	s9,s9,1146 # 80008170 <etext+0x170>
      for (int n = 0; n < depth; n++)
    80000cfe:	4d01                	li	s10,0
        printf(" ..");
    80000d00:	00007a97          	auipc	s5,0x7
    80000d04:	468a8a93          	addi	s5,s5,1128 # 80008168 <etext+0x168>
      vmprintwalk((pagetable_t)child, depth+1);
    80000d08:	00158d9b          	addiw	s11,a1,1
  for(int i = 0; i < 512; i++){
    80000d0c:	20000b93          	li	s7,512
    80000d10:	a8a1                	j	80000d68 <vmprintwalk+0x98>
      for (int n = 0; n < depth; n++)
    80000d12:	01305b63          	blez	s3,80000d28 <vmprintwalk+0x58>
    80000d16:	84ea                	mv	s1,s10
        printf(" ..");
    80000d18:	8556                	mv	a0,s5
    80000d1a:	00005097          	auipc	ra,0x5
    80000d1e:	0c4080e7          	jalr	196(ra) # 80005dde <printf>
      for (int n = 0; n < depth; n++)
    80000d22:	2485                	addiw	s1,s1,1
    80000d24:	fe999ae3          	bne	s3,s1,80000d18 <vmprintwalk+0x48>
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d28:	00a95493          	srli	s1,s2,0xa
    80000d2c:	04b2                	slli	s1,s1,0xc
    80000d2e:	86a6                	mv	a3,s1
    80000d30:	864a                	mv	a2,s2
    80000d32:	85d2                	mv	a1,s4
    80000d34:	8566                	mv	a0,s9
    80000d36:	00005097          	auipc	ra,0x5
    80000d3a:	0a8080e7          	jalr	168(ra) # 80005dde <printf>
      vmprintwalk((pagetable_t)child, depth+1);
    80000d3e:	85ee                	mv	a1,s11
    80000d40:	8526                	mv	a0,s1
    80000d42:	00000097          	auipc	ra,0x0
    80000d46:	f8e080e7          	jalr	-114(ra) # 80000cd0 <vmprintwalk>
    80000d4a:	a819                	j	80000d60 <vmprintwalk+0x90>
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d4c:	00a95693          	srli	a3,s2,0xa
    80000d50:	06b2                	slli	a3,a3,0xc
    80000d52:	864a                	mv	a2,s2
    80000d54:	85d2                	mv	a1,s4
    80000d56:	8566                	mv	a0,s9
    80000d58:	00005097          	auipc	ra,0x5
    80000d5c:	086080e7          	jalr	134(ra) # 80005dde <printf>
  for(int i = 0; i < 512; i++){
    80000d60:	2a05                	addiw	s4,s4,1
    80000d62:	0b21                	addi	s6,s6,8 # 1008 <_entry-0x7fffeff8>
    80000d64:	037a0763          	beq	s4,s7,80000d92 <vmprintwalk+0xc2>
    pte_t pte = pagetable[i];
    80000d68:	000b3903          	ld	s2,0(s6)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d6c:	00f97793          	andi	a5,s2,15
    80000d70:	fb8781e3          	beq	a5,s8,80000d12 <vmprintwalk+0x42>
    } else if(pte & PTE_V){
    80000d74:	00197793          	andi	a5,s2,1
    80000d78:	d7e5                	beqz	a5,80000d60 <vmprintwalk+0x90>
      for (int n = 0; n < depth; n++)
    80000d7a:	fd3059e3          	blez	s3,80000d4c <vmprintwalk+0x7c>
    80000d7e:	84ea                	mv	s1,s10
        printf(" ..");
    80000d80:	8556                	mv	a0,s5
    80000d82:	00005097          	auipc	ra,0x5
    80000d86:	05c080e7          	jalr	92(ra) # 80005dde <printf>
      for (int n = 0; n < depth; n++)
    80000d8a:	2485                	addiw	s1,s1,1
    80000d8c:	fe999ae3          	bne	s3,s1,80000d80 <vmprintwalk+0xb0>
    80000d90:	bf75                	j	80000d4c <vmprintwalk+0x7c>
    }
  }
}
    80000d92:	70a6                	ld	ra,104(sp)
    80000d94:	7406                	ld	s0,96(sp)
    80000d96:	64e6                	ld	s1,88(sp)
    80000d98:	6946                	ld	s2,80(sp)
    80000d9a:	69a6                	ld	s3,72(sp)
    80000d9c:	6a06                	ld	s4,64(sp)
    80000d9e:	7ae2                	ld	s5,56(sp)
    80000da0:	7b42                	ld	s6,48(sp)
    80000da2:	7ba2                	ld	s7,40(sp)
    80000da4:	7c02                	ld	s8,32(sp)
    80000da6:	6ce2                	ld	s9,24(sp)
    80000da8:	6d42                	ld	s10,16(sp)
    80000daa:	6da2                	ld	s11,8(sp)
    80000dac:	6165                	addi	sp,sp,112
    80000dae:	8082                	ret

0000000080000db0 <vmprint>:

void
vmprint(pagetable_t pagetable)
{
    80000db0:	1101                	addi	sp,sp,-32
    80000db2:	ec06                	sd	ra,24(sp)
    80000db4:	e822                	sd	s0,16(sp)
    80000db6:	e426                	sd	s1,8(sp)
    80000db8:	1000                	addi	s0,sp,32
    80000dba:	84aa                	mv	s1,a0
  printf("page table %p\n",pagetable);
    80000dbc:	85aa                	mv	a1,a0
    80000dbe:	00007517          	auipc	a0,0x7
    80000dc2:	3ca50513          	addi	a0,a0,970 # 80008188 <etext+0x188>
    80000dc6:	00005097          	auipc	ra,0x5
    80000dca:	018080e7          	jalr	24(ra) # 80005dde <printf>
  vmprintwalk(pagetable,1);
    80000dce:	4585                	li	a1,1
    80000dd0:	8526                	mv	a0,s1
    80000dd2:	00000097          	auipc	ra,0x0
    80000dd6:	efe080e7          	jalr	-258(ra) # 80000cd0 <vmprintwalk>
}
    80000dda:	60e2                	ld	ra,24(sp)
    80000ddc:	6442                	ld	s0,16(sp)
    80000dde:	64a2                	ld	s1,8(sp)
    80000de0:	6105                	addi	sp,sp,32
    80000de2:	8082                	ret

0000000080000de4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000de4:	7139                	addi	sp,sp,-64
    80000de6:	fc06                	sd	ra,56(sp)
    80000de8:	f822                	sd	s0,48(sp)
    80000dea:	f426                	sd	s1,40(sp)
    80000dec:	f04a                	sd	s2,32(sp)
    80000dee:	ec4e                	sd	s3,24(sp)
    80000df0:	e852                	sd	s4,16(sp)
    80000df2:	e456                	sd	s5,8(sp)
    80000df4:	e05a                	sd	s6,0(sp)
    80000df6:	0080                	addi	s0,sp,64
    80000df8:	89aa                	mv	s3,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	68648493          	addi	s1,s1,1670 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e02:	8b26                	mv	s6,s1
    80000e04:	00007a97          	auipc	s5,0x7
    80000e08:	1fca8a93          	addi	s5,s5,508 # 80008000 <etext>
    80000e0c:	01000937          	lui	s2,0x1000
    80000e10:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000e12:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e14:	0000ea17          	auipc	s4,0xe
    80000e18:	26ca0a13          	addi	s4,s4,620 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000e1c:	fffff097          	auipc	ra,0xfffff
    80000e20:	2fc080e7          	jalr	764(ra) # 80000118 <kalloc>
    80000e24:	862a                	mv	a2,a0
    if(pa == 0)
    80000e26:	c129                	beqz	a0,80000e68 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e28:	416485b3          	sub	a1,s1,s6
    80000e2c:	8591                	srai	a1,a1,0x4
    80000e2e:	000ab783          	ld	a5,0(s5)
    80000e32:	02f585b3          	mul	a1,a1,a5
    80000e36:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e3a:	4719                	li	a4,6
    80000e3c:	6685                	lui	a3,0x1
    80000e3e:	40b905b3          	sub	a1,s2,a1
    80000e42:	854e                	mv	a0,s3
    80000e44:	fffff097          	auipc	ra,0xfffff
    80000e48:	79c080e7          	jalr	1948(ra) # 800005e0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4c:	17048493          	addi	s1,s1,368
    80000e50:	fd4496e3          	bne	s1,s4,80000e1c <proc_mapstacks+0x38>
  }
}
    80000e54:	70e2                	ld	ra,56(sp)
    80000e56:	7442                	ld	s0,48(sp)
    80000e58:	74a2                	ld	s1,40(sp)
    80000e5a:	7902                	ld	s2,32(sp)
    80000e5c:	69e2                	ld	s3,24(sp)
    80000e5e:	6a42                	ld	s4,16(sp)
    80000e60:	6aa2                	ld	s5,8(sp)
    80000e62:	6b02                	ld	s6,0(sp)
    80000e64:	6121                	addi	sp,sp,64
    80000e66:	8082                	ret
      panic("kalloc");
    80000e68:	00007517          	auipc	a0,0x7
    80000e6c:	33050513          	addi	a0,a0,816 # 80008198 <etext+0x198>
    80000e70:	00005097          	auipc	ra,0x5
    80000e74:	f24080e7          	jalr	-220(ra) # 80005d94 <panic>

0000000080000e78 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e78:	7139                	addi	sp,sp,-64
    80000e7a:	fc06                	sd	ra,56(sp)
    80000e7c:	f822                	sd	s0,48(sp)
    80000e7e:	f426                	sd	s1,40(sp)
    80000e80:	f04a                	sd	s2,32(sp)
    80000e82:	ec4e                	sd	s3,24(sp)
    80000e84:	e852                	sd	s4,16(sp)
    80000e86:	e456                	sd	s5,8(sp)
    80000e88:	e05a                	sd	s6,0(sp)
    80000e8a:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000e8c:	00007597          	auipc	a1,0x7
    80000e90:	31458593          	addi	a1,a1,788 # 800081a0 <etext+0x1a0>
    80000e94:	00008517          	auipc	a0,0x8
    80000e98:	1bc50513          	addi	a0,a0,444 # 80009050 <pid_lock>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	3a4080e7          	jalr	932(ra) # 80006240 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ea4:	00007597          	auipc	a1,0x7
    80000ea8:	30458593          	addi	a1,a1,772 # 800081a8 <etext+0x1a8>
    80000eac:	00008517          	auipc	a0,0x8
    80000eb0:	1bc50513          	addi	a0,a0,444 # 80009068 <wait_lock>
    80000eb4:	00005097          	auipc	ra,0x5
    80000eb8:	38c080e7          	jalr	908(ra) # 80006240 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ebc:	00008497          	auipc	s1,0x8
    80000ec0:	5c448493          	addi	s1,s1,1476 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000ec4:	00007b17          	auipc	s6,0x7
    80000ec8:	2f4b0b13          	addi	s6,s6,756 # 800081b8 <etext+0x1b8>
      p->kstack = KSTACK((int) (p - proc));
    80000ecc:	8aa6                	mv	s5,s1
    80000ece:	00007a17          	auipc	s4,0x7
    80000ed2:	132a0a13          	addi	s4,s4,306 # 80008000 <etext>
    80000ed6:	01000937          	lui	s2,0x1000
    80000eda:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000edc:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ede:	0000e997          	auipc	s3,0xe
    80000ee2:	1a298993          	addi	s3,s3,418 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000ee6:	85da                	mv	a1,s6
    80000ee8:	8526                	mv	a0,s1
    80000eea:	00005097          	auipc	ra,0x5
    80000eee:	356080e7          	jalr	854(ra) # 80006240 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ef2:	415487b3          	sub	a5,s1,s5
    80000ef6:	8791                	srai	a5,a5,0x4
    80000ef8:	000a3703          	ld	a4,0(s4)
    80000efc:	02e787b3          	mul	a5,a5,a4
    80000f00:	00d7979b          	slliw	a5,a5,0xd
    80000f04:	40f907b3          	sub	a5,s2,a5
    80000f08:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f0a:	17048493          	addi	s1,s1,368
    80000f0e:	fd349ce3          	bne	s1,s3,80000ee6 <procinit+0x6e>
  }
}
    80000f12:	70e2                	ld	ra,56(sp)
    80000f14:	7442                	ld	s0,48(sp)
    80000f16:	74a2                	ld	s1,40(sp)
    80000f18:	7902                	ld	s2,32(sp)
    80000f1a:	69e2                	ld	s3,24(sp)
    80000f1c:	6a42                	ld	s4,16(sp)
    80000f1e:	6aa2                	ld	s5,8(sp)
    80000f20:	6b02                	ld	s6,0(sp)
    80000f22:	6121                	addi	sp,sp,64
    80000f24:	8082                	ret

0000000080000f26 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f26:	1141                	addi	sp,sp,-16
    80000f28:	e422                	sd	s0,8(sp)
    80000f2a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f2c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f2e:	2501                	sext.w	a0,a0
    80000f30:	6422                	ld	s0,8(sp)
    80000f32:	0141                	addi	sp,sp,16
    80000f34:	8082                	ret

0000000080000f36 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f36:	1141                	addi	sp,sp,-16
    80000f38:	e422                	sd	s0,8(sp)
    80000f3a:	0800                	addi	s0,sp,16
    80000f3c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f3e:	2781                	sext.w	a5,a5
    80000f40:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f42:	00008517          	auipc	a0,0x8
    80000f46:	13e50513          	addi	a0,a0,318 # 80009080 <cpus>
    80000f4a:	953e                	add	a0,a0,a5
    80000f4c:	6422                	ld	s0,8(sp)
    80000f4e:	0141                	addi	sp,sp,16
    80000f50:	8082                	ret

0000000080000f52 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f52:	1101                	addi	sp,sp,-32
    80000f54:	ec06                	sd	ra,24(sp)
    80000f56:	e822                	sd	s0,16(sp)
    80000f58:	e426                	sd	s1,8(sp)
    80000f5a:	1000                	addi	s0,sp,32
  push_off();
    80000f5c:	00005097          	auipc	ra,0x5
    80000f60:	328080e7          	jalr	808(ra) # 80006284 <push_off>
    80000f64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f66:	2781                	sext.w	a5,a5
    80000f68:	079e                	slli	a5,a5,0x7
    80000f6a:	00008717          	auipc	a4,0x8
    80000f6e:	0e670713          	addi	a4,a4,230 # 80009050 <pid_lock>
    80000f72:	97ba                	add	a5,a5,a4
    80000f74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f76:	00005097          	auipc	ra,0x5
    80000f7a:	3ae080e7          	jalr	942(ra) # 80006324 <pop_off>
  return p;
}
    80000f7e:	8526                	mv	a0,s1
    80000f80:	60e2                	ld	ra,24(sp)
    80000f82:	6442                	ld	s0,16(sp)
    80000f84:	64a2                	ld	s1,8(sp)
    80000f86:	6105                	addi	sp,sp,32
    80000f88:	8082                	ret

0000000080000f8a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f8a:	1141                	addi	sp,sp,-16
    80000f8c:	e406                	sd	ra,8(sp)
    80000f8e:	e022                	sd	s0,0(sp)
    80000f90:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f92:	00000097          	auipc	ra,0x0
    80000f96:	fc0080e7          	jalr	-64(ra) # 80000f52 <myproc>
    80000f9a:	00005097          	auipc	ra,0x5
    80000f9e:	3ea080e7          	jalr	1002(ra) # 80006384 <release>

  if (first) {
    80000fa2:	00008797          	auipc	a5,0x8
    80000fa6:	8fe7a783          	lw	a5,-1794(a5) # 800088a0 <first.1>
    80000faa:	eb89                	bnez	a5,80000fbc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fac:	00001097          	auipc	ra,0x1
    80000fb0:	c94080e7          	jalr	-876(ra) # 80001c40 <usertrapret>
}
    80000fb4:	60a2                	ld	ra,8(sp)
    80000fb6:	6402                	ld	s0,0(sp)
    80000fb8:	0141                	addi	sp,sp,16
    80000fba:	8082                	ret
    first = 0;
    80000fbc:	00008797          	auipc	a5,0x8
    80000fc0:	8e07a223          	sw	zero,-1820(a5) # 800088a0 <first.1>
    fsinit(ROOTDEV);
    80000fc4:	4505                	li	a0,1
    80000fc6:	00002097          	auipc	ra,0x2
    80000fca:	acc080e7          	jalr	-1332(ra) # 80002a92 <fsinit>
    80000fce:	bff9                	j	80000fac <forkret+0x22>

0000000080000fd0 <allocpid>:
allocpid() {
    80000fd0:	1101                	addi	sp,sp,-32
    80000fd2:	ec06                	sd	ra,24(sp)
    80000fd4:	e822                	sd	s0,16(sp)
    80000fd6:	e426                	sd	s1,8(sp)
    80000fd8:	e04a                	sd	s2,0(sp)
    80000fda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fdc:	00008917          	auipc	s2,0x8
    80000fe0:	07490913          	addi	s2,s2,116 # 80009050 <pid_lock>
    80000fe4:	854a                	mv	a0,s2
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	2ea080e7          	jalr	746(ra) # 800062d0 <acquire>
  pid = nextpid;
    80000fee:	00008797          	auipc	a5,0x8
    80000ff2:	8b678793          	addi	a5,a5,-1866 # 800088a4 <nextpid>
    80000ff6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ff8:	0014871b          	addiw	a4,s1,1
    80000ffc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ffe:	854a                	mv	a0,s2
    80001000:	00005097          	auipc	ra,0x5
    80001004:	384080e7          	jalr	900(ra) # 80006384 <release>
}
    80001008:	8526                	mv	a0,s1
    8000100a:	60e2                	ld	ra,24(sp)
    8000100c:	6442                	ld	s0,16(sp)
    8000100e:	64a2                	ld	s1,8(sp)
    80001010:	6902                	ld	s2,0(sp)
    80001012:	6105                	addi	sp,sp,32
    80001014:	8082                	ret

0000000080001016 <proc_pagetable>:
{
    80001016:	1101                	addi	sp,sp,-32
    80001018:	ec06                	sd	ra,24(sp)
    8000101a:	e822                	sd	s0,16(sp)
    8000101c:	e426                	sd	s1,8(sp)
    8000101e:	e04a                	sd	s2,0(sp)
    80001020:	1000                	addi	s0,sp,32
    80001022:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	7a6080e7          	jalr	1958(ra) # 800007ca <uvmcreate>
    8000102c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000102e:	cd39                	beqz	a0,8000108c <proc_pagetable+0x76>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80001030:	4749                	li	a4,18
    80001032:	16893683          	ld	a3,360(s2)
    80001036:	6605                	lui	a2,0x1
    80001038:	040005b7          	lui	a1,0x4000
    8000103c:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000103e:	05b2                	slli	a1,a1,0xc
    80001040:	fffff097          	auipc	ra,0xfffff
    80001044:	500080e7          	jalr	1280(ra) # 80000540 <mappages>
    80001048:	04054963          	bltz	a0,8000109a <proc_pagetable+0x84>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000104c:	4729                	li	a4,10
    8000104e:	00006697          	auipc	a3,0x6
    80001052:	fb268693          	addi	a3,a3,-78 # 80007000 <_trampoline>
    80001056:	6605                	lui	a2,0x1
    80001058:	040005b7          	lui	a1,0x4000
    8000105c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000105e:	05b2                	slli	a1,a1,0xc
    80001060:	8526                	mv	a0,s1
    80001062:	fffff097          	auipc	ra,0xfffff
    80001066:	4de080e7          	jalr	1246(ra) # 80000540 <mappages>
    8000106a:	04054063          	bltz	a0,800010aa <proc_pagetable+0x94>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000106e:	4719                	li	a4,6
    80001070:	05893683          	ld	a3,88(s2)
    80001074:	6605                	lui	a2,0x1
    80001076:	020005b7          	lui	a1,0x2000
    8000107a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000107c:	05b6                	slli	a1,a1,0xd
    8000107e:	8526                	mv	a0,s1
    80001080:	fffff097          	auipc	ra,0xfffff
    80001084:	4c0080e7          	jalr	1216(ra) # 80000540 <mappages>
    80001088:	02054963          	bltz	a0,800010ba <proc_pagetable+0xa4>
}
    8000108c:	8526                	mv	a0,s1
    8000108e:	60e2                	ld	ra,24(sp)
    80001090:	6442                	ld	s0,16(sp)
    80001092:	64a2                	ld	s1,8(sp)
    80001094:	6902                	ld	s2,0(sp)
    80001096:	6105                	addi	sp,sp,32
    80001098:	8082                	ret
    uvmfree(pagetable, 0);
    8000109a:	4581                	li	a1,0
    8000109c:	8526                	mv	a0,s1
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	928080e7          	jalr	-1752(ra) # 800009c6 <uvmfree>
    return 0;
    800010a6:	4481                	li	s1,0
    800010a8:	b7d5                	j	8000108c <proc_pagetable+0x76>
    uvmfree(pagetable, 0);
    800010aa:	4581                	li	a1,0
    800010ac:	8526                	mv	a0,s1
    800010ae:	00000097          	auipc	ra,0x0
    800010b2:	918080e7          	jalr	-1768(ra) # 800009c6 <uvmfree>
    return 0;
    800010b6:	4481                	li	s1,0
    800010b8:	bfd1                	j	8000108c <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010ba:	4681                	li	a3,0
    800010bc:	4605                	li	a2,1
    800010be:	040005b7          	lui	a1,0x4000
    800010c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010c4:	05b2                	slli	a1,a1,0xc
    800010c6:	8526                	mv	a0,s1
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	63e080e7          	jalr	1598(ra) # 80000706 <uvmunmap>
    uvmfree(pagetable, 0);
    800010d0:	4581                	li	a1,0
    800010d2:	8526                	mv	a0,s1
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	8f2080e7          	jalr	-1806(ra) # 800009c6 <uvmfree>
    return 0;
    800010dc:	4481                	li	s1,0
    800010de:	b77d                	j	8000108c <proc_pagetable+0x76>

00000000800010e0 <proc_freepagetable>:
{
    800010e0:	7179                	addi	sp,sp,-48
    800010e2:	f406                	sd	ra,40(sp)
    800010e4:	f022                	sd	s0,32(sp)
    800010e6:	ec26                	sd	s1,24(sp)
    800010e8:	e84a                	sd	s2,16(sp)
    800010ea:	e44e                	sd	s3,8(sp)
    800010ec:	1800                	addi	s0,sp,48
    800010ee:	84aa                	mv	s1,a0
    800010f0:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010f2:	4681                	li	a3,0
    800010f4:	4605                	li	a2,1
    800010f6:	04000937          	lui	s2,0x4000
    800010fa:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    800010fe:	05b2                	slli	a1,a1,0xc
    80001100:	fffff097          	auipc	ra,0xfffff
    80001104:	606080e7          	jalr	1542(ra) # 80000706 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001108:	4681                	li	a3,0
    8000110a:	4605                	li	a2,1
    8000110c:	020005b7          	lui	a1,0x2000
    80001110:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001112:	05b6                	slli	a1,a1,0xd
    80001114:	8526                	mv	a0,s1
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	5f0080e7          	jalr	1520(ra) # 80000706 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0); // add
    8000111e:	4681                	li	a3,0
    80001120:	4605                	li	a2,1
    80001122:	1975                	addi	s2,s2,-3
    80001124:	00c91593          	slli	a1,s2,0xc
    80001128:	8526                	mv	a0,s1
    8000112a:	fffff097          	auipc	ra,0xfffff
    8000112e:	5dc080e7          	jalr	1500(ra) # 80000706 <uvmunmap>
  uvmfree(pagetable, sz);
    80001132:	85ce                	mv	a1,s3
    80001134:	8526                	mv	a0,s1
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	890080e7          	jalr	-1904(ra) # 800009c6 <uvmfree>
}
    8000113e:	70a2                	ld	ra,40(sp)
    80001140:	7402                	ld	s0,32(sp)
    80001142:	64e2                	ld	s1,24(sp)
    80001144:	6942                	ld	s2,16(sp)
    80001146:	69a2                	ld	s3,8(sp)
    80001148:	6145                	addi	sp,sp,48
    8000114a:	8082                	ret

000000008000114c <freeproc>:
{
    8000114c:	1101                	addi	sp,sp,-32
    8000114e:	ec06                	sd	ra,24(sp)
    80001150:	e822                	sd	s0,16(sp)
    80001152:	e426                	sd	s1,8(sp)
    80001154:	1000                	addi	s0,sp,32
    80001156:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001158:	6d28                	ld	a0,88(a0)
    8000115a:	c509                	beqz	a0,80001164 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	ec0080e7          	jalr	-320(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001164:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001168:	68a8                	ld	a0,80(s1)
    8000116a:	c511                	beqz	a0,80001176 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000116c:	64ac                	ld	a1,72(s1)
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	f72080e7          	jalr	-142(ra) # 800010e0 <proc_freepagetable>
  p->pagetable = 0;
    80001176:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000117a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000117e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001182:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001186:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000118a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000118e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001192:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001196:	0004ac23          	sw	zero,24(s1)
  if(p->usyscall)
    8000119a:	1684b503          	ld	a0,360(s1)
    8000119e:	c509                	beqz	a0,800011a8 <freeproc+0x5c>
    kfree((void*)p->usyscall);
    800011a0:	fffff097          	auipc	ra,0xfffff
    800011a4:	e7c080e7          	jalr	-388(ra) # 8000001c <kfree>
  p->usyscall = 0;
    800011a8:	1604b423          	sd	zero,360(s1)
}
    800011ac:	60e2                	ld	ra,24(sp)
    800011ae:	6442                	ld	s0,16(sp)
    800011b0:	64a2                	ld	s1,8(sp)
    800011b2:	6105                	addi	sp,sp,32
    800011b4:	8082                	ret

00000000800011b6 <allocproc>:
{
    800011b6:	1101                	addi	sp,sp,-32
    800011b8:	ec06                	sd	ra,24(sp)
    800011ba:	e822                	sd	s0,16(sp)
    800011bc:	e426                	sd	s1,8(sp)
    800011be:	e04a                	sd	s2,0(sp)
    800011c0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011c2:	00008497          	auipc	s1,0x8
    800011c6:	2be48493          	addi	s1,s1,702 # 80009480 <proc>
    800011ca:	0000e917          	auipc	s2,0xe
    800011ce:	eb690913          	addi	s2,s2,-330 # 8000f080 <tickslock>
    acquire(&p->lock);
    800011d2:	8526                	mv	a0,s1
    800011d4:	00005097          	auipc	ra,0x5
    800011d8:	0fc080e7          	jalr	252(ra) # 800062d0 <acquire>
    if(p->state == UNUSED) {
    800011dc:	4c9c                	lw	a5,24(s1)
    800011de:	cf81                	beqz	a5,800011f6 <allocproc+0x40>
      release(&p->lock);
    800011e0:	8526                	mv	a0,s1
    800011e2:	00005097          	auipc	ra,0x5
    800011e6:	1a2080e7          	jalr	418(ra) # 80006384 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011ea:	17048493          	addi	s1,s1,368
    800011ee:	ff2492e3          	bne	s1,s2,800011d2 <allocproc+0x1c>
  return 0;
    800011f2:	4481                	li	s1,0
    800011f4:	a09d                	j	8000125a <allocproc+0xa4>
  p->pid = allocpid();
    800011f6:	00000097          	auipc	ra,0x0
    800011fa:	dda080e7          	jalr	-550(ra) # 80000fd0 <allocpid>
    800011fe:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001200:	4785                	li	a5,1
    80001202:	cc9c                	sw	a5,24(s1)
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    80001204:	fffff097          	auipc	ra,0xfffff
    80001208:	f14080e7          	jalr	-236(ra) # 80000118 <kalloc>
    8000120c:	892a                	mv	s2,a0
    8000120e:	16a4b423          	sd	a0,360(s1)
    80001212:	c939                	beqz	a0,80001268 <allocproc+0xb2>
  p->usyscall->pid = p->pid;
    80001214:	589c                	lw	a5,48(s1)
    80001216:	c11c                	sw	a5,0(a0)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001218:	fffff097          	auipc	ra,0xfffff
    8000121c:	f00080e7          	jalr	-256(ra) # 80000118 <kalloc>
    80001220:	892a                	mv	s2,a0
    80001222:	eca8                	sd	a0,88(s1)
    80001224:	cd31                	beqz	a0,80001280 <allocproc+0xca>
  p->pagetable = proc_pagetable(p);
    80001226:	8526                	mv	a0,s1
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	dee080e7          	jalr	-530(ra) # 80001016 <proc_pagetable>
    80001230:	892a                	mv	s2,a0
    80001232:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001234:	c135                	beqz	a0,80001298 <allocproc+0xe2>
  memset(&p->context, 0, sizeof(p->context));
    80001236:	07000613          	li	a2,112
    8000123a:	4581                	li	a1,0
    8000123c:	06048513          	addi	a0,s1,96
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	f38080e7          	jalr	-200(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001248:	00000797          	auipc	a5,0x0
    8000124c:	d4278793          	addi	a5,a5,-702 # 80000f8a <forkret>
    80001250:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001252:	60bc                	ld	a5,64(s1)
    80001254:	6705                	lui	a4,0x1
    80001256:	97ba                	add	a5,a5,a4
    80001258:	f4bc                	sd	a5,104(s1)
}
    8000125a:	8526                	mv	a0,s1
    8000125c:	60e2                	ld	ra,24(sp)
    8000125e:	6442                	ld	s0,16(sp)
    80001260:	64a2                	ld	s1,8(sp)
    80001262:	6902                	ld	s2,0(sp)
    80001264:	6105                	addi	sp,sp,32
    80001266:	8082                	ret
    freeproc(p);
    80001268:	8526                	mv	a0,s1
    8000126a:	00000097          	auipc	ra,0x0
    8000126e:	ee2080e7          	jalr	-286(ra) # 8000114c <freeproc>
    release(&p->lock);
    80001272:	8526                	mv	a0,s1
    80001274:	00005097          	auipc	ra,0x5
    80001278:	110080e7          	jalr	272(ra) # 80006384 <release>
    return 0;
    8000127c:	84ca                	mv	s1,s2
    8000127e:	bff1                	j	8000125a <allocproc+0xa4>
    freeproc(p);
    80001280:	8526                	mv	a0,s1
    80001282:	00000097          	auipc	ra,0x0
    80001286:	eca080e7          	jalr	-310(ra) # 8000114c <freeproc>
    release(&p->lock);
    8000128a:	8526                	mv	a0,s1
    8000128c:	00005097          	auipc	ra,0x5
    80001290:	0f8080e7          	jalr	248(ra) # 80006384 <release>
    return 0;
    80001294:	84ca                	mv	s1,s2
    80001296:	b7d1                	j	8000125a <allocproc+0xa4>
    freeproc(p);
    80001298:	8526                	mv	a0,s1
    8000129a:	00000097          	auipc	ra,0x0
    8000129e:	eb2080e7          	jalr	-334(ra) # 8000114c <freeproc>
    release(&p->lock);
    800012a2:	8526                	mv	a0,s1
    800012a4:	00005097          	auipc	ra,0x5
    800012a8:	0e0080e7          	jalr	224(ra) # 80006384 <release>
    return 0;
    800012ac:	84ca                	mv	s1,s2
    800012ae:	b775                	j	8000125a <allocproc+0xa4>

00000000800012b0 <userinit>:
{
    800012b0:	1101                	addi	sp,sp,-32
    800012b2:	ec06                	sd	ra,24(sp)
    800012b4:	e822                	sd	s0,16(sp)
    800012b6:	e426                	sd	s1,8(sp)
    800012b8:	1000                	addi	s0,sp,32
  p = allocproc();
    800012ba:	00000097          	auipc	ra,0x0
    800012be:	efc080e7          	jalr	-260(ra) # 800011b6 <allocproc>
    800012c2:	84aa                	mv	s1,a0
  initproc = p;
    800012c4:	00008797          	auipc	a5,0x8
    800012c8:	d4a7b623          	sd	a0,-692(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012cc:	03400613          	li	a2,52
    800012d0:	00007597          	auipc	a1,0x7
    800012d4:	5e058593          	addi	a1,a1,1504 # 800088b0 <initcode>
    800012d8:	6928                	ld	a0,80(a0)
    800012da:	fffff097          	auipc	ra,0xfffff
    800012de:	51e080e7          	jalr	1310(ra) # 800007f8 <uvminit>
  p->sz = PGSIZE;
    800012e2:	6785                	lui	a5,0x1
    800012e4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012e6:	6cb8                	ld	a4,88(s1)
    800012e8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012ec:	6cb8                	ld	a4,88(s1)
    800012ee:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012f0:	4641                	li	a2,16
    800012f2:	00007597          	auipc	a1,0x7
    800012f6:	ece58593          	addi	a1,a1,-306 # 800081c0 <etext+0x1c0>
    800012fa:	15848513          	addi	a0,s1,344
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	fc4080e7          	jalr	-60(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001306:	00007517          	auipc	a0,0x7
    8000130a:	eca50513          	addi	a0,a0,-310 # 800081d0 <etext+0x1d0>
    8000130e:	00002097          	auipc	ra,0x2
    80001312:	1b2080e7          	jalr	434(ra) # 800034c0 <namei>
    80001316:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000131a:	478d                	li	a5,3
    8000131c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000131e:	8526                	mv	a0,s1
    80001320:	00005097          	auipc	ra,0x5
    80001324:	064080e7          	jalr	100(ra) # 80006384 <release>
}
    80001328:	60e2                	ld	ra,24(sp)
    8000132a:	6442                	ld	s0,16(sp)
    8000132c:	64a2                	ld	s1,8(sp)
    8000132e:	6105                	addi	sp,sp,32
    80001330:	8082                	ret

0000000080001332 <growproc>:
{
    80001332:	1101                	addi	sp,sp,-32
    80001334:	ec06                	sd	ra,24(sp)
    80001336:	e822                	sd	s0,16(sp)
    80001338:	e426                	sd	s1,8(sp)
    8000133a:	e04a                	sd	s2,0(sp)
    8000133c:	1000                	addi	s0,sp,32
    8000133e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001340:	00000097          	auipc	ra,0x0
    80001344:	c12080e7          	jalr	-1006(ra) # 80000f52 <myproc>
    80001348:	892a                	mv	s2,a0
  sz = p->sz;
    8000134a:	652c                	ld	a1,72(a0)
    8000134c:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001350:	00904f63          	bgtz	s1,8000136e <growproc+0x3c>
  } else if(n < 0){
    80001354:	0204cc63          	bltz	s1,8000138c <growproc+0x5a>
  p->sz = sz;
    80001358:	1602                	slli	a2,a2,0x20
    8000135a:	9201                	srli	a2,a2,0x20
    8000135c:	04c93423          	sd	a2,72(s2)
  return 0;
    80001360:	4501                	li	a0,0
}
    80001362:	60e2                	ld	ra,24(sp)
    80001364:	6442                	ld	s0,16(sp)
    80001366:	64a2                	ld	s1,8(sp)
    80001368:	6902                	ld	s2,0(sp)
    8000136a:	6105                	addi	sp,sp,32
    8000136c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000136e:	9e25                	addw	a2,a2,s1
    80001370:	1602                	slli	a2,a2,0x20
    80001372:	9201                	srli	a2,a2,0x20
    80001374:	1582                	slli	a1,a1,0x20
    80001376:	9181                	srli	a1,a1,0x20
    80001378:	6928                	ld	a0,80(a0)
    8000137a:	fffff097          	auipc	ra,0xfffff
    8000137e:	538080e7          	jalr	1336(ra) # 800008b2 <uvmalloc>
    80001382:	0005061b          	sext.w	a2,a0
    80001386:	fa69                	bnez	a2,80001358 <growproc+0x26>
      return -1;
    80001388:	557d                	li	a0,-1
    8000138a:	bfe1                	j	80001362 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000138c:	9e25                	addw	a2,a2,s1
    8000138e:	1602                	slli	a2,a2,0x20
    80001390:	9201                	srli	a2,a2,0x20
    80001392:	1582                	slli	a1,a1,0x20
    80001394:	9181                	srli	a1,a1,0x20
    80001396:	6928                	ld	a0,80(a0)
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	4d2080e7          	jalr	1234(ra) # 8000086a <uvmdealloc>
    800013a0:	0005061b          	sext.w	a2,a0
    800013a4:	bf55                	j	80001358 <growproc+0x26>

00000000800013a6 <fork>:
{
    800013a6:	7139                	addi	sp,sp,-64
    800013a8:	fc06                	sd	ra,56(sp)
    800013aa:	f822                	sd	s0,48(sp)
    800013ac:	f426                	sd	s1,40(sp)
    800013ae:	f04a                	sd	s2,32(sp)
    800013b0:	ec4e                	sd	s3,24(sp)
    800013b2:	e852                	sd	s4,16(sp)
    800013b4:	e456                	sd	s5,8(sp)
    800013b6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013b8:	00000097          	auipc	ra,0x0
    800013bc:	b9a080e7          	jalr	-1126(ra) # 80000f52 <myproc>
    800013c0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	df4080e7          	jalr	-524(ra) # 800011b6 <allocproc>
    800013ca:	10050c63          	beqz	a0,800014e2 <fork+0x13c>
    800013ce:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013d0:	048ab603          	ld	a2,72(s5)
    800013d4:	692c                	ld	a1,80(a0)
    800013d6:	050ab503          	ld	a0,80(s5)
    800013da:	fffff097          	auipc	ra,0xfffff
    800013de:	624080e7          	jalr	1572(ra) # 800009fe <uvmcopy>
    800013e2:	04054863          	bltz	a0,80001432 <fork+0x8c>
  np->sz = p->sz;
    800013e6:	048ab783          	ld	a5,72(s5)
    800013ea:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800013ee:	058ab683          	ld	a3,88(s5)
    800013f2:	87b6                	mv	a5,a3
    800013f4:	058a3703          	ld	a4,88(s4)
    800013f8:	12068693          	addi	a3,a3,288
    800013fc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001400:	6788                	ld	a0,8(a5)
    80001402:	6b8c                	ld	a1,16(a5)
    80001404:	6f90                	ld	a2,24(a5)
    80001406:	01073023          	sd	a6,0(a4)
    8000140a:	e708                	sd	a0,8(a4)
    8000140c:	eb0c                	sd	a1,16(a4)
    8000140e:	ef10                	sd	a2,24(a4)
    80001410:	02078793          	addi	a5,a5,32
    80001414:	02070713          	addi	a4,a4,32
    80001418:	fed792e3          	bne	a5,a3,800013fc <fork+0x56>
  np->trapframe->a0 = 0;
    8000141c:	058a3783          	ld	a5,88(s4)
    80001420:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001424:	0d0a8493          	addi	s1,s5,208
    80001428:	0d0a0913          	addi	s2,s4,208
    8000142c:	150a8993          	addi	s3,s5,336
    80001430:	a00d                	j	80001452 <fork+0xac>
    freeproc(np);
    80001432:	8552                	mv	a0,s4
    80001434:	00000097          	auipc	ra,0x0
    80001438:	d18080e7          	jalr	-744(ra) # 8000114c <freeproc>
    release(&np->lock);
    8000143c:	8552                	mv	a0,s4
    8000143e:	00005097          	auipc	ra,0x5
    80001442:	f46080e7          	jalr	-186(ra) # 80006384 <release>
    return -1;
    80001446:	597d                	li	s2,-1
    80001448:	a059                	j	800014ce <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    8000144a:	04a1                	addi	s1,s1,8
    8000144c:	0921                	addi	s2,s2,8
    8000144e:	01348b63          	beq	s1,s3,80001464 <fork+0xbe>
    if(p->ofile[i])
    80001452:	6088                	ld	a0,0(s1)
    80001454:	d97d                	beqz	a0,8000144a <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001456:	00002097          	auipc	ra,0x2
    8000145a:	700080e7          	jalr	1792(ra) # 80003b56 <filedup>
    8000145e:	00a93023          	sd	a0,0(s2)
    80001462:	b7e5                	j	8000144a <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001464:	150ab503          	ld	a0,336(s5)
    80001468:	00002097          	auipc	ra,0x2
    8000146c:	864080e7          	jalr	-1948(ra) # 80002ccc <idup>
    80001470:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001474:	4641                	li	a2,16
    80001476:	158a8593          	addi	a1,s5,344
    8000147a:	158a0513          	addi	a0,s4,344
    8000147e:	fffff097          	auipc	ra,0xfffff
    80001482:	e44080e7          	jalr	-444(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001486:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000148a:	8552                	mv	a0,s4
    8000148c:	00005097          	auipc	ra,0x5
    80001490:	ef8080e7          	jalr	-264(ra) # 80006384 <release>
  acquire(&wait_lock);
    80001494:	00008497          	auipc	s1,0x8
    80001498:	bd448493          	addi	s1,s1,-1068 # 80009068 <wait_lock>
    8000149c:	8526                	mv	a0,s1
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	e32080e7          	jalr	-462(ra) # 800062d0 <acquire>
  np->parent = p;
    800014a6:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014aa:	8526                	mv	a0,s1
    800014ac:	00005097          	auipc	ra,0x5
    800014b0:	ed8080e7          	jalr	-296(ra) # 80006384 <release>
  acquire(&np->lock);
    800014b4:	8552                	mv	a0,s4
    800014b6:	00005097          	auipc	ra,0x5
    800014ba:	e1a080e7          	jalr	-486(ra) # 800062d0 <acquire>
  np->state = RUNNABLE;
    800014be:	478d                	li	a5,3
    800014c0:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014c4:	8552                	mv	a0,s4
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	ebe080e7          	jalr	-322(ra) # 80006384 <release>
}
    800014ce:	854a                	mv	a0,s2
    800014d0:	70e2                	ld	ra,56(sp)
    800014d2:	7442                	ld	s0,48(sp)
    800014d4:	74a2                	ld	s1,40(sp)
    800014d6:	7902                	ld	s2,32(sp)
    800014d8:	69e2                	ld	s3,24(sp)
    800014da:	6a42                	ld	s4,16(sp)
    800014dc:	6aa2                	ld	s5,8(sp)
    800014de:	6121                	addi	sp,sp,64
    800014e0:	8082                	ret
    return -1;
    800014e2:	597d                	li	s2,-1
    800014e4:	b7ed                	j	800014ce <fork+0x128>

00000000800014e6 <scheduler>:
{
    800014e6:	7139                	addi	sp,sp,-64
    800014e8:	fc06                	sd	ra,56(sp)
    800014ea:	f822                	sd	s0,48(sp)
    800014ec:	f426                	sd	s1,40(sp)
    800014ee:	f04a                	sd	s2,32(sp)
    800014f0:	ec4e                	sd	s3,24(sp)
    800014f2:	e852                	sd	s4,16(sp)
    800014f4:	e456                	sd	s5,8(sp)
    800014f6:	e05a                	sd	s6,0(sp)
    800014f8:	0080                	addi	s0,sp,64
    800014fa:	8792                	mv	a5,tp
  int id = r_tp();
    800014fc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014fe:	00779a93          	slli	s5,a5,0x7
    80001502:	00008717          	auipc	a4,0x8
    80001506:	b4e70713          	addi	a4,a4,-1202 # 80009050 <pid_lock>
    8000150a:	9756                	add	a4,a4,s5
    8000150c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001510:	00008717          	auipc	a4,0x8
    80001514:	b7870713          	addi	a4,a4,-1160 # 80009088 <cpus+0x8>
    80001518:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000151a:	498d                	li	s3,3
        p->state = RUNNING;
    8000151c:	4b11                	li	s6,4
        c->proc = p;
    8000151e:	079e                	slli	a5,a5,0x7
    80001520:	00008a17          	auipc	s4,0x8
    80001524:	b30a0a13          	addi	s4,s4,-1232 # 80009050 <pid_lock>
    80001528:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000152a:	0000e917          	auipc	s2,0xe
    8000152e:	b5690913          	addi	s2,s2,-1194 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001532:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001536:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000153a:	10079073          	csrw	sstatus,a5
    8000153e:	00008497          	auipc	s1,0x8
    80001542:	f4248493          	addi	s1,s1,-190 # 80009480 <proc>
    80001546:	a811                	j	8000155a <scheduler+0x74>
      release(&p->lock);
    80001548:	8526                	mv	a0,s1
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	e3a080e7          	jalr	-454(ra) # 80006384 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001552:	17048493          	addi	s1,s1,368
    80001556:	fd248ee3          	beq	s1,s2,80001532 <scheduler+0x4c>
      acquire(&p->lock);
    8000155a:	8526                	mv	a0,s1
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	d74080e7          	jalr	-652(ra) # 800062d0 <acquire>
      if(p->state == RUNNABLE) {
    80001564:	4c9c                	lw	a5,24(s1)
    80001566:	ff3791e3          	bne	a5,s3,80001548 <scheduler+0x62>
        p->state = RUNNING;
    8000156a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000156e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001572:	06048593          	addi	a1,s1,96
    80001576:	8556                	mv	a0,s5
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	61e080e7          	jalr	1566(ra) # 80001b96 <swtch>
        c->proc = 0;
    80001580:	020a3823          	sd	zero,48(s4)
    80001584:	b7d1                	j	80001548 <scheduler+0x62>

0000000080001586 <sched>:
{
    80001586:	7179                	addi	sp,sp,-48
    80001588:	f406                	sd	ra,40(sp)
    8000158a:	f022                	sd	s0,32(sp)
    8000158c:	ec26                	sd	s1,24(sp)
    8000158e:	e84a                	sd	s2,16(sp)
    80001590:	e44e                	sd	s3,8(sp)
    80001592:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001594:	00000097          	auipc	ra,0x0
    80001598:	9be080e7          	jalr	-1602(ra) # 80000f52 <myproc>
    8000159c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000159e:	00005097          	auipc	ra,0x5
    800015a2:	cb8080e7          	jalr	-840(ra) # 80006256 <holding>
    800015a6:	c93d                	beqz	a0,8000161c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015a8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015aa:	2781                	sext.w	a5,a5
    800015ac:	079e                	slli	a5,a5,0x7
    800015ae:	00008717          	auipc	a4,0x8
    800015b2:	aa270713          	addi	a4,a4,-1374 # 80009050 <pid_lock>
    800015b6:	97ba                	add	a5,a5,a4
    800015b8:	0a87a703          	lw	a4,168(a5)
    800015bc:	4785                	li	a5,1
    800015be:	06f71763          	bne	a4,a5,8000162c <sched+0xa6>
  if(p->state == RUNNING)
    800015c2:	4c98                	lw	a4,24(s1)
    800015c4:	4791                	li	a5,4
    800015c6:	06f70b63          	beq	a4,a5,8000163c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015ca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015ce:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015d0:	efb5                	bnez	a5,8000164c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015d2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015d4:	00008917          	auipc	s2,0x8
    800015d8:	a7c90913          	addi	s2,s2,-1412 # 80009050 <pid_lock>
    800015dc:	2781                	sext.w	a5,a5
    800015de:	079e                	slli	a5,a5,0x7
    800015e0:	97ca                	add	a5,a5,s2
    800015e2:	0ac7a983          	lw	s3,172(a5)
    800015e6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015e8:	2781                	sext.w	a5,a5
    800015ea:	079e                	slli	a5,a5,0x7
    800015ec:	00008597          	auipc	a1,0x8
    800015f0:	a9c58593          	addi	a1,a1,-1380 # 80009088 <cpus+0x8>
    800015f4:	95be                	add	a1,a1,a5
    800015f6:	06048513          	addi	a0,s1,96
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	59c080e7          	jalr	1436(ra) # 80001b96 <swtch>
    80001602:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001604:	2781                	sext.w	a5,a5
    80001606:	079e                	slli	a5,a5,0x7
    80001608:	97ca                	add	a5,a5,s2
    8000160a:	0b37a623          	sw	s3,172(a5)
}
    8000160e:	70a2                	ld	ra,40(sp)
    80001610:	7402                	ld	s0,32(sp)
    80001612:	64e2                	ld	s1,24(sp)
    80001614:	6942                	ld	s2,16(sp)
    80001616:	69a2                	ld	s3,8(sp)
    80001618:	6145                	addi	sp,sp,48
    8000161a:	8082                	ret
    panic("sched p->lock");
    8000161c:	00007517          	auipc	a0,0x7
    80001620:	bbc50513          	addi	a0,a0,-1092 # 800081d8 <etext+0x1d8>
    80001624:	00004097          	auipc	ra,0x4
    80001628:	770080e7          	jalr	1904(ra) # 80005d94 <panic>
    panic("sched locks");
    8000162c:	00007517          	auipc	a0,0x7
    80001630:	bbc50513          	addi	a0,a0,-1092 # 800081e8 <etext+0x1e8>
    80001634:	00004097          	auipc	ra,0x4
    80001638:	760080e7          	jalr	1888(ra) # 80005d94 <panic>
    panic("sched running");
    8000163c:	00007517          	auipc	a0,0x7
    80001640:	bbc50513          	addi	a0,a0,-1092 # 800081f8 <etext+0x1f8>
    80001644:	00004097          	auipc	ra,0x4
    80001648:	750080e7          	jalr	1872(ra) # 80005d94 <panic>
    panic("sched interruptible");
    8000164c:	00007517          	auipc	a0,0x7
    80001650:	bbc50513          	addi	a0,a0,-1092 # 80008208 <etext+0x208>
    80001654:	00004097          	auipc	ra,0x4
    80001658:	740080e7          	jalr	1856(ra) # 80005d94 <panic>

000000008000165c <yield>:
{
    8000165c:	1101                	addi	sp,sp,-32
    8000165e:	ec06                	sd	ra,24(sp)
    80001660:	e822                	sd	s0,16(sp)
    80001662:	e426                	sd	s1,8(sp)
    80001664:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001666:	00000097          	auipc	ra,0x0
    8000166a:	8ec080e7          	jalr	-1812(ra) # 80000f52 <myproc>
    8000166e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001670:	00005097          	auipc	ra,0x5
    80001674:	c60080e7          	jalr	-928(ra) # 800062d0 <acquire>
  p->state = RUNNABLE;
    80001678:	478d                	li	a5,3
    8000167a:	cc9c                	sw	a5,24(s1)
  sched();
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	f0a080e7          	jalr	-246(ra) # 80001586 <sched>
  release(&p->lock);
    80001684:	8526                	mv	a0,s1
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	cfe080e7          	jalr	-770(ra) # 80006384 <release>
}
    8000168e:	60e2                	ld	ra,24(sp)
    80001690:	6442                	ld	s0,16(sp)
    80001692:	64a2                	ld	s1,8(sp)
    80001694:	6105                	addi	sp,sp,32
    80001696:	8082                	ret

0000000080001698 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001698:	7179                	addi	sp,sp,-48
    8000169a:	f406                	sd	ra,40(sp)
    8000169c:	f022                	sd	s0,32(sp)
    8000169e:	ec26                	sd	s1,24(sp)
    800016a0:	e84a                	sd	s2,16(sp)
    800016a2:	e44e                	sd	s3,8(sp)
    800016a4:	1800                	addi	s0,sp,48
    800016a6:	89aa                	mv	s3,a0
    800016a8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016aa:	00000097          	auipc	ra,0x0
    800016ae:	8a8080e7          	jalr	-1880(ra) # 80000f52 <myproc>
    800016b2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016b4:	00005097          	auipc	ra,0x5
    800016b8:	c1c080e7          	jalr	-996(ra) # 800062d0 <acquire>
  release(lk);
    800016bc:	854a                	mv	a0,s2
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	cc6080e7          	jalr	-826(ra) # 80006384 <release>

  // Go to sleep.
  p->chan = chan;
    800016c6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016ca:	4789                	li	a5,2
    800016cc:	cc9c                	sw	a5,24(s1)

  sched();
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	eb8080e7          	jalr	-328(ra) # 80001586 <sched>

  // Tidy up.
  p->chan = 0;
    800016d6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016da:	8526                	mv	a0,s1
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	ca8080e7          	jalr	-856(ra) # 80006384 <release>
  acquire(lk);
    800016e4:	854a                	mv	a0,s2
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	bea080e7          	jalr	-1046(ra) # 800062d0 <acquire>
}
    800016ee:	70a2                	ld	ra,40(sp)
    800016f0:	7402                	ld	s0,32(sp)
    800016f2:	64e2                	ld	s1,24(sp)
    800016f4:	6942                	ld	s2,16(sp)
    800016f6:	69a2                	ld	s3,8(sp)
    800016f8:	6145                	addi	sp,sp,48
    800016fa:	8082                	ret

00000000800016fc <wait>:
{
    800016fc:	715d                	addi	sp,sp,-80
    800016fe:	e486                	sd	ra,72(sp)
    80001700:	e0a2                	sd	s0,64(sp)
    80001702:	fc26                	sd	s1,56(sp)
    80001704:	f84a                	sd	s2,48(sp)
    80001706:	f44e                	sd	s3,40(sp)
    80001708:	f052                	sd	s4,32(sp)
    8000170a:	ec56                	sd	s5,24(sp)
    8000170c:	e85a                	sd	s6,16(sp)
    8000170e:	e45e                	sd	s7,8(sp)
    80001710:	e062                	sd	s8,0(sp)
    80001712:	0880                	addi	s0,sp,80
    80001714:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001716:	00000097          	auipc	ra,0x0
    8000171a:	83c080e7          	jalr	-1988(ra) # 80000f52 <myproc>
    8000171e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001720:	00008517          	auipc	a0,0x8
    80001724:	94850513          	addi	a0,a0,-1720 # 80009068 <wait_lock>
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	ba8080e7          	jalr	-1112(ra) # 800062d0 <acquire>
    havekids = 0;
    80001730:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001732:	4a15                	li	s4,5
        havekids = 1;
    80001734:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001736:	0000e997          	auipc	s3,0xe
    8000173a:	94a98993          	addi	s3,s3,-1718 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000173e:	00008c17          	auipc	s8,0x8
    80001742:	92ac0c13          	addi	s8,s8,-1750 # 80009068 <wait_lock>
    havekids = 0;
    80001746:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001748:	00008497          	auipc	s1,0x8
    8000174c:	d3848493          	addi	s1,s1,-712 # 80009480 <proc>
    80001750:	a0bd                	j	800017be <wait+0xc2>
          pid = np->pid;
    80001752:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001756:	000b0e63          	beqz	s6,80001772 <wait+0x76>
    8000175a:	4691                	li	a3,4
    8000175c:	02c48613          	addi	a2,s1,44
    80001760:	85da                	mv	a1,s6
    80001762:	05093503          	ld	a0,80(s2)
    80001766:	fffff097          	auipc	ra,0xfffff
    8000176a:	39c080e7          	jalr	924(ra) # 80000b02 <copyout>
    8000176e:	02054563          	bltz	a0,80001798 <wait+0x9c>
          freeproc(np);
    80001772:	8526                	mv	a0,s1
    80001774:	00000097          	auipc	ra,0x0
    80001778:	9d8080e7          	jalr	-1576(ra) # 8000114c <freeproc>
          release(&np->lock);
    8000177c:	8526                	mv	a0,s1
    8000177e:	00005097          	auipc	ra,0x5
    80001782:	c06080e7          	jalr	-1018(ra) # 80006384 <release>
          release(&wait_lock);
    80001786:	00008517          	auipc	a0,0x8
    8000178a:	8e250513          	addi	a0,a0,-1822 # 80009068 <wait_lock>
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	bf6080e7          	jalr	-1034(ra) # 80006384 <release>
          return pid;
    80001796:	a09d                	j	800017fc <wait+0x100>
            release(&np->lock);
    80001798:	8526                	mv	a0,s1
    8000179a:	00005097          	auipc	ra,0x5
    8000179e:	bea080e7          	jalr	-1046(ra) # 80006384 <release>
            release(&wait_lock);
    800017a2:	00008517          	auipc	a0,0x8
    800017a6:	8c650513          	addi	a0,a0,-1850 # 80009068 <wait_lock>
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	bda080e7          	jalr	-1062(ra) # 80006384 <release>
            return -1;
    800017b2:	59fd                	li	s3,-1
    800017b4:	a0a1                	j	800017fc <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017b6:	17048493          	addi	s1,s1,368
    800017ba:	03348463          	beq	s1,s3,800017e2 <wait+0xe6>
      if(np->parent == p){
    800017be:	7c9c                	ld	a5,56(s1)
    800017c0:	ff279be3          	bne	a5,s2,800017b6 <wait+0xba>
        acquire(&np->lock);
    800017c4:	8526                	mv	a0,s1
    800017c6:	00005097          	auipc	ra,0x5
    800017ca:	b0a080e7          	jalr	-1270(ra) # 800062d0 <acquire>
        if(np->state == ZOMBIE){
    800017ce:	4c9c                	lw	a5,24(s1)
    800017d0:	f94781e3          	beq	a5,s4,80001752 <wait+0x56>
        release(&np->lock);
    800017d4:	8526                	mv	a0,s1
    800017d6:	00005097          	auipc	ra,0x5
    800017da:	bae080e7          	jalr	-1106(ra) # 80006384 <release>
        havekids = 1;
    800017de:	8756                	mv	a4,s5
    800017e0:	bfd9                	j	800017b6 <wait+0xba>
    if(!havekids || p->killed){
    800017e2:	c701                	beqz	a4,800017ea <wait+0xee>
    800017e4:	02892783          	lw	a5,40(s2)
    800017e8:	c79d                	beqz	a5,80001816 <wait+0x11a>
      release(&wait_lock);
    800017ea:	00008517          	auipc	a0,0x8
    800017ee:	87e50513          	addi	a0,a0,-1922 # 80009068 <wait_lock>
    800017f2:	00005097          	auipc	ra,0x5
    800017f6:	b92080e7          	jalr	-1134(ra) # 80006384 <release>
      return -1;
    800017fa:	59fd                	li	s3,-1
}
    800017fc:	854e                	mv	a0,s3
    800017fe:	60a6                	ld	ra,72(sp)
    80001800:	6406                	ld	s0,64(sp)
    80001802:	74e2                	ld	s1,56(sp)
    80001804:	7942                	ld	s2,48(sp)
    80001806:	79a2                	ld	s3,40(sp)
    80001808:	7a02                	ld	s4,32(sp)
    8000180a:	6ae2                	ld	s5,24(sp)
    8000180c:	6b42                	ld	s6,16(sp)
    8000180e:	6ba2                	ld	s7,8(sp)
    80001810:	6c02                	ld	s8,0(sp)
    80001812:	6161                	addi	sp,sp,80
    80001814:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001816:	85e2                	mv	a1,s8
    80001818:	854a                	mv	a0,s2
    8000181a:	00000097          	auipc	ra,0x0
    8000181e:	e7e080e7          	jalr	-386(ra) # 80001698 <sleep>
    havekids = 0;
    80001822:	b715                	j	80001746 <wait+0x4a>

0000000080001824 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001824:	7139                	addi	sp,sp,-64
    80001826:	fc06                	sd	ra,56(sp)
    80001828:	f822                	sd	s0,48(sp)
    8000182a:	f426                	sd	s1,40(sp)
    8000182c:	f04a                	sd	s2,32(sp)
    8000182e:	ec4e                	sd	s3,24(sp)
    80001830:	e852                	sd	s4,16(sp)
    80001832:	e456                	sd	s5,8(sp)
    80001834:	0080                	addi	s0,sp,64
    80001836:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001838:	00008497          	auipc	s1,0x8
    8000183c:	c4848493          	addi	s1,s1,-952 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001840:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001842:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001844:	0000e917          	auipc	s2,0xe
    80001848:	83c90913          	addi	s2,s2,-1988 # 8000f080 <tickslock>
    8000184c:	a811                	j	80001860 <wakeup+0x3c>
      }
      release(&p->lock);
    8000184e:	8526                	mv	a0,s1
    80001850:	00005097          	auipc	ra,0x5
    80001854:	b34080e7          	jalr	-1228(ra) # 80006384 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001858:	17048493          	addi	s1,s1,368
    8000185c:	03248663          	beq	s1,s2,80001888 <wakeup+0x64>
    if(p != myproc()){
    80001860:	fffff097          	auipc	ra,0xfffff
    80001864:	6f2080e7          	jalr	1778(ra) # 80000f52 <myproc>
    80001868:	fea488e3          	beq	s1,a0,80001858 <wakeup+0x34>
      acquire(&p->lock);
    8000186c:	8526                	mv	a0,s1
    8000186e:	00005097          	auipc	ra,0x5
    80001872:	a62080e7          	jalr	-1438(ra) # 800062d0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001876:	4c9c                	lw	a5,24(s1)
    80001878:	fd379be3          	bne	a5,s3,8000184e <wakeup+0x2a>
    8000187c:	709c                	ld	a5,32(s1)
    8000187e:	fd4798e3          	bne	a5,s4,8000184e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001882:	0154ac23          	sw	s5,24(s1)
    80001886:	b7e1                	j	8000184e <wakeup+0x2a>
    }
  }
}
    80001888:	70e2                	ld	ra,56(sp)
    8000188a:	7442                	ld	s0,48(sp)
    8000188c:	74a2                	ld	s1,40(sp)
    8000188e:	7902                	ld	s2,32(sp)
    80001890:	69e2                	ld	s3,24(sp)
    80001892:	6a42                	ld	s4,16(sp)
    80001894:	6aa2                	ld	s5,8(sp)
    80001896:	6121                	addi	sp,sp,64
    80001898:	8082                	ret

000000008000189a <reparent>:
{
    8000189a:	7179                	addi	sp,sp,-48
    8000189c:	f406                	sd	ra,40(sp)
    8000189e:	f022                	sd	s0,32(sp)
    800018a0:	ec26                	sd	s1,24(sp)
    800018a2:	e84a                	sd	s2,16(sp)
    800018a4:	e44e                	sd	s3,8(sp)
    800018a6:	e052                	sd	s4,0(sp)
    800018a8:	1800                	addi	s0,sp,48
    800018aa:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018ac:	00008497          	auipc	s1,0x8
    800018b0:	bd448493          	addi	s1,s1,-1068 # 80009480 <proc>
      pp->parent = initproc;
    800018b4:	00007a17          	auipc	s4,0x7
    800018b8:	75ca0a13          	addi	s4,s4,1884 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018bc:	0000d997          	auipc	s3,0xd
    800018c0:	7c498993          	addi	s3,s3,1988 # 8000f080 <tickslock>
    800018c4:	a029                	j	800018ce <reparent+0x34>
    800018c6:	17048493          	addi	s1,s1,368
    800018ca:	01348d63          	beq	s1,s3,800018e4 <reparent+0x4a>
    if(pp->parent == p){
    800018ce:	7c9c                	ld	a5,56(s1)
    800018d0:	ff279be3          	bne	a5,s2,800018c6 <reparent+0x2c>
      pp->parent = initproc;
    800018d4:	000a3503          	ld	a0,0(s4)
    800018d8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018da:	00000097          	auipc	ra,0x0
    800018de:	f4a080e7          	jalr	-182(ra) # 80001824 <wakeup>
    800018e2:	b7d5                	j	800018c6 <reparent+0x2c>
}
    800018e4:	70a2                	ld	ra,40(sp)
    800018e6:	7402                	ld	s0,32(sp)
    800018e8:	64e2                	ld	s1,24(sp)
    800018ea:	6942                	ld	s2,16(sp)
    800018ec:	69a2                	ld	s3,8(sp)
    800018ee:	6a02                	ld	s4,0(sp)
    800018f0:	6145                	addi	sp,sp,48
    800018f2:	8082                	ret

00000000800018f4 <exit>:
{
    800018f4:	7179                	addi	sp,sp,-48
    800018f6:	f406                	sd	ra,40(sp)
    800018f8:	f022                	sd	s0,32(sp)
    800018fa:	ec26                	sd	s1,24(sp)
    800018fc:	e84a                	sd	s2,16(sp)
    800018fe:	e44e                	sd	s3,8(sp)
    80001900:	e052                	sd	s4,0(sp)
    80001902:	1800                	addi	s0,sp,48
    80001904:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001906:	fffff097          	auipc	ra,0xfffff
    8000190a:	64c080e7          	jalr	1612(ra) # 80000f52 <myproc>
    8000190e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001910:	00007797          	auipc	a5,0x7
    80001914:	7007b783          	ld	a5,1792(a5) # 80009010 <initproc>
    80001918:	0d050493          	addi	s1,a0,208
    8000191c:	15050913          	addi	s2,a0,336
    80001920:	02a79363          	bne	a5,a0,80001946 <exit+0x52>
    panic("init exiting");
    80001924:	00007517          	auipc	a0,0x7
    80001928:	8fc50513          	addi	a0,a0,-1796 # 80008220 <etext+0x220>
    8000192c:	00004097          	auipc	ra,0x4
    80001930:	468080e7          	jalr	1128(ra) # 80005d94 <panic>
      fileclose(f);
    80001934:	00002097          	auipc	ra,0x2
    80001938:	274080e7          	jalr	628(ra) # 80003ba8 <fileclose>
      p->ofile[fd] = 0;
    8000193c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001940:	04a1                	addi	s1,s1,8
    80001942:	01248563          	beq	s1,s2,8000194c <exit+0x58>
    if(p->ofile[fd]){
    80001946:	6088                	ld	a0,0(s1)
    80001948:	f575                	bnez	a0,80001934 <exit+0x40>
    8000194a:	bfdd                	j	80001940 <exit+0x4c>
  begin_op();
    8000194c:	00002097          	auipc	ra,0x2
    80001950:	d90080e7          	jalr	-624(ra) # 800036dc <begin_op>
  iput(p->cwd);
    80001954:	1509b503          	ld	a0,336(s3)
    80001958:	00001097          	auipc	ra,0x1
    8000195c:	56c080e7          	jalr	1388(ra) # 80002ec4 <iput>
  end_op();
    80001960:	00002097          	auipc	ra,0x2
    80001964:	dfc080e7          	jalr	-516(ra) # 8000375c <end_op>
  p->cwd = 0;
    80001968:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000196c:	00007497          	auipc	s1,0x7
    80001970:	6fc48493          	addi	s1,s1,1788 # 80009068 <wait_lock>
    80001974:	8526                	mv	a0,s1
    80001976:	00005097          	auipc	ra,0x5
    8000197a:	95a080e7          	jalr	-1702(ra) # 800062d0 <acquire>
  reparent(p);
    8000197e:	854e                	mv	a0,s3
    80001980:	00000097          	auipc	ra,0x0
    80001984:	f1a080e7          	jalr	-230(ra) # 8000189a <reparent>
  wakeup(p->parent);
    80001988:	0389b503          	ld	a0,56(s3)
    8000198c:	00000097          	auipc	ra,0x0
    80001990:	e98080e7          	jalr	-360(ra) # 80001824 <wakeup>
  acquire(&p->lock);
    80001994:	854e                	mv	a0,s3
    80001996:	00005097          	auipc	ra,0x5
    8000199a:	93a080e7          	jalr	-1734(ra) # 800062d0 <acquire>
  p->xstate = status;
    8000199e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019a2:	4795                	li	a5,5
    800019a4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019a8:	8526                	mv	a0,s1
    800019aa:	00005097          	auipc	ra,0x5
    800019ae:	9da080e7          	jalr	-1574(ra) # 80006384 <release>
  sched();
    800019b2:	00000097          	auipc	ra,0x0
    800019b6:	bd4080e7          	jalr	-1068(ra) # 80001586 <sched>
  panic("zombie exit");
    800019ba:	00007517          	auipc	a0,0x7
    800019be:	87650513          	addi	a0,a0,-1930 # 80008230 <etext+0x230>
    800019c2:	00004097          	auipc	ra,0x4
    800019c6:	3d2080e7          	jalr	978(ra) # 80005d94 <panic>

00000000800019ca <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019ca:	7179                	addi	sp,sp,-48
    800019cc:	f406                	sd	ra,40(sp)
    800019ce:	f022                	sd	s0,32(sp)
    800019d0:	ec26                	sd	s1,24(sp)
    800019d2:	e84a                	sd	s2,16(sp)
    800019d4:	e44e                	sd	s3,8(sp)
    800019d6:	1800                	addi	s0,sp,48
    800019d8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019da:	00008497          	auipc	s1,0x8
    800019de:	aa648493          	addi	s1,s1,-1370 # 80009480 <proc>
    800019e2:	0000d997          	auipc	s3,0xd
    800019e6:	69e98993          	addi	s3,s3,1694 # 8000f080 <tickslock>
    acquire(&p->lock);
    800019ea:	8526                	mv	a0,s1
    800019ec:	00005097          	auipc	ra,0x5
    800019f0:	8e4080e7          	jalr	-1820(ra) # 800062d0 <acquire>
    if(p->pid == pid){
    800019f4:	589c                	lw	a5,48(s1)
    800019f6:	01278d63          	beq	a5,s2,80001a10 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019fa:	8526                	mv	a0,s1
    800019fc:	00005097          	auipc	ra,0x5
    80001a00:	988080e7          	jalr	-1656(ra) # 80006384 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a04:	17048493          	addi	s1,s1,368
    80001a08:	ff3491e3          	bne	s1,s3,800019ea <kill+0x20>
  }
  return -1;
    80001a0c:	557d                	li	a0,-1
    80001a0e:	a829                	j	80001a28 <kill+0x5e>
      p->killed = 1;
    80001a10:	4785                	li	a5,1
    80001a12:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a14:	4c98                	lw	a4,24(s1)
    80001a16:	4789                	li	a5,2
    80001a18:	00f70f63          	beq	a4,a5,80001a36 <kill+0x6c>
      release(&p->lock);
    80001a1c:	8526                	mv	a0,s1
    80001a1e:	00005097          	auipc	ra,0x5
    80001a22:	966080e7          	jalr	-1690(ra) # 80006384 <release>
      return 0;
    80001a26:	4501                	li	a0,0
}
    80001a28:	70a2                	ld	ra,40(sp)
    80001a2a:	7402                	ld	s0,32(sp)
    80001a2c:	64e2                	ld	s1,24(sp)
    80001a2e:	6942                	ld	s2,16(sp)
    80001a30:	69a2                	ld	s3,8(sp)
    80001a32:	6145                	addi	sp,sp,48
    80001a34:	8082                	ret
        p->state = RUNNABLE;
    80001a36:	478d                	li	a5,3
    80001a38:	cc9c                	sw	a5,24(s1)
    80001a3a:	b7cd                	j	80001a1c <kill+0x52>

0000000080001a3c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a3c:	7179                	addi	sp,sp,-48
    80001a3e:	f406                	sd	ra,40(sp)
    80001a40:	f022                	sd	s0,32(sp)
    80001a42:	ec26                	sd	s1,24(sp)
    80001a44:	e84a                	sd	s2,16(sp)
    80001a46:	e44e                	sd	s3,8(sp)
    80001a48:	e052                	sd	s4,0(sp)
    80001a4a:	1800                	addi	s0,sp,48
    80001a4c:	84aa                	mv	s1,a0
    80001a4e:	892e                	mv	s2,a1
    80001a50:	89b2                	mv	s3,a2
    80001a52:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	4fe080e7          	jalr	1278(ra) # 80000f52 <myproc>
  if(user_dst){
    80001a5c:	c08d                	beqz	s1,80001a7e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a5e:	86d2                	mv	a3,s4
    80001a60:	864e                	mv	a2,s3
    80001a62:	85ca                	mv	a1,s2
    80001a64:	6928                	ld	a0,80(a0)
    80001a66:	fffff097          	auipc	ra,0xfffff
    80001a6a:	09c080e7          	jalr	156(ra) # 80000b02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a6e:	70a2                	ld	ra,40(sp)
    80001a70:	7402                	ld	s0,32(sp)
    80001a72:	64e2                	ld	s1,24(sp)
    80001a74:	6942                	ld	s2,16(sp)
    80001a76:	69a2                	ld	s3,8(sp)
    80001a78:	6a02                	ld	s4,0(sp)
    80001a7a:	6145                	addi	sp,sp,48
    80001a7c:	8082                	ret
    memmove((char *)dst, src, len);
    80001a7e:	000a061b          	sext.w	a2,s4
    80001a82:	85ce                	mv	a1,s3
    80001a84:	854a                	mv	a0,s2
    80001a86:	ffffe097          	auipc	ra,0xffffe
    80001a8a:	74e080e7          	jalr	1870(ra) # 800001d4 <memmove>
    return 0;
    80001a8e:	8526                	mv	a0,s1
    80001a90:	bff9                	j	80001a6e <either_copyout+0x32>

0000000080001a92 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a92:	7179                	addi	sp,sp,-48
    80001a94:	f406                	sd	ra,40(sp)
    80001a96:	f022                	sd	s0,32(sp)
    80001a98:	ec26                	sd	s1,24(sp)
    80001a9a:	e84a                	sd	s2,16(sp)
    80001a9c:	e44e                	sd	s3,8(sp)
    80001a9e:	e052                	sd	s4,0(sp)
    80001aa0:	1800                	addi	s0,sp,48
    80001aa2:	892a                	mv	s2,a0
    80001aa4:	84ae                	mv	s1,a1
    80001aa6:	89b2                	mv	s3,a2
    80001aa8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aaa:	fffff097          	auipc	ra,0xfffff
    80001aae:	4a8080e7          	jalr	1192(ra) # 80000f52 <myproc>
  if(user_src){
    80001ab2:	c08d                	beqz	s1,80001ad4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ab4:	86d2                	mv	a3,s4
    80001ab6:	864e                	mv	a2,s3
    80001ab8:	85ca                	mv	a1,s2
    80001aba:	6928                	ld	a0,80(a0)
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	0d2080e7          	jalr	210(ra) # 80000b8e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001ac4:	70a2                	ld	ra,40(sp)
    80001ac6:	7402                	ld	s0,32(sp)
    80001ac8:	64e2                	ld	s1,24(sp)
    80001aca:	6942                	ld	s2,16(sp)
    80001acc:	69a2                	ld	s3,8(sp)
    80001ace:	6a02                	ld	s4,0(sp)
    80001ad0:	6145                	addi	sp,sp,48
    80001ad2:	8082                	ret
    memmove(dst, (char*)src, len);
    80001ad4:	000a061b          	sext.w	a2,s4
    80001ad8:	85ce                	mv	a1,s3
    80001ada:	854a                	mv	a0,s2
    80001adc:	ffffe097          	auipc	ra,0xffffe
    80001ae0:	6f8080e7          	jalr	1784(ra) # 800001d4 <memmove>
    return 0;
    80001ae4:	8526                	mv	a0,s1
    80001ae6:	bff9                	j	80001ac4 <either_copyin+0x32>

0000000080001ae8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ae8:	715d                	addi	sp,sp,-80
    80001aea:	e486                	sd	ra,72(sp)
    80001aec:	e0a2                	sd	s0,64(sp)
    80001aee:	fc26                	sd	s1,56(sp)
    80001af0:	f84a                	sd	s2,48(sp)
    80001af2:	f44e                	sd	s3,40(sp)
    80001af4:	f052                	sd	s4,32(sp)
    80001af6:	ec56                	sd	s5,24(sp)
    80001af8:	e85a                	sd	s6,16(sp)
    80001afa:	e45e                	sd	s7,8(sp)
    80001afc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001afe:	00006517          	auipc	a0,0x6
    80001b02:	52a50513          	addi	a0,a0,1322 # 80008028 <etext+0x28>
    80001b06:	00004097          	auipc	ra,0x4
    80001b0a:	2d8080e7          	jalr	728(ra) # 80005dde <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b0e:	00008497          	auipc	s1,0x8
    80001b12:	aca48493          	addi	s1,s1,-1334 # 800095d8 <proc+0x158>
    80001b16:	0000d917          	auipc	s2,0xd
    80001b1a:	6c290913          	addi	s2,s2,1730 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b1e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b20:	00006997          	auipc	s3,0x6
    80001b24:	72098993          	addi	s3,s3,1824 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001b28:	00006a97          	auipc	s5,0x6
    80001b2c:	720a8a93          	addi	s5,s5,1824 # 80008248 <etext+0x248>
    printf("\n");
    80001b30:	00006a17          	auipc	s4,0x6
    80001b34:	4f8a0a13          	addi	s4,s4,1272 # 80008028 <etext+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b38:	00007b97          	auipc	s7,0x7
    80001b3c:	c08b8b93          	addi	s7,s7,-1016 # 80008740 <states.0>
    80001b40:	a00d                	j	80001b62 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b42:	ed86a583          	lw	a1,-296(a3)
    80001b46:	8556                	mv	a0,s5
    80001b48:	00004097          	auipc	ra,0x4
    80001b4c:	296080e7          	jalr	662(ra) # 80005dde <printf>
    printf("\n");
    80001b50:	8552                	mv	a0,s4
    80001b52:	00004097          	auipc	ra,0x4
    80001b56:	28c080e7          	jalr	652(ra) # 80005dde <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b5a:	17048493          	addi	s1,s1,368
    80001b5e:	03248163          	beq	s1,s2,80001b80 <procdump+0x98>
    if(p->state == UNUSED)
    80001b62:	86a6                	mv	a3,s1
    80001b64:	ec04a783          	lw	a5,-320(s1)
    80001b68:	dbed                	beqz	a5,80001b5a <procdump+0x72>
      state = "???";
    80001b6a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b6c:	fcfb6be3          	bltu	s6,a5,80001b42 <procdump+0x5a>
    80001b70:	1782                	slli	a5,a5,0x20
    80001b72:	9381                	srli	a5,a5,0x20
    80001b74:	078e                	slli	a5,a5,0x3
    80001b76:	97de                	add	a5,a5,s7
    80001b78:	6390                	ld	a2,0(a5)
    80001b7a:	f661                	bnez	a2,80001b42 <procdump+0x5a>
      state = "???";
    80001b7c:	864e                	mv	a2,s3
    80001b7e:	b7d1                	j	80001b42 <procdump+0x5a>
  }
}
    80001b80:	60a6                	ld	ra,72(sp)
    80001b82:	6406                	ld	s0,64(sp)
    80001b84:	74e2                	ld	s1,56(sp)
    80001b86:	7942                	ld	s2,48(sp)
    80001b88:	79a2                	ld	s3,40(sp)
    80001b8a:	7a02                	ld	s4,32(sp)
    80001b8c:	6ae2                	ld	s5,24(sp)
    80001b8e:	6b42                	ld	s6,16(sp)
    80001b90:	6ba2                	ld	s7,8(sp)
    80001b92:	6161                	addi	sp,sp,80
    80001b94:	8082                	ret

0000000080001b96 <swtch>:
    80001b96:	00153023          	sd	ra,0(a0)
    80001b9a:	00253423          	sd	sp,8(a0)
    80001b9e:	e900                	sd	s0,16(a0)
    80001ba0:	ed04                	sd	s1,24(a0)
    80001ba2:	03253023          	sd	s2,32(a0)
    80001ba6:	03353423          	sd	s3,40(a0)
    80001baa:	03453823          	sd	s4,48(a0)
    80001bae:	03553c23          	sd	s5,56(a0)
    80001bb2:	05653023          	sd	s6,64(a0)
    80001bb6:	05753423          	sd	s7,72(a0)
    80001bba:	05853823          	sd	s8,80(a0)
    80001bbe:	05953c23          	sd	s9,88(a0)
    80001bc2:	07a53023          	sd	s10,96(a0)
    80001bc6:	07b53423          	sd	s11,104(a0)
    80001bca:	0005b083          	ld	ra,0(a1)
    80001bce:	0085b103          	ld	sp,8(a1)
    80001bd2:	6980                	ld	s0,16(a1)
    80001bd4:	6d84                	ld	s1,24(a1)
    80001bd6:	0205b903          	ld	s2,32(a1)
    80001bda:	0285b983          	ld	s3,40(a1)
    80001bde:	0305ba03          	ld	s4,48(a1)
    80001be2:	0385ba83          	ld	s5,56(a1)
    80001be6:	0405bb03          	ld	s6,64(a1)
    80001bea:	0485bb83          	ld	s7,72(a1)
    80001bee:	0505bc03          	ld	s8,80(a1)
    80001bf2:	0585bc83          	ld	s9,88(a1)
    80001bf6:	0605bd03          	ld	s10,96(a1)
    80001bfa:	0685bd83          	ld	s11,104(a1)
    80001bfe:	8082                	ret

0000000080001c00 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c00:	1141                	addi	sp,sp,-16
    80001c02:	e406                	sd	ra,8(sp)
    80001c04:	e022                	sd	s0,0(sp)
    80001c06:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c08:	00006597          	auipc	a1,0x6
    80001c0c:	67858593          	addi	a1,a1,1656 # 80008280 <etext+0x280>
    80001c10:	0000d517          	auipc	a0,0xd
    80001c14:	47050513          	addi	a0,a0,1136 # 8000f080 <tickslock>
    80001c18:	00004097          	auipc	ra,0x4
    80001c1c:	628080e7          	jalr	1576(ra) # 80006240 <initlock>
}
    80001c20:	60a2                	ld	ra,8(sp)
    80001c22:	6402                	ld	s0,0(sp)
    80001c24:	0141                	addi	sp,sp,16
    80001c26:	8082                	ret

0000000080001c28 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c28:	1141                	addi	sp,sp,-16
    80001c2a:	e422                	sd	s0,8(sp)
    80001c2c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c2e:	00003797          	auipc	a5,0x3
    80001c32:	5c278793          	addi	a5,a5,1474 # 800051f0 <kernelvec>
    80001c36:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c3a:	6422                	ld	s0,8(sp)
    80001c3c:	0141                	addi	sp,sp,16
    80001c3e:	8082                	ret

0000000080001c40 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c40:	1141                	addi	sp,sp,-16
    80001c42:	e406                	sd	ra,8(sp)
    80001c44:	e022                	sd	s0,0(sp)
    80001c46:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c48:	fffff097          	auipc	ra,0xfffff
    80001c4c:	30a080e7          	jalr	778(ra) # 80000f52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c50:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c54:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c56:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c5a:	00005617          	auipc	a2,0x5
    80001c5e:	3a660613          	addi	a2,a2,934 # 80007000 <_trampoline>
    80001c62:	00005697          	auipc	a3,0x5
    80001c66:	39e68693          	addi	a3,a3,926 # 80007000 <_trampoline>
    80001c6a:	8e91                	sub	a3,a3,a2
    80001c6c:	040007b7          	lui	a5,0x4000
    80001c70:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c72:	07b2                	slli	a5,a5,0xc
    80001c74:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c76:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c7a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c7c:	180026f3          	csrr	a3,satp
    80001c80:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c82:	6d38                	ld	a4,88(a0)
    80001c84:	6134                	ld	a3,64(a0)
    80001c86:	6585                	lui	a1,0x1
    80001c88:	96ae                	add	a3,a3,a1
    80001c8a:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c8c:	6d38                	ld	a4,88(a0)
    80001c8e:	00000697          	auipc	a3,0x0
    80001c92:	13868693          	addi	a3,a3,312 # 80001dc6 <usertrap>
    80001c96:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c98:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c9a:	8692                	mv	a3,tp
    80001c9c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c9e:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ca2:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001ca6:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001caa:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cae:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cb0:	6f18                	ld	a4,24(a4)
    80001cb2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cb6:	692c                	ld	a1,80(a0)
    80001cb8:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cba:	00005717          	auipc	a4,0x5
    80001cbe:	3d670713          	addi	a4,a4,982 # 80007090 <userret>
    80001cc2:	8f11                	sub	a4,a4,a2
    80001cc4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cc6:	577d                	li	a4,-1
    80001cc8:	177e                	slli	a4,a4,0x3f
    80001cca:	8dd9                	or	a1,a1,a4
    80001ccc:	02000537          	lui	a0,0x2000
    80001cd0:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001cd2:	0536                	slli	a0,a0,0xd
    80001cd4:	9782                	jalr	a5
}
    80001cd6:	60a2                	ld	ra,8(sp)
    80001cd8:	6402                	ld	s0,0(sp)
    80001cda:	0141                	addi	sp,sp,16
    80001cdc:	8082                	ret

0000000080001cde <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cde:	1101                	addi	sp,sp,-32
    80001ce0:	ec06                	sd	ra,24(sp)
    80001ce2:	e822                	sd	s0,16(sp)
    80001ce4:	e426                	sd	s1,8(sp)
    80001ce6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ce8:	0000d497          	auipc	s1,0xd
    80001cec:	39848493          	addi	s1,s1,920 # 8000f080 <tickslock>
    80001cf0:	8526                	mv	a0,s1
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	5de080e7          	jalr	1502(ra) # 800062d0 <acquire>
  ticks++;
    80001cfa:	00007517          	auipc	a0,0x7
    80001cfe:	31e50513          	addi	a0,a0,798 # 80009018 <ticks>
    80001d02:	411c                	lw	a5,0(a0)
    80001d04:	2785                	addiw	a5,a5,1
    80001d06:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	b1c080e7          	jalr	-1252(ra) # 80001824 <wakeup>
  release(&tickslock);
    80001d10:	8526                	mv	a0,s1
    80001d12:	00004097          	auipc	ra,0x4
    80001d16:	672080e7          	jalr	1650(ra) # 80006384 <release>
}
    80001d1a:	60e2                	ld	ra,24(sp)
    80001d1c:	6442                	ld	s0,16(sp)
    80001d1e:	64a2                	ld	s1,8(sp)
    80001d20:	6105                	addi	sp,sp,32
    80001d22:	8082                	ret

0000000080001d24 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d24:	1101                	addi	sp,sp,-32
    80001d26:	ec06                	sd	ra,24(sp)
    80001d28:	e822                	sd	s0,16(sp)
    80001d2a:	e426                	sd	s1,8(sp)
    80001d2c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d2e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d32:	00074d63          	bltz	a4,80001d4c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d36:	57fd                	li	a5,-1
    80001d38:	17fe                	slli	a5,a5,0x3f
    80001d3a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d3c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d3e:	06f70363          	beq	a4,a5,80001da4 <devintr+0x80>
  }
}
    80001d42:	60e2                	ld	ra,24(sp)
    80001d44:	6442                	ld	s0,16(sp)
    80001d46:	64a2                	ld	s1,8(sp)
    80001d48:	6105                	addi	sp,sp,32
    80001d4a:	8082                	ret
     (scause & 0xff) == 9){
    80001d4c:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001d50:	46a5                	li	a3,9
    80001d52:	fed792e3          	bne	a5,a3,80001d36 <devintr+0x12>
    int irq = plic_claim();
    80001d56:	00003097          	auipc	ra,0x3
    80001d5a:	5a2080e7          	jalr	1442(ra) # 800052f8 <plic_claim>
    80001d5e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d60:	47a9                	li	a5,10
    80001d62:	02f50763          	beq	a0,a5,80001d90 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d66:	4785                	li	a5,1
    80001d68:	02f50963          	beq	a0,a5,80001d9a <devintr+0x76>
    return 1;
    80001d6c:	4505                	li	a0,1
    } else if(irq){
    80001d6e:	d8f1                	beqz	s1,80001d42 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d70:	85a6                	mv	a1,s1
    80001d72:	00006517          	auipc	a0,0x6
    80001d76:	51650513          	addi	a0,a0,1302 # 80008288 <etext+0x288>
    80001d7a:	00004097          	auipc	ra,0x4
    80001d7e:	064080e7          	jalr	100(ra) # 80005dde <printf>
      plic_complete(irq);
    80001d82:	8526                	mv	a0,s1
    80001d84:	00003097          	auipc	ra,0x3
    80001d88:	598080e7          	jalr	1432(ra) # 8000531c <plic_complete>
    return 1;
    80001d8c:	4505                	li	a0,1
    80001d8e:	bf55                	j	80001d42 <devintr+0x1e>
      uartintr();
    80001d90:	00004097          	auipc	ra,0x4
    80001d94:	460080e7          	jalr	1120(ra) # 800061f0 <uartintr>
    80001d98:	b7ed                	j	80001d82 <devintr+0x5e>
      virtio_disk_intr();
    80001d9a:	00004097          	auipc	ra,0x4
    80001d9e:	a14080e7          	jalr	-1516(ra) # 800057ae <virtio_disk_intr>
    80001da2:	b7c5                	j	80001d82 <devintr+0x5e>
    if(cpuid() == 0){
    80001da4:	fffff097          	auipc	ra,0xfffff
    80001da8:	182080e7          	jalr	386(ra) # 80000f26 <cpuid>
    80001dac:	c901                	beqz	a0,80001dbc <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dae:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001db2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001db4:	14479073          	csrw	sip,a5
    return 2;
    80001db8:	4509                	li	a0,2
    80001dba:	b761                	j	80001d42 <devintr+0x1e>
      clockintr();
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	f22080e7          	jalr	-222(ra) # 80001cde <clockintr>
    80001dc4:	b7ed                	j	80001dae <devintr+0x8a>

0000000080001dc6 <usertrap>:
{
    80001dc6:	1101                	addi	sp,sp,-32
    80001dc8:	ec06                	sd	ra,24(sp)
    80001dca:	e822                	sd	s0,16(sp)
    80001dcc:	e426                	sd	s1,8(sp)
    80001dce:	e04a                	sd	s2,0(sp)
    80001dd0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001dd6:	1007f793          	andi	a5,a5,256
    80001dda:	e3ad                	bnez	a5,80001e3c <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ddc:	00003797          	auipc	a5,0x3
    80001de0:	41478793          	addi	a5,a5,1044 # 800051f0 <kernelvec>
    80001de4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	16a080e7          	jalr	362(ra) # 80000f52 <myproc>
    80001df0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001df2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df4:	14102773          	csrr	a4,sepc
    80001df8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dfa:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001dfe:	47a1                	li	a5,8
    80001e00:	04f71c63          	bne	a4,a5,80001e58 <usertrap+0x92>
    if(p->killed)
    80001e04:	551c                	lw	a5,40(a0)
    80001e06:	e3b9                	bnez	a5,80001e4c <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e08:	6cb8                	ld	a4,88(s1)
    80001e0a:	6f1c                	ld	a5,24(a4)
    80001e0c:	0791                	addi	a5,a5,4
    80001e0e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e10:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e14:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e18:	10079073          	csrw	sstatus,a5
    syscall();
    80001e1c:	00000097          	auipc	ra,0x0
    80001e20:	2e0080e7          	jalr	736(ra) # 800020fc <syscall>
  if(p->killed)
    80001e24:	549c                	lw	a5,40(s1)
    80001e26:	ebc1                	bnez	a5,80001eb6 <usertrap+0xf0>
  usertrapret();
    80001e28:	00000097          	auipc	ra,0x0
    80001e2c:	e18080e7          	jalr	-488(ra) # 80001c40 <usertrapret>
}
    80001e30:	60e2                	ld	ra,24(sp)
    80001e32:	6442                	ld	s0,16(sp)
    80001e34:	64a2                	ld	s1,8(sp)
    80001e36:	6902                	ld	s2,0(sp)
    80001e38:	6105                	addi	sp,sp,32
    80001e3a:	8082                	ret
    panic("usertrap: not from user mode");
    80001e3c:	00006517          	auipc	a0,0x6
    80001e40:	46c50513          	addi	a0,a0,1132 # 800082a8 <etext+0x2a8>
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	f50080e7          	jalr	-176(ra) # 80005d94 <panic>
      exit(-1);
    80001e4c:	557d                	li	a0,-1
    80001e4e:	00000097          	auipc	ra,0x0
    80001e52:	aa6080e7          	jalr	-1370(ra) # 800018f4 <exit>
    80001e56:	bf4d                	j	80001e08 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e58:	00000097          	auipc	ra,0x0
    80001e5c:	ecc080e7          	jalr	-308(ra) # 80001d24 <devintr>
    80001e60:	892a                	mv	s2,a0
    80001e62:	c501                	beqz	a0,80001e6a <usertrap+0xa4>
  if(p->killed)
    80001e64:	549c                	lw	a5,40(s1)
    80001e66:	c3a1                	beqz	a5,80001ea6 <usertrap+0xe0>
    80001e68:	a815                	j	80001e9c <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e6a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e6e:	5890                	lw	a2,48(s1)
    80001e70:	00006517          	auipc	a0,0x6
    80001e74:	45850513          	addi	a0,a0,1112 # 800082c8 <etext+0x2c8>
    80001e78:	00004097          	auipc	ra,0x4
    80001e7c:	f66080e7          	jalr	-154(ra) # 80005dde <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e80:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e84:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e88:	00006517          	auipc	a0,0x6
    80001e8c:	47050513          	addi	a0,a0,1136 # 800082f8 <etext+0x2f8>
    80001e90:	00004097          	auipc	ra,0x4
    80001e94:	f4e080e7          	jalr	-178(ra) # 80005dde <printf>
    p->killed = 1;
    80001e98:	4785                	li	a5,1
    80001e9a:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001e9c:	557d                	li	a0,-1
    80001e9e:	00000097          	auipc	ra,0x0
    80001ea2:	a56080e7          	jalr	-1450(ra) # 800018f4 <exit>
  if(which_dev == 2)
    80001ea6:	4789                	li	a5,2
    80001ea8:	f8f910e3          	bne	s2,a5,80001e28 <usertrap+0x62>
    yield();
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	7b0080e7          	jalr	1968(ra) # 8000165c <yield>
    80001eb4:	bf95                	j	80001e28 <usertrap+0x62>
  int which_dev = 0;
    80001eb6:	4901                	li	s2,0
    80001eb8:	b7d5                	j	80001e9c <usertrap+0xd6>

0000000080001eba <kerneltrap>:
{
    80001eba:	7179                	addi	sp,sp,-48
    80001ebc:	f406                	sd	ra,40(sp)
    80001ebe:	f022                	sd	s0,32(sp)
    80001ec0:	ec26                	sd	s1,24(sp)
    80001ec2:	e84a                	sd	s2,16(sp)
    80001ec4:	e44e                	sd	s3,8(sp)
    80001ec6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ecc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ed0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ed4:	1004f793          	andi	a5,s1,256
    80001ed8:	cb85                	beqz	a5,80001f08 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eda:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ede:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ee0:	ef85                	bnez	a5,80001f18 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ee2:	00000097          	auipc	ra,0x0
    80001ee6:	e42080e7          	jalr	-446(ra) # 80001d24 <devintr>
    80001eea:	cd1d                	beqz	a0,80001f28 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eec:	4789                	li	a5,2
    80001eee:	06f50a63          	beq	a0,a5,80001f62 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ef2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ef6:	10049073          	csrw	sstatus,s1
}
    80001efa:	70a2                	ld	ra,40(sp)
    80001efc:	7402                	ld	s0,32(sp)
    80001efe:	64e2                	ld	s1,24(sp)
    80001f00:	6942                	ld	s2,16(sp)
    80001f02:	69a2                	ld	s3,8(sp)
    80001f04:	6145                	addi	sp,sp,48
    80001f06:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f08:	00006517          	auipc	a0,0x6
    80001f0c:	41050513          	addi	a0,a0,1040 # 80008318 <etext+0x318>
    80001f10:	00004097          	auipc	ra,0x4
    80001f14:	e84080e7          	jalr	-380(ra) # 80005d94 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f18:	00006517          	auipc	a0,0x6
    80001f1c:	42850513          	addi	a0,a0,1064 # 80008340 <etext+0x340>
    80001f20:	00004097          	auipc	ra,0x4
    80001f24:	e74080e7          	jalr	-396(ra) # 80005d94 <panic>
    printf("scause %p\n", scause);
    80001f28:	85ce                	mv	a1,s3
    80001f2a:	00006517          	auipc	a0,0x6
    80001f2e:	43650513          	addi	a0,a0,1078 # 80008360 <etext+0x360>
    80001f32:	00004097          	auipc	ra,0x4
    80001f36:	eac080e7          	jalr	-340(ra) # 80005dde <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f3a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f3e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f42:	00006517          	auipc	a0,0x6
    80001f46:	42e50513          	addi	a0,a0,1070 # 80008370 <etext+0x370>
    80001f4a:	00004097          	auipc	ra,0x4
    80001f4e:	e94080e7          	jalr	-364(ra) # 80005dde <printf>
    panic("kerneltrap");
    80001f52:	00006517          	auipc	a0,0x6
    80001f56:	43650513          	addi	a0,a0,1078 # 80008388 <etext+0x388>
    80001f5a:	00004097          	auipc	ra,0x4
    80001f5e:	e3a080e7          	jalr	-454(ra) # 80005d94 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f62:	fffff097          	auipc	ra,0xfffff
    80001f66:	ff0080e7          	jalr	-16(ra) # 80000f52 <myproc>
    80001f6a:	d541                	beqz	a0,80001ef2 <kerneltrap+0x38>
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	fe6080e7          	jalr	-26(ra) # 80000f52 <myproc>
    80001f74:	4d18                	lw	a4,24(a0)
    80001f76:	4791                	li	a5,4
    80001f78:	f6f71de3          	bne	a4,a5,80001ef2 <kerneltrap+0x38>
    yield();
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	6e0080e7          	jalr	1760(ra) # 8000165c <yield>
    80001f84:	b7bd                	j	80001ef2 <kerneltrap+0x38>

0000000080001f86 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f86:	1101                	addi	sp,sp,-32
    80001f88:	ec06                	sd	ra,24(sp)
    80001f8a:	e822                	sd	s0,16(sp)
    80001f8c:	e426                	sd	s1,8(sp)
    80001f8e:	1000                	addi	s0,sp,32
    80001f90:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f92:	fffff097          	auipc	ra,0xfffff
    80001f96:	fc0080e7          	jalr	-64(ra) # 80000f52 <myproc>
  switch (n) {
    80001f9a:	4795                	li	a5,5
    80001f9c:	0497e163          	bltu	a5,s1,80001fde <argraw+0x58>
    80001fa0:	048a                	slli	s1,s1,0x2
    80001fa2:	00006717          	auipc	a4,0x6
    80001fa6:	7ce70713          	addi	a4,a4,1998 # 80008770 <states.0+0x30>
    80001faa:	94ba                	add	s1,s1,a4
    80001fac:	409c                	lw	a5,0(s1)
    80001fae:	97ba                	add	a5,a5,a4
    80001fb0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fb2:	6d3c                	ld	a5,88(a0)
    80001fb4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fb6:	60e2                	ld	ra,24(sp)
    80001fb8:	6442                	ld	s0,16(sp)
    80001fba:	64a2                	ld	s1,8(sp)
    80001fbc:	6105                	addi	sp,sp,32
    80001fbe:	8082                	ret
    return p->trapframe->a1;
    80001fc0:	6d3c                	ld	a5,88(a0)
    80001fc2:	7fa8                	ld	a0,120(a5)
    80001fc4:	bfcd                	j	80001fb6 <argraw+0x30>
    return p->trapframe->a2;
    80001fc6:	6d3c                	ld	a5,88(a0)
    80001fc8:	63c8                	ld	a0,128(a5)
    80001fca:	b7f5                	j	80001fb6 <argraw+0x30>
    return p->trapframe->a3;
    80001fcc:	6d3c                	ld	a5,88(a0)
    80001fce:	67c8                	ld	a0,136(a5)
    80001fd0:	b7dd                	j	80001fb6 <argraw+0x30>
    return p->trapframe->a4;
    80001fd2:	6d3c                	ld	a5,88(a0)
    80001fd4:	6bc8                	ld	a0,144(a5)
    80001fd6:	b7c5                	j	80001fb6 <argraw+0x30>
    return p->trapframe->a5;
    80001fd8:	6d3c                	ld	a5,88(a0)
    80001fda:	6fc8                	ld	a0,152(a5)
    80001fdc:	bfe9                	j	80001fb6 <argraw+0x30>
  panic("argraw");
    80001fde:	00006517          	auipc	a0,0x6
    80001fe2:	3ba50513          	addi	a0,a0,954 # 80008398 <etext+0x398>
    80001fe6:	00004097          	auipc	ra,0x4
    80001fea:	dae080e7          	jalr	-594(ra) # 80005d94 <panic>

0000000080001fee <fetchaddr>:
{
    80001fee:	1101                	addi	sp,sp,-32
    80001ff0:	ec06                	sd	ra,24(sp)
    80001ff2:	e822                	sd	s0,16(sp)
    80001ff4:	e426                	sd	s1,8(sp)
    80001ff6:	e04a                	sd	s2,0(sp)
    80001ff8:	1000                	addi	s0,sp,32
    80001ffa:	84aa                	mv	s1,a0
    80001ffc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	f54080e7          	jalr	-172(ra) # 80000f52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002006:	653c                	ld	a5,72(a0)
    80002008:	02f4f863          	bgeu	s1,a5,80002038 <fetchaddr+0x4a>
    8000200c:	00848713          	addi	a4,s1,8
    80002010:	02e7e663          	bltu	a5,a4,8000203c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002014:	46a1                	li	a3,8
    80002016:	8626                	mv	a2,s1
    80002018:	85ca                	mv	a1,s2
    8000201a:	6928                	ld	a0,80(a0)
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	b72080e7          	jalr	-1166(ra) # 80000b8e <copyin>
    80002024:	00a03533          	snez	a0,a0
    80002028:	40a00533          	neg	a0,a0
}
    8000202c:	60e2                	ld	ra,24(sp)
    8000202e:	6442                	ld	s0,16(sp)
    80002030:	64a2                	ld	s1,8(sp)
    80002032:	6902                	ld	s2,0(sp)
    80002034:	6105                	addi	sp,sp,32
    80002036:	8082                	ret
    return -1;
    80002038:	557d                	li	a0,-1
    8000203a:	bfcd                	j	8000202c <fetchaddr+0x3e>
    8000203c:	557d                	li	a0,-1
    8000203e:	b7fd                	j	8000202c <fetchaddr+0x3e>

0000000080002040 <fetchstr>:
{
    80002040:	7179                	addi	sp,sp,-48
    80002042:	f406                	sd	ra,40(sp)
    80002044:	f022                	sd	s0,32(sp)
    80002046:	ec26                	sd	s1,24(sp)
    80002048:	e84a                	sd	s2,16(sp)
    8000204a:	e44e                	sd	s3,8(sp)
    8000204c:	1800                	addi	s0,sp,48
    8000204e:	892a                	mv	s2,a0
    80002050:	84ae                	mv	s1,a1
    80002052:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002054:	fffff097          	auipc	ra,0xfffff
    80002058:	efe080e7          	jalr	-258(ra) # 80000f52 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000205c:	86ce                	mv	a3,s3
    8000205e:	864a                	mv	a2,s2
    80002060:	85a6                	mv	a1,s1
    80002062:	6928                	ld	a0,80(a0)
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	bb8080e7          	jalr	-1096(ra) # 80000c1c <copyinstr>
  if(err < 0)
    8000206c:	00054763          	bltz	a0,8000207a <fetchstr+0x3a>
  return strlen(buf);
    80002070:	8526                	mv	a0,s1
    80002072:	ffffe097          	auipc	ra,0xffffe
    80002076:	282080e7          	jalr	642(ra) # 800002f4 <strlen>
}
    8000207a:	70a2                	ld	ra,40(sp)
    8000207c:	7402                	ld	s0,32(sp)
    8000207e:	64e2                	ld	s1,24(sp)
    80002080:	6942                	ld	s2,16(sp)
    80002082:	69a2                	ld	s3,8(sp)
    80002084:	6145                	addi	sp,sp,48
    80002086:	8082                	ret

0000000080002088 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002088:	1101                	addi	sp,sp,-32
    8000208a:	ec06                	sd	ra,24(sp)
    8000208c:	e822                	sd	s0,16(sp)
    8000208e:	e426                	sd	s1,8(sp)
    80002090:	1000                	addi	s0,sp,32
    80002092:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002094:	00000097          	auipc	ra,0x0
    80002098:	ef2080e7          	jalr	-270(ra) # 80001f86 <argraw>
    8000209c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000209e:	4501                	li	a0,0
    800020a0:	60e2                	ld	ra,24(sp)
    800020a2:	6442                	ld	s0,16(sp)
    800020a4:	64a2                	ld	s1,8(sp)
    800020a6:	6105                	addi	sp,sp,32
    800020a8:	8082                	ret

00000000800020aa <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020aa:	1101                	addi	sp,sp,-32
    800020ac:	ec06                	sd	ra,24(sp)
    800020ae:	e822                	sd	s0,16(sp)
    800020b0:	e426                	sd	s1,8(sp)
    800020b2:	1000                	addi	s0,sp,32
    800020b4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	ed0080e7          	jalr	-304(ra) # 80001f86 <argraw>
    800020be:	e088                	sd	a0,0(s1)
  return 0;
}
    800020c0:	4501                	li	a0,0
    800020c2:	60e2                	ld	ra,24(sp)
    800020c4:	6442                	ld	s0,16(sp)
    800020c6:	64a2                	ld	s1,8(sp)
    800020c8:	6105                	addi	sp,sp,32
    800020ca:	8082                	ret

00000000800020cc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020cc:	1101                	addi	sp,sp,-32
    800020ce:	ec06                	sd	ra,24(sp)
    800020d0:	e822                	sd	s0,16(sp)
    800020d2:	e426                	sd	s1,8(sp)
    800020d4:	e04a                	sd	s2,0(sp)
    800020d6:	1000                	addi	s0,sp,32
    800020d8:	84ae                	mv	s1,a1
    800020da:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020dc:	00000097          	auipc	ra,0x0
    800020e0:	eaa080e7          	jalr	-342(ra) # 80001f86 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020e4:	864a                	mv	a2,s2
    800020e6:	85a6                	mv	a1,s1
    800020e8:	00000097          	auipc	ra,0x0
    800020ec:	f58080e7          	jalr	-168(ra) # 80002040 <fetchstr>
}
    800020f0:	60e2                	ld	ra,24(sp)
    800020f2:	6442                	ld	s0,16(sp)
    800020f4:	64a2                	ld	s1,8(sp)
    800020f6:	6902                	ld	s2,0(sp)
    800020f8:	6105                	addi	sp,sp,32
    800020fa:	8082                	ret

00000000800020fc <syscall>:



void
syscall(void)
{
    800020fc:	1101                	addi	sp,sp,-32
    800020fe:	ec06                	sd	ra,24(sp)
    80002100:	e822                	sd	s0,16(sp)
    80002102:	e426                	sd	s1,8(sp)
    80002104:	e04a                	sd	s2,0(sp)
    80002106:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	e4a080e7          	jalr	-438(ra) # 80000f52 <myproc>
    80002110:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002112:	05853903          	ld	s2,88(a0)
    80002116:	0a893783          	ld	a5,168(s2)
    8000211a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000211e:	37fd                	addiw	a5,a5,-1
    80002120:	4775                	li	a4,29
    80002122:	00f76f63          	bltu	a4,a5,80002140 <syscall+0x44>
    80002126:	00369713          	slli	a4,a3,0x3
    8000212a:	00006797          	auipc	a5,0x6
    8000212e:	65e78793          	addi	a5,a5,1630 # 80008788 <syscalls>
    80002132:	97ba                	add	a5,a5,a4
    80002134:	639c                	ld	a5,0(a5)
    80002136:	c789                	beqz	a5,80002140 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002138:	9782                	jalr	a5
    8000213a:	06a93823          	sd	a0,112(s2)
    8000213e:	a839                	j	8000215c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002140:	15848613          	addi	a2,s1,344
    80002144:	588c                	lw	a1,48(s1)
    80002146:	00006517          	auipc	a0,0x6
    8000214a:	25a50513          	addi	a0,a0,602 # 800083a0 <etext+0x3a0>
    8000214e:	00004097          	auipc	ra,0x4
    80002152:	c90080e7          	jalr	-880(ra) # 80005dde <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002156:	6cbc                	ld	a5,88(s1)
    80002158:	577d                	li	a4,-1
    8000215a:	fbb8                	sd	a4,112(a5)
  }
}
    8000215c:	60e2                	ld	ra,24(sp)
    8000215e:	6442                	ld	s0,16(sp)
    80002160:	64a2                	ld	s1,8(sp)
    80002162:	6902                	ld	s2,0(sp)
    80002164:	6105                	addi	sp,sp,32
    80002166:	8082                	ret

0000000080002168 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002168:	1101                	addi	sp,sp,-32
    8000216a:	ec06                	sd	ra,24(sp)
    8000216c:	e822                	sd	s0,16(sp)
    8000216e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002170:	fec40593          	addi	a1,s0,-20
    80002174:	4501                	li	a0,0
    80002176:	00000097          	auipc	ra,0x0
    8000217a:	f12080e7          	jalr	-238(ra) # 80002088 <argint>
    return -1;
    8000217e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002180:	00054963          	bltz	a0,80002192 <sys_exit+0x2a>
  exit(n);
    80002184:	fec42503          	lw	a0,-20(s0)
    80002188:	fffff097          	auipc	ra,0xfffff
    8000218c:	76c080e7          	jalr	1900(ra) # 800018f4 <exit>
  return 0;  // not reached
    80002190:	4781                	li	a5,0
}
    80002192:	853e                	mv	a0,a5
    80002194:	60e2                	ld	ra,24(sp)
    80002196:	6442                	ld	s0,16(sp)
    80002198:	6105                	addi	sp,sp,32
    8000219a:	8082                	ret

000000008000219c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000219c:	1141                	addi	sp,sp,-16
    8000219e:	e406                	sd	ra,8(sp)
    800021a0:	e022                	sd	s0,0(sp)
    800021a2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	dae080e7          	jalr	-594(ra) # 80000f52 <myproc>
}
    800021ac:	5908                	lw	a0,48(a0)
    800021ae:	60a2                	ld	ra,8(sp)
    800021b0:	6402                	ld	s0,0(sp)
    800021b2:	0141                	addi	sp,sp,16
    800021b4:	8082                	ret

00000000800021b6 <sys_fork>:

uint64
sys_fork(void)
{
    800021b6:	1141                	addi	sp,sp,-16
    800021b8:	e406                	sd	ra,8(sp)
    800021ba:	e022                	sd	s0,0(sp)
    800021bc:	0800                	addi	s0,sp,16
  return fork();
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	1e8080e7          	jalr	488(ra) # 800013a6 <fork>
}
    800021c6:	60a2                	ld	ra,8(sp)
    800021c8:	6402                	ld	s0,0(sp)
    800021ca:	0141                	addi	sp,sp,16
    800021cc:	8082                	ret

00000000800021ce <sys_wait>:

uint64
sys_wait(void)
{
    800021ce:	1101                	addi	sp,sp,-32
    800021d0:	ec06                	sd	ra,24(sp)
    800021d2:	e822                	sd	s0,16(sp)
    800021d4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021d6:	fe840593          	addi	a1,s0,-24
    800021da:	4501                	li	a0,0
    800021dc:	00000097          	auipc	ra,0x0
    800021e0:	ece080e7          	jalr	-306(ra) # 800020aa <argaddr>
    800021e4:	87aa                	mv	a5,a0
    return -1;
    800021e6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021e8:	0007c863          	bltz	a5,800021f8 <sys_wait+0x2a>
  return wait(p);
    800021ec:	fe843503          	ld	a0,-24(s0)
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	50c080e7          	jalr	1292(ra) # 800016fc <wait>
}
    800021f8:	60e2                	ld	ra,24(sp)
    800021fa:	6442                	ld	s0,16(sp)
    800021fc:	6105                	addi	sp,sp,32
    800021fe:	8082                	ret

0000000080002200 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002200:	7179                	addi	sp,sp,-48
    80002202:	f406                	sd	ra,40(sp)
    80002204:	f022                	sd	s0,32(sp)
    80002206:	ec26                	sd	s1,24(sp)
    80002208:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000220a:	fdc40593          	addi	a1,s0,-36
    8000220e:	4501                	li	a0,0
    80002210:	00000097          	auipc	ra,0x0
    80002214:	e78080e7          	jalr	-392(ra) # 80002088 <argint>
    return -1;
    80002218:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    8000221a:	00054f63          	bltz	a0,80002238 <sys_sbrk+0x38>

  addr = myproc()->sz;
    8000221e:	fffff097          	auipc	ra,0xfffff
    80002222:	d34080e7          	jalr	-716(ra) # 80000f52 <myproc>
    80002226:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002228:	fdc42503          	lw	a0,-36(s0)
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	106080e7          	jalr	262(ra) # 80001332 <growproc>
    80002234:	00054863          	bltz	a0,80002244 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002238:	8526                	mv	a0,s1
    8000223a:	70a2                	ld	ra,40(sp)
    8000223c:	7402                	ld	s0,32(sp)
    8000223e:	64e2                	ld	s1,24(sp)
    80002240:	6145                	addi	sp,sp,48
    80002242:	8082                	ret
    return -1;
    80002244:	54fd                	li	s1,-1
    80002246:	bfcd                	j	80002238 <sys_sbrk+0x38>

0000000080002248 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002248:	7139                	addi	sp,sp,-64
    8000224a:	fc06                	sd	ra,56(sp)
    8000224c:	f822                	sd	s0,48(sp)
    8000224e:	f426                	sd	s1,40(sp)
    80002250:	f04a                	sd	s2,32(sp)
    80002252:	ec4e                	sd	s3,24(sp)
    80002254:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002256:	fcc40593          	addi	a1,s0,-52
    8000225a:	4501                	li	a0,0
    8000225c:	00000097          	auipc	ra,0x0
    80002260:	e2c080e7          	jalr	-468(ra) # 80002088 <argint>
    return -1;
    80002264:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002266:	06054563          	bltz	a0,800022d0 <sys_sleep+0x88>
  acquire(&tickslock);
    8000226a:	0000d517          	auipc	a0,0xd
    8000226e:	e1650513          	addi	a0,a0,-490 # 8000f080 <tickslock>
    80002272:	00004097          	auipc	ra,0x4
    80002276:	05e080e7          	jalr	94(ra) # 800062d0 <acquire>
  ticks0 = ticks;
    8000227a:	00007917          	auipc	s2,0x7
    8000227e:	d9e92903          	lw	s2,-610(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002282:	fcc42783          	lw	a5,-52(s0)
    80002286:	cf85                	beqz	a5,800022be <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002288:	0000d997          	auipc	s3,0xd
    8000228c:	df898993          	addi	s3,s3,-520 # 8000f080 <tickslock>
    80002290:	00007497          	auipc	s1,0x7
    80002294:	d8848493          	addi	s1,s1,-632 # 80009018 <ticks>
    if(myproc()->killed){
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	cba080e7          	jalr	-838(ra) # 80000f52 <myproc>
    800022a0:	551c                	lw	a5,40(a0)
    800022a2:	ef9d                	bnez	a5,800022e0 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022a4:	85ce                	mv	a1,s3
    800022a6:	8526                	mv	a0,s1
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	3f0080e7          	jalr	1008(ra) # 80001698 <sleep>
  while(ticks - ticks0 < n){
    800022b0:	409c                	lw	a5,0(s1)
    800022b2:	412787bb          	subw	a5,a5,s2
    800022b6:	fcc42703          	lw	a4,-52(s0)
    800022ba:	fce7efe3          	bltu	a5,a4,80002298 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022be:	0000d517          	auipc	a0,0xd
    800022c2:	dc250513          	addi	a0,a0,-574 # 8000f080 <tickslock>
    800022c6:	00004097          	auipc	ra,0x4
    800022ca:	0be080e7          	jalr	190(ra) # 80006384 <release>
  return 0;
    800022ce:	4781                	li	a5,0
}
    800022d0:	853e                	mv	a0,a5
    800022d2:	70e2                	ld	ra,56(sp)
    800022d4:	7442                	ld	s0,48(sp)
    800022d6:	74a2                	ld	s1,40(sp)
    800022d8:	7902                	ld	s2,32(sp)
    800022da:	69e2                	ld	s3,24(sp)
    800022dc:	6121                	addi	sp,sp,64
    800022de:	8082                	ret
      release(&tickslock);
    800022e0:	0000d517          	auipc	a0,0xd
    800022e4:	da050513          	addi	a0,a0,-608 # 8000f080 <tickslock>
    800022e8:	00004097          	auipc	ra,0x4
    800022ec:	09c080e7          	jalr	156(ra) # 80006384 <release>
      return -1;
    800022f0:	57fd                	li	a5,-1
    800022f2:	bff9                	j	800022d0 <sys_sleep+0x88>

00000000800022f4 <sys_pgaccess>:

#ifdef LAB_PGTBL
extern pte_t *walk(pagetable_t, uint64, int);
int
sys_pgaccess(void)
{
    800022f4:	711d                	addi	sp,sp,-96
    800022f6:	ec86                	sd	ra,88(sp)
    800022f8:	e8a2                	sd	s0,80(sp)
    800022fa:	e4a6                	sd	s1,72(sp)
    800022fc:	e0ca                	sd	s2,64(sp)
    800022fe:	fc4e                	sd	s3,56(sp)
    80002300:	f852                	sd	s4,48(sp)
    80002302:	f456                	sd	s5,40(sp)
    80002304:	1080                	addi	s0,sp,96
  // lab pgtbl: your code here.
  uint64 srcva, st;
  int len;
  uint64 buf = 0;
    80002306:	fa043023          	sd	zero,-96(s0)
  struct proc *p = myproc();
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	c48080e7          	jalr	-952(ra) # 80000f52 <myproc>
    80002312:	89aa                	mv	s3,a0

  acquire(&p->lock);
    80002314:	00004097          	auipc	ra,0x4
    80002318:	fbc080e7          	jalr	-68(ra) # 800062d0 <acquire>

  argaddr(0, &srcva);
    8000231c:	fb840593          	addi	a1,s0,-72
    80002320:	4501                	li	a0,0
    80002322:	00000097          	auipc	ra,0x0
    80002326:	d88080e7          	jalr	-632(ra) # 800020aa <argaddr>
  argint(1, &len);
    8000232a:	fac40593          	addi	a1,s0,-84
    8000232e:	4505                	li	a0,1
    80002330:	00000097          	auipc	ra,0x0
    80002334:	d58080e7          	jalr	-680(ra) # 80002088 <argint>
  argaddr(2, &st);
    80002338:	fb040593          	addi	a1,s0,-80
    8000233c:	4509                	li	a0,2
    8000233e:	00000097          	auipc	ra,0x0
    80002342:	d6c080e7          	jalr	-660(ra) # 800020aa <argaddr>
  if ((len > 64) || (len < 1))
    80002346:	fac42783          	lw	a5,-84(s0)
    8000234a:	37fd                	addiw	a5,a5,-1
    8000234c:	03f00713          	li	a4,63
    80002350:	08f76d63          	bltu	a4,a5,800023ea <sys_pgaccess+0xf6>
    80002354:	4481                	li	s1,0
      return -1;
    }
    if((*pte & PTE_V) == 0){
      return -1;
    }
    if((*pte & PTE_U) == 0){
    80002356:	4a45                	li	s4,17
      return -1;
    }
    if(*pte & PTE_A){
      *pte = *pte & ~PTE_A;
      buf |= (1 << i);
    80002358:	4a85                	li	s5,1
    8000235a:	a801                	j	8000236a <sys_pgaccess+0x76>
  for (int i = 0; i < len; i++)
    8000235c:	0485                	addi	s1,s1,1
    8000235e:	fac42703          	lw	a4,-84(s0)
    80002362:	0004879b          	sext.w	a5,s1
    80002366:	04e7d563          	bge	a5,a4,800023b0 <sys_pgaccess+0xbc>
    8000236a:	0004891b          	sext.w	s2,s1
    pte = walk(p->pagetable, srcva + i * PGSIZE, 0);
    8000236e:	00c49793          	slli	a5,s1,0xc
    80002372:	4601                	li	a2,0
    80002374:	fb843583          	ld	a1,-72(s0)
    80002378:	95be                	add	a1,a1,a5
    8000237a:	0509b503          	ld	a0,80(s3)
    8000237e:	ffffe097          	auipc	ra,0xffffe
    80002382:	0da080e7          	jalr	218(ra) # 80000458 <walk>
    if(pte == 0){
    80002386:	c525                	beqz	a0,800023ee <sys_pgaccess+0xfa>
    if((*pte & PTE_V) == 0){
    80002388:	611c                	ld	a5,0(a0)
    if((*pte & PTE_U) == 0){
    8000238a:	0117f713          	andi	a4,a5,17
    8000238e:	07471263          	bne	a4,s4,800023f2 <sys_pgaccess+0xfe>
    if(*pte & PTE_A){
    80002392:	0407f713          	andi	a4,a5,64
    80002396:	d379                	beqz	a4,8000235c <sys_pgaccess+0x68>
      *pte = *pte & ~PTE_A;
    80002398:	fbf7f793          	andi	a5,a5,-65
    8000239c:	e11c                	sd	a5,0(a0)
      buf |= (1 << i);
    8000239e:	012a993b          	sllw	s2,s5,s2
    800023a2:	fa043783          	ld	a5,-96(s0)
    800023a6:	0127e933          	or	s2,a5,s2
    800023aa:	fb243023          	sd	s2,-96(s0)
    800023ae:	b77d                	j	8000235c <sys_pgaccess+0x68>
    }
  }
  release(&p->lock);
    800023b0:	854e                	mv	a0,s3
    800023b2:	00004097          	auipc	ra,0x4
    800023b6:	fd2080e7          	jalr	-46(ra) # 80006384 <release>
  copyout(p->pagetable, st, (char *)&buf, ((len -1) / 8) + 1);
    800023ba:	fac42683          	lw	a3,-84(s0)
    800023be:	fff6879b          	addiw	a5,a3,-1
    800023c2:	41f7d69b          	sraiw	a3,a5,0x1f
    800023c6:	01d6d69b          	srliw	a3,a3,0x1d
    800023ca:	9ebd                	addw	a3,a3,a5
    800023cc:	4036d69b          	sraiw	a3,a3,0x3
    800023d0:	2685                	addiw	a3,a3,1
    800023d2:	fa040613          	addi	a2,s0,-96
    800023d6:	fb043583          	ld	a1,-80(s0)
    800023da:	0509b503          	ld	a0,80(s3)
    800023de:	ffffe097          	auipc	ra,0xffffe
    800023e2:	724080e7          	jalr	1828(ra) # 80000b02 <copyout>
  return 0;
    800023e6:	4501                	li	a0,0
    800023e8:	a031                	j	800023f4 <sys_pgaccess+0x100>
    return -1;
    800023ea:	557d                	li	a0,-1
    800023ec:	a021                	j	800023f4 <sys_pgaccess+0x100>
      return -1;
    800023ee:	557d                	li	a0,-1
    800023f0:	a011                	j	800023f4 <sys_pgaccess+0x100>
      return -1;
    800023f2:	557d                	li	a0,-1
}
    800023f4:	60e6                	ld	ra,88(sp)
    800023f6:	6446                	ld	s0,80(sp)
    800023f8:	64a6                	ld	s1,72(sp)
    800023fa:	6906                	ld	s2,64(sp)
    800023fc:	79e2                	ld	s3,56(sp)
    800023fe:	7a42                	ld	s4,48(sp)
    80002400:	7aa2                	ld	s5,40(sp)
    80002402:	6125                	addi	sp,sp,96
    80002404:	8082                	ret

0000000080002406 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002406:	1101                	addi	sp,sp,-32
    80002408:	ec06                	sd	ra,24(sp)
    8000240a:	e822                	sd	s0,16(sp)
    8000240c:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000240e:	fec40593          	addi	a1,s0,-20
    80002412:	4501                	li	a0,0
    80002414:	00000097          	auipc	ra,0x0
    80002418:	c74080e7          	jalr	-908(ra) # 80002088 <argint>
    8000241c:	87aa                	mv	a5,a0
    return -1;
    8000241e:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002420:	0007c863          	bltz	a5,80002430 <sys_kill+0x2a>
  return kill(pid);
    80002424:	fec42503          	lw	a0,-20(s0)
    80002428:	fffff097          	auipc	ra,0xfffff
    8000242c:	5a2080e7          	jalr	1442(ra) # 800019ca <kill>
}
    80002430:	60e2                	ld	ra,24(sp)
    80002432:	6442                	ld	s0,16(sp)
    80002434:	6105                	addi	sp,sp,32
    80002436:	8082                	ret

0000000080002438 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002438:	1101                	addi	sp,sp,-32
    8000243a:	ec06                	sd	ra,24(sp)
    8000243c:	e822                	sd	s0,16(sp)
    8000243e:	e426                	sd	s1,8(sp)
    80002440:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002442:	0000d517          	auipc	a0,0xd
    80002446:	c3e50513          	addi	a0,a0,-962 # 8000f080 <tickslock>
    8000244a:	00004097          	auipc	ra,0x4
    8000244e:	e86080e7          	jalr	-378(ra) # 800062d0 <acquire>
  xticks = ticks;
    80002452:	00007497          	auipc	s1,0x7
    80002456:	bc64a483          	lw	s1,-1082(s1) # 80009018 <ticks>
  release(&tickslock);
    8000245a:	0000d517          	auipc	a0,0xd
    8000245e:	c2650513          	addi	a0,a0,-986 # 8000f080 <tickslock>
    80002462:	00004097          	auipc	ra,0x4
    80002466:	f22080e7          	jalr	-222(ra) # 80006384 <release>
  return xticks;
}
    8000246a:	02049513          	slli	a0,s1,0x20
    8000246e:	9101                	srli	a0,a0,0x20
    80002470:	60e2                	ld	ra,24(sp)
    80002472:	6442                	ld	s0,16(sp)
    80002474:	64a2                	ld	s1,8(sp)
    80002476:	6105                	addi	sp,sp,32
    80002478:	8082                	ret

000000008000247a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000247a:	7179                	addi	sp,sp,-48
    8000247c:	f406                	sd	ra,40(sp)
    8000247e:	f022                	sd	s0,32(sp)
    80002480:	ec26                	sd	s1,24(sp)
    80002482:	e84a                	sd	s2,16(sp)
    80002484:	e44e                	sd	s3,8(sp)
    80002486:	e052                	sd	s4,0(sp)
    80002488:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000248a:	00006597          	auipc	a1,0x6
    8000248e:	f3658593          	addi	a1,a1,-202 # 800083c0 <etext+0x3c0>
    80002492:	0000d517          	auipc	a0,0xd
    80002496:	c0650513          	addi	a0,a0,-1018 # 8000f098 <bcache>
    8000249a:	00004097          	auipc	ra,0x4
    8000249e:	da6080e7          	jalr	-602(ra) # 80006240 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024a2:	00015797          	auipc	a5,0x15
    800024a6:	bf678793          	addi	a5,a5,-1034 # 80017098 <bcache+0x8000>
    800024aa:	00015717          	auipc	a4,0x15
    800024ae:	e5670713          	addi	a4,a4,-426 # 80017300 <bcache+0x8268>
    800024b2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024b6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024ba:	0000d497          	auipc	s1,0xd
    800024be:	bf648493          	addi	s1,s1,-1034 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024c2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024c4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024c6:	00006a17          	auipc	s4,0x6
    800024ca:	f02a0a13          	addi	s4,s4,-254 # 800083c8 <etext+0x3c8>
    b->next = bcache.head.next;
    800024ce:	2b893783          	ld	a5,696(s2)
    800024d2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024d4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024d8:	85d2                	mv	a1,s4
    800024da:	01048513          	addi	a0,s1,16
    800024de:	00001097          	auipc	ra,0x1
    800024e2:	4bc080e7          	jalr	1212(ra) # 8000399a <initsleeplock>
    bcache.head.next->prev = b;
    800024e6:	2b893783          	ld	a5,696(s2)
    800024ea:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024ec:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024f0:	45848493          	addi	s1,s1,1112
    800024f4:	fd349de3          	bne	s1,s3,800024ce <binit+0x54>
  }
}
    800024f8:	70a2                	ld	ra,40(sp)
    800024fa:	7402                	ld	s0,32(sp)
    800024fc:	64e2                	ld	s1,24(sp)
    800024fe:	6942                	ld	s2,16(sp)
    80002500:	69a2                	ld	s3,8(sp)
    80002502:	6a02                	ld	s4,0(sp)
    80002504:	6145                	addi	sp,sp,48
    80002506:	8082                	ret

0000000080002508 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002508:	7179                	addi	sp,sp,-48
    8000250a:	f406                	sd	ra,40(sp)
    8000250c:	f022                	sd	s0,32(sp)
    8000250e:	ec26                	sd	s1,24(sp)
    80002510:	e84a                	sd	s2,16(sp)
    80002512:	e44e                	sd	s3,8(sp)
    80002514:	1800                	addi	s0,sp,48
    80002516:	892a                	mv	s2,a0
    80002518:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000251a:	0000d517          	auipc	a0,0xd
    8000251e:	b7e50513          	addi	a0,a0,-1154 # 8000f098 <bcache>
    80002522:	00004097          	auipc	ra,0x4
    80002526:	dae080e7          	jalr	-594(ra) # 800062d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000252a:	00015497          	auipc	s1,0x15
    8000252e:	e264b483          	ld	s1,-474(s1) # 80017350 <bcache+0x82b8>
    80002532:	00015797          	auipc	a5,0x15
    80002536:	dce78793          	addi	a5,a5,-562 # 80017300 <bcache+0x8268>
    8000253a:	02f48f63          	beq	s1,a5,80002578 <bread+0x70>
    8000253e:	873e                	mv	a4,a5
    80002540:	a021                	j	80002548 <bread+0x40>
    80002542:	68a4                	ld	s1,80(s1)
    80002544:	02e48a63          	beq	s1,a4,80002578 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002548:	449c                	lw	a5,8(s1)
    8000254a:	ff279ce3          	bne	a5,s2,80002542 <bread+0x3a>
    8000254e:	44dc                	lw	a5,12(s1)
    80002550:	ff3799e3          	bne	a5,s3,80002542 <bread+0x3a>
      b->refcnt++;
    80002554:	40bc                	lw	a5,64(s1)
    80002556:	2785                	addiw	a5,a5,1
    80002558:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000255a:	0000d517          	auipc	a0,0xd
    8000255e:	b3e50513          	addi	a0,a0,-1218 # 8000f098 <bcache>
    80002562:	00004097          	auipc	ra,0x4
    80002566:	e22080e7          	jalr	-478(ra) # 80006384 <release>
      acquiresleep(&b->lock);
    8000256a:	01048513          	addi	a0,s1,16
    8000256e:	00001097          	auipc	ra,0x1
    80002572:	466080e7          	jalr	1126(ra) # 800039d4 <acquiresleep>
      return b;
    80002576:	a8b9                	j	800025d4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002578:	00015497          	auipc	s1,0x15
    8000257c:	dd04b483          	ld	s1,-560(s1) # 80017348 <bcache+0x82b0>
    80002580:	00015797          	auipc	a5,0x15
    80002584:	d8078793          	addi	a5,a5,-640 # 80017300 <bcache+0x8268>
    80002588:	00f48863          	beq	s1,a5,80002598 <bread+0x90>
    8000258c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000258e:	40bc                	lw	a5,64(s1)
    80002590:	cf81                	beqz	a5,800025a8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002592:	64a4                	ld	s1,72(s1)
    80002594:	fee49de3          	bne	s1,a4,8000258e <bread+0x86>
  panic("bget: no buffers");
    80002598:	00006517          	auipc	a0,0x6
    8000259c:	e3850513          	addi	a0,a0,-456 # 800083d0 <etext+0x3d0>
    800025a0:	00003097          	auipc	ra,0x3
    800025a4:	7f4080e7          	jalr	2036(ra) # 80005d94 <panic>
      b->dev = dev;
    800025a8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025ac:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025b0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025b4:	4785                	li	a5,1
    800025b6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025b8:	0000d517          	auipc	a0,0xd
    800025bc:	ae050513          	addi	a0,a0,-1312 # 8000f098 <bcache>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	dc4080e7          	jalr	-572(ra) # 80006384 <release>
      acquiresleep(&b->lock);
    800025c8:	01048513          	addi	a0,s1,16
    800025cc:	00001097          	auipc	ra,0x1
    800025d0:	408080e7          	jalr	1032(ra) # 800039d4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025d4:	409c                	lw	a5,0(s1)
    800025d6:	cb89                	beqz	a5,800025e8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025d8:	8526                	mv	a0,s1
    800025da:	70a2                	ld	ra,40(sp)
    800025dc:	7402                	ld	s0,32(sp)
    800025de:	64e2                	ld	s1,24(sp)
    800025e0:	6942                	ld	s2,16(sp)
    800025e2:	69a2                	ld	s3,8(sp)
    800025e4:	6145                	addi	sp,sp,48
    800025e6:	8082                	ret
    virtio_disk_rw(b, 0);
    800025e8:	4581                	li	a1,0
    800025ea:	8526                	mv	a0,s1
    800025ec:	00003097          	auipc	ra,0x3
    800025f0:	f3a080e7          	jalr	-198(ra) # 80005526 <virtio_disk_rw>
    b->valid = 1;
    800025f4:	4785                	li	a5,1
    800025f6:	c09c                	sw	a5,0(s1)
  return b;
    800025f8:	b7c5                	j	800025d8 <bread+0xd0>

00000000800025fa <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025fa:	1101                	addi	sp,sp,-32
    800025fc:	ec06                	sd	ra,24(sp)
    800025fe:	e822                	sd	s0,16(sp)
    80002600:	e426                	sd	s1,8(sp)
    80002602:	1000                	addi	s0,sp,32
    80002604:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002606:	0541                	addi	a0,a0,16
    80002608:	00001097          	auipc	ra,0x1
    8000260c:	466080e7          	jalr	1126(ra) # 80003a6e <holdingsleep>
    80002610:	cd01                	beqz	a0,80002628 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002612:	4585                	li	a1,1
    80002614:	8526                	mv	a0,s1
    80002616:	00003097          	auipc	ra,0x3
    8000261a:	f10080e7          	jalr	-240(ra) # 80005526 <virtio_disk_rw>
}
    8000261e:	60e2                	ld	ra,24(sp)
    80002620:	6442                	ld	s0,16(sp)
    80002622:	64a2                	ld	s1,8(sp)
    80002624:	6105                	addi	sp,sp,32
    80002626:	8082                	ret
    panic("bwrite");
    80002628:	00006517          	auipc	a0,0x6
    8000262c:	dc050513          	addi	a0,a0,-576 # 800083e8 <etext+0x3e8>
    80002630:	00003097          	auipc	ra,0x3
    80002634:	764080e7          	jalr	1892(ra) # 80005d94 <panic>

0000000080002638 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002638:	1101                	addi	sp,sp,-32
    8000263a:	ec06                	sd	ra,24(sp)
    8000263c:	e822                	sd	s0,16(sp)
    8000263e:	e426                	sd	s1,8(sp)
    80002640:	e04a                	sd	s2,0(sp)
    80002642:	1000                	addi	s0,sp,32
    80002644:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002646:	01050913          	addi	s2,a0,16
    8000264a:	854a                	mv	a0,s2
    8000264c:	00001097          	auipc	ra,0x1
    80002650:	422080e7          	jalr	1058(ra) # 80003a6e <holdingsleep>
    80002654:	c92d                	beqz	a0,800026c6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002656:	854a                	mv	a0,s2
    80002658:	00001097          	auipc	ra,0x1
    8000265c:	3d2080e7          	jalr	978(ra) # 80003a2a <releasesleep>

  acquire(&bcache.lock);
    80002660:	0000d517          	auipc	a0,0xd
    80002664:	a3850513          	addi	a0,a0,-1480 # 8000f098 <bcache>
    80002668:	00004097          	auipc	ra,0x4
    8000266c:	c68080e7          	jalr	-920(ra) # 800062d0 <acquire>
  b->refcnt--;
    80002670:	40bc                	lw	a5,64(s1)
    80002672:	37fd                	addiw	a5,a5,-1
    80002674:	0007871b          	sext.w	a4,a5
    80002678:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000267a:	eb05                	bnez	a4,800026aa <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000267c:	68bc                	ld	a5,80(s1)
    8000267e:	64b8                	ld	a4,72(s1)
    80002680:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002682:	64bc                	ld	a5,72(s1)
    80002684:	68b8                	ld	a4,80(s1)
    80002686:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002688:	00015797          	auipc	a5,0x15
    8000268c:	a1078793          	addi	a5,a5,-1520 # 80017098 <bcache+0x8000>
    80002690:	2b87b703          	ld	a4,696(a5)
    80002694:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002696:	00015717          	auipc	a4,0x15
    8000269a:	c6a70713          	addi	a4,a4,-918 # 80017300 <bcache+0x8268>
    8000269e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026a0:	2b87b703          	ld	a4,696(a5)
    800026a4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026a6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026aa:	0000d517          	auipc	a0,0xd
    800026ae:	9ee50513          	addi	a0,a0,-1554 # 8000f098 <bcache>
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	cd2080e7          	jalr	-814(ra) # 80006384 <release>
}
    800026ba:	60e2                	ld	ra,24(sp)
    800026bc:	6442                	ld	s0,16(sp)
    800026be:	64a2                	ld	s1,8(sp)
    800026c0:	6902                	ld	s2,0(sp)
    800026c2:	6105                	addi	sp,sp,32
    800026c4:	8082                	ret
    panic("brelse");
    800026c6:	00006517          	auipc	a0,0x6
    800026ca:	d2a50513          	addi	a0,a0,-726 # 800083f0 <etext+0x3f0>
    800026ce:	00003097          	auipc	ra,0x3
    800026d2:	6c6080e7          	jalr	1734(ra) # 80005d94 <panic>

00000000800026d6 <bpin>:

void
bpin(struct buf *b) {
    800026d6:	1101                	addi	sp,sp,-32
    800026d8:	ec06                	sd	ra,24(sp)
    800026da:	e822                	sd	s0,16(sp)
    800026dc:	e426                	sd	s1,8(sp)
    800026de:	1000                	addi	s0,sp,32
    800026e0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026e2:	0000d517          	auipc	a0,0xd
    800026e6:	9b650513          	addi	a0,a0,-1610 # 8000f098 <bcache>
    800026ea:	00004097          	auipc	ra,0x4
    800026ee:	be6080e7          	jalr	-1050(ra) # 800062d0 <acquire>
  b->refcnt++;
    800026f2:	40bc                	lw	a5,64(s1)
    800026f4:	2785                	addiw	a5,a5,1
    800026f6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026f8:	0000d517          	auipc	a0,0xd
    800026fc:	9a050513          	addi	a0,a0,-1632 # 8000f098 <bcache>
    80002700:	00004097          	auipc	ra,0x4
    80002704:	c84080e7          	jalr	-892(ra) # 80006384 <release>
}
    80002708:	60e2                	ld	ra,24(sp)
    8000270a:	6442                	ld	s0,16(sp)
    8000270c:	64a2                	ld	s1,8(sp)
    8000270e:	6105                	addi	sp,sp,32
    80002710:	8082                	ret

0000000080002712 <bunpin>:

void
bunpin(struct buf *b) {
    80002712:	1101                	addi	sp,sp,-32
    80002714:	ec06                	sd	ra,24(sp)
    80002716:	e822                	sd	s0,16(sp)
    80002718:	e426                	sd	s1,8(sp)
    8000271a:	1000                	addi	s0,sp,32
    8000271c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000271e:	0000d517          	auipc	a0,0xd
    80002722:	97a50513          	addi	a0,a0,-1670 # 8000f098 <bcache>
    80002726:	00004097          	auipc	ra,0x4
    8000272a:	baa080e7          	jalr	-1110(ra) # 800062d0 <acquire>
  b->refcnt--;
    8000272e:	40bc                	lw	a5,64(s1)
    80002730:	37fd                	addiw	a5,a5,-1
    80002732:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002734:	0000d517          	auipc	a0,0xd
    80002738:	96450513          	addi	a0,a0,-1692 # 8000f098 <bcache>
    8000273c:	00004097          	auipc	ra,0x4
    80002740:	c48080e7          	jalr	-952(ra) # 80006384 <release>
}
    80002744:	60e2                	ld	ra,24(sp)
    80002746:	6442                	ld	s0,16(sp)
    80002748:	64a2                	ld	s1,8(sp)
    8000274a:	6105                	addi	sp,sp,32
    8000274c:	8082                	ret

000000008000274e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000274e:	1101                	addi	sp,sp,-32
    80002750:	ec06                	sd	ra,24(sp)
    80002752:	e822                	sd	s0,16(sp)
    80002754:	e426                	sd	s1,8(sp)
    80002756:	e04a                	sd	s2,0(sp)
    80002758:	1000                	addi	s0,sp,32
    8000275a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000275c:	00d5d59b          	srliw	a1,a1,0xd
    80002760:	00015797          	auipc	a5,0x15
    80002764:	0147a783          	lw	a5,20(a5) # 80017774 <sb+0x1c>
    80002768:	9dbd                	addw	a1,a1,a5
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	d9e080e7          	jalr	-610(ra) # 80002508 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002772:	0074f713          	andi	a4,s1,7
    80002776:	4785                	li	a5,1
    80002778:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000277c:	14ce                	slli	s1,s1,0x33
    8000277e:	90d9                	srli	s1,s1,0x36
    80002780:	00950733          	add	a4,a0,s1
    80002784:	05874703          	lbu	a4,88(a4)
    80002788:	00e7f6b3          	and	a3,a5,a4
    8000278c:	c69d                	beqz	a3,800027ba <bfree+0x6c>
    8000278e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002790:	94aa                	add	s1,s1,a0
    80002792:	fff7c793          	not	a5,a5
    80002796:	8ff9                	and	a5,a5,a4
    80002798:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000279c:	00001097          	auipc	ra,0x1
    800027a0:	118080e7          	jalr	280(ra) # 800038b4 <log_write>
  brelse(bp);
    800027a4:	854a                	mv	a0,s2
    800027a6:	00000097          	auipc	ra,0x0
    800027aa:	e92080e7          	jalr	-366(ra) # 80002638 <brelse>
}
    800027ae:	60e2                	ld	ra,24(sp)
    800027b0:	6442                	ld	s0,16(sp)
    800027b2:	64a2                	ld	s1,8(sp)
    800027b4:	6902                	ld	s2,0(sp)
    800027b6:	6105                	addi	sp,sp,32
    800027b8:	8082                	ret
    panic("freeing free block");
    800027ba:	00006517          	auipc	a0,0x6
    800027be:	c3e50513          	addi	a0,a0,-962 # 800083f8 <etext+0x3f8>
    800027c2:	00003097          	auipc	ra,0x3
    800027c6:	5d2080e7          	jalr	1490(ra) # 80005d94 <panic>

00000000800027ca <balloc>:
{
    800027ca:	711d                	addi	sp,sp,-96
    800027cc:	ec86                	sd	ra,88(sp)
    800027ce:	e8a2                	sd	s0,80(sp)
    800027d0:	e4a6                	sd	s1,72(sp)
    800027d2:	e0ca                	sd	s2,64(sp)
    800027d4:	fc4e                	sd	s3,56(sp)
    800027d6:	f852                	sd	s4,48(sp)
    800027d8:	f456                	sd	s5,40(sp)
    800027da:	f05a                	sd	s6,32(sp)
    800027dc:	ec5e                	sd	s7,24(sp)
    800027de:	e862                	sd	s8,16(sp)
    800027e0:	e466                	sd	s9,8(sp)
    800027e2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027e4:	00015797          	auipc	a5,0x15
    800027e8:	f787a783          	lw	a5,-136(a5) # 8001775c <sb+0x4>
    800027ec:	cbd1                	beqz	a5,80002880 <balloc+0xb6>
    800027ee:	8baa                	mv	s7,a0
    800027f0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027f2:	00015b17          	auipc	s6,0x15
    800027f6:	f66b0b13          	addi	s6,s6,-154 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fa:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027fc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fe:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002800:	6c89                	lui	s9,0x2
    80002802:	a831                	j	8000281e <balloc+0x54>
    brelse(bp);
    80002804:	854a                	mv	a0,s2
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	e32080e7          	jalr	-462(ra) # 80002638 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000280e:	015c87bb          	addw	a5,s9,s5
    80002812:	00078a9b          	sext.w	s5,a5
    80002816:	004b2703          	lw	a4,4(s6)
    8000281a:	06eaf363          	bgeu	s5,a4,80002880 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000281e:	41fad79b          	sraiw	a5,s5,0x1f
    80002822:	0137d79b          	srliw	a5,a5,0x13
    80002826:	015787bb          	addw	a5,a5,s5
    8000282a:	40d7d79b          	sraiw	a5,a5,0xd
    8000282e:	01cb2583          	lw	a1,28(s6)
    80002832:	9dbd                	addw	a1,a1,a5
    80002834:	855e                	mv	a0,s7
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	cd2080e7          	jalr	-814(ra) # 80002508 <bread>
    8000283e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002840:	004b2503          	lw	a0,4(s6)
    80002844:	000a849b          	sext.w	s1,s5
    80002848:	8662                	mv	a2,s8
    8000284a:	faa4fde3          	bgeu	s1,a0,80002804 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000284e:	41f6579b          	sraiw	a5,a2,0x1f
    80002852:	01d7d69b          	srliw	a3,a5,0x1d
    80002856:	00c6873b          	addw	a4,a3,a2
    8000285a:	00777793          	andi	a5,a4,7
    8000285e:	9f95                	subw	a5,a5,a3
    80002860:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002864:	4037571b          	sraiw	a4,a4,0x3
    80002868:	00e906b3          	add	a3,s2,a4
    8000286c:	0586c683          	lbu	a3,88(a3)
    80002870:	00d7f5b3          	and	a1,a5,a3
    80002874:	cd91                	beqz	a1,80002890 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002876:	2605                	addiw	a2,a2,1
    80002878:	2485                	addiw	s1,s1,1
    8000287a:	fd4618e3          	bne	a2,s4,8000284a <balloc+0x80>
    8000287e:	b759                	j	80002804 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002880:	00006517          	auipc	a0,0x6
    80002884:	b9050513          	addi	a0,a0,-1136 # 80008410 <etext+0x410>
    80002888:	00003097          	auipc	ra,0x3
    8000288c:	50c080e7          	jalr	1292(ra) # 80005d94 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002890:	974a                	add	a4,a4,s2
    80002892:	8fd5                	or	a5,a5,a3
    80002894:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002898:	854a                	mv	a0,s2
    8000289a:	00001097          	auipc	ra,0x1
    8000289e:	01a080e7          	jalr	26(ra) # 800038b4 <log_write>
        brelse(bp);
    800028a2:	854a                	mv	a0,s2
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	d94080e7          	jalr	-620(ra) # 80002638 <brelse>
  bp = bread(dev, bno);
    800028ac:	85a6                	mv	a1,s1
    800028ae:	855e                	mv	a0,s7
    800028b0:	00000097          	auipc	ra,0x0
    800028b4:	c58080e7          	jalr	-936(ra) # 80002508 <bread>
    800028b8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028ba:	40000613          	li	a2,1024
    800028be:	4581                	li	a1,0
    800028c0:	05850513          	addi	a0,a0,88
    800028c4:	ffffe097          	auipc	ra,0xffffe
    800028c8:	8b4080e7          	jalr	-1868(ra) # 80000178 <memset>
  log_write(bp);
    800028cc:	854a                	mv	a0,s2
    800028ce:	00001097          	auipc	ra,0x1
    800028d2:	fe6080e7          	jalr	-26(ra) # 800038b4 <log_write>
  brelse(bp);
    800028d6:	854a                	mv	a0,s2
    800028d8:	00000097          	auipc	ra,0x0
    800028dc:	d60080e7          	jalr	-672(ra) # 80002638 <brelse>
}
    800028e0:	8526                	mv	a0,s1
    800028e2:	60e6                	ld	ra,88(sp)
    800028e4:	6446                	ld	s0,80(sp)
    800028e6:	64a6                	ld	s1,72(sp)
    800028e8:	6906                	ld	s2,64(sp)
    800028ea:	79e2                	ld	s3,56(sp)
    800028ec:	7a42                	ld	s4,48(sp)
    800028ee:	7aa2                	ld	s5,40(sp)
    800028f0:	7b02                	ld	s6,32(sp)
    800028f2:	6be2                	ld	s7,24(sp)
    800028f4:	6c42                	ld	s8,16(sp)
    800028f6:	6ca2                	ld	s9,8(sp)
    800028f8:	6125                	addi	sp,sp,96
    800028fa:	8082                	ret

00000000800028fc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028fc:	7179                	addi	sp,sp,-48
    800028fe:	f406                	sd	ra,40(sp)
    80002900:	f022                	sd	s0,32(sp)
    80002902:	ec26                	sd	s1,24(sp)
    80002904:	e84a                	sd	s2,16(sp)
    80002906:	e44e                	sd	s3,8(sp)
    80002908:	e052                	sd	s4,0(sp)
    8000290a:	1800                	addi	s0,sp,48
    8000290c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000290e:	47ad                	li	a5,11
    80002910:	04b7fe63          	bgeu	a5,a1,8000296c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002914:	ff45849b          	addiw	s1,a1,-12
    80002918:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000291c:	0ff00793          	li	a5,255
    80002920:	0ae7e363          	bltu	a5,a4,800029c6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002924:	08052583          	lw	a1,128(a0)
    80002928:	c5ad                	beqz	a1,80002992 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000292a:	00092503          	lw	a0,0(s2)
    8000292e:	00000097          	auipc	ra,0x0
    80002932:	bda080e7          	jalr	-1062(ra) # 80002508 <bread>
    80002936:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002938:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000293c:	02049593          	slli	a1,s1,0x20
    80002940:	9181                	srli	a1,a1,0x20
    80002942:	058a                	slli	a1,a1,0x2
    80002944:	00b784b3          	add	s1,a5,a1
    80002948:	0004a983          	lw	s3,0(s1)
    8000294c:	04098d63          	beqz	s3,800029a6 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002950:	8552                	mv	a0,s4
    80002952:	00000097          	auipc	ra,0x0
    80002956:	ce6080e7          	jalr	-794(ra) # 80002638 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000295a:	854e                	mv	a0,s3
    8000295c:	70a2                	ld	ra,40(sp)
    8000295e:	7402                	ld	s0,32(sp)
    80002960:	64e2                	ld	s1,24(sp)
    80002962:	6942                	ld	s2,16(sp)
    80002964:	69a2                	ld	s3,8(sp)
    80002966:	6a02                	ld	s4,0(sp)
    80002968:	6145                	addi	sp,sp,48
    8000296a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000296c:	02059493          	slli	s1,a1,0x20
    80002970:	9081                	srli	s1,s1,0x20
    80002972:	048a                	slli	s1,s1,0x2
    80002974:	94aa                	add	s1,s1,a0
    80002976:	0504a983          	lw	s3,80(s1)
    8000297a:	fe0990e3          	bnez	s3,8000295a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000297e:	4108                	lw	a0,0(a0)
    80002980:	00000097          	auipc	ra,0x0
    80002984:	e4a080e7          	jalr	-438(ra) # 800027ca <balloc>
    80002988:	0005099b          	sext.w	s3,a0
    8000298c:	0534a823          	sw	s3,80(s1)
    80002990:	b7e9                	j	8000295a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002992:	4108                	lw	a0,0(a0)
    80002994:	00000097          	auipc	ra,0x0
    80002998:	e36080e7          	jalr	-458(ra) # 800027ca <balloc>
    8000299c:	0005059b          	sext.w	a1,a0
    800029a0:	08b92023          	sw	a1,128(s2)
    800029a4:	b759                	j	8000292a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029a6:	00092503          	lw	a0,0(s2)
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	e20080e7          	jalr	-480(ra) # 800027ca <balloc>
    800029b2:	0005099b          	sext.w	s3,a0
    800029b6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029ba:	8552                	mv	a0,s4
    800029bc:	00001097          	auipc	ra,0x1
    800029c0:	ef8080e7          	jalr	-264(ra) # 800038b4 <log_write>
    800029c4:	b771                	j	80002950 <bmap+0x54>
  panic("bmap: out of range");
    800029c6:	00006517          	auipc	a0,0x6
    800029ca:	a6250513          	addi	a0,a0,-1438 # 80008428 <etext+0x428>
    800029ce:	00003097          	auipc	ra,0x3
    800029d2:	3c6080e7          	jalr	966(ra) # 80005d94 <panic>

00000000800029d6 <iget>:
{
    800029d6:	7179                	addi	sp,sp,-48
    800029d8:	f406                	sd	ra,40(sp)
    800029da:	f022                	sd	s0,32(sp)
    800029dc:	ec26                	sd	s1,24(sp)
    800029de:	e84a                	sd	s2,16(sp)
    800029e0:	e44e                	sd	s3,8(sp)
    800029e2:	e052                	sd	s4,0(sp)
    800029e4:	1800                	addi	s0,sp,48
    800029e6:	89aa                	mv	s3,a0
    800029e8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029ea:	00015517          	auipc	a0,0x15
    800029ee:	d8e50513          	addi	a0,a0,-626 # 80017778 <itable>
    800029f2:	00004097          	auipc	ra,0x4
    800029f6:	8de080e7          	jalr	-1826(ra) # 800062d0 <acquire>
  empty = 0;
    800029fa:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029fc:	00015497          	auipc	s1,0x15
    80002a00:	d9448493          	addi	s1,s1,-620 # 80017790 <itable+0x18>
    80002a04:	00017697          	auipc	a3,0x17
    80002a08:	81c68693          	addi	a3,a3,-2020 # 80019220 <log>
    80002a0c:	a039                	j	80002a1a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a0e:	02090b63          	beqz	s2,80002a44 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a12:	08848493          	addi	s1,s1,136
    80002a16:	02d48a63          	beq	s1,a3,80002a4a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a1a:	449c                	lw	a5,8(s1)
    80002a1c:	fef059e3          	blez	a5,80002a0e <iget+0x38>
    80002a20:	4098                	lw	a4,0(s1)
    80002a22:	ff3716e3          	bne	a4,s3,80002a0e <iget+0x38>
    80002a26:	40d8                	lw	a4,4(s1)
    80002a28:	ff4713e3          	bne	a4,s4,80002a0e <iget+0x38>
      ip->ref++;
    80002a2c:	2785                	addiw	a5,a5,1
    80002a2e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a30:	00015517          	auipc	a0,0x15
    80002a34:	d4850513          	addi	a0,a0,-696 # 80017778 <itable>
    80002a38:	00004097          	auipc	ra,0x4
    80002a3c:	94c080e7          	jalr	-1716(ra) # 80006384 <release>
      return ip;
    80002a40:	8926                	mv	s2,s1
    80002a42:	a03d                	j	80002a70 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a44:	f7f9                	bnez	a5,80002a12 <iget+0x3c>
    80002a46:	8926                	mv	s2,s1
    80002a48:	b7e9                	j	80002a12 <iget+0x3c>
  if(empty == 0)
    80002a4a:	02090c63          	beqz	s2,80002a82 <iget+0xac>
  ip->dev = dev;
    80002a4e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a52:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a56:	4785                	li	a5,1
    80002a58:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a5c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a60:	00015517          	auipc	a0,0x15
    80002a64:	d1850513          	addi	a0,a0,-744 # 80017778 <itable>
    80002a68:	00004097          	auipc	ra,0x4
    80002a6c:	91c080e7          	jalr	-1764(ra) # 80006384 <release>
}
    80002a70:	854a                	mv	a0,s2
    80002a72:	70a2                	ld	ra,40(sp)
    80002a74:	7402                	ld	s0,32(sp)
    80002a76:	64e2                	ld	s1,24(sp)
    80002a78:	6942                	ld	s2,16(sp)
    80002a7a:	69a2                	ld	s3,8(sp)
    80002a7c:	6a02                	ld	s4,0(sp)
    80002a7e:	6145                	addi	sp,sp,48
    80002a80:	8082                	ret
    panic("iget: no inodes");
    80002a82:	00006517          	auipc	a0,0x6
    80002a86:	9be50513          	addi	a0,a0,-1602 # 80008440 <etext+0x440>
    80002a8a:	00003097          	auipc	ra,0x3
    80002a8e:	30a080e7          	jalr	778(ra) # 80005d94 <panic>

0000000080002a92 <fsinit>:
fsinit(int dev) {
    80002a92:	7179                	addi	sp,sp,-48
    80002a94:	f406                	sd	ra,40(sp)
    80002a96:	f022                	sd	s0,32(sp)
    80002a98:	ec26                	sd	s1,24(sp)
    80002a9a:	e84a                	sd	s2,16(sp)
    80002a9c:	e44e                	sd	s3,8(sp)
    80002a9e:	1800                	addi	s0,sp,48
    80002aa0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aa2:	4585                	li	a1,1
    80002aa4:	00000097          	auipc	ra,0x0
    80002aa8:	a64080e7          	jalr	-1436(ra) # 80002508 <bread>
    80002aac:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002aae:	00015997          	auipc	s3,0x15
    80002ab2:	caa98993          	addi	s3,s3,-854 # 80017758 <sb>
    80002ab6:	02000613          	li	a2,32
    80002aba:	05850593          	addi	a1,a0,88
    80002abe:	854e                	mv	a0,s3
    80002ac0:	ffffd097          	auipc	ra,0xffffd
    80002ac4:	714080e7          	jalr	1812(ra) # 800001d4 <memmove>
  brelse(bp);
    80002ac8:	8526                	mv	a0,s1
    80002aca:	00000097          	auipc	ra,0x0
    80002ace:	b6e080e7          	jalr	-1170(ra) # 80002638 <brelse>
  if(sb.magic != FSMAGIC)
    80002ad2:	0009a703          	lw	a4,0(s3)
    80002ad6:	102037b7          	lui	a5,0x10203
    80002ada:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ade:	02f71263          	bne	a4,a5,80002b02 <fsinit+0x70>
  initlog(dev, &sb);
    80002ae2:	00015597          	auipc	a1,0x15
    80002ae6:	c7658593          	addi	a1,a1,-906 # 80017758 <sb>
    80002aea:	854a                	mv	a0,s2
    80002aec:	00001097          	auipc	ra,0x1
    80002af0:	b4c080e7          	jalr	-1204(ra) # 80003638 <initlog>
}
    80002af4:	70a2                	ld	ra,40(sp)
    80002af6:	7402                	ld	s0,32(sp)
    80002af8:	64e2                	ld	s1,24(sp)
    80002afa:	6942                	ld	s2,16(sp)
    80002afc:	69a2                	ld	s3,8(sp)
    80002afe:	6145                	addi	sp,sp,48
    80002b00:	8082                	ret
    panic("invalid file system");
    80002b02:	00006517          	auipc	a0,0x6
    80002b06:	94e50513          	addi	a0,a0,-1714 # 80008450 <etext+0x450>
    80002b0a:	00003097          	auipc	ra,0x3
    80002b0e:	28a080e7          	jalr	650(ra) # 80005d94 <panic>

0000000080002b12 <iinit>:
{
    80002b12:	7179                	addi	sp,sp,-48
    80002b14:	f406                	sd	ra,40(sp)
    80002b16:	f022                	sd	s0,32(sp)
    80002b18:	ec26                	sd	s1,24(sp)
    80002b1a:	e84a                	sd	s2,16(sp)
    80002b1c:	e44e                	sd	s3,8(sp)
    80002b1e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b20:	00006597          	auipc	a1,0x6
    80002b24:	94858593          	addi	a1,a1,-1720 # 80008468 <etext+0x468>
    80002b28:	00015517          	auipc	a0,0x15
    80002b2c:	c5050513          	addi	a0,a0,-944 # 80017778 <itable>
    80002b30:	00003097          	auipc	ra,0x3
    80002b34:	710080e7          	jalr	1808(ra) # 80006240 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b38:	00015497          	auipc	s1,0x15
    80002b3c:	c6848493          	addi	s1,s1,-920 # 800177a0 <itable+0x28>
    80002b40:	00016997          	auipc	s3,0x16
    80002b44:	6f098993          	addi	s3,s3,1776 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b48:	00006917          	auipc	s2,0x6
    80002b4c:	92890913          	addi	s2,s2,-1752 # 80008470 <etext+0x470>
    80002b50:	85ca                	mv	a1,s2
    80002b52:	8526                	mv	a0,s1
    80002b54:	00001097          	auipc	ra,0x1
    80002b58:	e46080e7          	jalr	-442(ra) # 8000399a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b5c:	08848493          	addi	s1,s1,136
    80002b60:	ff3498e3          	bne	s1,s3,80002b50 <iinit+0x3e>
}
    80002b64:	70a2                	ld	ra,40(sp)
    80002b66:	7402                	ld	s0,32(sp)
    80002b68:	64e2                	ld	s1,24(sp)
    80002b6a:	6942                	ld	s2,16(sp)
    80002b6c:	69a2                	ld	s3,8(sp)
    80002b6e:	6145                	addi	sp,sp,48
    80002b70:	8082                	ret

0000000080002b72 <ialloc>:
{
    80002b72:	715d                	addi	sp,sp,-80
    80002b74:	e486                	sd	ra,72(sp)
    80002b76:	e0a2                	sd	s0,64(sp)
    80002b78:	fc26                	sd	s1,56(sp)
    80002b7a:	f84a                	sd	s2,48(sp)
    80002b7c:	f44e                	sd	s3,40(sp)
    80002b7e:	f052                	sd	s4,32(sp)
    80002b80:	ec56                	sd	s5,24(sp)
    80002b82:	e85a                	sd	s6,16(sp)
    80002b84:	e45e                	sd	s7,8(sp)
    80002b86:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b88:	00015717          	auipc	a4,0x15
    80002b8c:	bdc72703          	lw	a4,-1060(a4) # 80017764 <sb+0xc>
    80002b90:	4785                	li	a5,1
    80002b92:	04e7fa63          	bgeu	a5,a4,80002be6 <ialloc+0x74>
    80002b96:	8aaa                	mv	s5,a0
    80002b98:	8bae                	mv	s7,a1
    80002b9a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b9c:	00015a17          	auipc	s4,0x15
    80002ba0:	bbca0a13          	addi	s4,s4,-1092 # 80017758 <sb>
    80002ba4:	00048b1b          	sext.w	s6,s1
    80002ba8:	0044d793          	srli	a5,s1,0x4
    80002bac:	018a2583          	lw	a1,24(s4)
    80002bb0:	9dbd                	addw	a1,a1,a5
    80002bb2:	8556                	mv	a0,s5
    80002bb4:	00000097          	auipc	ra,0x0
    80002bb8:	954080e7          	jalr	-1708(ra) # 80002508 <bread>
    80002bbc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bbe:	05850993          	addi	s3,a0,88
    80002bc2:	00f4f793          	andi	a5,s1,15
    80002bc6:	079a                	slli	a5,a5,0x6
    80002bc8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bca:	00099783          	lh	a5,0(s3)
    80002bce:	c785                	beqz	a5,80002bf6 <ialloc+0x84>
    brelse(bp);
    80002bd0:	00000097          	auipc	ra,0x0
    80002bd4:	a68080e7          	jalr	-1432(ra) # 80002638 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bd8:	0485                	addi	s1,s1,1
    80002bda:	00ca2703          	lw	a4,12(s4)
    80002bde:	0004879b          	sext.w	a5,s1
    80002be2:	fce7e1e3          	bltu	a5,a4,80002ba4 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002be6:	00006517          	auipc	a0,0x6
    80002bea:	89250513          	addi	a0,a0,-1902 # 80008478 <etext+0x478>
    80002bee:	00003097          	auipc	ra,0x3
    80002bf2:	1a6080e7          	jalr	422(ra) # 80005d94 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bf6:	04000613          	li	a2,64
    80002bfa:	4581                	li	a1,0
    80002bfc:	854e                	mv	a0,s3
    80002bfe:	ffffd097          	auipc	ra,0xffffd
    80002c02:	57a080e7          	jalr	1402(ra) # 80000178 <memset>
      dip->type = type;
    80002c06:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	00001097          	auipc	ra,0x1
    80002c10:	ca8080e7          	jalr	-856(ra) # 800038b4 <log_write>
      brelse(bp);
    80002c14:	854a                	mv	a0,s2
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	a22080e7          	jalr	-1502(ra) # 80002638 <brelse>
      return iget(dev, inum);
    80002c1e:	85da                	mv	a1,s6
    80002c20:	8556                	mv	a0,s5
    80002c22:	00000097          	auipc	ra,0x0
    80002c26:	db4080e7          	jalr	-588(ra) # 800029d6 <iget>
}
    80002c2a:	60a6                	ld	ra,72(sp)
    80002c2c:	6406                	ld	s0,64(sp)
    80002c2e:	74e2                	ld	s1,56(sp)
    80002c30:	7942                	ld	s2,48(sp)
    80002c32:	79a2                	ld	s3,40(sp)
    80002c34:	7a02                	ld	s4,32(sp)
    80002c36:	6ae2                	ld	s5,24(sp)
    80002c38:	6b42                	ld	s6,16(sp)
    80002c3a:	6ba2                	ld	s7,8(sp)
    80002c3c:	6161                	addi	sp,sp,80
    80002c3e:	8082                	ret

0000000080002c40 <iupdate>:
{
    80002c40:	1101                	addi	sp,sp,-32
    80002c42:	ec06                	sd	ra,24(sp)
    80002c44:	e822                	sd	s0,16(sp)
    80002c46:	e426                	sd	s1,8(sp)
    80002c48:	e04a                	sd	s2,0(sp)
    80002c4a:	1000                	addi	s0,sp,32
    80002c4c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c4e:	415c                	lw	a5,4(a0)
    80002c50:	0047d79b          	srliw	a5,a5,0x4
    80002c54:	00015597          	auipc	a1,0x15
    80002c58:	b1c5a583          	lw	a1,-1252(a1) # 80017770 <sb+0x18>
    80002c5c:	9dbd                	addw	a1,a1,a5
    80002c5e:	4108                	lw	a0,0(a0)
    80002c60:	00000097          	auipc	ra,0x0
    80002c64:	8a8080e7          	jalr	-1880(ra) # 80002508 <bread>
    80002c68:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c6a:	05850793          	addi	a5,a0,88
    80002c6e:	40c8                	lw	a0,4(s1)
    80002c70:	893d                	andi	a0,a0,15
    80002c72:	051a                	slli	a0,a0,0x6
    80002c74:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c76:	04449703          	lh	a4,68(s1)
    80002c7a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c7e:	04649703          	lh	a4,70(s1)
    80002c82:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c86:	04849703          	lh	a4,72(s1)
    80002c8a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c8e:	04a49703          	lh	a4,74(s1)
    80002c92:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c96:	44f8                	lw	a4,76(s1)
    80002c98:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c9a:	03400613          	li	a2,52
    80002c9e:	05048593          	addi	a1,s1,80
    80002ca2:	0531                	addi	a0,a0,12
    80002ca4:	ffffd097          	auipc	ra,0xffffd
    80002ca8:	530080e7          	jalr	1328(ra) # 800001d4 <memmove>
  log_write(bp);
    80002cac:	854a                	mv	a0,s2
    80002cae:	00001097          	auipc	ra,0x1
    80002cb2:	c06080e7          	jalr	-1018(ra) # 800038b4 <log_write>
  brelse(bp);
    80002cb6:	854a                	mv	a0,s2
    80002cb8:	00000097          	auipc	ra,0x0
    80002cbc:	980080e7          	jalr	-1664(ra) # 80002638 <brelse>
}
    80002cc0:	60e2                	ld	ra,24(sp)
    80002cc2:	6442                	ld	s0,16(sp)
    80002cc4:	64a2                	ld	s1,8(sp)
    80002cc6:	6902                	ld	s2,0(sp)
    80002cc8:	6105                	addi	sp,sp,32
    80002cca:	8082                	ret

0000000080002ccc <idup>:
{
    80002ccc:	1101                	addi	sp,sp,-32
    80002cce:	ec06                	sd	ra,24(sp)
    80002cd0:	e822                	sd	s0,16(sp)
    80002cd2:	e426                	sd	s1,8(sp)
    80002cd4:	1000                	addi	s0,sp,32
    80002cd6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cd8:	00015517          	auipc	a0,0x15
    80002cdc:	aa050513          	addi	a0,a0,-1376 # 80017778 <itable>
    80002ce0:	00003097          	auipc	ra,0x3
    80002ce4:	5f0080e7          	jalr	1520(ra) # 800062d0 <acquire>
  ip->ref++;
    80002ce8:	449c                	lw	a5,8(s1)
    80002cea:	2785                	addiw	a5,a5,1
    80002cec:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cee:	00015517          	auipc	a0,0x15
    80002cf2:	a8a50513          	addi	a0,a0,-1398 # 80017778 <itable>
    80002cf6:	00003097          	auipc	ra,0x3
    80002cfa:	68e080e7          	jalr	1678(ra) # 80006384 <release>
}
    80002cfe:	8526                	mv	a0,s1
    80002d00:	60e2                	ld	ra,24(sp)
    80002d02:	6442                	ld	s0,16(sp)
    80002d04:	64a2                	ld	s1,8(sp)
    80002d06:	6105                	addi	sp,sp,32
    80002d08:	8082                	ret

0000000080002d0a <ilock>:
{
    80002d0a:	1101                	addi	sp,sp,-32
    80002d0c:	ec06                	sd	ra,24(sp)
    80002d0e:	e822                	sd	s0,16(sp)
    80002d10:	e426                	sd	s1,8(sp)
    80002d12:	e04a                	sd	s2,0(sp)
    80002d14:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d16:	c115                	beqz	a0,80002d3a <ilock+0x30>
    80002d18:	84aa                	mv	s1,a0
    80002d1a:	451c                	lw	a5,8(a0)
    80002d1c:	00f05f63          	blez	a5,80002d3a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d20:	0541                	addi	a0,a0,16
    80002d22:	00001097          	auipc	ra,0x1
    80002d26:	cb2080e7          	jalr	-846(ra) # 800039d4 <acquiresleep>
  if(ip->valid == 0){
    80002d2a:	40bc                	lw	a5,64(s1)
    80002d2c:	cf99                	beqz	a5,80002d4a <ilock+0x40>
}
    80002d2e:	60e2                	ld	ra,24(sp)
    80002d30:	6442                	ld	s0,16(sp)
    80002d32:	64a2                	ld	s1,8(sp)
    80002d34:	6902                	ld	s2,0(sp)
    80002d36:	6105                	addi	sp,sp,32
    80002d38:	8082                	ret
    panic("ilock");
    80002d3a:	00005517          	auipc	a0,0x5
    80002d3e:	75650513          	addi	a0,a0,1878 # 80008490 <etext+0x490>
    80002d42:	00003097          	auipc	ra,0x3
    80002d46:	052080e7          	jalr	82(ra) # 80005d94 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d4a:	40dc                	lw	a5,4(s1)
    80002d4c:	0047d79b          	srliw	a5,a5,0x4
    80002d50:	00015597          	auipc	a1,0x15
    80002d54:	a205a583          	lw	a1,-1504(a1) # 80017770 <sb+0x18>
    80002d58:	9dbd                	addw	a1,a1,a5
    80002d5a:	4088                	lw	a0,0(s1)
    80002d5c:	fffff097          	auipc	ra,0xfffff
    80002d60:	7ac080e7          	jalr	1964(ra) # 80002508 <bread>
    80002d64:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d66:	05850593          	addi	a1,a0,88
    80002d6a:	40dc                	lw	a5,4(s1)
    80002d6c:	8bbd                	andi	a5,a5,15
    80002d6e:	079a                	slli	a5,a5,0x6
    80002d70:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d72:	00059783          	lh	a5,0(a1)
    80002d76:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d7a:	00259783          	lh	a5,2(a1)
    80002d7e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d82:	00459783          	lh	a5,4(a1)
    80002d86:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d8a:	00659783          	lh	a5,6(a1)
    80002d8e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d92:	459c                	lw	a5,8(a1)
    80002d94:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d96:	03400613          	li	a2,52
    80002d9a:	05b1                	addi	a1,a1,12
    80002d9c:	05048513          	addi	a0,s1,80
    80002da0:	ffffd097          	auipc	ra,0xffffd
    80002da4:	434080e7          	jalr	1076(ra) # 800001d4 <memmove>
    brelse(bp);
    80002da8:	854a                	mv	a0,s2
    80002daa:	00000097          	auipc	ra,0x0
    80002dae:	88e080e7          	jalr	-1906(ra) # 80002638 <brelse>
    ip->valid = 1;
    80002db2:	4785                	li	a5,1
    80002db4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002db6:	04449783          	lh	a5,68(s1)
    80002dba:	fbb5                	bnez	a5,80002d2e <ilock+0x24>
      panic("ilock: no type");
    80002dbc:	00005517          	auipc	a0,0x5
    80002dc0:	6dc50513          	addi	a0,a0,1756 # 80008498 <etext+0x498>
    80002dc4:	00003097          	auipc	ra,0x3
    80002dc8:	fd0080e7          	jalr	-48(ra) # 80005d94 <panic>

0000000080002dcc <iunlock>:
{
    80002dcc:	1101                	addi	sp,sp,-32
    80002dce:	ec06                	sd	ra,24(sp)
    80002dd0:	e822                	sd	s0,16(sp)
    80002dd2:	e426                	sd	s1,8(sp)
    80002dd4:	e04a                	sd	s2,0(sp)
    80002dd6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dd8:	c905                	beqz	a0,80002e08 <iunlock+0x3c>
    80002dda:	84aa                	mv	s1,a0
    80002ddc:	01050913          	addi	s2,a0,16
    80002de0:	854a                	mv	a0,s2
    80002de2:	00001097          	auipc	ra,0x1
    80002de6:	c8c080e7          	jalr	-884(ra) # 80003a6e <holdingsleep>
    80002dea:	cd19                	beqz	a0,80002e08 <iunlock+0x3c>
    80002dec:	449c                	lw	a5,8(s1)
    80002dee:	00f05d63          	blez	a5,80002e08 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002df2:	854a                	mv	a0,s2
    80002df4:	00001097          	auipc	ra,0x1
    80002df8:	c36080e7          	jalr	-970(ra) # 80003a2a <releasesleep>
}
    80002dfc:	60e2                	ld	ra,24(sp)
    80002dfe:	6442                	ld	s0,16(sp)
    80002e00:	64a2                	ld	s1,8(sp)
    80002e02:	6902                	ld	s2,0(sp)
    80002e04:	6105                	addi	sp,sp,32
    80002e06:	8082                	ret
    panic("iunlock");
    80002e08:	00005517          	auipc	a0,0x5
    80002e0c:	6a050513          	addi	a0,a0,1696 # 800084a8 <etext+0x4a8>
    80002e10:	00003097          	auipc	ra,0x3
    80002e14:	f84080e7          	jalr	-124(ra) # 80005d94 <panic>

0000000080002e18 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e18:	7179                	addi	sp,sp,-48
    80002e1a:	f406                	sd	ra,40(sp)
    80002e1c:	f022                	sd	s0,32(sp)
    80002e1e:	ec26                	sd	s1,24(sp)
    80002e20:	e84a                	sd	s2,16(sp)
    80002e22:	e44e                	sd	s3,8(sp)
    80002e24:	e052                	sd	s4,0(sp)
    80002e26:	1800                	addi	s0,sp,48
    80002e28:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e2a:	05050493          	addi	s1,a0,80
    80002e2e:	08050913          	addi	s2,a0,128
    80002e32:	a021                	j	80002e3a <itrunc+0x22>
    80002e34:	0491                	addi	s1,s1,4
    80002e36:	01248d63          	beq	s1,s2,80002e50 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e3a:	408c                	lw	a1,0(s1)
    80002e3c:	dde5                	beqz	a1,80002e34 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e3e:	0009a503          	lw	a0,0(s3)
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	90c080e7          	jalr	-1780(ra) # 8000274e <bfree>
      ip->addrs[i] = 0;
    80002e4a:	0004a023          	sw	zero,0(s1)
    80002e4e:	b7dd                	j	80002e34 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e50:	0809a583          	lw	a1,128(s3)
    80002e54:	e185                	bnez	a1,80002e74 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e56:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e5a:	854e                	mv	a0,s3
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	de4080e7          	jalr	-540(ra) # 80002c40 <iupdate>
}
    80002e64:	70a2                	ld	ra,40(sp)
    80002e66:	7402                	ld	s0,32(sp)
    80002e68:	64e2                	ld	s1,24(sp)
    80002e6a:	6942                	ld	s2,16(sp)
    80002e6c:	69a2                	ld	s3,8(sp)
    80002e6e:	6a02                	ld	s4,0(sp)
    80002e70:	6145                	addi	sp,sp,48
    80002e72:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e74:	0009a503          	lw	a0,0(s3)
    80002e78:	fffff097          	auipc	ra,0xfffff
    80002e7c:	690080e7          	jalr	1680(ra) # 80002508 <bread>
    80002e80:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e82:	05850493          	addi	s1,a0,88
    80002e86:	45850913          	addi	s2,a0,1112
    80002e8a:	a021                	j	80002e92 <itrunc+0x7a>
    80002e8c:	0491                	addi	s1,s1,4
    80002e8e:	01248b63          	beq	s1,s2,80002ea4 <itrunc+0x8c>
      if(a[j])
    80002e92:	408c                	lw	a1,0(s1)
    80002e94:	dde5                	beqz	a1,80002e8c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e96:	0009a503          	lw	a0,0(s3)
    80002e9a:	00000097          	auipc	ra,0x0
    80002e9e:	8b4080e7          	jalr	-1868(ra) # 8000274e <bfree>
    80002ea2:	b7ed                	j	80002e8c <itrunc+0x74>
    brelse(bp);
    80002ea4:	8552                	mv	a0,s4
    80002ea6:	fffff097          	auipc	ra,0xfffff
    80002eaa:	792080e7          	jalr	1938(ra) # 80002638 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002eae:	0809a583          	lw	a1,128(s3)
    80002eb2:	0009a503          	lw	a0,0(s3)
    80002eb6:	00000097          	auipc	ra,0x0
    80002eba:	898080e7          	jalr	-1896(ra) # 8000274e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ebe:	0809a023          	sw	zero,128(s3)
    80002ec2:	bf51                	j	80002e56 <itrunc+0x3e>

0000000080002ec4 <iput>:
{
    80002ec4:	1101                	addi	sp,sp,-32
    80002ec6:	ec06                	sd	ra,24(sp)
    80002ec8:	e822                	sd	s0,16(sp)
    80002eca:	e426                	sd	s1,8(sp)
    80002ecc:	e04a                	sd	s2,0(sp)
    80002ece:	1000                	addi	s0,sp,32
    80002ed0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ed2:	00015517          	auipc	a0,0x15
    80002ed6:	8a650513          	addi	a0,a0,-1882 # 80017778 <itable>
    80002eda:	00003097          	auipc	ra,0x3
    80002ede:	3f6080e7          	jalr	1014(ra) # 800062d0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ee2:	4498                	lw	a4,8(s1)
    80002ee4:	4785                	li	a5,1
    80002ee6:	02f70363          	beq	a4,a5,80002f0c <iput+0x48>
  ip->ref--;
    80002eea:	449c                	lw	a5,8(s1)
    80002eec:	37fd                	addiw	a5,a5,-1
    80002eee:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ef0:	00015517          	auipc	a0,0x15
    80002ef4:	88850513          	addi	a0,a0,-1912 # 80017778 <itable>
    80002ef8:	00003097          	auipc	ra,0x3
    80002efc:	48c080e7          	jalr	1164(ra) # 80006384 <release>
}
    80002f00:	60e2                	ld	ra,24(sp)
    80002f02:	6442                	ld	s0,16(sp)
    80002f04:	64a2                	ld	s1,8(sp)
    80002f06:	6902                	ld	s2,0(sp)
    80002f08:	6105                	addi	sp,sp,32
    80002f0a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f0c:	40bc                	lw	a5,64(s1)
    80002f0e:	dff1                	beqz	a5,80002eea <iput+0x26>
    80002f10:	04a49783          	lh	a5,74(s1)
    80002f14:	fbf9                	bnez	a5,80002eea <iput+0x26>
    acquiresleep(&ip->lock);
    80002f16:	01048913          	addi	s2,s1,16
    80002f1a:	854a                	mv	a0,s2
    80002f1c:	00001097          	auipc	ra,0x1
    80002f20:	ab8080e7          	jalr	-1352(ra) # 800039d4 <acquiresleep>
    release(&itable.lock);
    80002f24:	00015517          	auipc	a0,0x15
    80002f28:	85450513          	addi	a0,a0,-1964 # 80017778 <itable>
    80002f2c:	00003097          	auipc	ra,0x3
    80002f30:	458080e7          	jalr	1112(ra) # 80006384 <release>
    itrunc(ip);
    80002f34:	8526                	mv	a0,s1
    80002f36:	00000097          	auipc	ra,0x0
    80002f3a:	ee2080e7          	jalr	-286(ra) # 80002e18 <itrunc>
    ip->type = 0;
    80002f3e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f42:	8526                	mv	a0,s1
    80002f44:	00000097          	auipc	ra,0x0
    80002f48:	cfc080e7          	jalr	-772(ra) # 80002c40 <iupdate>
    ip->valid = 0;
    80002f4c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f50:	854a                	mv	a0,s2
    80002f52:	00001097          	auipc	ra,0x1
    80002f56:	ad8080e7          	jalr	-1320(ra) # 80003a2a <releasesleep>
    acquire(&itable.lock);
    80002f5a:	00015517          	auipc	a0,0x15
    80002f5e:	81e50513          	addi	a0,a0,-2018 # 80017778 <itable>
    80002f62:	00003097          	auipc	ra,0x3
    80002f66:	36e080e7          	jalr	878(ra) # 800062d0 <acquire>
    80002f6a:	b741                	j	80002eea <iput+0x26>

0000000080002f6c <iunlockput>:
{
    80002f6c:	1101                	addi	sp,sp,-32
    80002f6e:	ec06                	sd	ra,24(sp)
    80002f70:	e822                	sd	s0,16(sp)
    80002f72:	e426                	sd	s1,8(sp)
    80002f74:	1000                	addi	s0,sp,32
    80002f76:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f78:	00000097          	auipc	ra,0x0
    80002f7c:	e54080e7          	jalr	-428(ra) # 80002dcc <iunlock>
  iput(ip);
    80002f80:	8526                	mv	a0,s1
    80002f82:	00000097          	auipc	ra,0x0
    80002f86:	f42080e7          	jalr	-190(ra) # 80002ec4 <iput>
}
    80002f8a:	60e2                	ld	ra,24(sp)
    80002f8c:	6442                	ld	s0,16(sp)
    80002f8e:	64a2                	ld	s1,8(sp)
    80002f90:	6105                	addi	sp,sp,32
    80002f92:	8082                	ret

0000000080002f94 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f94:	1141                	addi	sp,sp,-16
    80002f96:	e422                	sd	s0,8(sp)
    80002f98:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f9a:	411c                	lw	a5,0(a0)
    80002f9c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f9e:	415c                	lw	a5,4(a0)
    80002fa0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fa2:	04451783          	lh	a5,68(a0)
    80002fa6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002faa:	04a51783          	lh	a5,74(a0)
    80002fae:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fb2:	04c56783          	lwu	a5,76(a0)
    80002fb6:	e99c                	sd	a5,16(a1)
}
    80002fb8:	6422                	ld	s0,8(sp)
    80002fba:	0141                	addi	sp,sp,16
    80002fbc:	8082                	ret

0000000080002fbe <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fbe:	457c                	lw	a5,76(a0)
    80002fc0:	0ed7e963          	bltu	a5,a3,800030b2 <readi+0xf4>
{
    80002fc4:	7159                	addi	sp,sp,-112
    80002fc6:	f486                	sd	ra,104(sp)
    80002fc8:	f0a2                	sd	s0,96(sp)
    80002fca:	eca6                	sd	s1,88(sp)
    80002fcc:	e8ca                	sd	s2,80(sp)
    80002fce:	e4ce                	sd	s3,72(sp)
    80002fd0:	e0d2                	sd	s4,64(sp)
    80002fd2:	fc56                	sd	s5,56(sp)
    80002fd4:	f85a                	sd	s6,48(sp)
    80002fd6:	f45e                	sd	s7,40(sp)
    80002fd8:	f062                	sd	s8,32(sp)
    80002fda:	ec66                	sd	s9,24(sp)
    80002fdc:	e86a                	sd	s10,16(sp)
    80002fde:	e46e                	sd	s11,8(sp)
    80002fe0:	1880                	addi	s0,sp,112
    80002fe2:	8baa                	mv	s7,a0
    80002fe4:	8c2e                	mv	s8,a1
    80002fe6:	8ab2                	mv	s5,a2
    80002fe8:	84b6                	mv	s1,a3
    80002fea:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fec:	9f35                	addw	a4,a4,a3
    return 0;
    80002fee:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ff0:	0ad76063          	bltu	a4,a3,80003090 <readi+0xd2>
  if(off + n > ip->size)
    80002ff4:	00e7f463          	bgeu	a5,a4,80002ffc <readi+0x3e>
    n = ip->size - off;
    80002ff8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ffc:	0a0b0963          	beqz	s6,800030ae <readi+0xf0>
    80003000:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003002:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003006:	5cfd                	li	s9,-1
    80003008:	a82d                	j	80003042 <readi+0x84>
    8000300a:	020a1d93          	slli	s11,s4,0x20
    8000300e:	020ddd93          	srli	s11,s11,0x20
    80003012:	05890793          	addi	a5,s2,88
    80003016:	86ee                	mv	a3,s11
    80003018:	963e                	add	a2,a2,a5
    8000301a:	85d6                	mv	a1,s5
    8000301c:	8562                	mv	a0,s8
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	a1e080e7          	jalr	-1506(ra) # 80001a3c <either_copyout>
    80003026:	05950d63          	beq	a0,s9,80003080 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000302a:	854a                	mv	a0,s2
    8000302c:	fffff097          	auipc	ra,0xfffff
    80003030:	60c080e7          	jalr	1548(ra) # 80002638 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003034:	013a09bb          	addw	s3,s4,s3
    80003038:	009a04bb          	addw	s1,s4,s1
    8000303c:	9aee                	add	s5,s5,s11
    8000303e:	0569f763          	bgeu	s3,s6,8000308c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003042:	000ba903          	lw	s2,0(s7)
    80003046:	00a4d59b          	srliw	a1,s1,0xa
    8000304a:	855e                	mv	a0,s7
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	8b0080e7          	jalr	-1872(ra) # 800028fc <bmap>
    80003054:	0005059b          	sext.w	a1,a0
    80003058:	854a                	mv	a0,s2
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	4ae080e7          	jalr	1198(ra) # 80002508 <bread>
    80003062:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003064:	3ff4f613          	andi	a2,s1,1023
    80003068:	40cd07bb          	subw	a5,s10,a2
    8000306c:	413b073b          	subw	a4,s6,s3
    80003070:	8a3e                	mv	s4,a5
    80003072:	2781                	sext.w	a5,a5
    80003074:	0007069b          	sext.w	a3,a4
    80003078:	f8f6f9e3          	bgeu	a3,a5,8000300a <readi+0x4c>
    8000307c:	8a3a                	mv	s4,a4
    8000307e:	b771                	j	8000300a <readi+0x4c>
      brelse(bp);
    80003080:	854a                	mv	a0,s2
    80003082:	fffff097          	auipc	ra,0xfffff
    80003086:	5b6080e7          	jalr	1462(ra) # 80002638 <brelse>
      tot = -1;
    8000308a:	59fd                	li	s3,-1
  }
  return tot;
    8000308c:	0009851b          	sext.w	a0,s3
}
    80003090:	70a6                	ld	ra,104(sp)
    80003092:	7406                	ld	s0,96(sp)
    80003094:	64e6                	ld	s1,88(sp)
    80003096:	6946                	ld	s2,80(sp)
    80003098:	69a6                	ld	s3,72(sp)
    8000309a:	6a06                	ld	s4,64(sp)
    8000309c:	7ae2                	ld	s5,56(sp)
    8000309e:	7b42                	ld	s6,48(sp)
    800030a0:	7ba2                	ld	s7,40(sp)
    800030a2:	7c02                	ld	s8,32(sp)
    800030a4:	6ce2                	ld	s9,24(sp)
    800030a6:	6d42                	ld	s10,16(sp)
    800030a8:	6da2                	ld	s11,8(sp)
    800030aa:	6165                	addi	sp,sp,112
    800030ac:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030ae:	89da                	mv	s3,s6
    800030b0:	bff1                	j	8000308c <readi+0xce>
    return 0;
    800030b2:	4501                	li	a0,0
}
    800030b4:	8082                	ret

00000000800030b6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030b6:	457c                	lw	a5,76(a0)
    800030b8:	10d7e863          	bltu	a5,a3,800031c8 <writei+0x112>
{
    800030bc:	7159                	addi	sp,sp,-112
    800030be:	f486                	sd	ra,104(sp)
    800030c0:	f0a2                	sd	s0,96(sp)
    800030c2:	eca6                	sd	s1,88(sp)
    800030c4:	e8ca                	sd	s2,80(sp)
    800030c6:	e4ce                	sd	s3,72(sp)
    800030c8:	e0d2                	sd	s4,64(sp)
    800030ca:	fc56                	sd	s5,56(sp)
    800030cc:	f85a                	sd	s6,48(sp)
    800030ce:	f45e                	sd	s7,40(sp)
    800030d0:	f062                	sd	s8,32(sp)
    800030d2:	ec66                	sd	s9,24(sp)
    800030d4:	e86a                	sd	s10,16(sp)
    800030d6:	e46e                	sd	s11,8(sp)
    800030d8:	1880                	addi	s0,sp,112
    800030da:	8b2a                	mv	s6,a0
    800030dc:	8c2e                	mv	s8,a1
    800030de:	8ab2                	mv	s5,a2
    800030e0:	8936                	mv	s2,a3
    800030e2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030e4:	00e687bb          	addw	a5,a3,a4
    800030e8:	0ed7e263          	bltu	a5,a3,800031cc <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030ec:	00043737          	lui	a4,0x43
    800030f0:	0ef76063          	bltu	a4,a5,800031d0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f4:	0c0b8863          	beqz	s7,800031c4 <writei+0x10e>
    800030f8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030fa:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030fe:	5cfd                	li	s9,-1
    80003100:	a091                	j	80003144 <writei+0x8e>
    80003102:	02099d93          	slli	s11,s3,0x20
    80003106:	020ddd93          	srli	s11,s11,0x20
    8000310a:	05848793          	addi	a5,s1,88
    8000310e:	86ee                	mv	a3,s11
    80003110:	8656                	mv	a2,s5
    80003112:	85e2                	mv	a1,s8
    80003114:	953e                	add	a0,a0,a5
    80003116:	fffff097          	auipc	ra,0xfffff
    8000311a:	97c080e7          	jalr	-1668(ra) # 80001a92 <either_copyin>
    8000311e:	07950263          	beq	a0,s9,80003182 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003122:	8526                	mv	a0,s1
    80003124:	00000097          	auipc	ra,0x0
    80003128:	790080e7          	jalr	1936(ra) # 800038b4 <log_write>
    brelse(bp);
    8000312c:	8526                	mv	a0,s1
    8000312e:	fffff097          	auipc	ra,0xfffff
    80003132:	50a080e7          	jalr	1290(ra) # 80002638 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003136:	01498a3b          	addw	s4,s3,s4
    8000313a:	0129893b          	addw	s2,s3,s2
    8000313e:	9aee                	add	s5,s5,s11
    80003140:	057a7663          	bgeu	s4,s7,8000318c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003144:	000b2483          	lw	s1,0(s6)
    80003148:	00a9559b          	srliw	a1,s2,0xa
    8000314c:	855a                	mv	a0,s6
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	7ae080e7          	jalr	1966(ra) # 800028fc <bmap>
    80003156:	0005059b          	sext.w	a1,a0
    8000315a:	8526                	mv	a0,s1
    8000315c:	fffff097          	auipc	ra,0xfffff
    80003160:	3ac080e7          	jalr	940(ra) # 80002508 <bread>
    80003164:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003166:	3ff97513          	andi	a0,s2,1023
    8000316a:	40ad07bb          	subw	a5,s10,a0
    8000316e:	414b873b          	subw	a4,s7,s4
    80003172:	89be                	mv	s3,a5
    80003174:	2781                	sext.w	a5,a5
    80003176:	0007069b          	sext.w	a3,a4
    8000317a:	f8f6f4e3          	bgeu	a3,a5,80003102 <writei+0x4c>
    8000317e:	89ba                	mv	s3,a4
    80003180:	b749                	j	80003102 <writei+0x4c>
      brelse(bp);
    80003182:	8526                	mv	a0,s1
    80003184:	fffff097          	auipc	ra,0xfffff
    80003188:	4b4080e7          	jalr	1204(ra) # 80002638 <brelse>
  }

  if(off > ip->size)
    8000318c:	04cb2783          	lw	a5,76(s6)
    80003190:	0127f463          	bgeu	a5,s2,80003198 <writei+0xe2>
    ip->size = off;
    80003194:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003198:	855a                	mv	a0,s6
    8000319a:	00000097          	auipc	ra,0x0
    8000319e:	aa6080e7          	jalr	-1370(ra) # 80002c40 <iupdate>

  return tot;
    800031a2:	000a051b          	sext.w	a0,s4
}
    800031a6:	70a6                	ld	ra,104(sp)
    800031a8:	7406                	ld	s0,96(sp)
    800031aa:	64e6                	ld	s1,88(sp)
    800031ac:	6946                	ld	s2,80(sp)
    800031ae:	69a6                	ld	s3,72(sp)
    800031b0:	6a06                	ld	s4,64(sp)
    800031b2:	7ae2                	ld	s5,56(sp)
    800031b4:	7b42                	ld	s6,48(sp)
    800031b6:	7ba2                	ld	s7,40(sp)
    800031b8:	7c02                	ld	s8,32(sp)
    800031ba:	6ce2                	ld	s9,24(sp)
    800031bc:	6d42                	ld	s10,16(sp)
    800031be:	6da2                	ld	s11,8(sp)
    800031c0:	6165                	addi	sp,sp,112
    800031c2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031c4:	8a5e                	mv	s4,s7
    800031c6:	bfc9                	j	80003198 <writei+0xe2>
    return -1;
    800031c8:	557d                	li	a0,-1
}
    800031ca:	8082                	ret
    return -1;
    800031cc:	557d                	li	a0,-1
    800031ce:	bfe1                	j	800031a6 <writei+0xf0>
    return -1;
    800031d0:	557d                	li	a0,-1
    800031d2:	bfd1                	j	800031a6 <writei+0xf0>

00000000800031d4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031d4:	1141                	addi	sp,sp,-16
    800031d6:	e406                	sd	ra,8(sp)
    800031d8:	e022                	sd	s0,0(sp)
    800031da:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031dc:	4639                	li	a2,14
    800031de:	ffffd097          	auipc	ra,0xffffd
    800031e2:	06a080e7          	jalr	106(ra) # 80000248 <strncmp>
}
    800031e6:	60a2                	ld	ra,8(sp)
    800031e8:	6402                	ld	s0,0(sp)
    800031ea:	0141                	addi	sp,sp,16
    800031ec:	8082                	ret

00000000800031ee <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031ee:	7139                	addi	sp,sp,-64
    800031f0:	fc06                	sd	ra,56(sp)
    800031f2:	f822                	sd	s0,48(sp)
    800031f4:	f426                	sd	s1,40(sp)
    800031f6:	f04a                	sd	s2,32(sp)
    800031f8:	ec4e                	sd	s3,24(sp)
    800031fa:	e852                	sd	s4,16(sp)
    800031fc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031fe:	04451703          	lh	a4,68(a0)
    80003202:	4785                	li	a5,1
    80003204:	00f71a63          	bne	a4,a5,80003218 <dirlookup+0x2a>
    80003208:	892a                	mv	s2,a0
    8000320a:	89ae                	mv	s3,a1
    8000320c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000320e:	457c                	lw	a5,76(a0)
    80003210:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003212:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003214:	e79d                	bnez	a5,80003242 <dirlookup+0x54>
    80003216:	a8a5                	j	8000328e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003218:	00005517          	auipc	a0,0x5
    8000321c:	29850513          	addi	a0,a0,664 # 800084b0 <etext+0x4b0>
    80003220:	00003097          	auipc	ra,0x3
    80003224:	b74080e7          	jalr	-1164(ra) # 80005d94 <panic>
      panic("dirlookup read");
    80003228:	00005517          	auipc	a0,0x5
    8000322c:	2a050513          	addi	a0,a0,672 # 800084c8 <etext+0x4c8>
    80003230:	00003097          	auipc	ra,0x3
    80003234:	b64080e7          	jalr	-1180(ra) # 80005d94 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003238:	24c1                	addiw	s1,s1,16
    8000323a:	04c92783          	lw	a5,76(s2)
    8000323e:	04f4f763          	bgeu	s1,a5,8000328c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003242:	4741                	li	a4,16
    80003244:	86a6                	mv	a3,s1
    80003246:	fc040613          	addi	a2,s0,-64
    8000324a:	4581                	li	a1,0
    8000324c:	854a                	mv	a0,s2
    8000324e:	00000097          	auipc	ra,0x0
    80003252:	d70080e7          	jalr	-656(ra) # 80002fbe <readi>
    80003256:	47c1                	li	a5,16
    80003258:	fcf518e3          	bne	a0,a5,80003228 <dirlookup+0x3a>
    if(de.inum == 0)
    8000325c:	fc045783          	lhu	a5,-64(s0)
    80003260:	dfe1                	beqz	a5,80003238 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003262:	fc240593          	addi	a1,s0,-62
    80003266:	854e                	mv	a0,s3
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	f6c080e7          	jalr	-148(ra) # 800031d4 <namecmp>
    80003270:	f561                	bnez	a0,80003238 <dirlookup+0x4a>
      if(poff)
    80003272:	000a0463          	beqz	s4,8000327a <dirlookup+0x8c>
        *poff = off;
    80003276:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000327a:	fc045583          	lhu	a1,-64(s0)
    8000327e:	00092503          	lw	a0,0(s2)
    80003282:	fffff097          	auipc	ra,0xfffff
    80003286:	754080e7          	jalr	1876(ra) # 800029d6 <iget>
    8000328a:	a011                	j	8000328e <dirlookup+0xa0>
  return 0;
    8000328c:	4501                	li	a0,0
}
    8000328e:	70e2                	ld	ra,56(sp)
    80003290:	7442                	ld	s0,48(sp)
    80003292:	74a2                	ld	s1,40(sp)
    80003294:	7902                	ld	s2,32(sp)
    80003296:	69e2                	ld	s3,24(sp)
    80003298:	6a42                	ld	s4,16(sp)
    8000329a:	6121                	addi	sp,sp,64
    8000329c:	8082                	ret

000000008000329e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000329e:	711d                	addi	sp,sp,-96
    800032a0:	ec86                	sd	ra,88(sp)
    800032a2:	e8a2                	sd	s0,80(sp)
    800032a4:	e4a6                	sd	s1,72(sp)
    800032a6:	e0ca                	sd	s2,64(sp)
    800032a8:	fc4e                	sd	s3,56(sp)
    800032aa:	f852                	sd	s4,48(sp)
    800032ac:	f456                	sd	s5,40(sp)
    800032ae:	f05a                	sd	s6,32(sp)
    800032b0:	ec5e                	sd	s7,24(sp)
    800032b2:	e862                	sd	s8,16(sp)
    800032b4:	e466                	sd	s9,8(sp)
    800032b6:	1080                	addi	s0,sp,96
    800032b8:	84aa                	mv	s1,a0
    800032ba:	8aae                	mv	s5,a1
    800032bc:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032be:	00054703          	lbu	a4,0(a0)
    800032c2:	02f00793          	li	a5,47
    800032c6:	02f70363          	beq	a4,a5,800032ec <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ca:	ffffe097          	auipc	ra,0xffffe
    800032ce:	c88080e7          	jalr	-888(ra) # 80000f52 <myproc>
    800032d2:	15053503          	ld	a0,336(a0)
    800032d6:	00000097          	auipc	ra,0x0
    800032da:	9f6080e7          	jalr	-1546(ra) # 80002ccc <idup>
    800032de:	89aa                	mv	s3,a0
  while(*path == '/')
    800032e0:	02f00913          	li	s2,47
  len = path - s;
    800032e4:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800032e6:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032e8:	4b85                	li	s7,1
    800032ea:	a865                	j	800033a2 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032ec:	4585                	li	a1,1
    800032ee:	4505                	li	a0,1
    800032f0:	fffff097          	auipc	ra,0xfffff
    800032f4:	6e6080e7          	jalr	1766(ra) # 800029d6 <iget>
    800032f8:	89aa                	mv	s3,a0
    800032fa:	b7dd                	j	800032e0 <namex+0x42>
      iunlockput(ip);
    800032fc:	854e                	mv	a0,s3
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	c6e080e7          	jalr	-914(ra) # 80002f6c <iunlockput>
      return 0;
    80003306:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003308:	854e                	mv	a0,s3
    8000330a:	60e6                	ld	ra,88(sp)
    8000330c:	6446                	ld	s0,80(sp)
    8000330e:	64a6                	ld	s1,72(sp)
    80003310:	6906                	ld	s2,64(sp)
    80003312:	79e2                	ld	s3,56(sp)
    80003314:	7a42                	ld	s4,48(sp)
    80003316:	7aa2                	ld	s5,40(sp)
    80003318:	7b02                	ld	s6,32(sp)
    8000331a:	6be2                	ld	s7,24(sp)
    8000331c:	6c42                	ld	s8,16(sp)
    8000331e:	6ca2                	ld	s9,8(sp)
    80003320:	6125                	addi	sp,sp,96
    80003322:	8082                	ret
      iunlock(ip);
    80003324:	854e                	mv	a0,s3
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	aa6080e7          	jalr	-1370(ra) # 80002dcc <iunlock>
      return ip;
    8000332e:	bfe9                	j	80003308 <namex+0x6a>
      iunlockput(ip);
    80003330:	854e                	mv	a0,s3
    80003332:	00000097          	auipc	ra,0x0
    80003336:	c3a080e7          	jalr	-966(ra) # 80002f6c <iunlockput>
      return 0;
    8000333a:	89e6                	mv	s3,s9
    8000333c:	b7f1                	j	80003308 <namex+0x6a>
  len = path - s;
    8000333e:	40b48633          	sub	a2,s1,a1
    80003342:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003346:	099c5463          	bge	s8,s9,800033ce <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000334a:	4639                	li	a2,14
    8000334c:	8552                	mv	a0,s4
    8000334e:	ffffd097          	auipc	ra,0xffffd
    80003352:	e86080e7          	jalr	-378(ra) # 800001d4 <memmove>
  while(*path == '/')
    80003356:	0004c783          	lbu	a5,0(s1)
    8000335a:	01279763          	bne	a5,s2,80003368 <namex+0xca>
    path++;
    8000335e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003360:	0004c783          	lbu	a5,0(s1)
    80003364:	ff278de3          	beq	a5,s2,8000335e <namex+0xc0>
    ilock(ip);
    80003368:	854e                	mv	a0,s3
    8000336a:	00000097          	auipc	ra,0x0
    8000336e:	9a0080e7          	jalr	-1632(ra) # 80002d0a <ilock>
    if(ip->type != T_DIR){
    80003372:	04499783          	lh	a5,68(s3)
    80003376:	f97793e3          	bne	a5,s7,800032fc <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000337a:	000a8563          	beqz	s5,80003384 <namex+0xe6>
    8000337e:	0004c783          	lbu	a5,0(s1)
    80003382:	d3cd                	beqz	a5,80003324 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003384:	865a                	mv	a2,s6
    80003386:	85d2                	mv	a1,s4
    80003388:	854e                	mv	a0,s3
    8000338a:	00000097          	auipc	ra,0x0
    8000338e:	e64080e7          	jalr	-412(ra) # 800031ee <dirlookup>
    80003392:	8caa                	mv	s9,a0
    80003394:	dd51                	beqz	a0,80003330 <namex+0x92>
    iunlockput(ip);
    80003396:	854e                	mv	a0,s3
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	bd4080e7          	jalr	-1068(ra) # 80002f6c <iunlockput>
    ip = next;
    800033a0:	89e6                	mv	s3,s9
  while(*path == '/')
    800033a2:	0004c783          	lbu	a5,0(s1)
    800033a6:	05279763          	bne	a5,s2,800033f4 <namex+0x156>
    path++;
    800033aa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033ac:	0004c783          	lbu	a5,0(s1)
    800033b0:	ff278de3          	beq	a5,s2,800033aa <namex+0x10c>
  if(*path == 0)
    800033b4:	c79d                	beqz	a5,800033e2 <namex+0x144>
    path++;
    800033b6:	85a6                	mv	a1,s1
  len = path - s;
    800033b8:	8cda                	mv	s9,s6
    800033ba:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800033bc:	01278963          	beq	a5,s2,800033ce <namex+0x130>
    800033c0:	dfbd                	beqz	a5,8000333e <namex+0xa0>
    path++;
    800033c2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033c4:	0004c783          	lbu	a5,0(s1)
    800033c8:	ff279ce3          	bne	a5,s2,800033c0 <namex+0x122>
    800033cc:	bf8d                	j	8000333e <namex+0xa0>
    memmove(name, s, len);
    800033ce:	2601                	sext.w	a2,a2
    800033d0:	8552                	mv	a0,s4
    800033d2:	ffffd097          	auipc	ra,0xffffd
    800033d6:	e02080e7          	jalr	-510(ra) # 800001d4 <memmove>
    name[len] = 0;
    800033da:	9cd2                	add	s9,s9,s4
    800033dc:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800033e0:	bf9d                	j	80003356 <namex+0xb8>
  if(nameiparent){
    800033e2:	f20a83e3          	beqz	s5,80003308 <namex+0x6a>
    iput(ip);
    800033e6:	854e                	mv	a0,s3
    800033e8:	00000097          	auipc	ra,0x0
    800033ec:	adc080e7          	jalr	-1316(ra) # 80002ec4 <iput>
    return 0;
    800033f0:	4981                	li	s3,0
    800033f2:	bf19                	j	80003308 <namex+0x6a>
  if(*path == 0)
    800033f4:	d7fd                	beqz	a5,800033e2 <namex+0x144>
  while(*path != '/' && *path != 0)
    800033f6:	0004c783          	lbu	a5,0(s1)
    800033fa:	85a6                	mv	a1,s1
    800033fc:	b7d1                	j	800033c0 <namex+0x122>

00000000800033fe <dirlink>:
{
    800033fe:	7139                	addi	sp,sp,-64
    80003400:	fc06                	sd	ra,56(sp)
    80003402:	f822                	sd	s0,48(sp)
    80003404:	f426                	sd	s1,40(sp)
    80003406:	f04a                	sd	s2,32(sp)
    80003408:	ec4e                	sd	s3,24(sp)
    8000340a:	e852                	sd	s4,16(sp)
    8000340c:	0080                	addi	s0,sp,64
    8000340e:	892a                	mv	s2,a0
    80003410:	8a2e                	mv	s4,a1
    80003412:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003414:	4601                	li	a2,0
    80003416:	00000097          	auipc	ra,0x0
    8000341a:	dd8080e7          	jalr	-552(ra) # 800031ee <dirlookup>
    8000341e:	e93d                	bnez	a0,80003494 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003420:	04c92483          	lw	s1,76(s2)
    80003424:	c49d                	beqz	s1,80003452 <dirlink+0x54>
    80003426:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003428:	4741                	li	a4,16
    8000342a:	86a6                	mv	a3,s1
    8000342c:	fc040613          	addi	a2,s0,-64
    80003430:	4581                	li	a1,0
    80003432:	854a                	mv	a0,s2
    80003434:	00000097          	auipc	ra,0x0
    80003438:	b8a080e7          	jalr	-1142(ra) # 80002fbe <readi>
    8000343c:	47c1                	li	a5,16
    8000343e:	06f51163          	bne	a0,a5,800034a0 <dirlink+0xa2>
    if(de.inum == 0)
    80003442:	fc045783          	lhu	a5,-64(s0)
    80003446:	c791                	beqz	a5,80003452 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003448:	24c1                	addiw	s1,s1,16
    8000344a:	04c92783          	lw	a5,76(s2)
    8000344e:	fcf4ede3          	bltu	s1,a5,80003428 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003452:	4639                	li	a2,14
    80003454:	85d2                	mv	a1,s4
    80003456:	fc240513          	addi	a0,s0,-62
    8000345a:	ffffd097          	auipc	ra,0xffffd
    8000345e:	e2a080e7          	jalr	-470(ra) # 80000284 <strncpy>
  de.inum = inum;
    80003462:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003466:	4741                	li	a4,16
    80003468:	86a6                	mv	a3,s1
    8000346a:	fc040613          	addi	a2,s0,-64
    8000346e:	4581                	li	a1,0
    80003470:	854a                	mv	a0,s2
    80003472:	00000097          	auipc	ra,0x0
    80003476:	c44080e7          	jalr	-956(ra) # 800030b6 <writei>
    8000347a:	872a                	mv	a4,a0
    8000347c:	47c1                	li	a5,16
  return 0;
    8000347e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003480:	02f71863          	bne	a4,a5,800034b0 <dirlink+0xb2>
}
    80003484:	70e2                	ld	ra,56(sp)
    80003486:	7442                	ld	s0,48(sp)
    80003488:	74a2                	ld	s1,40(sp)
    8000348a:	7902                	ld	s2,32(sp)
    8000348c:	69e2                	ld	s3,24(sp)
    8000348e:	6a42                	ld	s4,16(sp)
    80003490:	6121                	addi	sp,sp,64
    80003492:	8082                	ret
    iput(ip);
    80003494:	00000097          	auipc	ra,0x0
    80003498:	a30080e7          	jalr	-1488(ra) # 80002ec4 <iput>
    return -1;
    8000349c:	557d                	li	a0,-1
    8000349e:	b7dd                	j	80003484 <dirlink+0x86>
      panic("dirlink read");
    800034a0:	00005517          	auipc	a0,0x5
    800034a4:	03850513          	addi	a0,a0,56 # 800084d8 <etext+0x4d8>
    800034a8:	00003097          	auipc	ra,0x3
    800034ac:	8ec080e7          	jalr	-1812(ra) # 80005d94 <panic>
    panic("dirlink");
    800034b0:	00005517          	auipc	a0,0x5
    800034b4:	13850513          	addi	a0,a0,312 # 800085e8 <etext+0x5e8>
    800034b8:	00003097          	auipc	ra,0x3
    800034bc:	8dc080e7          	jalr	-1828(ra) # 80005d94 <panic>

00000000800034c0 <namei>:

struct inode*
namei(char *path)
{
    800034c0:	1101                	addi	sp,sp,-32
    800034c2:	ec06                	sd	ra,24(sp)
    800034c4:	e822                	sd	s0,16(sp)
    800034c6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034c8:	fe040613          	addi	a2,s0,-32
    800034cc:	4581                	li	a1,0
    800034ce:	00000097          	auipc	ra,0x0
    800034d2:	dd0080e7          	jalr	-560(ra) # 8000329e <namex>
}
    800034d6:	60e2                	ld	ra,24(sp)
    800034d8:	6442                	ld	s0,16(sp)
    800034da:	6105                	addi	sp,sp,32
    800034dc:	8082                	ret

00000000800034de <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034de:	1141                	addi	sp,sp,-16
    800034e0:	e406                	sd	ra,8(sp)
    800034e2:	e022                	sd	s0,0(sp)
    800034e4:	0800                	addi	s0,sp,16
    800034e6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034e8:	4585                	li	a1,1
    800034ea:	00000097          	auipc	ra,0x0
    800034ee:	db4080e7          	jalr	-588(ra) # 8000329e <namex>
}
    800034f2:	60a2                	ld	ra,8(sp)
    800034f4:	6402                	ld	s0,0(sp)
    800034f6:	0141                	addi	sp,sp,16
    800034f8:	8082                	ret

00000000800034fa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034fa:	1101                	addi	sp,sp,-32
    800034fc:	ec06                	sd	ra,24(sp)
    800034fe:	e822                	sd	s0,16(sp)
    80003500:	e426                	sd	s1,8(sp)
    80003502:	e04a                	sd	s2,0(sp)
    80003504:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003506:	00016917          	auipc	s2,0x16
    8000350a:	d1a90913          	addi	s2,s2,-742 # 80019220 <log>
    8000350e:	01892583          	lw	a1,24(s2)
    80003512:	02892503          	lw	a0,40(s2)
    80003516:	fffff097          	auipc	ra,0xfffff
    8000351a:	ff2080e7          	jalr	-14(ra) # 80002508 <bread>
    8000351e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003520:	02c92683          	lw	a3,44(s2)
    80003524:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003526:	02d05763          	blez	a3,80003554 <write_head+0x5a>
    8000352a:	00016797          	auipc	a5,0x16
    8000352e:	d2678793          	addi	a5,a5,-730 # 80019250 <log+0x30>
    80003532:	05c50713          	addi	a4,a0,92
    80003536:	36fd                	addiw	a3,a3,-1
    80003538:	1682                	slli	a3,a3,0x20
    8000353a:	9281                	srli	a3,a3,0x20
    8000353c:	068a                	slli	a3,a3,0x2
    8000353e:	00016617          	auipc	a2,0x16
    80003542:	d1660613          	addi	a2,a2,-746 # 80019254 <log+0x34>
    80003546:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003548:	4390                	lw	a2,0(a5)
    8000354a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000354c:	0791                	addi	a5,a5,4
    8000354e:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003550:	fed79ce3          	bne	a5,a3,80003548 <write_head+0x4e>
  }
  bwrite(buf);
    80003554:	8526                	mv	a0,s1
    80003556:	fffff097          	auipc	ra,0xfffff
    8000355a:	0a4080e7          	jalr	164(ra) # 800025fa <bwrite>
  brelse(buf);
    8000355e:	8526                	mv	a0,s1
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	0d8080e7          	jalr	216(ra) # 80002638 <brelse>
}
    80003568:	60e2                	ld	ra,24(sp)
    8000356a:	6442                	ld	s0,16(sp)
    8000356c:	64a2                	ld	s1,8(sp)
    8000356e:	6902                	ld	s2,0(sp)
    80003570:	6105                	addi	sp,sp,32
    80003572:	8082                	ret

0000000080003574 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003574:	00016797          	auipc	a5,0x16
    80003578:	cd87a783          	lw	a5,-808(a5) # 8001924c <log+0x2c>
    8000357c:	0af05d63          	blez	a5,80003636 <install_trans+0xc2>
{
    80003580:	7139                	addi	sp,sp,-64
    80003582:	fc06                	sd	ra,56(sp)
    80003584:	f822                	sd	s0,48(sp)
    80003586:	f426                	sd	s1,40(sp)
    80003588:	f04a                	sd	s2,32(sp)
    8000358a:	ec4e                	sd	s3,24(sp)
    8000358c:	e852                	sd	s4,16(sp)
    8000358e:	e456                	sd	s5,8(sp)
    80003590:	e05a                	sd	s6,0(sp)
    80003592:	0080                	addi	s0,sp,64
    80003594:	8b2a                	mv	s6,a0
    80003596:	00016a97          	auipc	s5,0x16
    8000359a:	cbaa8a93          	addi	s5,s5,-838 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000359e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035a0:	00016997          	auipc	s3,0x16
    800035a4:	c8098993          	addi	s3,s3,-896 # 80019220 <log>
    800035a8:	a00d                	j	800035ca <install_trans+0x56>
    brelse(lbuf);
    800035aa:	854a                	mv	a0,s2
    800035ac:	fffff097          	auipc	ra,0xfffff
    800035b0:	08c080e7          	jalr	140(ra) # 80002638 <brelse>
    brelse(dbuf);
    800035b4:	8526                	mv	a0,s1
    800035b6:	fffff097          	auipc	ra,0xfffff
    800035ba:	082080e7          	jalr	130(ra) # 80002638 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035be:	2a05                	addiw	s4,s4,1
    800035c0:	0a91                	addi	s5,s5,4
    800035c2:	02c9a783          	lw	a5,44(s3)
    800035c6:	04fa5e63          	bge	s4,a5,80003622 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035ca:	0189a583          	lw	a1,24(s3)
    800035ce:	014585bb          	addw	a1,a1,s4
    800035d2:	2585                	addiw	a1,a1,1
    800035d4:	0289a503          	lw	a0,40(s3)
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	f30080e7          	jalr	-208(ra) # 80002508 <bread>
    800035e0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035e2:	000aa583          	lw	a1,0(s5)
    800035e6:	0289a503          	lw	a0,40(s3)
    800035ea:	fffff097          	auipc	ra,0xfffff
    800035ee:	f1e080e7          	jalr	-226(ra) # 80002508 <bread>
    800035f2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035f4:	40000613          	li	a2,1024
    800035f8:	05890593          	addi	a1,s2,88
    800035fc:	05850513          	addi	a0,a0,88
    80003600:	ffffd097          	auipc	ra,0xffffd
    80003604:	bd4080e7          	jalr	-1068(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003608:	8526                	mv	a0,s1
    8000360a:	fffff097          	auipc	ra,0xfffff
    8000360e:	ff0080e7          	jalr	-16(ra) # 800025fa <bwrite>
    if(recovering == 0)
    80003612:	f80b1ce3          	bnez	s6,800035aa <install_trans+0x36>
      bunpin(dbuf);
    80003616:	8526                	mv	a0,s1
    80003618:	fffff097          	auipc	ra,0xfffff
    8000361c:	0fa080e7          	jalr	250(ra) # 80002712 <bunpin>
    80003620:	b769                	j	800035aa <install_trans+0x36>
}
    80003622:	70e2                	ld	ra,56(sp)
    80003624:	7442                	ld	s0,48(sp)
    80003626:	74a2                	ld	s1,40(sp)
    80003628:	7902                	ld	s2,32(sp)
    8000362a:	69e2                	ld	s3,24(sp)
    8000362c:	6a42                	ld	s4,16(sp)
    8000362e:	6aa2                	ld	s5,8(sp)
    80003630:	6b02                	ld	s6,0(sp)
    80003632:	6121                	addi	sp,sp,64
    80003634:	8082                	ret
    80003636:	8082                	ret

0000000080003638 <initlog>:
{
    80003638:	7179                	addi	sp,sp,-48
    8000363a:	f406                	sd	ra,40(sp)
    8000363c:	f022                	sd	s0,32(sp)
    8000363e:	ec26                	sd	s1,24(sp)
    80003640:	e84a                	sd	s2,16(sp)
    80003642:	e44e                	sd	s3,8(sp)
    80003644:	1800                	addi	s0,sp,48
    80003646:	892a                	mv	s2,a0
    80003648:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000364a:	00016497          	auipc	s1,0x16
    8000364e:	bd648493          	addi	s1,s1,-1066 # 80019220 <log>
    80003652:	00005597          	auipc	a1,0x5
    80003656:	e9658593          	addi	a1,a1,-362 # 800084e8 <etext+0x4e8>
    8000365a:	8526                	mv	a0,s1
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	be4080e7          	jalr	-1052(ra) # 80006240 <initlock>
  log.start = sb->logstart;
    80003664:	0149a583          	lw	a1,20(s3)
    80003668:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000366a:	0109a783          	lw	a5,16(s3)
    8000366e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003670:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003674:	854a                	mv	a0,s2
    80003676:	fffff097          	auipc	ra,0xfffff
    8000367a:	e92080e7          	jalr	-366(ra) # 80002508 <bread>
  log.lh.n = lh->n;
    8000367e:	4d34                	lw	a3,88(a0)
    80003680:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003682:	02d05563          	blez	a3,800036ac <initlog+0x74>
    80003686:	05c50793          	addi	a5,a0,92
    8000368a:	00016717          	auipc	a4,0x16
    8000368e:	bc670713          	addi	a4,a4,-1082 # 80019250 <log+0x30>
    80003692:	36fd                	addiw	a3,a3,-1
    80003694:	1682                	slli	a3,a3,0x20
    80003696:	9281                	srli	a3,a3,0x20
    80003698:	068a                	slli	a3,a3,0x2
    8000369a:	06050613          	addi	a2,a0,96
    8000369e:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800036a0:	4390                	lw	a2,0(a5)
    800036a2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036a4:	0791                	addi	a5,a5,4
    800036a6:	0711                	addi	a4,a4,4
    800036a8:	fed79ce3          	bne	a5,a3,800036a0 <initlog+0x68>
  brelse(buf);
    800036ac:	fffff097          	auipc	ra,0xfffff
    800036b0:	f8c080e7          	jalr	-116(ra) # 80002638 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036b4:	4505                	li	a0,1
    800036b6:	00000097          	auipc	ra,0x0
    800036ba:	ebe080e7          	jalr	-322(ra) # 80003574 <install_trans>
  log.lh.n = 0;
    800036be:	00016797          	auipc	a5,0x16
    800036c2:	b807a723          	sw	zero,-1138(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800036c6:	00000097          	auipc	ra,0x0
    800036ca:	e34080e7          	jalr	-460(ra) # 800034fa <write_head>
}
    800036ce:	70a2                	ld	ra,40(sp)
    800036d0:	7402                	ld	s0,32(sp)
    800036d2:	64e2                	ld	s1,24(sp)
    800036d4:	6942                	ld	s2,16(sp)
    800036d6:	69a2                	ld	s3,8(sp)
    800036d8:	6145                	addi	sp,sp,48
    800036da:	8082                	ret

00000000800036dc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036dc:	1101                	addi	sp,sp,-32
    800036de:	ec06                	sd	ra,24(sp)
    800036e0:	e822                	sd	s0,16(sp)
    800036e2:	e426                	sd	s1,8(sp)
    800036e4:	e04a                	sd	s2,0(sp)
    800036e6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036e8:	00016517          	auipc	a0,0x16
    800036ec:	b3850513          	addi	a0,a0,-1224 # 80019220 <log>
    800036f0:	00003097          	auipc	ra,0x3
    800036f4:	be0080e7          	jalr	-1056(ra) # 800062d0 <acquire>
  while(1){
    if(log.committing){
    800036f8:	00016497          	auipc	s1,0x16
    800036fc:	b2848493          	addi	s1,s1,-1240 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003700:	4979                	li	s2,30
    80003702:	a039                	j	80003710 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003704:	85a6                	mv	a1,s1
    80003706:	8526                	mv	a0,s1
    80003708:	ffffe097          	auipc	ra,0xffffe
    8000370c:	f90080e7          	jalr	-112(ra) # 80001698 <sleep>
    if(log.committing){
    80003710:	50dc                	lw	a5,36(s1)
    80003712:	fbed                	bnez	a5,80003704 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003714:	509c                	lw	a5,32(s1)
    80003716:	0017871b          	addiw	a4,a5,1
    8000371a:	0007069b          	sext.w	a3,a4
    8000371e:	0027179b          	slliw	a5,a4,0x2
    80003722:	9fb9                	addw	a5,a5,a4
    80003724:	0017979b          	slliw	a5,a5,0x1
    80003728:	54d8                	lw	a4,44(s1)
    8000372a:	9fb9                	addw	a5,a5,a4
    8000372c:	00f95963          	bge	s2,a5,8000373e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003730:	85a6                	mv	a1,s1
    80003732:	8526                	mv	a0,s1
    80003734:	ffffe097          	auipc	ra,0xffffe
    80003738:	f64080e7          	jalr	-156(ra) # 80001698 <sleep>
    8000373c:	bfd1                	j	80003710 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000373e:	00016517          	auipc	a0,0x16
    80003742:	ae250513          	addi	a0,a0,-1310 # 80019220 <log>
    80003746:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003748:	00003097          	auipc	ra,0x3
    8000374c:	c3c080e7          	jalr	-964(ra) # 80006384 <release>
      break;
    }
  }
}
    80003750:	60e2                	ld	ra,24(sp)
    80003752:	6442                	ld	s0,16(sp)
    80003754:	64a2                	ld	s1,8(sp)
    80003756:	6902                	ld	s2,0(sp)
    80003758:	6105                	addi	sp,sp,32
    8000375a:	8082                	ret

000000008000375c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000375c:	7139                	addi	sp,sp,-64
    8000375e:	fc06                	sd	ra,56(sp)
    80003760:	f822                	sd	s0,48(sp)
    80003762:	f426                	sd	s1,40(sp)
    80003764:	f04a                	sd	s2,32(sp)
    80003766:	ec4e                	sd	s3,24(sp)
    80003768:	e852                	sd	s4,16(sp)
    8000376a:	e456                	sd	s5,8(sp)
    8000376c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000376e:	00016497          	auipc	s1,0x16
    80003772:	ab248493          	addi	s1,s1,-1358 # 80019220 <log>
    80003776:	8526                	mv	a0,s1
    80003778:	00003097          	auipc	ra,0x3
    8000377c:	b58080e7          	jalr	-1192(ra) # 800062d0 <acquire>
  log.outstanding -= 1;
    80003780:	509c                	lw	a5,32(s1)
    80003782:	37fd                	addiw	a5,a5,-1
    80003784:	0007891b          	sext.w	s2,a5
    80003788:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000378a:	50dc                	lw	a5,36(s1)
    8000378c:	e7b9                	bnez	a5,800037da <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000378e:	04091e63          	bnez	s2,800037ea <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003792:	00016497          	auipc	s1,0x16
    80003796:	a8e48493          	addi	s1,s1,-1394 # 80019220 <log>
    8000379a:	4785                	li	a5,1
    8000379c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000379e:	8526                	mv	a0,s1
    800037a0:	00003097          	auipc	ra,0x3
    800037a4:	be4080e7          	jalr	-1052(ra) # 80006384 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037a8:	54dc                	lw	a5,44(s1)
    800037aa:	06f04763          	bgtz	a5,80003818 <end_op+0xbc>
    acquire(&log.lock);
    800037ae:	00016497          	auipc	s1,0x16
    800037b2:	a7248493          	addi	s1,s1,-1422 # 80019220 <log>
    800037b6:	8526                	mv	a0,s1
    800037b8:	00003097          	auipc	ra,0x3
    800037bc:	b18080e7          	jalr	-1256(ra) # 800062d0 <acquire>
    log.committing = 0;
    800037c0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037c4:	8526                	mv	a0,s1
    800037c6:	ffffe097          	auipc	ra,0xffffe
    800037ca:	05e080e7          	jalr	94(ra) # 80001824 <wakeup>
    release(&log.lock);
    800037ce:	8526                	mv	a0,s1
    800037d0:	00003097          	auipc	ra,0x3
    800037d4:	bb4080e7          	jalr	-1100(ra) # 80006384 <release>
}
    800037d8:	a03d                	j	80003806 <end_op+0xaa>
    panic("log.committing");
    800037da:	00005517          	auipc	a0,0x5
    800037de:	d1650513          	addi	a0,a0,-746 # 800084f0 <etext+0x4f0>
    800037e2:	00002097          	auipc	ra,0x2
    800037e6:	5b2080e7          	jalr	1458(ra) # 80005d94 <panic>
    wakeup(&log);
    800037ea:	00016497          	auipc	s1,0x16
    800037ee:	a3648493          	addi	s1,s1,-1482 # 80019220 <log>
    800037f2:	8526                	mv	a0,s1
    800037f4:	ffffe097          	auipc	ra,0xffffe
    800037f8:	030080e7          	jalr	48(ra) # 80001824 <wakeup>
  release(&log.lock);
    800037fc:	8526                	mv	a0,s1
    800037fe:	00003097          	auipc	ra,0x3
    80003802:	b86080e7          	jalr	-1146(ra) # 80006384 <release>
}
    80003806:	70e2                	ld	ra,56(sp)
    80003808:	7442                	ld	s0,48(sp)
    8000380a:	74a2                	ld	s1,40(sp)
    8000380c:	7902                	ld	s2,32(sp)
    8000380e:	69e2                	ld	s3,24(sp)
    80003810:	6a42                	ld	s4,16(sp)
    80003812:	6aa2                	ld	s5,8(sp)
    80003814:	6121                	addi	sp,sp,64
    80003816:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003818:	00016a97          	auipc	s5,0x16
    8000381c:	a38a8a93          	addi	s5,s5,-1480 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003820:	00016a17          	auipc	s4,0x16
    80003824:	a00a0a13          	addi	s4,s4,-1536 # 80019220 <log>
    80003828:	018a2583          	lw	a1,24(s4)
    8000382c:	012585bb          	addw	a1,a1,s2
    80003830:	2585                	addiw	a1,a1,1
    80003832:	028a2503          	lw	a0,40(s4)
    80003836:	fffff097          	auipc	ra,0xfffff
    8000383a:	cd2080e7          	jalr	-814(ra) # 80002508 <bread>
    8000383e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003840:	000aa583          	lw	a1,0(s5)
    80003844:	028a2503          	lw	a0,40(s4)
    80003848:	fffff097          	auipc	ra,0xfffff
    8000384c:	cc0080e7          	jalr	-832(ra) # 80002508 <bread>
    80003850:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003852:	40000613          	li	a2,1024
    80003856:	05850593          	addi	a1,a0,88
    8000385a:	05848513          	addi	a0,s1,88
    8000385e:	ffffd097          	auipc	ra,0xffffd
    80003862:	976080e7          	jalr	-1674(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    80003866:	8526                	mv	a0,s1
    80003868:	fffff097          	auipc	ra,0xfffff
    8000386c:	d92080e7          	jalr	-622(ra) # 800025fa <bwrite>
    brelse(from);
    80003870:	854e                	mv	a0,s3
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	dc6080e7          	jalr	-570(ra) # 80002638 <brelse>
    brelse(to);
    8000387a:	8526                	mv	a0,s1
    8000387c:	fffff097          	auipc	ra,0xfffff
    80003880:	dbc080e7          	jalr	-580(ra) # 80002638 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003884:	2905                	addiw	s2,s2,1
    80003886:	0a91                	addi	s5,s5,4
    80003888:	02ca2783          	lw	a5,44(s4)
    8000388c:	f8f94ee3          	blt	s2,a5,80003828 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003890:	00000097          	auipc	ra,0x0
    80003894:	c6a080e7          	jalr	-918(ra) # 800034fa <write_head>
    install_trans(0); // Now install writes to home locations
    80003898:	4501                	li	a0,0
    8000389a:	00000097          	auipc	ra,0x0
    8000389e:	cda080e7          	jalr	-806(ra) # 80003574 <install_trans>
    log.lh.n = 0;
    800038a2:	00016797          	auipc	a5,0x16
    800038a6:	9a07a523          	sw	zero,-1622(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038aa:	00000097          	auipc	ra,0x0
    800038ae:	c50080e7          	jalr	-944(ra) # 800034fa <write_head>
    800038b2:	bdf5                	j	800037ae <end_op+0x52>

00000000800038b4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038b4:	1101                	addi	sp,sp,-32
    800038b6:	ec06                	sd	ra,24(sp)
    800038b8:	e822                	sd	s0,16(sp)
    800038ba:	e426                	sd	s1,8(sp)
    800038bc:	e04a                	sd	s2,0(sp)
    800038be:	1000                	addi	s0,sp,32
    800038c0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038c2:	00016917          	auipc	s2,0x16
    800038c6:	95e90913          	addi	s2,s2,-1698 # 80019220 <log>
    800038ca:	854a                	mv	a0,s2
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	a04080e7          	jalr	-1532(ra) # 800062d0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038d4:	02c92603          	lw	a2,44(s2)
    800038d8:	47f5                	li	a5,29
    800038da:	06c7c563          	blt	a5,a2,80003944 <log_write+0x90>
    800038de:	00016797          	auipc	a5,0x16
    800038e2:	95e7a783          	lw	a5,-1698(a5) # 8001923c <log+0x1c>
    800038e6:	37fd                	addiw	a5,a5,-1
    800038e8:	04f65e63          	bge	a2,a5,80003944 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038ec:	00016797          	auipc	a5,0x16
    800038f0:	9547a783          	lw	a5,-1708(a5) # 80019240 <log+0x20>
    800038f4:	06f05063          	blez	a5,80003954 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038f8:	4781                	li	a5,0
    800038fa:	06c05563          	blez	a2,80003964 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038fe:	44cc                	lw	a1,12(s1)
    80003900:	00016717          	auipc	a4,0x16
    80003904:	95070713          	addi	a4,a4,-1712 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003908:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000390a:	4314                	lw	a3,0(a4)
    8000390c:	04b68c63          	beq	a3,a1,80003964 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003910:	2785                	addiw	a5,a5,1
    80003912:	0711                	addi	a4,a4,4
    80003914:	fef61be3          	bne	a2,a5,8000390a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003918:	0621                	addi	a2,a2,8
    8000391a:	060a                	slli	a2,a2,0x2
    8000391c:	00016797          	auipc	a5,0x16
    80003920:	90478793          	addi	a5,a5,-1788 # 80019220 <log>
    80003924:	963e                	add	a2,a2,a5
    80003926:	44dc                	lw	a5,12(s1)
    80003928:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000392a:	8526                	mv	a0,s1
    8000392c:	fffff097          	auipc	ra,0xfffff
    80003930:	daa080e7          	jalr	-598(ra) # 800026d6 <bpin>
    log.lh.n++;
    80003934:	00016717          	auipc	a4,0x16
    80003938:	8ec70713          	addi	a4,a4,-1812 # 80019220 <log>
    8000393c:	575c                	lw	a5,44(a4)
    8000393e:	2785                	addiw	a5,a5,1
    80003940:	d75c                	sw	a5,44(a4)
    80003942:	a835                	j	8000397e <log_write+0xca>
    panic("too big a transaction");
    80003944:	00005517          	auipc	a0,0x5
    80003948:	bbc50513          	addi	a0,a0,-1092 # 80008500 <etext+0x500>
    8000394c:	00002097          	auipc	ra,0x2
    80003950:	448080e7          	jalr	1096(ra) # 80005d94 <panic>
    panic("log_write outside of trans");
    80003954:	00005517          	auipc	a0,0x5
    80003958:	bc450513          	addi	a0,a0,-1084 # 80008518 <etext+0x518>
    8000395c:	00002097          	auipc	ra,0x2
    80003960:	438080e7          	jalr	1080(ra) # 80005d94 <panic>
  log.lh.block[i] = b->blockno;
    80003964:	00878713          	addi	a4,a5,8
    80003968:	00271693          	slli	a3,a4,0x2
    8000396c:	00016717          	auipc	a4,0x16
    80003970:	8b470713          	addi	a4,a4,-1868 # 80019220 <log>
    80003974:	9736                	add	a4,a4,a3
    80003976:	44d4                	lw	a3,12(s1)
    80003978:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000397a:	faf608e3          	beq	a2,a5,8000392a <log_write+0x76>
  }
  release(&log.lock);
    8000397e:	00016517          	auipc	a0,0x16
    80003982:	8a250513          	addi	a0,a0,-1886 # 80019220 <log>
    80003986:	00003097          	auipc	ra,0x3
    8000398a:	9fe080e7          	jalr	-1538(ra) # 80006384 <release>
}
    8000398e:	60e2                	ld	ra,24(sp)
    80003990:	6442                	ld	s0,16(sp)
    80003992:	64a2                	ld	s1,8(sp)
    80003994:	6902                	ld	s2,0(sp)
    80003996:	6105                	addi	sp,sp,32
    80003998:	8082                	ret

000000008000399a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000399a:	1101                	addi	sp,sp,-32
    8000399c:	ec06                	sd	ra,24(sp)
    8000399e:	e822                	sd	s0,16(sp)
    800039a0:	e426                	sd	s1,8(sp)
    800039a2:	e04a                	sd	s2,0(sp)
    800039a4:	1000                	addi	s0,sp,32
    800039a6:	84aa                	mv	s1,a0
    800039a8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039aa:	00005597          	auipc	a1,0x5
    800039ae:	b8e58593          	addi	a1,a1,-1138 # 80008538 <etext+0x538>
    800039b2:	0521                	addi	a0,a0,8
    800039b4:	00003097          	auipc	ra,0x3
    800039b8:	88c080e7          	jalr	-1908(ra) # 80006240 <initlock>
  lk->name = name;
    800039bc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039c0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039c4:	0204a423          	sw	zero,40(s1)
}
    800039c8:	60e2                	ld	ra,24(sp)
    800039ca:	6442                	ld	s0,16(sp)
    800039cc:	64a2                	ld	s1,8(sp)
    800039ce:	6902                	ld	s2,0(sp)
    800039d0:	6105                	addi	sp,sp,32
    800039d2:	8082                	ret

00000000800039d4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039d4:	1101                	addi	sp,sp,-32
    800039d6:	ec06                	sd	ra,24(sp)
    800039d8:	e822                	sd	s0,16(sp)
    800039da:	e426                	sd	s1,8(sp)
    800039dc:	e04a                	sd	s2,0(sp)
    800039de:	1000                	addi	s0,sp,32
    800039e0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039e2:	00850913          	addi	s2,a0,8
    800039e6:	854a                	mv	a0,s2
    800039e8:	00003097          	auipc	ra,0x3
    800039ec:	8e8080e7          	jalr	-1816(ra) # 800062d0 <acquire>
  while (lk->locked) {
    800039f0:	409c                	lw	a5,0(s1)
    800039f2:	cb89                	beqz	a5,80003a04 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039f4:	85ca                	mv	a1,s2
    800039f6:	8526                	mv	a0,s1
    800039f8:	ffffe097          	auipc	ra,0xffffe
    800039fc:	ca0080e7          	jalr	-864(ra) # 80001698 <sleep>
  while (lk->locked) {
    80003a00:	409c                	lw	a5,0(s1)
    80003a02:	fbed                	bnez	a5,800039f4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a04:	4785                	li	a5,1
    80003a06:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a08:	ffffd097          	auipc	ra,0xffffd
    80003a0c:	54a080e7          	jalr	1354(ra) # 80000f52 <myproc>
    80003a10:	591c                	lw	a5,48(a0)
    80003a12:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a14:	854a                	mv	a0,s2
    80003a16:	00003097          	auipc	ra,0x3
    80003a1a:	96e080e7          	jalr	-1682(ra) # 80006384 <release>
}
    80003a1e:	60e2                	ld	ra,24(sp)
    80003a20:	6442                	ld	s0,16(sp)
    80003a22:	64a2                	ld	s1,8(sp)
    80003a24:	6902                	ld	s2,0(sp)
    80003a26:	6105                	addi	sp,sp,32
    80003a28:	8082                	ret

0000000080003a2a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a2a:	1101                	addi	sp,sp,-32
    80003a2c:	ec06                	sd	ra,24(sp)
    80003a2e:	e822                	sd	s0,16(sp)
    80003a30:	e426                	sd	s1,8(sp)
    80003a32:	e04a                	sd	s2,0(sp)
    80003a34:	1000                	addi	s0,sp,32
    80003a36:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a38:	00850913          	addi	s2,a0,8
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	892080e7          	jalr	-1902(ra) # 800062d0 <acquire>
  lk->locked = 0;
    80003a46:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a4a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a4e:	8526                	mv	a0,s1
    80003a50:	ffffe097          	auipc	ra,0xffffe
    80003a54:	dd4080e7          	jalr	-556(ra) # 80001824 <wakeup>
  release(&lk->lk);
    80003a58:	854a                	mv	a0,s2
    80003a5a:	00003097          	auipc	ra,0x3
    80003a5e:	92a080e7          	jalr	-1750(ra) # 80006384 <release>
}
    80003a62:	60e2                	ld	ra,24(sp)
    80003a64:	6442                	ld	s0,16(sp)
    80003a66:	64a2                	ld	s1,8(sp)
    80003a68:	6902                	ld	s2,0(sp)
    80003a6a:	6105                	addi	sp,sp,32
    80003a6c:	8082                	ret

0000000080003a6e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a6e:	7179                	addi	sp,sp,-48
    80003a70:	f406                	sd	ra,40(sp)
    80003a72:	f022                	sd	s0,32(sp)
    80003a74:	ec26                	sd	s1,24(sp)
    80003a76:	e84a                	sd	s2,16(sp)
    80003a78:	e44e                	sd	s3,8(sp)
    80003a7a:	1800                	addi	s0,sp,48
    80003a7c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a7e:	00850913          	addi	s2,a0,8
    80003a82:	854a                	mv	a0,s2
    80003a84:	00003097          	auipc	ra,0x3
    80003a88:	84c080e7          	jalr	-1972(ra) # 800062d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a8c:	409c                	lw	a5,0(s1)
    80003a8e:	ef99                	bnez	a5,80003aac <holdingsleep+0x3e>
    80003a90:	4481                	li	s1,0
  release(&lk->lk);
    80003a92:	854a                	mv	a0,s2
    80003a94:	00003097          	auipc	ra,0x3
    80003a98:	8f0080e7          	jalr	-1808(ra) # 80006384 <release>
  return r;
}
    80003a9c:	8526                	mv	a0,s1
    80003a9e:	70a2                	ld	ra,40(sp)
    80003aa0:	7402                	ld	s0,32(sp)
    80003aa2:	64e2                	ld	s1,24(sp)
    80003aa4:	6942                	ld	s2,16(sp)
    80003aa6:	69a2                	ld	s3,8(sp)
    80003aa8:	6145                	addi	sp,sp,48
    80003aaa:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aac:	0284a983          	lw	s3,40(s1)
    80003ab0:	ffffd097          	auipc	ra,0xffffd
    80003ab4:	4a2080e7          	jalr	1186(ra) # 80000f52 <myproc>
    80003ab8:	5904                	lw	s1,48(a0)
    80003aba:	413484b3          	sub	s1,s1,s3
    80003abe:	0014b493          	seqz	s1,s1
    80003ac2:	bfc1                	j	80003a92 <holdingsleep+0x24>

0000000080003ac4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ac4:	1141                	addi	sp,sp,-16
    80003ac6:	e406                	sd	ra,8(sp)
    80003ac8:	e022                	sd	s0,0(sp)
    80003aca:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003acc:	00005597          	auipc	a1,0x5
    80003ad0:	a7c58593          	addi	a1,a1,-1412 # 80008548 <etext+0x548>
    80003ad4:	00016517          	auipc	a0,0x16
    80003ad8:	89450513          	addi	a0,a0,-1900 # 80019368 <ftable>
    80003adc:	00002097          	auipc	ra,0x2
    80003ae0:	764080e7          	jalr	1892(ra) # 80006240 <initlock>
}
    80003ae4:	60a2                	ld	ra,8(sp)
    80003ae6:	6402                	ld	s0,0(sp)
    80003ae8:	0141                	addi	sp,sp,16
    80003aea:	8082                	ret

0000000080003aec <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003aec:	1101                	addi	sp,sp,-32
    80003aee:	ec06                	sd	ra,24(sp)
    80003af0:	e822                	sd	s0,16(sp)
    80003af2:	e426                	sd	s1,8(sp)
    80003af4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003af6:	00016517          	auipc	a0,0x16
    80003afa:	87250513          	addi	a0,a0,-1934 # 80019368 <ftable>
    80003afe:	00002097          	auipc	ra,0x2
    80003b02:	7d2080e7          	jalr	2002(ra) # 800062d0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b06:	00016497          	auipc	s1,0x16
    80003b0a:	87a48493          	addi	s1,s1,-1926 # 80019380 <ftable+0x18>
    80003b0e:	00017717          	auipc	a4,0x17
    80003b12:	81270713          	addi	a4,a4,-2030 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b16:	40dc                	lw	a5,4(s1)
    80003b18:	cf99                	beqz	a5,80003b36 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b1a:	02848493          	addi	s1,s1,40
    80003b1e:	fee49ce3          	bne	s1,a4,80003b16 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b22:	00016517          	auipc	a0,0x16
    80003b26:	84650513          	addi	a0,a0,-1978 # 80019368 <ftable>
    80003b2a:	00003097          	auipc	ra,0x3
    80003b2e:	85a080e7          	jalr	-1958(ra) # 80006384 <release>
  return 0;
    80003b32:	4481                	li	s1,0
    80003b34:	a819                	j	80003b4a <filealloc+0x5e>
      f->ref = 1;
    80003b36:	4785                	li	a5,1
    80003b38:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b3a:	00016517          	auipc	a0,0x16
    80003b3e:	82e50513          	addi	a0,a0,-2002 # 80019368 <ftable>
    80003b42:	00003097          	auipc	ra,0x3
    80003b46:	842080e7          	jalr	-1982(ra) # 80006384 <release>
}
    80003b4a:	8526                	mv	a0,s1
    80003b4c:	60e2                	ld	ra,24(sp)
    80003b4e:	6442                	ld	s0,16(sp)
    80003b50:	64a2                	ld	s1,8(sp)
    80003b52:	6105                	addi	sp,sp,32
    80003b54:	8082                	ret

0000000080003b56 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b56:	1101                	addi	sp,sp,-32
    80003b58:	ec06                	sd	ra,24(sp)
    80003b5a:	e822                	sd	s0,16(sp)
    80003b5c:	e426                	sd	s1,8(sp)
    80003b5e:	1000                	addi	s0,sp,32
    80003b60:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b62:	00016517          	auipc	a0,0x16
    80003b66:	80650513          	addi	a0,a0,-2042 # 80019368 <ftable>
    80003b6a:	00002097          	auipc	ra,0x2
    80003b6e:	766080e7          	jalr	1894(ra) # 800062d0 <acquire>
  if(f->ref < 1)
    80003b72:	40dc                	lw	a5,4(s1)
    80003b74:	02f05263          	blez	a5,80003b98 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b78:	2785                	addiw	a5,a5,1
    80003b7a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b7c:	00015517          	auipc	a0,0x15
    80003b80:	7ec50513          	addi	a0,a0,2028 # 80019368 <ftable>
    80003b84:	00003097          	auipc	ra,0x3
    80003b88:	800080e7          	jalr	-2048(ra) # 80006384 <release>
  return f;
}
    80003b8c:	8526                	mv	a0,s1
    80003b8e:	60e2                	ld	ra,24(sp)
    80003b90:	6442                	ld	s0,16(sp)
    80003b92:	64a2                	ld	s1,8(sp)
    80003b94:	6105                	addi	sp,sp,32
    80003b96:	8082                	ret
    panic("filedup");
    80003b98:	00005517          	auipc	a0,0x5
    80003b9c:	9b850513          	addi	a0,a0,-1608 # 80008550 <etext+0x550>
    80003ba0:	00002097          	auipc	ra,0x2
    80003ba4:	1f4080e7          	jalr	500(ra) # 80005d94 <panic>

0000000080003ba8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ba8:	7139                	addi	sp,sp,-64
    80003baa:	fc06                	sd	ra,56(sp)
    80003bac:	f822                	sd	s0,48(sp)
    80003bae:	f426                	sd	s1,40(sp)
    80003bb0:	f04a                	sd	s2,32(sp)
    80003bb2:	ec4e                	sd	s3,24(sp)
    80003bb4:	e852                	sd	s4,16(sp)
    80003bb6:	e456                	sd	s5,8(sp)
    80003bb8:	0080                	addi	s0,sp,64
    80003bba:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bbc:	00015517          	auipc	a0,0x15
    80003bc0:	7ac50513          	addi	a0,a0,1964 # 80019368 <ftable>
    80003bc4:	00002097          	auipc	ra,0x2
    80003bc8:	70c080e7          	jalr	1804(ra) # 800062d0 <acquire>
  if(f->ref < 1)
    80003bcc:	40dc                	lw	a5,4(s1)
    80003bce:	06f05163          	blez	a5,80003c30 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bd2:	37fd                	addiw	a5,a5,-1
    80003bd4:	0007871b          	sext.w	a4,a5
    80003bd8:	c0dc                	sw	a5,4(s1)
    80003bda:	06e04363          	bgtz	a4,80003c40 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bde:	0004a903          	lw	s2,0(s1)
    80003be2:	0094ca83          	lbu	s5,9(s1)
    80003be6:	0104ba03          	ld	s4,16(s1)
    80003bea:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bee:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bf2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bf6:	00015517          	auipc	a0,0x15
    80003bfa:	77250513          	addi	a0,a0,1906 # 80019368 <ftable>
    80003bfe:	00002097          	auipc	ra,0x2
    80003c02:	786080e7          	jalr	1926(ra) # 80006384 <release>

  if(ff.type == FD_PIPE){
    80003c06:	4785                	li	a5,1
    80003c08:	04f90d63          	beq	s2,a5,80003c62 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c0c:	3979                	addiw	s2,s2,-2
    80003c0e:	4785                	li	a5,1
    80003c10:	0527e063          	bltu	a5,s2,80003c50 <fileclose+0xa8>
    begin_op();
    80003c14:	00000097          	auipc	ra,0x0
    80003c18:	ac8080e7          	jalr	-1336(ra) # 800036dc <begin_op>
    iput(ff.ip);
    80003c1c:	854e                	mv	a0,s3
    80003c1e:	fffff097          	auipc	ra,0xfffff
    80003c22:	2a6080e7          	jalr	678(ra) # 80002ec4 <iput>
    end_op();
    80003c26:	00000097          	auipc	ra,0x0
    80003c2a:	b36080e7          	jalr	-1226(ra) # 8000375c <end_op>
    80003c2e:	a00d                	j	80003c50 <fileclose+0xa8>
    panic("fileclose");
    80003c30:	00005517          	auipc	a0,0x5
    80003c34:	92850513          	addi	a0,a0,-1752 # 80008558 <etext+0x558>
    80003c38:	00002097          	auipc	ra,0x2
    80003c3c:	15c080e7          	jalr	348(ra) # 80005d94 <panic>
    release(&ftable.lock);
    80003c40:	00015517          	auipc	a0,0x15
    80003c44:	72850513          	addi	a0,a0,1832 # 80019368 <ftable>
    80003c48:	00002097          	auipc	ra,0x2
    80003c4c:	73c080e7          	jalr	1852(ra) # 80006384 <release>
  }
}
    80003c50:	70e2                	ld	ra,56(sp)
    80003c52:	7442                	ld	s0,48(sp)
    80003c54:	74a2                	ld	s1,40(sp)
    80003c56:	7902                	ld	s2,32(sp)
    80003c58:	69e2                	ld	s3,24(sp)
    80003c5a:	6a42                	ld	s4,16(sp)
    80003c5c:	6aa2                	ld	s5,8(sp)
    80003c5e:	6121                	addi	sp,sp,64
    80003c60:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c62:	85d6                	mv	a1,s5
    80003c64:	8552                	mv	a0,s4
    80003c66:	00000097          	auipc	ra,0x0
    80003c6a:	34c080e7          	jalr	844(ra) # 80003fb2 <pipeclose>
    80003c6e:	b7cd                	j	80003c50 <fileclose+0xa8>

0000000080003c70 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c70:	715d                	addi	sp,sp,-80
    80003c72:	e486                	sd	ra,72(sp)
    80003c74:	e0a2                	sd	s0,64(sp)
    80003c76:	fc26                	sd	s1,56(sp)
    80003c78:	f84a                	sd	s2,48(sp)
    80003c7a:	f44e                	sd	s3,40(sp)
    80003c7c:	0880                	addi	s0,sp,80
    80003c7e:	84aa                	mv	s1,a0
    80003c80:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c82:	ffffd097          	auipc	ra,0xffffd
    80003c86:	2d0080e7          	jalr	720(ra) # 80000f52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c8a:	409c                	lw	a5,0(s1)
    80003c8c:	37f9                	addiw	a5,a5,-2
    80003c8e:	4705                	li	a4,1
    80003c90:	04f76763          	bltu	a4,a5,80003cde <filestat+0x6e>
    80003c94:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c96:	6c88                	ld	a0,24(s1)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	072080e7          	jalr	114(ra) # 80002d0a <ilock>
    stati(f->ip, &st);
    80003ca0:	fb840593          	addi	a1,s0,-72
    80003ca4:	6c88                	ld	a0,24(s1)
    80003ca6:	fffff097          	auipc	ra,0xfffff
    80003caa:	2ee080e7          	jalr	750(ra) # 80002f94 <stati>
    iunlock(f->ip);
    80003cae:	6c88                	ld	a0,24(s1)
    80003cb0:	fffff097          	auipc	ra,0xfffff
    80003cb4:	11c080e7          	jalr	284(ra) # 80002dcc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cb8:	46e1                	li	a3,24
    80003cba:	fb840613          	addi	a2,s0,-72
    80003cbe:	85ce                	mv	a1,s3
    80003cc0:	05093503          	ld	a0,80(s2)
    80003cc4:	ffffd097          	auipc	ra,0xffffd
    80003cc8:	e3e080e7          	jalr	-450(ra) # 80000b02 <copyout>
    80003ccc:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cd0:	60a6                	ld	ra,72(sp)
    80003cd2:	6406                	ld	s0,64(sp)
    80003cd4:	74e2                	ld	s1,56(sp)
    80003cd6:	7942                	ld	s2,48(sp)
    80003cd8:	79a2                	ld	s3,40(sp)
    80003cda:	6161                	addi	sp,sp,80
    80003cdc:	8082                	ret
  return -1;
    80003cde:	557d                	li	a0,-1
    80003ce0:	bfc5                	j	80003cd0 <filestat+0x60>

0000000080003ce2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ce2:	7179                	addi	sp,sp,-48
    80003ce4:	f406                	sd	ra,40(sp)
    80003ce6:	f022                	sd	s0,32(sp)
    80003ce8:	ec26                	sd	s1,24(sp)
    80003cea:	e84a                	sd	s2,16(sp)
    80003cec:	e44e                	sd	s3,8(sp)
    80003cee:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cf0:	00854783          	lbu	a5,8(a0)
    80003cf4:	c3d5                	beqz	a5,80003d98 <fileread+0xb6>
    80003cf6:	84aa                	mv	s1,a0
    80003cf8:	89ae                	mv	s3,a1
    80003cfa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cfc:	411c                	lw	a5,0(a0)
    80003cfe:	4705                	li	a4,1
    80003d00:	04e78963          	beq	a5,a4,80003d52 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d04:	470d                	li	a4,3
    80003d06:	04e78d63          	beq	a5,a4,80003d60 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d0a:	4709                	li	a4,2
    80003d0c:	06e79e63          	bne	a5,a4,80003d88 <fileread+0xa6>
    ilock(f->ip);
    80003d10:	6d08                	ld	a0,24(a0)
    80003d12:	fffff097          	auipc	ra,0xfffff
    80003d16:	ff8080e7          	jalr	-8(ra) # 80002d0a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d1a:	874a                	mv	a4,s2
    80003d1c:	5094                	lw	a3,32(s1)
    80003d1e:	864e                	mv	a2,s3
    80003d20:	4585                	li	a1,1
    80003d22:	6c88                	ld	a0,24(s1)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	29a080e7          	jalr	666(ra) # 80002fbe <readi>
    80003d2c:	892a                	mv	s2,a0
    80003d2e:	00a05563          	blez	a0,80003d38 <fileread+0x56>
      f->off += r;
    80003d32:	509c                	lw	a5,32(s1)
    80003d34:	9fa9                	addw	a5,a5,a0
    80003d36:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d38:	6c88                	ld	a0,24(s1)
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	092080e7          	jalr	146(ra) # 80002dcc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d42:	854a                	mv	a0,s2
    80003d44:	70a2                	ld	ra,40(sp)
    80003d46:	7402                	ld	s0,32(sp)
    80003d48:	64e2                	ld	s1,24(sp)
    80003d4a:	6942                	ld	s2,16(sp)
    80003d4c:	69a2                	ld	s3,8(sp)
    80003d4e:	6145                	addi	sp,sp,48
    80003d50:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d52:	6908                	ld	a0,16(a0)
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	3c0080e7          	jalr	960(ra) # 80004114 <piperead>
    80003d5c:	892a                	mv	s2,a0
    80003d5e:	b7d5                	j	80003d42 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d60:	02451783          	lh	a5,36(a0)
    80003d64:	03079693          	slli	a3,a5,0x30
    80003d68:	92c1                	srli	a3,a3,0x30
    80003d6a:	4725                	li	a4,9
    80003d6c:	02d76863          	bltu	a4,a3,80003d9c <fileread+0xba>
    80003d70:	0792                	slli	a5,a5,0x4
    80003d72:	00015717          	auipc	a4,0x15
    80003d76:	55670713          	addi	a4,a4,1366 # 800192c8 <devsw>
    80003d7a:	97ba                	add	a5,a5,a4
    80003d7c:	639c                	ld	a5,0(a5)
    80003d7e:	c38d                	beqz	a5,80003da0 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d80:	4505                	li	a0,1
    80003d82:	9782                	jalr	a5
    80003d84:	892a                	mv	s2,a0
    80003d86:	bf75                	j	80003d42 <fileread+0x60>
    panic("fileread");
    80003d88:	00004517          	auipc	a0,0x4
    80003d8c:	7e050513          	addi	a0,a0,2016 # 80008568 <etext+0x568>
    80003d90:	00002097          	auipc	ra,0x2
    80003d94:	004080e7          	jalr	4(ra) # 80005d94 <panic>
    return -1;
    80003d98:	597d                	li	s2,-1
    80003d9a:	b765                	j	80003d42 <fileread+0x60>
      return -1;
    80003d9c:	597d                	li	s2,-1
    80003d9e:	b755                	j	80003d42 <fileread+0x60>
    80003da0:	597d                	li	s2,-1
    80003da2:	b745                	j	80003d42 <fileread+0x60>

0000000080003da4 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003da4:	715d                	addi	sp,sp,-80
    80003da6:	e486                	sd	ra,72(sp)
    80003da8:	e0a2                	sd	s0,64(sp)
    80003daa:	fc26                	sd	s1,56(sp)
    80003dac:	f84a                	sd	s2,48(sp)
    80003dae:	f44e                	sd	s3,40(sp)
    80003db0:	f052                	sd	s4,32(sp)
    80003db2:	ec56                	sd	s5,24(sp)
    80003db4:	e85a                	sd	s6,16(sp)
    80003db6:	e45e                	sd	s7,8(sp)
    80003db8:	e062                	sd	s8,0(sp)
    80003dba:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dbc:	00954783          	lbu	a5,9(a0)
    80003dc0:	10078663          	beqz	a5,80003ecc <filewrite+0x128>
    80003dc4:	892a                	mv	s2,a0
    80003dc6:	8aae                	mv	s5,a1
    80003dc8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dca:	411c                	lw	a5,0(a0)
    80003dcc:	4705                	li	a4,1
    80003dce:	02e78263          	beq	a5,a4,80003df2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dd2:	470d                	li	a4,3
    80003dd4:	02e78663          	beq	a5,a4,80003e00 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dd8:	4709                	li	a4,2
    80003dda:	0ee79163          	bne	a5,a4,80003ebc <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dde:	0ac05d63          	blez	a2,80003e98 <filewrite+0xf4>
    int i = 0;
    80003de2:	4981                	li	s3,0
    80003de4:	6b05                	lui	s6,0x1
    80003de6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003dea:	6b85                	lui	s7,0x1
    80003dec:	c00b8b9b          	addiw	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003df0:	a861                	j	80003e88 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003df2:	6908                	ld	a0,16(a0)
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	22e080e7          	jalr	558(ra) # 80004022 <pipewrite>
    80003dfc:	8a2a                	mv	s4,a0
    80003dfe:	a045                	j	80003e9e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e00:	02451783          	lh	a5,36(a0)
    80003e04:	03079693          	slli	a3,a5,0x30
    80003e08:	92c1                	srli	a3,a3,0x30
    80003e0a:	4725                	li	a4,9
    80003e0c:	0cd76263          	bltu	a4,a3,80003ed0 <filewrite+0x12c>
    80003e10:	0792                	slli	a5,a5,0x4
    80003e12:	00015717          	auipc	a4,0x15
    80003e16:	4b670713          	addi	a4,a4,1206 # 800192c8 <devsw>
    80003e1a:	97ba                	add	a5,a5,a4
    80003e1c:	679c                	ld	a5,8(a5)
    80003e1e:	cbdd                	beqz	a5,80003ed4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e20:	4505                	li	a0,1
    80003e22:	9782                	jalr	a5
    80003e24:	8a2a                	mv	s4,a0
    80003e26:	a8a5                	j	80003e9e <filewrite+0xfa>
    80003e28:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e2c:	00000097          	auipc	ra,0x0
    80003e30:	8b0080e7          	jalr	-1872(ra) # 800036dc <begin_op>
      ilock(f->ip);
    80003e34:	01893503          	ld	a0,24(s2)
    80003e38:	fffff097          	auipc	ra,0xfffff
    80003e3c:	ed2080e7          	jalr	-302(ra) # 80002d0a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e40:	8762                	mv	a4,s8
    80003e42:	02092683          	lw	a3,32(s2)
    80003e46:	01598633          	add	a2,s3,s5
    80003e4a:	4585                	li	a1,1
    80003e4c:	01893503          	ld	a0,24(s2)
    80003e50:	fffff097          	auipc	ra,0xfffff
    80003e54:	266080e7          	jalr	614(ra) # 800030b6 <writei>
    80003e58:	84aa                	mv	s1,a0
    80003e5a:	00a05763          	blez	a0,80003e68 <filewrite+0xc4>
        f->off += r;
    80003e5e:	02092783          	lw	a5,32(s2)
    80003e62:	9fa9                	addw	a5,a5,a0
    80003e64:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e68:	01893503          	ld	a0,24(s2)
    80003e6c:	fffff097          	auipc	ra,0xfffff
    80003e70:	f60080e7          	jalr	-160(ra) # 80002dcc <iunlock>
      end_op();
    80003e74:	00000097          	auipc	ra,0x0
    80003e78:	8e8080e7          	jalr	-1816(ra) # 8000375c <end_op>

      if(r != n1){
    80003e7c:	009c1f63          	bne	s8,s1,80003e9a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e80:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e84:	0149db63          	bge	s3,s4,80003e9a <filewrite+0xf6>
      int n1 = n - i;
    80003e88:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e8c:	84be                	mv	s1,a5
    80003e8e:	2781                	sext.w	a5,a5
    80003e90:	f8fb5ce3          	bge	s6,a5,80003e28 <filewrite+0x84>
    80003e94:	84de                	mv	s1,s7
    80003e96:	bf49                	j	80003e28 <filewrite+0x84>
    int i = 0;
    80003e98:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e9a:	013a1f63          	bne	s4,s3,80003eb8 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e9e:	8552                	mv	a0,s4
    80003ea0:	60a6                	ld	ra,72(sp)
    80003ea2:	6406                	ld	s0,64(sp)
    80003ea4:	74e2                	ld	s1,56(sp)
    80003ea6:	7942                	ld	s2,48(sp)
    80003ea8:	79a2                	ld	s3,40(sp)
    80003eaa:	7a02                	ld	s4,32(sp)
    80003eac:	6ae2                	ld	s5,24(sp)
    80003eae:	6b42                	ld	s6,16(sp)
    80003eb0:	6ba2                	ld	s7,8(sp)
    80003eb2:	6c02                	ld	s8,0(sp)
    80003eb4:	6161                	addi	sp,sp,80
    80003eb6:	8082                	ret
    ret = (i == n ? n : -1);
    80003eb8:	5a7d                	li	s4,-1
    80003eba:	b7d5                	j	80003e9e <filewrite+0xfa>
    panic("filewrite");
    80003ebc:	00004517          	auipc	a0,0x4
    80003ec0:	6bc50513          	addi	a0,a0,1724 # 80008578 <etext+0x578>
    80003ec4:	00002097          	auipc	ra,0x2
    80003ec8:	ed0080e7          	jalr	-304(ra) # 80005d94 <panic>
    return -1;
    80003ecc:	5a7d                	li	s4,-1
    80003ece:	bfc1                	j	80003e9e <filewrite+0xfa>
      return -1;
    80003ed0:	5a7d                	li	s4,-1
    80003ed2:	b7f1                	j	80003e9e <filewrite+0xfa>
    80003ed4:	5a7d                	li	s4,-1
    80003ed6:	b7e1                	j	80003e9e <filewrite+0xfa>

0000000080003ed8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ed8:	7179                	addi	sp,sp,-48
    80003eda:	f406                	sd	ra,40(sp)
    80003edc:	f022                	sd	s0,32(sp)
    80003ede:	ec26                	sd	s1,24(sp)
    80003ee0:	e84a                	sd	s2,16(sp)
    80003ee2:	e44e                	sd	s3,8(sp)
    80003ee4:	e052                	sd	s4,0(sp)
    80003ee6:	1800                	addi	s0,sp,48
    80003ee8:	84aa                	mv	s1,a0
    80003eea:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003eec:	0005b023          	sd	zero,0(a1)
    80003ef0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ef4:	00000097          	auipc	ra,0x0
    80003ef8:	bf8080e7          	jalr	-1032(ra) # 80003aec <filealloc>
    80003efc:	e088                	sd	a0,0(s1)
    80003efe:	c551                	beqz	a0,80003f8a <pipealloc+0xb2>
    80003f00:	00000097          	auipc	ra,0x0
    80003f04:	bec080e7          	jalr	-1044(ra) # 80003aec <filealloc>
    80003f08:	00aa3023          	sd	a0,0(s4)
    80003f0c:	c92d                	beqz	a0,80003f7e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f0e:	ffffc097          	auipc	ra,0xffffc
    80003f12:	20a080e7          	jalr	522(ra) # 80000118 <kalloc>
    80003f16:	892a                	mv	s2,a0
    80003f18:	c125                	beqz	a0,80003f78 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f1a:	4985                	li	s3,1
    80003f1c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f20:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f24:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f28:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f2c:	00004597          	auipc	a1,0x4
    80003f30:	65c58593          	addi	a1,a1,1628 # 80008588 <etext+0x588>
    80003f34:	00002097          	auipc	ra,0x2
    80003f38:	30c080e7          	jalr	780(ra) # 80006240 <initlock>
  (*f0)->type = FD_PIPE;
    80003f3c:	609c                	ld	a5,0(s1)
    80003f3e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f42:	609c                	ld	a5,0(s1)
    80003f44:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f48:	609c                	ld	a5,0(s1)
    80003f4a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f4e:	609c                	ld	a5,0(s1)
    80003f50:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f54:	000a3783          	ld	a5,0(s4)
    80003f58:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f5c:	000a3783          	ld	a5,0(s4)
    80003f60:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f64:	000a3783          	ld	a5,0(s4)
    80003f68:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f6c:	000a3783          	ld	a5,0(s4)
    80003f70:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f74:	4501                	li	a0,0
    80003f76:	a025                	j	80003f9e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f78:	6088                	ld	a0,0(s1)
    80003f7a:	e501                	bnez	a0,80003f82 <pipealloc+0xaa>
    80003f7c:	a039                	j	80003f8a <pipealloc+0xb2>
    80003f7e:	6088                	ld	a0,0(s1)
    80003f80:	c51d                	beqz	a0,80003fae <pipealloc+0xd6>
    fileclose(*f0);
    80003f82:	00000097          	auipc	ra,0x0
    80003f86:	c26080e7          	jalr	-986(ra) # 80003ba8 <fileclose>
  if(*f1)
    80003f8a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f8e:	557d                	li	a0,-1
  if(*f1)
    80003f90:	c799                	beqz	a5,80003f9e <pipealloc+0xc6>
    fileclose(*f1);
    80003f92:	853e                	mv	a0,a5
    80003f94:	00000097          	auipc	ra,0x0
    80003f98:	c14080e7          	jalr	-1004(ra) # 80003ba8 <fileclose>
  return -1;
    80003f9c:	557d                	li	a0,-1
}
    80003f9e:	70a2                	ld	ra,40(sp)
    80003fa0:	7402                	ld	s0,32(sp)
    80003fa2:	64e2                	ld	s1,24(sp)
    80003fa4:	6942                	ld	s2,16(sp)
    80003fa6:	69a2                	ld	s3,8(sp)
    80003fa8:	6a02                	ld	s4,0(sp)
    80003faa:	6145                	addi	sp,sp,48
    80003fac:	8082                	ret
  return -1;
    80003fae:	557d                	li	a0,-1
    80003fb0:	b7fd                	j	80003f9e <pipealloc+0xc6>

0000000080003fb2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fb2:	1101                	addi	sp,sp,-32
    80003fb4:	ec06                	sd	ra,24(sp)
    80003fb6:	e822                	sd	s0,16(sp)
    80003fb8:	e426                	sd	s1,8(sp)
    80003fba:	e04a                	sd	s2,0(sp)
    80003fbc:	1000                	addi	s0,sp,32
    80003fbe:	84aa                	mv	s1,a0
    80003fc0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fc2:	00002097          	auipc	ra,0x2
    80003fc6:	30e080e7          	jalr	782(ra) # 800062d0 <acquire>
  if(writable){
    80003fca:	02090d63          	beqz	s2,80004004 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fce:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fd2:	21848513          	addi	a0,s1,536
    80003fd6:	ffffe097          	auipc	ra,0xffffe
    80003fda:	84e080e7          	jalr	-1970(ra) # 80001824 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fde:	2204b783          	ld	a5,544(s1)
    80003fe2:	eb95                	bnez	a5,80004016 <pipeclose+0x64>
    release(&pi->lock);
    80003fe4:	8526                	mv	a0,s1
    80003fe6:	00002097          	auipc	ra,0x2
    80003fea:	39e080e7          	jalr	926(ra) # 80006384 <release>
    kfree((char*)pi);
    80003fee:	8526                	mv	a0,s1
    80003ff0:	ffffc097          	auipc	ra,0xffffc
    80003ff4:	02c080e7          	jalr	44(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ff8:	60e2                	ld	ra,24(sp)
    80003ffa:	6442                	ld	s0,16(sp)
    80003ffc:	64a2                	ld	s1,8(sp)
    80003ffe:	6902                	ld	s2,0(sp)
    80004000:	6105                	addi	sp,sp,32
    80004002:	8082                	ret
    pi->readopen = 0;
    80004004:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004008:	21c48513          	addi	a0,s1,540
    8000400c:	ffffe097          	auipc	ra,0xffffe
    80004010:	818080e7          	jalr	-2024(ra) # 80001824 <wakeup>
    80004014:	b7e9                	j	80003fde <pipeclose+0x2c>
    release(&pi->lock);
    80004016:	8526                	mv	a0,s1
    80004018:	00002097          	auipc	ra,0x2
    8000401c:	36c080e7          	jalr	876(ra) # 80006384 <release>
}
    80004020:	bfe1                	j	80003ff8 <pipeclose+0x46>

0000000080004022 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004022:	711d                	addi	sp,sp,-96
    80004024:	ec86                	sd	ra,88(sp)
    80004026:	e8a2                	sd	s0,80(sp)
    80004028:	e4a6                	sd	s1,72(sp)
    8000402a:	e0ca                	sd	s2,64(sp)
    8000402c:	fc4e                	sd	s3,56(sp)
    8000402e:	f852                	sd	s4,48(sp)
    80004030:	f456                	sd	s5,40(sp)
    80004032:	f05a                	sd	s6,32(sp)
    80004034:	ec5e                	sd	s7,24(sp)
    80004036:	e862                	sd	s8,16(sp)
    80004038:	1080                	addi	s0,sp,96
    8000403a:	84aa                	mv	s1,a0
    8000403c:	8aae                	mv	s5,a1
    8000403e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004040:	ffffd097          	auipc	ra,0xffffd
    80004044:	f12080e7          	jalr	-238(ra) # 80000f52 <myproc>
    80004048:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000404a:	8526                	mv	a0,s1
    8000404c:	00002097          	auipc	ra,0x2
    80004050:	284080e7          	jalr	644(ra) # 800062d0 <acquire>
  while(i < n){
    80004054:	0b405363          	blez	s4,800040fa <pipewrite+0xd8>
  int i = 0;
    80004058:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000405a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000405c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004060:	21c48b93          	addi	s7,s1,540
    80004064:	a089                	j	800040a6 <pipewrite+0x84>
      release(&pi->lock);
    80004066:	8526                	mv	a0,s1
    80004068:	00002097          	auipc	ra,0x2
    8000406c:	31c080e7          	jalr	796(ra) # 80006384 <release>
      return -1;
    80004070:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004072:	854a                	mv	a0,s2
    80004074:	60e6                	ld	ra,88(sp)
    80004076:	6446                	ld	s0,80(sp)
    80004078:	64a6                	ld	s1,72(sp)
    8000407a:	6906                	ld	s2,64(sp)
    8000407c:	79e2                	ld	s3,56(sp)
    8000407e:	7a42                	ld	s4,48(sp)
    80004080:	7aa2                	ld	s5,40(sp)
    80004082:	7b02                	ld	s6,32(sp)
    80004084:	6be2                	ld	s7,24(sp)
    80004086:	6c42                	ld	s8,16(sp)
    80004088:	6125                	addi	sp,sp,96
    8000408a:	8082                	ret
      wakeup(&pi->nread);
    8000408c:	8562                	mv	a0,s8
    8000408e:	ffffd097          	auipc	ra,0xffffd
    80004092:	796080e7          	jalr	1942(ra) # 80001824 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004096:	85a6                	mv	a1,s1
    80004098:	855e                	mv	a0,s7
    8000409a:	ffffd097          	auipc	ra,0xffffd
    8000409e:	5fe080e7          	jalr	1534(ra) # 80001698 <sleep>
  while(i < n){
    800040a2:	05495d63          	bge	s2,s4,800040fc <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    800040a6:	2204a783          	lw	a5,544(s1)
    800040aa:	dfd5                	beqz	a5,80004066 <pipewrite+0x44>
    800040ac:	0289a783          	lw	a5,40(s3)
    800040b0:	fbdd                	bnez	a5,80004066 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040b2:	2184a783          	lw	a5,536(s1)
    800040b6:	21c4a703          	lw	a4,540(s1)
    800040ba:	2007879b          	addiw	a5,a5,512
    800040be:	fcf707e3          	beq	a4,a5,8000408c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040c2:	4685                	li	a3,1
    800040c4:	01590633          	add	a2,s2,s5
    800040c8:	faf40593          	addi	a1,s0,-81
    800040cc:	0509b503          	ld	a0,80(s3)
    800040d0:	ffffd097          	auipc	ra,0xffffd
    800040d4:	abe080e7          	jalr	-1346(ra) # 80000b8e <copyin>
    800040d8:	03650263          	beq	a0,s6,800040fc <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040dc:	21c4a783          	lw	a5,540(s1)
    800040e0:	0017871b          	addiw	a4,a5,1
    800040e4:	20e4ae23          	sw	a4,540(s1)
    800040e8:	1ff7f793          	andi	a5,a5,511
    800040ec:	97a6                	add	a5,a5,s1
    800040ee:	faf44703          	lbu	a4,-81(s0)
    800040f2:	00e78c23          	sb	a4,24(a5)
      i++;
    800040f6:	2905                	addiw	s2,s2,1
    800040f8:	b76d                	j	800040a2 <pipewrite+0x80>
  int i = 0;
    800040fa:	4901                	li	s2,0
  wakeup(&pi->nread);
    800040fc:	21848513          	addi	a0,s1,536
    80004100:	ffffd097          	auipc	ra,0xffffd
    80004104:	724080e7          	jalr	1828(ra) # 80001824 <wakeup>
  release(&pi->lock);
    80004108:	8526                	mv	a0,s1
    8000410a:	00002097          	auipc	ra,0x2
    8000410e:	27a080e7          	jalr	634(ra) # 80006384 <release>
  return i;
    80004112:	b785                	j	80004072 <pipewrite+0x50>

0000000080004114 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004114:	715d                	addi	sp,sp,-80
    80004116:	e486                	sd	ra,72(sp)
    80004118:	e0a2                	sd	s0,64(sp)
    8000411a:	fc26                	sd	s1,56(sp)
    8000411c:	f84a                	sd	s2,48(sp)
    8000411e:	f44e                	sd	s3,40(sp)
    80004120:	f052                	sd	s4,32(sp)
    80004122:	ec56                	sd	s5,24(sp)
    80004124:	e85a                	sd	s6,16(sp)
    80004126:	0880                	addi	s0,sp,80
    80004128:	84aa                	mv	s1,a0
    8000412a:	892e                	mv	s2,a1
    8000412c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000412e:	ffffd097          	auipc	ra,0xffffd
    80004132:	e24080e7          	jalr	-476(ra) # 80000f52 <myproc>
    80004136:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004138:	8526                	mv	a0,s1
    8000413a:	00002097          	auipc	ra,0x2
    8000413e:	196080e7          	jalr	406(ra) # 800062d0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004142:	2184a703          	lw	a4,536(s1)
    80004146:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000414a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000414e:	02f71463          	bne	a4,a5,80004176 <piperead+0x62>
    80004152:	2244a783          	lw	a5,548(s1)
    80004156:	c385                	beqz	a5,80004176 <piperead+0x62>
    if(pr->killed){
    80004158:	028a2783          	lw	a5,40(s4)
    8000415c:	ebc1                	bnez	a5,800041ec <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000415e:	85a6                	mv	a1,s1
    80004160:	854e                	mv	a0,s3
    80004162:	ffffd097          	auipc	ra,0xffffd
    80004166:	536080e7          	jalr	1334(ra) # 80001698 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000416a:	2184a703          	lw	a4,536(s1)
    8000416e:	21c4a783          	lw	a5,540(s1)
    80004172:	fef700e3          	beq	a4,a5,80004152 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004176:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004178:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000417a:	05505363          	blez	s5,800041c0 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    8000417e:	2184a783          	lw	a5,536(s1)
    80004182:	21c4a703          	lw	a4,540(s1)
    80004186:	02f70d63          	beq	a4,a5,800041c0 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000418a:	0017871b          	addiw	a4,a5,1
    8000418e:	20e4ac23          	sw	a4,536(s1)
    80004192:	1ff7f793          	andi	a5,a5,511
    80004196:	97a6                	add	a5,a5,s1
    80004198:	0187c783          	lbu	a5,24(a5)
    8000419c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041a0:	4685                	li	a3,1
    800041a2:	fbf40613          	addi	a2,s0,-65
    800041a6:	85ca                	mv	a1,s2
    800041a8:	050a3503          	ld	a0,80(s4)
    800041ac:	ffffd097          	auipc	ra,0xffffd
    800041b0:	956080e7          	jalr	-1706(ra) # 80000b02 <copyout>
    800041b4:	01650663          	beq	a0,s6,800041c0 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041b8:	2985                	addiw	s3,s3,1
    800041ba:	0905                	addi	s2,s2,1
    800041bc:	fd3a91e3          	bne	s5,s3,8000417e <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041c0:	21c48513          	addi	a0,s1,540
    800041c4:	ffffd097          	auipc	ra,0xffffd
    800041c8:	660080e7          	jalr	1632(ra) # 80001824 <wakeup>
  release(&pi->lock);
    800041cc:	8526                	mv	a0,s1
    800041ce:	00002097          	auipc	ra,0x2
    800041d2:	1b6080e7          	jalr	438(ra) # 80006384 <release>
  return i;
}
    800041d6:	854e                	mv	a0,s3
    800041d8:	60a6                	ld	ra,72(sp)
    800041da:	6406                	ld	s0,64(sp)
    800041dc:	74e2                	ld	s1,56(sp)
    800041de:	7942                	ld	s2,48(sp)
    800041e0:	79a2                	ld	s3,40(sp)
    800041e2:	7a02                	ld	s4,32(sp)
    800041e4:	6ae2                	ld	s5,24(sp)
    800041e6:	6b42                	ld	s6,16(sp)
    800041e8:	6161                	addi	sp,sp,80
    800041ea:	8082                	ret
      release(&pi->lock);
    800041ec:	8526                	mv	a0,s1
    800041ee:	00002097          	auipc	ra,0x2
    800041f2:	196080e7          	jalr	406(ra) # 80006384 <release>
      return -1;
    800041f6:	59fd                	li	s3,-1
    800041f8:	bff9                	j	800041d6 <piperead+0xc2>

00000000800041fa <exec>:
static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);
extern void vmprint(pagetable_t);

int
exec(char *path, char **argv)
{
    800041fa:	de010113          	addi	sp,sp,-544
    800041fe:	20113c23          	sd	ra,536(sp)
    80004202:	20813823          	sd	s0,528(sp)
    80004206:	20913423          	sd	s1,520(sp)
    8000420a:	21213023          	sd	s2,512(sp)
    8000420e:	ffce                	sd	s3,504(sp)
    80004210:	fbd2                	sd	s4,496(sp)
    80004212:	f7d6                	sd	s5,488(sp)
    80004214:	f3da                	sd	s6,480(sp)
    80004216:	efde                	sd	s7,472(sp)
    80004218:	ebe2                	sd	s8,464(sp)
    8000421a:	e7e6                	sd	s9,456(sp)
    8000421c:	e3ea                	sd	s10,448(sp)
    8000421e:	ff6e                	sd	s11,440(sp)
    80004220:	1400                	addi	s0,sp,544
    80004222:	892a                	mv	s2,a0
    80004224:	dea43423          	sd	a0,-536(s0)
    80004228:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	d26080e7          	jalr	-730(ra) # 80000f52 <myproc>
    80004234:	84aa                	mv	s1,a0

  begin_op();
    80004236:	fffff097          	auipc	ra,0xfffff
    8000423a:	4a6080e7          	jalr	1190(ra) # 800036dc <begin_op>

  if((ip = namei(path)) == 0){
    8000423e:	854a                	mv	a0,s2
    80004240:	fffff097          	auipc	ra,0xfffff
    80004244:	280080e7          	jalr	640(ra) # 800034c0 <namei>
    80004248:	c93d                	beqz	a0,800042be <exec+0xc4>
    8000424a:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000424c:	fffff097          	auipc	ra,0xfffff
    80004250:	abe080e7          	jalr	-1346(ra) # 80002d0a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004254:	04000713          	li	a4,64
    80004258:	4681                	li	a3,0
    8000425a:	e5040613          	addi	a2,s0,-432
    8000425e:	4581                	li	a1,0
    80004260:	8556                	mv	a0,s5
    80004262:	fffff097          	auipc	ra,0xfffff
    80004266:	d5c080e7          	jalr	-676(ra) # 80002fbe <readi>
    8000426a:	04000793          	li	a5,64
    8000426e:	00f51a63          	bne	a0,a5,80004282 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004272:	e5042703          	lw	a4,-432(s0)
    80004276:	464c47b7          	lui	a5,0x464c4
    8000427a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000427e:	04f70663          	beq	a4,a5,800042ca <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004282:	8556                	mv	a0,s5
    80004284:	fffff097          	auipc	ra,0xfffff
    80004288:	ce8080e7          	jalr	-792(ra) # 80002f6c <iunlockput>
    end_op();
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	4d0080e7          	jalr	1232(ra) # 8000375c <end_op>
  }
  return -1;
    80004294:	557d                	li	a0,-1
}
    80004296:	21813083          	ld	ra,536(sp)
    8000429a:	21013403          	ld	s0,528(sp)
    8000429e:	20813483          	ld	s1,520(sp)
    800042a2:	20013903          	ld	s2,512(sp)
    800042a6:	79fe                	ld	s3,504(sp)
    800042a8:	7a5e                	ld	s4,496(sp)
    800042aa:	7abe                	ld	s5,488(sp)
    800042ac:	7b1e                	ld	s6,480(sp)
    800042ae:	6bfe                	ld	s7,472(sp)
    800042b0:	6c5e                	ld	s8,464(sp)
    800042b2:	6cbe                	ld	s9,456(sp)
    800042b4:	6d1e                	ld	s10,448(sp)
    800042b6:	7dfa                	ld	s11,440(sp)
    800042b8:	22010113          	addi	sp,sp,544
    800042bc:	8082                	ret
    end_op();
    800042be:	fffff097          	auipc	ra,0xfffff
    800042c2:	49e080e7          	jalr	1182(ra) # 8000375c <end_op>
    return -1;
    800042c6:	557d                	li	a0,-1
    800042c8:	b7f9                	j	80004296 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800042ca:	8526                	mv	a0,s1
    800042cc:	ffffd097          	auipc	ra,0xffffd
    800042d0:	d4a080e7          	jalr	-694(ra) # 80001016 <proc_pagetable>
    800042d4:	8b2a                	mv	s6,a0
    800042d6:	d555                	beqz	a0,80004282 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042d8:	e7042783          	lw	a5,-400(s0)
    800042dc:	e8845703          	lhu	a4,-376(s0)
    800042e0:	c735                	beqz	a4,8000434c <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042e2:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042e4:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800042e8:	6a05                	lui	s4,0x1
    800042ea:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800042ee:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800042f2:	6d85                	lui	s11,0x1
    800042f4:	7d7d                	lui	s10,0xfffff
    800042f6:	a4b9                	j	80004544 <exec+0x34a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042f8:	00004517          	auipc	a0,0x4
    800042fc:	29850513          	addi	a0,a0,664 # 80008590 <etext+0x590>
    80004300:	00002097          	auipc	ra,0x2
    80004304:	a94080e7          	jalr	-1388(ra) # 80005d94 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004308:	874a                	mv	a4,s2
    8000430a:	009c86bb          	addw	a3,s9,s1
    8000430e:	4581                	li	a1,0
    80004310:	8556                	mv	a0,s5
    80004312:	fffff097          	auipc	ra,0xfffff
    80004316:	cac080e7          	jalr	-852(ra) # 80002fbe <readi>
    8000431a:	2501                	sext.w	a0,a0
    8000431c:	1ca91463          	bne	s2,a0,800044e4 <exec+0x2ea>
  for(i = 0; i < sz; i += PGSIZE){
    80004320:	009d84bb          	addw	s1,s11,s1
    80004324:	013d09bb          	addw	s3,s10,s3
    80004328:	1f74fe63          	bgeu	s1,s7,80004524 <exec+0x32a>
    pa = walkaddr(pagetable, va + i);
    8000432c:	02049593          	slli	a1,s1,0x20
    80004330:	9181                	srli	a1,a1,0x20
    80004332:	95e2                	add	a1,a1,s8
    80004334:	855a                	mv	a0,s6
    80004336:	ffffc097          	auipc	ra,0xffffc
    8000433a:	1c8080e7          	jalr	456(ra) # 800004fe <walkaddr>
    8000433e:	862a                	mv	a2,a0
    if(pa == 0)
    80004340:	dd45                	beqz	a0,800042f8 <exec+0xfe>
      n = PGSIZE;
    80004342:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004344:	fd49f2e3          	bgeu	s3,s4,80004308 <exec+0x10e>
      n = sz - i;
    80004348:	894e                	mv	s2,s3
    8000434a:	bf7d                	j	80004308 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000434c:	4481                	li	s1,0
  iunlockput(ip);
    8000434e:	8556                	mv	a0,s5
    80004350:	fffff097          	auipc	ra,0xfffff
    80004354:	c1c080e7          	jalr	-996(ra) # 80002f6c <iunlockput>
  end_op();
    80004358:	fffff097          	auipc	ra,0xfffff
    8000435c:	404080e7          	jalr	1028(ra) # 8000375c <end_op>
  p = myproc();
    80004360:	ffffd097          	auipc	ra,0xffffd
    80004364:	bf2080e7          	jalr	-1038(ra) # 80000f52 <myproc>
    80004368:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000436a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000436e:	6785                	lui	a5,0x1
    80004370:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004372:	94be                	add	s1,s1,a5
    80004374:	77fd                	lui	a5,0xfffff
    80004376:	8fe5                	and	a5,a5,s1
    80004378:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000437c:	6609                	lui	a2,0x2
    8000437e:	963e                	add	a2,a2,a5
    80004380:	85be                	mv	a1,a5
    80004382:	855a                	mv	a0,s6
    80004384:	ffffc097          	auipc	ra,0xffffc
    80004388:	52e080e7          	jalr	1326(ra) # 800008b2 <uvmalloc>
    8000438c:	8c2a                	mv	s8,a0
  ip = 0;
    8000438e:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004390:	14050a63          	beqz	a0,800044e4 <exec+0x2ea>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004394:	75f9                	lui	a1,0xffffe
    80004396:	95aa                	add	a1,a1,a0
    80004398:	855a                	mv	a0,s6
    8000439a:	ffffc097          	auipc	ra,0xffffc
    8000439e:	736080e7          	jalr	1846(ra) # 80000ad0 <uvmclear>
  stackbase = sp - PGSIZE;
    800043a2:	7afd                	lui	s5,0xfffff
    800043a4:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800043a6:	df043783          	ld	a5,-528(s0)
    800043aa:	6388                	ld	a0,0(a5)
    800043ac:	c925                	beqz	a0,8000441c <exec+0x222>
    800043ae:	e9040993          	addi	s3,s0,-368
    800043b2:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043b6:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043b8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043ba:	ffffc097          	auipc	ra,0xffffc
    800043be:	f3a080e7          	jalr	-198(ra) # 800002f4 <strlen>
    800043c2:	0015079b          	addiw	a5,a0,1
    800043c6:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043ca:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043ce:	13596f63          	bltu	s2,s5,8000450c <exec+0x312>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043d2:	df043d83          	ld	s11,-528(s0)
    800043d6:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800043da:	8552                	mv	a0,s4
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	f18080e7          	jalr	-232(ra) # 800002f4 <strlen>
    800043e4:	0015069b          	addiw	a3,a0,1
    800043e8:	8652                	mv	a2,s4
    800043ea:	85ca                	mv	a1,s2
    800043ec:	855a                	mv	a0,s6
    800043ee:	ffffc097          	auipc	ra,0xffffc
    800043f2:	714080e7          	jalr	1812(ra) # 80000b02 <copyout>
    800043f6:	10054f63          	bltz	a0,80004514 <exec+0x31a>
    ustack[argc] = sp;
    800043fa:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043fe:	0485                	addi	s1,s1,1
    80004400:	008d8793          	addi	a5,s11,8
    80004404:	def43823          	sd	a5,-528(s0)
    80004408:	008db503          	ld	a0,8(s11)
    8000440c:	c911                	beqz	a0,80004420 <exec+0x226>
    if(argc >= MAXARG)
    8000440e:	09a1                	addi	s3,s3,8
    80004410:	fb3c95e3          	bne	s9,s3,800043ba <exec+0x1c0>
  sz = sz1;
    80004414:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004418:	4a81                	li	s5,0
    8000441a:	a0e9                	j	800044e4 <exec+0x2ea>
  sp = sz;
    8000441c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000441e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004420:	00349793          	slli	a5,s1,0x3
    80004424:	f9040713          	addi	a4,s0,-112
    80004428:	97ba                	add	a5,a5,a4
    8000442a:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd8cc0>
  sp -= (argc+1) * sizeof(uint64);
    8000442e:	00148693          	addi	a3,s1,1
    80004432:	068e                	slli	a3,a3,0x3
    80004434:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004438:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000443c:	01597663          	bgeu	s2,s5,80004448 <exec+0x24e>
  sz = sz1;
    80004440:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004444:	4a81                	li	s5,0
    80004446:	a879                	j	800044e4 <exec+0x2ea>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004448:	e9040613          	addi	a2,s0,-368
    8000444c:	85ca                	mv	a1,s2
    8000444e:	855a                	mv	a0,s6
    80004450:	ffffc097          	auipc	ra,0xffffc
    80004454:	6b2080e7          	jalr	1714(ra) # 80000b02 <copyout>
    80004458:	0c054263          	bltz	a0,8000451c <exec+0x322>
  p->trapframe->a1 = sp;
    8000445c:	058bb783          	ld	a5,88(s7)
    80004460:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004464:	de843783          	ld	a5,-536(s0)
    80004468:	0007c703          	lbu	a4,0(a5)
    8000446c:	cf11                	beqz	a4,80004488 <exec+0x28e>
    8000446e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004470:	02f00693          	li	a3,47
    80004474:	a039                	j	80004482 <exec+0x288>
      last = s+1;
    80004476:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000447a:	0785                	addi	a5,a5,1
    8000447c:	fff7c703          	lbu	a4,-1(a5)
    80004480:	c701                	beqz	a4,80004488 <exec+0x28e>
    if(*s == '/')
    80004482:	fed71ce3          	bne	a4,a3,8000447a <exec+0x280>
    80004486:	bfc5                	j	80004476 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004488:	4641                	li	a2,16
    8000448a:	de843583          	ld	a1,-536(s0)
    8000448e:	158b8513          	addi	a0,s7,344
    80004492:	ffffc097          	auipc	ra,0xffffc
    80004496:	e30080e7          	jalr	-464(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000449a:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000449e:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800044a2:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044a6:	058bb783          	ld	a5,88(s7)
    800044aa:	e6843703          	ld	a4,-408(s0)
    800044ae:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044b0:	058bb783          	ld	a5,88(s7)
    800044b4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044b8:	85ea                	mv	a1,s10
    800044ba:	ffffd097          	auipc	ra,0xffffd
    800044be:	c26080e7          	jalr	-986(ra) # 800010e0 <proc_freepagetable>
  if(p->pid==1) vmprint(p->pagetable);
    800044c2:	030ba703          	lw	a4,48(s7)
    800044c6:	4785                	li	a5,1
    800044c8:	00f70563          	beq	a4,a5,800044d2 <exec+0x2d8>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044cc:	0004851b          	sext.w	a0,s1
    800044d0:	b3d9                	j	80004296 <exec+0x9c>
  if(p->pid==1) vmprint(p->pagetable);
    800044d2:	050bb503          	ld	a0,80(s7)
    800044d6:	ffffd097          	auipc	ra,0xffffd
    800044da:	8da080e7          	jalr	-1830(ra) # 80000db0 <vmprint>
    800044de:	b7fd                	j	800044cc <exec+0x2d2>
    800044e0:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800044e4:	df843583          	ld	a1,-520(s0)
    800044e8:	855a                	mv	a0,s6
    800044ea:	ffffd097          	auipc	ra,0xffffd
    800044ee:	bf6080e7          	jalr	-1034(ra) # 800010e0 <proc_freepagetable>
  if(ip){
    800044f2:	d80a98e3          	bnez	s5,80004282 <exec+0x88>
  return -1;
    800044f6:	557d                	li	a0,-1
    800044f8:	bb79                	j	80004296 <exec+0x9c>
    800044fa:	de943c23          	sd	s1,-520(s0)
    800044fe:	b7dd                	j	800044e4 <exec+0x2ea>
    80004500:	de943c23          	sd	s1,-520(s0)
    80004504:	b7c5                	j	800044e4 <exec+0x2ea>
    80004506:	de943c23          	sd	s1,-520(s0)
    8000450a:	bfe9                	j	800044e4 <exec+0x2ea>
  sz = sz1;
    8000450c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004510:	4a81                	li	s5,0
    80004512:	bfc9                	j	800044e4 <exec+0x2ea>
  sz = sz1;
    80004514:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004518:	4a81                	li	s5,0
    8000451a:	b7e9                	j	800044e4 <exec+0x2ea>
  sz = sz1;
    8000451c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004520:	4a81                	li	s5,0
    80004522:	b7c9                	j	800044e4 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004524:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004528:	e0843783          	ld	a5,-504(s0)
    8000452c:	0017869b          	addiw	a3,a5,1
    80004530:	e0d43423          	sd	a3,-504(s0)
    80004534:	e0043783          	ld	a5,-512(s0)
    80004538:	0387879b          	addiw	a5,a5,56
    8000453c:	e8845703          	lhu	a4,-376(s0)
    80004540:	e0e6d7e3          	bge	a3,a4,8000434e <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004544:	2781                	sext.w	a5,a5
    80004546:	e0f43023          	sd	a5,-512(s0)
    8000454a:	03800713          	li	a4,56
    8000454e:	86be                	mv	a3,a5
    80004550:	e1840613          	addi	a2,s0,-488
    80004554:	4581                	li	a1,0
    80004556:	8556                	mv	a0,s5
    80004558:	fffff097          	auipc	ra,0xfffff
    8000455c:	a66080e7          	jalr	-1434(ra) # 80002fbe <readi>
    80004560:	03800793          	li	a5,56
    80004564:	f6f51ee3          	bne	a0,a5,800044e0 <exec+0x2e6>
    if(ph.type != ELF_PROG_LOAD)
    80004568:	e1842783          	lw	a5,-488(s0)
    8000456c:	4705                	li	a4,1
    8000456e:	fae79de3          	bne	a5,a4,80004528 <exec+0x32e>
    if(ph.memsz < ph.filesz)
    80004572:	e4043603          	ld	a2,-448(s0)
    80004576:	e3843783          	ld	a5,-456(s0)
    8000457a:	f8f660e3          	bltu	a2,a5,800044fa <exec+0x300>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000457e:	e2843783          	ld	a5,-472(s0)
    80004582:	963e                	add	a2,a2,a5
    80004584:	f6f66ee3          	bltu	a2,a5,80004500 <exec+0x306>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004588:	85a6                	mv	a1,s1
    8000458a:	855a                	mv	a0,s6
    8000458c:	ffffc097          	auipc	ra,0xffffc
    80004590:	326080e7          	jalr	806(ra) # 800008b2 <uvmalloc>
    80004594:	dea43c23          	sd	a0,-520(s0)
    80004598:	d53d                	beqz	a0,80004506 <exec+0x30c>
    if((ph.vaddr % PGSIZE) != 0)
    8000459a:	e2843c03          	ld	s8,-472(s0)
    8000459e:	de043783          	ld	a5,-544(s0)
    800045a2:	00fc77b3          	and	a5,s8,a5
    800045a6:	ff9d                	bnez	a5,800044e4 <exec+0x2ea>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045a8:	e2042c83          	lw	s9,-480(s0)
    800045ac:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045b0:	f60b8ae3          	beqz	s7,80004524 <exec+0x32a>
    800045b4:	89de                	mv	s3,s7
    800045b6:	4481                	li	s1,0
    800045b8:	bb95                	j	8000432c <exec+0x132>

00000000800045ba <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045ba:	7179                	addi	sp,sp,-48
    800045bc:	f406                	sd	ra,40(sp)
    800045be:	f022                	sd	s0,32(sp)
    800045c0:	ec26                	sd	s1,24(sp)
    800045c2:	e84a                	sd	s2,16(sp)
    800045c4:	1800                	addi	s0,sp,48
    800045c6:	892e                	mv	s2,a1
    800045c8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045ca:	fdc40593          	addi	a1,s0,-36
    800045ce:	ffffe097          	auipc	ra,0xffffe
    800045d2:	aba080e7          	jalr	-1350(ra) # 80002088 <argint>
    800045d6:	04054063          	bltz	a0,80004616 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045da:	fdc42703          	lw	a4,-36(s0)
    800045de:	47bd                	li	a5,15
    800045e0:	02e7ed63          	bltu	a5,a4,8000461a <argfd+0x60>
    800045e4:	ffffd097          	auipc	ra,0xffffd
    800045e8:	96e080e7          	jalr	-1682(ra) # 80000f52 <myproc>
    800045ec:	fdc42703          	lw	a4,-36(s0)
    800045f0:	01a70793          	addi	a5,a4,26
    800045f4:	078e                	slli	a5,a5,0x3
    800045f6:	953e                	add	a0,a0,a5
    800045f8:	611c                	ld	a5,0(a0)
    800045fa:	c395                	beqz	a5,8000461e <argfd+0x64>
    return -1;
  if(pfd)
    800045fc:	00090463          	beqz	s2,80004604 <argfd+0x4a>
    *pfd = fd;
    80004600:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004604:	4501                	li	a0,0
  if(pf)
    80004606:	c091                	beqz	s1,8000460a <argfd+0x50>
    *pf = f;
    80004608:	e09c                	sd	a5,0(s1)
}
    8000460a:	70a2                	ld	ra,40(sp)
    8000460c:	7402                	ld	s0,32(sp)
    8000460e:	64e2                	ld	s1,24(sp)
    80004610:	6942                	ld	s2,16(sp)
    80004612:	6145                	addi	sp,sp,48
    80004614:	8082                	ret
    return -1;
    80004616:	557d                	li	a0,-1
    80004618:	bfcd                	j	8000460a <argfd+0x50>
    return -1;
    8000461a:	557d                	li	a0,-1
    8000461c:	b7fd                	j	8000460a <argfd+0x50>
    8000461e:	557d                	li	a0,-1
    80004620:	b7ed                	j	8000460a <argfd+0x50>

0000000080004622 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004622:	1101                	addi	sp,sp,-32
    80004624:	ec06                	sd	ra,24(sp)
    80004626:	e822                	sd	s0,16(sp)
    80004628:	e426                	sd	s1,8(sp)
    8000462a:	1000                	addi	s0,sp,32
    8000462c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000462e:	ffffd097          	auipc	ra,0xffffd
    80004632:	924080e7          	jalr	-1756(ra) # 80000f52 <myproc>
    80004636:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004638:	0d050793          	addi	a5,a0,208
    8000463c:	4501                	li	a0,0
    8000463e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004640:	6398                	ld	a4,0(a5)
    80004642:	cb19                	beqz	a4,80004658 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004644:	2505                	addiw	a0,a0,1
    80004646:	07a1                	addi	a5,a5,8
    80004648:	fed51ce3          	bne	a0,a3,80004640 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000464c:	557d                	li	a0,-1
}
    8000464e:	60e2                	ld	ra,24(sp)
    80004650:	6442                	ld	s0,16(sp)
    80004652:	64a2                	ld	s1,8(sp)
    80004654:	6105                	addi	sp,sp,32
    80004656:	8082                	ret
      p->ofile[fd] = f;
    80004658:	01a50793          	addi	a5,a0,26
    8000465c:	078e                	slli	a5,a5,0x3
    8000465e:	963e                	add	a2,a2,a5
    80004660:	e204                	sd	s1,0(a2)
      return fd;
    80004662:	b7f5                	j	8000464e <fdalloc+0x2c>

0000000080004664 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004664:	715d                	addi	sp,sp,-80
    80004666:	e486                	sd	ra,72(sp)
    80004668:	e0a2                	sd	s0,64(sp)
    8000466a:	fc26                	sd	s1,56(sp)
    8000466c:	f84a                	sd	s2,48(sp)
    8000466e:	f44e                	sd	s3,40(sp)
    80004670:	f052                	sd	s4,32(sp)
    80004672:	ec56                	sd	s5,24(sp)
    80004674:	0880                	addi	s0,sp,80
    80004676:	89ae                	mv	s3,a1
    80004678:	8ab2                	mv	s5,a2
    8000467a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000467c:	fb040593          	addi	a1,s0,-80
    80004680:	fffff097          	auipc	ra,0xfffff
    80004684:	e5e080e7          	jalr	-418(ra) # 800034de <nameiparent>
    80004688:	892a                	mv	s2,a0
    8000468a:	12050e63          	beqz	a0,800047c6 <create+0x162>
    return 0;

  ilock(dp);
    8000468e:	ffffe097          	auipc	ra,0xffffe
    80004692:	67c080e7          	jalr	1660(ra) # 80002d0a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004696:	4601                	li	a2,0
    80004698:	fb040593          	addi	a1,s0,-80
    8000469c:	854a                	mv	a0,s2
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	b50080e7          	jalr	-1200(ra) # 800031ee <dirlookup>
    800046a6:	84aa                	mv	s1,a0
    800046a8:	c921                	beqz	a0,800046f8 <create+0x94>
    iunlockput(dp);
    800046aa:	854a                	mv	a0,s2
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	8c0080e7          	jalr	-1856(ra) # 80002f6c <iunlockput>
    ilock(ip);
    800046b4:	8526                	mv	a0,s1
    800046b6:	ffffe097          	auipc	ra,0xffffe
    800046ba:	654080e7          	jalr	1620(ra) # 80002d0a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046be:	2981                	sext.w	s3,s3
    800046c0:	4789                	li	a5,2
    800046c2:	02f99463          	bne	s3,a5,800046ea <create+0x86>
    800046c6:	0444d783          	lhu	a5,68(s1)
    800046ca:	37f9                	addiw	a5,a5,-2
    800046cc:	17c2                	slli	a5,a5,0x30
    800046ce:	93c1                	srli	a5,a5,0x30
    800046d0:	4705                	li	a4,1
    800046d2:	00f76c63          	bltu	a4,a5,800046ea <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046d6:	8526                	mv	a0,s1
    800046d8:	60a6                	ld	ra,72(sp)
    800046da:	6406                	ld	s0,64(sp)
    800046dc:	74e2                	ld	s1,56(sp)
    800046de:	7942                	ld	s2,48(sp)
    800046e0:	79a2                	ld	s3,40(sp)
    800046e2:	7a02                	ld	s4,32(sp)
    800046e4:	6ae2                	ld	s5,24(sp)
    800046e6:	6161                	addi	sp,sp,80
    800046e8:	8082                	ret
    iunlockput(ip);
    800046ea:	8526                	mv	a0,s1
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	880080e7          	jalr	-1920(ra) # 80002f6c <iunlockput>
    return 0;
    800046f4:	4481                	li	s1,0
    800046f6:	b7c5                	j	800046d6 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046f8:	85ce                	mv	a1,s3
    800046fa:	00092503          	lw	a0,0(s2)
    800046fe:	ffffe097          	auipc	ra,0xffffe
    80004702:	474080e7          	jalr	1140(ra) # 80002b72 <ialloc>
    80004706:	84aa                	mv	s1,a0
    80004708:	c521                	beqz	a0,80004750 <create+0xec>
  ilock(ip);
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	600080e7          	jalr	1536(ra) # 80002d0a <ilock>
  ip->major = major;
    80004712:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004716:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000471a:	4a05                	li	s4,1
    8000471c:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004720:	8526                	mv	a0,s1
    80004722:	ffffe097          	auipc	ra,0xffffe
    80004726:	51e080e7          	jalr	1310(ra) # 80002c40 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000472a:	2981                	sext.w	s3,s3
    8000472c:	03498a63          	beq	s3,s4,80004760 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004730:	40d0                	lw	a2,4(s1)
    80004732:	fb040593          	addi	a1,s0,-80
    80004736:	854a                	mv	a0,s2
    80004738:	fffff097          	auipc	ra,0xfffff
    8000473c:	cc6080e7          	jalr	-826(ra) # 800033fe <dirlink>
    80004740:	06054b63          	bltz	a0,800047b6 <create+0x152>
  iunlockput(dp);
    80004744:	854a                	mv	a0,s2
    80004746:	fffff097          	auipc	ra,0xfffff
    8000474a:	826080e7          	jalr	-2010(ra) # 80002f6c <iunlockput>
  return ip;
    8000474e:	b761                	j	800046d6 <create+0x72>
    panic("create: ialloc");
    80004750:	00004517          	auipc	a0,0x4
    80004754:	e6050513          	addi	a0,a0,-416 # 800085b0 <etext+0x5b0>
    80004758:	00001097          	auipc	ra,0x1
    8000475c:	63c080e7          	jalr	1596(ra) # 80005d94 <panic>
    dp->nlink++;  // for ".."
    80004760:	04a95783          	lhu	a5,74(s2)
    80004764:	2785                	addiw	a5,a5,1
    80004766:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000476a:	854a                	mv	a0,s2
    8000476c:	ffffe097          	auipc	ra,0xffffe
    80004770:	4d4080e7          	jalr	1236(ra) # 80002c40 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004774:	40d0                	lw	a2,4(s1)
    80004776:	00004597          	auipc	a1,0x4
    8000477a:	e4a58593          	addi	a1,a1,-438 # 800085c0 <etext+0x5c0>
    8000477e:	8526                	mv	a0,s1
    80004780:	fffff097          	auipc	ra,0xfffff
    80004784:	c7e080e7          	jalr	-898(ra) # 800033fe <dirlink>
    80004788:	00054f63          	bltz	a0,800047a6 <create+0x142>
    8000478c:	00492603          	lw	a2,4(s2)
    80004790:	00004597          	auipc	a1,0x4
    80004794:	e3858593          	addi	a1,a1,-456 # 800085c8 <etext+0x5c8>
    80004798:	8526                	mv	a0,s1
    8000479a:	fffff097          	auipc	ra,0xfffff
    8000479e:	c64080e7          	jalr	-924(ra) # 800033fe <dirlink>
    800047a2:	f80557e3          	bgez	a0,80004730 <create+0xcc>
      panic("create dots");
    800047a6:	00004517          	auipc	a0,0x4
    800047aa:	e2a50513          	addi	a0,a0,-470 # 800085d0 <etext+0x5d0>
    800047ae:	00001097          	auipc	ra,0x1
    800047b2:	5e6080e7          	jalr	1510(ra) # 80005d94 <panic>
    panic("create: dirlink");
    800047b6:	00004517          	auipc	a0,0x4
    800047ba:	e2a50513          	addi	a0,a0,-470 # 800085e0 <etext+0x5e0>
    800047be:	00001097          	auipc	ra,0x1
    800047c2:	5d6080e7          	jalr	1494(ra) # 80005d94 <panic>
    return 0;
    800047c6:	84aa                	mv	s1,a0
    800047c8:	b739                	j	800046d6 <create+0x72>

00000000800047ca <sys_dup>:
{
    800047ca:	7179                	addi	sp,sp,-48
    800047cc:	f406                	sd	ra,40(sp)
    800047ce:	f022                	sd	s0,32(sp)
    800047d0:	ec26                	sd	s1,24(sp)
    800047d2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047d4:	fd840613          	addi	a2,s0,-40
    800047d8:	4581                	li	a1,0
    800047da:	4501                	li	a0,0
    800047dc:	00000097          	auipc	ra,0x0
    800047e0:	dde080e7          	jalr	-546(ra) # 800045ba <argfd>
    return -1;
    800047e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047e6:	02054363          	bltz	a0,8000480c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047ea:	fd843503          	ld	a0,-40(s0)
    800047ee:	00000097          	auipc	ra,0x0
    800047f2:	e34080e7          	jalr	-460(ra) # 80004622 <fdalloc>
    800047f6:	84aa                	mv	s1,a0
    return -1;
    800047f8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047fa:	00054963          	bltz	a0,8000480c <sys_dup+0x42>
  filedup(f);
    800047fe:	fd843503          	ld	a0,-40(s0)
    80004802:	fffff097          	auipc	ra,0xfffff
    80004806:	354080e7          	jalr	852(ra) # 80003b56 <filedup>
  return fd;
    8000480a:	87a6                	mv	a5,s1
}
    8000480c:	853e                	mv	a0,a5
    8000480e:	70a2                	ld	ra,40(sp)
    80004810:	7402                	ld	s0,32(sp)
    80004812:	64e2                	ld	s1,24(sp)
    80004814:	6145                	addi	sp,sp,48
    80004816:	8082                	ret

0000000080004818 <sys_read>:
{
    80004818:	7179                	addi	sp,sp,-48
    8000481a:	f406                	sd	ra,40(sp)
    8000481c:	f022                	sd	s0,32(sp)
    8000481e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004820:	fe840613          	addi	a2,s0,-24
    80004824:	4581                	li	a1,0
    80004826:	4501                	li	a0,0
    80004828:	00000097          	auipc	ra,0x0
    8000482c:	d92080e7          	jalr	-622(ra) # 800045ba <argfd>
    return -1;
    80004830:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004832:	04054163          	bltz	a0,80004874 <sys_read+0x5c>
    80004836:	fe440593          	addi	a1,s0,-28
    8000483a:	4509                	li	a0,2
    8000483c:	ffffe097          	auipc	ra,0xffffe
    80004840:	84c080e7          	jalr	-1972(ra) # 80002088 <argint>
    return -1;
    80004844:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004846:	02054763          	bltz	a0,80004874 <sys_read+0x5c>
    8000484a:	fd840593          	addi	a1,s0,-40
    8000484e:	4505                	li	a0,1
    80004850:	ffffe097          	auipc	ra,0xffffe
    80004854:	85a080e7          	jalr	-1958(ra) # 800020aa <argaddr>
    return -1;
    80004858:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000485a:	00054d63          	bltz	a0,80004874 <sys_read+0x5c>
  return fileread(f, p, n);
    8000485e:	fe442603          	lw	a2,-28(s0)
    80004862:	fd843583          	ld	a1,-40(s0)
    80004866:	fe843503          	ld	a0,-24(s0)
    8000486a:	fffff097          	auipc	ra,0xfffff
    8000486e:	478080e7          	jalr	1144(ra) # 80003ce2 <fileread>
    80004872:	87aa                	mv	a5,a0
}
    80004874:	853e                	mv	a0,a5
    80004876:	70a2                	ld	ra,40(sp)
    80004878:	7402                	ld	s0,32(sp)
    8000487a:	6145                	addi	sp,sp,48
    8000487c:	8082                	ret

000000008000487e <sys_write>:
{
    8000487e:	7179                	addi	sp,sp,-48
    80004880:	f406                	sd	ra,40(sp)
    80004882:	f022                	sd	s0,32(sp)
    80004884:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004886:	fe840613          	addi	a2,s0,-24
    8000488a:	4581                	li	a1,0
    8000488c:	4501                	li	a0,0
    8000488e:	00000097          	auipc	ra,0x0
    80004892:	d2c080e7          	jalr	-724(ra) # 800045ba <argfd>
    return -1;
    80004896:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004898:	04054163          	bltz	a0,800048da <sys_write+0x5c>
    8000489c:	fe440593          	addi	a1,s0,-28
    800048a0:	4509                	li	a0,2
    800048a2:	ffffd097          	auipc	ra,0xffffd
    800048a6:	7e6080e7          	jalr	2022(ra) # 80002088 <argint>
    return -1;
    800048aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ac:	02054763          	bltz	a0,800048da <sys_write+0x5c>
    800048b0:	fd840593          	addi	a1,s0,-40
    800048b4:	4505                	li	a0,1
    800048b6:	ffffd097          	auipc	ra,0xffffd
    800048ba:	7f4080e7          	jalr	2036(ra) # 800020aa <argaddr>
    return -1;
    800048be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c0:	00054d63          	bltz	a0,800048da <sys_write+0x5c>
  return filewrite(f, p, n);
    800048c4:	fe442603          	lw	a2,-28(s0)
    800048c8:	fd843583          	ld	a1,-40(s0)
    800048cc:	fe843503          	ld	a0,-24(s0)
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	4d4080e7          	jalr	1236(ra) # 80003da4 <filewrite>
    800048d8:	87aa                	mv	a5,a0
}
    800048da:	853e                	mv	a0,a5
    800048dc:	70a2                	ld	ra,40(sp)
    800048de:	7402                	ld	s0,32(sp)
    800048e0:	6145                	addi	sp,sp,48
    800048e2:	8082                	ret

00000000800048e4 <sys_close>:
{
    800048e4:	1101                	addi	sp,sp,-32
    800048e6:	ec06                	sd	ra,24(sp)
    800048e8:	e822                	sd	s0,16(sp)
    800048ea:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048ec:	fe040613          	addi	a2,s0,-32
    800048f0:	fec40593          	addi	a1,s0,-20
    800048f4:	4501                	li	a0,0
    800048f6:	00000097          	auipc	ra,0x0
    800048fa:	cc4080e7          	jalr	-828(ra) # 800045ba <argfd>
    return -1;
    800048fe:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004900:	02054463          	bltz	a0,80004928 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004904:	ffffc097          	auipc	ra,0xffffc
    80004908:	64e080e7          	jalr	1614(ra) # 80000f52 <myproc>
    8000490c:	fec42783          	lw	a5,-20(s0)
    80004910:	07e9                	addi	a5,a5,26
    80004912:	078e                	slli	a5,a5,0x3
    80004914:	97aa                	add	a5,a5,a0
    80004916:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000491a:	fe043503          	ld	a0,-32(s0)
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	28a080e7          	jalr	650(ra) # 80003ba8 <fileclose>
  return 0;
    80004926:	4781                	li	a5,0
}
    80004928:	853e                	mv	a0,a5
    8000492a:	60e2                	ld	ra,24(sp)
    8000492c:	6442                	ld	s0,16(sp)
    8000492e:	6105                	addi	sp,sp,32
    80004930:	8082                	ret

0000000080004932 <sys_fstat>:
{
    80004932:	1101                	addi	sp,sp,-32
    80004934:	ec06                	sd	ra,24(sp)
    80004936:	e822                	sd	s0,16(sp)
    80004938:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000493a:	fe840613          	addi	a2,s0,-24
    8000493e:	4581                	li	a1,0
    80004940:	4501                	li	a0,0
    80004942:	00000097          	auipc	ra,0x0
    80004946:	c78080e7          	jalr	-904(ra) # 800045ba <argfd>
    return -1;
    8000494a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000494c:	02054563          	bltz	a0,80004976 <sys_fstat+0x44>
    80004950:	fe040593          	addi	a1,s0,-32
    80004954:	4505                	li	a0,1
    80004956:	ffffd097          	auipc	ra,0xffffd
    8000495a:	754080e7          	jalr	1876(ra) # 800020aa <argaddr>
    return -1;
    8000495e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004960:	00054b63          	bltz	a0,80004976 <sys_fstat+0x44>
  return filestat(f, st);
    80004964:	fe043583          	ld	a1,-32(s0)
    80004968:	fe843503          	ld	a0,-24(s0)
    8000496c:	fffff097          	auipc	ra,0xfffff
    80004970:	304080e7          	jalr	772(ra) # 80003c70 <filestat>
    80004974:	87aa                	mv	a5,a0
}
    80004976:	853e                	mv	a0,a5
    80004978:	60e2                	ld	ra,24(sp)
    8000497a:	6442                	ld	s0,16(sp)
    8000497c:	6105                	addi	sp,sp,32
    8000497e:	8082                	ret

0000000080004980 <sys_link>:
{
    80004980:	7169                	addi	sp,sp,-304
    80004982:	f606                	sd	ra,296(sp)
    80004984:	f222                	sd	s0,288(sp)
    80004986:	ee26                	sd	s1,280(sp)
    80004988:	ea4a                	sd	s2,272(sp)
    8000498a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000498c:	08000613          	li	a2,128
    80004990:	ed040593          	addi	a1,s0,-304
    80004994:	4501                	li	a0,0
    80004996:	ffffd097          	auipc	ra,0xffffd
    8000499a:	736080e7          	jalr	1846(ra) # 800020cc <argstr>
    return -1;
    8000499e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049a0:	10054e63          	bltz	a0,80004abc <sys_link+0x13c>
    800049a4:	08000613          	li	a2,128
    800049a8:	f5040593          	addi	a1,s0,-176
    800049ac:	4505                	li	a0,1
    800049ae:	ffffd097          	auipc	ra,0xffffd
    800049b2:	71e080e7          	jalr	1822(ra) # 800020cc <argstr>
    return -1;
    800049b6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049b8:	10054263          	bltz	a0,80004abc <sys_link+0x13c>
  begin_op();
    800049bc:	fffff097          	auipc	ra,0xfffff
    800049c0:	d20080e7          	jalr	-736(ra) # 800036dc <begin_op>
  if((ip = namei(old)) == 0){
    800049c4:	ed040513          	addi	a0,s0,-304
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	af8080e7          	jalr	-1288(ra) # 800034c0 <namei>
    800049d0:	84aa                	mv	s1,a0
    800049d2:	c551                	beqz	a0,80004a5e <sys_link+0xde>
  ilock(ip);
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	336080e7          	jalr	822(ra) # 80002d0a <ilock>
  if(ip->type == T_DIR){
    800049dc:	04449703          	lh	a4,68(s1)
    800049e0:	4785                	li	a5,1
    800049e2:	08f70463          	beq	a4,a5,80004a6a <sys_link+0xea>
  ip->nlink++;
    800049e6:	04a4d783          	lhu	a5,74(s1)
    800049ea:	2785                	addiw	a5,a5,1
    800049ec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049f0:	8526                	mv	a0,s1
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	24e080e7          	jalr	590(ra) # 80002c40 <iupdate>
  iunlock(ip);
    800049fa:	8526                	mv	a0,s1
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	3d0080e7          	jalr	976(ra) # 80002dcc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a04:	fd040593          	addi	a1,s0,-48
    80004a08:	f5040513          	addi	a0,s0,-176
    80004a0c:	fffff097          	auipc	ra,0xfffff
    80004a10:	ad2080e7          	jalr	-1326(ra) # 800034de <nameiparent>
    80004a14:	892a                	mv	s2,a0
    80004a16:	c935                	beqz	a0,80004a8a <sys_link+0x10a>
  ilock(dp);
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	2f2080e7          	jalr	754(ra) # 80002d0a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a20:	00092703          	lw	a4,0(s2)
    80004a24:	409c                	lw	a5,0(s1)
    80004a26:	04f71d63          	bne	a4,a5,80004a80 <sys_link+0x100>
    80004a2a:	40d0                	lw	a2,4(s1)
    80004a2c:	fd040593          	addi	a1,s0,-48
    80004a30:	854a                	mv	a0,s2
    80004a32:	fffff097          	auipc	ra,0xfffff
    80004a36:	9cc080e7          	jalr	-1588(ra) # 800033fe <dirlink>
    80004a3a:	04054363          	bltz	a0,80004a80 <sys_link+0x100>
  iunlockput(dp);
    80004a3e:	854a                	mv	a0,s2
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	52c080e7          	jalr	1324(ra) # 80002f6c <iunlockput>
  iput(ip);
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	47a080e7          	jalr	1146(ra) # 80002ec4 <iput>
  end_op();
    80004a52:	fffff097          	auipc	ra,0xfffff
    80004a56:	d0a080e7          	jalr	-758(ra) # 8000375c <end_op>
  return 0;
    80004a5a:	4781                	li	a5,0
    80004a5c:	a085                	j	80004abc <sys_link+0x13c>
    end_op();
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	cfe080e7          	jalr	-770(ra) # 8000375c <end_op>
    return -1;
    80004a66:	57fd                	li	a5,-1
    80004a68:	a891                	j	80004abc <sys_link+0x13c>
    iunlockput(ip);
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	500080e7          	jalr	1280(ra) # 80002f6c <iunlockput>
    end_op();
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	ce8080e7          	jalr	-792(ra) # 8000375c <end_op>
    return -1;
    80004a7c:	57fd                	li	a5,-1
    80004a7e:	a83d                	j	80004abc <sys_link+0x13c>
    iunlockput(dp);
    80004a80:	854a                	mv	a0,s2
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	4ea080e7          	jalr	1258(ra) # 80002f6c <iunlockput>
  ilock(ip);
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	27e080e7          	jalr	638(ra) # 80002d0a <ilock>
  ip->nlink--;
    80004a94:	04a4d783          	lhu	a5,74(s1)
    80004a98:	37fd                	addiw	a5,a5,-1
    80004a9a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	1a0080e7          	jalr	416(ra) # 80002c40 <iupdate>
  iunlockput(ip);
    80004aa8:	8526                	mv	a0,s1
    80004aaa:	ffffe097          	auipc	ra,0xffffe
    80004aae:	4c2080e7          	jalr	1218(ra) # 80002f6c <iunlockput>
  end_op();
    80004ab2:	fffff097          	auipc	ra,0xfffff
    80004ab6:	caa080e7          	jalr	-854(ra) # 8000375c <end_op>
  return -1;
    80004aba:	57fd                	li	a5,-1
}
    80004abc:	853e                	mv	a0,a5
    80004abe:	70b2                	ld	ra,296(sp)
    80004ac0:	7412                	ld	s0,288(sp)
    80004ac2:	64f2                	ld	s1,280(sp)
    80004ac4:	6952                	ld	s2,272(sp)
    80004ac6:	6155                	addi	sp,sp,304
    80004ac8:	8082                	ret

0000000080004aca <sys_unlink>:
{
    80004aca:	7151                	addi	sp,sp,-240
    80004acc:	f586                	sd	ra,232(sp)
    80004ace:	f1a2                	sd	s0,224(sp)
    80004ad0:	eda6                	sd	s1,216(sp)
    80004ad2:	e9ca                	sd	s2,208(sp)
    80004ad4:	e5ce                	sd	s3,200(sp)
    80004ad6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ad8:	08000613          	li	a2,128
    80004adc:	f3040593          	addi	a1,s0,-208
    80004ae0:	4501                	li	a0,0
    80004ae2:	ffffd097          	auipc	ra,0xffffd
    80004ae6:	5ea080e7          	jalr	1514(ra) # 800020cc <argstr>
    80004aea:	18054163          	bltz	a0,80004c6c <sys_unlink+0x1a2>
  begin_op();
    80004aee:	fffff097          	auipc	ra,0xfffff
    80004af2:	bee080e7          	jalr	-1042(ra) # 800036dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004af6:	fb040593          	addi	a1,s0,-80
    80004afa:	f3040513          	addi	a0,s0,-208
    80004afe:	fffff097          	auipc	ra,0xfffff
    80004b02:	9e0080e7          	jalr	-1568(ra) # 800034de <nameiparent>
    80004b06:	84aa                	mv	s1,a0
    80004b08:	c979                	beqz	a0,80004bde <sys_unlink+0x114>
  ilock(dp);
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	200080e7          	jalr	512(ra) # 80002d0a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b12:	00004597          	auipc	a1,0x4
    80004b16:	aae58593          	addi	a1,a1,-1362 # 800085c0 <etext+0x5c0>
    80004b1a:	fb040513          	addi	a0,s0,-80
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	6b6080e7          	jalr	1718(ra) # 800031d4 <namecmp>
    80004b26:	14050a63          	beqz	a0,80004c7a <sys_unlink+0x1b0>
    80004b2a:	00004597          	auipc	a1,0x4
    80004b2e:	a9e58593          	addi	a1,a1,-1378 # 800085c8 <etext+0x5c8>
    80004b32:	fb040513          	addi	a0,s0,-80
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	69e080e7          	jalr	1694(ra) # 800031d4 <namecmp>
    80004b3e:	12050e63          	beqz	a0,80004c7a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b42:	f2c40613          	addi	a2,s0,-212
    80004b46:	fb040593          	addi	a1,s0,-80
    80004b4a:	8526                	mv	a0,s1
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	6a2080e7          	jalr	1698(ra) # 800031ee <dirlookup>
    80004b54:	892a                	mv	s2,a0
    80004b56:	12050263          	beqz	a0,80004c7a <sys_unlink+0x1b0>
  ilock(ip);
    80004b5a:	ffffe097          	auipc	ra,0xffffe
    80004b5e:	1b0080e7          	jalr	432(ra) # 80002d0a <ilock>
  if(ip->nlink < 1)
    80004b62:	04a91783          	lh	a5,74(s2)
    80004b66:	08f05263          	blez	a5,80004bea <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b6a:	04491703          	lh	a4,68(s2)
    80004b6e:	4785                	li	a5,1
    80004b70:	08f70563          	beq	a4,a5,80004bfa <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b74:	4641                	li	a2,16
    80004b76:	4581                	li	a1,0
    80004b78:	fc040513          	addi	a0,s0,-64
    80004b7c:	ffffb097          	auipc	ra,0xffffb
    80004b80:	5fc080e7          	jalr	1532(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b84:	4741                	li	a4,16
    80004b86:	f2c42683          	lw	a3,-212(s0)
    80004b8a:	fc040613          	addi	a2,s0,-64
    80004b8e:	4581                	li	a1,0
    80004b90:	8526                	mv	a0,s1
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	524080e7          	jalr	1316(ra) # 800030b6 <writei>
    80004b9a:	47c1                	li	a5,16
    80004b9c:	0af51563          	bne	a0,a5,80004c46 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004ba0:	04491703          	lh	a4,68(s2)
    80004ba4:	4785                	li	a5,1
    80004ba6:	0af70863          	beq	a4,a5,80004c56 <sys_unlink+0x18c>
  iunlockput(dp);
    80004baa:	8526                	mv	a0,s1
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	3c0080e7          	jalr	960(ra) # 80002f6c <iunlockput>
  ip->nlink--;
    80004bb4:	04a95783          	lhu	a5,74(s2)
    80004bb8:	37fd                	addiw	a5,a5,-1
    80004bba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bbe:	854a                	mv	a0,s2
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	080080e7          	jalr	128(ra) # 80002c40 <iupdate>
  iunlockput(ip);
    80004bc8:	854a                	mv	a0,s2
    80004bca:	ffffe097          	auipc	ra,0xffffe
    80004bce:	3a2080e7          	jalr	930(ra) # 80002f6c <iunlockput>
  end_op();
    80004bd2:	fffff097          	auipc	ra,0xfffff
    80004bd6:	b8a080e7          	jalr	-1142(ra) # 8000375c <end_op>
  return 0;
    80004bda:	4501                	li	a0,0
    80004bdc:	a84d                	j	80004c8e <sys_unlink+0x1c4>
    end_op();
    80004bde:	fffff097          	auipc	ra,0xfffff
    80004be2:	b7e080e7          	jalr	-1154(ra) # 8000375c <end_op>
    return -1;
    80004be6:	557d                	li	a0,-1
    80004be8:	a05d                	j	80004c8e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bea:	00004517          	auipc	a0,0x4
    80004bee:	a0650513          	addi	a0,a0,-1530 # 800085f0 <etext+0x5f0>
    80004bf2:	00001097          	auipc	ra,0x1
    80004bf6:	1a2080e7          	jalr	418(ra) # 80005d94 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bfa:	04c92703          	lw	a4,76(s2)
    80004bfe:	02000793          	li	a5,32
    80004c02:	f6e7f9e3          	bgeu	a5,a4,80004b74 <sys_unlink+0xaa>
    80004c06:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c0a:	4741                	li	a4,16
    80004c0c:	86ce                	mv	a3,s3
    80004c0e:	f1840613          	addi	a2,s0,-232
    80004c12:	4581                	li	a1,0
    80004c14:	854a                	mv	a0,s2
    80004c16:	ffffe097          	auipc	ra,0xffffe
    80004c1a:	3a8080e7          	jalr	936(ra) # 80002fbe <readi>
    80004c1e:	47c1                	li	a5,16
    80004c20:	00f51b63          	bne	a0,a5,80004c36 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c24:	f1845783          	lhu	a5,-232(s0)
    80004c28:	e7a1                	bnez	a5,80004c70 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c2a:	29c1                	addiw	s3,s3,16
    80004c2c:	04c92783          	lw	a5,76(s2)
    80004c30:	fcf9ede3          	bltu	s3,a5,80004c0a <sys_unlink+0x140>
    80004c34:	b781                	j	80004b74 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c36:	00004517          	auipc	a0,0x4
    80004c3a:	9d250513          	addi	a0,a0,-1582 # 80008608 <etext+0x608>
    80004c3e:	00001097          	auipc	ra,0x1
    80004c42:	156080e7          	jalr	342(ra) # 80005d94 <panic>
    panic("unlink: writei");
    80004c46:	00004517          	auipc	a0,0x4
    80004c4a:	9da50513          	addi	a0,a0,-1574 # 80008620 <etext+0x620>
    80004c4e:	00001097          	auipc	ra,0x1
    80004c52:	146080e7          	jalr	326(ra) # 80005d94 <panic>
    dp->nlink--;
    80004c56:	04a4d783          	lhu	a5,74(s1)
    80004c5a:	37fd                	addiw	a5,a5,-1
    80004c5c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c60:	8526                	mv	a0,s1
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	fde080e7          	jalr	-34(ra) # 80002c40 <iupdate>
    80004c6a:	b781                	j	80004baa <sys_unlink+0xe0>
    return -1;
    80004c6c:	557d                	li	a0,-1
    80004c6e:	a005                	j	80004c8e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c70:	854a                	mv	a0,s2
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	2fa080e7          	jalr	762(ra) # 80002f6c <iunlockput>
  iunlockput(dp);
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	2f0080e7          	jalr	752(ra) # 80002f6c <iunlockput>
  end_op();
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	ad8080e7          	jalr	-1320(ra) # 8000375c <end_op>
  return -1;
    80004c8c:	557d                	li	a0,-1
}
    80004c8e:	70ae                	ld	ra,232(sp)
    80004c90:	740e                	ld	s0,224(sp)
    80004c92:	64ee                	ld	s1,216(sp)
    80004c94:	694e                	ld	s2,208(sp)
    80004c96:	69ae                	ld	s3,200(sp)
    80004c98:	616d                	addi	sp,sp,240
    80004c9a:	8082                	ret

0000000080004c9c <sys_open>:

uint64
sys_open(void)
{
    80004c9c:	7131                	addi	sp,sp,-192
    80004c9e:	fd06                	sd	ra,184(sp)
    80004ca0:	f922                	sd	s0,176(sp)
    80004ca2:	f526                	sd	s1,168(sp)
    80004ca4:	f14a                	sd	s2,160(sp)
    80004ca6:	ed4e                	sd	s3,152(sp)
    80004ca8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004caa:	08000613          	li	a2,128
    80004cae:	f5040593          	addi	a1,s0,-176
    80004cb2:	4501                	li	a0,0
    80004cb4:	ffffd097          	auipc	ra,0xffffd
    80004cb8:	418080e7          	jalr	1048(ra) # 800020cc <argstr>
    return -1;
    80004cbc:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cbe:	0c054163          	bltz	a0,80004d80 <sys_open+0xe4>
    80004cc2:	f4c40593          	addi	a1,s0,-180
    80004cc6:	4505                	li	a0,1
    80004cc8:	ffffd097          	auipc	ra,0xffffd
    80004ccc:	3c0080e7          	jalr	960(ra) # 80002088 <argint>
    80004cd0:	0a054863          	bltz	a0,80004d80 <sys_open+0xe4>

  begin_op();
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	a08080e7          	jalr	-1528(ra) # 800036dc <begin_op>

  if(omode & O_CREATE){
    80004cdc:	f4c42783          	lw	a5,-180(s0)
    80004ce0:	2007f793          	andi	a5,a5,512
    80004ce4:	cbdd                	beqz	a5,80004d9a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ce6:	4681                	li	a3,0
    80004ce8:	4601                	li	a2,0
    80004cea:	4589                	li	a1,2
    80004cec:	f5040513          	addi	a0,s0,-176
    80004cf0:	00000097          	auipc	ra,0x0
    80004cf4:	974080e7          	jalr	-1676(ra) # 80004664 <create>
    80004cf8:	892a                	mv	s2,a0
    if(ip == 0){
    80004cfa:	c959                	beqz	a0,80004d90 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cfc:	04491703          	lh	a4,68(s2)
    80004d00:	478d                	li	a5,3
    80004d02:	00f71763          	bne	a4,a5,80004d10 <sys_open+0x74>
    80004d06:	04695703          	lhu	a4,70(s2)
    80004d0a:	47a5                	li	a5,9
    80004d0c:	0ce7ec63          	bltu	a5,a4,80004de4 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	ddc080e7          	jalr	-548(ra) # 80003aec <filealloc>
    80004d18:	89aa                	mv	s3,a0
    80004d1a:	10050263          	beqz	a0,80004e1e <sys_open+0x182>
    80004d1e:	00000097          	auipc	ra,0x0
    80004d22:	904080e7          	jalr	-1788(ra) # 80004622 <fdalloc>
    80004d26:	84aa                	mv	s1,a0
    80004d28:	0e054663          	bltz	a0,80004e14 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d2c:	04491703          	lh	a4,68(s2)
    80004d30:	478d                	li	a5,3
    80004d32:	0cf70463          	beq	a4,a5,80004dfa <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d36:	4789                	li	a5,2
    80004d38:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d3c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d40:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d44:	f4c42783          	lw	a5,-180(s0)
    80004d48:	0017c713          	xori	a4,a5,1
    80004d4c:	8b05                	andi	a4,a4,1
    80004d4e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d52:	0037f713          	andi	a4,a5,3
    80004d56:	00e03733          	snez	a4,a4
    80004d5a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d5e:	4007f793          	andi	a5,a5,1024
    80004d62:	c791                	beqz	a5,80004d6e <sys_open+0xd2>
    80004d64:	04491703          	lh	a4,68(s2)
    80004d68:	4789                	li	a5,2
    80004d6a:	08f70f63          	beq	a4,a5,80004e08 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d6e:	854a                	mv	a0,s2
    80004d70:	ffffe097          	auipc	ra,0xffffe
    80004d74:	05c080e7          	jalr	92(ra) # 80002dcc <iunlock>
  end_op();
    80004d78:	fffff097          	auipc	ra,0xfffff
    80004d7c:	9e4080e7          	jalr	-1564(ra) # 8000375c <end_op>

  return fd;
}
    80004d80:	8526                	mv	a0,s1
    80004d82:	70ea                	ld	ra,184(sp)
    80004d84:	744a                	ld	s0,176(sp)
    80004d86:	74aa                	ld	s1,168(sp)
    80004d88:	790a                	ld	s2,160(sp)
    80004d8a:	69ea                	ld	s3,152(sp)
    80004d8c:	6129                	addi	sp,sp,192
    80004d8e:	8082                	ret
      end_op();
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	9cc080e7          	jalr	-1588(ra) # 8000375c <end_op>
      return -1;
    80004d98:	b7e5                	j	80004d80 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d9a:	f5040513          	addi	a0,s0,-176
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	722080e7          	jalr	1826(ra) # 800034c0 <namei>
    80004da6:	892a                	mv	s2,a0
    80004da8:	c905                	beqz	a0,80004dd8 <sys_open+0x13c>
    ilock(ip);
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	f60080e7          	jalr	-160(ra) # 80002d0a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004db2:	04491703          	lh	a4,68(s2)
    80004db6:	4785                	li	a5,1
    80004db8:	f4f712e3          	bne	a4,a5,80004cfc <sys_open+0x60>
    80004dbc:	f4c42783          	lw	a5,-180(s0)
    80004dc0:	dba1                	beqz	a5,80004d10 <sys_open+0x74>
      iunlockput(ip);
    80004dc2:	854a                	mv	a0,s2
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	1a8080e7          	jalr	424(ra) # 80002f6c <iunlockput>
      end_op();
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	990080e7          	jalr	-1648(ra) # 8000375c <end_op>
      return -1;
    80004dd4:	54fd                	li	s1,-1
    80004dd6:	b76d                	j	80004d80 <sys_open+0xe4>
      end_op();
    80004dd8:	fffff097          	auipc	ra,0xfffff
    80004ddc:	984080e7          	jalr	-1660(ra) # 8000375c <end_op>
      return -1;
    80004de0:	54fd                	li	s1,-1
    80004de2:	bf79                	j	80004d80 <sys_open+0xe4>
    iunlockput(ip);
    80004de4:	854a                	mv	a0,s2
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	186080e7          	jalr	390(ra) # 80002f6c <iunlockput>
    end_op();
    80004dee:	fffff097          	auipc	ra,0xfffff
    80004df2:	96e080e7          	jalr	-1682(ra) # 8000375c <end_op>
    return -1;
    80004df6:	54fd                	li	s1,-1
    80004df8:	b761                	j	80004d80 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004dfa:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dfe:	04691783          	lh	a5,70(s2)
    80004e02:	02f99223          	sh	a5,36(s3)
    80004e06:	bf2d                	j	80004d40 <sys_open+0xa4>
    itrunc(ip);
    80004e08:	854a                	mv	a0,s2
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	00e080e7          	jalr	14(ra) # 80002e18 <itrunc>
    80004e12:	bfb1                	j	80004d6e <sys_open+0xd2>
      fileclose(f);
    80004e14:	854e                	mv	a0,s3
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	d92080e7          	jalr	-622(ra) # 80003ba8 <fileclose>
    iunlockput(ip);
    80004e1e:	854a                	mv	a0,s2
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	14c080e7          	jalr	332(ra) # 80002f6c <iunlockput>
    end_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	934080e7          	jalr	-1740(ra) # 8000375c <end_op>
    return -1;
    80004e30:	54fd                	li	s1,-1
    80004e32:	b7b9                	j	80004d80 <sys_open+0xe4>

0000000080004e34 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e34:	7175                	addi	sp,sp,-144
    80004e36:	e506                	sd	ra,136(sp)
    80004e38:	e122                	sd	s0,128(sp)
    80004e3a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e3c:	fffff097          	auipc	ra,0xfffff
    80004e40:	8a0080e7          	jalr	-1888(ra) # 800036dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e44:	08000613          	li	a2,128
    80004e48:	f7040593          	addi	a1,s0,-144
    80004e4c:	4501                	li	a0,0
    80004e4e:	ffffd097          	auipc	ra,0xffffd
    80004e52:	27e080e7          	jalr	638(ra) # 800020cc <argstr>
    80004e56:	02054963          	bltz	a0,80004e88 <sys_mkdir+0x54>
    80004e5a:	4681                	li	a3,0
    80004e5c:	4601                	li	a2,0
    80004e5e:	4585                	li	a1,1
    80004e60:	f7040513          	addi	a0,s0,-144
    80004e64:	00000097          	auipc	ra,0x0
    80004e68:	800080e7          	jalr	-2048(ra) # 80004664 <create>
    80004e6c:	cd11                	beqz	a0,80004e88 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	0fe080e7          	jalr	254(ra) # 80002f6c <iunlockput>
  end_op();
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	8e6080e7          	jalr	-1818(ra) # 8000375c <end_op>
  return 0;
    80004e7e:	4501                	li	a0,0
}
    80004e80:	60aa                	ld	ra,136(sp)
    80004e82:	640a                	ld	s0,128(sp)
    80004e84:	6149                	addi	sp,sp,144
    80004e86:	8082                	ret
    end_op();
    80004e88:	fffff097          	auipc	ra,0xfffff
    80004e8c:	8d4080e7          	jalr	-1836(ra) # 8000375c <end_op>
    return -1;
    80004e90:	557d                	li	a0,-1
    80004e92:	b7fd                	j	80004e80 <sys_mkdir+0x4c>

0000000080004e94 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e94:	7135                	addi	sp,sp,-160
    80004e96:	ed06                	sd	ra,152(sp)
    80004e98:	e922                	sd	s0,144(sp)
    80004e9a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	840080e7          	jalr	-1984(ra) # 800036dc <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ea4:	08000613          	li	a2,128
    80004ea8:	f7040593          	addi	a1,s0,-144
    80004eac:	4501                	li	a0,0
    80004eae:	ffffd097          	auipc	ra,0xffffd
    80004eb2:	21e080e7          	jalr	542(ra) # 800020cc <argstr>
    80004eb6:	04054a63          	bltz	a0,80004f0a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004eba:	f6c40593          	addi	a1,s0,-148
    80004ebe:	4505                	li	a0,1
    80004ec0:	ffffd097          	auipc	ra,0xffffd
    80004ec4:	1c8080e7          	jalr	456(ra) # 80002088 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ec8:	04054163          	bltz	a0,80004f0a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004ecc:	f6840593          	addi	a1,s0,-152
    80004ed0:	4509                	li	a0,2
    80004ed2:	ffffd097          	auipc	ra,0xffffd
    80004ed6:	1b6080e7          	jalr	438(ra) # 80002088 <argint>
     argint(1, &major) < 0 ||
    80004eda:	02054863          	bltz	a0,80004f0a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ede:	f6841683          	lh	a3,-152(s0)
    80004ee2:	f6c41603          	lh	a2,-148(s0)
    80004ee6:	458d                	li	a1,3
    80004ee8:	f7040513          	addi	a0,s0,-144
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	778080e7          	jalr	1912(ra) # 80004664 <create>
     argint(2, &minor) < 0 ||
    80004ef4:	c919                	beqz	a0,80004f0a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	076080e7          	jalr	118(ra) # 80002f6c <iunlockput>
  end_op();
    80004efe:	fffff097          	auipc	ra,0xfffff
    80004f02:	85e080e7          	jalr	-1954(ra) # 8000375c <end_op>
  return 0;
    80004f06:	4501                	li	a0,0
    80004f08:	a031                	j	80004f14 <sys_mknod+0x80>
    end_op();
    80004f0a:	fffff097          	auipc	ra,0xfffff
    80004f0e:	852080e7          	jalr	-1966(ra) # 8000375c <end_op>
    return -1;
    80004f12:	557d                	li	a0,-1
}
    80004f14:	60ea                	ld	ra,152(sp)
    80004f16:	644a                	ld	s0,144(sp)
    80004f18:	610d                	addi	sp,sp,160
    80004f1a:	8082                	ret

0000000080004f1c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f1c:	7135                	addi	sp,sp,-160
    80004f1e:	ed06                	sd	ra,152(sp)
    80004f20:	e922                	sd	s0,144(sp)
    80004f22:	e526                	sd	s1,136(sp)
    80004f24:	e14a                	sd	s2,128(sp)
    80004f26:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f28:	ffffc097          	auipc	ra,0xffffc
    80004f2c:	02a080e7          	jalr	42(ra) # 80000f52 <myproc>
    80004f30:	892a                	mv	s2,a0
  
  begin_op();
    80004f32:	ffffe097          	auipc	ra,0xffffe
    80004f36:	7aa080e7          	jalr	1962(ra) # 800036dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f3a:	08000613          	li	a2,128
    80004f3e:	f6040593          	addi	a1,s0,-160
    80004f42:	4501                	li	a0,0
    80004f44:	ffffd097          	auipc	ra,0xffffd
    80004f48:	188080e7          	jalr	392(ra) # 800020cc <argstr>
    80004f4c:	04054b63          	bltz	a0,80004fa2 <sys_chdir+0x86>
    80004f50:	f6040513          	addi	a0,s0,-160
    80004f54:	ffffe097          	auipc	ra,0xffffe
    80004f58:	56c080e7          	jalr	1388(ra) # 800034c0 <namei>
    80004f5c:	84aa                	mv	s1,a0
    80004f5e:	c131                	beqz	a0,80004fa2 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f60:	ffffe097          	auipc	ra,0xffffe
    80004f64:	daa080e7          	jalr	-598(ra) # 80002d0a <ilock>
  if(ip->type != T_DIR){
    80004f68:	04449703          	lh	a4,68(s1)
    80004f6c:	4785                	li	a5,1
    80004f6e:	04f71063          	bne	a4,a5,80004fae <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f72:	8526                	mv	a0,s1
    80004f74:	ffffe097          	auipc	ra,0xffffe
    80004f78:	e58080e7          	jalr	-424(ra) # 80002dcc <iunlock>
  iput(p->cwd);
    80004f7c:	15093503          	ld	a0,336(s2)
    80004f80:	ffffe097          	auipc	ra,0xffffe
    80004f84:	f44080e7          	jalr	-188(ra) # 80002ec4 <iput>
  end_op();
    80004f88:	ffffe097          	auipc	ra,0xffffe
    80004f8c:	7d4080e7          	jalr	2004(ra) # 8000375c <end_op>
  p->cwd = ip;
    80004f90:	14993823          	sd	s1,336(s2)
  return 0;
    80004f94:	4501                	li	a0,0
}
    80004f96:	60ea                	ld	ra,152(sp)
    80004f98:	644a                	ld	s0,144(sp)
    80004f9a:	64aa                	ld	s1,136(sp)
    80004f9c:	690a                	ld	s2,128(sp)
    80004f9e:	610d                	addi	sp,sp,160
    80004fa0:	8082                	ret
    end_op();
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	7ba080e7          	jalr	1978(ra) # 8000375c <end_op>
    return -1;
    80004faa:	557d                	li	a0,-1
    80004fac:	b7ed                	j	80004f96 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fae:	8526                	mv	a0,s1
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	fbc080e7          	jalr	-68(ra) # 80002f6c <iunlockput>
    end_op();
    80004fb8:	ffffe097          	auipc	ra,0xffffe
    80004fbc:	7a4080e7          	jalr	1956(ra) # 8000375c <end_op>
    return -1;
    80004fc0:	557d                	li	a0,-1
    80004fc2:	bfd1                	j	80004f96 <sys_chdir+0x7a>

0000000080004fc4 <sys_exec>:

uint64
sys_exec(void)
{
    80004fc4:	7145                	addi	sp,sp,-464
    80004fc6:	e786                	sd	ra,456(sp)
    80004fc8:	e3a2                	sd	s0,448(sp)
    80004fca:	ff26                	sd	s1,440(sp)
    80004fcc:	fb4a                	sd	s2,432(sp)
    80004fce:	f74e                	sd	s3,424(sp)
    80004fd0:	f352                	sd	s4,416(sp)
    80004fd2:	ef56                	sd	s5,408(sp)
    80004fd4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fd6:	08000613          	li	a2,128
    80004fda:	f4040593          	addi	a1,s0,-192
    80004fde:	4501                	li	a0,0
    80004fe0:	ffffd097          	auipc	ra,0xffffd
    80004fe4:	0ec080e7          	jalr	236(ra) # 800020cc <argstr>
    return -1;
    80004fe8:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fea:	0c054a63          	bltz	a0,800050be <sys_exec+0xfa>
    80004fee:	e3840593          	addi	a1,s0,-456
    80004ff2:	4505                	li	a0,1
    80004ff4:	ffffd097          	auipc	ra,0xffffd
    80004ff8:	0b6080e7          	jalr	182(ra) # 800020aa <argaddr>
    80004ffc:	0c054163          	bltz	a0,800050be <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005000:	10000613          	li	a2,256
    80005004:	4581                	li	a1,0
    80005006:	e4040513          	addi	a0,s0,-448
    8000500a:	ffffb097          	auipc	ra,0xffffb
    8000500e:	16e080e7          	jalr	366(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005012:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005016:	89a6                	mv	s3,s1
    80005018:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000501a:	02000a13          	li	s4,32
    8000501e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005022:	00391793          	slli	a5,s2,0x3
    80005026:	e3040593          	addi	a1,s0,-464
    8000502a:	e3843503          	ld	a0,-456(s0)
    8000502e:	953e                	add	a0,a0,a5
    80005030:	ffffd097          	auipc	ra,0xffffd
    80005034:	fbe080e7          	jalr	-66(ra) # 80001fee <fetchaddr>
    80005038:	02054a63          	bltz	a0,8000506c <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000503c:	e3043783          	ld	a5,-464(s0)
    80005040:	c3b9                	beqz	a5,80005086 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005042:	ffffb097          	auipc	ra,0xffffb
    80005046:	0d6080e7          	jalr	214(ra) # 80000118 <kalloc>
    8000504a:	85aa                	mv	a1,a0
    8000504c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005050:	cd11                	beqz	a0,8000506c <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005052:	6605                	lui	a2,0x1
    80005054:	e3043503          	ld	a0,-464(s0)
    80005058:	ffffd097          	auipc	ra,0xffffd
    8000505c:	fe8080e7          	jalr	-24(ra) # 80002040 <fetchstr>
    80005060:	00054663          	bltz	a0,8000506c <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005064:	0905                	addi	s2,s2,1
    80005066:	09a1                	addi	s3,s3,8
    80005068:	fb491be3          	bne	s2,s4,8000501e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000506c:	10048913          	addi	s2,s1,256
    80005070:	6088                	ld	a0,0(s1)
    80005072:	c529                	beqz	a0,800050bc <sys_exec+0xf8>
    kfree(argv[i]);
    80005074:	ffffb097          	auipc	ra,0xffffb
    80005078:	fa8080e7          	jalr	-88(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000507c:	04a1                	addi	s1,s1,8
    8000507e:	ff2499e3          	bne	s1,s2,80005070 <sys_exec+0xac>
  return -1;
    80005082:	597d                	li	s2,-1
    80005084:	a82d                	j	800050be <sys_exec+0xfa>
      argv[i] = 0;
    80005086:	0a8e                	slli	s5,s5,0x3
    80005088:	fc040793          	addi	a5,s0,-64
    8000508c:	9abe                	add	s5,s5,a5
    8000508e:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8c40>
  int ret = exec(path, argv);
    80005092:	e4040593          	addi	a1,s0,-448
    80005096:	f4040513          	addi	a0,s0,-192
    8000509a:	fffff097          	auipc	ra,0xfffff
    8000509e:	160080e7          	jalr	352(ra) # 800041fa <exec>
    800050a2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050a4:	10048993          	addi	s3,s1,256
    800050a8:	6088                	ld	a0,0(s1)
    800050aa:	c911                	beqz	a0,800050be <sys_exec+0xfa>
    kfree(argv[i]);
    800050ac:	ffffb097          	auipc	ra,0xffffb
    800050b0:	f70080e7          	jalr	-144(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b4:	04a1                	addi	s1,s1,8
    800050b6:	ff3499e3          	bne	s1,s3,800050a8 <sys_exec+0xe4>
    800050ba:	a011                	j	800050be <sys_exec+0xfa>
  return -1;
    800050bc:	597d                	li	s2,-1
}
    800050be:	854a                	mv	a0,s2
    800050c0:	60be                	ld	ra,456(sp)
    800050c2:	641e                	ld	s0,448(sp)
    800050c4:	74fa                	ld	s1,440(sp)
    800050c6:	795a                	ld	s2,432(sp)
    800050c8:	79ba                	ld	s3,424(sp)
    800050ca:	7a1a                	ld	s4,416(sp)
    800050cc:	6afa                	ld	s5,408(sp)
    800050ce:	6179                	addi	sp,sp,464
    800050d0:	8082                	ret

00000000800050d2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050d2:	7139                	addi	sp,sp,-64
    800050d4:	fc06                	sd	ra,56(sp)
    800050d6:	f822                	sd	s0,48(sp)
    800050d8:	f426                	sd	s1,40(sp)
    800050da:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050dc:	ffffc097          	auipc	ra,0xffffc
    800050e0:	e76080e7          	jalr	-394(ra) # 80000f52 <myproc>
    800050e4:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050e6:	fd840593          	addi	a1,s0,-40
    800050ea:	4501                	li	a0,0
    800050ec:	ffffd097          	auipc	ra,0xffffd
    800050f0:	fbe080e7          	jalr	-66(ra) # 800020aa <argaddr>
    return -1;
    800050f4:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050f6:	0e054063          	bltz	a0,800051d6 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050fa:	fc840593          	addi	a1,s0,-56
    800050fe:	fd040513          	addi	a0,s0,-48
    80005102:	fffff097          	auipc	ra,0xfffff
    80005106:	dd6080e7          	jalr	-554(ra) # 80003ed8 <pipealloc>
    return -1;
    8000510a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000510c:	0c054563          	bltz	a0,800051d6 <sys_pipe+0x104>
  fd0 = -1;
    80005110:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005114:	fd043503          	ld	a0,-48(s0)
    80005118:	fffff097          	auipc	ra,0xfffff
    8000511c:	50a080e7          	jalr	1290(ra) # 80004622 <fdalloc>
    80005120:	fca42223          	sw	a0,-60(s0)
    80005124:	08054c63          	bltz	a0,800051bc <sys_pipe+0xea>
    80005128:	fc843503          	ld	a0,-56(s0)
    8000512c:	fffff097          	auipc	ra,0xfffff
    80005130:	4f6080e7          	jalr	1270(ra) # 80004622 <fdalloc>
    80005134:	fca42023          	sw	a0,-64(s0)
    80005138:	06054863          	bltz	a0,800051a8 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000513c:	4691                	li	a3,4
    8000513e:	fc440613          	addi	a2,s0,-60
    80005142:	fd843583          	ld	a1,-40(s0)
    80005146:	68a8                	ld	a0,80(s1)
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	9ba080e7          	jalr	-1606(ra) # 80000b02 <copyout>
    80005150:	02054063          	bltz	a0,80005170 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005154:	4691                	li	a3,4
    80005156:	fc040613          	addi	a2,s0,-64
    8000515a:	fd843583          	ld	a1,-40(s0)
    8000515e:	0591                	addi	a1,a1,4
    80005160:	68a8                	ld	a0,80(s1)
    80005162:	ffffc097          	auipc	ra,0xffffc
    80005166:	9a0080e7          	jalr	-1632(ra) # 80000b02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000516a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000516c:	06055563          	bgez	a0,800051d6 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005170:	fc442783          	lw	a5,-60(s0)
    80005174:	07e9                	addi	a5,a5,26
    80005176:	078e                	slli	a5,a5,0x3
    80005178:	97a6                	add	a5,a5,s1
    8000517a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000517e:	fc042503          	lw	a0,-64(s0)
    80005182:	0569                	addi	a0,a0,26
    80005184:	050e                	slli	a0,a0,0x3
    80005186:	9526                	add	a0,a0,s1
    80005188:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000518c:	fd043503          	ld	a0,-48(s0)
    80005190:	fffff097          	auipc	ra,0xfffff
    80005194:	a18080e7          	jalr	-1512(ra) # 80003ba8 <fileclose>
    fileclose(wf);
    80005198:	fc843503          	ld	a0,-56(s0)
    8000519c:	fffff097          	auipc	ra,0xfffff
    800051a0:	a0c080e7          	jalr	-1524(ra) # 80003ba8 <fileclose>
    return -1;
    800051a4:	57fd                	li	a5,-1
    800051a6:	a805                	j	800051d6 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051a8:	fc442783          	lw	a5,-60(s0)
    800051ac:	0007c863          	bltz	a5,800051bc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051b0:	01a78513          	addi	a0,a5,26
    800051b4:	050e                	slli	a0,a0,0x3
    800051b6:	9526                	add	a0,a0,s1
    800051b8:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051bc:	fd043503          	ld	a0,-48(s0)
    800051c0:	fffff097          	auipc	ra,0xfffff
    800051c4:	9e8080e7          	jalr	-1560(ra) # 80003ba8 <fileclose>
    fileclose(wf);
    800051c8:	fc843503          	ld	a0,-56(s0)
    800051cc:	fffff097          	auipc	ra,0xfffff
    800051d0:	9dc080e7          	jalr	-1572(ra) # 80003ba8 <fileclose>
    return -1;
    800051d4:	57fd                	li	a5,-1
}
    800051d6:	853e                	mv	a0,a5
    800051d8:	70e2                	ld	ra,56(sp)
    800051da:	7442                	ld	s0,48(sp)
    800051dc:	74a2                	ld	s1,40(sp)
    800051de:	6121                	addi	sp,sp,64
    800051e0:	8082                	ret
	...

00000000800051f0 <kernelvec>:
    800051f0:	7111                	addi	sp,sp,-256
    800051f2:	e006                	sd	ra,0(sp)
    800051f4:	e40a                	sd	sp,8(sp)
    800051f6:	e80e                	sd	gp,16(sp)
    800051f8:	ec12                	sd	tp,24(sp)
    800051fa:	f016                	sd	t0,32(sp)
    800051fc:	f41a                	sd	t1,40(sp)
    800051fe:	f81e                	sd	t2,48(sp)
    80005200:	fc22                	sd	s0,56(sp)
    80005202:	e0a6                	sd	s1,64(sp)
    80005204:	e4aa                	sd	a0,72(sp)
    80005206:	e8ae                	sd	a1,80(sp)
    80005208:	ecb2                	sd	a2,88(sp)
    8000520a:	f0b6                	sd	a3,96(sp)
    8000520c:	f4ba                	sd	a4,104(sp)
    8000520e:	f8be                	sd	a5,112(sp)
    80005210:	fcc2                	sd	a6,120(sp)
    80005212:	e146                	sd	a7,128(sp)
    80005214:	e54a                	sd	s2,136(sp)
    80005216:	e94e                	sd	s3,144(sp)
    80005218:	ed52                	sd	s4,152(sp)
    8000521a:	f156                	sd	s5,160(sp)
    8000521c:	f55a                	sd	s6,168(sp)
    8000521e:	f95e                	sd	s7,176(sp)
    80005220:	fd62                	sd	s8,184(sp)
    80005222:	e1e6                	sd	s9,192(sp)
    80005224:	e5ea                	sd	s10,200(sp)
    80005226:	e9ee                	sd	s11,208(sp)
    80005228:	edf2                	sd	t3,216(sp)
    8000522a:	f1f6                	sd	t4,224(sp)
    8000522c:	f5fa                	sd	t5,232(sp)
    8000522e:	f9fe                	sd	t6,240(sp)
    80005230:	c8bfc0ef          	jal	80001eba <kerneltrap>
    80005234:	6082                	ld	ra,0(sp)
    80005236:	6122                	ld	sp,8(sp)
    80005238:	61c2                	ld	gp,16(sp)
    8000523a:	7282                	ld	t0,32(sp)
    8000523c:	7322                	ld	t1,40(sp)
    8000523e:	73c2                	ld	t2,48(sp)
    80005240:	7462                	ld	s0,56(sp)
    80005242:	6486                	ld	s1,64(sp)
    80005244:	6526                	ld	a0,72(sp)
    80005246:	65c6                	ld	a1,80(sp)
    80005248:	6666                	ld	a2,88(sp)
    8000524a:	7686                	ld	a3,96(sp)
    8000524c:	7726                	ld	a4,104(sp)
    8000524e:	77c6                	ld	a5,112(sp)
    80005250:	7866                	ld	a6,120(sp)
    80005252:	688a                	ld	a7,128(sp)
    80005254:	692a                	ld	s2,136(sp)
    80005256:	69ca                	ld	s3,144(sp)
    80005258:	6a6a                	ld	s4,152(sp)
    8000525a:	7a8a                	ld	s5,160(sp)
    8000525c:	7b2a                	ld	s6,168(sp)
    8000525e:	7bca                	ld	s7,176(sp)
    80005260:	7c6a                	ld	s8,184(sp)
    80005262:	6c8e                	ld	s9,192(sp)
    80005264:	6d2e                	ld	s10,200(sp)
    80005266:	6dce                	ld	s11,208(sp)
    80005268:	6e6e                	ld	t3,216(sp)
    8000526a:	7e8e                	ld	t4,224(sp)
    8000526c:	7f2e                	ld	t5,232(sp)
    8000526e:	7fce                	ld	t6,240(sp)
    80005270:	6111                	addi	sp,sp,256
    80005272:	10200073          	sret
    80005276:	00000013          	nop
    8000527a:	00000013          	nop
    8000527e:	0001                	nop

0000000080005280 <timervec>:
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	e10c                	sd	a1,0(a0)
    80005286:	e510                	sd	a2,8(a0)
    80005288:	e914                	sd	a3,16(a0)
    8000528a:	6d0c                	ld	a1,24(a0)
    8000528c:	7110                	ld	a2,32(a0)
    8000528e:	6194                	ld	a3,0(a1)
    80005290:	96b2                	add	a3,a3,a2
    80005292:	e194                	sd	a3,0(a1)
    80005294:	4589                	li	a1,2
    80005296:	14459073          	csrw	sip,a1
    8000529a:	6914                	ld	a3,16(a0)
    8000529c:	6510                	ld	a2,8(a0)
    8000529e:	610c                	ld	a1,0(a0)
    800052a0:	34051573          	csrrw	a0,mscratch,a0
    800052a4:	30200073          	mret
	...

00000000800052aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052aa:	1141                	addi	sp,sp,-16
    800052ac:	e422                	sd	s0,8(sp)
    800052ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052b0:	0c0007b7          	lui	a5,0xc000
    800052b4:	4705                	li	a4,1
    800052b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052b8:	c3d8                	sw	a4,4(a5)
}
    800052ba:	6422                	ld	s0,8(sp)
    800052bc:	0141                	addi	sp,sp,16
    800052be:	8082                	ret

00000000800052c0 <plicinithart>:

void
plicinithart(void)
{
    800052c0:	1141                	addi	sp,sp,-16
    800052c2:	e406                	sd	ra,8(sp)
    800052c4:	e022                	sd	s0,0(sp)
    800052c6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	c5e080e7          	jalr	-930(ra) # 80000f26 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052d0:	0085171b          	slliw	a4,a0,0x8
    800052d4:	0c0027b7          	lui	a5,0xc002
    800052d8:	97ba                	add	a5,a5,a4
    800052da:	40200713          	li	a4,1026
    800052de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052e2:	00d5151b          	slliw	a0,a0,0xd
    800052e6:	0c2017b7          	lui	a5,0xc201
    800052ea:	953e                	add	a0,a0,a5
    800052ec:	00052023          	sw	zero,0(a0)
}
    800052f0:	60a2                	ld	ra,8(sp)
    800052f2:	6402                	ld	s0,0(sp)
    800052f4:	0141                	addi	sp,sp,16
    800052f6:	8082                	ret

00000000800052f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052f8:	1141                	addi	sp,sp,-16
    800052fa:	e406                	sd	ra,8(sp)
    800052fc:	e022                	sd	s0,0(sp)
    800052fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005300:	ffffc097          	auipc	ra,0xffffc
    80005304:	c26080e7          	jalr	-986(ra) # 80000f26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005308:	00d5179b          	slliw	a5,a0,0xd
    8000530c:	0c201537          	lui	a0,0xc201
    80005310:	953e                	add	a0,a0,a5
  return irq;
}
    80005312:	4148                	lw	a0,4(a0)
    80005314:	60a2                	ld	ra,8(sp)
    80005316:	6402                	ld	s0,0(sp)
    80005318:	0141                	addi	sp,sp,16
    8000531a:	8082                	ret

000000008000531c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000531c:	1101                	addi	sp,sp,-32
    8000531e:	ec06                	sd	ra,24(sp)
    80005320:	e822                	sd	s0,16(sp)
    80005322:	e426                	sd	s1,8(sp)
    80005324:	1000                	addi	s0,sp,32
    80005326:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005328:	ffffc097          	auipc	ra,0xffffc
    8000532c:	bfe080e7          	jalr	-1026(ra) # 80000f26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005330:	00d5151b          	slliw	a0,a0,0xd
    80005334:	0c2017b7          	lui	a5,0xc201
    80005338:	97aa                	add	a5,a5,a0
    8000533a:	c3c4                	sw	s1,4(a5)
}
    8000533c:	60e2                	ld	ra,24(sp)
    8000533e:	6442                	ld	s0,16(sp)
    80005340:	64a2                	ld	s1,8(sp)
    80005342:	6105                	addi	sp,sp,32
    80005344:	8082                	ret

0000000080005346 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005346:	1141                	addi	sp,sp,-16
    80005348:	e406                	sd	ra,8(sp)
    8000534a:	e022                	sd	s0,0(sp)
    8000534c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000534e:	479d                	li	a5,7
    80005350:	06a7c963          	blt	a5,a0,800053c2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005354:	00016797          	auipc	a5,0x16
    80005358:	cac78793          	addi	a5,a5,-852 # 8001b000 <disk>
    8000535c:	00a78733          	add	a4,a5,a0
    80005360:	6789                	lui	a5,0x2
    80005362:	97ba                	add	a5,a5,a4
    80005364:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005368:	e7ad                	bnez	a5,800053d2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000536a:	00451793          	slli	a5,a0,0x4
    8000536e:	00018717          	auipc	a4,0x18
    80005372:	c9270713          	addi	a4,a4,-878 # 8001d000 <disk+0x2000>
    80005376:	6314                	ld	a3,0(a4)
    80005378:	96be                	add	a3,a3,a5
    8000537a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000537e:	6314                	ld	a3,0(a4)
    80005380:	96be                	add	a3,a3,a5
    80005382:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005386:	6314                	ld	a3,0(a4)
    80005388:	96be                	add	a3,a3,a5
    8000538a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000538e:	6318                	ld	a4,0(a4)
    80005390:	97ba                	add	a5,a5,a4
    80005392:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005396:	00016797          	auipc	a5,0x16
    8000539a:	c6a78793          	addi	a5,a5,-918 # 8001b000 <disk>
    8000539e:	97aa                	add	a5,a5,a0
    800053a0:	6509                	lui	a0,0x2
    800053a2:	953e                	add	a0,a0,a5
    800053a4:	4785                	li	a5,1
    800053a6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053aa:	00018517          	auipc	a0,0x18
    800053ae:	c6e50513          	addi	a0,a0,-914 # 8001d018 <disk+0x2018>
    800053b2:	ffffc097          	auipc	ra,0xffffc
    800053b6:	472080e7          	jalr	1138(ra) # 80001824 <wakeup>
}
    800053ba:	60a2                	ld	ra,8(sp)
    800053bc:	6402                	ld	s0,0(sp)
    800053be:	0141                	addi	sp,sp,16
    800053c0:	8082                	ret
    panic("free_desc 1");
    800053c2:	00003517          	auipc	a0,0x3
    800053c6:	26e50513          	addi	a0,a0,622 # 80008630 <etext+0x630>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	9ca080e7          	jalr	-1590(ra) # 80005d94 <panic>
    panic("free_desc 2");
    800053d2:	00003517          	auipc	a0,0x3
    800053d6:	26e50513          	addi	a0,a0,622 # 80008640 <etext+0x640>
    800053da:	00001097          	auipc	ra,0x1
    800053de:	9ba080e7          	jalr	-1606(ra) # 80005d94 <panic>

00000000800053e2 <virtio_disk_init>:
{
    800053e2:	1101                	addi	sp,sp,-32
    800053e4:	ec06                	sd	ra,24(sp)
    800053e6:	e822                	sd	s0,16(sp)
    800053e8:	e426                	sd	s1,8(sp)
    800053ea:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053ec:	00003597          	auipc	a1,0x3
    800053f0:	26458593          	addi	a1,a1,612 # 80008650 <etext+0x650>
    800053f4:	00018517          	auipc	a0,0x18
    800053f8:	d3450513          	addi	a0,a0,-716 # 8001d128 <disk+0x2128>
    800053fc:	00001097          	auipc	ra,0x1
    80005400:	e44080e7          	jalr	-444(ra) # 80006240 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005404:	100017b7          	lui	a5,0x10001
    80005408:	4398                	lw	a4,0(a5)
    8000540a:	2701                	sext.w	a4,a4
    8000540c:	747277b7          	lui	a5,0x74727
    80005410:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005414:	0ef71163          	bne	a4,a5,800054f6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005418:	100017b7          	lui	a5,0x10001
    8000541c:	43dc                	lw	a5,4(a5)
    8000541e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005420:	4705                	li	a4,1
    80005422:	0ce79a63          	bne	a5,a4,800054f6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005426:	100017b7          	lui	a5,0x10001
    8000542a:	479c                	lw	a5,8(a5)
    8000542c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000542e:	4709                	li	a4,2
    80005430:	0ce79363          	bne	a5,a4,800054f6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005434:	100017b7          	lui	a5,0x10001
    80005438:	47d8                	lw	a4,12(a5)
    8000543a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000543c:	554d47b7          	lui	a5,0x554d4
    80005440:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005444:	0af71963          	bne	a4,a5,800054f6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005448:	100017b7          	lui	a5,0x10001
    8000544c:	4705                	li	a4,1
    8000544e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005450:	470d                	li	a4,3
    80005452:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005454:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005456:	c7ffe737          	lui	a4,0xc7ffe
    8000545a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000545e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005460:	2701                	sext.w	a4,a4
    80005462:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005464:	472d                	li	a4,11
    80005466:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005468:	473d                	li	a4,15
    8000546a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000546c:	6705                	lui	a4,0x1
    8000546e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005470:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005474:	5bdc                	lw	a5,52(a5)
    80005476:	2781                	sext.w	a5,a5
  if(max == 0)
    80005478:	c7d9                	beqz	a5,80005506 <virtio_disk_init+0x124>
  if(max < NUM)
    8000547a:	471d                	li	a4,7
    8000547c:	08f77d63          	bgeu	a4,a5,80005516 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005480:	100014b7          	lui	s1,0x10001
    80005484:	47a1                	li	a5,8
    80005486:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005488:	6609                	lui	a2,0x2
    8000548a:	4581                	li	a1,0
    8000548c:	00016517          	auipc	a0,0x16
    80005490:	b7450513          	addi	a0,a0,-1164 # 8001b000 <disk>
    80005494:	ffffb097          	auipc	ra,0xffffb
    80005498:	ce4080e7          	jalr	-796(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000549c:	00016717          	auipc	a4,0x16
    800054a0:	b6470713          	addi	a4,a4,-1180 # 8001b000 <disk>
    800054a4:	00c75793          	srli	a5,a4,0xc
    800054a8:	2781                	sext.w	a5,a5
    800054aa:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054ac:	00018797          	auipc	a5,0x18
    800054b0:	b5478793          	addi	a5,a5,-1196 # 8001d000 <disk+0x2000>
    800054b4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054b6:	00016717          	auipc	a4,0x16
    800054ba:	bca70713          	addi	a4,a4,-1078 # 8001b080 <disk+0x80>
    800054be:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054c0:	00017717          	auipc	a4,0x17
    800054c4:	b4070713          	addi	a4,a4,-1216 # 8001c000 <disk+0x1000>
    800054c8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054ca:	4705                	li	a4,1
    800054cc:	00e78c23          	sb	a4,24(a5)
    800054d0:	00e78ca3          	sb	a4,25(a5)
    800054d4:	00e78d23          	sb	a4,26(a5)
    800054d8:	00e78da3          	sb	a4,27(a5)
    800054dc:	00e78e23          	sb	a4,28(a5)
    800054e0:	00e78ea3          	sb	a4,29(a5)
    800054e4:	00e78f23          	sb	a4,30(a5)
    800054e8:	00e78fa3          	sb	a4,31(a5)
}
    800054ec:	60e2                	ld	ra,24(sp)
    800054ee:	6442                	ld	s0,16(sp)
    800054f0:	64a2                	ld	s1,8(sp)
    800054f2:	6105                	addi	sp,sp,32
    800054f4:	8082                	ret
    panic("could not find virtio disk");
    800054f6:	00003517          	auipc	a0,0x3
    800054fa:	16a50513          	addi	a0,a0,362 # 80008660 <etext+0x660>
    800054fe:	00001097          	auipc	ra,0x1
    80005502:	896080e7          	jalr	-1898(ra) # 80005d94 <panic>
    panic("virtio disk has no queue 0");
    80005506:	00003517          	auipc	a0,0x3
    8000550a:	17a50513          	addi	a0,a0,378 # 80008680 <etext+0x680>
    8000550e:	00001097          	auipc	ra,0x1
    80005512:	886080e7          	jalr	-1914(ra) # 80005d94 <panic>
    panic("virtio disk max queue too short");
    80005516:	00003517          	auipc	a0,0x3
    8000551a:	18a50513          	addi	a0,a0,394 # 800086a0 <etext+0x6a0>
    8000551e:	00001097          	auipc	ra,0x1
    80005522:	876080e7          	jalr	-1930(ra) # 80005d94 <panic>

0000000080005526 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005526:	7119                	addi	sp,sp,-128
    80005528:	fc86                	sd	ra,120(sp)
    8000552a:	f8a2                	sd	s0,112(sp)
    8000552c:	f4a6                	sd	s1,104(sp)
    8000552e:	f0ca                	sd	s2,96(sp)
    80005530:	ecce                	sd	s3,88(sp)
    80005532:	e8d2                	sd	s4,80(sp)
    80005534:	e4d6                	sd	s5,72(sp)
    80005536:	e0da                	sd	s6,64(sp)
    80005538:	fc5e                	sd	s7,56(sp)
    8000553a:	f862                	sd	s8,48(sp)
    8000553c:	f466                	sd	s9,40(sp)
    8000553e:	f06a                	sd	s10,32(sp)
    80005540:	ec6e                	sd	s11,24(sp)
    80005542:	0100                	addi	s0,sp,128
    80005544:	8aaa                	mv	s5,a0
    80005546:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005548:	00c52c83          	lw	s9,12(a0)
    8000554c:	001c9c9b          	slliw	s9,s9,0x1
    80005550:	1c82                	slli	s9,s9,0x20
    80005552:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005556:	00018517          	auipc	a0,0x18
    8000555a:	bd250513          	addi	a0,a0,-1070 # 8001d128 <disk+0x2128>
    8000555e:	00001097          	auipc	ra,0x1
    80005562:	d72080e7          	jalr	-654(ra) # 800062d0 <acquire>
  for(int i = 0; i < 3; i++){
    80005566:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005568:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000556a:	00016c17          	auipc	s8,0x16
    8000556e:	a96c0c13          	addi	s8,s8,-1386 # 8001b000 <disk>
    80005572:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005574:	4b0d                	li	s6,3
    80005576:	a0ad                	j	800055e0 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005578:	00fc0733          	add	a4,s8,a5
    8000557c:	975e                	add	a4,a4,s7
    8000557e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005582:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005584:	0207c563          	bltz	a5,800055ae <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005588:	2905                	addiw	s2,s2,1
    8000558a:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    8000558c:	19690d63          	beq	s2,s6,80005726 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80005590:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005592:	00018717          	auipc	a4,0x18
    80005596:	a8670713          	addi	a4,a4,-1402 # 8001d018 <disk+0x2018>
    8000559a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000559c:	00074683          	lbu	a3,0(a4)
    800055a0:	fee1                	bnez	a3,80005578 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055a2:	2785                	addiw	a5,a5,1
    800055a4:	0705                	addi	a4,a4,1
    800055a6:	fe979be3          	bne	a5,s1,8000559c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055aa:	57fd                	li	a5,-1
    800055ac:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055ae:	01205d63          	blez	s2,800055c8 <virtio_disk_rw+0xa2>
    800055b2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055b4:	000a2503          	lw	a0,0(s4)
    800055b8:	00000097          	auipc	ra,0x0
    800055bc:	d8e080e7          	jalr	-626(ra) # 80005346 <free_desc>
      for(int j = 0; j < i; j++)
    800055c0:	2d85                	addiw	s11,s11,1
    800055c2:	0a11                	addi	s4,s4,4
    800055c4:	ffb918e3          	bne	s2,s11,800055b4 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055c8:	00018597          	auipc	a1,0x18
    800055cc:	b6058593          	addi	a1,a1,-1184 # 8001d128 <disk+0x2128>
    800055d0:	00018517          	auipc	a0,0x18
    800055d4:	a4850513          	addi	a0,a0,-1464 # 8001d018 <disk+0x2018>
    800055d8:	ffffc097          	auipc	ra,0xffffc
    800055dc:	0c0080e7          	jalr	192(ra) # 80001698 <sleep>
  for(int i = 0; i < 3; i++){
    800055e0:	f8040a13          	addi	s4,s0,-128
{
    800055e4:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055e6:	894e                	mv	s2,s3
    800055e8:	b765                	j	80005590 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055ea:	00018697          	auipc	a3,0x18
    800055ee:	a166b683          	ld	a3,-1514(a3) # 8001d000 <disk+0x2000>
    800055f2:	96ba                	add	a3,a3,a4
    800055f4:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055f8:	00016817          	auipc	a6,0x16
    800055fc:	a0880813          	addi	a6,a6,-1528 # 8001b000 <disk>
    80005600:	00018697          	auipc	a3,0x18
    80005604:	a0068693          	addi	a3,a3,-1536 # 8001d000 <disk+0x2000>
    80005608:	6290                	ld	a2,0(a3)
    8000560a:	963a                	add	a2,a2,a4
    8000560c:	00c65583          	lhu	a1,12(a2)
    80005610:	0015e593          	ori	a1,a1,1
    80005614:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005618:	f8842603          	lw	a2,-120(s0)
    8000561c:	628c                	ld	a1,0(a3)
    8000561e:	972e                	add	a4,a4,a1
    80005620:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005624:	20050593          	addi	a1,a0,512
    80005628:	0592                	slli	a1,a1,0x4
    8000562a:	95c2                	add	a1,a1,a6
    8000562c:	577d                	li	a4,-1
    8000562e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005632:	00461713          	slli	a4,a2,0x4
    80005636:	6290                	ld	a2,0(a3)
    80005638:	963a                	add	a2,a2,a4
    8000563a:	03078793          	addi	a5,a5,48
    8000563e:	97c2                	add	a5,a5,a6
    80005640:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80005642:	629c                	ld	a5,0(a3)
    80005644:	97ba                	add	a5,a5,a4
    80005646:	4605                	li	a2,1
    80005648:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000564a:	629c                	ld	a5,0(a3)
    8000564c:	97ba                	add	a5,a5,a4
    8000564e:	4809                	li	a6,2
    80005650:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005654:	629c                	ld	a5,0(a3)
    80005656:	973e                	add	a4,a4,a5
    80005658:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000565c:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005660:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005664:	6698                	ld	a4,8(a3)
    80005666:	00275783          	lhu	a5,2(a4)
    8000566a:	8b9d                	andi	a5,a5,7
    8000566c:	0786                	slli	a5,a5,0x1
    8000566e:	97ba                	add	a5,a5,a4
    80005670:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80005674:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005678:	6698                	ld	a4,8(a3)
    8000567a:	00275783          	lhu	a5,2(a4)
    8000567e:	2785                	addiw	a5,a5,1
    80005680:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005684:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005688:	100017b7          	lui	a5,0x10001
    8000568c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005690:	004aa783          	lw	a5,4(s5)
    80005694:	02c79163          	bne	a5,a2,800056b6 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005698:	00018917          	auipc	s2,0x18
    8000569c:	a9090913          	addi	s2,s2,-1392 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800056a0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056a2:	85ca                	mv	a1,s2
    800056a4:	8556                	mv	a0,s5
    800056a6:	ffffc097          	auipc	ra,0xffffc
    800056aa:	ff2080e7          	jalr	-14(ra) # 80001698 <sleep>
  while(b->disk == 1) {
    800056ae:	004aa783          	lw	a5,4(s5)
    800056b2:	fe9788e3          	beq	a5,s1,800056a2 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800056b6:	f8042903          	lw	s2,-128(s0)
    800056ba:	20090793          	addi	a5,s2,512
    800056be:	00479713          	slli	a4,a5,0x4
    800056c2:	00016797          	auipc	a5,0x16
    800056c6:	93e78793          	addi	a5,a5,-1730 # 8001b000 <disk>
    800056ca:	97ba                	add	a5,a5,a4
    800056cc:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056d0:	00018997          	auipc	s3,0x18
    800056d4:	93098993          	addi	s3,s3,-1744 # 8001d000 <disk+0x2000>
    800056d8:	00491713          	slli	a4,s2,0x4
    800056dc:	0009b783          	ld	a5,0(s3)
    800056e0:	97ba                	add	a5,a5,a4
    800056e2:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056e6:	854a                	mv	a0,s2
    800056e8:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056ec:	00000097          	auipc	ra,0x0
    800056f0:	c5a080e7          	jalr	-934(ra) # 80005346 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056f4:	8885                	andi	s1,s1,1
    800056f6:	f0ed                	bnez	s1,800056d8 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056f8:	00018517          	auipc	a0,0x18
    800056fc:	a3050513          	addi	a0,a0,-1488 # 8001d128 <disk+0x2128>
    80005700:	00001097          	auipc	ra,0x1
    80005704:	c84080e7          	jalr	-892(ra) # 80006384 <release>
}
    80005708:	70e6                	ld	ra,120(sp)
    8000570a:	7446                	ld	s0,112(sp)
    8000570c:	74a6                	ld	s1,104(sp)
    8000570e:	7906                	ld	s2,96(sp)
    80005710:	69e6                	ld	s3,88(sp)
    80005712:	6a46                	ld	s4,80(sp)
    80005714:	6aa6                	ld	s5,72(sp)
    80005716:	6b06                	ld	s6,64(sp)
    80005718:	7be2                	ld	s7,56(sp)
    8000571a:	7c42                	ld	s8,48(sp)
    8000571c:	7ca2                	ld	s9,40(sp)
    8000571e:	7d02                	ld	s10,32(sp)
    80005720:	6de2                	ld	s11,24(sp)
    80005722:	6109                	addi	sp,sp,128
    80005724:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005726:	f8042503          	lw	a0,-128(s0)
    8000572a:	20050793          	addi	a5,a0,512
    8000572e:	0792                	slli	a5,a5,0x4
  if(write)
    80005730:	00016817          	auipc	a6,0x16
    80005734:	8d080813          	addi	a6,a6,-1840 # 8001b000 <disk>
    80005738:	00f80733          	add	a4,a6,a5
    8000573c:	01a036b3          	snez	a3,s10
    80005740:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80005744:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005748:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000574c:	7679                	lui	a2,0xffffe
    8000574e:	963e                	add	a2,a2,a5
    80005750:	00018697          	auipc	a3,0x18
    80005754:	8b068693          	addi	a3,a3,-1872 # 8001d000 <disk+0x2000>
    80005758:	6298                	ld	a4,0(a3)
    8000575a:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000575c:	0a878593          	addi	a1,a5,168
    80005760:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005762:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005764:	6298                	ld	a4,0(a3)
    80005766:	9732                	add	a4,a4,a2
    80005768:	45c1                	li	a1,16
    8000576a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000576c:	6298                	ld	a4,0(a3)
    8000576e:	9732                	add	a4,a4,a2
    80005770:	4585                	li	a1,1
    80005772:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005776:	f8442703          	lw	a4,-124(s0)
    8000577a:	628c                	ld	a1,0(a3)
    8000577c:	962e                	add	a2,a2,a1
    8000577e:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005782:	0712                	slli	a4,a4,0x4
    80005784:	6290                	ld	a2,0(a3)
    80005786:	963a                	add	a2,a2,a4
    80005788:	058a8593          	addi	a1,s5,88
    8000578c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000578e:	6294                	ld	a3,0(a3)
    80005790:	96ba                	add	a3,a3,a4
    80005792:	40000613          	li	a2,1024
    80005796:	c690                	sw	a2,8(a3)
  if(write)
    80005798:	e40d19e3          	bnez	s10,800055ea <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000579c:	00018697          	auipc	a3,0x18
    800057a0:	8646b683          	ld	a3,-1948(a3) # 8001d000 <disk+0x2000>
    800057a4:	96ba                	add	a3,a3,a4
    800057a6:	4609                	li	a2,2
    800057a8:	00c69623          	sh	a2,12(a3)
    800057ac:	b5b1                	j	800055f8 <virtio_disk_rw+0xd2>

00000000800057ae <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057ae:	1101                	addi	sp,sp,-32
    800057b0:	ec06                	sd	ra,24(sp)
    800057b2:	e822                	sd	s0,16(sp)
    800057b4:	e426                	sd	s1,8(sp)
    800057b6:	e04a                	sd	s2,0(sp)
    800057b8:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057ba:	00018517          	auipc	a0,0x18
    800057be:	96e50513          	addi	a0,a0,-1682 # 8001d128 <disk+0x2128>
    800057c2:	00001097          	auipc	ra,0x1
    800057c6:	b0e080e7          	jalr	-1266(ra) # 800062d0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057ca:	10001737          	lui	a4,0x10001
    800057ce:	533c                	lw	a5,96(a4)
    800057d0:	8b8d                	andi	a5,a5,3
    800057d2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057d4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057d8:	00018797          	auipc	a5,0x18
    800057dc:	82878793          	addi	a5,a5,-2008 # 8001d000 <disk+0x2000>
    800057e0:	6b94                	ld	a3,16(a5)
    800057e2:	0207d703          	lhu	a4,32(a5)
    800057e6:	0026d783          	lhu	a5,2(a3)
    800057ea:	06f70163          	beq	a4,a5,8000584c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057ee:	00016917          	auipc	s2,0x16
    800057f2:	81290913          	addi	s2,s2,-2030 # 8001b000 <disk>
    800057f6:	00018497          	auipc	s1,0x18
    800057fa:	80a48493          	addi	s1,s1,-2038 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057fe:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005802:	6898                	ld	a4,16(s1)
    80005804:	0204d783          	lhu	a5,32(s1)
    80005808:	8b9d                	andi	a5,a5,7
    8000580a:	078e                	slli	a5,a5,0x3
    8000580c:	97ba                	add	a5,a5,a4
    8000580e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005810:	20078713          	addi	a4,a5,512
    80005814:	0712                	slli	a4,a4,0x4
    80005816:	974a                	add	a4,a4,s2
    80005818:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000581c:	e731                	bnez	a4,80005868 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000581e:	20078793          	addi	a5,a5,512
    80005822:	0792                	slli	a5,a5,0x4
    80005824:	97ca                	add	a5,a5,s2
    80005826:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005828:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000582c:	ffffc097          	auipc	ra,0xffffc
    80005830:	ff8080e7          	jalr	-8(ra) # 80001824 <wakeup>

    disk.used_idx += 1;
    80005834:	0204d783          	lhu	a5,32(s1)
    80005838:	2785                	addiw	a5,a5,1
    8000583a:	17c2                	slli	a5,a5,0x30
    8000583c:	93c1                	srli	a5,a5,0x30
    8000583e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005842:	6898                	ld	a4,16(s1)
    80005844:	00275703          	lhu	a4,2(a4)
    80005848:	faf71be3          	bne	a4,a5,800057fe <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000584c:	00018517          	auipc	a0,0x18
    80005850:	8dc50513          	addi	a0,a0,-1828 # 8001d128 <disk+0x2128>
    80005854:	00001097          	auipc	ra,0x1
    80005858:	b30080e7          	jalr	-1232(ra) # 80006384 <release>
}
    8000585c:	60e2                	ld	ra,24(sp)
    8000585e:	6442                	ld	s0,16(sp)
    80005860:	64a2                	ld	s1,8(sp)
    80005862:	6902                	ld	s2,0(sp)
    80005864:	6105                	addi	sp,sp,32
    80005866:	8082                	ret
      panic("virtio_disk_intr status");
    80005868:	00003517          	auipc	a0,0x3
    8000586c:	e5850513          	addi	a0,a0,-424 # 800086c0 <etext+0x6c0>
    80005870:	00000097          	auipc	ra,0x0
    80005874:	524080e7          	jalr	1316(ra) # 80005d94 <panic>

0000000080005878 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005878:	1141                	addi	sp,sp,-16
    8000587a:	e422                	sd	s0,8(sp)
    8000587c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000587e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005882:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005886:	0037979b          	slliw	a5,a5,0x3
    8000588a:	02004737          	lui	a4,0x2004
    8000588e:	97ba                	add	a5,a5,a4
    80005890:	0200c737          	lui	a4,0x200c
    80005894:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005898:	000f4637          	lui	a2,0xf4
    8000589c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058a0:	95b2                	add	a1,a1,a2
    800058a2:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058a4:	00269713          	slli	a4,a3,0x2
    800058a8:	9736                	add	a4,a4,a3
    800058aa:	00371693          	slli	a3,a4,0x3
    800058ae:	00018717          	auipc	a4,0x18
    800058b2:	75270713          	addi	a4,a4,1874 # 8001e000 <timer_scratch>
    800058b6:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058b8:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058ba:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058bc:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058c0:	00000797          	auipc	a5,0x0
    800058c4:	9c078793          	addi	a5,a5,-1600 # 80005280 <timervec>
    800058c8:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058cc:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058d0:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058d4:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058d8:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058dc:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058e0:	30479073          	csrw	mie,a5
}
    800058e4:	6422                	ld	s0,8(sp)
    800058e6:	0141                	addi	sp,sp,16
    800058e8:	8082                	ret

00000000800058ea <start>:
{
    800058ea:	1141                	addi	sp,sp,-16
    800058ec:	e406                	sd	ra,8(sp)
    800058ee:	e022                	sd	s0,0(sp)
    800058f0:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058f2:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058f6:	7779                	lui	a4,0xffffe
    800058f8:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058fc:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058fe:	6705                	lui	a4,0x1
    80005900:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005904:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005906:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000590a:	ffffb797          	auipc	a5,0xffffb
    8000590e:	a1478793          	addi	a5,a5,-1516 # 8000031e <main>
    80005912:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005916:	4781                	li	a5,0
    80005918:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000591c:	67c1                	lui	a5,0x10
    8000591e:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005920:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005924:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005928:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000592c:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005930:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005934:	57fd                	li	a5,-1
    80005936:	83a9                	srli	a5,a5,0xa
    80005938:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000593c:	47bd                	li	a5,15
    8000593e:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005942:	00000097          	auipc	ra,0x0
    80005946:	f36080e7          	jalr	-202(ra) # 80005878 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000594a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000594e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005950:	823e                	mv	tp,a5
  asm volatile("mret");
    80005952:	30200073          	mret
}
    80005956:	60a2                	ld	ra,8(sp)
    80005958:	6402                	ld	s0,0(sp)
    8000595a:	0141                	addi	sp,sp,16
    8000595c:	8082                	ret

000000008000595e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000595e:	715d                	addi	sp,sp,-80
    80005960:	e486                	sd	ra,72(sp)
    80005962:	e0a2                	sd	s0,64(sp)
    80005964:	fc26                	sd	s1,56(sp)
    80005966:	f84a                	sd	s2,48(sp)
    80005968:	f44e                	sd	s3,40(sp)
    8000596a:	f052                	sd	s4,32(sp)
    8000596c:	ec56                	sd	s5,24(sp)
    8000596e:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005970:	04c05663          	blez	a2,800059bc <consolewrite+0x5e>
    80005974:	8a2a                	mv	s4,a0
    80005976:	84ae                	mv	s1,a1
    80005978:	89b2                	mv	s3,a2
    8000597a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000597c:	5afd                	li	s5,-1
    8000597e:	4685                	li	a3,1
    80005980:	8626                	mv	a2,s1
    80005982:	85d2                	mv	a1,s4
    80005984:	fbf40513          	addi	a0,s0,-65
    80005988:	ffffc097          	auipc	ra,0xffffc
    8000598c:	10a080e7          	jalr	266(ra) # 80001a92 <either_copyin>
    80005990:	01550c63          	beq	a0,s5,800059a8 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005994:	fbf44503          	lbu	a0,-65(s0)
    80005998:	00000097          	auipc	ra,0x0
    8000599c:	77a080e7          	jalr	1914(ra) # 80006112 <uartputc>
  for(i = 0; i < n; i++){
    800059a0:	2905                	addiw	s2,s2,1
    800059a2:	0485                	addi	s1,s1,1
    800059a4:	fd299de3          	bne	s3,s2,8000597e <consolewrite+0x20>
  }

  return i;
}
    800059a8:	854a                	mv	a0,s2
    800059aa:	60a6                	ld	ra,72(sp)
    800059ac:	6406                	ld	s0,64(sp)
    800059ae:	74e2                	ld	s1,56(sp)
    800059b0:	7942                	ld	s2,48(sp)
    800059b2:	79a2                	ld	s3,40(sp)
    800059b4:	7a02                	ld	s4,32(sp)
    800059b6:	6ae2                	ld	s5,24(sp)
    800059b8:	6161                	addi	sp,sp,80
    800059ba:	8082                	ret
  for(i = 0; i < n; i++){
    800059bc:	4901                	li	s2,0
    800059be:	b7ed                	j	800059a8 <consolewrite+0x4a>

00000000800059c0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059c0:	7159                	addi	sp,sp,-112
    800059c2:	f486                	sd	ra,104(sp)
    800059c4:	f0a2                	sd	s0,96(sp)
    800059c6:	eca6                	sd	s1,88(sp)
    800059c8:	e8ca                	sd	s2,80(sp)
    800059ca:	e4ce                	sd	s3,72(sp)
    800059cc:	e0d2                	sd	s4,64(sp)
    800059ce:	fc56                	sd	s5,56(sp)
    800059d0:	f85a                	sd	s6,48(sp)
    800059d2:	f45e                	sd	s7,40(sp)
    800059d4:	f062                	sd	s8,32(sp)
    800059d6:	ec66                	sd	s9,24(sp)
    800059d8:	e86a                	sd	s10,16(sp)
    800059da:	1880                	addi	s0,sp,112
    800059dc:	8aaa                	mv	s5,a0
    800059de:	8a2e                	mv	s4,a1
    800059e0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059e2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059e6:	00020517          	auipc	a0,0x20
    800059ea:	75a50513          	addi	a0,a0,1882 # 80026140 <cons>
    800059ee:	00001097          	auipc	ra,0x1
    800059f2:	8e2080e7          	jalr	-1822(ra) # 800062d0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059f6:	00020497          	auipc	s1,0x20
    800059fa:	74a48493          	addi	s1,s1,1866 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059fe:	00020917          	auipc	s2,0x20
    80005a02:	7da90913          	addi	s2,s2,2010 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a06:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a08:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a0a:	4ca9                	li	s9,10
  while(n > 0){
    80005a0c:	07305863          	blez	s3,80005a7c <consoleread+0xbc>
    while(cons.r == cons.w){
    80005a10:	0984a783          	lw	a5,152(s1)
    80005a14:	09c4a703          	lw	a4,156(s1)
    80005a18:	02f71463          	bne	a4,a5,80005a40 <consoleread+0x80>
      if(myproc()->killed){
    80005a1c:	ffffb097          	auipc	ra,0xffffb
    80005a20:	536080e7          	jalr	1334(ra) # 80000f52 <myproc>
    80005a24:	551c                	lw	a5,40(a0)
    80005a26:	e7b5                	bnez	a5,80005a92 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005a28:	85a6                	mv	a1,s1
    80005a2a:	854a                	mv	a0,s2
    80005a2c:	ffffc097          	auipc	ra,0xffffc
    80005a30:	c6c080e7          	jalr	-916(ra) # 80001698 <sleep>
    while(cons.r == cons.w){
    80005a34:	0984a783          	lw	a5,152(s1)
    80005a38:	09c4a703          	lw	a4,156(s1)
    80005a3c:	fef700e3          	beq	a4,a5,80005a1c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a40:	0017871b          	addiw	a4,a5,1
    80005a44:	08e4ac23          	sw	a4,152(s1)
    80005a48:	07f7f713          	andi	a4,a5,127
    80005a4c:	9726                	add	a4,a4,s1
    80005a4e:	01874703          	lbu	a4,24(a4)
    80005a52:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a56:	077d0563          	beq	s10,s7,80005ac0 <consoleread+0x100>
    cbuf = c;
    80005a5a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a5e:	4685                	li	a3,1
    80005a60:	f9f40613          	addi	a2,s0,-97
    80005a64:	85d2                	mv	a1,s4
    80005a66:	8556                	mv	a0,s5
    80005a68:	ffffc097          	auipc	ra,0xffffc
    80005a6c:	fd4080e7          	jalr	-44(ra) # 80001a3c <either_copyout>
    80005a70:	01850663          	beq	a0,s8,80005a7c <consoleread+0xbc>
    dst++;
    80005a74:	0a05                	addi	s4,s4,1
    --n;
    80005a76:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a78:	f99d1ae3          	bne	s10,s9,80005a0c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a7c:	00020517          	auipc	a0,0x20
    80005a80:	6c450513          	addi	a0,a0,1732 # 80026140 <cons>
    80005a84:	00001097          	auipc	ra,0x1
    80005a88:	900080e7          	jalr	-1792(ra) # 80006384 <release>

  return target - n;
    80005a8c:	413b053b          	subw	a0,s6,s3
    80005a90:	a811                	j	80005aa4 <consoleread+0xe4>
        release(&cons.lock);
    80005a92:	00020517          	auipc	a0,0x20
    80005a96:	6ae50513          	addi	a0,a0,1710 # 80026140 <cons>
    80005a9a:	00001097          	auipc	ra,0x1
    80005a9e:	8ea080e7          	jalr	-1814(ra) # 80006384 <release>
        return -1;
    80005aa2:	557d                	li	a0,-1
}
    80005aa4:	70a6                	ld	ra,104(sp)
    80005aa6:	7406                	ld	s0,96(sp)
    80005aa8:	64e6                	ld	s1,88(sp)
    80005aaa:	6946                	ld	s2,80(sp)
    80005aac:	69a6                	ld	s3,72(sp)
    80005aae:	6a06                	ld	s4,64(sp)
    80005ab0:	7ae2                	ld	s5,56(sp)
    80005ab2:	7b42                	ld	s6,48(sp)
    80005ab4:	7ba2                	ld	s7,40(sp)
    80005ab6:	7c02                	ld	s8,32(sp)
    80005ab8:	6ce2                	ld	s9,24(sp)
    80005aba:	6d42                	ld	s10,16(sp)
    80005abc:	6165                	addi	sp,sp,112
    80005abe:	8082                	ret
      if(n < target){
    80005ac0:	0009871b          	sext.w	a4,s3
    80005ac4:	fb677ce3          	bgeu	a4,s6,80005a7c <consoleread+0xbc>
        cons.r--;
    80005ac8:	00020717          	auipc	a4,0x20
    80005acc:	70f72823          	sw	a5,1808(a4) # 800261d8 <cons+0x98>
    80005ad0:	b775                	j	80005a7c <consoleread+0xbc>

0000000080005ad2 <consputc>:
{
    80005ad2:	1141                	addi	sp,sp,-16
    80005ad4:	e406                	sd	ra,8(sp)
    80005ad6:	e022                	sd	s0,0(sp)
    80005ad8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ada:	10000793          	li	a5,256
    80005ade:	00f50a63          	beq	a0,a5,80005af2 <consputc+0x20>
    uartputc_sync(c);
    80005ae2:	00000097          	auipc	ra,0x0
    80005ae6:	55e080e7          	jalr	1374(ra) # 80006040 <uartputc_sync>
}
    80005aea:	60a2                	ld	ra,8(sp)
    80005aec:	6402                	ld	s0,0(sp)
    80005aee:	0141                	addi	sp,sp,16
    80005af0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005af2:	4521                	li	a0,8
    80005af4:	00000097          	auipc	ra,0x0
    80005af8:	54c080e7          	jalr	1356(ra) # 80006040 <uartputc_sync>
    80005afc:	02000513          	li	a0,32
    80005b00:	00000097          	auipc	ra,0x0
    80005b04:	540080e7          	jalr	1344(ra) # 80006040 <uartputc_sync>
    80005b08:	4521                	li	a0,8
    80005b0a:	00000097          	auipc	ra,0x0
    80005b0e:	536080e7          	jalr	1334(ra) # 80006040 <uartputc_sync>
    80005b12:	bfe1                	j	80005aea <consputc+0x18>

0000000080005b14 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b14:	1101                	addi	sp,sp,-32
    80005b16:	ec06                	sd	ra,24(sp)
    80005b18:	e822                	sd	s0,16(sp)
    80005b1a:	e426                	sd	s1,8(sp)
    80005b1c:	e04a                	sd	s2,0(sp)
    80005b1e:	1000                	addi	s0,sp,32
    80005b20:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b22:	00020517          	auipc	a0,0x20
    80005b26:	61e50513          	addi	a0,a0,1566 # 80026140 <cons>
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	7a6080e7          	jalr	1958(ra) # 800062d0 <acquire>

  switch(c){
    80005b32:	47d5                	li	a5,21
    80005b34:	0af48663          	beq	s1,a5,80005be0 <consoleintr+0xcc>
    80005b38:	0297ca63          	blt	a5,s1,80005b6c <consoleintr+0x58>
    80005b3c:	47a1                	li	a5,8
    80005b3e:	0ef48763          	beq	s1,a5,80005c2c <consoleintr+0x118>
    80005b42:	47c1                	li	a5,16
    80005b44:	10f49a63          	bne	s1,a5,80005c58 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b48:	ffffc097          	auipc	ra,0xffffc
    80005b4c:	fa0080e7          	jalr	-96(ra) # 80001ae8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b50:	00020517          	auipc	a0,0x20
    80005b54:	5f050513          	addi	a0,a0,1520 # 80026140 <cons>
    80005b58:	00001097          	auipc	ra,0x1
    80005b5c:	82c080e7          	jalr	-2004(ra) # 80006384 <release>
}
    80005b60:	60e2                	ld	ra,24(sp)
    80005b62:	6442                	ld	s0,16(sp)
    80005b64:	64a2                	ld	s1,8(sp)
    80005b66:	6902                	ld	s2,0(sp)
    80005b68:	6105                	addi	sp,sp,32
    80005b6a:	8082                	ret
  switch(c){
    80005b6c:	07f00793          	li	a5,127
    80005b70:	0af48e63          	beq	s1,a5,80005c2c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b74:	00020717          	auipc	a4,0x20
    80005b78:	5cc70713          	addi	a4,a4,1484 # 80026140 <cons>
    80005b7c:	0a072783          	lw	a5,160(a4)
    80005b80:	09872703          	lw	a4,152(a4)
    80005b84:	9f99                	subw	a5,a5,a4
    80005b86:	07f00713          	li	a4,127
    80005b8a:	fcf763e3          	bltu	a4,a5,80005b50 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b8e:	47b5                	li	a5,13
    80005b90:	0cf48763          	beq	s1,a5,80005c5e <consoleintr+0x14a>
      consputc(c);
    80005b94:	8526                	mv	a0,s1
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	f3c080e7          	jalr	-196(ra) # 80005ad2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b9e:	00020797          	auipc	a5,0x20
    80005ba2:	5a278793          	addi	a5,a5,1442 # 80026140 <cons>
    80005ba6:	0a07a703          	lw	a4,160(a5)
    80005baa:	0017069b          	addiw	a3,a4,1
    80005bae:	0006861b          	sext.w	a2,a3
    80005bb2:	0ad7a023          	sw	a3,160(a5)
    80005bb6:	07f77713          	andi	a4,a4,127
    80005bba:	97ba                	add	a5,a5,a4
    80005bbc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bc0:	47a9                	li	a5,10
    80005bc2:	0cf48563          	beq	s1,a5,80005c8c <consoleintr+0x178>
    80005bc6:	4791                	li	a5,4
    80005bc8:	0cf48263          	beq	s1,a5,80005c8c <consoleintr+0x178>
    80005bcc:	00020797          	auipc	a5,0x20
    80005bd0:	60c7a783          	lw	a5,1548(a5) # 800261d8 <cons+0x98>
    80005bd4:	0807879b          	addiw	a5,a5,128
    80005bd8:	f6f61ce3          	bne	a2,a5,80005b50 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bdc:	863e                	mv	a2,a5
    80005bde:	a07d                	j	80005c8c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005be0:	00020717          	auipc	a4,0x20
    80005be4:	56070713          	addi	a4,a4,1376 # 80026140 <cons>
    80005be8:	0a072783          	lw	a5,160(a4)
    80005bec:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bf0:	00020497          	auipc	s1,0x20
    80005bf4:	55048493          	addi	s1,s1,1360 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005bf8:	4929                	li	s2,10
    80005bfa:	f4f70be3          	beq	a4,a5,80005b50 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bfe:	37fd                	addiw	a5,a5,-1
    80005c00:	07f7f713          	andi	a4,a5,127
    80005c04:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c06:	01874703          	lbu	a4,24(a4)
    80005c0a:	f52703e3          	beq	a4,s2,80005b50 <consoleintr+0x3c>
      cons.e--;
    80005c0e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c12:	10000513          	li	a0,256
    80005c16:	00000097          	auipc	ra,0x0
    80005c1a:	ebc080e7          	jalr	-324(ra) # 80005ad2 <consputc>
    while(cons.e != cons.w &&
    80005c1e:	0a04a783          	lw	a5,160(s1)
    80005c22:	09c4a703          	lw	a4,156(s1)
    80005c26:	fcf71ce3          	bne	a4,a5,80005bfe <consoleintr+0xea>
    80005c2a:	b71d                	j	80005b50 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c2c:	00020717          	auipc	a4,0x20
    80005c30:	51470713          	addi	a4,a4,1300 # 80026140 <cons>
    80005c34:	0a072783          	lw	a5,160(a4)
    80005c38:	09c72703          	lw	a4,156(a4)
    80005c3c:	f0f70ae3          	beq	a4,a5,80005b50 <consoleintr+0x3c>
      cons.e--;
    80005c40:	37fd                	addiw	a5,a5,-1
    80005c42:	00020717          	auipc	a4,0x20
    80005c46:	58f72f23          	sw	a5,1438(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c4a:	10000513          	li	a0,256
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	e84080e7          	jalr	-380(ra) # 80005ad2 <consputc>
    80005c56:	bded                	j	80005b50 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c58:	ee048ce3          	beqz	s1,80005b50 <consoleintr+0x3c>
    80005c5c:	bf21                	j	80005b74 <consoleintr+0x60>
      consputc(c);
    80005c5e:	4529                	li	a0,10
    80005c60:	00000097          	auipc	ra,0x0
    80005c64:	e72080e7          	jalr	-398(ra) # 80005ad2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c68:	00020797          	auipc	a5,0x20
    80005c6c:	4d878793          	addi	a5,a5,1240 # 80026140 <cons>
    80005c70:	0a07a703          	lw	a4,160(a5)
    80005c74:	0017069b          	addiw	a3,a4,1
    80005c78:	0006861b          	sext.w	a2,a3
    80005c7c:	0ad7a023          	sw	a3,160(a5)
    80005c80:	07f77713          	andi	a4,a4,127
    80005c84:	97ba                	add	a5,a5,a4
    80005c86:	4729                	li	a4,10
    80005c88:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c8c:	00020797          	auipc	a5,0x20
    80005c90:	54c7a823          	sw	a2,1360(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c94:	00020517          	auipc	a0,0x20
    80005c98:	54450513          	addi	a0,a0,1348 # 800261d8 <cons+0x98>
    80005c9c:	ffffc097          	auipc	ra,0xffffc
    80005ca0:	b88080e7          	jalr	-1144(ra) # 80001824 <wakeup>
    80005ca4:	b575                	j	80005b50 <consoleintr+0x3c>

0000000080005ca6 <consoleinit>:

void
consoleinit(void)
{
    80005ca6:	1141                	addi	sp,sp,-16
    80005ca8:	e406                	sd	ra,8(sp)
    80005caa:	e022                	sd	s0,0(sp)
    80005cac:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cae:	00003597          	auipc	a1,0x3
    80005cb2:	a2a58593          	addi	a1,a1,-1494 # 800086d8 <etext+0x6d8>
    80005cb6:	00020517          	auipc	a0,0x20
    80005cba:	48a50513          	addi	a0,a0,1162 # 80026140 <cons>
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	582080e7          	jalr	1410(ra) # 80006240 <initlock>

  uartinit();
    80005cc6:	00000097          	auipc	ra,0x0
    80005cca:	32a080e7          	jalr	810(ra) # 80005ff0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cce:	00013797          	auipc	a5,0x13
    80005cd2:	5fa78793          	addi	a5,a5,1530 # 800192c8 <devsw>
    80005cd6:	00000717          	auipc	a4,0x0
    80005cda:	cea70713          	addi	a4,a4,-790 # 800059c0 <consoleread>
    80005cde:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ce0:	00000717          	auipc	a4,0x0
    80005ce4:	c7e70713          	addi	a4,a4,-898 # 8000595e <consolewrite>
    80005ce8:	ef98                	sd	a4,24(a5)
}
    80005cea:	60a2                	ld	ra,8(sp)
    80005cec:	6402                	ld	s0,0(sp)
    80005cee:	0141                	addi	sp,sp,16
    80005cf0:	8082                	ret

0000000080005cf2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cf2:	7179                	addi	sp,sp,-48
    80005cf4:	f406                	sd	ra,40(sp)
    80005cf6:	f022                	sd	s0,32(sp)
    80005cf8:	ec26                	sd	s1,24(sp)
    80005cfa:	e84a                	sd	s2,16(sp)
    80005cfc:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cfe:	c219                	beqz	a2,80005d04 <printint+0x12>
    80005d00:	08054663          	bltz	a0,80005d8c <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d04:	2501                	sext.w	a0,a0
    80005d06:	4881                	li	a7,0
    80005d08:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d0c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d0e:	2581                	sext.w	a1,a1
    80005d10:	00003617          	auipc	a2,0x3
    80005d14:	b7060613          	addi	a2,a2,-1168 # 80008880 <digits>
    80005d18:	883a                	mv	a6,a4
    80005d1a:	2705                	addiw	a4,a4,1
    80005d1c:	02b577bb          	remuw	a5,a0,a1
    80005d20:	1782                	slli	a5,a5,0x20
    80005d22:	9381                	srli	a5,a5,0x20
    80005d24:	97b2                	add	a5,a5,a2
    80005d26:	0007c783          	lbu	a5,0(a5)
    80005d2a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d2e:	0005079b          	sext.w	a5,a0
    80005d32:	02b5553b          	divuw	a0,a0,a1
    80005d36:	0685                	addi	a3,a3,1
    80005d38:	feb7f0e3          	bgeu	a5,a1,80005d18 <printint+0x26>

  if(sign)
    80005d3c:	00088b63          	beqz	a7,80005d52 <printint+0x60>
    buf[i++] = '-';
    80005d40:	fe040793          	addi	a5,s0,-32
    80005d44:	973e                	add	a4,a4,a5
    80005d46:	02d00793          	li	a5,45
    80005d4a:	fef70823          	sb	a5,-16(a4)
    80005d4e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d52:	02e05763          	blez	a4,80005d80 <printint+0x8e>
    80005d56:	fd040793          	addi	a5,s0,-48
    80005d5a:	00e784b3          	add	s1,a5,a4
    80005d5e:	fff78913          	addi	s2,a5,-1
    80005d62:	993a                	add	s2,s2,a4
    80005d64:	377d                	addiw	a4,a4,-1
    80005d66:	1702                	slli	a4,a4,0x20
    80005d68:	9301                	srli	a4,a4,0x20
    80005d6a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d6e:	fff4c503          	lbu	a0,-1(s1)
    80005d72:	00000097          	auipc	ra,0x0
    80005d76:	d60080e7          	jalr	-672(ra) # 80005ad2 <consputc>
  while(--i >= 0)
    80005d7a:	14fd                	addi	s1,s1,-1
    80005d7c:	ff2499e3          	bne	s1,s2,80005d6e <printint+0x7c>
}
    80005d80:	70a2                	ld	ra,40(sp)
    80005d82:	7402                	ld	s0,32(sp)
    80005d84:	64e2                	ld	s1,24(sp)
    80005d86:	6942                	ld	s2,16(sp)
    80005d88:	6145                	addi	sp,sp,48
    80005d8a:	8082                	ret
    x = -xx;
    80005d8c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d90:	4885                	li	a7,1
    x = -xx;
    80005d92:	bf9d                	j	80005d08 <printint+0x16>

0000000080005d94 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d94:	1101                	addi	sp,sp,-32
    80005d96:	ec06                	sd	ra,24(sp)
    80005d98:	e822                	sd	s0,16(sp)
    80005d9a:	e426                	sd	s1,8(sp)
    80005d9c:	1000                	addi	s0,sp,32
    80005d9e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005da0:	00020797          	auipc	a5,0x20
    80005da4:	4607a023          	sw	zero,1120(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005da8:	00003517          	auipc	a0,0x3
    80005dac:	93850513          	addi	a0,a0,-1736 # 800086e0 <etext+0x6e0>
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	02e080e7          	jalr	46(ra) # 80005dde <printf>
  printf(s);
    80005db8:	8526                	mv	a0,s1
    80005dba:	00000097          	auipc	ra,0x0
    80005dbe:	024080e7          	jalr	36(ra) # 80005dde <printf>
  printf("\n");
    80005dc2:	00002517          	auipc	a0,0x2
    80005dc6:	26650513          	addi	a0,a0,614 # 80008028 <etext+0x28>
    80005dca:	00000097          	auipc	ra,0x0
    80005dce:	014080e7          	jalr	20(ra) # 80005dde <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dd2:	4785                	li	a5,1
    80005dd4:	00003717          	auipc	a4,0x3
    80005dd8:	24f72423          	sw	a5,584(a4) # 8000901c <panicked>
  for(;;)
    80005ddc:	a001                	j	80005ddc <panic+0x48>

0000000080005dde <printf>:
{
    80005dde:	7131                	addi	sp,sp,-192
    80005de0:	fc86                	sd	ra,120(sp)
    80005de2:	f8a2                	sd	s0,112(sp)
    80005de4:	f4a6                	sd	s1,104(sp)
    80005de6:	f0ca                	sd	s2,96(sp)
    80005de8:	ecce                	sd	s3,88(sp)
    80005dea:	e8d2                	sd	s4,80(sp)
    80005dec:	e4d6                	sd	s5,72(sp)
    80005dee:	e0da                	sd	s6,64(sp)
    80005df0:	fc5e                	sd	s7,56(sp)
    80005df2:	f862                	sd	s8,48(sp)
    80005df4:	f466                	sd	s9,40(sp)
    80005df6:	f06a                	sd	s10,32(sp)
    80005df8:	ec6e                	sd	s11,24(sp)
    80005dfa:	0100                	addi	s0,sp,128
    80005dfc:	8a2a                	mv	s4,a0
    80005dfe:	e40c                	sd	a1,8(s0)
    80005e00:	e810                	sd	a2,16(s0)
    80005e02:	ec14                	sd	a3,24(s0)
    80005e04:	f018                	sd	a4,32(s0)
    80005e06:	f41c                	sd	a5,40(s0)
    80005e08:	03043823          	sd	a6,48(s0)
    80005e0c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e10:	00020d97          	auipc	s11,0x20
    80005e14:	3f0dad83          	lw	s11,1008(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e18:	020d9b63          	bnez	s11,80005e4e <printf+0x70>
  if (fmt == 0)
    80005e1c:	040a0263          	beqz	s4,80005e60 <printf+0x82>
  va_start(ap, fmt);
    80005e20:	00840793          	addi	a5,s0,8
    80005e24:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e28:	000a4503          	lbu	a0,0(s4)
    80005e2c:	14050f63          	beqz	a0,80005f8a <printf+0x1ac>
    80005e30:	4981                	li	s3,0
    if(c != '%'){
    80005e32:	02500a93          	li	s5,37
    switch(c){
    80005e36:	07000b93          	li	s7,112
  consputc('x');
    80005e3a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e3c:	00003b17          	auipc	s6,0x3
    80005e40:	a44b0b13          	addi	s6,s6,-1468 # 80008880 <digits>
    switch(c){
    80005e44:	07300c93          	li	s9,115
    80005e48:	06400c13          	li	s8,100
    80005e4c:	a82d                	j	80005e86 <printf+0xa8>
    acquire(&pr.lock);
    80005e4e:	00020517          	auipc	a0,0x20
    80005e52:	39a50513          	addi	a0,a0,922 # 800261e8 <pr>
    80005e56:	00000097          	auipc	ra,0x0
    80005e5a:	47a080e7          	jalr	1146(ra) # 800062d0 <acquire>
    80005e5e:	bf7d                	j	80005e1c <printf+0x3e>
    panic("null fmt");
    80005e60:	00003517          	auipc	a0,0x3
    80005e64:	89050513          	addi	a0,a0,-1904 # 800086f0 <etext+0x6f0>
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	f2c080e7          	jalr	-212(ra) # 80005d94 <panic>
      consputc(c);
    80005e70:	00000097          	auipc	ra,0x0
    80005e74:	c62080e7          	jalr	-926(ra) # 80005ad2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e78:	2985                	addiw	s3,s3,1
    80005e7a:	013a07b3          	add	a5,s4,s3
    80005e7e:	0007c503          	lbu	a0,0(a5)
    80005e82:	10050463          	beqz	a0,80005f8a <printf+0x1ac>
    if(c != '%'){
    80005e86:	ff5515e3          	bne	a0,s5,80005e70 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e8a:	2985                	addiw	s3,s3,1
    80005e8c:	013a07b3          	add	a5,s4,s3
    80005e90:	0007c783          	lbu	a5,0(a5)
    80005e94:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e98:	cbed                	beqz	a5,80005f8a <printf+0x1ac>
    switch(c){
    80005e9a:	05778a63          	beq	a5,s7,80005eee <printf+0x110>
    80005e9e:	02fbf663          	bgeu	s7,a5,80005eca <printf+0xec>
    80005ea2:	09978863          	beq	a5,s9,80005f32 <printf+0x154>
    80005ea6:	07800713          	li	a4,120
    80005eaa:	0ce79563          	bne	a5,a4,80005f74 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005eae:	f8843783          	ld	a5,-120(s0)
    80005eb2:	00878713          	addi	a4,a5,8
    80005eb6:	f8e43423          	sd	a4,-120(s0)
    80005eba:	4605                	li	a2,1
    80005ebc:	85ea                	mv	a1,s10
    80005ebe:	4388                	lw	a0,0(a5)
    80005ec0:	00000097          	auipc	ra,0x0
    80005ec4:	e32080e7          	jalr	-462(ra) # 80005cf2 <printint>
      break;
    80005ec8:	bf45                	j	80005e78 <printf+0x9a>
    switch(c){
    80005eca:	09578f63          	beq	a5,s5,80005f68 <printf+0x18a>
    80005ece:	0b879363          	bne	a5,s8,80005f74 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005ed2:	f8843783          	ld	a5,-120(s0)
    80005ed6:	00878713          	addi	a4,a5,8
    80005eda:	f8e43423          	sd	a4,-120(s0)
    80005ede:	4605                	li	a2,1
    80005ee0:	45a9                	li	a1,10
    80005ee2:	4388                	lw	a0,0(a5)
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	e0e080e7          	jalr	-498(ra) # 80005cf2 <printint>
      break;
    80005eec:	b771                	j	80005e78 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005eee:	f8843783          	ld	a5,-120(s0)
    80005ef2:	00878713          	addi	a4,a5,8
    80005ef6:	f8e43423          	sd	a4,-120(s0)
    80005efa:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005efe:	03000513          	li	a0,48
    80005f02:	00000097          	auipc	ra,0x0
    80005f06:	bd0080e7          	jalr	-1072(ra) # 80005ad2 <consputc>
  consputc('x');
    80005f0a:	07800513          	li	a0,120
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	bc4080e7          	jalr	-1084(ra) # 80005ad2 <consputc>
    80005f16:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f18:	03c95793          	srli	a5,s2,0x3c
    80005f1c:	97da                	add	a5,a5,s6
    80005f1e:	0007c503          	lbu	a0,0(a5)
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	bb0080e7          	jalr	-1104(ra) # 80005ad2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f2a:	0912                	slli	s2,s2,0x4
    80005f2c:	34fd                	addiw	s1,s1,-1
    80005f2e:	f4ed                	bnez	s1,80005f18 <printf+0x13a>
    80005f30:	b7a1                	j	80005e78 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f32:	f8843783          	ld	a5,-120(s0)
    80005f36:	00878713          	addi	a4,a5,8
    80005f3a:	f8e43423          	sd	a4,-120(s0)
    80005f3e:	6384                	ld	s1,0(a5)
    80005f40:	cc89                	beqz	s1,80005f5a <printf+0x17c>
      for(; *s; s++)
    80005f42:	0004c503          	lbu	a0,0(s1)
    80005f46:	d90d                	beqz	a0,80005e78 <printf+0x9a>
        consputc(*s);
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	b8a080e7          	jalr	-1142(ra) # 80005ad2 <consputc>
      for(; *s; s++)
    80005f50:	0485                	addi	s1,s1,1
    80005f52:	0004c503          	lbu	a0,0(s1)
    80005f56:	f96d                	bnez	a0,80005f48 <printf+0x16a>
    80005f58:	b705                	j	80005e78 <printf+0x9a>
        s = "(null)";
    80005f5a:	00002497          	auipc	s1,0x2
    80005f5e:	78e48493          	addi	s1,s1,1934 # 800086e8 <etext+0x6e8>
      for(; *s; s++)
    80005f62:	02800513          	li	a0,40
    80005f66:	b7cd                	j	80005f48 <printf+0x16a>
      consputc('%');
    80005f68:	8556                	mv	a0,s5
    80005f6a:	00000097          	auipc	ra,0x0
    80005f6e:	b68080e7          	jalr	-1176(ra) # 80005ad2 <consputc>
      break;
    80005f72:	b719                	j	80005e78 <printf+0x9a>
      consputc('%');
    80005f74:	8556                	mv	a0,s5
    80005f76:	00000097          	auipc	ra,0x0
    80005f7a:	b5c080e7          	jalr	-1188(ra) # 80005ad2 <consputc>
      consputc(c);
    80005f7e:	8526                	mv	a0,s1
    80005f80:	00000097          	auipc	ra,0x0
    80005f84:	b52080e7          	jalr	-1198(ra) # 80005ad2 <consputc>
      break;
    80005f88:	bdc5                	j	80005e78 <printf+0x9a>
  if(locking)
    80005f8a:	020d9163          	bnez	s11,80005fac <printf+0x1ce>
}
    80005f8e:	70e6                	ld	ra,120(sp)
    80005f90:	7446                	ld	s0,112(sp)
    80005f92:	74a6                	ld	s1,104(sp)
    80005f94:	7906                	ld	s2,96(sp)
    80005f96:	69e6                	ld	s3,88(sp)
    80005f98:	6a46                	ld	s4,80(sp)
    80005f9a:	6aa6                	ld	s5,72(sp)
    80005f9c:	6b06                	ld	s6,64(sp)
    80005f9e:	7be2                	ld	s7,56(sp)
    80005fa0:	7c42                	ld	s8,48(sp)
    80005fa2:	7ca2                	ld	s9,40(sp)
    80005fa4:	7d02                	ld	s10,32(sp)
    80005fa6:	6de2                	ld	s11,24(sp)
    80005fa8:	6129                	addi	sp,sp,192
    80005faa:	8082                	ret
    release(&pr.lock);
    80005fac:	00020517          	auipc	a0,0x20
    80005fb0:	23c50513          	addi	a0,a0,572 # 800261e8 <pr>
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	3d0080e7          	jalr	976(ra) # 80006384 <release>
}
    80005fbc:	bfc9                	j	80005f8e <printf+0x1b0>

0000000080005fbe <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fbe:	1101                	addi	sp,sp,-32
    80005fc0:	ec06                	sd	ra,24(sp)
    80005fc2:	e822                	sd	s0,16(sp)
    80005fc4:	e426                	sd	s1,8(sp)
    80005fc6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fc8:	00020497          	auipc	s1,0x20
    80005fcc:	22048493          	addi	s1,s1,544 # 800261e8 <pr>
    80005fd0:	00002597          	auipc	a1,0x2
    80005fd4:	73058593          	addi	a1,a1,1840 # 80008700 <etext+0x700>
    80005fd8:	8526                	mv	a0,s1
    80005fda:	00000097          	auipc	ra,0x0
    80005fde:	266080e7          	jalr	614(ra) # 80006240 <initlock>
  pr.locking = 1;
    80005fe2:	4785                	li	a5,1
    80005fe4:	cc9c                	sw	a5,24(s1)
}
    80005fe6:	60e2                	ld	ra,24(sp)
    80005fe8:	6442                	ld	s0,16(sp)
    80005fea:	64a2                	ld	s1,8(sp)
    80005fec:	6105                	addi	sp,sp,32
    80005fee:	8082                	ret

0000000080005ff0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ff0:	1141                	addi	sp,sp,-16
    80005ff2:	e406                	sd	ra,8(sp)
    80005ff4:	e022                	sd	s0,0(sp)
    80005ff6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ff8:	100007b7          	lui	a5,0x10000
    80005ffc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006000:	f8000713          	li	a4,-128
    80006004:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006008:	470d                	li	a4,3
    8000600a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000600e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006012:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006016:	469d                	li	a3,7
    80006018:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000601c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006020:	00002597          	auipc	a1,0x2
    80006024:	6e858593          	addi	a1,a1,1768 # 80008708 <etext+0x708>
    80006028:	00020517          	auipc	a0,0x20
    8000602c:	1e050513          	addi	a0,a0,480 # 80026208 <uart_tx_lock>
    80006030:	00000097          	auipc	ra,0x0
    80006034:	210080e7          	jalr	528(ra) # 80006240 <initlock>
}
    80006038:	60a2                	ld	ra,8(sp)
    8000603a:	6402                	ld	s0,0(sp)
    8000603c:	0141                	addi	sp,sp,16
    8000603e:	8082                	ret

0000000080006040 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006040:	1101                	addi	sp,sp,-32
    80006042:	ec06                	sd	ra,24(sp)
    80006044:	e822                	sd	s0,16(sp)
    80006046:	e426                	sd	s1,8(sp)
    80006048:	1000                	addi	s0,sp,32
    8000604a:	84aa                	mv	s1,a0
  push_off();
    8000604c:	00000097          	auipc	ra,0x0
    80006050:	238080e7          	jalr	568(ra) # 80006284 <push_off>

  if(panicked){
    80006054:	00003797          	auipc	a5,0x3
    80006058:	fc87a783          	lw	a5,-56(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000605c:	10000737          	lui	a4,0x10000
  if(panicked){
    80006060:	c391                	beqz	a5,80006064 <uartputc_sync+0x24>
    for(;;)
    80006062:	a001                	j	80006062 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006064:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006068:	0207f793          	andi	a5,a5,32
    8000606c:	dfe5                	beqz	a5,80006064 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000606e:	0ff4f513          	zext.b	a0,s1
    80006072:	100007b7          	lui	a5,0x10000
    80006076:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	2aa080e7          	jalr	682(ra) # 80006324 <pop_off>
}
    80006082:	60e2                	ld	ra,24(sp)
    80006084:	6442                	ld	s0,16(sp)
    80006086:	64a2                	ld	s1,8(sp)
    80006088:	6105                	addi	sp,sp,32
    8000608a:	8082                	ret

000000008000608c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000608c:	00003797          	auipc	a5,0x3
    80006090:	f947b783          	ld	a5,-108(a5) # 80009020 <uart_tx_r>
    80006094:	00003717          	auipc	a4,0x3
    80006098:	f9473703          	ld	a4,-108(a4) # 80009028 <uart_tx_w>
    8000609c:	06f70a63          	beq	a4,a5,80006110 <uartstart+0x84>
{
    800060a0:	7139                	addi	sp,sp,-64
    800060a2:	fc06                	sd	ra,56(sp)
    800060a4:	f822                	sd	s0,48(sp)
    800060a6:	f426                	sd	s1,40(sp)
    800060a8:	f04a                	sd	s2,32(sp)
    800060aa:	ec4e                	sd	s3,24(sp)
    800060ac:	e852                	sd	s4,16(sp)
    800060ae:	e456                	sd	s5,8(sp)
    800060b0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060b2:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060b6:	00020a17          	auipc	s4,0x20
    800060ba:	152a0a13          	addi	s4,s4,338 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060be:	00003497          	auipc	s1,0x3
    800060c2:	f6248493          	addi	s1,s1,-158 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060c6:	00003997          	auipc	s3,0x3
    800060ca:	f6298993          	addi	s3,s3,-158 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060ce:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060d2:	02077713          	andi	a4,a4,32
    800060d6:	c705                	beqz	a4,800060fe <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060d8:	01f7f713          	andi	a4,a5,31
    800060dc:	9752                	add	a4,a4,s4
    800060de:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800060e2:	0785                	addi	a5,a5,1
    800060e4:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060e6:	8526                	mv	a0,s1
    800060e8:	ffffb097          	auipc	ra,0xffffb
    800060ec:	73c080e7          	jalr	1852(ra) # 80001824 <wakeup>
    
    WriteReg(THR, c);
    800060f0:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060f4:	609c                	ld	a5,0(s1)
    800060f6:	0009b703          	ld	a4,0(s3)
    800060fa:	fcf71ae3          	bne	a4,a5,800060ce <uartstart+0x42>
  }
}
    800060fe:	70e2                	ld	ra,56(sp)
    80006100:	7442                	ld	s0,48(sp)
    80006102:	74a2                	ld	s1,40(sp)
    80006104:	7902                	ld	s2,32(sp)
    80006106:	69e2                	ld	s3,24(sp)
    80006108:	6a42                	ld	s4,16(sp)
    8000610a:	6aa2                	ld	s5,8(sp)
    8000610c:	6121                	addi	sp,sp,64
    8000610e:	8082                	ret
    80006110:	8082                	ret

0000000080006112 <uartputc>:
{
    80006112:	7179                	addi	sp,sp,-48
    80006114:	f406                	sd	ra,40(sp)
    80006116:	f022                	sd	s0,32(sp)
    80006118:	ec26                	sd	s1,24(sp)
    8000611a:	e84a                	sd	s2,16(sp)
    8000611c:	e44e                	sd	s3,8(sp)
    8000611e:	e052                	sd	s4,0(sp)
    80006120:	1800                	addi	s0,sp,48
    80006122:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006124:	00020517          	auipc	a0,0x20
    80006128:	0e450513          	addi	a0,a0,228 # 80026208 <uart_tx_lock>
    8000612c:	00000097          	auipc	ra,0x0
    80006130:	1a4080e7          	jalr	420(ra) # 800062d0 <acquire>
  if(panicked){
    80006134:	00003797          	auipc	a5,0x3
    80006138:	ee87a783          	lw	a5,-280(a5) # 8000901c <panicked>
    8000613c:	c391                	beqz	a5,80006140 <uartputc+0x2e>
    for(;;)
    8000613e:	a001                	j	8000613e <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006140:	00003717          	auipc	a4,0x3
    80006144:	ee873703          	ld	a4,-280(a4) # 80009028 <uart_tx_w>
    80006148:	00003797          	auipc	a5,0x3
    8000614c:	ed87b783          	ld	a5,-296(a5) # 80009020 <uart_tx_r>
    80006150:	02078793          	addi	a5,a5,32
    80006154:	02e79b63          	bne	a5,a4,8000618a <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006158:	00020997          	auipc	s3,0x20
    8000615c:	0b098993          	addi	s3,s3,176 # 80026208 <uart_tx_lock>
    80006160:	00003497          	auipc	s1,0x3
    80006164:	ec048493          	addi	s1,s1,-320 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006168:	00003917          	auipc	s2,0x3
    8000616c:	ec090913          	addi	s2,s2,-320 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006170:	85ce                	mv	a1,s3
    80006172:	8526                	mv	a0,s1
    80006174:	ffffb097          	auipc	ra,0xffffb
    80006178:	524080e7          	jalr	1316(ra) # 80001698 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000617c:	00093703          	ld	a4,0(s2)
    80006180:	609c                	ld	a5,0(s1)
    80006182:	02078793          	addi	a5,a5,32
    80006186:	fee785e3          	beq	a5,a4,80006170 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000618a:	00020497          	auipc	s1,0x20
    8000618e:	07e48493          	addi	s1,s1,126 # 80026208 <uart_tx_lock>
    80006192:	01f77793          	andi	a5,a4,31
    80006196:	97a6                	add	a5,a5,s1
    80006198:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000619c:	0705                	addi	a4,a4,1
    8000619e:	00003797          	auipc	a5,0x3
    800061a2:	e8e7b523          	sd	a4,-374(a5) # 80009028 <uart_tx_w>
      uartstart();
    800061a6:	00000097          	auipc	ra,0x0
    800061aa:	ee6080e7          	jalr	-282(ra) # 8000608c <uartstart>
      release(&uart_tx_lock);
    800061ae:	8526                	mv	a0,s1
    800061b0:	00000097          	auipc	ra,0x0
    800061b4:	1d4080e7          	jalr	468(ra) # 80006384 <release>
}
    800061b8:	70a2                	ld	ra,40(sp)
    800061ba:	7402                	ld	s0,32(sp)
    800061bc:	64e2                	ld	s1,24(sp)
    800061be:	6942                	ld	s2,16(sp)
    800061c0:	69a2                	ld	s3,8(sp)
    800061c2:	6a02                	ld	s4,0(sp)
    800061c4:	6145                	addi	sp,sp,48
    800061c6:	8082                	ret

00000000800061c8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061c8:	1141                	addi	sp,sp,-16
    800061ca:	e422                	sd	s0,8(sp)
    800061cc:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061ce:	100007b7          	lui	a5,0x10000
    800061d2:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061d6:	8b85                	andi	a5,a5,1
    800061d8:	cb91                	beqz	a5,800061ec <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061da:	100007b7          	lui	a5,0x10000
    800061de:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061e2:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
    800061e6:	6422                	ld	s0,8(sp)
    800061e8:	0141                	addi	sp,sp,16
    800061ea:	8082                	ret
    return -1;
    800061ec:	557d                	li	a0,-1
    800061ee:	bfe5                	j	800061e6 <uartgetc+0x1e>

00000000800061f0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061f0:	1101                	addi	sp,sp,-32
    800061f2:	ec06                	sd	ra,24(sp)
    800061f4:	e822                	sd	s0,16(sp)
    800061f6:	e426                	sd	s1,8(sp)
    800061f8:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061fa:	54fd                	li	s1,-1
    800061fc:	a029                	j	80006206 <uartintr+0x16>
      break;
    consoleintr(c);
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	916080e7          	jalr	-1770(ra) # 80005b14 <consoleintr>
    int c = uartgetc();
    80006206:	00000097          	auipc	ra,0x0
    8000620a:	fc2080e7          	jalr	-62(ra) # 800061c8 <uartgetc>
    if(c == -1)
    8000620e:	fe9518e3          	bne	a0,s1,800061fe <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006212:	00020497          	auipc	s1,0x20
    80006216:	ff648493          	addi	s1,s1,-10 # 80026208 <uart_tx_lock>
    8000621a:	8526                	mv	a0,s1
    8000621c:	00000097          	auipc	ra,0x0
    80006220:	0b4080e7          	jalr	180(ra) # 800062d0 <acquire>
  uartstart();
    80006224:	00000097          	auipc	ra,0x0
    80006228:	e68080e7          	jalr	-408(ra) # 8000608c <uartstart>
  release(&uart_tx_lock);
    8000622c:	8526                	mv	a0,s1
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	156080e7          	jalr	342(ra) # 80006384 <release>
}
    80006236:	60e2                	ld	ra,24(sp)
    80006238:	6442                	ld	s0,16(sp)
    8000623a:	64a2                	ld	s1,8(sp)
    8000623c:	6105                	addi	sp,sp,32
    8000623e:	8082                	ret

0000000080006240 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006240:	1141                	addi	sp,sp,-16
    80006242:	e422                	sd	s0,8(sp)
    80006244:	0800                	addi	s0,sp,16
  lk->name = name;
    80006246:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006248:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000624c:	00053823          	sd	zero,16(a0)
}
    80006250:	6422                	ld	s0,8(sp)
    80006252:	0141                	addi	sp,sp,16
    80006254:	8082                	ret

0000000080006256 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006256:	411c                	lw	a5,0(a0)
    80006258:	e399                	bnez	a5,8000625e <holding+0x8>
    8000625a:	4501                	li	a0,0
  return r;
}
    8000625c:	8082                	ret
{
    8000625e:	1101                	addi	sp,sp,-32
    80006260:	ec06                	sd	ra,24(sp)
    80006262:	e822                	sd	s0,16(sp)
    80006264:	e426                	sd	s1,8(sp)
    80006266:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006268:	6904                	ld	s1,16(a0)
    8000626a:	ffffb097          	auipc	ra,0xffffb
    8000626e:	ccc080e7          	jalr	-820(ra) # 80000f36 <mycpu>
    80006272:	40a48533          	sub	a0,s1,a0
    80006276:	00153513          	seqz	a0,a0
}
    8000627a:	60e2                	ld	ra,24(sp)
    8000627c:	6442                	ld	s0,16(sp)
    8000627e:	64a2                	ld	s1,8(sp)
    80006280:	6105                	addi	sp,sp,32
    80006282:	8082                	ret

0000000080006284 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006284:	1101                	addi	sp,sp,-32
    80006286:	ec06                	sd	ra,24(sp)
    80006288:	e822                	sd	s0,16(sp)
    8000628a:	e426                	sd	s1,8(sp)
    8000628c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000628e:	100024f3          	csrr	s1,sstatus
    80006292:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006296:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006298:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000629c:	ffffb097          	auipc	ra,0xffffb
    800062a0:	c9a080e7          	jalr	-870(ra) # 80000f36 <mycpu>
    800062a4:	5d3c                	lw	a5,120(a0)
    800062a6:	cf89                	beqz	a5,800062c0 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062a8:	ffffb097          	auipc	ra,0xffffb
    800062ac:	c8e080e7          	jalr	-882(ra) # 80000f36 <mycpu>
    800062b0:	5d3c                	lw	a5,120(a0)
    800062b2:	2785                	addiw	a5,a5,1
    800062b4:	dd3c                	sw	a5,120(a0)
}
    800062b6:	60e2                	ld	ra,24(sp)
    800062b8:	6442                	ld	s0,16(sp)
    800062ba:	64a2                	ld	s1,8(sp)
    800062bc:	6105                	addi	sp,sp,32
    800062be:	8082                	ret
    mycpu()->intena = old;
    800062c0:	ffffb097          	auipc	ra,0xffffb
    800062c4:	c76080e7          	jalr	-906(ra) # 80000f36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062c8:	8085                	srli	s1,s1,0x1
    800062ca:	8885                	andi	s1,s1,1
    800062cc:	dd64                	sw	s1,124(a0)
    800062ce:	bfe9                	j	800062a8 <push_off+0x24>

00000000800062d0 <acquire>:
{
    800062d0:	1101                	addi	sp,sp,-32
    800062d2:	ec06                	sd	ra,24(sp)
    800062d4:	e822                	sd	s0,16(sp)
    800062d6:	e426                	sd	s1,8(sp)
    800062d8:	1000                	addi	s0,sp,32
    800062da:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062dc:	00000097          	auipc	ra,0x0
    800062e0:	fa8080e7          	jalr	-88(ra) # 80006284 <push_off>
  if(holding(lk))
    800062e4:	8526                	mv	a0,s1
    800062e6:	00000097          	auipc	ra,0x0
    800062ea:	f70080e7          	jalr	-144(ra) # 80006256 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062ee:	4705                	li	a4,1
  if(holding(lk))
    800062f0:	e115                	bnez	a0,80006314 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062f2:	87ba                	mv	a5,a4
    800062f4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062f8:	2781                	sext.w	a5,a5
    800062fa:	ffe5                	bnez	a5,800062f2 <acquire+0x22>
  __sync_synchronize();
    800062fc:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006300:	ffffb097          	auipc	ra,0xffffb
    80006304:	c36080e7          	jalr	-970(ra) # 80000f36 <mycpu>
    80006308:	e888                	sd	a0,16(s1)
}
    8000630a:	60e2                	ld	ra,24(sp)
    8000630c:	6442                	ld	s0,16(sp)
    8000630e:	64a2                	ld	s1,8(sp)
    80006310:	6105                	addi	sp,sp,32
    80006312:	8082                	ret
    panic("acquire");
    80006314:	00002517          	auipc	a0,0x2
    80006318:	3fc50513          	addi	a0,a0,1020 # 80008710 <etext+0x710>
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	a78080e7          	jalr	-1416(ra) # 80005d94 <panic>

0000000080006324 <pop_off>:

void
pop_off(void)
{
    80006324:	1141                	addi	sp,sp,-16
    80006326:	e406                	sd	ra,8(sp)
    80006328:	e022                	sd	s0,0(sp)
    8000632a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000632c:	ffffb097          	auipc	ra,0xffffb
    80006330:	c0a080e7          	jalr	-1014(ra) # 80000f36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006334:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006338:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000633a:	e78d                	bnez	a5,80006364 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000633c:	5d3c                	lw	a5,120(a0)
    8000633e:	02f05b63          	blez	a5,80006374 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006342:	37fd                	addiw	a5,a5,-1
    80006344:	0007871b          	sext.w	a4,a5
    80006348:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000634a:	eb09                	bnez	a4,8000635c <pop_off+0x38>
    8000634c:	5d7c                	lw	a5,124(a0)
    8000634e:	c799                	beqz	a5,8000635c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006350:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006354:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006358:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000635c:	60a2                	ld	ra,8(sp)
    8000635e:	6402                	ld	s0,0(sp)
    80006360:	0141                	addi	sp,sp,16
    80006362:	8082                	ret
    panic("pop_off - interruptible");
    80006364:	00002517          	auipc	a0,0x2
    80006368:	3b450513          	addi	a0,a0,948 # 80008718 <etext+0x718>
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	a28080e7          	jalr	-1496(ra) # 80005d94 <panic>
    panic("pop_off");
    80006374:	00002517          	auipc	a0,0x2
    80006378:	3bc50513          	addi	a0,a0,956 # 80008730 <etext+0x730>
    8000637c:	00000097          	auipc	ra,0x0
    80006380:	a18080e7          	jalr	-1512(ra) # 80005d94 <panic>

0000000080006384 <release>:
{
    80006384:	1101                	addi	sp,sp,-32
    80006386:	ec06                	sd	ra,24(sp)
    80006388:	e822                	sd	s0,16(sp)
    8000638a:	e426                	sd	s1,8(sp)
    8000638c:	1000                	addi	s0,sp,32
    8000638e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006390:	00000097          	auipc	ra,0x0
    80006394:	ec6080e7          	jalr	-314(ra) # 80006256 <holding>
    80006398:	c115                	beqz	a0,800063bc <release+0x38>
  lk->cpu = 0;
    8000639a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000639e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063a2:	0f50000f          	fence	iorw,ow
    800063a6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063aa:	00000097          	auipc	ra,0x0
    800063ae:	f7a080e7          	jalr	-134(ra) # 80006324 <pop_off>
}
    800063b2:	60e2                	ld	ra,24(sp)
    800063b4:	6442                	ld	s0,16(sp)
    800063b6:	64a2                	ld	s1,8(sp)
    800063b8:	6105                	addi	sp,sp,32
    800063ba:	8082                	ret
    panic("release");
    800063bc:	00002517          	auipc	a0,0x2
    800063c0:	37c50513          	addi	a0,a0,892 # 80008738 <etext+0x738>
    800063c4:	00000097          	auipc	ra,0x0
    800063c8:	9d0080e7          	jalr	-1584(ra) # 80005d94 <panic>
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
