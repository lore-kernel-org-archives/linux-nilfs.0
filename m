From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS 2.0.19 and NILFS utils 2.0.16 released
Date: Sat, 13 Mar 2010 19:43:06 +0900
Message-ID: <c4a7c9421003130243o1c13063fs2086c68fa7a1c959@mail.gmail.com>
References: <20100313.150612.265919879.ryusuke@osrg.net>
	 <87zl2cfy0y.wl%jir@sekiba.com>
	 <20100313.175905.52160307.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:sender:received:in-reply-to
         :references:date:x-google-sender-auth:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        bh=WJxPtyWUYELQN8V13wik9USok/TsfvYVfUP5wC4qW+0=;
        b=PeqUXDA/y5X7LINDclJh+HPr3VmQ8kVDrDCmXuH2I6fh5+PWNqQLsfvwW87DWidO/F
         1FttcaodxuG5vEbRpT/+2rQERU/tgwVMUqrE7d1my0kFH+tA795Lio9KIAn71CygWmMz
         oLzNpddk1g0spShwHSxEK6X5fXy8phMfZmr50=
In-Reply-To: <20100313.175905.52160307.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2010/3/13 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> On Sat, 13 Mar 2010 17:04:13 +0900, Jiro SEKIBA wrote:
>> Hi,
>>
>> At Sat, 13 Mar 2010 15:06:12 +0900 (JST),
>> Ryusuke Konishi wrote:
>> >
>> > Hi,
>> >
>> > I have released nilfs-2.0.19 and nilfs-utils-2.0.16.
>>
>> I found that COPYING of nilfs-utils is now GPL v3.
>> I've checked older version. =A0Until 2.0.14, it was GPL v2,
>> however it upgraded to v3 in 2.0.15.
>>
>> It looks like there is no COPYING file in the git repository.
>> Therefore, I guess, =A0it was automatically copied by automake
>> when creating tarball.
>>
>> Or is it indented to be GPL v3 now?
>
> Ahhh, that is an accident.
>
> Ok, I will add a COPYING file to resolve this problem.

Done.

I made another util release (nilfs-utils-2.0.17).

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
