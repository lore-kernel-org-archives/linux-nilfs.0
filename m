From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Wed, 31 Oct 2012 21:06:43 +0300
Message-ID: <CAFPMYnHyUSEr5jwBNkh43Xpt=VrzgiSCK8LG3Vkf3HcwV9cnMQ@mail.gmail.com>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	<CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
	<1351604965.2069.13.camel@slavad-ubuntu>
	<CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com>
	<1351608774.2026.6.camel@slavad-ubuntu>
	<CAFPMYnGn4aNf=5B9v93TtTc6x4hG1ULgt0P9i75uO=xGX0U2bg@mail.gmail.com>
	<AFFE5823-0AD0-488C-B465-55CF45A10785@dubeyko.com>
	<CAFPMYnEtXMr1UOVYdNNRxxH83=O-_UOR_ZhCdqjh+JuUNrFiDA@mail.gmail.com>
	<1351664002.2105.3.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=sEnZEOm+P8R0K58x3Rh6zXleLS84R+oEs/xg9R+iivM=;
        b=R9vPUvjBOxNHvNaPwjy9nOzYdNls3nt3jUWGD56T9O9AN+0s8ZC8sfoX1eNZ88O+GS
         vC18chcV9VlW16lDI7vAv5yHTblNoXycsHcaF7MI9QPEJseRGV++8EAy8QwildDlyoJ9
         TWU6KC6YFBJ4EF/gEKih8Sa8D86FhwMBrjQXhUXLwER1RTxU8wRWp+O0Xr9J9uZHwhk3
         QLi582UJkD940WrcdGdxAY2Q+koEa7wlluaaBeTRa4i28G51lipZ9wG69evayKOQMwu5
         r36PsiyOhtJ1EB1APue7y1tWk0pW5GePZGw2MXK7TLVX5bDTm50rghGYpX5B3tAmOQAe
         xKyQ==
In-Reply-To: <1351664002.2105.3.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thank you very much for your help, sorry for diverting you from
probably more important and interesting things. May be I'll try to
reproduce the issue later(As a programmer I'm interested in finding
the bug), but (as a user) for now I'm just happy with present
situation.
Thanks for your help again.

>> I really dont'n know, what happened, but I failed to reproduce...
>> The only thing that have changed is version of nilfs-utils. It seems
>> that somewhere between 2.1.1 and 2.1.4 the bug was fixed.
>> Should I try to reprodce the bug with v 2.1.1, or we will consider the
>> question closed?
>>
>
> I think that it makes sense to try to reproduce the issue with 2.1.1
> version. If you can reproduce on 2.1.1 version but on 2.1.4 can't then
> it means that bug was fixed.
>
> But if you are happy without it then don't worry. :-)
>
> With the best regards,
> Vyacheslav Dubeyko.
>
--------------------------------------------------
Aleksandrov Sergey Vasil'evich
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
