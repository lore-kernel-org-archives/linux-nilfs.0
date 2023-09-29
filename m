From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete
 integers
Date: Fri, 29 Sep 2023 11:44:15 +0200
Message-ID: <20230929-yuppie-unzweifelhaft-434bf13bc964@brauner>
References: <20230928110554.34758-1-jlayton@kernel.org>
 <20230928110554.34758-2-jlayton@kernel.org>
 <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
 <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695980717;
        bh=oQTvAmCkCsoaLNjfsaMUmlY4D/qoWr90XSuheIQAYtc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WlV6Iok6t6x6wqtPDr2u2AsUWg4hMLM7cqaWPUDEeTpPDmS0JTVgMZlUl0HPmoBuT
         /MtXZyL5oovwNZMVTtYCnXU5O+6UqBVLwaqKXfjDA7Gi3QJjfoFg0kuMJ76nbuwBFl
         FM+QH0bvVjfmuBVMp9s5CgN9psq1cDgIpp1TcndUbm+j24otqfdnexR7nd6Jf+tuT9
         QFRyk1BHauhj4nL9X9E976w/vvMYaEWzc8Ucm1v15cgYx/ItXrPfVSX9rwflr20Upl
         1p24LfpWvr++mxmy87xjKVxbcTxjBWdURGxp63tvXsg372LYC0Zasv3SIGFC2AHpa8
         8VA1Ctle4jMgQ==
Content-Disposition: inline
In-Reply-To: <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>

> It is a lot of churn though.

I think that i_{a,c,m}time shouldn't be accessed directly by
filesystems same as no filesystem should really access i_{g,u}id which
we also provide i_{g,u}id_{read,write}() accessors for. The mode is
another example where really most often should use helpers because of all
the set*id stripping that we need to do (and the bugs that we had
because of this...).

The interdependency between ctime and mtime is enough to hide this in
accessors. The other big advantage is simply grepability. So really I
would like to see this change even without the type switch.

In other words, there's no need to lump the two changes together. Do the
conversion part and we can argue about the switch to discrete integers
separately.

The other adavantage is that we have a cycle to see any possible
regression from the conversion.

Thoughts anyone?
