From: Jan Kara <jack@suse.cz>
Subject: [PATCH v3 0/29] block: Make blkdev_get_by_*() return
 handle
Date: Wed, 23 Aug 2023 12:48:11 +0200
Message-ID: <20230818123232.2269-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=czbolVCNdiRIhtzRMydBVuDGtNoMVf0uK7rI8VUw4Wg=; b=h57u0J+Z6ADeQDqwAgmm/0AEhP
 DVMfhIA/4w87az8x4F11vgSc6z9oYXK22/VQkrEXUymIG2yFzBSJxdfzHlIOO4yKSWMy1MUIQuPZr
 WOsqZtBM9otB+78hYMUXUzQnchJV/YvcWe2xBK+cj6Ao2r46ozNnh0p4gdPWWGK4gAxk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From
 :Sender:Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
 References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=czbolVCNdiRIhtzRMydBVuDGtNoMVf0uK7rI8VUw4Wg=; b=T
 4wjyOuIulJdC+Rpa/KjEEfw/O07/aYm9Pga/wZXr+9p/TJOjJGRl3imxPCTVNbUUe93scYhqYYVCK
 dhx+CpLv2u6+3tmfjqLMLXtPLAvlTEKrj2Ps7wYhQ2Owyttu2OcGOFqOIR7wWw9F3GxgeBxxM84Cq
 uA2/1/ISebmEBAiA=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1692787738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version: content-transfer-encoding:content-transfer-encoding;
 bh=czbolVCNdiRIhtzRMydBVuDGtNoMVf0uK7rI8VUw4Wg=;
 b=cea+STFByaV36NWMjg8zifEKP9bUJaVFrhrdsQ1BHrDjc+6YKTyOk0XUYe/aGcn7z1GdBW
 Sp5Xg8/PcrR30C9G8GkmtNgleVHgoFT9VpO4HmYAD81nOJQ/2ts6Z2GJ97FCPouubZqTfM
 7Ki5cRwEgj/8O3iByHVAhCDVhrdgZS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1692787738;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version: content-transfer-encoding:content-transfer-encoding;
 bh=czbolVCNdiRIhtzRMydBVuDGtNoMVf0uK7rI8VUw4Wg=;
 b=ccloVX/Tox8MPvEstSnU1swyihs7KV2puBqol0j3M4wpbT7Z67JF74RuKmYp8i9zsSQ2aK
 Q/J06H24OiSZjOBw==
X-Developer-Signature: v=1; a=openpgp-sha256; l=3781; i=jack@suse.cz;
 h=from:subject:message-id; bh=cMBb8bZk7tVGWo+BW5D78pH+ebOvNFFLsxdd3Uvzd/w=;
 b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBk5ePhrEMij+4xGF6e8K//xuADex0OXIFxlpO0VT6g
 42vu5BeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZOXj4QAKCRCcnaoHP2RA2RqoB/
 91nt6Qs4NSStbt9M1WXY1akBbAqu+Bv3ZXdZ6WMy9kKyYwY7zCnyQziikP60M2MjCrud4NP9os4YAr
 4uXdyOyVcdJ9TjbciDgTyoYdfkFl7g+rZhj1pyPeep1xmvDMn3QtNJ28EbhLegdC+nkmL6+bxPGEwd
 IdsuBKGrdIIEryWwhBq0+BWowL3nzmQjs5GoDtXLoHADfHYhgC8RKYK/4FaML1/SsAZRvGJ/C8wFB4
 JUGsDGFE4CJx9XgiRx407CSIGNSoCciqBpMaMA7x/dbq9Tu76xcqN4/DZrtT2qyG4I7GZYetndEl3F
 vWMZMQFPauZmB2S1r30HY+nn2IOCrM
X-Developer-Key: i=jack@suse.cz; a=openpgp;
 fpr=93C6099A142276A28BBE35D815BC833443038D8C
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christian Brauner <brauner@kernel.org>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>, linux-nvme@lists.infradead.org, Joseph Qi <joseph.qi@linux.alibaba.com>, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, Jack Wang <jinpu.wang@ionos.com>, Alasdair Kergon <agk@redhat.com>, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>, Christoph Hellwig <hch@infradead.org>, xen-devel@lists.xenproject.org, Gao Xiang <xiang@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, Kent Overstreet <kent.overstreet@gmail.com>, Sven Schnelle <svens@linux.ibm.com>, linux-pm@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>, Joern Engel <joern@lazybastard.org>, reiserfs-devel@vger.kernel.org

Hello,

this is a v3 of the patch series which implements the idea of blkdev_get_by_*()
calls returning bdev_handle which is then passed to blkdev_put() [1]. This
makes the get and put calls for bdevs more obviously matching and allows us to
propagate context from get to put without having to modify all the users
(again!). In particular I need to propagate used open flags to blkdev_put() to
be able count writeable opens and add support for blocking writes to mounted
block devices. I'll send that series separately.

The series is based on Christian's vfs tree as of today as there is quite
some overlap. Patches have passed some reasonable testing - I've tested block
changes, md, dm, bcache, xfs, btrfs, ext4, swap. More testing or review is
always welcome. Thanks! I've pushed out the full branch to:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git bdev_handle

to ease review / testing. Since there were not many comments for v2 and
Christoph has acked the series I think we should start discussing how to merge
the series. Most collisions with this series seem to happen in the filesystems
area so VFS tree would seem as the least painful way to merge this. Jens,
are you OK with that?

Changes since v2:
* Rebased on top of current vfs tree
* Added some acks
* Reflected minor nits from Christoph
* Added missing conversion of blkdev_put() calls in cramfs and erofs
* Fixed possible leak of bdev handle in xfs if logdev is the same as fs dev

Changes since v1:
* Rebased on top of current vfs tree
* Renamed final functions to bdev_open_by_*() and bdev_release()
* Fixed detection of exclusive open in blkdev_ioctl() and blkdev_fallocate()
* Fixed swap conversion to properly reinitialize swap_info->bdev_handle
* Fixed xfs conversion to not oops with rtdev without logdev
* Couple other minor fixups

								Honza

[1] https://lore.kernel.org/all/ZJGNsVDhZx0Xgs2H@infradead.org

CC: Alasdair Kergon <agk@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Anna Schumaker <anna@kernel.org>
CC: Chao Yu <chao@kernel.org>
CC: Christian Borntraeger <borntraeger@linux.ibm.com>
CC: Coly Li <colyli@suse.de
CC: "Darrick J. Wong" <djwong@kernel.org>
CC: Dave Kleikamp <shaggy@kernel.org>
CC: David Sterba <dsterba@suse.com>
CC: dm-devel@redhat.com
CC: drbd-dev@lists.linbit.com
CC: Gao Xiang <xiang@kernel.org>
CC: Jack Wang <jinpu.wang@ionos.com>
CC: Jaegeuk Kim <jaegeuk@kernel.org>
CC: jfs-discussion@lists.sourceforge.net
CC: Joern Engel <joern@lazybastard.org>
CC: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: Kent Overstreet <kent.overstreet@gmail.com>
CC: linux-bcache@vger.kernel.org
CC: linux-btrfs@vger.kernel.org
CC: linux-erofs@lists.ozlabs.org
CC: <linux-ext4@vger.kernel.org>
CC: linux-f2fs-devel@lists.sourceforge.net
CC: linux-mm@kvack.org
CC: linux-mtd@lists.infradead.org
CC: linux-nfs@vger.kernel.org
CC: linux-nilfs@vger.kernel.org
CC: linux-nvme@lists.infradead.org
CC: linux-pm@vger.kernel.org
CC: linux-raid@vger.kernel.org
CC: linux-s390@vger.kernel.org
CC: linux-scsi@vger.kernel.org
CC: linux-xfs@vger.kernel.org
CC: "Md. Haris Iqbal" <haris.iqbal@ionos.com>
CC: Mike Snitzer <snitzer@kernel.org>
CC: Minchan Kim <minchan@kernel.org>
CC: ocfs2-devel@oss.oracle.com
CC: reiserfs-devel@vger.kernel.org
CC: Sergey Senozhatsky <senozhatsky@chromium.org>
CC: Song Liu <song@kernel.org>
CC: Sven Schnelle <svens@linux.ibm.com>
CC: target-devel@vger.kernel.org
CC: Ted Tso <tytso@mit.edu>
CC: Trond Myklebust <trond.myklebust@hammerspace.com>
CC: xen-devel@lists.xenproject.org

Previous versions:
Link: http://lore.kernel.org/r/20230629165206.383-1-jack@suse.cz # v1
Link: http://lore.kernel.org/r/20230810171429.31759-1-jack@suse.cz # v2
