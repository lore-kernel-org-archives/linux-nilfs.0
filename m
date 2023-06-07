From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/31] swsusp: don't pass a stack address to
 blkdev_get_by_path
Date: Wed, 7 Jun 2023 14:22:28 +0200
Message-ID: <bcce493a-9090-8520-f8c6-c9b14754e20e@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-13-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:Content-Type:
	Content-Transfer-Encoding:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:Subject:
	MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=arn/8rfszn+BwKYv0H/rzwIhGaQQQmZS4Q1t60c9DCg=; b=Q814t4Jy4P5c5r
	rVgXZl1sqZNfxymbb1ci/u13/8UvGyN+wqqJn69vfxlbZcmuVWa9aiI+2H8bQgk3gkqf2JBj9lBam
	MvjFWJIThwFtS4W/pu6kM/0eMwj91DwJuEWHYB+si9m81Eq/qMmHpfuluRbGVwnIC4l1ndEzIK5T+
	Yxs5lc2h/Y4zLxtFPT9nlPb67qA2DI58tQs6HPCU1artXG82fh4mTcNVSJrc7R9vCd4TYT1YT2tTz
	LyEiyNapV8r6k6z+fr3GW//CpU66+cJAW4uscVpPeA4Ll7i/hD4Ewbq+px8xKOwM6o7pnX92D3aKG
	E3Dt81zwjcIjmSxWUbTg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686140549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y5/re5ZKHhf+HsiKoBHJy9sV78dj7UGjrSWHzTtQwHY=;
	b=qvZ+tg3HOwDwgvlodDLQayhC5NPnqUtDyXNxfLFWZMX7Q6Zh5MwQdKIV6Vs4PUgW+Ar4aw
	NH2pny9sYDrFlo5nd7lOygNm+OvUPAkOaAeuXW6BJ30lokNS8kdN2s3N2OLQpHh7zY3Wj2
	A3G7JXYPchjGSP+aCqzbNbEc6weWD4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686140549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y5/re5ZKHhf+HsiKoBHJy9sV78dj7UGjrSWHzTtQwHY=;
	b=TBqgiJLiiypHLRGDDE9OJ7AcoFCL4AQWePcbCTYugUg9aHOr0dyrV6pl6bTOOmNJb6mMnq
	9WkSdFkXCITQkMCg==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-13-hch@lst.de>
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
> holder is just an on-stack pointer that can easily be reused by other calls,
> replace it with a static variable that doesn't change.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   kernel/power/swap.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
