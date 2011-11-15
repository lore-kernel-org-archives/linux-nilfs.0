From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: One checkpoint doesn't get GC'd
Date: Wed, 16 Nov 2011 01:11:02 +0900 (JST)
Message-ID: <20111116.011102.126207784.ryusuke@osrg.net>
References: <201111141351.50798.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201111141351.50798.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi dexen,
On Mon, 14 Nov 2011 13:51:50 +0100, dexen deVries wrote:
> Hi,
> 
> 
> I have strange problem: one checkpoint doesn't get garbage-collected, in spite 
> of subsequent checkpoints getting GC'd just alright.
> 
> for example:
> 1170140  2011-10-14 09:34:17   cp    -           50     379222
> 1171655  2011-10-14 14:43:14   cp    -         1345     379479
> 1171663  2011-10-14 14:45:06   cp    -           54     379480
> 1171664  2011-10-14 14:45:17   cp    -           51     379479
> (...)
> 
> A few hours ago there were much more checkpoints between 1170140 and 1171655 
> and they all got GC'd as expected -- but not the 1170140 itself.

This may happen since garbage collection of nilfs is done for each
disk segment instead of checkpoint.

If GC did not reclaim any blocks for a checkpoint, the checkpoint will
survive transiently.

Try nilfs-clean command to check if the checkpoint is actually orphan
or not.  The command triggers one pass GC, and this would actually
sweep unused checkpoints.  When using this command, you may give the
following protection period option to shorten it:

  $ sudo nilfs-clean -p 60


Thanks,
Ryusuke Konishi


> For reference,
> kernel: 3.1.0 (stock)
> nilfs-utils: 2.1.0-rc1
>
> Cheers,
> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> ``As my friend Jacob Gabrielson once put it, advocating Object-Oriented 
> Programming is like advocating Pants-Oriented Clothing.''
>  -- Steve Yegge, in http://steve-yegge.blogspot.com/2006/03/execution-in-
> kingdom-of-nouns.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
