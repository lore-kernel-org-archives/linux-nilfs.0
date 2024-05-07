Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F234A93C
	for <linux-nilfs@vger.kernel.org>; Tue,  7 May 2024 04:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715055044; cv=none; b=nxDvV8VUGDpRpW8nMP/slZz4B+QHiRAnzOFVc4pESuOJXWb+hD7oqUu3WY2TqX0oAst66G9ZaY+4rTvsDcCmEPc5La8JVOyGP57w+BnRAcVO/nHjGu5FeQaBilKR4/IQfH1zopHh8OyBT9VnjD5m83ns+9GHOVXCORnVecOHvdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715055044; c=relaxed/simple;
	bh=djfMokgCN7xYdNoFaFLoZx98W4sX9kstkC12sn3Z5ao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CaMMEYiqNc7pmMibjG/D6lmPBKnH8gbt5JWgjpVlS2oAJgdK7wZcQEy3x4mMQh5i8lDo0lsk7l+7mgctJB4syeks05AiHOnZ3EC+N9mIGpbr3FZPm73hsyMHQ0rCRDUHRvxGTyZpyZ7/9eAUbcQt/ExEG4qW+qrR80DS+iOUl+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LVNPJIjN; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LVNPJIjN"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-51f1bf83f06so3230884e87.1
        for <linux-nilfs@vger.kernel.org>; Mon, 06 May 2024 21:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715055041; x=1715659841; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5rs1S1yiZ960Su9L9zFfNLGBfNHQxnRxZWbYRyHpowM=;
        b=LVNPJIjN3ruiqWFmskM3j0gkAh2krBUBTkNZiyp0uyo1WlC3f0209SBlH72aSRJTOG
         hIvkhZCUle0EHAUE0cXoQfVLXxMs1ZXJh7DpYD1mC4bVw4qp5x0ec4k64j1wfDEJcNSS
         ElXiA7LPj87jqxrJ3WpJIQKoDf6n5Gc+DP3lSArklnOWCsHX4Sb3Pf2JaQ3JomF16o2V
         XqmWX69rlD0250ipHUejqKBKX08huZSDtnjtkn1tPznWFo7DviJByjrObvqNBKej4gaK
         XVo78j530G7lMUDb6AgUFemDQmxnVbcN1FDLzN7PVuGR2RhOo2X487O8BC/yFt25c+8N
         ZDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715055041; x=1715659841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5rs1S1yiZ960Su9L9zFfNLGBfNHQxnRxZWbYRyHpowM=;
        b=qw4uQGwsbKxYT/zrz08uyKSZDvtrytB+V2KPEJOjdZSr1CEBadcZEW/eRp+cmrgYNW
         dKYG8pCZNUtTPHcfyB+onhkpcCWUIRHG7fvs5AoK0rg9zNFiqMHHepib0tURvnWAtjZ5
         5N63WMuAsw2lL8yXX84V8N8tHxKpFY3HIIBfVUzAgin7/LvxbZhrCf30CiIp+xEwI9dp
         JjtDqlVYE4nFbHAKa+syI9BSpf4nsc7AOI20fPFfowrxZJNOgBZvlOz3lTu2WSWDOKU8
         /hmQnbDOXmNn13JMbwowci8HzVkPGcqALE5QYc8uXxl4G6YWaIrJcPPkwviBCncDhvQP
         3UZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0Y6BWl8HbE/GriqhiOnFKyFxV6k7nK+9KlfI68ChVLv1y2QtYnfTitBum6PxZ317IPUi7N3hCbJxyEjejvvQy+P8H6ufQbpuvHDE=
X-Gm-Message-State: AOJu0YxxvEp1U7ehrH/QP78OxcywdP5pFqmAd3dkVp47Exv0MyxmhZkZ
	sRKdMbIuqyUIQ9Vou8EKWSDtRGTSy8WeP7mvm6cQ8BSM6PjVkyL9e8QrdGcoAtte+FPJ7nNtblE
	PeRM0dXotpk41R6TCYS2g2sfmg1g=
X-Google-Smtp-Source: AGHT+IElwm0NF5vRZ3u+Zhal96mlnrZznoU61ILy7ltnvJ8/TnWERmRbboornHhobT+nZjNQxvP5tPwr7w+0IP630RQ=
X-Received: by 2002:a19:e017:0:b0:51d:3b87:70a4 with SMTP id
 x23-20020a19e017000000b0051d3b8770a4mr7353394lfg.36.1715055040374; Mon, 06
 May 2024 21:10:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240506232437.21264-1-bvanassche@acm.org>
In-Reply-To: <20240506232437.21264-1-bvanassche@acm.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 7 May 2024 13:10:23 +0900
Message-ID: <CAKFNMokz-zJu95hu42YVC6P5VJCJq-DStPWHuWpOkHwiq_RduQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: Use __field_struct() for a bitwise field
To: Bart Van Assche <bvanassche@acm.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 7, 2024 at 8:24=E2=80=AFAM Bart Van Assche wrote:
>
> As one can see in include/trace/stages/stage4_event_fields.h, the
> implementation of __field() uses the is_signed_type() macro. As one can s=
ee
> in commit dcf8e5633e2e ("tracing: Define the is_signed_type() macro once"=
),
> there has been an attempt to not make is_signed_type() trigger sparse
> warnings for bitwise types. Despite that change, sparse complains when
> passing a bitwise type to is_signed_type(). It is not clear to me why.
>
> Follow the example of <trace/events/initcall.h> and suppress the followin=
g
> sparse warnings by changing __field() into __field_struct():
>
>  fs/nilfs2/segment.c: note: in included file (through
>    include/trace/trace_events.h, include/trace/define_trace.h,
>    include/trace/events/nilfs2.h):
>  ./include/trace/events/nilfs2.h:191:1: warning: cast to restricted
>    blk_opf_t
>  ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
>    degrades to integer
>  ./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
>    degrades to integer
>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Reported-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Closes: https://lore.kernel.org/all/20240430080019.4242-2-konishi.ryusuke=
@gmail.com/
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/trace/events/nilfs2.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.=
h
> index 8efc6236f57c..8880c11733dd 100644
> --- a/include/trace/events/nilfs2.h
> +++ b/include/trace/events/nilfs2.h
> @@ -200,7 +200,11 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
>                     __field(struct inode *, inode)
>                     __field(unsigned long, ino)
>                     __field(unsigned long, blkoff)
> -                   __field(enum req_op, mode)
> +                   /*
> +                    * Use field_struct() to avoid is_signed_type() on th=
e
> +                    * bitwise type enum req_op.
> +                    */
> +                   __field_struct(enum req_op, mode)
>             ),
>
>             TP_fast_assign(

Bart, thank you very much for all your help.

This is a bit technical and may be debatable.  But this can actually
eliminate the sparse warnings.
So I'm thinking of having Andrew pick this up instead of my patch
currently pending in the mm tree.

If anyone has any objections, please let us know.


Thanks,
Ryusuke Konishi
