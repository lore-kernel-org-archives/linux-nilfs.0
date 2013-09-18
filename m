From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] [CRITICAL] nilfs2: fix issue with race condition of
 competition between segments for dirty blocks
Date: Thu, 19 Sep 2013 03:09:10 +0900 (JST)
Message-ID: <20130919.030910.27786580.konishi.ryusuke@lab.ntt.co.jp>
References: <1378221484.4325.51.camel@slavad-ubuntu>
	<20130905.053518.235784172.konishi.ryusuke@lab.ntt.co.jp>
	<1378395778.2299.10.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1378395778.2299.10.camel@slavad-ubuntu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jeromepoulin@gmail.com, devel@antoneliasson.se, fercerpav@gmail.com, hermes@ceres.dti.ne.jp, szarpaj@grubelek.pl, Linux@riotingpacifist.net, zahid.chowdhury@starsolutions.com, freeboy6716@gmail.com, klangga@gmail.com, akpm@linux-foundation.org

Hi Vyacheslav,
On Thu, 05 Sep 2013 19:42:58 +0400, Vyacheslav Dubeyko wrote:
> On Thu, 2013-09-05 at 05:35 +0900, Ryusuke Konishi wrote:
> 
>> Usually pages in nilfs are not marked dirty while the log writer is
>> writing.  ns_segctor_sem is used for this exclusion control.
>> 
>> But, we have an exception -- nilfs_set_page_dirty().
>> 
>> I now suspect the root cause is that nilfs_set_page_dirty() can
>> asynchronously mark pages dirty on mmapped files.
>> 
>> Can you confirm this assumption by comparing addresses of the
>> following two page structures ?
>> 
>> 1. Address of page structures passed to nilfs_set_page_dirty().
>> 2. bh->b_page of the buffer head captured by the above BUG_ON checks.
>> 
> 
> So, I have such output in my syslog:
> 
> [  257.825054] NILFS [nilfs_set_page_dirty]:225 page ffffea000687d680
> [  257.825072] NILFS [nilfs_set_page_dirty]:225 page ffffea000687d680
> [  257.855659] NILFS [nilfs_set_page_dirty]:225 page ffffea000687d680
> [  258.115918] NILFS [nilfs_set_page_dirty]:225 page ffffea000687d680
> [  258.622433] NILFS [nilfs_set_page_dirty]:225 page ffffea000687d680
> [  258.622433] NILFS [nilfs_set_page_dirty]:225 page ffffea000687d680
> [  258.643247] NILFS [nilfs_lookup_dirty_data_buffers]:673 bh->b_page ffffea000687d680, bh->b_blocknr 0
> [  258.643290] ------------[ cut here ]------------
> [  258.643294] kernel BUG at fs/nilfs2/segment.c:676!
> 
> And I can see such call trace for the case of nilfs_set_page_dirty()
> call:
> 
> [  441.538563] Call Trace:
> [  441.538568]  [<ffffffff816df345>] dump_stack+0x19/0x1b
> [  441.538574]  [<ffffffff812ae1cc>] nilfs_set_page_dirty+0x1c/0xa0
> [  441.538579]  [<ffffffff8112e75e>] set_page_dirty+0x3e/0x60
> [  441.538584]  [<ffffffff8112e838>] clear_page_dirty_for_io+0xb8/0xc0
> [  441.538589]  [<ffffffff812c01d9>] nilfs_begin_page_io.part.24+0x29/0x50
> [  441.538595]  [<ffffffff812c0e6c>] nilfs_segctor_do_construct+0xc6c/0x1ba0
> [  441.538601]  [<ffffffff812c20b3>] nilfs_segctor_construct+0x183/0x2a0
> [  441.538607]  [<ffffffff812c2316>] nilfs_segctor_thread+0x146/0x370
> [  441.538613]  [<ffffffff812c21d0>] ? nilfs_segctor_construct+0x2a0/0x2a0
> [  441.538617]  [<ffffffff8106bc9d>] kthread+0xed/0x100
> [  441.538623]  [<ffffffff8106bbb0>] ? flush_kthread_worker+0x190/0x190
> [  441.538628]  [<ffffffff816ef35c>] ret_from_fork+0x7c/0xb0
> [  441.538633]  [<ffffffff8106bbb0>] ? flush_kthread_worker+0x190/0x190
> 
> So, as I understand, segctor thread calls nilfs_set_page_dirty() on the
> segment construction phase by itself.

So, nilfs_set_page_dirty() turned out to make some buffers dirty
asynchronously and cause the issue as I predicted.

I looked again at nilfs_set_page_dirty().  This function implements
aops->set_page_dirty(), and is called from several callers.

When this function is called, the page is locked, but it is not
guaranteed that ns_segctor_sem is locked, and this restriction is
unavoidable.  If all callers wait on page writeback flag just before
calling aops->set_page_dirty, the problem doesn't arise, but this is
not satisfied, either.

We can change nilfs_set_page_dirty() not to make the given page dirty
if its page writeback flag is set.  But this approach doesn't work
properly when a page has multiple buffers and was partially dirtied.

So, I reached a conclusion that simply skipping reentry of buffer
heads to the payload list of log writer is better approach at present.
Your patch looks proper from this standpoint.


Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>


Vyacheslav, could you please test your patch for 1KB-block format to
make sure ?


Thanks,
Ryusuke Konishi
