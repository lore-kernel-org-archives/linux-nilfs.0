From: Rodrigo Severo <rodrigo-sUXncmUOihszlUgHzu1iJkEOCMrvLtNR@public.gmane.org>
Subject: Re: nilfs bad btree node and broken bmap
Date: Fri, 30 Jun 2017 09:34:54 -0300
Message-ID: <CAOdi6ib8VDquf0meZEmDsxoOHk-eBvr2RQ4p5egOQ0W+t6hzzA@mail.gmail.com>
References: <CAOdi6ianj9cgMHwjSzAkd=f2o3-i5KX4mznnR5hDzsN7ggKLdg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fabricadeideias-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to;
        bh=e2+a2+jgjo79YF1yymSYFL9t8T5hZw6y36Ydnnrvaas=;
        b=qeyn8dt+a1o+FIvkJM3XKBgpCp/WoyleY3xY9r0KRd7pD/2K6V5ibBo0+Vp0J8UL4Q
         2+ZDI0V/Rk7740s7LbxuB2ztc5rH4z0R0nRHV0EHU3JaA5KS+voUVl6DF0laUILz1k7T
         SPvBAGa5APIZh5dnR3mbM/RyMljBDMIOKwc6AkhgJKzXXta4YJAVNL/Js8MnVschQrhA
         NkU1KZLUd2lDZ13bHQZeXCYmVbTlsfdrVVHAMzZtknpmN6RcuTNdT8ZAj7E4AkhRGJWg
         DyiO3ZviQeStwsoo7dgjLhOylIMBdSbc+cG8mnRqa93FbU9LBKxGVXhY1kjrvHUpSCV5
         tamQ==
In-Reply-To: <CAOdi6ianj9cgMHwjSzAkd=f2o3-i5KX4mznnR5hDzsN7ggKLdg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2017-06-28 16:19 GMT-03:00 Rodrigo Severo <rodrigo-sUXncmUOihszlUgHzu1iJkEOCMrvLtNR@public.gmane.org>:
> Hi,
>
>
> I have a 8TG nilfs2 disk with started changing to read-only by itself.
>
> My log files are full of the following error messages:
>
> Jun 28 15:57:08 c1-df kernel: [ 1637.138168] NILFS (sdd1): bad btree
> node (ino=6069196, blocknr=446552325): level = 69, flags = 0x24,
> nchildren = 8203
> Jun 28 15:57:08 c1-df kernel: [ 1637.139363] NILFS error (device
> sdd1): nilfs_bmap_lookup_contig: broken bmap (inode number=6069196)
>
> I have already checked and there are not errors on the disk.
>
> How can I fix this?

No ideas? Nobody?


Rodrigo
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
