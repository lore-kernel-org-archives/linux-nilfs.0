From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 21/31] scsi: replace the fmode_t argument to ->sg_io_fn
 with a simple bool
Date: Wed, 07 Jun 2023 21:18:46 -0400
Message-ID: <yq11qim4uqa.fsf@ca-mkp.ca.oracle.com>
References: <20230606073950.225178-1-hch@lst.de>
	<20230606073950.225178-22-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:MIME-Version:In-Reply-To:Date:
	References:Message-ID:From:Subject:Cc:To:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Owner;
	bh=BevKBuNxLWDyhUiYjt2zlqjEp1Yibc1syhKB7CiDipA=; b=0Y2H/Wl1HoqvHJruBsm16pWvRm
	A5vEjABMEv9BQqRYWjidJ5N+lJMxkLuTF7xaHW/djqWyzVsPo06xxKcIo7t/VsSAvQFTTVxUJmray
	nzfjSXCzoar3k+eT0HOl6aEpFKd0lgvGAOS2Em/90S/Zk4XR66OxAjzxvK4+8OIQor2U1uD6HKwcT
	A3J3kB6U6skYTvqs6812OwWQy/uFvla+YCcAwS/yQYJ1H+bBn4ndFAlcZCdx/6Ma+kkYl6MpiZWPh
	MVwqDdEU9zi2RjVEY1ym6q5m4GK36jJqDP51drZRQ6sEz9KL89V4HJ6OYX9/tKvMyBFSzsyZWETlh
	D/VfCgkQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ZeTayBQmXEfkeiVK5cec74SvX2/0lEMAt3GDAZktehA=;
 b=RfkTx5PbHqMml3lxmSCAGlBn23jd4K5kA+A7Y+EFXCsLzZXpRm/qBw8XEbixxV5G0Xfv
 xC+uO8hyP+wUDorqrb19msPCarC/2zZWuW9NIvkckQ5JbrXa3v+Jw4ZeW+mCf+A3IpS3
 NnzL5+siV8IemqjDrQk9sAn+ubOy2b2aPQDSxO7G+0DHaPVv8Bb4/55+whQhusUhcJlB
 0Ei6rfV4z71z6dtYWrpKoVU2lpdFyLXUyww5gX6P6j/9xCwKppZz4u8884G0oso7KyNa
 JK9Bhu9pkLPUkzcKXk8l8b9qbaRp5CgsbjRvhNILscG3CAWZaRr9ybtZhJnaLjuUlfmr 4g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeTayBQmXEfkeiVK5cec74SvX2/0lEMAt3GDAZktehA=;
 b=r8q2uSCuGosarvUzp53nNCIUSP1nc28IYRqlejrS7JUgi/8qTVFRLp7EjLn8DOvb3U8qTdHLK1/Mih3iNHo7lvuH8I3CZwxM5ZiYnNpl4XyH825zVY0kG7grS5/1hI9Mfa2ue/KxDsiErFBlC7iGUYww+5V2ymM2n8mKVLjELck=
In-Reply-To: <20230606073950.225178-22-hch@lst.de> (Christoph Hellwig's
	message of "Tue, 6 Jun 2023 09:39:40 +0200")
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-um/>
List-Post: <mailto:linux-um@lists.infradead.org>
List-Help: <mailto:linux-um-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=subscribe>
Sender: "linux-um" <linux-um-bounces@lists.infradead.org>
Errors-To: linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@l


Christoph,

> Instead of passing a fmode_t and only checking it for FMODE_WRITE, pass
> a bool open_for_write to prepare for callers that won't have the fmode_t.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
