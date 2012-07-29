From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/2] nilfs-utils: integrate skeleton of fsck.nilfs2
 utility into nilfs-utils package
Date: Sun, 29 Jul 2012 18:33:09 +0900
Message-ID: <CAKFNMomL6kpZS=-w4a2rmEd2M9HWH=WiaULueLjP6m7Yvpr6Xg@mail.gmail.com>
References: <83A3B84C-2558-4C14-AF65-95E3B46F9F74@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=V1U6KEYGRGpcQd/w/t+LDSd3Vg75aGpvuxzXXl3wNXg=;
        b=MAimBQhXJsPFcT86v5HSaBkAslpM4YporMdh0LMLgXN+ppLRWeDxJg0uSo11FwtxRm
         jImdwM/VlB8R/KQ7v7ILPF656N/+iMfaqmu2pgLgzl0SLwoIF2zoEfK1N+cyizXAwwBB
         9d3z9xnY1WlqdJqOVEKc3cgOU2A/ksGsaEIx0kt8cxvqNDYpYYVPpPmMV3Dmxay4MGR3
         6f8KN/J9VmT2LcSq+GTKq0P7XshUPzY/PsNwyZ+14wjQKBc0M3r9XxdenYZIjk/5020Z
         CSQhWzVmJa9nP3b2y/iMCOULalB7exzw3Ri1GmWZMd/KxJddjP5ilZ5x17WlAOep+srC
         85Jw==
In-Reply-To: <83A3B84C-2558-4C14-AF65-95E3B46F9F74-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2012/7/23 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:
> Hi,
>
> This patch integrates skeleton of fsck.nilfs2 utility into nilfs-utils package.
>
> With the best regards,
> Vyacheslav Dubeyko.
> --
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH 1/2] nilfs-utils: integrate skeleton of fsck.nilfs2 utility into nilfs-utils package
>
> This patch integrates skeleton of fsck.nilfs2 utility into nilfs-utils package.
>
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

This patch looks OK to me.

Ryusuke Konishi

> ---
>  configure.ac     |    3 ++-
>  sbin/Makefile.am |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/configure.ac b/configure.ac
> index c2bcf4c..0d1a2d1 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -167,5 +167,6 @@ AC_CONFIG_FILES([Makefile
>                  sbin/mount/Makefile
>                  sbin/nilfs-tune/Makefile
>                  sbin/nilfs-clean/Makefile
> -                sbin/nilfs-resize/Makefile])
> +                sbin/nilfs-resize/Makefile
> +                sbin/fsck/Makefile])
>  AC_OUTPUT
> diff --git a/sbin/Makefile.am b/sbin/Makefile.am
> index 302e9a7..8a0d306 100644
> --- a/sbin/Makefile.am
> +++ b/sbin/Makefile.am
> @@ -1,3 +1,3 @@
>  ## Makefile.am
>
> -SUBDIRS = cleanerd mkfs mount nilfs-tune nilfs-clean nilfs-resize
> +SUBDIRS = cleanerd mkfs mount nilfs-tune nilfs-clean nilfs-resize fsck
> --
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
