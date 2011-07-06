From: "LinuxBSDos.com" <finid-aEpbUQpJQqXlKS8GlytQkw@public.gmane.org>
Subject: Re: Recommended partition scheme for nilfs2
Date: Wed, 6 Jul 2011 06:29:53 -0600
Message-ID: <59b61d7de047661eb7c2a1cf42df08f1.squirrel@linuxbsdos.com>
References: <4c09eb01174eecf704c751d7bf1b4bb2.squirrel@linuxbsdos.com>
    <20110706.133558.186520806.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110706.133558.186520806.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Thank you.

With regards to /home, will there be a negative impact on the way nilfs2
works if /home is on a separate partition?

On Ubuntu and nilfs2, Ubuntu's installer does not have nilfs2 as a file
system option, how did you install Natty N. on nilfs2?

I know these are not dev-related questions, but I'm planning on writing
several nilfs2-related tutorials, and need to know exactly how a disk
should be partitioned for it.

Thanks,


--
Fini D.



> Hi,
> On Mon, 4 Jul 2011 13:28:39 -0600, "LinuxBSDos.com" wrote:
>>
>> Hi,
>>
>> A couple of Linux distributions now have nilfs2 as an optional file
>> system
>> during installation and I just want to find out what the minimum number
>> of
>> partitions required for a nilfs2-based installation is.
>>
>> Is it necessary to create separate partitions for the major file
>> systems,
>> or does nilfs2 require just one root file system directory? Is /home on
>> a
>> separate partition necessary?
>
> nilfs2 can be used as a root filesystem and it is bootable from recent
> grub2.  I'm using nilfs2 for the root filesystem on my ubuntu-natty
> laptop.
>
> One restriction is that nilfs2 does not support swap file, so users
> need at least two partitions, swap and root.
>
> /home is not necessary to be a separate partition.
>
>> Lastly, can I encrypt a nilfs2 partition?
>
> nilfs2 itself does not support encryption.  Instead, it can be used
> together with ecryptfs or dm-crypt.
>
> Thanks,
> Ryusuke Konishi
>
>> Thanks,
>>
>> --
>> Fini D.
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
