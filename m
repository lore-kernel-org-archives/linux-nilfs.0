From: Zavi <zavi05-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Initial mount fails
Date: Mon, 5 Dec 2011 10:56:17 +0200
Message-ID: <CAN67vW31R1nVUVwiRwT8UC3kCvy8ySYOyTSpYaKVwqdgWQgBkg@mail.gmail.com>
References: <CAN67vW2nSDWfESF1o2umuqduJY-MKL1da0oboDy04tyT4FEL5g@mail.gmail.com>
 <20111205.021311.06955058.ryusuke@osrg.net> <CAN67vW2C3d5Byinib97otyCk9rujPhLSOmLXkC01juHo6e=nVA@mail.gmail.com>
 <20111205.132326.69345131.ryusuke@osrg.net>
Reply-To: zavi05-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        bh=VICQUOlkeKmRlOe1syAL39OG5wICWlw4XQz9vYngL5Q=;
        b=e+whCaNblgD4BtuYW+j6rdJ/r1Xvi9SyHH1Q5WqrOXQ4Ly0rtcnPYN8lvbNu1W2m/T
         axnPX4nV49al1YjrxVdUT+p3L/Xc23RlgcFbERvRUgIv1UtfmcxwpQUtedtzENqxaeIu
         QON2qDHh8j/O7p5iM+xIbvMWlGTHOLMAI63As=
In-Reply-To: <20111205.132326.69345131.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

That did it!
Although the messages I get now after mkfs are different than before.
But the bottom line is that the file system can be mounter now

Thanks a lot.

On Mon, Dec 5, 2011 at 6:23 AM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> Hi,
> On Sun, 4 Dec 2011 20:01:25 +0200, Zavi wrote:
>> Here's the result
>>
>> > sudo nilfs-tune -l /dev/sdc
>> nilfs-tune 2.1.0-rc1
>> /dev/sdc: cannot open NILFS
>
> Hmm, seems like super blocks are not written to disk.
>
> Does the following option ('-K' option) affect the results ?
>
> =A0$ sudo mkfs -t nilfs2 -v -K /dev/sdc
> =A0$ sudo nilfs-tune -l /dev/sdc
>
> This option stops issuing discard command to disk just before writing
> new super blocks.
>
> Regards,
> Ryusuke Konishi
>
>> On Sun, Dec 4, 2011 at 7:13 PM, Ryusuke Konishi
>> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>> > On Sun, 4 Dec 2011 18:38:58 +0200, Zavi wrote:
>> >> Thank you Ryusuke for the quick reply
>> >>
>> >> Of course dmesg is the first thing I looked at.
>> >> All I see is a not very informative message
>> >> > NILFS: Can't find nilfs on dev sdc.
>> >>
>> >
>> > This message is printed when no super blocks are found on the devi=
ce.
>> > Does nilfs-tune command work for the partition ?
>> >
>> > =A0$ sudo nilfs-tune -l /dev/sdc
>> >
>> > It tries to read super block, and displays file system information=
 if
>> > a valid super block was found.
>> >
>> > Regards,
>> > Ryusuke Konishi
>> >
>> >> On Sun, Dec 4, 2011 at 3:29 PM, Ryusuke Konishi
>> >> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>> >> > Hi,
>> >> > On Sun, 4 Dec 2011 11:10:12 +0200, Zavi wrote:
>> >> >> Hi all,
>> >> >>
>> >> >> I'm trying yo mount nilfs on a device without success.
>> >> >> mkfs works just fine, but when I try to mount I keep getting a=
n error
>> >> >> > sudo mkfs -t nilfs2 /dev/sdc
>> >> >> > sudo mount -t nilfs2 /dev/sdc ~/nilfs
>> >> >> mount.nilfs2: Error while mounting /dev/sdc on ~/nilfs: Invali=
d argument
>> >> >>
>> >> >
>> >> > Were there any related messages in logs? =A0Please try dmesg co=
mmand or
>> >> > make sure system logs:
>> >> >
>> >> > =A0$ dmesg
>> >> >
>> >> > =A0or
>> >> >
>> >> > =A0$ sudo cat /var/log/{messages,syslog}
>> >> >
>> >> > Regards,
>> >> > Ryusuke Konishi
>> >> >
>> >> >> I've installed nilfs-utils, and this is what I get from fsck
>> >> >> > sudo fsck0.nilfs2 -f -v /dev/sdc
>> >> >> fsck0.nilfs2: cannot read super block (device=3D/dev/sdc)
>> >> >>
>> >> >> just to be sure the problem is not in the device, I mounted ex=
t4 on it
>> >> >> successfuly.
>> >> >> I can also do block requests (dd, iometer) without a problem.
>> >> >>
>> >> >> I'd appreciate any suggestion.
>> >> >>
>> >> >> Thanks,
>> >> >> Zavi
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linu=
x-nilfs" in
>> >> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> >> More majordomo info at =A0http://vger.kernel.org/majordomo-inf=
o.html
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
