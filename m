From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/5] vfs: only allow FSSETXATTR to set DAX flag
 on files and dirs
Date: Tue, 25 Jun 2019 19:32:47 -0700
Message-ID: <156151636789.2283456.3835262849301472968.stgit@magnolia>
References: <156151632209.2283456.3592379873620132456.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version
 :References:In-Reply-To:Message-ID:Date:Cc:To:From:Subject:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=h0lWCLVuyu0P/36h1LaiA53s/qIbwAY/ZQm2+JFVybY=; b=XNpSKzQIUw+kWGOIjZsFsVDtsu
 sra9HsCIc0R1x7S+gMvbWf+Dsi9/mQ4VC2AbHFER7jZem08KbFSBRtneH0FPTLtm7xvFYqNECiKMG
 TSN9PWfzXG+U/YfsMkjLn40I+406gU/lY2EFid886UtdRs6s/E4Uvh7j03RKitNYEn5I=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
 In-Reply-To:Message-ID:Date:Cc:To:From:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=h0lWCLVuyu0P/36h1LaiA53s/qIbwAY/ZQm2+JFVybY=; b=OQ11JNOMQjR7sqRlzJEPNBhth9
 DBjKmmF9wgeWDXsZQg6w+EjXE0GWbq45TbXCTYZ5PXEi2+DIinIEhS2IQMbf3WO/vv4pUvTi8KPSz
 wqVTPB1xOhuuxHochRbit9ghvbW7DUUK5H68X8jgnBTweH2isZOgE0/OneCJ1oSosGgU=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=h0lWCLVuyu0P/36h1LaiA53s/qIbwAY/ZQm2+JFVybY=;
 b=WVzGJQhS0xFxS9ZetgIjbt11O8dEzX+ntxaHJA/Dp/fXfdPu7h/tulaSw1kwfk0cARJ2
 6P7+LaBlGhrlBlTBixL7H1joLQrl5v0O8Wq+iChywtxq2zREmo1SZZsiPwhchYHf5vcY
 R0rhHWm3t8w9kIzGZYGPtpv/6JW+V9DMY/ig7caUEniKBDHwAAFFsm07Eaqv5HMAGarc
 SKeFMzwagbIiY2I+pTgKcZn6a1g5ugBqrBvCiKUeVmttxdxpA1/1SINzfxzwgoTvWkZP
 UjKlu1lIQbbY9YDXdOtJshWXzjUfBugIbz/OPW6NC+6WJf+WV9PZRfD4hUj2cSIcQL/8 JQ== 
In-Reply-To: <156151632209.2283456.3592379873620132456.stgit@magnolia>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, darrick.wong@oracle.com, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk
Cc: linux-xfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

The DAX flag only applies to files and directories, so don't let it get
set for other types of files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/inode.c b/fs/inode.c
index 670d5408d022..f08711b34341 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2259,6 +2259,14 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 	    !S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
 		return -EINVAL;
 
+	/*
+	 * It is only valid to set the DAX flag on regular files and
+	 * directories on filesystems.
+	 */
+	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
+	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
+		return -EINVAL;
+
 	/* Extent size hints of zero turn off the flags. */
 	if (fa->fsx_extsize == 0)
 		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
