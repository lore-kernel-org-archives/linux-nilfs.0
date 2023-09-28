From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 87/87] fs: move i_blocks up a few places in struct inode
Date: Thu, 28 Sep 2023 10:41:34 -0700
Message-ID: <CAHk-=wij_42Q9WHY898r-gugmT5c-1JJKRh3C+nTUd1hc1aeqQ@mail.gmail.com>
References: <20230928110554.34758-1-jlayton@kernel.org> <20230928110554.34758-3-jlayton@kernel.org>
Mime-Version: 1.0
Return-path: <linux-unionfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1695922935; x=1696527735; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UoV8bp+GLn88RdeFyi+3G/jZGwWmlguHsi2KfbyyFTc=;
        b=UIL8UEvsGfYzxudq40RaHHMTyfacOSHnkm4T4Ubs5jJpWzXbBgqtus6UEVbOrGViAb
         HUwzQHNTfffpIHzZI0VTNSgD/GsGHJN/Oj0zqqfuvAMGxWf7tA5QHaOmBc30x1EKC1ha
         mjuxVcUa0K/sSG3QOIF68B+SAvLA6e8RhBMWs=
In-Reply-To: <20230928110554.34758-3-jlayton@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>

On Thu, 28 Sept 2023 at 04:06, Jeff Layton <jlayton@kernel.org> wrote:
>
> Move i_blocks up above the i_lock, which moves the new 4 byte hole to
> just after the timestamps, without changing the size of the structure.

I'm sure others have mentioned this, but 'struct inode' is marked with
__randomize_layout, so the actual layout may end up being very
different.

I'm personally not convinced the whole structure randomization is
worth it - it's easy enough to figure out for any distro kernel since
the seed has to be the same across machines for modules to work, so
even if the seed isn't "public", any layout is bound to be fairly
easily discoverable.

So the whole randomization only really works for private kernel
builds, and it adds this kind of pain where "optimizing" the structure
layout is kind of pointless depending on various options.

I certainly *hope* no distro enables that pointless thing, but it's a worry.

               Linus
