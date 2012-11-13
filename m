From: fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org
Subject: Re: Strange "flush" process bahaviour
Date: Tue, 13 Nov 2012 18:01:03 +0400
Message-ID: <50A2529F.1050005@li.ru>
References: <50A159BC.9060600@li.ru> <1352787218.2042.9.camel@slavad-ubuntu>  <50A24564.7000704@li.ru> <1352814101.2443.9.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352814101.2443.9.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> I can see that you have two running nilfs_cleanerd deamons. Second one
> (1237) is started with special configuration file. Moreover, I
> understand that /dev/mapper/raid_new device is mounted to /mnt/raid. But
> what is /dev/mapper/system device? And where did it mounted? What
> content has /etc/nilfs_cleanerd_rootfs.conf? What difference
> between /dev/mapper/raid_new and /dev/mapper/system?
>
> With the best regards,
> Vyacheslav Dubeyko.

I have 2 different nilfs2 partitions. /dev/mapper/system - is a rootfs, 
about 32GB size. /dev/mapper/raid_new - is a data partition 1.8TB size.
Yes, there are 2 different config files for nilfs_cleanerd, because I 
need different GC collection policy for rootfs.
I'll send contents of nilfs_cleanerd*.conf files when I'll get to my PC.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
