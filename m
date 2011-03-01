From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: record used amount of each checkpoint in checkpoint list
Date: Tue, 1 Mar 2011 13:05:42 +0100
Message-ID: <201103011305.43120.dexen.devries@gmail.com>
References: <1298740431-13749-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        bh=bqQu9ywYVTovLjSUSLqrpy6dm8KwlUoQWslCm9eijS4=;
        b=x+N7wRjxby756Eb1xW77+NEEefIuOkPGZZXtyO+5X9t303u3M2jRWqAS0z3bkfyiDx
         uKADzchh0OjJ2V//R4dO6B1xAdzLakoh9rvNYCBrWXYfgfEnJvUesKQLy9dqWs5hBrxH
         ShNKsLY/JxYC80NwTV4KibLxnWZqA+GJVgvY0=
In-Reply-To: <1298740431-13749-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,


On Saturday 26 of February 2011 18:13:51 you wrote:
> This records the number of used blocks per checkpoint in each
> checkpoint entry of cpfile.  Even though userland tools can get the
> block count via nilfs_get_cpinfo ioctl, it was not updated by the
> nilfs2 kernel code.  This fixes the issue and makes it available for
> userland tools to calculate used amount per checkpoint.
>=20
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> ---
>  (...snip...)


I've applied this this patch and the two recent userpace patches and it=
 works=20
alright, with one surprise -- two suspiciously large BLKCNT:

$ lscp -b
(...snip...)
              270584  2011-03-01 12:52:57   cp    -           33     24=
8244
              270585  2011-03-01 12:53:01   cp    -           34     24=
8245
              270586  2011-03-01 12:53:06   cp    - 1844674407370955052=
3    =20
248245
              270587  2011-03-01 12:53:11   cp    - 1844674407370955055=
0    =20
248257
              270588  2011-03-01 12:53:15   cp    -         1268     24=
8247
              270589  2011-03-01 12:53:16   cp    -         1803     24=
8246
              270590  2011-03-01 12:53:21   cp    -         4952     24=
8256
(...snip...)


It is possible the two strange checkpoints (270586 & 7) were created wi=
th new=20
userland and old kernel, before reboot.

Do you want me to provide any extra info on it or just let it slip?

--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

> how does a C compiler get to be that big? what is all that code doing=
?

iterators, string objects, and a full set of C macros that ensure
boundary conditions and improve interfaces.

ron minnich, in response to Charles Forsyth

http://9fans.net/archive/2011/02/90
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
