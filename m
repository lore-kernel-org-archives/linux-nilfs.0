From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Mon, 21 Mar 2011 13:05:48 +0100
Message-ID: <201103211305.48353.dexen.devries@gmail.com>
References: <20110319220157.GA681@heethoofdje.13thmonkey.org> <20110320125040.GA735@heethoofdje.13thmonkey.org> <20110321.200706.260176646.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=oq02qxWyjxpgxA4Zd3HdhWusSTqcZcJHzJlmCoCPrqM=;
        b=MvvQAklSp8IXWHOV5ckGEmXh8NzTXCRXCj13DS0lQQEa4h7LUPfyX0jTu4nkc88Zil
         RZu3b23ZLsZo9FDqjYbiYahRvbNCdQFF6WDCKV42Cy7juf1Bm6vHCG1vhXVSgbFd2wDq
         ILC9zULIVYjt+w4odAXBiJRv0t97tBVzEc38k=
In-Reply-To: <20110321.200706.260176646.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi again,


On Monday 21 of March 2011 12:07:06 you wrote:
> The ".nilfs" file is used for two purposes:
>=20
>  1) As the file on which the nilfs library issues ioctls.
>=20
>  2) For advisory locks (i.e. fcntl(F_GETLK/F_SETLK/FSETLKW)).  This
>     works as a mutex between the cleaner and other nilfs-tools.


Regarding 2), it seems multiple instances of nilfs_cleanerd can be star=
ted for=20
one filesystem (which leads to metadata corruption, as per my earlier=20
``Regarding problem with nilfs_cleanerd - part 2 and Nilfs_cleanerd err=
=3D-17''=20
mail).

Is that intentional? Should we guard on nilfs_cleanerd level, or on ker=
nel=20
level?


Regards,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

``In other news, STFU and hack.''
mahmud, in response to Erann Gat's ``How I lost my faith in Lisp''
http://news.ycombinator.com/item?id=3D2308816
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
