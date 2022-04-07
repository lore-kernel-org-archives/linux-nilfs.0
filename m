From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [PATCH 01/27] target: remove an incorrect unmap
 zeroes data deduction
Date: Wed, 06 Apr 2022 23:05:13 -0400
Message-ID: <yq1wng1k2zn.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=YsLEXwzHHuhF8Y2ubKs7WB5IRORi93e0Vmn68Bi4rNA=;
 b=NfkaK2NCMW3x6JiAe6CyDENNOARvHDPb02I5fwoWxOu6QfcjwiXHY8Xrx4mcDWkinikI
 6y4iSHee4zyBe8QJm5tGfgOkAj83SF9OykxjXn7vNSW2mJgWYrf5/fUSzDfg0XfmCs1J
 +oAbW8F3tDhDUqTy+eCamQ91BX21vJ4MJB4EGZR8HynPhZNqhlYoDA/HLfQDBP+Bo4CR
 x9rTg/eQ+/XOfhq/Ik5Mn266beB4VlXnYt6pQZmsHu7vA+BBuG6FRivVgrT/mpZl+pEH
 mlVBoOLNp7A97wLDUSOK5yHa7XAT643O9e2NZAIcfD0zc10YNOs0pYfWr7nlIIE2mlT4 XQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsLEXwzHHuhF8Y2ubKs7WB5IRORi93e0Vmn68Bi4rNA=;
 b=nQ1EV2Z2MwlvkJGlLAO7iFJYI6/mpP6qHesyCjyJNkoNah/7fILGtoubqQmqI1YcRdlyln9Kt9HjWF/h9c7R0jKk1BKfkc8enXMa4DreRin9+h1VJ4fFvcD86VOH7JoEWo+TzBXyBlfYYFG+s2hxLrvDcOlC6vYzT0JUfYneq2c=
In-Reply-To: <20220406060516.409838-2-hch@lst.de> (Christoph Hellwig's message
 of "Wed, 6 Apr 2022 08:04:50 +0200")
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com


Christoph,

> For block devices the target code implements UNMAP as calls to
> blkdev_issue_discard, which does not guarantee zeroing just because
> Write Zeroes is supported.
>
> Note that this does not affect the file backed path which uses
> fallocate to punch holes.
>
> Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
> Signed-off-by: Christoph Hellwig <hch@lst.de>



-- 
Martin K. Petersen	Oracle Linux Engineering
