From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 28/31] block: replace fmode_t with a
 block-specific type for block open flags
Date: Wed, 7 Jun 2023 14:47:06 +0200
Message-ID: <20230607-bekannt-sonnig-c881b3228862@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-29-hch@lst.de>
 <20230607-kocht-kornfeld-a249c6740e38@brauner>
 <20230607121658.GA13632@lst.de>
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
 bh=2n9gTM7Fbu+GFGmtyRMiVeFghCZhSAGtaiHBEBXO6cM=; b=EG0+S+MLpvPagIaaXG/UH6c0JL
 Q3t5sVidVmcCuoOtw013a1HplIU2x9xUY8+t7dNyA6g6KIi41Fx7/0V5eYRrHf2LVCOt1WymfElE6
 AtF1jhGNd5DY5ldXd4iW5DmaTJL+HNWeWIq3fPDaCu7NUaJ1SAqDBuFfXN0Pa+SV/ySk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=2n9gTM7Fbu+GFGmtyRMiVeFghCZhSAGtaiHBEBXO6cM=; b=KQXOoUzBu28KbdcLD7aWCmY9vV
 MiAkg4/CRkN3mUtWM9Ph2+FfseQa6KKuUWZPaXs2T5crT5DERXrIM/iC0/0Ucl7Bh6Wld/4u5VYfn
 TUKDwpdZAzYNSA3rFTNYmh/Ndq0LuZxfisynlAqV8PYMeOG8foTpuv1q3nH51XiD7Jwk=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1686142035;
 bh=yQwyPVuAGoNHQWOMctts7HBR5pbTnomidetU1VDq7mo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=KY16ohuxDUXf8jhwatNYz+c9Rc4twpyKWnQ7ldIraz/oidrRhEkgKjDaCyV7fu+/D
 hyPEXDLCndSEKQzmdg0sd7RtJsiVXZkKH9YZD/rZPdkgDjEfakY63lgFslkki2sVId
 9aw42j6uL8oCpHNIXRMF+V8IaaIdwDSR9Lo2IhWB34MF3i5ImLcmOTYcFE8YqPxQZy
 vs7oB2HoHfPekk9Wo0uu34t8cgoDOIABPz67CJlm5dSZc8w51ypbNJGMVTv0G8WUu1
 ficc1osgWKt3z27CzmGiEUD/rWC+VhJRlyKTAeZUUWmkZq8ur2sbvHeLvycrfjH5AS
 qC1hC1l2dB0UA==
Content-Disposition: inline
In-Reply-To: <20230607121658.GA13632@lst.de>
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

On Wed, Jun 07, 2023 at 02:16:58PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 07, 2023 at 11:21:14AM +0200, Christian Brauner wrote:
> > On Tue, Jun 06, 2023 at 09:39:47AM +0200, Christoph Hellwig wrote:
> > > The only overlap between the block open flags mapped into the fmode_t and
> > > other uses of fmode_t are FMODE_READ and FMODE_WRITE.  Define a new
> > 
> > and FMODE_EXCL afaict
> 
> FMODE_EXCL isn't used outside the block layer and removed in the last
> patch.
> 
> > > +blk_mode_t file_to_blk_mode(struct file *file)
> > > +{
> > > +	blk_mode_t mode = 0;
> > > +
> > > +	if (file->f_mode & FMODE_READ)
> > > +		mode |= BLK_OPEN_READ;
> > > +	if (file->f_mode & FMODE_WRITE)
> > > +		mode |= BLK_OPEN_WRITE;
> > > +	if (file->f_mode & FMODE_EXCL)
> > > +		mode |= BLK_OPEN_EXCL;
> > > +	if ((file->f_flags & O_ACCMODE) == 3)
> > 
> > I really don't like magic numbers like this.
> 
> I don't like them either, but this is just moved around and not new.
> 
> > Groan, O_RDONLY being defined as 0 strikes again...
> > Becuase of this quirk we internally map
> > 
> > O_RDONLY(0) -> FMODE_READ(1)
> > O_WRONLY(1) -> FMODE_WRITE(2)
> > O_RDWR(3)   -> (FMODE_READ | FMODE_WRITE)
> 
> O_RDWR is 2.

Yeah, that was a typo. See the other mail I sent right after:
https://lore.kernel.org/all/20230607-kribbeln-dilettanten-b901b57dd962@brauner

> 
> > so checking for the raw 3 here is confusing in addition to being a magic
> > number as it could give the impression that what's checked here is
> > (O_WRONLY | O_RDWR) which doesn't make sense...
> 
> Well, that is exactly what we check for.  This is a 30-ish year old
> quirk only used in the floppy driver.

Ugh, it's f_flags. I misread that as f_mode...

This is rather ugly. Then please, make it explicit and check for
== (O_WRONLY | O_RDWR) and leave a brief comment.

Anything's better than that raw 3 in there. We just had fun with
figuring out why there was a raw coredump in fs/coredump.c 30 years
later.
