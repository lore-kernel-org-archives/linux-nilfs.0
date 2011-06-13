From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cleancache
Date: Mon, 13 Jun 2011 19:54:23 +0200
Message-ID: <201106131954.23812.dexen.devries@gmail.com>
References: <20110608.230231.65968027.ryusuke@osrg.net> <201106131521.15372.dexen.devries@gmail.com> <20110613.234048.21322431.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_P7k9N1T7oAKz8L5"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type:message-id;
        bh=Z8VzviRp8htIszcMk/qUAPvYX1xH67VCQ1DIHTLOMCM=;
        b=kZOh5HY19cPYmmU1lSnGrvxKPjCsXreNEx5HeYTk6pi72A8Jb37DIq+fn0pymkxj0+
         01UG5QJB5J62/bWY+ULOlMBR/nyIkwwNNhlVBXCiS/3as8a3w7e86X1h6KjTCBv5pcl7
         caA9/sPgBG33VAURvMTg+EHTWveDt5Pydb/j0=
In-Reply-To: <20110613.234048.21322431.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--Boundary-00=_P7k9N1T7oAKz8L5
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi Ryusuke,


On Monday 13 June 2011 16:40:48 you wrote:
> So, you hit the bug on a raw hadrware.
> In my hardware, /sys/kernel/mm/cleancache/* didn't change.
> 
> Is it reproducible without zcache?
> 
> If not, we should share the steps with zcache.


I think I've got it reproductable. I believe it shouldn't matter whether it's 
bare metal or virtualized OS.

First off, attached is kernel log of the crash. Kernel version is 3.0-rc2 with 
a slight change for zcache -- more on that in next mail.


Steps to reproduce:
1) enable zcache (important details in the next mail)
2) hack NILFS2 to add cleancache (in next mail, again)
3) compile, boot etc.
4) mount NILFS2
5) (important!) read content of some file(s) from NILFS2 (it seems to me 
cleancache currently handles only file data, not metadata; but I may be wrong 
here
6) echo 3 > /proc/sys/vm/drop_caches

As far as I remember, the `echo 3 > /proc/sys/vm/drop_caches' it worked a-OK 
with EXT4 alone. Want me to verify that?


Thanks for your patience ;-)
-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''

--Boundary-00=_P7k9N1T7oAKz8L5
Content-Type: text/plain;
  charset="UTF-8";
  name="nilfs-cleancache-dmesg-fragment.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="nilfs-cleancache-dmesg-fragment.txt"

<1>BUG: unable to handle kernel NULL pointer dereference at           (null)
<1>IP: [<ffffffff81197b17>] nilfs_encode_fh+0x3b/0xc4
<4>PGD 123b20067 PUD 123b18067 PMD 0 
<0>Oops: 0000 [#1] PREEMPT SMP 
<4>CPU 0 
<4>Modules linked in:
<4>
<4>Pid: 933, comm: bash Not tainted 3.0.0-rc2-l28cc_n_t+ #6 Dell Inc. Precision WorkStation T3400  /0TP412
<4>RIP: 0010:[<ffffffff81197b17>]  [<ffffffff81197b17>] nilfs_encode_fh+0x3b/0xc4
<4>RSP: 0018:ffff880122977af8  EFLAGS: 00010046
<4>RAX: 00000000000000ff RBX: ffff880122977b28 RCX: 0000000000000000
<4>RDX: ffff8801254908e0 RSI: 0000000000000006 RDI: 0000000000000000
<4>RBP: ffff880122977b18 R08: ffffffff81197adc R09: ffff880122977cc8
<4>R10: ffffffff810dfafb R11: 0000000000000001 R12: ffff880122977c28
<4>R13: ffff880122977bf4 R14: 0000000000000000 R15: ffff880125490a28
<4>FS:  00007ff682f14720(0000) GS:ffff88012bc00000(0000) knlGS:0000000000000000
<4>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>CR2: 0000000000000000 CR3: 00000001228f6000 CR4: 00000000000006f0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process bash (pid: 933, threadinfo ffff880122976000, task ffff880125b81ea0)
<0>Stack:
<4> ffff880122977c28 0000000000000000 ffffea0003feece8 0000000000000000
<4> ffff880122977bf8 ffffffff810bb3be ffff880122977b58 0000000000000092
<4> ffff880125490de0 ffff880122977b88 ffffea0003f97e50 ffff880122977b78
<0>Call Trace:
<4> [<ffffffff810bb3be>] cleancache_get_key+0x4a/0x67
<4> [<ffffffff810baf47>] ? lookup_page_cgroup+0x31/0x47
<4> [<ffffffff81036a81>] ? get_parent_ip+0x11/0x41
<4> [<ffffffff81036a81>] ? get_parent_ip+0x11/0x41
<4> [<ffffffff81036b43>] ? sub_preempt_count+0x92/0xa5
<4> [<ffffffff810bb52a>] __cleancache_flush_page+0x42/0x75
<4> [<ffffffff810dfafb>] ? free_buffer_head+0x1f/0x60
<4> [<ffffffff81087541>] __delete_from_page_cache+0x6d/0x10a
<4> [<ffffffff81090eef>] __remove_mapping+0xaa/0xdc
<4> [<ffffffff8109140d>] remove_mapping+0x11/0x31
<4> [<ffffffff81090741>] invalidate_inode_page+0x89/0x97
<4> [<ffffffff810907e7>] invalidate_mapping_pages+0x98/0x139
<4> [<ffffffff81036a81>] ? get_parent_ip+0x11/0x41
<4> [<ffffffff81036a81>] ? get_parent_ip+0x11/0x41
<4> [<ffffffff810da980>] ? propagate_umount+0x8a/0x8a
<4> [<ffffffff810daa0c>] drop_pagecache_sb+0x8c/0xde
<4> [<ffffffff810bf6b4>] iterate_supers+0x6d/0xc2
<4> [<ffffffff810daa92>] drop_caches_sysctl_handler+0x34/0x76
<4> [<ffffffff81104066>] proc_sys_call_handler.clone.1+0x81/0xab
<4> [<ffffffff811040a3>] proc_sys_write+0x13/0x15
<4> [<ffffffff810bd275>] vfs_write+0xa7/0xda
<4> [<ffffffff810be32e>] ? fget_light+0x3d/0x9c
<4> [<ffffffff810bd42d>] sys_write+0x45/0x69
<4> [<ffffffff814811bb>] system_call_fastpath+0x16/0x1b
<0>Code: 41 54 49 89 f4 53 41 8b 75 00 48 89 fb 48 8b 57 30 83 fe 04 48 8b 7a f8 0f 86 8d 00 00 00 85 c9 74 09 83 fe 07 0f 86 80 00 00 00 
<48> 8b 07 85 c9 49 89 04 24 48 8b 82 a8 00 00 00 49 89 44 24 08 
<1>RIP  [<ffffffff81197b17>] nilfs_encode_fh+0x3b/0xc4
<4> RSP <ffff880122977af8>
<0>CR2: 0000000000000000
<4>---[ end trace 0d0bfc97f7bb3efc ]---
<6>note: bash[933] exited with preempt_count 1
<3>BUG: scheduling while atomic: bash/933/0x10000002
<4>Modules linked in:
<4>Pid: 933, comm: bash Tainted: G      D     3.0.0-rc2-l28cc_n_t+ #6
<4>Call Trace:
<4> [<ffffffff81034162>] __schedule_bug+0x5a/0x5f
<4> [<ffffffff8147ed7b>] schedule+0x9d/0x4f3
<4> [<ffffffff810d3f22>] ? mntput_no_expire+0x27/0xc8
<4> [<ffffffff8103889b>] __cond_resched+0x13/0x1f
<4> [<ffffffff8147f3ac>] _cond_resched+0x16/0x1d
<4> [<ffffffff810405a9>] put_files_struct+0x78/0xd1
<4> [<ffffffff81040695>] exit_files+0x46/0x4f
<4> [<ffffffff81040bb3>] do_exit+0x22f/0x6b3
<4> [<ffffffff8103eec1>] ? kmsg_dump+0xcc/0xdb
<4> [<ffffffff810054fd>] oops_end+0xb1/0xb9
<4> [<ffffffff81020739>] no_context+0x1f4/0x203
<4> [<ffffffff810208d0>] __bad_area_nosemaphore+0x188/0x1ab
<4> [<ffffffff81020901>] bad_area_nosemaphore+0xe/0x10
<4> [<ffffffff81020c6a>] do_page_fault+0x142/0x31c
<4> [<ffffffff81480dcf>] page_fault+0x1f/0x30
<4> [<ffffffff810dfafb>] ? free_buffer_head+0x1f/0x60
<4> [<ffffffff81197adc>] ? nilfs_fh_to_dentry+0x2b/0x2b
<4> [<ffffffff81197b17>] ? nilfs_encode_fh+0x3b/0xc4
<4> [<ffffffff810bb3be>] cleancache_get_key+0x4a/0x67
<4> [<ffffffff810baf47>] ? lookup_page_cgroup+0x31/0x47
<4> [<ffffffff81036a81>] ? get_parent_ip+0x11/0x41
<4> [<ffffffff81036a81>] ? get_parent_ip+0x11/0x41
<4> [<ffffffff81036b43>] ? sub_preempt_count+0x92/0xa5
<4> [<ffffffff810bb52a>] __cleancache_flush_page+0x42/0x75
<4> [<ffffffff810dfafb>] ? free_buffer_head+0x1f/0x60
<4> [<ffffffff81087541>] __delete_from_page_cache+0x6d/0x10a
<4> [<ffffffff81090eef>] __remove_mapping+0xaa/0xdc
<4> [<ffffffff8109140d>] remove_mapping+0x11/0x31
<4> [<ffffffff81090741>] invalidate_inode_page+0x89/0x97
<4> [<ffffffff810907e7>] invalidate_mapping_pages+0x98/0x139
<4> [<ffffffff81036a81>] ? get_parent_ip+0x11/0x41
<4> [<ffffffff81036a81>] ? get_parent_ip+0x11/0x41
<4> [<ffffffff810da980>] ? propagate_umount+0x8a/0x8a
<4> [<ffffffff810daa0c>] drop_pagecache_sb+0x8c/0xde
<4> [<ffffffff810bf6b4>] iterate_supers+0x6d/0xc2
<4> [<ffffffff810daa92>] drop_caches_sysctl_handler+0x34/0x76
<4> [<ffffffff81104066>] proc_sys_call_handler.clone.1+0x81/0xab
<4> [<ffffffff811040a3>] proc_sys_write+0x13/0x15
<4> [<ffffffff810bd275>] vfs_write+0xa7/0xda
<4> [<ffffffff810be32e>] ? fget_light+0x3d/0x9c
<4> [<ffffffff810bd42d>] sys_write+0x45/0x69
<4> [<ffffffff814811bb>] system_call_fastpath+0x16/0x1b

--Boundary-00=_P7k9N1T7oAKz8L5--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
