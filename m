From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete integers
Date: Thu, 28 Sep 2023 17:18:42 -0700
Message-ID: <CAHk-=wjTynK9BdGbi+8eShU77nkPvipFwRxEd1TSBrw2+LiuDg@mail.gmail.com>
References: <20230928110554.34758-1-jlayton@kernel.org> <20230928110554.34758-2-jlayton@kernel.org>
 <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com> <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
 <20230928171943.GK11439@frogsfrogsfrogs> <6a6f37d16b55a3003af3f3dbb7778a367f68cd8d.camel@kernel.org>
 <20230928212656.GC189345@mit.edu>
Mime-Version: 1.0
Return-path: <linux-unionfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1695946761; x=1696551561; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bvzvBt54YKz6rxhAovyc5UddK2JDmyrig02MAqmRW1o=;
        b=Nco9MwD+ZWekSSLrxtyPFYHbH5dJiwAN5W6KIrG4ASqA3JiKtnRsD/Ty/O6Dv/SVpz
         MlkQfUVjQ7+8xqGsnYMd9RgeE1G7QsSn4/XYu2xfF8JGEV2qOcRTb4Wcgjwd5qT7sCzb
         Mh2+QDlZEFqH1DfM7jXyKV2c6MF3+Kab5MQQA=
In-Reply-To: <20230928212656.GC189345@mit.edu>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jeff Layton <jlayton@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QX

On Thu, 28 Sept 2023 at 14:28, Theodore Ts'o <tytso@mit.edu> wrote:
>
> I don't think anyone will complain about breaking the userspace API
> --- especially since if, say, the CIA was using this for their spies'
> drop boxes, they probably wouldn't want to admit it.  :-)

Well, you will find that real apps do kind of of care.

Just to take a very real example, "git" will very much notice time
granularity issues and care - because git will cache the 'stat' times
in the index.

So if you get a different stat time (because the vfs layer has changed
some granularity), git will then have to check the files carefully
again and update the index.

You can simulate this "re-check all files" with something like this:

    $ time git diff

    real 0m0.040s
    user 0m0.035s
    sys 0m0.264s

    $ rm .git/index && git read-tree HEAD

    $ time git diff

    real 0m9.595s
    user 0m7.287s
    sys 0m2.810s

so the difference between just doing a "look, index information
matches current 'stat' information" and "oops, index does not have the
stat data" is "40 milliseconds" vs "10 seconds".

That's a big difference, and you'd see that each time the granularity
changes. But then once the index file has been updated, it's back to
the good case.

So yes, real programs to cache stat information, and it matters for performance.

But I don't think any actual reasonable program will have
*correctness* issues, though - because there are certainly filesystems
out there that don't do nanosecond resolution (and other operations
like copying trees around will obviously also change times).

Anybody doing steganography in the timestamps is already not going to
have a great time, really.

                 Linus
