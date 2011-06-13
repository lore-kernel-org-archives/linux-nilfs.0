From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: mount & fsck of nilfs partition fail.
Date: Tue, 14 Jun 2011 08:51:57 +0900 (JST)
Message-ID: <20110614.085157.212693296.ryusuke@osrg.net>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E167@COLOSSEXCH01.starsolutions.com>
	<201106140021.52229.dexen.devries@gmail.com>
	<053D39D3D76C474EB2D2A284AA6BA3181B05E4E1CE@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E1CE-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org
Cc: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 13 Jun 2011 16:28:19 -0700, Zahid Chowdhury wrote:
> Hello Dexen/Ryusuke,
>   Thanks both for your help. I tried this:
>    [quadcore:~/nilfs/nilfs-utils.git/nilfs2-utils] git fetch
>            http://git.nilfs.org/nilfs2-utils-devel.git fsck0:fsck0
>    fatal: Refusing to fetch into current branch
>    [quadcore:~/nilfs/nilfs-utils.git/nilfs2-utils] git checkout fsck0
>    Already on "fsck0"
> I also tried from scratch with your commands below (not co, but checkout) -
> there were no changes to the file with diff:
>   nilfs2-utils-devel/sbin/fsck/fsck0.nilfs2.c

Sorry, the fsck0 branch was not propery updated.
I just fixed the problem in the git repo.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
