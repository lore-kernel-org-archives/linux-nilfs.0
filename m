From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 2/2] nilfs2: add a print message after loading nilfs2
Date: Thu, 08 Apr 2010 11:34:05 +0900 (JST)
Message-ID: <20100408.113405.221629738.ryusuke@osrg.net>
References: <20100405173402.GA22644@xhl>
	<20100405173534.GB22644@xhl>
	<20100407142058.GA27224@xhl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100407142058.GA27224@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 7 Apr 2010 22:20:58 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi KONISHI Ryusuke,
> 
> Any feedbacks on these patches?
> 
> Thanks,
> Li Hong

Well, adding a load message is ok, but it should be more moderate like
"nilfs2 file system loaded\n".

I think this sort of change should be discussed in the sub topic
mailing list (i.e. linux-nilfs).  You don't have to cc every patch to
linux-kernel.

And, please include some explanation in the change log to clarify the
aim or motivation.

Thanks,
Ryusuke Konishi

> On Tue, Apr 06, 2010 at 01:35:34AM +0800, Li Hong wrote:
> > From b4e426f77cd05bd6046c1fa67c51ee06368ea23e Mon Sep 17 00:00:00 2001
> > From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Date: Tue, 6 Apr 2010 01:23:04 +0800
> > Subject: [PATCH] nilfs2: add a print message after loading nilfs2
> > 
> > 
> > Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >  fs/nilfs2/super.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index 2e767bc..9f91765 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -1186,7 +1186,12 @@ static int __init init_nilfs_fs(void)
> >  		return err;
> >  
> >  	err = register_filesystem(&nilfs_fs_type);
> > -	return err;
> > +	if (err)
> > +		return err;
> > +
> > +	printk(KERN_INFO "nilfs2 file system loaded!\n");

	printk(KERN_INFO "nilfs2 file system loaded!\n");

> > +	return 0;
> > +
> >  }
> >  
> >  static void __exit exit_nilfs_fs(void)
> > -- 
> > 1.6.3.3
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
