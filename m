From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v4 0/5] vfs: clean up SETFLAGS and FSSETXATTR
 option processing
Date: Fri, 28 Jun 2019 11:33:49 -0700
Message-ID: <156174682897.1557318.14418894077683701275.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2018-07-02;
 bh=SkRY1ivB9KBTRLTtQHgBcJxGVLczp/JdiQD6/HHs19w=;
 b=JAXaPUdeolJZ12cGDjcLfFOboa/Bcv6mahjNHCF8zxX7TB1qKhpkynugbKx9GhkYyNPE
 LJGl3EQTM39Lpo2h1wdaFkiGN1N9gLNK3IhcnHLz3mB60tjpf1FpYwo5rgyuU4VlUnP4
 1PhvtWX5RHZLqxFa3NaV/P5/DiApTvDDqUdG5ddGbQvOB8//zHWSWjmmmBw0b1JYK2Jp
 zXQSLU23CdutnqFMifEWU3DbLBCWifQkNVhjs+bby6vAb+gDRDdCTtU/hiYWYBLD5uer
 RvIzqzJX9iJjx/T8uMSJKys5csISjVVWh+0KNxnSKxdi0v7V1D4qmViof7PAUyHZkhk7 DA== 
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
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, darrick.wong@oracle.com, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk
Cc: linux-xfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi all,

The FS_IOC_SETFLAGS and FS_IOC_FSSETXATTR ioctls were promoted from ext4
and XFS, respectively, into the VFS.  However, we didn't promote any of
the parameter checking code from those filesystems, which lead to a mess
where each filesystem open-codes whatever parameter checks they want and
the behavior across filesystems is no longer consistent.

Therefore, create some generic checking functions in the VFS and remove
all the open-coded pieces in each filesystem.  This preserves the
current behavior where a filesystem can choose to ignore fields it
doesn't understand.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=file-ioctl-cleanups
