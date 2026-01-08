Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAB822B5AD
	for <linux-nilfs@vger.kernel.org>; Thu,  8 Jan 2026 05:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767851232; cv=none; b=vDczc6X7/saBEfADKZd+ZOtZOuGmGGrWUzSgdqjv+UBo56ukc57/y/ANXb6vUpiz/YLC2PvHFE/2SNM6/1oD+DtK8G9ySoTd2lkdfJbxq3dXYAVwrG5MVfy2CelNuiiEFHiwJoCaoeb+P8+Ng+PDFWH/ZK1XWCtqAyq2iMSvcHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767851232; c=relaxed/simple;
	bh=lBjgvgdP3C4sP1wcyzlr+eGiBUTMmK9t9vBi8n1m+E4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f+/6UqigVDDmSeFwRtuAIV0yUouwUTcQQFNu7x0DWFhIxCFTUg+qhvAJi5vb5QeMZNlSIGM9D8Zv9Nf0l+1oIGlm9asZgrz6z24T93KmkswJT5Nk37SpaNXydMZ7h2B83R1si4mOVNYzX7mFDyefglMu2pIlZmo5ct43Fi0/gHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LI0rfC5T; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LI0rfC5T"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59b672f8ec4so2608826e87.1
        for <linux-nilfs@vger.kernel.org>; Wed, 07 Jan 2026 21:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767851229; x=1768456029; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZMCIEo44W4m+PPfA4T39Ozb69dnQvTF8ZniDMfocVc=;
        b=LI0rfC5TKJF7nRZUOpr2M+v29RVUTjd3f8C2ct3dEdU0E121F0v2Q5iGYijmB+ZrBr
         agzbuhqkWlMOLugXoOBvY5O0fDC5qaKsHVQQ8GCNnNk0CK7hQYG3eLsplvvwOs/hdv34
         qCzbZ+DBxLsAAzyt1QH3FvWyLPMjcJdFSpstre1/TXFFYLjW0YCr4/PkUeCuuwLyYzqE
         4NCYckOxnnTEaWHLFUgvsXdcU9Eyzo2Je2N6cRJFMgAG8Q8Kj215T3REovFIXsKXMAFY
         +sMTjEFvINBoImUygb/0QY93wRhEeugAdfAoQYtx3/dfySBGoYC6t6+aKNPHjV84b1VF
         8d0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767851229; x=1768456029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SZMCIEo44W4m+PPfA4T39Ozb69dnQvTF8ZniDMfocVc=;
        b=ayUMVhD47vQlE8T1QXWqdBdnqgLqfusneg4cKeJNd3vis+a4LnEyJ0liIVVyYUA1ot
         OBYSw8P/Wzp6Fd0I5izEdEm9Os8a6j1Fl8+62Mqp9Lubj0n18UdZdLn1XfJdGk5qstGV
         zkkl28zl1rosYbaShxAyFWm8JdFossa1JUnzI2kyE5zVcmCVeAA9/W21OqIXa3USLsSk
         FMBsmqms8YhotnziEi9igQKA7emGSJVm9kdMMKv7d/EATca/IiP3BFJfb6P0ZueYi+uY
         3evXeGQIIrmZSHE39mKbAdr/tKb2XNDZ5wOfF3VQ+/Wm9ZmQI0mDqGsalg5Gj8J6R619
         l/jw==
X-Gm-Message-State: AOJu0YwzyThKBxGCD4K9suozfSkuiR5QrhNK301MLLL57WpKXwyLyTxm
	/HXHjT3EA8KCYsgiESoV1GggqiJMFmJu5abhY0DZUSax81MAdPVIxCsR1A6vgMCEuGv9O6lnTsB
	J57PyzYkHEjTgVFGDLHUW73gM3DYkdILnOKU7grg=
X-Gm-Gg: AY/fxX6WaurajDSuFN7iSmkfnB2gMegZAS+1XeAuYuURjn6E1CDHasM6zirl3qSWQUv
	+sRtrUWe0VPnICFlGUar43pNibLnZJd++H/OPhr3ZFLhMAPRU06AkUe+UVB2lCSdjz3trNMQeXq
	PrAaqlTnH2MAr/ctvkXx3NbOq1b5BqSoXxtfo4EPpEramPCYobzrVA+05q4mTY0Hh98JyVN6k6x
	OJq9VSijFdED37TsFvbXwTJLClDDI2FKtpgIop/S6pZE6l9+pqlcL7GT2J9KYFhMPPAEmr4
X-Google-Smtp-Source: AGHT+IEQmMlUw0xevtXwywjYb0Kwnzr5Hgu4I9ag9XLL43RmKJhbtZC9Ba/81hUagIYU2N5CNLurce+oGYBI8TwkcKE=
X-Received: by 2002:a05:6512:3b94:b0:598:e4ca:8175 with SMTP id
 2adb3069b0e04-59b6f03d651mr1558756e87.45.1767851228768; Wed, 07 Jan 2026
 21:47:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <93c5c0a639a31958876739641fae9989afe8bb26.camel@ibm.com>
In-Reply-To: <93c5c0a639a31958876739641fae9989afe8bb26.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 8 Jan 2026 14:46:52 +0900
X-Gm-Features: AQt7F2qsWP0nVISpYsUx3Uzo6__Ap6sLq6bi8NPc7lAosw_Ld7s6TODTbW2j90E
Message-ID: <CAKFNMo=a+gB+SUhWGO+J_2t7TOgzfwYBsJLF61UGEfWej-yLrA@mail.gmail.com>
Subject: Re: [RFC] generic/003 xfstests failure details
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "slava@dubeyko.com" <slava@dubeyko.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 1:04=E2=80=AFPM Viacheslav Dubeyko wrote:
>
> Hi Ryusuke,
>
> As far as I can see, this test is trying to check the access time (atime)=
 after
> every touch. And it expects to see the difference between atime and ctime=
. But
> it cannot see the difference:
>
> sudo touch ./001.txt
> sudo stat ./001.txt
>   File: ./001.txt
>   Size: 0               Blocks: 0          IO Block: 4096   regular empty=
 file
> Device: 7,50    Inode: 12          Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2026-01-06 16:23:18.315637313 -0800
> Modify: 2026-01-06 16:23:18.315637313 -0800
> Change: 2026-01-06 16:23:18.315637313 -0800
>  Birth: -
>
> sudo touch ./001.txt
> sudo stat ./001.txt
>   File: ./001.txt
>   Size: 0               Blocks: 0          IO Block: 4096   regular empty=
 file
> Device: 7,50    Inode: 12          Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2026-01-06 16:23:44.535933843 -0800
> Modify: 2026-01-06 16:23:44.535933843 -0800
> Change: 2026-01-06 16:23:44.535933843 -0800
>  Birth: -
>
> Moreover, NILFS2 hasn't atime support in on-disk layout [1]:
>
> struct nilfs_inode {
>         __le64  i_blocks;
>         __le64  i_size;
>         __le64  i_ctime;
>         __le64  i_mtime;
>         __le32  i_ctime_nsec;
>         __le32  i_mtime_nsec;
>         __le32  i_uid;
>         __le32  i_gid;
>         __le16  i_mode;
>         __le16  i_links_count;
>         __le32  i_flags;
>         __le64  i_bmap[NILFS_INODE_BMAP_SIZE];
> #define i_device_code   i_bmap[0]
>         __le64  i_xattr;
>         __le32  i_generation;
>         __le32  i_pad;
> };
>
> Current implementation does such trick [2]:
>
> int nilfs_read_inode_common(struct inode *inode,
>                             struct nilfs_inode *raw_inode)
> {
> <skipped>
>         inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
>                         le32_to_cpu(raw_inode->i_mtime_nsec));
>         inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
>                         le32_to_cpu(raw_inode->i_ctime_nsec));
>         inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
>                         le32_to_cpu(raw_inode->i_mtime_nsec));
> <skipped>
> }
>
> I think we can use i_xattr and i_pad fields of struct nilfs_inode to impl=
ement
> atime support. NILFS2 hasn't xattrs support and, anyway, i_xattr is not e=
nough
> to implement this support.
>
> What do you think?

What do you think is the appropriate goal for atime support?

The Linux kernel has multiple support levels for atime, including
lazytime, relatime, noatime, and nodiratime.
For an append-only filesystem like nilfs2, supporting strict atime
would likely result in a disk-full error due to inode writes.

Therefore, regardless of the implementation method, some kind of
constraint must be imposed.

Personally, I think the limit is two options: noatime, relatime, or
three options, including lazytime (where inode writes occur when
evictions occur).

What level of atime support is required for this test and other tests?
(Is it simply a matter of decision?)

Regarding the atime implementation, it was originally intended to be
stored in a separate metadata file called the atime file.  Because of
its limited fields, it is a trade-off with xattr support.
A decision must be made to either move it to another metadata file or
expand the inode size.

Regarding this, I agree with you that it would be better to ignore
past assumptions, assign the remaining fields (i_xattr, i_pad) to
atime, and implement xattr so that the sweet spot of the xattr size
fits inline, by expanding the inode size to 256 bytes.

In any case, the above fields cannot be consumed unless the
implementation policy for xattrs is decided.

Thanks,
Ryusuke Konishi

>
> Thanks,
> Slava.
>
> [1]
> https://elixir.bootlin.com/linux/v6.19-rc4/source/include/uapi/linux/nilf=
s2_ondisk.h#L37
> [2] https://elixir.bootlin.com/linux/v6.19-rc4/source/fs/nilfs2/inode.c#L=
413
>
