From: <cchou-Q5dYYSiXXjw@public.gmane.org>
Subject: Checkpoint rollback
Date: Mon, 23 Oct 2017 11:20:06 -0700
Message-ID: <20171023112006.7db454e36a4909f8b019c674b239f499.b5a9df3a04.wbe@email04.godaddy.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
    In this thread dated 2013-10-15:

https://marc.info/?l=linux-nilfs&m=138184919111358&w=2


    It briefly mentioned NILFS's ability to rollback into previous file
system states:


"Of course, NILFS2 has such very powerful concept as checkpoint/snapshot
is based on
Copy-On-Write (COW) policy. Potentially it gives opportunity to rollback
into \previous file system states"

    Can someone show me how this is done? Thanks!


Charles Chou

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
