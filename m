From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Kernel Bug while deleting files (with rsync)
Date: Tue, 25 Mar 2008 20:45:20 +0900
Message-ID: <1206445521.3131.60.camel@localhost.localdomain>
References: <20080325102553.GA10853@laxu.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080325102553.GA10853-W0ZHf6uU1cg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi Alex,

On Tue, 2008-03-25 at 11:25 +0100, Alexander Schier wrote:
> kernel BUG at /home/allo/nilfs-2.0.0/fs/page.c:436!
> invalid opcode: 0000 [#1] PREEMPT 
> Modules linked in: nilfs2 sha256_generic aes_i586 aes_generic cbc blkcipher nfsd exportfs ipv6 nfs lockd sunrpc dm_crypt dm_mod analog gameport parport_pc parport snd_intel8x0 snd_ac97_codec ehci_hcd ohci_hcd uhci_hcd ac97_bus snd_pcm snd_timer snd snd_page_alloc usbcore
> 
> Pid: 2456, comm: rsync Not tainted (2.6.24.2 #2)
> EIP: 0060:[<e0e58cff>] EFLAGS: 00010246 CPU: 0
> EIP is at nilfs_free_buffer_page+0x29/0x32 [nilfs2]
> EAX: 00000000 EBX: c1366360 ECX: d6b161a4 EDX: cfc71e48
> ESI: c1366360 EDI: 00000001 EBP: d6b14334 ESP: cfc71e58
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process rsync (pid: 2456, ti=cfc70000 task=ddcabaa0 task.ti=cfc70000)
> Stack: 00000001 e0e5a207 c1366360 00000001 00000001 e0e5aa0a 00000010 c1366360 
>        00000004 00000000 00000000 00000005 00000000 00081088 00000000 00081089 
>        00000000 0008108a 00000000 0008108b 00000000 00000000 00000000 00081090 
> Call Trace:
>  [<e0e5a207>] nilfs_btnode_delete_page+0x27/0x2d [nilfs2]
>  [<e0e5aa0a>] nilfs_btnode_cache_clear+0x7e/0x91 [nilfs2]
>  [<e0e58380>] nilfs_clear_inode+0x87/0x9a [nilfs2]
>  [<c0176ca3>] clear_inode+0x6c/0xba
>  [<e0e556e5>] nilfs_free_inode+0x17/0x28 [nilfs2]
>  [<e0e55959>] nilfs_delete_inode+0xd0/0x10f [nilfs2]
>  [<c0175d23>] d_delete+0x5d/0xe3
>  [<e0e55889>] nilfs_delete_inode+0x0/0x10f [nilfs2]
>  [<c0177122>] generic_delete_inode+0x71/0xee
>  [<c0176636>] iput+0x60/0x62
>  [<c016e80e>] do_unlinkat+0xbe/0xfe
>  [<c01656b1>] vfs_write+0x114/0x124
>  [<c0165763>] sys_write+0x41/0x67
>  [<c0103e4e>] syscall_call+0x7/0xb
>  =======================
> Code: 2f df 53 89 c3 8b 00 a8 01 75 04 0f 0b eb fe 83 7b 10 00 74 04 0f 0b eb fe 8b 03 f6 c4 08 74 0f 89 d8 e8 33 9a 32 df 85 c0 75 04 <0f> 0b eb fe 89 d8 5b eb bc 55 57 56 53 83 ec 20 85 c0 c7 44 24 
> EIP: [<e0e58cff>] nilfs_free_buffer_page+0x29/0x32 [nilfs2] SS:ESP 0068:cfc71e58
> ---[ end trace bdf0e0f308ae752d ]---
> 
> Yes, its 2.0.0 because of the 2.0.1 incompatiblity. If its in 2.0.1 fixed, disregard this ;).
> 
> Alex

Whoa, it seems to be a new bug!
This one seems rather tough. :(

OK, I'll review it before releasing the version 2.0.2.
Anyway, thanks for sending the log.

Regards,
-- 
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
