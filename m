From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: One checkpoint just won't get GC'd
Date: Fri, 18 Feb 2011 11:22:46 +0900 (JST)
Message-ID: <20110218.112246.163318864.ryusuke@osrg.net>
References: <201102171529.43904.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201102171529.43904.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 17 Feb 2011 15:29:43 +0100, dexen deVries wrote:
> Hello,
> 
> I have a few snapshots and between two of them (few days old) there is a lone 
> checkpoint (68) that just won't get GC'd:
> CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
> 67  2011-02-11 10:58:34   ss    -      10214     183442
> 68  2011-02-11 11:00:07   cp    -         12     183442
> 11205  2011-02-11 13:13:44   ss    -       2229     245061
> 40205  2011-02-16 18:16:04   ss    -         59     260421
> 
> Lots and lots of subsequent checkpoints has been GC'd sine then; current is 
> 79450.
> 
> How do I pinpoint the reason the checkpoint is not getting GC'd?

Yeah, this is known (and minor) issue of the currrent GC algorithm.

I guess you did "mkcp -s" on the checkpoint 67 (cp-67), and then the
checkpoint 68 (cp-68) was created to record the change on metadata of
checkpoints which we call "cpfile".

So, cp-68 does not have any new data blocks as compared with cp-67
except for the "cpfile" update.

All data blocks in cp-68 are protected from GC because they are shared
with the snapshot cp-67.  In such case, the current GC cannot know
whether the checkpoint is invalidated or not, and it doesn't drop the
checkpoint automatically.

You can delete cp-68 by rmcp command without incident since the
filesystem itself is sanity.

In addition, cp-68 will be removed by GC if you will release the
snapshot cp-67.


Thanks,
Ryusuke Konishi

 
> Running Linux 2.6.38-rc4 with nilfs-utils-2.0.21 right now, but the checkpoint 
> and the snapshots around it were created with 2.6.37 and nilfs-utils-2.0.20, 
> IIRC.
> 
> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> > how does a C compiler get to be that big? what is all that code doing?
> 
> iterators, string objects, and a full set of C macros that ensure
> boundary conditions and improve interfaces.
> 
> ron minnich, in response to Charles Forsyth
> 
> http://9fans.net/archive/2011/02/90
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
