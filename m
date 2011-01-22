From: Wakko Warner <wakko-WZdgCHJQUilg9hUCZPvPmw@public.gmane.org>
Subject: Re: NILFS crash on 2.6.37
Date: Sat, 22 Jan 2011 11:09:38 -0500
Message-ID: <20110122160938.GA23181@animx.eu.org>
References: <20110121.163738.135792151.ryusuke@osrg.net> <20110121.181859.144825828.ryusuke@osrg.net> <20110122015748.GA3174@animx.eu.org> <20110122.230956.176521815.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110122.230956.176521815.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Ryusuke Konishi wrote:
> On Fri, 21 Jan 2011 20:57:48 -0500, Wakko Warner wrote:
> > That patch fix it.  Just a note, the 2.6.37 vanilla source was about 20
> > lines up from 704
> 
> Thanks for testing.  Will send upstream and to stable.

No problem.

> > > > > [ 1202.581501] NILFS warning: broken superblock. using spare superblock.
> > > > > [ 1202.582093] NILFS warning: broken superblock. using spare superblock.
> > 
> > Why does it say this 2 times?  Just curious.
> 
> Because each super block is read twice in different block sizes.
> 
> Well, indeed it looks confusing.  I'll try to do something.

Ah, I see.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
