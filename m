From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount & fsck of nilfs partition fail.
Date: Tue, 14 Jun 2011 00:21:51 +0200
Message-ID: <201106140021.52229.dexen.devries@gmail.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E02D@COLOSSEXCH01.starsolutions.com> <20110613.213316.221578492.ryusuke@osrg.net> <053D39D3D76C474EB2D2A284AA6BA3181B05E4E167@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=J99DLe+eN17Nn/sO6dgrWhi6UEQJgzhFNmGe84xueSA=;
        b=giYB1z30VP9pjTee3U4dVDlfR4L1xxnUl4skkWSYgl37FhBlh8I8vs0+lw0W0Uef5f
         U6kiPtpn4kGOmitj713NuT8pOoDBEXjkUMfND600dqlhooY7C7zEmVIboroHQXLrfeut
         RJ1M+4Rr+3fNr7hRrNPBrSiIspovHcJ1rdhFY=
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E167-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
