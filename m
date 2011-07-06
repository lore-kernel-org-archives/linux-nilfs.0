From: "LinuxBSDos.com" <finid-aEpbUQpJQqXlKS8GlytQkw@public.gmane.org>
Subject: Re: Recommended partition scheme for nilfs2
Date: Wed, 6 Jul 2011 09:56:08 -0600
Message-ID: <3414843e1dfde171b9a9da8db1d295a6.squirrel@linuxbsdos.com>
References: <4c09eb01174eecf704c751d7bf1b4bb2.squirrel@linuxbsdos.com>
    <20110706.133558.186520806.ryusuke@osrg.net>
    <59b61d7de047661eb7c2a1cf42df08f1.squirrel@linuxbsdos.com>
    <20110707.004339.125911682.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110707.004339.125911682.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Thanks a bundle. That pretty much addresses all I/we need to know about
disk partitioning per nilfs2.


--
Fini D.


> On Wed, 6 Jul 2011 06:29:53 -0600, "LinuxBSDos.com" wrote:
>>
>> Thank you.
>>
>> With regards to /home, will there be a negative impact on the way nilfs2
>> works if /home is on a separate partition?
>
> Usually this is a good usage.
>
> Possible demerits are:
>
>  * We have to mount and access snapshots separately per partition.
>
>  * Checkpoint numbers increase differently if we use two or more nilfs
>    partitions.  This makes it a bit troublesome to choose consistent
>    snapshots for multiple nilfs2 partitions.
>
>  * User needs to specify a device argument for lscp and other snapshot
>    commands for multiple nilfs2 partitions.
>
>    The current nilfs utilities does not provide the way to specify a
>    target partition with a directory argument.
>
>  * GC daemons run and reside for each nilfs2 partition, and this may
>    require more memory and cpu time.  Usually this is not an issue
>    because GC daemons will sleep while having enough free space.
>
>
> As long as applying nilfs2 only to /home, I think there is no
> mentionable demerit except the system is not protected with the
> automatic checkpoints/snapshots.
>
>
>> On Ubuntu and nilfs2, Ubuntu's installer does not have nilfs2 as a file
>> system option, how did you install Natty N. on nilfs2?
>
> I cannot remember how I built the current natty environment, but
> usually I do that manually with debootstrap program.  The following is
> a copy of my memorandum showing a rough scheme:
>
>  1) Make a bootable usb pendrive.
>
>  2) Install nilfs-utils and debootstrap in it.
>
>  3) Boot from the usb memory and format the main drive with nilfs2:
>
>    # mkfs -t nilfs2 /dev/sda8
>
>  4) Mount it and run debootstrap.
>
>    # mount -t nilfs2 /dev/sda8 /nilfs
>    # debootstrap --arch amd64 natty /nilfs/
> http://xxx.xxx.xx.xx/xxxxx/ubuntu/
>
>  5) Edit /nilfs/etc/fstab.
>
>  6) Edit or copy /etc/hosts.
>
>  7) Copy /home as needed.
>
>    # rsync -ax /home/ /nilfs/home/
>
>  8) Do chroot
>
>    # chroot /nilfs /bin/bash
>    # mount -t proc none /proc
>    # mount -t sysfs none /sys
>    # mount /dev/sda8 /boot  (if using a separate boot partition)
>
>  9) Set root password
>
>    # passwd
>
>  10) Make an acount
>
>    # groupadd -g 1000 <my-user-name>
>    # useradd -g <my-user-name> -u 1000 -c "My Name" -s /bin/bash
> <my-user-name>
>    # passwd <my-user-name>
>
>  11) Edit /nilfs/etc/apt/sources.list
>
>  12) Set timezone
>
>    # dpkg-reconfigure tzdata
>
>  13) Install packages
>
>    # apt-get update
>    # apt-get install rsync ssh openssh-server sudo gcc make git-core
>      automake autoconf aptitude ...
>
>  14) Build and install nilfs-utils
>
>  15) Manually build and install util-linux-ng which supports nilfs2.
>      This is required to mount nilfs2 partitions by a UUID or a LABEL.
>
>  16) Install and setup grub2, and run update-grub program
>
>  17) Reboot
>
>  18) Install desktop environment
>
>
> I think this needs trial and error for natty since this memorandum was
> originally made for Debian.
>
>
> Regards,
> Ryusuke Konishi
>
>> I know these are not dev-related questions, but I'm planning on writing
>> several nilfs2-related tutorials, and need to know exactly how a disk
>> should be partitioned for it.
>>
>> Thanks,
>>
>>
>> --
>> Fini D.
>>
>>
>>
>> > Hi,
>> > On Mon, 4 Jul 2011 13:28:39 -0600, "LinuxBSDos.com" wrote:
>> >>
>> >> Hi,
>> >>
>> >> A couple of Linux distributions now have nilfs2 as an optional file
>> >> system
>> >> during installation and I just want to find out what the minimum
>> number
>> >> of
>> >> partitions required for a nilfs2-based installation is.
>> >>
>> >> Is it necessary to create separate partitions for the major file
>> >> systems,
>> >> or does nilfs2 require just one root file system directory? Is /home
>> on
>> >> a
>> >> separate partition necessary?
>> >
>> > nilfs2 can be used as a root filesystem and it is bootable from recent
>> > grub2.  I'm using nilfs2 for the root filesystem on my ubuntu-natty
>> > laptop.
>> >
>> > One restriction is that nilfs2 does not support swap file, so users
>> > need at least two partitions, swap and root.
>> >
>> > /home is not necessary to be a separate partition.
>> >
>> >> Lastly, can I encrypt a nilfs2 partition?
>> >
>> > nilfs2 itself does not support encryption.  Instead, it can be used
>> > together with ecryptfs or dm-crypt.
>> >
>> > Thanks,
>> > Ryusuke Konishi
>> >
>> >> Thanks,
>> >>
>> >> --
>> >> Fini D.
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe
>> linux-nilfs"
>> >> in
>> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
>> in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
>> in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
