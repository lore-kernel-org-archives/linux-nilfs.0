From: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fw:Re: [PATCH] fs: nilfs2: fix memory leak in nilfs sysfs create
 device group
Date: Sat, 12 Mar 2022 18:16:09 +0300
Message-ID: <7da316f4-aa65-896e-9020-2dfff2bbfc09@gmail.com>
References: <3192BC90-D082-472B-B310-6E09A14A77C6@hust.edu.cn>
 <CAD-N9QUqfq+0UeMjQALUmGpX5xgjS6=BXvsqcXQpJRzhB6hHLw@mail.gmail.com>
 <CAKFNMokdB+Zph-1OyC1-Xnyi93r+yKSusgaEaa=CkuUBttwRZA@mail.gmail.com>
 <CAD-N9QU8-Od3G+-=RHM5K7vR2-4Af+4t=XutJJVdmkKhH7OarA@mail.gmail.com>
 <CAKFNMo=E8mMuY7Et0auH02fOzGKx04k2=LOj8mZJ6a-=J+sPzQ@mail.gmail.com>
 <CAD-N9QWt=d2Vj2bevSzOPL4AWF08_zTyq=hHOcOOROCazNY4_A@mail.gmail.com>
 <CAD-N9QWrBLygN24EC6QLRFF6uf7=PiTRdA4suKqEXJ7tk9aocA@mail.gmail.com>
 <dac7104a-21ac-24f4-6132-e51960fa0b7e@gmail.com>
 <CAKFNMon3=fFWtuUa1_wDyK9agpCXjbzA8b+rj=OYu=7Gs8nMqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yP2kewe3ti9ZfOopOVa7K12sPi5NnAgBl2PzcRBkWxE=;
        b=DWV+Ze/xxejqT2xuEHPDwP7tMXEou8ChjnbYU9d1tNyzMZ+aeyZ5Eipp7rVQ+LfV6+
         FGe6sze7Te+y03eLyZ9iTRz7Z7aKNT96YQfhnf5YiyADQfaMoICoPra4LuNFZaCfeV62
         XOkto9pkMGGB075KVJlJcoF41LQvl8cnBFxo8nhgaSGaAPUUw9pY3U5ou+zTMMe8GmUV
         M6ViOlgC52qZpszdGsT5vOVADEABD2c86+XTKhT6XRN5/0cBvPGjMkMlRDsU7cJmzLqK
         e1FxnLLcWkZgTQ/uw79IQdPFN93ea+O9k7NiBx3ly8R9hAJsbryKPWBCP60CG0ggXOP4
         FosA==
Content-Language: en-US
In-Reply-To: <CAKFNMon3=fFWtuUa1_wDyK9agpCXjbzA8b+rj=OYu=7Gs8nMqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>

Hi Ryusuke,

On 3/12/22 18:11, Ryusuke Konishi wrote:
>> In case of nilfs_attach_log_writer() error code jumps to
>> failed_checkpoint label and calls destroy_nilfs() which should call
>> nilfs_sysfs_delete_device_group().
> 
> nilfs_sysfs_delete_device_group() is called in destroy_nilfs()
> if nilfs->ns_flags has THE_NILFS_INIT flag -- nilfs_init() inline
> function tests this flag.
> 
> The flag is set after init_nilfs() succeeded at the beginning of
> nilfs_fill_super() because the set_nilfs_init() inline in init_nilfs() sets it.
> 
> So,  nilfs_sysfs_delete_group() seems to be called in case of
> the above failure.   Am I missing something?
> 

Yeah, that's what I mean :) I can't see how reported issue is possible 
with current code.


Sorry for not being clear




With regards,
Pavel Skripkin
