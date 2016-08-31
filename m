From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs_cleanerd not running
Date: Wed, 31 Aug 2016 13:27:27 +0900 (JST)
Message-ID: <20160831.132727.240200142837625882.konishi.ryusuke@lab.ntt.co.jp>
References: <2a90bda59a98d4f35e8dbab5534c014e@fripost.org>
        <ef82ce0808205f8ecda06baa9a3f9232@fripost.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3BnprnsvyRssqiP+qype3CIwTt0ecZZzQ2fegiFB/kI=;
        b=AFqZl1x6Ymu0CcoIpWI8hNpVS6427zAMEKgxgJ8mR6ULvpNcP38akTPznq0nTTRL3I
         Y6ubVrvrcR7ciQjvp+Q5EWEE0rCLX9ySAzbNypMg1jgqxlYEilpblsoIUE5BSBWakivU
         0qz8phYHDKFaWsSyLd8GUKD2A74pTmuKxtcC6QzwBJRX3D1k01JuO6wmBmSyb9RM+Zvr
         yb4/JxCB0jPUNRJymQromwCbBkKVpoxQpzJ18S+qPLSAYjHBVjoLMgkpJpsHIeU+DH6j
         d/tt55k8GELLMhds5bnQo+8M5FPwK+MLkjwYpk7nKh3yLnoJb2dV5DmGqenGuS7DZQc2
         sxZg==
In-Reply-To: <ef82ce0808205f8ecda06baa9a3f9232-m2T68/X/qvZAfugRpC6u6w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mikael-m2T68/X/qvZAfugRpC6u6w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 31 Aug 2016 00:28:04 +0200, mikael-m2T68/X/qvZAfugRpC6u6w@public.gmane.org wrote:
> Hi again,
> 
> I am now able to run nilfs_cleanerd after running it as root... :)
> When I am running it with sudo I get below, although I set
> LD_LIBRARY_PATH first:
> 
> nilfs_cleanerd: error while loading shared libraries: libnilfs.so.0:
> cannot open shared object file: No such file or directory
> 
> Maybe sudo starts a new shell and loses the LD_LIBRARY_PATH variable?
> 
> I think it is rather strange and confusing that nilfs_cleanerd says
> 'NILFS_CLEANERD_PID=25215' without being able to start a process
> properly. Is that perhaps a bug?

Seems that libnilfs.so is loaded when its function is used first time.
nilfs_cleanerd first tries to deliver PID to the parent process and
then call a function of libnilfs.  So, this order looks to be natural.

> 
> My problem is still:
> 
> [root@nixos:/home/mikael]# nilfs_cleanerd /dev/mapper/cryptroot
> nilfs_cleanerd: error while loading shared libraries: libnilfs.so.0:
> cannot open shared object file: No such file or directory
> 
> If I set LD_LIBRARY_PATH, I am however able to start nilfs_cleanerd as
> root.
> 
> Any ideas?

Try ldd to investigate library dependency.

 $ ldd /sbin/nilfs_cleanerd

If libnilfs.so is "not found", add the library path
where libnilfs.so exists, to /etc/ld.so.conf or /etc/ld.so.conf.d/*.conf.
And, then run ldconfig.

Usually we don't have to care this kind of task.  It looks like there
is a problem in the NixOS distro package or your system environment.

Regards,
Ryusuke Konishi

> 
> Kind regards,
> 
> Mikael Andersson
> 
> 2016-08-30 22:01 skrev mikael-m2T68/X/qvZAfugRpC6u6w@public.gmane.org:
>> Hi,
>> It seems my NILFS is not garbage collected. The other day I was not
>> able to boot up my NixOS due to a full disk. I booted on a USB stick
>> and ran nilfs-clean which freed about 20 Gbytes. I suppose there
>> should always be a process nilfs_cleanerd running on a system in order
>> to clean up old check points. I have actually not read on the NILFS
>> web site that nilfs_cleanerd should be running normally, but maybe I
>> have missed this. Should it not be running normally?
>> When I am running nilfs-clean on my device, I get:
>> 'No cleaner found on /dev/dm-0.'
>> mount | grep nilfs gives:
>> /dev/mapper/cryptroot on / type nilfs2 (rw,relatime)
>> /dev/mapper/cryptroot on /nix/store type nilfs2 (ro,relatime)
>> nilfs-clean -V gives:
>> nilfs-clean version 2.2.3
>> I am only able to run nilfs_cleanerd after setting LD_LIBRARY_PATH to
>> /nix/store/*-nilfs-utils-2.2.3/lib
>> nilfs_cleanerd /dev/mapper/cryptroot
>> NILFS_CLEANERD_PID=24468
>> It seems however like the process terminates since there does not seem
>> to exist any process when running 'ps aux | grep nilfs'
>> When trying 'sudo mount -t nilfs2 -o remount,pp=1
>> /dev/mapper/cryptroot /', I get:
>> /nix/store/y0ldq0j9qpax23d6g5iww7nz17xgx32q-nilfs-utils-2.2.3/sbin/nilfs_cleanerd:
>> error while loading shared libraries: libnilfs.so.0: cannot open
>> shared object file: No such file or directory
>> mount.nilfs2: Warning: cannot get pid of cleanerd
>> mount.nilfs2: cannot modify /etc/mtab.
>> Please remount the partition with -f option after making /etc/mtab
>> writable.
>> I am running NixOS 16.03
>> 'uname -r' gives:
>> 4.4.14
>> Any ideas?
>> Thanks in advance.
>> Kind regards,
>> Mikael Andersson
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
>> in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
