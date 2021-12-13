From: "NeilBrown" <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/2] Remove inode_congested()
Date: Mon, 13 Dec 2021 15:59:30 +1100
Message-ID: <163937157093.22433.10907067066589299028@noble.neil.brown.name>
References: <163936868317.23860.5037433897004720387.stgit@noble.brown>,
 <163936886725.23860.2403757518009677424.stgit@noble.brown>,
 <YbbKjjFzIzSBJWCn@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639371578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k2gChwyl/DClB5L/ZT8aeA5y8mUKecKjBiO/0QKY6kA=;
        b=EjXT775p7Ib4onLWPFpQRGtiEyslALZ9bZI7hc8yXChzHyJHZ9EjymDPHRmWnb3wI3EY1s
        vo9vutxlhmeMBMdUMMeEjbGVJWUQL5hb9PSTaFMoKMbuijj8cVdgI1cBNUzMjvcavizEkv
        dgBUeJhGUr9ykPpecP8Sbrk2A5kwuig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639371578;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k2gChwyl/DClB5L/ZT8aeA5y8mUKecKjBiO/0QKY6kA=;
        b=hqsL0TIql1g+XAQIVqyCnbaG2whzR8D/uS62k89KHb57moD27i3si5uDxcmNGIU2IL6eAM
        U8UcCBivlGAfW0AA==
In-reply-to: <YbbKjjFzIzSBJWCn-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 13 Dec 2021, Matthew Wilcox wrote:
> On Mon, Dec 13, 2021 at 03:14:27PM +1100, NeilBrown wrote:
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index fb9584641ac7..540aa0ea67ff 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -989,17 +989,6 @@ static inline int is_page_cache_freeable(struct page=
 *page)
> >  	return page_count(page) - page_has_private(page) =3D=3D 1 + page_cache_=
pins;
> >  }
> > =20
> > -static int may_write_to_inode(struct inode *inode)
> > -{
> > -	if (current->flags & PF_SWAPWRITE)
> > -		return 1;
> > -	if (!inode_write_congested(inode))
> > -		return 1;
> > -	if (inode_to_bdi(inode) =3D=3D current->backing_dev_info)
> > -		return 1;
> > -	return 0;
> > -}
>=20
> Why is it safe to get rid of the PF_SWAPWRITE and current->backing_dev_info
> checks?

Ask George Bool.
If inode_write_congested() returns False, then may_write_to_inode() will
always return True.

NeilBrown


>=20
> > @@ -1158,8 +1147,6 @@ static pageout_t pageout(struct page *page, struct =
address_space *mapping)
> >  	}
> >  	if (mapping->a_ops->writepage =3D=3D NULL)
> >  		return PAGE_ACTIVATE;
> > -	if (!may_write_to_inode(mapping->host))
> > -		return PAGE_KEEP;
> > =20
> >  	if (clear_page_dirty_for_io(page)) {
> >  		int res;
>=20
>=20
