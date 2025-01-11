Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7B9129A78
	for <linux-nilfs@vger.kernel.org>; Sat, 11 Jan 2025 06:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736576538; cv=none; b=KAlefxV3DDCaxY5LqgcRfxviEkt0s7z83cCM4jV0KSkKsXCud8uW+e0jW7ekcKyq/mLaCJzMeupT6X3/zIYhlHsM7SvbzoT5Dhpd/tqW1s9yQkPiXQ7X/Gjd5K932C2WHiXQU9Ua1TtW/ezs4yCYuKEE2GccPrXPaYqZWTBQs2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736576538; c=relaxed/simple;
	bh=VVSFZ8E5Uqc1AF3IPCXNFr5aLs7jWBr0VmoYCeZICWI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K9DmQKgSOOHKdYPa8at2AQ1bsF26OersbYt7Q5gmi9NcNXyUELoklUANIjqlXg6HSUizR7ROHF7VZUoeKQt9QidcVYHC0X6oHb/taj6XY6stgXTdlUCgiohwXra9M7y4NtlsS+bFqm8dCqHq8bee1XUxS5vVECPThNdn8WBNPl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eNqTNd7z; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNqTNd7z"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5401c68b89eso2961965e87.0
        for <linux-nilfs@vger.kernel.org>; Fri, 10 Jan 2025 22:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736576535; x=1737181335; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UO29qrN5NA9atVg0YgeJg588MsLJOfsdgwm5baCndjI=;
        b=eNqTNd7z4UVxvtpBkNXSo8lrvO9WNk/m5x5RTmG61tN7RIlZ4LSJnc/WpRgRhiJP6q
         b3MK5RfDFsR7QzmxX+5rqFTXDkBX51CN7bkiWia9unfIt1rmgS2RHnGwHu+WVgxPkPnp
         piE+v1TatTjoaJaoYCXif/7ptwTJL0rmwasZs0ugc5QoQT7IPYQsazUymNeK3NDQ2ljq
         AdLF05WtlMg/2dlE9DamrZRD5jGKsPGjID48EkvfbDr9WmxvcX6S26jPA2aizZBE8wI8
         QIi4Og1ht88GrtpFqYYJvjsvtwsgN0VMimKm5YYpzb46qCaI5tWQPZEnDzZwIlbQ9RtN
         pdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736576535; x=1737181335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UO29qrN5NA9atVg0YgeJg588MsLJOfsdgwm5baCndjI=;
        b=K2ALg6kiQkNM2ui/R+WxX9Feq3kk8Sd9tJ4rlzToP0ZUHAmNdFRJDF/xQg6AiOZ7uK
         uh98AnDDJSo6GjVmoasg1K2Aaetpjfffi5Wn0hbkaEX7bezmPtiNeDko3a49rTZlgci6
         1KUUD0VrQLVrMSCBVuyPXSuzYQTtVFcKaRO0OGK/y/FcVbArcHmVrMn7vkAkFKgxBsiR
         dyO6TmpLst13HXMIZNu47qfLJqkAgWW2tXiFHL1AUsR2MZ4GY6GADRlz8LRZpxic9YMV
         tRlftqfYHHbO7kZPN+iuyZwx6fyf9r9Jb478jJeT+rtozfRGtbZti0qG3X3qzN2v2e65
         Sqxg==
X-Gm-Message-State: AOJu0YzsLjCmSozuGgFPiSJ5iQmM+bbJK0eQF4xWJKUsSSU/Uoa5kWJi
	OAGEFF81rvcxagVNW6bLl/eL2rs0kkJNhCHXXF85Co+BI2twdFfahbtRyKyl1zG0wBwZIy/aMw5
	cJxYx/AWBxkXmTORyfLZ8nXD7/LXITMhO
X-Gm-Gg: ASbGncvyVS6SNH0QTmpM/P6D0rbTNCB3ibfVQYDHXU0KFY/eiHCJ8EBA1X7niivEZWg
	F50PhB6M0YaH+ajWLarYPRKKI122jCZEL1xRMcoCdmZxfRHTRYlBryiNOMEH0s4ZV+BDsgII=
X-Google-Smtp-Source: AGHT+IEAgll0wfCRusJ31bOsSOfKz/mO8moV3Bp2l/v61wtb5+VkuiuR0K58l+AJKKsogJB/4n1PfusbOSFqQBDGnt0=
X-Received: by 2002:a05:6512:238e:b0:542:91ac:3f78 with SMTP id
 2adb3069b0e04-54291ac3fd5mr1621075e87.17.1736576535124; Fri, 10 Jan 2025
 22:22:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
 <CAKFNMokeyee6PEAHs+zs2OO8gEKftK+_RCt9wYD+2cG6sEqDoQ@mail.gmail.com>
 <CA+m_8J3Cf5BZUB-c4gVko84FuA0=OtyNCq89A3gJR8-vcTxDyg@mail.gmail.com> <CAKFNMomiYJhNXTTVH5wRuWSBEEYmHcnxqRU8iUPVxFNmfcezMw@mail.gmail.com>
In-Reply-To: <CAKFNMomiYJhNXTTVH5wRuWSBEEYmHcnxqRU8iUPVxFNmfcezMw@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 11 Jan 2025 15:21:58 +0900
X-Gm-Features: AbW1kvZeM0diVil6e8fCSKppb76o1mKbGhlbamdJKAHwWMEljgqWop5Y3mgCIuo
Message-ID: <CAKFNMons0oLVgByGXEa4Pv3rgxmgEYP9h4z_fjgMm1qjEJDHFA@mail.gmail.com>
Subject: Re: Massive overhead even after deleting checkpoints
To: "Felix E. Klee" <felix.klee@inka.de>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 11, 2025 at 2:29=E2=80=AFPM Ryusuke Konishi wrote:
>
> On Sat, Jan 11, 2025 at 3:25=E2=80=AFAM Felix E. Klee wrote:
> >
> > On Fri, Jan 10, 2025 at 6:37=E2=80=AFPM Ryusuke Konishi
> > <konishi.ryusuke@gmail.com> wrote:
> > > Example:
> > > $ sudo nilfs-clean -S 20/0.1
> >
> > Thank you! That improved things. But there is still a lot of overhead.
> > It=E2=80=99s 3.0TB in total vs. 2.5TB actually used by files:
> >
> >     $ sudo nilfs-clean -S 20/0.1
> >     $ df -h /bigstore/
> >     Filesystem            Size  Used Avail Use% Mounted on
> >     /dev/mapper/bigstore  3.5T  3.0T  338G  91% /bigstore
> >     $ du -sh /bigstore/
> >     2.5T    /bigstore/
> >
> > As mentioned in my original email, initially usage according to `df` wa=
s
> > 3.3TB. So only 0.3TB have been gained.
> >
> > > $ sudo lssu -l
> >
> > It generates 28 MB of data that starts off like this:
> >
> >           SEGNUM        DATE     TIME STAT     NBLOCKS       NLIVEBLOCK=
S
> >                3  2025-01-10 12:19:48 -d--        2048       2036 ( 99%=
)
> >                4  2025-01-10 12:19:48 -d--        2048       2040 ( 99%=
)
> >                5  2025-01-10 12:19:48 -d--        2048       2036 ( 99%=
)
> >                6  2025-01-10 12:19:48 -d--        2048       2040 ( 99%=
)
> >                7  2025-01-10 12:19:48 -d--        2048       2036 ( 99%=
)
> >
> > I have no idea what to make out of this.
>
> The output seems to be after GC, but by default nilfs considers blocks
> less than an hour old as live (in use), so if you run "lssu -l" again
> or add the "-p 0" option to set the protection period to 0 seconds,
> the results may be different.
>
> $ sudo lssu -l -p 0
>
> Note that the disk capacity output of the df command includes the
> reserved space of the file system. By default, NILFS reserves 5% of
> the disk capacity as a reserved space for GC and normal file system
> operations (the ratio is the same as ext4). Therefore, the effective
> capacity of a 3.5TiB disk is about 3.3TiB.
>
> In addition to that, NILFS has overhead due to various metadata, the
> largest of which are DAT for disk address management (1), segment
> summary for managing segments and logs (2), and B-tree blocks (3).
>
> Of these, (3) should be included in the du output capacity, so (1) and
> (2) are likely to be the main causes.
> (1) is just over 32 bytes per 4KiB block, which is about 0.78%, and
> (2) is at most 1.5% depending on usage, so there is a total overhead
> of just over 2.3%.
> If the effective capacity is 3.3TiB, the calculated overhead is
> 0.076TiB, so the upper limit capacity should be around 3.2TiB
> (theoretically).
>
> Other factors may include the 3600 second protection period, and the
> fact that the NILFS df output is roughly calculated from used segments
> rather than actual used blocks, so this difference may be affecting
> it.

Incidentally, the reason why the df output (used capacity) of NILFS is
calculated from the used segments and not the number of used blocks is
because the blocks in use on NILFS change dynamically depending on the
conditions, making it difficult to respond immediately. If the
dissociation is large, I think some kind of algorithm should be
introduced to improve it.

The actual blocks in use should be able to be calculated as follows
using the output of "lssu -l" (when the block size is 4KiB).  For your
reference.

$ sudo lssu -l -p 0 | awk 'NR>1{sum+=3D$6}END{print sum*4096}' | numfmt --t=
o=3Diec-i

Regards,
Ryusuke Konishi
