Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19413156231
	for <linux-nilfs@vger.kernel.org>; Sat, 11 Jan 2025 05:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736573408; cv=none; b=ge/h7MmUILHTFvOpdng776flaC0ZgZ4vxthnAn327NoVyVDxbFG74twYNZhzYNLFgxihMpv1TEIcGTXJT+igK3ixKFoB2sKjeaAs6cOfxNY3lvZFOlQNiF31GTRGn/sZeTD0fkxkBVSoPR2ZRjhiqKDRFb1lw0mZHrdJ8+4Uxuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736573408; c=relaxed/simple;
	bh=E2qqMYK6vAedZNQW09/tdQ8s8PnFjDR8BnBLIdX0ER8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/NDOvtiRtjemlmeu9yYEWrSnoL8xjH1DdmPs0pwOHcUczaMmfoCbhZ6i02XZ1h1yEP08xylJw+Xqq5ET3ljJ/8KHfkPw4YRqEtiLQ6FlLTkNMu+Gt5HYIxa3AzK8wkuIrG2YnD0VXNuhOYAV3y7LSFB3zs+PIcgtZQRN9GHCKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6+8ue6E; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6+8ue6E"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3003c0c43c0so25408611fa.1
        for <linux-nilfs@vger.kernel.org>; Fri, 10 Jan 2025 21:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736573404; x=1737178204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JU2y/CLfnygHmYHPKv/Q4HnMmT5ChSPncFcYph3+5iE=;
        b=L6+8ue6ETdV8O8ONyc2i8JJl+5MvvYVc6F984FSxDxboAG9kwpJJ/c7IusqJqMhI9Q
         cOyp4008zBNBEl5Q5ILxetp5Ui1dH+NGfgZ/UyS/9pWY29dtJktHyssI5BQx5gUkFM66
         CFihOZyiWkGpiV8Vy6hNEpKNHyKgN13cuNY7xpptnuzjCzazAMKNJqQXUBCr/rCXdfko
         bgH0ziLl5B3IfglR1vfnyjPQ9QaRpzgAEulR8vs1Lk7+9iUpXE+RXPPRR99tfSDOqJLK
         TPEShySAFJJ+BoNl5dJfeb6krlesGPEYlAPVZmlIcyeW7KVdZJ0RTgSBjgMpFU0EuShF
         mPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736573404; x=1737178204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JU2y/CLfnygHmYHPKv/Q4HnMmT5ChSPncFcYph3+5iE=;
        b=Bo7lR61tdUucNJddzW090jJy90fqJIZQp4Q5CoxPA6PVD9eLr8QVVmy5ri0yQlZTUZ
         YOV+vvqStsKXQcQ/FeSopM0JqflwDJzyeZxGy3plX+73Kp0PMxmeoIdYuR88B64zbnAA
         QvohKxF7Smva1rhbrh73n6IQ1IxzBSqCFNNk3E9pFgq21lieNzfG9pW7YQ+qHMyJwfAj
         /NKH2FhvgYQae6GIblCp5biZhktKCsvztYSki4w2rP4/7iX7IO81HJIiA+u/F4dS6q/S
         Sm/7mq4AbEVz37Njo4Vy7I+fA72MTwrTLxE8OEXU1WcWJ+0hEXHEyb0I87K14oCLE/lz
         2Clw==
X-Gm-Message-State: AOJu0Ywi6I00aRNwnZoFpsZmmpNr25ehUbIWbcaPoAxpOinsfclpHHVK
	pzyfrh2MAxIp4r2fZTgnk1Pjecw67kkrMw0jYMLghCmk21kOkcw8O3WCEDvxfrv5dBdeGxXGCw1
	mmiEdD2qlI/Qqd9Gh8PSu3c4rzIGYVn/G
X-Gm-Gg: ASbGncuwB4MIUm1WP56H2FA+xRsxBtOZDWMEfbYRea+8LP2TMLzaCw9RYvVDq6JEr//
	dSXN5O+4BAl4A1tw8OtlyrFtsJb1Pl4AL2dT0H0V7Ggk31o95v845/fY1T+zB0MtMR6KnwF6y
X-Google-Smtp-Source: AGHT+IFIBcmqWzgE/O9XO8kowrJAh0BBBppQP18FLn8bFud3BCovrgmPOydZT/Pso848SDyeGNmxiYQZtXH2NCZyBjE=
X-Received: by 2002:a05:6512:3a93:b0:540:3550:b0f8 with SMTP id
 2adb3069b0e04-542845c3ecbmr4322288e87.24.1736573403600; Fri, 10 Jan 2025
 21:30:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
 <CAKFNMokeyee6PEAHs+zs2OO8gEKftK+_RCt9wYD+2cG6sEqDoQ@mail.gmail.com> <CA+m_8J3Cf5BZUB-c4gVko84FuA0=OtyNCq89A3gJR8-vcTxDyg@mail.gmail.com>
In-Reply-To: <CA+m_8J3Cf5BZUB-c4gVko84FuA0=OtyNCq89A3gJR8-vcTxDyg@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 11 Jan 2025 14:29:47 +0900
X-Gm-Features: AbW1kvY8-f5NHYtVstXIW7Q4tkFE4y4EUwMO0b8-WvNye989YrHIne3MnxcXnLw
Message-ID: <CAKFNMomiYJhNXTTVH5wRuWSBEEYmHcnxqRU8iUPVxFNmfcezMw@mail.gmail.com>
Subject: Re: Massive overhead even after deleting checkpoints
To: "Felix E. Klee" <felix.klee@inka.de>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 11, 2025 at 3:25=E2=80=AFAM Felix E. Klee wrote:
>
> On Fri, Jan 10, 2025 at 6:37=E2=80=AFPM Ryusuke Konishi
> <konishi.ryusuke@gmail.com> wrote:
> > Example:
> > $ sudo nilfs-clean -S 20/0.1
>
> Thank you! That improved things. But there is still a lot of overhead.
> It=E2=80=99s 3.0TB in total vs. 2.5TB actually used by files:
>
>     $ sudo nilfs-clean -S 20/0.1
>     $ df -h /bigstore/
>     Filesystem            Size  Used Avail Use% Mounted on
>     /dev/mapper/bigstore  3.5T  3.0T  338G  91% /bigstore
>     $ du -sh /bigstore/
>     2.5T    /bigstore/
>
> As mentioned in my original email, initially usage according to `df` was
> 3.3TB. So only 0.3TB have been gained.
>
> > $ sudo lssu -l
>
> It generates 28 MB of data that starts off like this:
>
>           SEGNUM        DATE     TIME STAT     NBLOCKS       NLIVEBLOCKS
>                3  2025-01-10 12:19:48 -d--        2048       2036 ( 99%)
>                4  2025-01-10 12:19:48 -d--        2048       2040 ( 99%)
>                5  2025-01-10 12:19:48 -d--        2048       2036 ( 99%)
>                6  2025-01-10 12:19:48 -d--        2048       2040 ( 99%)
>                7  2025-01-10 12:19:48 -d--        2048       2036 ( 99%)
>
> I have no idea what to make out of this.

The output seems to be after GC, but by default nilfs considers blocks
less than an hour old as live (in use), so if you run "lssu -l" again
or add the "-p 0" option to set the protection period to 0 seconds,
the results may be different.

$ sudo lssu -l -p 0

Note that the disk capacity output of the df command includes the
reserved space of the file system. By default, NILFS reserves 5% of
the disk capacity as a reserved space for GC and normal file system
operations (the ratio is the same as ext4). Therefore, the effective
capacity of a 3.5TiB disk is about 3.3TiB.

In addition to that, NILFS has overhead due to various metadata, the
largest of which are DAT for disk address management (1), segment
summary for managing segments and logs (2), and B-tree blocks (3).

Of these, (3) should be included in the du output capacity, so (1) and
(2) are likely to be the main causes.
(1) is just over 32 bytes per 4KiB block, which is about 0.78%, and
(2) is at most 1.5% depending on usage, so there is a total overhead
of just over 2.3%.
If the effective capacity is 3.3TiB, the calculated overhead is
0.076TiB, so the upper limit capacity should be around 3.2TiB
(theoretically).

Other factors may include the 3600 second protection period, and the
fact that the NILFS df output is roughly calculated from used segments
rather than actual used blocks, so this difference may be affecting
it.

Regards,
Ryusuke Konishi
