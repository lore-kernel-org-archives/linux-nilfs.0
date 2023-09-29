From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 87/87] fs: move i_blocks up a few places in struct inode
Date: Fri, 29 Sep 2023 11:32:49 +0200
Message-ID: <20230929-keimt-umspannen-bfd12d2c2033@brauner>
References: <20230928110554.34758-1-jlayton@kernel.org>
 <20230928110554.34758-3-jlayton@kernel.org>
 <CAHk-=wij_42Q9WHY898r-gugmT5c-1JJKRh3C+nTUd1hc1aeqQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-unionfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695980011;
        bh=5rEQjJQmUmhQcZE/S/zbC0z+O4aP1HcivNZvR+uMTdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j3Z7MPGXgH3qxJhUlGKswKaevoMz5lRlYfLKv517rB572Uft036HOzVnh6y+Fta2y
         IoP7pRk6lJWa27fv+jFujIlmXsGfS+YQww12NsbvPCYDl6f8XCPE+CtURkcHaeicsG
         yrkS/+0BXoBXAhDuBIWkGS4iWyGcgZc4uj5K1I6XTsFJQGfVSUCd06bbdxYUiSeitY
         kWvaORdHP4IXSdIX2Ck5PihMbYV+j7YqPan4YQc6tbETcfSrUPTc518VDuKuEt3jeG
         gYpsCzcJzJ2TfBOID0I9Ah10OPTMXVGJPcaLChcuIuOHlJVeXlo8F4Hi+JnhGg6W4h
         6HAwcZKgDftHQ==
Content-Disposition: inline
In-Reply-To: <CAHk-=wij_42Q9WHY898r-gugmT5c-1JJKRh3C+nTUd1hc1aeqQ@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, Todd Kjos <>

On Thu, Sep 28, 2023 at 10:41:34AM -0700, Linus Torvalds wrote:
> On Thu, 28 Sept 2023 at 04:06, Jeff Layton <jlayton@kernel.org> wrote:
> >
> > Move i_blocks up above the i_lock, which moves the new 4 byte hole to
> > just after the timestamps, without changing the size of the structure.
> 
> I'm sure others have mentioned this, but 'struct inode' is marked with
> __randomize_layout, so the actual layout may end up being very
> different.
> 
> I'm personally not convinced the whole structure randomization is
> worth it - it's easy enough to figure out for any distro kernel since
> the seed has to be the same across machines for modules to work, so
> even if the seed isn't "public", any layout is bound to be fairly
> easily discoverable.
> 
> So the whole randomization only really works for private kernel
> builds, and it adds this kind of pain where "optimizing" the structure
> layout is kind of pointless depending on various options.
> 
> I certainly *hope* no distro enables that pointless thing, but it's a worry.

They don't last we checked. Just last cycle we moved stuff in struct
file around to optimize things and we explicitly said we don't give a
damn about struct randomization. Anyone who enables this will bleed
performance pretty badly, I would reckon.
