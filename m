From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] TimeBrowse: add missing exclamation mark in the first line
Date: Sat, 5 Feb 2011 17:14:18 +0900
Message-ID: <AANLkTim3gVnEVR2reyuZQky=AW2gHx75Cc8a0mDPQ89g@mail.gmail.com>
References: <1296892003-23000-1-git-send-email-ryusuke@osrg.net>
	<87r5bm7w51.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=we23i4TOMBhkHOAxFVWtHa16dIXSNHeBpgM2qsaFJtk=;
        b=F6Z0ZgVnOy3PdO29M3F0/PTDfnFv6chKlsgKLG1myeqEk+lFVqhFypeEUqDxRYajmw
         kx1hm5Fqvn9Iv5qHUeahAYN4mwsDMsoDCDkVk/BW1iasCNmQ5kyxlLaWnuwsiMWmLIo0
         L71qZwaldlCUbwyWHNHpqFTaPBC9/5yhCkEsM=
In-Reply-To: <87r5bm7w51.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

By the way,  you can append your sob line to the commits
with "git am -s <patch>".

Cheers,
Ryusuke Konishi

2011/2/5 Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>:
> applied
>
> thank you
> --
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
>
> At Sat, =A05 Feb 2011 16:46:43 +0900,
> Ryusuke Konishi wrote:
>>
>> Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
>> ---
>> =A0nautilus/TimeBrowse.py | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/nautilus/TimeBrowse.py b/nautilus/TimeBrowse.py
>> index fd8c478..ad59b35 100644
>> --- a/nautilus/TimeBrowse.py
>> +++ b/nautilus/TimeBrowse.py
>> @@ -1,4 +1,4 @@
>> -#/usr/bin/env python
>> +#!/usr/bin/env python
>> =A0#
>> =A0# =A0copyright(c) 2011 - Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
>> =A0#
>> --
>> 1.7.2.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilf=
s" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Ryusuke KONISHI <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
