From: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Which version of nilfs do you use?
Date: Thu, 27 Dec 2012 17:47:34 +0800
Message-ID: <AAEC3976-3D79-4170-B1DC-2A04499392DE@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:content-type:content-transfer-encoding:subject:date
         :message-id:cc:to:mime-version:x-mailer;
        bh=K8OuBJjGdqFxFUw0hYP2HMcZdMqsQNFH+2INiAG2Arg=;
        b=A7fcf8YYThUDAlWQvULfNBjuNP+d8ZUwVdlB2ayhYV8GVTYKIpTCczetuqjzmhzHd8
         jrazHqouitBOeTZkcuIgXZvLaoCTa/DpqGTvBPEdvGqBC6+aswo2PjU51I0XJygRTHAY
         Dj0imWbzKejZDHNkD45hQfXqfYK/ma1KS1FAU9uUMPoZ42Ib4SSWhn033qYv4reHjpjs
         bJvkGJwLN4usE4znzy/WkERFz+e0X/Oei6PpjL9Q0rTfNnGjr4XK/RoRZkYHckX+a/lL
         JXenf2KilEuSLo82b2DsIxsIEjw9AezEP7DyKmtxgeoaB1bDtLCNLX3zUDYwYBKF/Kpu
         Qljg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi konishi ryusuke,

I am trying to use NILFS2 to make MySQL cold backup, but  the MySQL tables often be crashed. It seems there is some problems with nilfs filesystem.

I have described how I use nilfs in this mail: http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01481.html

Can I know which version of nilfs do you use, and what do you use nilfs for?

Thanks,
Elmer Zhang--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
