From: Alexander Schier <alex-W0ZHf6uU1cg@public.gmane.org>
Subject: Re: Kernel Bug while deleting files (with rsync)
Date: Wed, 26 Mar 2008 17:47:23 +0100
Message-ID: <20080326164723.GA31518@laxu.de>
References: <20080325102553.GA10853@laxu.de>
	<1206445521.3131.60.camel@localhost.localdomain>
	<20080326.220532.62697306.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080326.220532.62697306.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi!


segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
NILFS warning (device dm-3): nilfs_sync_super: barrier-based sync failed. disabling barriers

PAGE_BUG(c1328080): cnt=2 index#=0 flags=0x40000805 mapping=00000000 ino=0
 BH[0] d66a1cd0: cnt=1 block#=0 state=0x20000
------------[ cut here ]------------
kernel BUG at /home/allo/nilfs-2.0.2/fs/page.c:651!
invalid opcode: 0000 [#1] PREEMPT 
Modules linked in: nilfs2 sha256_generic aes_i586 aes_generic cbc blkcipher nfsd exportfs ipv6 nfs lockd sunrpc dm_crypt dm_mod analog uhci_hcd snd_intel8x0 snd_ac97_codec ohci_hcd ehci_hcd gameport parport_pc parport ac97_bus snd_pcm snd_timer usbcore snd snd_page_alloc

Pid: 2903, comm: rsync Not tainted (2.6.24.2 #2)
EIP: 0060:[<e0e7308f>] EFLAGS: 00010246 CPU: 0
EIP is at nilfs_page_bug+0xc5/0xc9 [nilfs2]
EAX: 00000031 EBX: 00000001 ECX: d8fa3e24 EDX: e0e883eb
ESI: d66a1cd0 EDI: 00000000 EBP: 00000001 ESP: d8fa3e20
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process rsync (pid: 2903, ti=d8fa2000 task=deb72550 task.ti=d8fa2000)
Stack: e0e883eb 00000000 d66a1cd0 00000001 00000000 00000000 00020000 00000000 
       d66a1cd0 c1328080 c1328080 00000001 d670dc60 e0e730d8 00000001 e0e745c6 
       c1328080 00000001 00000001 e0e74dda 00000010 c1328080 00000004 00000000 
Call Trace:
 [<e0e730d8>] nilfs_free_buffer_page+0x33/0x38 [nilfs2]
 [<e0e745c6>] nilfs_btnode_delete_page+0x27/0x2d [nilfs2]
 [<e0e74dda>] nilfs_btnode_cache_clear+0x81/0x94 [nilfs2]
 [<e0e725bb>] nilfs_clear_inode+0x87/0x9a [nilfs2]
 [<c0176ca3>] clear_inode+0x6c/0xba
 [<e0e6f978>] nilfs_free_inode+0x17/0x28 [nilfs2]
 [<e0e6fbcb>] nilfs_delete_inode+0xd0/0x10f [nilfs2]
 [<c0175d23>] d_delete+0x5d/0xe3
 [<e0e6fafb>] nilfs_delete_inode+0x0/0x10f [nilfs2]
 [<c0177122>] generic_delete_inode+0x71/0xee
 [<c0176636>] iput+0x60/0x62
 [<c016e80e>] do_unlinkat+0xbe/0xfe
 [<c01656b1>] vfs_write+0x114/0x124
 [<c0165763>] sys_write+0x41/0x67
 [<c0103e4e>] syscall_call+0x7/0xb
 =======================
Code: 24 18 89 54 24 10 89 4c 24 14 89 5c 24 0c 89 7c 24 04 c7 04 24 eb 83 e8 e0 e8 ef c8 47 df 8b 76 04 3b 74 24 20 74 04 89 ef eb c2 <0f> 0b eb fe 53 89 c3 e8 7c 47 2d df 89 d8 31 d2 5b e9 44 8f 2d 
EIP: [<e0e7308f>] nilfs_page_bug+0xc5/0xc9 [nilfs2] SS:ESP 0068:d8fa3e20
---[ end trace e90c885f690f08c3 ]---

with rsync again.

Alex
