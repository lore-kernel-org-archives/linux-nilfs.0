From: Eric Lan <tenoreamer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Feature request: time-shift function
Date: Fri, 5 Feb 2016 01:57:40 +0800
Message-ID: <CAFm8q6fJm-ZYKhGpV0b6PrdbaosSzUz4JUC9-XjiDLUvObQ0TA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=7EV/KBEMV/cFF0PNFcmATp58O9AjOiBgSMrDNB8tRRc=;
        b=rRN8a1+9s8ArJqvPkWGtbJpxXqArY5DDCtnEbI9asWNhvOulBmbO3s9sxZ2ew9Ojc2
         Y9MNfWpgjSUA4JxpMfr6peY3kvXovqZCPpy2+4RiVB48n08i106PsK3Fg6kWbT3+UyAi
         Vyds+EG35o2o+llzyPf+P5k/hhVCgBPHzmHRvgoIfVBIEY3jKjUuQtZlHGkMTe8WU9G4
         BNepPDl8qD0SWxFZ5xVcWRseqVmsnHYDwxHYCUwwefLEpXrnJOLz6hHoo0v9kZ2iFVEg
         iR28t+Zad7CeyFRM5/3IbGGBqAckimCCxZkM0p9jNrvwMwdHz51Q0X0orUzCM2xoh4ei
         tb1Q==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Every checkpoint represent a complete filesystem at a given time. When
a system corruption occurs, is it possible to mount a specified
checkpoint (when the system is still clean) as read-write to
"time-shift" to the state when the bad thing still not happened. Of
course the checkpoints newer than the "time-shift" point will be
discarded.


Best regards,
Eric Lan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
