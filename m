From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Ability to discard all changes after a point in time?
Date: Fri, 27 May 2011 16:34:34 +0900 (JST)
Message-ID: <20110527.163434.163671247.ryusuke@osrg.net>
References: <201105270828.32843.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201105270828.32843.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Fri, 27 May 2011 08:28:28 +0200, dexen deVries wrote:
> Hi,
> 
> 
> recently I was searching for a way to discard all changes after a certain 
> point in time -- that is, to rollback filesystem state to a particular 
> checkpoint. I couldn't find a way, is there any?
> 
> If not, I'd like to request such functionality. Preferrably selectable at 
> mount time, via an argument to mount (or the `rootflags' kernel parameter).
> 
> Something along the lines `rollbackto=<checkpoint-number>'. 
> 
> The desired effect is to set the indicated checkpoint as the latest one, so all 
> subsequent changes to filesystem are discarded.
> 
> 
> What are your thoughts on that?

The feature is indeed one of todo items, and I just have been
considering the topic for upcoming LinuxCon Japan.

At present, I made a patchset which can revert only one fully deleted
regular file without duplicating data blocks. (This work derives your
post titled "It is not possible to restore file from a mounted
snapshot using a hardlink" and the successive reflink topic.)


The challenge in the rollback (or revert) feature is to handle
lifetime of each disk block, which is maintained for garbage
collection.  (a disk address table, which we call DAT file, preserves
this metadata).

The mount-time whole checkpoint reversion, that is to say rollback,
seems rather difficult than this.  In my estimation, it would take too
long time to rewrite whole DAT file.

But, yes, I think this feature is one of priorities, and have plan to
take time for it.

Thanks,
Ryusuke Konishi


> Regards,
> -- 
> dexen deVries
> 
> ``One can't proceed from the informal to the formal by formal means.''
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
