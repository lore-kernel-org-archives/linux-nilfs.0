From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Thu, 15 Aug 2013 07:38:06 +0900 (JST)
Message-ID: <20130815.073806.260411879.konishi.ryusuke@lab.ntt.co.jp>
References: <680DC2BF-EEEC-445C-BA5B-DF966CABF1BA@dubeyko.com>
	<CALJXSJqV5nYb_t6GMS0FpWyf1aRehAgpvebwgbJzMJfctf1b2A@mail.gmail.com>
	<1376054125.2272.84.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376054125.2272.84.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi Vyacheslav,
On Fri, 09 Aug 2013 17:15:25 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> I am investigating the issue during last two weeks and I think that it
> is time to share current results and my considerations. I feel necessity
> to discuss possible reasons of the issue. Maybe, I miss something and it
> needs to advise me a proper way of the issue investigation.
> 
> Actually, I can reproduce the issue by means of way of starting on
> rootfs compilation task of Linux kernel and apt-get update task in
> parallel. The issue results in such crash:
<snip>

> [  959.874242] NILFS [nilfs_segctor_complete_write]:2224 bh_count 1761
> [  959.874245] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 22583012, bh->b_size 4096, bh->b_page ffffea00082a9b40
> [  959.874249] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff880182b97fb8, bh->b_assoc_buffers.prev ffff880209836ad8
> [  959.874252] NILFS [nilfs_segctor_complete_write]:2227 page->index 22583012, i_ino 3, i_size 0

> [  959.874255] NILFS [nilfs_segctor_complete_write]:2224 bh_count 1762
> [  959.874259] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 22583013, bh->b_size 4096, bh->b_page ffffea0005fe3080
> [  959.874262] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev ffff880209836a70
> [  959.874266] NILFS [nilfs_segctor_complete_write]:2227 page->index 22583013, i_ino 0, i_size 242770509824

This block (physical block number = #22583013) looks to be a super
root block, so the strange i_ino and i_size are, maybe, correct.

> [  959.874270] NILFS [nilfs_segctor_complete_write]:2224 bh_count 1763
> [  959.874274] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 22581248, bh->b_size 22583295, bh->b_page 0000000000002b13
> [  959.874277] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff880182abab40, bh->b_assoc_buffers.prev ffff880182b97fb8

This looks a list head structure on the head at &segbuf->sb_payload_buffers.
So, maybe the strange b_blocknr, b_size, b_page, are correct.

How did you judge the end condition of this loop?

Is this buffer head actually causing the oops at nilfs_end_page_io() ?


Regards,
Ryusuke Konishi


> It is possible to see that buffer head {page->index 22583013, i_ino 0,
> i_size 242770509824, nblocks 1766} has #1762 index on complete write
> phase and namely next item in the list to raise crash because of illegal
> page address {bh->b_page 0000000000002b13}. But all content of next item
> is very strange. So, I think that it is not list's memory. But it is
> more strange that bh->b_assoc_buffers.prev ffff880182b97fb8 of this
> corrupted item has address that points on previous good item (this item
> was last in the list). As I can see, item #1762 {page->index 22583013,
> i_ino 0, i_size 242770509824} has unchanged next and prev pointers
> {bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev
> ffff880209836a70}. So, I suspect that we have the reason of the issue
> somewhere between add payload buffer and complete write phase. But,
> currently, I haven't clear understanding of the whole picture and the
> reason of the issue.
> 
> I think that it makes sense to try to simplify the issue environment
> with the purpose to investigate the issue more deeply. But, maybe, you
> can advise something yet.
> 
> Do you have any ideas about the reason of the issue? Could you share
> your vision of possible reason of the issue? Anyway, I continue
> investigation of the issue. But, unfortunately, I don't catch the issue
> reason yet.
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
