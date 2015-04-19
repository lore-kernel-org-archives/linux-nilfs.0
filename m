From: Linux NILFS <linuxnilfs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs2-kmod7 v1.0 was released: back-port improvements from the
 latest mainline kernel
Date: Sun, 19 Apr 2015 13:49:38 +0900
Message-ID: <CAE7Udf_wOnbHF8QHm_enRMXCUuJuX47Dt+NbkfxgDWi2JMuPSQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:date:message-id:subject:from:to:content-type;
        bh=H55cTgqPKEIZ9lhVeHbB4/xOPLsXYGPKeEelrwqqZvE=;
        b=r8NFt5itb4EAalEe3xXwQCXnnBlg6H5pejrJtwYVcWSccLXT3JM47CPMntqrHu+Ctu
         +raDadRIpuu5STVYdKJ6Aw4qCH9CLvGg9pAXaciaHSZm0fDsVljcyjwYv4myKy/oeqLt
         zdAzf56T+fvFpaZAeBBhmy2R0/n3d1qtiXodnceF5yi06CTHB8LJG0hRLyDYYzOWeC0m
         frtpOuk8LZ5ziMDVRAcbA/lo3bXbiDHZZTfQ/RrqTRnM7n5/rdBLnVW+tFfqfninfCBE
         VnHBbK2YOIoOLoKFDSVb5fkRmOFgh/jQqDGHz+uXUh5kZgdYEhk8dyT7oZUOdPNLcB6Q
         x2zQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Version 1.0 of nilfs2-kmod7, the stand-alone kernel module supporting
CentOS 7, was released. Back-port improvements from the latest
mainline kernel, including improved performance of checkpoint list
output (lscp) on aged file systems. Also, support build for vanilla
kernels v3.10+ and v4.0. For details, please see ChangeLog file or
commit logs.

from NILFS http://ift.tt/1Dyb1w0
via IFTTT
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
