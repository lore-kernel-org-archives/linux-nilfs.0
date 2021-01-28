From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH 02/34] block: introduce and use bio_new
Date: Thu, 28 Jan 2021 07:21:42 +0000
Message-ID: <BL0PR04MB6514C554B4AC96866BC1B16FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
 <20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
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
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611818509; x=1643354509;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9Hp1mmxIhP12exuHZUs6f4NIF64JekIbMU2y2gjowsY=;
  b=cittq4uyzE37X04Jqtt2+HGP2Pxgvo0Jb+MJJPC5Bic8mTRNuH9FjoSn
   LwydS9PXOizr7fS/4O3o24qtOxijo5a+87NWZflPDKlJHUNKocFfM+DVj
   IL+SJsVFj0gHs984lummV0KeAqbcHLf1ANwNomZyO1HQ2dE/H8cUx5Ohr
   WQ5PW2p+fzjJoi+c0owaD8+7EQRe6R3qVuQiDJgh1k3zZ6AtqRRz8pMNH
   Nj9IneQ9eJBVj/5qeaXeBjiSpoUCGqVRF0x2y8sf7lmp5Q74ClvEJjXPb
   L5LSQ7U86pqfu77MBF6GQOV2FoXhvE6b6SIKAhfRUS9GaIGYp5lyfrIT8
   Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZQ79VfW37oEjUPhbUXgVDt26btMTlh35TXahcKTIxw=;
 b=hrFaGwglVnPWcvrZYYTSLmKDzWe4Ql8MYzMhE/ZNdzUUxZaQHpa0WUmIc6fKPln6CA7rT0gIe3GHUdejLdgow6Yj1ChwX6iG2QGP9vTtBq0U3ZLqwlykpawLR4D2R+Htay7VfWrlfDvS5SjOdFc1MzrgeW8k4qfHTZmC0UwhJ90=
Content-Language: en-US
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>, "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, ocfs2-devel@oss.oracle.c
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "minchan@kernel.org" <minchan@kernel.org>, "ngupta@vflare.org" <ngupta@vflare.org>, "sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "tytso@mit.edu" <tytso@mit.edu>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "ebiggers@kernel.org" <ebiggers@kernel.org>, "djwong@kernel.org" <djwong@kernel.org>, "shaggy@kernel.org" <shaggy@kernel.org>, konishi.ryusuke

On 2021/01/28 16:12, Chaitanya Kulkarni wrote:=0A=
> Introduce bio_new() helper and use it in blk-lib.c to allocate and=0A=
> initialize various non-optional or semi-optional members of the bio=0A=
> along with bio allocation done with bio_alloc(). Here we also calmp the=
=0A=
> max_bvecs for bio with BIO_MAX_PAGES before we pass to bio_alloc().=0A=
> =0A=
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> ---=0A=
>  block/blk-lib.c     |  6 +-----=0A=
>  include/linux/bio.h | 25 +++++++++++++++++++++++++=0A=
>  2 files changed, 26 insertions(+), 5 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-lib.c b/block/blk-lib.c=0A=
> index fb486a0bdb58..ec29415f00dd 100644=0A=
> --- a/block/blk-lib.c=0A=
> +++ b/block/blk-lib.c=0A=
> @@ -14,17 +14,13 @@ struct bio *blk_next_bio(struct bio *bio, struct bloc=
k_device *bdev,=0A=
>  			sector_t sect, unsigned op, unsigned opf,=0A=
>  			unsigned int nr_pages, gfp_t gfp)=0A=
>  {=0A=
> -	struct bio *new =3D bio_alloc(gfp, nr_pages);=0A=
> +	struct bio *new =3D bio_new(bdev, sect, op, opf, gfp, nr_pages);=0A=
>  =0A=
>  	if (bio) {=0A=
>  		bio_chain(bio, new);=0A=
>  		submit_bio(bio);=0A=
>  	}=0A=
>  =0A=
> -	new->bi_iter.bi_sector =3D sect;=0A=
> -	bio_set_dev(new, bdev);=0A=
> -	bio_set_op_attrs(new, op, opf);=0A=
> -=0A=
>  	return new;=0A=
>  }=0A=
>  =0A=
> diff --git a/include/linux/bio.h b/include/linux/bio.h=0A=
> index c74857cf1252..2a09ba100546 100644=0A=
> --- a/include/linux/bio.h=0A=
> +++ b/include/linux/bio.h=0A=
> @@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio, s=
truct kiocb *kiocb)=0A=
>  	if (!is_sync_kiocb(kiocb))=0A=
>  		bio->bi_opf |=3D REQ_NOWAIT;=0A=
>  }=0A=
> +/**=0A=
> + * bio_new -	allcate and initialize new bio=0A=
> + * @bdev:	blockdev to issue discard for=0A=
> + * @sector:	start sector=0A=
> + * @op:		REQ_OP_XXX from enum req_opf=0A=
> + * @op_flags:	REQ_XXX from enum req_flag_bits=0A=
> + * @max_bvecs:	maximum bvec to be allocated for this bio=0A=
> + * @gfp_mask:	memory allocation flags (for bio_alloc)=0A=
> + *=0A=
> + * Description:=0A=
> + *    Allocates, initializes common members, and returns a new bio.=0A=
> + */=0A=
> +static inline struct bio *bio_new(struct block_device *bdev, sector_t se=
ctor,=0A=
> +				  unsigned int op, unsigned int op_flags,=0A=
> +				  unsigned int max_bvecs, gfp_t gfp_mask)=0A=
> +{=0A=
> +	unsigned nr_bvec =3D clamp_t(unsigned int, max_bvecs, 0, BIO_MAX_PAGES)=
;=0A=
> +	struct bio *bio =3D bio_alloc(gfp_mask, nr_bvec);=0A=
=0A=
I think that depending on the gfp_mask passed, bio can be NULL. So this sho=
uld=0A=
be checked.=0A=
=0A=
> +=0A=
> +	bio_set_dev(bio, bdev);=0A=
> +	bio->bi_iter.bi_sector =3D sector;=0A=
> +	bio_set_op_attrs(bio, op, op_flags);=0A=
=0A=
This function is obsolete. Open code this.=0A=
=0A=
> +=0A=
> +	return bio;=0A=
> +}=0A=
>  =0A=
>  #endif /* __LINUX_BIO_H */=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

