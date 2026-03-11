Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2B7345757
	for <linux-nilfs@vger.kernel.org>; Wed, 11 Mar 2026 17:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773250762; cv=none; b=MmgoIsSJfVHLLLF1mkvWg4zCbmLjCUriFfF8MUmOm4HZuLzLw4nLEMkci0wxv23aIoq735EEpiiDPyfX2MCaQZ2uunlakPCOyS6+mmZ9PiKY8JeeTkLD1KQXlFLNvFkwGpfr5QYLdh/Dim5hyfPb8HeveB2ustFB0kNbD5rbP9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773250762; c=relaxed/simple;
	bh=TkhjlhQ4UU7xyRZUcM42J4GIPc6IsIjNLIO+4uja3VI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t9AJwaqvDqELbsbK23zhmGG1IOk1HMF8r0ud2VVpIXITpQEbKNfZ2U/JtFJKGqQkXZ28MonpytYzOoPGdtcSZn49xFSPfHdSVM8GQEJF3Rg5M0eZRTtuCama7yitGcAmG5DBXCykFBv8YA/VjLV2dYqVvzazDIS/spBp5eH7mCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=p9sVV5xx; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="p9sVV5xx"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-46701f2077cso1092503b6e.0
        for <linux-nilfs@vger.kernel.org>; Wed, 11 Mar 2026 10:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1773250760; x=1773855560; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TkhjlhQ4UU7xyRZUcM42J4GIPc6IsIjNLIO+4uja3VI=;
        b=p9sVV5xxQqX4NgRrTT0hppwGWi3tR4nje/58F9R+fRc7NIWVr9tygjL3nIix+PJ1TQ
         K2cyJH0E+r+Yks5rfHSWzApqoQAXZBVwaQfh+7VGmPYsT8vAEotYP/b7x/lGrIAKT1z4
         7ZRC6Wg2y9NFvRAOnWDoWBu7puTQMKTDs48EorsTjryz2hUYnYPIEDZrcaqHlByxNtFU
         Fk8oAf7f6y+GYX747zv+74XTSBEBqkaFnDPL78Sv/uVl59H5pl67eoc6ZLpDPHuMrT+e
         pf98jmOSTxLxCOTANxa0JQVmJX2vfjXdOzkBh5XPtPeqTLVR5bHzW460S986KCrG+HBd
         ZbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773250760; x=1773855560;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TkhjlhQ4UU7xyRZUcM42J4GIPc6IsIjNLIO+4uja3VI=;
        b=ay9q+Z4iuOsisThSNykkLBC3CCIuAlgHqrmug61PDrhJD6LCi75qDHtYzo5YXIXLWj
         dUHq6sQ1qJ/3RtV+RY/vGC4vwv4DMzGm7z3E++ycdlnhrWnM8jQxGcJRQSyPzNdNkE2I
         DfCL0yqzHJrI/loF0RzWfmPxPb5ZxjWk+9qq+oMM5q82fugguINDPluwFrvOHv1w564W
         E3CPLO72m3x1ttVmsrhSsKBQXM6uSCNmDcumf+vNiN8jjzngwajRz2Sb3SMX+8BT0y0R
         JlpxEtipLokdBwJrImLLWnp03WELgtOY36HbbwbFLygo0YQ7sLe/PUFCgKiHtas8/gdU
         wQ4g==
X-Gm-Message-State: AOJu0YzgmAMS4SpDApOM6Wx8lLrDJ4VaFnZI3MxzdQWT6De6DDdSzUAl
	9WSI1XcfjYQNxrK549RG3Wu0nIqHhTlB9a9LjiwHeIOl46qjetQ7qCKwpl3YdJI5Rmo=
X-Gm-Gg: ATEYQzw5kI0cSS/wUkXwbDtquZNbLU/s9264I+MgiZc9lN9kA68u48jbrEU+Txk+49d
	ruqCsvFtqJce7Tbsy2mrS+qB1TXq9xKK2RZpQgx4dIs7R+XERtYNjgtJY/WE85sIZYpF3firSAy
	k1IwBWkSwgxd7YMj4rANQTwZEmtDVZoh2ee+/kPpNfoYqsmYqEMj504W8FjWnWsWPrfRWj2DDY4
	4x2vI2GKuo3icVKuBLTuczAGvNYoPTrFMtCzG2jVaz+ElPvNG/mYKmIiCK/AaEZoDTGUtLJhwVS
	IMzwbXR76pjmlZr81jcRBmpxPtx7UfyJ1o3cKWqgm37ptsVd4a4EA/9jb+SywDitDHVWbygw1hI
	ILDEk+Et4N86yghsxp0RP7D1e2CLg7bUTlsK7huie4hOlJkdxb2l5urSFGHEQ6fr1PXALfGQb5W
	5KKbGo1J18RLwCory60LgIVB7FKC6HhQVcqiOJykwJAPyv8yQHcOA/0TZMl7wlD3ncdzwuWq+qv
	P4pKytsZO/Wcpv8T/suheTy+l0kQ3G1MaKry9ybBsrpV64SEj/x7bYqS/4nM4JEhlkmz8E=
X-Received: by 2002:a05:6808:6786:b0:467:8b7:4a46 with SMTP id 5614622812f47-467430aa1e4mr244348b6e.9.1773250759976;
        Wed, 11 Mar 2026 10:39:19 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:d53d:8e08:a83c:876c? ([2600:1700:6476:1430:d53d:8e08:a83c:876c])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467342fab49sm1568012b6e.16.2026.03.11.10.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 10:39:19 -0700 (PDT)
Message-ID: <88cfd49dda56bbf3d15595063e2706ce7ee06ef0.camel@dubeyko.com>
Subject: Re: File system corruption after writing to unlinked file and using
 fdatasync on the file if system crashes
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>, 
	konishi.ryusuke@gmail.com
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 11 Mar 2026 10:39:17 -0700
In-Reply-To: <31ee60a7-4b23-4dce-99f6-b86c8c8cc53e@gmail.com>
References: <31ee60a7-4b23-4dce-99f6-b86c8c8cc53e@gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-03-11 at 16:01 +0300, Vyacheslav Kovalevsky wrote:
> Detailed description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Hello, there seems to be an issue with NILFS2 crash behavior:
>=20
> 1. Create new file and truncate to some length.
> 2. Unlink the file but keep the file descriptor open.
> 3. Make new empty directory.
> 4. Sync file system.
> 5. Write some data to the file.
> 6. Apply fdatasync() to the file.
>=20
> After system crash (e.g. power failure) mounting file system results
> in=20
> error message `Stale file handle`. See details below.
>=20
>=20
> System info
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Linux version 7.0-rc2, also tested on 6.19.2
> nilfs-tools version 2.2.11
>=20
>=20
> How to reproduce
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> ```
> #include <errno.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <string.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <unistd.h>
>=20
> int main() {
> =C2=A0=C2=A0 int status;
> =C2=A0=C2=A0 int file_fd;
>=20
> =C2=A0=C2=A0 status =3D
> =C2=A0=C2=A0 =C2=A0 =C2=A0 open("file", O_WRONLY | O_CREAT, S_IRWXU | S_I=
RWXG | S_IROTH |
> S_IXOTH);
> =C2=A0=C2=A0 printf("OPEN: %d\n", status);
> =C2=A0=C2=A0 file_fd =3D status;
>=20
> =C2=A0=C2=A0 status =3D ftruncate(file_fd, 1000);
> =C2=A0=C2=A0 printf("FTRUNCATE: %d\n", status);
>=20
> =C2=A0=C2=A0 status =3D unlink("file");
> =C2=A0=C2=A0 printf("UNLINK: %d\n", status);
>=20
> =C2=A0=C2=A0 status =3D mkdir("dir", S_IRWXU | S_IRWXG | S_IROTH | S_IXOT=
H);
> =C2=A0=C2=A0 printf("MKDIR: %d\n", status);
>=20
> =C2=A0=C2=A0 sync();
>=20
> =C2=A0=C2=A0 status =3D write(file_fd, "Test data!", 10);
> =C2=A0=C2=A0 printf("WRITE: %d\n", status);
>=20
> =C2=A0=C2=A0 status =3D fdatasync(file_fd); // everything is fine if usin=
g
> fsync()=20
> instead...
> =C2=A0=C2=A0 printf("FDATASYNC: %d\n", status);
> }
> // file system is unmountable after crash
>=20
> // `mount` output:
> // mount.nilfs2: Error while mounting /dev/vdb on /mnt/fstest: Stale=20
> file handle
>=20
> // `dmesg` output:
> // [=C2=A0 =C2=A029.941736] NILFS (vdb): mounting unchecked fs
> // [=C2=A0 =C2=A029.953605] NILFS (vdb): error -116 recovering data block
> (ino=3D11,=20
> block-offset=3D0)
> // [=C2=A0 =C2=A029.953609] NILFS (vdb): error -116 roll-forwarding parti=
al=20
> segment at blocknr =3D 26
> ```
>=20
> Steps:
>=20
> 1. Create and mount new NILFS2 file system in default configuration.
> 2. Change directory to root of the file system and run the compiled
> test.
> 3. Cause hard system crash (e.g. QEMU `system_reset` command).
> 4. Remount file system after crash.
> 5. Observe that mount fails.

Thank you for the report. The issue [1] has been created.

What's about to fix the issue? ;)

Thanks,
Slava.

[1] https://github.com/nilfs-dev/nilfs2/issues/164
