From: Linux NILFS <linuxnilfs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs2-kmod6 v1.0 was released: back-port improvements from the
 latest mainline kernel
Date: Sun, 19 Apr 2015 14:04:39 +0900
Message-ID: <CAE7Udf80v2apa0HNz-Mv_hZ9tep32ASYHj5FxYJafop8tD8zpQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:date:message-id:subject:from:to:content-type;
        bh=8CoDp2eQ3UOYhQqeKBOAjtW87l9VGbIlvkx5MeLDSu4=;
        b=Z/O9xI7PavRFocSwDuNkSdqfQl/50j7H6RCUC1lRBQm4M8Z24Bu/NCpQ1D2X7xLO+a
         vXnUqqu792tQoybDkR2soXRjp0/tzWmRsDUDrnairuREZ3lno3lbjeV9PYk2bbWf12XP
         qoSaacTr31tMmSLuhGtLLKWUkWfSgQoEtLyW90ad6sHU1g8IpLLvlWupdaq3GOFnsOEE
         uNd35j56h84jARc2yWjUgRCCOLIJis7Rw+SHEu7p9/cKNwQsBfPzG498UpGW6NWu3so3
         VJrwaaFlBdHBjFkLlo1Z8p/y8fqiXZjywCT3a0x7vus78cNw5ITHcRJ4VWbBePzNU7vU
         1EBw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Version 1.0 of nilfs2-kmod6, the stand-alone kernel module supporting
CentOS 6, was released. Back-ported improvements from the latest
mainline kernel, including improved performance of checkpoint list
output (lscp) on aged file systems. For details, please see ChangeLog
file or commit logs.

from NILFS http://ift.tt/1yGCDAk
via IFTTT
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
