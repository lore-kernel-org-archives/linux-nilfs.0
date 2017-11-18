From: linuxnilfs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: nilfs2-kmod6 version 1.1.2 was released: fix a race bug that causes
 file system corruption.
Date: Sat, 18 Nov 2017 08:02:31 -0500
Message-ID: <CAE7Udf9GpFiu-Ad3M5wSBSVeHHCJkKvE0gPNUbUOVhF_t1Td2Q@mail.gmail.com>
Reply-To: Linux NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:reply-to:date:message-id:subject:to;
        bh=3tAdsVnzfqthPPaKq3qa3YjRtlI0OVCdXxnzyzAgfKA=;
        b=ZahkI/wjjCmWk+Q42kQSLNEuCrTa03/68LybP1y0uPYmETSW1ngXIt1j+WL34b1SpZ
         IwMg7gcM+unD5zfFmsyuq9T9gevc+g86moYP+jMsEsZQotU4t5g4XIFVN8nHQ8oQj8b1
         l2kxea5x+E2+ySvi8Mc2DsWIiBa0n1pS/QtyG4Vb2ZXJjiLm2DKQddq571kE4ApjO5L6
         sXdR50+l2rTV9OFYaNTBHbqzP63J8VWJH4ZTg42t3PyNf/Horr7Q3K3/s6ETMofl9+/G
         nZqSVQbxJu4bmDNH/Acr2FMxJB3KC1D/sF8by1ndvi8Ly8HP46M01evVDYgsN7hbvWjG
         2zgw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs2-kmod6 version 1.1.2 was released. Fix a race condition bug that
causes file system corruption. For details, please see ChangeLog file
or commit logs.

from https://nilfs.sourceforge.io/en/index.html#n130
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
