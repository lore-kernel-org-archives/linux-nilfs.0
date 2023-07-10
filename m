From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v2 00/89] fs: new accessors for inode->i_ctime
Date: Mon, 10 Jul 2023 14:35:28 +0200
Message-ID: <20230710-zudem-entkam-bb508cbd8c78@brauner>
References: <20230705185812.579118-1-jlayton@kernel.org>
 <5e40891f6423feb5b68f025e31f26e9a50ae9390.camel@kernel.org>
Mime-Version: 1.0
Return-path: <ecryptfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688992570;
        bh=H2xgbjqXpjCIL1YrRX5e2Lm0dCE6nhNpxkhLzNT5ua0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GYBFwi445q0lt0ZphYZpLmOt5wR+meJbqPSRhxet7P0iiPRYgnHSi9LobGg38wRHk
         YRw3H+QXcyvvByqsJ+4wCmkCN6cf2UfzMYa1sqxLulNzp2UeGTyc0ij28Jne5oQ1T1
         3RwWXPXG0ww5I/wkFqIbXj1fKOk/tlA6pnousvcLf4fNGPnso9ohJABAD43u0T4XNZ
         4qx5bhLf1Dg7cYvF3ikt77ixrICUwaQpwn/PA/WiTF+kWZvjsjd1ey6AFXxc5U5x4u
         9w1gOuNArxobHqFss0Ukd6pKRPqY5GTMTdaOCIUwXl2G+JmZTqpL3AJhz3XT+Fb/gm
         tN6yuNjSBVu7g==
Content-Disposition: inline
In-Reply-To: <5e40891f6423feb5b68f025e31f26e9a50ae9390.camel@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>
Cc: jk@ozlabs.org, arnd@arndb.de, mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com, maco@android.com, joel@joelfernandes.org, cmllamas@google.com, surenb@google.com, dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, leon@kernel.org, bwarrum@linux.ibm.com, rituagar@linux.ibm.com, ericvh@kernel.org, lucho@ionkov.net, asmadeus@codewreck.org, linux_oss@crudebyte.com, dsterba@suse.com, dhowells@redhat.com, marc.dionne@auristor.com, viro@zeniv.linux.org.uk, raven@themaw.net, luisbg@kernel.org, salah.triki@gmail.com, aivazian.tigran@gmail.com, ebiederm@xmission.com, keescook@chromium.org, clm@fb.co

On Fri, Jul 07, 2023 at 08:42:31AM -0400, Jeff Layton wrote:
> On Wed, 2023-07-05 at 14:58 -0400, Jeff Layton wrote:
> > v2:
> > - prepend patches to add missing ctime updates
> > - add simple_rename_timestamp helper function
> > - rename ctime accessor functions as inode_get_ctime/inode_set_ctime_*
> > - drop individual inode_ctime_set_{sec,nsec} helpers
> > 
> 
> After review by Jan and others, and Jan's ext4 rework, the diff on top
> of the series I posted a couple of days ago is below. I don't really
> want to spam everyone with another ~100 patch v3 series, but I can if
> you think that's best.
> 
> Christian, what would you like me to do here?

I picked up the series from the list and folded the fixups you posted
here into the respective fs conversion patches. I hope that helps you
avoid a resend. You should have received a separate "thank you" mail for
all of this.

To each patch that I folded one of the fixlets from below into I added a
git note that records a link to your mail here and the respective patch
hunk from this mail that I folded into the patch. git.kernel.org will
show notes by default. For example,
https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=vfs.ctime&id=8b0e3c2e99004609a16ba145bcbdfdddb78e220e
should show you the note I added. You can also fetch them via
git fetch $remote refs/notes/*:refs/notes/*
(You probably know that ofc but jic.) if you're interested.

Based on v6.5-rc1 as of today.

Btw, both b4 and patchwork somehow treat the series in weird was.
IOW, based on the message id of the cover letter I was able to pull most
messages except for:

[07/92] fs: add ctime accessors infrastructure
[08/92] fs: new helper: simple_rename_timestamp
[92/92] fs: rename i_ctime field to __i_ctime

which I pulled in separately. Not sure what the cause of this is.
