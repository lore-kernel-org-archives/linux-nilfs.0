From: NeilBrown <neilb@suse.de>
Subject: [PATCH 0/2] Remove some 'congested' tests
Date: Mon, 13 Dec 2021 15:14:27 +1100
Message-ID: <163936868317.23860.5037433897004720387.stgit@noble.brown>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639368930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=d3ZK4cWv8H7actTxxnZZLYOrGmIHEpiDysulN0ZGTfQ=;
        b=Siet2ZPRSy42BsoMsDbZgZQRd2FGdZNFiGMVH1theIyEuj7H55s9fpVtsIR5Sa2Kp150xE
        /cMi3KGN+0Zp9qqRGrwkElO53Pz0HhLVMCz6IzuAKUwu9skGrYaHkOr0rot7wp2LQsFBeY
        vESybLOON63VU3uZuG/StzoqcmK4cMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639368930;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=d3ZK4cWv8H7actTxxnZZLYOrGmIHEpiDysulN0ZGTfQ=;
        b=Pw9406nV/5BOZ4PG4ymu1QAygKL5V2x2Cdl0R8TeO7drctFhMnA/Oi2od7Lhfoq+TNkP46
        yImyG+ssud6D30BA==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Jan Kara <jack@suse.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

The framework for reporting congestion for "bdi"s is no longer widely
used.  bdis for block devices don't report congestion at all.
bdis for nfs, ceph, and fuse do, but any code which depends on that
is not going to work for most filesystems.

So we should remove it.

These two patches remove {inode,bdi,wb}_congested() and related
functions, and change all call site to assume the result was "false",
which it (almost) always is.

NeilBrown
---

NeilBrown (2):
      Remove inode_congested()
      Remove bdi_congested() and wb_congested() and related functions


 drivers/block/drbd/drbd_int.h |  3 ---
 drivers/block/drbd/drbd_req.c |  3 +--
 fs/ext2/ialloc.c              |  2 --
 fs/nilfs2/segbuf.c            | 11 -----------
 fs/xfs/xfs_buf.c              |  3 ---
 include/linux/backing-dev.h   | 26 --------------------------
 mm/vmscan.c                   |  4 +---
 7 files changed, 2 insertions(+), 50 deletions(-)

--
Signature

