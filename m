From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 20/31] scsi: replace the fmode_t argument to
 scsi_ioctl with a simple bool
Date: Wed, 7 Jun 2023 15:04:48 +0200
Message-ID: <a11fb73b-6da2-ab25-ca7f-57f449b45d3f@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-21-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=6ru0thZ8nfvt46gXzu50pUmIMhJ4YjfHGU0S7NDPXJc=; b=FpSwVRNd4feQ3XRjCln+tK/HE/
 cM56BzNz2rbZ/6dC7QgcK4LTKVnDYB8eqfc3E60Fjtm9wuuTTEWPxySrlsSnyoiRkXvo7MiBWCt/w
 hYeFF5BKXy1r9QVIXBEiRoVOBttteLKxlViQg66p+JEgBC2OijMU4ZJrPjAwX5gu//sA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
 Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=6ru0thZ8nfvt46gXzu50pUmIMhJ4YjfHGU0S7NDPXJc=; b=FXCliX2uEFtP+8G6npv8Ufp/ii
 jJC2I3iZ8QxAVRfs3YXxQCiOhX8NVsF3GSB/vQShYsQRamhVLdzIrcS2IQJgP7Z2AXeusmCYhabIM
 g/e2AokV0/11SxuH88JPmRxtaG+AXAEQvzvRgyVX6VwjuEE39K0QizGfmsnFerCtIwo8=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1686143089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6ru0thZ8nfvt46gXzu50pUmIMhJ4YjfHGU0S7NDPXJc=;
 b=LDzG/FZX8+A749MhkfcbaO0/pSl5XzJ9kizkc2BlHr+CJ0OvB7HA+RE7WXn85KrExl92Os
 IzQkcBtxo9jxjym01y9CCeiH3S0xsnZG08hq3s27jGEDDyzfepQigu3EzmnUJttRWq9Q0r
 gLAzr1Smr57HQC2DT6141ezeh6kWY2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1686143089;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6ru0thZ8nfvt46gXzu50pUmIMhJ4YjfHGU0S7NDPXJc=;
 b=aPV7dc8iqJjc6zRUQ4+/5tAxmJb5wPICstK1ajAOs5PwpnlIv8obvFxDXAQKxOl16Ptol8
 uk8KJ6nLnB0CvoCw==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-21-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

On 6/6/23 09:39, Christoph Hellwig wrote:
> Instead of passing a fmode_t and only checking it for FMODE_WRITE, pass
> a bool open_for_write to prepare for callers that won't have the fmode_t.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/ch.c         |  3 ++-
>   drivers/scsi/scsi_ioctl.c | 34 +++++++++++++++++-----------------
>   drivers/scsi/sd.c         |  2 +-
>   drivers/scsi/sg.c         |  5 +++--
>   drivers/scsi/sr.c         |  2 +-
>   drivers/scsi/st.c         |  2 +-
>   include/scsi/scsi_ioctl.h |  2 +-
>   7 files changed, 26 insertions(+), 24 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
