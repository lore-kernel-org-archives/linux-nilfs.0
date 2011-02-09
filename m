From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Checking actually used space on NILFS
Date: Wed, 9 Feb 2011 13:33:38 +0100
Message-ID: <201102091333.39072.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:mime-version
         :content-type:content-transfer-encoding:message-id;
        bh=kvZNfXItA9RvZ7T8qaQ3Njc/GvJB2jcFC/PJJJWv2UE=;
        b=RKQ7x/FGNvHXuY9Wai+hWRtzOhghYQJLTKqv/7NmRydfTas+eCAwlnliIuThH0w496
         MhPSPQ1oRFlk53rE7tXm1nnvRCl2Sm+f8KZUkAwkcRrFFYMLblBfuoodBv+ygGUq6btZ
         AE03enJgXDuBR4EmSVQp5IpvIqDtMVwNQgmRM=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello list,


it's my first day with NILFS, and one issue bothers me:

is there a reasonably easy way to check the size of the current (most r=
ecent)=20
content of the NILFS filesystem?

As in, how much space would remain used if I decided to purge all old=20
checkpoints and only keep the current one.


Regards,
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
