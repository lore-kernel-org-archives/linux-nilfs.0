Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D731312B64
	for <linux-nilfs@vger.kernel.org>; Fri, 25 Oct 2024 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729872264; cv=none; b=frGNoSTlszZ4g97lijOoit8qxFEa7Rxx8EpZEsjjVCpIrY9GaKxXZPCi5cDDKNbaHlnr44laoIIUNHGamPF8vZebudbKv3c/kTaAUUuscOnFutTJGFe0qpJd9gg6iRBTJlveytVRvcpfvcOjAlNfb3gSSDvAZEFXX/blbxI9LOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729872264; c=relaxed/simple;
	bh=Ej/Yy98rd00SIeaxUgnrsX9ZsylfqkUI8CaKMXJ5MdE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jYY0AxBDLQL1zvOKgVPoKasM/cgxaCJTXtxcCb75khYfGso/jZ0iUsWrwnve+wNBGFWIbfxKqV83NkoW3lO/Ezb78Qr6hGlbiLztUZE44IsB/u8QgjJrPEid8DyXa8MfdqNmZ44FGZaCQl5rh3RcTF90pWHcmR8Dxn+U/9DGloU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e6YhW9Oa; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6YhW9Oa"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539f84907caso2483959e87.3
        for <linux-nilfs@vger.kernel.org>; Fri, 25 Oct 2024 09:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729872259; x=1730477059; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1vs2rzGI5nJjLqG/9FK5S4WwnZTwsq965cNIYQfMP0A=;
        b=e6YhW9OaY59ZJPwZxGgaS1BOn8E2jywKYA+hPw7cjjgVdd78Zn6ghHgvuDM5tkT1fR
         e5C8qXbmmx4TeYlPCmcfrzYE+JKZIYDQIvGV4KvLmVohHpqPG3l10MNVktgDFUt1gPmH
         0rWxLrlRPXBPZ3CXoDAc7SG5BWQ8uAo062bYQZUrkmVDE2J5lVPAmC+O6uZ3va6WEC9t
         OehEqC3j6Eqc6XIFy3995hap9trZnPfRAHGNXMTi/EsSXggnCWKHw2ZdC4Dt32er2gwn
         PQaYSnwy+tCGul5EU7ltFHYRK956J4FwlolJQ0id6I1/Y4Rh949TFl26915MKqvHF632
         KGIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729872259; x=1730477059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1vs2rzGI5nJjLqG/9FK5S4WwnZTwsq965cNIYQfMP0A=;
        b=U++BBz7aT8cw3Sugwhui2BVzkh+S23WcPoYnE6ox1YwarXsRaeJMJGRQgLeZBQSm2f
         5FOtoyuZ9SQXiWOlJXDSWJeYcOf/TxcSb06pGoXDApr5P7nCRHJvu3uV9WUbhtvARfhs
         4x3WOnqQVQwR/ovz9DRkWIEQUsOO73F0Em6zqgECEQ7AkhTVYvXbaNPqUEkEahwSFu8R
         Bxv9/LV53KLCNOzthOUXe0gu3+CfAC2+Xrpq/1ErYl3JnytlCEqQmWXJVMoR6X1K3OQ/
         JUCD3//JwoZmflGh6RjqfWLwSY4IWKnj8QR0wE/ZT5jfjKVFekObdPLH2ahSg811sJ3o
         rqvg==
X-Gm-Message-State: AOJu0YwmXuezyUdosyGhk3rF0h3euQN/8i8u1d4SzGznrCiLUETop6N1
	0RWZ9iXPQBZIyyHV/41a0hN7R7o/OUyjPUIpC7fiD0GvrB5YZtGzBHIwhpYVfbmQOzvXBwMOBKs
	T4t7/KJKVVv/ARLbbmCAj4//3i+yGSoOx
X-Google-Smtp-Source: AGHT+IG+aaJucXTR2R3Aai4bZ9+2+BT/exBbtnh/dxwBVJPIXs0U0k3XGY4i2ZAkcQZqQ2I18caOEqHODogDI++DpBw=
X-Received: by 2002:a05:6512:3e0f:b0:536:54df:bffa with SMTP id
 2adb3069b0e04-53b23e8510amr3810562e87.45.1729872258502; Fri, 25 Oct 2024
 09:04:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJUT6o4xwggZDcyHq2yYiRRLgqkho5oQSsqW0g4ZCWR6R0w-MA@mail.gmail.com>
In-Reply-To: <CAJUT6o4xwggZDcyHq2yYiRRLgqkho5oQSsqW0g4ZCWR6R0w-MA@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 26 Oct 2024 01:04:01 +0900
Message-ID: <CAKFNMon4CzpXcDoXUrZ2gww3rQfqkpwdNfh2e06hupgC8xOJDA@mail.gmail.com>
Subject: Re: lscp and number of used or appended blocks
To: dexen deVries <dexen.devries@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 8:54=E2=80=AFPM dexen deVries wrote:
>
> Hello list,
>
> lscp's "-g, --show-increment" option seems to give misleading number
> of appended blocks, significantly under-counting disk usage. i
> expected the sum total of increments, plus the full size of the first
> checkpoint, multiplied by block size (4096 in my case) to be equal to
> total used disk space (or slightly below it, due to partly used
> segments). and while the size of each checkpoint is indeed roughly
> equal to disk use by that checkpoint, the sum of increments
> significantly undercounts disk space usage.
>
> am i using it wrong, or is it bugged?
> using latest kernel and long-running filesystems
>
> example from one of my computers: 170GB calculated vs 356GB actual use
> Nr checkpoints: 49477
> Oldest checkpoint used space [MB]:          141903
> Computed sum increments used space [MB]:     28777
> Computed sum total used space [MB]:         170680
> Actual used space reported by df -m [MB]:   354072
>
>
> example from another of my computers: 34GB calculated vs 119GB actual use
> Nr checkpoints: 2368
> Oldest checkpoint used space [MB]:           27520
> Computed sum increments used space [MB]:      6813
> Computed sum total used space [MB]:          34334
> Actual used space reported by df -m [MB]:   119040
>
> repro script:
> #!/bin/sh
>
> fs=3D`df . | awk 'NR=3D=3D2 {print $1}'`
> lscp $fs | awk 'END {print "Nr checkpoints: " NR-1}'
> lscp --all $fs | awk 'NR=3D=3D2 {print $6}' | awk '{printf("Oldest
> checkpoint used space [MB]: %15d\n", ($1*4096)/1024/1024)}'
> lscp --all --show-increment $fs | head -n-1 | awk 'NR>2 {sum=3Dsum+$6}
> END {print sum}' | awk '{printf("Computed sum increments used space
> [MB]: %9d\n", ($1*4096)/1024/1024)}'
> {
> lscp --all $fs | awk 'NR=3D=3D2 {print $6}'
> lscp --all --show-increment $fs | head -n-1 | awk 'NR>2 {print $6}'
> } | awk '{sum=3Dsum+$1} END { printf("Computed sum total used space
> [MB]: %14d\n", (sum*4096)/1024/1024)}'
> df -m $fs | awk 'NR=3D=3D2 {printf("Actual used space reported by df -m
> [MB]: %8d\n", $3)}'
>
>
> cheers,
> --
> dexen

Dear dexen,

I've been busy this week, sorry for the late reply.

The number displayed by the "-g, --show-increment" option of lscp is
the incremental block count measured when writing logs recorded in the
checkpoint metadata, but I'm going to check the implementation to see
if it's what we intended.
Please give me a little time.

However, please do not use this number in general.

Checkpoints are deleted by GC, and the differential block count also
becomes inaccurate due to GC.
Therefore, this value of the block count is meaningless in practice.
(And that is why it's hidden and not the default.)

Use only the absolute block count displayed by default, and if
necessary, calculate the difference with the absolute value of the
previous remaining checkpoint.

If it's really necessary, it might be useful to add a block count
difference display function to the lscp command that performs such
searches and calculations internally.   It's clear what needs to be
implemented, but I'm currently busy dealing with the constant reports
of issues in the kernel, so I can't say anything promising.

Regards,
Ryusuke Konishi
