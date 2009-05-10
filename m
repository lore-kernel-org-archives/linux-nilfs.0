From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Sun, 10 May 2009 18:12:27 +0200
Message-ID: <4A06FCEB.7030800@prnet.org>
References: <4A01B0D2.6030509@prnet.org>	<20090510.144313.10164669.ryusuke@osrg.net>	<4A06D0C4.5030008@prnet.org>
	<20090511.004002.32775441.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010709080704040503070002"
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090511.004002.32775441.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

This is a multi-part message in MIME format.
--------------010709080704040503070002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

ok, here the requested file

Bye,
David Arendt

Ryusuke Konishi wrote:
> Hi,
> On Sun, 10 May 2009 15:04:04 +0200, David Arendt wrote:
>   
>> Hi,
>>
>> I am using gcc 4.1.2.
>>
>> In the meantime, I upgraded from kernel 2.6.29.2 to 2.6.29.3 and as a 
>> result of this, I have also recompiled nilfs, so I suppose an objdump 
>> from this one would be useless in combination with the old crash log.
>>     
>
> It's fine by me unless gcc version has changed.  The difference
> between kernel 2.6.29.2 and 2.6.29.3 is ignorable in this case.
>
> Regards,
> Ryusuke Konishi
>
>   
>> I think I should wait until the problem appears again with
>> 2.6.29.3. What do you think ?
>>
>> Bye,
>> David Arendt
>>
>> Ryusuke Konishi wrote:
>>     
>>> Hi David,
>>> On Wed, 06 May 2009 17:46:26 +0200, David Arendt wrote:
>>>   
>>>       
>>>> Hi,
>>>>
>>>> today I had run cleanerd on 2 clean partitions.
>>>>
>>>> One worked flawlessly. On the other one this error occured:
>>>>
>>>> BUG: unable to handle kernel NULL pointer dereference at 00000ccd
>>>> IP: [<f8341fcc>] nilfs_gc_iget+0x4c/0x130 [nilfs2]
>>>> *pdpt = 0000000013d32001 *pde = 0000000000000000
>>>> Oops: 0000 [#1] PREEMPT SMP
>>>> last sysfs file: /sys/devices/pci0000:00/0000:00:1f.0/resource
>>>> Modules linked in: nvidia(P) vmnet vmblock vmci vmmon fcpci(P) capi 
>>>> capifs kernelcapi nilfs2 scsi_wait_scan
>>>>
>>>> Pid: 8551, comm: nilfs_cleanerd Tainted: P           (2.6.29.2server #1) 
>>>> P5QL-E
>>>> EIP: 0060:[<f8341fcc>] EFLAGS: 00010202 CPU: 3
>>>> EIP is at nilfs_gc_iget+0x4c/0x130 [nilfs2]
>>>> EAX: 00000ccd EBX: 00000000 ECX: 00000002 EDX: f6897c00
>>>> ESI: 0000004e EDI: 00000002 EBP: 00000000 ESP: c3801ca0
>>>>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>>>> Process nilfs_cleanerd (pid: 8551, ti=c3800000 task=d4d10330 
>>>> task.ti=c3800000)
>>>> Stack:
>>>>  e11854c0 f6857a00 f6897c3c 00000000 00000000 00000000 e1185500 f8342e06
>>>>  00000002 00000000 c3801d60 00000044 f7450990 d4d10484 00000001 00000001
>>>>  00000000 00000000 00020050 00000202 00000000 00000000 00000000 c3801d58
>>>> Call Trace:
>>>>  [<f8342e06>] nilfs_ioctl_do_move_blocks+0x76/0x3e0 [nilfs2]
>>>>  [<f8342379>] nilfs_ioctl_wrap_copy+0x169/0x1f0 [nilfs2]
>>>>  [<f834292e>] nilfs_ioctl_prepare_clean_segments+0x6e/0x130 [nilfs2]
>>>>  [<f8342d90>] nilfs_ioctl_do_move_blocks+0x0/0x3e0 [nilfs2]
>>>>  [<f833deb3>] nilfs_clean_segments+0x83/0x200 [nilfs2]
>>>>  [<f83423c6>] nilfs_ioctl_wrap_copy+0x1b6/0x1f0 [nilfs2]
>>>>  [<f8342810>] nilfs_ioctl+0x3d0/0x480 [nilfs2]
>>>>  [<f8342c90>] nilfs_ioctl_do_get_bdescs+0x0/0xb0 [nilfs2]
>>>>  [<c0312ddf>] ehci_irq+0x17f/0x340
>>>>  [<c0168a78>] page_add_new_anon_rmap+0x28/0x60
>>>>  [<c013ddfe>] getnstimeofday+0x4e/0x120
>>>>  [<f8342440>] nilfs_ioctl+0x0/0x480 [nilfs2]
>>>>  [<c017f50b>] vfs_ioctl+0x2b/0x90
>>>>  [<c017f87b>] do_vfs_ioctl+0x1eb/0x530
>>>>  [<c012d45b>] run_timer_softirq+0x15b/0x190
>>>>  [<c0128d74>] __do_softirq+0x94/0x140
>>>>  [<c017fbfd>] sys_ioctl+0x3d/0x70
>>>>  [<c0103131>] sysenter_do_call+0x12/0x25
>>>>  [<c0400000>] pci_read_bridge_bases+0x20/0x350
>>>> Code: f8 69 c0 01 00 37 9e c1 e8 18 c1 e0 02 89 44 24 08 8b 92 dc 00 00 
>>>> 00 01 d0 89 44 24 08 8b 00 85 c0 75 08 eb 2b 85 c9 74 27 89 c8 <8b> 08 
>>>> 0f 18 01 90 3b 70 20 89 c3 75 ed 8b 50 9c 8b 40 98 31 ea
>>>> EIP: [<f8341fcc>] nilfs_gc_iget+0x4c/0x130 [nilfs2] SS:ESP 0068:c3801ca0
>>>> ---[ end trace 573da78de6d7c815 ]---
>>>>
>>>> Bye,
>>>> Arendt David
>>>>     
>>>>         
>>> I finally gave up trailing this problem from your log because my gcc
>>> generates different assembler code with yours.
>>>
>>> Could you send me a disassembler output of the nilfs_gc_iget function?
>>> It is acquirable as follows:
>>>
>>>   $ cd nilfs2-module/fs
>>>   $ objdump -D gcinode.o > gcinode.disasm
>>>
>>> And, please let me know the gcc version you are using.
>>>
>>> Thanks in advance,
>>> Ryusuke Konishi
>>>   
>>>       


--------------010709080704040503070002
Content-Type: text/plain;
 name="gcinode.disasm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gcinode.disasm"


gcinode.o:     file format elf32-i386

Disassembly of section .text:

00000000 <nilfs_clear_gcinode>:
   0:	53                   	push   %ebx
   1:	89 c3                	mov    %eax,%ebx
   3:	e8 fc ff ff ff       	call   4 <nilfs_clear_gcinode+0x4>
   8:	89 d8                	mov    %ebx,%eax
   a:	5b                   	pop    %ebx
   b:	e9 fc ff ff ff       	jmp    c <nilfs_clear_gcinode+0xc>

00000010 <nilfs_remove_all_gcinode>:
  10:	55                   	push   %ebp
  11:	31 ed                	xor    %ebp,%ebp
  13:	57                   	push   %edi
  14:	56                   	push   %esi
  15:	53                   	push   %ebx
  16:	8b b8 dc 00 00 00    	mov    0xdc(%eax),%edi
  1c:	8d 74 26 00          	lea    0x0(%esi),%esi
  20:	8b 1f                	mov    (%edi),%ebx
  22:	85 db                	test   %ebx,%ebx
  24:	74 4a                	je     70 <nilfs_remove_all_gcinode+0x60>
  26:	8d 76 00             	lea    0x0(%esi),%esi
  29:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi
  30:	8b 43 04             	mov    0x4(%ebx),%eax
  33:	8b 33                	mov    (%ebx),%esi
  35:	85 c0                	test   %eax,%eax
  37:	74 16                	je     4f <nilfs_remove_all_gcinode+0x3f>
  39:	85 f6                	test   %esi,%esi
  3b:	89 30                	mov    %esi,(%eax)
  3d:	74 03                	je     42 <nilfs_remove_all_gcinode+0x32>
  3f:	89 46 04             	mov    %eax,0x4(%esi)
  42:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  48:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  4f:	8d 43 f4             	lea    -0xc(%ebx),%eax
  52:	8b 4b f4             	mov    -0xc(%ebx),%ecx
  55:	8b 50 04             	mov    0x4(%eax),%edx
  58:	89 51 04             	mov    %edx,0x4(%ecx)
  5b:	89 0a                	mov    %ecx,(%edx)
  5d:	89 40 04             	mov    %eax,0x4(%eax)
  60:	89 43 f4             	mov    %eax,-0xc(%ebx)
  63:	89 d8                	mov    %ebx,%eax
  65:	89 f3                	mov    %esi,%ebx
  67:	e8 fc ff ff ff       	call   68 <nilfs_remove_all_gcinode+0x58>
  6c:	85 f6                	test   %esi,%esi
  6e:	75 c0                	jne    30 <nilfs_remove_all_gcinode+0x20>
  70:	45                   	inc    %ebp
  71:	81 fd 00 01 00 00    	cmp    $0x100,%ebp
  77:	74 09                	je     82 <nilfs_remove_all_gcinode+0x72>
  79:	83 c7 04             	add    $0x4,%edi
  7c:	8d 74 26 00          	lea    0x0(%esi),%esi
  80:	eb 9e                	jmp    20 <nilfs_remove_all_gcinode+0x10>
  82:	5b                   	pop    %ebx
  83:	5e                   	pop    %esi
  84:	5f                   	pop    %edi
  85:	5d                   	pop    %ebp
  86:	c3                   	ret    
  87:	89 f6                	mov    %esi,%esi
  89:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000090 <nilfs_destroy_gccache>:
  90:	53                   	push   %ebx
  91:	89 c3                	mov    %eax,%ebx
  93:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  99:	85 d2                	test   %edx,%edx
  9b:	74 18                	je     b5 <nilfs_destroy_gccache+0x25>
  9d:	e8 fc ff ff ff       	call   9e <nilfs_destroy_gccache+0xe>
  a2:	8b 83 dc 00 00 00    	mov    0xdc(%ebx),%eax
  a8:	e8 fc ff ff ff       	call   a9 <nilfs_destroy_gccache+0x19>
  ad:	31 c0                	xor    %eax,%eax
  af:	89 83 dc 00 00 00    	mov    %eax,0xdc(%ebx)
  b5:	5b                   	pop    %ebx
  b6:	c3                   	ret    
  b7:	89 f6                	mov    %esi,%esi
  b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000000c0 <nilfs_init_gccache>:
  c0:	53                   	push   %ebx
  c1:	89 c3                	mov    %eax,%ebx
  c3:	8b 88 dc 00 00 00    	mov    0xdc(%eax),%ecx
  c9:	85 c9                	test   %ecx,%ecx
  cb:	75 51                	jne    11e <nilfs_init_gccache+0x5e>
  cd:	8d 80 d4 00 00 00    	lea    0xd4(%eax),%eax
  d3:	ba 50 00 00 00       	mov    $0x50,%edx
  d8:	89 83 d4 00 00 00    	mov    %eax,0xd4(%ebx)
  de:	89 40 04             	mov    %eax,0x4(%eax)
  e1:	a1 4c 00 00 00       	mov    0x4c,%eax
  e6:	e8 fc ff ff ff       	call   e7 <nilfs_init_gccache+0x27>
  eb:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  f0:	85 c0                	test   %eax,%eax
  f2:	89 83 dc 00 00 00    	mov    %eax,0xdc(%ebx)
  f8:	74 20                	je     11a <nilfs_init_gccache+0x5a>
  fa:	31 d2                	xor    %edx,%edx
  fc:	8d 74 26 00          	lea    0x0(%esi),%esi
 100:	8b 83 dc 00 00 00    	mov    0xdc(%ebx),%eax
 106:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
 10d:	83 c2 04             	add    $0x4,%edx
 110:	81 fa 00 04 00 00    	cmp    $0x400,%edx
 116:	75 e8                	jne    100 <nilfs_init_gccache+0x40>
 118:	31 d2                	xor    %edx,%edx
 11a:	5b                   	pop    %ebx
 11b:	89 d0                	mov    %edx,%eax
 11d:	c3                   	ret    
 11e:	0f 0b                	ud2a   
 120:	eb fe                	jmp    120 <nilfs_init_gccache+0x60>
 122:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000130 <nilfs_gccache_wait_and_mark_dirty>:
 130:	53                   	push   %ebx
 131:	89 c3                	mov    %eax,%ebx
 133:	f6 00 04             	testb  $0x4,(%eax)
 136:	75 18                	jne    150 <nilfs_gccache_wait_and_mark_dirty+0x20>
 138:	8b 40 30             	mov    0x30(%eax),%eax
 13b:	85 c0                	test   %eax,%eax
 13d:	74 11                	je     150 <nilfs_gccache_wait_and_mark_dirty+0x20>
 13f:	f6 03 01             	testb  $0x1,(%ebx)
 142:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
 147:	75 19                	jne    162 <nilfs_gccache_wait_and_mark_dirty+0x32>
 149:	5b                   	pop    %ebx
 14a:	c3                   	ret    
 14b:	90                   	nop    
 14c:	8d 74 26 00          	lea    0x0(%esi),%esi
 150:	89 d8                	mov    %ebx,%eax
 152:	e8 fc ff ff ff       	call   153 <nilfs_gccache_wait_and_mark_dirty+0x23>
 157:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
 15c:	f6 03 01             	testb  $0x1,(%ebx)
 15f:	90                   	nop    
 160:	74 e7                	je     149 <nilfs_gccache_wait_and_mark_dirty+0x19>
 162:	f6 03 02             	testb  $0x2,(%ebx)
 165:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
 16a:	75 dd                	jne    149 <nilfs_gccache_wait_and_mark_dirty+0x19>
 16c:	89 d8                	mov    %ebx,%eax
 16e:	e8 fc ff ff ff       	call   16f <nilfs_gccache_wait_and_mark_dirty+0x3f>
 173:	31 c0                	xor    %eax,%eax
 175:	5b                   	pop    %ebx
 176:	c3                   	ret    
 177:	89 f6                	mov    %esi,%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000180 <nilfs_gccache_submit_read_node>:
 180:	83 ec 14             	sub    $0x14,%esp
 183:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 187:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
 18b:	8b 4c 24 18          	mov    0x18(%esp),%ecx
 18f:	89 74 24 10          	mov    %esi,0x10(%esp)
 193:	89 d6                	mov    %edx,%esi
 195:	89 da                	mov    %ebx,%edx
 197:	09 ca                	or     %ecx,%edx
 199:	75 04                	jne    19f <nilfs_gccache_submit_read_node+0x1f>
 19b:	89 f1                	mov    %esi,%ecx
 19d:	31 db                	xor    %ebx,%ebx
 19f:	31 d2                	xor    %edx,%edx
 1a1:	83 e8 60             	sub    $0x60,%eax
 1a4:	89 54 24 08          	mov    %edx,0x8(%esp)
 1a8:	8b 54 24 20          	mov    0x20(%esp),%edx
 1ac:	89 34 24             	mov    %esi,(%esp)
 1af:	89 54 24 04          	mov    %edx,0x4(%esp)
 1b3:	89 ca                	mov    %ecx,%edx
 1b5:	89 d9                	mov    %ebx,%ecx
 1b7:	e8 fc ff ff ff       	call   1b8 <nilfs_gccache_submit_read_node+0x38>
 1bc:	ba 00 00 00 00       	mov    $0x0,%edx
 1c1:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
 1c5:	8b 74 24 10          	mov    0x10(%esp),%esi
 1c9:	83 f8 ef             	cmp    $0xffffffef,%eax
 1cc:	0f 44 c2             	cmove  %edx,%eax
 1cf:	83 c4 14             	add    $0x14,%esp
 1d2:	c3                   	ret    
 1d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

000001e0 <nilfs_gc_iget>:
 1e0:	55                   	push   %ebp
 1e1:	57                   	push   %edi
 1e2:	56                   	push   %esi
 1e3:	89 d6                	mov    %edx,%esi
 1e5:	53                   	push   %ebx
 1e6:	83 ec 0c             	sub    $0xc,%esp
 1e9:	8b 7c 24 20          	mov    0x20(%esp),%edi
 1ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f1:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 1f8:	8b 6c 24 24          	mov    0x24(%esp),%ebp
 1fc:	8b 54 24 04          	mov    0x4(%esp),%edx
 200:	01 f8                	add    %edi,%eax
 202:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
 208:	c1 e8 18             	shr    $0x18,%eax
 20b:	c1 e0 02             	shl    $0x2,%eax
 20e:	89 44 24 08          	mov    %eax,0x8(%esp)
 212:	8b 92 dc 00 00 00    	mov    0xdc(%edx),%edx
 218:	01 d0                	add    %edx,%eax
 21a:	89 44 24 08          	mov    %eax,0x8(%esp)
 21e:	8b 00                	mov    (%eax),%eax
 220:	85 c0                	test   %eax,%eax
 222:	75 08                	jne    22c <nilfs_gc_iget+0x4c>
 224:	eb 2b                	jmp    251 <nilfs_gc_iget+0x71>
 226:	85 c9                	test   %ecx,%ecx
 228:	74 27                	je     251 <nilfs_gc_iget+0x71>
 22a:	89 c8                	mov    %ecx,%eax
 22c:	8b 08                	mov    (%eax),%ecx
 22e:	8d 74 26 00          	lea    0x0(%esi),%esi
 232:	3b 70 20             	cmp    0x20(%eax),%esi
 235:	89 c3                	mov    %eax,%ebx
 237:	75 ed                	jne    226 <nilfs_gc_iget+0x46>
 239:	8b 50 9c             	mov    -0x64(%eax),%edx
 23c:	8b 40 98             	mov    -0x68(%eax),%eax
 23f:	31 ea                	xor    %ebp,%edx
 241:	31 f8                	xor    %edi,%eax
 243:	09 c2                	or     %eax,%edx
 245:	75 df                	jne    226 <nilfs_gc_iget+0x46>
 247:	83 c4 0c             	add    $0xc,%esp
 24a:	89 d8                	mov    %ebx,%eax
 24c:	5b                   	pop    %ebx
 24d:	5e                   	pop    %esi
 24e:	5f                   	pop    %edi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
 251:	8b 44 24 04          	mov    0x4(%esp),%eax
 255:	31 d2                	xor    %edx,%edx
 257:	89 f1                	mov    %esi,%ecx
 259:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
 260:	e8 fc ff ff ff       	call   261 <nilfs_gc_iget+0x81>
 265:	85 c0                	test   %eax,%eax
 267:	89 c3                	mov    %eax,%ebx
 269:	74 dc                	je     247 <nilfs_gc_iget+0x67>
 26b:	31 c0                	xor    %eax,%eax
 26d:	31 c9                	xor    %ecx,%ecx
 26f:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
 275:	31 c0                	xor    %eax,%eax
 277:	31 f6                	xor    %esi,%esi
 279:	89 83 98 00 00 00    	mov    %eax,0x98(%ebx)
 27f:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
 285:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
 28c:	8d 83 04 ff ff ff    	lea    -0xfc(%ebx),%eax
 292:	89 b8 94 00 00 00    	mov    %edi,0x94(%eax)
 298:	89 a8 98 00 00 00    	mov    %ebp,0x98(%eax)
 29e:	c7 40 04 00 01 00 00 	movl   $0x100,0x4(%eax)
 2a5:	89 88 f8 00 00 00    	mov    %ecx,0xf8(%eax)
 2ab:	8b 40 08             	mov    0x8(%eax),%eax
 2ae:	89 b3 04 ff ff ff    	mov    %esi,-0xfc(%ebx)
 2b4:	e8 fc ff ff ff       	call   2b5 <nilfs_gc_iget+0xd5>
 2b9:	8b 54 24 08          	mov    0x8(%esp),%edx
 2bd:	8b 02                	mov    (%edx),%eax
 2bf:	85 c0                	test   %eax,%eax
 2c1:	89 03                	mov    %eax,(%ebx)
 2c3:	74 03                	je     2c8 <nilfs_gc_iget+0xe8>
 2c5:	89 58 04             	mov    %ebx,0x4(%eax)
 2c8:	8b 44 24 08          	mov    0x8(%esp),%eax
 2cc:	89 18                	mov    %ebx,(%eax)
 2ce:	89 43 04             	mov    %eax,0x4(%ebx)
 2d1:	8b 44 24 04          	mov    0x4(%esp),%eax
 2d5:	8b 4c 24 04          	mov    0x4(%esp),%ecx
 2d9:	8b 90 d4 00 00 00    	mov    0xd4(%eax),%edx
 2df:	8d 43 f4             	lea    -0xc(%ebx),%eax
 2e2:	81 c1 d4 00 00 00    	add    $0xd4,%ecx
 2e8:	89 42 04             	mov    %eax,0x4(%edx)
 2eb:	89 53 f4             	mov    %edx,-0xc(%ebx)
 2ee:	89 48 04             	mov    %ecx,0x4(%eax)
 2f1:	8b 54 24 04          	mov    0x4(%esp),%edx
 2f5:	89 82 d4 00 00 00    	mov    %eax,0xd4(%edx)
 2fb:	83 c4 0c             	add    $0xc,%esp
 2fe:	89 d8                	mov    %ebx,%eax
 300:	5b                   	pop    %ebx
 301:	5e                   	pop    %esi
 302:	5f                   	pop    %edi
 303:	5d                   	pop    %ebp
 304:	c3                   	ret    
 305:	8d 74 26 00          	lea    0x0(%esi),%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00000310 <nilfs_gccache_submit_read_data>:
 310:	57                   	push   %edi
 311:	89 c7                	mov    %eax,%edi
 313:	56                   	push   %esi
 314:	89 d0                	mov    %edx,%eax
 316:	53                   	push   %ebx
 317:	be f4 ff ff ff       	mov    $0xfffffff4,%esi
 31c:	83 ec 08             	sub    $0x8,%esp
 31f:	8b 97 a4 00 00 00    	mov    0xa4(%edi),%edx
 325:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 329:	89 c1                	mov    %eax,%ecx
 32b:	89 f8                	mov    %edi,%eax
 32d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 334:	e8 fc ff ff ff       	call   335 <nilfs_gccache_submit_read_data+0x25>
 339:	85 c0                	test   %eax,%eax
 33b:	89 c3                	mov    %eax,%ebx
 33d:	0f 84 d5 00 00 00    	je     418 <nilfs_gccache_submit_read_data+0x108>
 343:	f6 00 01             	testb  $0x1,(%eax)
 346:	0f 85 b4 00 00 00    	jne    400 <nilfs_gccache_submit_read_data+0xf0>
 34c:	8b 44 24 04          	mov    0x4(%esp),%eax
 350:	85 c0                	test   %eax,%eax
 352:	75 3b                	jne    38f <nilfs_gccache_submit_read_data+0x7f>
 354:	8b 87 9c 00 00 00    	mov    0x9c(%edi),%eax
 35a:	85 c0                	test   %eax,%eax
 35c:	0f 84 d7 00 00 00    	je     439 <nilfs_gccache_submit_read_data+0x129>
 362:	8b 80 88 01 00 00    	mov    0x188(%eax),%eax
 368:	8b 40 28             	mov    0x28(%eax),%eax
 36b:	8d 54 24 04          	lea    0x4(%esp),%edx
 36f:	8b 80 c4 00 00 00    	mov    0xc4(%eax),%eax
 375:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
 379:	89 14 24             	mov    %edx,(%esp)
 37c:	8b 54 24 18          	mov    0x18(%esp),%edx
 380:	e8 fc ff ff ff       	call   381 <nilfs_gccache_submit_read_data+0x71>
 385:	85 c0                	test   %eax,%eax
 387:	89 c6                	mov    %eax,%esi
 389:	0f 85 d0 00 00 00    	jne    45f <nilfs_gccache_submit_read_data+0x14f>
 38f:	f0 0f ba 2b 02       	lock btsl $0x2,(%ebx)
 394:	19 c0                	sbb    %eax,%eax
 396:	85 c0                	test   %eax,%eax
 398:	0f 85 b5 00 00 00    	jne    453 <nilfs_gccache_submit_read_data+0x143>
 39e:	8b 03                	mov    (%ebx),%eax
 3a0:	a8 01                	test   $0x1,%al
 3a2:	0f 85 88 00 00 00    	jne    430 <nilfs_gccache_submit_read_data+0x120>
 3a8:	a8 20                	test   $0x20,%al
 3aa:	75 21                	jne    3cd <nilfs_gccache_submit_read_data+0xbd>
 3ac:	8b 87 9c 00 00 00    	mov    0x9c(%edi),%eax
 3b2:	85 c0                	test   %eax,%eax
 3b4:	0f 84 8c 00 00 00    	je     446 <nilfs_gccache_submit_read_data+0x136>
 3ba:	8b 80 88 01 00 00    	mov    0x188(%eax),%eax
 3c0:	8b 40 28             	mov    0x28(%eax),%eax
 3c3:	8b 40 08             	mov    0x8(%eax),%eax
 3c6:	89 43 18             	mov    %eax,0x18(%ebx)
 3c9:	f0 80 0b 20          	lock orb $0x20,(%ebx)
 3cd:	8b 44 24 04          	mov    0x4(%esp),%eax
 3d1:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
 3d8:	89 43 0c             	mov    %eax,0xc(%ebx)
 3db:	f0 ff 43 30          	lock incl 0x30(%ebx)
 3df:	31 c0                	xor    %eax,%eax
 3e1:	89 da                	mov    %ebx,%edx
 3e3:	e8 fc ff ff ff       	call   3e4 <nilfs_gccache_submit_read_data+0xd4>
 3e8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 3ec:	0b 44 24 18          	or     0x18(%esp),%eax
 3f0:	75 2f                	jne    421 <nilfs_gccache_submit_read_data+0x111>
 3f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi
 400:	8b 44 24 20          	mov    0x20(%esp),%eax
 404:	31 f6                	xor    %esi,%esi
 406:	89 18                	mov    %ebx,(%eax)
 408:	8b 43 08             	mov    0x8(%ebx),%eax
 40b:	e8 fc ff ff ff       	call   40c <nilfs_gccache_submit_read_data+0xfc>
 410:	8b 43 08             	mov    0x8(%ebx),%eax
 413:	e8 fc ff ff ff       	call   414 <nilfs_gccache_submit_read_data+0x104>
 418:	83 c4 08             	add    $0x8,%esp
 41b:	89 f0                	mov    %esi,%eax
 41d:	5b                   	pop    %ebx
 41e:	5e                   	pop    %esi
 41f:	5f                   	pop    %edi
 420:	c3                   	ret    
 421:	8b 54 24 18          	mov    0x18(%esp),%edx
 425:	89 53 0c             	mov    %edx,0xc(%ebx)
 428:	eb d6                	jmp    400 <nilfs_gccache_submit_read_data+0xf0>
 42a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 430:	89 d8                	mov    %ebx,%eax
 432:	e8 fc ff ff ff       	call   433 <nilfs_gccache_submit_read_data+0x123>
 437:	eb c7                	jmp    400 <nilfs_gccache_submit_read_data+0xf0>
 439:	8b 87 40 01 00 00    	mov    0x140(%edi),%eax
 43f:	8b 00                	mov    (%eax),%eax
 441:	e9 25 ff ff ff       	jmp    36b <nilfs_gccache_submit_read_data+0x5b>
 446:	8b 87 40 01 00 00    	mov    0x140(%edi),%eax
 44c:	8b 00                	mov    (%eax),%eax
 44e:	e9 70 ff ff ff       	jmp    3c3 <nilfs_gccache_submit_read_data+0xb3>
 453:	89 d8                	mov    %ebx,%eax
 455:	e8 fc ff ff ff       	call   456 <nilfs_gccache_submit_read_data+0x146>
 45a:	e9 3f ff ff ff       	jmp    39e <nilfs_gccache_submit_read_data+0x8e>
 45f:	85 db                	test   %ebx,%ebx
 461:	74 a5                	je     408 <nilfs_gccache_submit_read_data+0xf8>
 463:	89 d8                	mov    %ebx,%eax
 465:	e8 fc ff ff ff       	call   466 <nilfs_gccache_submit_read_data+0x156>
 46a:	eb 9c                	jmp    408 <nilfs_gccache_submit_read_data+0xf8>
Disassembly of section .bss:

00000000 <def_gcinode_aops>:
	...
Disassembly of section .rodata.str1.4:

00000000 <.rodata.str1.4>:
   0:	2f                   	das    
   1:	68 6f 6d 65 2f       	push   $0x2f656d6f
   6:	61                   	popa   
   7:	64                   	fs
   8:	6d                   	insl   (%dx),%es:(%edi)
   9:	69 6e 2f 78 2f 6e 69 	imul   $0x696e2f78,0x2f(%esi),%ebp
  10:	6c                   	insb   (%dx),%es:(%edi)
  11:	66                   	data16
  12:	73 2d                	jae    41 <nilfs_remove_all_gcinode+0x31>
  14:	32 2e                	xor    (%esi),%ch
  16:	30 2e                	xor    %ch,(%esi)
  18:	31 32                	xor    %esi,(%edx)
  1a:	2f                   	das    
  1b:	66                   	data16
  1c:	73 2f                	jae    4d <nilfs_remove_all_gcinode+0x3d>
  1e:	67 63 69 6e          	addr16 arpl %bp,0x6e(%bx,%di)
  22:	6f                   	outsl  %ds:(%esi),(%dx)
  23:	64 65 2e 63 00       	arpl   %ax,%cs:%fs:%gs:(%eax)
Disassembly of section __bug_table:

00000000 <__bug_table>:
   0:	1e                   	push   %ds
   1:	01 00                	add    %eax,(%eax)
   3:	00 00                	add    %al,(%eax)
   5:	00 00                	add    %al,(%eax)
   7:	00                   	.byte 0x0
   8:	ba                   	.byte 0xba
   9:	00 00                	add    %al,(%eax)
	...
Disassembly of section .altinstructions:

00000000 <.altinstructions>:
   0:	2e 02 00             	add    %cs:(%eax),%al
   3:	00 00                	add    %al,(%eax)
   5:	00 00                	add    %al,(%eax)
   7:	00 19                	add    %bl,(%ecx)
   9:	04 03                	add    $0x3,%al
Disassembly of section .altinstr_replacement:

00000000 <.altinstr_replacement>:
   0:	0f 18 01             	prefetchnta (%ecx)
Disassembly of section .smp_locks:

00000000 <.smp_locks>:
   0:	8f 03                	popl   (%ebx)
   2:	00 00                	add    %al,(%eax)
   4:	c9                   	leave  
   5:	03 00                	add    (%eax),%eax
   7:	00 db                	add    %bl,%bl
   9:	03 00                	add    (%eax),%eax
	...
Disassembly of section .comment:

00000000 <.comment>:
   0:	00 47 43             	add    %al,0x43(%edi)
   3:	43                   	inc    %ebx
   4:	3a 20                	cmp    (%eax),%ah
   6:	28 47 4e             	sub    %al,0x4e(%edi)
   9:	55                   	push   %ebp
   a:	29 20                	sub    %esp,(%eax)
   c:	34 2e                	xor    $0x2e,%al
   e:	31 2e                	xor    %ebp,(%esi)
  10:	32 20                	xor    (%eax),%ah
  12:	28 47 65             	sub    %al,0x65(%edi)
  15:	6e                   	outsb  %ds:(%esi),(%dx)
  16:	74 6f                	je     87 <nilfs_remove_all_gcinode+0x77>
  18:	6f                   	outsl  %ds:(%esi),(%dx)
  19:	20 34 2e             	and    %dh,(%esi,%ebp,1)
  1c:	31 2e                	xor    %ebp,(%esi)
  1e:	32 20                	xor    (%eax),%ah
  20:	70 31                	jo     53 <nilfs_remove_all_gcinode+0x43>
  22:	2e 30 2e             	xor    %ch,%cs:(%esi)
  25:	32 29                	xor    (%ecx),%ch
	...

--------------010709080704040503070002
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--------------010709080704040503070002--
