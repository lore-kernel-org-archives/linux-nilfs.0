From: Kenneth Langga <klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Questions on nilfs_cleanerd
Date: Wed, 7 Mar 2012 14:13:35 +0800
Message-ID: <CAHmELnXB7LFwDRR53G_kCWb9t5wfWQOXDq=0xRC5bh9Z3TJuuw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=UqkKSaF5VWn45y1RS8zWvrgQIw0T1lJ3/8AZiJjfvhM=;
        b=VbRvfnlr+883z9sjUq9Kr49Ha3/RQXoZut5Xg0JHoh+MYS62RiwqO50tw4aCGkQFb1
         B4lFNxDMU+D5yoKMHcsU3qD4/XMy8u4wO1y83CoEeJwnh8v/BecpMtNjM104DI5lhK24
         72fri76rAZEyuNU0k7jOsvn+ABY7VABJPs/y8RDZ4SOSUgrfvwiUMUCtjARSYxdCFFCP
         XJP7xGDDTuLeEButaZCPuvUUnKlfFRWX7Ecyj/ksxso7+y4RnL4vNtVE0lnOVdQ+a4ov
         LCXIiDgYdiaRyY8Tiv1DuErDBvXqjh7E1ikWCNwWwu7Ij679P2YxTXSX03c/SI8S77bQ
         aSHQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

1) Does the daemon read/write the entire drive to look for dead blocks to clean?

2) What if there aren't any dead blocks to clean and the free space in
the drive is still less than 10% (the default min_clean_segments in
the conf file), does the daemon still process the drive? If so, how do
I change the cleaning interval so that it doesn't process the drive as
often?
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
