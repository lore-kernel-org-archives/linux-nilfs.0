From: Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH 12/12] xfs use fs_holder_ops for the log and
 RT devices
Date: Mon, 14 Aug 2023 12:58:56 +0200
Message-ID: <20230814105856.pudqvixopjh3hmtn@andromeda>
References: <20230802154131.2221419-1-hch@lst.de>
 <GiAHRRU8GiDH6Pv5bBBlwPA3hI_9kRXKZCNl7-CoadP8Bf7DiWIUnUt9bG1gBU92q5OuJ4Uy1Negt6JqJWxpeg==@protonmail.internalid>
 <20230802154131.2221419-13-hch@lst.de>
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
 bh=8jyqnNQl/ylK1R1JgJC5U0XdIEwZgI/c97GyfstF/eQ=; b=PuCwPuBBtiIf2zSZi2HgcKvkJV
 WUt4uzjo0PbpkB6MAVBn46eIvbIU/NIMJ3VIgOrgb3f6+/OXTDJ3S0lelpsA8vGonNkOxRwpqN9WQ
 gUq8HbeVtZ7dKVkIhm3GcSnueoOBKYqFxnm77z/nG8kOTM6sNgohcBgc4B6VZWkAwOzU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=8jyqnNQl/ylK1R1JgJC5U0XdIEwZgI/c97GyfstF/eQ=; b=mp0tWRfJrwl/uoOfnZfNyXnuTS
 7tvrfBTG7OVcPYEokYW8MZOC0X+CRYYBZSMa0d/H/5hegFzA5l8cBjBaL2OllvXupNql8nWG5ciz1
 83sO+Uh7oxXzXQAl4rge0pmi2xSM/kB7JRPW35lkAPSLBbEtG/uYH9Vcad0grOvFDvQU=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1692010745;
 bh=M68BqgspvfU5HkD8cXrXN5XkVUNTnVosqqKv0zCZIIk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ada7zEq7w0DjLuBrqXHOSajouseLbVl17YndMQxL3QeWejlDOozfOtF82B8qmwNTA
 7dCpOY37afZc8cxdIIJJwmBSOgHOlJ5bzVUO6YcRgJH+7pnIhpv17Z3Q7hJ1yX3twJ
 KOO+HncXhvEEEB5YKNR1RNqUW0wvB6HisyJDUZ2DOA+IADPGNKO10AJfDgGjU5mnji
 lXLQIy2a5AFWaKwNNAprmmH0HYbwbydTi3s7Ro3RoQTRznof5bS6Qjip6IN9hQwrw3
 FNMGM+A0F4aRNoGmLxg9R2TwJH+atdw5/KmEhxfDPY/tZ0k7M77GLPNf0+NgB9l4gG
 Vu2X2xHwSn73A==
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-13-hch@lst.de>
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

On Wed, Aug 02, 2023 at 05:41:31PM +0200, Christoph Hellwig wrote:
> Use the generic fs_holder_ops to shut down the file system when the
> log or RT device goes away instead of duplicating the logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c | 17 +++--------------
>  1 file changed, 3 insertions(+), 14 deletions(-)

Looks good:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d5042419ed9997..338eba71ff8667 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -377,17 +377,6 @@ xfs_setup_dax_always(
>  	return 0;
>  }
> 
> -static void
> -xfs_bdev_mark_dead(
> -	struct block_device	*bdev)
> -{
> -	xfs_force_shutdown(bdev->bd_holder, SHUTDOWN_DEVICE_REMOVED);
> -}
> -
> -static const struct blk_holder_ops xfs_holder_ops = {
> -	.mark_dead		= xfs_bdev_mark_dead,
> -};
> -
>  STATIC int
>  xfs_blkdev_get(
>  	xfs_mount_t		*mp,
> @@ -396,8 +385,8 @@ xfs_blkdev_get(
>  {
>  	int			error = 0;
> 
> -	*bdevp = blkdev_get_by_path(name, BLK_OPEN_READ | BLK_OPEN_WRITE, mp,
> -				    &xfs_holder_ops);
> +	*bdevp = blkdev_get_by_path(name, BLK_OPEN_READ | BLK_OPEN_WRITE,
> +				    mp->m_super, &fs_holder_ops);
>  	if (IS_ERR(*bdevp)) {
>  		error = PTR_ERR(*bdevp);
>  		xfs_warn(mp, "Invalid device [%s], error=%d", name, error);
> @@ -412,7 +401,7 @@ xfs_blkdev_put(
>  	struct block_device	*bdev)
>  {
>  	if (bdev)
> -		blkdev_put(bdev, mp);
> +		blkdev_put(bdev, mp->m_super);
>  }
> 
>  STATIC void
> --
> 2.39.2
> 
