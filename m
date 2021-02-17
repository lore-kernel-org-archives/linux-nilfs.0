From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH 29/34] power/swap: use bio_new in hib_submit_io
Date: Wed, 17 Feb 2021 23:02:58 +0100
Message-ID: <20210217220257.GA10791@amd>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
 <20210128071133.60335-30-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Return-path: <xen-devel-bounces@lists.xenproject.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
Content-Disposition: inline
In-Reply-To: <20210128071133.60335-30-chaitanya.kulkarni@wdc.com>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, axboe@kernel.dk, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, konrad.wilk@oracle.com, roger.pau@citrix.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, agk@redhat.com, snitzer@redhat.com, hch@lst.de, sagi@grimberg.me, martin.petersen@oracle.com, viro@zeniv.linux.org.uk, tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org, djwong@kernel.org, shaggy@kernel.org, konishi.ryusuke@gm


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
>=20
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index c73f2e295167..e92e36c053a6 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -271,13 +271,12 @@ static int hib_submit_io(int op, int op_flags, pgof=
f_t page_off, void *addr,
>  		struct hib_bio_batch *hb)
>  {
>  	struct page *page =3D virt_to_page(addr);
> +	sector_t sect =3D page_off * (PAGE_SIZE >> 9);
>  	struct bio *bio;
>  	int error =3D 0;
> =20
> -	bio =3D bio_alloc(GFP_NOIO | __GFP_HIGH, 1);
> -	bio->bi_iter.bi_sector =3D page_off * (PAGE_SIZE >> 9);
> -	bio_set_dev(bio, hib_resume_bdev);
> -	bio_set_op_attrs(bio, op, op_flags);
> +	bio =3D bio_new(hib_resume_bdev, sect, op, op_flags, 1,
> +		      GFP_NOIO | __GFP_HIGH);
> =20

C function with 6 arguments... dunno. Old version looks comparable or
even more readable...

Best regards,
							Pavel

--=20
http://www.livejournal.com/~pavelmachek

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAtkpEACgkQMOfwapXb+vL5ywCguk9XRtMJ4/rJgwKlR42qzH7B
ww4AoK8H3c5uHgpu/eHAUqpvoYMrxHuL
=Rk1V
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--

