From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [systemd-devel] nilfs-cleanerd startup on boot
Date: Wed, 04 Mar 2015 12:45:12 +0900
Message-ID: <54F67FC8.40003@lab.ntt.co.jp>
References: <SIXPR03MB461887A763AD9ADA7B79841ED150@SIXPR03MB461.apcprd03.prod.outlook.com> <20150228183348.GA8274@gardel-login> <HKNPR03MB452F1AE0C164650CE0CCCA4ED110@HKNPR03MB452.apcprd03.prod.outlook.com> <54F64F48.80403@lab.ntt.co.jp> <SIXPR03MB461D49AB19D08CF73F05760ED1E0@SIXPR03MB461.apcprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SIXPR03MB461D49AB19D08CF73F05760ED1E0-vZpGLg/9lRlECMeiuiIiL+O6mTEJWrR4XA4E9RH9d+qIuWR1G4zioA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: dennis.murata-uxC5H9eHYlcAvxtiuMwx3w@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org
Cc: systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2015/03/04 10:11, dennis.murata-uxC5H9eHYlcAvxtiuMwx3w@public.gmane.org wrote:
>
>> -----Original Message-----
>> From: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nilfs-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ryusuke Konishi
>> Sent: Tuesday, March 03, 2015 6:18 PM
>> To: Dennis Murata (WT01 - ENU); lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org
>> Cc: systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org; linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: [systemd-devel] nilfs-cleanerd startup on boot
>>
>> Hi
>>
>> On 2015/03/04 0:44, dennis.murata-uxC5H9eHYlcAvxtiuMwx3w@public.gmane.org wrote:
>>> I had mis-typed the address for the nilfs mail group
>>>
>>>> -----Original Message-----
>>>> From: Lennart Poettering [mailto:lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org]
>>>> Sent: Saturday, February 28, 2015 12:34 PM
>>>> To: Dennis Murata (WT01 - ENU)
>>>> Cc: systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org; linus-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> Subject: Re: [systemd-devel] nilfs-cleanerd startup on boot
>>>>
>>>> On Fri, 27.02.15 18:31, dennis.murata-uxC5H9eHYlcAvxtiuMwx3w@public.gmane.org
>>>> (dennis.murata-uxC5H9eHYlcAvxtiuMwx3w@public.gmane.org) wrote:
>>>>
>>>>> I have a fedora 21 system that where I mount an nilfs2 file system.
>>>>> I use a simple /etc/modules-load.d/nilfs.conf file to load the
>>>>> kernel module and have an entry in the fstab.
>>>>
>>>> Creating the modules-load.d snippet should not be necessary, as the
>>>> kernel should autoload the kernel module for it when it is first required.
>>> I did not find this to be the case for fedora 21.
>>   > Without creating the file to load the module, any attempt I made to mount
>>> the file system would get a unknown filetype error.  Does this point at  >
>> adding this module to the initrd file?
>>
>> Is "nilfs2.ko" installed in your environment?
> I had to add the kernel-modules-extra package that you list below.  This is probably why I also had to add the file in modules-load.d to get this module loaded
>>
>> Try "modinfo nilfs2"
>>
>> Older fedora needed kernel-modules-extra package. [1]
>>
>> [1] http://nilfs.sourceforge.net/en/pkg_fedora.html
>>
>>>>> The file system mounts on boot as it should, but the nilfs-cleanerd
>>>>> program does not startup.  If I umount /nilfs then mount /nilfs the
>>>>> nilfs-cleanerd program starts as it should to cleanup the checkpoints.
>>>>
>>>> How is that daemon supposed to be started? Is it forked off /bin/mount?
>>>>
>>>>> Does systemd use a different mount program at boot?
>>>>
>>>> It uses /bin/mount for mounting normal file systems.
>>
>> nilfs_cleanerd is invoked through /sbin/mount.nilfs2 helper. [2] The helper is
>> called from /sbin/mount if it exists.
>
> What is confusing to me, is an umount then a mount will start the nilfs_cleanerd process so it does exist on the system.  I had expected it to be started as soon as the file system was mounted the first time.

Curious.  Is /sbin/mount.nilfs2 called in the first mount?

If mount.nilfs2 is unavailable at the early stage, the next best way
is to use rw-remount (i.e. mount -t nilfs2 -o rw,remount <device>
<directory>).  It would also run cleanerd instead of umount && mount.

Regards,
Ryusuke Konishi

>>
>> /sbin/mount.nilfs2 is included in nilfs-utils package.
>>
>> nilfs_cleanerd is just a user-land process, so it can be manually invoked if you
>> have root privilege. [3]
>>
>>     # /sbin/nilfs_cleanerd <device> <directory>
>>
>> But, in this case, you need to kill nilfs_cleanerd manually before umount.  So, I
>> recommend running cleanerd through mount.nilfs2.
>>
>> The above explanation may not suit for the recent fedora since nilfs-utils is not
>> yet tuned to systemd environment.
>>
>> [2] http://nilfs.sourceforge.net/en/man8/mount.nilfs2.8.html
>> [3] http://nilfs.sourceforge.net/en/man8/nilfs_cleanerd.8.html
>>
>> Regards,
>> Ryusuke Konishi
>>
>>>>> Is there something else that should be included other than the
>>>>> nilfs.conf file?  I have just started using a system with systemd as
>>>>> the init so please forgive my ignorance.
>>>>
>>>> I have no idea about nilfs really, and we had no reports about any
>>>> problems with it before.
>>> I wanted to look at the performance of nilfs and f2fs.
>>   > This is my first try at using these file systems
>>>>
>>>> Lennart
>>>>
>>>> --
>>>> Lennart Poettering, Red Hat
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
>>> info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in the body
>> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
