From: Edgard Pineda <epineda.contact-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cannot mount nilfs2 partition after io error in raid5
Date: Mon, 22 Feb 2010 13:44:46 -0300
Message-ID: <d5c85db51002220844k1fdd5f03pdd2fd97f61a10fa7@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:date:message-id:subject
         :from:to:content-type;
        bh=FLv4y+TmtdS4ECMcE7qUrwdeoij4LjtdFXWB9CmN5ZQ=;
        b=k60tNqg8x03fKW7jCBHHhclUPb48x2K+H7JZCeQfPgi3fe0Gu78LNOfzOPf91+lI35
         +wzJaY8g4i2zEQsO0YrrRMNLSvX1aVmf2iz9Op6qJrX1iajGZGpybeEGi6tvYKJLw/oy
         2GWkFUkf/DuTQiFM5s5DUC8bA9r+u7T0Nu1KM=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I just had a 4 harddrives in raid5 with nilfs2 (kernel 2.6.32 and
nilfs-utils 2.0.15) and I've got a power cut, then I rebuilt the
array, but when I tried to mount the nilfs2 partition I've got:
"NILFS: Can't find nilfs on dev md0" (in dmesg) after execute
"mount.nilfs2: Error while mounting /dev/md0 on disk: Invalid
argument".

Any idea? can I mount as "read only" to rescue some files? any tools
to "see" the files and fix the partition?

Regards,
Edgard.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
