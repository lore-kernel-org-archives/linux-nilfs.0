From: =?UTF-8?Q?=C5=81ukasz_W=C3=B3jcicki?= <lwojcicki-V+nj596LuoKHKKo6LODCOg@public.gmane.org>
Subject: Re: problem with nilfs_cleanerd
Date: Wed, 07 Jul 2010 08:25:22 +0200
Message-ID: <1278483922.8049.4.camel@Stanowisko-25>
References: <1278406961.8438.6.camel@Stanowisko-25>
	 <20100707.150225.135808641.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100707.150225.135808641.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Does this patch eliminate the problem?
Unfortunately I can not generate this error again because after
re-formatting the memory (mkfs.nilfs2) the problem disappeared.

=C5=81ukasz W=C3=B3jcicki=20
=20



Dnia 2010-07-07, =C5=9Bro o godzinie 15:02 +0900, Ryusuke Konishi pisze=
:
> Hi,
>=20
> On Tue, 06 Jul 2010 11:02:41 +0200, =C5=81ukasz_W=C3=B3jcicki wrote:
> > I'am using kernel 2.6.20 with nilf_utils-2-0-18 and nilfs kernel mo=
dule
> > 2-0-20 .
> >=20
> > <1>Unable to handle kernel NULL pointer dereference at virtual addr=
ess
> > 00000000
> > <1>pgd =3D c4eb0000
> > <1>[00000000] *pgd=3Dc4e2d031, *pte=3D00000000, *ppte=3D00000000
> > <4>Internal error: Oops: 17 [#1]
> > <4>Modules linked in:
> > <4>CPU: 0
> > <4>PC is at nilfs_btree_lookup_dirty_buffers+0x10c/0x1ec
> > <4>LR is at 0xc4c99b24
> <snip>
>=20
> Could you try the following patch to narrow down the cause?
>=20
> There is a function lacking range check in the btree code.  This patc=
h
> will catch the defect if the oops comes from a range error.
>=20
> I'm now reviewing the btree code to find out root cause of the range
> error.
>=20
> Thanks,
> Ryusuke Konishi
> ---
>=20
> diff --git a/fs/btree.c b/fs/btree.c
> index beb11fe..9622ff4 100644
> --- a/fs/btree.c
> +++ b/fs/btree.c
> @@ -2007,6 +2007,15 @@ static void nilfs_btree_add_dirty_buffer(struc=
t nilfs_btree *btree,
>  	node =3D (struct nilfs_btree_node *)bh->b_data;
>  	key =3D nilfs_btree_node_get_key(node, 0);
>  	level =3D nilfs_btree_node_get_level(node);
> +	if (level < NILFS_BTREE_LEVEL_NODE_MIN ||
> +	    level >=3D NILFS_BTREE_LEVEL_MAX) {
> +		dump_stack();
> +		printk(KERN_CRIT
> +		       "%s: invalid btree level: %d (ino=3D%lu)\n", __func__,
> +		       level, NILFS_BMAP_I(&btree->bt_bmap)->vfs_inode.i_ino);
> +		return;
> +	}
> +
>  	list_for_each(head, &lists[level]) {
>  		cbh =3D list_entry(head, struct buffer_head, b_assoc_buffers);
>  		cnode =3D (struct nilfs_btree_node *)cbh->b_data;

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
