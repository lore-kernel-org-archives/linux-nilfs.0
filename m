From: "LinuxBSDos.com" <finid-aEpbUQpJQqXlKS8GlytQkw@public.gmane.org>
Subject: Re: Recommended partition scheme for nilfs2
Date: Wed, 6 Jul 2011 21:55:42 -0600
Message-ID: <09684f8b425db9547af792839dd38a68.squirrel@linuxbsdos.com>
References: <4c09eb01174eecf704c751d7bf1b4bb2.squirrel@linuxbsdos.com>
    <3414843e1dfde171b9a9da8db1d295a6.squirrel@linuxbsdos.com>
    <a6cda77328d5712a296a687a0e05e298.squirrel@linuxbsdos.com>
    <201107061919.38253.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201107061919.38253.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Thank you.

> On Wednesday 06 July 2011 18:05:29 you wrote:
>> Just one more thing.
>>
>> For btrfs and other file systems, it is customary to have a separate
>> boot
>> partition, so that at a minimum, you have 3 partitions - /boot, Swap,
>> and
>> /. Would that be a problem for nilfs2?
>>
>> If it is ok to have a separate boot partition, does it make sense to use
>> nilfs2 on it? Or is it better to use a non-journaling file system, like
>> Linux Native (ext2) on the boot partition, and nilfs2 on /.
>
>
> for reference, my setup at home and at work:
> two harddrives, one for / and /boot, the other for /home.
>
> both / and /home are NILFS2, while /boot is ext3.
>
> i wanted a very reliable journaling FS on /boot to lessen risk of foobar,
> and
> also I'm using lilo, which is not supported by NILFS2 yet -- lack of
> fibmap
> syscall.
>
>
> --
> dexen deVries
>
>> (...) I never use more than 800Mb of RAM. I am running Linux,
>> a browser and a terminal.
> rjbond3rd in http://news.ycombinator.com/item?id=2692529
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
