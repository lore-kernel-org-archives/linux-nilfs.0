From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 doesn't garbage collect checkpoints for me
Date: Wed, 1 Jun 2011 21:19:25 +0200
Message-ID: <201106012119.26289.dexen.devries@gmail.com>
References: <BANLkTim4BBKwFJUzbnsKw0_Ru2k8ZW3MYw@mail.gmail.com> <201106011934.30725.dexen.devries@gmail.com> <BANLkTinsZZeRDmQR8sAWrqUP1N4UK5ktAA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=yPiehQxW5zeLsxGkn+EKi/51ZRsqNE9OJGlco/VrvTs=;
        b=PBYp7XeBBaPPgN98iJqm4c1iqWGm3naoceq6ycC4BHIJRtKfBPqZhfFvtWnVDmCFgi
         DjRZETJNfZlATcbeBIH/NAV9jTEyRX8FoDwaORmdwfJfQV0jJXfJ48fmyDb3JwgE7L/Q
         E7HZ5vjTYNVJDeYGnM9gEHyxNfX7oS/CUqWyk=
In-Reply-To: <BANLkTinsZZeRDmQR8sAWrqUP1N4UK5ktAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi again, Dima,


On Wednesday 01 June 2011 20:21:07 you wrote:
> Thanks for the tip, bkltrace seems to give me what I want and much more!

yay :)


dunno if that'll help you at all, but:
I've been observing some process writing to NILFS2 to-day. It was issuing one 
(filesystem) transaction every couple seconds. About 250kb was written to the 
drive (of both data and metadata) -- and the interesting thing is, it was 
written as one I/O operation (as reported by iostat).

Depending on configuration and properties of your storage (possibly including 
multiple-sector i/o configuration, see hdparm's `-m' option), a (filesystem-
level) transaction on to NILFS2 may issue just one drive-level operation.

As opposed to other filesystems, which keep data and various kinds of metadataa 
all separate.

Of course later on the GC will kick in, but it also writes large chunks at 
once, rather than spreading them all over the storage.



Cheers,
-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
