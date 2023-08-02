From: Christoph Hellwig <hch@lst.de>
Subject: more blkdev_get and holder work
Date: Wed,  2 Aug 2023 17:41:19 +0200
Message-ID: <20230802154131.2221419-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=b4U6bkV1Hpe1BTMHR6FYKzJdXgCv2eIo7grqFPPTqjk=; b=mEmIb7uaUaKOwJY8lv1GETQvVo
        WNRAbVgAX3I0Nq8v6CM/Qo1DrhqE34m6F/BDf6xyn9aDiz8ir/jR+j+b6N3vmF4ctRKkZekSnf/xi
        uUswI0ekQNU4ccZrtb1iKIfKRkjifCinoSifA+mjBzEDaNBg7gOhnCnHmtnIl+lP+7yi1X0U5ECrV
        CBu/ROThv8CXmTxygF8pUmZ+UHKpiHPjUS4CpeuY+nPNuUWnZTnad0/okenZbctCPywHMdIKttcRj
        Mov5cp0eIKS0KO0w/8rDBjKZPumqCJP1eChnKXGXEVAMc4/RbvHBDfEltpKwT7S55Y91Tb9SGytMS
        jH+0LgHw==;
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

Hi all,

this series sits on top of the vfs.super branch in the VFS tree and does a
few closely related things:

  1) it also converts nilfs2 and btrfs to the new scheme where the file system
     only opens the block devices after we know that a new super_block was
     allocated.
  2) it then makes sure that for all file system openers the super_block is
     stored in bd_holder, and makes use of that fact in the mark_dead method
     so that it doesn't have to fall get_super and thus can also work on
     block devices that sb->s_bdev doesn't point to
  3) it then drops the fs-specific holder ops in ext4 and xfs and uses the
     generic fs_holder_ops there

A git tree is available here:

    git://git.infradead.org/users/hch/misc.git fs-holder-rework

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/fs-holder-rework

Diffstat:
 fs/btrfs/super.c           |   67 ++++++++++++++++---------------------
 fs/btrfs/volumes.c         |    8 ++--
 fs/btrfs/volumes.h         |    2 -
 fs/ext4/super.c            |   18 +++-------
 fs/f2fs/super.c            |    7 +--
 fs/nilfs2/super.c          |   81 ++++++++++++++++-----------------------------
 fs/super.c                 |   44 ++++++++++++++++++------
 fs/xfs/xfs_super.c         |   32 +++++++----------
 include/linux/blkdev.h     |    2 +
 include/linux/fs_context.h |    2 +
 10 files changed, 126 insertions(+), 137 deletions(-)
