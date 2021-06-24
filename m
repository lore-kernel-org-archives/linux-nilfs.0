From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH] nilfs2: remove redundant continue statement in a while-loop
Date: Fri, 25 Jun 2021 02:34:38 +0900
Message-ID: <CAKFNMomw60BGObwF2ZOFriFwPnEk5hFZgC-5vJwJjPnrW3RyPw@mail.gmail.com>
References: <20210621100519.10257-1-colin.king@canonical.com>
Mime-Version: 1.0
Return-path: <kernel-janitors-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+1dHCIjVGu+VUQzg64ApXX1v4ulkFxMzGJoEo7mlEN8=;
        b=AARHRFZK4+BCpIFSAR4Ai01+dvIC2tHWRomTVTb1qj8A98A4rj7a7RL0a1YxshGXjS
         ylJERtxccirnh2JtFVERSbZqjqFkZv151h58DU7fxtNvk1ymxTwBWWxeK4CRSorRYFX3
         ZH3KmSFqkl+0HpUw+VOEJPP+aZsXVDgdooZjimavAs28OTJ+5nW7jqV+w2VtbIyI875S
         JDEA8jR5UG1z465hHft34VuKxHIYrEfwcZwk6JTrJ/qGaWKaRZPXFasqE5z8e2nzzQMG
         uXVmd7OVicFr2VZlaFpLatGxVSRkMPTjImm4rK45atjpd8bgjoYlhpjMHni+J2lrE74m
         44vA==
In-Reply-To: <20210621100519.10257-1-colin.king@canonical.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin King <colin.king@canonical.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Thank you.  This change is correct also in view of the expected
behavior of the function
(it really is unnecessary).
I will send this to upstream.

Regards,
Ryusuke Konishi

On Mon, Jun 21, 2021 at 7:05 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The continue statement at the end of the while-loop is redundant,
> remove it.
>
> Addresses-Coverity: ("Continue has no effect")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/nilfs2/btree.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index f42ab57201e7..ab9ec073330f 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -738,7 +738,6 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
>                         if (ptr2 != ptr + cnt || ++cnt == maxblocks)
>                                 goto end;
>                         index++;
> -                       continue;
>                 }
>                 if (level == maxlevel)
>                         break;
> --
> 2.31.1
>
