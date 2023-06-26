From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 47/79] nilfs2: switch to new ctime accessors
Date: Tue, 27 Jun 2023 00:26:34 +0900
Message-ID: <CAKFNMomCU54JHKZxcUFLwci5ntzdD7gTv6JADhg--rLHXCcC+g@mail.gmail.com>
References: <20230621144507.55591-1-jlayton@kernel.org> <20230621144735.55953-1-jlayton@kernel.org>
 <20230621144735.55953-46-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687793211; x=1690385211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+89gfXmJ9PSf+Pt2D4c4GX0Uof4aHZCLD/OrH79jSsg=;
        b=AyjaD1eRoHDM50xgpG49ONEAd3ndFMRyHh0H5eO24TVgUJCPnnH4f6Awyv/KHFnBPJ
         thZLmikNpLEsYfzXkKEYVXFFqODOVhj7tOHNuQGoKmCUV5VHKortEVd1UA9lVRz4SVl7
         IZUQSyt3qgzmVnZPVC5S/fpIAABOxwJnEwn9FuURH2ratOjmKDIpYd7co/TPJlkFg+yy
         KoDcjOVoExNJWg5H9vP0ADy4ONVjdJ5q6gOSSu7o+0eKf4IC9lNVzJQ+d1a9TfT2LvpJ
         IGowrBkiM5MQKiFkQC8XTFacFVpF0luaGtl0ilvneRhDX/R7JP1msNJmZqx770MhW+Vx
         dG2Q==
In-Reply-To: <20230621144735.55953-46-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 21, 2023 at 11:48=E2=80=AFPM Jeff Layton wrote:
>
> In later patches, we're going to change how the ctime.tv_nsec field is
> utilized. Switch to using accessor functions instead of raw accesses of
> inode->i_ctime.
>
> Signed-off-by: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  fs/nilfs2/dir.c   |  6 +++---
>  fs/nilfs2/inode.c | 12 ++++++------
>  fs/nilfs2/ioctl.c |  2 +-
>  fs/nilfs2/namei.c |  8 ++++----
>  4 files changed, 14 insertions(+), 14 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

As already mentioned in the s390 patch comment, the implementation of
inode_ctime_set_current() needs to be rewritten to use
inode_ctime_set() instead of inode_set_ctime(), but I agree with this
conversion patch for nilfs2 itself.

Thank you for your efforts.

Ryusuke Konishi
