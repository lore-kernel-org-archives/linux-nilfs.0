From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: remove unnecessary call to nilfs_construct_dsync_segment()
Date: Tue, 11 Nov 2014 22:19:56 +0100
Message-ID: <54627D7C.3010400@gmx.net>
References: <5458F5BD.2030908@gmx.net>	<20141105.090704.583801206386960498.konishi.ryusuke@lab.ntt.co.jp>	<545A59A9.8090506@gmx.net> <20141112.015839.1565017343097841658.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141112.015839.1565017343097841658.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-11-11 17:58, Ryusuke Konishi wrote:
> On Wed, 05 Nov 2014 18:08:57 +0100, Andreas Rohner wrote:
>> On 2014-11-05 01:07, Ryusuke Konishi wrote:
>>> On Tue, 04 Nov 2014 16:50:21 +0100, Andreas Rohner wrote:
>>>
>>> I found filemap_write_and_wait_range() returns error status of
>>> already done page I/Os via filemap_check_errors().  We need to
>>> look into what it does.
>>
>> I have looked into this a bit. AS_EIO and AS_ENOSPC are asynchronous
>> error flags, set by the function mapping_set_error(). However I don't
>> think this is relevant for NILFS2, because it implements its own
>> writepages() function:
>>
>> nilfs_sync_file()
>>    filemap_write_and_wait_range()
>>       __filemap_fdatawrite_range()
>>          do_writepages()
>>             writepages()
>>                nilfs_writepages()
>>
>> mapping_set_error() would only be called if NILFS2 would use
>> generic_writepages() like this:
>>
>> nilfs_sync_file()
>>    filemap_write_and_wait_range()
>>       __filemap_fdatawrite_range()
>>          do_writepages()
>>             generic_writepages()
>>
>> But it doesn't, so we can ignore filemap_check_errors(). Furthermore
>> NILFS2 doesn't use the generic writeback mechanism of the kernel at all.
>> It creates its own bio in nilfs_segbuf_submit_bh(), submits the bio with
>> nilfs_segbuf_submit_bio() and waits for it with nilfs_segbuf_wait() and
>> records IO-errors in segbuf->sb_err, so there is no need to check AS_EIO
>> and AS_ENOSPC.
>>
>> I think filemap_write_and_wait_range() is mostly useful for in place
>> updates. A copy on write filesystem like NILFS2 doesn't need it. BTRFS
>> doesn't use it either in its fsync function...
> 
> OK.  I confirmed the current NILFS2 doesn't need to check AS_EIO and
> AS_ENOSPC because NILFS2 doesn't evict erroneous pages from the page
> cache; NILFS2 tries to keep such pages until they will be successfully
> written back to disk.  Therefore it can detect error of already
> finished page-IOs without calling filemap_fdatawait_range() or
> filemap_check_errors().
> 
> On the other hand, regular filesystems need to these functions in
> fsync() because they will clear the dirty flags of pages and buffers
> even if the writeback failed due to an IO error or a disk full error.
> Without AS_EIO and AS_ENOSPC check, fsync() of these filesystems
> can miss the errors.

So it is necessary to catch the errors that happened before the call to
fsync() and if the pages are not redirtied, the errors could be missed.
I didn't know that.

> However this design policy of NILFS2 has a defect that the system
> easily falls into a memory shortage with too many dirty pages when
> I/O errors will block.
>
> If we would introduce a simliar logic to NILFS2, it will need the
> following changes:
> 
>  - nilfs_abort_logs() and nilfs_end_page_io() are changed so that they
>    call mapping_set_error() instead of redirtying data pages on error.
> 
>  - nilfs_sync_file() will be also changed so that it first calls
>    filemap_fdatawait_range() and catches errors previously happened.

I don't know if I fully understand the problem. So I may be completely
wrong here.

But if there is only one bad sector somewhere, which causes an I/O
Error, you could potentially lose the data from a whole segment and
there would possibly be data loss all over the file system. There could
also be inconsistent metadata, because the metadata files would also
lose data.

NILFS has a good chance of recovering from an I/O error, because it will
mark the segment with nilfs_sufile_set_error() and write the pages to a
different segment. Isn't that worth the extra memory?

Best regards,
Andreas Rohner

> Regards,
> Ryusuke Konishi
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
