From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [ANNOUNCE] NILFS utils 2.0.19 released
Date: Mon, 09 Aug 2010 15:26:38 +0900 (JST)
Message-ID: <20100809.152638.37589806.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi folks,

nilfs-utils-2.0.19 became available at

 http://www.nilfs.org/en/download.html

This version adds uhelper support to mount.nilfs2 so that
udisks/palimpsests can control nilfs2 partitions, and adds enlarged
label in which maximum size of the volume name was enlarged to 80
bytes keeping compatibility.

Man pages and header files are also updated to follow recent changes
at kernel (upto 2.6.35).

See the changelog ( http://www.nilfs.org/download/ChangeLog-utils-v2 )
for more details.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
