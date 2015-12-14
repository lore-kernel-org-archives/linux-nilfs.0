From: Brian Cottingham <spiffytech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Cleaner crashes, can't read source blocks, error=-5
Date: Mon, 14 Dec 2015 10:11:10 -0500
Message-ID: <CAJEMKXOZuojpXq7T4iAN5101AADe1XbbrCUt1L66PM5w6POg6w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=Ofd176AuePm7EoOQvXm+7aNaz06o/an58x80rFhhE6c=;
        b=UyiJdd8BDwxWWdfZ2UCuqdbMpsm6oMw6okguCJYlIEQPFQrcm5g2Zqi20pBAwd6Z9/
         gxFgYlpc53VlAgnk/zcj8uHYjUmBuNiMftEvLPQkIKkf0QiHDN+Ay5av974cum7o3fIm
         9unv6p4rKkn7t1nXt7bS6sRUr1InSatwcI88BLXcChNk8I/aUcs6GxyH/C8EpDje9UNu
         TZ3htTATp1rFr5lTimciIuXCGom5fUBfbj5px5DVx/VjcP5G5rkAMPoXR9HVOw8d92Hm
         LfVRWJtpCU79IaMQQ8GCyKuxfM+diQQbXNESJYYXPeIO1J+GtW0ZTCe49Lbu97mm0oxr
         TNzg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

My nilfs2 partition has filled up, and I can't free up space because
nilfs_cleanerd crashes. This is what I get in syslog:

----
Dec 14 09:49:38 spiffyhome nilfs_cleanerd[1580]: start
Dec 14 09:49:38 spiffyhome nilfs_cleanerd[1580]: pause (clean check)
Dec 14 09:49:38 spiffyhome nilfs_cleanerd[1580]: resume (clean check)
Dec 14 09:50:45 spiffyhome kernel: [  149.008559] NILFS: GC failed
during preparation: cannot read source blocks: err=-5
Dec 14 09:50:45 spiffyhome nilfs_cleanerd[1580]: cannot clean
segments: Input/output error
Dec 14 09:50:45 spiffyhome nilfs_cleanerd[1580]: shutdown
----
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
