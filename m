From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 19/31] scsi: replace the fmode_t argument to
 scsi_cmd_allowed with a simple bool
Date: Wed, 07 Jun 2023 21:18:12 -0400
Message-ID: <yq17cse4ur8.fsf@ca-mkp.ca.oracle.com>
References: <20230606073950.225178-1-hch@lst.de>
	<20230606073950.225178-20-hch@lst.de>
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
	bh=BevKBuNxLWDyhUiYjt2zlqjEp1Yibc1syhKB7CiDipA=; b=dOUkTyMUOF8sy7/pk72f1SdsL9
	nr1ZRwFJK61EGtAF7kBn4gmy0kf6xKMfltOx3IEMfhANonJNMsES42pUKvYfd5oHEcnqs4XNs8/KZ
	qAIV5EeUxx401+VgRIoE3SS6ZpDjuIDn4iLr+KwAqYrkMTS2J5U81r3WIIZxNMEyr6Y1/Z7wFZUMs
	hVsmmyLOSOZV7Vn9fTJHi18z9DjqFSaEluUwTjeMN9hS7oopvvSCub+PP2DGJYuWWVBJIAw4/yMTo
	GSUYFIyQdTKV4+jrDUUl+SI6sS63Cg2kGrhUq0KekKghMk3WbEaL1HijtcdLUyztZ51FS6YAuZago
	4nqfbBxA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ZeTayBQmXEfkeiVK5cec74SvX2/0lEMAt3GDAZktehA=;
 b=2/uambdYLh5UaQ/Mck1BA8lVwwZTMC2kA7TtLCfsuAdSeI6e4jXRwsSJjWjRCiCFITDg
 CrCH+bCm/wEawp2TWgvQjlYpgKUFwWqV4blwFYgGyXP5++mJITY4AqfnWDjZQPd5DkXy
 6YnPx7exqr9dcbL1khWZZ+x+FTBcS9HND4ohPKHzTNWTUqkqk6isE7DRx1idn52neLbA
 UJpXaI/uN/mt0mTi+J7yMid+thNDoGLC68J2BR1Ui+57AYkQUSGUg6pDtHUAw8dDJPbo
 874Nco73hsfKV2WzCx+Sc0dDEMscMAESlWlgtkl+FIyZsg4IZplQlgidKrnIWs/aNL9l rQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeTayBQmXEfkeiVK5cec74SvX2/0lEMAt3GDAZktehA=;
 b=AzaepLL2qbJiwzkeasEtbeSPn+GJaGPIGx1jejbnx7BfYjDm+cSvlEHu12SZFYACf3SfXCSj+dax4EG4RNVhos7x5xNP+mh+p35fbSftUl50VVdGC5SgJ7Wc5GonA3pBUvykZb8PyiuKOOpGyXzOZzN6ZhWDLs9sRaJI0GpIjGU=
In-Reply-To: <20230606073950.225178-20-hch@lst.de> (Christoph Hellwig's
	message of "Tue, 6 Jun 2023 09:39:38 +0200")
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
