From: Jay Carlson <nop-Nqdcz63CPQY@public.gmane.org>
Subject: Re: uuid for nilfs partition?
Date: Fri, 28 May 2010 16:11:16 -0400
Message-ID: <AFD9E520-C364-41DF-9772-4765AB63E49B@nop.com>
References: <4BFA8D5B.6000700@daliverse.com> <20100525.003345.115737304.ryusuke@osrg.net>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100525.003345.115737304.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: Jay Carlson <nop-Nqdcz63CPQY@public.gmane.org>, dlarge-RrB2l6sP9Nll57MIdRCFDg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On May 24, 2010, at 11:33 AM, Ryusuke Konishi wrote:

> Hi,
> On Mon, 24 May 2010 09:29:47 -0500, Darien Large wrote:
>> I'm using nilfs2 for my /home directory, under Ubuntu 10.04 with kernel 
>> 2.6.32-22. I love it, but I'm having trouble mounting it through fstab 
>> consistently. How can I set a UUID for an nilfs volume? I've been unable 
>> to do so using any of the linux tools I'm aware of.
>> 
>> --Darien Large
> 
> UUID is set when creating nilfs volume with mkfs.nilfs2 (or mkfs -t
> nilfs2).  But, the current standard mount program does not identify
> the UUID of nilfs partitions.

(I am writing this for Google to find.)

There is an interesting question of whether snapshots (or even checkpoints) should get their own true UUIDs, but it is not necessary to answer that question immediately; it does not fit the current Linux tools well.

One could use /dev/disk/by-id until blkid and other tools like util-linux-ng support nilfs UUIDs.  The UUID will be superior because it is the identity of the filesystem itself.  But for many simple uses, filesystems do not move from one physical medium to another, and the medium's identity then can be used as a way of persistently referring to the filesystem.  udev can probe for serial numbers, and I know the udev rules shipping with Ubuntu have done this for a while.

For example, on an Ubuntu 10.04 server the boot disk in one machine shows up in /dev/disk/by-id:

ata-WDC_WD7500AADS-00L5B1_WD-WCAU4A688888
ata-WDC_WD7500AADS-00L5B1_WD-WCAU4A688888-part1
ata-WDC_WD7500AADS-00L5B1_WD-WCAU4A688888-part2

And because this disk is relatively new, it also has a World Wide Name:

wwn-0x50014ee202e88888
wwn-0x50014ee202e88888-part1
wwn-0x50014ee202e88888-part2

As it happens, that second partition is actually an LVM2 container, which also provides (not so unique) dm names for its contents:

dm-name-fade2sys-root
dm-name-fade2sys-swap

But LVM2 gives dm a real unique identifier for those as well:

dm-uuid-LVM-5y6K2m8AqnUNwE8EZBzQgbgAl4p5wj1s3kb0fwsPc7X4drBv1M2Xog3OlHfiYlYq
dm-uuid-LVM-5y6K2m8AqnUNwE8EZBzQgbgAl4p5wj1sDEfgiabT2qYUpRwWbtqR11MgIl1JRda0

USB mass storage devices get a serial number:

usb-IMC_KanguruDrive2.0_074519340060-0:0
usb-IMC_KanguruDrive2.0_074519340060-0:0-part1

Unfortunately, card readers (like the tiny microSD USB readers) show up under their identity rather than the medium's.  So if you want to keep your home through a card reader device and have it distinguished from other cards, create an LVM2 container on the SD or CF card.  (However, alignment of logical volume blocks with physical flash erase blocks then becomes important, and I have not personally performed this procedure yet.)

Jay

P.S.: I'm not lucky enough to actually have a drive with that many 8s in a row in both the serial number and the WWN, but that's the format.--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
