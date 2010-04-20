From: "Yongkun Wang" <yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org>
Subject: Writes doubled by NILFS2
Date: Tue, 20 Apr 2010 17:39:13 +0900
Message-ID: <00c901cae064$f42b4bb0$dc81e310$@iis.u-tokyo.ac.jp>
References: <t2kf2d3ba1f1004131638nb61e68cek1ecb43a86c316d35@mail.gmail.com>	<20100415.015106.58888665.ryusuke@osrg.net>	<j2kf2d3ba1f1004141746n9f914465q3e24d48bec7f990e@mail.gmail.com> <20100416.213151.77349735.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100416.213151.77349735.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-us
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, guys,

We have a database system, the data is stored on the disk formatted with
NILFS2 (nilfs-2.0.15, kmod-nilfs-2.0.5-1.2.6.18_92.1.22.el5.x86_64).

I have run a trace at the system call level and the block IO level, that is,
tracing the requests before processed by NILFS2 and after processed by
NILFS2.

We use synchronous IO. So the amount of writes at the two trace points
should be equal. 
It is true when we use EXT2 file system.

However, for NILFS2, we found that the writes have been doubled, that is,
the amount of writes is doubled after processed by NILFS2. The amount of
writes at the system call level is equal between EXT2 and NILFS2. 

Since all the address are log-structured, it is hard to know what are the
additional writes.

Can you provide some hints on the additional writes? Is it caused by some
special functions such as snapshot?

Thank you very much.

Best Regards,
Yongkun

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
