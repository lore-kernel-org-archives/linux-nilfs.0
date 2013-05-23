From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Thu, 23 May 2013 10:40:57 +0900 (JST)
Message-ID: <20130523.104057.27800870.konishi.ryusuke@lab.ntt.co.jp>
References: <519D2B96.9000106@antoneliasson.se>
	<519D2C32.5040600@antoneliasson.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519D2C32.5040600-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 22 May 2013 22:36:02 +0200, Anton Eliasson wrote:
> Anton Eliasson skrev 2013-05-22 22:33:
>> Greetings!
>> It pains me to report that my /home filesystem broke down today. My
>> system is running Arch Linux 64-bit. The filesystem resides on a
>> Crucial M4 256 GB SSD, on top of a LVM2 volume. The drive and
>> filesystem are both around six months old. Partition table and error
>> log excerpts are at the bottom of this e-mail. Full logs are available
>> upon request.
>>
>> I am providing this information as a bug report. I have no reason to
>> suspect the hardware but I cannot exclude it either. If you (the
>> developers) are interested in troubleshooting this for prosperity, I
>> can be your hands and run whatever tools are required. If not, I'll
>> reformat the filesystem, restore the data from backup and forget that
>> this happened.
>>
>> In case the formatting gets mangled, this e-mail is also available at
> Right here: http://paste.debian.net/5841/

Thank you for the report.

According to the log, btree of a regular file is destroyed for some reason.
I think we should look into how the btree block is broken.

Could you try the following commands to inspect the broken disk segment ?

 $ sudo dd if=/dev/dm-3 bs=4k count=2048 skip=14350336 iflag=direct 2>/dev/null | hexdump -C

This will print out blocks of the segment 7007 which includes the
broken btree block.

The following commands are also useful to get debug information.
Could you try them, too ?

 $ sudo nilfs-tune -l /dev/dm-3
 $ sudo dumpseg /dev/dm-3 7007
 $ lssu -a /dev/dm-3

The third command requires the device is mounted, so /home should be
mounted previously with a readonly option and a norecovery option:

 $ sudo mount -t nilfs2 -o ro,norecovery /dev/dm-3 /home


With regards,
Ryusuke Konishi

> -- 
> Best Regards,
> Anton Eliasson
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
