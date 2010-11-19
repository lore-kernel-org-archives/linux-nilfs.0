From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/2] nilfs-utils: re-license nilfs library
Date: Fri, 19 Nov 2010 19:23:00 +0900
Message-ID: <1290162182-31605-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1290155467-5475-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290155467-5475-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

These two patches re-license libraries and their header files included
in nilfs-utils to LGPL.

I will queue them for the next util release along with sekiba-san's CRC
patch unless there are objections.

Thanks,
Ryusuke Konishi

--
 COPYING         |  517 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/nilfs.h |   18 +-
 lib/cno.c       |   10 +-
 lib/nilfs.c     |   18 +-
 lib/sb.c        |   10 +-
 5 files changed, 543 insertions(+), 30 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
