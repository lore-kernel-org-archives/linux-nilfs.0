From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 1/8] lscp: support opening mounted filesystem by
 directory pathname
Date: Fri, 04 Mar 2011 02:16:03 +0900 (JST)
Message-ID: <20110304.021603.234305303.ryusuke@osrg.net>
References: <1299156472-4707-1-git-send-email-dexen.devries@gmail.com>
	<20110304.011511.83301246.ryusuke@osrg.net>
	<201103031723.22583.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103031723.22583.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 3 Mar 2011 17:23:22 +0100, dexen deVries wrote:
> Hi,
> 
> 
> On Thursday 03 of March 2011 17:15:11 you wrote:
> > Thank you for posting this series.  I'll queue it up in
> > nilfs-utils-devel tree.
> > 
> > By the way, may I add your "Signed-off-by:" line to these patches?
> 
> Sure.
> 
> 
> I'll fix that in my clone and push out to Github. Will it be enough if I sent a 
> Pull Request from Github to the list rather than submit individual patches as 
> mails?

Usually we post every patch to the list every time we modified the
series for convenience of reference and review.  But, I think a pull
request is enough if just adding a sob line.

By the way, can you enhance the series so that the directory argument
works for any directories in the filesystem rather than just a mount
point?

We know the directory argument of "df" command works like that.

  $ cd; df .
  Filesystem           1K-blocks      Used Available Use% Mounted on
  /dev/sda1            ....            ...        ..  ... /

This semantics seems more convenient especially for snapshot tools.

Any idea?

> It's the first time I'm trying to contribute to opensource; thanks for being 
> patient :-)

It's my pleasure.  Keep it coming :)

Thanks,
Ryusuke Konishi

> Regards,
> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> 47. As Will Rogers would have said, "There is no such thing as a free 
> variable."
> 
> (Alan Perlis, `Epigrams on Programming')
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
