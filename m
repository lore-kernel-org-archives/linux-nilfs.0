From: karunakar merugu <karuna.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: fsck.nilfs2: not found
Date: Wed, 9 May 2012 14:46:00 +0530
Message-ID: <CABECqUHJFN-6K1eP29BL39G=EgSTf2usRHLAWsNY98zzMTLT7w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=0tPAb+DwCcPY4NQWGNcw9Pdb3tdBM+Bw5bVWPFqiuZ8=;
        b=ptHdyNGf9SxLubW7GV0gTAieQikie8pKiqOB78uBw6gEPfQ7To9HNt9JPVsYOe2etU
         mu1Tnxoxw5OEdATzUa0RO6jVIeVwgq7NkQG/CYg26ZxJxjYePY8iNhZmYU1qcnbP05Wf
         I0k4fzxWPtdXRfiIxgNKmE04lTMQY+a3GD87L1XXiS0NfcSzHSGQZOre598+xFeQhhDy
         PY3MyaJaIkXG7rhoP/A/hz8k6vtevOzPQTD/g/R7TAFS0u61pX7MxsJIbqdV1iEofS7S
         mt6S62tDPBs7H8hqKQGZMlEipmtcWr1/cXGhwRPqgnLOpHfU/GNzYXlNbif1GX5YbvFD
         fPfQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi
I am using Linux karunakar-VirtualBox 3.0.0-12-generic #20-Ubuntu SMP.
I installed nilfs utilities  by
sudo apt-get update
sudo apt-get install nilfs2-tools

Even after this I am getting error like:
fsck from util-linux 2.19.1
fsck: fsck.nilfs2: not found
fsck: Error 2 while executing fsck.nilfs2 for /dev/sdb

can anyone help me in finding the correct package for fsck.nilfs2
utility please.
thanks,
Karunakar.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
