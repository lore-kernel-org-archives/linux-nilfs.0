From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v11 00/63] Convert page cache to XArray
Date: Thu, 31 May 2018 15:37:42 -0600
Message-ID: <20180531213742.GE28256@linux.intel.com>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180416160133.GA12434@linux.intel.com>
 <20180531213643.GD28256@linux.intel.com>
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
 bh=n6TDuCiU5mgOAE2AlarghAxZVdorwUuHceKeJMyYhNU=; b=aogizvV2TN4fAPhH/d8zBJTOcD
 GOhTieetZvvS0tAAB4elxXP3qpnhL1UCSxj98cUG33DmML9WwCxNw4LkX+r3XpDkpYP3mJLFZEVNN
 oAc7CaA0N5ksNchJ0Dc+yi526KV6Q5kKZZbX7YsRVi6QdzHbDIPJ4QIzMEd6mTO8UBkU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:To:
 From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=n6TDuCiU5mgOAE2AlarghAxZVdorwUuHceKeJMyYhNU=; b=HMl7lm9Ban14vNOLxO0noXsbgK
 LDAQCtNeAJ+3S/faEKj5AdgvE00gwNq/Rdn0BYdvlw0j3zY4SElSlF8Z+1qZRCQ3va4f2eme+O3zt
 QQWmtEm/SMsXyMr+rbnERAXNjs5Q1HDRhK8EWL9b+Z7dvltoGYAn5Md9SBMC1zXAQlak=;
Content-Disposition: inline
In-Reply-To: <20180531213643.GD28256@linux.intel.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Mike Kravetz <mike.kravetz@oracle.com>

On Thu, May 31, 2018 at 03:36:43PM -0600, Ross Zwisler wrote:
> On Mon, Apr 16, 2018 at 10:01:33AM -0600, Ross Zwisler wrote:
> > On Sat, Apr 14, 2018 at 07:12:13AM -0700, Matthew Wilcox wrote:
> > > From: Matthew Wilcox <mawilcox@microsoft.com>
> > > 
> > > This conversion keeps the radix tree and XArray data structures in sync
> > > at all times.  That allows us to convert the page cache one function at
> > > a time and should allow for easier bisection.  Other than renaming some
> > > elements of the structures, the data structures are fundamentally
> > > unchanged; a radix tree walk and an XArray walk will touch the same
> > > number of cachelines.  I have changes planned to the XArray data
> > > structure, but those will happen in future patches.
> > 
> > I've hit a few failures when throwing this into my test setup.  The first two
> > seem like similar bugs hit in two different ways, the third seems unique.
> > I've verified that these don't seem to happen with the next-20180413 baseline.
> 
> Hey Matthew, did you ever figure out these failures?

Never mind, just saw your mail from a few weeks ago.  :-/  I'll retest on my
end.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
