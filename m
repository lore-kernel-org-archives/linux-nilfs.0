From: Jan Misiak <fijam7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel panic (2.6.36) after file system corruption (?)
Date: Sun, 19 Dec 2010 13:04:23 +0100
Message-ID: <AANLkTika7SunjtX+eMq=22L97T=dHBs0_GFdL8KbKwQ3@mail.gmail.com>
References: <AANLkTim3dU2mZMr-BVP0JmSoD9y-UtGT=NTTLmSgiYsU@mail.gmail.com> <20101219.141304.213200153.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:mime-version:received:in-reply-to
         :references:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        bh=Mh08ajwp1Kt9XBjpNcbxR8rw44xriVYBo7MFK/CiNok=;
        b=jZftzb7dpSmhGwGczEn67LvTU9yUPhNg5fnk9bfK8Xjd2n1XxlAXwXigVlpuJ4oNU5
         q9SjUdHrYSTQB9aDNH3NhPaKDu2vu6dW/5xg/ihO4vY4vVGF0mmp/Eg4Pt9TziqTjcCv
         wGmrPXJUpbXqOXWGTT6bCJfgBE7EneOqLLOlQ=
In-Reply-To: <20101219.141304.213200153.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 19 December 2010 06:13, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> Hi,
> On Sat, 18 Dec 2010 15:08:45 +0100, Jan Misiak wrote:
>> Hello,
>>
>> I am just a simple end-user but as nobody in my distribution has had
>> the same problem I was forced to turn to the upstream. Please bear
>> with me.
>>
>> I have been using nilfs2 on a 16GB usb-stick on a x86 thin client
>> running Arch Linux. The box had been running 24/7 and had an uptime =
of
>> about two weeks with kernel 2.6.36/nilfs-utils 2.0.20 when it
>> panicked. Unfortunately nothing was to be seen in the logs (system
>> partition was ext3). Now it panics every time I attempt to mount the
>> volume.
>>
>> I tried to use netconsole to capture the panic message but it gets
>> truncated so I had to resort to taking pictures.
>>
>> box #1 kernel 2.6.36.2/nilfs-utlis 2.0.20
>> =C2=A0 =C2=A0 http://fijam.eu.org/other/netconsole.log
>> =C2=A0 =C2=A0 http://fijam.eu.org/other/0000.jpg
>>
>> I tried to mount the usb-stick on a laptop with the same kernel
>> (2.6.36.2) to capture more of the panic messages:
>>
>> box #2 kernel 2.6.36.2/nilfs-utlis 2.0.20
>> =C2=A0 =C2=A0 http://fijam.eu.org/other/0001.jpeg
>> =C2=A0 =C2=A0 http://fijam.eu.org/other/0002.jpeg
>>
>> It crashes when I try to mount with kernel 2.6.32.27 as well:
>>
>> box #2 kernel 2.6.32.27/nilfs-utlis 2.0.20
>> =C2=A0 =C2=A0 http://fijam.eu.org/other/0003.jpeg
>> =C2=A0 =C2=A0 http://fijam.eu.org/other/0004.jpeg
>>
>> I would be grateful for advice on how can I help with getting to the
>> bottom of this.
>>
>> Regards,
>> Jan
>
> It looks like these oopses were hit in the common block layer code
> called from the usb mass storage driver.
>
> Could you do some tests to narrow down the issue ?
>
> =C2=A01) Use "nogc" mount option to see whether the oops depends on t=
he
> =C2=A0 =C2=A0context of garbage collection or not:
>
> =C2=A0 # mount -t nilfs2 -o nogc /dev/sdb1 /your-mount-dir
>
> =C2=A02) Mount the partition read-only with "norecovery" option and m=
ake
> =C2=A0 =C2=A0read accesses to the filesystem as below:
>
> =C2=A0 # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
> =C2=A0 # find /your-mount-dir -type f -exec cat {} > /dev/null \;
>
> =C2=A03) Try to read the block device directly with "dd":
>
> =C2=A0 # dd if=3D/dev/sdb1 bs=3D4k > /dev/null
>
> =C2=A04) Try lssu and lscp commands in the read-only mount to do quic=
k
> =C2=A0 =C2=A0sanity checks of meta data files.
>
> =C2=A0 # mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
> =C2=A0 # lssu -a
> =C2=A0 # lscp
>
>
> Regards,
> Ryusuke Konishi
>

Thank you for your reply and suggestions. I have tried the following:

# mount -t nilfs2 -o nogc /dev/sdb1 /your-mount-dir
    Results in exactly the same kernel panic.

# mount -t nilfs2 -o ro,norecovery /dev/sdb1 /your-mount-dir
# find /your-mount-dir -type f -exec cat {} > /dev/null \;
    Doesn't trigger the oops. I was able to retrieve my data but
haven't checked them for correctness yet.

# lssu -a
    http://fijam.eu.org/other/lssu
# lscp
    http://fijam.eu.org/other/lscp

# dd if=3D/dev/sdb1 bs=3D4k > /dev/null
    Likewise, it doesn't trigger the oops.

Is there anything else I could do to help?

Regards,
Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
