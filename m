From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete integers
Date: Fri, 29 Sep 2023 06:50:13 +0300
Message-ID: <CAOQ4uxg5ctY9yCjLOjN1nETAcEuNb2UERnYuDv7PoErdxX=WUw@mail.gmail.com>
References: <20230928110554.34758-1-jlayton@kernel.org> <20230928110554.34758-2-jlayton@kernel.org>
 <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com> <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
 <20230928171943.GK11439@frogsfrogsfrogs> <6a6f37d16b55a3003af3f3dbb7778a367f68cd8d.camel@kernel.org>
 <20230928212656.GC189345@mit.edu> <CAHk-=wjTynK9BdGbi+8eShU77nkPvipFwRxEd1TSBrw2+LiuDg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695959425; x=1696564225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LYYbHmRBUQu7YjfKhJdocL7dPfjriCkGg2JwzJsWdwM=;
        b=OgS0+rHVheAoiR5EnChiZq2pVgkTwoqklKOc2O2TXqKHvKq8kU2A7Wz5bYw1kGtFqI
         aqXIefdua592BhK8tIohJ8bNNn5WQlaegSE0cLv9wCLeW1C5R2pivJS8Z81dN5avSQK9
         yKR0a7PRt86/Rm3KerAawe/6QQQGfdflrGMJa7sjwn7MHNR5TJUAtSZZ/g9f6fkQMvgW
         vD/sMK5JqyNJXDSKWVkoZpNdpzIHMdlCjB7daouB4b+BgkZry7wqQ+lKghcMaG5hqDFI
         7VZcrZAQA4w2SNB7X9tmCU5+W0cs6a5SecHwc4O1krlgRjWDQkpk++JkqMD3Fah7hKTL
         W1Ww==
In-Reply-To: <CAHk-=wjTynK9BdGbi+8eShU77nkPvipFwRxEd1TSBrw2+LiuDg@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm

On Fri, Sep 29, 2023 at 3:19=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
...
> So yes, real programs to cache stat information, and it matters for perfo=
rmance.
>
> But I don't think any actual reasonable program will have
> *correctness* issues, though -

I beg to disagree.

> because there are certainly filesystems
> out there that don't do nanosecond resolution (and other operations
> like copying trees around will obviously also change times).
>
> Anybody doing steganography in the timestamps is already not going to
> have a great time, really.
>

Your thesis implies that all applications are portable across different
filesystems and all applications are expected to cope with copying
trees around.

There are applications that work on specific filesystems and those
applications are very much within sanity if they expect that past
observed values of nsec will not to change if the file was not changed.

But even if we agree that will "only" hurt performance, your example of
performance hit (10s of git diff) is nowhere close to the performance
hit of invalidating the mtime cache of billions of files at once (i.e. afte=
r
kernel upgrade), which means that rsync-like programs need to
re-read all the data from remote locations.

I am not saying that filesystems cannot decide to *stop storing nsec
granularity* from this day forth, but like btrfs pre-historic timestamps,
those fs have an obligation to preserve existing metadata, unless
users opted to throw it away.

OTOH, it is perfectly fine if the vfs wants to stop providing sub 100ns
services to filesystems. It's just going to be the fs problem and the
preserved pre-historic/fine-grained time on existing files would only
need to be provided in getattr(). It does not need to be in __i_mtime.

Thanks,
Amir.
