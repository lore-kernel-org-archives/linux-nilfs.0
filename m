From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete integers
Date: Fri, 29 Sep 2023 09:22:14 -0700
Message-ID: <CAHk-=wjTZ=6QkE_eksL+kzywj2cA_kiY-ydZKoz-+kBQwtNWwQ@mail.gmail.com>
References: <20230928110554.34758-1-jlayton@kernel.org> <20230928110554.34758-2-jlayton@kernel.org>
 <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com> <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
 <20230928171943.GK11439@frogsfrogsfrogs> <6a6f37d16b55a3003af3f3dbb7778a367f68cd8d.camel@kernel.org>
 <20230928212656.GC189345@mit.edu> <CAHk-=wjTynK9BdGbi+8eShU77nkPvipFwRxEd1TSBrw2+LiuDg@mail.gmail.com>
 <CAOQ4uxg5ctY9yCjLOjN1nETAcEuNb2UERnYuDv7PoErdxX=WUw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1696004575; x=1696609375; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1jnYTA/sVS+Z8Orhdi2AQdhdCY0rlD66I6Sde9ZBPos=;
        b=HhLEqN95NAj/aHhk98zfBSe79SqWhJrM2BTXZ8fI71Zoek3/LCzKETu8KEGT1b6Sze
         bHwmuyr/bI2HOAG+tutmb/+CMNNsUeya2v0Yy0LChQvCi3Zrq8k47or5r9fvSdLObzz2
         XEFQ8jZ0DY1sHiFSszHoK3yhSRdemkTpILEWs=
In-Reply-To: <CAOQ4uxg5ctY9yCjLOjN1nETAcEuNb2UERnYuDv7PoErdxX=WUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Nicholas Piggin <npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christophe Leroy <christophe.leroy-2tlSp11Fh4xulxpn9UvDqw@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Christian Borntraeger <borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sven Schnelle <svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm

On Thu, 28 Sept 2023 at 20:50, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> OTOH, it is perfectly fine if the vfs wants to stop providing sub 100ns
> services to filesystems. It's just going to be the fs problem and the
> preserved pre-historic/fine-grained time on existing files would only
> need to be provided in getattr(). It does not need to be in __i_mtime.

Hmm. That sounds technically sane, but for one thing: if the aim is to try to do

 (a) atomic timestamp access

 (b) shrink the inode

then having the filesystem maintain its own timestamp for fine-grained
data will break both of those goals.

Yes, we'd make 'struct inode' smaller if we pack the times into one
64-bit entity, but if btrfs responds by adding mtime fields to "struct
btrfs_inode", we lost the size advantage and only made things worse.

And if ->getattr() then reads those fields without locking (and we
definitely don't want locking in that path), then we lost the
atomicity thing too.

So no. A "but the filesystem can maintain finer granularity" model is
not acceptable, I think.

If we do require nanoseconds for compatibility, what we could possibly
do is say "we guarantee nanosecond values for *legacy* dates", and say
that future dates use 100ns resolution. We'd define "legacy dates" to
be the traditional 32-bit signed time_t.

So with a 64-bit fstime_t, we'd have the "legacy format":

 - top 32 bits are seconds, bottom 32 bits are ns

which gives us that ns format.

Then, because only 30 bits are needed for nanosecond resolution, we
use the top two bits of that ns field as flags. '00' means that legacy
format, and '01' would mean "we're not doing nanosecond resolution,
we're doing 64ns resolution, and the low 6 bits of the ns field are
actually bits 32-37 of the seconds field".

That still gives us some extensibility (unless the multi-grain code
still wants to use the other top bit), and it gives us 40 bits of
seconds, which is quite a lot.

And all the conversion functions will be simple bit field
manipulations, so there are no expensive ops here.

Anyway, I agree with the "let's introduce the accessor functions
first, we can do the 'pack into one word' decisions later".

                Linus
