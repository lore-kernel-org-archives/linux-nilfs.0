From: Alexander Bezrukov <nilfs-issues-tvrqcU/I3+LBxmVkcvZ8vQ@public.gmane.org>
Subject: Re: Corrupted nilfs2 volume
Date: Tue, 19 Mar 2013 21:35:44 +0400
Message-ID: <20130319173544.GB32146@black>
References: <20130315024019.7DC1BD00@mail.dragonworks.ru>
 <1363328491.2078.21.camel@slavad-ubuntu>
 <20130315232157.GC1542@black>
 <70219EF1-8083-4DD5-BA18-84CD1914DC3E@dubeyko.com>
 <20130318142352.GA4148@black>
 <4E5BDA60-7615-4F82-AC0F-4459DD9EF544@dubeyko.com>
 <20130318223145.GA17965@black>
 <1363680412.2229.14.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1363680412.2229.14.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

sorry about my slow turnaround.

> Ok. I see. But I really need to have for analysis as minimum last
> segment's raw content #23445 (ss_seq = 305303, first block #48015360).
> Because I need to conclude what the reason of failure with checkpoint
> attach. I can see from code analysis that only raw dump can give to me
> more hints than additional debug output.

I have prepared and sent you privately the data.

> > Is there any chance to register a different fs aside with
> > "official" nilfs2? Would such a simple change be sufficient?
> > 
> > diff -ur org/super.c new/super.c
> > --- org/super.c	2013-03-19 02:17:23.922469000 +0400
> > +++ new/super.c	2013-03-19 02:16:20.440634698 +0400
> > @@ -1356,7 +1356,7 @@
> >  
> >  struct file_system_type nilfs_fs_type = {
> >  	.owner    = THIS_MODULE,
> > -	.name     = "nilfs2",
> > +	.name     = "nilfs2-dbg",
> >  	.mount    = nilfs_mount,
> >  	.kill_sb  = kill_block_super,
> >  	.fs_flags = FS_REQUIRES_DEV,
> > 
> > What I want is to whenever possible avoid rebooting a machine
> > I am using for experimentation. It has /home on a nilfs2
> > partition and there're usually open user files on it.
> > 
> 
> I think that you can have more simple solution. I suggest to have
> special experimental build of the kernel that you can choose in the grub
> menu. Moreover, debug output will be completely disabled by means of
> #undef macro. Anyway, I need to analyze raw dump before offering to you
> a patch with additional debug output.

I surely can do this but my goal was to avoid rebooting whenever
possible. That's why I asked to register the fs with a different name.
If this is non-trivial I will boot into a new kernel, no problem.

Thanks for all your support.

Regards.
Alexander Bezrukov.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
