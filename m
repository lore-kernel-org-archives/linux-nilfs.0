From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/12] fs: stop using get_super in fs_mark_dead
Date: Wed,  2 Aug 2023 17:41:26 +0200
Message-ID: <20230802154131.2221419-8-hch@lst.de>
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
 bh=H3MTtQkLFkLtQvQuadZGreptlnpEa/QPHhaLm59CLeo=; b=SllETIZ2eOPlmdKwUnKHFnOEgl
 dCUUXZD8I//p6++SrBFbyFkQVN0AKCghcGZ6jSuFzFxo6oTWYoiH6G0GIBVkyqc3cQkeFFTruh9zl
 A+9fGQNqE3HT6xufiMDZodcKGlOaiLSi2I8c/e4ufx2LDjYVJCbsPnKnVdmEXjhbjis0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=H3MTtQkLFkLtQvQuadZGreptlnpEa/QPHhaLm59CLeo=; b=U5S8XlAndMpyn0WzdMhFl0tu0v
 eDna6SeeHtUBGcNO6Ry5p+m/GGhhRL3/7xZUNvd5v2QVlzRuLEOTIa+9BfW8HOqG3s9EGzeEqE2/P
 OaEY7Ww3DSg1i3n9aC6XZyuFIbIAg0jrE0KS7Wa1vYINa3EHNS9ETHjeMikgWvE3zFys=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=H3MTtQkLFkLtQvQuadZGreptlnpEa/QPHhaLm59CLeo=; b=3JXg/prj0HfTjXvS5Acr1C9TH8
 tBCdwieLU44WmKkY3yg459RwXOD3Ksk/8LYtSODjqVxZt/pb+SwDXBOYev1CR9j0Gzt6WBv9+Yb9n
 0d6Gg7s326FEZsZfpcNZDOIYGoDpH0mESnTfRIiZI3w8I2NMPDqxnxJLbxNPkqle4gMEcQKYp1EgX
 7CEBSecV3ExtqrQHb8ny4H4fzi1LfiImJPIEpcVxedd+2YDNFXNgP5/iHFTm9wdAgHoWSi4D7/T4A
 qQP6+/T+EtbyBae5S1gS5DirSjkxKBoWa/sIWZn8/4j/f/cAkgIIVu/nkTbTc3SB4lzPFWqQHZ5An
 LLzbtv3w==;
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

fs_mark_dead currently uses get_super to find the superblock for the
block device that is going away.  This means it is limited to the
main device stored in sb->s_dev, leading to a lot of code duplication
for file systems that can use multiple block devices.

Now that the holder for all block devices used by file systems is set
to the super_block, we can instead look at that holder and then check
if the file system is born and active, so do that instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/super.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 09b65ee1a8b737..0cda4af0a7e16c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1209,17 +1209,39 @@ int get_tree_keyed(struct fs_context *fc,
 EXPORT_SYMBOL(get_tree_keyed);
 
 #ifdef CONFIG_BLOCK
+/*
+ * Lock a super block that the callers holds a reference to.
+ *
+ * The caller needs to ensure that the super_block isn't being freed while
+ * calling this function, e.g. by holding a lock over the call to this function
+ * and the place that clears the pointer to the superblock used by this function
+ * before freeing the superblock.
+ */
+static bool lock_active_super(struct super_block *sb)
+{
+	down_read(&sb->s_umount);
+	if (!sb->s_root ||
+	    (sb->s_flags & (SB_ACTIVE | SB_BORN)) != (SB_ACTIVE | SB_BORN)) {
+		up_read(&sb->s_umount);
+		return false;
+	}
+	return true;
+}
+
 static void fs_mark_dead(struct block_device *bdev)
 {
-	struct super_block *sb;
+	struct super_block *sb = bdev->bd_holder;
 
-	sb = get_super(bdev);
-	if (!sb)
+	/* bd_holder_lock ensures that the sb isn't freed */
+	lockdep_assert_held(&bdev->bd_holder_lock);
+
+	if (!lock_active_super(sb))
 		return;
 
 	if (sb->s_op->shutdown)
 		sb->s_op->shutdown(sb);
-	drop_super(sb);
+
+	up_read(&sb->s_umount);
 }
 
 static const struct blk_holder_ops fs_holder_ops = {
-- 
2.39.2
