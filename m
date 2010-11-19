From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 0/1] replace crc32.c
Date: Fri, 19 Nov 2010 17:31:06 +0900
Message-ID: <1290155467-5475-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ryusuke-sG5X7nlA6pw@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Hi,

I think we've had consensus that libnilfs2 should be LGPLed. 
The problems are included GPLed kernel header(nilfs2_fs.h) and
crc32.c derived from GPL2 base code.
 http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg00489.html

The kernel header is properly re-licensed as LGPL2.1 in 2.6.37 merge window.
Thus the only problem is crc32.c now.

The following patch addresses the remaining problem.
The patch replaces crc32.c implementation.
The implementation is based on the jamlib(*1) and is LGPL2.1.
*1) http://sourceforge.net/projects/jamlib/

I've checked the compatibility on x86, ppc32 and mixed environments.
Everything was OK.

thanks, regards
-- 
Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
