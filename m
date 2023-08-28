From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/30] block: also call ->open for incremental
 partition opens
Date: Mon, 28 Aug 2023 14:09:40 +0200
Message-ID: <20230828120940.GB10552@lst.de>
References: <20230608110258.189493-1-hch@lst.de> <20230608110258.189493-2-hch@lst.de> <20230825024457.GD95084@ZenIV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:In-Reply-To:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=zPTpIdXfaVdwmiCVg4v8U9XdCPc/NV9nuRnAhZUD6XY=; b=dS+Kze7b8oO7Ti
	NENi8uNxKfNMR4SV3G8cDyjmg9b7nKsr2g84SyCxqslfTu+5E1vNKw3birtg6OJRUiQWQkL7o2zFi
	RsXMHCLIbn2hMuvFQo3Nxrd1hcpMeBbV3jgHuYXas8Phn+J02yJ4InLmyiYAM2ANdMHNcXwJZIlVT
	9NYsQFyZHwJYBbf/DBBSxFTVTcITohVP47C1OKTFQjroHaRLMjIBfn8GVv/KiTd0yx3fzrxLEf6PY
	5YIzlhuKCkW7Lq1rlzb0S16ajDo2rDrTaHYfg+SLAVTJmy4qquHdlF+yF1Y/iXGUvJ31yfjDMvZfe
	z3k/rCyKfnZBxoQ30xDA==;
Content-Disposition: inline
In-Reply-To: <20230825024457.GD95084@ZenIV>
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org

On Fri, Aug 25, 2023 at 03:44:57AM +0100, Al Viro wrote:
> That got me curious about the ->bd_openers - do we need it atomic?
> Most of the users (and all places that do modifications) are
> under ->open_mutex; the only exceptions are
> 	* early sync logics in blkdev_put(); it's explicitly racy -
> see the comment there.
> 	* callers of disk_openers() in loop and nbd (the ones in
> zram are under ->open_mutex).  There's driver-private exclusion
> around those, but in any case - READ_ONCE() is no worse than
> atomic_read() in those cases.
> 
> Is there something subtle I'm missing here?

No.  When I had to add unlocked readers I did the READ_ONCE initially,
but reviewers though the atomic_t would be better.  I didn't really feel
like arguing so went with this version.
