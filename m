From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 10/27] block: add a bdev_nonrot helper
Date: Wed, 06 Apr 2022 23:16:22 -0400
Message-ID: <yq14k35k2h9.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-11-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=W1WqCICKHnvyvIEevFUyUtdGDLu7sKYBjmUGmhlgDFw=;
 b=Ijw2Hbs8JlfO85BdJ/ePlHYrF2UCKxnJLItzdWFviUalxElI3wDrwqjNlyiB7i84rddJ
 LFAlhUCGk+g1Qiv/GNS3oehC3qPVbzzWFH48CUBLJZLeqKLmA+nzGF7CFwDmAsCUR4DG
 g6JzSWOAHIDuyYwrXKfwzYmvCgQPE04R/QmdQSE5q8GaqvzJ2dfuPVDQJbClBaWJt6Uk
 2yQut1Eh7TwRv8dlTTuLi0zBfffH50lZT5l7pAWvweJY71CPUr12IN2nu/3nLikq/61m
 UYouBqsKJVTAyLHMoePtKdZR7LZbm+/1Nb4FYlCom29laVhilgBW2d/i+YxuiSCaoVLj xA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1WqCICKHnvyvIEevFUyUtdGDLu7sKYBjmUGmhlgDFw=;
 b=d1mW83v97OXADeEhiNwno4KHtAI1Dr/+rfv/xp/Div5IkCokXN8XJgFqPMOvRx1qGArbx3W+Ih5BSOZkemvBHmMsRm9EsBi4czSxbNzQ+B6BKyEEVrC8iqfSjIX1by/wOiMQjUo4/0Ts4Bv85+SzzsC/ynTPMowE6yh3sNbq0dM=
In-Reply-To: <20220406060516.409838-11-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:04:59 +0200")
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
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, Christoph Hellwig <hch@lst.de>, drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org


Christoph,

> Add a helper to check the nonrot flag based on the block_device
> instead of having to poke into the block layer internal request_queue.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
