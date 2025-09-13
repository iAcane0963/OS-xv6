
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
    80000016:	784050ef          	jal	8000579a <start>

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
    8000005e:	126080e7          	jalr	294(ra) # 80006180 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1c6080e7          	jalr	454(ra) # 80006234 <release>
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
    8000008e:	bba080e7          	jalr	-1094(ra) # 80005c44 <panic>

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
    800000f8:	ffc080e7          	jalr	-4(ra) # 800060f0 <initlock>
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
    80000130:	054080e7          	jalr	84(ra) # 80006180 <acquire>
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
    80000148:	0f0080e7          	jalr	240(ra) # 80006234 <release>

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
    80000172:	0c6080e7          	jalr	198(ra) # 80006234 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <getfreemem>:

// Return the amount of free memory.
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
    80000190:	ff4080e7          	jalr	-12(ra) # 80006180 <acquire>
  r = kmem.freelist;
    80000194:	6c9c                	ld	a5,24(s1)
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
    800001ac:	08c080e7          	jalr	140(ra) # 80006234 <release>
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
    800003a2:	8f0080e7          	jalr	-1808(ra) # 80005c8e <printf>
    kvminithart();    // turn on paging
    800003a6:	00000097          	auipc	ra,0x0
    800003aa:	0d8080e7          	jalr	216(ra) # 8000047e <kvminithart>
    trapinithart();   // install kernel trap vector
    800003ae:	00001097          	auipc	ra,0x1
    800003b2:	796080e7          	jalr	1942(ra) # 80001b44 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b6:	00005097          	auipc	ra,0x5
    800003ba:	dba080e7          	jalr	-582(ra) # 80005170 <plicinithart>
  }

  scheduler();        
    800003be:	00001097          	auipc	ra,0x1
    800003c2:	fe4080e7          	jalr	-28(ra) # 800013a2 <scheduler>
    consoleinit();
    800003c6:	00005097          	auipc	ra,0x5
    800003ca:	790080e7          	jalr	1936(ra) # 80005b56 <consoleinit>
    printfinit();
    800003ce:	00006097          	auipc	ra,0x6
    800003d2:	aa0080e7          	jalr	-1376(ra) # 80005e6e <printfinit>
    printf("\n");
    800003d6:	00008517          	auipc	a0,0x8
    800003da:	c7250513          	addi	a0,a0,-910 # 80008048 <etext+0x48>
    800003de:	00006097          	auipc	ra,0x6
    800003e2:	8b0080e7          	jalr	-1872(ra) # 80005c8e <printf>
    printf("xv6 kernel is booting\n");
    800003e6:	00008517          	auipc	a0,0x8
    800003ea:	c3a50513          	addi	a0,a0,-966 # 80008020 <etext+0x20>
    800003ee:	00006097          	auipc	ra,0x6
    800003f2:	8a0080e7          	jalr	-1888(ra) # 80005c8e <printf>
    printf("\n");
    800003f6:	00008517          	auipc	a0,0x8
    800003fa:	c5250513          	addi	a0,a0,-942 # 80008048 <etext+0x48>
    800003fe:	00006097          	auipc	ra,0x6
    80000402:	890080e7          	jalr	-1904(ra) # 80005c8e <printf>
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
    8000042a:	6f6080e7          	jalr	1782(ra) # 80001b1c <trapinit>
    trapinithart();  // install kernel trap vector
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	716080e7          	jalr	1814(ra) # 80001b44 <trapinithart>
    plicinit();      // set up interrupt controller
    80000436:	00005097          	auipc	ra,0x5
    8000043a:	d24080e7          	jalr	-732(ra) # 8000515a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	d32080e7          	jalr	-718(ra) # 80005170 <plicinithart>
    binit();         // buffer cache
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	f0a080e7          	jalr	-246(ra) # 80002350 <binit>
    iinit();         // inode table
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	59a080e7          	jalr	1434(ra) # 800029e8 <iinit>
    fileinit();      // file table
    80000456:	00003097          	auipc	ra,0x3
    8000045a:	544080e7          	jalr	1348(ra) # 8000399a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000045e:	00005097          	auipc	ra,0x5
    80000462:	e34080e7          	jalr	-460(ra) # 80005292 <virtio_disk_init>
    userinit();      // first user process
    80000466:	00001097          	auipc	ra,0x1
    8000046a:	cfe080e7          	jalr	-770(ra) # 80001164 <userinit>
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
    800004d4:	774080e7          	jalr	1908(ra) # 80005c44 <panic>
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
    800005fa:	64e080e7          	jalr	1614(ra) # 80005c44 <panic>
      panic("mappages: remap");
    800005fe:	00008517          	auipc	a0,0x8
    80000602:	a6a50513          	addi	a0,a0,-1430 # 80008068 <etext+0x68>
    80000606:	00005097          	auipc	ra,0x5
    8000060a:	63e080e7          	jalr	1598(ra) # 80005c44 <panic>
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
    80000656:	5f2080e7          	jalr	1522(ra) # 80005c44 <panic>

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
    800007a2:	4a6080e7          	jalr	1190(ra) # 80005c44 <panic>
      panic("uvmunmap: walk");
    800007a6:	00008517          	auipc	a0,0x8
    800007aa:	8f250513          	addi	a0,a0,-1806 # 80008098 <etext+0x98>
    800007ae:	00005097          	auipc	ra,0x5
    800007b2:	496080e7          	jalr	1174(ra) # 80005c44 <panic>
      panic("uvmunmap: not mapped");
    800007b6:	00008517          	auipc	a0,0x8
    800007ba:	8f250513          	addi	a0,a0,-1806 # 800080a8 <etext+0xa8>
    800007be:	00005097          	auipc	ra,0x5
    800007c2:	486080e7          	jalr	1158(ra) # 80005c44 <panic>
      panic("uvmunmap: not a leaf");
    800007c6:	00008517          	auipc	a0,0x8
    800007ca:	8fa50513          	addi	a0,a0,-1798 # 800080c0 <etext+0xc0>
    800007ce:	00005097          	auipc	ra,0x5
    800007d2:	476080e7          	jalr	1142(ra) # 80005c44 <panic>
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
    800008b0:	398080e7          	jalr	920(ra) # 80005c44 <panic>

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
    800009f2:	256080e7          	jalr	598(ra) # 80005c44 <panic>
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
    80000ace:	17a080e7          	jalr	378(ra) # 80005c44 <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	65650513          	addi	a0,a0,1622 # 80008128 <etext+0x128>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	16a080e7          	jalr	362(ra) # 80005c44 <panic>
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
    80000b48:	100080e7          	jalr	256(ra) # 80005c44 <panic>

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
    80000dac:	e9c080e7          	jalr	-356(ra) # 80005c44 <panic>

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
    80000dd8:	31c080e7          	jalr	796(ra) # 800060f0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ddc:	00007597          	auipc	a1,0x7
    80000de0:	38c58593          	addi	a1,a1,908 # 80008168 <etext+0x168>
    80000de4:	00008517          	auipc	a0,0x8
    80000de8:	28450513          	addi	a0,a0,644 # 80009068 <wait_lock>
    80000dec:	00005097          	auipc	ra,0x5
    80000df0:	304080e7          	jalr	772(ra) # 800060f0 <initlock>
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
    80000e26:	2ce080e7          	jalr	718(ra) # 800060f0 <initlock>
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
    80000e9a:	29e080e7          	jalr	670(ra) # 80006134 <push_off>
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
    80000eb4:	324080e7          	jalr	804(ra) # 800061d4 <pop_off>
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
    80000ed8:	360080e7          	jalr	864(ra) # 80006234 <release>

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
    80000eea:	c76080e7          	jalr	-906(ra) # 80001b5c <usertrapret>
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
    80000f04:	a68080e7          	jalr	-1432(ra) # 80002968 <fsinit>
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
    80000f24:	260080e7          	jalr	608(ra) # 80006180 <acquire>
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
    80000f3e:	2fa080e7          	jalr	762(ra) # 80006234 <release>
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
    800010b8:	0cc080e7          	jalr	204(ra) # 80006180 <acquire>
    if(p->state == UNUSED) {
    800010bc:	4c9c                	lw	a5,24(s1)
    800010be:	cf81                	beqz	a5,800010d6 <allocproc+0x40>
      release(&p->lock);
    800010c0:	8526                	mv	a0,s1
    800010c2:	00005097          	auipc	ra,0x5
    800010c6:	172080e7          	jalr	370(ra) # 80006234 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ca:	17048493          	addi	s1,s1,368
    800010ce:	ff2492e3          	bne	s1,s2,800010b2 <allocproc+0x1c>
  return 0;
    800010d2:	4481                	li	s1,0
    800010d4:	a889                	j	80001126 <allocproc+0x90>
  p->pid = allocpid();
    800010d6:	00000097          	auipc	ra,0x0
    800010da:	e34080e7          	jalr	-460(ra) # 80000f0a <allocpid>
    800010de:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e0:	4785                	li	a5,1
    800010e2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	034080e7          	jalr	52(ra) # 80000118 <kalloc>
    800010ec:	892a                	mv	s2,a0
    800010ee:	eca8                	sd	a0,88(s1)
    800010f0:	c131                	beqz	a0,80001134 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010f2:	8526                	mv	a0,s1
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	e5c080e7          	jalr	-420(ra) # 80000f50 <proc_pagetable>
    800010fc:	892a                	mv	s2,a0
    800010fe:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001100:	c531                	beqz	a0,8000114c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001102:	07000613          	li	a2,112
    80001106:	4581                	li	a1,0
    80001108:	06048513          	addi	a0,s1,96
    8000110c:	fffff097          	auipc	ra,0xfffff
    80001110:	0b6080e7          	jalr	182(ra) # 800001c2 <memset>
  p->context.ra = (uint64)forkret;
    80001114:	00000797          	auipc	a5,0x0
    80001118:	db078793          	addi	a5,a5,-592 # 80000ec4 <forkret>
    8000111c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000111e:	60bc                	ld	a5,64(s1)
    80001120:	6705                	lui	a4,0x1
    80001122:	97ba                	add	a5,a5,a4
    80001124:	f4bc                	sd	a5,104(s1)
}
    80001126:	8526                	mv	a0,s1
    80001128:	60e2                	ld	ra,24(sp)
    8000112a:	6442                	ld	s0,16(sp)
    8000112c:	64a2                	ld	s1,8(sp)
    8000112e:	6902                	ld	s2,0(sp)
    80001130:	6105                	addi	sp,sp,32
    80001132:	8082                	ret
    freeproc(p);
    80001134:	8526                	mv	a0,s1
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	f08080e7          	jalr	-248(ra) # 8000103e <freeproc>
    release(&p->lock);
    8000113e:	8526                	mv	a0,s1
    80001140:	00005097          	auipc	ra,0x5
    80001144:	0f4080e7          	jalr	244(ra) # 80006234 <release>
    return 0;
    80001148:	84ca                	mv	s1,s2
    8000114a:	bff1                	j	80001126 <allocproc+0x90>
    freeproc(p);
    8000114c:	8526                	mv	a0,s1
    8000114e:	00000097          	auipc	ra,0x0
    80001152:	ef0080e7          	jalr	-272(ra) # 8000103e <freeproc>
    release(&p->lock);
    80001156:	8526                	mv	a0,s1
    80001158:	00005097          	auipc	ra,0x5
    8000115c:	0dc080e7          	jalr	220(ra) # 80006234 <release>
    return 0;
    80001160:	84ca                	mv	s1,s2
    80001162:	b7d1                	j	80001126 <allocproc+0x90>

0000000080001164 <userinit>:
{
    80001164:	1101                	addi	sp,sp,-32
    80001166:	ec06                	sd	ra,24(sp)
    80001168:	e822                	sd	s0,16(sp)
    8000116a:	e426                	sd	s1,8(sp)
    8000116c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	f28080e7          	jalr	-216(ra) # 80001096 <allocproc>
    80001176:	84aa                	mv	s1,a0
  initproc = p;
    80001178:	00008797          	auipc	a5,0x8
    8000117c:	e8a7bc23          	sd	a0,-360(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001180:	03400613          	li	a2,52
    80001184:	00007597          	auipc	a1,0x7
    80001188:	76c58593          	addi	a1,a1,1900 # 800088f0 <initcode>
    8000118c:	6928                	ld	a0,80(a0)
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	6b4080e7          	jalr	1716(ra) # 80000842 <uvminit>
  p->sz = PGSIZE;
    80001196:	6785                	lui	a5,0x1
    80001198:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000119a:	6cb8                	ld	a4,88(s1)
    8000119c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a0:	6cb8                	ld	a4,88(s1)
    800011a2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011a4:	4641                	li	a2,16
    800011a6:	00007597          	auipc	a1,0x7
    800011aa:	fda58593          	addi	a1,a1,-38 # 80008180 <etext+0x180>
    800011ae:	15848513          	addi	a0,s1,344
    800011b2:	fffff097          	auipc	ra,0xfffff
    800011b6:	15a080e7          	jalr	346(ra) # 8000030c <safestrcpy>
  p->cwd = namei("/");
    800011ba:	00007517          	auipc	a0,0x7
    800011be:	fd650513          	addi	a0,a0,-42 # 80008190 <etext+0x190>
    800011c2:	00002097          	auipc	ra,0x2
    800011c6:	1d4080e7          	jalr	468(ra) # 80003396 <namei>
    800011ca:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011ce:	478d                	li	a5,3
    800011d0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d2:	8526                	mv	a0,s1
    800011d4:	00005097          	auipc	ra,0x5
    800011d8:	060080e7          	jalr	96(ra) # 80006234 <release>
}
    800011dc:	60e2                	ld	ra,24(sp)
    800011de:	6442                	ld	s0,16(sp)
    800011e0:	64a2                	ld	s1,8(sp)
    800011e2:	6105                	addi	sp,sp,32
    800011e4:	8082                	ret

00000000800011e6 <growproc>:
{
    800011e6:	1101                	addi	sp,sp,-32
    800011e8:	ec06                	sd	ra,24(sp)
    800011ea:	e822                	sd	s0,16(sp)
    800011ec:	e426                	sd	s1,8(sp)
    800011ee:	e04a                	sd	s2,0(sp)
    800011f0:	1000                	addi	s0,sp,32
    800011f2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011f4:	00000097          	auipc	ra,0x0
    800011f8:	c98080e7          	jalr	-872(ra) # 80000e8c <myproc>
    800011fc:	892a                	mv	s2,a0
  sz = p->sz;
    800011fe:	652c                	ld	a1,72(a0)
    80001200:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001204:	00904f63          	bgtz	s1,80001222 <growproc+0x3c>
  } else if(n < 0){
    80001208:	0204cc63          	bltz	s1,80001240 <growproc+0x5a>
  p->sz = sz;
    8000120c:	1602                	slli	a2,a2,0x20
    8000120e:	9201                	srli	a2,a2,0x20
    80001210:	04c93423          	sd	a2,72(s2)
  return 0;
    80001214:	4501                	li	a0,0
}
    80001216:	60e2                	ld	ra,24(sp)
    80001218:	6442                	ld	s0,16(sp)
    8000121a:	64a2                	ld	s1,8(sp)
    8000121c:	6902                	ld	s2,0(sp)
    8000121e:	6105                	addi	sp,sp,32
    80001220:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001222:	9e25                	addw	a2,a2,s1
    80001224:	1602                	slli	a2,a2,0x20
    80001226:	9201                	srli	a2,a2,0x20
    80001228:	1582                	slli	a1,a1,0x20
    8000122a:	9181                	srli	a1,a1,0x20
    8000122c:	6928                	ld	a0,80(a0)
    8000122e:	fffff097          	auipc	ra,0xfffff
    80001232:	6ce080e7          	jalr	1742(ra) # 800008fc <uvmalloc>
    80001236:	0005061b          	sext.w	a2,a0
    8000123a:	fa69                	bnez	a2,8000120c <growproc+0x26>
      return -1;
    8000123c:	557d                	li	a0,-1
    8000123e:	bfe1                	j	80001216 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001240:	9e25                	addw	a2,a2,s1
    80001242:	1602                	slli	a2,a2,0x20
    80001244:	9201                	srli	a2,a2,0x20
    80001246:	1582                	slli	a1,a1,0x20
    80001248:	9181                	srli	a1,a1,0x20
    8000124a:	6928                	ld	a0,80(a0)
    8000124c:	fffff097          	auipc	ra,0xfffff
    80001250:	668080e7          	jalr	1640(ra) # 800008b4 <uvmdealloc>
    80001254:	0005061b          	sext.w	a2,a0
    80001258:	bf55                	j	8000120c <growproc+0x26>

000000008000125a <fork>:
{
    8000125a:	7139                	addi	sp,sp,-64
    8000125c:	fc06                	sd	ra,56(sp)
    8000125e:	f822                	sd	s0,48(sp)
    80001260:	f426                	sd	s1,40(sp)
    80001262:	f04a                	sd	s2,32(sp)
    80001264:	ec4e                	sd	s3,24(sp)
    80001266:	e852                	sd	s4,16(sp)
    80001268:	e456                	sd	s5,8(sp)
    8000126a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	c20080e7          	jalr	-992(ra) # 80000e8c <myproc>
    80001274:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	e20080e7          	jalr	-480(ra) # 80001096 <allocproc>
    8000127e:	12050063          	beqz	a0,8000139e <fork+0x144>
    80001282:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001284:	048ab603          	ld	a2,72(s5)
    80001288:	692c                	ld	a1,80(a0)
    8000128a:	050ab503          	ld	a0,80(s5)
    8000128e:	fffff097          	auipc	ra,0xfffff
    80001292:	7ba080e7          	jalr	1978(ra) # 80000a48 <uvmcopy>
    80001296:	04054c63          	bltz	a0,800012ee <fork+0x94>
  np->sz = p->sz;
    8000129a:	048ab783          	ld	a5,72(s5)
    8000129e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012a2:	058ab683          	ld	a3,88(s5)
    800012a6:	87b6                	mv	a5,a3
    800012a8:	0589b703          	ld	a4,88(s3)
    800012ac:	12068693          	addi	a3,a3,288
    800012b0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b4:	6788                	ld	a0,8(a5)
    800012b6:	6b8c                	ld	a1,16(a5)
    800012b8:	6f90                	ld	a2,24(a5)
    800012ba:	01073023          	sd	a6,0(a4)
    800012be:	e708                	sd	a0,8(a4)
    800012c0:	eb0c                	sd	a1,16(a4)
    800012c2:	ef10                	sd	a2,24(a4)
    800012c4:	02078793          	addi	a5,a5,32
    800012c8:	02070713          	addi	a4,a4,32
    800012cc:	fed792e3          	bne	a5,a3,800012b0 <fork+0x56>
  np->tracemask = p->tracemask;
    800012d0:	168aa783          	lw	a5,360(s5)
    800012d4:	16f9a423          	sw	a5,360(s3)
  np->trapframe->a0 = 0;
    800012d8:	0589b783          	ld	a5,88(s3)
    800012dc:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e0:	0d0a8493          	addi	s1,s5,208
    800012e4:	0d098913          	addi	s2,s3,208
    800012e8:	150a8a13          	addi	s4,s5,336
    800012ec:	a00d                	j	8000130e <fork+0xb4>
    freeproc(np);
    800012ee:	854e                	mv	a0,s3
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	d4e080e7          	jalr	-690(ra) # 8000103e <freeproc>
    release(&np->lock);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	f3a080e7          	jalr	-198(ra) # 80006234 <release>
    return -1;
    80001302:	597d                	li	s2,-1
    80001304:	a059                	j	8000138a <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001306:	04a1                	addi	s1,s1,8
    80001308:	0921                	addi	s2,s2,8
    8000130a:	01448b63          	beq	s1,s4,80001320 <fork+0xc6>
    if(p->ofile[i])
    8000130e:	6088                	ld	a0,0(s1)
    80001310:	d97d                	beqz	a0,80001306 <fork+0xac>
      np->ofile[i] = filedup(p->ofile[i]);
    80001312:	00002097          	auipc	ra,0x2
    80001316:	71a080e7          	jalr	1818(ra) # 80003a2c <filedup>
    8000131a:	00a93023          	sd	a0,0(s2)
    8000131e:	b7e5                	j	80001306 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001320:	150ab503          	ld	a0,336(s5)
    80001324:	00002097          	auipc	ra,0x2
    80001328:	87e080e7          	jalr	-1922(ra) # 80002ba2 <idup>
    8000132c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001330:	4641                	li	a2,16
    80001332:	158a8593          	addi	a1,s5,344
    80001336:	15898513          	addi	a0,s3,344
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	fd2080e7          	jalr	-46(ra) # 8000030c <safestrcpy>
  pid = np->pid;
    80001342:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001346:	854e                	mv	a0,s3
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	eec080e7          	jalr	-276(ra) # 80006234 <release>
  acquire(&wait_lock);
    80001350:	00008497          	auipc	s1,0x8
    80001354:	d1848493          	addi	s1,s1,-744 # 80009068 <wait_lock>
    80001358:	8526                	mv	a0,s1
    8000135a:	00005097          	auipc	ra,0x5
    8000135e:	e26080e7          	jalr	-474(ra) # 80006180 <acquire>
  np->parent = p;
    80001362:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001366:	8526                	mv	a0,s1
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	ecc080e7          	jalr	-308(ra) # 80006234 <release>
  acquire(&np->lock);
    80001370:	854e                	mv	a0,s3
    80001372:	00005097          	auipc	ra,0x5
    80001376:	e0e080e7          	jalr	-498(ra) # 80006180 <acquire>
  np->state = RUNNABLE;
    8000137a:	478d                	li	a5,3
    8000137c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001380:	854e                	mv	a0,s3
    80001382:	00005097          	auipc	ra,0x5
    80001386:	eb2080e7          	jalr	-334(ra) # 80006234 <release>
}
    8000138a:	854a                	mv	a0,s2
    8000138c:	70e2                	ld	ra,56(sp)
    8000138e:	7442                	ld	s0,48(sp)
    80001390:	74a2                	ld	s1,40(sp)
    80001392:	7902                	ld	s2,32(sp)
    80001394:	69e2                	ld	s3,24(sp)
    80001396:	6a42                	ld	s4,16(sp)
    80001398:	6aa2                	ld	s5,8(sp)
    8000139a:	6121                	addi	sp,sp,64
    8000139c:	8082                	ret
    return -1;
    8000139e:	597d                	li	s2,-1
    800013a0:	b7ed                	j	8000138a <fork+0x130>

00000000800013a2 <scheduler>:
{
    800013a2:	7139                	addi	sp,sp,-64
    800013a4:	fc06                	sd	ra,56(sp)
    800013a6:	f822                	sd	s0,48(sp)
    800013a8:	f426                	sd	s1,40(sp)
    800013aa:	f04a                	sd	s2,32(sp)
    800013ac:	ec4e                	sd	s3,24(sp)
    800013ae:	e852                	sd	s4,16(sp)
    800013b0:	e456                	sd	s5,8(sp)
    800013b2:	e05a                	sd	s6,0(sp)
    800013b4:	0080                	addi	s0,sp,64
    800013b6:	8792                	mv	a5,tp
  int id = r_tp();
    800013b8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ba:	00779a93          	slli	s5,a5,0x7
    800013be:	00008717          	auipc	a4,0x8
    800013c2:	c9270713          	addi	a4,a4,-878 # 80009050 <pid_lock>
    800013c6:	9756                	add	a4,a4,s5
    800013c8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013cc:	00008717          	auipc	a4,0x8
    800013d0:	cbc70713          	addi	a4,a4,-836 # 80009088 <cpus+0x8>
    800013d4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d6:	498d                	li	s3,3
        p->state = RUNNING;
    800013d8:	4b11                	li	s6,4
        c->proc = p;
    800013da:	079e                	slli	a5,a5,0x7
    800013dc:	00008a17          	auipc	s4,0x8
    800013e0:	c74a0a13          	addi	s4,s4,-908 # 80009050 <pid_lock>
    800013e4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e6:	0000e917          	auipc	s2,0xe
    800013ea:	c9a90913          	addi	s2,s2,-870 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f6:	10079073          	csrw	sstatus,a5
    800013fa:	00008497          	auipc	s1,0x8
    800013fe:	08648493          	addi	s1,s1,134 # 80009480 <proc>
    80001402:	a811                	j	80001416 <scheduler+0x74>
      release(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	e2e080e7          	jalr	-466(ra) # 80006234 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000140e:	17048493          	addi	s1,s1,368
    80001412:	fd248ee3          	beq	s1,s2,800013ee <scheduler+0x4c>
      acquire(&p->lock);
    80001416:	8526                	mv	a0,s1
    80001418:	00005097          	auipc	ra,0x5
    8000141c:	d68080e7          	jalr	-664(ra) # 80006180 <acquire>
      if(p->state == RUNNABLE) {
    80001420:	4c9c                	lw	a5,24(s1)
    80001422:	ff3791e3          	bne	a5,s3,80001404 <scheduler+0x62>
        p->state = RUNNING;
    80001426:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000142a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000142e:	06048593          	addi	a1,s1,96
    80001432:	8556                	mv	a0,s5
    80001434:	00000097          	auipc	ra,0x0
    80001438:	67e080e7          	jalr	1662(ra) # 80001ab2 <swtch>
        c->proc = 0;
    8000143c:	020a3823          	sd	zero,48(s4)
    80001440:	b7d1                	j	80001404 <scheduler+0x62>

0000000080001442 <sched>:
{
    80001442:	7179                	addi	sp,sp,-48
    80001444:	f406                	sd	ra,40(sp)
    80001446:	f022                	sd	s0,32(sp)
    80001448:	ec26                	sd	s1,24(sp)
    8000144a:	e84a                	sd	s2,16(sp)
    8000144c:	e44e                	sd	s3,8(sp)
    8000144e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001450:	00000097          	auipc	ra,0x0
    80001454:	a3c080e7          	jalr	-1476(ra) # 80000e8c <myproc>
    80001458:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145a:	00005097          	auipc	ra,0x5
    8000145e:	cac080e7          	jalr	-852(ra) # 80006106 <holding>
    80001462:	c93d                	beqz	a0,800014d8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001464:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	00008717          	auipc	a4,0x8
    8000146e:	be670713          	addi	a4,a4,-1050 # 80009050 <pid_lock>
    80001472:	97ba                	add	a5,a5,a4
    80001474:	0a87a703          	lw	a4,168(a5)
    80001478:	4785                	li	a5,1
    8000147a:	06f71763          	bne	a4,a5,800014e8 <sched+0xa6>
  if(p->state == RUNNING)
    8000147e:	4c98                	lw	a4,24(s1)
    80001480:	4791                	li	a5,4
    80001482:	06f70b63          	beq	a4,a5,800014f8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001486:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148c:	efb5                	bnez	a5,80001508 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000148e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001490:	00008917          	auipc	s2,0x8
    80001494:	bc090913          	addi	s2,s2,-1088 # 80009050 <pid_lock>
    80001498:	2781                	sext.w	a5,a5
    8000149a:	079e                	slli	a5,a5,0x7
    8000149c:	97ca                	add	a5,a5,s2
    8000149e:	0ac7a983          	lw	s3,172(a5)
    800014a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a4:	2781                	sext.w	a5,a5
    800014a6:	079e                	slli	a5,a5,0x7
    800014a8:	00008597          	auipc	a1,0x8
    800014ac:	be058593          	addi	a1,a1,-1056 # 80009088 <cpus+0x8>
    800014b0:	95be                	add	a1,a1,a5
    800014b2:	06048513          	addi	a0,s1,96
    800014b6:	00000097          	auipc	ra,0x0
    800014ba:	5fc080e7          	jalr	1532(ra) # 80001ab2 <swtch>
    800014be:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c0:	2781                	sext.w	a5,a5
    800014c2:	079e                	slli	a5,a5,0x7
    800014c4:	97ca                	add	a5,a5,s2
    800014c6:	0b37a623          	sw	s3,172(a5)
}
    800014ca:	70a2                	ld	ra,40(sp)
    800014cc:	7402                	ld	s0,32(sp)
    800014ce:	64e2                	ld	s1,24(sp)
    800014d0:	6942                	ld	s2,16(sp)
    800014d2:	69a2                	ld	s3,8(sp)
    800014d4:	6145                	addi	sp,sp,48
    800014d6:	8082                	ret
    panic("sched p->lock");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	cc050513          	addi	a0,a0,-832 # 80008198 <etext+0x198>
    800014e0:	00004097          	auipc	ra,0x4
    800014e4:	764080e7          	jalr	1892(ra) # 80005c44 <panic>
    panic("sched locks");
    800014e8:	00007517          	auipc	a0,0x7
    800014ec:	cc050513          	addi	a0,a0,-832 # 800081a8 <etext+0x1a8>
    800014f0:	00004097          	auipc	ra,0x4
    800014f4:	754080e7          	jalr	1876(ra) # 80005c44 <panic>
    panic("sched running");
    800014f8:	00007517          	auipc	a0,0x7
    800014fc:	cc050513          	addi	a0,a0,-832 # 800081b8 <etext+0x1b8>
    80001500:	00004097          	auipc	ra,0x4
    80001504:	744080e7          	jalr	1860(ra) # 80005c44 <panic>
    panic("sched interruptible");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	cc050513          	addi	a0,a0,-832 # 800081c8 <etext+0x1c8>
    80001510:	00004097          	auipc	ra,0x4
    80001514:	734080e7          	jalr	1844(ra) # 80005c44 <panic>

0000000080001518 <yield>:
{
    80001518:	1101                	addi	sp,sp,-32
    8000151a:	ec06                	sd	ra,24(sp)
    8000151c:	e822                	sd	s0,16(sp)
    8000151e:	e426                	sd	s1,8(sp)
    80001520:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001522:	00000097          	auipc	ra,0x0
    80001526:	96a080e7          	jalr	-1686(ra) # 80000e8c <myproc>
    8000152a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	c54080e7          	jalr	-940(ra) # 80006180 <acquire>
  p->state = RUNNABLE;
    80001534:	478d                	li	a5,3
    80001536:	cc9c                	sw	a5,24(s1)
  sched();
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	f0a080e7          	jalr	-246(ra) # 80001442 <sched>
  release(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	00005097          	auipc	ra,0x5
    80001546:	cf2080e7          	jalr	-782(ra) # 80006234 <release>
}
    8000154a:	60e2                	ld	ra,24(sp)
    8000154c:	6442                	ld	s0,16(sp)
    8000154e:	64a2                	ld	s1,8(sp)
    80001550:	6105                	addi	sp,sp,32
    80001552:	8082                	ret

0000000080001554 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001554:	7179                	addi	sp,sp,-48
    80001556:	f406                	sd	ra,40(sp)
    80001558:	f022                	sd	s0,32(sp)
    8000155a:	ec26                	sd	s1,24(sp)
    8000155c:	e84a                	sd	s2,16(sp)
    8000155e:	e44e                	sd	s3,8(sp)
    80001560:	1800                	addi	s0,sp,48
    80001562:	89aa                	mv	s3,a0
    80001564:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	926080e7          	jalr	-1754(ra) # 80000e8c <myproc>
    8000156e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001570:	00005097          	auipc	ra,0x5
    80001574:	c10080e7          	jalr	-1008(ra) # 80006180 <acquire>
  release(lk);
    80001578:	854a                	mv	a0,s2
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	cba080e7          	jalr	-838(ra) # 80006234 <release>

  // Go to sleep.
  p->chan = chan;
    80001582:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001586:	4789                	li	a5,2
    80001588:	cc9c                	sw	a5,24(s1)

  sched();
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	eb8080e7          	jalr	-328(ra) # 80001442 <sched>

  // Tidy up.
  p->chan = 0;
    80001592:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001596:	8526                	mv	a0,s1
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	c9c080e7          	jalr	-868(ra) # 80006234 <release>
  acquire(lk);
    800015a0:	854a                	mv	a0,s2
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	bde080e7          	jalr	-1058(ra) # 80006180 <acquire>
}
    800015aa:	70a2                	ld	ra,40(sp)
    800015ac:	7402                	ld	s0,32(sp)
    800015ae:	64e2                	ld	s1,24(sp)
    800015b0:	6942                	ld	s2,16(sp)
    800015b2:	69a2                	ld	s3,8(sp)
    800015b4:	6145                	addi	sp,sp,48
    800015b6:	8082                	ret

00000000800015b8 <wait>:
{
    800015b8:	715d                	addi	sp,sp,-80
    800015ba:	e486                	sd	ra,72(sp)
    800015bc:	e0a2                	sd	s0,64(sp)
    800015be:	fc26                	sd	s1,56(sp)
    800015c0:	f84a                	sd	s2,48(sp)
    800015c2:	f44e                	sd	s3,40(sp)
    800015c4:	f052                	sd	s4,32(sp)
    800015c6:	ec56                	sd	s5,24(sp)
    800015c8:	e85a                	sd	s6,16(sp)
    800015ca:	e45e                	sd	s7,8(sp)
    800015cc:	e062                	sd	s8,0(sp)
    800015ce:	0880                	addi	s0,sp,80
    800015d0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d2:	00000097          	auipc	ra,0x0
    800015d6:	8ba080e7          	jalr	-1862(ra) # 80000e8c <myproc>
    800015da:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015dc:	00008517          	auipc	a0,0x8
    800015e0:	a8c50513          	addi	a0,a0,-1396 # 80009068 <wait_lock>
    800015e4:	00005097          	auipc	ra,0x5
    800015e8:	b9c080e7          	jalr	-1124(ra) # 80006180 <acquire>
    havekids = 0;
    800015ec:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015ee:	4a15                	li	s4,5
        havekids = 1;
    800015f0:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015f2:	0000e997          	auipc	s3,0xe
    800015f6:	a8e98993          	addi	s3,s3,-1394 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fa:	00008c17          	auipc	s8,0x8
    800015fe:	a6ec0c13          	addi	s8,s8,-1426 # 80009068 <wait_lock>
    havekids = 0;
    80001602:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001604:	00008497          	auipc	s1,0x8
    80001608:	e7c48493          	addi	s1,s1,-388 # 80009480 <proc>
    8000160c:	a0bd                	j	8000167a <wait+0xc2>
          pid = np->pid;
    8000160e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001612:	000b0e63          	beqz	s6,8000162e <wait+0x76>
    80001616:	4691                	li	a3,4
    80001618:	02c48613          	addi	a2,s1,44
    8000161c:	85da                	mv	a1,s6
    8000161e:	05093503          	ld	a0,80(s2)
    80001622:	fffff097          	auipc	ra,0xfffff
    80001626:	52a080e7          	jalr	1322(ra) # 80000b4c <copyout>
    8000162a:	02054563          	bltz	a0,80001654 <wait+0x9c>
          freeproc(np);
    8000162e:	8526                	mv	a0,s1
    80001630:	00000097          	auipc	ra,0x0
    80001634:	a0e080e7          	jalr	-1522(ra) # 8000103e <freeproc>
          release(&np->lock);
    80001638:	8526                	mv	a0,s1
    8000163a:	00005097          	auipc	ra,0x5
    8000163e:	bfa080e7          	jalr	-1030(ra) # 80006234 <release>
          release(&wait_lock);
    80001642:	00008517          	auipc	a0,0x8
    80001646:	a2650513          	addi	a0,a0,-1498 # 80009068 <wait_lock>
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	bea080e7          	jalr	-1046(ra) # 80006234 <release>
          return pid;
    80001652:	a09d                	j	800016b8 <wait+0x100>
            release(&np->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	00005097          	auipc	ra,0x5
    8000165a:	bde080e7          	jalr	-1058(ra) # 80006234 <release>
            release(&wait_lock);
    8000165e:	00008517          	auipc	a0,0x8
    80001662:	a0a50513          	addi	a0,a0,-1526 # 80009068 <wait_lock>
    80001666:	00005097          	auipc	ra,0x5
    8000166a:	bce080e7          	jalr	-1074(ra) # 80006234 <release>
            return -1;
    8000166e:	59fd                	li	s3,-1
    80001670:	a0a1                	j	800016b8 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001672:	17048493          	addi	s1,s1,368
    80001676:	03348463          	beq	s1,s3,8000169e <wait+0xe6>
      if(np->parent == p){
    8000167a:	7c9c                	ld	a5,56(s1)
    8000167c:	ff279be3          	bne	a5,s2,80001672 <wait+0xba>
        acquire(&np->lock);
    80001680:	8526                	mv	a0,s1
    80001682:	00005097          	auipc	ra,0x5
    80001686:	afe080e7          	jalr	-1282(ra) # 80006180 <acquire>
        if(np->state == ZOMBIE){
    8000168a:	4c9c                	lw	a5,24(s1)
    8000168c:	f94781e3          	beq	a5,s4,8000160e <wait+0x56>
        release(&np->lock);
    80001690:	8526                	mv	a0,s1
    80001692:	00005097          	auipc	ra,0x5
    80001696:	ba2080e7          	jalr	-1118(ra) # 80006234 <release>
        havekids = 1;
    8000169a:	8756                	mv	a4,s5
    8000169c:	bfd9                	j	80001672 <wait+0xba>
    if(!havekids || p->killed){
    8000169e:	c701                	beqz	a4,800016a6 <wait+0xee>
    800016a0:	02892783          	lw	a5,40(s2)
    800016a4:	c79d                	beqz	a5,800016d2 <wait+0x11a>
      release(&wait_lock);
    800016a6:	00008517          	auipc	a0,0x8
    800016aa:	9c250513          	addi	a0,a0,-1598 # 80009068 <wait_lock>
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	b86080e7          	jalr	-1146(ra) # 80006234 <release>
      return -1;
    800016b6:	59fd                	li	s3,-1
}
    800016b8:	854e                	mv	a0,s3
    800016ba:	60a6                	ld	ra,72(sp)
    800016bc:	6406                	ld	s0,64(sp)
    800016be:	74e2                	ld	s1,56(sp)
    800016c0:	7942                	ld	s2,48(sp)
    800016c2:	79a2                	ld	s3,40(sp)
    800016c4:	7a02                	ld	s4,32(sp)
    800016c6:	6ae2                	ld	s5,24(sp)
    800016c8:	6b42                	ld	s6,16(sp)
    800016ca:	6ba2                	ld	s7,8(sp)
    800016cc:	6c02                	ld	s8,0(sp)
    800016ce:	6161                	addi	sp,sp,80
    800016d0:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d2:	85e2                	mv	a1,s8
    800016d4:	854a                	mv	a0,s2
    800016d6:	00000097          	auipc	ra,0x0
    800016da:	e7e080e7          	jalr	-386(ra) # 80001554 <sleep>
    havekids = 0;
    800016de:	b715                	j	80001602 <wait+0x4a>

00000000800016e0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e0:	7139                	addi	sp,sp,-64
    800016e2:	fc06                	sd	ra,56(sp)
    800016e4:	f822                	sd	s0,48(sp)
    800016e6:	f426                	sd	s1,40(sp)
    800016e8:	f04a                	sd	s2,32(sp)
    800016ea:	ec4e                	sd	s3,24(sp)
    800016ec:	e852                	sd	s4,16(sp)
    800016ee:	e456                	sd	s5,8(sp)
    800016f0:	0080                	addi	s0,sp,64
    800016f2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016f4:	00008497          	auipc	s1,0x8
    800016f8:	d8c48493          	addi	s1,s1,-628 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016fc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016fe:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001700:	0000e917          	auipc	s2,0xe
    80001704:	98090913          	addi	s2,s2,-1664 # 8000f080 <tickslock>
    80001708:	a811                	j	8000171c <wakeup+0x3c>
      }
      release(&p->lock);
    8000170a:	8526                	mv	a0,s1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	b28080e7          	jalr	-1240(ra) # 80006234 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001714:	17048493          	addi	s1,s1,368
    80001718:	03248663          	beq	s1,s2,80001744 <wakeup+0x64>
    if(p != myproc()){
    8000171c:	fffff097          	auipc	ra,0xfffff
    80001720:	770080e7          	jalr	1904(ra) # 80000e8c <myproc>
    80001724:	fea488e3          	beq	s1,a0,80001714 <wakeup+0x34>
      acquire(&p->lock);
    80001728:	8526                	mv	a0,s1
    8000172a:	00005097          	auipc	ra,0x5
    8000172e:	a56080e7          	jalr	-1450(ra) # 80006180 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001732:	4c9c                	lw	a5,24(s1)
    80001734:	fd379be3          	bne	a5,s3,8000170a <wakeup+0x2a>
    80001738:	709c                	ld	a5,32(s1)
    8000173a:	fd4798e3          	bne	a5,s4,8000170a <wakeup+0x2a>
        p->state = RUNNABLE;
    8000173e:	0154ac23          	sw	s5,24(s1)
    80001742:	b7e1                	j	8000170a <wakeup+0x2a>
    }
  }
}
    80001744:	70e2                	ld	ra,56(sp)
    80001746:	7442                	ld	s0,48(sp)
    80001748:	74a2                	ld	s1,40(sp)
    8000174a:	7902                	ld	s2,32(sp)
    8000174c:	69e2                	ld	s3,24(sp)
    8000174e:	6a42                	ld	s4,16(sp)
    80001750:	6aa2                	ld	s5,8(sp)
    80001752:	6121                	addi	sp,sp,64
    80001754:	8082                	ret

0000000080001756 <reparent>:
{
    80001756:	7179                	addi	sp,sp,-48
    80001758:	f406                	sd	ra,40(sp)
    8000175a:	f022                	sd	s0,32(sp)
    8000175c:	ec26                	sd	s1,24(sp)
    8000175e:	e84a                	sd	s2,16(sp)
    80001760:	e44e                	sd	s3,8(sp)
    80001762:	e052                	sd	s4,0(sp)
    80001764:	1800                	addi	s0,sp,48
    80001766:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001768:	00008497          	auipc	s1,0x8
    8000176c:	d1848493          	addi	s1,s1,-744 # 80009480 <proc>
      pp->parent = initproc;
    80001770:	00008a17          	auipc	s4,0x8
    80001774:	8a0a0a13          	addi	s4,s4,-1888 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001778:	0000e997          	auipc	s3,0xe
    8000177c:	90898993          	addi	s3,s3,-1784 # 8000f080 <tickslock>
    80001780:	a029                	j	8000178a <reparent+0x34>
    80001782:	17048493          	addi	s1,s1,368
    80001786:	01348d63          	beq	s1,s3,800017a0 <reparent+0x4a>
    if(pp->parent == p){
    8000178a:	7c9c                	ld	a5,56(s1)
    8000178c:	ff279be3          	bne	a5,s2,80001782 <reparent+0x2c>
      pp->parent = initproc;
    80001790:	000a3503          	ld	a0,0(s4)
    80001794:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001796:	00000097          	auipc	ra,0x0
    8000179a:	f4a080e7          	jalr	-182(ra) # 800016e0 <wakeup>
    8000179e:	b7d5                	j	80001782 <reparent+0x2c>
}
    800017a0:	70a2                	ld	ra,40(sp)
    800017a2:	7402                	ld	s0,32(sp)
    800017a4:	64e2                	ld	s1,24(sp)
    800017a6:	6942                	ld	s2,16(sp)
    800017a8:	69a2                	ld	s3,8(sp)
    800017aa:	6a02                	ld	s4,0(sp)
    800017ac:	6145                	addi	sp,sp,48
    800017ae:	8082                	ret

00000000800017b0 <exit>:
{
    800017b0:	7179                	addi	sp,sp,-48
    800017b2:	f406                	sd	ra,40(sp)
    800017b4:	f022                	sd	s0,32(sp)
    800017b6:	ec26                	sd	s1,24(sp)
    800017b8:	e84a                	sd	s2,16(sp)
    800017ba:	e44e                	sd	s3,8(sp)
    800017bc:	e052                	sd	s4,0(sp)
    800017be:	1800                	addi	s0,sp,48
    800017c0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c2:	fffff097          	auipc	ra,0xfffff
    800017c6:	6ca080e7          	jalr	1738(ra) # 80000e8c <myproc>
    800017ca:	89aa                	mv	s3,a0
  if(p == initproc)
    800017cc:	00008797          	auipc	a5,0x8
    800017d0:	8447b783          	ld	a5,-1980(a5) # 80009010 <initproc>
    800017d4:	0d050493          	addi	s1,a0,208
    800017d8:	15050913          	addi	s2,a0,336
    800017dc:	02a79363          	bne	a5,a0,80001802 <exit+0x52>
    panic("init exiting");
    800017e0:	00007517          	auipc	a0,0x7
    800017e4:	a0050513          	addi	a0,a0,-1536 # 800081e0 <etext+0x1e0>
    800017e8:	00004097          	auipc	ra,0x4
    800017ec:	45c080e7          	jalr	1116(ra) # 80005c44 <panic>
      fileclose(f);
    800017f0:	00002097          	auipc	ra,0x2
    800017f4:	28e080e7          	jalr	654(ra) # 80003a7e <fileclose>
      p->ofile[fd] = 0;
    800017f8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017fc:	04a1                	addi	s1,s1,8
    800017fe:	01248563          	beq	s1,s2,80001808 <exit+0x58>
    if(p->ofile[fd]){
    80001802:	6088                	ld	a0,0(s1)
    80001804:	f575                	bnez	a0,800017f0 <exit+0x40>
    80001806:	bfdd                	j	800017fc <exit+0x4c>
  begin_op();
    80001808:	00002097          	auipc	ra,0x2
    8000180c:	daa080e7          	jalr	-598(ra) # 800035b2 <begin_op>
  iput(p->cwd);
    80001810:	1509b503          	ld	a0,336(s3)
    80001814:	00001097          	auipc	ra,0x1
    80001818:	586080e7          	jalr	1414(ra) # 80002d9a <iput>
  end_op();
    8000181c:	00002097          	auipc	ra,0x2
    80001820:	e16080e7          	jalr	-490(ra) # 80003632 <end_op>
  p->cwd = 0;
    80001824:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001828:	00008497          	auipc	s1,0x8
    8000182c:	84048493          	addi	s1,s1,-1984 # 80009068 <wait_lock>
    80001830:	8526                	mv	a0,s1
    80001832:	00005097          	auipc	ra,0x5
    80001836:	94e080e7          	jalr	-1714(ra) # 80006180 <acquire>
  reparent(p);
    8000183a:	854e                	mv	a0,s3
    8000183c:	00000097          	auipc	ra,0x0
    80001840:	f1a080e7          	jalr	-230(ra) # 80001756 <reparent>
  wakeup(p->parent);
    80001844:	0389b503          	ld	a0,56(s3)
    80001848:	00000097          	auipc	ra,0x0
    8000184c:	e98080e7          	jalr	-360(ra) # 800016e0 <wakeup>
  acquire(&p->lock);
    80001850:	854e                	mv	a0,s3
    80001852:	00005097          	auipc	ra,0x5
    80001856:	92e080e7          	jalr	-1746(ra) # 80006180 <acquire>
  p->xstate = status;
    8000185a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000185e:	4795                	li	a5,5
    80001860:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001864:	8526                	mv	a0,s1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	9ce080e7          	jalr	-1586(ra) # 80006234 <release>
  sched();
    8000186e:	00000097          	auipc	ra,0x0
    80001872:	bd4080e7          	jalr	-1068(ra) # 80001442 <sched>
  panic("zombie exit");
    80001876:	00007517          	auipc	a0,0x7
    8000187a:	97a50513          	addi	a0,a0,-1670 # 800081f0 <etext+0x1f0>
    8000187e:	00004097          	auipc	ra,0x4
    80001882:	3c6080e7          	jalr	966(ra) # 80005c44 <panic>

0000000080001886 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001886:	7179                	addi	sp,sp,-48
    80001888:	f406                	sd	ra,40(sp)
    8000188a:	f022                	sd	s0,32(sp)
    8000188c:	ec26                	sd	s1,24(sp)
    8000188e:	e84a                	sd	s2,16(sp)
    80001890:	e44e                	sd	s3,8(sp)
    80001892:	1800                	addi	s0,sp,48
    80001894:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001896:	00008497          	auipc	s1,0x8
    8000189a:	bea48493          	addi	s1,s1,-1046 # 80009480 <proc>
    8000189e:	0000d997          	auipc	s3,0xd
    800018a2:	7e298993          	addi	s3,s3,2018 # 8000f080 <tickslock>
    acquire(&p->lock);
    800018a6:	8526                	mv	a0,s1
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	8d8080e7          	jalr	-1832(ra) # 80006180 <acquire>
    if(p->pid == pid){
    800018b0:	589c                	lw	a5,48(s1)
    800018b2:	01278d63          	beq	a5,s2,800018cc <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018b6:	8526                	mv	a0,s1
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	97c080e7          	jalr	-1668(ra) # 80006234 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c0:	17048493          	addi	s1,s1,368
    800018c4:	ff3491e3          	bne	s1,s3,800018a6 <kill+0x20>
  }
  return -1;
    800018c8:	557d                	li	a0,-1
    800018ca:	a829                	j	800018e4 <kill+0x5e>
      p->killed = 1;
    800018cc:	4785                	li	a5,1
    800018ce:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d0:	4c98                	lw	a4,24(s1)
    800018d2:	4789                	li	a5,2
    800018d4:	00f70f63          	beq	a4,a5,800018f2 <kill+0x6c>
      release(&p->lock);
    800018d8:	8526                	mv	a0,s1
    800018da:	00005097          	auipc	ra,0x5
    800018de:	95a080e7          	jalr	-1702(ra) # 80006234 <release>
      return 0;
    800018e2:	4501                	li	a0,0
}
    800018e4:	70a2                	ld	ra,40(sp)
    800018e6:	7402                	ld	s0,32(sp)
    800018e8:	64e2                	ld	s1,24(sp)
    800018ea:	6942                	ld	s2,16(sp)
    800018ec:	69a2                	ld	s3,8(sp)
    800018ee:	6145                	addi	sp,sp,48
    800018f0:	8082                	ret
        p->state = RUNNABLE;
    800018f2:	478d                	li	a5,3
    800018f4:	cc9c                	sw	a5,24(s1)
    800018f6:	b7cd                	j	800018d8 <kill+0x52>

00000000800018f8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018f8:	7179                	addi	sp,sp,-48
    800018fa:	f406                	sd	ra,40(sp)
    800018fc:	f022                	sd	s0,32(sp)
    800018fe:	ec26                	sd	s1,24(sp)
    80001900:	e84a                	sd	s2,16(sp)
    80001902:	e44e                	sd	s3,8(sp)
    80001904:	e052                	sd	s4,0(sp)
    80001906:	1800                	addi	s0,sp,48
    80001908:	84aa                	mv	s1,a0
    8000190a:	892e                	mv	s2,a1
    8000190c:	89b2                	mv	s3,a2
    8000190e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001910:	fffff097          	auipc	ra,0xfffff
    80001914:	57c080e7          	jalr	1404(ra) # 80000e8c <myproc>
  if(user_dst){
    80001918:	c08d                	beqz	s1,8000193a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191a:	86d2                	mv	a3,s4
    8000191c:	864e                	mv	a2,s3
    8000191e:	85ca                	mv	a1,s2
    80001920:	6928                	ld	a0,80(a0)
    80001922:	fffff097          	auipc	ra,0xfffff
    80001926:	22a080e7          	jalr	554(ra) # 80000b4c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192a:	70a2                	ld	ra,40(sp)
    8000192c:	7402                	ld	s0,32(sp)
    8000192e:	64e2                	ld	s1,24(sp)
    80001930:	6942                	ld	s2,16(sp)
    80001932:	69a2                	ld	s3,8(sp)
    80001934:	6a02                	ld	s4,0(sp)
    80001936:	6145                	addi	sp,sp,48
    80001938:	8082                	ret
    memmove((char *)dst, src, len);
    8000193a:	000a061b          	sext.w	a2,s4
    8000193e:	85ce                	mv	a1,s3
    80001940:	854a                	mv	a0,s2
    80001942:	fffff097          	auipc	ra,0xfffff
    80001946:	8dc080e7          	jalr	-1828(ra) # 8000021e <memmove>
    return 0;
    8000194a:	8526                	mv	a0,s1
    8000194c:	bff9                	j	8000192a <either_copyout+0x32>

000000008000194e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000194e:	7179                	addi	sp,sp,-48
    80001950:	f406                	sd	ra,40(sp)
    80001952:	f022                	sd	s0,32(sp)
    80001954:	ec26                	sd	s1,24(sp)
    80001956:	e84a                	sd	s2,16(sp)
    80001958:	e44e                	sd	s3,8(sp)
    8000195a:	e052                	sd	s4,0(sp)
    8000195c:	1800                	addi	s0,sp,48
    8000195e:	892a                	mv	s2,a0
    80001960:	84ae                	mv	s1,a1
    80001962:	89b2                	mv	s3,a2
    80001964:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001966:	fffff097          	auipc	ra,0xfffff
    8000196a:	526080e7          	jalr	1318(ra) # 80000e8c <myproc>
  if(user_src){
    8000196e:	c08d                	beqz	s1,80001990 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001970:	86d2                	mv	a3,s4
    80001972:	864e                	mv	a2,s3
    80001974:	85ca                	mv	a1,s2
    80001976:	6928                	ld	a0,80(a0)
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	260080e7          	jalr	608(ra) # 80000bd8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001980:	70a2                	ld	ra,40(sp)
    80001982:	7402                	ld	s0,32(sp)
    80001984:	64e2                	ld	s1,24(sp)
    80001986:	6942                	ld	s2,16(sp)
    80001988:	69a2                	ld	s3,8(sp)
    8000198a:	6a02                	ld	s4,0(sp)
    8000198c:	6145                	addi	sp,sp,48
    8000198e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001990:	000a061b          	sext.w	a2,s4
    80001994:	85ce                	mv	a1,s3
    80001996:	854a                	mv	a0,s2
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	886080e7          	jalr	-1914(ra) # 8000021e <memmove>
    return 0;
    800019a0:	8526                	mv	a0,s1
    800019a2:	bff9                	j	80001980 <either_copyin+0x32>

00000000800019a4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a4:	715d                	addi	sp,sp,-80
    800019a6:	e486                	sd	ra,72(sp)
    800019a8:	e0a2                	sd	s0,64(sp)
    800019aa:	fc26                	sd	s1,56(sp)
    800019ac:	f84a                	sd	s2,48(sp)
    800019ae:	f44e                	sd	s3,40(sp)
    800019b0:	f052                	sd	s4,32(sp)
    800019b2:	ec56                	sd	s5,24(sp)
    800019b4:	e85a                	sd	s6,16(sp)
    800019b6:	e45e                	sd	s7,8(sp)
    800019b8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019ba:	00006517          	auipc	a0,0x6
    800019be:	68e50513          	addi	a0,a0,1678 # 80008048 <etext+0x48>
    800019c2:	00004097          	auipc	ra,0x4
    800019c6:	2cc080e7          	jalr	716(ra) # 80005c8e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ca:	00008497          	auipc	s1,0x8
    800019ce:	c0e48493          	addi	s1,s1,-1010 # 800095d8 <proc+0x158>
    800019d2:	0000e917          	auipc	s2,0xe
    800019d6:	80690913          	addi	s2,s2,-2042 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019da:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019dc:	00007997          	auipc	s3,0x7
    800019e0:	82498993          	addi	s3,s3,-2012 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e4:	00007a97          	auipc	s5,0x7
    800019e8:	824a8a93          	addi	s5,s5,-2012 # 80008208 <etext+0x208>
    printf("\n");
    800019ec:	00006a17          	auipc	s4,0x6
    800019f0:	65ca0a13          	addi	s4,s4,1628 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f4:	00007b97          	auipc	s7,0x7
    800019f8:	dccb8b93          	addi	s7,s7,-564 # 800087c0 <states.0>
    800019fc:	a00d                	j	80001a1e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019fe:	ed86a583          	lw	a1,-296(a3)
    80001a02:	8556                	mv	a0,s5
    80001a04:	00004097          	auipc	ra,0x4
    80001a08:	28a080e7          	jalr	650(ra) # 80005c8e <printf>
    printf("\n");
    80001a0c:	8552                	mv	a0,s4
    80001a0e:	00004097          	auipc	ra,0x4
    80001a12:	280080e7          	jalr	640(ra) # 80005c8e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a16:	17048493          	addi	s1,s1,368
    80001a1a:	03248163          	beq	s1,s2,80001a3c <procdump+0x98>
    if(p->state == UNUSED)
    80001a1e:	86a6                	mv	a3,s1
    80001a20:	ec04a783          	lw	a5,-320(s1)
    80001a24:	dbed                	beqz	a5,80001a16 <procdump+0x72>
      state = "???";
    80001a26:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a28:	fcfb6be3          	bltu	s6,a5,800019fe <procdump+0x5a>
    80001a2c:	1782                	slli	a5,a5,0x20
    80001a2e:	9381                	srli	a5,a5,0x20
    80001a30:	078e                	slli	a5,a5,0x3
    80001a32:	97de                	add	a5,a5,s7
    80001a34:	6390                	ld	a2,0(a5)
    80001a36:	f661                	bnez	a2,800019fe <procdump+0x5a>
      state = "???";
    80001a38:	864e                	mv	a2,s3
    80001a3a:	b7d1                	j	800019fe <procdump+0x5a>
  }
}
    80001a3c:	60a6                	ld	ra,72(sp)
    80001a3e:	6406                	ld	s0,64(sp)
    80001a40:	74e2                	ld	s1,56(sp)
    80001a42:	7942                	ld	s2,48(sp)
    80001a44:	79a2                	ld	s3,40(sp)
    80001a46:	7a02                	ld	s4,32(sp)
    80001a48:	6ae2                	ld	s5,24(sp)
    80001a4a:	6b42                	ld	s6,16(sp)
    80001a4c:	6ba2                	ld	s7,8(sp)
    80001a4e:	6161                	addi	sp,sp,80
    80001a50:	8082                	ret

0000000080001a52 <getnproc>:

// Return the number of non-UNUSED procs in the process table.
int getnproc(void)
{
    80001a52:	7179                	addi	sp,sp,-48
    80001a54:	f406                	sd	ra,40(sp)
    80001a56:	f022                	sd	s0,32(sp)
    80001a58:	ec26                	sd	s1,24(sp)
    80001a5a:	e84a                	sd	s2,16(sp)
    80001a5c:	e44e                	sd	s3,8(sp)
    80001a5e:	1800                	addi	s0,sp,48
  struct proc *p;
  int count = 0;
    80001a60:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++)
    80001a62:	00008497          	auipc	s1,0x8
    80001a66:	a1e48493          	addi	s1,s1,-1506 # 80009480 <proc>
    80001a6a:	0000d997          	auipc	s3,0xd
    80001a6e:	61698993          	addi	s3,s3,1558 # 8000f080 <tickslock>
    80001a72:	a811                	j	80001a86 <getnproc+0x34>
      count++;
      release(&p->lock);
    }
    else
    {
      release(&p->lock);
    80001a74:	8526                	mv	a0,s1
    80001a76:	00004097          	auipc	ra,0x4
    80001a7a:	7be080e7          	jalr	1982(ra) # 80006234 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a7e:	17048493          	addi	s1,s1,368
    80001a82:	03348063          	beq	s1,s3,80001aa2 <getnproc+0x50>
    acquire(&p->lock);
    80001a86:	8526                	mv	a0,s1
    80001a88:	00004097          	auipc	ra,0x4
    80001a8c:	6f8080e7          	jalr	1784(ra) # 80006180 <acquire>
    if (p->state != UNUSED)
    80001a90:	4c9c                	lw	a5,24(s1)
    80001a92:	d3ed                	beqz	a5,80001a74 <getnproc+0x22>
      count++;
    80001a94:	2905                	addiw	s2,s2,1
      release(&p->lock);
    80001a96:	8526                	mv	a0,s1
    80001a98:	00004097          	auipc	ra,0x4
    80001a9c:	79c080e7          	jalr	1948(ra) # 80006234 <release>
    80001aa0:	bff9                	j	80001a7e <getnproc+0x2c>
    }
  }
  return count;
}
    80001aa2:	854a                	mv	a0,s2
    80001aa4:	70a2                	ld	ra,40(sp)
    80001aa6:	7402                	ld	s0,32(sp)
    80001aa8:	64e2                	ld	s1,24(sp)
    80001aaa:	6942                	ld	s2,16(sp)
    80001aac:	69a2                	ld	s3,8(sp)
    80001aae:	6145                	addi	sp,sp,48
    80001ab0:	8082                	ret

0000000080001ab2 <swtch>:
    80001ab2:	00153023          	sd	ra,0(a0)
    80001ab6:	00253423          	sd	sp,8(a0)
    80001aba:	e900                	sd	s0,16(a0)
    80001abc:	ed04                	sd	s1,24(a0)
    80001abe:	03253023          	sd	s2,32(a0)
    80001ac2:	03353423          	sd	s3,40(a0)
    80001ac6:	03453823          	sd	s4,48(a0)
    80001aca:	03553c23          	sd	s5,56(a0)
    80001ace:	05653023          	sd	s6,64(a0)
    80001ad2:	05753423          	sd	s7,72(a0)
    80001ad6:	05853823          	sd	s8,80(a0)
    80001ada:	05953c23          	sd	s9,88(a0)
    80001ade:	07a53023          	sd	s10,96(a0)
    80001ae2:	07b53423          	sd	s11,104(a0)
    80001ae6:	0005b083          	ld	ra,0(a1)
    80001aea:	0085b103          	ld	sp,8(a1)
    80001aee:	6980                	ld	s0,16(a1)
    80001af0:	6d84                	ld	s1,24(a1)
    80001af2:	0205b903          	ld	s2,32(a1)
    80001af6:	0285b983          	ld	s3,40(a1)
    80001afa:	0305ba03          	ld	s4,48(a1)
    80001afe:	0385ba83          	ld	s5,56(a1)
    80001b02:	0405bb03          	ld	s6,64(a1)
    80001b06:	0485bb83          	ld	s7,72(a1)
    80001b0a:	0505bc03          	ld	s8,80(a1)
    80001b0e:	0585bc83          	ld	s9,88(a1)
    80001b12:	0605bd03          	ld	s10,96(a1)
    80001b16:	0685bd83          	ld	s11,104(a1)
    80001b1a:	8082                	ret

0000000080001b1c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b1c:	1141                	addi	sp,sp,-16
    80001b1e:	e406                	sd	ra,8(sp)
    80001b20:	e022                	sd	s0,0(sp)
    80001b22:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b24:	00006597          	auipc	a1,0x6
    80001b28:	71c58593          	addi	a1,a1,1820 # 80008240 <etext+0x240>
    80001b2c:	0000d517          	auipc	a0,0xd
    80001b30:	55450513          	addi	a0,a0,1364 # 8000f080 <tickslock>
    80001b34:	00004097          	auipc	ra,0x4
    80001b38:	5bc080e7          	jalr	1468(ra) # 800060f0 <initlock>
}
    80001b3c:	60a2                	ld	ra,8(sp)
    80001b3e:	6402                	ld	s0,0(sp)
    80001b40:	0141                	addi	sp,sp,16
    80001b42:	8082                	ret

0000000080001b44 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b44:	1141                	addi	sp,sp,-16
    80001b46:	e422                	sd	s0,8(sp)
    80001b48:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b4a:	00003797          	auipc	a5,0x3
    80001b4e:	55678793          	addi	a5,a5,1366 # 800050a0 <kernelvec>
    80001b52:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b56:	6422                	ld	s0,8(sp)
    80001b58:	0141                	addi	sp,sp,16
    80001b5a:	8082                	ret

0000000080001b5c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b5c:	1141                	addi	sp,sp,-16
    80001b5e:	e406                	sd	ra,8(sp)
    80001b60:	e022                	sd	s0,0(sp)
    80001b62:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b64:	fffff097          	auipc	ra,0xfffff
    80001b68:	328080e7          	jalr	808(ra) # 80000e8c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b6c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b70:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b72:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b76:	00005617          	auipc	a2,0x5
    80001b7a:	48a60613          	addi	a2,a2,1162 # 80007000 <_trampoline>
    80001b7e:	00005697          	auipc	a3,0x5
    80001b82:	48268693          	addi	a3,a3,1154 # 80007000 <_trampoline>
    80001b86:	8e91                	sub	a3,a3,a2
    80001b88:	040007b7          	lui	a5,0x4000
    80001b8c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b8e:	07b2                	slli	a5,a5,0xc
    80001b90:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b92:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b96:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b98:	180026f3          	csrr	a3,satp
    80001b9c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b9e:	6d38                	ld	a4,88(a0)
    80001ba0:	6134                	ld	a3,64(a0)
    80001ba2:	6585                	lui	a1,0x1
    80001ba4:	96ae                	add	a3,a3,a1
    80001ba6:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001ba8:	6d38                	ld	a4,88(a0)
    80001baa:	00000697          	auipc	a3,0x0
    80001bae:	13868693          	addi	a3,a3,312 # 80001ce2 <usertrap>
    80001bb2:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bb4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bb6:	8692                	mv	a3,tp
    80001bb8:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bba:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bbe:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bc2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc6:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bca:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bcc:	6f18                	ld	a4,24(a4)
    80001bce:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bd2:	692c                	ld	a1,80(a0)
    80001bd4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bd6:	00005717          	auipc	a4,0x5
    80001bda:	4ba70713          	addi	a4,a4,1210 # 80007090 <userret>
    80001bde:	8f11                	sub	a4,a4,a2
    80001be0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001be2:	577d                	li	a4,-1
    80001be4:	177e                	slli	a4,a4,0x3f
    80001be6:	8dd9                	or	a1,a1,a4
    80001be8:	02000537          	lui	a0,0x2000
    80001bec:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bee:	0536                	slli	a0,a0,0xd
    80001bf0:	9782                	jalr	a5
}
    80001bf2:	60a2                	ld	ra,8(sp)
    80001bf4:	6402                	ld	s0,0(sp)
    80001bf6:	0141                	addi	sp,sp,16
    80001bf8:	8082                	ret

0000000080001bfa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bfa:	1101                	addi	sp,sp,-32
    80001bfc:	ec06                	sd	ra,24(sp)
    80001bfe:	e822                	sd	s0,16(sp)
    80001c00:	e426                	sd	s1,8(sp)
    80001c02:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c04:	0000d497          	auipc	s1,0xd
    80001c08:	47c48493          	addi	s1,s1,1148 # 8000f080 <tickslock>
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	572080e7          	jalr	1394(ra) # 80006180 <acquire>
  ticks++;
    80001c16:	00007517          	auipc	a0,0x7
    80001c1a:	40250513          	addi	a0,a0,1026 # 80009018 <ticks>
    80001c1e:	411c                	lw	a5,0(a0)
    80001c20:	2785                	addiw	a5,a5,1
    80001c22:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c24:	00000097          	auipc	ra,0x0
    80001c28:	abc080e7          	jalr	-1348(ra) # 800016e0 <wakeup>
  release(&tickslock);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	00004097          	auipc	ra,0x4
    80001c32:	606080e7          	jalr	1542(ra) # 80006234 <release>
}
    80001c36:	60e2                	ld	ra,24(sp)
    80001c38:	6442                	ld	s0,16(sp)
    80001c3a:	64a2                	ld	s1,8(sp)
    80001c3c:	6105                	addi	sp,sp,32
    80001c3e:	8082                	ret

0000000080001c40 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c4a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c4e:	00074d63          	bltz	a4,80001c68 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c52:	57fd                	li	a5,-1
    80001c54:	17fe                	slli	a5,a5,0x3f
    80001c56:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c58:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c5a:	06f70363          	beq	a4,a5,80001cc0 <devintr+0x80>
  }
}
    80001c5e:	60e2                	ld	ra,24(sp)
    80001c60:	6442                	ld	s0,16(sp)
    80001c62:	64a2                	ld	s1,8(sp)
    80001c64:	6105                	addi	sp,sp,32
    80001c66:	8082                	ret
     (scause & 0xff) == 9){
    80001c68:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c6c:	46a5                	li	a3,9
    80001c6e:	fed792e3          	bne	a5,a3,80001c52 <devintr+0x12>
    int irq = plic_claim();
    80001c72:	00003097          	auipc	ra,0x3
    80001c76:	536080e7          	jalr	1334(ra) # 800051a8 <plic_claim>
    80001c7a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7c:	47a9                	li	a5,10
    80001c7e:	02f50763          	beq	a0,a5,80001cac <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c82:	4785                	li	a5,1
    80001c84:	02f50963          	beq	a0,a5,80001cb6 <devintr+0x76>
    return 1;
    80001c88:	4505                	li	a0,1
    } else if(irq){
    80001c8a:	d8f1                	beqz	s1,80001c5e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8c:	85a6                	mv	a1,s1
    80001c8e:	00006517          	auipc	a0,0x6
    80001c92:	5ba50513          	addi	a0,a0,1466 # 80008248 <etext+0x248>
    80001c96:	00004097          	auipc	ra,0x4
    80001c9a:	ff8080e7          	jalr	-8(ra) # 80005c8e <printf>
      plic_complete(irq);
    80001c9e:	8526                	mv	a0,s1
    80001ca0:	00003097          	auipc	ra,0x3
    80001ca4:	52c080e7          	jalr	1324(ra) # 800051cc <plic_complete>
    return 1;
    80001ca8:	4505                	li	a0,1
    80001caa:	bf55                	j	80001c5e <devintr+0x1e>
      uartintr();
    80001cac:	00004097          	auipc	ra,0x4
    80001cb0:	3f4080e7          	jalr	1012(ra) # 800060a0 <uartintr>
    80001cb4:	b7ed                	j	80001c9e <devintr+0x5e>
      virtio_disk_intr();
    80001cb6:	00004097          	auipc	ra,0x4
    80001cba:	9a8080e7          	jalr	-1624(ra) # 8000565e <virtio_disk_intr>
    80001cbe:	b7c5                	j	80001c9e <devintr+0x5e>
    if(cpuid() == 0){
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	1a0080e7          	jalr	416(ra) # 80000e60 <cpuid>
    80001cc8:	c901                	beqz	a0,80001cd8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cca:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cce:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cd0:	14479073          	csrw	sip,a5
    return 2;
    80001cd4:	4509                	li	a0,2
    80001cd6:	b761                	j	80001c5e <devintr+0x1e>
      clockintr();
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	f22080e7          	jalr	-222(ra) # 80001bfa <clockintr>
    80001ce0:	b7ed                	j	80001cca <devintr+0x8a>

0000000080001ce2 <usertrap>:
{
    80001ce2:	1101                	addi	sp,sp,-32
    80001ce4:	ec06                	sd	ra,24(sp)
    80001ce6:	e822                	sd	s0,16(sp)
    80001ce8:	e426                	sd	s1,8(sp)
    80001cea:	e04a                	sd	s2,0(sp)
    80001cec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cee:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf2:	1007f793          	andi	a5,a5,256
    80001cf6:	e3ad                	bnez	a5,80001d58 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf8:	00003797          	auipc	a5,0x3
    80001cfc:	3a878793          	addi	a5,a5,936 # 800050a0 <kernelvec>
    80001d00:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	188080e7          	jalr	392(ra) # 80000e8c <myproc>
    80001d0c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d0e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d10:	14102773          	csrr	a4,sepc
    80001d14:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d16:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d1a:	47a1                	li	a5,8
    80001d1c:	04f71c63          	bne	a4,a5,80001d74 <usertrap+0x92>
    if(p->killed)
    80001d20:	551c                	lw	a5,40(a0)
    80001d22:	e3b9                	bnez	a5,80001d68 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d24:	6cb8                	ld	a4,88(s1)
    80001d26:	6f1c                	ld	a5,24(a4)
    80001d28:	0791                	addi	a5,a5,4
    80001d2a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d30:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d34:	10079073          	csrw	sstatus,a5
    syscall();
    80001d38:	00000097          	auipc	ra,0x0
    80001d3c:	2e0080e7          	jalr	736(ra) # 80002018 <syscall>
  if(p->killed)
    80001d40:	549c                	lw	a5,40(s1)
    80001d42:	ebc1                	bnez	a5,80001dd2 <usertrap+0xf0>
  usertrapret();
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	e18080e7          	jalr	-488(ra) # 80001b5c <usertrapret>
}
    80001d4c:	60e2                	ld	ra,24(sp)
    80001d4e:	6442                	ld	s0,16(sp)
    80001d50:	64a2                	ld	s1,8(sp)
    80001d52:	6902                	ld	s2,0(sp)
    80001d54:	6105                	addi	sp,sp,32
    80001d56:	8082                	ret
    panic("usertrap: not from user mode");
    80001d58:	00006517          	auipc	a0,0x6
    80001d5c:	51050513          	addi	a0,a0,1296 # 80008268 <etext+0x268>
    80001d60:	00004097          	auipc	ra,0x4
    80001d64:	ee4080e7          	jalr	-284(ra) # 80005c44 <panic>
      exit(-1);
    80001d68:	557d                	li	a0,-1
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	a46080e7          	jalr	-1466(ra) # 800017b0 <exit>
    80001d72:	bf4d                	j	80001d24 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d74:	00000097          	auipc	ra,0x0
    80001d78:	ecc080e7          	jalr	-308(ra) # 80001c40 <devintr>
    80001d7c:	892a                	mv	s2,a0
    80001d7e:	c501                	beqz	a0,80001d86 <usertrap+0xa4>
  if(p->killed)
    80001d80:	549c                	lw	a5,40(s1)
    80001d82:	c3a1                	beqz	a5,80001dc2 <usertrap+0xe0>
    80001d84:	a815                	j	80001db8 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d86:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d8a:	5890                	lw	a2,48(s1)
    80001d8c:	00006517          	auipc	a0,0x6
    80001d90:	4fc50513          	addi	a0,a0,1276 # 80008288 <etext+0x288>
    80001d94:	00004097          	auipc	ra,0x4
    80001d98:	efa080e7          	jalr	-262(ra) # 80005c8e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d9c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001da0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001da4:	00006517          	auipc	a0,0x6
    80001da8:	51450513          	addi	a0,a0,1300 # 800082b8 <etext+0x2b8>
    80001dac:	00004097          	auipc	ra,0x4
    80001db0:	ee2080e7          	jalr	-286(ra) # 80005c8e <printf>
    p->killed = 1;
    80001db4:	4785                	li	a5,1
    80001db6:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001db8:	557d                	li	a0,-1
    80001dba:	00000097          	auipc	ra,0x0
    80001dbe:	9f6080e7          	jalr	-1546(ra) # 800017b0 <exit>
  if(which_dev == 2)
    80001dc2:	4789                	li	a5,2
    80001dc4:	f8f910e3          	bne	s2,a5,80001d44 <usertrap+0x62>
    yield();
    80001dc8:	fffff097          	auipc	ra,0xfffff
    80001dcc:	750080e7          	jalr	1872(ra) # 80001518 <yield>
    80001dd0:	bf95                	j	80001d44 <usertrap+0x62>
  int which_dev = 0;
    80001dd2:	4901                	li	s2,0
    80001dd4:	b7d5                	j	80001db8 <usertrap+0xd6>

0000000080001dd6 <kerneltrap>:
{
    80001dd6:	7179                	addi	sp,sp,-48
    80001dd8:	f406                	sd	ra,40(sp)
    80001dda:	f022                	sd	s0,32(sp)
    80001ddc:	ec26                	sd	s1,24(sp)
    80001dde:	e84a                	sd	s2,16(sp)
    80001de0:	e44e                	sd	s3,8(sp)
    80001de2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dec:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001df0:	1004f793          	andi	a5,s1,256
    80001df4:	cb85                	beqz	a5,80001e24 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dfa:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dfc:	ef85                	bnez	a5,80001e34 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dfe:	00000097          	auipc	ra,0x0
    80001e02:	e42080e7          	jalr	-446(ra) # 80001c40 <devintr>
    80001e06:	cd1d                	beqz	a0,80001e44 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e08:	4789                	li	a5,2
    80001e0a:	06f50a63          	beq	a0,a5,80001e7e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e0e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e12:	10049073          	csrw	sstatus,s1
}
    80001e16:	70a2                	ld	ra,40(sp)
    80001e18:	7402                	ld	s0,32(sp)
    80001e1a:	64e2                	ld	s1,24(sp)
    80001e1c:	6942                	ld	s2,16(sp)
    80001e1e:	69a2                	ld	s3,8(sp)
    80001e20:	6145                	addi	sp,sp,48
    80001e22:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e24:	00006517          	auipc	a0,0x6
    80001e28:	4b450513          	addi	a0,a0,1204 # 800082d8 <etext+0x2d8>
    80001e2c:	00004097          	auipc	ra,0x4
    80001e30:	e18080e7          	jalr	-488(ra) # 80005c44 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	4cc50513          	addi	a0,a0,1228 # 80008300 <etext+0x300>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	e08080e7          	jalr	-504(ra) # 80005c44 <panic>
    printf("scause %p\n", scause);
    80001e44:	85ce                	mv	a1,s3
    80001e46:	00006517          	auipc	a0,0x6
    80001e4a:	4da50513          	addi	a0,a0,1242 # 80008320 <etext+0x320>
    80001e4e:	00004097          	auipc	ra,0x4
    80001e52:	e40080e7          	jalr	-448(ra) # 80005c8e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e56:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e5a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e5e:	00006517          	auipc	a0,0x6
    80001e62:	4d250513          	addi	a0,a0,1234 # 80008330 <etext+0x330>
    80001e66:	00004097          	auipc	ra,0x4
    80001e6a:	e28080e7          	jalr	-472(ra) # 80005c8e <printf>
    panic("kerneltrap");
    80001e6e:	00006517          	auipc	a0,0x6
    80001e72:	4da50513          	addi	a0,a0,1242 # 80008348 <etext+0x348>
    80001e76:	00004097          	auipc	ra,0x4
    80001e7a:	dce080e7          	jalr	-562(ra) # 80005c44 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	00e080e7          	jalr	14(ra) # 80000e8c <myproc>
    80001e86:	d541                	beqz	a0,80001e0e <kerneltrap+0x38>
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	004080e7          	jalr	4(ra) # 80000e8c <myproc>
    80001e90:	4d18                	lw	a4,24(a0)
    80001e92:	4791                	li	a5,4
    80001e94:	f6f71de3          	bne	a4,a5,80001e0e <kerneltrap+0x38>
    yield();
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	680080e7          	jalr	1664(ra) # 80001518 <yield>
    80001ea0:	b7bd                	j	80001e0e <kerneltrap+0x38>

0000000080001ea2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ea2:	1101                	addi	sp,sp,-32
    80001ea4:	ec06                	sd	ra,24(sp)
    80001ea6:	e822                	sd	s0,16(sp)
    80001ea8:	e426                	sd	s1,8(sp)
    80001eaa:	1000                	addi	s0,sp,32
    80001eac:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eae:	fffff097          	auipc	ra,0xfffff
    80001eb2:	fde080e7          	jalr	-34(ra) # 80000e8c <myproc>
  switch (n) {
    80001eb6:	4795                	li	a5,5
    80001eb8:	0497e163          	bltu	a5,s1,80001efa <argraw+0x58>
    80001ebc:	048a                	slli	s1,s1,0x2
    80001ebe:	00007717          	auipc	a4,0x7
    80001ec2:	93270713          	addi	a4,a4,-1742 # 800087f0 <states.0+0x30>
    80001ec6:	94ba                	add	s1,s1,a4
    80001ec8:	409c                	lw	a5,0(s1)
    80001eca:	97ba                	add	a5,a5,a4
    80001ecc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ece:	6d3c                	ld	a5,88(a0)
    80001ed0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ed2:	60e2                	ld	ra,24(sp)
    80001ed4:	6442                	ld	s0,16(sp)
    80001ed6:	64a2                	ld	s1,8(sp)
    80001ed8:	6105                	addi	sp,sp,32
    80001eda:	8082                	ret
    return p->trapframe->a1;
    80001edc:	6d3c                	ld	a5,88(a0)
    80001ede:	7fa8                	ld	a0,120(a5)
    80001ee0:	bfcd                	j	80001ed2 <argraw+0x30>
    return p->trapframe->a2;
    80001ee2:	6d3c                	ld	a5,88(a0)
    80001ee4:	63c8                	ld	a0,128(a5)
    80001ee6:	b7f5                	j	80001ed2 <argraw+0x30>
    return p->trapframe->a3;
    80001ee8:	6d3c                	ld	a5,88(a0)
    80001eea:	67c8                	ld	a0,136(a5)
    80001eec:	b7dd                	j	80001ed2 <argraw+0x30>
    return p->trapframe->a4;
    80001eee:	6d3c                	ld	a5,88(a0)
    80001ef0:	6bc8                	ld	a0,144(a5)
    80001ef2:	b7c5                	j	80001ed2 <argraw+0x30>
    return p->trapframe->a5;
    80001ef4:	6d3c                	ld	a5,88(a0)
    80001ef6:	6fc8                	ld	a0,152(a5)
    80001ef8:	bfe9                	j	80001ed2 <argraw+0x30>
  panic("argraw");
    80001efa:	00006517          	auipc	a0,0x6
    80001efe:	45e50513          	addi	a0,a0,1118 # 80008358 <etext+0x358>
    80001f02:	00004097          	auipc	ra,0x4
    80001f06:	d42080e7          	jalr	-702(ra) # 80005c44 <panic>

0000000080001f0a <fetchaddr>:
{
    80001f0a:	1101                	addi	sp,sp,-32
    80001f0c:	ec06                	sd	ra,24(sp)
    80001f0e:	e822                	sd	s0,16(sp)
    80001f10:	e426                	sd	s1,8(sp)
    80001f12:	e04a                	sd	s2,0(sp)
    80001f14:	1000                	addi	s0,sp,32
    80001f16:	84aa                	mv	s1,a0
    80001f18:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	f72080e7          	jalr	-142(ra) # 80000e8c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f22:	653c                	ld	a5,72(a0)
    80001f24:	02f4f863          	bgeu	s1,a5,80001f54 <fetchaddr+0x4a>
    80001f28:	00848713          	addi	a4,s1,8
    80001f2c:	02e7e663          	bltu	a5,a4,80001f58 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f30:	46a1                	li	a3,8
    80001f32:	8626                	mv	a2,s1
    80001f34:	85ca                	mv	a1,s2
    80001f36:	6928                	ld	a0,80(a0)
    80001f38:	fffff097          	auipc	ra,0xfffff
    80001f3c:	ca0080e7          	jalr	-864(ra) # 80000bd8 <copyin>
    80001f40:	00a03533          	snez	a0,a0
    80001f44:	40a00533          	neg	a0,a0
}
    80001f48:	60e2                	ld	ra,24(sp)
    80001f4a:	6442                	ld	s0,16(sp)
    80001f4c:	64a2                	ld	s1,8(sp)
    80001f4e:	6902                	ld	s2,0(sp)
    80001f50:	6105                	addi	sp,sp,32
    80001f52:	8082                	ret
    return -1;
    80001f54:	557d                	li	a0,-1
    80001f56:	bfcd                	j	80001f48 <fetchaddr+0x3e>
    80001f58:	557d                	li	a0,-1
    80001f5a:	b7fd                	j	80001f48 <fetchaddr+0x3e>

0000000080001f5c <fetchstr>:
{
    80001f5c:	7179                	addi	sp,sp,-48
    80001f5e:	f406                	sd	ra,40(sp)
    80001f60:	f022                	sd	s0,32(sp)
    80001f62:	ec26                	sd	s1,24(sp)
    80001f64:	e84a                	sd	s2,16(sp)
    80001f66:	e44e                	sd	s3,8(sp)
    80001f68:	1800                	addi	s0,sp,48
    80001f6a:	892a                	mv	s2,a0
    80001f6c:	84ae                	mv	s1,a1
    80001f6e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f70:	fffff097          	auipc	ra,0xfffff
    80001f74:	f1c080e7          	jalr	-228(ra) # 80000e8c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f78:	86ce                	mv	a3,s3
    80001f7a:	864a                	mv	a2,s2
    80001f7c:	85a6                	mv	a1,s1
    80001f7e:	6928                	ld	a0,80(a0)
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	ce6080e7          	jalr	-794(ra) # 80000c66 <copyinstr>
  if(err < 0)
    80001f88:	00054763          	bltz	a0,80001f96 <fetchstr+0x3a>
  return strlen(buf);
    80001f8c:	8526                	mv	a0,s1
    80001f8e:	ffffe097          	auipc	ra,0xffffe
    80001f92:	3b0080e7          	jalr	944(ra) # 8000033e <strlen>
}
    80001f96:	70a2                	ld	ra,40(sp)
    80001f98:	7402                	ld	s0,32(sp)
    80001f9a:	64e2                	ld	s1,24(sp)
    80001f9c:	6942                	ld	s2,16(sp)
    80001f9e:	69a2                	ld	s3,8(sp)
    80001fa0:	6145                	addi	sp,sp,48
    80001fa2:	8082                	ret

0000000080001fa4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fa4:	1101                	addi	sp,sp,-32
    80001fa6:	ec06                	sd	ra,24(sp)
    80001fa8:	e822                	sd	s0,16(sp)
    80001faa:	e426                	sd	s1,8(sp)
    80001fac:	1000                	addi	s0,sp,32
    80001fae:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	ef2080e7          	jalr	-270(ra) # 80001ea2 <argraw>
    80001fb8:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fba:	4501                	li	a0,0
    80001fbc:	60e2                	ld	ra,24(sp)
    80001fbe:	6442                	ld	s0,16(sp)
    80001fc0:	64a2                	ld	s1,8(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret

0000000080001fc6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	1000                	addi	s0,sp,32
    80001fd0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd2:	00000097          	auipc	ra,0x0
    80001fd6:	ed0080e7          	jalr	-304(ra) # 80001ea2 <argraw>
    80001fda:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fdc:	4501                	li	a0,0
    80001fde:	60e2                	ld	ra,24(sp)
    80001fe0:	6442                	ld	s0,16(sp)
    80001fe2:	64a2                	ld	s1,8(sp)
    80001fe4:	6105                	addi	sp,sp,32
    80001fe6:	8082                	ret

0000000080001fe8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fe8:	1101                	addi	sp,sp,-32
    80001fea:	ec06                	sd	ra,24(sp)
    80001fec:	e822                	sd	s0,16(sp)
    80001fee:	e426                	sd	s1,8(sp)
    80001ff0:	e04a                	sd	s2,0(sp)
    80001ff2:	1000                	addi	s0,sp,32
    80001ff4:	84ae                	mv	s1,a1
    80001ff6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	eaa080e7          	jalr	-342(ra) # 80001ea2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002000:	864a                	mv	a2,s2
    80002002:	85a6                	mv	a1,s1
    80002004:	00000097          	auipc	ra,0x0
    80002008:	f58080e7          	jalr	-168(ra) # 80001f5c <fetchstr>
}
    8000200c:	60e2                	ld	ra,24(sp)
    8000200e:	6442                	ld	s0,16(sp)
    80002010:	64a2                	ld	s1,8(sp)
    80002012:	6902                	ld	s2,0(sp)
    80002014:	6105                	addi	sp,sp,32
    80002016:	8082                	ret

0000000080002018 <syscall>:
  "sysinfo",
};

void
syscall(void)
{
    80002018:	7179                	addi	sp,sp,-48
    8000201a:	f406                	sd	ra,40(sp)
    8000201c:	f022                	sd	s0,32(sp)
    8000201e:	ec26                	sd	s1,24(sp)
    80002020:	e84a                	sd	s2,16(sp)
    80002022:	e44e                	sd	s3,8(sp)
    80002024:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002026:	fffff097          	auipc	ra,0xfffff
    8000202a:	e66080e7          	jalr	-410(ra) # 80000e8c <myproc>
    8000202e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002030:	05853903          	ld	s2,88(a0)
    80002034:	0a893783          	ld	a5,168(s2)
    80002038:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000203c:	37fd                	addiw	a5,a5,-1
    8000203e:	4759                	li	a4,22
    80002040:	04f76863          	bltu	a4,a5,80002090 <syscall+0x78>
    80002044:	00399713          	slli	a4,s3,0x3
    80002048:	00006797          	auipc	a5,0x6
    8000204c:	7c078793          	addi	a5,a5,1984 # 80008808 <syscalls>
    80002050:	97ba                	add	a5,a5,a4
    80002052:	639c                	ld	a5,0(a5)
    80002054:	cf95                	beqz	a5,80002090 <syscall+0x78>
    p->trapframe->a0 = syscalls[num]();
    80002056:	9782                	jalr	a5
    80002058:	06a93823          	sd	a0,112(s2)
    if (p->tracemask >> num & 1)
    8000205c:	1684a783          	lw	a5,360(s1)
    80002060:	4137d7bb          	sraw	a5,a5,s3
    80002064:	8b85                	andi	a5,a5,1
    80002066:	c7a1                	beqz	a5,800020ae <syscall+0x96>
    {
      printf("%d: syscall %s -> %d\n",
    80002068:	6cb8                	ld	a4,88(s1)
    8000206a:	098e                	slli	s3,s3,0x3
    8000206c:	00007797          	auipc	a5,0x7
    80002070:	8bc78793          	addi	a5,a5,-1860 # 80008928 <syscallnames>
    80002074:	99be                	add	s3,s3,a5
    80002076:	7b34                	ld	a3,112(a4)
    80002078:	0009b603          	ld	a2,0(s3)
    8000207c:	588c                	lw	a1,48(s1)
    8000207e:	00006517          	auipc	a0,0x6
    80002082:	2e250513          	addi	a0,a0,738 # 80008360 <etext+0x360>
    80002086:	00004097          	auipc	ra,0x4
    8000208a:	c08080e7          	jalr	-1016(ra) # 80005c8e <printf>
    8000208e:	a005                	j	800020ae <syscall+0x96>
      p->pid, syscallnames[num], p->trapframe->a0);
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002090:	86ce                	mv	a3,s3
    80002092:	15848613          	addi	a2,s1,344
    80002096:	588c                	lw	a1,48(s1)
    80002098:	00006517          	auipc	a0,0x6
    8000209c:	2e050513          	addi	a0,a0,736 # 80008378 <etext+0x378>
    800020a0:	00004097          	auipc	ra,0x4
    800020a4:	bee080e7          	jalr	-1042(ra) # 80005c8e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020a8:	6cbc                	ld	a5,88(s1)
    800020aa:	577d                	li	a4,-1
    800020ac:	fbb8                	sd	a4,112(a5)
  }
}
    800020ae:	70a2                	ld	ra,40(sp)
    800020b0:	7402                	ld	s0,32(sp)
    800020b2:	64e2                	ld	s1,24(sp)
    800020b4:	6942                	ld	s2,16(sp)
    800020b6:	69a2                	ld	s3,8(sp)
    800020b8:	6145                	addi	sp,sp,48
    800020ba:	8082                	ret

00000000800020bc <sys_exit>:
extern int getnproc(void);
extern int getfreemem(void);

uint64
sys_exit(void)
{
    800020bc:	1101                	addi	sp,sp,-32
    800020be:	ec06                	sd	ra,24(sp)
    800020c0:	e822                	sd	s0,16(sp)
    800020c2:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020c4:	fec40593          	addi	a1,s0,-20
    800020c8:	4501                	li	a0,0
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	eda080e7          	jalr	-294(ra) # 80001fa4 <argint>
    return -1;
    800020d2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d4:	00054963          	bltz	a0,800020e6 <sys_exit+0x2a>
  exit(n);
    800020d8:	fec42503          	lw	a0,-20(s0)
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	6d4080e7          	jalr	1748(ra) # 800017b0 <exit>
  return 0;  // not reached
    800020e4:	4781                	li	a5,0
}
    800020e6:	853e                	mv	a0,a5
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	6105                	addi	sp,sp,32
    800020ee:	8082                	ret

00000000800020f0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020f0:	1141                	addi	sp,sp,-16
    800020f2:	e406                	sd	ra,8(sp)
    800020f4:	e022                	sd	s0,0(sp)
    800020f6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	d94080e7          	jalr	-620(ra) # 80000e8c <myproc>
}
    80002100:	5908                	lw	a0,48(a0)
    80002102:	60a2                	ld	ra,8(sp)
    80002104:	6402                	ld	s0,0(sp)
    80002106:	0141                	addi	sp,sp,16
    80002108:	8082                	ret

000000008000210a <sys_fork>:

uint64
sys_fork(void)
{
    8000210a:	1141                	addi	sp,sp,-16
    8000210c:	e406                	sd	ra,8(sp)
    8000210e:	e022                	sd	s0,0(sp)
    80002110:	0800                	addi	s0,sp,16
  return fork();
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	148080e7          	jalr	328(ra) # 8000125a <fork>
}
    8000211a:	60a2                	ld	ra,8(sp)
    8000211c:	6402                	ld	s0,0(sp)
    8000211e:	0141                	addi	sp,sp,16
    80002120:	8082                	ret

0000000080002122 <sys_wait>:

uint64
sys_wait(void)
{
    80002122:	1101                	addi	sp,sp,-32
    80002124:	ec06                	sd	ra,24(sp)
    80002126:	e822                	sd	s0,16(sp)
    80002128:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000212a:	fe840593          	addi	a1,s0,-24
    8000212e:	4501                	li	a0,0
    80002130:	00000097          	auipc	ra,0x0
    80002134:	e96080e7          	jalr	-362(ra) # 80001fc6 <argaddr>
    80002138:	87aa                	mv	a5,a0
    return -1;
    8000213a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000213c:	0007c863          	bltz	a5,8000214c <sys_wait+0x2a>
  return wait(p);
    80002140:	fe843503          	ld	a0,-24(s0)
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	474080e7          	jalr	1140(ra) # 800015b8 <wait>
}
    8000214c:	60e2                	ld	ra,24(sp)
    8000214e:	6442                	ld	s0,16(sp)
    80002150:	6105                	addi	sp,sp,32
    80002152:	8082                	ret

0000000080002154 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002154:	7179                	addi	sp,sp,-48
    80002156:	f406                	sd	ra,40(sp)
    80002158:	f022                	sd	s0,32(sp)
    8000215a:	ec26                	sd	s1,24(sp)
    8000215c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000215e:	fdc40593          	addi	a1,s0,-36
    80002162:	4501                	li	a0,0
    80002164:	00000097          	auipc	ra,0x0
    80002168:	e40080e7          	jalr	-448(ra) # 80001fa4 <argint>
    return -1;
    8000216c:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    8000216e:	00054f63          	bltz	a0,8000218c <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	d1a080e7          	jalr	-742(ra) # 80000e8c <myproc>
    8000217a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000217c:	fdc42503          	lw	a0,-36(s0)
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	066080e7          	jalr	102(ra) # 800011e6 <growproc>
    80002188:	00054863          	bltz	a0,80002198 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    8000218c:	8526                	mv	a0,s1
    8000218e:	70a2                	ld	ra,40(sp)
    80002190:	7402                	ld	s0,32(sp)
    80002192:	64e2                	ld	s1,24(sp)
    80002194:	6145                	addi	sp,sp,48
    80002196:	8082                	ret
    return -1;
    80002198:	54fd                	li	s1,-1
    8000219a:	bfcd                	j	8000218c <sys_sbrk+0x38>

000000008000219c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000219c:	7139                	addi	sp,sp,-64
    8000219e:	fc06                	sd	ra,56(sp)
    800021a0:	f822                	sd	s0,48(sp)
    800021a2:	f426                	sd	s1,40(sp)
    800021a4:	f04a                	sd	s2,32(sp)
    800021a6:	ec4e                	sd	s3,24(sp)
    800021a8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021aa:	fcc40593          	addi	a1,s0,-52
    800021ae:	4501                	li	a0,0
    800021b0:	00000097          	auipc	ra,0x0
    800021b4:	df4080e7          	jalr	-524(ra) # 80001fa4 <argint>
    return -1;
    800021b8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ba:	06054563          	bltz	a0,80002224 <sys_sleep+0x88>
  acquire(&tickslock);
    800021be:	0000d517          	auipc	a0,0xd
    800021c2:	ec250513          	addi	a0,a0,-318 # 8000f080 <tickslock>
    800021c6:	00004097          	auipc	ra,0x4
    800021ca:	fba080e7          	jalr	-70(ra) # 80006180 <acquire>
  ticks0 = ticks;
    800021ce:	00007917          	auipc	s2,0x7
    800021d2:	e4a92903          	lw	s2,-438(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021d6:	fcc42783          	lw	a5,-52(s0)
    800021da:	cf85                	beqz	a5,80002212 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021dc:	0000d997          	auipc	s3,0xd
    800021e0:	ea498993          	addi	s3,s3,-348 # 8000f080 <tickslock>
    800021e4:	00007497          	auipc	s1,0x7
    800021e8:	e3448493          	addi	s1,s1,-460 # 80009018 <ticks>
    if(myproc()->killed){
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	ca0080e7          	jalr	-864(ra) # 80000e8c <myproc>
    800021f4:	551c                	lw	a5,40(a0)
    800021f6:	ef9d                	bnez	a5,80002234 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021f8:	85ce                	mv	a1,s3
    800021fa:	8526                	mv	a0,s1
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	358080e7          	jalr	856(ra) # 80001554 <sleep>
  while(ticks - ticks0 < n){
    80002204:	409c                	lw	a5,0(s1)
    80002206:	412787bb          	subw	a5,a5,s2
    8000220a:	fcc42703          	lw	a4,-52(s0)
    8000220e:	fce7efe3          	bltu	a5,a4,800021ec <sys_sleep+0x50>
  }
  release(&tickslock);
    80002212:	0000d517          	auipc	a0,0xd
    80002216:	e6e50513          	addi	a0,a0,-402 # 8000f080 <tickslock>
    8000221a:	00004097          	auipc	ra,0x4
    8000221e:	01a080e7          	jalr	26(ra) # 80006234 <release>
  return 0;
    80002222:	4781                	li	a5,0
}
    80002224:	853e                	mv	a0,a5
    80002226:	70e2                	ld	ra,56(sp)
    80002228:	7442                	ld	s0,48(sp)
    8000222a:	74a2                	ld	s1,40(sp)
    8000222c:	7902                	ld	s2,32(sp)
    8000222e:	69e2                	ld	s3,24(sp)
    80002230:	6121                	addi	sp,sp,64
    80002232:	8082                	ret
      release(&tickslock);
    80002234:	0000d517          	auipc	a0,0xd
    80002238:	e4c50513          	addi	a0,a0,-436 # 8000f080 <tickslock>
    8000223c:	00004097          	auipc	ra,0x4
    80002240:	ff8080e7          	jalr	-8(ra) # 80006234 <release>
      return -1;
    80002244:	57fd                	li	a5,-1
    80002246:	bff9                	j	80002224 <sys_sleep+0x88>

0000000080002248 <sys_kill>:

uint64
sys_kill(void)
{
    80002248:	1101                	addi	sp,sp,-32
    8000224a:	ec06                	sd	ra,24(sp)
    8000224c:	e822                	sd	s0,16(sp)
    8000224e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002250:	fec40593          	addi	a1,s0,-20
    80002254:	4501                	li	a0,0
    80002256:	00000097          	auipc	ra,0x0
    8000225a:	d4e080e7          	jalr	-690(ra) # 80001fa4 <argint>
    8000225e:	87aa                	mv	a5,a0
    return -1;
    80002260:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002262:	0007c863          	bltz	a5,80002272 <sys_kill+0x2a>
  return kill(pid);
    80002266:	fec42503          	lw	a0,-20(s0)
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	61c080e7          	jalr	1564(ra) # 80001886 <kill>
}
    80002272:	60e2                	ld	ra,24(sp)
    80002274:	6442                	ld	s0,16(sp)
    80002276:	6105                	addi	sp,sp,32
    80002278:	8082                	ret

000000008000227a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000227a:	1101                	addi	sp,sp,-32
    8000227c:	ec06                	sd	ra,24(sp)
    8000227e:	e822                	sd	s0,16(sp)
    80002280:	e426                	sd	s1,8(sp)
    80002282:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002284:	0000d517          	auipc	a0,0xd
    80002288:	dfc50513          	addi	a0,a0,-516 # 8000f080 <tickslock>
    8000228c:	00004097          	auipc	ra,0x4
    80002290:	ef4080e7          	jalr	-268(ra) # 80006180 <acquire>
  xticks = ticks;
    80002294:	00007497          	auipc	s1,0x7
    80002298:	d844a483          	lw	s1,-636(s1) # 80009018 <ticks>
  release(&tickslock);
    8000229c:	0000d517          	auipc	a0,0xd
    800022a0:	de450513          	addi	a0,a0,-540 # 8000f080 <tickslock>
    800022a4:	00004097          	auipc	ra,0x4
    800022a8:	f90080e7          	jalr	-112(ra) # 80006234 <release>
  return xticks;
}
    800022ac:	02049513          	slli	a0,s1,0x20
    800022b0:	9101                	srli	a0,a0,0x20
    800022b2:	60e2                	ld	ra,24(sp)
    800022b4:	6442                	ld	s0,16(sp)
    800022b6:	64a2                	ld	s1,8(sp)
    800022b8:	6105                	addi	sp,sp,32
    800022ba:	8082                	ret

00000000800022bc <sys_trace>:

uint64
sys_trace(void)
{
    800022bc:	1101                	addi	sp,sp,-32
    800022be:	ec06                	sd	ra,24(sp)
    800022c0:	e822                	sd	s0,16(sp)
    800022c2:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask); // 从用户空间获取 trace 参数
    800022c4:	fec40593          	addi	a1,s0,-20
    800022c8:	4501                	li	a0,0
    800022ca:	00000097          	auipc	ra,0x0
    800022ce:	cda080e7          	jalr	-806(ra) # 80001fa4 <argint>
  myproc()->tracemask = mask; // 将 trace 参数保存到当前进程的进程控制块中
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	bba080e7          	jalr	-1094(ra) # 80000e8c <myproc>
    800022da:	fec42783          	lw	a5,-20(s0)
    800022de:	16f52423          	sw	a5,360(a0)
  return 0; // 返回 0 表示系统调用执行成功
}
    800022e2:	4501                	li	a0,0
    800022e4:	60e2                	ld	ra,24(sp)
    800022e6:	6442                	ld	s0,16(sp)
    800022e8:	6105                	addi	sp,sp,32
    800022ea:	8082                	ret

00000000800022ec <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    800022ec:	7139                	addi	sp,sp,-64
    800022ee:	fc06                	sd	ra,56(sp)
    800022f0:	f822                	sd	s0,48(sp)
    800022f2:	f426                	sd	s1,40(sp)
    800022f4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	b96080e7          	jalr	-1130(ra) # 80000e8c <myproc>
    800022fe:	84aa                	mv	s1,a0
  struct sysinfo st;
  uint64 addr; // user pointer to struct stat
  st.freemem = getfreemem();
    80002300:	ffffe097          	auipc	ra,0xffffe
    80002304:	e78080e7          	jalr	-392(ra) # 80000178 <getfreemem>
    80002308:	fca43823          	sd	a0,-48(s0)
  st.nproc = getnproc();
    8000230c:	fffff097          	auipc	ra,0xfffff
    80002310:	746080e7          	jalr	1862(ra) # 80001a52 <getnproc>
    80002314:	fca43c23          	sd	a0,-40(s0)
  if (argaddr(0, &addr) < 0)
    80002318:	fc840593          	addi	a1,s0,-56
    8000231c:	4501                	li	a0,0
    8000231e:	00000097          	auipc	ra,0x0
    80002322:	ca8080e7          	jalr	-856(ra) # 80001fc6 <argaddr>
      return -1;
    80002326:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0)
    80002328:	00054e63          	bltz	a0,80002344 <sys_sysinfo+0x58>
  if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000232c:	46c1                	li	a3,16
    8000232e:	fd040613          	addi	a2,s0,-48
    80002332:	fc843583          	ld	a1,-56(s0)
    80002336:	68a8                	ld	a0,80(s1)
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	814080e7          	jalr	-2028(ra) # 80000b4c <copyout>
    80002340:	43f55793          	srai	a5,a0,0x3f
      return -1;
  return 0;
}
    80002344:	853e                	mv	a0,a5
    80002346:	70e2                	ld	ra,56(sp)
    80002348:	7442                	ld	s0,48(sp)
    8000234a:	74a2                	ld	s1,40(sp)
    8000234c:	6121                	addi	sp,sp,64
    8000234e:	8082                	ret

0000000080002350 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002350:	7179                	addi	sp,sp,-48
    80002352:	f406                	sd	ra,40(sp)
    80002354:	f022                	sd	s0,32(sp)
    80002356:	ec26                	sd	s1,24(sp)
    80002358:	e84a                	sd	s2,16(sp)
    8000235a:	e44e                	sd	s3,8(sp)
    8000235c:	e052                	sd	s4,0(sp)
    8000235e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002360:	00006597          	auipc	a1,0x6
    80002364:	0e858593          	addi	a1,a1,232 # 80008448 <etext+0x448>
    80002368:	0000d517          	auipc	a0,0xd
    8000236c:	d3050513          	addi	a0,a0,-720 # 8000f098 <bcache>
    80002370:	00004097          	auipc	ra,0x4
    80002374:	d80080e7          	jalr	-640(ra) # 800060f0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002378:	00015797          	auipc	a5,0x15
    8000237c:	d2078793          	addi	a5,a5,-736 # 80017098 <bcache+0x8000>
    80002380:	00015717          	auipc	a4,0x15
    80002384:	f8070713          	addi	a4,a4,-128 # 80017300 <bcache+0x8268>
    80002388:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000238c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002390:	0000d497          	auipc	s1,0xd
    80002394:	d2048493          	addi	s1,s1,-736 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002398:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000239a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000239c:	00006a17          	auipc	s4,0x6
    800023a0:	0b4a0a13          	addi	s4,s4,180 # 80008450 <etext+0x450>
    b->next = bcache.head.next;
    800023a4:	2b893783          	ld	a5,696(s2)
    800023a8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023aa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023ae:	85d2                	mv	a1,s4
    800023b0:	01048513          	addi	a0,s1,16
    800023b4:	00001097          	auipc	ra,0x1
    800023b8:	4bc080e7          	jalr	1212(ra) # 80003870 <initsleeplock>
    bcache.head.next->prev = b;
    800023bc:	2b893783          	ld	a5,696(s2)
    800023c0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023c2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023c6:	45848493          	addi	s1,s1,1112
    800023ca:	fd349de3          	bne	s1,s3,800023a4 <binit+0x54>
  }
}
    800023ce:	70a2                	ld	ra,40(sp)
    800023d0:	7402                	ld	s0,32(sp)
    800023d2:	64e2                	ld	s1,24(sp)
    800023d4:	6942                	ld	s2,16(sp)
    800023d6:	69a2                	ld	s3,8(sp)
    800023d8:	6a02                	ld	s4,0(sp)
    800023da:	6145                	addi	sp,sp,48
    800023dc:	8082                	ret

00000000800023de <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023de:	7179                	addi	sp,sp,-48
    800023e0:	f406                	sd	ra,40(sp)
    800023e2:	f022                	sd	s0,32(sp)
    800023e4:	ec26                	sd	s1,24(sp)
    800023e6:	e84a                	sd	s2,16(sp)
    800023e8:	e44e                	sd	s3,8(sp)
    800023ea:	1800                	addi	s0,sp,48
    800023ec:	892a                	mv	s2,a0
    800023ee:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023f0:	0000d517          	auipc	a0,0xd
    800023f4:	ca850513          	addi	a0,a0,-856 # 8000f098 <bcache>
    800023f8:	00004097          	auipc	ra,0x4
    800023fc:	d88080e7          	jalr	-632(ra) # 80006180 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002400:	00015497          	auipc	s1,0x15
    80002404:	f504b483          	ld	s1,-176(s1) # 80017350 <bcache+0x82b8>
    80002408:	00015797          	auipc	a5,0x15
    8000240c:	ef878793          	addi	a5,a5,-264 # 80017300 <bcache+0x8268>
    80002410:	02f48f63          	beq	s1,a5,8000244e <bread+0x70>
    80002414:	873e                	mv	a4,a5
    80002416:	a021                	j	8000241e <bread+0x40>
    80002418:	68a4                	ld	s1,80(s1)
    8000241a:	02e48a63          	beq	s1,a4,8000244e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000241e:	449c                	lw	a5,8(s1)
    80002420:	ff279ce3          	bne	a5,s2,80002418 <bread+0x3a>
    80002424:	44dc                	lw	a5,12(s1)
    80002426:	ff3799e3          	bne	a5,s3,80002418 <bread+0x3a>
      b->refcnt++;
    8000242a:	40bc                	lw	a5,64(s1)
    8000242c:	2785                	addiw	a5,a5,1
    8000242e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002430:	0000d517          	auipc	a0,0xd
    80002434:	c6850513          	addi	a0,a0,-920 # 8000f098 <bcache>
    80002438:	00004097          	auipc	ra,0x4
    8000243c:	dfc080e7          	jalr	-516(ra) # 80006234 <release>
      acquiresleep(&b->lock);
    80002440:	01048513          	addi	a0,s1,16
    80002444:	00001097          	auipc	ra,0x1
    80002448:	466080e7          	jalr	1126(ra) # 800038aa <acquiresleep>
      return b;
    8000244c:	a8b9                	j	800024aa <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000244e:	00015497          	auipc	s1,0x15
    80002452:	efa4b483          	ld	s1,-262(s1) # 80017348 <bcache+0x82b0>
    80002456:	00015797          	auipc	a5,0x15
    8000245a:	eaa78793          	addi	a5,a5,-342 # 80017300 <bcache+0x8268>
    8000245e:	00f48863          	beq	s1,a5,8000246e <bread+0x90>
    80002462:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002464:	40bc                	lw	a5,64(s1)
    80002466:	cf81                	beqz	a5,8000247e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002468:	64a4                	ld	s1,72(s1)
    8000246a:	fee49de3          	bne	s1,a4,80002464 <bread+0x86>
  panic("bget: no buffers");
    8000246e:	00006517          	auipc	a0,0x6
    80002472:	fea50513          	addi	a0,a0,-22 # 80008458 <etext+0x458>
    80002476:	00003097          	auipc	ra,0x3
    8000247a:	7ce080e7          	jalr	1998(ra) # 80005c44 <panic>
      b->dev = dev;
    8000247e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002482:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002486:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000248a:	4785                	li	a5,1
    8000248c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000248e:	0000d517          	auipc	a0,0xd
    80002492:	c0a50513          	addi	a0,a0,-1014 # 8000f098 <bcache>
    80002496:	00004097          	auipc	ra,0x4
    8000249a:	d9e080e7          	jalr	-610(ra) # 80006234 <release>
      acquiresleep(&b->lock);
    8000249e:	01048513          	addi	a0,s1,16
    800024a2:	00001097          	auipc	ra,0x1
    800024a6:	408080e7          	jalr	1032(ra) # 800038aa <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024aa:	409c                	lw	a5,0(s1)
    800024ac:	cb89                	beqz	a5,800024be <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024ae:	8526                	mv	a0,s1
    800024b0:	70a2                	ld	ra,40(sp)
    800024b2:	7402                	ld	s0,32(sp)
    800024b4:	64e2                	ld	s1,24(sp)
    800024b6:	6942                	ld	s2,16(sp)
    800024b8:	69a2                	ld	s3,8(sp)
    800024ba:	6145                	addi	sp,sp,48
    800024bc:	8082                	ret
    virtio_disk_rw(b, 0);
    800024be:	4581                	li	a1,0
    800024c0:	8526                	mv	a0,s1
    800024c2:	00003097          	auipc	ra,0x3
    800024c6:	f14080e7          	jalr	-236(ra) # 800053d6 <virtio_disk_rw>
    b->valid = 1;
    800024ca:	4785                	li	a5,1
    800024cc:	c09c                	sw	a5,0(s1)
  return b;
    800024ce:	b7c5                	j	800024ae <bread+0xd0>

00000000800024d0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024d0:	1101                	addi	sp,sp,-32
    800024d2:	ec06                	sd	ra,24(sp)
    800024d4:	e822                	sd	s0,16(sp)
    800024d6:	e426                	sd	s1,8(sp)
    800024d8:	1000                	addi	s0,sp,32
    800024da:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024dc:	0541                	addi	a0,a0,16
    800024de:	00001097          	auipc	ra,0x1
    800024e2:	466080e7          	jalr	1126(ra) # 80003944 <holdingsleep>
    800024e6:	cd01                	beqz	a0,800024fe <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024e8:	4585                	li	a1,1
    800024ea:	8526                	mv	a0,s1
    800024ec:	00003097          	auipc	ra,0x3
    800024f0:	eea080e7          	jalr	-278(ra) # 800053d6 <virtio_disk_rw>
}
    800024f4:	60e2                	ld	ra,24(sp)
    800024f6:	6442                	ld	s0,16(sp)
    800024f8:	64a2                	ld	s1,8(sp)
    800024fa:	6105                	addi	sp,sp,32
    800024fc:	8082                	ret
    panic("bwrite");
    800024fe:	00006517          	auipc	a0,0x6
    80002502:	f7250513          	addi	a0,a0,-142 # 80008470 <etext+0x470>
    80002506:	00003097          	auipc	ra,0x3
    8000250a:	73e080e7          	jalr	1854(ra) # 80005c44 <panic>

000000008000250e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000250e:	1101                	addi	sp,sp,-32
    80002510:	ec06                	sd	ra,24(sp)
    80002512:	e822                	sd	s0,16(sp)
    80002514:	e426                	sd	s1,8(sp)
    80002516:	e04a                	sd	s2,0(sp)
    80002518:	1000                	addi	s0,sp,32
    8000251a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000251c:	01050913          	addi	s2,a0,16
    80002520:	854a                	mv	a0,s2
    80002522:	00001097          	auipc	ra,0x1
    80002526:	422080e7          	jalr	1058(ra) # 80003944 <holdingsleep>
    8000252a:	c92d                	beqz	a0,8000259c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000252c:	854a                	mv	a0,s2
    8000252e:	00001097          	auipc	ra,0x1
    80002532:	3d2080e7          	jalr	978(ra) # 80003900 <releasesleep>

  acquire(&bcache.lock);
    80002536:	0000d517          	auipc	a0,0xd
    8000253a:	b6250513          	addi	a0,a0,-1182 # 8000f098 <bcache>
    8000253e:	00004097          	auipc	ra,0x4
    80002542:	c42080e7          	jalr	-958(ra) # 80006180 <acquire>
  b->refcnt--;
    80002546:	40bc                	lw	a5,64(s1)
    80002548:	37fd                	addiw	a5,a5,-1
    8000254a:	0007871b          	sext.w	a4,a5
    8000254e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002550:	eb05                	bnez	a4,80002580 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002552:	68bc                	ld	a5,80(s1)
    80002554:	64b8                	ld	a4,72(s1)
    80002556:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002558:	64bc                	ld	a5,72(s1)
    8000255a:	68b8                	ld	a4,80(s1)
    8000255c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000255e:	00015797          	auipc	a5,0x15
    80002562:	b3a78793          	addi	a5,a5,-1222 # 80017098 <bcache+0x8000>
    80002566:	2b87b703          	ld	a4,696(a5)
    8000256a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000256c:	00015717          	auipc	a4,0x15
    80002570:	d9470713          	addi	a4,a4,-620 # 80017300 <bcache+0x8268>
    80002574:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002576:	2b87b703          	ld	a4,696(a5)
    8000257a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000257c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002580:	0000d517          	auipc	a0,0xd
    80002584:	b1850513          	addi	a0,a0,-1256 # 8000f098 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	cac080e7          	jalr	-852(ra) # 80006234 <release>
}
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	64a2                	ld	s1,8(sp)
    80002596:	6902                	ld	s2,0(sp)
    80002598:	6105                	addi	sp,sp,32
    8000259a:	8082                	ret
    panic("brelse");
    8000259c:	00006517          	auipc	a0,0x6
    800025a0:	edc50513          	addi	a0,a0,-292 # 80008478 <etext+0x478>
    800025a4:	00003097          	auipc	ra,0x3
    800025a8:	6a0080e7          	jalr	1696(ra) # 80005c44 <panic>

00000000800025ac <bpin>:

void
bpin(struct buf *b) {
    800025ac:	1101                	addi	sp,sp,-32
    800025ae:	ec06                	sd	ra,24(sp)
    800025b0:	e822                	sd	s0,16(sp)
    800025b2:	e426                	sd	s1,8(sp)
    800025b4:	1000                	addi	s0,sp,32
    800025b6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b8:	0000d517          	auipc	a0,0xd
    800025bc:	ae050513          	addi	a0,a0,-1312 # 8000f098 <bcache>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	bc0080e7          	jalr	-1088(ra) # 80006180 <acquire>
  b->refcnt++;
    800025c8:	40bc                	lw	a5,64(s1)
    800025ca:	2785                	addiw	a5,a5,1
    800025cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ce:	0000d517          	auipc	a0,0xd
    800025d2:	aca50513          	addi	a0,a0,-1334 # 8000f098 <bcache>
    800025d6:	00004097          	auipc	ra,0x4
    800025da:	c5e080e7          	jalr	-930(ra) # 80006234 <release>
}
    800025de:	60e2                	ld	ra,24(sp)
    800025e0:	6442                	ld	s0,16(sp)
    800025e2:	64a2                	ld	s1,8(sp)
    800025e4:	6105                	addi	sp,sp,32
    800025e6:	8082                	ret

00000000800025e8 <bunpin>:

void
bunpin(struct buf *b) {
    800025e8:	1101                	addi	sp,sp,-32
    800025ea:	ec06                	sd	ra,24(sp)
    800025ec:	e822                	sd	s0,16(sp)
    800025ee:	e426                	sd	s1,8(sp)
    800025f0:	1000                	addi	s0,sp,32
    800025f2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f4:	0000d517          	auipc	a0,0xd
    800025f8:	aa450513          	addi	a0,a0,-1372 # 8000f098 <bcache>
    800025fc:	00004097          	auipc	ra,0x4
    80002600:	b84080e7          	jalr	-1148(ra) # 80006180 <acquire>
  b->refcnt--;
    80002604:	40bc                	lw	a5,64(s1)
    80002606:	37fd                	addiw	a5,a5,-1
    80002608:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260a:	0000d517          	auipc	a0,0xd
    8000260e:	a8e50513          	addi	a0,a0,-1394 # 8000f098 <bcache>
    80002612:	00004097          	auipc	ra,0x4
    80002616:	c22080e7          	jalr	-990(ra) # 80006234 <release>
}
    8000261a:	60e2                	ld	ra,24(sp)
    8000261c:	6442                	ld	s0,16(sp)
    8000261e:	64a2                	ld	s1,8(sp)
    80002620:	6105                	addi	sp,sp,32
    80002622:	8082                	ret

0000000080002624 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002624:	1101                	addi	sp,sp,-32
    80002626:	ec06                	sd	ra,24(sp)
    80002628:	e822                	sd	s0,16(sp)
    8000262a:	e426                	sd	s1,8(sp)
    8000262c:	e04a                	sd	s2,0(sp)
    8000262e:	1000                	addi	s0,sp,32
    80002630:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002632:	00d5d59b          	srliw	a1,a1,0xd
    80002636:	00015797          	auipc	a5,0x15
    8000263a:	13e7a783          	lw	a5,318(a5) # 80017774 <sb+0x1c>
    8000263e:	9dbd                	addw	a1,a1,a5
    80002640:	00000097          	auipc	ra,0x0
    80002644:	d9e080e7          	jalr	-610(ra) # 800023de <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002648:	0074f713          	andi	a4,s1,7
    8000264c:	4785                	li	a5,1
    8000264e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002652:	14ce                	slli	s1,s1,0x33
    80002654:	90d9                	srli	s1,s1,0x36
    80002656:	00950733          	add	a4,a0,s1
    8000265a:	05874703          	lbu	a4,88(a4)
    8000265e:	00e7f6b3          	and	a3,a5,a4
    80002662:	c69d                	beqz	a3,80002690 <bfree+0x6c>
    80002664:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002666:	94aa                	add	s1,s1,a0
    80002668:	fff7c793          	not	a5,a5
    8000266c:	8ff9                	and	a5,a5,a4
    8000266e:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002672:	00001097          	auipc	ra,0x1
    80002676:	118080e7          	jalr	280(ra) # 8000378a <log_write>
  brelse(bp);
    8000267a:	854a                	mv	a0,s2
    8000267c:	00000097          	auipc	ra,0x0
    80002680:	e92080e7          	jalr	-366(ra) # 8000250e <brelse>
}
    80002684:	60e2                	ld	ra,24(sp)
    80002686:	6442                	ld	s0,16(sp)
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	6902                	ld	s2,0(sp)
    8000268c:	6105                	addi	sp,sp,32
    8000268e:	8082                	ret
    panic("freeing free block");
    80002690:	00006517          	auipc	a0,0x6
    80002694:	df050513          	addi	a0,a0,-528 # 80008480 <etext+0x480>
    80002698:	00003097          	auipc	ra,0x3
    8000269c:	5ac080e7          	jalr	1452(ra) # 80005c44 <panic>

00000000800026a0 <balloc>:
{
    800026a0:	711d                	addi	sp,sp,-96
    800026a2:	ec86                	sd	ra,88(sp)
    800026a4:	e8a2                	sd	s0,80(sp)
    800026a6:	e4a6                	sd	s1,72(sp)
    800026a8:	e0ca                	sd	s2,64(sp)
    800026aa:	fc4e                	sd	s3,56(sp)
    800026ac:	f852                	sd	s4,48(sp)
    800026ae:	f456                	sd	s5,40(sp)
    800026b0:	f05a                	sd	s6,32(sp)
    800026b2:	ec5e                	sd	s7,24(sp)
    800026b4:	e862                	sd	s8,16(sp)
    800026b6:	e466                	sd	s9,8(sp)
    800026b8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026ba:	00015797          	auipc	a5,0x15
    800026be:	0a27a783          	lw	a5,162(a5) # 8001775c <sb+0x4>
    800026c2:	cbd1                	beqz	a5,80002756 <balloc+0xb6>
    800026c4:	8baa                	mv	s7,a0
    800026c6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026c8:	00015b17          	auipc	s6,0x15
    800026cc:	090b0b13          	addi	s6,s6,144 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026d2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026d6:	6c89                	lui	s9,0x2
    800026d8:	a831                	j	800026f4 <balloc+0x54>
    brelse(bp);
    800026da:	854a                	mv	a0,s2
    800026dc:	00000097          	auipc	ra,0x0
    800026e0:	e32080e7          	jalr	-462(ra) # 8000250e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026e4:	015c87bb          	addw	a5,s9,s5
    800026e8:	00078a9b          	sext.w	s5,a5
    800026ec:	004b2703          	lw	a4,4(s6)
    800026f0:	06eaf363          	bgeu	s5,a4,80002756 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026f4:	41fad79b          	sraiw	a5,s5,0x1f
    800026f8:	0137d79b          	srliw	a5,a5,0x13
    800026fc:	015787bb          	addw	a5,a5,s5
    80002700:	40d7d79b          	sraiw	a5,a5,0xd
    80002704:	01cb2583          	lw	a1,28(s6)
    80002708:	9dbd                	addw	a1,a1,a5
    8000270a:	855e                	mv	a0,s7
    8000270c:	00000097          	auipc	ra,0x0
    80002710:	cd2080e7          	jalr	-814(ra) # 800023de <bread>
    80002714:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002716:	004b2503          	lw	a0,4(s6)
    8000271a:	000a849b          	sext.w	s1,s5
    8000271e:	8662                	mv	a2,s8
    80002720:	faa4fde3          	bgeu	s1,a0,800026da <balloc+0x3a>
      m = 1 << (bi % 8);
    80002724:	41f6579b          	sraiw	a5,a2,0x1f
    80002728:	01d7d69b          	srliw	a3,a5,0x1d
    8000272c:	00c6873b          	addw	a4,a3,a2
    80002730:	00777793          	andi	a5,a4,7
    80002734:	9f95                	subw	a5,a5,a3
    80002736:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000273a:	4037571b          	sraiw	a4,a4,0x3
    8000273e:	00e906b3          	add	a3,s2,a4
    80002742:	0586c683          	lbu	a3,88(a3)
    80002746:	00d7f5b3          	and	a1,a5,a3
    8000274a:	cd91                	beqz	a1,80002766 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000274c:	2605                	addiw	a2,a2,1
    8000274e:	2485                	addiw	s1,s1,1
    80002750:	fd4618e3          	bne	a2,s4,80002720 <balloc+0x80>
    80002754:	b759                	j	800026da <balloc+0x3a>
  panic("balloc: out of blocks");
    80002756:	00006517          	auipc	a0,0x6
    8000275a:	d4250513          	addi	a0,a0,-702 # 80008498 <etext+0x498>
    8000275e:	00003097          	auipc	ra,0x3
    80002762:	4e6080e7          	jalr	1254(ra) # 80005c44 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002766:	974a                	add	a4,a4,s2
    80002768:	8fd5                	or	a5,a5,a3
    8000276a:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000276e:	854a                	mv	a0,s2
    80002770:	00001097          	auipc	ra,0x1
    80002774:	01a080e7          	jalr	26(ra) # 8000378a <log_write>
        brelse(bp);
    80002778:	854a                	mv	a0,s2
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	d94080e7          	jalr	-620(ra) # 8000250e <brelse>
  bp = bread(dev, bno);
    80002782:	85a6                	mv	a1,s1
    80002784:	855e                	mv	a0,s7
    80002786:	00000097          	auipc	ra,0x0
    8000278a:	c58080e7          	jalr	-936(ra) # 800023de <bread>
    8000278e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002790:	40000613          	li	a2,1024
    80002794:	4581                	li	a1,0
    80002796:	05850513          	addi	a0,a0,88
    8000279a:	ffffe097          	auipc	ra,0xffffe
    8000279e:	a28080e7          	jalr	-1496(ra) # 800001c2 <memset>
  log_write(bp);
    800027a2:	854a                	mv	a0,s2
    800027a4:	00001097          	auipc	ra,0x1
    800027a8:	fe6080e7          	jalr	-26(ra) # 8000378a <log_write>
  brelse(bp);
    800027ac:	854a                	mv	a0,s2
    800027ae:	00000097          	auipc	ra,0x0
    800027b2:	d60080e7          	jalr	-672(ra) # 8000250e <brelse>
}
    800027b6:	8526                	mv	a0,s1
    800027b8:	60e6                	ld	ra,88(sp)
    800027ba:	6446                	ld	s0,80(sp)
    800027bc:	64a6                	ld	s1,72(sp)
    800027be:	6906                	ld	s2,64(sp)
    800027c0:	79e2                	ld	s3,56(sp)
    800027c2:	7a42                	ld	s4,48(sp)
    800027c4:	7aa2                	ld	s5,40(sp)
    800027c6:	7b02                	ld	s6,32(sp)
    800027c8:	6be2                	ld	s7,24(sp)
    800027ca:	6c42                	ld	s8,16(sp)
    800027cc:	6ca2                	ld	s9,8(sp)
    800027ce:	6125                	addi	sp,sp,96
    800027d0:	8082                	ret

00000000800027d2 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027d2:	7179                	addi	sp,sp,-48
    800027d4:	f406                	sd	ra,40(sp)
    800027d6:	f022                	sd	s0,32(sp)
    800027d8:	ec26                	sd	s1,24(sp)
    800027da:	e84a                	sd	s2,16(sp)
    800027dc:	e44e                	sd	s3,8(sp)
    800027de:	e052                	sd	s4,0(sp)
    800027e0:	1800                	addi	s0,sp,48
    800027e2:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027e4:	47ad                	li	a5,11
    800027e6:	04b7fe63          	bgeu	a5,a1,80002842 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027ea:	ff45849b          	addiw	s1,a1,-12
    800027ee:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027f2:	0ff00793          	li	a5,255
    800027f6:	0ae7e363          	bltu	a5,a4,8000289c <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027fa:	08052583          	lw	a1,128(a0)
    800027fe:	c5ad                	beqz	a1,80002868 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002800:	00092503          	lw	a0,0(s2)
    80002804:	00000097          	auipc	ra,0x0
    80002808:	bda080e7          	jalr	-1062(ra) # 800023de <bread>
    8000280c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000280e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002812:	02049593          	slli	a1,s1,0x20
    80002816:	9181                	srli	a1,a1,0x20
    80002818:	058a                	slli	a1,a1,0x2
    8000281a:	00b784b3          	add	s1,a5,a1
    8000281e:	0004a983          	lw	s3,0(s1)
    80002822:	04098d63          	beqz	s3,8000287c <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002826:	8552                	mv	a0,s4
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	ce6080e7          	jalr	-794(ra) # 8000250e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002830:	854e                	mv	a0,s3
    80002832:	70a2                	ld	ra,40(sp)
    80002834:	7402                	ld	s0,32(sp)
    80002836:	64e2                	ld	s1,24(sp)
    80002838:	6942                	ld	s2,16(sp)
    8000283a:	69a2                	ld	s3,8(sp)
    8000283c:	6a02                	ld	s4,0(sp)
    8000283e:	6145                	addi	sp,sp,48
    80002840:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002842:	02059493          	slli	s1,a1,0x20
    80002846:	9081                	srli	s1,s1,0x20
    80002848:	048a                	slli	s1,s1,0x2
    8000284a:	94aa                	add	s1,s1,a0
    8000284c:	0504a983          	lw	s3,80(s1)
    80002850:	fe0990e3          	bnez	s3,80002830 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002854:	4108                	lw	a0,0(a0)
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	e4a080e7          	jalr	-438(ra) # 800026a0 <balloc>
    8000285e:	0005099b          	sext.w	s3,a0
    80002862:	0534a823          	sw	s3,80(s1)
    80002866:	b7e9                	j	80002830 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002868:	4108                	lw	a0,0(a0)
    8000286a:	00000097          	auipc	ra,0x0
    8000286e:	e36080e7          	jalr	-458(ra) # 800026a0 <balloc>
    80002872:	0005059b          	sext.w	a1,a0
    80002876:	08b92023          	sw	a1,128(s2)
    8000287a:	b759                	j	80002800 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000287c:	00092503          	lw	a0,0(s2)
    80002880:	00000097          	auipc	ra,0x0
    80002884:	e20080e7          	jalr	-480(ra) # 800026a0 <balloc>
    80002888:	0005099b          	sext.w	s3,a0
    8000288c:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002890:	8552                	mv	a0,s4
    80002892:	00001097          	auipc	ra,0x1
    80002896:	ef8080e7          	jalr	-264(ra) # 8000378a <log_write>
    8000289a:	b771                	j	80002826 <bmap+0x54>
  panic("bmap: out of range");
    8000289c:	00006517          	auipc	a0,0x6
    800028a0:	c1450513          	addi	a0,a0,-1004 # 800084b0 <etext+0x4b0>
    800028a4:	00003097          	auipc	ra,0x3
    800028a8:	3a0080e7          	jalr	928(ra) # 80005c44 <panic>

00000000800028ac <iget>:
{
    800028ac:	7179                	addi	sp,sp,-48
    800028ae:	f406                	sd	ra,40(sp)
    800028b0:	f022                	sd	s0,32(sp)
    800028b2:	ec26                	sd	s1,24(sp)
    800028b4:	e84a                	sd	s2,16(sp)
    800028b6:	e44e                	sd	s3,8(sp)
    800028b8:	e052                	sd	s4,0(sp)
    800028ba:	1800                	addi	s0,sp,48
    800028bc:	89aa                	mv	s3,a0
    800028be:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028c0:	00015517          	auipc	a0,0x15
    800028c4:	eb850513          	addi	a0,a0,-328 # 80017778 <itable>
    800028c8:	00004097          	auipc	ra,0x4
    800028cc:	8b8080e7          	jalr	-1864(ra) # 80006180 <acquire>
  empty = 0;
    800028d0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028d2:	00015497          	auipc	s1,0x15
    800028d6:	ebe48493          	addi	s1,s1,-322 # 80017790 <itable+0x18>
    800028da:	00017697          	auipc	a3,0x17
    800028de:	94668693          	addi	a3,a3,-1722 # 80019220 <log>
    800028e2:	a039                	j	800028f0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028e4:	02090b63          	beqz	s2,8000291a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028e8:	08848493          	addi	s1,s1,136
    800028ec:	02d48a63          	beq	s1,a3,80002920 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028f0:	449c                	lw	a5,8(s1)
    800028f2:	fef059e3          	blez	a5,800028e4 <iget+0x38>
    800028f6:	4098                	lw	a4,0(s1)
    800028f8:	ff3716e3          	bne	a4,s3,800028e4 <iget+0x38>
    800028fc:	40d8                	lw	a4,4(s1)
    800028fe:	ff4713e3          	bne	a4,s4,800028e4 <iget+0x38>
      ip->ref++;
    80002902:	2785                	addiw	a5,a5,1
    80002904:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002906:	00015517          	auipc	a0,0x15
    8000290a:	e7250513          	addi	a0,a0,-398 # 80017778 <itable>
    8000290e:	00004097          	auipc	ra,0x4
    80002912:	926080e7          	jalr	-1754(ra) # 80006234 <release>
      return ip;
    80002916:	8926                	mv	s2,s1
    80002918:	a03d                	j	80002946 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000291a:	f7f9                	bnez	a5,800028e8 <iget+0x3c>
    8000291c:	8926                	mv	s2,s1
    8000291e:	b7e9                	j	800028e8 <iget+0x3c>
  if(empty == 0)
    80002920:	02090c63          	beqz	s2,80002958 <iget+0xac>
  ip->dev = dev;
    80002924:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002928:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000292c:	4785                	li	a5,1
    8000292e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002932:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002936:	00015517          	auipc	a0,0x15
    8000293a:	e4250513          	addi	a0,a0,-446 # 80017778 <itable>
    8000293e:	00004097          	auipc	ra,0x4
    80002942:	8f6080e7          	jalr	-1802(ra) # 80006234 <release>
}
    80002946:	854a                	mv	a0,s2
    80002948:	70a2                	ld	ra,40(sp)
    8000294a:	7402                	ld	s0,32(sp)
    8000294c:	64e2                	ld	s1,24(sp)
    8000294e:	6942                	ld	s2,16(sp)
    80002950:	69a2                	ld	s3,8(sp)
    80002952:	6a02                	ld	s4,0(sp)
    80002954:	6145                	addi	sp,sp,48
    80002956:	8082                	ret
    panic("iget: no inodes");
    80002958:	00006517          	auipc	a0,0x6
    8000295c:	b7050513          	addi	a0,a0,-1168 # 800084c8 <etext+0x4c8>
    80002960:	00003097          	auipc	ra,0x3
    80002964:	2e4080e7          	jalr	740(ra) # 80005c44 <panic>

0000000080002968 <fsinit>:
fsinit(int dev) {
    80002968:	7179                	addi	sp,sp,-48
    8000296a:	f406                	sd	ra,40(sp)
    8000296c:	f022                	sd	s0,32(sp)
    8000296e:	ec26                	sd	s1,24(sp)
    80002970:	e84a                	sd	s2,16(sp)
    80002972:	e44e                	sd	s3,8(sp)
    80002974:	1800                	addi	s0,sp,48
    80002976:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002978:	4585                	li	a1,1
    8000297a:	00000097          	auipc	ra,0x0
    8000297e:	a64080e7          	jalr	-1436(ra) # 800023de <bread>
    80002982:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002984:	00015997          	auipc	s3,0x15
    80002988:	dd498993          	addi	s3,s3,-556 # 80017758 <sb>
    8000298c:	02000613          	li	a2,32
    80002990:	05850593          	addi	a1,a0,88
    80002994:	854e                	mv	a0,s3
    80002996:	ffffe097          	auipc	ra,0xffffe
    8000299a:	888080e7          	jalr	-1912(ra) # 8000021e <memmove>
  brelse(bp);
    8000299e:	8526                	mv	a0,s1
    800029a0:	00000097          	auipc	ra,0x0
    800029a4:	b6e080e7          	jalr	-1170(ra) # 8000250e <brelse>
  if(sb.magic != FSMAGIC)
    800029a8:	0009a703          	lw	a4,0(s3)
    800029ac:	102037b7          	lui	a5,0x10203
    800029b0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029b4:	02f71263          	bne	a4,a5,800029d8 <fsinit+0x70>
  initlog(dev, &sb);
    800029b8:	00015597          	auipc	a1,0x15
    800029bc:	da058593          	addi	a1,a1,-608 # 80017758 <sb>
    800029c0:	854a                	mv	a0,s2
    800029c2:	00001097          	auipc	ra,0x1
    800029c6:	b4c080e7          	jalr	-1204(ra) # 8000350e <initlog>
}
    800029ca:	70a2                	ld	ra,40(sp)
    800029cc:	7402                	ld	s0,32(sp)
    800029ce:	64e2                	ld	s1,24(sp)
    800029d0:	6942                	ld	s2,16(sp)
    800029d2:	69a2                	ld	s3,8(sp)
    800029d4:	6145                	addi	sp,sp,48
    800029d6:	8082                	ret
    panic("invalid file system");
    800029d8:	00006517          	auipc	a0,0x6
    800029dc:	b0050513          	addi	a0,a0,-1280 # 800084d8 <etext+0x4d8>
    800029e0:	00003097          	auipc	ra,0x3
    800029e4:	264080e7          	jalr	612(ra) # 80005c44 <panic>

00000000800029e8 <iinit>:
{
    800029e8:	7179                	addi	sp,sp,-48
    800029ea:	f406                	sd	ra,40(sp)
    800029ec:	f022                	sd	s0,32(sp)
    800029ee:	ec26                	sd	s1,24(sp)
    800029f0:	e84a                	sd	s2,16(sp)
    800029f2:	e44e                	sd	s3,8(sp)
    800029f4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029f6:	00006597          	auipc	a1,0x6
    800029fa:	afa58593          	addi	a1,a1,-1286 # 800084f0 <etext+0x4f0>
    800029fe:	00015517          	auipc	a0,0x15
    80002a02:	d7a50513          	addi	a0,a0,-646 # 80017778 <itable>
    80002a06:	00003097          	auipc	ra,0x3
    80002a0a:	6ea080e7          	jalr	1770(ra) # 800060f0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a0e:	00015497          	auipc	s1,0x15
    80002a12:	d9248493          	addi	s1,s1,-622 # 800177a0 <itable+0x28>
    80002a16:	00017997          	auipc	s3,0x17
    80002a1a:	81a98993          	addi	s3,s3,-2022 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a1e:	00006917          	auipc	s2,0x6
    80002a22:	ada90913          	addi	s2,s2,-1318 # 800084f8 <etext+0x4f8>
    80002a26:	85ca                	mv	a1,s2
    80002a28:	8526                	mv	a0,s1
    80002a2a:	00001097          	auipc	ra,0x1
    80002a2e:	e46080e7          	jalr	-442(ra) # 80003870 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a32:	08848493          	addi	s1,s1,136
    80002a36:	ff3498e3          	bne	s1,s3,80002a26 <iinit+0x3e>
}
    80002a3a:	70a2                	ld	ra,40(sp)
    80002a3c:	7402                	ld	s0,32(sp)
    80002a3e:	64e2                	ld	s1,24(sp)
    80002a40:	6942                	ld	s2,16(sp)
    80002a42:	69a2                	ld	s3,8(sp)
    80002a44:	6145                	addi	sp,sp,48
    80002a46:	8082                	ret

0000000080002a48 <ialloc>:
{
    80002a48:	715d                	addi	sp,sp,-80
    80002a4a:	e486                	sd	ra,72(sp)
    80002a4c:	e0a2                	sd	s0,64(sp)
    80002a4e:	fc26                	sd	s1,56(sp)
    80002a50:	f84a                	sd	s2,48(sp)
    80002a52:	f44e                	sd	s3,40(sp)
    80002a54:	f052                	sd	s4,32(sp)
    80002a56:	ec56                	sd	s5,24(sp)
    80002a58:	e85a                	sd	s6,16(sp)
    80002a5a:	e45e                	sd	s7,8(sp)
    80002a5c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a5e:	00015717          	auipc	a4,0x15
    80002a62:	d0672703          	lw	a4,-762(a4) # 80017764 <sb+0xc>
    80002a66:	4785                	li	a5,1
    80002a68:	04e7fa63          	bgeu	a5,a4,80002abc <ialloc+0x74>
    80002a6c:	8aaa                	mv	s5,a0
    80002a6e:	8bae                	mv	s7,a1
    80002a70:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a72:	00015a17          	auipc	s4,0x15
    80002a76:	ce6a0a13          	addi	s4,s4,-794 # 80017758 <sb>
    80002a7a:	00048b1b          	sext.w	s6,s1
    80002a7e:	0044d793          	srli	a5,s1,0x4
    80002a82:	018a2583          	lw	a1,24(s4)
    80002a86:	9dbd                	addw	a1,a1,a5
    80002a88:	8556                	mv	a0,s5
    80002a8a:	00000097          	auipc	ra,0x0
    80002a8e:	954080e7          	jalr	-1708(ra) # 800023de <bread>
    80002a92:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a94:	05850993          	addi	s3,a0,88
    80002a98:	00f4f793          	andi	a5,s1,15
    80002a9c:	079a                	slli	a5,a5,0x6
    80002a9e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aa0:	00099783          	lh	a5,0(s3)
    80002aa4:	c785                	beqz	a5,80002acc <ialloc+0x84>
    brelse(bp);
    80002aa6:	00000097          	auipc	ra,0x0
    80002aaa:	a68080e7          	jalr	-1432(ra) # 8000250e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aae:	0485                	addi	s1,s1,1
    80002ab0:	00ca2703          	lw	a4,12(s4)
    80002ab4:	0004879b          	sext.w	a5,s1
    80002ab8:	fce7e1e3          	bltu	a5,a4,80002a7a <ialloc+0x32>
  panic("ialloc: no inodes");
    80002abc:	00006517          	auipc	a0,0x6
    80002ac0:	a4450513          	addi	a0,a0,-1468 # 80008500 <etext+0x500>
    80002ac4:	00003097          	auipc	ra,0x3
    80002ac8:	180080e7          	jalr	384(ra) # 80005c44 <panic>
      memset(dip, 0, sizeof(*dip));
    80002acc:	04000613          	li	a2,64
    80002ad0:	4581                	li	a1,0
    80002ad2:	854e                	mv	a0,s3
    80002ad4:	ffffd097          	auipc	ra,0xffffd
    80002ad8:	6ee080e7          	jalr	1774(ra) # 800001c2 <memset>
      dip->type = type;
    80002adc:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	00001097          	auipc	ra,0x1
    80002ae6:	ca8080e7          	jalr	-856(ra) # 8000378a <log_write>
      brelse(bp);
    80002aea:	854a                	mv	a0,s2
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	a22080e7          	jalr	-1502(ra) # 8000250e <brelse>
      return iget(dev, inum);
    80002af4:	85da                	mv	a1,s6
    80002af6:	8556                	mv	a0,s5
    80002af8:	00000097          	auipc	ra,0x0
    80002afc:	db4080e7          	jalr	-588(ra) # 800028ac <iget>
}
    80002b00:	60a6                	ld	ra,72(sp)
    80002b02:	6406                	ld	s0,64(sp)
    80002b04:	74e2                	ld	s1,56(sp)
    80002b06:	7942                	ld	s2,48(sp)
    80002b08:	79a2                	ld	s3,40(sp)
    80002b0a:	7a02                	ld	s4,32(sp)
    80002b0c:	6ae2                	ld	s5,24(sp)
    80002b0e:	6b42                	ld	s6,16(sp)
    80002b10:	6ba2                	ld	s7,8(sp)
    80002b12:	6161                	addi	sp,sp,80
    80002b14:	8082                	ret

0000000080002b16 <iupdate>:
{
    80002b16:	1101                	addi	sp,sp,-32
    80002b18:	ec06                	sd	ra,24(sp)
    80002b1a:	e822                	sd	s0,16(sp)
    80002b1c:	e426                	sd	s1,8(sp)
    80002b1e:	e04a                	sd	s2,0(sp)
    80002b20:	1000                	addi	s0,sp,32
    80002b22:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b24:	415c                	lw	a5,4(a0)
    80002b26:	0047d79b          	srliw	a5,a5,0x4
    80002b2a:	00015597          	auipc	a1,0x15
    80002b2e:	c465a583          	lw	a1,-954(a1) # 80017770 <sb+0x18>
    80002b32:	9dbd                	addw	a1,a1,a5
    80002b34:	4108                	lw	a0,0(a0)
    80002b36:	00000097          	auipc	ra,0x0
    80002b3a:	8a8080e7          	jalr	-1880(ra) # 800023de <bread>
    80002b3e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b40:	05850793          	addi	a5,a0,88
    80002b44:	40c8                	lw	a0,4(s1)
    80002b46:	893d                	andi	a0,a0,15
    80002b48:	051a                	slli	a0,a0,0x6
    80002b4a:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b4c:	04449703          	lh	a4,68(s1)
    80002b50:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b54:	04649703          	lh	a4,70(s1)
    80002b58:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b5c:	04849703          	lh	a4,72(s1)
    80002b60:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b64:	04a49703          	lh	a4,74(s1)
    80002b68:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b6c:	44f8                	lw	a4,76(s1)
    80002b6e:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b70:	03400613          	li	a2,52
    80002b74:	05048593          	addi	a1,s1,80
    80002b78:	0531                	addi	a0,a0,12
    80002b7a:	ffffd097          	auipc	ra,0xffffd
    80002b7e:	6a4080e7          	jalr	1700(ra) # 8000021e <memmove>
  log_write(bp);
    80002b82:	854a                	mv	a0,s2
    80002b84:	00001097          	auipc	ra,0x1
    80002b88:	c06080e7          	jalr	-1018(ra) # 8000378a <log_write>
  brelse(bp);
    80002b8c:	854a                	mv	a0,s2
    80002b8e:	00000097          	auipc	ra,0x0
    80002b92:	980080e7          	jalr	-1664(ra) # 8000250e <brelse>
}
    80002b96:	60e2                	ld	ra,24(sp)
    80002b98:	6442                	ld	s0,16(sp)
    80002b9a:	64a2                	ld	s1,8(sp)
    80002b9c:	6902                	ld	s2,0(sp)
    80002b9e:	6105                	addi	sp,sp,32
    80002ba0:	8082                	ret

0000000080002ba2 <idup>:
{
    80002ba2:	1101                	addi	sp,sp,-32
    80002ba4:	ec06                	sd	ra,24(sp)
    80002ba6:	e822                	sd	s0,16(sp)
    80002ba8:	e426                	sd	s1,8(sp)
    80002baa:	1000                	addi	s0,sp,32
    80002bac:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bae:	00015517          	auipc	a0,0x15
    80002bb2:	bca50513          	addi	a0,a0,-1078 # 80017778 <itable>
    80002bb6:	00003097          	auipc	ra,0x3
    80002bba:	5ca080e7          	jalr	1482(ra) # 80006180 <acquire>
  ip->ref++;
    80002bbe:	449c                	lw	a5,8(s1)
    80002bc0:	2785                	addiw	a5,a5,1
    80002bc2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bc4:	00015517          	auipc	a0,0x15
    80002bc8:	bb450513          	addi	a0,a0,-1100 # 80017778 <itable>
    80002bcc:	00003097          	auipc	ra,0x3
    80002bd0:	668080e7          	jalr	1640(ra) # 80006234 <release>
}
    80002bd4:	8526                	mv	a0,s1
    80002bd6:	60e2                	ld	ra,24(sp)
    80002bd8:	6442                	ld	s0,16(sp)
    80002bda:	64a2                	ld	s1,8(sp)
    80002bdc:	6105                	addi	sp,sp,32
    80002bde:	8082                	ret

0000000080002be0 <ilock>:
{
    80002be0:	1101                	addi	sp,sp,-32
    80002be2:	ec06                	sd	ra,24(sp)
    80002be4:	e822                	sd	s0,16(sp)
    80002be6:	e426                	sd	s1,8(sp)
    80002be8:	e04a                	sd	s2,0(sp)
    80002bea:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bec:	c115                	beqz	a0,80002c10 <ilock+0x30>
    80002bee:	84aa                	mv	s1,a0
    80002bf0:	451c                	lw	a5,8(a0)
    80002bf2:	00f05f63          	blez	a5,80002c10 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bf6:	0541                	addi	a0,a0,16
    80002bf8:	00001097          	auipc	ra,0x1
    80002bfc:	cb2080e7          	jalr	-846(ra) # 800038aa <acquiresleep>
  if(ip->valid == 0){
    80002c00:	40bc                	lw	a5,64(s1)
    80002c02:	cf99                	beqz	a5,80002c20 <ilock+0x40>
}
    80002c04:	60e2                	ld	ra,24(sp)
    80002c06:	6442                	ld	s0,16(sp)
    80002c08:	64a2                	ld	s1,8(sp)
    80002c0a:	6902                	ld	s2,0(sp)
    80002c0c:	6105                	addi	sp,sp,32
    80002c0e:	8082                	ret
    panic("ilock");
    80002c10:	00006517          	auipc	a0,0x6
    80002c14:	90850513          	addi	a0,a0,-1784 # 80008518 <etext+0x518>
    80002c18:	00003097          	auipc	ra,0x3
    80002c1c:	02c080e7          	jalr	44(ra) # 80005c44 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c20:	40dc                	lw	a5,4(s1)
    80002c22:	0047d79b          	srliw	a5,a5,0x4
    80002c26:	00015597          	auipc	a1,0x15
    80002c2a:	b4a5a583          	lw	a1,-1206(a1) # 80017770 <sb+0x18>
    80002c2e:	9dbd                	addw	a1,a1,a5
    80002c30:	4088                	lw	a0,0(s1)
    80002c32:	fffff097          	auipc	ra,0xfffff
    80002c36:	7ac080e7          	jalr	1964(ra) # 800023de <bread>
    80002c3a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c3c:	05850593          	addi	a1,a0,88
    80002c40:	40dc                	lw	a5,4(s1)
    80002c42:	8bbd                	andi	a5,a5,15
    80002c44:	079a                	slli	a5,a5,0x6
    80002c46:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c48:	00059783          	lh	a5,0(a1)
    80002c4c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c50:	00259783          	lh	a5,2(a1)
    80002c54:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c58:	00459783          	lh	a5,4(a1)
    80002c5c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c60:	00659783          	lh	a5,6(a1)
    80002c64:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c68:	459c                	lw	a5,8(a1)
    80002c6a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c6c:	03400613          	li	a2,52
    80002c70:	05b1                	addi	a1,a1,12
    80002c72:	05048513          	addi	a0,s1,80
    80002c76:	ffffd097          	auipc	ra,0xffffd
    80002c7a:	5a8080e7          	jalr	1448(ra) # 8000021e <memmove>
    brelse(bp);
    80002c7e:	854a                	mv	a0,s2
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	88e080e7          	jalr	-1906(ra) # 8000250e <brelse>
    ip->valid = 1;
    80002c88:	4785                	li	a5,1
    80002c8a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c8c:	04449783          	lh	a5,68(s1)
    80002c90:	fbb5                	bnez	a5,80002c04 <ilock+0x24>
      panic("ilock: no type");
    80002c92:	00006517          	auipc	a0,0x6
    80002c96:	88e50513          	addi	a0,a0,-1906 # 80008520 <etext+0x520>
    80002c9a:	00003097          	auipc	ra,0x3
    80002c9e:	faa080e7          	jalr	-86(ra) # 80005c44 <panic>

0000000080002ca2 <iunlock>:
{
    80002ca2:	1101                	addi	sp,sp,-32
    80002ca4:	ec06                	sd	ra,24(sp)
    80002ca6:	e822                	sd	s0,16(sp)
    80002ca8:	e426                	sd	s1,8(sp)
    80002caa:	e04a                	sd	s2,0(sp)
    80002cac:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cae:	c905                	beqz	a0,80002cde <iunlock+0x3c>
    80002cb0:	84aa                	mv	s1,a0
    80002cb2:	01050913          	addi	s2,a0,16
    80002cb6:	854a                	mv	a0,s2
    80002cb8:	00001097          	auipc	ra,0x1
    80002cbc:	c8c080e7          	jalr	-884(ra) # 80003944 <holdingsleep>
    80002cc0:	cd19                	beqz	a0,80002cde <iunlock+0x3c>
    80002cc2:	449c                	lw	a5,8(s1)
    80002cc4:	00f05d63          	blez	a5,80002cde <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cc8:	854a                	mv	a0,s2
    80002cca:	00001097          	auipc	ra,0x1
    80002cce:	c36080e7          	jalr	-970(ra) # 80003900 <releasesleep>
}
    80002cd2:	60e2                	ld	ra,24(sp)
    80002cd4:	6442                	ld	s0,16(sp)
    80002cd6:	64a2                	ld	s1,8(sp)
    80002cd8:	6902                	ld	s2,0(sp)
    80002cda:	6105                	addi	sp,sp,32
    80002cdc:	8082                	ret
    panic("iunlock");
    80002cde:	00006517          	auipc	a0,0x6
    80002ce2:	85250513          	addi	a0,a0,-1966 # 80008530 <etext+0x530>
    80002ce6:	00003097          	auipc	ra,0x3
    80002cea:	f5e080e7          	jalr	-162(ra) # 80005c44 <panic>

0000000080002cee <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cee:	7179                	addi	sp,sp,-48
    80002cf0:	f406                	sd	ra,40(sp)
    80002cf2:	f022                	sd	s0,32(sp)
    80002cf4:	ec26                	sd	s1,24(sp)
    80002cf6:	e84a                	sd	s2,16(sp)
    80002cf8:	e44e                	sd	s3,8(sp)
    80002cfa:	e052                	sd	s4,0(sp)
    80002cfc:	1800                	addi	s0,sp,48
    80002cfe:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d00:	05050493          	addi	s1,a0,80
    80002d04:	08050913          	addi	s2,a0,128
    80002d08:	a021                	j	80002d10 <itrunc+0x22>
    80002d0a:	0491                	addi	s1,s1,4
    80002d0c:	01248d63          	beq	s1,s2,80002d26 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d10:	408c                	lw	a1,0(s1)
    80002d12:	dde5                	beqz	a1,80002d0a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d14:	0009a503          	lw	a0,0(s3)
    80002d18:	00000097          	auipc	ra,0x0
    80002d1c:	90c080e7          	jalr	-1780(ra) # 80002624 <bfree>
      ip->addrs[i] = 0;
    80002d20:	0004a023          	sw	zero,0(s1)
    80002d24:	b7dd                	j	80002d0a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d26:	0809a583          	lw	a1,128(s3)
    80002d2a:	e185                	bnez	a1,80002d4a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d2c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d30:	854e                	mv	a0,s3
    80002d32:	00000097          	auipc	ra,0x0
    80002d36:	de4080e7          	jalr	-540(ra) # 80002b16 <iupdate>
}
    80002d3a:	70a2                	ld	ra,40(sp)
    80002d3c:	7402                	ld	s0,32(sp)
    80002d3e:	64e2                	ld	s1,24(sp)
    80002d40:	6942                	ld	s2,16(sp)
    80002d42:	69a2                	ld	s3,8(sp)
    80002d44:	6a02                	ld	s4,0(sp)
    80002d46:	6145                	addi	sp,sp,48
    80002d48:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d4a:	0009a503          	lw	a0,0(s3)
    80002d4e:	fffff097          	auipc	ra,0xfffff
    80002d52:	690080e7          	jalr	1680(ra) # 800023de <bread>
    80002d56:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d58:	05850493          	addi	s1,a0,88
    80002d5c:	45850913          	addi	s2,a0,1112
    80002d60:	a021                	j	80002d68 <itrunc+0x7a>
    80002d62:	0491                	addi	s1,s1,4
    80002d64:	01248b63          	beq	s1,s2,80002d7a <itrunc+0x8c>
      if(a[j])
    80002d68:	408c                	lw	a1,0(s1)
    80002d6a:	dde5                	beqz	a1,80002d62 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d6c:	0009a503          	lw	a0,0(s3)
    80002d70:	00000097          	auipc	ra,0x0
    80002d74:	8b4080e7          	jalr	-1868(ra) # 80002624 <bfree>
    80002d78:	b7ed                	j	80002d62 <itrunc+0x74>
    brelse(bp);
    80002d7a:	8552                	mv	a0,s4
    80002d7c:	fffff097          	auipc	ra,0xfffff
    80002d80:	792080e7          	jalr	1938(ra) # 8000250e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d84:	0809a583          	lw	a1,128(s3)
    80002d88:	0009a503          	lw	a0,0(s3)
    80002d8c:	00000097          	auipc	ra,0x0
    80002d90:	898080e7          	jalr	-1896(ra) # 80002624 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d94:	0809a023          	sw	zero,128(s3)
    80002d98:	bf51                	j	80002d2c <itrunc+0x3e>

0000000080002d9a <iput>:
{
    80002d9a:	1101                	addi	sp,sp,-32
    80002d9c:	ec06                	sd	ra,24(sp)
    80002d9e:	e822                	sd	s0,16(sp)
    80002da0:	e426                	sd	s1,8(sp)
    80002da2:	e04a                	sd	s2,0(sp)
    80002da4:	1000                	addi	s0,sp,32
    80002da6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002da8:	00015517          	auipc	a0,0x15
    80002dac:	9d050513          	addi	a0,a0,-1584 # 80017778 <itable>
    80002db0:	00003097          	auipc	ra,0x3
    80002db4:	3d0080e7          	jalr	976(ra) # 80006180 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002db8:	4498                	lw	a4,8(s1)
    80002dba:	4785                	li	a5,1
    80002dbc:	02f70363          	beq	a4,a5,80002de2 <iput+0x48>
  ip->ref--;
    80002dc0:	449c                	lw	a5,8(s1)
    80002dc2:	37fd                	addiw	a5,a5,-1
    80002dc4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dc6:	00015517          	auipc	a0,0x15
    80002dca:	9b250513          	addi	a0,a0,-1614 # 80017778 <itable>
    80002dce:	00003097          	auipc	ra,0x3
    80002dd2:	466080e7          	jalr	1126(ra) # 80006234 <release>
}
    80002dd6:	60e2                	ld	ra,24(sp)
    80002dd8:	6442                	ld	s0,16(sp)
    80002dda:	64a2                	ld	s1,8(sp)
    80002ddc:	6902                	ld	s2,0(sp)
    80002dde:	6105                	addi	sp,sp,32
    80002de0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002de2:	40bc                	lw	a5,64(s1)
    80002de4:	dff1                	beqz	a5,80002dc0 <iput+0x26>
    80002de6:	04a49783          	lh	a5,74(s1)
    80002dea:	fbf9                	bnez	a5,80002dc0 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dec:	01048913          	addi	s2,s1,16
    80002df0:	854a                	mv	a0,s2
    80002df2:	00001097          	auipc	ra,0x1
    80002df6:	ab8080e7          	jalr	-1352(ra) # 800038aa <acquiresleep>
    release(&itable.lock);
    80002dfa:	00015517          	auipc	a0,0x15
    80002dfe:	97e50513          	addi	a0,a0,-1666 # 80017778 <itable>
    80002e02:	00003097          	auipc	ra,0x3
    80002e06:	432080e7          	jalr	1074(ra) # 80006234 <release>
    itrunc(ip);
    80002e0a:	8526                	mv	a0,s1
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	ee2080e7          	jalr	-286(ra) # 80002cee <itrunc>
    ip->type = 0;
    80002e14:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e18:	8526                	mv	a0,s1
    80002e1a:	00000097          	auipc	ra,0x0
    80002e1e:	cfc080e7          	jalr	-772(ra) # 80002b16 <iupdate>
    ip->valid = 0;
    80002e22:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e26:	854a                	mv	a0,s2
    80002e28:	00001097          	auipc	ra,0x1
    80002e2c:	ad8080e7          	jalr	-1320(ra) # 80003900 <releasesleep>
    acquire(&itable.lock);
    80002e30:	00015517          	auipc	a0,0x15
    80002e34:	94850513          	addi	a0,a0,-1720 # 80017778 <itable>
    80002e38:	00003097          	auipc	ra,0x3
    80002e3c:	348080e7          	jalr	840(ra) # 80006180 <acquire>
    80002e40:	b741                	j	80002dc0 <iput+0x26>

0000000080002e42 <iunlockput>:
{
    80002e42:	1101                	addi	sp,sp,-32
    80002e44:	ec06                	sd	ra,24(sp)
    80002e46:	e822                	sd	s0,16(sp)
    80002e48:	e426                	sd	s1,8(sp)
    80002e4a:	1000                	addi	s0,sp,32
    80002e4c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e4e:	00000097          	auipc	ra,0x0
    80002e52:	e54080e7          	jalr	-428(ra) # 80002ca2 <iunlock>
  iput(ip);
    80002e56:	8526                	mv	a0,s1
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	f42080e7          	jalr	-190(ra) # 80002d9a <iput>
}
    80002e60:	60e2                	ld	ra,24(sp)
    80002e62:	6442                	ld	s0,16(sp)
    80002e64:	64a2                	ld	s1,8(sp)
    80002e66:	6105                	addi	sp,sp,32
    80002e68:	8082                	ret

0000000080002e6a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e6a:	1141                	addi	sp,sp,-16
    80002e6c:	e422                	sd	s0,8(sp)
    80002e6e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e70:	411c                	lw	a5,0(a0)
    80002e72:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e74:	415c                	lw	a5,4(a0)
    80002e76:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e78:	04451783          	lh	a5,68(a0)
    80002e7c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e80:	04a51783          	lh	a5,74(a0)
    80002e84:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e88:	04c56783          	lwu	a5,76(a0)
    80002e8c:	e99c                	sd	a5,16(a1)
}
    80002e8e:	6422                	ld	s0,8(sp)
    80002e90:	0141                	addi	sp,sp,16
    80002e92:	8082                	ret

0000000080002e94 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e94:	457c                	lw	a5,76(a0)
    80002e96:	0ed7e963          	bltu	a5,a3,80002f88 <readi+0xf4>
{
    80002e9a:	7159                	addi	sp,sp,-112
    80002e9c:	f486                	sd	ra,104(sp)
    80002e9e:	f0a2                	sd	s0,96(sp)
    80002ea0:	eca6                	sd	s1,88(sp)
    80002ea2:	e8ca                	sd	s2,80(sp)
    80002ea4:	e4ce                	sd	s3,72(sp)
    80002ea6:	e0d2                	sd	s4,64(sp)
    80002ea8:	fc56                	sd	s5,56(sp)
    80002eaa:	f85a                	sd	s6,48(sp)
    80002eac:	f45e                	sd	s7,40(sp)
    80002eae:	f062                	sd	s8,32(sp)
    80002eb0:	ec66                	sd	s9,24(sp)
    80002eb2:	e86a                	sd	s10,16(sp)
    80002eb4:	e46e                	sd	s11,8(sp)
    80002eb6:	1880                	addi	s0,sp,112
    80002eb8:	8baa                	mv	s7,a0
    80002eba:	8c2e                	mv	s8,a1
    80002ebc:	8ab2                	mv	s5,a2
    80002ebe:	84b6                	mv	s1,a3
    80002ec0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ec2:	9f35                	addw	a4,a4,a3
    return 0;
    80002ec4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ec6:	0ad76063          	bltu	a4,a3,80002f66 <readi+0xd2>
  if(off + n > ip->size)
    80002eca:	00e7f463          	bgeu	a5,a4,80002ed2 <readi+0x3e>
    n = ip->size - off;
    80002ece:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed2:	0a0b0963          	beqz	s6,80002f84 <readi+0xf0>
    80002ed6:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ed8:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002edc:	5cfd                	li	s9,-1
    80002ede:	a82d                	j	80002f18 <readi+0x84>
    80002ee0:	020a1d93          	slli	s11,s4,0x20
    80002ee4:	020ddd93          	srli	s11,s11,0x20
    80002ee8:	05890793          	addi	a5,s2,88
    80002eec:	86ee                	mv	a3,s11
    80002eee:	963e                	add	a2,a2,a5
    80002ef0:	85d6                	mv	a1,s5
    80002ef2:	8562                	mv	a0,s8
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	a04080e7          	jalr	-1532(ra) # 800018f8 <either_copyout>
    80002efc:	05950d63          	beq	a0,s9,80002f56 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f00:	854a                	mv	a0,s2
    80002f02:	fffff097          	auipc	ra,0xfffff
    80002f06:	60c080e7          	jalr	1548(ra) # 8000250e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f0a:	013a09bb          	addw	s3,s4,s3
    80002f0e:	009a04bb          	addw	s1,s4,s1
    80002f12:	9aee                	add	s5,s5,s11
    80002f14:	0569f763          	bgeu	s3,s6,80002f62 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f18:	000ba903          	lw	s2,0(s7)
    80002f1c:	00a4d59b          	srliw	a1,s1,0xa
    80002f20:	855e                	mv	a0,s7
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	8b0080e7          	jalr	-1872(ra) # 800027d2 <bmap>
    80002f2a:	0005059b          	sext.w	a1,a0
    80002f2e:	854a                	mv	a0,s2
    80002f30:	fffff097          	auipc	ra,0xfffff
    80002f34:	4ae080e7          	jalr	1198(ra) # 800023de <bread>
    80002f38:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3a:	3ff4f613          	andi	a2,s1,1023
    80002f3e:	40cd07bb          	subw	a5,s10,a2
    80002f42:	413b073b          	subw	a4,s6,s3
    80002f46:	8a3e                	mv	s4,a5
    80002f48:	2781                	sext.w	a5,a5
    80002f4a:	0007069b          	sext.w	a3,a4
    80002f4e:	f8f6f9e3          	bgeu	a3,a5,80002ee0 <readi+0x4c>
    80002f52:	8a3a                	mv	s4,a4
    80002f54:	b771                	j	80002ee0 <readi+0x4c>
      brelse(bp);
    80002f56:	854a                	mv	a0,s2
    80002f58:	fffff097          	auipc	ra,0xfffff
    80002f5c:	5b6080e7          	jalr	1462(ra) # 8000250e <brelse>
      tot = -1;
    80002f60:	59fd                	li	s3,-1
  }
  return tot;
    80002f62:	0009851b          	sext.w	a0,s3
}
    80002f66:	70a6                	ld	ra,104(sp)
    80002f68:	7406                	ld	s0,96(sp)
    80002f6a:	64e6                	ld	s1,88(sp)
    80002f6c:	6946                	ld	s2,80(sp)
    80002f6e:	69a6                	ld	s3,72(sp)
    80002f70:	6a06                	ld	s4,64(sp)
    80002f72:	7ae2                	ld	s5,56(sp)
    80002f74:	7b42                	ld	s6,48(sp)
    80002f76:	7ba2                	ld	s7,40(sp)
    80002f78:	7c02                	ld	s8,32(sp)
    80002f7a:	6ce2                	ld	s9,24(sp)
    80002f7c:	6d42                	ld	s10,16(sp)
    80002f7e:	6da2                	ld	s11,8(sp)
    80002f80:	6165                	addi	sp,sp,112
    80002f82:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f84:	89da                	mv	s3,s6
    80002f86:	bff1                	j	80002f62 <readi+0xce>
    return 0;
    80002f88:	4501                	li	a0,0
}
    80002f8a:	8082                	ret

0000000080002f8c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f8c:	457c                	lw	a5,76(a0)
    80002f8e:	10d7e863          	bltu	a5,a3,8000309e <writei+0x112>
{
    80002f92:	7159                	addi	sp,sp,-112
    80002f94:	f486                	sd	ra,104(sp)
    80002f96:	f0a2                	sd	s0,96(sp)
    80002f98:	eca6                	sd	s1,88(sp)
    80002f9a:	e8ca                	sd	s2,80(sp)
    80002f9c:	e4ce                	sd	s3,72(sp)
    80002f9e:	e0d2                	sd	s4,64(sp)
    80002fa0:	fc56                	sd	s5,56(sp)
    80002fa2:	f85a                	sd	s6,48(sp)
    80002fa4:	f45e                	sd	s7,40(sp)
    80002fa6:	f062                	sd	s8,32(sp)
    80002fa8:	ec66                	sd	s9,24(sp)
    80002faa:	e86a                	sd	s10,16(sp)
    80002fac:	e46e                	sd	s11,8(sp)
    80002fae:	1880                	addi	s0,sp,112
    80002fb0:	8b2a                	mv	s6,a0
    80002fb2:	8c2e                	mv	s8,a1
    80002fb4:	8ab2                	mv	s5,a2
    80002fb6:	8936                	mv	s2,a3
    80002fb8:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fba:	00e687bb          	addw	a5,a3,a4
    80002fbe:	0ed7e263          	bltu	a5,a3,800030a2 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fc2:	00043737          	lui	a4,0x43
    80002fc6:	0ef76063          	bltu	a4,a5,800030a6 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fca:	0c0b8863          	beqz	s7,8000309a <writei+0x10e>
    80002fce:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fd0:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fd4:	5cfd                	li	s9,-1
    80002fd6:	a091                	j	8000301a <writei+0x8e>
    80002fd8:	02099d93          	slli	s11,s3,0x20
    80002fdc:	020ddd93          	srli	s11,s11,0x20
    80002fe0:	05848793          	addi	a5,s1,88
    80002fe4:	86ee                	mv	a3,s11
    80002fe6:	8656                	mv	a2,s5
    80002fe8:	85e2                	mv	a1,s8
    80002fea:	953e                	add	a0,a0,a5
    80002fec:	fffff097          	auipc	ra,0xfffff
    80002ff0:	962080e7          	jalr	-1694(ra) # 8000194e <either_copyin>
    80002ff4:	07950263          	beq	a0,s9,80003058 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ff8:	8526                	mv	a0,s1
    80002ffa:	00000097          	auipc	ra,0x0
    80002ffe:	790080e7          	jalr	1936(ra) # 8000378a <log_write>
    brelse(bp);
    80003002:	8526                	mv	a0,s1
    80003004:	fffff097          	auipc	ra,0xfffff
    80003008:	50a080e7          	jalr	1290(ra) # 8000250e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000300c:	01498a3b          	addw	s4,s3,s4
    80003010:	0129893b          	addw	s2,s3,s2
    80003014:	9aee                	add	s5,s5,s11
    80003016:	057a7663          	bgeu	s4,s7,80003062 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000301a:	000b2483          	lw	s1,0(s6)
    8000301e:	00a9559b          	srliw	a1,s2,0xa
    80003022:	855a                	mv	a0,s6
    80003024:	fffff097          	auipc	ra,0xfffff
    80003028:	7ae080e7          	jalr	1966(ra) # 800027d2 <bmap>
    8000302c:	0005059b          	sext.w	a1,a0
    80003030:	8526                	mv	a0,s1
    80003032:	fffff097          	auipc	ra,0xfffff
    80003036:	3ac080e7          	jalr	940(ra) # 800023de <bread>
    8000303a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000303c:	3ff97513          	andi	a0,s2,1023
    80003040:	40ad07bb          	subw	a5,s10,a0
    80003044:	414b873b          	subw	a4,s7,s4
    80003048:	89be                	mv	s3,a5
    8000304a:	2781                	sext.w	a5,a5
    8000304c:	0007069b          	sext.w	a3,a4
    80003050:	f8f6f4e3          	bgeu	a3,a5,80002fd8 <writei+0x4c>
    80003054:	89ba                	mv	s3,a4
    80003056:	b749                	j	80002fd8 <writei+0x4c>
      brelse(bp);
    80003058:	8526                	mv	a0,s1
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	4b4080e7          	jalr	1204(ra) # 8000250e <brelse>
  }

  if(off > ip->size)
    80003062:	04cb2783          	lw	a5,76(s6)
    80003066:	0127f463          	bgeu	a5,s2,8000306e <writei+0xe2>
    ip->size = off;
    8000306a:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000306e:	855a                	mv	a0,s6
    80003070:	00000097          	auipc	ra,0x0
    80003074:	aa6080e7          	jalr	-1370(ra) # 80002b16 <iupdate>

  return tot;
    80003078:	000a051b          	sext.w	a0,s4
}
    8000307c:	70a6                	ld	ra,104(sp)
    8000307e:	7406                	ld	s0,96(sp)
    80003080:	64e6                	ld	s1,88(sp)
    80003082:	6946                	ld	s2,80(sp)
    80003084:	69a6                	ld	s3,72(sp)
    80003086:	6a06                	ld	s4,64(sp)
    80003088:	7ae2                	ld	s5,56(sp)
    8000308a:	7b42                	ld	s6,48(sp)
    8000308c:	7ba2                	ld	s7,40(sp)
    8000308e:	7c02                	ld	s8,32(sp)
    80003090:	6ce2                	ld	s9,24(sp)
    80003092:	6d42                	ld	s10,16(sp)
    80003094:	6da2                	ld	s11,8(sp)
    80003096:	6165                	addi	sp,sp,112
    80003098:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000309a:	8a5e                	mv	s4,s7
    8000309c:	bfc9                	j	8000306e <writei+0xe2>
    return -1;
    8000309e:	557d                	li	a0,-1
}
    800030a0:	8082                	ret
    return -1;
    800030a2:	557d                	li	a0,-1
    800030a4:	bfe1                	j	8000307c <writei+0xf0>
    return -1;
    800030a6:	557d                	li	a0,-1
    800030a8:	bfd1                	j	8000307c <writei+0xf0>

00000000800030aa <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030aa:	1141                	addi	sp,sp,-16
    800030ac:	e406                	sd	ra,8(sp)
    800030ae:	e022                	sd	s0,0(sp)
    800030b0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030b2:	4639                	li	a2,14
    800030b4:	ffffd097          	auipc	ra,0xffffd
    800030b8:	1de080e7          	jalr	478(ra) # 80000292 <strncmp>
}
    800030bc:	60a2                	ld	ra,8(sp)
    800030be:	6402                	ld	s0,0(sp)
    800030c0:	0141                	addi	sp,sp,16
    800030c2:	8082                	ret

00000000800030c4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030c4:	7139                	addi	sp,sp,-64
    800030c6:	fc06                	sd	ra,56(sp)
    800030c8:	f822                	sd	s0,48(sp)
    800030ca:	f426                	sd	s1,40(sp)
    800030cc:	f04a                	sd	s2,32(sp)
    800030ce:	ec4e                	sd	s3,24(sp)
    800030d0:	e852                	sd	s4,16(sp)
    800030d2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030d4:	04451703          	lh	a4,68(a0)
    800030d8:	4785                	li	a5,1
    800030da:	00f71a63          	bne	a4,a5,800030ee <dirlookup+0x2a>
    800030de:	892a                	mv	s2,a0
    800030e0:	89ae                	mv	s3,a1
    800030e2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e4:	457c                	lw	a5,76(a0)
    800030e6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030e8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ea:	e79d                	bnez	a5,80003118 <dirlookup+0x54>
    800030ec:	a8a5                	j	80003164 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030ee:	00005517          	auipc	a0,0x5
    800030f2:	44a50513          	addi	a0,a0,1098 # 80008538 <etext+0x538>
    800030f6:	00003097          	auipc	ra,0x3
    800030fa:	b4e080e7          	jalr	-1202(ra) # 80005c44 <panic>
      panic("dirlookup read");
    800030fe:	00005517          	auipc	a0,0x5
    80003102:	45250513          	addi	a0,a0,1106 # 80008550 <etext+0x550>
    80003106:	00003097          	auipc	ra,0x3
    8000310a:	b3e080e7          	jalr	-1218(ra) # 80005c44 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000310e:	24c1                	addiw	s1,s1,16
    80003110:	04c92783          	lw	a5,76(s2)
    80003114:	04f4f763          	bgeu	s1,a5,80003162 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003118:	4741                	li	a4,16
    8000311a:	86a6                	mv	a3,s1
    8000311c:	fc040613          	addi	a2,s0,-64
    80003120:	4581                	li	a1,0
    80003122:	854a                	mv	a0,s2
    80003124:	00000097          	auipc	ra,0x0
    80003128:	d70080e7          	jalr	-656(ra) # 80002e94 <readi>
    8000312c:	47c1                	li	a5,16
    8000312e:	fcf518e3          	bne	a0,a5,800030fe <dirlookup+0x3a>
    if(de.inum == 0)
    80003132:	fc045783          	lhu	a5,-64(s0)
    80003136:	dfe1                	beqz	a5,8000310e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003138:	fc240593          	addi	a1,s0,-62
    8000313c:	854e                	mv	a0,s3
    8000313e:	00000097          	auipc	ra,0x0
    80003142:	f6c080e7          	jalr	-148(ra) # 800030aa <namecmp>
    80003146:	f561                	bnez	a0,8000310e <dirlookup+0x4a>
      if(poff)
    80003148:	000a0463          	beqz	s4,80003150 <dirlookup+0x8c>
        *poff = off;
    8000314c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003150:	fc045583          	lhu	a1,-64(s0)
    80003154:	00092503          	lw	a0,0(s2)
    80003158:	fffff097          	auipc	ra,0xfffff
    8000315c:	754080e7          	jalr	1876(ra) # 800028ac <iget>
    80003160:	a011                	j	80003164 <dirlookup+0xa0>
  return 0;
    80003162:	4501                	li	a0,0
}
    80003164:	70e2                	ld	ra,56(sp)
    80003166:	7442                	ld	s0,48(sp)
    80003168:	74a2                	ld	s1,40(sp)
    8000316a:	7902                	ld	s2,32(sp)
    8000316c:	69e2                	ld	s3,24(sp)
    8000316e:	6a42                	ld	s4,16(sp)
    80003170:	6121                	addi	sp,sp,64
    80003172:	8082                	ret

0000000080003174 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003174:	711d                	addi	sp,sp,-96
    80003176:	ec86                	sd	ra,88(sp)
    80003178:	e8a2                	sd	s0,80(sp)
    8000317a:	e4a6                	sd	s1,72(sp)
    8000317c:	e0ca                	sd	s2,64(sp)
    8000317e:	fc4e                	sd	s3,56(sp)
    80003180:	f852                	sd	s4,48(sp)
    80003182:	f456                	sd	s5,40(sp)
    80003184:	f05a                	sd	s6,32(sp)
    80003186:	ec5e                	sd	s7,24(sp)
    80003188:	e862                	sd	s8,16(sp)
    8000318a:	e466                	sd	s9,8(sp)
    8000318c:	1080                	addi	s0,sp,96
    8000318e:	84aa                	mv	s1,a0
    80003190:	8aae                	mv	s5,a1
    80003192:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003194:	00054703          	lbu	a4,0(a0)
    80003198:	02f00793          	li	a5,47
    8000319c:	02f70363          	beq	a4,a5,800031c2 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031a0:	ffffe097          	auipc	ra,0xffffe
    800031a4:	cec080e7          	jalr	-788(ra) # 80000e8c <myproc>
    800031a8:	15053503          	ld	a0,336(a0)
    800031ac:	00000097          	auipc	ra,0x0
    800031b0:	9f6080e7          	jalr	-1546(ra) # 80002ba2 <idup>
    800031b4:	89aa                	mv	s3,a0
  while(*path == '/')
    800031b6:	02f00913          	li	s2,47
  len = path - s;
    800031ba:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800031bc:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031be:	4b85                	li	s7,1
    800031c0:	a865                	j	80003278 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031c2:	4585                	li	a1,1
    800031c4:	4505                	li	a0,1
    800031c6:	fffff097          	auipc	ra,0xfffff
    800031ca:	6e6080e7          	jalr	1766(ra) # 800028ac <iget>
    800031ce:	89aa                	mv	s3,a0
    800031d0:	b7dd                	j	800031b6 <namex+0x42>
      iunlockput(ip);
    800031d2:	854e                	mv	a0,s3
    800031d4:	00000097          	auipc	ra,0x0
    800031d8:	c6e080e7          	jalr	-914(ra) # 80002e42 <iunlockput>
      return 0;
    800031dc:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031de:	854e                	mv	a0,s3
    800031e0:	60e6                	ld	ra,88(sp)
    800031e2:	6446                	ld	s0,80(sp)
    800031e4:	64a6                	ld	s1,72(sp)
    800031e6:	6906                	ld	s2,64(sp)
    800031e8:	79e2                	ld	s3,56(sp)
    800031ea:	7a42                	ld	s4,48(sp)
    800031ec:	7aa2                	ld	s5,40(sp)
    800031ee:	7b02                	ld	s6,32(sp)
    800031f0:	6be2                	ld	s7,24(sp)
    800031f2:	6c42                	ld	s8,16(sp)
    800031f4:	6ca2                	ld	s9,8(sp)
    800031f6:	6125                	addi	sp,sp,96
    800031f8:	8082                	ret
      iunlock(ip);
    800031fa:	854e                	mv	a0,s3
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	aa6080e7          	jalr	-1370(ra) # 80002ca2 <iunlock>
      return ip;
    80003204:	bfe9                	j	800031de <namex+0x6a>
      iunlockput(ip);
    80003206:	854e                	mv	a0,s3
    80003208:	00000097          	auipc	ra,0x0
    8000320c:	c3a080e7          	jalr	-966(ra) # 80002e42 <iunlockput>
      return 0;
    80003210:	89e6                	mv	s3,s9
    80003212:	b7f1                	j	800031de <namex+0x6a>
  len = path - s;
    80003214:	40b48633          	sub	a2,s1,a1
    80003218:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000321c:	099c5463          	bge	s8,s9,800032a4 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003220:	4639                	li	a2,14
    80003222:	8552                	mv	a0,s4
    80003224:	ffffd097          	auipc	ra,0xffffd
    80003228:	ffa080e7          	jalr	-6(ra) # 8000021e <memmove>
  while(*path == '/')
    8000322c:	0004c783          	lbu	a5,0(s1)
    80003230:	01279763          	bne	a5,s2,8000323e <namex+0xca>
    path++;
    80003234:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003236:	0004c783          	lbu	a5,0(s1)
    8000323a:	ff278de3          	beq	a5,s2,80003234 <namex+0xc0>
    ilock(ip);
    8000323e:	854e                	mv	a0,s3
    80003240:	00000097          	auipc	ra,0x0
    80003244:	9a0080e7          	jalr	-1632(ra) # 80002be0 <ilock>
    if(ip->type != T_DIR){
    80003248:	04499783          	lh	a5,68(s3)
    8000324c:	f97793e3          	bne	a5,s7,800031d2 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003250:	000a8563          	beqz	s5,8000325a <namex+0xe6>
    80003254:	0004c783          	lbu	a5,0(s1)
    80003258:	d3cd                	beqz	a5,800031fa <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000325a:	865a                	mv	a2,s6
    8000325c:	85d2                	mv	a1,s4
    8000325e:	854e                	mv	a0,s3
    80003260:	00000097          	auipc	ra,0x0
    80003264:	e64080e7          	jalr	-412(ra) # 800030c4 <dirlookup>
    80003268:	8caa                	mv	s9,a0
    8000326a:	dd51                	beqz	a0,80003206 <namex+0x92>
    iunlockput(ip);
    8000326c:	854e                	mv	a0,s3
    8000326e:	00000097          	auipc	ra,0x0
    80003272:	bd4080e7          	jalr	-1068(ra) # 80002e42 <iunlockput>
    ip = next;
    80003276:	89e6                	mv	s3,s9
  while(*path == '/')
    80003278:	0004c783          	lbu	a5,0(s1)
    8000327c:	05279763          	bne	a5,s2,800032ca <namex+0x156>
    path++;
    80003280:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003282:	0004c783          	lbu	a5,0(s1)
    80003286:	ff278de3          	beq	a5,s2,80003280 <namex+0x10c>
  if(*path == 0)
    8000328a:	c79d                	beqz	a5,800032b8 <namex+0x144>
    path++;
    8000328c:	85a6                	mv	a1,s1
  len = path - s;
    8000328e:	8cda                	mv	s9,s6
    80003290:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003292:	01278963          	beq	a5,s2,800032a4 <namex+0x130>
    80003296:	dfbd                	beqz	a5,80003214 <namex+0xa0>
    path++;
    80003298:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000329a:	0004c783          	lbu	a5,0(s1)
    8000329e:	ff279ce3          	bne	a5,s2,80003296 <namex+0x122>
    800032a2:	bf8d                	j	80003214 <namex+0xa0>
    memmove(name, s, len);
    800032a4:	2601                	sext.w	a2,a2
    800032a6:	8552                	mv	a0,s4
    800032a8:	ffffd097          	auipc	ra,0xffffd
    800032ac:	f76080e7          	jalr	-138(ra) # 8000021e <memmove>
    name[len] = 0;
    800032b0:	9cd2                	add	s9,s9,s4
    800032b2:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032b6:	bf9d                	j	8000322c <namex+0xb8>
  if(nameiparent){
    800032b8:	f20a83e3          	beqz	s5,800031de <namex+0x6a>
    iput(ip);
    800032bc:	854e                	mv	a0,s3
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	adc080e7          	jalr	-1316(ra) # 80002d9a <iput>
    return 0;
    800032c6:	4981                	li	s3,0
    800032c8:	bf19                	j	800031de <namex+0x6a>
  if(*path == 0)
    800032ca:	d7fd                	beqz	a5,800032b8 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032cc:	0004c783          	lbu	a5,0(s1)
    800032d0:	85a6                	mv	a1,s1
    800032d2:	b7d1                	j	80003296 <namex+0x122>

00000000800032d4 <dirlink>:
{
    800032d4:	7139                	addi	sp,sp,-64
    800032d6:	fc06                	sd	ra,56(sp)
    800032d8:	f822                	sd	s0,48(sp)
    800032da:	f426                	sd	s1,40(sp)
    800032dc:	f04a                	sd	s2,32(sp)
    800032de:	ec4e                	sd	s3,24(sp)
    800032e0:	e852                	sd	s4,16(sp)
    800032e2:	0080                	addi	s0,sp,64
    800032e4:	892a                	mv	s2,a0
    800032e6:	8a2e                	mv	s4,a1
    800032e8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032ea:	4601                	li	a2,0
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	dd8080e7          	jalr	-552(ra) # 800030c4 <dirlookup>
    800032f4:	e93d                	bnez	a0,8000336a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f6:	04c92483          	lw	s1,76(s2)
    800032fa:	c49d                	beqz	s1,80003328 <dirlink+0x54>
    800032fc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032fe:	4741                	li	a4,16
    80003300:	86a6                	mv	a3,s1
    80003302:	fc040613          	addi	a2,s0,-64
    80003306:	4581                	li	a1,0
    80003308:	854a                	mv	a0,s2
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	b8a080e7          	jalr	-1142(ra) # 80002e94 <readi>
    80003312:	47c1                	li	a5,16
    80003314:	06f51163          	bne	a0,a5,80003376 <dirlink+0xa2>
    if(de.inum == 0)
    80003318:	fc045783          	lhu	a5,-64(s0)
    8000331c:	c791                	beqz	a5,80003328 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000331e:	24c1                	addiw	s1,s1,16
    80003320:	04c92783          	lw	a5,76(s2)
    80003324:	fcf4ede3          	bltu	s1,a5,800032fe <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003328:	4639                	li	a2,14
    8000332a:	85d2                	mv	a1,s4
    8000332c:	fc240513          	addi	a0,s0,-62
    80003330:	ffffd097          	auipc	ra,0xffffd
    80003334:	f9e080e7          	jalr	-98(ra) # 800002ce <strncpy>
  de.inum = inum;
    80003338:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000333c:	4741                	li	a4,16
    8000333e:	86a6                	mv	a3,s1
    80003340:	fc040613          	addi	a2,s0,-64
    80003344:	4581                	li	a1,0
    80003346:	854a                	mv	a0,s2
    80003348:	00000097          	auipc	ra,0x0
    8000334c:	c44080e7          	jalr	-956(ra) # 80002f8c <writei>
    80003350:	872a                	mv	a4,a0
    80003352:	47c1                	li	a5,16
  return 0;
    80003354:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003356:	02f71863          	bne	a4,a5,80003386 <dirlink+0xb2>
}
    8000335a:	70e2                	ld	ra,56(sp)
    8000335c:	7442                	ld	s0,48(sp)
    8000335e:	74a2                	ld	s1,40(sp)
    80003360:	7902                	ld	s2,32(sp)
    80003362:	69e2                	ld	s3,24(sp)
    80003364:	6a42                	ld	s4,16(sp)
    80003366:	6121                	addi	sp,sp,64
    80003368:	8082                	ret
    iput(ip);
    8000336a:	00000097          	auipc	ra,0x0
    8000336e:	a30080e7          	jalr	-1488(ra) # 80002d9a <iput>
    return -1;
    80003372:	557d                	li	a0,-1
    80003374:	b7dd                	j	8000335a <dirlink+0x86>
      panic("dirlink read");
    80003376:	00005517          	auipc	a0,0x5
    8000337a:	1ea50513          	addi	a0,a0,490 # 80008560 <etext+0x560>
    8000337e:	00003097          	auipc	ra,0x3
    80003382:	8c6080e7          	jalr	-1850(ra) # 80005c44 <panic>
    panic("dirlink");
    80003386:	00005517          	auipc	a0,0x5
    8000338a:	2e250513          	addi	a0,a0,738 # 80008668 <etext+0x668>
    8000338e:	00003097          	auipc	ra,0x3
    80003392:	8b6080e7          	jalr	-1866(ra) # 80005c44 <panic>

0000000080003396 <namei>:

struct inode*
namei(char *path)
{
    80003396:	1101                	addi	sp,sp,-32
    80003398:	ec06                	sd	ra,24(sp)
    8000339a:	e822                	sd	s0,16(sp)
    8000339c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000339e:	fe040613          	addi	a2,s0,-32
    800033a2:	4581                	li	a1,0
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	dd0080e7          	jalr	-560(ra) # 80003174 <namex>
}
    800033ac:	60e2                	ld	ra,24(sp)
    800033ae:	6442                	ld	s0,16(sp)
    800033b0:	6105                	addi	sp,sp,32
    800033b2:	8082                	ret

00000000800033b4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033b4:	1141                	addi	sp,sp,-16
    800033b6:	e406                	sd	ra,8(sp)
    800033b8:	e022                	sd	s0,0(sp)
    800033ba:	0800                	addi	s0,sp,16
    800033bc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033be:	4585                	li	a1,1
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	db4080e7          	jalr	-588(ra) # 80003174 <namex>
}
    800033c8:	60a2                	ld	ra,8(sp)
    800033ca:	6402                	ld	s0,0(sp)
    800033cc:	0141                	addi	sp,sp,16
    800033ce:	8082                	ret

00000000800033d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033d0:	1101                	addi	sp,sp,-32
    800033d2:	ec06                	sd	ra,24(sp)
    800033d4:	e822                	sd	s0,16(sp)
    800033d6:	e426                	sd	s1,8(sp)
    800033d8:	e04a                	sd	s2,0(sp)
    800033da:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033dc:	00016917          	auipc	s2,0x16
    800033e0:	e4490913          	addi	s2,s2,-444 # 80019220 <log>
    800033e4:	01892583          	lw	a1,24(s2)
    800033e8:	02892503          	lw	a0,40(s2)
    800033ec:	fffff097          	auipc	ra,0xfffff
    800033f0:	ff2080e7          	jalr	-14(ra) # 800023de <bread>
    800033f4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033f6:	02c92683          	lw	a3,44(s2)
    800033fa:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033fc:	02d05763          	blez	a3,8000342a <write_head+0x5a>
    80003400:	00016797          	auipc	a5,0x16
    80003404:	e5078793          	addi	a5,a5,-432 # 80019250 <log+0x30>
    80003408:	05c50713          	addi	a4,a0,92
    8000340c:	36fd                	addiw	a3,a3,-1
    8000340e:	1682                	slli	a3,a3,0x20
    80003410:	9281                	srli	a3,a3,0x20
    80003412:	068a                	slli	a3,a3,0x2
    80003414:	00016617          	auipc	a2,0x16
    80003418:	e4060613          	addi	a2,a2,-448 # 80019254 <log+0x34>
    8000341c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000341e:	4390                	lw	a2,0(a5)
    80003420:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003422:	0791                	addi	a5,a5,4
    80003424:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003426:	fed79ce3          	bne	a5,a3,8000341e <write_head+0x4e>
  }
  bwrite(buf);
    8000342a:	8526                	mv	a0,s1
    8000342c:	fffff097          	auipc	ra,0xfffff
    80003430:	0a4080e7          	jalr	164(ra) # 800024d0 <bwrite>
  brelse(buf);
    80003434:	8526                	mv	a0,s1
    80003436:	fffff097          	auipc	ra,0xfffff
    8000343a:	0d8080e7          	jalr	216(ra) # 8000250e <brelse>
}
    8000343e:	60e2                	ld	ra,24(sp)
    80003440:	6442                	ld	s0,16(sp)
    80003442:	64a2                	ld	s1,8(sp)
    80003444:	6902                	ld	s2,0(sp)
    80003446:	6105                	addi	sp,sp,32
    80003448:	8082                	ret

000000008000344a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000344a:	00016797          	auipc	a5,0x16
    8000344e:	e027a783          	lw	a5,-510(a5) # 8001924c <log+0x2c>
    80003452:	0af05d63          	blez	a5,8000350c <install_trans+0xc2>
{
    80003456:	7139                	addi	sp,sp,-64
    80003458:	fc06                	sd	ra,56(sp)
    8000345a:	f822                	sd	s0,48(sp)
    8000345c:	f426                	sd	s1,40(sp)
    8000345e:	f04a                	sd	s2,32(sp)
    80003460:	ec4e                	sd	s3,24(sp)
    80003462:	e852                	sd	s4,16(sp)
    80003464:	e456                	sd	s5,8(sp)
    80003466:	e05a                	sd	s6,0(sp)
    80003468:	0080                	addi	s0,sp,64
    8000346a:	8b2a                	mv	s6,a0
    8000346c:	00016a97          	auipc	s5,0x16
    80003470:	de4a8a93          	addi	s5,s5,-540 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003474:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003476:	00016997          	auipc	s3,0x16
    8000347a:	daa98993          	addi	s3,s3,-598 # 80019220 <log>
    8000347e:	a00d                	j	800034a0 <install_trans+0x56>
    brelse(lbuf);
    80003480:	854a                	mv	a0,s2
    80003482:	fffff097          	auipc	ra,0xfffff
    80003486:	08c080e7          	jalr	140(ra) # 8000250e <brelse>
    brelse(dbuf);
    8000348a:	8526                	mv	a0,s1
    8000348c:	fffff097          	auipc	ra,0xfffff
    80003490:	082080e7          	jalr	130(ra) # 8000250e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003494:	2a05                	addiw	s4,s4,1
    80003496:	0a91                	addi	s5,s5,4
    80003498:	02c9a783          	lw	a5,44(s3)
    8000349c:	04fa5e63          	bge	s4,a5,800034f8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a0:	0189a583          	lw	a1,24(s3)
    800034a4:	014585bb          	addw	a1,a1,s4
    800034a8:	2585                	addiw	a1,a1,1
    800034aa:	0289a503          	lw	a0,40(s3)
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	f30080e7          	jalr	-208(ra) # 800023de <bread>
    800034b6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034b8:	000aa583          	lw	a1,0(s5)
    800034bc:	0289a503          	lw	a0,40(s3)
    800034c0:	fffff097          	auipc	ra,0xfffff
    800034c4:	f1e080e7          	jalr	-226(ra) # 800023de <bread>
    800034c8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034ca:	40000613          	li	a2,1024
    800034ce:	05890593          	addi	a1,s2,88
    800034d2:	05850513          	addi	a0,a0,88
    800034d6:	ffffd097          	auipc	ra,0xffffd
    800034da:	d48080e7          	jalr	-696(ra) # 8000021e <memmove>
    bwrite(dbuf);  // write dst to disk
    800034de:	8526                	mv	a0,s1
    800034e0:	fffff097          	auipc	ra,0xfffff
    800034e4:	ff0080e7          	jalr	-16(ra) # 800024d0 <bwrite>
    if(recovering == 0)
    800034e8:	f80b1ce3          	bnez	s6,80003480 <install_trans+0x36>
      bunpin(dbuf);
    800034ec:	8526                	mv	a0,s1
    800034ee:	fffff097          	auipc	ra,0xfffff
    800034f2:	0fa080e7          	jalr	250(ra) # 800025e8 <bunpin>
    800034f6:	b769                	j	80003480 <install_trans+0x36>
}
    800034f8:	70e2                	ld	ra,56(sp)
    800034fa:	7442                	ld	s0,48(sp)
    800034fc:	74a2                	ld	s1,40(sp)
    800034fe:	7902                	ld	s2,32(sp)
    80003500:	69e2                	ld	s3,24(sp)
    80003502:	6a42                	ld	s4,16(sp)
    80003504:	6aa2                	ld	s5,8(sp)
    80003506:	6b02                	ld	s6,0(sp)
    80003508:	6121                	addi	sp,sp,64
    8000350a:	8082                	ret
    8000350c:	8082                	ret

000000008000350e <initlog>:
{
    8000350e:	7179                	addi	sp,sp,-48
    80003510:	f406                	sd	ra,40(sp)
    80003512:	f022                	sd	s0,32(sp)
    80003514:	ec26                	sd	s1,24(sp)
    80003516:	e84a                	sd	s2,16(sp)
    80003518:	e44e                	sd	s3,8(sp)
    8000351a:	1800                	addi	s0,sp,48
    8000351c:	892a                	mv	s2,a0
    8000351e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003520:	00016497          	auipc	s1,0x16
    80003524:	d0048493          	addi	s1,s1,-768 # 80019220 <log>
    80003528:	00005597          	auipc	a1,0x5
    8000352c:	04858593          	addi	a1,a1,72 # 80008570 <etext+0x570>
    80003530:	8526                	mv	a0,s1
    80003532:	00003097          	auipc	ra,0x3
    80003536:	bbe080e7          	jalr	-1090(ra) # 800060f0 <initlock>
  log.start = sb->logstart;
    8000353a:	0149a583          	lw	a1,20(s3)
    8000353e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003540:	0109a783          	lw	a5,16(s3)
    80003544:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003546:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000354a:	854a                	mv	a0,s2
    8000354c:	fffff097          	auipc	ra,0xfffff
    80003550:	e92080e7          	jalr	-366(ra) # 800023de <bread>
  log.lh.n = lh->n;
    80003554:	4d34                	lw	a3,88(a0)
    80003556:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003558:	02d05563          	blez	a3,80003582 <initlog+0x74>
    8000355c:	05c50793          	addi	a5,a0,92
    80003560:	00016717          	auipc	a4,0x16
    80003564:	cf070713          	addi	a4,a4,-784 # 80019250 <log+0x30>
    80003568:	36fd                	addiw	a3,a3,-1
    8000356a:	1682                	slli	a3,a3,0x20
    8000356c:	9281                	srli	a3,a3,0x20
    8000356e:	068a                	slli	a3,a3,0x2
    80003570:	06050613          	addi	a2,a0,96
    80003574:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003576:	4390                	lw	a2,0(a5)
    80003578:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000357a:	0791                	addi	a5,a5,4
    8000357c:	0711                	addi	a4,a4,4
    8000357e:	fed79ce3          	bne	a5,a3,80003576 <initlog+0x68>
  brelse(buf);
    80003582:	fffff097          	auipc	ra,0xfffff
    80003586:	f8c080e7          	jalr	-116(ra) # 8000250e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000358a:	4505                	li	a0,1
    8000358c:	00000097          	auipc	ra,0x0
    80003590:	ebe080e7          	jalr	-322(ra) # 8000344a <install_trans>
  log.lh.n = 0;
    80003594:	00016797          	auipc	a5,0x16
    80003598:	ca07ac23          	sw	zero,-840(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    8000359c:	00000097          	auipc	ra,0x0
    800035a0:	e34080e7          	jalr	-460(ra) # 800033d0 <write_head>
}
    800035a4:	70a2                	ld	ra,40(sp)
    800035a6:	7402                	ld	s0,32(sp)
    800035a8:	64e2                	ld	s1,24(sp)
    800035aa:	6942                	ld	s2,16(sp)
    800035ac:	69a2                	ld	s3,8(sp)
    800035ae:	6145                	addi	sp,sp,48
    800035b0:	8082                	ret

00000000800035b2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035b2:	1101                	addi	sp,sp,-32
    800035b4:	ec06                	sd	ra,24(sp)
    800035b6:	e822                	sd	s0,16(sp)
    800035b8:	e426                	sd	s1,8(sp)
    800035ba:	e04a                	sd	s2,0(sp)
    800035bc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035be:	00016517          	auipc	a0,0x16
    800035c2:	c6250513          	addi	a0,a0,-926 # 80019220 <log>
    800035c6:	00003097          	auipc	ra,0x3
    800035ca:	bba080e7          	jalr	-1094(ra) # 80006180 <acquire>
  while(1){
    if(log.committing){
    800035ce:	00016497          	auipc	s1,0x16
    800035d2:	c5248493          	addi	s1,s1,-942 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d6:	4979                	li	s2,30
    800035d8:	a039                	j	800035e6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035da:	85a6                	mv	a1,s1
    800035dc:	8526                	mv	a0,s1
    800035de:	ffffe097          	auipc	ra,0xffffe
    800035e2:	f76080e7          	jalr	-138(ra) # 80001554 <sleep>
    if(log.committing){
    800035e6:	50dc                	lw	a5,36(s1)
    800035e8:	fbed                	bnez	a5,800035da <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ea:	509c                	lw	a5,32(s1)
    800035ec:	0017871b          	addiw	a4,a5,1
    800035f0:	0007069b          	sext.w	a3,a4
    800035f4:	0027179b          	slliw	a5,a4,0x2
    800035f8:	9fb9                	addw	a5,a5,a4
    800035fa:	0017979b          	slliw	a5,a5,0x1
    800035fe:	54d8                	lw	a4,44(s1)
    80003600:	9fb9                	addw	a5,a5,a4
    80003602:	00f95963          	bge	s2,a5,80003614 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003606:	85a6                	mv	a1,s1
    80003608:	8526                	mv	a0,s1
    8000360a:	ffffe097          	auipc	ra,0xffffe
    8000360e:	f4a080e7          	jalr	-182(ra) # 80001554 <sleep>
    80003612:	bfd1                	j	800035e6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003614:	00016517          	auipc	a0,0x16
    80003618:	c0c50513          	addi	a0,a0,-1012 # 80019220 <log>
    8000361c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000361e:	00003097          	auipc	ra,0x3
    80003622:	c16080e7          	jalr	-1002(ra) # 80006234 <release>
      break;
    }
  }
}
    80003626:	60e2                	ld	ra,24(sp)
    80003628:	6442                	ld	s0,16(sp)
    8000362a:	64a2                	ld	s1,8(sp)
    8000362c:	6902                	ld	s2,0(sp)
    8000362e:	6105                	addi	sp,sp,32
    80003630:	8082                	ret

0000000080003632 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003632:	7139                	addi	sp,sp,-64
    80003634:	fc06                	sd	ra,56(sp)
    80003636:	f822                	sd	s0,48(sp)
    80003638:	f426                	sd	s1,40(sp)
    8000363a:	f04a                	sd	s2,32(sp)
    8000363c:	ec4e                	sd	s3,24(sp)
    8000363e:	e852                	sd	s4,16(sp)
    80003640:	e456                	sd	s5,8(sp)
    80003642:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003644:	00016497          	auipc	s1,0x16
    80003648:	bdc48493          	addi	s1,s1,-1060 # 80019220 <log>
    8000364c:	8526                	mv	a0,s1
    8000364e:	00003097          	auipc	ra,0x3
    80003652:	b32080e7          	jalr	-1230(ra) # 80006180 <acquire>
  log.outstanding -= 1;
    80003656:	509c                	lw	a5,32(s1)
    80003658:	37fd                	addiw	a5,a5,-1
    8000365a:	0007891b          	sext.w	s2,a5
    8000365e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003660:	50dc                	lw	a5,36(s1)
    80003662:	e7b9                	bnez	a5,800036b0 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003664:	04091e63          	bnez	s2,800036c0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003668:	00016497          	auipc	s1,0x16
    8000366c:	bb848493          	addi	s1,s1,-1096 # 80019220 <log>
    80003670:	4785                	li	a5,1
    80003672:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003674:	8526                	mv	a0,s1
    80003676:	00003097          	auipc	ra,0x3
    8000367a:	bbe080e7          	jalr	-1090(ra) # 80006234 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000367e:	54dc                	lw	a5,44(s1)
    80003680:	06f04763          	bgtz	a5,800036ee <end_op+0xbc>
    acquire(&log.lock);
    80003684:	00016497          	auipc	s1,0x16
    80003688:	b9c48493          	addi	s1,s1,-1124 # 80019220 <log>
    8000368c:	8526                	mv	a0,s1
    8000368e:	00003097          	auipc	ra,0x3
    80003692:	af2080e7          	jalr	-1294(ra) # 80006180 <acquire>
    log.committing = 0;
    80003696:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000369a:	8526                	mv	a0,s1
    8000369c:	ffffe097          	auipc	ra,0xffffe
    800036a0:	044080e7          	jalr	68(ra) # 800016e0 <wakeup>
    release(&log.lock);
    800036a4:	8526                	mv	a0,s1
    800036a6:	00003097          	auipc	ra,0x3
    800036aa:	b8e080e7          	jalr	-1138(ra) # 80006234 <release>
}
    800036ae:	a03d                	j	800036dc <end_op+0xaa>
    panic("log.committing");
    800036b0:	00005517          	auipc	a0,0x5
    800036b4:	ec850513          	addi	a0,a0,-312 # 80008578 <etext+0x578>
    800036b8:	00002097          	auipc	ra,0x2
    800036bc:	58c080e7          	jalr	1420(ra) # 80005c44 <panic>
    wakeup(&log);
    800036c0:	00016497          	auipc	s1,0x16
    800036c4:	b6048493          	addi	s1,s1,-1184 # 80019220 <log>
    800036c8:	8526                	mv	a0,s1
    800036ca:	ffffe097          	auipc	ra,0xffffe
    800036ce:	016080e7          	jalr	22(ra) # 800016e0 <wakeup>
  release(&log.lock);
    800036d2:	8526                	mv	a0,s1
    800036d4:	00003097          	auipc	ra,0x3
    800036d8:	b60080e7          	jalr	-1184(ra) # 80006234 <release>
}
    800036dc:	70e2                	ld	ra,56(sp)
    800036de:	7442                	ld	s0,48(sp)
    800036e0:	74a2                	ld	s1,40(sp)
    800036e2:	7902                	ld	s2,32(sp)
    800036e4:	69e2                	ld	s3,24(sp)
    800036e6:	6a42                	ld	s4,16(sp)
    800036e8:	6aa2                	ld	s5,8(sp)
    800036ea:	6121                	addi	sp,sp,64
    800036ec:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ee:	00016a97          	auipc	s5,0x16
    800036f2:	b62a8a93          	addi	s5,s5,-1182 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036f6:	00016a17          	auipc	s4,0x16
    800036fa:	b2aa0a13          	addi	s4,s4,-1238 # 80019220 <log>
    800036fe:	018a2583          	lw	a1,24(s4)
    80003702:	012585bb          	addw	a1,a1,s2
    80003706:	2585                	addiw	a1,a1,1
    80003708:	028a2503          	lw	a0,40(s4)
    8000370c:	fffff097          	auipc	ra,0xfffff
    80003710:	cd2080e7          	jalr	-814(ra) # 800023de <bread>
    80003714:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003716:	000aa583          	lw	a1,0(s5)
    8000371a:	028a2503          	lw	a0,40(s4)
    8000371e:	fffff097          	auipc	ra,0xfffff
    80003722:	cc0080e7          	jalr	-832(ra) # 800023de <bread>
    80003726:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003728:	40000613          	li	a2,1024
    8000372c:	05850593          	addi	a1,a0,88
    80003730:	05848513          	addi	a0,s1,88
    80003734:	ffffd097          	auipc	ra,0xffffd
    80003738:	aea080e7          	jalr	-1302(ra) # 8000021e <memmove>
    bwrite(to);  // write the log
    8000373c:	8526                	mv	a0,s1
    8000373e:	fffff097          	auipc	ra,0xfffff
    80003742:	d92080e7          	jalr	-622(ra) # 800024d0 <bwrite>
    brelse(from);
    80003746:	854e                	mv	a0,s3
    80003748:	fffff097          	auipc	ra,0xfffff
    8000374c:	dc6080e7          	jalr	-570(ra) # 8000250e <brelse>
    brelse(to);
    80003750:	8526                	mv	a0,s1
    80003752:	fffff097          	auipc	ra,0xfffff
    80003756:	dbc080e7          	jalr	-580(ra) # 8000250e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000375a:	2905                	addiw	s2,s2,1
    8000375c:	0a91                	addi	s5,s5,4
    8000375e:	02ca2783          	lw	a5,44(s4)
    80003762:	f8f94ee3          	blt	s2,a5,800036fe <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	c6a080e7          	jalr	-918(ra) # 800033d0 <write_head>
    install_trans(0); // Now install writes to home locations
    8000376e:	4501                	li	a0,0
    80003770:	00000097          	auipc	ra,0x0
    80003774:	cda080e7          	jalr	-806(ra) # 8000344a <install_trans>
    log.lh.n = 0;
    80003778:	00016797          	auipc	a5,0x16
    8000377c:	ac07aa23          	sw	zero,-1324(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003780:	00000097          	auipc	ra,0x0
    80003784:	c50080e7          	jalr	-944(ra) # 800033d0 <write_head>
    80003788:	bdf5                	j	80003684 <end_op+0x52>

000000008000378a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000378a:	1101                	addi	sp,sp,-32
    8000378c:	ec06                	sd	ra,24(sp)
    8000378e:	e822                	sd	s0,16(sp)
    80003790:	e426                	sd	s1,8(sp)
    80003792:	e04a                	sd	s2,0(sp)
    80003794:	1000                	addi	s0,sp,32
    80003796:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003798:	00016917          	auipc	s2,0x16
    8000379c:	a8890913          	addi	s2,s2,-1400 # 80019220 <log>
    800037a0:	854a                	mv	a0,s2
    800037a2:	00003097          	auipc	ra,0x3
    800037a6:	9de080e7          	jalr	-1570(ra) # 80006180 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037aa:	02c92603          	lw	a2,44(s2)
    800037ae:	47f5                	li	a5,29
    800037b0:	06c7c563          	blt	a5,a2,8000381a <log_write+0x90>
    800037b4:	00016797          	auipc	a5,0x16
    800037b8:	a887a783          	lw	a5,-1400(a5) # 8001923c <log+0x1c>
    800037bc:	37fd                	addiw	a5,a5,-1
    800037be:	04f65e63          	bge	a2,a5,8000381a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037c2:	00016797          	auipc	a5,0x16
    800037c6:	a7e7a783          	lw	a5,-1410(a5) # 80019240 <log+0x20>
    800037ca:	06f05063          	blez	a5,8000382a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037ce:	4781                	li	a5,0
    800037d0:	06c05563          	blez	a2,8000383a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d4:	44cc                	lw	a1,12(s1)
    800037d6:	00016717          	auipc	a4,0x16
    800037da:	a7a70713          	addi	a4,a4,-1414 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037de:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e0:	4314                	lw	a3,0(a4)
    800037e2:	04b68c63          	beq	a3,a1,8000383a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037e6:	2785                	addiw	a5,a5,1
    800037e8:	0711                	addi	a4,a4,4
    800037ea:	fef61be3          	bne	a2,a5,800037e0 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037ee:	0621                	addi	a2,a2,8
    800037f0:	060a                	slli	a2,a2,0x2
    800037f2:	00016797          	auipc	a5,0x16
    800037f6:	a2e78793          	addi	a5,a5,-1490 # 80019220 <log>
    800037fa:	963e                	add	a2,a2,a5
    800037fc:	44dc                	lw	a5,12(s1)
    800037fe:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003800:	8526                	mv	a0,s1
    80003802:	fffff097          	auipc	ra,0xfffff
    80003806:	daa080e7          	jalr	-598(ra) # 800025ac <bpin>
    log.lh.n++;
    8000380a:	00016717          	auipc	a4,0x16
    8000380e:	a1670713          	addi	a4,a4,-1514 # 80019220 <log>
    80003812:	575c                	lw	a5,44(a4)
    80003814:	2785                	addiw	a5,a5,1
    80003816:	d75c                	sw	a5,44(a4)
    80003818:	a835                	j	80003854 <log_write+0xca>
    panic("too big a transaction");
    8000381a:	00005517          	auipc	a0,0x5
    8000381e:	d6e50513          	addi	a0,a0,-658 # 80008588 <etext+0x588>
    80003822:	00002097          	auipc	ra,0x2
    80003826:	422080e7          	jalr	1058(ra) # 80005c44 <panic>
    panic("log_write outside of trans");
    8000382a:	00005517          	auipc	a0,0x5
    8000382e:	d7650513          	addi	a0,a0,-650 # 800085a0 <etext+0x5a0>
    80003832:	00002097          	auipc	ra,0x2
    80003836:	412080e7          	jalr	1042(ra) # 80005c44 <panic>
  log.lh.block[i] = b->blockno;
    8000383a:	00878713          	addi	a4,a5,8
    8000383e:	00271693          	slli	a3,a4,0x2
    80003842:	00016717          	auipc	a4,0x16
    80003846:	9de70713          	addi	a4,a4,-1570 # 80019220 <log>
    8000384a:	9736                	add	a4,a4,a3
    8000384c:	44d4                	lw	a3,12(s1)
    8000384e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003850:	faf608e3          	beq	a2,a5,80003800 <log_write+0x76>
  }
  release(&log.lock);
    80003854:	00016517          	auipc	a0,0x16
    80003858:	9cc50513          	addi	a0,a0,-1588 # 80019220 <log>
    8000385c:	00003097          	auipc	ra,0x3
    80003860:	9d8080e7          	jalr	-1576(ra) # 80006234 <release>
}
    80003864:	60e2                	ld	ra,24(sp)
    80003866:	6442                	ld	s0,16(sp)
    80003868:	64a2                	ld	s1,8(sp)
    8000386a:	6902                	ld	s2,0(sp)
    8000386c:	6105                	addi	sp,sp,32
    8000386e:	8082                	ret

0000000080003870 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003870:	1101                	addi	sp,sp,-32
    80003872:	ec06                	sd	ra,24(sp)
    80003874:	e822                	sd	s0,16(sp)
    80003876:	e426                	sd	s1,8(sp)
    80003878:	e04a                	sd	s2,0(sp)
    8000387a:	1000                	addi	s0,sp,32
    8000387c:	84aa                	mv	s1,a0
    8000387e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003880:	00005597          	auipc	a1,0x5
    80003884:	d4058593          	addi	a1,a1,-704 # 800085c0 <etext+0x5c0>
    80003888:	0521                	addi	a0,a0,8
    8000388a:	00003097          	auipc	ra,0x3
    8000388e:	866080e7          	jalr	-1946(ra) # 800060f0 <initlock>
  lk->name = name;
    80003892:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003896:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000389a:	0204a423          	sw	zero,40(s1)
}
    8000389e:	60e2                	ld	ra,24(sp)
    800038a0:	6442                	ld	s0,16(sp)
    800038a2:	64a2                	ld	s1,8(sp)
    800038a4:	6902                	ld	s2,0(sp)
    800038a6:	6105                	addi	sp,sp,32
    800038a8:	8082                	ret

00000000800038aa <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038aa:	1101                	addi	sp,sp,-32
    800038ac:	ec06                	sd	ra,24(sp)
    800038ae:	e822                	sd	s0,16(sp)
    800038b0:	e426                	sd	s1,8(sp)
    800038b2:	e04a                	sd	s2,0(sp)
    800038b4:	1000                	addi	s0,sp,32
    800038b6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038b8:	00850913          	addi	s2,a0,8
    800038bc:	854a                	mv	a0,s2
    800038be:	00003097          	auipc	ra,0x3
    800038c2:	8c2080e7          	jalr	-1854(ra) # 80006180 <acquire>
  while (lk->locked) {
    800038c6:	409c                	lw	a5,0(s1)
    800038c8:	cb89                	beqz	a5,800038da <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038ca:	85ca                	mv	a1,s2
    800038cc:	8526                	mv	a0,s1
    800038ce:	ffffe097          	auipc	ra,0xffffe
    800038d2:	c86080e7          	jalr	-890(ra) # 80001554 <sleep>
  while (lk->locked) {
    800038d6:	409c                	lw	a5,0(s1)
    800038d8:	fbed                	bnez	a5,800038ca <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038da:	4785                	li	a5,1
    800038dc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038de:	ffffd097          	auipc	ra,0xffffd
    800038e2:	5ae080e7          	jalr	1454(ra) # 80000e8c <myproc>
    800038e6:	591c                	lw	a5,48(a0)
    800038e8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ea:	854a                	mv	a0,s2
    800038ec:	00003097          	auipc	ra,0x3
    800038f0:	948080e7          	jalr	-1720(ra) # 80006234 <release>
}
    800038f4:	60e2                	ld	ra,24(sp)
    800038f6:	6442                	ld	s0,16(sp)
    800038f8:	64a2                	ld	s1,8(sp)
    800038fa:	6902                	ld	s2,0(sp)
    800038fc:	6105                	addi	sp,sp,32
    800038fe:	8082                	ret

0000000080003900 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003900:	1101                	addi	sp,sp,-32
    80003902:	ec06                	sd	ra,24(sp)
    80003904:	e822                	sd	s0,16(sp)
    80003906:	e426                	sd	s1,8(sp)
    80003908:	e04a                	sd	s2,0(sp)
    8000390a:	1000                	addi	s0,sp,32
    8000390c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000390e:	00850913          	addi	s2,a0,8
    80003912:	854a                	mv	a0,s2
    80003914:	00003097          	auipc	ra,0x3
    80003918:	86c080e7          	jalr	-1940(ra) # 80006180 <acquire>
  lk->locked = 0;
    8000391c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003920:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003924:	8526                	mv	a0,s1
    80003926:	ffffe097          	auipc	ra,0xffffe
    8000392a:	dba080e7          	jalr	-582(ra) # 800016e0 <wakeup>
  release(&lk->lk);
    8000392e:	854a                	mv	a0,s2
    80003930:	00003097          	auipc	ra,0x3
    80003934:	904080e7          	jalr	-1788(ra) # 80006234 <release>
}
    80003938:	60e2                	ld	ra,24(sp)
    8000393a:	6442                	ld	s0,16(sp)
    8000393c:	64a2                	ld	s1,8(sp)
    8000393e:	6902                	ld	s2,0(sp)
    80003940:	6105                	addi	sp,sp,32
    80003942:	8082                	ret

0000000080003944 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003944:	7179                	addi	sp,sp,-48
    80003946:	f406                	sd	ra,40(sp)
    80003948:	f022                	sd	s0,32(sp)
    8000394a:	ec26                	sd	s1,24(sp)
    8000394c:	e84a                	sd	s2,16(sp)
    8000394e:	e44e                	sd	s3,8(sp)
    80003950:	1800                	addi	s0,sp,48
    80003952:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003954:	00850913          	addi	s2,a0,8
    80003958:	854a                	mv	a0,s2
    8000395a:	00003097          	auipc	ra,0x3
    8000395e:	826080e7          	jalr	-2010(ra) # 80006180 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003962:	409c                	lw	a5,0(s1)
    80003964:	ef99                	bnez	a5,80003982 <holdingsleep+0x3e>
    80003966:	4481                	li	s1,0
  release(&lk->lk);
    80003968:	854a                	mv	a0,s2
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	8ca080e7          	jalr	-1846(ra) # 80006234 <release>
  return r;
}
    80003972:	8526                	mv	a0,s1
    80003974:	70a2                	ld	ra,40(sp)
    80003976:	7402                	ld	s0,32(sp)
    80003978:	64e2                	ld	s1,24(sp)
    8000397a:	6942                	ld	s2,16(sp)
    8000397c:	69a2                	ld	s3,8(sp)
    8000397e:	6145                	addi	sp,sp,48
    80003980:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003982:	0284a983          	lw	s3,40(s1)
    80003986:	ffffd097          	auipc	ra,0xffffd
    8000398a:	506080e7          	jalr	1286(ra) # 80000e8c <myproc>
    8000398e:	5904                	lw	s1,48(a0)
    80003990:	413484b3          	sub	s1,s1,s3
    80003994:	0014b493          	seqz	s1,s1
    80003998:	bfc1                	j	80003968 <holdingsleep+0x24>

000000008000399a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000399a:	1141                	addi	sp,sp,-16
    8000399c:	e406                	sd	ra,8(sp)
    8000399e:	e022                	sd	s0,0(sp)
    800039a0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039a2:	00005597          	auipc	a1,0x5
    800039a6:	c2e58593          	addi	a1,a1,-978 # 800085d0 <etext+0x5d0>
    800039aa:	00016517          	auipc	a0,0x16
    800039ae:	9be50513          	addi	a0,a0,-1602 # 80019368 <ftable>
    800039b2:	00002097          	auipc	ra,0x2
    800039b6:	73e080e7          	jalr	1854(ra) # 800060f0 <initlock>
}
    800039ba:	60a2                	ld	ra,8(sp)
    800039bc:	6402                	ld	s0,0(sp)
    800039be:	0141                	addi	sp,sp,16
    800039c0:	8082                	ret

00000000800039c2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039c2:	1101                	addi	sp,sp,-32
    800039c4:	ec06                	sd	ra,24(sp)
    800039c6:	e822                	sd	s0,16(sp)
    800039c8:	e426                	sd	s1,8(sp)
    800039ca:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039cc:	00016517          	auipc	a0,0x16
    800039d0:	99c50513          	addi	a0,a0,-1636 # 80019368 <ftable>
    800039d4:	00002097          	auipc	ra,0x2
    800039d8:	7ac080e7          	jalr	1964(ra) # 80006180 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039dc:	00016497          	auipc	s1,0x16
    800039e0:	9a448493          	addi	s1,s1,-1628 # 80019380 <ftable+0x18>
    800039e4:	00017717          	auipc	a4,0x17
    800039e8:	93c70713          	addi	a4,a4,-1732 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039ec:	40dc                	lw	a5,4(s1)
    800039ee:	cf99                	beqz	a5,80003a0c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f0:	02848493          	addi	s1,s1,40
    800039f4:	fee49ce3          	bne	s1,a4,800039ec <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039f8:	00016517          	auipc	a0,0x16
    800039fc:	97050513          	addi	a0,a0,-1680 # 80019368 <ftable>
    80003a00:	00003097          	auipc	ra,0x3
    80003a04:	834080e7          	jalr	-1996(ra) # 80006234 <release>
  return 0;
    80003a08:	4481                	li	s1,0
    80003a0a:	a819                	j	80003a20 <filealloc+0x5e>
      f->ref = 1;
    80003a0c:	4785                	li	a5,1
    80003a0e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a10:	00016517          	auipc	a0,0x16
    80003a14:	95850513          	addi	a0,a0,-1704 # 80019368 <ftable>
    80003a18:	00003097          	auipc	ra,0x3
    80003a1c:	81c080e7          	jalr	-2020(ra) # 80006234 <release>
}
    80003a20:	8526                	mv	a0,s1
    80003a22:	60e2                	ld	ra,24(sp)
    80003a24:	6442                	ld	s0,16(sp)
    80003a26:	64a2                	ld	s1,8(sp)
    80003a28:	6105                	addi	sp,sp,32
    80003a2a:	8082                	ret

0000000080003a2c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a2c:	1101                	addi	sp,sp,-32
    80003a2e:	ec06                	sd	ra,24(sp)
    80003a30:	e822                	sd	s0,16(sp)
    80003a32:	e426                	sd	s1,8(sp)
    80003a34:	1000                	addi	s0,sp,32
    80003a36:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a38:	00016517          	auipc	a0,0x16
    80003a3c:	93050513          	addi	a0,a0,-1744 # 80019368 <ftable>
    80003a40:	00002097          	auipc	ra,0x2
    80003a44:	740080e7          	jalr	1856(ra) # 80006180 <acquire>
  if(f->ref < 1)
    80003a48:	40dc                	lw	a5,4(s1)
    80003a4a:	02f05263          	blez	a5,80003a6e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a4e:	2785                	addiw	a5,a5,1
    80003a50:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a52:	00016517          	auipc	a0,0x16
    80003a56:	91650513          	addi	a0,a0,-1770 # 80019368 <ftable>
    80003a5a:	00002097          	auipc	ra,0x2
    80003a5e:	7da080e7          	jalr	2010(ra) # 80006234 <release>
  return f;
}
    80003a62:	8526                	mv	a0,s1
    80003a64:	60e2                	ld	ra,24(sp)
    80003a66:	6442                	ld	s0,16(sp)
    80003a68:	64a2                	ld	s1,8(sp)
    80003a6a:	6105                	addi	sp,sp,32
    80003a6c:	8082                	ret
    panic("filedup");
    80003a6e:	00005517          	auipc	a0,0x5
    80003a72:	b6a50513          	addi	a0,a0,-1174 # 800085d8 <etext+0x5d8>
    80003a76:	00002097          	auipc	ra,0x2
    80003a7a:	1ce080e7          	jalr	462(ra) # 80005c44 <panic>

0000000080003a7e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a7e:	7139                	addi	sp,sp,-64
    80003a80:	fc06                	sd	ra,56(sp)
    80003a82:	f822                	sd	s0,48(sp)
    80003a84:	f426                	sd	s1,40(sp)
    80003a86:	f04a                	sd	s2,32(sp)
    80003a88:	ec4e                	sd	s3,24(sp)
    80003a8a:	e852                	sd	s4,16(sp)
    80003a8c:	e456                	sd	s5,8(sp)
    80003a8e:	0080                	addi	s0,sp,64
    80003a90:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a92:	00016517          	auipc	a0,0x16
    80003a96:	8d650513          	addi	a0,a0,-1834 # 80019368 <ftable>
    80003a9a:	00002097          	auipc	ra,0x2
    80003a9e:	6e6080e7          	jalr	1766(ra) # 80006180 <acquire>
  if(f->ref < 1)
    80003aa2:	40dc                	lw	a5,4(s1)
    80003aa4:	06f05163          	blez	a5,80003b06 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003aa8:	37fd                	addiw	a5,a5,-1
    80003aaa:	0007871b          	sext.w	a4,a5
    80003aae:	c0dc                	sw	a5,4(s1)
    80003ab0:	06e04363          	bgtz	a4,80003b16 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ab4:	0004a903          	lw	s2,0(s1)
    80003ab8:	0094ca83          	lbu	s5,9(s1)
    80003abc:	0104ba03          	ld	s4,16(s1)
    80003ac0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ac4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ac8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003acc:	00016517          	auipc	a0,0x16
    80003ad0:	89c50513          	addi	a0,a0,-1892 # 80019368 <ftable>
    80003ad4:	00002097          	auipc	ra,0x2
    80003ad8:	760080e7          	jalr	1888(ra) # 80006234 <release>

  if(ff.type == FD_PIPE){
    80003adc:	4785                	li	a5,1
    80003ade:	04f90d63          	beq	s2,a5,80003b38 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ae2:	3979                	addiw	s2,s2,-2
    80003ae4:	4785                	li	a5,1
    80003ae6:	0527e063          	bltu	a5,s2,80003b26 <fileclose+0xa8>
    begin_op();
    80003aea:	00000097          	auipc	ra,0x0
    80003aee:	ac8080e7          	jalr	-1336(ra) # 800035b2 <begin_op>
    iput(ff.ip);
    80003af2:	854e                	mv	a0,s3
    80003af4:	fffff097          	auipc	ra,0xfffff
    80003af8:	2a6080e7          	jalr	678(ra) # 80002d9a <iput>
    end_op();
    80003afc:	00000097          	auipc	ra,0x0
    80003b00:	b36080e7          	jalr	-1226(ra) # 80003632 <end_op>
    80003b04:	a00d                	j	80003b26 <fileclose+0xa8>
    panic("fileclose");
    80003b06:	00005517          	auipc	a0,0x5
    80003b0a:	ada50513          	addi	a0,a0,-1318 # 800085e0 <etext+0x5e0>
    80003b0e:	00002097          	auipc	ra,0x2
    80003b12:	136080e7          	jalr	310(ra) # 80005c44 <panic>
    release(&ftable.lock);
    80003b16:	00016517          	auipc	a0,0x16
    80003b1a:	85250513          	addi	a0,a0,-1966 # 80019368 <ftable>
    80003b1e:	00002097          	auipc	ra,0x2
    80003b22:	716080e7          	jalr	1814(ra) # 80006234 <release>
  }
}
    80003b26:	70e2                	ld	ra,56(sp)
    80003b28:	7442                	ld	s0,48(sp)
    80003b2a:	74a2                	ld	s1,40(sp)
    80003b2c:	7902                	ld	s2,32(sp)
    80003b2e:	69e2                	ld	s3,24(sp)
    80003b30:	6a42                	ld	s4,16(sp)
    80003b32:	6aa2                	ld	s5,8(sp)
    80003b34:	6121                	addi	sp,sp,64
    80003b36:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b38:	85d6                	mv	a1,s5
    80003b3a:	8552                	mv	a0,s4
    80003b3c:	00000097          	auipc	ra,0x0
    80003b40:	34c080e7          	jalr	844(ra) # 80003e88 <pipeclose>
    80003b44:	b7cd                	j	80003b26 <fileclose+0xa8>

0000000080003b46 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b46:	715d                	addi	sp,sp,-80
    80003b48:	e486                	sd	ra,72(sp)
    80003b4a:	e0a2                	sd	s0,64(sp)
    80003b4c:	fc26                	sd	s1,56(sp)
    80003b4e:	f84a                	sd	s2,48(sp)
    80003b50:	f44e                	sd	s3,40(sp)
    80003b52:	0880                	addi	s0,sp,80
    80003b54:	84aa                	mv	s1,a0
    80003b56:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b58:	ffffd097          	auipc	ra,0xffffd
    80003b5c:	334080e7          	jalr	820(ra) # 80000e8c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b60:	409c                	lw	a5,0(s1)
    80003b62:	37f9                	addiw	a5,a5,-2
    80003b64:	4705                	li	a4,1
    80003b66:	04f76763          	bltu	a4,a5,80003bb4 <filestat+0x6e>
    80003b6a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b6c:	6c88                	ld	a0,24(s1)
    80003b6e:	fffff097          	auipc	ra,0xfffff
    80003b72:	072080e7          	jalr	114(ra) # 80002be0 <ilock>
    stati(f->ip, &st);
    80003b76:	fb840593          	addi	a1,s0,-72
    80003b7a:	6c88                	ld	a0,24(s1)
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	2ee080e7          	jalr	750(ra) # 80002e6a <stati>
    iunlock(f->ip);
    80003b84:	6c88                	ld	a0,24(s1)
    80003b86:	fffff097          	auipc	ra,0xfffff
    80003b8a:	11c080e7          	jalr	284(ra) # 80002ca2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b8e:	46e1                	li	a3,24
    80003b90:	fb840613          	addi	a2,s0,-72
    80003b94:	85ce                	mv	a1,s3
    80003b96:	05093503          	ld	a0,80(s2)
    80003b9a:	ffffd097          	auipc	ra,0xffffd
    80003b9e:	fb2080e7          	jalr	-78(ra) # 80000b4c <copyout>
    80003ba2:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003ba6:	60a6                	ld	ra,72(sp)
    80003ba8:	6406                	ld	s0,64(sp)
    80003baa:	74e2                	ld	s1,56(sp)
    80003bac:	7942                	ld	s2,48(sp)
    80003bae:	79a2                	ld	s3,40(sp)
    80003bb0:	6161                	addi	sp,sp,80
    80003bb2:	8082                	ret
  return -1;
    80003bb4:	557d                	li	a0,-1
    80003bb6:	bfc5                	j	80003ba6 <filestat+0x60>

0000000080003bb8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bb8:	7179                	addi	sp,sp,-48
    80003bba:	f406                	sd	ra,40(sp)
    80003bbc:	f022                	sd	s0,32(sp)
    80003bbe:	ec26                	sd	s1,24(sp)
    80003bc0:	e84a                	sd	s2,16(sp)
    80003bc2:	e44e                	sd	s3,8(sp)
    80003bc4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bc6:	00854783          	lbu	a5,8(a0)
    80003bca:	c3d5                	beqz	a5,80003c6e <fileread+0xb6>
    80003bcc:	84aa                	mv	s1,a0
    80003bce:	89ae                	mv	s3,a1
    80003bd0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bd2:	411c                	lw	a5,0(a0)
    80003bd4:	4705                	li	a4,1
    80003bd6:	04e78963          	beq	a5,a4,80003c28 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bda:	470d                	li	a4,3
    80003bdc:	04e78d63          	beq	a5,a4,80003c36 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003be0:	4709                	li	a4,2
    80003be2:	06e79e63          	bne	a5,a4,80003c5e <fileread+0xa6>
    ilock(f->ip);
    80003be6:	6d08                	ld	a0,24(a0)
    80003be8:	fffff097          	auipc	ra,0xfffff
    80003bec:	ff8080e7          	jalr	-8(ra) # 80002be0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bf0:	874a                	mv	a4,s2
    80003bf2:	5094                	lw	a3,32(s1)
    80003bf4:	864e                	mv	a2,s3
    80003bf6:	4585                	li	a1,1
    80003bf8:	6c88                	ld	a0,24(s1)
    80003bfa:	fffff097          	auipc	ra,0xfffff
    80003bfe:	29a080e7          	jalr	666(ra) # 80002e94 <readi>
    80003c02:	892a                	mv	s2,a0
    80003c04:	00a05563          	blez	a0,80003c0e <fileread+0x56>
      f->off += r;
    80003c08:	509c                	lw	a5,32(s1)
    80003c0a:	9fa9                	addw	a5,a5,a0
    80003c0c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c0e:	6c88                	ld	a0,24(s1)
    80003c10:	fffff097          	auipc	ra,0xfffff
    80003c14:	092080e7          	jalr	146(ra) # 80002ca2 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c18:	854a                	mv	a0,s2
    80003c1a:	70a2                	ld	ra,40(sp)
    80003c1c:	7402                	ld	s0,32(sp)
    80003c1e:	64e2                	ld	s1,24(sp)
    80003c20:	6942                	ld	s2,16(sp)
    80003c22:	69a2                	ld	s3,8(sp)
    80003c24:	6145                	addi	sp,sp,48
    80003c26:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c28:	6908                	ld	a0,16(a0)
    80003c2a:	00000097          	auipc	ra,0x0
    80003c2e:	3c0080e7          	jalr	960(ra) # 80003fea <piperead>
    80003c32:	892a                	mv	s2,a0
    80003c34:	b7d5                	j	80003c18 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c36:	02451783          	lh	a5,36(a0)
    80003c3a:	03079693          	slli	a3,a5,0x30
    80003c3e:	92c1                	srli	a3,a3,0x30
    80003c40:	4725                	li	a4,9
    80003c42:	02d76863          	bltu	a4,a3,80003c72 <fileread+0xba>
    80003c46:	0792                	slli	a5,a5,0x4
    80003c48:	00015717          	auipc	a4,0x15
    80003c4c:	68070713          	addi	a4,a4,1664 # 800192c8 <devsw>
    80003c50:	97ba                	add	a5,a5,a4
    80003c52:	639c                	ld	a5,0(a5)
    80003c54:	c38d                	beqz	a5,80003c76 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c56:	4505                	li	a0,1
    80003c58:	9782                	jalr	a5
    80003c5a:	892a                	mv	s2,a0
    80003c5c:	bf75                	j	80003c18 <fileread+0x60>
    panic("fileread");
    80003c5e:	00005517          	auipc	a0,0x5
    80003c62:	99250513          	addi	a0,a0,-1646 # 800085f0 <etext+0x5f0>
    80003c66:	00002097          	auipc	ra,0x2
    80003c6a:	fde080e7          	jalr	-34(ra) # 80005c44 <panic>
    return -1;
    80003c6e:	597d                	li	s2,-1
    80003c70:	b765                	j	80003c18 <fileread+0x60>
      return -1;
    80003c72:	597d                	li	s2,-1
    80003c74:	b755                	j	80003c18 <fileread+0x60>
    80003c76:	597d                	li	s2,-1
    80003c78:	b745                	j	80003c18 <fileread+0x60>

0000000080003c7a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c7a:	715d                	addi	sp,sp,-80
    80003c7c:	e486                	sd	ra,72(sp)
    80003c7e:	e0a2                	sd	s0,64(sp)
    80003c80:	fc26                	sd	s1,56(sp)
    80003c82:	f84a                	sd	s2,48(sp)
    80003c84:	f44e                	sd	s3,40(sp)
    80003c86:	f052                	sd	s4,32(sp)
    80003c88:	ec56                	sd	s5,24(sp)
    80003c8a:	e85a                	sd	s6,16(sp)
    80003c8c:	e45e                	sd	s7,8(sp)
    80003c8e:	e062                	sd	s8,0(sp)
    80003c90:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c92:	00954783          	lbu	a5,9(a0)
    80003c96:	10078663          	beqz	a5,80003da2 <filewrite+0x128>
    80003c9a:	892a                	mv	s2,a0
    80003c9c:	8aae                	mv	s5,a1
    80003c9e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ca0:	411c                	lw	a5,0(a0)
    80003ca2:	4705                	li	a4,1
    80003ca4:	02e78263          	beq	a5,a4,80003cc8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ca8:	470d                	li	a4,3
    80003caa:	02e78663          	beq	a5,a4,80003cd6 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cae:	4709                	li	a4,2
    80003cb0:	0ee79163          	bne	a5,a4,80003d92 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cb4:	0ac05d63          	blez	a2,80003d6e <filewrite+0xf4>
    int i = 0;
    80003cb8:	4981                	li	s3,0
    80003cba:	6b05                	lui	s6,0x1
    80003cbc:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cc0:	6b85                	lui	s7,0x1
    80003cc2:	c00b8b9b          	addiw	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cc6:	a861                	j	80003d5e <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cc8:	6908                	ld	a0,16(a0)
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	22e080e7          	jalr	558(ra) # 80003ef8 <pipewrite>
    80003cd2:	8a2a                	mv	s4,a0
    80003cd4:	a045                	j	80003d74 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cd6:	02451783          	lh	a5,36(a0)
    80003cda:	03079693          	slli	a3,a5,0x30
    80003cde:	92c1                	srli	a3,a3,0x30
    80003ce0:	4725                	li	a4,9
    80003ce2:	0cd76263          	bltu	a4,a3,80003da6 <filewrite+0x12c>
    80003ce6:	0792                	slli	a5,a5,0x4
    80003ce8:	00015717          	auipc	a4,0x15
    80003cec:	5e070713          	addi	a4,a4,1504 # 800192c8 <devsw>
    80003cf0:	97ba                	add	a5,a5,a4
    80003cf2:	679c                	ld	a5,8(a5)
    80003cf4:	cbdd                	beqz	a5,80003daa <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cf6:	4505                	li	a0,1
    80003cf8:	9782                	jalr	a5
    80003cfa:	8a2a                	mv	s4,a0
    80003cfc:	a8a5                	j	80003d74 <filewrite+0xfa>
    80003cfe:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d02:	00000097          	auipc	ra,0x0
    80003d06:	8b0080e7          	jalr	-1872(ra) # 800035b2 <begin_op>
      ilock(f->ip);
    80003d0a:	01893503          	ld	a0,24(s2)
    80003d0e:	fffff097          	auipc	ra,0xfffff
    80003d12:	ed2080e7          	jalr	-302(ra) # 80002be0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d16:	8762                	mv	a4,s8
    80003d18:	02092683          	lw	a3,32(s2)
    80003d1c:	01598633          	add	a2,s3,s5
    80003d20:	4585                	li	a1,1
    80003d22:	01893503          	ld	a0,24(s2)
    80003d26:	fffff097          	auipc	ra,0xfffff
    80003d2a:	266080e7          	jalr	614(ra) # 80002f8c <writei>
    80003d2e:	84aa                	mv	s1,a0
    80003d30:	00a05763          	blez	a0,80003d3e <filewrite+0xc4>
        f->off += r;
    80003d34:	02092783          	lw	a5,32(s2)
    80003d38:	9fa9                	addw	a5,a5,a0
    80003d3a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d3e:	01893503          	ld	a0,24(s2)
    80003d42:	fffff097          	auipc	ra,0xfffff
    80003d46:	f60080e7          	jalr	-160(ra) # 80002ca2 <iunlock>
      end_op();
    80003d4a:	00000097          	auipc	ra,0x0
    80003d4e:	8e8080e7          	jalr	-1816(ra) # 80003632 <end_op>

      if(r != n1){
    80003d52:	009c1f63          	bne	s8,s1,80003d70 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d56:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d5a:	0149db63          	bge	s3,s4,80003d70 <filewrite+0xf6>
      int n1 = n - i;
    80003d5e:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d62:	84be                	mv	s1,a5
    80003d64:	2781                	sext.w	a5,a5
    80003d66:	f8fb5ce3          	bge	s6,a5,80003cfe <filewrite+0x84>
    80003d6a:	84de                	mv	s1,s7
    80003d6c:	bf49                	j	80003cfe <filewrite+0x84>
    int i = 0;
    80003d6e:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d70:	013a1f63          	bne	s4,s3,80003d8e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d74:	8552                	mv	a0,s4
    80003d76:	60a6                	ld	ra,72(sp)
    80003d78:	6406                	ld	s0,64(sp)
    80003d7a:	74e2                	ld	s1,56(sp)
    80003d7c:	7942                	ld	s2,48(sp)
    80003d7e:	79a2                	ld	s3,40(sp)
    80003d80:	7a02                	ld	s4,32(sp)
    80003d82:	6ae2                	ld	s5,24(sp)
    80003d84:	6b42                	ld	s6,16(sp)
    80003d86:	6ba2                	ld	s7,8(sp)
    80003d88:	6c02                	ld	s8,0(sp)
    80003d8a:	6161                	addi	sp,sp,80
    80003d8c:	8082                	ret
    ret = (i == n ? n : -1);
    80003d8e:	5a7d                	li	s4,-1
    80003d90:	b7d5                	j	80003d74 <filewrite+0xfa>
    panic("filewrite");
    80003d92:	00005517          	auipc	a0,0x5
    80003d96:	86e50513          	addi	a0,a0,-1938 # 80008600 <etext+0x600>
    80003d9a:	00002097          	auipc	ra,0x2
    80003d9e:	eaa080e7          	jalr	-342(ra) # 80005c44 <panic>
    return -1;
    80003da2:	5a7d                	li	s4,-1
    80003da4:	bfc1                	j	80003d74 <filewrite+0xfa>
      return -1;
    80003da6:	5a7d                	li	s4,-1
    80003da8:	b7f1                	j	80003d74 <filewrite+0xfa>
    80003daa:	5a7d                	li	s4,-1
    80003dac:	b7e1                	j	80003d74 <filewrite+0xfa>

0000000080003dae <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dae:	7179                	addi	sp,sp,-48
    80003db0:	f406                	sd	ra,40(sp)
    80003db2:	f022                	sd	s0,32(sp)
    80003db4:	ec26                	sd	s1,24(sp)
    80003db6:	e84a                	sd	s2,16(sp)
    80003db8:	e44e                	sd	s3,8(sp)
    80003dba:	e052                	sd	s4,0(sp)
    80003dbc:	1800                	addi	s0,sp,48
    80003dbe:	84aa                	mv	s1,a0
    80003dc0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dc2:	0005b023          	sd	zero,0(a1)
    80003dc6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	bf8080e7          	jalr	-1032(ra) # 800039c2 <filealloc>
    80003dd2:	e088                	sd	a0,0(s1)
    80003dd4:	c551                	beqz	a0,80003e60 <pipealloc+0xb2>
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	bec080e7          	jalr	-1044(ra) # 800039c2 <filealloc>
    80003dde:	00aa3023          	sd	a0,0(s4)
    80003de2:	c92d                	beqz	a0,80003e54 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003de4:	ffffc097          	auipc	ra,0xffffc
    80003de8:	334080e7          	jalr	820(ra) # 80000118 <kalloc>
    80003dec:	892a                	mv	s2,a0
    80003dee:	c125                	beqz	a0,80003e4e <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003df0:	4985                	li	s3,1
    80003df2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003df6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dfa:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dfe:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e02:	00004597          	auipc	a1,0x4
    80003e06:	5ae58593          	addi	a1,a1,1454 # 800083b0 <etext+0x3b0>
    80003e0a:	00002097          	auipc	ra,0x2
    80003e0e:	2e6080e7          	jalr	742(ra) # 800060f0 <initlock>
  (*f0)->type = FD_PIPE;
    80003e12:	609c                	ld	a5,0(s1)
    80003e14:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e18:	609c                	ld	a5,0(s1)
    80003e1a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e1e:	609c                	ld	a5,0(s1)
    80003e20:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e24:	609c                	ld	a5,0(s1)
    80003e26:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e2a:	000a3783          	ld	a5,0(s4)
    80003e2e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e32:	000a3783          	ld	a5,0(s4)
    80003e36:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e3a:	000a3783          	ld	a5,0(s4)
    80003e3e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e42:	000a3783          	ld	a5,0(s4)
    80003e46:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e4a:	4501                	li	a0,0
    80003e4c:	a025                	j	80003e74 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e4e:	6088                	ld	a0,0(s1)
    80003e50:	e501                	bnez	a0,80003e58 <pipealloc+0xaa>
    80003e52:	a039                	j	80003e60 <pipealloc+0xb2>
    80003e54:	6088                	ld	a0,0(s1)
    80003e56:	c51d                	beqz	a0,80003e84 <pipealloc+0xd6>
    fileclose(*f0);
    80003e58:	00000097          	auipc	ra,0x0
    80003e5c:	c26080e7          	jalr	-986(ra) # 80003a7e <fileclose>
  if(*f1)
    80003e60:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e64:	557d                	li	a0,-1
  if(*f1)
    80003e66:	c799                	beqz	a5,80003e74 <pipealloc+0xc6>
    fileclose(*f1);
    80003e68:	853e                	mv	a0,a5
    80003e6a:	00000097          	auipc	ra,0x0
    80003e6e:	c14080e7          	jalr	-1004(ra) # 80003a7e <fileclose>
  return -1;
    80003e72:	557d                	li	a0,-1
}
    80003e74:	70a2                	ld	ra,40(sp)
    80003e76:	7402                	ld	s0,32(sp)
    80003e78:	64e2                	ld	s1,24(sp)
    80003e7a:	6942                	ld	s2,16(sp)
    80003e7c:	69a2                	ld	s3,8(sp)
    80003e7e:	6a02                	ld	s4,0(sp)
    80003e80:	6145                	addi	sp,sp,48
    80003e82:	8082                	ret
  return -1;
    80003e84:	557d                	li	a0,-1
    80003e86:	b7fd                	j	80003e74 <pipealloc+0xc6>

0000000080003e88 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e88:	1101                	addi	sp,sp,-32
    80003e8a:	ec06                	sd	ra,24(sp)
    80003e8c:	e822                	sd	s0,16(sp)
    80003e8e:	e426                	sd	s1,8(sp)
    80003e90:	e04a                	sd	s2,0(sp)
    80003e92:	1000                	addi	s0,sp,32
    80003e94:	84aa                	mv	s1,a0
    80003e96:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e98:	00002097          	auipc	ra,0x2
    80003e9c:	2e8080e7          	jalr	744(ra) # 80006180 <acquire>
  if(writable){
    80003ea0:	02090d63          	beqz	s2,80003eda <pipeclose+0x52>
    pi->writeopen = 0;
    80003ea4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ea8:	21848513          	addi	a0,s1,536
    80003eac:	ffffe097          	auipc	ra,0xffffe
    80003eb0:	834080e7          	jalr	-1996(ra) # 800016e0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eb4:	2204b783          	ld	a5,544(s1)
    80003eb8:	eb95                	bnez	a5,80003eec <pipeclose+0x64>
    release(&pi->lock);
    80003eba:	8526                	mv	a0,s1
    80003ebc:	00002097          	auipc	ra,0x2
    80003ec0:	378080e7          	jalr	888(ra) # 80006234 <release>
    kfree((char*)pi);
    80003ec4:	8526                	mv	a0,s1
    80003ec6:	ffffc097          	auipc	ra,0xffffc
    80003eca:	156080e7          	jalr	342(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ece:	60e2                	ld	ra,24(sp)
    80003ed0:	6442                	ld	s0,16(sp)
    80003ed2:	64a2                	ld	s1,8(sp)
    80003ed4:	6902                	ld	s2,0(sp)
    80003ed6:	6105                	addi	sp,sp,32
    80003ed8:	8082                	ret
    pi->readopen = 0;
    80003eda:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ede:	21c48513          	addi	a0,s1,540
    80003ee2:	ffffd097          	auipc	ra,0xffffd
    80003ee6:	7fe080e7          	jalr	2046(ra) # 800016e0 <wakeup>
    80003eea:	b7e9                	j	80003eb4 <pipeclose+0x2c>
    release(&pi->lock);
    80003eec:	8526                	mv	a0,s1
    80003eee:	00002097          	auipc	ra,0x2
    80003ef2:	346080e7          	jalr	838(ra) # 80006234 <release>
}
    80003ef6:	bfe1                	j	80003ece <pipeclose+0x46>

0000000080003ef8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ef8:	711d                	addi	sp,sp,-96
    80003efa:	ec86                	sd	ra,88(sp)
    80003efc:	e8a2                	sd	s0,80(sp)
    80003efe:	e4a6                	sd	s1,72(sp)
    80003f00:	e0ca                	sd	s2,64(sp)
    80003f02:	fc4e                	sd	s3,56(sp)
    80003f04:	f852                	sd	s4,48(sp)
    80003f06:	f456                	sd	s5,40(sp)
    80003f08:	f05a                	sd	s6,32(sp)
    80003f0a:	ec5e                	sd	s7,24(sp)
    80003f0c:	e862                	sd	s8,16(sp)
    80003f0e:	1080                	addi	s0,sp,96
    80003f10:	84aa                	mv	s1,a0
    80003f12:	8aae                	mv	s5,a1
    80003f14:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f16:	ffffd097          	auipc	ra,0xffffd
    80003f1a:	f76080e7          	jalr	-138(ra) # 80000e8c <myproc>
    80003f1e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f20:	8526                	mv	a0,s1
    80003f22:	00002097          	auipc	ra,0x2
    80003f26:	25e080e7          	jalr	606(ra) # 80006180 <acquire>
  while(i < n){
    80003f2a:	0b405363          	blez	s4,80003fd0 <pipewrite+0xd8>
  int i = 0;
    80003f2e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f30:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f32:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f36:	21c48b93          	addi	s7,s1,540
    80003f3a:	a089                	j	80003f7c <pipewrite+0x84>
      release(&pi->lock);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	00002097          	auipc	ra,0x2
    80003f42:	2f6080e7          	jalr	758(ra) # 80006234 <release>
      return -1;
    80003f46:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f48:	854a                	mv	a0,s2
    80003f4a:	60e6                	ld	ra,88(sp)
    80003f4c:	6446                	ld	s0,80(sp)
    80003f4e:	64a6                	ld	s1,72(sp)
    80003f50:	6906                	ld	s2,64(sp)
    80003f52:	79e2                	ld	s3,56(sp)
    80003f54:	7a42                	ld	s4,48(sp)
    80003f56:	7aa2                	ld	s5,40(sp)
    80003f58:	7b02                	ld	s6,32(sp)
    80003f5a:	6be2                	ld	s7,24(sp)
    80003f5c:	6c42                	ld	s8,16(sp)
    80003f5e:	6125                	addi	sp,sp,96
    80003f60:	8082                	ret
      wakeup(&pi->nread);
    80003f62:	8562                	mv	a0,s8
    80003f64:	ffffd097          	auipc	ra,0xffffd
    80003f68:	77c080e7          	jalr	1916(ra) # 800016e0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f6c:	85a6                	mv	a1,s1
    80003f6e:	855e                	mv	a0,s7
    80003f70:	ffffd097          	auipc	ra,0xffffd
    80003f74:	5e4080e7          	jalr	1508(ra) # 80001554 <sleep>
  while(i < n){
    80003f78:	05495d63          	bge	s2,s4,80003fd2 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f7c:	2204a783          	lw	a5,544(s1)
    80003f80:	dfd5                	beqz	a5,80003f3c <pipewrite+0x44>
    80003f82:	0289a783          	lw	a5,40(s3)
    80003f86:	fbdd                	bnez	a5,80003f3c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f88:	2184a783          	lw	a5,536(s1)
    80003f8c:	21c4a703          	lw	a4,540(s1)
    80003f90:	2007879b          	addiw	a5,a5,512
    80003f94:	fcf707e3          	beq	a4,a5,80003f62 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f98:	4685                	li	a3,1
    80003f9a:	01590633          	add	a2,s2,s5
    80003f9e:	faf40593          	addi	a1,s0,-81
    80003fa2:	0509b503          	ld	a0,80(s3)
    80003fa6:	ffffd097          	auipc	ra,0xffffd
    80003faa:	c32080e7          	jalr	-974(ra) # 80000bd8 <copyin>
    80003fae:	03650263          	beq	a0,s6,80003fd2 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fb2:	21c4a783          	lw	a5,540(s1)
    80003fb6:	0017871b          	addiw	a4,a5,1
    80003fba:	20e4ae23          	sw	a4,540(s1)
    80003fbe:	1ff7f793          	andi	a5,a5,511
    80003fc2:	97a6                	add	a5,a5,s1
    80003fc4:	faf44703          	lbu	a4,-81(s0)
    80003fc8:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fcc:	2905                	addiw	s2,s2,1
    80003fce:	b76d                	j	80003f78 <pipewrite+0x80>
  int i = 0;
    80003fd0:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fd2:	21848513          	addi	a0,s1,536
    80003fd6:	ffffd097          	auipc	ra,0xffffd
    80003fda:	70a080e7          	jalr	1802(ra) # 800016e0 <wakeup>
  release(&pi->lock);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	00002097          	auipc	ra,0x2
    80003fe4:	254080e7          	jalr	596(ra) # 80006234 <release>
  return i;
    80003fe8:	b785                	j	80003f48 <pipewrite+0x50>

0000000080003fea <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fea:	715d                	addi	sp,sp,-80
    80003fec:	e486                	sd	ra,72(sp)
    80003fee:	e0a2                	sd	s0,64(sp)
    80003ff0:	fc26                	sd	s1,56(sp)
    80003ff2:	f84a                	sd	s2,48(sp)
    80003ff4:	f44e                	sd	s3,40(sp)
    80003ff6:	f052                	sd	s4,32(sp)
    80003ff8:	ec56                	sd	s5,24(sp)
    80003ffa:	e85a                	sd	s6,16(sp)
    80003ffc:	0880                	addi	s0,sp,80
    80003ffe:	84aa                	mv	s1,a0
    80004000:	892e                	mv	s2,a1
    80004002:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004004:	ffffd097          	auipc	ra,0xffffd
    80004008:	e88080e7          	jalr	-376(ra) # 80000e8c <myproc>
    8000400c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000400e:	8526                	mv	a0,s1
    80004010:	00002097          	auipc	ra,0x2
    80004014:	170080e7          	jalr	368(ra) # 80006180 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004018:	2184a703          	lw	a4,536(s1)
    8000401c:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004020:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004024:	02f71463          	bne	a4,a5,8000404c <piperead+0x62>
    80004028:	2244a783          	lw	a5,548(s1)
    8000402c:	c385                	beqz	a5,8000404c <piperead+0x62>
    if(pr->killed){
    8000402e:	028a2783          	lw	a5,40(s4)
    80004032:	ebc1                	bnez	a5,800040c2 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004034:	85a6                	mv	a1,s1
    80004036:	854e                	mv	a0,s3
    80004038:	ffffd097          	auipc	ra,0xffffd
    8000403c:	51c080e7          	jalr	1308(ra) # 80001554 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004040:	2184a703          	lw	a4,536(s1)
    80004044:	21c4a783          	lw	a5,540(s1)
    80004048:	fef700e3          	beq	a4,a5,80004028 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000404c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000404e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004050:	05505363          	blez	s5,80004096 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004054:	2184a783          	lw	a5,536(s1)
    80004058:	21c4a703          	lw	a4,540(s1)
    8000405c:	02f70d63          	beq	a4,a5,80004096 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004060:	0017871b          	addiw	a4,a5,1
    80004064:	20e4ac23          	sw	a4,536(s1)
    80004068:	1ff7f793          	andi	a5,a5,511
    8000406c:	97a6                	add	a5,a5,s1
    8000406e:	0187c783          	lbu	a5,24(a5)
    80004072:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004076:	4685                	li	a3,1
    80004078:	fbf40613          	addi	a2,s0,-65
    8000407c:	85ca                	mv	a1,s2
    8000407e:	050a3503          	ld	a0,80(s4)
    80004082:	ffffd097          	auipc	ra,0xffffd
    80004086:	aca080e7          	jalr	-1334(ra) # 80000b4c <copyout>
    8000408a:	01650663          	beq	a0,s6,80004096 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000408e:	2985                	addiw	s3,s3,1
    80004090:	0905                	addi	s2,s2,1
    80004092:	fd3a91e3          	bne	s5,s3,80004054 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004096:	21c48513          	addi	a0,s1,540
    8000409a:	ffffd097          	auipc	ra,0xffffd
    8000409e:	646080e7          	jalr	1606(ra) # 800016e0 <wakeup>
  release(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	190080e7          	jalr	400(ra) # 80006234 <release>
  return i;
}
    800040ac:	854e                	mv	a0,s3
    800040ae:	60a6                	ld	ra,72(sp)
    800040b0:	6406                	ld	s0,64(sp)
    800040b2:	74e2                	ld	s1,56(sp)
    800040b4:	7942                	ld	s2,48(sp)
    800040b6:	79a2                	ld	s3,40(sp)
    800040b8:	7a02                	ld	s4,32(sp)
    800040ba:	6ae2                	ld	s5,24(sp)
    800040bc:	6b42                	ld	s6,16(sp)
    800040be:	6161                	addi	sp,sp,80
    800040c0:	8082                	ret
      release(&pi->lock);
    800040c2:	8526                	mv	a0,s1
    800040c4:	00002097          	auipc	ra,0x2
    800040c8:	170080e7          	jalr	368(ra) # 80006234 <release>
      return -1;
    800040cc:	59fd                	li	s3,-1
    800040ce:	bff9                	j	800040ac <piperead+0xc2>

00000000800040d0 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040d0:	de010113          	addi	sp,sp,-544
    800040d4:	20113c23          	sd	ra,536(sp)
    800040d8:	20813823          	sd	s0,528(sp)
    800040dc:	20913423          	sd	s1,520(sp)
    800040e0:	21213023          	sd	s2,512(sp)
    800040e4:	ffce                	sd	s3,504(sp)
    800040e6:	fbd2                	sd	s4,496(sp)
    800040e8:	f7d6                	sd	s5,488(sp)
    800040ea:	f3da                	sd	s6,480(sp)
    800040ec:	efde                	sd	s7,472(sp)
    800040ee:	ebe2                	sd	s8,464(sp)
    800040f0:	e7e6                	sd	s9,456(sp)
    800040f2:	e3ea                	sd	s10,448(sp)
    800040f4:	ff6e                	sd	s11,440(sp)
    800040f6:	1400                	addi	s0,sp,544
    800040f8:	892a                	mv	s2,a0
    800040fa:	dea43423          	sd	a0,-536(s0)
    800040fe:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004102:	ffffd097          	auipc	ra,0xffffd
    80004106:	d8a080e7          	jalr	-630(ra) # 80000e8c <myproc>
    8000410a:	84aa                	mv	s1,a0

  begin_op();
    8000410c:	fffff097          	auipc	ra,0xfffff
    80004110:	4a6080e7          	jalr	1190(ra) # 800035b2 <begin_op>

  if((ip = namei(path)) == 0){
    80004114:	854a                	mv	a0,s2
    80004116:	fffff097          	auipc	ra,0xfffff
    8000411a:	280080e7          	jalr	640(ra) # 80003396 <namei>
    8000411e:	c93d                	beqz	a0,80004194 <exec+0xc4>
    80004120:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004122:	fffff097          	auipc	ra,0xfffff
    80004126:	abe080e7          	jalr	-1346(ra) # 80002be0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000412a:	04000713          	li	a4,64
    8000412e:	4681                	li	a3,0
    80004130:	e5040613          	addi	a2,s0,-432
    80004134:	4581                	li	a1,0
    80004136:	8556                	mv	a0,s5
    80004138:	fffff097          	auipc	ra,0xfffff
    8000413c:	d5c080e7          	jalr	-676(ra) # 80002e94 <readi>
    80004140:	04000793          	li	a5,64
    80004144:	00f51a63          	bne	a0,a5,80004158 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004148:	e5042703          	lw	a4,-432(s0)
    8000414c:	464c47b7          	lui	a5,0x464c4
    80004150:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004154:	04f70663          	beq	a4,a5,800041a0 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004158:	8556                	mv	a0,s5
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	ce8080e7          	jalr	-792(ra) # 80002e42 <iunlockput>
    end_op();
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	4d0080e7          	jalr	1232(ra) # 80003632 <end_op>
  }
  return -1;
    8000416a:	557d                	li	a0,-1
}
    8000416c:	21813083          	ld	ra,536(sp)
    80004170:	21013403          	ld	s0,528(sp)
    80004174:	20813483          	ld	s1,520(sp)
    80004178:	20013903          	ld	s2,512(sp)
    8000417c:	79fe                	ld	s3,504(sp)
    8000417e:	7a5e                	ld	s4,496(sp)
    80004180:	7abe                	ld	s5,488(sp)
    80004182:	7b1e                	ld	s6,480(sp)
    80004184:	6bfe                	ld	s7,472(sp)
    80004186:	6c5e                	ld	s8,464(sp)
    80004188:	6cbe                	ld	s9,456(sp)
    8000418a:	6d1e                	ld	s10,448(sp)
    8000418c:	7dfa                	ld	s11,440(sp)
    8000418e:	22010113          	addi	sp,sp,544
    80004192:	8082                	ret
    end_op();
    80004194:	fffff097          	auipc	ra,0xfffff
    80004198:	49e080e7          	jalr	1182(ra) # 80003632 <end_op>
    return -1;
    8000419c:	557d                	li	a0,-1
    8000419e:	b7f9                	j	8000416c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041a0:	8526                	mv	a0,s1
    800041a2:	ffffd097          	auipc	ra,0xffffd
    800041a6:	dae080e7          	jalr	-594(ra) # 80000f50 <proc_pagetable>
    800041aa:	8b2a                	mv	s6,a0
    800041ac:	d555                	beqz	a0,80004158 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ae:	e7042783          	lw	a5,-400(s0)
    800041b2:	e8845703          	lhu	a4,-376(s0)
    800041b6:	c735                	beqz	a4,80004222 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041b8:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ba:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041be:	6a05                	lui	s4,0x1
    800041c0:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041c4:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041c8:	6d85                	lui	s11,0x1
    800041ca:	7d7d                	lui	s10,0xfffff
    800041cc:	ac1d                	j	80004402 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041ce:	00004517          	auipc	a0,0x4
    800041d2:	44250513          	addi	a0,a0,1090 # 80008610 <etext+0x610>
    800041d6:	00002097          	auipc	ra,0x2
    800041da:	a6e080e7          	jalr	-1426(ra) # 80005c44 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041de:	874a                	mv	a4,s2
    800041e0:	009c86bb          	addw	a3,s9,s1
    800041e4:	4581                	li	a1,0
    800041e6:	8556                	mv	a0,s5
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	cac080e7          	jalr	-852(ra) # 80002e94 <readi>
    800041f0:	2501                	sext.w	a0,a0
    800041f2:	1aa91863          	bne	s2,a0,800043a2 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041f6:	009d84bb          	addw	s1,s11,s1
    800041fa:	013d09bb          	addw	s3,s10,s3
    800041fe:	1f74f263          	bgeu	s1,s7,800043e2 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004202:	02049593          	slli	a1,s1,0x20
    80004206:	9181                	srli	a1,a1,0x20
    80004208:	95e2                	add	a1,a1,s8
    8000420a:	855a                	mv	a0,s6
    8000420c:	ffffc097          	auipc	ra,0xffffc
    80004210:	33c080e7          	jalr	828(ra) # 80000548 <walkaddr>
    80004214:	862a                	mv	a2,a0
    if(pa == 0)
    80004216:	dd45                	beqz	a0,800041ce <exec+0xfe>
      n = PGSIZE;
    80004218:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000421a:	fd49f2e3          	bgeu	s3,s4,800041de <exec+0x10e>
      n = sz - i;
    8000421e:	894e                	mv	s2,s3
    80004220:	bf7d                	j	800041de <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004222:	4481                	li	s1,0
  iunlockput(ip);
    80004224:	8556                	mv	a0,s5
    80004226:	fffff097          	auipc	ra,0xfffff
    8000422a:	c1c080e7          	jalr	-996(ra) # 80002e42 <iunlockput>
  end_op();
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	404080e7          	jalr	1028(ra) # 80003632 <end_op>
  p = myproc();
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	c56080e7          	jalr	-938(ra) # 80000e8c <myproc>
    8000423e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004240:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004244:	6785                	lui	a5,0x1
    80004246:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004248:	94be                	add	s1,s1,a5
    8000424a:	77fd                	lui	a5,0xfffff
    8000424c:	8fe5                	and	a5,a5,s1
    8000424e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004252:	6609                	lui	a2,0x2
    80004254:	963e                	add	a2,a2,a5
    80004256:	85be                	mv	a1,a5
    80004258:	855a                	mv	a0,s6
    8000425a:	ffffc097          	auipc	ra,0xffffc
    8000425e:	6a2080e7          	jalr	1698(ra) # 800008fc <uvmalloc>
    80004262:	8c2a                	mv	s8,a0
  ip = 0;
    80004264:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004266:	12050e63          	beqz	a0,800043a2 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000426a:	75f9                	lui	a1,0xffffe
    8000426c:	95aa                	add	a1,a1,a0
    8000426e:	855a                	mv	a0,s6
    80004270:	ffffd097          	auipc	ra,0xffffd
    80004274:	8aa080e7          	jalr	-1878(ra) # 80000b1a <uvmclear>
  stackbase = sp - PGSIZE;
    80004278:	7afd                	lui	s5,0xfffff
    8000427a:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000427c:	df043783          	ld	a5,-528(s0)
    80004280:	6388                	ld	a0,0(a5)
    80004282:	c925                	beqz	a0,800042f2 <exec+0x222>
    80004284:	e9040993          	addi	s3,s0,-368
    80004288:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000428c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000428e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004290:	ffffc097          	auipc	ra,0xffffc
    80004294:	0ae080e7          	jalr	174(ra) # 8000033e <strlen>
    80004298:	0015079b          	addiw	a5,a0,1
    8000429c:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042a0:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042a4:	13596363          	bltu	s2,s5,800043ca <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042a8:	df043d83          	ld	s11,-528(s0)
    800042ac:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042b0:	8552                	mv	a0,s4
    800042b2:	ffffc097          	auipc	ra,0xffffc
    800042b6:	08c080e7          	jalr	140(ra) # 8000033e <strlen>
    800042ba:	0015069b          	addiw	a3,a0,1
    800042be:	8652                	mv	a2,s4
    800042c0:	85ca                	mv	a1,s2
    800042c2:	855a                	mv	a0,s6
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	888080e7          	jalr	-1912(ra) # 80000b4c <copyout>
    800042cc:	10054363          	bltz	a0,800043d2 <exec+0x302>
    ustack[argc] = sp;
    800042d0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042d4:	0485                	addi	s1,s1,1
    800042d6:	008d8793          	addi	a5,s11,8
    800042da:	def43823          	sd	a5,-528(s0)
    800042de:	008db503          	ld	a0,8(s11)
    800042e2:	c911                	beqz	a0,800042f6 <exec+0x226>
    if(argc >= MAXARG)
    800042e4:	09a1                	addi	s3,s3,8
    800042e6:	fb3c95e3          	bne	s9,s3,80004290 <exec+0x1c0>
  sz = sz1;
    800042ea:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042ee:	4a81                	li	s5,0
    800042f0:	a84d                	j	800043a2 <exec+0x2d2>
  sp = sz;
    800042f2:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042f4:	4481                	li	s1,0
  ustack[argc] = 0;
    800042f6:	00349793          	slli	a5,s1,0x3
    800042fa:	f9040713          	addi	a4,s0,-112
    800042fe:	97ba                	add	a5,a5,a4
    80004300:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd8cc0>
  sp -= (argc+1) * sizeof(uint64);
    80004304:	00148693          	addi	a3,s1,1
    80004308:	068e                	slli	a3,a3,0x3
    8000430a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000430e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004312:	01597663          	bgeu	s2,s5,8000431e <exec+0x24e>
  sz = sz1;
    80004316:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000431a:	4a81                	li	s5,0
    8000431c:	a059                	j	800043a2 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000431e:	e9040613          	addi	a2,s0,-368
    80004322:	85ca                	mv	a1,s2
    80004324:	855a                	mv	a0,s6
    80004326:	ffffd097          	auipc	ra,0xffffd
    8000432a:	826080e7          	jalr	-2010(ra) # 80000b4c <copyout>
    8000432e:	0a054663          	bltz	a0,800043da <exec+0x30a>
  p->trapframe->a1 = sp;
    80004332:	058bb783          	ld	a5,88(s7)
    80004336:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000433a:	de843783          	ld	a5,-536(s0)
    8000433e:	0007c703          	lbu	a4,0(a5)
    80004342:	cf11                	beqz	a4,8000435e <exec+0x28e>
    80004344:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004346:	02f00693          	li	a3,47
    8000434a:	a039                	j	80004358 <exec+0x288>
      last = s+1;
    8000434c:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004350:	0785                	addi	a5,a5,1
    80004352:	fff7c703          	lbu	a4,-1(a5)
    80004356:	c701                	beqz	a4,8000435e <exec+0x28e>
    if(*s == '/')
    80004358:	fed71ce3          	bne	a4,a3,80004350 <exec+0x280>
    8000435c:	bfc5                	j	8000434c <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000435e:	4641                	li	a2,16
    80004360:	de843583          	ld	a1,-536(s0)
    80004364:	158b8513          	addi	a0,s7,344
    80004368:	ffffc097          	auipc	ra,0xffffc
    8000436c:	fa4080e7          	jalr	-92(ra) # 8000030c <safestrcpy>
  oldpagetable = p->pagetable;
    80004370:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004374:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004378:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000437c:	058bb783          	ld	a5,88(s7)
    80004380:	e6843703          	ld	a4,-408(s0)
    80004384:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004386:	058bb783          	ld	a5,88(s7)
    8000438a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000438e:	85ea                	mv	a1,s10
    80004390:	ffffd097          	auipc	ra,0xffffd
    80004394:	c5c080e7          	jalr	-932(ra) # 80000fec <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004398:	0004851b          	sext.w	a0,s1
    8000439c:	bbc1                	j	8000416c <exec+0x9c>
    8000439e:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043a2:	df843583          	ld	a1,-520(s0)
    800043a6:	855a                	mv	a0,s6
    800043a8:	ffffd097          	auipc	ra,0xffffd
    800043ac:	c44080e7          	jalr	-956(ra) # 80000fec <proc_freepagetable>
  if(ip){
    800043b0:	da0a94e3          	bnez	s5,80004158 <exec+0x88>
  return -1;
    800043b4:	557d                	li	a0,-1
    800043b6:	bb5d                	j	8000416c <exec+0x9c>
    800043b8:	de943c23          	sd	s1,-520(s0)
    800043bc:	b7dd                	j	800043a2 <exec+0x2d2>
    800043be:	de943c23          	sd	s1,-520(s0)
    800043c2:	b7c5                	j	800043a2 <exec+0x2d2>
    800043c4:	de943c23          	sd	s1,-520(s0)
    800043c8:	bfe9                	j	800043a2 <exec+0x2d2>
  sz = sz1;
    800043ca:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043ce:	4a81                	li	s5,0
    800043d0:	bfc9                	j	800043a2 <exec+0x2d2>
  sz = sz1;
    800043d2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043d6:	4a81                	li	s5,0
    800043d8:	b7e9                	j	800043a2 <exec+0x2d2>
  sz = sz1;
    800043da:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043de:	4a81                	li	s5,0
    800043e0:	b7c9                	j	800043a2 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043e2:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043e6:	e0843783          	ld	a5,-504(s0)
    800043ea:	0017869b          	addiw	a3,a5,1
    800043ee:	e0d43423          	sd	a3,-504(s0)
    800043f2:	e0043783          	ld	a5,-512(s0)
    800043f6:	0387879b          	addiw	a5,a5,56
    800043fa:	e8845703          	lhu	a4,-376(s0)
    800043fe:	e2e6d3e3          	bge	a3,a4,80004224 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004402:	2781                	sext.w	a5,a5
    80004404:	e0f43023          	sd	a5,-512(s0)
    80004408:	03800713          	li	a4,56
    8000440c:	86be                	mv	a3,a5
    8000440e:	e1840613          	addi	a2,s0,-488
    80004412:	4581                	li	a1,0
    80004414:	8556                	mv	a0,s5
    80004416:	fffff097          	auipc	ra,0xfffff
    8000441a:	a7e080e7          	jalr	-1410(ra) # 80002e94 <readi>
    8000441e:	03800793          	li	a5,56
    80004422:	f6f51ee3          	bne	a0,a5,8000439e <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004426:	e1842783          	lw	a5,-488(s0)
    8000442a:	4705                	li	a4,1
    8000442c:	fae79de3          	bne	a5,a4,800043e6 <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004430:	e4043603          	ld	a2,-448(s0)
    80004434:	e3843783          	ld	a5,-456(s0)
    80004438:	f8f660e3          	bltu	a2,a5,800043b8 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000443c:	e2843783          	ld	a5,-472(s0)
    80004440:	963e                	add	a2,a2,a5
    80004442:	f6f66ee3          	bltu	a2,a5,800043be <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004446:	85a6                	mv	a1,s1
    80004448:	855a                	mv	a0,s6
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	4b2080e7          	jalr	1202(ra) # 800008fc <uvmalloc>
    80004452:	dea43c23          	sd	a0,-520(s0)
    80004456:	d53d                	beqz	a0,800043c4 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004458:	e2843c03          	ld	s8,-472(s0)
    8000445c:	de043783          	ld	a5,-544(s0)
    80004460:	00fc77b3          	and	a5,s8,a5
    80004464:	ff9d                	bnez	a5,800043a2 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004466:	e2042c83          	lw	s9,-480(s0)
    8000446a:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000446e:	f60b8ae3          	beqz	s7,800043e2 <exec+0x312>
    80004472:	89de                	mv	s3,s7
    80004474:	4481                	li	s1,0
    80004476:	b371                	j	80004202 <exec+0x132>

0000000080004478 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004478:	7179                	addi	sp,sp,-48
    8000447a:	f406                	sd	ra,40(sp)
    8000447c:	f022                	sd	s0,32(sp)
    8000447e:	ec26                	sd	s1,24(sp)
    80004480:	e84a                	sd	s2,16(sp)
    80004482:	1800                	addi	s0,sp,48
    80004484:	892e                	mv	s2,a1
    80004486:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004488:	fdc40593          	addi	a1,s0,-36
    8000448c:	ffffe097          	auipc	ra,0xffffe
    80004490:	b18080e7          	jalr	-1256(ra) # 80001fa4 <argint>
    80004494:	04054063          	bltz	a0,800044d4 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004498:	fdc42703          	lw	a4,-36(s0)
    8000449c:	47bd                	li	a5,15
    8000449e:	02e7ed63          	bltu	a5,a4,800044d8 <argfd+0x60>
    800044a2:	ffffd097          	auipc	ra,0xffffd
    800044a6:	9ea080e7          	jalr	-1558(ra) # 80000e8c <myproc>
    800044aa:	fdc42703          	lw	a4,-36(s0)
    800044ae:	01a70793          	addi	a5,a4,26
    800044b2:	078e                	slli	a5,a5,0x3
    800044b4:	953e                	add	a0,a0,a5
    800044b6:	611c                	ld	a5,0(a0)
    800044b8:	c395                	beqz	a5,800044dc <argfd+0x64>
    return -1;
  if(pfd)
    800044ba:	00090463          	beqz	s2,800044c2 <argfd+0x4a>
    *pfd = fd;
    800044be:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044c2:	4501                	li	a0,0
  if(pf)
    800044c4:	c091                	beqz	s1,800044c8 <argfd+0x50>
    *pf = f;
    800044c6:	e09c                	sd	a5,0(s1)
}
    800044c8:	70a2                	ld	ra,40(sp)
    800044ca:	7402                	ld	s0,32(sp)
    800044cc:	64e2                	ld	s1,24(sp)
    800044ce:	6942                	ld	s2,16(sp)
    800044d0:	6145                	addi	sp,sp,48
    800044d2:	8082                	ret
    return -1;
    800044d4:	557d                	li	a0,-1
    800044d6:	bfcd                	j	800044c8 <argfd+0x50>
    return -1;
    800044d8:	557d                	li	a0,-1
    800044da:	b7fd                	j	800044c8 <argfd+0x50>
    800044dc:	557d                	li	a0,-1
    800044de:	b7ed                	j	800044c8 <argfd+0x50>

00000000800044e0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044e0:	1101                	addi	sp,sp,-32
    800044e2:	ec06                	sd	ra,24(sp)
    800044e4:	e822                	sd	s0,16(sp)
    800044e6:	e426                	sd	s1,8(sp)
    800044e8:	1000                	addi	s0,sp,32
    800044ea:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044ec:	ffffd097          	auipc	ra,0xffffd
    800044f0:	9a0080e7          	jalr	-1632(ra) # 80000e8c <myproc>
    800044f4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044f6:	0d050793          	addi	a5,a0,208
    800044fa:	4501                	li	a0,0
    800044fc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044fe:	6398                	ld	a4,0(a5)
    80004500:	cb19                	beqz	a4,80004516 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004502:	2505                	addiw	a0,a0,1
    80004504:	07a1                	addi	a5,a5,8
    80004506:	fed51ce3          	bne	a0,a3,800044fe <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000450a:	557d                	li	a0,-1
}
    8000450c:	60e2                	ld	ra,24(sp)
    8000450e:	6442                	ld	s0,16(sp)
    80004510:	64a2                	ld	s1,8(sp)
    80004512:	6105                	addi	sp,sp,32
    80004514:	8082                	ret
      p->ofile[fd] = f;
    80004516:	01a50793          	addi	a5,a0,26
    8000451a:	078e                	slli	a5,a5,0x3
    8000451c:	963e                	add	a2,a2,a5
    8000451e:	e204                	sd	s1,0(a2)
      return fd;
    80004520:	b7f5                	j	8000450c <fdalloc+0x2c>

0000000080004522 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004522:	715d                	addi	sp,sp,-80
    80004524:	e486                	sd	ra,72(sp)
    80004526:	e0a2                	sd	s0,64(sp)
    80004528:	fc26                	sd	s1,56(sp)
    8000452a:	f84a                	sd	s2,48(sp)
    8000452c:	f44e                	sd	s3,40(sp)
    8000452e:	f052                	sd	s4,32(sp)
    80004530:	ec56                	sd	s5,24(sp)
    80004532:	0880                	addi	s0,sp,80
    80004534:	89ae                	mv	s3,a1
    80004536:	8ab2                	mv	s5,a2
    80004538:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000453a:	fb040593          	addi	a1,s0,-80
    8000453e:	fffff097          	auipc	ra,0xfffff
    80004542:	e76080e7          	jalr	-394(ra) # 800033b4 <nameiparent>
    80004546:	892a                	mv	s2,a0
    80004548:	12050e63          	beqz	a0,80004684 <create+0x162>
    return 0;

  ilock(dp);
    8000454c:	ffffe097          	auipc	ra,0xffffe
    80004550:	694080e7          	jalr	1684(ra) # 80002be0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004554:	4601                	li	a2,0
    80004556:	fb040593          	addi	a1,s0,-80
    8000455a:	854a                	mv	a0,s2
    8000455c:	fffff097          	auipc	ra,0xfffff
    80004560:	b68080e7          	jalr	-1176(ra) # 800030c4 <dirlookup>
    80004564:	84aa                	mv	s1,a0
    80004566:	c921                	beqz	a0,800045b6 <create+0x94>
    iunlockput(dp);
    80004568:	854a                	mv	a0,s2
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	8d8080e7          	jalr	-1832(ra) # 80002e42 <iunlockput>
    ilock(ip);
    80004572:	8526                	mv	a0,s1
    80004574:	ffffe097          	auipc	ra,0xffffe
    80004578:	66c080e7          	jalr	1644(ra) # 80002be0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000457c:	2981                	sext.w	s3,s3
    8000457e:	4789                	li	a5,2
    80004580:	02f99463          	bne	s3,a5,800045a8 <create+0x86>
    80004584:	0444d783          	lhu	a5,68(s1)
    80004588:	37f9                	addiw	a5,a5,-2
    8000458a:	17c2                	slli	a5,a5,0x30
    8000458c:	93c1                	srli	a5,a5,0x30
    8000458e:	4705                	li	a4,1
    80004590:	00f76c63          	bltu	a4,a5,800045a8 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004594:	8526                	mv	a0,s1
    80004596:	60a6                	ld	ra,72(sp)
    80004598:	6406                	ld	s0,64(sp)
    8000459a:	74e2                	ld	s1,56(sp)
    8000459c:	7942                	ld	s2,48(sp)
    8000459e:	79a2                	ld	s3,40(sp)
    800045a0:	7a02                	ld	s4,32(sp)
    800045a2:	6ae2                	ld	s5,24(sp)
    800045a4:	6161                	addi	sp,sp,80
    800045a6:	8082                	ret
    iunlockput(ip);
    800045a8:	8526                	mv	a0,s1
    800045aa:	fffff097          	auipc	ra,0xfffff
    800045ae:	898080e7          	jalr	-1896(ra) # 80002e42 <iunlockput>
    return 0;
    800045b2:	4481                	li	s1,0
    800045b4:	b7c5                	j	80004594 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045b6:	85ce                	mv	a1,s3
    800045b8:	00092503          	lw	a0,0(s2)
    800045bc:	ffffe097          	auipc	ra,0xffffe
    800045c0:	48c080e7          	jalr	1164(ra) # 80002a48 <ialloc>
    800045c4:	84aa                	mv	s1,a0
    800045c6:	c521                	beqz	a0,8000460e <create+0xec>
  ilock(ip);
    800045c8:	ffffe097          	auipc	ra,0xffffe
    800045cc:	618080e7          	jalr	1560(ra) # 80002be0 <ilock>
  ip->major = major;
    800045d0:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045d4:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045d8:	4a05                	li	s4,1
    800045da:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045de:	8526                	mv	a0,s1
    800045e0:	ffffe097          	auipc	ra,0xffffe
    800045e4:	536080e7          	jalr	1334(ra) # 80002b16 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045e8:	2981                	sext.w	s3,s3
    800045ea:	03498a63          	beq	s3,s4,8000461e <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045ee:	40d0                	lw	a2,4(s1)
    800045f0:	fb040593          	addi	a1,s0,-80
    800045f4:	854a                	mv	a0,s2
    800045f6:	fffff097          	auipc	ra,0xfffff
    800045fa:	cde080e7          	jalr	-802(ra) # 800032d4 <dirlink>
    800045fe:	06054b63          	bltz	a0,80004674 <create+0x152>
  iunlockput(dp);
    80004602:	854a                	mv	a0,s2
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	83e080e7          	jalr	-1986(ra) # 80002e42 <iunlockput>
  return ip;
    8000460c:	b761                	j	80004594 <create+0x72>
    panic("create: ialloc");
    8000460e:	00004517          	auipc	a0,0x4
    80004612:	02250513          	addi	a0,a0,34 # 80008630 <etext+0x630>
    80004616:	00001097          	auipc	ra,0x1
    8000461a:	62e080e7          	jalr	1582(ra) # 80005c44 <panic>
    dp->nlink++;  // for ".."
    8000461e:	04a95783          	lhu	a5,74(s2)
    80004622:	2785                	addiw	a5,a5,1
    80004624:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004628:	854a                	mv	a0,s2
    8000462a:	ffffe097          	auipc	ra,0xffffe
    8000462e:	4ec080e7          	jalr	1260(ra) # 80002b16 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004632:	40d0                	lw	a2,4(s1)
    80004634:	00004597          	auipc	a1,0x4
    80004638:	00c58593          	addi	a1,a1,12 # 80008640 <etext+0x640>
    8000463c:	8526                	mv	a0,s1
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	c96080e7          	jalr	-874(ra) # 800032d4 <dirlink>
    80004646:	00054f63          	bltz	a0,80004664 <create+0x142>
    8000464a:	00492603          	lw	a2,4(s2)
    8000464e:	00004597          	auipc	a1,0x4
    80004652:	ffa58593          	addi	a1,a1,-6 # 80008648 <etext+0x648>
    80004656:	8526                	mv	a0,s1
    80004658:	fffff097          	auipc	ra,0xfffff
    8000465c:	c7c080e7          	jalr	-900(ra) # 800032d4 <dirlink>
    80004660:	f80557e3          	bgez	a0,800045ee <create+0xcc>
      panic("create dots");
    80004664:	00004517          	auipc	a0,0x4
    80004668:	fec50513          	addi	a0,a0,-20 # 80008650 <etext+0x650>
    8000466c:	00001097          	auipc	ra,0x1
    80004670:	5d8080e7          	jalr	1496(ra) # 80005c44 <panic>
    panic("create: dirlink");
    80004674:	00004517          	auipc	a0,0x4
    80004678:	fec50513          	addi	a0,a0,-20 # 80008660 <etext+0x660>
    8000467c:	00001097          	auipc	ra,0x1
    80004680:	5c8080e7          	jalr	1480(ra) # 80005c44 <panic>
    return 0;
    80004684:	84aa                	mv	s1,a0
    80004686:	b739                	j	80004594 <create+0x72>

0000000080004688 <sys_dup>:
{
    80004688:	7179                	addi	sp,sp,-48
    8000468a:	f406                	sd	ra,40(sp)
    8000468c:	f022                	sd	s0,32(sp)
    8000468e:	ec26                	sd	s1,24(sp)
    80004690:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004692:	fd840613          	addi	a2,s0,-40
    80004696:	4581                	li	a1,0
    80004698:	4501                	li	a0,0
    8000469a:	00000097          	auipc	ra,0x0
    8000469e:	dde080e7          	jalr	-546(ra) # 80004478 <argfd>
    return -1;
    800046a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046a4:	02054363          	bltz	a0,800046ca <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046a8:	fd843503          	ld	a0,-40(s0)
    800046ac:	00000097          	auipc	ra,0x0
    800046b0:	e34080e7          	jalr	-460(ra) # 800044e0 <fdalloc>
    800046b4:	84aa                	mv	s1,a0
    return -1;
    800046b6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046b8:	00054963          	bltz	a0,800046ca <sys_dup+0x42>
  filedup(f);
    800046bc:	fd843503          	ld	a0,-40(s0)
    800046c0:	fffff097          	auipc	ra,0xfffff
    800046c4:	36c080e7          	jalr	876(ra) # 80003a2c <filedup>
  return fd;
    800046c8:	87a6                	mv	a5,s1
}
    800046ca:	853e                	mv	a0,a5
    800046cc:	70a2                	ld	ra,40(sp)
    800046ce:	7402                	ld	s0,32(sp)
    800046d0:	64e2                	ld	s1,24(sp)
    800046d2:	6145                	addi	sp,sp,48
    800046d4:	8082                	ret

00000000800046d6 <sys_read>:
{
    800046d6:	7179                	addi	sp,sp,-48
    800046d8:	f406                	sd	ra,40(sp)
    800046da:	f022                	sd	s0,32(sp)
    800046dc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046de:	fe840613          	addi	a2,s0,-24
    800046e2:	4581                	li	a1,0
    800046e4:	4501                	li	a0,0
    800046e6:	00000097          	auipc	ra,0x0
    800046ea:	d92080e7          	jalr	-622(ra) # 80004478 <argfd>
    return -1;
    800046ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f0:	04054163          	bltz	a0,80004732 <sys_read+0x5c>
    800046f4:	fe440593          	addi	a1,s0,-28
    800046f8:	4509                	li	a0,2
    800046fa:	ffffe097          	auipc	ra,0xffffe
    800046fe:	8aa080e7          	jalr	-1878(ra) # 80001fa4 <argint>
    return -1;
    80004702:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004704:	02054763          	bltz	a0,80004732 <sys_read+0x5c>
    80004708:	fd840593          	addi	a1,s0,-40
    8000470c:	4505                	li	a0,1
    8000470e:	ffffe097          	auipc	ra,0xffffe
    80004712:	8b8080e7          	jalr	-1864(ra) # 80001fc6 <argaddr>
    return -1;
    80004716:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004718:	00054d63          	bltz	a0,80004732 <sys_read+0x5c>
  return fileread(f, p, n);
    8000471c:	fe442603          	lw	a2,-28(s0)
    80004720:	fd843583          	ld	a1,-40(s0)
    80004724:	fe843503          	ld	a0,-24(s0)
    80004728:	fffff097          	auipc	ra,0xfffff
    8000472c:	490080e7          	jalr	1168(ra) # 80003bb8 <fileread>
    80004730:	87aa                	mv	a5,a0
}
    80004732:	853e                	mv	a0,a5
    80004734:	70a2                	ld	ra,40(sp)
    80004736:	7402                	ld	s0,32(sp)
    80004738:	6145                	addi	sp,sp,48
    8000473a:	8082                	ret

000000008000473c <sys_write>:
{
    8000473c:	7179                	addi	sp,sp,-48
    8000473e:	f406                	sd	ra,40(sp)
    80004740:	f022                	sd	s0,32(sp)
    80004742:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004744:	fe840613          	addi	a2,s0,-24
    80004748:	4581                	li	a1,0
    8000474a:	4501                	li	a0,0
    8000474c:	00000097          	auipc	ra,0x0
    80004750:	d2c080e7          	jalr	-724(ra) # 80004478 <argfd>
    return -1;
    80004754:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004756:	04054163          	bltz	a0,80004798 <sys_write+0x5c>
    8000475a:	fe440593          	addi	a1,s0,-28
    8000475e:	4509                	li	a0,2
    80004760:	ffffe097          	auipc	ra,0xffffe
    80004764:	844080e7          	jalr	-1980(ra) # 80001fa4 <argint>
    return -1;
    80004768:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476a:	02054763          	bltz	a0,80004798 <sys_write+0x5c>
    8000476e:	fd840593          	addi	a1,s0,-40
    80004772:	4505                	li	a0,1
    80004774:	ffffe097          	auipc	ra,0xffffe
    80004778:	852080e7          	jalr	-1966(ra) # 80001fc6 <argaddr>
    return -1;
    8000477c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000477e:	00054d63          	bltz	a0,80004798 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004782:	fe442603          	lw	a2,-28(s0)
    80004786:	fd843583          	ld	a1,-40(s0)
    8000478a:	fe843503          	ld	a0,-24(s0)
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	4ec080e7          	jalr	1260(ra) # 80003c7a <filewrite>
    80004796:	87aa                	mv	a5,a0
}
    80004798:	853e                	mv	a0,a5
    8000479a:	70a2                	ld	ra,40(sp)
    8000479c:	7402                	ld	s0,32(sp)
    8000479e:	6145                	addi	sp,sp,48
    800047a0:	8082                	ret

00000000800047a2 <sys_close>:
{
    800047a2:	1101                	addi	sp,sp,-32
    800047a4:	ec06                	sd	ra,24(sp)
    800047a6:	e822                	sd	s0,16(sp)
    800047a8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047aa:	fe040613          	addi	a2,s0,-32
    800047ae:	fec40593          	addi	a1,s0,-20
    800047b2:	4501                	li	a0,0
    800047b4:	00000097          	auipc	ra,0x0
    800047b8:	cc4080e7          	jalr	-828(ra) # 80004478 <argfd>
    return -1;
    800047bc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047be:	02054463          	bltz	a0,800047e6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047c2:	ffffc097          	auipc	ra,0xffffc
    800047c6:	6ca080e7          	jalr	1738(ra) # 80000e8c <myproc>
    800047ca:	fec42783          	lw	a5,-20(s0)
    800047ce:	07e9                	addi	a5,a5,26
    800047d0:	078e                	slli	a5,a5,0x3
    800047d2:	97aa                	add	a5,a5,a0
    800047d4:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047d8:	fe043503          	ld	a0,-32(s0)
    800047dc:	fffff097          	auipc	ra,0xfffff
    800047e0:	2a2080e7          	jalr	674(ra) # 80003a7e <fileclose>
  return 0;
    800047e4:	4781                	li	a5,0
}
    800047e6:	853e                	mv	a0,a5
    800047e8:	60e2                	ld	ra,24(sp)
    800047ea:	6442                	ld	s0,16(sp)
    800047ec:	6105                	addi	sp,sp,32
    800047ee:	8082                	ret

00000000800047f0 <sys_fstat>:
{
    800047f0:	1101                	addi	sp,sp,-32
    800047f2:	ec06                	sd	ra,24(sp)
    800047f4:	e822                	sd	s0,16(sp)
    800047f6:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047f8:	fe840613          	addi	a2,s0,-24
    800047fc:	4581                	li	a1,0
    800047fe:	4501                	li	a0,0
    80004800:	00000097          	auipc	ra,0x0
    80004804:	c78080e7          	jalr	-904(ra) # 80004478 <argfd>
    return -1;
    80004808:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000480a:	02054563          	bltz	a0,80004834 <sys_fstat+0x44>
    8000480e:	fe040593          	addi	a1,s0,-32
    80004812:	4505                	li	a0,1
    80004814:	ffffd097          	auipc	ra,0xffffd
    80004818:	7b2080e7          	jalr	1970(ra) # 80001fc6 <argaddr>
    return -1;
    8000481c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000481e:	00054b63          	bltz	a0,80004834 <sys_fstat+0x44>
  return filestat(f, st);
    80004822:	fe043583          	ld	a1,-32(s0)
    80004826:	fe843503          	ld	a0,-24(s0)
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	31c080e7          	jalr	796(ra) # 80003b46 <filestat>
    80004832:	87aa                	mv	a5,a0
}
    80004834:	853e                	mv	a0,a5
    80004836:	60e2                	ld	ra,24(sp)
    80004838:	6442                	ld	s0,16(sp)
    8000483a:	6105                	addi	sp,sp,32
    8000483c:	8082                	ret

000000008000483e <sys_link>:
{
    8000483e:	7169                	addi	sp,sp,-304
    80004840:	f606                	sd	ra,296(sp)
    80004842:	f222                	sd	s0,288(sp)
    80004844:	ee26                	sd	s1,280(sp)
    80004846:	ea4a                	sd	s2,272(sp)
    80004848:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000484a:	08000613          	li	a2,128
    8000484e:	ed040593          	addi	a1,s0,-304
    80004852:	4501                	li	a0,0
    80004854:	ffffd097          	auipc	ra,0xffffd
    80004858:	794080e7          	jalr	1940(ra) # 80001fe8 <argstr>
    return -1;
    8000485c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485e:	10054e63          	bltz	a0,8000497a <sys_link+0x13c>
    80004862:	08000613          	li	a2,128
    80004866:	f5040593          	addi	a1,s0,-176
    8000486a:	4505                	li	a0,1
    8000486c:	ffffd097          	auipc	ra,0xffffd
    80004870:	77c080e7          	jalr	1916(ra) # 80001fe8 <argstr>
    return -1;
    80004874:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004876:	10054263          	bltz	a0,8000497a <sys_link+0x13c>
  begin_op();
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	d38080e7          	jalr	-712(ra) # 800035b2 <begin_op>
  if((ip = namei(old)) == 0){
    80004882:	ed040513          	addi	a0,s0,-304
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	b10080e7          	jalr	-1264(ra) # 80003396 <namei>
    8000488e:	84aa                	mv	s1,a0
    80004890:	c551                	beqz	a0,8000491c <sys_link+0xde>
  ilock(ip);
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	34e080e7          	jalr	846(ra) # 80002be0 <ilock>
  if(ip->type == T_DIR){
    8000489a:	04449703          	lh	a4,68(s1)
    8000489e:	4785                	li	a5,1
    800048a0:	08f70463          	beq	a4,a5,80004928 <sys_link+0xea>
  ip->nlink++;
    800048a4:	04a4d783          	lhu	a5,74(s1)
    800048a8:	2785                	addiw	a5,a5,1
    800048aa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048ae:	8526                	mv	a0,s1
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	266080e7          	jalr	614(ra) # 80002b16 <iupdate>
  iunlock(ip);
    800048b8:	8526                	mv	a0,s1
    800048ba:	ffffe097          	auipc	ra,0xffffe
    800048be:	3e8080e7          	jalr	1000(ra) # 80002ca2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048c2:	fd040593          	addi	a1,s0,-48
    800048c6:	f5040513          	addi	a0,s0,-176
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	aea080e7          	jalr	-1302(ra) # 800033b4 <nameiparent>
    800048d2:	892a                	mv	s2,a0
    800048d4:	c935                	beqz	a0,80004948 <sys_link+0x10a>
  ilock(dp);
    800048d6:	ffffe097          	auipc	ra,0xffffe
    800048da:	30a080e7          	jalr	778(ra) # 80002be0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048de:	00092703          	lw	a4,0(s2)
    800048e2:	409c                	lw	a5,0(s1)
    800048e4:	04f71d63          	bne	a4,a5,8000493e <sys_link+0x100>
    800048e8:	40d0                	lw	a2,4(s1)
    800048ea:	fd040593          	addi	a1,s0,-48
    800048ee:	854a                	mv	a0,s2
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	9e4080e7          	jalr	-1564(ra) # 800032d4 <dirlink>
    800048f8:	04054363          	bltz	a0,8000493e <sys_link+0x100>
  iunlockput(dp);
    800048fc:	854a                	mv	a0,s2
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	544080e7          	jalr	1348(ra) # 80002e42 <iunlockput>
  iput(ip);
    80004906:	8526                	mv	a0,s1
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	492080e7          	jalr	1170(ra) # 80002d9a <iput>
  end_op();
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	d22080e7          	jalr	-734(ra) # 80003632 <end_op>
  return 0;
    80004918:	4781                	li	a5,0
    8000491a:	a085                	j	8000497a <sys_link+0x13c>
    end_op();
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	d16080e7          	jalr	-746(ra) # 80003632 <end_op>
    return -1;
    80004924:	57fd                	li	a5,-1
    80004926:	a891                	j	8000497a <sys_link+0x13c>
    iunlockput(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	518080e7          	jalr	1304(ra) # 80002e42 <iunlockput>
    end_op();
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	d00080e7          	jalr	-768(ra) # 80003632 <end_op>
    return -1;
    8000493a:	57fd                	li	a5,-1
    8000493c:	a83d                	j	8000497a <sys_link+0x13c>
    iunlockput(dp);
    8000493e:	854a                	mv	a0,s2
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	502080e7          	jalr	1282(ra) # 80002e42 <iunlockput>
  ilock(ip);
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	296080e7          	jalr	662(ra) # 80002be0 <ilock>
  ip->nlink--;
    80004952:	04a4d783          	lhu	a5,74(s1)
    80004956:	37fd                	addiw	a5,a5,-1
    80004958:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000495c:	8526                	mv	a0,s1
    8000495e:	ffffe097          	auipc	ra,0xffffe
    80004962:	1b8080e7          	jalr	440(ra) # 80002b16 <iupdate>
  iunlockput(ip);
    80004966:	8526                	mv	a0,s1
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	4da080e7          	jalr	1242(ra) # 80002e42 <iunlockput>
  end_op();
    80004970:	fffff097          	auipc	ra,0xfffff
    80004974:	cc2080e7          	jalr	-830(ra) # 80003632 <end_op>
  return -1;
    80004978:	57fd                	li	a5,-1
}
    8000497a:	853e                	mv	a0,a5
    8000497c:	70b2                	ld	ra,296(sp)
    8000497e:	7412                	ld	s0,288(sp)
    80004980:	64f2                	ld	s1,280(sp)
    80004982:	6952                	ld	s2,272(sp)
    80004984:	6155                	addi	sp,sp,304
    80004986:	8082                	ret

0000000080004988 <sys_unlink>:
{
    80004988:	7151                	addi	sp,sp,-240
    8000498a:	f586                	sd	ra,232(sp)
    8000498c:	f1a2                	sd	s0,224(sp)
    8000498e:	eda6                	sd	s1,216(sp)
    80004990:	e9ca                	sd	s2,208(sp)
    80004992:	e5ce                	sd	s3,200(sp)
    80004994:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004996:	08000613          	li	a2,128
    8000499a:	f3040593          	addi	a1,s0,-208
    8000499e:	4501                	li	a0,0
    800049a0:	ffffd097          	auipc	ra,0xffffd
    800049a4:	648080e7          	jalr	1608(ra) # 80001fe8 <argstr>
    800049a8:	18054163          	bltz	a0,80004b2a <sys_unlink+0x1a2>
  begin_op();
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	c06080e7          	jalr	-1018(ra) # 800035b2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049b4:	fb040593          	addi	a1,s0,-80
    800049b8:	f3040513          	addi	a0,s0,-208
    800049bc:	fffff097          	auipc	ra,0xfffff
    800049c0:	9f8080e7          	jalr	-1544(ra) # 800033b4 <nameiparent>
    800049c4:	84aa                	mv	s1,a0
    800049c6:	c979                	beqz	a0,80004a9c <sys_unlink+0x114>
  ilock(dp);
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	218080e7          	jalr	536(ra) # 80002be0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049d0:	00004597          	auipc	a1,0x4
    800049d4:	c7058593          	addi	a1,a1,-912 # 80008640 <etext+0x640>
    800049d8:	fb040513          	addi	a0,s0,-80
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	6ce080e7          	jalr	1742(ra) # 800030aa <namecmp>
    800049e4:	14050a63          	beqz	a0,80004b38 <sys_unlink+0x1b0>
    800049e8:	00004597          	auipc	a1,0x4
    800049ec:	c6058593          	addi	a1,a1,-928 # 80008648 <etext+0x648>
    800049f0:	fb040513          	addi	a0,s0,-80
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	6b6080e7          	jalr	1718(ra) # 800030aa <namecmp>
    800049fc:	12050e63          	beqz	a0,80004b38 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a00:	f2c40613          	addi	a2,s0,-212
    80004a04:	fb040593          	addi	a1,s0,-80
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	6ba080e7          	jalr	1722(ra) # 800030c4 <dirlookup>
    80004a12:	892a                	mv	s2,a0
    80004a14:	12050263          	beqz	a0,80004b38 <sys_unlink+0x1b0>
  ilock(ip);
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	1c8080e7          	jalr	456(ra) # 80002be0 <ilock>
  if(ip->nlink < 1)
    80004a20:	04a91783          	lh	a5,74(s2)
    80004a24:	08f05263          	blez	a5,80004aa8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a28:	04491703          	lh	a4,68(s2)
    80004a2c:	4785                	li	a5,1
    80004a2e:	08f70563          	beq	a4,a5,80004ab8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a32:	4641                	li	a2,16
    80004a34:	4581                	li	a1,0
    80004a36:	fc040513          	addi	a0,s0,-64
    80004a3a:	ffffb097          	auipc	ra,0xffffb
    80004a3e:	788080e7          	jalr	1928(ra) # 800001c2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a42:	4741                	li	a4,16
    80004a44:	f2c42683          	lw	a3,-212(s0)
    80004a48:	fc040613          	addi	a2,s0,-64
    80004a4c:	4581                	li	a1,0
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	53c080e7          	jalr	1340(ra) # 80002f8c <writei>
    80004a58:	47c1                	li	a5,16
    80004a5a:	0af51563          	bne	a0,a5,80004b04 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a5e:	04491703          	lh	a4,68(s2)
    80004a62:	4785                	li	a5,1
    80004a64:	0af70863          	beq	a4,a5,80004b14 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a68:	8526                	mv	a0,s1
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	3d8080e7          	jalr	984(ra) # 80002e42 <iunlockput>
  ip->nlink--;
    80004a72:	04a95783          	lhu	a5,74(s2)
    80004a76:	37fd                	addiw	a5,a5,-1
    80004a78:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a7c:	854a                	mv	a0,s2
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	098080e7          	jalr	152(ra) # 80002b16 <iupdate>
  iunlockput(ip);
    80004a86:	854a                	mv	a0,s2
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	3ba080e7          	jalr	954(ra) # 80002e42 <iunlockput>
  end_op();
    80004a90:	fffff097          	auipc	ra,0xfffff
    80004a94:	ba2080e7          	jalr	-1118(ra) # 80003632 <end_op>
  return 0;
    80004a98:	4501                	li	a0,0
    80004a9a:	a84d                	j	80004b4c <sys_unlink+0x1c4>
    end_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	b96080e7          	jalr	-1130(ra) # 80003632 <end_op>
    return -1;
    80004aa4:	557d                	li	a0,-1
    80004aa6:	a05d                	j	80004b4c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aa8:	00004517          	auipc	a0,0x4
    80004aac:	bc850513          	addi	a0,a0,-1080 # 80008670 <etext+0x670>
    80004ab0:	00001097          	auipc	ra,0x1
    80004ab4:	194080e7          	jalr	404(ra) # 80005c44 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ab8:	04c92703          	lw	a4,76(s2)
    80004abc:	02000793          	li	a5,32
    80004ac0:	f6e7f9e3          	bgeu	a5,a4,80004a32 <sys_unlink+0xaa>
    80004ac4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ac8:	4741                	li	a4,16
    80004aca:	86ce                	mv	a3,s3
    80004acc:	f1840613          	addi	a2,s0,-232
    80004ad0:	4581                	li	a1,0
    80004ad2:	854a                	mv	a0,s2
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	3c0080e7          	jalr	960(ra) # 80002e94 <readi>
    80004adc:	47c1                	li	a5,16
    80004ade:	00f51b63          	bne	a0,a5,80004af4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ae2:	f1845783          	lhu	a5,-232(s0)
    80004ae6:	e7a1                	bnez	a5,80004b2e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ae8:	29c1                	addiw	s3,s3,16
    80004aea:	04c92783          	lw	a5,76(s2)
    80004aee:	fcf9ede3          	bltu	s3,a5,80004ac8 <sys_unlink+0x140>
    80004af2:	b781                	j	80004a32 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004af4:	00004517          	auipc	a0,0x4
    80004af8:	b9450513          	addi	a0,a0,-1132 # 80008688 <etext+0x688>
    80004afc:	00001097          	auipc	ra,0x1
    80004b00:	148080e7          	jalr	328(ra) # 80005c44 <panic>
    panic("unlink: writei");
    80004b04:	00004517          	auipc	a0,0x4
    80004b08:	b9c50513          	addi	a0,a0,-1124 # 800086a0 <etext+0x6a0>
    80004b0c:	00001097          	auipc	ra,0x1
    80004b10:	138080e7          	jalr	312(ra) # 80005c44 <panic>
    dp->nlink--;
    80004b14:	04a4d783          	lhu	a5,74(s1)
    80004b18:	37fd                	addiw	a5,a5,-1
    80004b1a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b1e:	8526                	mv	a0,s1
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	ff6080e7          	jalr	-10(ra) # 80002b16 <iupdate>
    80004b28:	b781                	j	80004a68 <sys_unlink+0xe0>
    return -1;
    80004b2a:	557d                	li	a0,-1
    80004b2c:	a005                	j	80004b4c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b2e:	854a                	mv	a0,s2
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	312080e7          	jalr	786(ra) # 80002e42 <iunlockput>
  iunlockput(dp);
    80004b38:	8526                	mv	a0,s1
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	308080e7          	jalr	776(ra) # 80002e42 <iunlockput>
  end_op();
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	af0080e7          	jalr	-1296(ra) # 80003632 <end_op>
  return -1;
    80004b4a:	557d                	li	a0,-1
}
    80004b4c:	70ae                	ld	ra,232(sp)
    80004b4e:	740e                	ld	s0,224(sp)
    80004b50:	64ee                	ld	s1,216(sp)
    80004b52:	694e                	ld	s2,208(sp)
    80004b54:	69ae                	ld	s3,200(sp)
    80004b56:	616d                	addi	sp,sp,240
    80004b58:	8082                	ret

0000000080004b5a <sys_open>:

uint64
sys_open(void)
{
    80004b5a:	7131                	addi	sp,sp,-192
    80004b5c:	fd06                	sd	ra,184(sp)
    80004b5e:	f922                	sd	s0,176(sp)
    80004b60:	f526                	sd	s1,168(sp)
    80004b62:	f14a                	sd	s2,160(sp)
    80004b64:	ed4e                	sd	s3,152(sp)
    80004b66:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b68:	08000613          	li	a2,128
    80004b6c:	f5040593          	addi	a1,s0,-176
    80004b70:	4501                	li	a0,0
    80004b72:	ffffd097          	auipc	ra,0xffffd
    80004b76:	476080e7          	jalr	1142(ra) # 80001fe8 <argstr>
    return -1;
    80004b7a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b7c:	0c054163          	bltz	a0,80004c3e <sys_open+0xe4>
    80004b80:	f4c40593          	addi	a1,s0,-180
    80004b84:	4505                	li	a0,1
    80004b86:	ffffd097          	auipc	ra,0xffffd
    80004b8a:	41e080e7          	jalr	1054(ra) # 80001fa4 <argint>
    80004b8e:	0a054863          	bltz	a0,80004c3e <sys_open+0xe4>

  begin_op();
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	a20080e7          	jalr	-1504(ra) # 800035b2 <begin_op>

  if(omode & O_CREATE){
    80004b9a:	f4c42783          	lw	a5,-180(s0)
    80004b9e:	2007f793          	andi	a5,a5,512
    80004ba2:	cbdd                	beqz	a5,80004c58 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ba4:	4681                	li	a3,0
    80004ba6:	4601                	li	a2,0
    80004ba8:	4589                	li	a1,2
    80004baa:	f5040513          	addi	a0,s0,-176
    80004bae:	00000097          	auipc	ra,0x0
    80004bb2:	974080e7          	jalr	-1676(ra) # 80004522 <create>
    80004bb6:	892a                	mv	s2,a0
    if(ip == 0){
    80004bb8:	c959                	beqz	a0,80004c4e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bba:	04491703          	lh	a4,68(s2)
    80004bbe:	478d                	li	a5,3
    80004bc0:	00f71763          	bne	a4,a5,80004bce <sys_open+0x74>
    80004bc4:	04695703          	lhu	a4,70(s2)
    80004bc8:	47a5                	li	a5,9
    80004bca:	0ce7ec63          	bltu	a5,a4,80004ca2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	df4080e7          	jalr	-524(ra) # 800039c2 <filealloc>
    80004bd6:	89aa                	mv	s3,a0
    80004bd8:	10050263          	beqz	a0,80004cdc <sys_open+0x182>
    80004bdc:	00000097          	auipc	ra,0x0
    80004be0:	904080e7          	jalr	-1788(ra) # 800044e0 <fdalloc>
    80004be4:	84aa                	mv	s1,a0
    80004be6:	0e054663          	bltz	a0,80004cd2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bea:	04491703          	lh	a4,68(s2)
    80004bee:	478d                	li	a5,3
    80004bf0:	0cf70463          	beq	a4,a5,80004cb8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bf4:	4789                	li	a5,2
    80004bf6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bfa:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bfe:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c02:	f4c42783          	lw	a5,-180(s0)
    80004c06:	0017c713          	xori	a4,a5,1
    80004c0a:	8b05                	andi	a4,a4,1
    80004c0c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c10:	0037f713          	andi	a4,a5,3
    80004c14:	00e03733          	snez	a4,a4
    80004c18:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c1c:	4007f793          	andi	a5,a5,1024
    80004c20:	c791                	beqz	a5,80004c2c <sys_open+0xd2>
    80004c22:	04491703          	lh	a4,68(s2)
    80004c26:	4789                	li	a5,2
    80004c28:	08f70f63          	beq	a4,a5,80004cc6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c2c:	854a                	mv	a0,s2
    80004c2e:	ffffe097          	auipc	ra,0xffffe
    80004c32:	074080e7          	jalr	116(ra) # 80002ca2 <iunlock>
  end_op();
    80004c36:	fffff097          	auipc	ra,0xfffff
    80004c3a:	9fc080e7          	jalr	-1540(ra) # 80003632 <end_op>

  return fd;
}
    80004c3e:	8526                	mv	a0,s1
    80004c40:	70ea                	ld	ra,184(sp)
    80004c42:	744a                	ld	s0,176(sp)
    80004c44:	74aa                	ld	s1,168(sp)
    80004c46:	790a                	ld	s2,160(sp)
    80004c48:	69ea                	ld	s3,152(sp)
    80004c4a:	6129                	addi	sp,sp,192
    80004c4c:	8082                	ret
      end_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	9e4080e7          	jalr	-1564(ra) # 80003632 <end_op>
      return -1;
    80004c56:	b7e5                	j	80004c3e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c58:	f5040513          	addi	a0,s0,-176
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	73a080e7          	jalr	1850(ra) # 80003396 <namei>
    80004c64:	892a                	mv	s2,a0
    80004c66:	c905                	beqz	a0,80004c96 <sys_open+0x13c>
    ilock(ip);
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	f78080e7          	jalr	-136(ra) # 80002be0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c70:	04491703          	lh	a4,68(s2)
    80004c74:	4785                	li	a5,1
    80004c76:	f4f712e3          	bne	a4,a5,80004bba <sys_open+0x60>
    80004c7a:	f4c42783          	lw	a5,-180(s0)
    80004c7e:	dba1                	beqz	a5,80004bce <sys_open+0x74>
      iunlockput(ip);
    80004c80:	854a                	mv	a0,s2
    80004c82:	ffffe097          	auipc	ra,0xffffe
    80004c86:	1c0080e7          	jalr	448(ra) # 80002e42 <iunlockput>
      end_op();
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	9a8080e7          	jalr	-1624(ra) # 80003632 <end_op>
      return -1;
    80004c92:	54fd                	li	s1,-1
    80004c94:	b76d                	j	80004c3e <sys_open+0xe4>
      end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	99c080e7          	jalr	-1636(ra) # 80003632 <end_op>
      return -1;
    80004c9e:	54fd                	li	s1,-1
    80004ca0:	bf79                	j	80004c3e <sys_open+0xe4>
    iunlockput(ip);
    80004ca2:	854a                	mv	a0,s2
    80004ca4:	ffffe097          	auipc	ra,0xffffe
    80004ca8:	19e080e7          	jalr	414(ra) # 80002e42 <iunlockput>
    end_op();
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	986080e7          	jalr	-1658(ra) # 80003632 <end_op>
    return -1;
    80004cb4:	54fd                	li	s1,-1
    80004cb6:	b761                	j	80004c3e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cb8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cbc:	04691783          	lh	a5,70(s2)
    80004cc0:	02f99223          	sh	a5,36(s3)
    80004cc4:	bf2d                	j	80004bfe <sys_open+0xa4>
    itrunc(ip);
    80004cc6:	854a                	mv	a0,s2
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	026080e7          	jalr	38(ra) # 80002cee <itrunc>
    80004cd0:	bfb1                	j	80004c2c <sys_open+0xd2>
      fileclose(f);
    80004cd2:	854e                	mv	a0,s3
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	daa080e7          	jalr	-598(ra) # 80003a7e <fileclose>
    iunlockput(ip);
    80004cdc:	854a                	mv	a0,s2
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	164080e7          	jalr	356(ra) # 80002e42 <iunlockput>
    end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	94c080e7          	jalr	-1716(ra) # 80003632 <end_op>
    return -1;
    80004cee:	54fd                	li	s1,-1
    80004cf0:	b7b9                	j	80004c3e <sys_open+0xe4>

0000000080004cf2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cf2:	7175                	addi	sp,sp,-144
    80004cf4:	e506                	sd	ra,136(sp)
    80004cf6:	e122                	sd	s0,128(sp)
    80004cf8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	8b8080e7          	jalr	-1864(ra) # 800035b2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d02:	08000613          	li	a2,128
    80004d06:	f7040593          	addi	a1,s0,-144
    80004d0a:	4501                	li	a0,0
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	2dc080e7          	jalr	732(ra) # 80001fe8 <argstr>
    80004d14:	02054963          	bltz	a0,80004d46 <sys_mkdir+0x54>
    80004d18:	4681                	li	a3,0
    80004d1a:	4601                	li	a2,0
    80004d1c:	4585                	li	a1,1
    80004d1e:	f7040513          	addi	a0,s0,-144
    80004d22:	00000097          	auipc	ra,0x0
    80004d26:	800080e7          	jalr	-2048(ra) # 80004522 <create>
    80004d2a:	cd11                	beqz	a0,80004d46 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d2c:	ffffe097          	auipc	ra,0xffffe
    80004d30:	116080e7          	jalr	278(ra) # 80002e42 <iunlockput>
  end_op();
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	8fe080e7          	jalr	-1794(ra) # 80003632 <end_op>
  return 0;
    80004d3c:	4501                	li	a0,0
}
    80004d3e:	60aa                	ld	ra,136(sp)
    80004d40:	640a                	ld	s0,128(sp)
    80004d42:	6149                	addi	sp,sp,144
    80004d44:	8082                	ret
    end_op();
    80004d46:	fffff097          	auipc	ra,0xfffff
    80004d4a:	8ec080e7          	jalr	-1812(ra) # 80003632 <end_op>
    return -1;
    80004d4e:	557d                	li	a0,-1
    80004d50:	b7fd                	j	80004d3e <sys_mkdir+0x4c>

0000000080004d52 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d52:	7135                	addi	sp,sp,-160
    80004d54:	ed06                	sd	ra,152(sp)
    80004d56:	e922                	sd	s0,144(sp)
    80004d58:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	858080e7          	jalr	-1960(ra) # 800035b2 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d62:	08000613          	li	a2,128
    80004d66:	f7040593          	addi	a1,s0,-144
    80004d6a:	4501                	li	a0,0
    80004d6c:	ffffd097          	auipc	ra,0xffffd
    80004d70:	27c080e7          	jalr	636(ra) # 80001fe8 <argstr>
    80004d74:	04054a63          	bltz	a0,80004dc8 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d78:	f6c40593          	addi	a1,s0,-148
    80004d7c:	4505                	li	a0,1
    80004d7e:	ffffd097          	auipc	ra,0xffffd
    80004d82:	226080e7          	jalr	550(ra) # 80001fa4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d86:	04054163          	bltz	a0,80004dc8 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d8a:	f6840593          	addi	a1,s0,-152
    80004d8e:	4509                	li	a0,2
    80004d90:	ffffd097          	auipc	ra,0xffffd
    80004d94:	214080e7          	jalr	532(ra) # 80001fa4 <argint>
     argint(1, &major) < 0 ||
    80004d98:	02054863          	bltz	a0,80004dc8 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d9c:	f6841683          	lh	a3,-152(s0)
    80004da0:	f6c41603          	lh	a2,-148(s0)
    80004da4:	458d                	li	a1,3
    80004da6:	f7040513          	addi	a0,s0,-144
    80004daa:	fffff097          	auipc	ra,0xfffff
    80004dae:	778080e7          	jalr	1912(ra) # 80004522 <create>
     argint(2, &minor) < 0 ||
    80004db2:	c919                	beqz	a0,80004dc8 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004db4:	ffffe097          	auipc	ra,0xffffe
    80004db8:	08e080e7          	jalr	142(ra) # 80002e42 <iunlockput>
  end_op();
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	876080e7          	jalr	-1930(ra) # 80003632 <end_op>
  return 0;
    80004dc4:	4501                	li	a0,0
    80004dc6:	a031                	j	80004dd2 <sys_mknod+0x80>
    end_op();
    80004dc8:	fffff097          	auipc	ra,0xfffff
    80004dcc:	86a080e7          	jalr	-1942(ra) # 80003632 <end_op>
    return -1;
    80004dd0:	557d                	li	a0,-1
}
    80004dd2:	60ea                	ld	ra,152(sp)
    80004dd4:	644a                	ld	s0,144(sp)
    80004dd6:	610d                	addi	sp,sp,160
    80004dd8:	8082                	ret

0000000080004dda <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dda:	7135                	addi	sp,sp,-160
    80004ddc:	ed06                	sd	ra,152(sp)
    80004dde:	e922                	sd	s0,144(sp)
    80004de0:	e526                	sd	s1,136(sp)
    80004de2:	e14a                	sd	s2,128(sp)
    80004de4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004de6:	ffffc097          	auipc	ra,0xffffc
    80004dea:	0a6080e7          	jalr	166(ra) # 80000e8c <myproc>
    80004dee:	892a                	mv	s2,a0
  
  begin_op();
    80004df0:	ffffe097          	auipc	ra,0xffffe
    80004df4:	7c2080e7          	jalr	1986(ra) # 800035b2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004df8:	08000613          	li	a2,128
    80004dfc:	f6040593          	addi	a1,s0,-160
    80004e00:	4501                	li	a0,0
    80004e02:	ffffd097          	auipc	ra,0xffffd
    80004e06:	1e6080e7          	jalr	486(ra) # 80001fe8 <argstr>
    80004e0a:	04054b63          	bltz	a0,80004e60 <sys_chdir+0x86>
    80004e0e:	f6040513          	addi	a0,s0,-160
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	584080e7          	jalr	1412(ra) # 80003396 <namei>
    80004e1a:	84aa                	mv	s1,a0
    80004e1c:	c131                	beqz	a0,80004e60 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	dc2080e7          	jalr	-574(ra) # 80002be0 <ilock>
  if(ip->type != T_DIR){
    80004e26:	04449703          	lh	a4,68(s1)
    80004e2a:	4785                	li	a5,1
    80004e2c:	04f71063          	bne	a4,a5,80004e6c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e30:	8526                	mv	a0,s1
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	e70080e7          	jalr	-400(ra) # 80002ca2 <iunlock>
  iput(p->cwd);
    80004e3a:	15093503          	ld	a0,336(s2)
    80004e3e:	ffffe097          	auipc	ra,0xffffe
    80004e42:	f5c080e7          	jalr	-164(ra) # 80002d9a <iput>
  end_op();
    80004e46:	ffffe097          	auipc	ra,0xffffe
    80004e4a:	7ec080e7          	jalr	2028(ra) # 80003632 <end_op>
  p->cwd = ip;
    80004e4e:	14993823          	sd	s1,336(s2)
  return 0;
    80004e52:	4501                	li	a0,0
}
    80004e54:	60ea                	ld	ra,152(sp)
    80004e56:	644a                	ld	s0,144(sp)
    80004e58:	64aa                	ld	s1,136(sp)
    80004e5a:	690a                	ld	s2,128(sp)
    80004e5c:	610d                	addi	sp,sp,160
    80004e5e:	8082                	ret
    end_op();
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	7d2080e7          	jalr	2002(ra) # 80003632 <end_op>
    return -1;
    80004e68:	557d                	li	a0,-1
    80004e6a:	b7ed                	j	80004e54 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e6c:	8526                	mv	a0,s1
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	fd4080e7          	jalr	-44(ra) # 80002e42 <iunlockput>
    end_op();
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	7bc080e7          	jalr	1980(ra) # 80003632 <end_op>
    return -1;
    80004e7e:	557d                	li	a0,-1
    80004e80:	bfd1                	j	80004e54 <sys_chdir+0x7a>

0000000080004e82 <sys_exec>:

uint64
sys_exec(void)
{
    80004e82:	7145                	addi	sp,sp,-464
    80004e84:	e786                	sd	ra,456(sp)
    80004e86:	e3a2                	sd	s0,448(sp)
    80004e88:	ff26                	sd	s1,440(sp)
    80004e8a:	fb4a                	sd	s2,432(sp)
    80004e8c:	f74e                	sd	s3,424(sp)
    80004e8e:	f352                	sd	s4,416(sp)
    80004e90:	ef56                	sd	s5,408(sp)
    80004e92:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e94:	08000613          	li	a2,128
    80004e98:	f4040593          	addi	a1,s0,-192
    80004e9c:	4501                	li	a0,0
    80004e9e:	ffffd097          	auipc	ra,0xffffd
    80004ea2:	14a080e7          	jalr	330(ra) # 80001fe8 <argstr>
    return -1;
    80004ea6:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ea8:	0c054a63          	bltz	a0,80004f7c <sys_exec+0xfa>
    80004eac:	e3840593          	addi	a1,s0,-456
    80004eb0:	4505                	li	a0,1
    80004eb2:	ffffd097          	auipc	ra,0xffffd
    80004eb6:	114080e7          	jalr	276(ra) # 80001fc6 <argaddr>
    80004eba:	0c054163          	bltz	a0,80004f7c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ebe:	10000613          	li	a2,256
    80004ec2:	4581                	li	a1,0
    80004ec4:	e4040513          	addi	a0,s0,-448
    80004ec8:	ffffb097          	auipc	ra,0xffffb
    80004ecc:	2fa080e7          	jalr	762(ra) # 800001c2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ed0:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ed4:	89a6                	mv	s3,s1
    80004ed6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ed8:	02000a13          	li	s4,32
    80004edc:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ee0:	00391793          	slli	a5,s2,0x3
    80004ee4:	e3040593          	addi	a1,s0,-464
    80004ee8:	e3843503          	ld	a0,-456(s0)
    80004eec:	953e                	add	a0,a0,a5
    80004eee:	ffffd097          	auipc	ra,0xffffd
    80004ef2:	01c080e7          	jalr	28(ra) # 80001f0a <fetchaddr>
    80004ef6:	02054a63          	bltz	a0,80004f2a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004efa:	e3043783          	ld	a5,-464(s0)
    80004efe:	c3b9                	beqz	a5,80004f44 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f00:	ffffb097          	auipc	ra,0xffffb
    80004f04:	218080e7          	jalr	536(ra) # 80000118 <kalloc>
    80004f08:	85aa                	mv	a1,a0
    80004f0a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f0e:	cd11                	beqz	a0,80004f2a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f10:	6605                	lui	a2,0x1
    80004f12:	e3043503          	ld	a0,-464(s0)
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	046080e7          	jalr	70(ra) # 80001f5c <fetchstr>
    80004f1e:	00054663          	bltz	a0,80004f2a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f22:	0905                	addi	s2,s2,1
    80004f24:	09a1                	addi	s3,s3,8
    80004f26:	fb491be3          	bne	s2,s4,80004edc <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f2a:	10048913          	addi	s2,s1,256
    80004f2e:	6088                	ld	a0,0(s1)
    80004f30:	c529                	beqz	a0,80004f7a <sys_exec+0xf8>
    kfree(argv[i]);
    80004f32:	ffffb097          	auipc	ra,0xffffb
    80004f36:	0ea080e7          	jalr	234(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f3a:	04a1                	addi	s1,s1,8
    80004f3c:	ff2499e3          	bne	s1,s2,80004f2e <sys_exec+0xac>
  return -1;
    80004f40:	597d                	li	s2,-1
    80004f42:	a82d                	j	80004f7c <sys_exec+0xfa>
      argv[i] = 0;
    80004f44:	0a8e                	slli	s5,s5,0x3
    80004f46:	fc040793          	addi	a5,s0,-64
    80004f4a:	9abe                	add	s5,s5,a5
    80004f4c:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8c40>
  int ret = exec(path, argv);
    80004f50:	e4040593          	addi	a1,s0,-448
    80004f54:	f4040513          	addi	a0,s0,-192
    80004f58:	fffff097          	auipc	ra,0xfffff
    80004f5c:	178080e7          	jalr	376(ra) # 800040d0 <exec>
    80004f60:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f62:	10048993          	addi	s3,s1,256
    80004f66:	6088                	ld	a0,0(s1)
    80004f68:	c911                	beqz	a0,80004f7c <sys_exec+0xfa>
    kfree(argv[i]);
    80004f6a:	ffffb097          	auipc	ra,0xffffb
    80004f6e:	0b2080e7          	jalr	178(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f72:	04a1                	addi	s1,s1,8
    80004f74:	ff3499e3          	bne	s1,s3,80004f66 <sys_exec+0xe4>
    80004f78:	a011                	j	80004f7c <sys_exec+0xfa>
  return -1;
    80004f7a:	597d                	li	s2,-1
}
    80004f7c:	854a                	mv	a0,s2
    80004f7e:	60be                	ld	ra,456(sp)
    80004f80:	641e                	ld	s0,448(sp)
    80004f82:	74fa                	ld	s1,440(sp)
    80004f84:	795a                	ld	s2,432(sp)
    80004f86:	79ba                	ld	s3,424(sp)
    80004f88:	7a1a                	ld	s4,416(sp)
    80004f8a:	6afa                	ld	s5,408(sp)
    80004f8c:	6179                	addi	sp,sp,464
    80004f8e:	8082                	ret

0000000080004f90 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f90:	7139                	addi	sp,sp,-64
    80004f92:	fc06                	sd	ra,56(sp)
    80004f94:	f822                	sd	s0,48(sp)
    80004f96:	f426                	sd	s1,40(sp)
    80004f98:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f9a:	ffffc097          	auipc	ra,0xffffc
    80004f9e:	ef2080e7          	jalr	-270(ra) # 80000e8c <myproc>
    80004fa2:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fa4:	fd840593          	addi	a1,s0,-40
    80004fa8:	4501                	li	a0,0
    80004faa:	ffffd097          	auipc	ra,0xffffd
    80004fae:	01c080e7          	jalr	28(ra) # 80001fc6 <argaddr>
    return -1;
    80004fb2:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fb4:	0e054063          	bltz	a0,80005094 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fb8:	fc840593          	addi	a1,s0,-56
    80004fbc:	fd040513          	addi	a0,s0,-48
    80004fc0:	fffff097          	auipc	ra,0xfffff
    80004fc4:	dee080e7          	jalr	-530(ra) # 80003dae <pipealloc>
    return -1;
    80004fc8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fca:	0c054563          	bltz	a0,80005094 <sys_pipe+0x104>
  fd0 = -1;
    80004fce:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fd2:	fd043503          	ld	a0,-48(s0)
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	50a080e7          	jalr	1290(ra) # 800044e0 <fdalloc>
    80004fde:	fca42223          	sw	a0,-60(s0)
    80004fe2:	08054c63          	bltz	a0,8000507a <sys_pipe+0xea>
    80004fe6:	fc843503          	ld	a0,-56(s0)
    80004fea:	fffff097          	auipc	ra,0xfffff
    80004fee:	4f6080e7          	jalr	1270(ra) # 800044e0 <fdalloc>
    80004ff2:	fca42023          	sw	a0,-64(s0)
    80004ff6:	06054863          	bltz	a0,80005066 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ffa:	4691                	li	a3,4
    80004ffc:	fc440613          	addi	a2,s0,-60
    80005000:	fd843583          	ld	a1,-40(s0)
    80005004:	68a8                	ld	a0,80(s1)
    80005006:	ffffc097          	auipc	ra,0xffffc
    8000500a:	b46080e7          	jalr	-1210(ra) # 80000b4c <copyout>
    8000500e:	02054063          	bltz	a0,8000502e <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005012:	4691                	li	a3,4
    80005014:	fc040613          	addi	a2,s0,-64
    80005018:	fd843583          	ld	a1,-40(s0)
    8000501c:	0591                	addi	a1,a1,4
    8000501e:	68a8                	ld	a0,80(s1)
    80005020:	ffffc097          	auipc	ra,0xffffc
    80005024:	b2c080e7          	jalr	-1236(ra) # 80000b4c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005028:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000502a:	06055563          	bgez	a0,80005094 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000502e:	fc442783          	lw	a5,-60(s0)
    80005032:	07e9                	addi	a5,a5,26
    80005034:	078e                	slli	a5,a5,0x3
    80005036:	97a6                	add	a5,a5,s1
    80005038:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000503c:	fc042503          	lw	a0,-64(s0)
    80005040:	0569                	addi	a0,a0,26
    80005042:	050e                	slli	a0,a0,0x3
    80005044:	9526                	add	a0,a0,s1
    80005046:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000504a:	fd043503          	ld	a0,-48(s0)
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	a30080e7          	jalr	-1488(ra) # 80003a7e <fileclose>
    fileclose(wf);
    80005056:	fc843503          	ld	a0,-56(s0)
    8000505a:	fffff097          	auipc	ra,0xfffff
    8000505e:	a24080e7          	jalr	-1500(ra) # 80003a7e <fileclose>
    return -1;
    80005062:	57fd                	li	a5,-1
    80005064:	a805                	j	80005094 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005066:	fc442783          	lw	a5,-60(s0)
    8000506a:	0007c863          	bltz	a5,8000507a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000506e:	01a78513          	addi	a0,a5,26
    80005072:	050e                	slli	a0,a0,0x3
    80005074:	9526                	add	a0,a0,s1
    80005076:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000507a:	fd043503          	ld	a0,-48(s0)
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	a00080e7          	jalr	-1536(ra) # 80003a7e <fileclose>
    fileclose(wf);
    80005086:	fc843503          	ld	a0,-56(s0)
    8000508a:	fffff097          	auipc	ra,0xfffff
    8000508e:	9f4080e7          	jalr	-1548(ra) # 80003a7e <fileclose>
    return -1;
    80005092:	57fd                	li	a5,-1
}
    80005094:	853e                	mv	a0,a5
    80005096:	70e2                	ld	ra,56(sp)
    80005098:	7442                	ld	s0,48(sp)
    8000509a:	74a2                	ld	s1,40(sp)
    8000509c:	6121                	addi	sp,sp,64
    8000509e:	8082                	ret

00000000800050a0 <kernelvec>:
    800050a0:	7111                	addi	sp,sp,-256
    800050a2:	e006                	sd	ra,0(sp)
    800050a4:	e40a                	sd	sp,8(sp)
    800050a6:	e80e                	sd	gp,16(sp)
    800050a8:	ec12                	sd	tp,24(sp)
    800050aa:	f016                	sd	t0,32(sp)
    800050ac:	f41a                	sd	t1,40(sp)
    800050ae:	f81e                	sd	t2,48(sp)
    800050b0:	fc22                	sd	s0,56(sp)
    800050b2:	e0a6                	sd	s1,64(sp)
    800050b4:	e4aa                	sd	a0,72(sp)
    800050b6:	e8ae                	sd	a1,80(sp)
    800050b8:	ecb2                	sd	a2,88(sp)
    800050ba:	f0b6                	sd	a3,96(sp)
    800050bc:	f4ba                	sd	a4,104(sp)
    800050be:	f8be                	sd	a5,112(sp)
    800050c0:	fcc2                	sd	a6,120(sp)
    800050c2:	e146                	sd	a7,128(sp)
    800050c4:	e54a                	sd	s2,136(sp)
    800050c6:	e94e                	sd	s3,144(sp)
    800050c8:	ed52                	sd	s4,152(sp)
    800050ca:	f156                	sd	s5,160(sp)
    800050cc:	f55a                	sd	s6,168(sp)
    800050ce:	f95e                	sd	s7,176(sp)
    800050d0:	fd62                	sd	s8,184(sp)
    800050d2:	e1e6                	sd	s9,192(sp)
    800050d4:	e5ea                	sd	s10,200(sp)
    800050d6:	e9ee                	sd	s11,208(sp)
    800050d8:	edf2                	sd	t3,216(sp)
    800050da:	f1f6                	sd	t4,224(sp)
    800050dc:	f5fa                	sd	t5,232(sp)
    800050de:	f9fe                	sd	t6,240(sp)
    800050e0:	cf7fc0ef          	jal	80001dd6 <kerneltrap>
    800050e4:	6082                	ld	ra,0(sp)
    800050e6:	6122                	ld	sp,8(sp)
    800050e8:	61c2                	ld	gp,16(sp)
    800050ea:	7282                	ld	t0,32(sp)
    800050ec:	7322                	ld	t1,40(sp)
    800050ee:	73c2                	ld	t2,48(sp)
    800050f0:	7462                	ld	s0,56(sp)
    800050f2:	6486                	ld	s1,64(sp)
    800050f4:	6526                	ld	a0,72(sp)
    800050f6:	65c6                	ld	a1,80(sp)
    800050f8:	6666                	ld	a2,88(sp)
    800050fa:	7686                	ld	a3,96(sp)
    800050fc:	7726                	ld	a4,104(sp)
    800050fe:	77c6                	ld	a5,112(sp)
    80005100:	7866                	ld	a6,120(sp)
    80005102:	688a                	ld	a7,128(sp)
    80005104:	692a                	ld	s2,136(sp)
    80005106:	69ca                	ld	s3,144(sp)
    80005108:	6a6a                	ld	s4,152(sp)
    8000510a:	7a8a                	ld	s5,160(sp)
    8000510c:	7b2a                	ld	s6,168(sp)
    8000510e:	7bca                	ld	s7,176(sp)
    80005110:	7c6a                	ld	s8,184(sp)
    80005112:	6c8e                	ld	s9,192(sp)
    80005114:	6d2e                	ld	s10,200(sp)
    80005116:	6dce                	ld	s11,208(sp)
    80005118:	6e6e                	ld	t3,216(sp)
    8000511a:	7e8e                	ld	t4,224(sp)
    8000511c:	7f2e                	ld	t5,232(sp)
    8000511e:	7fce                	ld	t6,240(sp)
    80005120:	6111                	addi	sp,sp,256
    80005122:	10200073          	sret
    80005126:	00000013          	nop
    8000512a:	00000013          	nop
    8000512e:	0001                	nop

0000000080005130 <timervec>:
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	e10c                	sd	a1,0(a0)
    80005136:	e510                	sd	a2,8(a0)
    80005138:	e914                	sd	a3,16(a0)
    8000513a:	6d0c                	ld	a1,24(a0)
    8000513c:	7110                	ld	a2,32(a0)
    8000513e:	6194                	ld	a3,0(a1)
    80005140:	96b2                	add	a3,a3,a2
    80005142:	e194                	sd	a3,0(a1)
    80005144:	4589                	li	a1,2
    80005146:	14459073          	csrw	sip,a1
    8000514a:	6914                	ld	a3,16(a0)
    8000514c:	6510                	ld	a2,8(a0)
    8000514e:	610c                	ld	a1,0(a0)
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	30200073          	mret
	...

000000008000515a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000515a:	1141                	addi	sp,sp,-16
    8000515c:	e422                	sd	s0,8(sp)
    8000515e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005160:	0c0007b7          	lui	a5,0xc000
    80005164:	4705                	li	a4,1
    80005166:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005168:	c3d8                	sw	a4,4(a5)
}
    8000516a:	6422                	ld	s0,8(sp)
    8000516c:	0141                	addi	sp,sp,16
    8000516e:	8082                	ret

0000000080005170 <plicinithart>:

void
plicinithart(void)
{
    80005170:	1141                	addi	sp,sp,-16
    80005172:	e406                	sd	ra,8(sp)
    80005174:	e022                	sd	s0,0(sp)
    80005176:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	ce8080e7          	jalr	-792(ra) # 80000e60 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005180:	0085171b          	slliw	a4,a0,0x8
    80005184:	0c0027b7          	lui	a5,0xc002
    80005188:	97ba                	add	a5,a5,a4
    8000518a:	40200713          	li	a4,1026
    8000518e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005192:	00d5151b          	slliw	a0,a0,0xd
    80005196:	0c2017b7          	lui	a5,0xc201
    8000519a:	953e                	add	a0,a0,a5
    8000519c:	00052023          	sw	zero,0(a0)
}
    800051a0:	60a2                	ld	ra,8(sp)
    800051a2:	6402                	ld	s0,0(sp)
    800051a4:	0141                	addi	sp,sp,16
    800051a6:	8082                	ret

00000000800051a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051a8:	1141                	addi	sp,sp,-16
    800051aa:	e406                	sd	ra,8(sp)
    800051ac:	e022                	sd	s0,0(sp)
    800051ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	cb0080e7          	jalr	-848(ra) # 80000e60 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051b8:	00d5179b          	slliw	a5,a0,0xd
    800051bc:	0c201537          	lui	a0,0xc201
    800051c0:	953e                	add	a0,a0,a5
  return irq;
}
    800051c2:	4148                	lw	a0,4(a0)
    800051c4:	60a2                	ld	ra,8(sp)
    800051c6:	6402                	ld	s0,0(sp)
    800051c8:	0141                	addi	sp,sp,16
    800051ca:	8082                	ret

00000000800051cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051cc:	1101                	addi	sp,sp,-32
    800051ce:	ec06                	sd	ra,24(sp)
    800051d0:	e822                	sd	s0,16(sp)
    800051d2:	e426                	sd	s1,8(sp)
    800051d4:	1000                	addi	s0,sp,32
    800051d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	c88080e7          	jalr	-888(ra) # 80000e60 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051e0:	00d5151b          	slliw	a0,a0,0xd
    800051e4:	0c2017b7          	lui	a5,0xc201
    800051e8:	97aa                	add	a5,a5,a0
    800051ea:	c3c4                	sw	s1,4(a5)
}
    800051ec:	60e2                	ld	ra,24(sp)
    800051ee:	6442                	ld	s0,16(sp)
    800051f0:	64a2                	ld	s1,8(sp)
    800051f2:	6105                	addi	sp,sp,32
    800051f4:	8082                	ret

00000000800051f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051f6:	1141                	addi	sp,sp,-16
    800051f8:	e406                	sd	ra,8(sp)
    800051fa:	e022                	sd	s0,0(sp)
    800051fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051fe:	479d                	li	a5,7
    80005200:	06a7c963          	blt	a5,a0,80005272 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005204:	00016797          	auipc	a5,0x16
    80005208:	dfc78793          	addi	a5,a5,-516 # 8001b000 <disk>
    8000520c:	00a78733          	add	a4,a5,a0
    80005210:	6789                	lui	a5,0x2
    80005212:	97ba                	add	a5,a5,a4
    80005214:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005218:	e7ad                	bnez	a5,80005282 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000521a:	00451793          	slli	a5,a0,0x4
    8000521e:	00018717          	auipc	a4,0x18
    80005222:	de270713          	addi	a4,a4,-542 # 8001d000 <disk+0x2000>
    80005226:	6314                	ld	a3,0(a4)
    80005228:	96be                	add	a3,a3,a5
    8000522a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000522e:	6314                	ld	a3,0(a4)
    80005230:	96be                	add	a3,a3,a5
    80005232:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005236:	6314                	ld	a3,0(a4)
    80005238:	96be                	add	a3,a3,a5
    8000523a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000523e:	6318                	ld	a4,0(a4)
    80005240:	97ba                	add	a5,a5,a4
    80005242:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005246:	00016797          	auipc	a5,0x16
    8000524a:	dba78793          	addi	a5,a5,-582 # 8001b000 <disk>
    8000524e:	97aa                	add	a5,a5,a0
    80005250:	6509                	lui	a0,0x2
    80005252:	953e                	add	a0,a0,a5
    80005254:	4785                	li	a5,1
    80005256:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000525a:	00018517          	auipc	a0,0x18
    8000525e:	dbe50513          	addi	a0,a0,-578 # 8001d018 <disk+0x2018>
    80005262:	ffffc097          	auipc	ra,0xffffc
    80005266:	47e080e7          	jalr	1150(ra) # 800016e0 <wakeup>
}
    8000526a:	60a2                	ld	ra,8(sp)
    8000526c:	6402                	ld	s0,0(sp)
    8000526e:	0141                	addi	sp,sp,16
    80005270:	8082                	ret
    panic("free_desc 1");
    80005272:	00003517          	auipc	a0,0x3
    80005276:	43e50513          	addi	a0,a0,1086 # 800086b0 <etext+0x6b0>
    8000527a:	00001097          	auipc	ra,0x1
    8000527e:	9ca080e7          	jalr	-1590(ra) # 80005c44 <panic>
    panic("free_desc 2");
    80005282:	00003517          	auipc	a0,0x3
    80005286:	43e50513          	addi	a0,a0,1086 # 800086c0 <etext+0x6c0>
    8000528a:	00001097          	auipc	ra,0x1
    8000528e:	9ba080e7          	jalr	-1606(ra) # 80005c44 <panic>

0000000080005292 <virtio_disk_init>:
{
    80005292:	1101                	addi	sp,sp,-32
    80005294:	ec06                	sd	ra,24(sp)
    80005296:	e822                	sd	s0,16(sp)
    80005298:	e426                	sd	s1,8(sp)
    8000529a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000529c:	00003597          	auipc	a1,0x3
    800052a0:	43458593          	addi	a1,a1,1076 # 800086d0 <etext+0x6d0>
    800052a4:	00018517          	auipc	a0,0x18
    800052a8:	e8450513          	addi	a0,a0,-380 # 8001d128 <disk+0x2128>
    800052ac:	00001097          	auipc	ra,0x1
    800052b0:	e44080e7          	jalr	-444(ra) # 800060f0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052b4:	100017b7          	lui	a5,0x10001
    800052b8:	4398                	lw	a4,0(a5)
    800052ba:	2701                	sext.w	a4,a4
    800052bc:	747277b7          	lui	a5,0x74727
    800052c0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052c4:	0ef71163          	bne	a4,a5,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	43dc                	lw	a5,4(a5)
    800052ce:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d0:	4705                	li	a4,1
    800052d2:	0ce79a63          	bne	a5,a4,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052d6:	100017b7          	lui	a5,0x10001
    800052da:	479c                	lw	a5,8(a5)
    800052dc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052de:	4709                	li	a4,2
    800052e0:	0ce79363          	bne	a5,a4,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052e4:	100017b7          	lui	a5,0x10001
    800052e8:	47d8                	lw	a4,12(a5)
    800052ea:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ec:	554d47b7          	lui	a5,0x554d4
    800052f0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052f4:	0af71963          	bne	a4,a5,800053a6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f8:	100017b7          	lui	a5,0x10001
    800052fc:	4705                	li	a4,1
    800052fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005300:	470d                	li	a4,3
    80005302:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005304:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005306:	c7ffe737          	lui	a4,0xc7ffe
    8000530a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000530e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005310:	2701                	sext.w	a4,a4
    80005312:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005314:	472d                	li	a4,11
    80005316:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005318:	473d                	li	a4,15
    8000531a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000531c:	6705                	lui	a4,0x1
    8000531e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005320:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005324:	5bdc                	lw	a5,52(a5)
    80005326:	2781                	sext.w	a5,a5
  if(max == 0)
    80005328:	c7d9                	beqz	a5,800053b6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000532a:	471d                	li	a4,7
    8000532c:	08f77d63          	bgeu	a4,a5,800053c6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005330:	100014b7          	lui	s1,0x10001
    80005334:	47a1                	li	a5,8
    80005336:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005338:	6609                	lui	a2,0x2
    8000533a:	4581                	li	a1,0
    8000533c:	00016517          	auipc	a0,0x16
    80005340:	cc450513          	addi	a0,a0,-828 # 8001b000 <disk>
    80005344:	ffffb097          	auipc	ra,0xffffb
    80005348:	e7e080e7          	jalr	-386(ra) # 800001c2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000534c:	00016717          	auipc	a4,0x16
    80005350:	cb470713          	addi	a4,a4,-844 # 8001b000 <disk>
    80005354:	00c75793          	srli	a5,a4,0xc
    80005358:	2781                	sext.w	a5,a5
    8000535a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000535c:	00018797          	auipc	a5,0x18
    80005360:	ca478793          	addi	a5,a5,-860 # 8001d000 <disk+0x2000>
    80005364:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005366:	00016717          	auipc	a4,0x16
    8000536a:	d1a70713          	addi	a4,a4,-742 # 8001b080 <disk+0x80>
    8000536e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005370:	00017717          	auipc	a4,0x17
    80005374:	c9070713          	addi	a4,a4,-880 # 8001c000 <disk+0x1000>
    80005378:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000537a:	4705                	li	a4,1
    8000537c:	00e78c23          	sb	a4,24(a5)
    80005380:	00e78ca3          	sb	a4,25(a5)
    80005384:	00e78d23          	sb	a4,26(a5)
    80005388:	00e78da3          	sb	a4,27(a5)
    8000538c:	00e78e23          	sb	a4,28(a5)
    80005390:	00e78ea3          	sb	a4,29(a5)
    80005394:	00e78f23          	sb	a4,30(a5)
    80005398:	00e78fa3          	sb	a4,31(a5)
}
    8000539c:	60e2                	ld	ra,24(sp)
    8000539e:	6442                	ld	s0,16(sp)
    800053a0:	64a2                	ld	s1,8(sp)
    800053a2:	6105                	addi	sp,sp,32
    800053a4:	8082                	ret
    panic("could not find virtio disk");
    800053a6:	00003517          	auipc	a0,0x3
    800053aa:	33a50513          	addi	a0,a0,826 # 800086e0 <etext+0x6e0>
    800053ae:	00001097          	auipc	ra,0x1
    800053b2:	896080e7          	jalr	-1898(ra) # 80005c44 <panic>
    panic("virtio disk has no queue 0");
    800053b6:	00003517          	auipc	a0,0x3
    800053ba:	34a50513          	addi	a0,a0,842 # 80008700 <etext+0x700>
    800053be:	00001097          	auipc	ra,0x1
    800053c2:	886080e7          	jalr	-1914(ra) # 80005c44 <panic>
    panic("virtio disk max queue too short");
    800053c6:	00003517          	auipc	a0,0x3
    800053ca:	35a50513          	addi	a0,a0,858 # 80008720 <etext+0x720>
    800053ce:	00001097          	auipc	ra,0x1
    800053d2:	876080e7          	jalr	-1930(ra) # 80005c44 <panic>

00000000800053d6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053d6:	7119                	addi	sp,sp,-128
    800053d8:	fc86                	sd	ra,120(sp)
    800053da:	f8a2                	sd	s0,112(sp)
    800053dc:	f4a6                	sd	s1,104(sp)
    800053de:	f0ca                	sd	s2,96(sp)
    800053e0:	ecce                	sd	s3,88(sp)
    800053e2:	e8d2                	sd	s4,80(sp)
    800053e4:	e4d6                	sd	s5,72(sp)
    800053e6:	e0da                	sd	s6,64(sp)
    800053e8:	fc5e                	sd	s7,56(sp)
    800053ea:	f862                	sd	s8,48(sp)
    800053ec:	f466                	sd	s9,40(sp)
    800053ee:	f06a                	sd	s10,32(sp)
    800053f0:	ec6e                	sd	s11,24(sp)
    800053f2:	0100                	addi	s0,sp,128
    800053f4:	8aaa                	mv	s5,a0
    800053f6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053f8:	00c52c83          	lw	s9,12(a0)
    800053fc:	001c9c9b          	slliw	s9,s9,0x1
    80005400:	1c82                	slli	s9,s9,0x20
    80005402:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005406:	00018517          	auipc	a0,0x18
    8000540a:	d2250513          	addi	a0,a0,-734 # 8001d128 <disk+0x2128>
    8000540e:	00001097          	auipc	ra,0x1
    80005412:	d72080e7          	jalr	-654(ra) # 80006180 <acquire>
  for(int i = 0; i < 3; i++){
    80005416:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005418:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000541a:	00016c17          	auipc	s8,0x16
    8000541e:	be6c0c13          	addi	s8,s8,-1050 # 8001b000 <disk>
    80005422:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005424:	4b0d                	li	s6,3
    80005426:	a0ad                	j	80005490 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005428:	00fc0733          	add	a4,s8,a5
    8000542c:	975e                	add	a4,a4,s7
    8000542e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005432:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005434:	0207c563          	bltz	a5,8000545e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005438:	2905                	addiw	s2,s2,1
    8000543a:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    8000543c:	19690d63          	beq	s2,s6,800055d6 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80005440:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005442:	00018717          	auipc	a4,0x18
    80005446:	bd670713          	addi	a4,a4,-1066 # 8001d018 <disk+0x2018>
    8000544a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000544c:	00074683          	lbu	a3,0(a4)
    80005450:	fee1                	bnez	a3,80005428 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005452:	2785                	addiw	a5,a5,1
    80005454:	0705                	addi	a4,a4,1
    80005456:	fe979be3          	bne	a5,s1,8000544c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000545a:	57fd                	li	a5,-1
    8000545c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000545e:	01205d63          	blez	s2,80005478 <virtio_disk_rw+0xa2>
    80005462:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005464:	000a2503          	lw	a0,0(s4)
    80005468:	00000097          	auipc	ra,0x0
    8000546c:	d8e080e7          	jalr	-626(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005470:	2d85                	addiw	s11,s11,1
    80005472:	0a11                	addi	s4,s4,4
    80005474:	ffb918e3          	bne	s2,s11,80005464 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005478:	00018597          	auipc	a1,0x18
    8000547c:	cb058593          	addi	a1,a1,-848 # 8001d128 <disk+0x2128>
    80005480:	00018517          	auipc	a0,0x18
    80005484:	b9850513          	addi	a0,a0,-1128 # 8001d018 <disk+0x2018>
    80005488:	ffffc097          	auipc	ra,0xffffc
    8000548c:	0cc080e7          	jalr	204(ra) # 80001554 <sleep>
  for(int i = 0; i < 3; i++){
    80005490:	f8040a13          	addi	s4,s0,-128
{
    80005494:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005496:	894e                	mv	s2,s3
    80005498:	b765                	j	80005440 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000549a:	00018697          	auipc	a3,0x18
    8000549e:	b666b683          	ld	a3,-1178(a3) # 8001d000 <disk+0x2000>
    800054a2:	96ba                	add	a3,a3,a4
    800054a4:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054a8:	00016817          	auipc	a6,0x16
    800054ac:	b5880813          	addi	a6,a6,-1192 # 8001b000 <disk>
    800054b0:	00018697          	auipc	a3,0x18
    800054b4:	b5068693          	addi	a3,a3,-1200 # 8001d000 <disk+0x2000>
    800054b8:	6290                	ld	a2,0(a3)
    800054ba:	963a                	add	a2,a2,a4
    800054bc:	00c65583          	lhu	a1,12(a2)
    800054c0:	0015e593          	ori	a1,a1,1
    800054c4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800054c8:	f8842603          	lw	a2,-120(s0)
    800054cc:	628c                	ld	a1,0(a3)
    800054ce:	972e                	add	a4,a4,a1
    800054d0:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054d4:	20050593          	addi	a1,a0,512
    800054d8:	0592                	slli	a1,a1,0x4
    800054da:	95c2                	add	a1,a1,a6
    800054dc:	577d                	li	a4,-1
    800054de:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054e2:	00461713          	slli	a4,a2,0x4
    800054e6:	6290                	ld	a2,0(a3)
    800054e8:	963a                	add	a2,a2,a4
    800054ea:	03078793          	addi	a5,a5,48
    800054ee:	97c2                	add	a5,a5,a6
    800054f0:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800054f2:	629c                	ld	a5,0(a3)
    800054f4:	97ba                	add	a5,a5,a4
    800054f6:	4605                	li	a2,1
    800054f8:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054fa:	629c                	ld	a5,0(a3)
    800054fc:	97ba                	add	a5,a5,a4
    800054fe:	4809                	li	a6,2
    80005500:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005504:	629c                	ld	a5,0(a3)
    80005506:	973e                	add	a4,a4,a5
    80005508:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000550c:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005510:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005514:	6698                	ld	a4,8(a3)
    80005516:	00275783          	lhu	a5,2(a4)
    8000551a:	8b9d                	andi	a5,a5,7
    8000551c:	0786                	slli	a5,a5,0x1
    8000551e:	97ba                	add	a5,a5,a4
    80005520:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80005524:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005528:	6698                	ld	a4,8(a3)
    8000552a:	00275783          	lhu	a5,2(a4)
    8000552e:	2785                	addiw	a5,a5,1
    80005530:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005534:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005538:	100017b7          	lui	a5,0x10001
    8000553c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005540:	004aa783          	lw	a5,4(s5)
    80005544:	02c79163          	bne	a5,a2,80005566 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005548:	00018917          	auipc	s2,0x18
    8000554c:	be090913          	addi	s2,s2,-1056 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005550:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005552:	85ca                	mv	a1,s2
    80005554:	8556                	mv	a0,s5
    80005556:	ffffc097          	auipc	ra,0xffffc
    8000555a:	ffe080e7          	jalr	-2(ra) # 80001554 <sleep>
  while(b->disk == 1) {
    8000555e:	004aa783          	lw	a5,4(s5)
    80005562:	fe9788e3          	beq	a5,s1,80005552 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005566:	f8042903          	lw	s2,-128(s0)
    8000556a:	20090793          	addi	a5,s2,512
    8000556e:	00479713          	slli	a4,a5,0x4
    80005572:	00016797          	auipc	a5,0x16
    80005576:	a8e78793          	addi	a5,a5,-1394 # 8001b000 <disk>
    8000557a:	97ba                	add	a5,a5,a4
    8000557c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005580:	00018997          	auipc	s3,0x18
    80005584:	a8098993          	addi	s3,s3,-1408 # 8001d000 <disk+0x2000>
    80005588:	00491713          	slli	a4,s2,0x4
    8000558c:	0009b783          	ld	a5,0(s3)
    80005590:	97ba                	add	a5,a5,a4
    80005592:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005596:	854a                	mv	a0,s2
    80005598:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000559c:	00000097          	auipc	ra,0x0
    800055a0:	c5a080e7          	jalr	-934(ra) # 800051f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055a4:	8885                	andi	s1,s1,1
    800055a6:	f0ed                	bnez	s1,80005588 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055a8:	00018517          	auipc	a0,0x18
    800055ac:	b8050513          	addi	a0,a0,-1152 # 8001d128 <disk+0x2128>
    800055b0:	00001097          	auipc	ra,0x1
    800055b4:	c84080e7          	jalr	-892(ra) # 80006234 <release>
}
    800055b8:	70e6                	ld	ra,120(sp)
    800055ba:	7446                	ld	s0,112(sp)
    800055bc:	74a6                	ld	s1,104(sp)
    800055be:	7906                	ld	s2,96(sp)
    800055c0:	69e6                	ld	s3,88(sp)
    800055c2:	6a46                	ld	s4,80(sp)
    800055c4:	6aa6                	ld	s5,72(sp)
    800055c6:	6b06                	ld	s6,64(sp)
    800055c8:	7be2                	ld	s7,56(sp)
    800055ca:	7c42                	ld	s8,48(sp)
    800055cc:	7ca2                	ld	s9,40(sp)
    800055ce:	7d02                	ld	s10,32(sp)
    800055d0:	6de2                	ld	s11,24(sp)
    800055d2:	6109                	addi	sp,sp,128
    800055d4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055d6:	f8042503          	lw	a0,-128(s0)
    800055da:	20050793          	addi	a5,a0,512
    800055de:	0792                	slli	a5,a5,0x4
  if(write)
    800055e0:	00016817          	auipc	a6,0x16
    800055e4:	a2080813          	addi	a6,a6,-1504 # 8001b000 <disk>
    800055e8:	00f80733          	add	a4,a6,a5
    800055ec:	01a036b3          	snez	a3,s10
    800055f0:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800055f4:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055f8:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055fc:	7679                	lui	a2,0xffffe
    800055fe:	963e                	add	a2,a2,a5
    80005600:	00018697          	auipc	a3,0x18
    80005604:	a0068693          	addi	a3,a3,-1536 # 8001d000 <disk+0x2000>
    80005608:	6298                	ld	a4,0(a3)
    8000560a:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000560c:	0a878593          	addi	a1,a5,168
    80005610:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005612:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005614:	6298                	ld	a4,0(a3)
    80005616:	9732                	add	a4,a4,a2
    80005618:	45c1                	li	a1,16
    8000561a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000561c:	6298                	ld	a4,0(a3)
    8000561e:	9732                	add	a4,a4,a2
    80005620:	4585                	li	a1,1
    80005622:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005626:	f8442703          	lw	a4,-124(s0)
    8000562a:	628c                	ld	a1,0(a3)
    8000562c:	962e                	add	a2,a2,a1
    8000562e:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005632:	0712                	slli	a4,a4,0x4
    80005634:	6290                	ld	a2,0(a3)
    80005636:	963a                	add	a2,a2,a4
    80005638:	058a8593          	addi	a1,s5,88
    8000563c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000563e:	6294                	ld	a3,0(a3)
    80005640:	96ba                	add	a3,a3,a4
    80005642:	40000613          	li	a2,1024
    80005646:	c690                	sw	a2,8(a3)
  if(write)
    80005648:	e40d19e3          	bnez	s10,8000549a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000564c:	00018697          	auipc	a3,0x18
    80005650:	9b46b683          	ld	a3,-1612(a3) # 8001d000 <disk+0x2000>
    80005654:	96ba                	add	a3,a3,a4
    80005656:	4609                	li	a2,2
    80005658:	00c69623          	sh	a2,12(a3)
    8000565c:	b5b1                	j	800054a8 <virtio_disk_rw+0xd2>

000000008000565e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000565e:	1101                	addi	sp,sp,-32
    80005660:	ec06                	sd	ra,24(sp)
    80005662:	e822                	sd	s0,16(sp)
    80005664:	e426                	sd	s1,8(sp)
    80005666:	e04a                	sd	s2,0(sp)
    80005668:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000566a:	00018517          	auipc	a0,0x18
    8000566e:	abe50513          	addi	a0,a0,-1346 # 8001d128 <disk+0x2128>
    80005672:	00001097          	auipc	ra,0x1
    80005676:	b0e080e7          	jalr	-1266(ra) # 80006180 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000567a:	10001737          	lui	a4,0x10001
    8000567e:	533c                	lw	a5,96(a4)
    80005680:	8b8d                	andi	a5,a5,3
    80005682:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005684:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005688:	00018797          	auipc	a5,0x18
    8000568c:	97878793          	addi	a5,a5,-1672 # 8001d000 <disk+0x2000>
    80005690:	6b94                	ld	a3,16(a5)
    80005692:	0207d703          	lhu	a4,32(a5)
    80005696:	0026d783          	lhu	a5,2(a3)
    8000569a:	06f70163          	beq	a4,a5,800056fc <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000569e:	00016917          	auipc	s2,0x16
    800056a2:	96290913          	addi	s2,s2,-1694 # 8001b000 <disk>
    800056a6:	00018497          	auipc	s1,0x18
    800056aa:	95a48493          	addi	s1,s1,-1702 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056ae:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056b2:	6898                	ld	a4,16(s1)
    800056b4:	0204d783          	lhu	a5,32(s1)
    800056b8:	8b9d                	andi	a5,a5,7
    800056ba:	078e                	slli	a5,a5,0x3
    800056bc:	97ba                	add	a5,a5,a4
    800056be:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056c0:	20078713          	addi	a4,a5,512
    800056c4:	0712                	slli	a4,a4,0x4
    800056c6:	974a                	add	a4,a4,s2
    800056c8:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056cc:	e731                	bnez	a4,80005718 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056ce:	20078793          	addi	a5,a5,512
    800056d2:	0792                	slli	a5,a5,0x4
    800056d4:	97ca                	add	a5,a5,s2
    800056d6:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056d8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056dc:	ffffc097          	auipc	ra,0xffffc
    800056e0:	004080e7          	jalr	4(ra) # 800016e0 <wakeup>

    disk.used_idx += 1;
    800056e4:	0204d783          	lhu	a5,32(s1)
    800056e8:	2785                	addiw	a5,a5,1
    800056ea:	17c2                	slli	a5,a5,0x30
    800056ec:	93c1                	srli	a5,a5,0x30
    800056ee:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056f2:	6898                	ld	a4,16(s1)
    800056f4:	00275703          	lhu	a4,2(a4)
    800056f8:	faf71be3          	bne	a4,a5,800056ae <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056fc:	00018517          	auipc	a0,0x18
    80005700:	a2c50513          	addi	a0,a0,-1492 # 8001d128 <disk+0x2128>
    80005704:	00001097          	auipc	ra,0x1
    80005708:	b30080e7          	jalr	-1232(ra) # 80006234 <release>
}
    8000570c:	60e2                	ld	ra,24(sp)
    8000570e:	6442                	ld	s0,16(sp)
    80005710:	64a2                	ld	s1,8(sp)
    80005712:	6902                	ld	s2,0(sp)
    80005714:	6105                	addi	sp,sp,32
    80005716:	8082                	ret
      panic("virtio_disk_intr status");
    80005718:	00003517          	auipc	a0,0x3
    8000571c:	02850513          	addi	a0,a0,40 # 80008740 <etext+0x740>
    80005720:	00000097          	auipc	ra,0x0
    80005724:	524080e7          	jalr	1316(ra) # 80005c44 <panic>

0000000080005728 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005728:	1141                	addi	sp,sp,-16
    8000572a:	e422                	sd	s0,8(sp)
    8000572c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000572e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005732:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005736:	0037979b          	slliw	a5,a5,0x3
    8000573a:	02004737          	lui	a4,0x2004
    8000573e:	97ba                	add	a5,a5,a4
    80005740:	0200c737          	lui	a4,0x200c
    80005744:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005748:	000f4637          	lui	a2,0xf4
    8000574c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005750:	95b2                	add	a1,a1,a2
    80005752:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005754:	00269713          	slli	a4,a3,0x2
    80005758:	9736                	add	a4,a4,a3
    8000575a:	00371693          	slli	a3,a4,0x3
    8000575e:	00019717          	auipc	a4,0x19
    80005762:	8a270713          	addi	a4,a4,-1886 # 8001e000 <timer_scratch>
    80005766:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005768:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000576a:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000576c:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005770:	00000797          	auipc	a5,0x0
    80005774:	9c078793          	addi	a5,a5,-1600 # 80005130 <timervec>
    80005778:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000577c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005780:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005784:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005788:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000578c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005790:	30479073          	csrw	mie,a5
}
    80005794:	6422                	ld	s0,8(sp)
    80005796:	0141                	addi	sp,sp,16
    80005798:	8082                	ret

000000008000579a <start>:
{
    8000579a:	1141                	addi	sp,sp,-16
    8000579c:	e406                	sd	ra,8(sp)
    8000579e:	e022                	sd	s0,0(sp)
    800057a0:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057a2:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057a6:	7779                	lui	a4,0xffffe
    800057a8:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057ac:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057ae:	6705                	lui	a4,0x1
    800057b0:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057b4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057b6:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057ba:	ffffb797          	auipc	a5,0xffffb
    800057be:	bae78793          	addi	a5,a5,-1106 # 80000368 <main>
    800057c2:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057c6:	4781                	li	a5,0
    800057c8:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057cc:	67c1                	lui	a5,0x10
    800057ce:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057d0:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057d4:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057d8:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057dc:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057e0:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057e4:	57fd                	li	a5,-1
    800057e6:	83a9                	srli	a5,a5,0xa
    800057e8:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057ec:	47bd                	li	a5,15
    800057ee:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057f2:	00000097          	auipc	ra,0x0
    800057f6:	f36080e7          	jalr	-202(ra) # 80005728 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057fa:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057fe:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005800:	823e                	mv	tp,a5
  asm volatile("mret");
    80005802:	30200073          	mret
}
    80005806:	60a2                	ld	ra,8(sp)
    80005808:	6402                	ld	s0,0(sp)
    8000580a:	0141                	addi	sp,sp,16
    8000580c:	8082                	ret

000000008000580e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000580e:	715d                	addi	sp,sp,-80
    80005810:	e486                	sd	ra,72(sp)
    80005812:	e0a2                	sd	s0,64(sp)
    80005814:	fc26                	sd	s1,56(sp)
    80005816:	f84a                	sd	s2,48(sp)
    80005818:	f44e                	sd	s3,40(sp)
    8000581a:	f052                	sd	s4,32(sp)
    8000581c:	ec56                	sd	s5,24(sp)
    8000581e:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005820:	04c05663          	blez	a2,8000586c <consolewrite+0x5e>
    80005824:	8a2a                	mv	s4,a0
    80005826:	84ae                	mv	s1,a1
    80005828:	89b2                	mv	s3,a2
    8000582a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000582c:	5afd                	li	s5,-1
    8000582e:	4685                	li	a3,1
    80005830:	8626                	mv	a2,s1
    80005832:	85d2                	mv	a1,s4
    80005834:	fbf40513          	addi	a0,s0,-65
    80005838:	ffffc097          	auipc	ra,0xffffc
    8000583c:	116080e7          	jalr	278(ra) # 8000194e <either_copyin>
    80005840:	01550c63          	beq	a0,s5,80005858 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005844:	fbf44503          	lbu	a0,-65(s0)
    80005848:	00000097          	auipc	ra,0x0
    8000584c:	77a080e7          	jalr	1914(ra) # 80005fc2 <uartputc>
  for(i = 0; i < n; i++){
    80005850:	2905                	addiw	s2,s2,1
    80005852:	0485                	addi	s1,s1,1
    80005854:	fd299de3          	bne	s3,s2,8000582e <consolewrite+0x20>
  }

  return i;
}
    80005858:	854a                	mv	a0,s2
    8000585a:	60a6                	ld	ra,72(sp)
    8000585c:	6406                	ld	s0,64(sp)
    8000585e:	74e2                	ld	s1,56(sp)
    80005860:	7942                	ld	s2,48(sp)
    80005862:	79a2                	ld	s3,40(sp)
    80005864:	7a02                	ld	s4,32(sp)
    80005866:	6ae2                	ld	s5,24(sp)
    80005868:	6161                	addi	sp,sp,80
    8000586a:	8082                	ret
  for(i = 0; i < n; i++){
    8000586c:	4901                	li	s2,0
    8000586e:	b7ed                	j	80005858 <consolewrite+0x4a>

0000000080005870 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005870:	7159                	addi	sp,sp,-112
    80005872:	f486                	sd	ra,104(sp)
    80005874:	f0a2                	sd	s0,96(sp)
    80005876:	eca6                	sd	s1,88(sp)
    80005878:	e8ca                	sd	s2,80(sp)
    8000587a:	e4ce                	sd	s3,72(sp)
    8000587c:	e0d2                	sd	s4,64(sp)
    8000587e:	fc56                	sd	s5,56(sp)
    80005880:	f85a                	sd	s6,48(sp)
    80005882:	f45e                	sd	s7,40(sp)
    80005884:	f062                	sd	s8,32(sp)
    80005886:	ec66                	sd	s9,24(sp)
    80005888:	e86a                	sd	s10,16(sp)
    8000588a:	1880                	addi	s0,sp,112
    8000588c:	8aaa                	mv	s5,a0
    8000588e:	8a2e                	mv	s4,a1
    80005890:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005892:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005896:	00021517          	auipc	a0,0x21
    8000589a:	8aa50513          	addi	a0,a0,-1878 # 80026140 <cons>
    8000589e:	00001097          	auipc	ra,0x1
    800058a2:	8e2080e7          	jalr	-1822(ra) # 80006180 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058a6:	00021497          	auipc	s1,0x21
    800058aa:	89a48493          	addi	s1,s1,-1894 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058ae:	00021917          	auipc	s2,0x21
    800058b2:	92a90913          	addi	s2,s2,-1750 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058b6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058b8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058ba:	4ca9                	li	s9,10
  while(n > 0){
    800058bc:	07305863          	blez	s3,8000592c <consoleread+0xbc>
    while(cons.r == cons.w){
    800058c0:	0984a783          	lw	a5,152(s1)
    800058c4:	09c4a703          	lw	a4,156(s1)
    800058c8:	02f71463          	bne	a4,a5,800058f0 <consoleread+0x80>
      if(myproc()->killed){
    800058cc:	ffffb097          	auipc	ra,0xffffb
    800058d0:	5c0080e7          	jalr	1472(ra) # 80000e8c <myproc>
    800058d4:	551c                	lw	a5,40(a0)
    800058d6:	e7b5                	bnez	a5,80005942 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800058d8:	85a6                	mv	a1,s1
    800058da:	854a                	mv	a0,s2
    800058dc:	ffffc097          	auipc	ra,0xffffc
    800058e0:	c78080e7          	jalr	-904(ra) # 80001554 <sleep>
    while(cons.r == cons.w){
    800058e4:	0984a783          	lw	a5,152(s1)
    800058e8:	09c4a703          	lw	a4,156(s1)
    800058ec:	fef700e3          	beq	a4,a5,800058cc <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058f0:	0017871b          	addiw	a4,a5,1
    800058f4:	08e4ac23          	sw	a4,152(s1)
    800058f8:	07f7f713          	andi	a4,a5,127
    800058fc:	9726                	add	a4,a4,s1
    800058fe:	01874703          	lbu	a4,24(a4)
    80005902:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005906:	077d0563          	beq	s10,s7,80005970 <consoleread+0x100>
    cbuf = c;
    8000590a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000590e:	4685                	li	a3,1
    80005910:	f9f40613          	addi	a2,s0,-97
    80005914:	85d2                	mv	a1,s4
    80005916:	8556                	mv	a0,s5
    80005918:	ffffc097          	auipc	ra,0xffffc
    8000591c:	fe0080e7          	jalr	-32(ra) # 800018f8 <either_copyout>
    80005920:	01850663          	beq	a0,s8,8000592c <consoleread+0xbc>
    dst++;
    80005924:	0a05                	addi	s4,s4,1
    --n;
    80005926:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005928:	f99d1ae3          	bne	s10,s9,800058bc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000592c:	00021517          	auipc	a0,0x21
    80005930:	81450513          	addi	a0,a0,-2028 # 80026140 <cons>
    80005934:	00001097          	auipc	ra,0x1
    80005938:	900080e7          	jalr	-1792(ra) # 80006234 <release>

  return target - n;
    8000593c:	413b053b          	subw	a0,s6,s3
    80005940:	a811                	j	80005954 <consoleread+0xe4>
        release(&cons.lock);
    80005942:	00020517          	auipc	a0,0x20
    80005946:	7fe50513          	addi	a0,a0,2046 # 80026140 <cons>
    8000594a:	00001097          	auipc	ra,0x1
    8000594e:	8ea080e7          	jalr	-1814(ra) # 80006234 <release>
        return -1;
    80005952:	557d                	li	a0,-1
}
    80005954:	70a6                	ld	ra,104(sp)
    80005956:	7406                	ld	s0,96(sp)
    80005958:	64e6                	ld	s1,88(sp)
    8000595a:	6946                	ld	s2,80(sp)
    8000595c:	69a6                	ld	s3,72(sp)
    8000595e:	6a06                	ld	s4,64(sp)
    80005960:	7ae2                	ld	s5,56(sp)
    80005962:	7b42                	ld	s6,48(sp)
    80005964:	7ba2                	ld	s7,40(sp)
    80005966:	7c02                	ld	s8,32(sp)
    80005968:	6ce2                	ld	s9,24(sp)
    8000596a:	6d42                	ld	s10,16(sp)
    8000596c:	6165                	addi	sp,sp,112
    8000596e:	8082                	ret
      if(n < target){
    80005970:	0009871b          	sext.w	a4,s3
    80005974:	fb677ce3          	bgeu	a4,s6,8000592c <consoleread+0xbc>
        cons.r--;
    80005978:	00021717          	auipc	a4,0x21
    8000597c:	86f72023          	sw	a5,-1952(a4) # 800261d8 <cons+0x98>
    80005980:	b775                	j	8000592c <consoleread+0xbc>

0000000080005982 <consputc>:
{
    80005982:	1141                	addi	sp,sp,-16
    80005984:	e406                	sd	ra,8(sp)
    80005986:	e022                	sd	s0,0(sp)
    80005988:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000598a:	10000793          	li	a5,256
    8000598e:	00f50a63          	beq	a0,a5,800059a2 <consputc+0x20>
    uartputc_sync(c);
    80005992:	00000097          	auipc	ra,0x0
    80005996:	55e080e7          	jalr	1374(ra) # 80005ef0 <uartputc_sync>
}
    8000599a:	60a2                	ld	ra,8(sp)
    8000599c:	6402                	ld	s0,0(sp)
    8000599e:	0141                	addi	sp,sp,16
    800059a0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059a2:	4521                	li	a0,8
    800059a4:	00000097          	auipc	ra,0x0
    800059a8:	54c080e7          	jalr	1356(ra) # 80005ef0 <uartputc_sync>
    800059ac:	02000513          	li	a0,32
    800059b0:	00000097          	auipc	ra,0x0
    800059b4:	540080e7          	jalr	1344(ra) # 80005ef0 <uartputc_sync>
    800059b8:	4521                	li	a0,8
    800059ba:	00000097          	auipc	ra,0x0
    800059be:	536080e7          	jalr	1334(ra) # 80005ef0 <uartputc_sync>
    800059c2:	bfe1                	j	8000599a <consputc+0x18>

00000000800059c4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059c4:	1101                	addi	sp,sp,-32
    800059c6:	ec06                	sd	ra,24(sp)
    800059c8:	e822                	sd	s0,16(sp)
    800059ca:	e426                	sd	s1,8(sp)
    800059cc:	e04a                	sd	s2,0(sp)
    800059ce:	1000                	addi	s0,sp,32
    800059d0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059d2:	00020517          	auipc	a0,0x20
    800059d6:	76e50513          	addi	a0,a0,1902 # 80026140 <cons>
    800059da:	00000097          	auipc	ra,0x0
    800059de:	7a6080e7          	jalr	1958(ra) # 80006180 <acquire>

  switch(c){
    800059e2:	47d5                	li	a5,21
    800059e4:	0af48663          	beq	s1,a5,80005a90 <consoleintr+0xcc>
    800059e8:	0297ca63          	blt	a5,s1,80005a1c <consoleintr+0x58>
    800059ec:	47a1                	li	a5,8
    800059ee:	0ef48763          	beq	s1,a5,80005adc <consoleintr+0x118>
    800059f2:	47c1                	li	a5,16
    800059f4:	10f49a63          	bne	s1,a5,80005b08 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059f8:	ffffc097          	auipc	ra,0xffffc
    800059fc:	fac080e7          	jalr	-84(ra) # 800019a4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a00:	00020517          	auipc	a0,0x20
    80005a04:	74050513          	addi	a0,a0,1856 # 80026140 <cons>
    80005a08:	00001097          	auipc	ra,0x1
    80005a0c:	82c080e7          	jalr	-2004(ra) # 80006234 <release>
}
    80005a10:	60e2                	ld	ra,24(sp)
    80005a12:	6442                	ld	s0,16(sp)
    80005a14:	64a2                	ld	s1,8(sp)
    80005a16:	6902                	ld	s2,0(sp)
    80005a18:	6105                	addi	sp,sp,32
    80005a1a:	8082                	ret
  switch(c){
    80005a1c:	07f00793          	li	a5,127
    80005a20:	0af48e63          	beq	s1,a5,80005adc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a24:	00020717          	auipc	a4,0x20
    80005a28:	71c70713          	addi	a4,a4,1820 # 80026140 <cons>
    80005a2c:	0a072783          	lw	a5,160(a4)
    80005a30:	09872703          	lw	a4,152(a4)
    80005a34:	9f99                	subw	a5,a5,a4
    80005a36:	07f00713          	li	a4,127
    80005a3a:	fcf763e3          	bltu	a4,a5,80005a00 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a3e:	47b5                	li	a5,13
    80005a40:	0cf48763          	beq	s1,a5,80005b0e <consoleintr+0x14a>
      consputc(c);
    80005a44:	8526                	mv	a0,s1
    80005a46:	00000097          	auipc	ra,0x0
    80005a4a:	f3c080e7          	jalr	-196(ra) # 80005982 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a4e:	00020797          	auipc	a5,0x20
    80005a52:	6f278793          	addi	a5,a5,1778 # 80026140 <cons>
    80005a56:	0a07a703          	lw	a4,160(a5)
    80005a5a:	0017069b          	addiw	a3,a4,1
    80005a5e:	0006861b          	sext.w	a2,a3
    80005a62:	0ad7a023          	sw	a3,160(a5)
    80005a66:	07f77713          	andi	a4,a4,127
    80005a6a:	97ba                	add	a5,a5,a4
    80005a6c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a70:	47a9                	li	a5,10
    80005a72:	0cf48563          	beq	s1,a5,80005b3c <consoleintr+0x178>
    80005a76:	4791                	li	a5,4
    80005a78:	0cf48263          	beq	s1,a5,80005b3c <consoleintr+0x178>
    80005a7c:	00020797          	auipc	a5,0x20
    80005a80:	75c7a783          	lw	a5,1884(a5) # 800261d8 <cons+0x98>
    80005a84:	0807879b          	addiw	a5,a5,128
    80005a88:	f6f61ce3          	bne	a2,a5,80005a00 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a8c:	863e                	mv	a2,a5
    80005a8e:	a07d                	j	80005b3c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a90:	00020717          	auipc	a4,0x20
    80005a94:	6b070713          	addi	a4,a4,1712 # 80026140 <cons>
    80005a98:	0a072783          	lw	a5,160(a4)
    80005a9c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005aa0:	00020497          	auipc	s1,0x20
    80005aa4:	6a048493          	addi	s1,s1,1696 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005aa8:	4929                	li	s2,10
    80005aaa:	f4f70be3          	beq	a4,a5,80005a00 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005aae:	37fd                	addiw	a5,a5,-1
    80005ab0:	07f7f713          	andi	a4,a5,127
    80005ab4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ab6:	01874703          	lbu	a4,24(a4)
    80005aba:	f52703e3          	beq	a4,s2,80005a00 <consoleintr+0x3c>
      cons.e--;
    80005abe:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ac2:	10000513          	li	a0,256
    80005ac6:	00000097          	auipc	ra,0x0
    80005aca:	ebc080e7          	jalr	-324(ra) # 80005982 <consputc>
    while(cons.e != cons.w &&
    80005ace:	0a04a783          	lw	a5,160(s1)
    80005ad2:	09c4a703          	lw	a4,156(s1)
    80005ad6:	fcf71ce3          	bne	a4,a5,80005aae <consoleintr+0xea>
    80005ada:	b71d                	j	80005a00 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005adc:	00020717          	auipc	a4,0x20
    80005ae0:	66470713          	addi	a4,a4,1636 # 80026140 <cons>
    80005ae4:	0a072783          	lw	a5,160(a4)
    80005ae8:	09c72703          	lw	a4,156(a4)
    80005aec:	f0f70ae3          	beq	a4,a5,80005a00 <consoleintr+0x3c>
      cons.e--;
    80005af0:	37fd                	addiw	a5,a5,-1
    80005af2:	00020717          	auipc	a4,0x20
    80005af6:	6ef72723          	sw	a5,1774(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005afa:	10000513          	li	a0,256
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	e84080e7          	jalr	-380(ra) # 80005982 <consputc>
    80005b06:	bded                	j	80005a00 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b08:	ee048ce3          	beqz	s1,80005a00 <consoleintr+0x3c>
    80005b0c:	bf21                	j	80005a24 <consoleintr+0x60>
      consputc(c);
    80005b0e:	4529                	li	a0,10
    80005b10:	00000097          	auipc	ra,0x0
    80005b14:	e72080e7          	jalr	-398(ra) # 80005982 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b18:	00020797          	auipc	a5,0x20
    80005b1c:	62878793          	addi	a5,a5,1576 # 80026140 <cons>
    80005b20:	0a07a703          	lw	a4,160(a5)
    80005b24:	0017069b          	addiw	a3,a4,1
    80005b28:	0006861b          	sext.w	a2,a3
    80005b2c:	0ad7a023          	sw	a3,160(a5)
    80005b30:	07f77713          	andi	a4,a4,127
    80005b34:	97ba                	add	a5,a5,a4
    80005b36:	4729                	li	a4,10
    80005b38:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b3c:	00020797          	auipc	a5,0x20
    80005b40:	6ac7a023          	sw	a2,1696(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b44:	00020517          	auipc	a0,0x20
    80005b48:	69450513          	addi	a0,a0,1684 # 800261d8 <cons+0x98>
    80005b4c:	ffffc097          	auipc	ra,0xffffc
    80005b50:	b94080e7          	jalr	-1132(ra) # 800016e0 <wakeup>
    80005b54:	b575                	j	80005a00 <consoleintr+0x3c>

0000000080005b56 <consoleinit>:

void
consoleinit(void)
{
    80005b56:	1141                	addi	sp,sp,-16
    80005b58:	e406                	sd	ra,8(sp)
    80005b5a:	e022                	sd	s0,0(sp)
    80005b5c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b5e:	00003597          	auipc	a1,0x3
    80005b62:	bfa58593          	addi	a1,a1,-1030 # 80008758 <etext+0x758>
    80005b66:	00020517          	auipc	a0,0x20
    80005b6a:	5da50513          	addi	a0,a0,1498 # 80026140 <cons>
    80005b6e:	00000097          	auipc	ra,0x0
    80005b72:	582080e7          	jalr	1410(ra) # 800060f0 <initlock>

  uartinit();
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	32a080e7          	jalr	810(ra) # 80005ea0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b7e:	00013797          	auipc	a5,0x13
    80005b82:	74a78793          	addi	a5,a5,1866 # 800192c8 <devsw>
    80005b86:	00000717          	auipc	a4,0x0
    80005b8a:	cea70713          	addi	a4,a4,-790 # 80005870 <consoleread>
    80005b8e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b90:	00000717          	auipc	a4,0x0
    80005b94:	c7e70713          	addi	a4,a4,-898 # 8000580e <consolewrite>
    80005b98:	ef98                	sd	a4,24(a5)
}
    80005b9a:	60a2                	ld	ra,8(sp)
    80005b9c:	6402                	ld	s0,0(sp)
    80005b9e:	0141                	addi	sp,sp,16
    80005ba0:	8082                	ret

0000000080005ba2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ba2:	7179                	addi	sp,sp,-48
    80005ba4:	f406                	sd	ra,40(sp)
    80005ba6:	f022                	sd	s0,32(sp)
    80005ba8:	ec26                	sd	s1,24(sp)
    80005baa:	e84a                	sd	s2,16(sp)
    80005bac:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bae:	c219                	beqz	a2,80005bb4 <printint+0x12>
    80005bb0:	08054663          	bltz	a0,80005c3c <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bb4:	2501                	sext.w	a0,a0
    80005bb6:	4881                	li	a7,0
    80005bb8:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bbc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bbe:	2581                	sext.w	a1,a1
    80005bc0:	00003617          	auipc	a2,0x3
    80005bc4:	d0860613          	addi	a2,a2,-760 # 800088c8 <digits>
    80005bc8:	883a                	mv	a6,a4
    80005bca:	2705                	addiw	a4,a4,1
    80005bcc:	02b577bb          	remuw	a5,a0,a1
    80005bd0:	1782                	slli	a5,a5,0x20
    80005bd2:	9381                	srli	a5,a5,0x20
    80005bd4:	97b2                	add	a5,a5,a2
    80005bd6:	0007c783          	lbu	a5,0(a5)
    80005bda:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bde:	0005079b          	sext.w	a5,a0
    80005be2:	02b5553b          	divuw	a0,a0,a1
    80005be6:	0685                	addi	a3,a3,1
    80005be8:	feb7f0e3          	bgeu	a5,a1,80005bc8 <printint+0x26>

  if(sign)
    80005bec:	00088b63          	beqz	a7,80005c02 <printint+0x60>
    buf[i++] = '-';
    80005bf0:	fe040793          	addi	a5,s0,-32
    80005bf4:	973e                	add	a4,a4,a5
    80005bf6:	02d00793          	li	a5,45
    80005bfa:	fef70823          	sb	a5,-16(a4)
    80005bfe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c02:	02e05763          	blez	a4,80005c30 <printint+0x8e>
    80005c06:	fd040793          	addi	a5,s0,-48
    80005c0a:	00e784b3          	add	s1,a5,a4
    80005c0e:	fff78913          	addi	s2,a5,-1
    80005c12:	993a                	add	s2,s2,a4
    80005c14:	377d                	addiw	a4,a4,-1
    80005c16:	1702                	slli	a4,a4,0x20
    80005c18:	9301                	srli	a4,a4,0x20
    80005c1a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c1e:	fff4c503          	lbu	a0,-1(s1)
    80005c22:	00000097          	auipc	ra,0x0
    80005c26:	d60080e7          	jalr	-672(ra) # 80005982 <consputc>
  while(--i >= 0)
    80005c2a:	14fd                	addi	s1,s1,-1
    80005c2c:	ff2499e3          	bne	s1,s2,80005c1e <printint+0x7c>
}
    80005c30:	70a2                	ld	ra,40(sp)
    80005c32:	7402                	ld	s0,32(sp)
    80005c34:	64e2                	ld	s1,24(sp)
    80005c36:	6942                	ld	s2,16(sp)
    80005c38:	6145                	addi	sp,sp,48
    80005c3a:	8082                	ret
    x = -xx;
    80005c3c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c40:	4885                	li	a7,1
    x = -xx;
    80005c42:	bf9d                	j	80005bb8 <printint+0x16>

0000000080005c44 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c44:	1101                	addi	sp,sp,-32
    80005c46:	ec06                	sd	ra,24(sp)
    80005c48:	e822                	sd	s0,16(sp)
    80005c4a:	e426                	sd	s1,8(sp)
    80005c4c:	1000                	addi	s0,sp,32
    80005c4e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c50:	00020797          	auipc	a5,0x20
    80005c54:	5a07a823          	sw	zero,1456(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c58:	00003517          	auipc	a0,0x3
    80005c5c:	b0850513          	addi	a0,a0,-1272 # 80008760 <etext+0x760>
    80005c60:	00000097          	auipc	ra,0x0
    80005c64:	02e080e7          	jalr	46(ra) # 80005c8e <printf>
  printf(s);
    80005c68:	8526                	mv	a0,s1
    80005c6a:	00000097          	auipc	ra,0x0
    80005c6e:	024080e7          	jalr	36(ra) # 80005c8e <printf>
  printf("\n");
    80005c72:	00002517          	auipc	a0,0x2
    80005c76:	3d650513          	addi	a0,a0,982 # 80008048 <etext+0x48>
    80005c7a:	00000097          	auipc	ra,0x0
    80005c7e:	014080e7          	jalr	20(ra) # 80005c8e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c82:	4785                	li	a5,1
    80005c84:	00003717          	auipc	a4,0x3
    80005c88:	38f72c23          	sw	a5,920(a4) # 8000901c <panicked>
  for(;;)
    80005c8c:	a001                	j	80005c8c <panic+0x48>

0000000080005c8e <printf>:
{
    80005c8e:	7131                	addi	sp,sp,-192
    80005c90:	fc86                	sd	ra,120(sp)
    80005c92:	f8a2                	sd	s0,112(sp)
    80005c94:	f4a6                	sd	s1,104(sp)
    80005c96:	f0ca                	sd	s2,96(sp)
    80005c98:	ecce                	sd	s3,88(sp)
    80005c9a:	e8d2                	sd	s4,80(sp)
    80005c9c:	e4d6                	sd	s5,72(sp)
    80005c9e:	e0da                	sd	s6,64(sp)
    80005ca0:	fc5e                	sd	s7,56(sp)
    80005ca2:	f862                	sd	s8,48(sp)
    80005ca4:	f466                	sd	s9,40(sp)
    80005ca6:	f06a                	sd	s10,32(sp)
    80005ca8:	ec6e                	sd	s11,24(sp)
    80005caa:	0100                	addi	s0,sp,128
    80005cac:	8a2a                	mv	s4,a0
    80005cae:	e40c                	sd	a1,8(s0)
    80005cb0:	e810                	sd	a2,16(s0)
    80005cb2:	ec14                	sd	a3,24(s0)
    80005cb4:	f018                	sd	a4,32(s0)
    80005cb6:	f41c                	sd	a5,40(s0)
    80005cb8:	03043823          	sd	a6,48(s0)
    80005cbc:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cc0:	00020d97          	auipc	s11,0x20
    80005cc4:	540dad83          	lw	s11,1344(s11) # 80026200 <pr+0x18>
  if(locking)
    80005cc8:	020d9b63          	bnez	s11,80005cfe <printf+0x70>
  if (fmt == 0)
    80005ccc:	040a0263          	beqz	s4,80005d10 <printf+0x82>
  va_start(ap, fmt);
    80005cd0:	00840793          	addi	a5,s0,8
    80005cd4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cd8:	000a4503          	lbu	a0,0(s4)
    80005cdc:	14050f63          	beqz	a0,80005e3a <printf+0x1ac>
    80005ce0:	4981                	li	s3,0
    if(c != '%'){
    80005ce2:	02500a93          	li	s5,37
    switch(c){
    80005ce6:	07000b93          	li	s7,112
  consputc('x');
    80005cea:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cec:	00003b17          	auipc	s6,0x3
    80005cf0:	bdcb0b13          	addi	s6,s6,-1060 # 800088c8 <digits>
    switch(c){
    80005cf4:	07300c93          	li	s9,115
    80005cf8:	06400c13          	li	s8,100
    80005cfc:	a82d                	j	80005d36 <printf+0xa8>
    acquire(&pr.lock);
    80005cfe:	00020517          	auipc	a0,0x20
    80005d02:	4ea50513          	addi	a0,a0,1258 # 800261e8 <pr>
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	47a080e7          	jalr	1146(ra) # 80006180 <acquire>
    80005d0e:	bf7d                	j	80005ccc <printf+0x3e>
    panic("null fmt");
    80005d10:	00003517          	auipc	a0,0x3
    80005d14:	a6050513          	addi	a0,a0,-1440 # 80008770 <etext+0x770>
    80005d18:	00000097          	auipc	ra,0x0
    80005d1c:	f2c080e7          	jalr	-212(ra) # 80005c44 <panic>
      consputc(c);
    80005d20:	00000097          	auipc	ra,0x0
    80005d24:	c62080e7          	jalr	-926(ra) # 80005982 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d28:	2985                	addiw	s3,s3,1
    80005d2a:	013a07b3          	add	a5,s4,s3
    80005d2e:	0007c503          	lbu	a0,0(a5)
    80005d32:	10050463          	beqz	a0,80005e3a <printf+0x1ac>
    if(c != '%'){
    80005d36:	ff5515e3          	bne	a0,s5,80005d20 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d3a:	2985                	addiw	s3,s3,1
    80005d3c:	013a07b3          	add	a5,s4,s3
    80005d40:	0007c783          	lbu	a5,0(a5)
    80005d44:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d48:	cbed                	beqz	a5,80005e3a <printf+0x1ac>
    switch(c){
    80005d4a:	05778a63          	beq	a5,s7,80005d9e <printf+0x110>
    80005d4e:	02fbf663          	bgeu	s7,a5,80005d7a <printf+0xec>
    80005d52:	09978863          	beq	a5,s9,80005de2 <printf+0x154>
    80005d56:	07800713          	li	a4,120
    80005d5a:	0ce79563          	bne	a5,a4,80005e24 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d5e:	f8843783          	ld	a5,-120(s0)
    80005d62:	00878713          	addi	a4,a5,8
    80005d66:	f8e43423          	sd	a4,-120(s0)
    80005d6a:	4605                	li	a2,1
    80005d6c:	85ea                	mv	a1,s10
    80005d6e:	4388                	lw	a0,0(a5)
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	e32080e7          	jalr	-462(ra) # 80005ba2 <printint>
      break;
    80005d78:	bf45                	j	80005d28 <printf+0x9a>
    switch(c){
    80005d7a:	09578f63          	beq	a5,s5,80005e18 <printf+0x18a>
    80005d7e:	0b879363          	bne	a5,s8,80005e24 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d82:	f8843783          	ld	a5,-120(s0)
    80005d86:	00878713          	addi	a4,a5,8
    80005d8a:	f8e43423          	sd	a4,-120(s0)
    80005d8e:	4605                	li	a2,1
    80005d90:	45a9                	li	a1,10
    80005d92:	4388                	lw	a0,0(a5)
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	e0e080e7          	jalr	-498(ra) # 80005ba2 <printint>
      break;
    80005d9c:	b771                	j	80005d28 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d9e:	f8843783          	ld	a5,-120(s0)
    80005da2:	00878713          	addi	a4,a5,8
    80005da6:	f8e43423          	sd	a4,-120(s0)
    80005daa:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005dae:	03000513          	li	a0,48
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	bd0080e7          	jalr	-1072(ra) # 80005982 <consputc>
  consputc('x');
    80005dba:	07800513          	li	a0,120
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	bc4080e7          	jalr	-1084(ra) # 80005982 <consputc>
    80005dc6:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dc8:	03c95793          	srli	a5,s2,0x3c
    80005dcc:	97da                	add	a5,a5,s6
    80005dce:	0007c503          	lbu	a0,0(a5)
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	bb0080e7          	jalr	-1104(ra) # 80005982 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dda:	0912                	slli	s2,s2,0x4
    80005ddc:	34fd                	addiw	s1,s1,-1
    80005dde:	f4ed                	bnez	s1,80005dc8 <printf+0x13a>
    80005de0:	b7a1                	j	80005d28 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005de2:	f8843783          	ld	a5,-120(s0)
    80005de6:	00878713          	addi	a4,a5,8
    80005dea:	f8e43423          	sd	a4,-120(s0)
    80005dee:	6384                	ld	s1,0(a5)
    80005df0:	cc89                	beqz	s1,80005e0a <printf+0x17c>
      for(; *s; s++)
    80005df2:	0004c503          	lbu	a0,0(s1)
    80005df6:	d90d                	beqz	a0,80005d28 <printf+0x9a>
        consputc(*s);
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	b8a080e7          	jalr	-1142(ra) # 80005982 <consputc>
      for(; *s; s++)
    80005e00:	0485                	addi	s1,s1,1
    80005e02:	0004c503          	lbu	a0,0(s1)
    80005e06:	f96d                	bnez	a0,80005df8 <printf+0x16a>
    80005e08:	b705                	j	80005d28 <printf+0x9a>
        s = "(null)";
    80005e0a:	00003497          	auipc	s1,0x3
    80005e0e:	95e48493          	addi	s1,s1,-1698 # 80008768 <etext+0x768>
      for(; *s; s++)
    80005e12:	02800513          	li	a0,40
    80005e16:	b7cd                	j	80005df8 <printf+0x16a>
      consputc('%');
    80005e18:	8556                	mv	a0,s5
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	b68080e7          	jalr	-1176(ra) # 80005982 <consputc>
      break;
    80005e22:	b719                	j	80005d28 <printf+0x9a>
      consputc('%');
    80005e24:	8556                	mv	a0,s5
    80005e26:	00000097          	auipc	ra,0x0
    80005e2a:	b5c080e7          	jalr	-1188(ra) # 80005982 <consputc>
      consputc(c);
    80005e2e:	8526                	mv	a0,s1
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	b52080e7          	jalr	-1198(ra) # 80005982 <consputc>
      break;
    80005e38:	bdc5                	j	80005d28 <printf+0x9a>
  if(locking)
    80005e3a:	020d9163          	bnez	s11,80005e5c <printf+0x1ce>
}
    80005e3e:	70e6                	ld	ra,120(sp)
    80005e40:	7446                	ld	s0,112(sp)
    80005e42:	74a6                	ld	s1,104(sp)
    80005e44:	7906                	ld	s2,96(sp)
    80005e46:	69e6                	ld	s3,88(sp)
    80005e48:	6a46                	ld	s4,80(sp)
    80005e4a:	6aa6                	ld	s5,72(sp)
    80005e4c:	6b06                	ld	s6,64(sp)
    80005e4e:	7be2                	ld	s7,56(sp)
    80005e50:	7c42                	ld	s8,48(sp)
    80005e52:	7ca2                	ld	s9,40(sp)
    80005e54:	7d02                	ld	s10,32(sp)
    80005e56:	6de2                	ld	s11,24(sp)
    80005e58:	6129                	addi	sp,sp,192
    80005e5a:	8082                	ret
    release(&pr.lock);
    80005e5c:	00020517          	auipc	a0,0x20
    80005e60:	38c50513          	addi	a0,a0,908 # 800261e8 <pr>
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	3d0080e7          	jalr	976(ra) # 80006234 <release>
}
    80005e6c:	bfc9                	j	80005e3e <printf+0x1b0>

0000000080005e6e <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e6e:	1101                	addi	sp,sp,-32
    80005e70:	ec06                	sd	ra,24(sp)
    80005e72:	e822                	sd	s0,16(sp)
    80005e74:	e426                	sd	s1,8(sp)
    80005e76:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e78:	00020497          	auipc	s1,0x20
    80005e7c:	37048493          	addi	s1,s1,880 # 800261e8 <pr>
    80005e80:	00003597          	auipc	a1,0x3
    80005e84:	90058593          	addi	a1,a1,-1792 # 80008780 <etext+0x780>
    80005e88:	8526                	mv	a0,s1
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	266080e7          	jalr	614(ra) # 800060f0 <initlock>
  pr.locking = 1;
    80005e92:	4785                	li	a5,1
    80005e94:	cc9c                	sw	a5,24(s1)
}
    80005e96:	60e2                	ld	ra,24(sp)
    80005e98:	6442                	ld	s0,16(sp)
    80005e9a:	64a2                	ld	s1,8(sp)
    80005e9c:	6105                	addi	sp,sp,32
    80005e9e:	8082                	ret

0000000080005ea0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ea0:	1141                	addi	sp,sp,-16
    80005ea2:	e406                	sd	ra,8(sp)
    80005ea4:	e022                	sd	s0,0(sp)
    80005ea6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ea8:	100007b7          	lui	a5,0x10000
    80005eac:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005eb0:	f8000713          	li	a4,-128
    80005eb4:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005eb8:	470d                	li	a4,3
    80005eba:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ebe:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ec2:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ec6:	469d                	li	a3,7
    80005ec8:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ecc:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ed0:	00003597          	auipc	a1,0x3
    80005ed4:	8b858593          	addi	a1,a1,-1864 # 80008788 <etext+0x788>
    80005ed8:	00020517          	auipc	a0,0x20
    80005edc:	33050513          	addi	a0,a0,816 # 80026208 <uart_tx_lock>
    80005ee0:	00000097          	auipc	ra,0x0
    80005ee4:	210080e7          	jalr	528(ra) # 800060f0 <initlock>
}
    80005ee8:	60a2                	ld	ra,8(sp)
    80005eea:	6402                	ld	s0,0(sp)
    80005eec:	0141                	addi	sp,sp,16
    80005eee:	8082                	ret

0000000080005ef0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ef0:	1101                	addi	sp,sp,-32
    80005ef2:	ec06                	sd	ra,24(sp)
    80005ef4:	e822                	sd	s0,16(sp)
    80005ef6:	e426                	sd	s1,8(sp)
    80005ef8:	1000                	addi	s0,sp,32
    80005efa:	84aa                	mv	s1,a0
  push_off();
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	238080e7          	jalr	568(ra) # 80006134 <push_off>

  if(panicked){
    80005f04:	00003797          	auipc	a5,0x3
    80005f08:	1187a783          	lw	a5,280(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f0c:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f10:	c391                	beqz	a5,80005f14 <uartputc_sync+0x24>
    for(;;)
    80005f12:	a001                	j	80005f12 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f14:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f18:	0207f793          	andi	a5,a5,32
    80005f1c:	dfe5                	beqz	a5,80005f14 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f1e:	0ff4f513          	zext.b	a0,s1
    80005f22:	100007b7          	lui	a5,0x10000
    80005f26:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	2aa080e7          	jalr	682(ra) # 800061d4 <pop_off>
}
    80005f32:	60e2                	ld	ra,24(sp)
    80005f34:	6442                	ld	s0,16(sp)
    80005f36:	64a2                	ld	s1,8(sp)
    80005f38:	6105                	addi	sp,sp,32
    80005f3a:	8082                	ret

0000000080005f3c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f3c:	00003797          	auipc	a5,0x3
    80005f40:	0e47b783          	ld	a5,228(a5) # 80009020 <uart_tx_r>
    80005f44:	00003717          	auipc	a4,0x3
    80005f48:	0e473703          	ld	a4,228(a4) # 80009028 <uart_tx_w>
    80005f4c:	06f70a63          	beq	a4,a5,80005fc0 <uartstart+0x84>
{
    80005f50:	7139                	addi	sp,sp,-64
    80005f52:	fc06                	sd	ra,56(sp)
    80005f54:	f822                	sd	s0,48(sp)
    80005f56:	f426                	sd	s1,40(sp)
    80005f58:	f04a                	sd	s2,32(sp)
    80005f5a:	ec4e                	sd	s3,24(sp)
    80005f5c:	e852                	sd	s4,16(sp)
    80005f5e:	e456                	sd	s5,8(sp)
    80005f60:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f62:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f66:	00020a17          	auipc	s4,0x20
    80005f6a:	2a2a0a13          	addi	s4,s4,674 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f6e:	00003497          	auipc	s1,0x3
    80005f72:	0b248493          	addi	s1,s1,178 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f76:	00003997          	auipc	s3,0x3
    80005f7a:	0b298993          	addi	s3,s3,178 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f7e:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f82:	02077713          	andi	a4,a4,32
    80005f86:	c705                	beqz	a4,80005fae <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f88:	01f7f713          	andi	a4,a5,31
    80005f8c:	9752                	add	a4,a4,s4
    80005f8e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f92:	0785                	addi	a5,a5,1
    80005f94:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f96:	8526                	mv	a0,s1
    80005f98:	ffffb097          	auipc	ra,0xffffb
    80005f9c:	748080e7          	jalr	1864(ra) # 800016e0 <wakeup>
    
    WriteReg(THR, c);
    80005fa0:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fa4:	609c                	ld	a5,0(s1)
    80005fa6:	0009b703          	ld	a4,0(s3)
    80005faa:	fcf71ae3          	bne	a4,a5,80005f7e <uartstart+0x42>
  }
}
    80005fae:	70e2                	ld	ra,56(sp)
    80005fb0:	7442                	ld	s0,48(sp)
    80005fb2:	74a2                	ld	s1,40(sp)
    80005fb4:	7902                	ld	s2,32(sp)
    80005fb6:	69e2                	ld	s3,24(sp)
    80005fb8:	6a42                	ld	s4,16(sp)
    80005fba:	6aa2                	ld	s5,8(sp)
    80005fbc:	6121                	addi	sp,sp,64
    80005fbe:	8082                	ret
    80005fc0:	8082                	ret

0000000080005fc2 <uartputc>:
{
    80005fc2:	7179                	addi	sp,sp,-48
    80005fc4:	f406                	sd	ra,40(sp)
    80005fc6:	f022                	sd	s0,32(sp)
    80005fc8:	ec26                	sd	s1,24(sp)
    80005fca:	e84a                	sd	s2,16(sp)
    80005fcc:	e44e                	sd	s3,8(sp)
    80005fce:	e052                	sd	s4,0(sp)
    80005fd0:	1800                	addi	s0,sp,48
    80005fd2:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005fd4:	00020517          	auipc	a0,0x20
    80005fd8:	23450513          	addi	a0,a0,564 # 80026208 <uart_tx_lock>
    80005fdc:	00000097          	auipc	ra,0x0
    80005fe0:	1a4080e7          	jalr	420(ra) # 80006180 <acquire>
  if(panicked){
    80005fe4:	00003797          	auipc	a5,0x3
    80005fe8:	0387a783          	lw	a5,56(a5) # 8000901c <panicked>
    80005fec:	c391                	beqz	a5,80005ff0 <uartputc+0x2e>
    for(;;)
    80005fee:	a001                	j	80005fee <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ff0:	00003717          	auipc	a4,0x3
    80005ff4:	03873703          	ld	a4,56(a4) # 80009028 <uart_tx_w>
    80005ff8:	00003797          	auipc	a5,0x3
    80005ffc:	0287b783          	ld	a5,40(a5) # 80009020 <uart_tx_r>
    80006000:	02078793          	addi	a5,a5,32
    80006004:	02e79b63          	bne	a5,a4,8000603a <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006008:	00020997          	auipc	s3,0x20
    8000600c:	20098993          	addi	s3,s3,512 # 80026208 <uart_tx_lock>
    80006010:	00003497          	auipc	s1,0x3
    80006014:	01048493          	addi	s1,s1,16 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006018:	00003917          	auipc	s2,0x3
    8000601c:	01090913          	addi	s2,s2,16 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006020:	85ce                	mv	a1,s3
    80006022:	8526                	mv	a0,s1
    80006024:	ffffb097          	auipc	ra,0xffffb
    80006028:	530080e7          	jalr	1328(ra) # 80001554 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000602c:	00093703          	ld	a4,0(s2)
    80006030:	609c                	ld	a5,0(s1)
    80006032:	02078793          	addi	a5,a5,32
    80006036:	fee785e3          	beq	a5,a4,80006020 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000603a:	00020497          	auipc	s1,0x20
    8000603e:	1ce48493          	addi	s1,s1,462 # 80026208 <uart_tx_lock>
    80006042:	01f77793          	andi	a5,a4,31
    80006046:	97a6                	add	a5,a5,s1
    80006048:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000604c:	0705                	addi	a4,a4,1
    8000604e:	00003797          	auipc	a5,0x3
    80006052:	fce7bd23          	sd	a4,-38(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006056:	00000097          	auipc	ra,0x0
    8000605a:	ee6080e7          	jalr	-282(ra) # 80005f3c <uartstart>
      release(&uart_tx_lock);
    8000605e:	8526                	mv	a0,s1
    80006060:	00000097          	auipc	ra,0x0
    80006064:	1d4080e7          	jalr	468(ra) # 80006234 <release>
}
    80006068:	70a2                	ld	ra,40(sp)
    8000606a:	7402                	ld	s0,32(sp)
    8000606c:	64e2                	ld	s1,24(sp)
    8000606e:	6942                	ld	s2,16(sp)
    80006070:	69a2                	ld	s3,8(sp)
    80006072:	6a02                	ld	s4,0(sp)
    80006074:	6145                	addi	sp,sp,48
    80006076:	8082                	ret

0000000080006078 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006078:	1141                	addi	sp,sp,-16
    8000607a:	e422                	sd	s0,8(sp)
    8000607c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000607e:	100007b7          	lui	a5,0x10000
    80006082:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006086:	8b85                	andi	a5,a5,1
    80006088:	cb91                	beqz	a5,8000609c <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000608a:	100007b7          	lui	a5,0x10000
    8000608e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006092:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
    80006096:	6422                	ld	s0,8(sp)
    80006098:	0141                	addi	sp,sp,16
    8000609a:	8082                	ret
    return -1;
    8000609c:	557d                	li	a0,-1
    8000609e:	bfe5                	j	80006096 <uartgetc+0x1e>

00000000800060a0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060a0:	1101                	addi	sp,sp,-32
    800060a2:	ec06                	sd	ra,24(sp)
    800060a4:	e822                	sd	s0,16(sp)
    800060a6:	e426                	sd	s1,8(sp)
    800060a8:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060aa:	54fd                	li	s1,-1
    800060ac:	a029                	j	800060b6 <uartintr+0x16>
      break;
    consoleintr(c);
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	916080e7          	jalr	-1770(ra) # 800059c4 <consoleintr>
    int c = uartgetc();
    800060b6:	00000097          	auipc	ra,0x0
    800060ba:	fc2080e7          	jalr	-62(ra) # 80006078 <uartgetc>
    if(c == -1)
    800060be:	fe9518e3          	bne	a0,s1,800060ae <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060c2:	00020497          	auipc	s1,0x20
    800060c6:	14648493          	addi	s1,s1,326 # 80026208 <uart_tx_lock>
    800060ca:	8526                	mv	a0,s1
    800060cc:	00000097          	auipc	ra,0x0
    800060d0:	0b4080e7          	jalr	180(ra) # 80006180 <acquire>
  uartstart();
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	e68080e7          	jalr	-408(ra) # 80005f3c <uartstart>
  release(&uart_tx_lock);
    800060dc:	8526                	mv	a0,s1
    800060de:	00000097          	auipc	ra,0x0
    800060e2:	156080e7          	jalr	342(ra) # 80006234 <release>
}
    800060e6:	60e2                	ld	ra,24(sp)
    800060e8:	6442                	ld	s0,16(sp)
    800060ea:	64a2                	ld	s1,8(sp)
    800060ec:	6105                	addi	sp,sp,32
    800060ee:	8082                	ret

00000000800060f0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060f0:	1141                	addi	sp,sp,-16
    800060f2:	e422                	sd	s0,8(sp)
    800060f4:	0800                	addi	s0,sp,16
  lk->name = name;
    800060f6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060f8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060fc:	00053823          	sd	zero,16(a0)
}
    80006100:	6422                	ld	s0,8(sp)
    80006102:	0141                	addi	sp,sp,16
    80006104:	8082                	ret

0000000080006106 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006106:	411c                	lw	a5,0(a0)
    80006108:	e399                	bnez	a5,8000610e <holding+0x8>
    8000610a:	4501                	li	a0,0
  return r;
}
    8000610c:	8082                	ret
{
    8000610e:	1101                	addi	sp,sp,-32
    80006110:	ec06                	sd	ra,24(sp)
    80006112:	e822                	sd	s0,16(sp)
    80006114:	e426                	sd	s1,8(sp)
    80006116:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006118:	6904                	ld	s1,16(a0)
    8000611a:	ffffb097          	auipc	ra,0xffffb
    8000611e:	d56080e7          	jalr	-682(ra) # 80000e70 <mycpu>
    80006122:	40a48533          	sub	a0,s1,a0
    80006126:	00153513          	seqz	a0,a0
}
    8000612a:	60e2                	ld	ra,24(sp)
    8000612c:	6442                	ld	s0,16(sp)
    8000612e:	64a2                	ld	s1,8(sp)
    80006130:	6105                	addi	sp,sp,32
    80006132:	8082                	ret

0000000080006134 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006134:	1101                	addi	sp,sp,-32
    80006136:	ec06                	sd	ra,24(sp)
    80006138:	e822                	sd	s0,16(sp)
    8000613a:	e426                	sd	s1,8(sp)
    8000613c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000613e:	100024f3          	csrr	s1,sstatus
    80006142:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006146:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006148:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000614c:	ffffb097          	auipc	ra,0xffffb
    80006150:	d24080e7          	jalr	-732(ra) # 80000e70 <mycpu>
    80006154:	5d3c                	lw	a5,120(a0)
    80006156:	cf89                	beqz	a5,80006170 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006158:	ffffb097          	auipc	ra,0xffffb
    8000615c:	d18080e7          	jalr	-744(ra) # 80000e70 <mycpu>
    80006160:	5d3c                	lw	a5,120(a0)
    80006162:	2785                	addiw	a5,a5,1
    80006164:	dd3c                	sw	a5,120(a0)
}
    80006166:	60e2                	ld	ra,24(sp)
    80006168:	6442                	ld	s0,16(sp)
    8000616a:	64a2                	ld	s1,8(sp)
    8000616c:	6105                	addi	sp,sp,32
    8000616e:	8082                	ret
    mycpu()->intena = old;
    80006170:	ffffb097          	auipc	ra,0xffffb
    80006174:	d00080e7          	jalr	-768(ra) # 80000e70 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006178:	8085                	srli	s1,s1,0x1
    8000617a:	8885                	andi	s1,s1,1
    8000617c:	dd64                	sw	s1,124(a0)
    8000617e:	bfe9                	j	80006158 <push_off+0x24>

0000000080006180 <acquire>:
{
    80006180:	1101                	addi	sp,sp,-32
    80006182:	ec06                	sd	ra,24(sp)
    80006184:	e822                	sd	s0,16(sp)
    80006186:	e426                	sd	s1,8(sp)
    80006188:	1000                	addi	s0,sp,32
    8000618a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	fa8080e7          	jalr	-88(ra) # 80006134 <push_off>
  if(holding(lk))
    80006194:	8526                	mv	a0,s1
    80006196:	00000097          	auipc	ra,0x0
    8000619a:	f70080e7          	jalr	-144(ra) # 80006106 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000619e:	4705                	li	a4,1
  if(holding(lk))
    800061a0:	e115                	bnez	a0,800061c4 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061a2:	87ba                	mv	a5,a4
    800061a4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061a8:	2781                	sext.w	a5,a5
    800061aa:	ffe5                	bnez	a5,800061a2 <acquire+0x22>
  __sync_synchronize();
    800061ac:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061b0:	ffffb097          	auipc	ra,0xffffb
    800061b4:	cc0080e7          	jalr	-832(ra) # 80000e70 <mycpu>
    800061b8:	e888                	sd	a0,16(s1)
}
    800061ba:	60e2                	ld	ra,24(sp)
    800061bc:	6442                	ld	s0,16(sp)
    800061be:	64a2                	ld	s1,8(sp)
    800061c0:	6105                	addi	sp,sp,32
    800061c2:	8082                	ret
    panic("acquire");
    800061c4:	00002517          	auipc	a0,0x2
    800061c8:	5cc50513          	addi	a0,a0,1484 # 80008790 <etext+0x790>
    800061cc:	00000097          	auipc	ra,0x0
    800061d0:	a78080e7          	jalr	-1416(ra) # 80005c44 <panic>

00000000800061d4 <pop_off>:

void
pop_off(void)
{
    800061d4:	1141                	addi	sp,sp,-16
    800061d6:	e406                	sd	ra,8(sp)
    800061d8:	e022                	sd	s0,0(sp)
    800061da:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061dc:	ffffb097          	auipc	ra,0xffffb
    800061e0:	c94080e7          	jalr	-876(ra) # 80000e70 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061e4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061e8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800061ea:	e78d                	bnez	a5,80006214 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061ec:	5d3c                	lw	a5,120(a0)
    800061ee:	02f05b63          	blez	a5,80006224 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800061f2:	37fd                	addiw	a5,a5,-1
    800061f4:	0007871b          	sext.w	a4,a5
    800061f8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061fa:	eb09                	bnez	a4,8000620c <pop_off+0x38>
    800061fc:	5d7c                	lw	a5,124(a0)
    800061fe:	c799                	beqz	a5,8000620c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006200:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006204:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006208:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000620c:	60a2                	ld	ra,8(sp)
    8000620e:	6402                	ld	s0,0(sp)
    80006210:	0141                	addi	sp,sp,16
    80006212:	8082                	ret
    panic("pop_off - interruptible");
    80006214:	00002517          	auipc	a0,0x2
    80006218:	58450513          	addi	a0,a0,1412 # 80008798 <etext+0x798>
    8000621c:	00000097          	auipc	ra,0x0
    80006220:	a28080e7          	jalr	-1496(ra) # 80005c44 <panic>
    panic("pop_off");
    80006224:	00002517          	auipc	a0,0x2
    80006228:	58c50513          	addi	a0,a0,1420 # 800087b0 <etext+0x7b0>
    8000622c:	00000097          	auipc	ra,0x0
    80006230:	a18080e7          	jalr	-1512(ra) # 80005c44 <panic>

0000000080006234 <release>:
{
    80006234:	1101                	addi	sp,sp,-32
    80006236:	ec06                	sd	ra,24(sp)
    80006238:	e822                	sd	s0,16(sp)
    8000623a:	e426                	sd	s1,8(sp)
    8000623c:	1000                	addi	s0,sp,32
    8000623e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006240:	00000097          	auipc	ra,0x0
    80006244:	ec6080e7          	jalr	-314(ra) # 80006106 <holding>
    80006248:	c115                	beqz	a0,8000626c <release+0x38>
  lk->cpu = 0;
    8000624a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000624e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006252:	0f50000f          	fence	iorw,ow
    80006256:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	f7a080e7          	jalr	-134(ra) # 800061d4 <pop_off>
}
    80006262:	60e2                	ld	ra,24(sp)
    80006264:	6442                	ld	s0,16(sp)
    80006266:	64a2                	ld	s1,8(sp)
    80006268:	6105                	addi	sp,sp,32
    8000626a:	8082                	ret
    panic("release");
    8000626c:	00002517          	auipc	a0,0x2
    80006270:	54c50513          	addi	a0,a0,1356 # 800087b8 <etext+0x7b8>
    80006274:	00000097          	auipc	ra,0x0
    80006278:	9d0080e7          	jalr	-1584(ra) # 80005c44 <panic>
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
