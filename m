From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Checking actually used space on NILFS
Date: Thu, 10 Feb 2011 01:34:10 +0900 (JST)
Message-ID: <20110210.013410.133414746.ryusuke@osrg.net>
References: <201102091333.39072.dexen.devries@gmail.com>
	<20110210.001303.24922676.ryusuke@osrg.net>
	<201102091625.55553.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201102091625.55553.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 9 Feb 2011 16:25:55 +0100, dexen deVries wrote:
> On Wednesday, February 09, 2011 04:13:03 pm you wrote:
> > > is there a reasonably easy way to check the size of the current (most
> > > recent) content of the NILFS filesystem?
> > 
> > The current nilfs doesn't have an effiecient way to do that.
> > So, the easy way is using 'du -s':
> > 
> >  # du -s /nilfs-mount-point
> 
> that's true, but it relies on
> 1) user being able to see all the allocated files (and even root won't see some 
> allocated files, for example if they have been unlinked but are still held open 
> by a process), and
> 2) disk having low seek times

Right.

> > We need adding API (ioctl) to get extended space information and may
> > need minor disk format change for that.
> 
> 
> The `lscp' lists, under NBLKINC, the incremental count of blocks added by this 
> particular checkpoint. As far as I understand, if one summed up all NBLKINCs 
> of all checkpoints, the actual number of allocated blocks would result. 
> However, that seems to work only when no checkpoints have been ever removed...
> 
> Would it be possible to change the semantics of NBLKINC (and possibly the on-
> disk structure) to report increment from the last existing checkpoint rather 
> than just any (existing or not) previous checkpoint? I assume that'd make the 
> NBLKINC summing up a viable way of counting used space (at least with good 
> approximation).

It seems possible, but cleaner routine have to track back the most
recent live checkpoint when deleting each checkpoint.

Fortunately, I just remembered that each checkpoint metadata has an
reserved block_count field and the current checkpoint API can get it
through ioctl though lscp command doesn't display this field.

So, we can use the block_count field to store space information that
you wanted initially.  Bad news is that enabling this field will break
forward compatibility since the current nilfs doesn't update this
field. (sigh).

Anyway, I will consider implementing the block_count field and
updating lscp so that it can display "the block count at that moment"
instead of NBLKINC.


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
