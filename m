From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 1/8] lscp: support opening mounted filesystem by directory pathname
Date: Fri, 4 Mar 2011 20:21:30 +0900
Message-ID: <AANLkTimo14Brge+eswBjTgWs3iGKXHRDgpTSGjivmBsz@mail.gmail.com>
References: <201103031723.22583.dexen.devries@gmail.com>
	<20110304.021603.234305303.ryusuke@osrg.net>
	<201103031931.32310.dexen.devries@gmail.com>
	<20110304.192609.247659638.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=mhWgYMjxRAjkNpkpfhTMK6QPzxmCfBJ26XPja4SQbwE=;
        b=S9bgwXrY6ydIrgfOes0KxYSgjBQPpgoqoteYf+SteIvu4nSAK/Rl1DXrHjtR/WNpk3
         OJuIhv22EJMBTvwuIX/O5LkNwHIm3+gh4ZG5mehJfidT0TxtEbwIktLMsDpGNDavgx5j
         qGlkU3ar8cq3mhKg/Vh6dLFiFnVrbu5x2br/A=
In-Reply-To: <20110304.192609.247659638.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2011/3/4 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> In the new directory semantics, we needs to decide if a given
> directory argument belongs to a mount point in the mtab entries.
>
> This matching check needs to know whether the given directory crosses
> over a filesystem boundary starting from each mount point. =A0And, th=
is
> needs testing if each intermediate directory is a mount point or not.
>
> "mountpoint" command judges this by comparing device ids and inode
> numbers for each directory with its parent.

BTW, we can test if a given nilfs2 directory is a mount point or not
with its inode number.  The nilfs2 mount point always has
inode number 2 (=3DNILFS_ROOT_INO) and no other directories
have this inode number.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
