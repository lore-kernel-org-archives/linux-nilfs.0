From: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix memory leak in nilfs_sysfs_create_device_group
Date: Tue, 7 Sep 2021 12:00:09 +0800
Message-ID: <CAD-N9QUjd-yNVa2uOac434tgyd2wXEQ6Z=aA9Yu9-_UANv7YjA@mail.gmail.com>
References: <20210906041330.2065214-1-mudongliangabcd@gmail.com>
 <CAD-N9QUHfoqOOxDuKniMi8VGLR2j6g50BBy45eAL0kPRrntmgA@mail.gmail.com>
 <aa2fb8c6-ef6b-a1ca-d598-b0814529a31d@gmail.com> <53fb4217-21b8-ac46-bb39-581a4c9837a4@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zvYVDMQgs67A0xyIISSLD3E0W3ASycTx+U4ytRbx0js=;
        b=fo9ddkCjC4KeMP2iMIRoV5LjMKTgvwXJiUQ+7vflzMiQUusDNytZ3hTxkB/T5Enri8
         wPtR5VyZHn7M0cvtFQ0vjmtbAMmB02reH3Cl+qODQ+tVv15Pl3LxNUwcsjc51h9RNIM+
         KJWBIVjWc90LfxktKgxr7oFvtYENWI8XZfKIhvcvEmLquR3ucznwViS4Pio4m2bxJYXu
         0kbxsyd7L4lMkzgtB/qQZFn1CLEsYqS66WJQELZpg1qPGV26vyMPg0O0FFkVuP/D3Ald
         ATrG5UYpY4LtjaMtzrlXEQIbITb0Cy9W6OZvBJBTFoT7gOqiDOiDfMg9Xn3fq82HBe+n
         giTg==
In-Reply-To: <53fb4217-21b8-ac46-bb39-581a4c9837a4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Sep 7, 2021 at 12:47 AM Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On 9/6/21 18:56, Pavel Skripkin wrote:
> > On 9/6/21 08:43, Dongliang Mu wrote:
> >> On Mon, Sep 6, 2021 at 12:13 PM Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>>
> >>> The commit 8fd0c1b0647a ("nilfs2: fix memory leak in
> >>> nilfs_sysfs_delete_device_group") adds a kobject_put to free the leaking
> >>> object name. However, it is incomplete to only add kobject_put in the
> >>> nilfs_sysfs_delete_device_group. The function
> >>> nilfs_sysfs_create_device_group also needs the kobject_put to
> >>> free the object name in the error handling part.
> >>>
> >>> Fix this by adding kobject_put in the error handling code of
> >>> nilfs_sysfs_create_device_group.
> >>
> >> Even after I add this patch, my local syzkaller still reports this
> >> memory leak one hour later. Therefore, there are some other paths or
> >> magics which can trigger the memory leak. I need to dig deeper.
> >>
> >> Pavel, do you have any idea about this crash report?
> >>
> >> BUG: memory leak
> >> unreferenced object 0xffff88804a1a8a60 (size 32):
> >>    comm "syz-executor", pid 14551, jiffies 4294960586 (age 14.780s)
> >>    hex dump (first 32 bytes):
> >>      6c 6f 6f 70 35 00 00 00 00 00 00 00 00 00 00 00  loop5...........
> >>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >>    backtrace:
> >>      [<ffffffff814750c6>] kstrdup+0x36/0x70
> >>      [<ffffffff81475153>] kstrdup_const+0x53/0x80
> >>      [<ffffffff822773a2>] kvasprintf_const+0xc2/0x110
> >>      [<ffffffff82337c5b>] kobject_set_name_vargs+0x3b/0xe0
> >>      [<ffffffff823385ed>] kobject_init_and_add+0x6d/0xc0
> >>      [<ffffffff81d2bd08>] nilfs_sysfs_create_device_group+0x98/0x3a0
> >>      [<ffffffff81d14fc4>] init_nilfs+0x424/0x580
> >>      [<ffffffff81d02962>] nilfs_mount+0x532/0x8c0
> >>      [<ffffffff815c754b>] legacy_get_tree+0x2b/0x90
> >>      [<ffffffff81565158>] vfs_get_tree+0x28/0x100
> >>      [<ffffffff815a3a82>] path_mount+0xb92/0xfe0
> >>      [<ffffffff815a3f71>] do_mount+0xa1/0xc0
> >>      [<ffffffff815a4584>] __x64_sys_mount+0xf4/0x160
> >>      [<ffffffff8433fd35>] do_syscall_64+0x35/0xb0
> >>      [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>
> >>
> >
> > Hi, Dongliang!
> >
> >
> > This report says nothing to me... It shows, that there is missing
> > kobject_put() somewhere. I think, we need a reproducer for this leak,
> > otherwise only code review can help :(
> >
> >
> >
>
> Hm, I guess, I see... We should call kobject_put() in case of
> kobject_init_and_add() failure:
>
> lib/kobject.c:459
>
>   * If this function returns an error, kobject_put() must be called to
>   * properly clean up the memory associated with the object.  This is the
>
>
> so I suggest:
>
> diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> index 68e8d61e28dd..e8717f4ba2a1 100644
> --- a/fs/nilfs2/sysfs.c
> +++ b/fs/nilfs2/sysfs.c
> @@ -1026,6 +1026,7 @@ int nilfs_sysfs_create_device_group(struct
> super_block *sb)        kobject_del(&nilfs->ns_dev_kobj);
>
>   free_dev_subgroups:
> +       kobject_put(&nilfs->ns_dev_kobj);
>         kfree(nilfs->ns_dev_subgroups);
>
>   failed_create_device_group:
>
>
> This patch should fix 2 memory leaks :)

Yes. We should move kobject_put from the label cleanup_dev_kobject to
free_dev_subgroups.

However, I tried the syz reproducer just sent to you. The memory leak
is still there.

>
>
>
>
> With regards,
> Pavel Skripkin
