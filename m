From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Hello list!
Date: Wed, 12 Feb 2014 14:04:12 +0100
Message-ID: <CAFvQSYTuM7Zjfz47UGU3KnTgH1iSRWiiZ3iSqXUiu7MKFnOmFA@mail.gmail.com>
References: <52FB49EA.30004@eurekelettronica.it>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=JX1YWgiTwRw/WLUQV43VKJDTOvBSev7b3yeTEO7PV8Q=;
        b=oaCn025PCE1qyf7bI9G/pIruZetBfOsZuPSEXHpW7JLBiD1wVwVVel8v1UDMkfqkH1
         k1SgMXr3VpFZt5ZzPrSLuftsbBSkN7kcMc31BwiqltVWZIB/M3rLQ4F2QMGThsvZU5RW
         fEVrCkbIhhtPiF9KLok0w0sn4UfPpPifsn6x2dqflNgcWfNJoDBzKd0ItbfOq99K358b
         ZJl5PAPYA5FhcBvDfiE43hvzTwpoMVIe2El6Fh7Na0J1cxU7KYyU7s3Txmfir9LZ/23T
         cCv+yCZmzgKWdQE6O3+JjqtPvlWnIrxvPISMrvEPdee6UkPjpcj9G/tYsj8AGyaAsysI
         EsHA==
In-Reply-To: <52FB49EA.30004-RMR/+jklkADqD7ZJT3/+rDUZDU+1vuVT@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gianluca <gianlucarenzi-RMR/+jklkADqD7ZJT3/+rDUZDU+1vuVT@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Gianluca,

> What about the wear-leveling of this configuration of the eMMC device?

Actually nilfs2 is by design as friendly to flash devices with a weak
controller as possible.
It only performs sequential writes, yielding a perfectly equal
distribution of writes across the device.
Nilfs2 even overwrites static data which won't be written to when
using other filesystems - which is great for devices supporting only
dynamic wear leveling (usually SD, mmc, emmc, ...).

However, there is one issue left - the (two) superblocks are written
to periodically in short intervals.
There is currently an ongoing discussion about this and Andreas has
posted an experimental patch which works well on my raspberry pi.

> Can you point me on some tools, utilities to check out this issue?

What I did to observe the write-patterns of various file-systems was
to create a ram-disk using BUSE: https://github.com/acozzette/BUSE
It delivers an example-program which can be modified to log each
write-access, which I imported as CSV into LibreOffice for
visualization.

Regards, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
