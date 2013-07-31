From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [PATCH v2] nilfs2: remove double bio_put() in
 nilfs_end_bio_write() for BIO_EOPNOTSUPP error
Date: Wed, 31 Jul 2013 14:36:47 +0400
Message-ID: <1375267007.2364.7.camel@slavad-ubuntu>
References: <1374847154.3671.70.camel@slavad-ubuntu>
	 <20130727.120232.356926182.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kernel-janitors-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=uwGONRCaDS96jsXS/I/a2xDUBjfY6wQtPB7Xi7n7JtM=;
	b=fwqsvTUpqRaTpq2DunJ8rEFiXgDxi9Bc1tmOLEVi9J+kI+NbLwr19fg0cwf9BN/2RzXLYQyUixu6ew9aIX7Dwb/aEMVlmkp8+tRAHUfYTJ/+cXoTppTgljOiZrf3EnAQ;
In-Reply-To: <20130727.120232.356926182.konishi.ryusuke@lab.ntt.co.jp>
Sender: kernel-janitors-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: DanCarpenter <dan.carpenter@oracle.com>, linux-nilfs <linux-nilfs@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, kernel-janitors@vger.kernel.org, akpm@linux-foundation.org, =?ISO-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin@gmail.com>

Hi Ryusuke,

On Sat, 2013-07-27 at 12:02 +0900, Ryusuke Konishi wrote:

[snip]
>=20
> This decrement looks wrong.
>=20
> Otherwise, your change of nilfs_segbuf_submit_bio() is just a
> equivalent transformation and doesn't fix problem, that is, a mismatc=
h
> of the number of calls between complete() and wait_for_completion().
>=20
> In your patch, nilfs_end_bio_write() function calls the complete()
> routine as before even if it received an EOPNOTSUPP error.
>=20
> In that case, segbuf->sb_nbio must be incremented to call
> wait_for_completion() the right number of times.
>=20
> Note that wait_for_completion() is called based on the count of
> segbuf->sb_nbio even if nilfs_segbuf_submit_bio() returns an error.
> This is performed through the following path:
>=20
>             nilfs_segbuf_submit_bio
>           nilfs_segbuf_submit_bh
>         nilfs_segbuf_write
>       nilfs_write_logs
>     nilfs_segctor_write
>   nilfs_segctor_do_construct
>     nilfs_segctor_abort_construction
>       nilfs_wait_on_logs
>         nilfs_segbuf_wait
>           wait_for_completion
>             (repeated for the number of times of segbuf->sb_nbio)
>=20
>=20
> If you think this is a separate problem, then it should be fixed in
> another patch and nilfs_segbuf_submit_bio() should not be touched in
> this patch.
>=20

Sorry for delay with working on this patch. Now I am investigating
the issue (Kernel Bug: unable to handle kernel paging request) that it
was reported by J=C3=A9r=C3=B4me Poulin <jeromepoulin@gmail.com>. I sus=
pect that
the reported issue is related to this patch. So, I feel a necessity to
investigate the issue more deeply before continuation to work on this
patch.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
