Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A685212B17
	for <linux-nilfs@vger.kernel.org>; Fri, 10 Jan 2025 17:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736530633; cv=none; b=UZBbaPKvnnnGfenl8j0Y2A3VmGCh0joHCrsKigiNyx/0dU68b5oKDqV9cY8NZbVsUnXdJJ5i+pbXE+0UqBp8o8cuUtV6/TRo4jOxyjOyfSWJqbaa9rlQVydzGei8gdxMDBSyYikzoiO92k6kf4rJzQqbRwxsk5DnpFjSSELRVo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736530633; c=relaxed/simple;
	bh=PGCrLFwQrL2OjiwKz23RyrJ1z9KGHx2v9ZeKhvLFun8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OnxHuUisHeBCPMOScC9If3FEzkMcdFbFMKsCzNiR+B4e3fv/m0XEuhgd2Heetg8QQXlM0RKm0qdCzsO7ft4+AojPcZmPD4DuXNamtVVxWUALhZDE7LJ/S0cVe59H+hv/ZV6cRGgmW6j6AEmfGEc6HnrSlOS42VnhTypOwc+DTGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F3HRK8t5; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F3HRK8t5"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5401ab97206so2376458e87.3
        for <linux-nilfs@vger.kernel.org>; Fri, 10 Jan 2025 09:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736530630; x=1737135430; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/LacD1VAhUbvYE90T0QOHLKeDklBcsvmzfmYpf8iZo=;
        b=F3HRK8t5s6uWY3mnY7aSgi1fDUWrylXsMtyzqWDsKKDRJhLlocv0XPHsjxPnzTUc4+
         TJT84ekAwh/x66MQmqmp9BHJDN3Y4A9KJXmSeRTD5RXl2jeKMC3bNuaLjHdYHZoE4n4A
         VDT7EDsX9+sqY8c3ZEbw2W6uG0ffHmx5lWssoPn6OtIQZTDRhjxcVPlmVpXHnAETgRS2
         RREFm0eG9H5lFK8nWA3mP7u+o9TrdJRmjcCW4vNEB/Za1zYJY/bK0cwOW2WL07IdhI+H
         8RjmVjO3kO1YHx79wJYE7I3iokewy+ljZdbG3977n77uyv5xUJIndFgyMP0axAnlTJUF
         jPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736530630; x=1737135430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H/LacD1VAhUbvYE90T0QOHLKeDklBcsvmzfmYpf8iZo=;
        b=whSiK7IiQOIHvdlkMiToRlzPdqvT9F9ctYYm8bO6URwiQP3LCfY424eLyUZCWatHpc
         KhjwhfLzlZzpgtG1Bs93+JIV1qLLgp3zE8Gkcxr73hcSVtqzI2EOtNZqXYVgpaIrired
         MtMMq1PAWbUT9PyfIe17/ZVeWJofbypSBQEvm0DbhENJh9fXedRG51RjnHlgsSdCW4XN
         brYIxFMP/sjhGMVHjagOGzTMyGO+8FA2uV4K9yP/jashZFQj1zJ3NETQNIrJ8euwjYkm
         lY12ApypYhYzcohTXKolMhsWOlIvONuM7Q55ke02X1X/eaSP1HUmkxSH80yhoKuc7S5e
         k4uw==
X-Gm-Message-State: AOJu0YyZi4cj3AWnQZkSZbTHQYgpQdVSmjWBM0O3hcg6Dna1Q8lB/e4k
	0vupPLwcOZyC5d0ss9XKQhxeMInfDbXQaV0gBst8sxhk0e+u1zXyHJt873/lI9zAXAwHoag00ya
	ZF93qKVVOCq1mPxUueAatJTyWNeZ6c6oA
X-Gm-Gg: ASbGnct79acYNzFtWnj9w5wNt4tjApj5oEsV1Bkubyt2OVX3aozkpUcKliv8+pfQWuc
	DoN3uIgtPlpioKjQ8CJVJcx06+bi3afUOw2M0hQXfWfeIV5QPeKEv8JKahvktQPpxHNSbXS9J
X-Google-Smtp-Source: AGHT+IGSi6oIJWtlhYXdAAveY6YihOmbs0RFIvF8tyOClmS9Hs8AEUD0XJTNJU3AijTF8cluGXUmSvzLWKIOiC7t6q0=
X-Received: by 2002:a05:6512:281d:b0:540:1c18:4e38 with SMTP id
 2adb3069b0e04-54284546e51mr3995165e87.28.1736530629893; Fri, 10 Jan 2025
 09:37:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
In-Reply-To: <CA+m_8J37qo6fKFUp0wpRuK1FHawXNmCMiEyVYEwpt2Nc3uX5Og@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 11 Jan 2025 02:36:53 +0900
X-Gm-Features: AbW1kvbmVJRQ08Pk_TPs8bslyXOTiTkOBD9lV1cHx7gEyP3mtXVC_qIguCFXi14
Message-ID: <CAKFNMokeyee6PEAHs+zs2OO8gEKftK+_RCt9wYD+2cG6sEqDoQ@mail.gmail.com>
Subject: Re: Massive overhead even after deleting checkpoints
To: "Felix E. Klee" <felix.klee@inka.de>
Cc: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 11, 2025 at 12:54=E2=80=AFAM Felix E. Klee wrote:
>
> The disk is full close to the max:
>
>     $ df -h /bigstore/
>     Filesystem            Size  Used Avail Use% Mounted on
>     /dev/mapper/bigstore  3.5T  3.3T   65G  99% /bigstore
>
> Yet, not that much is actually used by the files themselves:
>
>     $ du -sh /bigstore/
>     2.5T    /bigstore/
>
> Using `rmcp` I deleted all checkpoints, but that didn=E2=80=99t solve the=
 issue.
> Furthermore, there are no snapshots:
>
>     $ lscp
>              CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
>           443574  2025-01-10 16:41:44   cp    -    652100924     421961
>           443575  2025-01-10 16:41:44   cp    -    652100923     421960
>
> The cleaner daemon is running with default configuration (Arch):
>
>     $ ps ax | grep -i cleanerd
>         827 ?        S      0:39 /sbin/nilfs_cleanerd
> /dev/mapper/bigstore /bigstore
>      117067 pts/1    S+     0:00 grep --color=3Dauto -i cleanerd
>
> I also rebooted the system, causing a remount of the partition. Yet,
> still no improvement.
>
> Is there a solution, or is the missing space simply used up by NILFS
> data structures? (it would be a bit very much overhead)

rmcp only deletes checkpoints and does nothing to free up disk space,
so try the nilfs-clean command. This command forces GC to run.

Example:
$ sudo nilfs-clean -S 20/0.1

Because your disk usage seems too high, you might want to check the
actual usage with the "lssu -l" command before actually running it.
This is a kind of debugging command, but it will actually show you the
percentage of blocks used per segment (GC unit).

$ sudo lssu -l


Regards,
Ryusuke Konishi
