From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: time-shifting
Date: Mon, 08 Aug 2011 21:28:59 +0900 (JST)
Message-ID: <20110808.212859.255403671.ryusuke@osrg.net>
References: <4E3CEF72.1070303@evert.net>
	<20110807.231959.212685724.ryusuke@osrg.net>
	<4E3F0F16.7020200@evert.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E3F0F16.7020200-yfx6isLFVcpeoWH0uzbU5w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: post-yfx6isLFVcpeoWH0uzbU5w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 08 Aug 2011 00:17:58 +0200, Evert Mouw wrote:
> Hi,
> 
> Op 2011-08-07 16:19, Ryusuke Konishi schreef:
> > At present, nilfs does not have such per-file pointer to past
> > versions, so actually it's not optimal for file history lookups.
> >
> > We may be able to do indirectly by adding a new field to on-disk inode
> > to keep a checkpoint number in which the inode lastly changed.
> > However, the new field must be updated every time garbage collector
> > thins out the previous version, -- this may complicate things
> > unacceptably because the current nilfs is designed so that it never
> > overwrites in-use blocks except super blocks.
> Very interesting, thanks for your explanation. I agree that updating 
> such a field to a previous checkpoint should not be overwritten. A 
> solution would be to not update the field when the garbage collector 
> runs. The result is that a pointer to a previous checkpoint could point 
> to a non-existing checkpoint. That should not be a problem, because it 
> is known which checkpoints do exist, so a simple "if ( ( 
> previous-checkpoint == X ) and ( X not element of available checkpoints 
> ) ) then previous-checkpoint = NULL" would do. That would enable easier 
> checks for previous versions,

I agree with this let-it-be approach.

> although if there is some chechpoint series like "1 2 3 4" and some
> file exists in all four of those, and if you remove checkpoint 2,
> then this system will never find the oldest version in checkpoint
> 1. But such a scenario is unlikely because the garbage collector
> removes the oldest checkpoints first. Also, this solution doesn't
> need to be perfect to be better than nothing at all.
 
Okay, garbage collector may delete newer checkpoints first, and also
intermediate checkpoints can be deleted manually with rmcp command.
But, the let-it-be approach seems to go well in most cases.  If the
previous checkpoint number is lost, we only have to track back to the
last valid checkpoint younger than it and confirm that the inode
contained in the checkpoint is alive with the same generation number.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
