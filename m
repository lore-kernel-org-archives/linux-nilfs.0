From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete
 integers
Date: Fri, 29 Sep 2023 06:16:57 -0400
Message-ID: <d52b4330cd26e8ef9b2999281b05e50bd7106b3a.camel@kernel.org>
References: <20230928110554.34758-1-jlayton@kernel.org>
         <20230928110554.34758-2-jlayton@kernel.org>
         <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
         <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
         <20230929-yuppie-unzweifelhaft-434bf13bc964@brauner>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695982632;
        bh=P0eff07RhtpS5UOcz3JkNsf+Ld6yeT/W26VJM0WDCPo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XzS9mEvGo34Ng6IbV0phy7oFkBghevr6TXQtKuvgCZiNk6sipSIK1ybdV8fiZNmJi
         ryG2oocKEqZZKJ0Qpanb9xZf3XPiR4Bq6wmT9EMmf0fleXLKV9fNEg9/bkdRQXUeb0
         6CCRA5VO7ZThmTCkkfWYanznw4Z3cZqE/s5mMA3tjLRXwYn9bn1bqt+qj2Mv3mg9Lj
         pTssK95Hwcb1T8QjlazVp2JhItPwZmMqN2Vq1pnJqTnlHDG5dK0bcBFAZ33vjsFaWl
         leIqxKSfZkutf2lGQF/4jFFb0IVmQg0er/lH6TmX4JwaSuIbh4XkLnYFCd3nLSRRA6
         40ODyX835zJVA==
In-Reply-To: <20230929-yuppie-unzweifelhaft-434bf13bc964@brauner>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>

On Fri, 2023-09-29 at 11:44 +0200, Christian Brauner wrote:
> > It is a lot of churn though.
>=20
> I think that i_{a,c,m}time shouldn't be accessed directly by
> filesystems same as no filesystem should really access i_{g,u}id which
> we also provide i_{g,u}id_{read,write}() accessors for. The mode is
> another example where really most often should use helpers because of all
> the set*id stripping that we need to do (and the bugs that we had
> because of this...).
>=20
> The interdependency between ctime and mtime is enough to hide this in
> accessors. The other big advantage is simply grepability. So really I
> would like to see this change even without the type switch.
>=20
> In other words, there's no need to lump the two changes together. Do the
> conversion part and we can argue about the switch to discrete integers
> separately.
>=20
> The other adavantage is that we have a cycle to see any possible
> regression from the conversion.
>=20
> Thoughts anyone?

That works for me, and sort of what I was planning anyway. I mostly just
did the change to timestamp storage to see what it would look like
afterward.

FWIW, I'm planning to do a v2 patchbomb early next week, with the
changes that Chuck suggested (specific helpers for fetching the _sec and
_nsec fields). For now, I'll drop the change from timespec64 to discrete
fields. We can do that in a separate follow-on set.
--=20
Jeff Layton <jlayton@kernel.org>
