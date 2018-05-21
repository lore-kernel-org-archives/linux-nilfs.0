From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v11 54/63] dax: Hash on XArray instead of
 mapping
Date: Sun, 20 May 2018 22:47:56 -0600
Message-ID: <20180521044756.GD27043@linux.intel.com>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-55-willy@infradead.org>
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
 bh=0ZmBJuLtYcf3wNAp+FEKDtsXKoqZK6AaS+3vGeFNqSI=; b=VuDfpW9nDGD6xwv2cI+ZlJrJSI
 /4/f2E2z8GO1Z0mlLXDe6EQP2o0B+R7Pi7hEAPuwnCVYZoN06YtiMHfYG6rk2mwZdy9f/BCRURiSI
 5i5kE7JBD1yMB3Q4hUVEwNCIUtWo+hFfC6UviWK5rL2+mgFgkNWn/2yC3xN9vTG6mi2c=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=0ZmBJuLtYcf3wNAp+FEKDtsXKoqZK6AaS+3vGeFNqSI=; b=V1rYV+2sb0iUhHMbwMf94YuDu2
 CG3qQ/y5crFQkikSDbTb24ToCKRkTnqMqk5tSSN+9/dpAqOsh621V9bV4+Y641Ed4NKf7td1aivhI
 DcAGH2Wqwj1NSpj4+ISqyBwVnIqrW+KOv4sYxEUfJx5qO5gWnwAeroCNBTexOfWJ64Xw=;
Content-Disposition: inline
In-Reply-To: <20180414141316.7167-55-willy@infradead.org>
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

On Sat, Apr 14, 2018 at 07:13:07AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Since the XArray is embedded in the struct address_space, this contains
> exactly as much entropy as the address of the mapping.

I agree that they both have the same amount of entropy, but what's the
benefit?  It doesn't seem like this changes any behavior, fixes any bugs or
makes things any simpler?

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
