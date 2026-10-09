Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA983AD522
	for <linux-nilfs@vger.kernel.org>; Fri,  9 Oct 2026 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557298; cv=pass; b=bkxNXr9thZM1FKIEsS9GdCdg+B97YA9rY1bit7CDiecbN2ND9Cd+2/Qt7xK9aeWligZ8RCzb5//26Ks+oRp2u3Qai+sv89LnDgD5SKYm8T3UWK55ZnjORaDL1tL67m8gSt1EW1aeWrqcmOsthifvckVOV8IiDvc/n8+NgZHBKZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557298; c=relaxed/simple;
	bh=LVp1QAdQ2YqvwwGtYjaMP/0Ze3KRBFBEet88ie1SGkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tdS4vMTkvoFtujQajOyPmG1BXZcplrKZKFnPDsTNeNwopynGJEV3bgQV1c2hxLR/9hPzE+9EaMAd5i9+6H3TJyklFItuegkIB8sLtUcQfTUZsyGKvRqR8G484aqaJdyIgAEuIeoC/5iU3gG0f+t9RCV7/hEOBEMqs2L/e+K5hRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5tSvdNe; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5tSvdNe"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c4be28b82so3813658f8f.2
        for <linux-nilfs@vger.kernel.org>; Fri, 09 Oct 2026 07:48:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791557295; cv=none;
        d=google.com; s=arc-20260327;
        b=NxABRUo7tBcH96fLuGRjUD67MKT4RYj2a+QkLmAFk3Mv9PKfwuRi4Tfs6qTUx1p+yz
         dndbPwlDJkwJ/jp7EZkCyi7secupEYaWrgfkivHNX/kJda2JDxnNzTQhY/mBFronbAZC
         4aRoPKh6XLcD4/u05VJL+CZdvyVf0LAglIyp4hQjhmBbgAOiy6n7DPdERhf55fKOLtF7
         zbg96Kga22mMYszfDbIflQsK6B7WxsA7E4f+rLHJpiy9pN+3IiEy+Cm7wkMo63aolnaZ
         TJSU0E/r/z0yGWdM9VlC/hYzDKwG/t6d/A+Uo0HD8+ihaKgTEXEa1rc6ayTso/tKvgX5
         QTDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DcHGczPgZRvJBLX6otp4fWgB9WOm7KJjLDKmnGx+ZXM=;
        fh=CKoGGRMCVlgontJOpp/W2Vz1qZ3qfbKrzfpjBBUe3co=;
        b=Z+Bx/CEEMxFEnXHqQmziVItNQwMD0fycPbUKAFaoWdeu3YzinJV0cmfCJYV8lgqYi5
         AUY5b6zUQROjinsLZR9mPUjClyQAssVFPt+5fAlS0znVLWIRpWFBGCb2Gc0JMcoLatTe
         wxiISFoy9z6ZVzCbC8SLBgZQH20lIAi3UpcJFR9p8y7fOjkmKQOSNdsHcTz2hKlHtkVP
         GcXRun6IAHS4yYsh+5x1ubw7NHxFAJEhye53Y5RrEqGzGwP67FWWyEsUob2CCuCVoqL4
         0PquJYefc73eFdXg29l12rhxZKWh8SBtPELYgpAdh9y84Bn80JMR0gWd4oqDu30zbMS6
         x9qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791557295; x=1792162095; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DcHGczPgZRvJBLX6otp4fWgB9WOm7KJjLDKmnGx+ZXM=;
        b=b5tSvdNeg0/KyXxGEA0eNiHLm3v5pD7YhCfACEljzl0lAVKeh0oa7AUYVbAW4+SUkm
         dSmhRoS25mhTSeCcDY8NiT1SKi9XjAwyGHxzgyfM4CZ7IWoS0PFOevDUcNQu837dk7/6
         x3RRMXknkiVS1NE5mvDYbfDQGMEtPj1+HUC+HtkicS7W6Jd9WBvRdRJzbUsdIhh+Ezlb
         /xJcuzkGkPrViXAa2HRuPMiNRB/TepsfuUqPjvROC1uuJqWyUYfnJPJi6HJ2IjnUb6AF
         hmIXhf/xMtvx6aWFHE5WRyENegVEv0CQnuQV0nE6xGlqC8P2wMNlbsfMIJl8ogwmJByW
         eYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791557295; x=1792162095;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DcHGczPgZRvJBLX6otp4fWgB9WOm7KJjLDKmnGx+ZXM=;
        b=ST7Ee6Ag1KdH0NtS1P5mggNIqSCXKatRkhTeJF2y4aSuVPPkkh2tpo5c/M4udRIzp/
         ifsQoU8KvSs0iVAIMc32+XS7O4Bim6qzm7lCyqF/6lHclpIS0tyH0kMo01yZO9Ck5ij3
         YVid7cHtP15aTxUE+rh2VHSXwCRU1MsUIyOB3E19YJ8GLIe1iMH2p4awL3ckDXE5SRMm
         AOU4e+lpDtU1ipF1cX11sL2qMDGCcC/3lTMqRL2IU0Kh6GfUM+Ic44KbeLPWRIS/ENuJ
         o/rlCaUTb5K8WsMhz0XJEfU0JhlcexdFrcSHR3sblbOcR1GhhMlM0XFuryQz72U0vuaK
         c3CA==
X-Forwarded-Encrypted: i=1; AKwUvBx66otGbfzzXFRQayrcYKfGc5anuHM0+Qp2je8IJ5cEOQh3u2JIRxthdTys4Kvzp+DLsXxPngP9jij+ig==@vger.kernel.org
X-Gm-Message-State: AFq9FYJUzXu3hOZJirkxphyyqe3ajTUGIpB+LIBefSzwWW+XW1PBH/dW
	ZDFCI9Y9RjTQwICR2xJC85B6oVQjQ48Ae6NPk/jRjjkEJ7i7iO7/Bx3UXYTBUD0odXojP+vZDj/
	kqDwyg6oVFANEnk6CjN+cxdjfQ78HkABmTSIs0RM=
X-Gm-Gg: AYBFou0fohC+kfIjmiOEyMVKcjaMQuSsw9v7RSfIJR2waNrhKRtWMyS69rELAO7vqpF
	35oQrl8noyYM3HHSRrP7l9xa5x6Oxbz5fgFnfeO9kYN+OfSdfXqkpyRNfpTJksfLs8o2twcCATr
	NXeUFHRVczqBdHaOZc/wq376XDGEy6QYhsT88Unto0wFw/sNAsa7ApU8txdUD7lvlomzzQP0Jfr
	uB2ExdppZKJAlYlt2wEgI+k+kzgMStiaJhfEb5mGgFfOtRHMNK86kFgtqOd0Ye0usL3PMOO4O+X
	1CTz7eI9faL2W4e4h6QtpDtEcmUdn20UbIHEHf5VSwBR1Tb+kTc7U+Lx
X-Received: by 2002:a05:6000:4287:b0:48b:68:592e with SMTP id
 ffacd0b85a97d-48dba77cf6dmr5471601f8f.4.1791557294915; Fri, 09 Oct 2026
 07:48:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <47d7da4a-5029-4c56-a5ac-3e4c526cc569@gmail.com>
In-Reply-To: <47d7da4a-5029-4c56-a5ac-3e4c526cc569@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 9 Oct 2026 23:47:57 +0900
X-Gm-Features: AclHuK9EJLFEf7xaSOmpA2lH2mwwgWwZsDy43bq0zbth0WsulONkQKj8XuO57X8
Message-ID: <CAKFNMomfwzD52Kpjo1ZvSF=n92=tOY=3XcLxPBY-=_-7J3JChQ@mail.gmail.com>
Subject: Re: System writes out modified portions of the last memory mapped
 page beyond file end if file is resized
To: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 11:09=E2=80=AFPM Vyacheslav Kovalevsky wrote:
>
> Detailed description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Hello, there seems to be an issue with NILFS2:
>
> 1. Create a file, truncate it to some size that is not multiple of OS
> page size (which is usually 4096).
> 2. Open the file.
> 3. Create a new shared mapping (MAP_SHARED) using `mmap` from 0 to some
> point beyond file end (but still on the same OS page as the file end,
> otherwise next steps will fail).
> 4. Write some data beyond file end using the mapping.
> 5. Resize file (e.g. using `truncate`) so the file end is now after the
> mapping range.
> 6. Observe that bytes written beyond file end (using the mapping) were
> also written to backing file after resizing.
>
> The last bit violates the POSIX specification, extract from `mmap`
> documentation at
> <https://pubs.opengroup.org/onlinepubs/9799919799/functions/mmap.html>:
>
>  > The system shall always zero-fill any partial page at the end of an
> object. Further, __the system shall never write out any modified
> portions of the last page of an object which are beyond its end__.
>
> Linux manual <https://man7.org/linux/man-pages/man2/mmap.2.html>:
>
>  > For a file that is not a multiple of the page size, the remaining
> bytes in the partial page at the end of the mapping are zeroed when
> mapped, and __modifications to that region are not written out to the
> file__.
>
> For reference: `ext4` / `btrfs` / `xfs` do not write the data to file
> after resizing, as
>
> The exact same issue was recently reported for ZFS:
> <https://github.com/openzfs/zfs/issues/19220>
>
>
> System info
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Linux version 7.0.0-34-generic (Ubuntu 26.04.1 LTS)
> nilfs-tools version 2.2.11
>
>
> How to reproduce
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> ```
> #include <err.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/mman.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <unistd.h>
>
> #define WRITE_OFF 10
> #define WRITE_SIZE 10
> #define WRITE_DATA "Test data!"
> #define MMAP_SIZE WRITE_SIZE + WRITE_OFF
> #define FILE_SIZE_INI 10
> #define FILE_SIZE_END 32
>
> int main() {
>    char buffer[FILE_SIZE_END + 1] =3D {};
>    int status;
>    int fd;
>    void *addr;
>
>    status =3D creat("file", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
>    printf("CREAT: %d\n", status);
>    close(status);
>
>    status =3D truncate("file", FILE_SIZE_INI);
>    printf("TRUNCATE: %d\n", status);
>
>    status =3D open("file", O_RDWR);
>    printf("OPEN: %d\n", status);
>    fd =3D status;
>
>    addr =3D mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd,=
 0);
>    if (addr =3D=3D MAP_FAILED) {
>      printf("MMAP: FAILED\n");
>      return EXIT_FAILURE;
>    }
>    printf("MMAP: OK\n");
>    close(fd);
>
>    memcpy(((char *)addr) + WRITE_OFF, WRITE_DATA, WRITE_SIZE);
>
>    status =3D munmap(addr, MMAP_SIZE);
>    printf("MUNMAP: %d\n", status);
>
>    status =3D truncate("file", FILE_SIZE_END);
>    printf("TRUNCATE: %d\n", status);
>
>    status =3D open("file", O_RDONLY);
>    printf("OPEN: %d\n", status);
>    fd =3D status;
>
>    status =3D read(fd, buffer, FILE_SIZE_END);
>    printf("READ: %d\n", status);
>    printf("BYTES: ");
>    for (int i =3D 0; i < status; i++) {
>      printf("%02x ", buffer[i]);
>    }
>    printf("\n");
> }
>
> // ::Expected::
> // CREAT: 3
> // TRUNCATE: 0
> // OPEN: 3
> // MMAP: OK
> // MUNMAP: 0
> // TRUNCATE: 0
> // OPEN: 3
> // READ: 32
> // BYTES: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00 00
>
> // ::Actual::
> // CREAT: 3
> // TRUNCATE: 0
> // OPEN: 3
> // MMAP: OK
> // MUNMAP: 0
> // TRUNCATE: 0
> // OPEN: 3
> // READ: 32
> // BYTES: 00 00 00 00 00 00 00 00 00 00 54 65 73 74 20 64 61 74 61 21 00
> 00 00 00 00 00 00 00 00 00 00 00
> ```
>
> Steps:
>
> 1. Create and mount new NILFS2 filesystem in default configuration.
> 2. Change directory to root of the filesystem and run the compiled test.
> 3. Observe that last operation returns unexpected value.

Hi Vyacheslav Kovalevsky,

Thank you for your report.  I have registered it as issue #179:

 https://github.com/nilfs-dev/nilfs2/issues/179

Having the reproduction steps clearly outlined is extremely helpful.
This appears to be an unaddressed bug, but I'd like to begin the
investigation by verifying whether the issue can be reproduced with
the latest code.

Thanks,
Ryusuke Konishi
