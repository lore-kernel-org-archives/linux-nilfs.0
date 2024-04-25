Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E338414A82
	for <linux-nilfs@vger.kernel.org>; Thu, 25 Apr 2024 08:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714034142; cv=none; b=QxxfyQqTf7asplAThoI1vM4jVgCUNKV1QL7pc6ZFfffQX7eCbPI1VjHHLEXIkp+7XoJFLylgpR+HWeMis0FBee/KQxpEJcMENyScTzMVWTIVUBls/S3HUVWeQD13dGW9jQoP5MXTqUEE/xLmcpFgmoFb59g7+1qBXmDQ/LgqAgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714034142; c=relaxed/simple;
	bh=fOmvf1OLBwZggp/UVzPO//GW8IXiTz2tl5j3m7q1EAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nnEP8vGhd/CtfNholm/Cn5baCwHGqQyqy89e2zje8pOIeETWYz1ZlaI67rOjCuF+3oUO2Iq9FaXWawV5gpFvqbt1oxDGjc83nqtB4wMGshHKXzdTlgtZkKzlAe4PCABDg6u8/lMEsn7sW30ehCXGmbV8hZwcJY+m4UIsUNvVX/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kCuzDjQb; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kCuzDjQb"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-51ac9c6599bso789859e87.1
        for <linux-nilfs@vger.kernel.org>; Thu, 25 Apr 2024 01:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714034139; x=1714638939; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2fPG+guHYrC0XiylByyEBdhwd/Ja+cgxjsWJHssyU+s=;
        b=kCuzDjQbH5MNl1qAN3uYzGApwUlA1iRfS1ozwIMbYcCbHHjncMy9bumggWowVSrZYV
         D8UxLnCP/GeJXvgcReh946QmE2m/NQfWwz3SQTA7QZRqOPFJstqk8aLoahvjnF8F6Od1
         m0bIh2+vDERKQ6urBHaUW2pjJ4EYoosQnJYiFs/R2rPux7uukxd1S6N3obXHjgJ8sGdh
         dAO7jnyBHi/bB81r8w8elSNNq/OrPGvBKJspsimvfzQ7XwKcudzC5Ix/7TKg2pwHLRNN
         AdSNLZ+d42bK5fzt5tNQ56wdxxhP7mzqQPrBhY0rrfWXEUcKdYbjqhiT6sp633gxfbha
         88yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714034139; x=1714638939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2fPG+guHYrC0XiylByyEBdhwd/Ja+cgxjsWJHssyU+s=;
        b=dwcCiil/OLkg+KQYNdj8arc0tss7ZMee5dLg09jAHgD0N5mNArcVKIMQUF3N+qMtHC
         I4IPrfUqC6iyjLRosUY5kp90jDjWCz/VukvcZ3/SOpukLBDTJuaYjgQ1cM6+0sMNTmNJ
         CpbfXRuYzSqgqa+5U0uVNUlNqpvb/FYCARrR9HVjAnp0ZwcqTz5d29eXUAzrt8MH/Tcl
         oTupH5601hSYXbh0GbHxUCy7glHLpkOkmOVbNGlgiAatjt8J0Q7OZaIyL/enNnFMM8C4
         gAPLKv8i0wYbM5TejOkuQY29ePUqkSd0PJauHSQXyjFcJiEu8IJ4ZU0GJvWDI9vLZAZX
         fcQw==
X-Forwarded-Encrypted: i=1; AJvYcCWY7AYK4ZGusUr6MutEvjev7LbuulLk4bhER7Asg68ct3BctxtwgZlLByNOKJQsmILa4TStlW1ZUEAnfhM5cC8vVOnZ0vkOLEqqG2A=
X-Gm-Message-State: AOJu0YxMSPeqqkF9xNLYifiWi6YWd2QY8pMq0yWGiUkd52RLeGCCiemc
	rcOr72jApT08uvTx0Lgyj41i8PXUKpfDOz9uwfRmAsy0yYPkHfpjq2M7UN19sDLnaebYndQOn+/
	0aV9/w6Q8mgkx1gxTmeMLZxv3j3o=
X-Google-Smtp-Source: AGHT+IGZCCK8cmvAjI3f1Hg/xKrDPzNR11rdNkvlyvvxLx9aHBggBWicRCe6e95/5v7vA5nD82IzJQZsjFR9Rd5QudM=
X-Received: by 2002:a19:9157:0:b0:51a:ca75:9ffe with SMTP id
 y23-20020a199157000000b0051aca759ffemr3760402lfj.42.1714034138827; Thu, 25
 Apr 2024 01:35:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202404251450.rttcxC1o-lkp@intel.com>
In-Reply-To: <202404251450.rttcxC1o-lkp@intel.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 25 Apr 2024 17:35:22 +0900
Message-ID: <CAKFNMonbNQJofL7QjgthShSt9y+BCoZOv+cWstDe5LRpAqsu-w@mail.gmail.com>
Subject: Re: [konis-nilfs2:for-akpm 4/4] fs/nilfs2/super.c: linux/fs_context.h
 is included more than once.
To: kernel test robot <yujie.liu@intel.com>
Cc: Eric Sandeen <sandeen@redhat.com>, oe-kbuild-all@lists.linux.dev, 
	linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 3:48=E2=80=AFPM kernel test robot wrote:
>
> tree:   https://github.com/konis/nilfs2 for-akpm
> head:   69812977939c7895ede256e122284c19d4d83aef
> commit: 69812977939c7895ede256e122284c19d4d83aef [4/4] nilfs2: convert to=
 use the new mount API
> compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009=
708b4367171ccdbf4b5905cb6a803753fe18)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <yujie.liu@intel.com>
> | Closes: https://lore.kernel.org/r/202404251450.rttcxC1o-lkp@intel.com/
>
> includecheck warnings: (new ones prefixed by >>)
> >> fs/nilfs2/super.c: linux/fs_context.h is included more than once.

Thank you for the report.

This patch has just been added to the -mm unstable tree, but I found
another issue, so I'd like to ask Andrew to remove it once, and will
resend a revised patch that also includes the fix for this warning.

Regards,
Ryusuke Konishi

>
> vim +32 fs/nilfs2/super.c
>
>   > 32  #include <linux/fs_context.h>
>     33  #include <linux/fs_parser.h>
>     34  #include <linux/crc32.h>
>     35  #include <linux/vfs.h>
>     36  #include <linux/writeback.h>
>     37  #include <linux/seq_file.h>
>     38  #include <linux/mount.h>
>   > 39  #include <linux/fs_context.h>
>     40  #include "nilfs.h"
>     41  #include "export.h"
>     42  #include "mdt.h"
>     43  #include "alloc.h"
>     44  #include "btree.h"
>     45  #include "btnode.h"
>     46  #include "page.h"
>     47  #include "cpfile.h"
>     48  #include "sufile.h" /* nilfs_sufile_resize(), nilfs_sufile_set_al=
loc_range() */
>     49  #include "ifile.h"
>     50  #include "dat.h"
>     51  #include "segment.h"
>     52  #include "segbuf.h"
>     53
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>
