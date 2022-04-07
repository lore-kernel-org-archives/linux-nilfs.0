From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 23/27] block: add a
 bdev_max_discard_sectors helper
Date: Wed, 06 Apr 2022 23:30:51 -0400
Message-ID: <yq18rshh8o7.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-24-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mYq6byqIyiFjHV8Jr0Ype4Fjz5k3Y7rfnHXOHjRgy9A=;
 b=UoLG9f3rZI3Wt+K09rjVRxZ9B08Rhn+8Grv4X1PNpsDZE/RDxHcFxHCQUgwuEjjZ6rJq
 wNuNdlyjT8obYSvTpy3fP8BF876Zs+hqOsSrpBucEgo+EGYJuY95NOIj/xV4vE8YbjAM
 Vagf4r2oIzDGXZGT1bdnYp5qbnHGYW7ZJYGyzEiZs3s6Ry00lGPuyfSwiiKyo3rmS6Xs
 jIimKiYXYc+jcfhgOe5RxG0KhocTvE23Yl2MlbRB7vMxhf8ntKaiSqTtKKykNy2isH9t
 U+pUa7b3DleXFwYe6m9t9XKqagf5GTTGyB+OMYYemMPa9DZQE+veiYorobvoHI2Ri9I9 vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYq6byqIyiFjHV8Jr0Ype4Fjz5k3Y7rfnHXOHjRgy9A=;
 b=Eq21Wo+j1JF7OTWA82B9borMkMphwY8igrWHR4LUBmyqVvlgcx8FVIJUwbmKdh+L5EQ9Jv9PuMecfsquNzJY+mcwWkiVOlR6FgCJX0GNs3UISUzrsOhNNFWZSMcdkqsDwJX8uKCIJCU4bK3t5lY/Fsw3+RryaRh/fdY/cELhbQs=
In-Reply-To: <20220406060516.409838-24-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:12 +0200")
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

> Add a helper to query the number of sectors support per each discard
> bio based on the block device and use this helper to stop various
> places from poking into the request_queue to see if discard is
> supported and if so how much.  This mirrors what is done e.g. for
> write zeroes as well.

Nicer!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
