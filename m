From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Initial mount fails
Date: Sun, 04 Dec 2011 22:29:08 +0900 (JST)
Message-ID: <20111204.222908.193237875.ryusuke@osrg.net>
References: <CAN67vW1TR8g=LBH6p+G4yj8UL9wCmjLghGJJOB3zzQjD-tC-Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN67vW1TR8g=LBH6p+G4yj8UL9wCmjLghGJJOB3zzQjD-tC-Ug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zavi05-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 4 Dec 2011 11:10:12 +0200, Zavi wrote:
> Hi all,
> 
> I'm trying yo mount nilfs on a device without success.
> mkfs works just fine, but when I try to mount I keep getting an error
> > sudo mkfs -t nilfs2 /dev/sdc
> > sudo mount -t nilfs2 /dev/sdc ~/nilfs
> mount.nilfs2: Error while mounting /dev/sdc on ~/nilfs: Invalid argument
> 

Were there any related messages in logs?  Please try dmesg command or
make sure system logs:

 $ dmesg

 or 

 $ sudo cat /var/log/{messages,syslog}

Regards,
Ryusuke Konishi

> I've installed nilfs-utils, and this is what I get from fsck
> > sudo fsck0.nilfs2 -f -v /dev/sdc
> fsck0.nilfs2: cannot read super block (device=/dev/sdc)
> 
> just to be sure the problem is not in the device, I mounted ext4 on it
> successfuly.
> I can also do block requests (dd, iometer) without a problem.
> 
> I'd appreciate any suggestion.
> 
> Thanks,
> Zavi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
