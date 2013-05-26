From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Sun, 26 May 2013 16:54:34 +0400
Message-ID: <5C805A19-6CAA-4602-9ECB-A1E87D8A650B@dubeyko.com>
References: <519D2B96.9000106@antoneliasson.se> <1369291449.2673.15.camel@slavad-ubuntu> <51A0A7A0.6010207@antoneliasson.se> <51A0E62D.5060600@antoneliasson.se>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=n4FpFsLjNw0cUL0Rjc0PsSZG6/UbwJ1tO4eMw9AmPPo=;
	b=kGDyJHCN2IxDrA/Z3760sUBuLrOQQs0A06IDmDEqaUOutM+zqKKDpjAZqOoke0d1MOB6NCgCOG2KrfEa0UaIm8N3RWAQAp0i85wsnUKd376vcJp/RfPG+etZ4e4QVHOI;
In-Reply-To: <51A0E62D.5060600-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anton,

On May 25, 2013, at 8:26 PM, Anton Eliasson wrote:

> Anton Eliasson skrev 2013-05-25 13:59:
> [...]
>>>> ~20:00
>>>> ======
>>>> When I came back, bup hade frozen (/var/log/messages at 18:53:31).[1] I
>>>> restart X by pressing Alt+SysRq+K (/var/log/messages at 20:06:33) and
>>>> return to the login screen. The system freezes during login though,
>>>> probably because /home had probably been mounted read only). So I reboot
>>>> using Alt+SysRq+REISUB (/var/log/messages at 20:07:05). I noticed some
>>>> I/O errors during shutdown.
>>>> 
>>>> After the reboot there are no immediate signs of disaster. I launch bup
>>>> again. Some time later, /home remounts as read only. I notice that bup
>>>> has reported I/O errors while reading some files in /home.[2] dmesg and
>>>> /var/log/kern.log contains errors mentioning "bad btree node" and
>>>> "nilfs_bmap_lookup_contig: broken bmap".[3]
>>>> 
>>> Now we have patch for overcome the freezing of system after such issue:
>>> http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01614.html.
>> That is good. I shall await the next release with great anticipation.
> I don't think the bug described in the patch you linked to is responsible for my crashes. Check this out:
> 

I didn't state that this patch solves your issue. I meant that after remount in RO mode the NILFS2 driver still has dirty
pages for the case of issue. This patch solves the issue of infinite trying of flushing these dirty pages by kernel
flush thread. The infinite trying to flush dirty pages can result in system freezing, as I understand.

[snip]

> No remounts, just a kernel oops. I can reproduce this without fail by booting a VMware Workstation (9.0.2) virtual machine that resides on the nilfs /home volume while another virtual machine is doing something IO-intensive.
> 

Sorry, I am confused slightly by different descriptions of the issue in your e-mails. Initially, I have understanding
that, first of all, you have issue with remount in RO mode. But now you are talking about crash without remount.

Could you share full system log that you have for the issue case?

I need to understand a sequence of events. Maybe, you have two issues instead of one. Currently, I haven't
clear picture of the issue's environment.

Thanks,
Vyacheslav Dubeyko.

> More specifically, I have a virtual machine running Windows XP in /home, a nilfs filesystem, and a virtual machine running Windows 7 in /Supplement. /Supplement is an ext4 volume in the same LVM volume group as /home on the same slow hard drive. I can crash the host by either:
> 
> * Starting both machines at the same time.
> * Starting the W7 machine first and when it is fully booted to the desktop, but still doing I/O intensive Windows stuff, starting the WXP machine.
> 
> If I first start the WXP machine and let it boot to the desktop, at the point where it is actually I/O idle, I can safely start the W7 machine. After that I found no trouble installing software updates and logging in and out of both machines at the same time, though the HDD made it very slow of course.
> 
> After the host had crashed, I could still list and read files in /home but as soon as I attempted to `touch` a file, that terminal froze. Any terminal that attempted to read a file after that point froze as well and there was nothing left to do but to Alt+SysRq+B.
> 
> -- 
> Best Regards,
> Anton Eliasson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
