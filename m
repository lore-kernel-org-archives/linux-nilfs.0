From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix issue with broken bmap for the case of
 block size lesser than 4 KB
Date: Mon, 29 Apr 2013 13:24:53 +0400
Message-ID: <1367227493.2140.43.camel@slavad-ubuntu>
References: <1366885717.2119.5.camel@slavad-ubuntu>
	 <20130426.013748.27792413.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=W4n16FKcQeyAC/VEeeHQBMQh3XaVvwL9lAGn2Drka7g=;
	b=kw4TBkBdB75ecUh5V/MRI6/WZDfvn/1/cH6N8p0xLAgtFuIOGN90wYyVHaTiPcyD0aeQ/UsHNHxe54ztkicacF7qBq7Af7KPlmIkBETBCXhsAICUE9Qb+YtEq2qVZy1W;
In-Reply-To: <20130426.013748.27792413.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>

Hi Ryusuke,

On Fri, 2013-04-26 at 01:37 +0900, Ryusuke Konishi wrote:

[snip]
> 
> Adding BH_NILFS_Allocated flag looks overkill for this issue.
> 
> Why not modify btree or direct mapping code so that the buffer dirty
> flag is propery set or cleared also for 1 KB block?  Basically, the
> block mapping code of NILFS is designed to be able to handle 1 KB
> block.
> 

My idea is simple. As I can see, usual way of processing page's buffers
in NILFS2 driver is likewise:

struct buffer_head *bh, *head;
bh = head = page_buffers(page);
do {

	/* Do something */

} while (bh = bh->b_this_page, bh != head);

And, as I understand, the essence of the issue is in processing of spare
buffers that were allocated during create_empty_buffers() call but these
buffers shouldn't be used yet. So, from my viewpoint, the reasonable way
of the issue fix is to ignore such spare buffers. Because operations
with spare buffers can be resulted in presence of very sophisticated
bugs and performance degradation. As a result, I suggested to use
BH_NILFS_Allocated flag in this patch.

> If this issue occurs after file size extension with ftruncate(), I
> guess handling of hole blocks created by the extension seems to have
> problem.
> 

The nature of this issue is more complex, as I described in patch. The
ftruncate call is simply beginning of the issue. The peculiarity of this
call for this issue consists in growing file from zero bytes to 60
bytes. So, for 1 KB block size we should use only one block (hole) but,
as a result, we have 4 allocated buffers (1 for hole block and 3 spare
buffers).

[  223.543981] nilfs_truncate:715: blkoff 1, inode->i_size 60
[  223.544068] nilfs_get_block:89: inode->i_ino 21, ii->i_bmap->b_last_allocated_ptr 0
[  223.544079] nilfs_truncate:729: inode->i_ino 21
[  223.544086] Pid: 2424, comm: darcs Tainted: G          I  3.8.0-rc1 #147
[  223.544089] Call Trace:
[  223.544098]  [<ffffffff812e0c77>] nilfs_truncate+0x117/0x130
[  223.544105]  [<ffffffff811516de>] ? truncate_pagecache+0x5e/0x70
[  223.544111]  [<ffffffff812e0d11>] nilfs_setattr+0x81/0xb0
[  223.544119]  [<ffffffff817285b1>] ? mutex_lock_nested+0x2a1/0x370
[  223.544126]  [<ffffffff811bf60b>] notify_change+0x1cb/0x390
[  223.544132]  [<ffffffff811a1290>] do_truncate+0x60/0xa0
[  223.544138]  [<ffffffff811a1644>] sys_ftruncate+0x114/0x180
[  223.544146]  [<ffffffff8139fcae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  223.544152]  [<ffffffff81735119>] system_call_fastpath+0x16/0x1b

Then, it is possible to identify trying to write in file mapping:

[  489.785334] nilfs_page_mkwrite:146: inode->i_ino 21
[  489.785336] Pid: 2447, comm: darcs Tainted: G          I  3.8.0-rc1 #149
[  489.785338] Call Trace:
[  489.785342]  [<ffffffff812e1a55>] nilfs_page_mkwrite+0x315/0x390
[  489.785347]  [<ffffffff81169562>] __do_fault+0xe2/0x4c0
[  489.785351]  [<ffffffff8116c260>] handle_pte_fault+0x90/0x8e0
[  489.785355]  [<ffffffff8101dcc9>] ? sched_clock+0x9/0x10
[  489.785359]  [<ffffffff81098985>] ? sched_clock_local+0x25/0x90
[  489.785363]  [<ffffffff81730644>] ? __do_page_fault+0x114/0x5b0
[  489.785367]  [<ffffffff8116dc85>] handle_mm_fault+0x235/0x330
[  489.785371]  [<ffffffff817306cc>] __do_page_fault+0x19c/0x5b0
[  489.785375]  [<ffffffff81098b18>] ? sched_clock_cpu+0xa8/0x110
[  489.785378]  [<ffffffff810bd9fd>] ? trace_hardirqs_off+0xd/0x10
[  489.785382]  [<ffffffff81098bef>] ? local_clock+0x6f/0x80
[  489.785386]  [<ffffffff810be345>] ? lock_release_holdtime.part.25+0x15/0x1a0
[  489.785390]  [<ffffffff811c1183>] ? __close_fd+0x83/0xb0
[  489.785394]  [<ffffffff8139fe9d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  489.785398]  [<ffffffff81730aee>] do_page_fault+0xe/0x10
[  489.785402]  [<ffffffff8172cc48>] page_fault+0x28/0x30

It is possible to see that after segment construction we have such state
of bmap (namely, it was set two block numbers):

[  490.177923] nilfs_direct_set_ptr: inode: 21
[  490.177925] NILFS2: 00 00 00 00 00 00 00 00 01 14 00 00 00 00 00 00  ................
[  490.177927] NILFS2: 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  490.177929] NILFS2: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  490.177931] NILFS2: 00 00 00 00 00 00 00 00

And, finally, we have issue:

[  490.179790] nilfs_direct_assign: inode: 21
[  490.179800] nilfs_direct_assign: ptr: 5121
[  490.179802] nilfs_dat_prepare_entry:57 req->pr_entry_nr 5121
[  490.179805] nilfs_palloc_get_entry_block:294 nr 5121, create 0
[  490.179815] nilfs_direct_assign: inode: 21
[  490.179828] nilfs_direct_assign: ptr: 10
[  490.179830] nilfs_dat_prepare_entry:57 req->pr_entry_nr 10
[  490.179832] nilfs_palloc_get_entry_block:294 nr 10, create 0
[  490.179843] nilfs_direct_assign: inode: 21
[  490.179857] nilfs_direct_assign: ptr: 0
[  490.179859] nilfs_direct_assign: invalid pointer: 0
[  490.179862] NILFS error (device dm-0): nilfs_bmap_assign: broken bmap (inode number=21)

With the best regards,
Vyacheslav Dubeyko.

> I will look into the issue too.
> 
> 
> Regards,
> Ryusuke Konishi
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
