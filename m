From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/1] fs/nilfs2: Fix potential underflow in call to crc32_le
Date: Fri, 24 Jun 2016 23:29:46 +0900
Message-ID: <1466778587-5184-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=w+TgCMIWGbypK1yIrpGuXfT/iYxZIF4Nsv0IL2/BRpc=;
        b=FVTHYZMeSgrRGyuTGMXOjbUJJbXuLjTpSNzgj0XBzFpsILgZ+LDacq77lMPcleeslB
         lUGgVuaHSaq6nWsiezuNeBZI0aIvIw8mkm5ewRnL70Lm//MkCRxzHDCWG1pWhcW4R5g1
         uSMrdb1rnG08RPEd/T+LbXsPcxJrRXzayayHM21cReeKQqoitefLHqk9KobG845GHpLD
         KOCT0OJnH/Az1MOgTRs1kT2B641kilbLS6o5MZFhO1rSWe3Yxb5SX/SXA7uD39H5/8di
         5UvzyQulc3TzT3i5izMTKIhvsn/GU/gRn8K9BV6Cgp4fc5fQ9/vP6Zc08dIdkp+xLU/0
         HqFQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>

Hi Andrew,

Please send the following patch to upstream (hopefully in this cycle).
It fixes a memory overrun issue due to incomplete sanity check of
on-disk super block size information, which can result in a kernel
panic, for instance, in the case where a non-nilfs volume is
accidentally mounted through nilfs2.

The patch is applicable to the mainline as well as -mm tree.

Thanks,
Ryusuke Konishi
--
Torsten Hilbrich (1):
      fs/nilfs2: Fix potential underflow in call to crc32_le

 fs/nilfs2/the_nilfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
