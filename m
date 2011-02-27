From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: It is not possible to restore file from a mounted snapshot using a hardlink
Date: Sun, 27 Feb 2011 18:08:26 +0100
Message-ID: <201102271808.35626.dexen.devries@gmail.com>
References: <201102271420.57110.dexen.devries@gmail.com> <-5130718212985067227@unknownmsgid>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=IyS380CefcIVWwqX8uodWLvZZbafLmaiChQtV7B14ZU=;
        b=ZokRI47irOrdaDWviOsnEMFAENSVVW8S8vTLhEAemN9Yoe8NkKGpmPA/JlN//yzIIy
         smLeiE2CjTTyJRgzO0Z5R3NqIprLySqczjOJhlZfxLoM1iU+1QHaYWJg3R23YF4146wb
         jlJHSsnNmMv31aj6h/vLPejxBFs1O0ANNgk9Y=
In-Reply-To: <-5130718212985067227@unknownmsgid>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sunday 27 of February 2011 16:56:25 you wrote:
> In fact, hard links are not supposed to work but cp --reflink
> *should* work but it does not seem to. cp --reflink is what you would
> need to achieve what you want.

I'm much surprised why hardlink shouldn't work.

I used the `stat' command on a file that's both in snapshot and (uchanged) in 
current filesystem state and both inode and device fields (st_ino and st_dev) 
are the same. Thus I don't get why Linux would consider that a cross-device 
hardlink. After all, it's the same filesystem, just different views of it. 
Perhaps Linux' VFS is to blame...


-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
