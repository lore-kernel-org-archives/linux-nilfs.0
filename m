From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix warning in nilfs_writepage()
Date: Thu, 25 Apr 2013 23:55:58 +0300
Message-ID: <20130425205558.GF5123@mwanda>
References: <20130425074947.GB11880@elgon.mountain>
 <1366882715.3181.11.camel@slavad-ubuntu>
 <20130425134610.d26f087c0db29d0703736db3@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130425134610.d26f087c0db29d0703736db3-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kbuild-JC7UmRfGjtg@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On Thu, Apr 25, 2013 at 01:46:10PM -0700, Andrew Morton wrote:
> On Thu, 25 Apr 2013 13:38:35 +0400 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> > On Thu, 2013-04-25 at 10:49 +0300, Dan Carpenter wrote:
> > > [ It's weird that kbuild didn't catch this ].
> > > 
> > > Hello Vyacheslav Dubeyko,
> > > 
> > > The patch bb594c4767b0: "nilfs2: fix issue with flush kernel thread
> > > after remount in RO mode because of driver's internal error or
> > > metadata corruption" from Apr 18, 2013, leads to the following 
> > > warning:
> > > "fs/nilfs2/inode.c:211 nilfs_writepage()
> > > 	 error: we previously assumed 'inode' could be null (see line 195)"
> > > 
> > 
> > Please, find below the patch with fix.
> > 
> > Thanks,
> > Vyacheslav Dubeyko.
> > --
> > From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> > Subject: [PATCH] nilfs2: fix warning in nilfs_writepage()
> > 
> > The patch fixes warning: "fs/nilfs2/inode.c:211 nilfs_writepage() error: we previously assumed 'inode' could be null (see line 195)".
> 
> The changelog doesn't tell us what tool emitted the warning.  Was it sparse?
> 

That's my fault.  It's a Smatch warning.

regards,
dan carpenter


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
