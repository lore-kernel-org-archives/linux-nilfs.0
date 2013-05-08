From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] nilfs2: fix issue of nilfs_set_page_dirty for page at
 EOF boundary
Date: Wed, 08 May 2013 17:45:36 +0900 (JST)
Message-ID: <20130508.174536.492726450.konishi.ryusuke@lab.ntt.co.jp>
References: <20130501.163930.56348973.konishi.ryusuke@lab.ntt.co.jp>
	<20130507133835.625d694a3eca7f5b6c83c0ba@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130507133835.625d694a3eca7f5b6c83c0ba@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Anthony Doggett <Anthony2486@interfaces.org.uk>

On Tue, 7 May 2013 13:38:35 -0700, Andrew Morton wrote:
> On Wed, 01 May 2013 16:39:30 +0900 (JST) Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:
> 
>> DESCRIPTION:
>> There are use-cases when NILFS2 file system (formatted with block size
>> lesser than 4 KB) can be remounted in RO mode because of encountering
>> of "broken bmap" issue.
>> 
>> ...
>>
>> --- a/fs/nilfs2/inode.c
>> +++ b/fs/nilfs2/inode.c
>> @@ -219,13 +219,25 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
>>  
>>  static int nilfs_set_page_dirty(struct page *page)
>>  {
>> -	int ret = __set_page_dirty_buffers(page);
>> +	int ret = __set_page_dirty_nobuffers(page);
>>  
>> -	if (ret) {
>> +	if (page_has_buffers(page)) {
>>  		struct inode *inode = page->mapping->host;
>> -		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
>> +		unsigned nr_dirty = 0;
>> +		struct buffer_head *bh, *head;
>>  
>> -		nilfs_set_file_dirty(inode, nr_dirty);
>> +		bh = head = page_buffers(page);
>> +		do {
>> +			/* Do not mark hole blocks dirty */
>> +			if (!buffer_dirty(bh) || !buffer_mapped(bh))
>> +				continue;
>> +
>> +			set_buffer_dirty(bh);
> 
> This doesn't seem right.  The only time we will run set_buffer_dirty()
> is if the buffer was dirty and mapped.  What's the point in running
> set_buffer_dirty() against an already dirty buffer?
> 
> I suspect you intended (buffer_dirty || !buffer_mapped)

Yes, sorry, this is my mistake.
I'll correct it and redo tests.

>> +			nr_dirty++;
>> +		} while (bh = bh->b_this_page, bh != head);
>> +
>> +		if (nr_dirty)
>> +			nilfs_set_file_dirty(inode, nr_dirty);
> 
> Rather secondarily: the above code appears to assume that no other
> thread can come in and mark a buffer dirty while the loop is executing.
>  This *should* be OK - the page is locked (or it should be).  Can you
> confirm that this is the case?  There are no other places where a
> buffer can be concurrently dirtied against an unlocked page?

Yes, I confirmed no other thread concurrently marks the above buffer
dirty.

The nilfs_page_set_dirty function is called only for data blocks of
regular files, directory data, or symlinks.

And, nilfs only dirties this type of buffers through routines in
fs/buffer.c.  Every routine in fs/buffer.c that can be called from
nilfs, was protecting call sites of mark_buffer_dirty() by page lock.

I'll add a comment to brief this assumption.

Thanks,
Ryusuke Konishi

>>  	}
>>  	return ret;
>>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
