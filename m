From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v13 00/72] Convert page cache to XArray
Date: Tue, 12 Jun 2018 13:37:41 -0600
Message-ID: <20180612193741.GC28436@linux.intel.com>
References: <20180611140639.17215-1-willy@infradead.org>
 <20180612104041.GB24375@twin.jikos.cz>
 <20180612113122.GA19433@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180612113122.GA19433@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: dsterba@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

On Tue, Jun 12, 2018 at 04:31:22AM -0700, Matthew Wilcox wrote:
> On Tue, Jun 12, 2018 at 12:40:41PM +0200, David Sterba wrote:
> > [ 9875.174796] kernel BUG at fs/inode.c:513!
> 
> What the ...
> 
> Somehow the fix for that got dropped.  I spent most of last week chasing
> that problem!  This is the correct code:
> 
> http://git.infradead.org/users/willy/linux-dax.git/commitdiff/01177bb06761539af8a6c872416109e2c8b64559
> 
> I'll check over the patchset and see if anything else got dropped!

Can you please repost when you have this sorted?

I think the commit you've pointed to is in your xarray-20180601 branch, but I
see two more recent xarray branches in your tree (xarray-20180608 and
xarray-20180612).

Basically, I don't know what is stable and what's not, and what I should be
reviewing/testing.
