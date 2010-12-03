From: Kurt Van Dijck <kurt.van.dijck-/BeEPy95v10@public.gmane.org>
Subject: nilfs on bare NAND flash
Date: Fri, 3 Dec 2010 13:41:51 +0100
Message-ID: <20101203124151.GC662@e-circ.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I may not be the first to ask this type of question, but I was unable
to find the answer yet.

I'm looking for a solution to provide a filesystem
in bare NAND flash (no compact flash or SSD).
Is NILFS2 capable of running in bare NAND flash?
I see these 2 issues:
1) how are bad blocks handled
2) Do I need the caching block device, or the char device?

Thanks in advance,
Kurt Van Dijck
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
