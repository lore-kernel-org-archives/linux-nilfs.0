From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_cleanerd wont run after 3.7.2 upgrade
Date: Sun, 3 Feb 2013 11:22:22 +0300
Message-ID: <CAFPMYnGUCjiGv2An0r+JcWXLtP7Ro-1mXtWGZqx2xGeXG0sJtQ@mail.gmail.com>
References: <CACc=JvH81x9hUqGmn7b-sYuu0UhQpVBnOCSOjtZfDNhK0s-F8Q@mail.gmail.com>
	<3859090E-3011-4A3A-A15B-0569EFEED0B9@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=QaHb4ygzViJkmlbiwmnC0zZhp5NrT1oOpQNsvRL+OZs=;
        b=MEu4jJh/jKTaR1VnYfh6WABDoYiFm6zWisS7ERdwH14h7iPT5+zx6Awgwcjs2OHuoJ
         ciapF0Hl898DGfML2OB/jMGjtsvgh/ZLEA7cd/ySrWvWpJ7+2IR8JT4/ZAcjPc8ttoVZ
         8ZSfp0nocXtIinmd3t9kprpGUx11Dij+d3u5AzfMk5nLKiGXP255d7Rba53hfe4guXyH
         5PyVCNQBsj2c+iKztCRzLe5ujAlp86uK9OE3xksNWI2Z9UiTmBzRtU/nycRa9Utj2xzX
         rzsNsJ9I5iww8zyEhDrEF8RqW4flSmG8lfI6jOkS9omg21EWTGsmahV+4qEePc5K8WVM
         7Rpg==
In-Reply-To: <3859090E-3011-4A3A-A15B-0569EFEED0B9-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Tim Benham <tim.j.benham-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I've the same issue.
The reason is /dev/root device no longer exists with modern udev (197
at least for gentoo) and the kernel reports /dev/root to be mounted as
root device. So nilfs_cleanerd tries to open it and fails.

The issue only takes place without initramfs, may be that's why it's
not fixed yet.

Possible fixes are:
1) patch kernel to report real device
2) may be there is another way to get proper device name for
nilfs_cleanerd but I doubt
3a) downgrade udev (as a temporary solution)
3b) switch to eudev beta (at least for gentoo)

-----------------------------
Alexandrov Sergey



2013/1/20 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> Hi Tim,
>
> On Jan 20, 2013, at 9:51 AM, Tim Benham wrote:
>
>> After upgrading from the 3.5.0 to the 3.7.2 kernel I cannot get
>> nilfs_cleanerd to start. Trying to start it causes the following lines
>> to be appended to the system log.
>>
>> Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: start
>> Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: cannot open nilfs on
>> (null): No such file or directory
>> Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: cannot create cleanerd
>> on (null): No such file or directory
>> Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: shutdown
>>
>> My root file system is nilfs2. Cleanerd has never started on mount. I
>> worked around this by creating a local.d script that starts it. Then
>> this stopped working. I was able to get it going again by modifying my
>> script to create a /dev/root symlink. Now I cannot get it to start at
>> all. Giving it the root device explicitly doesn't work either
>>
>>
>> # nilfs_cleanerd /dev/sda2
>> Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: start
>> Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: cannot open nilfs on
>> /dev/sda2: No such file or directory
>> Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: cannot create cleanerd
>> on /dev/sda2: No such file or directory
>> Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: shutdown
>> # ls -l /dev/sda2
>> brw-rw---- 1 root disk 8, 2 Jan 20 16:18 /dev/sda2
>>
>> mount -t nilfs2 -o remount /dev/sda2 / produces an identical set of messages.
>
> It looks like you have troubles with udev after upgrade. Could you share strace output of nilfs_cleanerd trying to start? Could you share fstab file content on your system?
>
> With the best regards,
> Vyacheslav Dubeyko.
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
