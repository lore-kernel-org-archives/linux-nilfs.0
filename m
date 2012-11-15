From: =?KOI8-R?B?88XSx8XKIOHMxcvTwc7E0s/X?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Thu, 15 Nov 2012 07:07:38 +0300
Message-ID: <CAFPMYnE2j0DjiqcSuJRiJX5hfDjHoyh-WUhG0cMav9K=tbsLDQ@mail.gmail.com>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	<CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
	<1351604965.2069.13.camel@slavad-ubuntu>
	<CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com>
	<1351608774.2026.6.camel@slavad-ubuntu>
	<CAFPMYnGn4aNf=5B9v93TtTc6x4hG1ULgt0P9i75uO=xGX0U2bg@mail.gmail.com>
	<AFFE5823-0AD0-488C-B465-55CF45A10785@dubeyko.com>
	<CAFPMYnEtXMr1UOVYdNNRxxH83=O-_UOR_ZhCdqjh+JuUNrFiDA@mail.gmail.com>
	<1351664002.2105.3.camel@slavad-ubuntu>
	<CAFPMYnHyUSEr5jwBNkh43Xpt=VrzgiSCK8LG3Vkf3HcwV9cnMQ@mail.gmail.com>
	<CAFPMYnHB=x2y3C-bVSEcaT2nMYn12zc5Jnr56ph31zBbym4Kfw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=G3hnaCw2VrM2hOZFmf3SjlV4l2cjWaQQpdumGiNYo34=;
        b=m2gSxdksuP3y/tqx3cqCGIp5JSoX9KBJlik2uwZMLkbP8/yU/d3Tr91MBdSazZjDbF
         OW/PvmJBq9vgUutqk+xH8QVdR4DzJAhZOvNOENYGbGbGsJIp8l+pztwSxfZkRJpgucOr
         MupfK8f/AeUtTOpkOHQslyaqLtk5sAmoieU+HRoGDCKZb2xibiZs2SPaqo7tv3sZrf8f
         144TyMfMWrsrlKMvKNTodyvDggyvlUWEvUIFUaNgFBybNVd5WQkMwgVZqs47S+bKD5Ka
         YdjLLqbkwG8fSaenx+E+6UbzoTg4pv65PUC8i3F46y5jAvas3L/AF3quxi2yh2QY98G1
         Cg/g==
In-Reply-To: <CAFPMYnHB=x2y3C-bVSEcaT2nMYn12zc5Jnr56ph31zBbym4Kfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
The bug appeared again. And apparently it's a kernel one.
My bad that I didn't notice that the CPU activity wals in kernel space.
The mount process hangs inside mount call itself. I've an strace
output, but it's not informative, it perfectly normal besides the hang
in mount call.
I've a very few experience in catching kernel bugs like that, but I'll
do my best to help.


According to my observations, the bug takes place only after emergency
power down after a rather long uptime, may be even the time it takes
to mount the partition is proportional to ether uptime or the amount
of io since last mount.

I left FS unclean, so it is possible to do some tests, but I would
like to see it up and running as soon as possible.


Best regards,
Aleksandrov Sergey Vasil'evich
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
