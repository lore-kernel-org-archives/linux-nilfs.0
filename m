Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AE912F580
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Apr 2024 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713548498; cv=none; b=fOJop424DP72XWDFb6li0rlkzYDU2OuNpcWTnY33Ig2li5ESzRKK83qWdZdg/GT8EpJ4ZqaHEiHtT7robt/ne1kHdGC5AibkBKWFuXqJZKCHg+02HzGoqbbLGE5MKBgPL9hJS2YJGOwOKGQkmCycxi+IJkewG5mmkEkLPGQCbhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713548498; c=relaxed/simple;
	bh=meayex/aRSC67w0W6jE3TeAWwLLOjYxVi9T1ynyRsZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RO/c6+MHDjMs6SdVQY17CeZvGRMfukf/sM6PQ/J6CmPLXy2n2zHP0WDYNoEm/hDiZgUQiacmmtHho+AIuggseGXlV5mr8skcH5uD9E0H0OgodiLKMgnYIqSIqN4QxNLOZ18PJzH498ML9jLMrAOsaucio6KWziD101BtLyetrjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aYDgNqma; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aYDgNqma"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d895138ce6so34086831fa.0
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Apr 2024 10:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713548494; x=1714153294; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYHYMEkbNQ+pcIZZQCVmIkUdJUkeyeWFZ7IRUDBiagc=;
        b=aYDgNqmaW4UWqIz/sBasZCC7B98t0g/rd6m/rSgpo1ray+twXfLOAq7qOJOdd6uegg
         iVYTEf5I1OofASyE7Oej5/oHlisFUJrqOuBXuupess3jzSasJVDhlknz2fBEBqjPqcnB
         yF9pJbSjMYLaOjYaKfo8qB6+AQ4WtJSiKajjWHtptydW+It/bJBlkq2Vh9XwOv7wchOd
         FnvEVcS2Pz1PEmozfRcQhAybGfRGEH+v1oPV3dd+3JwaSdLeUpW+1redYiY6ce2qr/or
         kob/WtMz1Bu79Bzv7S+W1lXKUM91JbfNVHFEIWTl14e69GGZp6sK2ONiwbgCl5O4uElV
         foPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713548495; x=1714153295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vYHYMEkbNQ+pcIZZQCVmIkUdJUkeyeWFZ7IRUDBiagc=;
        b=gOuMp6RVFWm73cJGo0sJJaxxVmcUus4O3mE2StN9zkIPMlJ2Hed90ZWJuqdtxSOn9z
         BkOzPN5+EXhoDlhLMtpgUhcroKPDCu3emcpKHWGlUJD5QSOB5aUfHDTSEqgRzhO9GZ5E
         pxsEkHwRHso6Ct+F3rGaZCMG3X+EqBOIVNHUCbr2pC0EVqo9aL/Qhm3feQ8NZse4HDRF
         aAAOEDYlUA7IP4WU0BfEDJEjGU6XLn2J86KI1AcdG+Yjc3UlhHcIETy9F74/b4lR6ZS5
         l40qsSG6Pl3gLfs30jqCf5h8Oh+2pLJ8Rl8PJqfHEgLOsDToNn0uUk6Px7WAgsvuiZE9
         73tA==
X-Gm-Message-State: AOJu0YwC290gvXubgYa6X39VDsEM6kn5z371rUX5u4ipll5UdLnf7aFT
	1VtTGHwAo2M/aixchg7fQX9tUMkz5PqQ9l1Jmbo3FnBpGOXL/D5tZNi+Ws9obziPPRP8kgKUJOo
	1Q0qGDK3Ak/0aTd6C3njyM6+oO+aVZi7C
X-Google-Smtp-Source: AGHT+IGJFgVGvRng35yFsLhzoCRxt1DSG+klLLffoXS/9dK3j2Pa8johlWMl2AIQNnL2qZ6hmRB0EW7gKeSsDERRoxs=
X-Received: by 2002:a2e:b947:0:b0:2dc:ae40:db95 with SMTP id
 7-20020a2eb947000000b002dcae40db95mr1569363ljs.52.1713548494325; Fri, 19 Apr
 2024 10:41:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <bbac8195-cf8d-1685-9038-9d45cb9865d7@inetstar.ru>
In-Reply-To: <bbac8195-cf8d-1685-9038-9d45cb9865d7@inetstar.ru>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 20 Apr 2024 02:41:17 +0900
Message-ID: <CAKFNMokqsbO1wfCiiWB=7gXrHoscS=Hz4c6GhFB8VGOeHSYxzQ@mail.gmail.com>
Subject: Re: I'm trying NILFS2 in kernels 6.6.12, 6.7.12, 6.8.4
To: Veter Kamenev <nilfs19@inetstar.ru>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 20, 2024 at 1:08=E2=80=AFAM Veter Kamenev wrote:
>
> Hi folks!
>
> I learned about Nilfs2 many years ago and was impressed by its capabiliti=
es. The idea is brilliant!
>
> But due to glitches, I returned back to reiserfs3, which works like a cha=
rm, although it will be removed from the kernel in 2025.
>
> Now, after several years, I decided to return to Nilfs2, hoping that the =
bugs have been corrected.
>
> To my greatest regret, I received errors in all kernels and the system we=
nt into read-only state.
> Luckily I didn't lose any data.
>
> The texts of the errors will be below in the letter. In this regard, I ha=
ve 2 questions:
>
> 1. What is the reason that after so many years, Nilfs2 still cannot work =
stably?

Hi Veter,

I've been fixing bugs reported by Google's automatic fuzzing tool
called "syzbot" (particularly intensively over the last several
years), so I believe the current version is pretty stable.

However, since this activity is still ongoing, it is not possible to
say that there are no bugs.  Fortunately or unfortunately, a few major
bugs have been recently been fixed.

> 2. Are the errors I sent corrected? If fixed, then starting with what ver=
sion of the kernel?

I can't say for sure due to lack of information, but the logs you
reported appear to be symptoms of a high impact mmap regression that
was fixed within the last three months.

Assuming the problem occurred in v6.6.12 of subject, the following
important fixes have not yet been backported to this version,
including the mmap regression fix.   Regarding stable-6.6.y, versions
below v6.6.24 (latest) do not include all important fixes.

$ git shortlog v6.6.12..v6.6.24 fs/nilfs2

Ryusuke Konishi (5):
      nilfs2: fix data corruption in dsync block recovery for small block s=
izes
      nilfs2: fix hang in nilfs_lookup_dirty_data_buffers()
      nilfs2: fix potential bug in end_buffer_async_write
      nilfs2: fix failure to detect DAT corruption in btree and direct mapp=
ings
      nilfs2: prevent kernel bug at submit_bh_wbc()

On the other hand, v6.7.12 (latest) and v6.8.4 (not latest) included
all of these important fixes.

As for the logs, all messages in the logs are warning and are harmless
in themselves.  However, they are often produced due to the influence
of other problems, so you need to be careful in that sense.

> Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty page: offset=
=3D2579136512, ino=3D3

This message indicates that there were changes that could not be
written to disk and were discarded during unmounting, and is likely to
occur when the file system is degraded to read-only.

> Apr 14 15:10:24 MainPC kernel: NILFS (dm-5): nilfs_get_block (ino=3D55694=
): a race condition while inserting a data block at offset=3D0

This message indicates that an unexpected race occurred when writing,
but the bug that outputs this message has been recently fixed, so it
may be that.  Of the patches listed above that have not been applied
to v6.6.12, these are the the following two:

      nilfs2: fix potential bug in end_buffer_async_write
      nilfs2: fix failure to detect DAT corruption in btree and direct mapp=
ings


If the environment in which these messages were output is v6.7.12 or
v6.8.4 and you think this is not the cause, it would be helpful if you
could report the situation in more detail.


Regards,
Ryusuke Konishi
