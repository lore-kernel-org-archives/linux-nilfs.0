From: "LinuxBSDos.com" <finid-aEpbUQpJQqXlKS8GlytQkw@public.gmane.org>
Subject: Re: Recommended partition scheme for nilfs2
Date: Wed, 6 Jul 2011 21:56:43 -0600
Message-ID: <5e3e49d501ed21fb756ac9092e581386.squirrel@linuxbsdos.com>
References: <3414843e1dfde171b9a9da8db1d295a6.squirrel@linuxbsdos.com>
    <a6cda77328d5712a296a687a0e05e298.squirrel@linuxbsdos.com>
    <201107061919.38253.dexen.devries@gmail.com>
    <20110707.122142.41457972.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110707.122142.41457972.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Thanks for taking the time to answer my questions.

> On Wed, 6 Jul 2011 19:19:37 +0200, dexen deVries wrote:
>> On Wednesday 06 July 2011 18:05:29 you wrote:
>> > Just one more thing.
>> >
>> > For btrfs and other file systems, it is customary to have a separate
>> boot
>> > partition, so that at a minimum, you have 3 partitions - /boot, Swap,
>> and
>> > /. Would that be a problem for nilfs2?
>> >
>> > If it is ok to have a separate boot partition, does it make sense to
>> use
>> > nilfs2 on it? Or is it better to use a non-journaling file system,
>> like
>> > Linux Native (ext2) on the boot partition, and nilfs2 on /.
>>
>>
>> for reference, my setup at home and at work:
>> two harddrives, one for / and /boot, the other for /home.
>>
>> both / and /home are NILFS2, while /boot is ext3.
>>
>> i wanted a very reliable journaling FS on /boot to lessen risk of
>> foobar,
>
> As dexen mentioned, separating boot partition is more reliable.  And I
> think ext3 is a good choice for it.  This configuration is recommended
> especially if you make a dual boot environment.
>
> On the other hand, incorporating /boot into / is not bad choice if
> grub2 and initramfs-tools are properly set up and used.  This
> configuration is simple and allows us to back up a fully consistent
> state of the system (with a snapshot).
>
>> and also I'm using lilo, which is not supported by NILFS2 yet --
>> lack of fibmap syscall.
>
> This topic was once discussed with the title of "FIBMAP ioctl
> missing".
>
> fibmap internally uses bmap vfs method.  Adding the feature is not so
> difficult, but it must not be used for overwriting data blocks because
> nilfs everytime changes allocation of file blocks due to its COW
> nature.  Garbage collection also blows up safety of such operation.
> Unfortunately, swap file is actually doing it.
>
> Does LILO use fibmap for read-only purpose ?
>
> If so, we only need a method to deny direct block write by the swap
> file.
>
>
> Regards,
> Ryusuke Konishi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
