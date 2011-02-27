From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Removing large file blocks write access
Date: Sun, 27 Feb 2011 13:17:17 +0100
Message-ID: <201102271317.17653.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=mw9lRGEjC4JwOjPV0QwY6UsfgOp9t8xh9uLiZeQwND0=;
        b=FY0ZfRLGa/kcYacQluwy6pVBfECAaqAHB0Td6ivX40mfI0rMr1Yh/v2Omjmy93kG1r
         E+xIFWuo/gjsEo8SL/3XdErsLXxhPKRJw6W6CmhVxyKLLo7X2yomIWyGq8fUy8+tXijp
         QhQNz6v4N5f4XtHf9/D7AnwEa3l6Ts1D5E53M=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,


I deleted a 84GB file from a nilfs partition and it blocked write access to the 
filesystem for about 4 minutes, on decent harddrive (SCSI 15k RPM, 147GB)

I believe the file was somewhat fragmented due to fragmentation of free space 
on the filesystem, even though it was created in one pass (a harddrive image).

Unfortunately I don't have checkpoints with the file anymore :(

Regards,
-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
