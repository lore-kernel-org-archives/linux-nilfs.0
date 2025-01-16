Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8252522F39F
	for <linux-nilfs@vger.kernel.org>; Thu, 16 Jan 2025 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737051915; cv=none; b=YVFiyAwSqBMWaIpdh4e4LQAhOWTFeHACEFvmgKpjlKOk30/qbVB1MeVZGgDBv+Mokjqam5BVK26ulJ7W3O1WlstpqT0JtJBYWFeR3WEyXxtq4nFgZUzbBOF6Pk22xxfurNWSjMSb1DnYdxelwoqmRarGNQxd9/BfXhRjZfrQSOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737051915; c=relaxed/simple;
	bh=XoKKHvjjHrORXXSJZFHJ9eIINsXUlEt8wUuN9T0zWt8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AgH3gA3NGNFt2R2rabvJ71R/cgOKvadeJsh6l4NdQMVDGHaqkDzBzlCaqwpkolsUNBCuGYKye8ho5jXw/0H39W0RdG3/XPyf/1BuzTnspx0y/4tIb1UKqoSGRZ0nNIMRrzAGt3OCw3QPnDOfXQZkS0eDen0UDx3ArnmRDQ4K3zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FQbeQfnI; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQbeQfnI"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53e3a227b82so1289783e87.0
        for <linux-nilfs@vger.kernel.org>; Thu, 16 Jan 2025 10:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737051912; x=1737656712; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kagais1OrhMLEUM/ZfMTS+ts0QrDEuaPJTsoOuwUe84=;
        b=FQbeQfnI4pEnrw2Vqeo25QhNGxA3w4nRkle0n8B0feQFz7yGnz6v5Ie40ZV+tyDrmo
         A0YcQve+5kXZ9s4hRBjt9GCnCyb5sogX8AYDQv4Jb7woFsFC+Jjl9xRarhMVoURjn7sr
         VFqyyP5nT8pCzt15GZUIIN0dmYuKhdj+DBEkYkXJBw2TrwLNFFYXy3g5p4qnUXaVVcj8
         5fo3ThlbW0Y5iyI2dbHiuO3VTeEPaekt0t0FH3yS+6xM5uCcuKYxXALe+ASUEcrBoJnc
         Kq11GzzOa6psmL++sKtgKk78kSOl6oTeVhO5vnWP8j+xytEKqLDAtfCfMND3hDti22V0
         YHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737051912; x=1737656712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kagais1OrhMLEUM/ZfMTS+ts0QrDEuaPJTsoOuwUe84=;
        b=Pp1tvmERDicGPRFtjyp+83jHqs7VQK5qwRMZ3oLV2Pr8OhAxafKERy6MM3w3HmM3nF
         LytfI4yHkvXHvw7mEryS3XkVRTxeIVQJzsOa8vVJyzlD188OzCPQf6VvtJxlM1fLbD0F
         A7R3YRpcSqjNNtCs9wr0Y6e2dRHg22lOKxPDdUwzaFBZWd+aX0j6Oc92p6j0lVY82I5J
         ZDZr53gTkk3iv3yk+adVGyJzfJdsiFiGHCyMXMrC7zAbfgYm/ikTW60Xy5ixqRzGy/Zo
         /YCROFYqcS/UBTEyGjQYOuRWDZld4W7UJ6dxcE6wJpmniaQe8bpgkLh7G0/165/DwpP/
         3FDA==
X-Gm-Message-State: AOJu0YysaQx2lxwI8Q/rJeEde9c18Fx7vIWU+2iryhzMR7ATIDDtOMLu
	wEpEQelYP0XQg3cygBmWFcm9XdV9CBjxzcNcNev3wANmBkO85rBPaLZ+YnFd/BvILpMNefU0kto
	OnQaYCmzb1xzxkZmbjL/Pfk2o4Qa8VjUx
X-Gm-Gg: ASbGnctQVhee9bbPNq5uKWAgGjixCQsbVgkQpj43iMmvx4h0IWoO5el4nwmpeeMOzY9
	2qU91oDeW0EugJlPnWEO1MSy1yBdfiIjBgF0pIzO/bxXiong+U18y18nSo9q3Ql1NrqgHbrFs
X-Google-Smtp-Source: AGHT+IF5KrlUb3AiQQZYS1gZ/BET3UlZcwp+orwzbQdudO5IBhmOgnL4f29d6iaZ7QB9B+iUhK91hA+/lJAGgAbBHWg=
X-Received: by 2002:a05:6512:138e:b0:541:cdef:7ca3 with SMTP id
 2adb3069b0e04-542845c47a0mr12069064e87.27.1737051911253; Thu, 16 Jan 2025
 10:25:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
 <CAKFNMokeyee6PEAHs+zs2OO8gEKftK+_RCt9wYD+2cG6sEqDoQ@mail.gmail.com>
 <CA+m_8J3Cf5BZUB-c4gVko84FuA0=OtyNCq89A3gJR8-vcTxDyg@mail.gmail.com>
 <CAKFNMomiYJhNXTTVH5wRuWSBEEYmHcnxqRU8iUPVxFNmfcezMw@mail.gmail.com>
 <CAKFNMons0oLVgByGXEa4Pv3rgxmgEYP9h4z_fjgMm1qjEJDHFA@mail.gmail.com> <CA+m_8J0UjaOONaRwSMTCup-8xFmjkf6rHaLv0XSMOmvR3_d=PA@mail.gmail.com>
In-Reply-To: <CA+m_8J0UjaOONaRwSMTCup-8xFmjkf6rHaLv0XSMOmvR3_d=PA@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 17 Jan 2025 03:24:54 +0900
X-Gm-Features: AbW1kvZxmrjIPMntTmzeoaW6z-sKbnThOlxnYQxWZUQDzhP_YttrTb9H6Dx2VJE
Message-ID: <CAKFNMomMZB9oBppxqfAebOQNHAS1+fQRTDPORVH4PYTVnapBig@mail.gmail.com>
Subject: Re: Massive overhead even after deleting checkpoints
To: "Felix E. Klee" <felix.klee@inka.de>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 8:09=E2=80=AFPM Felix E. Klee wrote:
>
> Thank you for the detailed explanation! The overhead for metadata is
> what I expected. However, I wasn=E2=80=99t aware of the default protectio=
n
> period of one hour, also not of the concept of segments.
>
> Now, a few days later, I get:
>
>     $ df -h /bigstore/
>     Filesystem            Size  Used Avail Use% Mounted on
>     /dev/mapper/bigstore  3.5T  2.7T  699G  80% /bigstore
>     $ du -sh /bigstore/
>     2.5T    /bigstore/
>
> The used space reported by `df -f` is not 2.7T vs 3.0T a few days ago.
> Back then I was apparently too close to a major file operation. I had
> geotagged tens of thousands of raw image files, modifying them directly
> (exif headers).
>
> Should the following command have freed up diskspace?
>
>     # nilfs-clean -S 20/0.1 --protection-period=3D0 /bigstore
>
> I realize it doesn=E2=80=99t reduce the number of checkpoints.

The nilfs-clean command is a maintenance command, so use it when you
want to free up disk space quickly (especially if you don't mind
turning off the protection period).  GC runs automatically in the
background based on the watermark conditions set in
/etc/nilfs_cleanerd.conf, even if you don't run the nilfs-clean
command.

However, the GC speed is slow by default, so if the capacity is large,
you may want to adjust parameters such as "nsegments_per_clean" (and
"mc_nsegments_per_clean") and "cleaning_interval" (and
"mc_cleaning_interval") to increase the GC speed.

The nilfs-clean command takes a device path as an argument, so the
command line is:

# nilfs-clean -S 20/0.1 --protection-period=3D0 /dev/mapper/bigstore

or, omitting the device:

# nilfs-clean -S 20/0.1 --protection-period=3D0

Also, I forgot to explain one thing.  The current GC skips segments
whose free block ratio is equal to or less than the
"min_reclaimable_blocks" parameter (default is 10%, and 1% of
mc_min_reclaimable_blocks if the remaining capacity is low) in
/etc/nilfs_cleanerd.conf.

If you want to ignore this ratio and force GC, use the "-m" option, like th=
is:

# nilfs-clean -S 20/0.1 -p 0 -m 5

or  specify a percentage:

# nilfs-clean -S 20/0.1 -p 0 -m 1%

When running GC manually, be aware that once GC of all segments is
finished, GC will be skipped until some change is made to avoid
infinite GC execution.

If you change the GC conditions and rerun it, it may work if you make
a change and then run the nilfs-clean command, as in the example
below:

# touch /bigstore
# mkcp
# nilfs-clean -S 20/0.1 -p 0 -m 1%

I've gotten into a lot of detail.  Please understand that these are
tips to use for when you're in trouble.

> I really am a n00b when it comes to log structured file systems. I just
> want to use NILFS2 for the ability to revert accidental file changes.

LFS is a legacy method and is not common, so the need for this kind of
interaction is a drawback in a sense, and it may be an area where the
tools need to be improved.

One thing to note is that while nilfs can save you from data loss due
to user misoperation, it is powerless against physical device failure,
so you still need to back up important data.

> One more question, as you wrote:
> > Incidentally, the reason why the df output (used capacity) of NILFS is
> > calculated from the used segments and not the number of used blocks is
> > because the blocks in use on NILFS change dynamically depending on the
> > conditions, making it difficult to respond immediately. If the
> > dissociation is large, I think some kind of algorithm should be
> > introduced to improve it.
> >
> > The actual blocks in use should be able to be calculated as follows
> > using the output of "lssu -l" (when the block size is 4KiB). For your
> > reference.
> >
> > $ sudo lssu -l -p 0 | awk 'NR>1{sum+=3D$6}END{print sum*4096}' | numfmt=
 --to=3Diec-i
>
> Certainly interesting! But, I assume, without garbage collection I
> cannot use the space in sparse segments anyhow. So `df` should give me
> the space that currently is available for actual use. Do I understand
> that correctly?

That understanding is correct.  The above example is for checking
potential free space and isolating the problem.

On the other hand, the current capacity calculation is not without issues.
For example, I think it is counterintuitive that a segment is judged
to be in use even if all the blocks inside are garbage (reclaimable)
until the GC runs.
Well, but rather than improving the capacity calculation, it may be
better to cover this by improving the GC.

Regards,
Ryusuke Konishi
