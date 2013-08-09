From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Fri, 09 Aug 2013 17:15:25 +0400
Message-ID: <1376054125.2272.84.camel@slavad-ubuntu>
References: <CALJXSJquK6YxGKuH97Ec2CTMyJaZrJjOfePSKtgPDm8_9YXzzw@mail.gmail.com>
	 <CALJXSJoW9Qpp9t42u_k4cW3gO6qzSPoeCjtQDU3tDKq6TJ=K8Q@mail.gmail.com>
	 <F4156394-8A25-4F81-81C3-9921CB00BD92@dubeyko.com>
	 <CALJXSJrj0J_-ZUCOurJXaYhx_wEJwxb2_5OOJjQSSmmP-PQDgg@mail.gmail.com>
	 <1374578141.2226.5.camel@slavad-ubuntu>
	 <CALJXSJrY22eGkYA76wwL4moAdsjV+_PUtvVO6tt5K16hzMh8xQ@mail.gmail.com>
	 <680DC2BF-EEEC-445C-BA5B-DF966CABF1BA@dubeyko.com>
	 <CALJXSJqV5nYb_t6GMS0FpWyf1aRehAgpvebwgbJzMJfctf1b2A@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=ze6MSrnYUojaR4DSFFLoli0AWbgPo4U3FaxHSS9R6Yo=;
	b=KgDtkNcM+IT5GTLkwoCFxvLwGK5QeiqGD7eAXcJO0CnyLLhkZSgJa9P60uGpFhi+dmPAr8vB/L2VMFk+btN8VJK7mya/tR26IGRmyo0z+nmqi7RyaE9jRoG4911HNfjv;
In-Reply-To: <CALJXSJqV5nYb_t6GMS0FpWyf1aRehAgpvebwgbJzMJfctf1b2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?ISO-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ryusuke,

I am investigating the issue during last two weeks and I think that it
is time to share current results and my considerations. I feel necessity
to discuss possible reasons of the issue. Maybe, I miss something and it
needs to advise me a proper way of the issue investigation.

Actually, I can reproduce the issue by means of way of starting on
rootfs compilation task of Linux kernel and apt-get update task in
parallel. The issue results in such crash:

[  220.130662] BUG: unable to handle kernel paging request at 0000000000004612
[  220.130666] IP: [<ffffffff812b55ae>] nilfs_end_page_io+0x3e/0x180

[  220.130574] Call Trace:
[  220.130587]  [<ffffffff816c6b57>] dump_stack+0x19/0x1b
[  220.130593]  [<ffffffff812b5667>] nilfs_end_page_io+0xf7/0x180
[  220.130598]  [<ffffffff812ba2c4>] nilfs_segctor_do_construct+0x1984/0x2410
[  220.130603]  [<ffffffff812bb1f3>] nilfs_segctor_construct+0x1c3/0x450
[  220.130608]  [<ffffffff812bb5da>] nilfs_segctor_thread+0x15a/0x4c0
[  220.130612]  [<ffffffff816cad1f>] ? __schedule+0x3cf/0x810
[  220.130617]  [<ffffffff812bb480>] ? nilfs_segctor_construct+0x450/0x450
[  220.130622]  [<ffffffff81069760>] kthread+0xc0/0xd0
[  220.130626]  [<ffffffff810696a0>] ? flush_kthread_worker+0xb0/0xb0
[  220.130631]  [<ffffffff816d519c>] ret_from_fork+0x7c/0xb0
[  220.130635]  [<ffffffff810696a0>] ? flush_kthread_worker+0xb0/0xb0

I suppose that I haven't clear picture of the issue, currently. But I
have some steady reproducible results of the issue investigation.

As I can see, the issue is reproduced in the case of writing on volume
many blocks of a big file (for example, 1518 blocks) with mixture in the
buffer heads chain some count of another small files' blocks. Usually,
the issue takes place for a buffer heads chain that contains about 1500
- 2000 blocks.

I have such picture on the phase of adding of payload buffers:

[  959.803987] NILFS [nilfs_segbuf_add_payload_buffer]:167 page->index 22579166, i_ino 3, i_size 0, nblocks 1762
[  959.803990] NILFS [nilfs_segbuf_add_payload_buffer]:168 bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev ffff880209838a08
[  959.803993] NILFS [nilfs_segctor_apply_buffers]:1158 listp ffff880220345ba8, listp->prev ffff880209836a70, listp->next ffff880209839ad8
[  959.803997] NILFS [nilfs_segctor_apply_buffers]:1159 bh->b_blocknr 22579166, bh->b_size 4096, bh->b_page ffffea000895db40
[  959.804000] NILFS [nilfs_segctor_apply_buffers]:1160 bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev ffff880209838a08
[  959.804006] NILFS [nilfs_segbuf_add_payload_buffer]:167 page->index 22579167, i_ino 3, i_size 0, nblocks 1763
[  959.804009] NILFS [nilfs_segbuf_add_payload_buffer]:168 bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev ffff8802267aac78
[  959.804013] NILFS [nilfs_segctor_apply_buffers]:1158 listp ffff880220345ba8, listp->prev ffff880209836a70, listp->next ffff880209836ad8
[  959.804016] NILFS [nilfs_segctor_apply_buffers]:1159 bh->b_blocknr 22579167, bh->b_size 4096, bh->b_page ffffea00082b73c0
[  959.804025] NILFS [nilfs_segbuf_add_payload_buffer]:167 page->index 22579168, i_ino 3, i_size 0, nblocks 1764
[  959.804028] NILFS [nilfs_segbuf_add_payload_buffer]:168 bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev ffff880209839ad8
[  959.804032] NILFS [nilfs_segctor_apply_buffers]:1158 listp ffff880220345ba8, listp->prev ffff880209836a70, listp->next ffff880209836a70
[  959.804035] NILFS [nilfs_segctor_apply_buffers]:1159 bh->b_blocknr 22579168, bh->b_size 4096, bh->b_page ffffea00082afc00
[  959.804044] NILFS [nilfs_segbuf_add_payload_buffer]:167 page->index 22579169, i_ino 3, i_size 0, nblocks 1765
[  959.804047] NILFS [nilfs_segbuf_add_payload_buffer]:168 bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev ffff880209836ad8
[  959.804051] NILFS [nilfs_segctor_apply_buffers]:1158 listp ffff880220345ba8, listp->prev ffff880220345ba8, listp->next ffff880220345ba8
[  959.804054] NILFS [nilfs_segctor_apply_buffers]:1159 bh->b_blocknr 22579169, bh->b_size 4096, bh->b_page ffffea00082a9b40
[  959.804058] NILFS [nilfs_segctor_apply_buffers]:1160 bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev ffff880209836ad8
[  959.804092] NILFS [nilfs_segbuf_add_payload_buffer]:167 page->index 22583013, i_ino 0, i_size 242770509824, nblocks 1766
[  959.804096] NILFS [nilfs_segbuf_add_payload_buffer]:168 bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev ffff880209836a70

It is possible to see that:
(1) It was added 1766 blocks in list.
(2) The last blocks are blocks of inode (ino = 3): #1762, #1763, #1764,
#1765.
(3) The last buffer head has next pointer ffff8802247e3af8 that is
pointed on first buffer head in list (as I understand).

But on the stage of complete write we have such picture:

[  959.848722] NILFS [nilfs_segctor_complete_write]:2224 bh_count 1
[  959.848735] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 21394345, bh->b_size 4096, bh->b_page ffffea00076ffd80
[  959.848739] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff88021de434c0, bh->b_assoc_buffers.prev ffff8802247e3828
[  959.848744] NILFS [nilfs_segctor_complete_write]:2227 page->index 12, i_ino 1005398, i_size 77824
[  959.848752] NILFS [nilfs_segctor_complete_write]:2224 bh_count 2
[  959.848756] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 21394887, bh->b_size 4096, bh->b_page ffffea00078db900
[  959.848759] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff88021de10048, bh->b_assoc_buffers.prev ffff88021de42048
[  959.848763] NILFS [nilfs_segctor_complete_write]:2227 page->index 13, i_ino 1005398, i_size 77824
[  959.848771] NILFS [nilfs_segctor_complete_write]:2224 bh_count 3
[  959.848774] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 50231152, bh->b_size 4096, bh->b_page ffffea000889ae80
[  959.848778] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff880182abab40, bh->b_assoc_buffers.prev ffff88021de434c0
[  959.848782] NILFS [nilfs_segctor_complete_write]:2227 page->index 50231152, i_ino 1005398, i_size 77824

[............................................................................................................................................]

[  959.874242] NILFS [nilfs_segctor_complete_write]:2224 bh_count 1761
[  959.874245] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 22583012, bh->b_size 4096, bh->b_page ffffea00082a9b40
[  959.874249] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff880182b97fb8, bh->b_assoc_buffers.prev ffff880209836ad8
[  959.874252] NILFS [nilfs_segctor_complete_write]:2227 page->index 22583012, i_ino 3, i_size 0
[  959.874255] NILFS [nilfs_segctor_complete_write]:2224 bh_count 1762
[  959.874259] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 22583013, bh->b_size 4096, bh->b_page ffffea0005fe3080
[  959.874262] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev ffff880209836a70
[  959.874266] NILFS [nilfs_segctor_complete_write]:2227 page->index 22583013, i_ino 0, i_size 242770509824
[  959.874270] NILFS [nilfs_segctor_complete_write]:2224 bh_count 1763
[  959.874274] NILFS [nilfs_segctor_complete_write]:2225 bh->b_blocknr 22581248, bh->b_size 22583295, bh->b_page 0000000000002b13
[  959.874277] NILFS [nilfs_segctor_complete_write]:2226 bh->b_assoc_buffers.next ffff880182abab40, bh->b_assoc_buffers.prev ffff880182b97fb8


It is possible to see that buffer head {page->index 22583013, i_ino 0,
i_size 242770509824, nblocks 1766} has #1762 index on complete write
phase and namely next item in the list to raise crash because of illegal
page address {bh->b_page 0000000000002b13}. But all content of next item
is very strange. So, I think that it is not list's memory. But it is
more strange that bh->b_assoc_buffers.prev ffff880182b97fb8 of this
corrupted item has address that points on previous good item (this item
was last in the list). As I can see, item #1762 {page->index 22583013,
i_ino 0, i_size 242770509824} has unchanged next and prev pointers
{bh->b_assoc_buffers.next ffff8802247e3af8, bh->b_assoc_buffers.prev
ffff880209836a70}. So, I suspect that we have the reason of the issue
somewhere between add payload buffer and complete write phase. But,
currently, I haven't clear understanding of the whole picture and the
reason of the issue.

I think that it makes sense to try to simplify the issue environment
with the purpose to investigate the issue more deeply. But, maybe, you
can advise something yet.

Do you have any ideas about the reason of the issue? Could you share
your vision of possible reason of the issue? Anyway, I continue
investigation of the issue. But, unfortunately, I don't catch the issue
reason yet.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
