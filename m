From: Zavi <zavi05-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Initial mount fails
Date: Sun, 4 Dec 2011 20:01:25 +0200
Message-ID: <CAN67vW2C3d5Byinib97otyCk9rujPhLSOmLXkC01juHo6e=nVA@mail.gmail.com>
References: <CAN67vW1TR8g=LBH6p+G4yj8UL9wCmjLghGJJOB3zzQjD-tC-Ug@mail.gmail.com>
 <20111204.222908.193237875.ryusuke@osrg.net> <CAN67vW2nSDWfESF1o2umuqduJY-MKL1da0oboDy04tyT4FEL5g@mail.gmail.com>
 <20111205.021311.06955058.ryusuke@osrg.net>
Reply-To: zavi05-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        bh=9E5DJqbuqDm+ekmm4MkjYzPt5cBIsLDs+BBvaUg5LFA=;
        b=GvPIhUZmBZ1YGHIyYC77gfJ6z0kXuxxJP3G6/YB4WSpNanKaHVRZDcLb706iVA1/9n
         xnhIaA4NlMniC1s4DKGmMjoXI01IHNLLfxUMh58CXcxeF852b2VNWY9FIbZyNYXECqZL
         n0EkJdnVGRIb+MwLH3rzvgcPatPxVkAlfRqOc=
In-Reply-To: <20111205.021311.06955058.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Here's the result

> sudo nilfs-tune -l /dev/sdc
nilfs-tune 2.1.0-rc1
/dev/sdc: cannot open NILFS


On Sun, Dec 4, 2011 at 7:13 PM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> On Sun, 4 Dec 2011 18:38:58 +0200, Zavi wrote:
>> Thank you Ryusuke for the quick reply
>>
>> Of course dmesg is the first thing I looked at.
>> All I see is a not very informative message
>> > NILFS: Can't find nilfs on dev sdc.
>>
>
> This message is printed when no super blocks are found on the device.
> Does nilfs-tune command work for the partition ?
>
> =A0$ sudo nilfs-tune -l /dev/sdc
>
> It tries to read super block, and displays file system information if
> a valid super block was found.
>
> Regards,
> Ryusuke Konishi
>
>> On Sun, Dec 4, 2011 at 3:29 PM, Ryusuke Konishi
>> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>> > Hi,
>> > On Sun, 4 Dec 2011 11:10:12 +0200, Zavi wrote:
>> >> Hi all,
>> >>
>> >> I'm trying yo mount nilfs on a device without success.
>> >> mkfs works just fine, but when I try to mount I keep getting an e=
rror
>> >> > sudo mkfs -t nilfs2 /dev/sdc
>> >> > sudo mount -t nilfs2 /dev/sdc ~/nilfs
>> >> mount.nilfs2: Error while mounting /dev/sdc on ~/nilfs: Invalid a=
rgument
>> >>
>> >
>> > Were there any related messages in logs? =A0Please try dmesg comma=
nd or
>> > make sure system logs:
>> >
>> > =A0$ dmesg
>> >
>> > =A0or
>> >
>> > =A0$ sudo cat /var/log/{messages,syslog}
>> >
>> > Regards,
>> > Ryusuke Konishi
>> >
>> >> I've installed nilfs-utils, and this is what I get from fsck
>> >> > sudo fsck0.nilfs2 -f -v /dev/sdc
>> >> fsck0.nilfs2: cannot read super block (device=3D/dev/sdc)
>> >>
>> >> just to be sure the problem is not in the device, I mounted ext4 =
on it
>> >> successfuly.
>> >> I can also do block requests (dd, iometer) without a problem.
>> >>
>> >> I'd appreciate any suggestion.
>> >>
>> >> Thanks,
>> >> Zavi
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-n=
ilfs" in
>> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
