From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/5] vfs: teach vfs_ioc_fssetxattr_check to check
 extent size hints
Date: Fri, 28 Jun 2019 11:34:23 -0700
Message-ID: <156174686376.1557318.5574192602758705361.stgit@magnolia>
References: <156174682897.1557318.14418894077683701275.stgit@magnolia>
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
 bh=RJo9HRMvrhDC3/z4MR2nW8aji8vHUz97eCXxdDfB7Qw=; b=DZiHDHuhvgxyepI4y2U25T9t9j
 43e+NuNtSOYHMMwc/NdtLZywvtDz7wmI/tWzKkfel9QWDineRumMIPSFX/si1RaG7zrsXVtJW4PCq
 8DhdjRKlSbilw9R5e0ltm6Pirh5LOI5O9mH5F4VPu7Gosx0sY0aEb4XTSxxR1gAG8ETU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
 In-Reply-To:Message-ID:Date:Cc:To:From:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=RJo9HRMvrhDC3/z4MR2nW8aji8vHUz97eCXxdDfB7Qw=; b=c5hdukAFT3YMAW3uw0NS8amk1c
 J1SduzROX1cLH1mAcIooDRzlhhTLCao39Y758chAg6gDZEyHwFuaL2bccPPbE0QbVs9XJljfbyx5U
 zXGTjGLgUfFaOMtYKqJq+kezjo2rUVO5v91dGuWtA/lYLP2QXGkHWcDO0V0d7Kpdt8O0=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=RJo9HRMvrhDC3/z4MR2nW8aji8vHUz97eCXxdDfB7Qw=;
 b=zfsBPq4VIgYQNsYJJLrQACmJUX2r4WH3O24sII7d3G3YpAp2BPvIaItNZuKFgX8DhxfW
 vXdtmCxGUQAsSnZqhsjZ7kHOL3QYXAeRSerILJ9orq99UK4YmM56dP18DZpACbCT3wN2
 V0UDcy16W4vhh0jil3d+yfPReca3dIRCwA0TQNssA4D+W/GOgk6nez66Cf6ykSiEYYmD
 8T4iOAs7QMyYZCEXLJJXiFCrdLDL866nH1zyubZnV2zumrYW5Op10XIew14erNhQP/4t
 HbOBURZkWTQNo7pA/qgq/oaCbtYUv9E36D5xwci4Dq8czAcUUDO1LB1hSPwSLDRKwbk3 5g== 
In-Reply-To: <156174682897.1557318.14418894077683701275.stgit@magnolia>
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
Cc: linux-xfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the extent size hint checks that aren't xfs-specific to the vfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         |   18 +++++++++++++
 fs/xfs/xfs_ioctl.c |   70 ++++++++++++++++++++++------------------------------
 2 files changed, 47 insertions(+), 41 deletions(-)


diff --git a/fs/inode.c b/fs/inode.c
index c4f8fb16f633..670d5408d022 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2247,6 +2247,24 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 			return -EINVAL;
 	}
 
+	/* Check extent size hints. */
+	if ((fa->fsx_xflags & FS_XFLAG_EXTSIZE) && !S_ISREG(inode->i_mode))
+		return -EINVAL;
+
+	if ((fa->fsx_xflags & FS_XFLAG_EXTSZINHERIT) &&
+			!S_ISDIR(inode->i_mode))
+		return -EINVAL;
+
+	if ((fa->fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
+	    !S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
+		return -EINVAL;
+
+	/* Extent size hints of zero turn off the flags. */
+	if (fa->fsx_extsize == 0)
+		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
+	if (fa->fsx_cowextsize == 0)
+		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
+
 	return 0;
 }
 EXPORT_SYMBOL(vfs_ioc_fssetxattr_check);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f494c01342c6..fe29aa61293c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1200,39 +1200,31 @@ xfs_ioctl_setattr_check_extsize(
 	struct fsxattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-
-	if ((fa->fsx_xflags & FS_XFLAG_EXTSIZE) && !S_ISREG(VFS_I(ip)->i_mode))
-		return -EINVAL;
-
-	if ((fa->fsx_xflags & FS_XFLAG_EXTSZINHERIT) &&
-	    !S_ISDIR(VFS_I(ip)->i_mode))
-		return -EINVAL;
+	xfs_extlen_t		size;
+	xfs_fsblock_t		extsize_fsb;
 
 	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_d.di_nextents &&
 	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
 		return -EINVAL;
 
-	if (fa->fsx_extsize != 0) {
-		xfs_extlen_t    size;
-		xfs_fsblock_t   extsize_fsb;
-
-		extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
-		if (extsize_fsb > MAXEXTLEN)
-			return -EINVAL;
+	if (fa->fsx_extsize == 0)
+		return 0;
 
-		if (XFS_IS_REALTIME_INODE(ip) ||
-		    (fa->fsx_xflags & FS_XFLAG_REALTIME)) {
-			size = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
-		} else {
-			size = mp->m_sb.sb_blocksize;
-			if (extsize_fsb > mp->m_sb.sb_agblocks / 2)
-				return -EINVAL;
-		}
+	extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
+	if (extsize_fsb > MAXEXTLEN)
+		return -EINVAL;
 
-		if (fa->fsx_extsize % size)
+	if (XFS_IS_REALTIME_INODE(ip) ||
+	    (fa->fsx_xflags & FS_XFLAG_REALTIME)) {
+		size = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
+	} else {
+		size = mp->m_sb.sb_blocksize;
+		if (extsize_fsb > mp->m_sb.sb_agblocks / 2)
 			return -EINVAL;
-	} else
-		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
+	}
+
+	if (fa->fsx_extsize % size)
+		return -EINVAL;
 
 	return 0;
 }
@@ -1258,6 +1250,8 @@ xfs_ioctl_setattr_check_cowextsize(
 	struct fsxattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	xfs_extlen_t		size;
+	xfs_fsblock_t		cowextsize_fsb;
 
 	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
 		return 0;
@@ -1266,25 +1260,19 @@ xfs_ioctl_setattr_check_cowextsize(
 	    ip->i_d.di_version != 3)
 		return -EINVAL;
 
-	if (!S_ISREG(VFS_I(ip)->i_mode) && !S_ISDIR(VFS_I(ip)->i_mode))
-		return -EINVAL;
-
-	if (fa->fsx_cowextsize != 0) {
-		xfs_extlen_t    size;
-		xfs_fsblock_t   cowextsize_fsb;
+	if (fa->fsx_cowextsize == 0)
+		return 0;
 
-		cowextsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
-		if (cowextsize_fsb > MAXEXTLEN)
-			return -EINVAL;
+	cowextsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
+	if (cowextsize_fsb > MAXEXTLEN)
+		return -EINVAL;
 
-		size = mp->m_sb.sb_blocksize;
-		if (cowextsize_fsb > mp->m_sb.sb_agblocks / 2)
-			return -EINVAL;
+	size = mp->m_sb.sb_blocksize;
+	if (cowextsize_fsb > mp->m_sb.sb_agblocks / 2)
+		return -EINVAL;
 
-		if (fa->fsx_cowextsize % size)
-			return -EINVAL;
-	} else
-		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
+	if (fa->fsx_cowextsize % size)
+		return -EINVAL;
 
 	return 0;
 }
