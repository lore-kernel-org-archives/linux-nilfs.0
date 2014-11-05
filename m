From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: remove unnecessary call to nilfs_construct_dsync_segment()
Date: Wed, 05 Nov 2014 18:08:57 +0100
Message-ID: <545A59A9.8090506@gmx.net>
References: <1414861267-13103-1-git-send-email-andreas.rohner@gmx.net>	<20141104.233458.804333886341114381.konishi.ryusuke@lab.ntt.co.jp>	<5458F5BD.2030908@gmx.net> <20141105.090704.583801206386960498.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141105.090704.583801206386960498.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-11-05 01:07, Ryusuke Konishi wrote:
> On Tue, 04 Nov 2014 16:50:21 +0100, Andreas Rohner wrote:
>> On 2014-11-04 15:34, Ryusuke Konishi wrote:
>>> Since each call to nilfs_construct_segment() or
>>> nilfs_construct_dsync_segment() implies an IO completion wait, it
>>> seems that this doubles the latency of fsync().
>>>
>>> Do you really need to call filemap_write_and_wait_range() in
>>> nilfs_sync_file() ?
>>
>> I don't think we need it, but I found the following paragraph in
>> Documentation/filesystems/porting:
>>
>> [mandatory]
>> 	If you have your own ->fsync() you must make sure to call
>> filemap_write_and_wait_range() so that all dirty pages are synced out
>> properly. You must also keep in mind that ->fsync() is not called with
>> i_mutex held anymore, so if you require i_mutex locking you must make
>> sure to take it and release it yourself.
>>
>> So I was unsure, if it is safe to remove it. But maybe I interpreted
>> that wrongly, since nilfs_construct_dsync_segment() and
>> nilfs_construct_segment() write out all dirty pages anyway, there is no
>> need for filemap_write_and_wait_range().
> 
> I found filemap_write_and_wait_range() returns error status of
> already done page I/Os via filemap_check_errors().  We need to
> look into what it does.

I have looked into this a bit. AS_EIO and AS_ENOSPC are asynchronous
error flags, set by the function mapping_set_error(). However I don't
think this is relevant for NILFS2, because it implements its own
writepages() function:

nilfs_sync_file()
   filemap_write_and_wait_range()
      __filemap_fdatawrite_range()
         do_writepages()
            writepages()
               nilfs_writepages()

mapping_set_error() would only be called if NILFS2 would use
generic_writepages() like this:

nilfs_sync_file()
   filemap_write_and_wait_range()
      __filemap_fdatawrite_range()
         do_writepages()
            generic_writepages()

But it doesn't, so we can ignore filemap_check_errors(). Furthermore
NILFS2 doesn't use the generic writeback mechanism of the kernel at all.
It creates its own bio in nilfs_segbuf_submit_bh(), submits the bio with
nilfs_segbuf_submit_bio() and waits for it with nilfs_segbuf_wait() and
records IO-errors in segbuf->sb_err, so there is no need to check AS_EIO
and AS_ENOSPC.

I think filemap_write_and_wait_range() is mostly useful for in place
updates. A copy on write filesystem like NILFS2 doesn't need it. BTRFS
doesn't use it either in its fsync function...

>> Also do we need i_mutex? As far as I can tell all relevant code blocks
>> are wrapped in nilfs_transaction_begin/commit/abort().
> 
> Yes, we may also remove the i_mutex.  We have to confirm what i_mutex
> protects for nilfs.

There are some callback functions which are called with i_mutex already
held, but I can't find documentation about that right now. I'm sure I
saw it somewhere. Anyway I am going to look into this as well.

Regards,
Andreas Rohner

> Regards,
> Ryusuke Konishi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
