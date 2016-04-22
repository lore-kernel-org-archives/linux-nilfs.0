From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/1] nilfs2: constify nilfs_sc_operations structures
Date: Fri, 22 Apr 2016 23:08:26 +0900
Message-ID: <1461334107-4694-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=5xzf+Iq2lHk0H0w/ezbKlTzZn8vZ1Lde+plHJB3tOhY=;
        b=HA0yJQQtQWEyCOVu29d6vKsrI23ne0mg7Iw/ZCAGN0zD7uEl8yRl6dOGtQdmonV0ZC
         6uUrOA86WP7HrlQIAza5nrnv+j3kc0YihZIgGqzaZB7CnfQsD37Or3/5G9uuiYBrusm8
         3Gx3HuGc/OsMyL4ZZLrZbdaKR9n7C542vaeVzOY9EKSGIJly17dmI3qM+UHAHxxLNcnQ
         nbO2YROUnrg281ZgXprO+VjQQnFaWNTOs976/45L3F/mV1yeDvA7vPbMZpNdeclFVn9M
         5Oy0Avf7dAe5CdOq9tQccS1XT2+F0I2yafHQdJwpdFXxU5otp8HhX8kE3LM2v6HgpdLn
         2Tog==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andrew,

please queue the following change for the next merge window.

Thanks,
Ryusuke Konishi
--
Julia Lawall (1):
      nilfs2: constify nilfs_sc_operations structures

 fs/nilfs2/segment.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
