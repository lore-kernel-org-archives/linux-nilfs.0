From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 6/9] mm: set mapping error when launder_pages fails
Date: Thu, 09 Mar 2017 08:28:44 +1100
Message-ID: <8737env4oj.fsf@notabene.neil.brown.name>
References: <20170308162934.21989-1-jlayton@redhat.com> <20170308162934.21989-7-jlayton@redhat.com> <1488996103.3098.4.camel@primarydata.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1488996103.3098.4.camel@primarydata.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Trond Myklebust <trondmy@primarydata.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jlayton@redhat.com" <jlayton@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "adilger@dilger.ca" <adilger@dilger.ca>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "openosd@gmail.com" <openosd@gmail.com>, "jack@suse.cz" <jack@suse.cz>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 09 2017, Trond Myklebust wrote:

> On Wed, 2017-03-08 at 11:29 -0500, Jeff Layton wrote:
>> If launder_page fails, then we hit a problem writing back some inode
>> data. Ensure that we communicate that fact in a subsequent fsync
>> since
>> another task could still have it open for write.
>>=20
>> Signed-off-by: Jeff Layton <jlayton@redhat.com>
>> ---
>> =C2=A0mm/truncate.c | 6 +++++-
>> =C2=A01 file changed, 5 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index 6263affdef88..29ae420a5bf9 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -594,11 +594,15 @@ invalidate_complete_page2(struct address_space
>> *mapping, struct page *page)
>> =C2=A0
>> =C2=A0static int do_launder_page(struct address_space *mapping, struct
>> page *page)
>> =C2=A0{
>> +	int ret;
>> +
>> =C2=A0	if (!PageDirty(page))
>> =C2=A0		return 0;
>> =C2=A0	if (page->mapping !=3D mapping || mapping->a_ops->launder_page=20
>> =3D=3D NULL)
>> =C2=A0		return 0;
>> -	return mapping->a_ops->launder_page(page);
>> +	ret =3D mapping->a_ops->launder_page(page);
>> +	mapping_set_error(mapping, ret);
>> +	return ret;
>> =C2=A0}
>> =C2=A0
>> =C2=A0/**
>
> No. At that layer, you don't know that this is a page error. In the NFS
> case, it could, for instance, just as well be a fatal signal.
>

In that case, would 'ret' be ERESTARTSYS or EAGAIN or similar?
Should mapping_set_error() ignore those?

Thanks,
NeilBrown

> --=20
> Trond Myklebust
> Linux NFS client maintainer, PrimaryData
> trond.myklebust@primarydata.com

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljAd4wACgkQOeye3VZi
gbm1Aw/+KUaI5yaNmIZ/B1joRbcEHuqoYG5C+/qQf/DemKx0xH/GG+zANX6leXfH
rWjSdfIlacmYOi4POgf1cgkcPv04PQIeb+9hZRC32tQL1AOYGMO1Yxsklt65hgto
bbUz1NfKtohdNC4evGem/whT5lZcfEUOB2CM29FnG3rwluAGFrFRoPETaAiWSse8
yg/UG4iScH6zfarf3ts3wf1wQ0vJEuqEMDoP298gQsWFi/ZildFlxbpjF6DTYchF
LugVAQOhk68zrQ2xe9OJKDfiSQyTm2c3GptTotMa8KTvNT8ZFtfaC6lWA/14BZuS
yJ8r1ZVJCprEVR/uYsclTEgouzuUbImnS/QyCoB+Nfd19KkxJAOC8+ssZsuhh/uH
ERSV3j+mnJGpYhvBygUNDxyYwpkjZHPCOvLuIhWnb0u8YR40ldbwjrpN0Vd0ttZK
rhQY6AxSIe9EcM2/NBR4U2KmFjY6/ErBgpBmeG5tOKkANG2od6j/bIwO9o9sIhp2
euOXk/NzD0tqEbvRG9NYk0g9sFIUI+frn1vBj150VwSrcef3wJyOEED6IuXB5W00
anHaZr8QfQXSIvwKPYEWW9TPo34oTMrTuN7cTV2zik275CBqsEEiFpiHLGbJSnHj
JQ7j6EHBdoH9FYH9FIEsGFHm8fHnF9l2VzD0nO9C/09VkpFAt0U=
=lbYc
-----END PGP SIGNATURE-----
--=-=-=--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
