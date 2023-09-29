From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete integers
Date: Fri, 29 Sep 2023 06:27:57 +0300
Message-ID: <CAOQ4uxjTpPPUa3VXW+DWKy72JABOZBCXD6pjNk-FhJZWnqvNPA@mail.gmail.com>
References: <20230928110554.34758-1-jlayton@kernel.org> <20230928110554.34758-2-jlayton@kernel.org>
 <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com> <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
 <20230928171943.GK11439@frogsfrogsfrogs>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695958089; x=1696562889; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IiAb/i1gc98L6SazD4d4ItKm7HOWY4Sc1dUvsARnIt8=;
        b=Zj6wu2hbBXtbYyTQuFA71C53wbF8PuIPcek7IRZ5p5evtCnhM4RHLS1ciB8ceh/nam
         AazrV5vm/uC2lXnN6Oi09ElGY7GqmeLgUPi7gERFik0UB2dcHZPMxLEzaAHc0KizeCcJ
         jy+iCmTdIuJvAx4iVchMJciykIgMZGLaLtji5QTDBg1zO8WyQ1X70ZdoW5ZcjlhgAimF
         GneNVj6PBDgt5LT0ZFaMAwwHlIojzeBSnC7YTWSSWAn5ilhjP8I4llftBM2mLboWhMvN
         pu7fLkxmrB+0/olPBxMkkiJXYp0il+Anbp5cqKpOpjUe8ZE97A9IJQU+ZRU+ZOMzZvKI
         3aUA==
In-Reply-To: <20230928171943.GK11439@frogsfrogsfrogs>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Theodore Ts'o <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2Z

On Thu, Sep 28, 2023 at 8:19=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Thu, Sep 28, 2023 at 01:06:03PM -0400, Jeff Layton wrote:
> > On Thu, 2023-09-28 at 11:48 -0400, Arnd Bergmann wrote:
> > > On Thu, Sep 28, 2023, at 07:05, Jeff Layton wrote:
> > > > This shaves 8 bytes off struct inode, according to pahole.
> > > >
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > >
> > > FWIW, this is similar to the approach that Deepa suggested
> > > back in 2016:
> > >
> > > https://lore.kernel.org/lkml/1452144972-15802-3-git-send-email-deepa.=
kernel@gmail.com/
> > >
> > > It was NaKed at the time because of the added complexity,
> > > though it would have been much easier to do it then,
> > > as we had to touch all the timespec references anyway.
> > >
> > > The approach still seems ok to me, but I'm not sure it's worth
> > > doing it now if we didn't do it then.
> > >
> >
> > I remember seeing those patches go by. I don't remember that change
> > being NaK'ed, but I wasn't paying close attention at the time
> >
> > Looking at it objectively now, I think it's worth it to recover 8 bytes
> > per inode and open a 4 byte hole that Amir can use to grow the
> > i_fsnotify_mask. We might even able to shave off another 12 bytes
> > eventually if we can move to a single 64-bit word per timestamp.
>
> I don't think you can, since btrfs timestamps utilize s64 seconds
> counting in both directions from the Unix epoch.  They also support ns
> resolution:
>
>         struct btrfs_timespec {
>                 __le64 sec;
>                 __le32 nsec;
>         } __attribute__ ((__packed__));
>
> --D
>

Sure we can.
That's what btrfs_inode is for.
vfs inode also does not store i_otime (birth time) and there is even a
precedent of vfs/btrfs variable size mismatch:

        /* full 64 bit generation number, struct vfs_inode doesn't have a b=
ig
         * enough field for this.
         */
        u64 generation;

If we decide that vfs should use "bigtime", btrfs pre-historic
timestamps are not a show stopper.

Thanks,
Amir.
