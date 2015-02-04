From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/1] fix deadlock of segment constructor over I_SYNC flag
Date: Wed,  4 Feb 2015 22:26:22 +0900
Message-ID: <1423056383-24247-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=i7gZJlbvY4ONUPFVJvj+8cqm/YufqCeodLnpfOI3b3k=;
        b=zXERPK6BBoFEDRdGtF9jhpn0Uy8MulNWUS0mcTIsVnRbDBHaO2/GAhK7OoE4uu161O
         mKtIL+1HTFKSUjgkckH4REW/7F5SVBB+me/JAfRjrWbqNV7iPgaiE/EQFFhEPy35VUtG
         e4XD7DEUkq/1KEXI8N5ovExwSRgHa6qJfGekafvSvrbpV9ZJTXnBj2AQSTj5dkM0/omb
         2LJh3IpW5btvL8I09bbn3111chmL0NXOR2VxujffXpkF5a83IC78XS+gQ23i+mjxVPKB
         C1tB9EMIZXhERNCB3dDI6Z3wisoK+sQGJTxY4cjcgsRsWosgXCWemsu0jaBOK8/gny9O
         r+eg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please queue the following patch for the next merge window.  It fixes
a deadlock issue found in nilfs2.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (1):
      nilfs2: fix deadlock of segment constructor over I_SYNC flag

 fs/nilfs2/nilfs.h   |  2 --
 fs/nilfs2/segment.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 fs/nilfs2/segment.h |  5 +++++
 3 files changed, 44 insertions(+), 7 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
