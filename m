From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/12] ext4: drop s_umount over opening the
 log device
Date: Thu, 3 Aug 2023 15:25:49 +0200
Message-ID: <20230803132549.s3rz4au5adagwdtf@quack3>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-10-hch@lst.de>
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
 bh=UDPtnYSNM4hfZ7dEGKrwZaeKN847Hc2R5Tx9DTRoPVo=; b=OdcGnSXrbyVeC1JZ/bK4uiGmgK
 hxdrAgZGxJ0yJpQj2qNAKQ0d6Po+pUly4AUyw0sIviPs5KosVxXVFpQgKw8D/ZJWIU9k1vaSP/Pyk
 DgUEFQm89UMCyX9KQ9WlPiUqY7f9qV5xbE+dOyKbqbimXKeLODF/itxAb60lyc/c5LuQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=UDPtnYSNM4hfZ7dEGKrwZaeKN847Hc2R5Tx9DTRoPVo=; b=Hx8hnkLZj0Y0goG5oGPneoLU08
 SdbIaAXZu+t17TOi1aeOo7w2eJXIi7nRZYJlWNO16fPaeyhVjaNic8gQDfgLJcgNfNqjYNqptu4sq
 BQBlCfI25A+fXmDfC45qfKnvc8qi+WaOZerMkRgdzsnR2sQEJ64V7VQUJ9ancjeuKm58=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1691069150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UDPtnYSNM4hfZ7dEGKrwZaeKN847Hc2R5Tx9DTRoPVo=;
 b=E7UZ1iiufRd6HQ+34iZcMYVFaaRe8SvsUrT0SQQvYAiV7H0ow4HMtpOSs0XFfDLsK6mofq
 m8IW+7BHidAqacwvDXpUtYQ/stwlGUq8qmHod1q3RRCoVv9jmLoSr02udJ08ZthhcQ8goZ
 YrmN6xC5D8mhbxcLHkRP7y9BvhATuBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1691069150;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UDPtnYSNM4hfZ7dEGKrwZaeKN847Hc2R5Tx9DTRoPVo=;
 b=B5xphLHA7/FHGZBWy7OlEj6b7ZdzMhzyW2fcwI1Lqy4kV7PED0c6lIhQPKoGPMxCPtcEYu
 4Ivy0DuFbz5vzjCw==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-10-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, Jaegeuk Kim <jaegeuk@kernel.org>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-btrfs@vger.kernel.org

On Wed 02-08-23 17:41:28, Christoph Hellwig wrote:
> Just like get_tree_bdev needs to drop s_umount when opening the main
> device, we need to do the same for the ext4 log device to avoid a
> potential lock order reversal with s_unmount for the mark_dead path.
> 
> It might be preferable to just drop s_umount over ->fill_super entirely,
> but that will require a fairly massive audit first, so we'll do the easy
> version here first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 193d665813b611..2ccb19d345c6dd 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5854,7 +5854,10 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
>  	if (WARN_ON_ONCE(!ext4_has_feature_journal(sb)))
>  		return NULL;
>  
> +	/* see get_tree_bdev why this is needed and safe */
> +	up_write(&sb->s_umount);
>  	bdev = ext4_blkdev_get(j_dev, sb);
> +	down_write(&sb->s_umount);
>  	if (bdev == NULL)
>  		return NULL;
>  
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
