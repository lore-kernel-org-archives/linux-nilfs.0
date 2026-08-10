Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020B839A06A
	for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 06:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786344572; cv=pass; b=MXvJL0WXIsvtKrHlaFFkUR7I4lHs7Xu0pZAhdgwFMcpEfXhB2OvOEhKA1ELFJm71TQAWqokhDX7Oa7Bg1jMNahZcuoxVyBKNxOteVl02Tu6sd1x/C7Spz4YtFIYOWgTRbgptQnRY1Lo/HjNRH7uc1JI4C72t8+upV0slw9YVx7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786344572; c=relaxed/simple;
	bh=/jknNKfDFKHNMTfeaspt9VFp2mYDxCNIqoNXP5R+pR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gQ8fwbQ/lKfB/Jmnt5DdbeFO2bfc/fuJB1rQhKGGwPYqafVInySwL5kgk613nOK/F1MaDkopz06dCZ/h95g3dzmO4xN4IwXNs0cC6Yso7/wA6yZm4csfYaFG9fbI3SLIpepQIfjtfkaciiN7ILU25z1LgA8icIv2ZEuW9Crz+2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a8/pfbys; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8/pfbys"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aeb59d54b1so1622786e87.1
        for <linux-nilfs@vger.kernel.org>; Sun, 09 Aug 2026 23:49:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786344569; cv=none;
        d=google.com; s=arc-20260327;
        b=f3REwkW5Lf3ReqrpzBVmsU5MZkMKRxufOS4E1RhU1pqqy7S44oOdSog8GKVMCEGodP
         XWpFHDdWffniX6zPHnUU1BG6Y3z2r37uSsq8moieok1zY+hCIXCMOXqu4rnfFwwvXkWh
         zQ0qjkvu36qWfHsnvtmnQWvBeqKuwgA18awG7/oXv2jqtaPaFgyzmiik+C2PLIMUjqoC
         cBj6jW732DW46j438bm/VC07SSsPJ+qdMG87c9Ss9UH3qV4q8628WBlKExYyucGXOtaY
         weSWGiSrRNMZYmadlWoIaSKYHPJ6LXWbcpaZmWfauCN1j145vpvdzPbgZ4TX1VDmNpdv
         TaeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L/o9ESRHWKBvDZcYHHfi092lVf6jNdWrCyTLLbcc914=;
        fh=sRXzkuAa28vMDBzdzLAO7PL91xZ+P6k9tz6BscVKYDk=;
        b=BRi05ypO+Jq/AF88qE1b6mcmd2y03/83h0RD7GKHsI0U2bo0M88igjN1/b8FSMPWqu
         Gq5bAxaU3042NjS7mYOx1puVhqOQy7exGmN1tGx9otPQld/M1GV2nciBJH5FFbuAqziP
         0c1jr3Z4EicC0xehiT0PwLsXYQPMVF5eW11tq4N+HtF3Cb8iCrVU+wTcgLaEthaOtMUM
         OPYazebn/DWmYdanqC6IcjXb3xlW7H+WQsSFWCcg15VDWc2cYWoAyBjYX7Wdvu35JhQx
         V9Aav5QsddEd3i+rNcTt8hSdyXU9aKmUOPYdxCPY6fCSUSQMZ28rQPRggYs/ttejXEqP
         5Osw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786344569; x=1786949369; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L/o9ESRHWKBvDZcYHHfi092lVf6jNdWrCyTLLbcc914=;
        b=a8/pfbysGDim8W4WCM3WvPXOo+wXuhIPvaNzZaoj4DkB+cGzOHnwxrBe1a0WH36zGB
         nUyuSuGrXzGNNm7Q4B7Sex4EKT1POu5ORjJqLX3hqc5PMGCghT7iowjuG4SMO0qku7rq
         KfVcmUiLE78gNEELFcODxIkmyUuhRfkObaUInNAOeLIn9IX6PgCdUAS8HdAcR9it9a9B
         26xJ5tVF6gZWB/wpEJbjOl5d9VvRZRtVksjSsszJfLb6dR3R/QM5uE2CVCGtIX2/gKkb
         H8/UPO+EBA//SjkWjOW6UkH/pp8HW5tQfxh2hgg5uYSVm4WDObTNEI0p4YEGax21ZoMy
         aUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786344569; x=1786949369;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L/o9ESRHWKBvDZcYHHfi092lVf6jNdWrCyTLLbcc914=;
        b=pZmRie4ERiO35R80v5XOyRotBHqphQ3u7fR2ArNQu+hGjt3BQs0WRuAEUMyl6JMrSE
         Zh+07H0Rijo5Maq5TLyRhvSYEOEqvaqslDn/xC2JIMMotdx82lXpxI+w45caBHLvVeQs
         FBbdEy3QLpgVpCK34PuE6qVymXnqXt4DSSosE3rizkny/7gdeuZ6ZwvqxxsGVxeJgzV7
         e2tgfXQ+lcvOVflbPDFBXjBzoJ/MCsHKMBbvbsIOtHy4xwMwAh3zukx70wESS8aPSw1x
         fWvkkgaEW/+tPo1DZhUtyg9+1CX22HrlgO7iwvKWPOeohbUn9rTC2NZ0rY8Dmiy0NY75
         S3tA==
X-Forwarded-Encrypted: i=1; AHgh+Rph8CmGvIYd1o852kW2D6RJP16E4PAmKxtwz0qFbYHC8Fqs1L53ICGa1SdIAcIVQc7qYHc6QzLRR/pWDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIJvMnC6G9OzSWtXHswPWdL9JfCIcp5ntkqT1la3l0EIf9Kzm5
	1m7R0k2g23mKr1SVhV1nsKcHGfvx7LaIEB49l7l+jlDEwLMzLQvyjNKSVLXQegOFa0X/85ObIBS
	Dq1hcqRfRGu2QmuYt+eo8MnHrgXdNcu0gTmon
X-Gm-Gg: AR+sD12bHgRPz/bHS7LcXhxcvcyb7CIpYm+wnwpSdT42EZgDtJI1MWCdaGyHkplbWda
	lSA5RDA9IZss/Dh3h6aFCeSRx6+Qmzxf2tIgw2npcOEkN3aiAOQIr8fAaxedFveZSZApLi8ph+m
	nOFbUZbykZFln8ig4B63wuuU9HGn14uB9U1z5nq+Hu4GYvu/WO2rTVSESBw+rJsECdoPI5PH/7Z
	PoSB4y8BSWF7B1z5WEp9WTU9GhELIvW91OGhdyJlomj3VIiV6GG2H8m+v/UrpyuCFH1CyQtngmg
	nGJaiw6z/0CiOKV8i2aaukDfmDgt0skc4xMP1JxATYrI4w==
X-Received: by 2002:ac2:5b1b:0:b0:5b2:9358:b868 with SMTP id
 2adb3069b0e04-5b30b766464mr1531881e87.34.1786344568713; Sun, 09 Aug 2026
 23:49:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260810061059.1854426-1-wangjianjian3@huawei.com>
In-Reply-To: <20260810061059.1854426-1-wangjianjian3@huawei.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 10 Aug 2026 15:49:11 +0900
X-Gm-Features: AUfX_mx24f14nrNqGT41_0WMdsmSxjl3fT16wg0rTguKX5PJl6lWE_FKzPArUSI
Message-ID: <CAKFNMo=ypauSr1O7YqrYaD0JkoSJAHcDW-DFfFhLgqgh2o0G-w@mail.gmail.com>
Subject: Re: [PATCH v3] nilfs2: enhance btree node keys check
To: Wang Jianjian <wangjianjian3@huawei.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10, 2026 at 3:43=E2=80=AFPM Wang Jianjian wrote:
>
> syzbot reported a warning on nilfs_btree_assign:
> WARNING: fs/nilfs2/btree.c:2302 at nilfs_btree_assign+0x983/0xbe0 fs/nilf=
s2/btree.c:2302,
>
> Analysis found that a corrupted file has the following btree layout:
> Level2(key/ptr): [ 256/15 ]
> Level1(key/ptr): [ 0/8, 1/9, 0/10, 3/11, 4/12, 5/13, 6/14, 13963797672755=
9/16, 0/17 ]
>
> The test truncated the file to 2 bytes, which partially zeroes the first =
block and
> adds the file to the dirty list. When the segment constructor writes it a=
nd assigns
> a new blocknr for the index block, it searches the btree with key=3D0 and=
 min level=3D2,
> and apparently returns ENOENT.
>
> Therefore, we should perform more checks on the btree nodes and return ea=
rly.
>
> Reported-by: syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D158be45e4d99232e1900
> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
> ---
>  fs/nilfs2/btree.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
Hi Wang Jianjian,

Thank you for the patch.

I would like to send this upstream.
However, since there are a few minor things I would like to tweak, I
will make the adjustments myself, run a thorough test, and then send
it upstream.

Specifically, after actually testing it, I found the message a bit
confusing. (While the commit message refers to keys and pointers as
"key/ptr", referring to them as "index/key" in the actual log message
is confusing.)Therefore, please note this slight change to the error
message output:

        nilfs_crit(inode->i_sb,
                  "bad btree node (ino=3D%llu, blocknr=3D%llu): unsorted
keys at index %d (%llu) and %d (%llu)",
                  inode->i_ino, (unsigned long long)blocknr,
                  i - 1, prev_key, i, key);

Also, starting next time when you submit patches, please run
checkpatch.pl (located in the scripts folder) on the patch output
generated by git format-patch beforehand to check if it complies with
the coding style guidelines.

So, unless you have any concerns, please leave this to me and sit tight.

Thanks,
Ryusuke Konishi

>
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 64d5f7c5ab44..adf087c896ba 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -341,7 +341,8 @@ static int nilfs_btree_node_broken(const struct nilfs=
_btree_node *node,
>                                    sector_t blocknr)
>  {
>         int level, flags, nchildren;
> -       int ret =3D 0;
> +       __u64 key, prev_key;
> +       int i;
>
>         level =3D nilfs_btree_node_get_level(node);
>         flags =3D nilfs_btree_node_get_flags(node);
> @@ -356,9 +357,19 @@ static int nilfs_btree_node_broken(const struct nilf=
s_btree_node *node,
>                            "bad btree node (ino=3D%llu, blocknr=3D%llu): =
level =3D %d, flags =3D 0x%x, nchildren =3D %d",
>                            inode->i_ino, (unsigned long long)blocknr, lev=
el,
>                            flags, nchildren);
> -               ret =3D 1;
> +               return 1;
>         }
> -       return ret;
> +
> +       for (i =3D 1, prev_key =3D nilfs_btree_node_get_key(node, 0); i <=
 nchildren; i++, prev_key =3D key) {
> +               key =3D nilfs_btree_node_get_key(node, i);
> +               if (unlikely(key <=3D prev_key)) {
> +                       nilfs_crit(inode->i_sb,
> +                               "bad btree node(ino=3D%llu, blocknr=3D%ll=
u), key not sorted: %d/%llu <=3D %d/%llu",
> +                               inode->i_ino, (unsigned long long)blocknr=
, i, key, i - 1, prev_key);
> +                       return 1;
> +               }
> +       }
> +       return 0;
>  }
>
>  /**
> --
> 2.34.1
>
