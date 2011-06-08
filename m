From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Cleancache
Date: Wed, 08 Jun 2011 23:02:31 +0900 (JST)
Message-ID: <20110608.230231.65968027.ryusuke@osrg.net>
References: <201106081514.59693.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106081514.59693.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 8 Jun 2011 15:14:59 +0200, dexen deVries wrote:
> Hi list,
> 
> 
> there's that recent interesting addition to linux: `cleancache' (and 
> `zcache').
> I've enabled it for NILFS2 yesterday (in 3.0-rc2).
> It seemed to work for a while -- sensible numbers in 
> /sys/kernel/mm/cleancache/* 
> But it broke terribly after performing
> echo 3 > /proc/sys/vm/drop_caches
> kernel reported NULL pointer dereference, IIRC. Ext4 works a-OK with that, so 
> my first guess waws NILFS2 is doing something funky with page allocation or 
> mapping.
> 
> Cleancache has own hooks into VFS, and for `normal' filesystem that's enough; 
> at least enough for ext3 and ext4 drivers to work reliably. On the other hand, 
> btrfs does something unusual with pages and they used extra cleancache hooks 
> for btrfs, IIRC.
> 
> Should I dig further, post backtraces or something?

Interesting.

Can you get a log of the oops ?

I may have time to look into the problem in this weekend.


Regards,
Ryusuke Konishi

 
> I believe using cleancache + zcache could be beneficial, especially for NILFS2 
> metadata like the DAT file; what are your thoughts on it?
> 
> 
> Regards,
> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> For example, if the first thing in the file is:
>    <?kzy irefvba="1.0" rapbqvat="ebg13"?>
> an XML parser will recognize that the document is stored in the traditional 
> ROT13 encoding.
> 
> (( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
