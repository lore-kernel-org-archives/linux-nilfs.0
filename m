From: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: nilfs2-kmod6 version 1.1 was released: improve decrease of available
 disk space on aged file systems.
Date: Sun, 8 Nov 2015 06:46:40 -0800
Message-ID: <CAKFNMomdPCmhDyfwfDVo2n+1rLR45L7dpUMAcnaRKCMoEUxvTA@mail.gmail.com>
Reply-To: Linux NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:reply-to:date:message-id:subject:to:content-type;
        bh=Jifb3J43jRtt+UgYglFjaIrbTfxd+ps51ugpp4LC4+c=;
        b=qAmHrBawjT9/F7phTzRa1I1cX8kBCHuFUI5Qzc8nn0+DydhuMcIY2hxxG/PQah8b9y
         l2aAmgAEhwCCw3CwucSzZ4XZmXRnusDN1567ch4wl//vETdL9pbt37HyzHEa1fX2vhNk
         IGpgBHKmQdHmN05aNZiAhcMquok0vCvlRi1aPwyaoDT/zorlINVwrv9DYIvOW+R313vz
         YWRGWsyRClEat53V+y+SwulTv7fG54+6UAWZ9hV3CdgcWY4EWMbEnYDrYQENULfewsc5
         Dr3oHzy3LBd6CIMf/kd91leorwUA1dz3Kst02eCR1Y7Q7U5srujeWPha+CzsB32mUb7S
         V7oA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs2-kmod6 version 1.1 was released. Back-port fixes including ones
to improve decrease of available disk space related to aging of DAT
metadata file. For details, please see ChangeLog file or commit logs.

from http://nilfs.sourceforge.net/en/index.html#n122
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
