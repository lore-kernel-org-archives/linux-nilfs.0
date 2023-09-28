From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 87/87] fs: move i_blocks up a few places in struct inode
Date: Thu, 28 Sep 2023 14:01:33 -0400
Message-ID: <00ca2e3997cc86401f7fb65d936fe5403abd5627.camel@kernel.org>
References: <20230928110554.34758-1-jlayton@kernel.org>
         <20230928110554.34758-3-jlayton@kernel.org>
         <CAHk-=wij_42Q9WHY898r-gugmT5c-1JJKRh3C+nTUd1hc1aeqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695924109;
        bh=EAdPFsmHcyWayc69u1pNQGVN/Od37LMkwOOQtSvFBiM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bfK28RLdLGgKZCUgDzeWTBKaqWs6brrGRaSyPdFXskOVm0On6PlLojE5M/xCgEEY5
         grpUMo2uaqDtijMvKbHWfOGFJG+vQA/tkSyBcl6qHWL3dn3aU/KYO5L4q/l83Nz1PF
         rjm7ECl0slpI4oU4YRq3Il4iqcNMzLzfgVWdoz5lG6ZAiTp3N12KGI95ZvFcFMlTR+
         jbG318WOr9JpuRBEryTb1XBxjEr4Jw9k8E4/FfV1BqWFd1k5jtZEs5n6naq0zoe6ze
         HRJ/cpQFseJro5/YEKgl8SVwodWHkLRLpC8H6rkjRLoCIio3JUF68vh6UiBMp7cQEp
         W7opbVnaB1VbA==
In-Reply-To: <CAHk-=wij_42Q9WHY898r-gugmT5c-1JJKRh3C+nTUd1hc1aeqQ@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>, Tod

On Thu, 2023-09-28 at 10:41 -0700, Linus Torvalds wrote:
> On Thu, 28 Sept 2023 at 04:06, Jeff Layton <jlayton@kernel.org> wrote:
> >=20
> > Move i_blocks up above the i_lock, which moves the new 4 byte hole to
> > just after the timestamps, without changing the size of the structure.
>=20
> I'm sure others have mentioned this, but 'struct inode' is marked with
> __randomize_layout, so the actual layout may end up being very
> different.
>=20
> I'm personally not convinced the whole structure randomization is
> worth it - it's easy enough to figure out for any distro kernel since
> the seed has to be the same across machines for modules to work, so
> even if the seed isn't "public", any layout is bound to be fairly
> easily discoverable.
>=20
> So the whole randomization only really works for private kernel
> builds, and it adds this kind of pain where "optimizing" the structure
> layout is kind of pointless depending on various options.
>=20
> I certainly *hope* no distro enables that pointless thing, but it's a wor=
ry.
>=20

I've never enabled struct randomization and don't know anyone who does.
I figure if you turn that on, you get to keep all of the pieces when you
start seeing weird performance problems.

I think that we have to optimize for that being disabled. Even without
that though, turning on and off options can change the layout...and then
there are different arches, etc.

I'm using a config derived from the Fedora x86_64 kernel images and hope
that represents a reasonably common configuration. The only conditional
members before the timestamps are based on CONFIG_FS_POSIX_ACL and
CONFIG_SECURITY, which are almost always turned on with most distros.
--=20
Jeff Layton <jlayton@kernel.org>
