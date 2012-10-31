From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Wed, 31 Oct 2012 06:51:40 +0300
Message-ID: <CAFPMYnEtXMr1UOVYdNNRxxH83=O-_UOR_ZhCdqjh+JuUNrFiDA@mail.gmail.com>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	<CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
	<1351604965.2069.13.camel@slavad-ubuntu>
	<CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com>
	<1351608774.2026.6.camel@slavad-ubuntu>
	<CAFPMYnGn4aNf=5B9v93TtTc6x4hG1ULgt0P9i75uO=xGX0U2bg@mail.gmail.com>
	<AFFE5823-0AD0-488C-B465-55CF45A10785@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=r6/DFWbDO5SgBm5QGAjpTEcLdROrOdW1DBOlGbK2q+I=;
        b=ZHgdvG/TpajMthHrUHV5ymD6m5yybuxAPbaRNjK6Tmpf33pPllws5BWZSUxN0X9DCy
         Y16riARPMBLMfBGhssKoYOXGe/e+GVvGQy9B48knR7BjYdq0kRMRwH9SMIG2lcc4uUHe
         rHn60VKDmQEkk6C/CzOi3HGPdxMrxVA9nzPPyefYSw3V64gltZJ1dtKs7rRp6kIoIcGe
         BHp4N3xa4gO3TXpCNn+wKChLn1OshGxtI5lkF/Lqy318CDnwTEEkYAJxKXIBMJjFeBHs
         1qC10IIFn31cT6khhG5vAmUWqyJbFWs7dLbUpOSt/GK3V76/+QbQ/R5LVP/enoIM8+9W
         6ZmQ==
In-Reply-To: <AFFE5823-0AD0-488C-B465-55CF45A10785-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>>> Could you try to reproduce the issue with log_priority enhanced to debug
>>> level (I mean option in nilfs_cleanerd.conf) and share messages log
>>> again?
>>
>> I can, but a bit later, if you don''t mind(in 24 hours).
>>
>
> Please, try to mount with using "strace". The output of "strace" can be useful. Please, share it after trying.

I really dont'n know, what happened, but I failed to reproduce...
The only thing that have changed is version of nilfs-utils. It seems
that somewhere between 2.1.1 and 2.1.4 the bug was fixed.
Should I try to reprodce the bug with v 2.1.1, or we will consider the
question closed?

--------------------------------------------------
Aleksandrov Sergey Vasil'evich
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
