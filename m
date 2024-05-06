Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660A6EBB;
	Mon,  6 May 2024 21:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715030269; cv=none; b=tnFAEuHvILORU2BtyDpDQd+bFX5vaQqUHgzRKTU7TN/jZRU/AjHG1uDtw1Tcac35WJd5pczzYt7oZWn+9rtycXEJeqgt3IDJLB+lsQ8GQcn5+HtymF2+OdFznCL1rLVsMTAczNBpeT/1hm4hexOjJ3I0Ij9MthPdP39ofKXtP3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715030269; c=relaxed/simple;
	bh=e8VgMeSCZ/OulgKMvTpaka2RvvG3NXalkKCqK6iBpZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uSxfEFIMmK7lkn8MWnCAqUHJa3khr6UHxq/2QmHXR7LtbZpZoeS1X3Owp8XQ6BEEpU4BBLKWyKBQMKoo+v4oTogXM7KT/quEWOsiVQJyJH7C1Ud/aEbBp2XFMVbxlGnS7c9TnSz3uUniohHBWYqOqmvqGnnAFyCt4yt0VOtuAgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IHyXoysM; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IHyXoysM"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2e1fa824504so35161431fa.0;
        Mon, 06 May 2024 14:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715030265; x=1715635065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3qTQN/g2qZ283tv4UTy5xindxNuRSAyapuUJnKhnb3Y=;
        b=IHyXoysMbRNpgRArLQUjO6SVES4uF0NzeaZqYQL9Rjit6LWtqcatr/p3OM6Hv74HYv
         DOhS5dhrg5Gg9epkp1HOgH5qeZ2DXKNMIs49LRaYBttfmp8THyAsTAvDEyxUFocf8waY
         V9vuPNrhJmNnReMsHTwj1dEKudVqlTnVn7fkxppOkCDeXTDr7FAbkfcGxm37/HYink0J
         rua+TTeRGlgicwEbzHs4YjSqcF7Ai9duw9Q0x/HdHXxlEBRRM+HuXcuXgVcuox45KcYY
         s5Dw0/8OoSUIvRf8GA/KxIxXj4KE6QRgqVOizr4AXcHDNe2CSIxmwqcRXunMCcYdNp9H
         cfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715030265; x=1715635065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3qTQN/g2qZ283tv4UTy5xindxNuRSAyapuUJnKhnb3Y=;
        b=OKcnIsltaXW1PHvxcd8tDejL6tgXojdZh6vv9gkilL+kK+q01RowPl/BE2sh5qWyYy
         vukcFJVQMtb1N1RE2fBnXrm7BRzhyiLKmGPPoBO32xkjRRchdIcatxCp/v7IBE162jky
         g6nmw5rRhtJFlnjslAobffXbIzDNp6FYoCYrRfuLPVM+nRbM9kZzIUa5dxtgpc3oAqH+
         /P6sipCY17gZBS1WjYBjhI8BZgfh70udCypqbfwB+cmBREAZi6My9wwsYadvUNY8zkRc
         oSHkfED5tW767LSD6I934XK/pZgzuNpHr9lVzBxFRmiKhdP8o1clyLd1ACUlaGoRQyqj
         jolQ==
X-Forwarded-Encrypted: i=1; AJvYcCVheQJAnj7VHB+hEwqzUWA9uZH5YfJBm4yluyHy7fmzSpZnbszSLPHvdCc4b1qnb++mC3yprRrHaZdd5M9LsuuW4beHkgD3B06/Tn7x4AQNdFESgUavRqjyno/T4hxBiqcDmhqEQIfYi0U=
X-Gm-Message-State: AOJu0Yw2LFkMxngZaJ/6UPjvakousZQ2v7PDk/1tO/3SgFln6soH8Y4g
	4NLCqwtGgjC4Ri5JbmOS9IaiS8uzzFHCIPhe0Y0pZhRyktYEbeGfgQ270sCW5LjeUs55NSyufEs
	w/o/pnOfhYnK5hWVQqm/H6KkrfaNNjLQC
X-Google-Smtp-Source: AGHT+IHyv+lzt1LK2LFK/ZLOsWT7wOGj2Kdf+c3xpAX3dL1/auTk2ttKMEncm4x/ZiJ7dAWS31RcCI8iJphL6ktCS1s=
X-Received: by 2002:a2e:9059:0:b0:2e3:3eaa:ac92 with SMTP id
 n25-20020a2e9059000000b002e33eaaac92mr2731275ljg.53.1715030265230; Mon, 06
 May 2024 14:17:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240430080019.4242-1-konishi.ryusuke@gmail.com>
 <20240430080019.4242-2-konishi.ryusuke@gmail.com> <650ed9f6-fa50-4a3b-939d-633f9e389137@acm.org>
 <CAKFNMomCzNMU0tjLkEchr=GQwSVW1zr1GAq7vUToeOvX-M3eVg@mail.gmail.com>
 <CAKFNMo=rkHF6urydfDbcvTbGzUEHmsTudVMm517pTE32vzqiwA@mail.gmail.com>
 <32e6621b-cbd9-42be-8626-49c12c25f139@acm.org> <CAKFNMokSLHrB8jyGuNH-HBqcrAmJ5-SFwu-sTgt30X2j+=KykA@mail.gmail.com>
 <5a1ebb30-d6b8-4f1f-9324-4d7b12e1be21@acm.org>
In-Reply-To: <5a1ebb30-d6b8-4f1f-9324-4d7b12e1be21@acm.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 7 May 2024 06:17:28 +0900
Message-ID: <CAKFNMokwnkku4tHcaAJPmFaBONZqoTMOLtKh_A7kcjzoxj3QZw@mail.gmail.com>
Subject: Re: [PATCH -mm 1/2] nilfs2: use integer type instead of enum req_op
 for event tracing header
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 7, 2024 at 2:26=E2=80=AFAM Bart Van Assche wrote:
>
> On 5/5/24 12:04 PM, Ryusuke Konishi wrote:
> > I also tried typecasting on the declaration header side of event
> > tracing, but so far, the sparse warnings don't go away except for the
> > patch I first proposed.
>
> How about this patch?
>
> diff --git a/include/trace/events/nilfs2.h b/include/trace/events/nilfs2.=
h
> index 8efc6236f57c..b1a364a33a62 100644
> --- a/include/trace/events/nilfs2.h
> +++ b/include/trace/events/nilfs2.h
> @@ -200,7 +200,11 @@ TRACE_EVENT(nilfs2_mdt_submit_block,
>                     __field(struct inode *, inode)
>                     __field(unsigned long, ino)
>                     __field(unsigned long, blkoff)
> -                   __field(enum req_op, mode)
> +                   /*
> +                    * Use field_struct to avoid is_signed_type() on the =
bitwise
> +                    * type enum req_op.
> +                    */
> +                   __field_struct(enum req_op, mode)
>             ),
>
>             TP_fast_assign(
>
> Thanks,
>
> Bart.

Great!  This patch removed the sparse warnings.

It passed multiple build methods and did not break either tracing or
nilfs2 functionality in operational testing.

I never thought of using __field_struct for enum type, but looking at
the definition it looks like it can be used to just avoid
is_signed_type() without any side effects.   So, this patch looks
better than mine.

If you don't mind, could you complete this change as a patch by adding
a commit message and related tags?

Thanks,
Ryusuke Konishi
