From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC xfstests PATCH] xfstests: add a writeback error handling
 test
Date: Mon, 24 Apr 2017 08:00:19 -0700
Message-ID: <20170424150019.GA3288@infradead.org>
References: <20170424134551.10301-1-jlayton@redhat.com>
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8ejpWm4JRoudRltRutJMGrfPE6fai8YlNG1/tFgq0x0=; b=WzeuC3Od2SxgeesOafdw6fMOS
        yFGk+/j5EOUS2+k3MczFE2poS00Li5lDjR3I/ihaz2odjXk4G/jmXkojA43IlInogzs2niPCh3TMT
        y2M50z5SPjnuj4gHS1E3P0rDDjietITgKsuO6OD5awqio8eeomvsgZxm94OI1H8slcsC8BMaATYxw
        wtsEGJo4TTgLmnc4H36MYkfz13tkh/995cpq49OewiX7kfc2+2QFItYyA/KOY3F9VN2w0btJqekx4
        0cGGRR39wa8olAc/lWI1s1GWwG7J+17EDnxaxtXsPRHHe/aphOhIKQRxiKOzXHo0a2O6id0lQOEBx
    
Content-Disposition: inline
In-Reply-To: <20170424134551.10301-1-jlayton@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@redhat.com>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

On Mon, Apr 24, 2017 at 09:45:51AM -0400, Jeff Layton wrote:
> With the patch series above, ext4 now passes. xfs and btrfs end up in
> r/o mode after the test. xfs returns -EIO at that point though, and
> btrfs returns -EROFS. What behavior we actually want there, I'm not
> certain. We might be able to mitigate that by putting the journals on a
> separate device?

This looks like XFS shut down because of a permanent write error from
dm-error.  Which seems like the expected behavior.
