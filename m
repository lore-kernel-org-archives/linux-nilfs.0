From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 87/87] fs: move i_blocks up a few places in struct inode
Date: Thu, 28 Sep 2023 08:01:50 -0400
Message-ID: <f88106b26a2b647a1541d049999d5546d2ee3e51.camel@kernel.org>
References: <20230928110554.34758-1-jlayton@kernel.org>
	 <20230928110554.34758-3-jlayton@kernel.org>
	 <CAOQ4uxjSrgGr+6UOs4ADGYCderpQ7hAaPjNmB1DExAPLQQsHSg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf+bounces-11047-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695902525;
	bh=1OUz3HfWq12NDsf5pt/6tI4U8Mw0C+kMAWU6iE/wPW8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=X75jpHewuenH5i4yKP6hTRRG96bBnvYSW9ppyaPCvnjRr7Vm9FFZm7UX9cHhEdgJN
	 9sWsiJl4JoQqsZw/GKoi7gqY0vw1WSuYAKrfeyF1owUUDgi337zCsV6xBykTFrjqQ4
	 1IMm02SWv3ExmYV6PPhf6pdloK7xjV68MtysVko9J4sCrAu5RV7rZ7A69VK3LrHZj/
	 A70QTwuFIQFa4pBSyL7/hVskPkmrikqba+e0r1Z/ds7+Y2X+m8S6nvykGKta//EbMF
	 i8R56KOYB+jvupadzk05Se+6sdUCAkxdoK6c3HGUXdwYBTc4QSGFZzFBPryJ+pbGMH
	 lSy4ugTII5Mvw==
In-Reply-To: <CAOQ4uxjSrgGr+6UOs4ADGYCderpQ7hAaPjNmB1DExAPLQQsHSg@mail.gmail.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Carlos Llamas <>

On Thu, 2023-09-28 at 14:35 +0300, Amir Goldstein wrote:
> On Thu, Sep 28, 2023 at 2:06=E2=80=AFPM Jeff Layton <jlayton@kernel.org> =
wrote:
> >=20
> > The recent change to use discrete integers instead of struct timespec64
> > in struct inode shaved 8 bytes off of it, but it also moves the i_lock
> > into the previous cacheline, away from the fields that it protects.
> >=20
> > Move i_blocks up above the i_lock, which moves the new 4 byte hole to
> > just after the timestamps, without changing the size of the structure.
> >=20
>=20
> Instead of creating an implicit hole, can you please move i_generation
> to fill the 4 bytes hole.
>=20
> It makes sense in the same cache line with i_ino and I could
> use the vacant 4 bytes hole above i_fsnotify_mask to expand the
> mask to 64bit (the 32bit event mask space is running out).
>=20
> Thanks,
> Amir.
>=20

Sounds like a plan. Resulting struct inode size is the same (616 bytes
with my kdevops kconfig). BTW: all of these changes are in my "amtime"
branch if anyone wants to pull them down.
--
Jeff Layton <jlayton@kernel.org>

