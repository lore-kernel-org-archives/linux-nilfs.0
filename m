From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 2/3] nilfs2: nilfs_segctor_destroy() should do a full
 job
Date: Sun, 11 Apr 2010 17:15:51 +0900 (JST)
Message-ID: <20100411.171551.04175650.ryusuke@osrg.net>
References: <20100410161700.GB9213@xhl>
	<20100411.031005.204131803.ryusuke@osrg.net>
	<20100411042749.GB10086@xhl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100411042749.GB10086@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 11 Apr 2010 12:27:49 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Apr 11, 2010 at 03:10:05AM +0900, Ryusuke Konishi wrote:
> > On Sun, 11 Apr 2010 00:17:00 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > From 466fbbc10dabc8a14e292ee19636fc534036a8b7 Mon Sep 17 00:00:00 2001
> > > From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > Date: Sat, 10 Apr 2010 22:26:04 +0800
> > > Subject: [PATCH 2/3] nilfs2: nilfs_segctor_destroy() should do a full job
> > > 
> > > To set "sbi->s_sc_info = NULL;" is also a part of nilfs_segctor_destroy()'s job.
> > > Move it into the destroy procedure.
> > > 
> > > Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > No, don't do this.  sbi->s_sc_info is the holder of the segment
> > constructor object and is not a part of the object though
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> No, my meaning is that: to set "sbi->s_sc_info = NULL;" is also a _part_ of 
> nilfs_segctor_destroy()'s _job_. 

It's your opinion, and my opinion is different.  I'd prefer to
intentionally keep the clearance in
nilfs_detach_segment_constructor().  It's not a matter of your
changelog description.

Thanks,
Ryusuke Konishi

> I should make the explanation clearer. IMO, I just think 'kfree
> something' and 'set the obj to NULL' can't be seperated by a
> procedure.

> Thanks,
> Li Hong
> 
> > nilfs_segctor_destroy needs some cleanup.
> > 
> > Ryusuke Konishi
> > 
> > > ---
> > >  fs/nilfs2/segment.c |    5 ++---
> > >  1 files changed, 2 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> > > index 514620d..dd3c4d5 100644
> > > --- a/fs/nilfs2/segment.c
> > > +++ b/fs/nilfs2/segment.c
> > > @@ -2774,6 +2774,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
> > >  	down_write(&sbi->s_nilfs->ns_segctor_sem);
> > >  
> > >  	kfree(sci);
> > > +	sbi->s_sc_info = NULL;
> > >  }
> > >  
> > >  /**
> > > @@ -2829,10 +2830,8 @@ void nilfs_detach_segment_constructor(struct nilfs_sb_info *sbi)
> > >  	LIST_HEAD(garbage_list);
> > >  
> > >  	down_write(&nilfs->ns_segctor_sem);
> > > -	if (NILFS_SC(sbi)) {
> > > +	if (NILFS_SC(sbi))
> > >  		nilfs_segctor_destroy(NILFS_SC(sbi));
> > > -		sbi->s_sc_info = NULL;
> > > -	}
> > >  
> > >  	/* Force to free the list of dirty files */
> > >  	spin_lock(&sbi->s_inode_lock);
> > > -- 
> > > 1.6.3.3
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
