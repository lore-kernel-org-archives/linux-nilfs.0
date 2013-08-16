From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Fri, 16 Aug 2013 13:49:34 +0900 (JST)
Message-ID: <20130816.134934.27810145.konishi.ryusuke@lab.ntt.co.jp>
References: <CALJXSJqV5nYb_t6GMS0FpWyf1aRehAgpvebwgbJzMJfctf1b2A@mail.gmail.com>
	<1376054125.2272.84.camel@slavad-ubuntu>
	<20130815.073806.260411879.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130815.073806.260411879.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi Vyachelav,

I haven't yet succeeded to reproduce this issue even with apt-get
update operation.

How long did it take to reproduce this issue in your environment ?

According to reported logs, the crash seems to occur at the following
BUG_ON() which is inlined in nilfs_end_page_io() function:

#define page_buffers(page)                                      \
        ({                                                      \
                BUG_ON(!PagePrivate(page));                     \
                ((struct buffer_head *)page_private(page));     \
        })

However, it's hard to narrow down the cause without reproducing the
issue.  The page private flag is used to indicate that the given page
has buffer heads.  So, this issue seems to be caused by that an
invalid page was passed to nilfs_end_page_io() or
try_to_free_buffers() freed the buffer head by some reason.

The latter situation can occur if the following buffer_busy() function
unexpectedly failed for the buffer head:

static inline int buffer_busy(struct buffer_head *bh)
{
        return atomic_read(&bh->b_count) |
                (bh->b_state & ((1 << BH_Dirty) | (1 << BH_Lock)));
}

Since BH_Dirty is dropped in nilfs_segctor_complete_write() function,
I suspect the situation that bh->b_count mistakenly reached zero.

Anyhow, further debug seems hard without reproducing the issue.


Regards,
Ryusuke Konishi


On Thu, 15 Aug 2013 07:38:06 +0900 (JST), Ryusuke Konishi wrote:
> Hi Vyacheslav,
> On Fri, 09 Aug 2013 17:15:25 +0400, Vyacheslav Dubeyko wrote:
>> Hi Ryusuke,
>> 
>> I am investigating the issue during last two weeks and I think that it
>> is time to share current results and my considerations. I feel necessity
>> to discuss possible reasons of the issue. Maybe, I miss something and it
>> needs to advise me a proper way of the issue investigation.
>> 
>> Actually, I can reproduce the issue by means of way of starting on
>> rootfs compilation task of Linux kernel and apt-get update task in
>> parallel. The issue results in such crash:
> <snip>
> 
>> [  959.874242] NILFS [nilfs_segctor_complete_write]:2224 bh_count 1761
>> [  959.874245] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 22583012, bh->b_size 4096, bh->b_page ffffea00082a9b40
>> [  959.874249] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff880182b97fb8, bh->b_assoc_buffers.prev ffff880209836ad8
>> [  959.874252] NILFS [nilfs_segctor_complete_write]:2227 page->index 22583012, i_ino 3, i_size 0
> 
>> [  959.874255] NILFS [nilfs_segctor_complete_write]:2224 bh_count 1762
>> [  959.874259] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 22583013, bh->b_size 4096, bh->b_page ffffea0005fe3080
>> [  959.874262] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev ffff880209836a70
>> [  959.874266] NILFS [nilfs_segctor_complete_write]:2227 page->index 22583013, i_ino 0, i_size 242770509824
> 
> This block (physical block number = #22583013) looks to be a super
> root block, so the strange i_ino and i_size are, maybe, correct.
> 
>> [  959.874270] NILFS [nilfs_segctor_complete_write]:2224 bh_count 1763
>> [  959.874274] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 22581248, bh->b_size 22583295, bh->b_page 0000000000002b13
>> [  959.874277] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff880182abab40, bh->b_assoc_buffers.prev ffff880182b97fb8
> 
> This looks a list head structure on the head at &segbuf->sb_payload_buffers.
> So, maybe the strange b_blocknr, b_size, b_page, are correct.
> 
> How did you judge the end condition of this loop?
> 
> Is this buffer head actually causing the oops at nilfs_end_page_io() ?
> 
> 
> Regards,
> Ryusuke Konishi
> 
> 
>> It is possible to see that buffer head {page->index 22583013, i_ino 0,
>> i_size 242770509824, nblocks 1766} has #1762 index on complete write
>> phase and namely next item in the list to raise crash because of illegal
>> page address {bh->b_page 0000000000002b13}. But all content of next item
>> is very strange. So, I think that it is not list's memory. But it is
>> more strange that bh->b_assoc_buffers.prev ffff880182b97fb8 of this
>> corrupted item has address that points on previous good item (this item
>> was last in the list). As I can see, item #1762 {page->index 22583013,
>> i_ino 0, i_size 242770509824} has unchanged next and prev pointers
>> {bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev
>> ffff880209836a70}. So, I suspect that we have the reason of the issue
>> somewhere between add payload buffer and complete write phase. But,
>> currently, I haven't clear understanding of the whole picture and the
>> reason of the issue.
>> 
>> I think that it makes sense to try to simplify the issue environment
>> with the purpose to investigate the issue more deeply. But, maybe, you
>> can advise something yet.
>> 
>> Do you have any ideas about the reason of the issue? Could you share
>> your vision of possible reason of the issue? Anyway, I continue
>> investigation of the issue. But, unfortunately, I don't catch the issue
>> reason yet.
>> 
>> With the best regards,
>> Vyacheslav Dubeyko.
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
