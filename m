From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Corrupted nilfs2 volume
Date: Thu, 21 Mar 2013 10:31:30 +0400
Message-ID: <1363847490.2593.19.camel@slavad-ubuntu>
References: <20130315024019.7DC1BD00@mail.dragonworks.ru>
	 <1363328491.2078.21.camel@slavad-ubuntu> <20130315232157.GC1542@black>
	 <70219EF1-8083-4DD5-BA18-84CD1914DC3E@dubeyko.com>
	 <20130318142352.GA4148@black>
	 <4E5BDA60-7615-4F82-AC0F-4459DD9EF544@dubeyko.com>
	 <20130318223145.GA17965@black> <1363680412.2229.14.camel@slavad-ubuntu>
	 <20130319173544.GB32146@black>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=3nRqFHe/WtfNGay3Ad0+kDUTVVvoR//tRpi2fnqbHOE=;
	b=TPej+ltDAptoGafDIro1DzLSLn5YffdqzATvwKl41RZ/ytN8KOMCFcy4NC/Xywp18T9mlvk+EW8xiltE+d+63cp28/t7aZ1DWrSJCGbjGbCT4B/wXoDB5Og4WGh35nRZ;
In-Reply-To: <20130319173544.GB32146@black>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Bezrukov <nilfs-issues-tvrqcU/I3+LBxmVkcvZ8vQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Alexander,

On Tue, 2013-03-19 at 21:35 +0400, Alexander Bezrukov wrote:
> Hi Vyacheslav,
> 
> sorry about my slow turnaround.
> 
> > Ok. I see. But I really need to have for analysis as minimum last
> > segment's raw content #23445 (ss_seq = 305303, first block #48015360).
> > Because I need to conclude what the reason of failure with checkpoint
> > attach. I can see from code analysis that only raw dump can give to me
> > more hints than additional debug output.
> 
> I have prepared and sent you privately the data.
> 

Thank you for additional details.

The reason of reported symptoms (NILFS: Invalid checkpoint (checkpoint
number=5439464)) is clear. The actual superblock points out on last
checkpoint with number s_last_cno = 5439464. But actual state of cpfile
in last partial segment doesn't contain valid record for #5439464. The
last valid record in cpfile is record for #5439463 checkpoint. Moreover,
it is possible to see from dumpseg output that in last partial segment
files live in #5439463 checkpoint. So, it is strange. I think that it
was some failure during NILFS2 driver operations with this volume.
Maybe, system log on this volume contains some details about errors that
were a reason of such corruption.

Currently, I think that it is recoverable corruption. But for some
reason the recovery doesn't take place during mount. I am preparing
patchset with debug output for more detailed investigating the issue
with mount on your side and checking my presuppositions about possible
way to fix the issue. So, I'll send you this patchset soon.

> > > Is there any chance to register a different fs aside with
> > > "official" nilfs2? Would such a simple change be sufficient?
> > > 
> > > diff -ur org/super.c new/super.c
> > > --- org/super.c	2013-03-19 02:17:23.922469000 +0400
> > > +++ new/super.c	2013-03-19 02:16:20.440634698 +0400
> > > @@ -1356,7 +1356,7 @@
> > >  
> > >  struct file_system_type nilfs_fs_type = {
> > >  	.owner    = THIS_MODULE,
> > > -	.name     = "nilfs2",
> > > +	.name     = "nilfs2-dbg",
> > >  	.mount    = nilfs_mount,
> > >  	.kill_sb  = kill_block_super,
> > >  	.fs_flags = FS_REQUIRES_DEV,
> > > 
> > > What I want is to whenever possible avoid rebooting a machine
> > > I am using for experimentation. It has /home on a nilfs2
> > > partition and there're usually open user files on it.
> > > 
> > 
> > I think that you can have more simple solution. I suggest to have
> > special experimental build of the kernel that you can choose in the grub
> > menu. Moreover, debug output will be completely disabled by means of
> > #undef macro. Anyway, I need to analyze raw dump before offering to you
> > a patch with additional debug output.
> 
> I surely can do this but my goal was to avoid rebooting whenever
> possible. That's why I asked to register the fs with a different name.
> If this is non-trivial I will boot into a new kernel, no problem.
> 

I think that maybe loadable kernel module of NILFS2 driver can be a
solution for you.

With the best regards,
Vyacheslav Dubeyko.

> Thanks for all your support.
> 
> Regards.
> Alexander Bezrukov.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
