From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] [CRITICAL] nilfs2: fix issue with race condition of
 competition between segments for dirty blocks
Date: Thu, 05 Sep 2013 05:35:18 +0900 (JST)
Message-ID: <20130905.053518.235784172.konishi.ryusuke@lab.ntt.co.jp>
References: <1378128464.2327.20.camel@slavad-ubuntu>
	<20130903.031321.52162146.konishi.ryusuke@lab.ntt.co.jp>
	<1378221484.4325.51.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378221484.4325.51.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org, fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org, szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org, Linux-pOR+BrglI3BO41XttqYhMtHuzzzSOjJt@public.gmane.org, zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org, freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Tue, 03 Sep 2013 19:18:04 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> On Tue, 2013-09-03 at 03:13 +0900, Ryusuke Konishi wrote:
>> On Mon, 02 Sep 2013 17:27:44 +0400, Vyacheslav Dubeyko wrote:
>> > From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>> > Subject: [PATCH] [CRITICAL] nilfs2: fix issue with race condition of competition between segments for dirty blocks
>> 
>> Before considering to apply this patch, please confirm that the
>> suspected issue, "dirty buffer_heads are added in several lists of
>> payload_buffers" you pointed out, is actually happening.
>> 
>> The easiest way for this is testing the following patch:
>> 
>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>> index bd88a74..cab38db 100644
>> --- a/fs/nilfs2/segment.c
>> +++ b/fs/nilfs2/segment.c
>> @@ -668,6 +668,7 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
>>  			if (!buffer_dirty(bh))
>>  				continue;
>>  			get_bh(bh);
>> +			BUG_ON(!list_empty(&bh->b_assoc_buffers));
>>  			list_add_tail(&bh->b_assoc_buffers, listp);
>>  			ndirties++;
>>  			if (unlikely(ndirties >= nlimit)) {
>> @@ -701,6 +702,7 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
>>  			do {
>>  				if (buffer_dirty(bh)) {
>>  					get_bh(bh);
>> +					BUG_ON(!list_empty(&bh->b_assoc_buffers));
>>  					list_add_tail(&bh->b_assoc_buffers,
>>  						      listp);
>>  				}
>> 
> 
> Yes, I can confirm the issue. I have applied your patch. And I have such
> output in my syslog after reproducing of the issue:
> 
> [  424.605561] ------------[ cut here ]------------
> [  424.605576] kernel BUG at fs/nilfs2/segment.c:672!
> [  424.605581] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  424.605589] Modules linked in: rfcomm bnep bluetooth parport_pc ppdev snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_pcm xfs snd_seq_midi kvm_amd snd_rawmidi kvm snd_seq_midi_event snd_seq r8712u(C) snd_timer snd_seq_device snd sp5100_tco microcode soundcore k10temp i2c_piix4 lp snd_page_alloc parport mac_hid video ext2 sky2 btrfs raid6_pq xor zlib_deflate libcrc32c
> [  424.605650] CPU: 0 PID: 358 Comm: segctord Tainted: G         C   3.10.0-rc5+ #116
> [  424.605654] Hardware name:    /EDGE-FT1M1 E450, BIOS 4.6.4 11/15/2011
> [  424.605660] task: ffff880208ad22a0 ti: ffff8802085e0000 task.ti: ffff8802085e0000
> [  424.605663] RIP: 0010:[<ffffffff812bff53>]  [<ffffffff812bff53>] nilfs_lookup_dirty_data_buffers.isra.22+0x203/0x270
> [  424.605678] RSP: 0000:ffff8802085e1b08  EFLAGS: 00010293
> [  424.605682] RAX: ffff880219589618 RBX: ffff8802085e1c08 RCX: ffff88022dfb6000
> [  424.605685] RDX: ffff880219589660 RSI: ffff880219589618 RDI: ffff88022dff8aa8
> [  424.605689] RBP: ffff8802085e1be8 R08: 4600000000000000 R09: a8001c7123000000
> [  424.605692] R10: 57ffcd8ee41c48c0 R11: 0000000000000000 R12: 0000000000000000
> [  424.605695] R13: ffffea00071c48c0 R14: 0000000000000000 R15: 0000000000000800
> [  424.605699] FS:  00002aaaaaae3780(0000) GS:ffff880225a00000(0000) knlGS:0000000000000000
> [  424.605703] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  424.605706] CR2: 00007fff2945bff8 CR3: 00000002186f9000 CR4: 00000000000007f0
> [  424.605710] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  424.605713] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  424.605716] Stack:
> [  424.605719]  ffff8802085e1b78 ffff880219177508 ffff8802191773cc ffffffffffffffff
> [  424.605728]  ffff88021a637958 000000000000000e 0000000000000000 ffffea00071c48c0
> [  424.605735]  ffffea00071c4880 ffffea00071c4840 ffffea00071c4800 ffffea00071dd7c0
> [  424.605742] Call Trace:
> [  424.605753]  [<ffffffff812c0050>] nilfs_segctor_scan_file+0x90/0x190
> [  424.605760]  [<ffffffff812c0736>] nilfs_segctor_do_construct+0x596/0x1ba0
> [  424.605767]  [<ffffffff812c2053>] nilfs_segctor_construct+0x183/0x2a0
> [  424.605774]  [<ffffffff812c22b6>] nilfs_segctor_thread+0x146/0x370
> [  424.605781]  [<ffffffff812c2170>] ? nilfs_segctor_construct+0x2a0/0x2a0
> [  424.605788]  [<ffffffff8106bc9d>] kthread+0xed/0x100
> [  424.605794]  [<ffffffff8106bbb0>] ? flush_kthread_worker+0x190/0x190
> [  424.605802]  [<ffffffff816ef2dc>] ret_from_fork+0x7c/0xb0
> [  424.605808]  [<ffffffff8106bbb0>] ? flush_kthread_worker+0x190/0x190
> [  424.605811] Code: ef 8b 08 d3 e6 48 63 f6 e8 2b 3d ef ff e9 19 ff ff ff 85 c0 74 ac 66 90 eb 9c 8b 95 48 ff ff ff 85 d2 75 09 e8 6f 48 42 00 eb ad <0f> 0b 48 8d bd 48 ff ff ff e8 1f 29 e7 ff e8 5a 48 42 00 eb 98 
> [  424.605886] RIP  [<ffffffff812bff53>] nilfs_lookup_dirty_data_buffers.isra.22+0x203/0x270
> [  424.605893]  RSP <ffff8802085e1b08>
> [  424.605900] ---[ end trace 0061903595fb4cff ]---

Thank you for testing the patch.
Ok, let's narrow down the root cause of this issue.

>> You can rewrite the above BUG_ON() check with the following debug code
>> if you want to get detail information on the buffer:
>> 
>>   if (!list_empty(&bh->b_assoc_buffers)) {
>>      /* dump information on bh */
>>   }
>> 
>> As a workaround, we can avoid double registration to different payload
>> lists with list_empty(&bh->b_assoc_buffers) instead of adding
>> BH_async_write flag.
>> 
> 
> Ok. I agree that we need to elaborate another fix if you think that my
> approach is not clear enough.
> 
>> However, I think we should first narrow down the root cause of why the
>> issue "dirty buffer_heads are added in several lists of
>> payload_buffers" happens.
>> 
>> We designed the log writer so that the same buffer is not registered
>> to two different payload buffer lists at the same time.  If it is not
>> satisfied, it's a bug.
>> 
>> What is the root cause of the "double registration" of a buffer head,
>> do you think?
>> 
> 
> I have such understanding of the issue's reason.
> 
> First of all, I am talking about full segments case but not about
> partial segments. As I see, all works fine for partial segments case
> because processing of partial segments of one full segment is located
> inside of one iteration of cycle in nilfs_segctor_do_construct() method.
> 
> So, if we have a file with dirty blocks count is greater than full
> segment size then such dirty file will be processed by means of several
> iterations of cycle in nilfs_segctor_do_construct() method. Also it
> needs to take into account the asynchronous nature of processing of
> submitted bio requests on block layer. The searching of dirty blocks is
> made in nilfs_lookup_dirty_data_buffers() and
> nilfs_lookup_dirty_node_buffers() on the basis of lookup of dirty memory
> pages in pagecache and selecting found dirty buffers. Found dirty blocks
> are added in current segbuf. Then it makes preparation of dirty blocks
> for write operation and submission write requests on block layer. When
> block layer ends processing of some bio then it calls
> nilfs_end_bio_write(). The segctor thread can complete write request in
> nilfs_segctor_complete_write() only after nilfs_end_bio_write() call.
> Processed buffers are made as clean namely in
> nilfs_segctor_complete_write() method. But if we submitted dirty blocks
> of file A in previous iteration and try to process dirty blocks of file
> A in next iteration again without
> nilfs_end_bio_write()/nilfs_segctor_complete_write() pair for previous
> iteration then we will have the issue of "double registration" of a
> buffer head (because we find pages under asynchronous write as dirty
> again).

Usually pages in nilfs are not marked dirty while the log writer is
writing.  ns_segctor_sem is used for this exclusion control.

But, we have an exception -- nilfs_set_page_dirty().

I now suspect the root cause is that nilfs_set_page_dirty() can
asynchronously mark pages dirty on mmapped files.

Can you confirm this assumption by comparing addresses of the
following two page structures ?

1. Address of page structures passed to nilfs_set_page_dirty().
2. bh->b_page of the buffer head captured by the above BUG_ON checks.


Regards,
Ryusuke Konishi


> Maybe I don't clear understand a condition of this issue or NILFS2
> driver's architecture but I can't see another solution for this issue
> yet. I suppose that we need to talk over the issue in more details. What
> do you think?
> 
> You said that the log writer design should prevent from registering of
> buffer in several payload buffer lists. Could you describe this in more
> details?
> 
> With the best regards,
> Vyacheslav Dubeyko.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
