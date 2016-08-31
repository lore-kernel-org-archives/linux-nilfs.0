From: Kai Parow-Souchon <kai.parow-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Port for nilfs-utils for Blackfin-uClinux?
Date: Wed, 31 Aug 2016 14:17:05 +0100
Message-ID: <CAGNxCnsUs_CT47Pw1tWhLaTKKJOR3fJYVEpU5sjFHodoXCtg+g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to;
        bh=v6IzuunT6lcxf3yAW52uMKge4XjdrbxMC92rEo+jEHU=;
        b=GQ8pZdBG7T85+IPb186yLwUA70DGOTqY0p1aso8dLu6ESpeaZwUR2gXURdhDlZsba9
         YBqeDE7ZO1rd1BllVGdd2F/itx/LHGyH97VB9rDhfL1gwsf2iHsX+e9Uz06ADKEQB6bj
         gzF/VptRLLKpcYqGrPAvhFtqBQ3GzT+8oI34dUxhzOzem34PoZY00aycWApua+tg2zkc
         CrrpJ6vI83IwpMJh3m4JsIkH0j7f0mEKzg3Yrv8I4bMnIuG35pLfJSFeKIkMMgnGaYtB
         PRayZtTKVT2gI1FVp3jXkE07csnb/tFumFm/245YgeXc587VJOiKRWEVUA3aQoyCCyfN
         AtMA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
I am currently working on an embedded system running uClinux using a
Blackfin processor.

While the nilfs kernel module is available and builds without issues
there don't appear any useable version of the nilfs-utils in that
buildroot build system...my quick attempt at porting this wasn't
succesful, but I don't really know how to do that.

To start off with, two questions:
- are the NILFS-utils required for using the file system? Can I use it
manually using /sys/class interface or similar? (I suppose this is a
yes...)

- are there any already ported versions of the nilfs-utils available
somewhere to blackfin-uClinux? (I suppose it is a no)

Otherwise I will need to try to compile these myself, but it didn't
work very well...Are there some rough guidelines on how to do this?
I guess the obvious things are to point to the kernel build directory
and using the blackfin-specific tools.

Any suggestions welcome!

Thanks,
Kai
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
