From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 26/31] block: move a few internal definitions
 out of blkdev.h
Date: Wed, 7 Jun 2023 11:03:09 +0200
Message-ID: <20230607-kernkompetenz-halbleiter-b8874bc39061@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-27-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=3c7Q4wKRdmA1MQcEV1xnhu6LCilclGTs//lC74QnyLc=; b=DVI3OJCZSdU9T3huk6ptRgHjML
 joO8NYZM06ZpxZmq9RWc0KDY2KUMZOdivT12GWtjkjVDJwUOxvYNcqBzmSteVWWDp9JIMRmrRiUL2
 k7V3Ndp1xFgE7HCMaV+89XGbQBmvf1a5tuaq6Db7G17S6/+TrNcPGtbOrcmT8wAKV2zA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=3c7Q4wKRdmA1MQcEV1xnhu6LCilclGTs//lC74QnyLc=; b=VfNsgQv/FUdAKi92f25TINOVRX
 FeehwZWXTZHoP8KMbVCWmL1fNJNln3pZBmuyjhOmZd/MMZueztgLqi8LVfr6q2eh3CWgdr6SU87XR
 FexCKO8z9n6ihJ3QO/tSsvkIs9gm+m+P7nUzxF0Y4+4Eo6Lwb7JGrl3W6Boezr5ypfNY=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1686128597;
 bh=q7AdZhSDALKQcnwiboxtavjTYhFCYH416kEbuBo82ZY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=LmFv4NUDSWWO12W7cnryBDYV8PpqTiV6m9IiQfaN+Gy1TfavMxnrDvH/1VFaqu0VY
 pNdbYyRHzF2xHsOOKI87miWMENWlYg9+fsdmVVKTz7wYCo6GM1+2x+3dTWnt7WYDdZ
 Mcjyuj+xp5weCEAYKk11qk0vTGQUIzOnBLlKJpx07Q5ZRsx7ASXqBbtAW0ZLkT7Ew4
 zBKVTwzdquqRp3RuennzrpOsYTw2sC0VjBfUPhiyrzzFVaAdPGx6+N+quMH0El0KVh
 SXVIETbMrhU8sh4IsaqUJwCWqqtEaM+3Y6KO5/S9XwefBpx2SMbZ5aVq7LqHVJcaJB
 5ShZ62p5oKScw==
Content-Disposition: inline
In-Reply-To: <20230606073950.225178-27-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@lst.de>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, linux

On Tue, Jun 06, 2023 at 09:39:45AM +0200, Christoph Hellwig wrote:
> All these helpers are only used in core block code, so move them out of
> the public header.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
