From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v4 0/7] vfs: make immutable files actually immutable
Date: Tue, 25 Jun 2019 14:37:37 -0600
Message-ID: <E84C8EBC-8341-49E5-8EED-0980D158CD50@dilger.ca>
References: <156116141046.1664939.11424021489724835645.stgit@magnolia>
 <20190625103631.GB30156@infradead.org> <20190625180326.GC2230847@magnolia>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D22B91A1-39DB-42F5-937D-A1034700DAE0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=k9wVBI3MNSxJVQhODLuSRbOf+SmT1l1K5RRF5+DdhGM=;
        b=i0tlux+8FNEu0ugkEvUUlD4zKy+jo4LmPTngoA6r4KZwHDBk4l5v9aHPUQEnX49/5g
         z/5lU03hiGUesQ1zP/lPDO/M9fU515Y8oNEl0EKjwdC7dNyZmZQEQEJzGU548pSrAizw
         AlBCGdOUNg8gVK9FeesIiFWJzJ6YbgT5nrsBvzAUmh99yf7q8hQlgwIm8HPdOmToZugA
         nEmrM6blVwgyo7dN5eFPje1f1HwAtA+5XwodCP1ntkD5mvR/FwjSqB5AJn7YMTtfEeor
         5bhYLcubsCaGOlgF0onarHD40ER7JyKcO4a/eslTTHQKCN3GB1Tra4WgBV7T6KYa0chE
         ps9Q==
In-Reply-To: <20190625180326.GC2230847@magnolia>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, matthew.garrett@nebula.com, yuchao0@huawei.com, Theodore Ts'o <tytso@mit.edu>, ard.biesheuvel@linaro.org, Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, dsterba@suse.com, Jaegeuk Kim <jaegeuk@kernel.org>, jk@ozlabs.org, reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs <linux-xfs@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.o>


--Apple-Mail=_D22B91A1-39DB-42F5-937D-A1034700DAE0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 25, 2019, at 12:03 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Tue, Jun 25, 2019 at 03:36:31AM -0700, Christoph Hellwig wrote:
>> On Fri, Jun 21, 2019 at 04:56:50PM -0700, Darrick J. Wong wrote:
>>> Hi all,
>>>=20
>>> The chattr(1) manpage has this to say about the immutable bit that
>>> system administrators can set on files:
>>>=20
>>> "A file with the 'i' attribute cannot be modified: it cannot be =
deleted
>>> or renamed, no link can be created to this file, most of the file's
>>> metadata can not be modified, and the file can not be opened in =
write
>>> mode."
>>>=20
>>> Given the clause about how the file 'cannot be modified', it is
>>> surprising that programs holding writable file descriptors can =
continue
>>> to write to and truncate files after the immutable flag has been =
set,
>>> but they cannot call other things such as utimes, fallocate, unlink,
>>> link, setxattr, or reflink.
>>=20
>> I still think living code beats documentation.  And as far as I can
>> tell the immutable bit never behaved as documented or implemented
>> in this series on Linux, and it originated on Linux.
>=20
> The behavior has never been consistent -- since the beginning you can
> keep write()ing to a fd after the file becomes immutable, but you =
can't
> ftruncate() it.  I would really like to make the behavior consistent.
> Since the authors of nearly every new system call and ioctl since the
> late 1990s have interpreted S_IMMUTABLE to mean "immutable takes =
effect
> everywhere immediately" I resolved the inconsistency in favor of that
> interpretation.
>=20
> I asked Ted what he thought that that userspace having the ability to
> continue writing to an immutable file, and he thought it was an
> implementation bug that had been there for 25 years.  Even he thought
> that immutable should take effect immediately everywhere.
>=20
>> If you want  hard cut off style immutable flag it should really be a
>> new API, but I don't really see the point.  It isn't like the usual
>> workload is to set the flag on a file actively in use.
>=20
> FWIW Ted also thought that since it's rare for admins to set +i on a
> file actively in use we could just change it without forcing everyone
> onto a new api.

On the flip side, it is possible to continue to write to an open fd
after removing the write permission, and this is a problem we've hit
in the real world with NFS export, so real applications do this.

It may be the same case with immutable files, where an application sets
the immutable flag immediately after creation, but continues to write
until it closes the file, so that the file can't be modified by other
processes, and there isn't a risk that the file is missing the immutable
flag if the writing process dies before setting it at the end.

Cheers, Andreas






--Apple-Mail=_D22B91A1-39DB-42F5-937D-A1034700DAE0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl0ShhEACgkQcqXauRfM
H+CbrRAAps35LK3poNlahSXPmgZ5tD+3nAlaeG8JU1XTggnEeHdAHY7wdK713thT
OumdwU7nj1s+0ngxeUxPU/ZVWyuL2LjugpWEfw8lf0N/16hoTIUPBAe7kXce3jb+
eg72QT36y1srscGQ/95rv/DPfelxzC7WiVYV7ZHIIF2Cq31B34cZ7GF0zpi6oZSH
RKioHBOX1Qez1CksvAevhtSGf9e0dF1hNx7gyoVFnGb5V72P7WGGQqWSW4nSJvMe
xhzkT0wLU28MioHsIcnqwnZJdvCb66Z1FGvAwsNItELe2tch4JzZjVR5sbq/g0+Q
CpDZk350WiKaFzo9m1TO2Eiiog2vS1bqO+hZuwf7jPqcfIa6Tu9BdCx9U/bKp/rN
sEtDj+p4qnjTCX2ggozPxye92wzhbF2o25jjoofBh9x9ShQ3GAc/gaTxcR9fpuWJ
UmMwXwKMVXP/kvBaclrbz/zxaeo3ga7z3mFGgzxU6we9M5x1Lo+ppFxRpEPMIVkW
LUEIQ4emE6yqzOWLWH6iPnxly9Jtzye3jsiq6s7RPPUGHn1/SCdhVZG130vKEpkC
IcSmmJGlhPcI8wJ5/gwhAoxm9yLa+t0oH/Y6HUoNc722A3sCVRV5JWoHuK9MKBDK
IPKKud+iKoNON0zr28k4iNyK1XAO+7yAqjfBAmdm0grbW/nItxg=
=YBbV
-----END PGP SIGNATURE-----

--Apple-Mail=_D22B91A1-39DB-42F5-937D-A1034700DAE0--
