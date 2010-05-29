From: Aditya Rao <adityacrao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Support for R/W snapshots
Date: Sat, 29 May 2010 19:48:32 -0400
Message-ID: <AANLkTilP5L6XzoU6TQEGFogbWCrJl1MAqyD_6ZpkN53M@mail.gmail.com>
References: <AANLkTil8vqadujEgWPeNveBBD-oyLgwKszSgSqo8i1wn@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:mime-version:received:in-reply-to
         :references:from:date:message-id:subject:to:content-type;
        bh=XXDkEBahq+3o41fKYY16e584AZ+6S6tQy6+HnyK6kUI=;
        b=TeDTTUrODGFnbJnjoc1E8q3z535zD3H9rqPgTywM4mC2DEWdERw6Ys03mg2lYWCpfo
         GXWqOo+dv8P/HF2od2Zy1K9hu59ZiluIjp+2PVBuRRnyem89hNaObPOWxHnBjTVo8ARF
         +r0ZOSyMh686VmA0UJGbBKyvGbO8AamxJ+Tc0=
In-Reply-To: <AANLkTil8vqadujEgWPeNveBBD-oyLgwKszSgSqo8i1wn-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I've been using NILFS along with Xen in my research work. I just
wanted to know if there is any way I can mount a NILFS snapshot in a
read/write format.

Thanks,
--
Aditya Rao
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
