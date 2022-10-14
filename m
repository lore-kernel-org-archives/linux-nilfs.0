From: Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: git://github -> https://github.com for konis
Date: Thu, 13 Oct 2022 20:51:17 -0700 (PDT)
Message-ID: <mhng-1ec448c6-70ad-4964-9dd0-032892bfb2ef@palmer-ri-x1c9a>
References: <CAKFNMonU3aVqwRdxyFefBJMg0-XC9j8bE-qYZ-9xx-4--NdkGg@mail.gmail.com>
Mime-Version: 1.0 (MHng)
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xj6EA9Cf8G1V5kTfX084ZFL0HswwaRXsbxfz8fvUzdM=;
        b=EmENXU//I1HHcNUunkI3Nuy/Lst7i/3szR10j2QqD9QUaz/zaxjc6gMJPzkEvRVSXz
         RvEx64dqOngIB0pCZGpVsYdGLkNngiqc/dU6a+AuL5mseSoG8zQad2HS7ZLB3TJ5+v6K
         2pSOaNfvKHEI/b02Yiaj++xzqAJ3C/teg8I2g76lxRiTVjupi42/SBVYnPHlW80gtDIS
         yK4jKf7x9bY5aLFABs8AeC1mOqhcHA9qWCB3nF4irs+2HRsAGQmWQYu882I9IN6swonx
         qxhdWDU8P+9WlnGEBWMHWMNQEKLsNlJRT18Nl/QiYe9vnZ7tnvXiXVtr3pnhtshA3+Jx
         o5Vg==
In-Reply-To: <CAKFNMonU3aVqwRdxyFefBJMg0-XC9j8bE-qYZ-9xx-4--NdkGg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Conor Dooley <conor.dooley-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>

On Thu, 13 Oct 2022 16:06:43 PDT (-0700), konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> On Fri, Oct 14, 2022 at 6:49 AM Palmer Dabbelt wrote:
>>
>> Github deprecated the git:// links about a year ago, so let's move to
>> the https:// URLs instead.
>>
>> Reported-by: Conor Dooley <conor.dooley-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
>> Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
>> Signed-off-by: Palmer Dabbelt <palmer-bl1M7uvjFoxWk0Htik3J/w@public.gmane.org>
>> ---
>> I've split these up by github username so folks can take them
>> independently, as some of these repos have been renamed at github and
>> thus need more than just a sed to fix them.
>> ---
>>  MAINTAINERS | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index d118acdce8b8..c9c396e2d8a0 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -14363,7 +14363,7 @@ L:      linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>  S:     Supported
>>  W:     https://nilfs.sourceforge.io/
>>  W:     https://nilfs.osdn.jp/
>> -T:     git git://github.com/konis/nilfs2.git
>> +T:     git https://github.com/konis/nilfs2.git
>>  F:     Documentation/filesystems/nilfs2.rst
>>  F:     fs/nilfs2/
>>  F:     include/trace/events/nilfs2.h
>> --
>> 2.38.0
>>
>
> Ah, that's right, it needs to be fixed.
>
> I'll pick this up unless it's decided to apply similar fixes all at once.
> Thank you.

It's easier on my end if you just pick it up.  Just note the 
"git://github -> https://github.com" typo.  I can send a v2 if you want, 
but IMO it's trival enough to just fix up.

Thanks!

>
> Ryusuke Konishi
