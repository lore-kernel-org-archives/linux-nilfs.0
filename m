From: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix memory leak in
 nilfs_sysfs_create_device_group
Date: Mon, 6 Sep 2021 18:56:54 +0300
Message-ID: <aa2fb8c6-ef6b-a1ca-d598-b0814529a31d@gmail.com>
References: <20210906041330.2065214-1-mudongliangabcd@gmail.com>
 <CAD-N9QUHfoqOOxDuKniMi8VGLR2j6g50BBy45eAL0kPRrntmgA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WAFFW6/E8EkAvweZY81x+iHepjZ6KxIjBe1d7SWBGig=;
        b=m6IHXg16nPUehvniIXt2wEQRG7xJNr3Iq8VmXeQ5N4LnmQBlePMkh9ygL/w16WFTg2
         I1VTMCs9FvKpZfpPOi08YaWrzkbYkyy06nbNv7ddEhph2rgypaKyN9cdWGZxa/rTPBFe
         FjxFIKrCxlL4XOe14SbElHfAuGguueunOInzhx9vXtUdBrRt1tUPtnbEIhYAKEZkQiUy
         LcYiy/wTB358MUWsT4e1zLu01TDGPmLcmrIePHqFALnd3OMBdMmDlCU8i6cIr1xPlIRY
         1Vz17xwsPOPGLtTKHStpXboYsz7UTOUY9rVFYjTaOh8YubCHjb2lHoDak3Qz0XEiuKj1
         qWHg==
Content-Language: en-US
In-Reply-To: <CAD-N9QUHfoqOOxDuKniMi8VGLR2j6g50BBy45eAL0kPRrntmgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 9/6/21 08:43, Dongliang Mu wrote:
> On Mon, Sep 6, 2021 at 12:13 PM Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> The commit 8fd0c1b0647a ("nilfs2: fix memory leak in
>> nilfs_sysfs_delete_device_group") adds a kobject_put to free the leaking
>> object name. However, it is incomplete to only add kobject_put in the
>> nilfs_sysfs_delete_device_group. The function
>> nilfs_sysfs_create_device_group also needs the kobject_put to
>> free the object name in the error handling part.
>>
>> Fix this by adding kobject_put in the error handling code of
>> nilfs_sysfs_create_device_group.
> 
> Even after I add this patch, my local syzkaller still reports this
> memory leak one hour later. Therefore, there are some other paths or
> magics which can trigger the memory leak. I need to dig deeper.
> 
> Pavel, do you have any idea about this crash report?
> 
> BUG: memory leak
> unreferenced object 0xffff88804a1a8a60 (size 32):
>    comm "syz-executor", pid 14551, jiffies 4294960586 (age 14.780s)
>    hex dump (first 32 bytes):
>      6c 6f 6f 70 35 00 00 00 00 00 00 00 00 00 00 00  loop5...........
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff814750c6>] kstrdup+0x36/0x70
>      [<ffffffff81475153>] kstrdup_const+0x53/0x80
>      [<ffffffff822773a2>] kvasprintf_const+0xc2/0x110
>      [<ffffffff82337c5b>] kobject_set_name_vargs+0x3b/0xe0
>      [<ffffffff823385ed>] kobject_init_and_add+0x6d/0xc0
>      [<ffffffff81d2bd08>] nilfs_sysfs_create_device_group+0x98/0x3a0
>      [<ffffffff81d14fc4>] init_nilfs+0x424/0x580
>      [<ffffffff81d02962>] nilfs_mount+0x532/0x8c0
>      [<ffffffff815c754b>] legacy_get_tree+0x2b/0x90
>      [<ffffffff81565158>] vfs_get_tree+0x28/0x100
>      [<ffffffff815a3a82>] path_mount+0xb92/0xfe0
>      [<ffffffff815a3f71>] do_mount+0xa1/0xc0
>      [<ffffffff815a4584>] __x64_sys_mount+0xf4/0x160
>      [<ffffffff8433fd35>] do_syscall_64+0x35/0xb0
>      [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> 

Hi, Dongliang!


This report says nothing to me... It shows, that there is missing 
kobject_put() somewhere. I think, we need a reproducer for this leak, 
otherwise only code review can help :(



With regards,
Pavel Skripkin
