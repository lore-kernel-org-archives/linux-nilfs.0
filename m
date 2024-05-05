Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B4A2D60A;
	Sun,  5 May 2024 19:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714935919; cv=none; b=asAX3MadYgz07HdzOiMXqfGPOhXPHkL2kB0bFjGzKMwkJDsfEItW64caoe7WIPTsY3lHQRkhdfT8jWfsPI+w93nTCfoW5BLiQ57VzPvSTTIaidlX+u8dEoCkvJa9QaoviFxF2j3f2OOs+yZOuXezVvj5NvJKkmcBhTZhf5s2GRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714935919; c=relaxed/simple;
	bh=l4a0ArGONDNzKNTIOsu12f4Y+6X95zHt+Leq4K2WG6c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HYbPDeWNF8vF8RYQoTL1LnNxtQyG55gQ3C5m3xy1yn68j9euzpeY5MYpryLcZ2igDxVxPuFLtJ24Sbbh2/KkiIXrtGz8sxXRPlSSwQthhRko5y/4Vuludw//8AlJ+Q7Fcuv7KUn4+S8+HTGp2Qq6askkwPdLlz8qI2c1jBzUFa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jDU9M3h6; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDU9M3h6"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2e0b2ddc5d1so15837541fa.3;
        Sun, 05 May 2024 12:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714935915; x=1715540715; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wad+9JCJl3oXkEa3SET7EwhW1F0CMBi3uJ0HqvgbGl8=;
        b=jDU9M3h6KZx1n8RoViB/syh+uBulL8EQdEmU35WmCJueHcb49xWodtMqS6JBxqxNDA
         l3vz3nJJjf+tlDnHELBidMbBRgN+Duhu5Hncw7/Ir9aqX8slilDETf5B3Yw3DZQpyTl6
         QWA5Kupq9tmYujdB0cFHZ8+GJQlN5dich/hFDCRVG7XVAJUPhifasLXvLkEEHMJuqTey
         4xsEu41pbnzaBknZG1GjrGHEdCK0Nlg+cIN6gHNMOXQ8lsHmxa7QM9WRfLO5TKQhfkth
         ju2NoouVXr2qXsle6PvndxCv139m2ubEiBF0bkk2vFqSDO6KPVgduCIseGHNGd4eoMC0
         cFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714935915; x=1715540715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wad+9JCJl3oXkEa3SET7EwhW1F0CMBi3uJ0HqvgbGl8=;
        b=KPCs6LRzJGUdThqLU0hpFIDOLLH1+7O1aEeEObHFfIOnPz5MHy9PQSOAQxnqmZLJVq
         Lv9wpTn4WNK1rE/pEQvsKl+RxvUkhDOoMJxnzA0egkaq4Im723Dft6Z2eze4uYW8n9ex
         IJoK2l80nRLEWH6eDbHTR9jTEejrYR6uThrZ1Y3YAL1PNYCdMgCnLKDTzNOb8Op5YRQl
         eVYI/a9dnbGvm+q5QVMTB9zjGzvCE9a6I3g1f5tsEosNK+KCF1sbKtMMdomJJLP/J35o
         1LBORrmQS0xiwCx+GtP6uN7aTMajKDUe+adYvTm5qhOdF8GwB3zppbCHYDfjEfsKPq2/
         w3WA==
X-Forwarded-Encrypted: i=1; AJvYcCVacH7FIEf8fCyVjCehL7eNGzTWLytaWus08y6zW865UBKheePyIiCsNFU9HL7w2bg64S8t+1zd+8azeyNPXHicWUGkKwlJyKePsHwlsAeCDtQuUMQMzOM+s7vcMsrblOBn4+AXH7TtnFY=
X-Gm-Message-State: AOJu0YwKCkCo+Qnvh5NwCsdqVPw4chXZcqkGWx4r0B+MdQWmmJpvgvt4
	UOvHuLfGewDszzmIFO1vYCeIhaWto0zPZjWo5TONWKJEC5oI9bVqITzGNg0u0rjlrVi2dBGBqSD
	irViTrjdZMh/2kL4MCfZeMg29epw=
X-Google-Smtp-Source: AGHT+IHQGAH9I3d2xpvxt1OWJ5+/3R+Ok5+gszUhaQAR42Sc2pt/klNvVUHtO+OLHlwZ9WDp/4ixRmmmQ7JuEPr1Bbs=
X-Received: by 2002:ac2:5322:0:b0:51a:f362:ab30 with SMTP id
 f2-20020ac25322000000b0051af362ab30mr4989779lfh.7.1714935915272; Sun, 05 May
 2024 12:05:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240430080019.4242-1-konishi.ryusuke@gmail.com>
 <20240430080019.4242-2-konishi.ryusuke@gmail.com> <650ed9f6-fa50-4a3b-939d-633f9e389137@acm.org>
 <CAKFNMomCzNMU0tjLkEchr=GQwSVW1zr1GAq7vUToeOvX-M3eVg@mail.gmail.com>
 <CAKFNMo=rkHF6urydfDbcvTbGzUEHmsTudVMm517pTE32vzqiwA@mail.gmail.com> <32e6621b-cbd9-42be-8626-49c12c25f139@acm.org>
In-Reply-To: <32e6621b-cbd9-42be-8626-49c12c25f139@acm.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 6 May 2024 04:04:58 +0900
Message-ID: <CAKFNMokSLHrB8jyGuNH-HBqcrAmJ5-SFwu-sTgt30X2j+=KykA@mail.gmail.com>
Subject: Re: [PATCH -mm 1/2] nilfs2: use integer type instead of enum req_op
 for event tracing header
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 5, 2024 at 9:47=E2=80=AFPM Bart Van Assche wrote:
>
> On 5/2/24 12:01 PM, Ryusuke Konishi wrote:
> > If you haven't given up yet on solving the underlying problem, I would
> > like to withdraw this patch.
>
> Has this untested change been considered?
>
> diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.=
h
> index 8efc6236f57c..67fd2e002ca7 100644
> --- a/include/trace/events/nilfs2.h
> +++ b/include/trace/events/nilfs2.h
> @@ -214,7 +214,7 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
>                       __entry->inode,
>                       __entry->ino,
>                       __entry->blkoff,
> -                     __entry->mode)
> +                     (__force u32)__entry->mode)
>   );
>
>   #endif /* _TRACE_NILFS2_H */

No, I didn't think of that.  There was no warning in TP_printk()
declaration of the nilfs2_mdt_submit_block trace point.

If you suggested this as an alternative idea, unfortunately the
following warnings are still output:

  CC [M]  fs/nilfs2/segment.o
  CHECK   fs/nilfs2/segment.c
fs/nilfs2/segment.c: note: in included file (through
include/trace/trace_events.h, include/trace/define_trace.h,
include/trace/events/nilfs2.h):
./include/trace/events/nilfs2.h:191:1: warning: cast to restricted blk_opf_=
t
./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
degrades to integer
./include/trace/events/nilfs2.h:191:1: warning: restricted blk_opf_t
degrades to integer

I also tried typecasting on the declaration header side of event
tracing, but so far, the sparse warnings don't go away except for the
patch I first proposed.

But, better suggestions or solutions to the underlying problem are welcome.
(Again, should we put the patch on hold?)

Regards,
Ryusuke Konishi
