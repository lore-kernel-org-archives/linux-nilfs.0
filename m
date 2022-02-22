From: Christoph Hellwig <hch@lst.de>
Subject: simple file system cleanups for the new bio_alloc calling conventions
Date: Tue, 22 Feb 2022 16:46:31 +0100
Message-ID: <20220222154634.597067-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Huls1rFGB2qZ4Fp0OAzd0z5j8dCiIe4CcnDjsirdHE0=; b=NY5NPM4j7DAPbkK2cuMwVlfa9+
        pLtx2zKV51IUpxN7o0axOaaHbuz+beKtzWxc4XEL07ug7leB4Yspk738ozlaaKjWJovbBXQBqXNyf
        om34hTqCcGkdiUHf+j/bfamzv5QoP6KfFuYt2iBA9s5Y4ATbsQwK9gN/MJN48svGIBCqS9zotUV+L
        CTqIQMCatfRCPBM05BCxZnW65Ugl3HjvA8UkzHDlR4rS9aSSxve7S5y2Tl0bO4fthkP8GFtlc0YjN
        xl33J386SdqkhSC5ccdG2hBr/4vQv6x6zo+nDpY9jP1EcQLa4ccie6/aCoShiKC0TTSycbGcHjdEa
        XD5+2vxA==;
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org

Hi all,

this fixes up the remaining fairly trivial file system bio alloctions to
directly pass the bdev to bio_alloc.  f2fs and btrfs will need more work and
will be handled separately.

This is against Jens' for-5.18/block branch.  It would probably make sense to
also merge it through that.

Diffstat:
 ext4/page-io.c  |    7 +++----
 mpage.c         |   50 +++++++++++++++++++++-----------------------------
 nilfs2/segbuf.c |   20 +++++++++-----------
 3 files changed, 33 insertions(+), 44 deletions(-)
