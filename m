From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 0/4] vfs: clean up SETFLAGS and FSSETXATTR option processing
Date: Fri, 21 Jun 2019 16:56:07 -0700
Message-ID: <156116136742.1664814.17093419199766834123.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20170209; h=Sender:
	Content-Transfer-Encoding:Content-Type:Cc:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:MIME-Version:Message-ID:Date:To:From:
	Subject:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:
	List-Owner; bh=2pIp4YMXJEgwl8PHoK4X+Z1obl0f+8OzEzMaUz1gEeY=; b=Im8XBygOhqfs6F
	tl7NNALndvtDom+XAsEGoso2Nulb9Vt7iHVwfhI/OeVJevfIb3/s2lO89/d/rdpIPW6h6WaoXQQpi
	Cd4QSBYb4WXiPirF+s4sl6kjWY+irI3kpXcyrxZGeXjEPPU3HE+T7AUd3yqpvtejoJ/rIFhY8jOKQ
	X9gBD4vO30L4vRn5NpYY0+QP8yqhAb5nIeEoLoRej7SCY6LEEIxf34/S8fZkW4w6Ldx4hIqnjf10k
	ARs1PV+1VJR+NLfc3WP+2iHKidsuHbRPoxhBrFEYVu0SUmdST4CnCy1qwDdJzTLYQn5KJdXCUTA4b
	IKgMUUI6weGGbF7hmbeA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=cAdDQjLmw3paRsCYayAMtBFRH59fRNc4vYLBHuqjsSA=;
 b=TzR6Wru1xSjTTRJAS5YLkE/BrGnsLOB3oXc++TPNZTilrEotX+w/PXZSlo2GmgalFn6q
 EFIn2g7OnCMHKiU/KYZQjoVVDHvaifoE42AmpxsuNL7wnDmrtZhKVTyFzOJI7etrK4kK
 KEBGejr346UOlFcuSkyuDnIO/5wd6UqT/S/KQGVF+NHJ5J7mmhYyVd5c2jc+HbQbg3wB
 wa4pvaZQ8fS5HuyXYBN1pV+PfgLDpbPcaxs+KsA+sgcG7mAhRxGd5p97mdMZnG6Ft3yd
 IEh9EmQpStxpaanEvQR/EobOi//ZfTjzIl0oWYndnxgPHklvyg0k1RPOB0QGCH15ATwX mw== 
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, darrick.wong@oracle.com, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk
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

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
