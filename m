From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/1] nilfs2: fix deadlock of segment constructor during recovery
Date: Tue,  3 Mar 2015 20:59:42 +0900
Message-ID: <1425383983-29404-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=Gg0AT9ls2YK7vlo+Cvp1nhrfW4q3wQ3rgAK14l5f6Vo=;
        b=dwraRIDr7dy4ddn8iPWBJR+YrGIZm3nnaEejMmThk31nsIyTKSsH4j1TaCmQi+HgJf
         Zl27ge2uiRZFIzk44qlVEr3eG4Uwln8Atl3/rBDKIZ59Bft78wuHjcJnqXqQ8F1hEzj2
         Sa1dZZMlSSiaekiY71H3rxSna2IhW5aWgSvUpeFe9QvBVmigV8ryQifG08skJJB3m/i/
         TNp0G/NAJifmgK6K8pZ5k6RzaSeyWeUhsmexaH2k2y8wOQLuWVuzd1NTmOPamjS2rA4N
         fVl0TGfIsbH0pCrWINQCRCmWzhyvtqRIK9ddgjawJPnS7pzgtDicwiNbpO54nod6JUd8
         N1eg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please send the following bug fix to upstream.  It fixes another
deadlock issue of nilfs2 segment constructor, which was recently
reported.

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (1):
      nilfs2: fix deadlock of segment constructor during recovery

 fs/nilfs2/segment.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
