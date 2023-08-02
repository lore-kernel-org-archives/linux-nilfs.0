From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/12] fs: export fs_holder_ops
Date: Wed,  2 Aug 2023 17:41:27 +0200
Message-ID: <20230802154131.2221419-9-hch@lst.de>
References: <20230802154131.2221419-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:References:
 In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ZozxeyMGKtkHoR7QtYaUPrxcN8fxX1IcTx0bj1m0eVM=; b=FMNlTWsb79LlTomhJ4WQJNaaR0
 qzUuYinm8/JQxz5JrZZaK4tgMAxSQDGOWZ3V+XXkqmLsRRcMNOyEcw/6YkS5+1ce5K+f19PnphpNi
 OCiciVEZmPEa78jml5lw8mbxK/VrVWYv0hNyXnxhkaPQlhu9NI8e2c7/SEN2oMELmVRM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ZozxeyMGKtkHoR7QtYaUPrxcN8fxX1IcTx0bj1m0eVM=; b=P4okKdpgIGTw1QBdzthHZEtfT1
 gSv5XF5tYGXAUSnCosj/bSQoJIgCtUyQx1USwn2JA11Exn9KcFN6tBhaFMgiB7FoWHW4u8Jkatnbj
 kAHpL9S4mS/ICNQn/yuZWVs319Iw57/18xfajo9kS9o4touNGw2UdZvKjocbikwJCpL8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=ZozxeyMGKtkHoR7QtYaUPrxcN8fxX1IcTx0bj1m0eVM=; b=tmx+7o4GP5sBLM4xYrSsgh9Bda
 +QbMMfDpv1DNC4tqjwNcuPtyVRBYZ5oHVHlh96dQf4IlYjTn55/fw/emJuHrTvhSTgLn4CKM9zq4t
 yT98ZOv03AtsAwaRoj6DqU98ep41F8AzGg/vBGkfVEdAUr4avk2zKXcHV0RtlssyfziJvzMueYqIu
 KhQzE7/xrzzJxOSxfghcWbWDsTFToL/ymn6ov4rjA65Xpl2PHUsmr14itMLIKsS6o6PNsi4Ntd7Pn
 Had/kLEX3WJqsmYXpRsZO5n2YtV4JiZvaKZR7L9CDniwRiSZTphwqLxU2Uxztca27xF+6dVMKrhoR
 wAcOwFaA==;
In-Reply-To: <20230802154131.2221419-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-btrfs@vger.kernel.org

Export fs_holder_ops so that file systems that open additional block
devices can use it as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/super.c             | 3 ++-
 include/linux/blkdev.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 0cda4af0a7e16c..dac05f96ab9ac8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1244,9 +1244,10 @@ static void fs_mark_dead(struct block_device *bdev)
 	up_read(&sb->s_umount);
 }
 
-static const struct blk_holder_ops fs_holder_ops = {
+const struct blk_holder_ops fs_holder_ops = {
 	.mark_dead		= fs_mark_dead,
 };
+EXPORT_SYMBOL_GPL(fs_holder_ops);
 
 static int set_bdev_super(struct super_block *s, void *data)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ed44a997f629f5..83262702eea71a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1464,6 +1464,8 @@ struct blk_holder_ops {
 	void (*mark_dead)(struct block_device *bdev);
 };
 
+extern const struct blk_holder_ops fs_holder_ops;
+
 /*
  * Return the correct open flags for blkdev_get_by_* for super block flags
  * as stored in sb->s_flags.
-- 
2.39.2
