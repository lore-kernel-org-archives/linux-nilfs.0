From: "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete
 integers
Date: Thu, 28 Sep 2023 10:19:43 -0700
Message-ID: <20230928171943.GK11439@frogsfrogsfrogs>
References: <20230928110554.34758-1-jlayton@kernel.org>
 <20230928110554.34758-2-jlayton@kernel.org>
 <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
 <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695921584;
        bh=TBXriEELB328eOKqJ6NFSOrKvuSXYJvHz6sohZrQIx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ryWGGERqf3ypGjqQYm5gVKZvkucKGUk0K4h6YIIWQ/NpKuXJi36HQDWjgdgtJd7wu
         TP/RvT38TPj/OA2Jk4aeD0DGoa7LAN7jIOlBWE0I1eYn6imAEKifbbeaG59NKi/slD
         aEVjDaHe+6Tji3j/v0JkIDO2dR6Fo6pHy84G4o5KxjxBslGp0LwydCJH4NJcX4DsY2
         2+Ki57CRL6p89OjFpqSqXlcve39ZEqPDxD7QZyCHUVk8IqPpmvXHWivOQJXeNPWNjx
         piSViGDp1oRPgjAY21DvqURTHMn9e50dg1rgKW7SErtrbVvTXl75DArwoAJ6zoDjTa
         8X72loIt6il5Q==
Content-Disposition: inline
In-Reply-To: <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve

On Thu, Sep 28, 2023 at 01:06:03PM -0400, Jeff Layton wrote:
> On Thu, 2023-09-28 at 11:48 -0400, Arnd Bergmann wrote:
> > On Thu, Sep 28, 2023, at 07:05, Jeff Layton wrote:
> > > This shaves 8 bytes off struct inode, according to pahole.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > 
> > FWIW, this is similar to the approach that Deepa suggested
> > back in 2016:
> > 
> > https://lore.kernel.org/lkml/1452144972-15802-3-git-send-email-deepa.kernel@gmail.com/
> > 
> > It was NaKed at the time because of the added complexity,
> > though it would have been much easier to do it then,
> > as we had to touch all the timespec references anyway.
> > 
> > The approach still seems ok to me, but I'm not sure it's worth
> > doing it now if we didn't do it then.
> > 
> 
> I remember seeing those patches go by. I don't remember that change
> being NaK'ed, but I wasn't paying close attention at the time 
> 
> Looking at it objectively now, I think it's worth it to recover 8 bytes
> per inode and open a 4 byte hole that Amir can use to grow the
> i_fsnotify_mask. We might even able to shave off another 12 bytes
> eventually if we can move to a single 64-bit word per timestamp. 

I don't think you can, since btrfs timestamps utilize s64 seconds
counting in both directions from the Unix epoch.  They also support ns
resolution:

	struct btrfs_timespec {
		__le64 sec;
		__le32 nsec;
	} __attribute__ ((__packed__));

--D

> It is a lot of churn though.
> -- 
> Jeff Layton <jlayton@kernel.org>
