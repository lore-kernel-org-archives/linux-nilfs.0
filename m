From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/4] vfs: clean up SETFLAGS and FSSETXATTR option processing
Date: Mon, 10 Jun 2019 21:45:32 -0700
Message-ID: <156022833285.3227089.11990489625041926920.stgit@magnolia>
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
	List-Owner; bh=2pIp4YMXJEgwl8PHoK4X+Z1obl0f+8OzEzMaUz1gEeY=; b=Ms/c5JIY5iFP11
	fYrPtK1CwTDUmLEVU1W+sT2LpxRvwTsYNFES0Bv1LOFctqyi3aeTiQButRvx6FKXPJndBHF3vb2A/
	sfniPW9v/ClzDkIb+aqXCpPbOKLSqpNA4e+xOKa51xrhnzLu8mV6EcHj/e3gMtlMVruhvDBJKBTex
	fq4fHvzFFeB9bDAE5Io4maEjVKTsX7bl532Cdp5VnhIRkTfTXYhQXNbgQVdMcOhEpXpu6HxNgx5pt
	GHLrJloNLeN/dHml+N266pZG8ubF8/MiK+eJ0Q/kgR7IbJ2oH6JJk+0b5Wkl2oekF65nn9N1wqJab
	lMHGL2hcH2zC9sAgyE6w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=cAdDQjLmw3paRsCYayAMtBFRH59fRNc4vYLBHuqjsSA=;
 b=AnqW+epX9OYHOzw5sTwOrIxO7AnaE4zZ8lKJiAKmrhvGxrpd3f8wxkkZBflgbEq1sOzY
 KV9eHWtYAaDLZEqtrf3ZJguDUBlZ5gkFNbVMpa3eMHo3FyTTFKbmVm7G73D6lbw7s1dS
 5J0Lk/d+rVXhiXXKr/mH872REZ1FpGGZjopVCJKDYW2v1wPRflHiayy7E/k6yaqVysXu
 pMLLiLZptpvWSoeeq4y3wkBrabcsyoDe44zUwkjmFZpE9J0c9WugSVczTNIfBX8CJsY6
 ZMZfEBndl9+QIq5/p+cyhxYC9prtn2PzyyKr32uqZ/hzXp9SjaAVfhiNdQ0vX/gWicFf oA== 
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
