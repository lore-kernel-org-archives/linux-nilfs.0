From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/31] btrfs: don't pass a holder for non-exclusive
 blkdev_get_by_path
Date: Wed, 7 Jun 2023 14:24:39 +0200
Message-ID: <02530b35-dcfe-1de3-9f09-5120fc166a28@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-16-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:Content-Type:
	Content-Transfer-Encoding:List-Subscribe:List-Help:List-Post:List-Archive:
	List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:Subject:
	MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=+ea96QFF0SXgGDIicNhMAH3oPVAGSzq/uObiB3cILmA=; b=PSaixKAkyYWmFD
	1MaP7v/j3sMO6fUQ3a40YXz0YVEJlkOlFgEyvtuhwqhxReTcL4x1uSt0n6UR8r2M3wQ6LuGklJJ3K
	NWbv1lk7xkJZKHtWNlPt597yOJ6C9X7c5p9pXH7xBvunkQBdJGUH2lpOr1jXsQGx/L8+NMeYUApfB
	XZKloj+tJvz80U8het6P2wInMxe7ql1TmBN9b9l39N3Z0M3lRJEgZHNsYgukeMcwkSnnPY5BqdzNt
	QQWYsIA6DeGjVTLHi4ASrUCzis49WHwDe3uZJROXyVzs2N1N9QmKeovQoNtQ48dlagmVoz76gUIU9
	AzS/wS4ANqnoVJJpXZ3A==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686140684; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KCRiIM6mgQNiaRN4slOj6w2K+n4GV4y/Ipgg+KcKOaw=;
	b=eWvKc6+XsVMgS2o+jnbgVDiOxQfeWHhu0e8T9BkZN4xA7GtFhLnijTW4uhg0GV6Tf2jI61
	NSUIFb4QGmNRaAc7HobP5WP81kvgm1LEwZVkZpQCtAzVm+ftIzRfzSXOKTc93VRWbO9CEq
	G4uxhhr86DwZ61t/AujdSyJtfIiEsF4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686140684;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KCRiIM6mgQNiaRN4slOj6w2K+n4GV4y/Ipgg+KcKOaw=;
	b=bustZKsI1NR6CLV+CI1hmTL5N+5NnWVOX+XSb0CX0csEo3uCjSxAj612Gua8G/bodioPMl
	Lwx2I58oATCzfNAg==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-16-hch@lst.de>
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
> Passing a holder to blkdev_get_by_path when FMODE_EXCL isn't set doesn't
> make sense, so pass NULL instead and remove the holder argument from the
> call chains the only end up in non-FMODE_EXCL blkdev_get_by_path calls.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/btrfs/super.c   | 16 ++++++----------
>   fs/btrfs/volumes.c | 17 ++++++++---------
>   fs/btrfs/volumes.h |  3 +--
>   3 files changed, 15 insertions(+), 21 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
