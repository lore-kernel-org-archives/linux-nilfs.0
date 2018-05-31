From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v11 00/63] Convert page cache to XArray
Date: Thu, 31 May 2018 14:46:12 -0700
Message-ID: <20180531214612.GA12216@bombadil.infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180416160133.GA12434@linux.intel.com>
 <20180531213643.GD28256@linux.intel.com>
 <20180531213742.GE28256@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=723KVrZ4Cw5Mpqt9LPsLRLb//EZkovVEAl0D6JVoyGk=; b=JO8BmKrrlT4kQqabZ7tOf+a8Wz
 FH5C3HJSmtfPZj3lDXG6yhHUcLjLln0tctoRJvij3DZXQI7ac9kbwMafAEcdNXZv66+obl6fDcg1x
 8FIciOB9ZVwanAGBhziEGnOdjHAq1obRMXrDVXzOi6EVBlUwHr3KoEhtBAZ49LsukIho=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:To:
 From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=723KVrZ4Cw5Mpqt9LPsLRLb//EZkovVEAl0D6JVoyGk=; b=LCcYRt8Gi9FfD/0KnZX9ObVrwr
 U17rjP4oNMKltnz4O7zohjATWALKLBFPLoB5v8wVQzi8To2vl8Y9NB7Rk71EmlJeaTbtiDXPn0zjJ
 chyvW099Z8PfZ/bqy1NwAZRj+hU6sMPImyaTDwndSQxuhyis9o9iCyOD7TqRTqV//pvE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=723KVrZ4Cw5Mpqt9LPsLRLb//EZkovVEAl0D6JVoyGk=; b=F+2NAbSjhymiTGBpNGnW6Si+m
 098GGj0peeF17sQMKC+DxXocwTwUVqve/Mdlji08jYLRoH8g/bbC26zQSrnLAYBoXm65Rdf3eK0Gq
 GO//UFJlmVgSLjRZbc1oRRH7fT2dPRSiMg+z+6PNJA/bcJiOWheZ8F2ZSZyxAyMLbrhZCQDey8aka
 e+bUkKnqMonNRmq+9EX8Y4i762w+Op1EAPMf9FgWvYY/grdQNzvCasGTRiJVPB5aQMAv6k5QVdjfb
 3ceQ3Z9WvBzT1W8YjGnRNk6M7dq27QtkASrXv+dHaTYeDR6scEGTgcq1WVxKTHJG6R258/2uDXpTM
 GUQZZen3w==;
Content-Disposition: inline
In-Reply-To: <20180531213742.GE28256@linux.intel.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Mike Kravetz <mike.kravetz@oracle.com>

On Thu, May 31, 2018 at 03:37:42PM -0600, Ross Zwisler wrote:
> Never mind, just saw your mail from a few weeks ago.  :-/  I'll retest on my
> end.

Don't strain too hard; I found (and fixed) some bugs in the DAX
conversion.  I keep finding new bugs though -- the latest was that
xas_store(xas, NULL); doesn't work properly if xas is multiindex and some
of the covered entries are not NULL.  And in fixing that, I noticed that
xas_store(xas, not-null) doesn't handle tagged entries correctly.

I'd offer to push out the current version for testing but I've pulled
everything apart and nothing works right now ;-)  I always think "it'll
be ready tomorrow", but I don't want to make a promise I can't keep.

Here's my current changelog (may have forgotten a few things; need to
compare a diff once I've put together a decent patch series)

 - Reordered two DAX bugfixes to the head of the queue to allow them to
   be merged independently.
 - Converted apparmor secid to IDR
 - Fixed bug in page cache lookup conversion which could lead to returning
   pages which had been released from the page cache.
 - Fixed several bugs in DAX conversion
 - Re-added conversion of dax_layout_busy_page
 - At Ross's request, renamed dax_mk_foo() to dax_make_foo().
 - Split out the radix tree test suite addition of ubsan.
 - Split out radix tree code deletion.
 - Removed __radix_tree_create from the public API
 - Fixed up a couple of comments in DAX
 - Renamed shmem_xa_replace() to shmem_replace_entry()
 * Undid change of xas_load() behaviour with multislot xa_state
 - Added xas_store_for_each() and use it in DAX
 - Corrected some typos in the XArray kerneldoc.
 - Fixed multi-index xas_store(xas, NULL)
 - Fixed tag handling in multi-index xas_store(xas, not-null)


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
