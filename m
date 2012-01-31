From: Christophe-Marie Duquesne <chm.duquesne-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Battery friendly mount options?
Date: Wed, 1 Feb 2012 00:19:29 +0100
Message-ID: <CAHLp1Y=Dv8AGM6=dHx2GknuRXudoSuh8+-QTdvkFAtpSVXbeOg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=1o0yZy67owpIg0+rTOpr2zlHWummEudWJ93gZK0r3n4=;
        b=oaDk4y+2BLOlqVFO6j2HdSS8zKtlnypQddKwdweSJpHDV5UIRGt0TbrtUoWR4lElIV
         EFFmNOt5og0MvrlKtyINV/h0FvhEQhMLQeS6+QZVAay55x6tzEgx0SVCUj48gu7S/Bgp
         TruC2+XSt4oaVHhPmCV2Hmb7JSxV+JeY1dNUA=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I decided to give a try to nilfs2 on my laptop, and I wanted to know
if it has battery friendly mount options, like commit=<value> for
ext3, which syncs data and meta to disk every <value> seconds. I have
seen that with nilfs-tune you can set a commit-interval and a
watermark treshold, but I don't know what kind of values I could
apply.

Programs for saving power like laptop-mode-tools typically set the
commit value on ext3 systems to 600, meaning that you can loose at
most 10 minutes of work when running on battery. I would be perfectly
comfortable with the same kind of settings.

Cheers,
--
Christophe-Marie Duquesne
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
