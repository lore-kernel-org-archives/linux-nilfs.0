From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: It is not possible to restore file from a mounted snapshot using a hardlink
Date: Sun, 27 Feb 2011 14:20:56 +0100
Message-ID: <201102271420.57110.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=+RWQiNIE4FsZrCZPhQYqMxnBX+c+WA/Rm3wli3TXcDM=;
        b=ivDjMOubqBM4Fqdw/9z54+lCAafmgjuPSS2rLflBQz448m6G093vqLIZ08aqYqhubO
         OQfIwlgmZQGP4MXQ6rERj8OdPgznMmRXFmwIz2A60Zgvt3c2sxHiPjFOQAQq41fLCxji
         h4uSRhl0BwZtIKOP4dyAyvcUjuh8pxEelvmwE=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,


The following is more of a feature request than problem report, actually.

I've mounted an older snapshot and tried to restore (add it to the current 
filesystem state) by creating a hardlink.
Roughly like:
mount /dev/sdb3 ~/current
mount.nilfs2 /dev/sdb3 ~/old -o ro,cp=1234
cd ~/current
ln ~/old/file.bin ./restored-file.bin

The `ln' returned `Invalid cross-device link'.

I expected such hardlink to have semantics of re-using all the data blocks & 
metadata of file.bin from snapshot as restored-file.bin, so no duplication of 
data blocks happens.


Regards,
-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
