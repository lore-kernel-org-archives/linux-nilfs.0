From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete
 integers
Date: Thu, 28 Sep 2023 13:40:55 -0400
Message-ID: <6a6f37d16b55a3003af3f3dbb7778a367f68cd8d.camel@kernel.org>
References: <20230928110554.34758-1-jlayton@kernel.org>
         <20230928110554.34758-2-jlayton@kernel.org>
         <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
         <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
         <20230928171943.GK11439@frogsfrogsfrogs>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695922871;
        bh=q4Y+iRhQNw28trXDtNOjgA21Uv+IbPAACk59LAWJmZQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Pt2knsyPVF5IN2LrEHFDhKXAMR+bUOcTlyAAG093ma8ffe9kH/u7HXG2g+Td0GQbU
         dj6xCSvBaMeN3dkuuuxcxsY6aAAFekfxMF19xWrooSEMrmsfY/FrKOmIr30Ef9iwhy
         6QfDCUZqE6k5rEywc5Ze8K4/SAUL1W/1QDmSbwueKYxqX2aaIVxDcPqg/lhskw8rFh
         jOw/ARPQHq26NmwE3QZN+kwE0QI6+60XvzrrVfZo0ayZcNh/tBcZ410YuqL9+lmQQb
         qZZexkDUvIABncMcV2ChnF/ASLiH8NqVr7NTUG7D+At/G4u0PnSWIbaDK60vBHhtw8
         vViGtl0HWhtVQ==
In-Reply-To: <20230928171943.GK11439@frogsfrogsfrogs>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve

On Thu, 2023-09-28 at 10:19 -0700, Darrick J. Wong wrote:
> On Thu, Sep 28, 2023 at 01:06:03PM -0400, Jeff Layton wrote:
> > On Thu, 2023-09-28 at 11:48 -0400, Arnd Bergmann wrote:
> > > On Thu, Sep 28, 2023, at 07:05, Jeff Layton wrote:
> > > > This shaves 8 bytes off struct inode, according to pahole.
> > > >=20
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > >=20
> > > FWIW, this is similar to the approach that Deepa suggested
> > > back in 2016:
> > >=20
> > > https://lore.kernel.org/lkml/1452144972-15802-3-git-send-email-deepa.=
kernel@gmail.com/
> > >=20
> > > It was NaKed at the time because of the added complexity,
> > > though it would have been much easier to do it then,
> > > as we had to touch all the timespec references anyway.
> > >=20
> > > The approach still seems ok to me, but I'm not sure it's worth
> > > doing it now if we didn't do it then.
> > >=20
> >=20
> > I remember seeing those patches go by. I don't remember that change
> > being NaK'ed, but I wasn't paying close attention at the time=20
> >=20
> > Looking at it objectively now, I think it's worth it to recover 8 bytes
> > per inode and open a 4 byte hole that Amir can use to grow the
> > i_fsnotify_mask. We might even able to shave off another 12 bytes
> > eventually if we can move to a single 64-bit word per timestamp.=20
>=20
> I don't think you can, since btrfs timestamps utilize s64 seconds
> counting in both directions from the Unix epoch.  They also support ns
> resolution:
>=20
> 	struct btrfs_timespec {
> 		__le64 sec;
> 		__le32 nsec;
> 	} __attribute__ ((__packed__));
>=20

Correct. We'd lose some fidelity in currently stored timestamps, but as
Linus and Ted pointed out, anything below ~100ns granularity is
effectively just noise, as that's the floor overhead for calling into
the kernel. It's hard to argue that any application needs that sort of
timestamp resolution, at least with contemporary hardware.=20

Doing that would mean that tests that store specific values in the
atime/mtime and expect to be able to fetch exactly that value back would
break though, so we'd have to be OK with that if we want to try it. The
good news is that it's relatively easy to experiment with new ways to
store timestamps with these wrappers in place.

--=20
Jeff Layton <jlayton@kernel.org>
