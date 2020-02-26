From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NiLFS support on Pinebook
Date: Thu, 27 Feb 2020 00:14:57 +0900 (JST)
Message-ID: <20200227.001457.2102675267682326035.konishi.ryusuke@lab.ntt.co.jp>
References: <20200226102235.GA2060@dropje.13thmonkey.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wI1GsLnjFMP9Dm9JS/xs2U8x9zCxeZWv1ClCqCrijjQ=;
        b=oAlodPMZl2QkSxDMZEVbxJHeLKkpVGq1wqZ4k4+60sKc0H/PkfFpqEzpnKsroq7YPJ
         rYvIlp4K1ixcd1Q2kIDpSPRkGHKqrYjJ3uDMrjQpetn8FXV78nUOcHBx2jnGs4aYjD5W
         UUbr+uNj3c9+4DDxOSc0cuFStwooZYvpBJs4MSxeCO8HE+UhW7H7Xceg18e8g4FueaX/
         inoHWtuXez1HJW6t1wAqSfH5MidGcoIxCsg0dOKw9JPbCxKS76di0LgH95Etbov4vugq
         MUo/1jdXRprm6iFDbRe+EdSpc0S+CXeMQetxJAvU4HpAPS3Bh8ryg9tv01AKuP9tcIAo
         HOmw==
In-Reply-To: <20200226102235.GA2060-WweU7nrmO3INqjISwOrxaLFspR4gePGN@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi Reinoud,

> when i mount a partition it gives the error "mount.nilfs2: cannot find or load
> nilfs2 filesystem". Does this mean the linux kernel has no nilfs2 module
> shipped with it, but only the tools?

We see this message if nilfs2 kernel module (nilfs2.ko) doesn't exists in
/lib/modules/$(uname -r)/... .

Some distros don't have nilfs2 module (e.g. RHEL/CentOS), and some
need an extra package like kernel-modules-extra (e.g. Fedora).

I don't know that is there in the Pinebook.

Regards,
Ryusuke Konishi

On Wed, 26 Feb 2020 11:22:35 +0100, Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org> wrote:
> Dear folks, dear Ryusuke,
> 
> I am trying to use NiLFS2 on my Pinebook that identifies itself as GNU/Linux
> on aarch64. It allows me to install nilfs-tools wich seem to work fine but
> when i mount a partition it gives the error "mount.nilfs2: cannot find or load
> nilfs2 filesystem". Does this mean the linux kernel has no nilfs2 module
> shipped with it, but only the tools?
> 
> How can I install the nilfs2 filesystem? Or is that up to the distribution and
> out of my control?
> 
> With regards,
> Reinoud
> 
