From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 0/32] block: Make blkdev_get_by_*() return handle
Date: Thu, 6 Jul 2023 07:54:51 -0700
Message-ID: <ZKbVuyn0jELh8UDM@infradead.org>
References: <20230629165206.383-1-jack@suse.cz>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fhykVYOZkzlXT4yh75rGeCVJ3cPkDr5sjhaxZXHjD+c=; b=zbagyQChudyQPE2bMPZfTnWPir
        xEx+mIn+jmhXiSkClrK6vyYVxVucLdM5bush+XAhi1L8+RYYMWbrfI/PXNLKjNrWkvX1JuFMBGnvz
        hobfOtgzfc30tNgXDTW5f735BiGierSS2sw4A5BsLsjO+NIDmCJaoqnJvjB6GpO63lTBhPw1Ktdzv
        09/JTSE1nHQ4VXLt2IEwE6yDDWWPLCfOggEtJrOTiDfYzQXVq9m9NhYrAKw8aQvc7GPBw2+8hQS8A
        80c0RawRFeosEEQrvmZs9gRIzWZlEHNQkGLdtR04aftBqsNeChaMLjpw0CwixmzDs5mdRTNLsZohR
        2STEGtcw==;
Content-Disposition: inline
In-Reply-To: <20230629165206.383-1-jack@suse.cz>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Alasdair Kergon <agk@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Darrick J. Wong" <djwong@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, David Sterba <dsterba@suse.com>, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Gao Xiang <xiang@kernel.org>, Jack Wang <jinpu.wang@ionos.com>, Jaegeuk Kim <jaegeuk@kernel.org>, jfs-discussion@lists.sourceforge.net, Joern Engel <joern@lazybastard.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On Tue, Jul 04, 2023 at 02:21:27PM +0200, Jan Kara wrote:
> Hello,
> 
> this patch series implements the idea of blkdev_get_by_*() calls returning
> bdev_handle which is then passed to blkdev_put() [1]. This makes the get
> and put calls for bdevs more obviously matching and allows us to propagate
> context from get to put without having to modify all the users (again!).
> In particular I need to propagate used open flags to blkdev_put() to be able
> count writeable opens and add support for blocking writes to mounted block
> devices. I'll send that series separately.
> 
> The series is based on Linus' tree as of yesterday + two bcache fixes which are
> in the block tree. Patches have passed some basic testing, I plan to test more
> users once we agree this is the right way to go.

Can you post a link to a git branch for this and the follow up series?
Especially with a fairly unstable base it's kinda hard to look at the
result otherwise.
