From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: mount & fsck of nilfs partition fail.
Date: Mon, 13 Jun 2011 16:28:19 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E1CE@COLOSSEXCH01.starsolutions.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E02D@COLOSSEXCH01.starsolutions.com>
 <20110613.213316.221578492.ryusuke@osrg.net>
 <053D39D3D76C474EB2D2A284AA6BA3181B05E4E167@COLOSSEXCH01.starsolutions.com>
 <201106140021.52229.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106140021.52229.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Dexen/Ryusuke,
  Thanks both for your help. I tried this:
   [quadcore:~/nilfs/nilfs-utils.git/nilfs2-utils] git fetch
           http://git.nilfs.org/nilfs2-utils-devel.git fsck0:fsck0
   fatal: Refusing to fetch into current branch
   [quadcore:~/nilfs/nilfs-utils.git/nilfs2-utils] git checkout fsck0
   Already on "fsck0"
I also tried from scratch with your commands below (not co, but checkout) -
there were no changes to the file with diff:
  nilfs2-utils-devel/sbin/fsck/fsck0.nilfs2.c
Regards.

Zahid

-----Original Message-----
From: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of dexen deVries
Sent: Monday, June 13, 2011 3:22 PM
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: mount & fsck of nilfs partition fail.

Hi Zahid,


On Monday 13 June 2011 23:12:00 you wrote:
>   I am no git expert, just looked at the cheatsheet, but I was unable to
> find your commit which add's a reason to the message below. I tried: git
> pull http://git.nilfs.org/nilfs2-utils-devel.git fsck0:fsck0
> 	Already up-to-date.
> I also tried a re-fetch from scratch. All with no changes showing up in
> fsck0.nilfs2.c. If anybody else knows a way for me to pickup Ryusuke's
> commit, please let me know. Thanks.
> 


you need two operations, actually, go get what you want:

1) `git fetch ...' -- to download the changes from server to the auxilliary 
`.git' directory; you did that already
2) `git checkout ...' -- to check out the actual files.


you did the `git fetch ...' part already, but for now the changes are still 
held only in the auxilliary `.git' directory. To get the actual files visible 
in the repository, do:
$ git checkout fsck0

and that should be it.


In case something goes awry (say, you have a modified file or something), it'll 
be easiest to just create a new repository clone from scratch, like:

$ cd ../SOME_OTHER_DIRECTORY/
$ git clone http://git.nilfs.org/nilfs2-utils-devel.git
$ cd nilfs2-utils-devel
$ git co -b fsck0 remotes/origin/fsck0

The last line creates an `fsck0' branch in your repository clone and makes it 
follow/track the `fsck0' branch from the `origin' server -- the server you 
cloned the repo from. Here, the official NILFS2 server :-)

Regards,
-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
