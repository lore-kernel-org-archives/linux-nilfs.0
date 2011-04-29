From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] nilfs_cleanerd: make gc safe for duplicate invocation
Date: Fri, 29 Apr 2011 10:23:18 +0200
Message-ID: <201104291023.19215.dexen.devries@gmail.com>
References: <1304065125-9532-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=jKPGfOa+d5dGUfdkEC3SMkulxqpPHiBXCKxlVpuJxzw=;
        b=tPwWUdqNXZQ4rjk059lriolnEnx6PL3ajdlHl7P37oi3FD1Z/Ype07JZSbtsLjpNj0
         evFLXFdD3ivrjV+Fo2HsaTsDqN3KYu4Ki9gdJ84jv6fVkgMr7w8PxRIdcOAlVAEF6jjn
         2/TVDuAxicIsBQStIE00v7BlOE5LPYxPb7uBk=
In-Reply-To: <1304065125-9532-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Friday 29 of April 2011 10:18:45 you wrote:
> This enlarges the region that a garbage collection lock protects so
> that indivisible steps of garbage collection do not interleave.
> (...)

thanks Ryusuke, it's an important improvement :)

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
