From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 0/5] vfs: clean up SETFLAGS and FSSETXATTR
 option processing
Date: Tue, 25 Jun 2019 19:32:02 -0700
Message-ID: <156151632209.2283456.3592379873620132456.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version
 :Message-ID:Date:Cc:To:From:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=cAdDQjLmw3paRsCYayAMtBFRH59fRNc4vYLBHuqjsSA=; b=ZLP2WSHWamtJADaiaBXkCaX8Xd
 MzGV4UWOCPyaaxXrNhktcGUbfDDHeatJ7UZHFBcgyrO/2fUIgMVno4x+Z5YkedxJ8xxZqTOIUPqlQ
 64DnVRLDzaULYKRlamla8WNHN4usZ+z8tsARa/7NYfo4sJqsvVwS/jozQFXHcJDkF0aM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Cc:To
 :From:Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
 References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=cAdDQjLmw3paRsCYayAMtBFRH59fRNc4vYLBHuqjsSA=; b=D
 7OQL8XBz/Iro83FzQN/gzJ9Nd0ERTBBQY/f/JjFJE+RKf3YhqPEKjeI3ycMXZcek9grdHE2FyelzU
 bqfYBC/Ye8aON7nTCetbiqaNbVd2ULJM310cvRvGYW4bO8EnT0tdBUVkhUfc0l3YDAbqLvjqLv/X1
 3/PCmTajJtWqkIg4=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=cAdDQjLmw3paRsCYayAMtBFRH59fRNc4vYLBHuqjsSA=;
 b=fhD2ePrRwz/tNVnG2b1N2SxWwBCi3qxAJ9ScLeOvuVkLhycNeHtLXg/o3eL41275woj8
 ae1pnoc9gndxX+yPAgYKkLzMLpobHgcGQ7u78YZOh1Ap4HyoVxmhrN6K2mnHKlN0MyOd
 OhBevmeNR6hVZ8huHdvp8I/MYGLascpA2Nj3UglocjM5tT8AyX8aGLlXg9ilLp8JGPs/
 BuVhOxq4datwVQrCjXZzkXwLRSy9DeWUHsvP4OQepO7T/089VH31yaMyMT5TpZ60nQhL
 1SkoakCcrrCOOp8D6xl2gCyf9HGardzMlnRRr/ecDAzrAgD4E1/UxtQCn7f5gt8MOlS/ Pw== 
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
