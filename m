From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/31] cdrom: remove the unused bdev argument to
 cdrom_open
Date: Wed, 7 Jun 2023 14:10:58 +0200
Message-ID: <f65481fd-3643-b857-4ce0-d2cbe7645fa2@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-3-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:Content-Type:
	Content-Transfer-Encoding:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:Subject:
	MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=ryqRQLt55cFkpDQhpllTMiNkJSMtMxkhugilb9QLZUg=; b=XCKNmBu/yP45VK
	wWwbkjCrCocTnOmmCRAEOM3LXLAagoe/u9BsqKKLEEjp4xQWf0dYHfWpuQ96WSlsabgIDB9cysln5
	aCNPe6piU32wKQIUClNb+tchoKlZftYzZf2Dw76RXQOEtAsphW0I/SwxSQ57mPZRPKdjV2FF1H/Zi
	dJotC6e+4UG8Zxm1ShQyiaY6Cs2D0obbf4k8rUvs+5GokFUodqMgxCHAM/ajtb3nrKv+BksgXU7kh
	BA2HfJbK+tqPKv5qBqQd2c8JIqH+YIi7uD0E+kp8PutSiJoR6zVf/PSbqbFNcR+yD11rW2TxJCmG+
	vw9UET+kgOARPPOSMKVg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686139859; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i3Sp9Vc7BKL2q4ntse5epXVtIDkCZqSEAXdGLa11Y6Y=;
	b=ttYltdtuUZziPOSY/hUCTk4BQAu/PYFzk6nCigjnFuocXjm/EEBuSY1cCHiiwVwgZr6b+o
	HViqSuJsDW/Q//ZAWZXF/gRZpDFJ53Q8dmIV5JSyi/5tWvgvn8bGtcv5a+Y1mhqB0S0APT
	2bUbCWwEdhQ79HwrqnhCMq75lC66+NE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686139859;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i3Sp9Vc7BKL2q4ntse5epXVtIDkCZqSEAXdGLa11Y6Y=;
	b=vfe3ZYUna+XkRBs8Tavq1ONCkn45ty+xLODCzcCXpSMvV9GYUDSA6ZAPHz6GL5XDv6fuMi
	bFI45cclEet2DCDw==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-3-hch@lst.de>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, Phillip Potter <phil@philpotter.co.uk>, Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-um@lists.infradead.org, linux-scsi@vger.kernel.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kerne

On 6/6/23 09:39, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/cdrom/cdrom.c | 3 +--
>   drivers/cdrom/gdrom.c | 2 +-
>   drivers/scsi/sr.c     | 2 +-
>   include/linux/cdrom.h | 3 +--
>   4 files changed, 4 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
