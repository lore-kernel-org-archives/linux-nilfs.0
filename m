From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS utils 2.0.18 released
Date: Sat, 10 Apr 2010 22:58:34 +0900 (JST)
Message-ID: <20100410.225834.255401080.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi folks,

A new util release became available at

 http://www.nilfs.org/en/download.html

This release introduced the GC policy implemented by David Arendt
(thanks!).  The new cleanerd can suspend GC depending on the amount of
free segments on the device.  This would be of help to use nilfs on
flash devices.

Other changes include "-o nogc" mount option and so forth.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
