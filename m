From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete
 integers
Date: Thu, 28 Sep 2023 13:06:03 -0400
Message-ID: <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
References: <20230928110554.34758-1-jlayton@kernel.org>
         <20230928110554.34758-2-jlayton@kernel.org>
         <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695920779;
        bh=DNM/VlOuUT51G0bnMvXw+94sqfHee3c68K5vLwQuau4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=T1EG9wCsmdavqbCDgZQmRYDY2hTjqQ8HvqU7HakqZRoba0+m8x7Xb0PPxNH54fTbK
         gxOvKBrhR/NUHAqOFYLgQFvCS4fbqqpdpyJ0meCz+VJBZB5WwUDXaofxixCnDwGA2b
         xVhvTR3lvjwhcUNCr4cL+zM4prum42dBj/EqssN3wQ5xwZohTtnO5wenm4djJ5rTsg
         au+O/I2DWLjGqSGQ9+pJFDrXNkgJ5uSZlH8zfxoOHymWjEqjSumVZbYplcXqZfm3+f
         KDfZ0aAr31be94G8szYCClaMWLFdZEYGpG76Y3w4tHoT3E7mgxWznMj5HFQTi8O+xa
         SaKUjb/2UX2Ww==
In-Reply-To: <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-rdma@vger.kernel.org, linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-efi@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, gfs2@lists.linux.dev, linux-um@lists.infradead.org, linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-d

On Thu, 2023-09-28 at 11:48 -0400, Arnd Bergmann wrote:
> On Thu, Sep 28, 2023, at 07:05, Jeff Layton wrote:
> > This shaves 8 bytes off struct inode, according to pahole.
> >=20
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
>=20
> FWIW, this is similar to the approach that Deepa suggested
> back in 2016:
>=20
> https://lore.kernel.org/lkml/1452144972-15802-3-git-send-email-deepa.kern=
el@gmail.com/
>=20
> It was NaKed at the time because of the added complexity,
> though it would have been much easier to do it then,
> as we had to touch all the timespec references anyway.
>=20
> The approach still seems ok to me, but I'm not sure it's worth
> doing it now if we didn't do it then.
>=20

I remember seeing those patches go by. I don't remember that change
being NaK'ed, but I wasn't paying close attention at the time=20

Looking at it objectively now, I think it's worth it to recover 8 bytes
per inode and open a 4 byte hole that Amir can use to grow the
i_fsnotify_mask. We might even able to shave off another 12 bytes
eventually if we can move to a single 64-bit word per timestamp.=20

It is a lot of churn though.
--=20
Jeff Layton <jlayton@kernel.org>
