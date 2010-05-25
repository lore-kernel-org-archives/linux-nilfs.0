From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: TRIM Support?
Date: Tue, 25 May 2010 19:16:50 +0100
Message-ID: <4BFC1412.6000908@bobich.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I notice that the pitch for NILFS is that it is particularly suitable 
for flash based media. Does it have any sort of support for TRIM 
command? If not, is there at least an equivalent of dumpfs that could be 
used to get the list of free blocks that could be passed to hdparm to 
issue TRIM commands to the SSD?

TIA.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
