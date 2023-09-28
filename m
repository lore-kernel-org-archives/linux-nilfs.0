From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete
 integers
Date: Thu, 28 Sep 2023 13:09:08 -0400
Message-ID: <555fd53b72742fe8a8d2b67c80502f749631d773.camel@kernel.org>
References: <20230928110554.34758-1-jlayton@kernel.org>
         <20230928110554.34758-2-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695920964;
        bh=zRV/ipMOOeHJFSr00KRb3DbkWuWIfMUsmholMiYqIFk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RTCWP38X/3Qiq9e2eoLruFi6qLhhyLJQrL65PrzDXWj1P7d+rG2Zhi5BPUongplET
         wsh5RnIrkn2G9TM6HAAN0NYZV5F3YR+mvgQFtP+9DfawGUb0VUEGN4ZEWFes0Iqc9f
         GfOE5yeYJ7UoCrij4lXLrG+jRW8wnHjCzfKNNQxN4dSF4K07yMiaZJqV+VHP19Z5O0
         9Eizi+4+cRTlhImq1fbs7Tb7Mmc79AROTIyl6OUF1ztlUjMfm5tqzXneCy0nyt31m3
         teqvuavXAiJG2oyvZuxOiGcbkwGZED723LL7ZyPIvGZsh/B5aAGwbzTt8Xw0FUHUy0
         P2xkFw6PYWKrw==
In-Reply-To: <20230928110554.34758-2-jlayton@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-rdma@vger.kernel.org, linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-efi@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, gfs2@lists.linux.dev, linux-um@lists.infradead.org, linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-d

On Thu, 2023-09-28 at 07:05 -0400, Jeff Layton wrote:
> This shaves 8 bytes off struct inode, according to pahole.
>=20
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/fs.h | 32 +++++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 831657011036..de902ff2938b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -671,9 +671,12 @@ struct inode {
>  	};
>  	dev_t			i_rdev;
>  	loff_t			i_size;
> -	struct timespec64	__i_atime; /* use inode_*_atime accessors */
> -	struct timespec64	__i_mtime; /* use inode_*_mtime accessors */
> -	struct timespec64	__i_ctime; /* use inode_*_ctime accessors */
> +	time64_t		i_atime_sec;
> +	time64_t		i_mtime_sec;
> +	time64_t		i_ctime_sec;
> +	u32			i_atime_nsec;
> +	u32			i_mtime_nsec;
> +	u32			i_ctime_nsec;
>  	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
>  	unsigned short          i_bytes;
>  	u8			i_blkbits;
> @@ -1519,7 +1522,9 @@ struct timespec64 inode_set_ctime_current(struct in=
ode *inode);
>   */
>  static inline struct timespec64 inode_get_ctime(const struct inode *inod=
e)
>  {
> -	return inode->__i_ctime;
> +	struct timespec64 ts =3D { .tv_sec  =3D inode->i_ctime_sec,
> +				 .tv_nsec =3D inode->i_ctime_nsec };
> +	return ts;
>  }
>=20
>
> =20
>  /**
> @@ -1532,7 +1537,8 @@ static inline struct timespec64 inode_get_ctime(con=
st struct inode *inode)
>  static inline struct timespec64 inode_set_ctime_to_ts(struct inode *inod=
e,
>  						      struct timespec64 ts)
>  {
> -	inode->__i_ctime =3D ts;
> +	inode->i_ctime_sec =3D ts.tv_sec;
> +	inode->i_ctime_nsec =3D ts.tv_sec;

Bug above and in the other inode_set_?time_to_ts() functions. This isn't
setting the nsec field correctly.

>  	return ts;
>  }
>=20
>=20


> =20
> @@ -1555,13 +1561,17 @@ static inline struct timespec64 inode_set_ctime(s=
truct inode *inode,
> =20
>  static inline struct timespec64 inode_get_atime(const struct inode *inod=
e)
>  {
> -	return inode->__i_atime;
> +	struct timespec64 ts =3D { .tv_sec  =3D inode->i_atime_sec,
> +				 .tv_nsec =3D inode->i_atime_nsec };
> +
> +	return ts;
>  }
> =20
>  static inline struct timespec64 inode_set_atime_to_ts(struct inode *inod=
e,
>  						      struct timespec64 ts)
>  {
> -	inode->__i_atime =3D ts;
> +	inode->i_atime_sec =3D ts.tv_sec;
> +	inode->i_atime_nsec =3D ts.tv_sec;
>  	return ts;
>  }
> =20
> @@ -1575,13 +1585,17 @@ static inline struct timespec64 inode_set_atime(s=
truct inode *inode,
> =20
>  static inline struct timespec64 inode_get_mtime(const struct inode *inod=
e)
>  {
> -	return inode->__i_mtime;
> +	struct timespec64 ts =3D { .tv_sec  =3D inode->i_mtime_sec,
> +				 .tv_nsec =3D inode->i_mtime_nsec };
> +
> +	return ts;
>  }
> =20
>  static inline struct timespec64 inode_set_mtime_to_ts(struct inode *inod=
e,
>  						      struct timespec64 ts)
>  {
> -	inode->__i_mtime =3D ts;
> +	inode->i_atime_sec =3D ts.tv_sec;
> +	inode->i_atime_nsec =3D ts.tv_sec;

Doh! s/atime/mtime/ in the above lines.

>  	return ts;
>  }
> =20

Both bugs are fixed in my tree.
--=20
Jeff Layton <jlayton@kernel.org>
