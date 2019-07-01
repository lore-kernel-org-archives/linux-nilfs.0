From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 4/4] vfs: don't allow most setxattr to
	immutable files
Date: Mon, 1 Jul 2019 08:42:00 -0700
Message-ID: <20190701154200.GK1404256@magnolia>
References: <156174687561.1557469.7505651950825460767.stgit@magnolia>
	<156174690758.1557469.9258105121276292687.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : references : mime-version : in-reply-to : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2018-07-02; bh=GDKI4jxma30W8dysQyH6fGQQmEcxGjDQ/l/FsFe6Oig=;
 b=nSisQxKthP8/pgT9bQOIVBnHl8trZ2mNN3u3VpDv0JMhnbBlHhnGd8bxgUNLTTf05o82
 irOJ0OO4lXB1dPfYeabn9nNSB7tOyyd9xukHIJQnhMDB521GVsr6cwYyaq4JJqU9S9F0
 NsJWJmBMNnromFVpQ8EX9xpJcoIIlQ/UnMMZwZlMVEDx9LlLJX6DHnw4TpTKR4GJe8/6
 INb9DsYoi5+fMl8wXh/36TETEbt1Bel9CcJFE0Ltk57T04cbakVVBOZJJLPYhNEwduQn
 OF/qqljg8vrMw8yk/eIl8vdYB9y2sbfruP+stFZ2DX5JI2SbeGNq9FzqQLZj3zYysYNa HQ== 
Content-Disposition: inline
In-Reply-To: <156174690758.1557469.9258105121276292687.stgit@magnolia>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org
Cc: linux-efi@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, devel@lists.orangefs.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The chattr manpage has this to say about immutable files:

"A file with the 'i' attribute cannot be modified: it cannot be deleted
or renamed, no link can be created to this file, most of the file's
metadata can not be modified, and the file can not be opened in write
mode."

However, we don't actually check the immutable flag in the setattr code,
which means that we can update inode flags and project ids and extent
size hints on supposedly immutable files.  Therefore, reject setflags
and fssetxattr calls on an immutable file if the file is immutable and
will remain that way.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: use memcmp instead of open coding a bunch of checks
---
 fs/inode.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index cf07378e5731..31f694e405fe 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2214,6 +2214,14 @@ int vfs_ioc_setflags_prepare(struct inode *inode, unsigned int oldflags,
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
+	/*
+	 * We aren't allowed to change any other flags if the immutable flag is
+	 * already set and is not being unset.
+	 */
+	if ((oldflags & FS_IMMUTABLE_FL) && (flags & FS_IMMUTABLE_FL) &&
+	    oldflags != flags)
+		return -EPERM;
+
 	/*
 	 * Now that we're done checking the new flags, flush all pending IO and
 	 * dirty mappings before setting S_IMMUTABLE on an inode via
@@ -2284,6 +2292,15 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 		return -EINVAL;
 
+	/*
+	 * We aren't allowed to change any fields if the immutable flag is
+	 * already set and is not being unset.
+	 */
+	if ((old_fa->fsx_xflags & FS_XFLAG_IMMUTABLE) &&
+	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE) &&
+	    memcmp(fa, old_fa, offsetof(struct fsxattr, fsx_pad)))
+		return -EPERM;
+
 	/* Extent size hints of zero turn off the flags. */
 	if (fa->fsx_extsize == 0)
 		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
