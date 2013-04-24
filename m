From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Very low write-performance and troubles with RPM
Date: Wed, 24 Apr 2013 15:53:24 +0200
Message-ID: <CAFvQSYS5E7wFLyc___yvSBDaDsPyjEJ19XUs2M3UEN1nXJcumg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:date:message-id:subject:from:to
         :content-type;
        bh=F5rhme996w/ogzp5TdQKIMxUzDipBvLWTFnkH+/nv/U=;
        b=hLY+TFDqLtkh788jTTS1J9Is+fxxfWg9yWHcVfA6othqGRqgoL8mf0y6CKEIUEwFIC
         wrRT5j3WVmmOa64TR53+ROYGqwBzJG4VeXugpOGPnSKIVaJAvSEa7l8qBFokla5hocMl
         QMsLxBL1hUi0EcEGvzHV0VG2sP2xMcMh4M+wjKYt9xHfe3Vhp7LTX/e7eVUgkONS4p8x
         eEiDlyzKOn8rHw7xTQomLo0O+XnTklcDB+MlkdMNspwnUt9+Veq9q6GMUbS0Jdg4UWvC
         3R6XWfraXsl5E2oiidbN3fWoq58yfYdLm7l8wA9OVEXP7sI7cAKZ0Vbud33MzeNlKnzL
         jhgA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi.

I am in the process of migrating to nilfs2 for my root-filesystem
running Fedora-19-alpha.
Basically the system works quite fine, except:

1. RPM checks for free inodes prior installing a package, which
doesn't make any sence of course.
I can pass "--ignoresize" to RPM which disables those checks, however,
I haven't found any way to disable it when using the "yum" package
manager.
Is there any way to make nilfs2 report a large number of unused inodes
instead of "0"?

2. Write-operations are very slow (a few mb/s) and a lot of time is
spent inside:
- segctord
- the application performing the filesystem operations.

I've recorded a system-wide profile of extracting a tar archive as
well as a larger delete operation (rm):
https://plus.google.com/photos/118350688762629274389/albums/5870410083987119137?authkey=CPu0iK2TiOWsoQE

Any idea what could be going wrong here?

Thank you in advance, Clemens

PS: I am using nilfs-utils-2.1.4-3.fc19.x86_64 and linux
3.9.0-0.rc6.git2.3.fc19.x86_64.
the root-filesystem is an encrypted luks container (worked quite will
with ext4, so don't think this is causing the issue)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
