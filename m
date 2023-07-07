From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/32] block: Provide blkdev_get_handle_* functions
Date: Fri, 7 Jul 2023 14:24:34 +0200
Message-ID: <20230707122434.s46ytxpne42hecni@quack3>
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
 <ZKbgAG5OoHVyUKOG@infradead.org>
 <20230706161433.lj4apushiwguzvdd@quack3>
 <ZKf26fYMDHnTCb29@infradead.org>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1688732675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v97Z4h87RrabL7WLNBXHFysNCdL5KIt8mtxxyrwI0lE=;
        b=LqFRs1c1G67BsNNDLuNq3gTOMo8UAqFT+ZgX0/ce2GYyjoNTkNY3JvymPyQUIIgvdCfdfA
        wvYabjfbqON86k1PsUxAyhGKf+BANbZ0orxg0fUOS7bjyZ5ddpTiVyICESJEtA4U8iKIIb
        0Zu9Qq9rWpT0jHo3EjIE5diazY1476M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1688732675;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v97Z4h87RrabL7WLNBXHFysNCdL5KIt8mtxxyrwI0lE=;
        b=WsVzOxtNAjI8cmGR5IMHwFDPJM5ZBawTTSTtFHjjnpb4nomNuwaP8lcoennzww9M9DfIc5
        k35MoJGFDmLh3vBw==
Content-Disposition: inline
In-Reply-To: <ZKf26fYMDHnTCb29@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Darrick J. Wong" <djwong@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, David Sterba <dsterba@suse.com>, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Gao Xiang <xiang@kernel.org>, Jack Wang <jinpu.wang@ionos.com>, Jaegeuk Kim <jaegeuk@kernel.org>, jfs-discussion@lists.sourceforge.net, Joern Engel <joern@lazybastard.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-btrfs@vger.ker

On Fri 07-07-23 04:28:41, Christoph Hellwig wrote:
> On Thu, Jul 06, 2023 at 06:14:33PM +0200, Jan Kara wrote:
> > > struct bdev_handle *bdev_open_by_path(dev_t dev, blk_mode_t mode,
> > > 		void *holder, const struct blk_holder_ops *hops);
> > > void bdev_release(struct bdev_handle *handle);
> > 
> > I'd maybe use bdev_close() instead of bdev_release() but otherwise I like
> > the new naming.
> 
> We're using release everywhese else, but if Jens is fine with that I
> can live with close.

Dunno, to me words pair like open-close, get-put, acquire-release.
Furthermore e.g. ->release() (and thus blkdev_release()) is called only
when the last file reference is dropped, not when each reference is
dropped, so that's why bdev_release() seems a bit confusing to me.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
