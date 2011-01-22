From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: NILFS crash on 2.6.37
Date: Sat, 22 Jan 2011 23:09:56 +0900 (JST)
Message-ID: <20110122.230956.176521815.ryusuke@osrg.net>
References: <20110121.163738.135792151.ryusuke@osrg.net>
	<20110121.181859.144825828.ryusuke@osrg.net>
	<20110122015748.GA3174@animx.eu.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110122015748.GA3174-WZdgCHJQUilg9hUCZPvPmw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: wakko-WZdgCHJQUilg9hUCZPvPmw@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 21 Jan 2011 20:57:48 -0500, Wakko Warner wrote:
> Ryusuke Konishi wrote:
> > On Fri, 21 Jan 2011 16:37:38 +0900 (JST), Ryusuke Konishi wrote:
> > > (Cc'ed to linux-nilfs)
> > Does the following patch fix your problem?
> 
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index 0994f6a7..58fd707 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -704,7 +704,8 @@ skip_mount_setup:
> >  	sbp[0]->s_state =
> >  		cpu_to_le16(le16_to_cpu(sbp[0]->s_state) & ~NILFS_VALID_FS);
> >  	/* synchronize sbp[1] with sbp[0] */
> > -	memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
> > +	if (sbp[1])
> > +		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
> >  	return nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
> >  }
> 
> That patch fix it.  Just a note, the 2.6.37 vanilla source was about 20
> lines up from 704

Thanks for testing.  Will send upstream and to stable.


> > > > [ 1202.581501] NILFS warning: broken superblock. using spare superblock.
> > > > [ 1202.582093] NILFS warning: broken superblock. using spare superblock.
> 
> Why does it say this 2 times?  Just curious.

Because each super block is read twice in different block sizes.

Well, indeed it looks confusing.  I'll try to do something.


Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
