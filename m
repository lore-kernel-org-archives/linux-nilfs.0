From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v11 00/63] Convert page cache to XArray
Date: Thu, 31 May 2018 15:53:29 -0600
Message-ID: <20180531215329.GG28256@linux.intel.com>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180416160133.GA12434@linux.intel.com>
 <20180531213643.GD28256@linux.intel.com>
 <20180531213742.GE28256@linux.intel.com>
 <20180531214612.GA12216@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=SSIqY+c4rmpO57L2t53YXD4ZAq9CLoYA8rhmJn4RcEU=; b=JaixCaBaUBVLKFog0483DoVk61
 npexsjhWnrHFAmoV8CPTP26WBP2Kwaf6p3529OcqN0SagNi42CxM29VhM8nMvDpucuIlA/bCsQbZ4
 YbXVlJDpNjxIQgUuWd5bF8NwcFtmFRN/ExwSD5SXQukAoLAiM8fcAH6HLHFyaBjMZ7wA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=SSIqY+c4rmpO57L2t53YXD4ZAq9CLoYA8rhmJn4RcEU=; b=SqSKhRMTItTcM+LuebluK/jLS9
 uJqqLkDVBefTHuzWZn4aUnOSLUZlcasnICSyB9OTfkeb5uSmdwFAcG+nRvt/dnfNgsX8DqwE4D0ID
 xk12+pgpJcGFgKxFuhLY53kJwDVVOevYxkV9/CY8nN1sufg21Xg1E5pxdL0ZsAuXGgAs=;
Content-Disposition: inline
In-Reply-To: <20180531214612.GA12216@bombadil.infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

On Thu, May 31, 2018 at 02:46:12PM -0700, Matthew Wilcox wrote:
> On Thu, May 31, 2018 at 03:37:42PM -0600, Ross Zwisler wrote:
> > Never mind, just saw your mail from a few weeks ago.  :-/  I'll retest on my
> > end.
> 
> Don't strain too hard; I found (and fixed) some bugs in the DAX
> conversion.  I keep finding new bugs though -- the latest was that
> xas_store(xas, NULL); doesn't work properly if xas is multiindex and some
> of the covered entries are not NULL.  And in fixing that, I noticed that
> xas_store(xas, not-null) doesn't handle tagged entries correctly.
> 
> I'd offer to push out the current version for testing but I've pulled
> everything apart and nothing works right now ;-)  I always think "it'll
> be ready tomorrow", but I don't want to make a promise I can't keep.
> 
> Here's my current changelog (may have forgotten a few things; need to
> compare a diff once I've put together a decent patch series)
> 
>  - Reordered two DAX bugfixes to the head of the queue to allow them to
>    be merged independently.
>  - Converted apparmor secid to IDR
>  - Fixed bug in page cache lookup conversion which could lead to returning
>    pages which had been released from the page cache.
>  - Fixed several bugs in DAX conversion
>  - Re-added conversion of dax_layout_busy_page
>  - At Ross's request, renamed dax_mk_foo() to dax_make_foo().
>  - Split out the radix tree test suite addition of ubsan.
>  - Split out radix tree code deletion.
>  - Removed __radix_tree_create from the public API
>  - Fixed up a couple of comments in DAX
>  - Renamed shmem_xa_replace() to shmem_replace_entry()
>  * Undid change of xas_load() behaviour with multislot xa_state
>  - Added xas_store_for_each() and use it in DAX
>  - Corrected some typos in the XArray kerneldoc.
>  - Fixed multi-index xas_store(xas, NULL)
>  - Fixed tag handling in multi-index xas_store(xas, not-null)

Ah, okay.  I'll retest & resume review once things settle down and you send
out a new version.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
