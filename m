From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v10 00/62] Convert page cache to XArray
Date: Thu, 5 Apr 2018 11:33:29 -0700
Message-ID: <e2b37818-53bf-8e38-82c5-d05ac2804420@oracle.com>
References: <20180330034245.10462-1-willy@infradead.org>
 <ff6a317f-920b-62c7-9a7a-9bf235371d41@oracle.com>
 <20180405035200.GE9301@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=3mtZkYbFpTMipN8/0/O4BZDhujg+du8qI7WBQZeU3YQ=; b=JV1f+LEZgJxxPLiLw1AQpaoo/z
 s99FWZqTzHWIOJhOXd0wLzvOmY7L6GGb4ATYgET+vckE7wN2WJtNpxTJi2iof48a92ESfGiYEDhgC
 o5M3suXYfq21w6Ump7ifMDLTZh62J34j1QR8zcbLvhXjroKaQeUjNePYcrI8ZxnOGhE4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
 Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=3mtZkYbFpTMipN8/0/O4BZDhujg+du8qI7WBQZeU3YQ=; b=nFs7XNI0zSMzXyIzzxD1f4X2LN
 2M4ooavjYUwLQ+IBtusDkva8MctQXMR6BoU92SJ4NzCH94PfmLAgCKRZSXdAagEd0ocXHYsTQtz4J
 fk7leMkuMrM02K0XWYPiq99A5HAX7126s0QeVcDKDTl6KPRk4YCXOH692oekO3T8oJKk=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2017-10-26;
 bh=3mtZkYbFpTMipN8/0/O4BZDhujg+du8qI7WBQZeU3YQ=;
 b=k5P4BRZs3CnwbKwNiA717ERw2f2uPfhUQLscmwL5KI+JzaJC8oxHxxnp+Y78puBAwIiy
 hQZJ/WQfeyQuyskQcmAqLU/Q5NQdyGjpQuB1nub4CeU394mDV2dNV8V48gT4ipdGHgt/
 Qcr7OfgtYRU4P61G38MVA+8Cq3/bjHaDNa4jIDJQCsgpO1M2Q36PwTOmtnvaN0NGSSe3
 8LcHH8RmVMHNSPCoHm/uT+1y+yCCUH4dDxfpZxYF2OzGiVz/OvaZlWRyt8sPa8yQNNyl
 1LD+ntkxxKiKCtfo+ON78XszT7kAb/TbYIoWI5RrZvtBtNZ5h1NMda5PojuNpHoUF+sQ gA== 
In-Reply-To: <20180405035200.GE9301@bombadil.infradead.org>
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

On 04/04/2018 08:52 PM, Matthew Wilcox wrote:
> On Wed, Apr 04, 2018 at 09:35:46AM -0700, Mike Kravetz wrote:
>> Running with this XArray series on top of next-20180329 consistently 'hangs'
>> on shutdown looping (?forever?) in tag_pages_for_writeback/xas_for_each_tag.
>> All I have to do is make sure there is some activity on the ext4 fs before
>> shutdown.  Not sure if this is a 'next-20180329' issue or XArray issue.
>> But the fact that we are looping in xas_for_each_tag looks suspicious.
> 
> Thanks for your help debugging this!  Particularly collecting the xa_dump.
> I got bit by the undefined behaviour of shifting by BITS_PER_LONG,
> but of course it was subtle.
> 
> The userspace testing framework wasn't catching this for a couple of
> reasons; I'll work on making sure it catches this kind of thing in
> the future.
> 
> I'll fold this in and post a v11 later this week or early next week.

Nice!  Added patch and it solves the hangs I observed.

-- 
Mike Kravetz

> 
> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index eac04922eba2..f5b7e507a86f 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -904,9 +929,12 @@ static inline unsigned int xas_find_chunk(struct xa_state *xas, bool advance,
>  	if (advance)
>  		offset++;
>  	if (XA_CHUNK_SIZE == BITS_PER_LONG) {
> -		unsigned long data = *addr & (~0UL << offset);
> -		if (data)
> -			return __ffs(data);
> +		if (offset < XA_CHUNK_SIZE) {
> +			unsigned long data = *addr & (~0UL << offset);
> +
> +			if (data)
> +				return __ffs(data);
> +		}
>  		return XA_CHUNK_SIZE;
>  	}
>  
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
