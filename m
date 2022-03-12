From: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fw:Re: [PATCH] fs: nilfs2: fix memory leak in nilfs sysfs create
 device group
Date: Sat, 12 Mar 2022 17:20:28 +0300
Message-ID: <dac7104a-21ac-24f4-6132-e51960fa0b7e@gmail.com>
References: <3192BC90-D082-472B-B310-6E09A14A77C6@hust.edu.cn>
 <CAD-N9QUqfq+0UeMjQALUmGpX5xgjS6=BXvsqcXQpJRzhB6hHLw@mail.gmail.com>
 <CAKFNMokdB+Zph-1OyC1-Xnyi93r+yKSusgaEaa=CkuUBttwRZA@mail.gmail.com>
 <CAD-N9QU8-Od3G+-=RHM5K7vR2-4Af+4t=XutJJVdmkKhH7OarA@mail.gmail.com>
 <CAKFNMo=E8mMuY7Et0auH02fOzGKx04k2=LOj8mZJ6a-=J+sPzQ@mail.gmail.com>
 <CAD-N9QWt=d2Vj2bevSzOPL4AWF08_zTyq=hHOcOOROCazNY4_A@mail.gmail.com>
 <CAD-N9QWrBLygN24EC6QLRFF6uf7=PiTRdA4suKqEXJ7tk9aocA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xxng1XACAuzas2FHe44rwKp6k4WnZM5V6/BhtW2iAeo=;
        b=OUHiPI/6v3cfddwCsDB3lBYPkJdhHyZHPPhxL6PKDCfaD2MiJfBr7F4D4dfN8/mjsl
         jyE8hTh19krEVng4t1IHEIb1+oIxs7n0XY3wG4VVAFvhc3JXt1xjONY2dd7tAZ+UdsEP
         zAcAfgpc7hJr83tqtx0qiSX1PeZL0xOmbD3nPc1cT/nN9a5m8H3JTaeSEDNF5BD6/rzT
         Ofxds2cX/nRwiMU32Hk2FwrZcLUYv7fyh4cYjNa4zU5rRZjIZOxEdpubHg7fBQrzZ745
         WhtYxDla3/KxtVTpF3rpsibWhxTPomoLlg6vdWrF3+ESzjCjR24pGoctrUxcRogwamlf
         4exQ==
Content-Language: en-US
In-Reply-To: <CAD-N9QWrBLygN24EC6QLRFF6uf7=PiTRdA4suKqEXJ7tk9aocA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>

Hi Dongliang,

On 3/9/22 11:30, Dongliang Mu wrote:
>> Now I am checking the log and trying to find error injection in the
>> log file, as said by Pavel.
> 
> Attached is the report and log file.
> 
> @Pavel Skripkin I don't find any useful error injection in the log file.
> 
> In case I made some mistakes, I will clean up my local crash reports,
> update to the latest upstream kernel and restart the syzkaller. Let's
> see if the crash still occurs.

The execution path is clear from the logs. Quick grep for nilfs shows 
these lines

[  886.701044][T25972] NILFS (loop2): broken superblock, retrying with 
spare superblock (blocksize = 1024)
[  886.703251][T25972] NILFS (loop2): broken superblock, retrying with 
spare superblock (blocksize = 4096)
[  886.706454][T25972] NILFS (loop2): error -4 creating segctord thread

So here is calltrace:

nilfs_fill_super
   nilfs_attach_log_writer
     nilfs_segctor_start_thread <- failed


In case of nilfs_attach_log_writer() error code jumps to 
failed_checkpoint label and calls destroy_nilfs() which should call 
nilfs_sysfs_delete_device_group().


So I can really see how this leak is possible on top of current Linus' HEAD.


Also in the log there are onlyh 4 syz_mount_image$nilfs2 programs, so 
only one of them may be a reproducer. If you have spare time you can try 
to execute them using syz-execprog and see if it works :))



With regards,
Pavel Skripkin
