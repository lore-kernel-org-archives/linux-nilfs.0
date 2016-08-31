From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Port for nilfs-utils for Blackfin-uClinux?
Date: Wed, 31 Aug 2016 23:11:26 +0900 (JST)
Message-ID: <20160831.231126.66742263435819720.konishi.ryusuke@lab.ntt.co.jp>
References: <CAGNxCnsUs_CT47Pw1tWhLaTKKJOR3fJYVEpU5sjFHodoXCtg+g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XB2VydI4tyaWw6O+/VSiXhNGiMBm/98s0jwytYy//lc=;
        b=AptEn/3gZ45V/un0YdK8pfIP9BEXGCHr2ErWq5TE93YJ0oqhC+LaetMIRKfSQQ6T1L
         4VDweDEorjIYUtHBBMevy1tEZx6iN8eYcwrm3Ws9cLtwZdadV5SgkJqIVCUE1rtF34QJ
         V4KfxCqgWFl5twbP77JA4vJTS/77vCInQI9jZObRbVb2ikA/6TIwlfismc0I4ltG6BLM
         IQLV+OqJPryRTZ5Af8JliusATc8YTShCEA5nq7LS8lp09eJDpt4uJNUUX01njV71ITaP
         a1Y0PhbBYUQf3nNEkW+4I6bhWaZuY2OkeS5deSEqaWDnxFw7aSKq/0gqmVedh/G9K+A/
         q7OQ==
In-Reply-To: <CAGNxCnsUs_CT47Pw1tWhLaTKKJOR3fJYVEpU5sjFHodoXCtg+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Kai Parow-Souchon <kai.parow-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 31 Aug 2016 14:17:05 +0100, Kai Parow-Souchon wrote:
> Hi,
> I am currently working on an embedded system running uClinux using a
> Blackfin processor.
> 
> While the nilfs kernel module is available and builds without issues
> there don't appear any useable version of the nilfs-utils in that
> buildroot build system...my quick attempt at porting this wasn't
> succesful, but I don't really know how to do that.
> 
> To start off with, two questions:

> - are the NILFS-utils required for using the file system?

Yes.  Userland GC program, nilfs_cleanerd, is included in nilfs-utils.
Without nilfs-utils, disk space is not reclaimed.  Also, mkfs.nilfs2,
nilfs-resize (resize tool), and other utilities are not available.

> Can I use it
> manually using /sys/class interface or similar? (I suppose this is a
> yes...)

No.  At least nilfs_cleanerd should be installed.

> 
> - are there any already ported versions of the nilfs-utils available
> somewhere to blackfin-uClinux? (I suppose it is a no)

I don't know.

> 
> Otherwise I will need to try to compile these myself, but it didn't
> work very well...Are there some rough guidelines on how to do this?

Please see the README file included in the nilfs-utils tarball.
In most cases, it's not difficult to build from the tarball.

Regards,
Ryusuke Konishi

> I guess the obvious things are to point to the kernel build directory
> and using the blackfin-specific tools.
> 
> Any suggestions welcome!
> 
> Thanks,
> Kai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
