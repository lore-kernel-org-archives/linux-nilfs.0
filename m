From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: read error on superblock
Date: Mon, 23 Jul 2012 18:39:07 +0900 (JST)
Message-ID: <20120723.183907.154986664.konishi.ryusuke@lab.ntt.co.jp>
References: <19753282.RhzHOQAfKG@coil>
	<1343035048.1974.6.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343035048.1974.6.camel@slavad-ubuntu-11>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 23 Jul 2012 13:17:28 +0400, Vyacheslav Dubeyko wrote:
> Hi,
> 
> On Mon, 2012-07-23 at 10:45 +0200, dexen deVries wrote:
> > Hi list,
> > 
> > 
> > a harddrive got some bad sectors and now one NILFS filesystem can't be mounted;
> > 
> > mount: /dev/sda3: can't read superblock
> > 
> > I can (try to) copy this filesystem to another drive; how do I proceed form 
> > that point? Does it make any sense to substitute another superblock for this 
> > one? (either to use a spare superblock, if such exists, or put a new 
> > superblock on the damaged sector(s)).

NILFS tries to use the second superblock automatically if the primary
super block was broken.  And, NILFS even tries to recover the primary
superblock by copying the secondary superblock.

> > mount: /dev/sda3: can't read superblock

Looks weird.  mount.nilfs2 doesn't output this error message.

Is mount.nilfs2 installed in /sbin directory?

Could you try mount.nilfs2 as follows instead of the mount program?

# mount.nilfs2 <device> <mount-point>

 or

# mount -t nilfs2 <device> <mount-point>


Regards,
Ryusuke Konishi

> > Regards,
> 
> It exits second superblock at the end of NILFS volume. But it can be not
> in fully synchronous state with primary ones (as I guess).
> Theoretically, it is possible to copy secondary superblock on the place
> of primary. But I am afraid that the NILFS volume can be in inconsistent
> state anyway.
> 
> Do you sure that this volume doesn't contain another damaged sectors?
> 
> With the best regards,
> Vyacheslav Dubeyko.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
