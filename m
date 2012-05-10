From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Small device
Date: Fri, 11 May 2012 00:42:22 +0900 (JST)
Message-ID: <20120511.004222.123644820.konishi.ryusuke@lab.ntt.co.jp>
References: <1336606410.14957.140661073496877.75A2D273@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336606410.14957.140661073496877.75A2D273-2RFepEojUI2N1INw9kWLP6GC3tUn3ZHUQQ4Iyu8u01E@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zeke-iuD2ETIrjQqsTnJN9+BGXg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 10 May 2012 00:33:30 +0100, Zeke Rondel wrote:
> Hi,
> 
> I've a small memory card (SD) of 64MB used for keys related to crypto.
> stuff so I need a log filesystem that avoids the data can be re-written
> or modified. Is NILFS suitable in case of little devices? If so, which
> size of blocks per segment would be suitable for it? Thanks in advance!

Basically NILFS is not designed for small devices.  Its most on-disk
data items have 64-bit width.  In addition, it's more likely to suffer
from disk full on such devices due to the copy-on-write nature.

However, I guess you can use NILFS on 64MB SD card by formatting the
device with a smaller block size and a smaller number of blocks per
segment.

My mkfs format parameter for a 64MB sized device is as follows:

$ mkfs -t nilfs2 -b 1024 -B 512 <device>


We may get more disk space overhead for much smaller "blocks per
segment" because every segment of NILFS needs at least one header
block.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
