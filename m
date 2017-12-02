From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: error mounting, input/output error
Date: Sat, 2 Dec 2017 09:12:31 -0500
Message-ID: <CALJXSJrpR_BzaXSBeVTUw=UCK=OjcmGnD14Yb86rehsi=pcPtg@mail.gmail.com>
References: <20171202072129.Horde.hTiH1buA85eVlzWo5n2UQ-5@rapidbsure.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=LYg7pfi01c7SilmeMPelfk8JH7LF4w5sU3FYoHYzTA0=;
        b=E0imik84QDPN+giG1N+CXBYIv/2TpyLhT4pmG5Yt4QXL0obji7l+/RqF6QV1i4ywXs
         b6sJkxUVl7YCM/W214gx916QEfF9o0Uw+1v6MbJV8egja5em1qXL/jJNzItXmqDSYN17
         2SVyC/3x+9v8h5dr/hRzi7NsBnullNqwa4JwL5vPM1h8GH0ndRAlH74iDEJwr8fKd21q
         PrAt3f0YNp2/26CCB0kjD5axajWTdhGQPqbAvPvlBBqM3EsTRtJpIA/GuAmpx462eoYf
         Dbccjj2LZQwqqR2Kgjqz6HgJRK6x8Dq4Vb6tNEST+aCuEc1nLQO8c2LSVLJOAr5yntzH
         aQMg==
In-Reply-To: <20171202072129.Horde.hTiH1buA85eVlzWo5n2UQ-5-F+CjGebjtwRZroRs9YW3xA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: customersupport-F+CjGebjtwRZroRs9YW3xA@public.gmane.org
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Dec 2, 2017 02:39, <customersupport-F+CjGebjtwRZroRs9YW3xA@public.gmane.org> wrote:
>
>
> There is no fsck function available, and I failed to copy the image and
> reinstall to a reformated partition- as explained below.

Using fsck when there are IO errors would cause even more data lost.

>
> I get an I/O error "Error while mounting... Input/output error"
>
> output of dmesg
>
>
> [ 3521.639526] NILFS (sdb2): mounting unchecked fs
> [ 3524.672660] ata2.00: exception Emask 0x0 SAct 0x3e000 SErr 0x0 action 0x0
> [ 3524.672668] ata2.00: irq_stat 0x40000008
> [ 3524.672673] ata2.00: failed command: READ FPDMA QUEUED
> [ 3524.672681] ata2.00: cmd 60/40:68:c0:5d:ba/05:00:e3:00:00/40 tag 13
> ncq dma 688128 in
>                         res 41/40:00:e0:60:ba/00:00:e3:00:00/40 Emask
> 0x409 (media error) <F>
> [ 3524.672684] ata2.00: status: { DRDY ERR }
> [ 3524.672687] ata2.00: error: { UNC }
> [ 3524.686112] ata2.00: configured for UDMA/133
> [ 3524.686206] sd 1:0:0:0: [sdb] tag#13 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [ 3524.686210] sd 1:0:0:0: [sdb] tag#13 Sense Key : Medium Error [current]
> [ 3524.686213] sd 1:0:0:0: [sdb] tag#13 Add. Sense: Unrecovered read
> error - auto reallocate failed
> [ 3524.686218] sd 1:0:0:0: [sdb] tag#13 CDB: Read(10) 28 00 e3 ba 5d c0
> 00 05 40 00
> [ 3524.686221] print_req_error: I/O error, dev sdb, sector 3820642528
> [ 3524.686272] ata2: EH complete

When you see this message in the log, your best bet is to use ddrescue
to copy thee disk onto a new one and try to mount again. Anything else
will only damage the disk even more.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
