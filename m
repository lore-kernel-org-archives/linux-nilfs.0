From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 86/87] fs: switch timespec64 fields in inode to discrete
 integers
Date: Thu, 28 Sep 2023 17:26:56 -0400
Message-ID: <20230928212656.GC189345@mit.edu>
References: <20230928110554.34758-1-jlayton@kernel.org>
 <20230928110554.34758-2-jlayton@kernel.org>
 <6020d6e7-b187-4abb-bf38-dc09d8bd0f6d@app.fastmail.com>
 <af047e4a1c6947c59d4a13d4ae221c784a5386b4.camel@kernel.org>
 <20230928171943.GK11439@frogsfrogsfrogs>
 <6a6f37d16b55a3003af3f3dbb7778a367f68cd8d.camel@kernel.org>
Mime-Version: 1.0
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1695936425; bh=w4hql40FuyyfsTNK9D530X9ExV2y5b7TU7/1a0HHsnU=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=NGPOVv6aP7Wgx4/k9ruqGjDYWmjUQVAfEL5fppG6yE2RNxUM6uiyoWrXBZfGmZyL2
         gb1zEZjWcSSCFd+NWg1/BYhZ5jeEptXNin1ZAM6seg38Angccj8YOPtyzxOx/hDFrb
         Q+ePr/t98/fHq2BcSzJCThnFTNb50fVmlIrGfb3oMvB11ToZpH+p8R2mhaDk4/44dl
         uEHGVh6Q6Ih5iyFuN8+PasXijpXT1PXJm+5Rkla8PX5Glna1OAsFe3wre6CQl62oa4
         RAr1Z2b44rKF067M11yaRPI56z2wMDur4vLyEnjrhgmaYzW5D9XQ8I+PJlbP887wDq
         NXSNNWLPWiTbQ==
Content-Disposition: inline
In-Reply-To: <6a6f37d16b55a3003af3f3dbb7778a367f68cd8d.camel@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Amir Goldstein <amir73il@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Thu, Sep 28, 2023 at 01:40:55PM -0400, Jeff Layton wrote:
> 
> Correct. We'd lose some fidelity in currently stored timestamps, but as
> Linus and Ted pointed out, anything below ~100ns granularity is
> effectively just noise, as that's the floor overhead for calling into
> the kernel. It's hard to argue that any application needs that sort of
> timestamp resolution, at least with contemporary hardware. 
> 
> Doing that would mean that tests that store specific values in the
> atime/mtime and expect to be able to fetch exactly that value back would
> break though, so we'd have to be OK with that if we want to try it. The
> good news is that it's relatively easy to experiment with new ways to
> store timestamps with these wrappers in place.

The reason why we store 1ns granularity in ext4's on-disk format (and
accept that we only support times only a couple of centuries into the
future, as opposed shooting for an on-disk format good for several
millennia :-), was in case there was userspace that might try to store
a very fine-grained timestamp and want to be able to get it back
bit-for-bit identical.

For example, what if someone was trying to implement some kind of
steganographic scheme where they going store a secret message (or more
likely, a 256-bit AES key) in the nanosecond fields of the file's
{c,m,a,cr}time timestamps, "hiding in plain sight".  Not that I think
that we have to support something like that, since the field is for
*timestamps* not cryptographic bits, so if we break someone who is
doing that, do we care?

I don't think anyone will complain about breaking the userspace API
--- especially since if, say, the CIA was using this for their spies'
drop boxes, they probably wouldn't want to admit it.  :-)

       	    	     	      	      	    - Ted
