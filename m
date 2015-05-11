From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 8/9] nilfs2: correct live block tracking for GC protection
 period
Date: Mon, 11 May 2015 14:32:50 +0200
Message-ID: <5550A172.8040704@gmx.net>
References: <1430647522-14304-9-git-send-email-andreas.rohner@gmx.net>	<20150511.031512.1036934606749624197.konishi.ryusuke@lab.ntt.co.jp>	<20150511.032323.1250231827423193240.konishi.ryusuke@lab.ntt.co.jp> <20150511.110726.725667075147435663.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i373IdNLFv7Td2VB0sccomfp78qsCswJ5"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150511.110726.725667075147435663.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i373IdNLFv7Td2VB0sccomfp78qsCswJ5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-05-11 04:07, Ryusuke Konishi wrote:
> On Mon, 11 May 2015 03:23:23 +0900 (JST), Ryusuke Konishi wrote:
>> On Mon, 11 May 2015 03:15:12 +0900 (JST), Ryusuke Konishi wrote:
>>> On Sun,  3 May 2015 12:05:21 +0200, Andreas Rohner wrote:
>>>> +/**
>>>> + * nilfs_segctor_dec_nlive_blks_gc - dec. nlive_blks for blocks of =
GC-Inodes
>>>> + * @dat: dat inode
>>>> + * @segbuf: currtent segment buffer
>>>> + * @bh: current buffer head
>>>> + *
>>>> + * Description: nilfs_segctor_dec_nlive_blks_gc() is called if the =
inode to
>>>> + * which @bh belongs is a GC-Inode. In that case it is not necessar=
y to
>>>> + * decrement the previous segment, because at the end of the GC pro=
cess it
>>>> + * will be freed anyway. It is however necessary to check again if =
the blocks
>>>> + * are alive here, because the last check was in userspace without =
the proper
>>>> + * locking. Additionally the blocks protected by the protection per=
iod should
>>>> + * be considered reclaimable. It is assumed, that @bh->b_blocknr co=
ntains
>>>> + * a virtual block number, which is only true if @bh is part of a G=
C-Inode.
>>>> + */
>>>
>>>> +static void nilfs_segctor_dec_nlive_blks_gc(struct inode *dat,
>>>> +					    struct nilfs_segment_buffer *segbuf,
>>>> +					    struct buffer_head *bh) {
>>>> +	bool isreclaimable =3D buffer_nilfs_period_protected(bh) ||
>>>> +				nilfs_dat_is_live(dat, bh->b_blocknr) <=3D 0;
>>>> +
>>>> +	if (!buffer_nilfs_snapshot_protected(bh) && isreclaimable)
>>>> +		segbuf->sb_nlive_blks--;
>>>> +	if (buffer_nilfs_snapshot_protected(bh))
>>>> +		segbuf->sb_nsnapshot_blks++;
>>>> +}
>>>
>>> I have some comments on this function:
>>>
>>>  - The position of the brace "{" violates a CodingStyle rule of funct=
ion.
>>>  - buffer_nilfs_snapshot_protected() is tested twice, but this can be=

>>>    reduced as follows:
>>>
>>> 	if (buffer_nilfs_snapshot_protected(bh))
>>> 		segbuf->sb_nsnapshot_blks++;
>>> 	else if (isreclaimable)
>>> 		segbuf->sb_nlive_blks--;
>>>
>>>  - Additionally, I prefer "reclaimable" to "isreclaimable" since it's=

>>>    simpler and still trivial.
>>>
>>>  - The logic of isreclaimable is counterintuitive. =20
>>>
>>>> +	bool isreclaimable =3D buffer_nilfs_period_protected(bh) ||
>>>> +				nilfs_dat_is_live(dat, bh->b_blocknr) <=3D 0;
>>>
>>>    It looks like buffer_nilfs_period_protected(bh) here implies that
>>>    the block is deleted.  But it's independent from the buffer is
>>>    protected by protection_period or not.
>>>
>>>    Why not just adding "still alive" or "deleted" flag and its
>>>    corresponding vdesc flag instead of adding the period protected
>>>    flag ?
>>>
>>>    If we add the "still alive" flag, which means that the block is
>>>    not yet deleted from the latest checkpoint, then this function
>>>    can be simplified as follows:
>>>
>>> static void nilfs_segctor_dec_nlive_blks_gc(struct inode *dat,
>>> 					    struct nilfs_segment_buffer *segbuf,
>>> 					    struct buffer_head *bh)
>>> {
>>> 	if (buffer_nilfs_snapshot_protected(bh))
>>> 		segbuf->sb_nsnapshot_blks++;
>>
>>> 	else if (!buffer_nilfs_still_alive(bh) ||
>>> 		 nilfs_dat_is_live(dat, bh->b_blocknr) <=3D 0)
>>> 		segbuf->sb_nlive_blks--;
>>
>> This was wrong.  It should be:
>>
>> 	else if (!buffer_nilfs_still_alive(bh) &&
>> 		 nilfs_dat_is_live(dat, bh->b_blocknr) <=3D 0)
>> 		segbuf->sb_nlive_blks--;
>=20
> Sorry for confusing you.  I read again the code, and now feel
> the previous one (the following) was rather correct.
>=20
>>> 	if (buffer_nilfs_snapshot_protected(bh))
>>> 		segbuf->sb_nsnapshot_blks++;
>>> 	else if (!buffer_nilfs_still_alive(bh) ||
>>> 		 nilfs_dat_is_live(dat, bh->b_blocknr) <=3D 0)
>>> 		segbuf->sb_nlive_blks--;
>=20
> Could you confirm which logic correctly implements the algorithm that
> you intended ?

This one is correct. We only have to call nilfs_dat_is_live() if the
block is alive. nilfs_dat_is_live() is intended to confirm that a block
is really live. If we know from userspace, that a block is
dead/reclaimable we do not have to check it again.

Regards,
Andreas Rohner

> Regards,
> Ryusuke Konishi
>=20



--i373IdNLFv7Td2VB0sccomfp78qsCswJ5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJVUKFyAAoJEKnLCnsUYRwBnIkQAIUVV4pZT3IYZMmX81EoC9uW
NU44tqVedVrxCkubJQCseZuhtw/y9eZOc2Y5EVdsZ7oI/CLIVKgUd3GI8X8u/w2k
3/1TmPAOrNyblf0cwdQSZo2gxKQS9UtVFaJP4jprgPAvBszFkRxx46LGYlx1EgQ3
0gia89DnB/7mKElV5zz1aZQaogfzKIlaWO2ETaDF/aYt2p+U8DbEwSQ9GKuMgVgN
yyx6E3XmUuDHDAbH3tLtnNf7GXc6YfiCFcjBwat6olsVY0VyGNGYXA+XAqbwMZlU
8ChnH3AwmgOLNrnjpeOWSYF7cICfnCKUb8RDNObGsMG9SrXrpFm+7qHaS8DB+dPX
phmnfy/xLIu6fHNbmJhheCkLsWxiW38qqK898xDmiESOl/F7zBqEg3IXkjZgrm9U
K6nd7kCJ+wcuHkSaIKt8Yc4hnbIJQwW62Rg1RL0Jntu64mKh+Xdv57fdeJmOfAR2
lTCHqXaAh+ZFHg3hGiQ0zyybkOGUx9liG+1sN3gn5m0KTpMvYDMqKRnpAHYr/65I
c+t3ZqMvKN7lhO6kYIIBzM1c4qhz9U4I/bR0xbYFr8pRUpdAAijEncreVzSGIqxn
2fkAQOjX7KrolUkJK2FqpDa5+f90W678Vhcb60JI/AYdqt/UDCYGbulDVpMquoG+
gn3fUT2Ovi+gx/fl5aiy
=uP37
-----END PGP SIGNATURE-----

--i373IdNLFv7Td2VB0sccomfp78qsCswJ5--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
