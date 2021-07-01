From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] nilfs2: fix incorrect usage of kobject
Date: Thu, 1 Jul 2021 22:00:28 +0900
Message-ID: <CAKFNMokmN5fZZ5_SUABYGOzEyd+sr3jYtfZNWmUTZwQAZa4NFg@mail.gmail.com>
References: <20210629022556.3985106-1-sunnanyong@huawei.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DaPUpeGq4S3Zxelp1iJnw2sl2vB3LeguXSMXQNFZYHM=;
        b=rhIz2OrWRKxx/a+2VkK9ig3LnQCF7LQXVySbjUv8Tg6gNS0I4aIvQOzCSEyYgaZb4u
         YAYu/GPDCdpRaiQLtYQt5rz0kW4tf8JVYJo3LN8BXGNuQAIzuKdCmWshN56S9LwXguVz
         YspgpuH7e8ZaM4g7DckGHTqp1DCIGeQJDQEniLGRqxZWvbD1k+JC8cIMCYI872EJ/Odw
         EAZDjMw+UR3GoDBZTf0U/VVjdEEFvqL9W9gXKk2dhWK4vVniJqxK+MPpf+yYmW6oNUB4
         9qojbls90/gqdbIfySZruC2Bk5JfnON22bIsCvVeEAFepc8VSZxxtLfAWEJus0psMhl9
         z08Q==
In-Reply-To: <20210629022556.3985106-1-sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hi, Nanyong

Thank you so much for sending this patchset.  I will review each and
send them upstream if applicable as is.

Thanks,
Ryusuke Konishi

On Tue, Jun 29, 2021 at 10:54 AM Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> This patchset fix the memory leak problems and NULL pointer problem
> caused by incorrect usage of kobject in nilfs2 sysfs driver.
>
> Nanyong Sun (6):
>   nilfs2: fix memory leak in nilfs_sysfs_create_device_group
>   nilfs2: fix NULL pointer in nilfs_##name##_attr_release
>   nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group
>   nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group
>   nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
>   nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
>
>  fs/nilfs2/sysfs.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
>
> --
> 2.18.0.huawei.25
>
