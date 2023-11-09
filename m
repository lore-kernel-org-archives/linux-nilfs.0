Return-Path: <linux-nilfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D39C4332F
	for <linux-nilfs@archiver.kernel.org>; Thu,  9 Nov 2023 14:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjKIOWu (ORCPT <rfc822;linux-nilfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 09:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjKIOWu (ORCPT
        <rfc822;linux-nilfs@vger.kernel.org>); Thu, 9 Nov 2023 09:22:50 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB752D77;
        Thu,  9 Nov 2023 06:22:47 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id a1e0cc1a2514c-7bae0c07007so322991241.1;
        Thu, 09 Nov 2023 06:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699539767; x=1700144567; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9TmqeanMEhaszCYSFZusF2dTuvYMgkzIuIC9fGlwnw=;
        b=KRl30SiY8HnEe2Z/sPsf9QA/j7k8N8SFzMTLzueno4QGfnu8Iy1GaeFCGvU4u11Y9m
         CzLZzjVGYP9XXW0QmvH+4b67QYW6nqji8XmF9zzZ620tF38w8IbpSVKUg1Z9oW7eF9pR
         B7UNCQUUhfLHb9Srd92iYcuERIEYlNFIZk88xYFLuM7cBBIeUhTaKLvgX+daEnNiicbT
         P7PEY9aoayXNa7RS2ByjbQkx19LZg7II9d3BGDtOA3veFq7SK5smJOOSCbN4kG5tzeXk
         QOPy04ZbksCWXj6maMNjiAvqqIie1//SV7ARtZ0QEjiIqadTKAPVO2ZdNZ8gd+/wXj5f
         PxrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699539767; x=1700144567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9TmqeanMEhaszCYSFZusF2dTuvYMgkzIuIC9fGlwnw=;
        b=I0oRxoyLciIx19W8mJ6BgAZUDLg+iSYnj9juQiNkhr9Mf+03p7ITzgTDjC8KLYgSAJ
         M7s/SjQKcMfMLBUIZVmEcgCmt/FvDqchEFt1EliOT+mWEcqfioB7w+V74as923awv6bY
         a+Zr+hSIetw8bCSyVrrVI2+DxW8mG6jkknYrdNaE0uDCYazm0pJouG6xAZSq8XCBqeLb
         QVmTa6xE4/HEz6sAio4ENMrmccyvDxRT2BynXUHFde61+A/UXN3VpEBLWk9uBNWUiHUd
         S9Q99QAhp6iNVndV2TbcfcZglsrvUJgoyeshvHY4E3o6TfBQ0LnKTvL5FYOzWDARiTL1
         s7Ow==
X-Gm-Message-State: AOJu0Yx2NRUnSpQ2LSMK46cv9QNiZ+oDTh3stbxS1LrgV2D17WAfpDQV
        lE/G/0bwgYWZT2WtdSC2Mz07063LHl+gLAZ3mYHCJfpQRrc=
X-Google-Smtp-Source: AGHT+IEVJEjsWBe26eNo6UHuMKjyG2cIfpieYDtThgh0PsaxLEtE1unKJyTaNHLPeBihVWJS+iehXNvC2/9lCafLkzA=
X-Received: by 2002:a67:e14b:0:b0:45d:c4d1:5bd8 with SMTP id
 o11-20020a67e14b000000b0045dc4d15bd8mr4134299vsl.0.1699539766696; Thu, 09 Nov
 2023 06:22:46 -0800 (PST)
MIME-Version: 1.0
References: <20231106173903.1734114-1-willy@infradead.org> <20231106173903.1734114-12-willy@infradead.org>
 <CAKFNMomYhk2D6F9=mee4=H_QtvrfWYYSsiXrKjCms8pz61xhAQ@mail.gmail.com> <ZUzgjxJoKYP9KIx0@casper.infradead.org>
In-Reply-To: <ZUzgjxJoKYP9KIx0@casper.infradead.org>
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date:   Thu, 9 Nov 2023 23:22:30 +0900
Message-ID: <CAKFNMonjA2OyZRju4VRRrdKD6XvvD-cgLFH1u53M+wGKUNL2Kw@mail.gmail.com>
Subject: Re: [PATCH 11/35] nilfs2: Convert nilfs_page_mkwrite() to use a folio
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-nilfs.vger.kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org

On Thu, Nov 9, 2023 at 10:37=E2=80=AFPM Matthew Wilcox wrote:
>
> On Thu, Nov 09, 2023 at 10:11:27PM +0900, Ryusuke Konishi wrote:
> > On Tue, Nov 7, 2023 at 2:39=E2=80=AFAM Matthew Wilcox (Oracle) wrote:
> > >
> > > Using the new folio APIs saves seven hidden calls to compound_head().
> > >
> > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > ---
> > >  fs/nilfs2/file.c | 28 +++++++++++++++-------------
> > >  1 file changed, 15 insertions(+), 13 deletions(-)
> >
> > I'm still in the middle of reviewing this series, but I had one
> > question in a relevant part outside of this patch, so I'd like to ask
> > you a question.
> >
> > In block_page_mkwrite() that nilfs_page_mkwrite() calls,
> > __block_write_begin_int() was called with the range using
> > folio_size(), as shown below:
> >
> >         end =3D folio_size(folio);
> >         /* folio is wholly or partially inside EOF */
> >         if (folio_pos(folio) + end > size)
> >                 end =3D size - folio_pos(folio);
> >
> >         ret =3D __block_write_begin_int(folio, 0, end, get_block, NULL)=
;
> >         ...
> >
> > On the other hand, __block_write_begin_int() takes a folio as an
> > argument, but uses a PAGE_SIZE-based remainder calculation and BUG_ON
> > checks:
> >
> > int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned l=
en,
> >                 get_block_t *get_block, const struct iomap *iomap)
> > {
> >         unsigned from =3D pos & (PAGE_SIZE - 1);
> >         unsigned to =3D from + len;
> >         ...
> >         BUG_ON(from > PAGE_SIZE);
> >         BUG_ON(to > PAGE_SIZE);
> >         ...
> >
> > So, it looks like this function causes a kernel BUG if it's called
> > from block_page_mkwrite() and folio_size() exceeds PAGE_SIZE.
> >
> > Is this constraint intentional or temporary in folio conversions ?
>
> Good catch!
>
> At the time I converted __block_write_begin_int() to take a folio
> (over two years ago), the plan was that filesystems would convert to
> the iomap infrastructure in order to take advantage of large folios.
>
> The needs of the Large Block Size project mean that may not happen;
> filesystems want to add support for, eg, 16kB hardware block sizes
> without converting to iomap.  So we shoud fix up
> __block_write_begin_int().  I'll submit a patch along these lines:
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index cd114110b27f..24a5694f9b41 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2080,25 +2080,24 @@ iomap_to_bh(struct inode *inode, sector_t block, =
struct buffer_head *bh,
>  int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned le=
n,
>                 get_block_t *get_block, const struct iomap *iomap)
>  {
> -       unsigned from =3D pos & (PAGE_SIZE - 1);
> -       unsigned to =3D from + len;
> +       size_t from =3D offset_in_folio(folio, pos);
> +       size_t to =3D from + len;
>         struct inode *inode =3D folio->mapping->host;
> -       unsigned block_start, block_end;
> +       size_t block_start, block_end;
>         sector_t block;
>         int err =3D 0;
>         unsigned blocksize, bbits;
>         struct buffer_head *bh, *head, *wait[2], **wait_bh=3Dwait;
>
>         BUG_ON(!folio_test_locked(folio));
> -       BUG_ON(from > PAGE_SIZE);
> -       BUG_ON(to > PAGE_SIZE);
> +       BUG_ON(to > folio_size(folio));
>         BUG_ON(from > to);
>
>         head =3D folio_create_buffers(folio, inode, 0);
>         blocksize =3D head->b_size;
>         bbits =3D block_size_bits(blocksize);
>
> -       block =3D (sector_t)folio->index << (PAGE_SHIFT - bbits);
> +       block =3D ((loff_t)folio->index * PAGE_SIZE) >> bbits;
>
>         for(bh =3D head, block_start =3D 0; bh !=3D head || !block_start;
>             block++, block_start=3Dblock_end, bh =3D bh->b_this_page) {

I got it.
We may have to look at the entire function, but if this change is
applied, it seems to be fine, at least for my question.

Thank you for your prompt correction!

Regards,
Ryusuke Konishi
