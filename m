From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/29] block: Make blkdev_get_by_*() return handle
Date: Fri, 11 Aug 2023 05:27:28 -0700
Message-ID: <ZNYpMPM5o4q1xcIt@infradead.org>
References: <20230810171429.31759-1-jack@suse.cz>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=96Jyxa0hgrG24aZgu2ilDmsPaDJbIFT8CvAcqFGq7ak=; b=Lt8QMt/qiwPklQXJKNxAAayl50
        ejm5z3TauQQgWXDYeiy6ev7CoxuktCUjLml+tQTXB0FrmwYo9bGjhm2G8bwiVtr2qWkYfM3c8FNl1
        cPDaz7ayPa6vktH3ev1ZeHUse0hr9sV3dSKzn62142iTuA8TTM4tDaiYAHOFhJAm7nP3aQxRbODoe
        cl8s2GHmVFeXScu6jrXcZHGDTmN2udO8XZ0pPwfpsd5QoOiRLOiFHXD6KYR9f2MEyvA/KeT9RzHmF
        DIvDgADu/AxqynsuMYC3hcwdLyXOsBeZQBLnrFNVOoRqDCMnS+8kcWICKZ1ml8I/4TT3bYAOcmKWy
        N15IsxAA==;
Content-Disposition: inline
In-Reply-To: <20230810171429.31759-1-jack@suse.cz>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Alasdair Kergon <agk@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Darrick J. Wong" <djwong@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, David Sterba <dsterba@suse.com>, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Gao Xiang <xiang@kernel.org>, Jack Wang <jinpu.wang@ionos.com>, Jaegeuk Kim <jaegeuk@kernel.org>, jfs-discussion@lists.sourceforge.net, Joern Engel <joern@lazybastard.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-btrfs@vger.kernel.org

Except for a mostly cosmetic nitpick this looks good to me:

Acked-by: Christoph Hellwig <hch@lst.de>

That's not eactly the deep review I'd like to do, but as I'm about to
head out for vacation that's probably as good as it gets.
