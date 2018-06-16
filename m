From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v13 00/72] Convert page cache to XArray
Date: Sat, 16 Jun 2018 05:07:21 -0700
Message-ID: <20180616120721.GA15447@bombadil.infradead.org>
References: <20180611140639.17215-1-willy@infradead.org>
 <20180612104041.GB24375@twin.jikos.cz>
 <20180612113122.GA19433@bombadil.infradead.org>
 <20180612193741.GC28436@linux.intel.com>
 <20180612194619.GH19433@bombadil.infradead.org>
 <20180613201021.GA4801@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=b2ioswnzWdhz5qEECKAGp4/3YpmEOPOWXCkZpHPyyZg=; b=usRTxjyQYXOn6Ij4kHPknClLi
        angCMiSwvcg+ntS4Yv3V+aLKBD2Qxi9Ha5oZ0sa/yaaVwQUJBZT62dXzaI9uPML2Rvgu6ABGoXW3A
        yyvf6Yt/P4tm2pWVyTXDpZc+cwLPuSo55gicl/EzaIwHqtVkJ5IFrcOf6dZJfmSP6QxeMPOXJsztZ
        v6cay1SWiNWKob6uv7aRT59DB685w2VYUrI0PEw6I5+zCMjPM+zZMm/yIrnxUOGn7m1y5VxI94LT7
        cgnra6/pka4ULO2P4JxktrYvjHpYKrxk5m9NjIN+shpS9ofFp8Ee36EKL5bNGO4NR4vXfAkzjp4kL
    
Content-Disposition: inline
In-Reply-To: <20180613201021.GA4801@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ross Zwisler <ross.zwisler@linux.intel.com>, dsterba@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

On Wed, Jun 13, 2018 at 02:10:21PM -0600, Ross Zwisler wrote:
> I tested xarray-20180612 vs next-20180612, and your patches cause a new
> deadlock with XFS + DAX + generic/269.  Here's the output from
> "echo w > /proc/sysrq-trigger":

After getting my pmem setup working (thanks for the help Dan &
Jeff), I tracked this down to a missing call to dax_wake_entry() in
dax_writeback_one().  I'm running xfstests -g auto now to see if
there's anything else that needs to be fixed.
