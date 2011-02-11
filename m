From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs_cleanerd for the root filesystem
Date: Fri, 11 Feb 2011 14:29:41 +0100
Message-ID: <201102111429.41478.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:mime-version
         :content-type:content-transfer-encoding:message-id;
        bh=PXAqsIPBjTZg8HiAZRIfBlCtnIgi7VzjcFJO45sztU8=;
        b=sHzLwXC44LLuJF47Adrix5q3QGmFjciZp7TpGCchr2mArMGgrcCAd2T7qQMQq5pNrk
         At2eHqm0LMbkgBzbS0D81UCu4KjE0aeX4VsaChq0TqIyIzalf1VgFIkKoPadHMa+2nkP
         0FeGqJ4VHoPe3EFVdH2YfnYoOQWAZYz5+xviM=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

It seems mounting NILFS as root filesystem does not cause nilfs_cleaner=
d to be=20
started. I'm not using initrd; just indicated the root partition in ker=
nel's=20
command line, so it gets mounted directly.

Is there a way to fix that?
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
