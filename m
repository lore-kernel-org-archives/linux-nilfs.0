From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Sat, 17 Nov 2012 10:27:36 +0900
Message-ID: <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com>
References: <50A5737C.2040805@li.ru>
	<201211160313.AA04185@capsicum.lab.ntt.co.jp>
	<50A65588.3000205@li.ru>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=+QBf6hvx1K64ee+lSTcx3AL1LslODO4lr+MdECw6T0Y=;
        b=y8DZ+PfuG+XMLE2AK24vrIdvpW1sfBDBpcFOmgSGs8T2XpqnfFiQHJrtNfUr9QWNnx
         nXb+/A/uwwnMJbhkVK/WHDD91AkwHlTbqNZ32zM/VrAQofLU9SWPJvqH1IwaPWMJIqNR
         8z0eEbKUt1rnffaP2XK3T7U1x4wEASg/BBC/2SVpY9c52lMOOr4LVglbWFAah7gIJwPe
         ckx4sLWNGwaIXCMEqoFp8wBZwqG+SA21rMubBBub04ktxKg4KEXt2t5rG7vxi5Dw/F1G
         xBuF2U2mWIewKlgBLF/64uKtMIi7k2VYTGWCZcByRTHQ6LvJmFPBSiMOAe8hQ7KM7bU0
         tCWA==
In-Reply-To: <50A65588.3000205-3TRaYzfGuuI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Nov 17, 2012 at 12:02 AM,  <fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org> wrote:
>> Hmm, the default value of this parameter is zero.
>> Have you changed it with the nilfs-tune tool by some chance ?
>
> Yes, I've changed it to 60 sec for rootfs partition, and 180 sec for data
> partition. It worked flawlessly with this setup on root partition for last
> 14 months...

OK, please confirm version of your all kernels including initrd.

The interval parameter was broken in old NILFS2 kernel
modules due to a bug.  It was fixed at kernel 3.0 as follows:

> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2573,7 +2573,7 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct super_block *sb,
>
>         if (nilfs->ns_interval)
> -               sci->sc_interval = nilfs->ns_interval;
> +               sci->sc_interval = HZ * nilfs->ns_interval;

If you changed kernel back to an older one, this may be the
cause of your problem.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
