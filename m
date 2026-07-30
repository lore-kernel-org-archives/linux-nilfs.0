Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E670C42DA48
	for <linux-nilfs@vger.kernel.org>; Thu, 30 Jul 2026 12:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785415355; cv=pass; b=rxa1HtbxlY6UI/gqAJefU9h6sMokyNTWdxRmJOalRvDVxXkxVdKlZR1CxYv+KA/e6rb9IL5LGeuik5C4CPDV6s+fhCm2gOnnhE6KPeqlKgtA+lxrnuIXJoLN/yliDiv3rccyi41Al8k07nxykyhVBMN5bdGaSI/4LlXlGOVg2IQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785415355; c=relaxed/simple;
	bh=KvGirR/O/vriTHnBi7rQ4BYuG6DjIKhz9Q8h8Om2xjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CRzTrccxMwlG0RVlbvxRp0USgGelZtuHzgbl3EPvgjWU3SnBbW8OrZS040827DJMJpVZjBSTPSzSEoLyGPxR619hl+kdIQWM6Uq1hFIoLQopxDRB0gl2+7KzmDNT+d+9A1rqTnouBbsLNU3RbnusxU0dRw5SD90L1oa6/fRWl7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f8xjAZRd; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f8xjAZRd"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39ca300db70so18640411fa.2
        for <linux-nilfs@vger.kernel.org>; Thu, 30 Jul 2026 05:42:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785415350; cv=none;
        d=google.com; s=arc-20260327;
        b=BWBIUP3o083ELHISFpeTvjesk/GFHz4TQeBA7GR9nHpWPP9KatrVsdkErlDMyYo/tf
         pHDEZDYmaw3RfeLhxmrQ2eKMX+vjVcLSmaYDCJ820zs3rBMtgd6OWCQwz25DorogxR0O
         ZxpgzPP6jMQZkX9EKFpXEor/j/nU1/XG6hBKAVBMQnAyDN96yDeuDYxdqkz9Glfo7jsf
         kMC82iaqnZQOpC8mwXbKiJ2Yo5+FRNdfUI82yIhNDhnH2rDeiUk2owK4UEBCU7/r2rtY
         HJXtl/EeF2hFZTNLztv4oFtnEodldQaMnk9nu90QpogM0XjaEsZimN2TREfYq/yqJ2eU
         0jHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ceHycHfJStjcVhSX8Etl8+VC0lZUxw7F9+WCz5an37M=;
        fh=/+XxuMjub5lQo54k/urp3kJ1zgJ/qb2kjjj7iwF+HCk=;
        b=ZlIAhGk24l8l0u+aBn/I2dupFO1msWIAVkRqDkyRjxu278namgfaHzGbLw+AryHMuu
         V3GTPh2kTrRCbxo+D+/iFfopeFJfL3fQZUnhhy6us63lCkIPsHoir2CclcSpZE8KqPIe
         gYEdl95hUv0aiV22IENBzicZhSpv9956+9UT+Qo61hoEeqlQpW2K28Uaoyp/hgZZg5LC
         vbyvj2D/3Vy9NTcQnHCk80dMPjN9h8IJAdiQ+6IEiuFLR2uYus5opNWCcgHvllbmKHlE
         73PiSfeMp/R/zIHnWm7ISUNbP6YZpGdIJkXQkLg5EUDJl5tCbtXr8LCcz78pyioMW9H2
         A0PA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785415350; x=1786020150; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ceHycHfJStjcVhSX8Etl8+VC0lZUxw7F9+WCz5an37M=;
        b=f8xjAZRd9+NN4SzxbzBK09B6JzYSLvyRgmySo1ssLQe3HjfhKT0t0DxmRQayqoIbsM
         0HeMMjnUqLS9E6OOnsNjeq5qx8XWSW9QSHZGvoGC7vsH5oK3MNnaxiNxg7DWFRLlSfLC
         z/sH2Js9ycBjgpSb9+nkXsZ85Hb3B66qmWDWGw1h3pBLghCZ7aXUrUs3qYzQY+Y7775e
         OCnA3rQdIZj2YbQkJuJ5FzhZAW9p06lwRLPlvZ1x2pTtbu2XOt3bencLwcsnnp7J8gz3
         bdZ9zOEOiybUcDc7hocySdvhdKj0afEv19zXQ8dCLA+j7jOcKcidFQAj9YTl9s4O0U1z
         R79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785415350; x=1786020150;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ceHycHfJStjcVhSX8Etl8+VC0lZUxw7F9+WCz5an37M=;
        b=ss56UpaRofq5lhpf6HlfhjQAdeSyw5gS2NuhC7aywXvvDFrkAW0Pd5hx02Vmnk4jsg
         VfVc3bnlU9dNr3/8nvYunzdX7Zein+wqVPD/0widP2cbBY5O44NEMHCMvAACY/xjKYSA
         MvgbCx0EjKbvCar43V7MkLLq2gLHk5KfCBwZT5I/bBwJJkDQmEzWHiz+BoDlT1N0pCZ4
         MxZPFyJQLCRb0VcxqpW/KHjJDVC3xAd4y0vIzw22aGDWocIQhDX+zJ0D62lLcBKcWuFF
         V6pvpo0sqfy+FyzX2MpYUCmt3tWEg9of/PAQUoKf65dRRgLt2mGQab4eEexEqWreR+Rd
         XQqA==
X-Forwarded-Encrypted: i=1; AHgh+RpaiJvNqKaSq3G5VHIm6v86BIsyuX2yjSxFxYypaWl6A+aINmh4opXRpEHvGpfn38yJlaIxJXotL7vqpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpTrU8HSx0Zx/5tIu4xR8E6AfJMm7jlZPP37oZfbLqYvRP6Bv+
	wEGGLInxdGJFUpY4N838k7Ii2Loekf8oqu5csxxi49X5Pr6nwKJv/jSORsaf02bGwSx7GYBRwyh
	bi1RL5RjXCRWUkgPnqSi9jqC+rx857vQ=
X-Gm-Gg: AR+sD13VxXRTfmZ974kA3c5fT2KTJiky67PZCjaZK9MEr5MNpytSZjoUh351serLAyO
	cGCvMbwGasl7xTAM6q2G17PWLs/QDH3046z7EagRZEM1ZGq7t0/ExL1skij/ZG1Hrj6tB393tAn
	+7fEiy7aU3B16vKNIx8C0xOBC5GHXxEYzbUjH3nbxEXGkFWSxQ9nz9Sf6r/61HlbacRGFdPqOc6
	fvULDuwomD6+mRufZ7Z7Wozg4PE7Y64YrF2iHGkPOiqlXe4082oKWzlHwaMQhDUh4EIFCfyU7yl
	1s0lr1ws4VV5IcJ+vSWmEiLeyD78KFuMw611S5/SKWpf+A==
X-Received: by 2002:a05:6512:3da7:b0:5b2:907c:e8b1 with SMTP id
 2adb3069b0e04-5b2db3a4dbfmr571578e87.62.1785415349487; Thu, 30 Jul 2026
 05:42:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730120105.2746192-1-wangjianjian3@huawei.com>
In-Reply-To: <20260730120105.2746192-1-wangjianjian3@huawei.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 30 Jul 2026 21:42:12 +0900
X-Gm-Features: AUfX_myZPTWdJPdzsjGthXqEInA_kRL5ouC7UVoFCxFkXWjXnIyZuWADk8-zreI
Message-ID: <CAKFNMomBf5+K1NC=UXCy2Jktcb6Nq-EVCfxv73Okrg7ZjHdnCw@mail.gmail.com>
Subject: Re: [PATCH 1/2] nilfs: enhance btree node keys check
To: Wang Jianjian <wangjianjian3@huawei.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 9:32=E2=80=AFPM Wang Jianjian wrote:
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
> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
> ---
>  fs/nilfs2/btree.c | 40 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 35 insertions(+), 5 deletions(-)
>
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 64d5f7c5ab44..8b164e13663f 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -448,16 +448,46 @@ nilfs_btree_get_node(const struct nilfs_bmap *btree=
,
>  }
>
>  static int nilfs_btree_bad_node(const struct nilfs_bmap *btree,
> +                               const struct nilfs_btree_path *path,
>                                 struct nilfs_btree_node *node, int level)
>  {
> +       struct inode *inode =3D btree->b_inode;
> +       __u64 key1, key2;
> +       int i, ncmax;
> +
>         if (unlikely(nilfs_btree_node_get_level(node) !=3D level)) {
>                 dump_stack();
> -               nilfs_crit(btree->b_inode->i_sb,
> +               nilfs_crit(inode->i_sb,
>                            "btree level mismatch (ino=3D%llu): %d !=3D %d=
",
> -                          btree->b_inode->i_ino,
> -                          nilfs_btree_node_get_level(node), level);
> +                          inode->i_ino, nilfs_btree_node_get_level(node)=
, level);
>                 return 1;
>         }
> +
> +       for (i =3D 1; i < nilfs_btree_node_get_nchildren(node); i++) {
> +               key1 =3D nilfs_btree_node_get_key(node, i);
> +               key2 =3D nilfs_btree_node_get_key(node, i - 1);
> +
> +               if (key1 <=3D key2) {
> +                       nilfs_crit(inode->i_sb,
> +                                  "btree node(ino=3D%llu) level=3D%d key=
 not sorted: %d/%llu <=3D %d/%llu",
> +                                       inode->i_ino, level, i, key1, i -=
 1, key2);
> +                       return 1;
> +               }
> +       }
> +
> +       if (level < nilfs_btree_height(btree) - 1) {
> +               struct nilfs_btree_node *parent =3D nilfs_btree_get_node(=
btree, path, level + 1, &ncmax);
> +
> +               key1 =3D nilfs_btree_node_get_key(parent, path[level + 1]=
.bp_index);
> +               key2 =3D nilfs_btree_node_get_key(node, 0);
> +               if (key1 !=3D key2) {
> +                       nilfs_crit(inode->i_sb,
> +                                  "btree node(ino=3D%llu) level=3D%d key=
=3D%llu not equal to parent's key=3D%llu",
> +                                  inode->i_ino, level, key2, key1);
> +                       return 1;
> +               }
> +       }
> +
>         return 0;
>  }
>
> @@ -582,7 +612,7 @@ static int nilfs_btree_do_lookup(const struct nilfs_b=
map *btree,
>                         return ret;
>
>                 node =3D nilfs_btree_get_nonroot_node(path, level);
> -               if (nilfs_btree_bad_node(btree, node, level))
> +               if (nilfs_btree_bad_node(btree, path, node, level))
>                         return -EINVAL;
>                 if (!found)
>                         found =3D nilfs_btree_node_lookup(node, key, &ind=
ex);
> @@ -630,7 +660,7 @@ static int nilfs_btree_do_lookup_last(const struct ni=
lfs_bmap *btree,
>                 if (ret < 0)
>                         return ret;
>                 node =3D nilfs_btree_get_nonroot_node(path, level);
> -               if (nilfs_btree_bad_node(btree, node, level))
> +               if (nilfs_btree_bad_node(btree, path, node, level))
>                         return -EINVAL;
>                 index =3D nilfs_btree_node_get_nchildren(node) - 1;
>                 ptr =3D nilfs_btree_node_get_ptr(node, index, ncmax);
> --
> 2.34.1

Hi, Wang Jianjian.

Thank you for proposing the patch.

Your patch checks for key consistency within B-tree nodes; however,
since this check is performed inside nilfs_btree_bad_node() - which is
called during every B-tree search - it imposes unnecessary overhead.

Could you please move the check to nilfs_btree_broken_node_block() instead?
That function performs the check only once when the B-tree node block is lo=
aded.

By leveraging the BH_nilfs_checked flag on the buffer head, once the
check is performed, it prevents redundant checks as long as the buffer
remains in the cache.

If a node becomes corrupted after being loaded into memory, that
indicates a bug in the B-tree implementation itself; therefore,
checking it on every lookup is unnecessary.

Note that nilfs_btree_get_block() does not currently take a path
argument, but how about passing the parent node's key to it for
checking purposes?

Also, regarding the check for whether keys in the B-tree node are
sorted: instead of calling nilfs_btree_node_get_key() for both keys in
each iteration, could you reuse the value of the previous key?

While the compiler might optimize this, failing to reuse a variable
that has already been accessed feels a bit counterintuitive.

One more minor point: since the conditions like "if (key1 <=3D key2)" is
an exceptional error case, please wrap it with the unlikely() macro.

Could you please revise your implementation based on these comments?

Thank you.
Ryusuke Konishi
