From: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: NILFS utils 2.2.5 was released
Date: Sun, 4 Sep 2016 04:10:14 +0200
Message-ID: <CAKFNMonokQqe409vNdXoGr9WsGSgAMA9uSdU8Zmi4QDPZS1x3A@mail.gmail.com>
Reply-To: Linux NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:reply-to:date:message-id:subject:to;
        bh=yd6eYBUmpxlLzmBFCh2/sPlkee2/5ZFWEdERMjCz0y8=;
        b=U8RKPIaAEe6IUuVKM79ByMqhnrbbo11BRGIAvAYWeoukFifDDlXw9LvMW2bD4de4WP
         nkMeFK1l9+UiGhP7dijK1YjwMuaHRgAtvG6RUEINhHBAzdEwVADYOsN+paRgPHq2EdMj
         /nOarfnXCJ9YUwF0qyqaoGtZ3s/pXN5i5voIKsFeLfCztJ96uFyVij6oh0bDHbH561Kp
         CC76bDs3DOdtegW5RDE9yFJLfMxg1y1SmhkOnSuzQAnM7GprHXmv/cOF8u3/TCgYwSxU
         LGYZKQMpOvRbWG5GtLI1P6WC55EaI82UpBGM2qeI6XmKT0kpwhtCDL5qurM8lrC3gGlA
         BLLQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Fix various issues that happen when the system time is changed to
earlier time or future.

from http://nilfs.sourceforge.net/en/download.html#2.2.5-u
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
