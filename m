From: Christian Smith <csmith-r5H9PUQoNxUga4AWyxku7ULnMzgEhdHr@public.gmane.org>
Subject: Re: NILFS2 under stress
Date: Sat, 16 Jun 2012 20:09:06 +0100
Message-ID: <20120616190906.GJ16953@csmith-bm.vm.bytemark.co.uk>
References: <20120615165024.GI16953@csmith-bm.vm.bytemark.co.uk> <985C1135657081458B80476678A9AF7F3ADDAC29@MBXP05.ds.man.ac.uk>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <985C1135657081458B80476678A9AF7F3ADDAC29-AwGyfWOFj6xM8+wRG0yK8vXRex20P6io@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Bannister <Tim.Bannister-m7QheJJv02N4oUbgFh0ZNQ@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, Jun 16, 2012 at 11:49:55AM +0000, Tim Bannister wrote:
> > In summary, I think NILFS is fantastic in short bursts of heavy pressure
> > so long as space isn't exhausted.
> 
> OK, but if exhausting the space leads to unrecoverable / difficult-to-fix data loss then it's a poor choice of filesystem for uses where a full filesystem is unlikely but remains a possibility (eg a mail spool). If /var/tmp shouldn't be on NILFS then probably /var shouldn't be on NILFS either.


Which is a shame, because short synchronous file writes are an ideal use for NILFS. Perhaps one area where NILFS could be improved is in handling of disk full errors, for example, not allowing complete exhaustion of space unless a cleaner is running.

It doesn't help that I run my NILFS systems on small media, such as my Acer Aspire One netbook with crappy 8GB SSD, because it's the only filesystem that makes such disks usable performance wise. The biggest media I use NILFS with is a 40GB tablet the kids use for playing with, and I haven't come close to filling or killing that.


> 
> I recognise that NILFS2 is not yet described as ready for production use.
> 

Exactly. I don't store on it anything I can't easily reproduce. That said, I've never had a filesystem I couldn't recover data from, so recovery has been easy so far.

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
