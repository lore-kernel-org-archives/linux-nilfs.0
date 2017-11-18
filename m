From: linuxnilfs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: nilfs2-kmod7 version 1.1.2 was released: fix a race bug that causes
 file system corruption.
Date: Sat, 18 Nov 2017 08:02:31 -0500
Message-ID: <CAE7Udf8kVO3gt7tLBXau=FNnaaTKcyLEAF8UN=hTNbpJnQdYHg@mail.gmail.com>
Reply-To: Linux NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:reply-to:date:message-id:subject:to;
        bh=/IWTBDtC5aJQOUGpY0BKEXZpOOpxclpjSq6XCJR5Vw8=;
        b=P+v+ePwDW78IHkrVPU8YMKGHMQslLhiC29pG5hPU0C5ZGWwF4Bb27vhKea998rMyEL
         5d9Pr6VTc+Vkh3SCeR0yNBFH9tcpW/15FFKl7pJrWfr+a8s1UFio/T/Gc3/cdalmx7Ha
         ypVLDOuTSEECGrotSRVmnCIjo4Xs+FIn/OL2UocICcSClDlXhjp9jCMEVDgbyJilWJwz
         eTWQrhloJCwW5tYtR49lnMVmThgpM7Q61PRv9AjRifb+a/gfd1D9lJKExIlTpM3Ysdbu
         rVkyyQfHen++FJxLMA1ap4eYUX4jYtRDnnKASvzhZ1yzsB8uYolq8iurJ4wy8zUJJ8fS
         jvbA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs2-kmod7 version 1.1.2 was released. Fix a race condition bug that
causes file system corruption. For details, please see ChangeLog file
or commit logs.

from https://nilfs.sourceforge.io/en/index.html#n131
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
