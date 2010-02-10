From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: crash
Date: Wed, 10 Feb 2010 13:07:00 +0900 (JST)
Message-ID: <20100210.130700.55835591.ryusuke@osrg.net>
References: <201002100059.AA01340@capsicum.lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201002100059.AA01340-ZdTO5nnmHvkOizVVqyxoihMFgDP4sedm@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

----
Hi,
> (Cc'ed to linux-nilfs)
> Hallo,
> here is a copy of a post to the list in which you might have an interest.
> If you need me to do anything please feel free to ask, I hope I will have
> some time tomorrow.
> 
> Regards
> 
> Jan de Kruyf.
> 
> ------------------------------------------------
> Hallo,
> I did it again.
> computer locked up. Most likely X, since the keyboard was dead. But the
> cleanerd was still running
> from the flashing of the hard-drive LED.
> 
> Press the big hard reset button
> restart . . . /var partition (nilfs2) is now full and the restart cannot run
> to completion.
> 
> This is the 3rd time it happened to me!
> 
> The only thing I can think of right now is that the cleaner daemon was
> interrupted at the wrong moment.
> And the /var partition was left in a full state. Is this possible?
> 
> Does anybody want anything of the image for a post mortem?
> 
> Does anybody want me to do some tests before I reformat?
> 
> Further details will follow once I got the rescue HD hooked up.
> 
> Regards,
> 
> Jan de Kruyf.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Can you mount the partition with -o ro,norecovery ?

If so, can you see if there are warnings or errors of some kind in
syslog or daemon or messages?


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
