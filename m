Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218F52773D3
	for <linux-nilfs@vger.kernel.org>; Wed, 11 Mar 2026 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773234093; cv=none; b=mN5w+A9PBBnDyyz6VZJ0WVk+/bfl5kBWic6lf+3ayR1VxAp+QjlG2Q0dCJhLukJDgTC6/iqjwiaD7EuKBWvKyGjwMuLGTGhogX4iU4HpglXQGFkGgE5KjhqoLpOd+wwLPDbyGw64baGvdsZ7tMVgIyDLFh5LrJSLAcg+mwHHtAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773234093; c=relaxed/simple;
	bh=CLBRwGYmbJ0k3DklFkvThqG5Dk79zbT5XKLlwktJCao=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=KVLuSgT9cppNjI6GC+pfcC+HCPIBAg+GYywWbhx2xcbqz7BgL8xSvPh4bYJmwBt8gOuujch+KqA8Nhwx1IMNdXVbpXwGUT2y+OL0N8DgCv6pgZvsgqMRARgWUPW3swvwVyLFrrptxX5rqIBL/33+YIQfkxzilcLArm67CanQR10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8QBkfII; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8QBkfII"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b9704cd6951so315032666b.3
        for <linux-nilfs@vger.kernel.org>; Wed, 11 Mar 2026 06:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773234090; x=1773838890; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgOupCzfEhpbNhUiordHXOWTqSwHQhblBvedM3+Nb2E=;
        b=e8QBkfIIlMuIpTbmXeorXMbxT2aVzPlpIK9NfuCXq/0FobeECdNR3YPl2YbBCdWCDW
         a+1wi6VkF3IJ9lJ88DYQ+MwtvjtCSdViJKz4oNnTTFxcbLklLq9f271El2mP9gtLiBGT
         46olX3MjHmRJbybEDjdXpO8fXyI5XreDLlVSS4y2d8Ykqt33noEpKlOhJHOk8hPyOd0x
         DBlycqDH0NEmIamAQnuYEF6hTo+9EhWLXkROvs+cSGMdVJTng6zscUc34Xc55tnmCihB
         HP1pBkGGhCGl10BAXG8/FUuv703bkzUyFA94ns/q0X9VVXN3b6bGfEKDKDKedNmQMJPg
         zqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773234090; x=1773838890;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pgOupCzfEhpbNhUiordHXOWTqSwHQhblBvedM3+Nb2E=;
        b=KZk5O3XL53qw7QPHn1bC2G5+wFLHj6luD/mbYCo0EoG4IhBXdjzsun+/5hzx04gLvg
         vWnKA0z4TYaMJSzZKT2NOmuXSn36SmJXNRzp9bxQy3vAepJPtelyXiBEUK8K/Z9+JTB4
         MXtKqBNYJwbokHES4or+bPKw4XBO1SM0w47aMAnsRQ6VMLkh0twGduT0/PmJvj24E8lO
         jnNKiX/risPys2MsCEI/3w5EGFxSGzUjRn1cm9zfToQXexbiWqrSIAMXaGM+vspIneBr
         +4iKO3R7MUbSECyePgstHZ0dNlGhB9+tRC8TdcPCWk2H7nXW4/O/rTUpFJT4cNO9wddh
         uvZA==
X-Gm-Message-State: AOJu0YyJIqJvdx48Lj/4PjQidaJuVA2EG8okhGBDLPUuLtzn32Q/bx5e
	Xg7cqkJ01z6ZPaBexKtn438V2YfLnM7a7F4/TLPSIwlrtLq287P9rPKoez2fxA==
X-Gm-Gg: ATEYQzx9w+osyovbgiJNqacGIYd/gUckiBRTzXhU6Y8bdb1TQsV0MJgIJKgCy2Jtegk
	D89MaaTb0usjKJjE8Yka5zHvjAHhNzly+2+qDWw8UeYVMWHRtr18BVk3p5BrBuIEl4AI1+grteu
	J38yBEC3s1xBVHqqSudaW5swu24UjEskGGkS7iJT5Ut9c5qVqPObLUv6yu86WFMJ46CbRcT3N0h
	LlxEWHOb15oBxdLA8rv83aJn4x1CeNVoVFcEeHwIlihkUsGrSbo5grpInGoHGi46rk4Ar7Mmk/U
	OwAYC56iV8Cebb7GoLb3n+8pCf3eED7jnaw2d4upmKndByJZ6ctrFL8tGVPpJXIQSfOyglVjP/9
	ANVXstGfO/XX1w2UaORCTZqZph7XeTlzrDh6OUwkf7X7Apai+NM18U5+TofBSLeCN1zJlApL+4a
	tAij7Mn8CBueQ2RUiJyhn/C8aw9FQXXN7xB264IEQL2XTP48hjHMoHC0aM
X-Received: by 2002:a17:906:eecc:b0:b93:a3db:a6a7 with SMTP id a640c23a62f3a-b972e5fb52bmr129162266b.29.1773234089819;
        Wed, 11 Mar 2026 06:01:29 -0700 (PDT)
Received: from [10.128.170.182] ([77.234.210.12])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b972de82bc0sm53025766b.27.2026.03.11.06.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 06:01:29 -0700 (PDT)
Message-ID: <31ee60a7-4b23-4dce-99f6-b86c8c8cc53e@gmail.com>
Date: Wed, 11 Mar 2026 16:01:27 +0300
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: konishi.ryusuke@gmail.com, slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Subject: File system corruption after writing to unlinked file and using
 fdatasync on the file if system crashes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Detailed description
====================

Hello, there seems to be an issue with NILFS2 crash behavior:

1. Create new file and truncate to some length.
2. Unlink the file but keep the file descriptor open.
3. Make new empty directory.
4. Sync file system.
5. Write some data to the file.
6. Apply fdatasync() to the file.

After system crash (e.g. power failure) mounting file system results in 
error message `Stale file handle`. See details below.


System info
===========

Linux version 7.0-rc2, also tested on 6.19.2
nilfs-tools version 2.2.11


How to reproduce
================

```
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
   int status;
   int file_fd;

   status =
       open("file", O_WRONLY | O_CREAT, S_IRWXU | S_IRWXG | S_IROTH | 
S_IXOTH);
   printf("OPEN: %d\n", status);
   file_fd = status;

   status = ftruncate(file_fd, 1000);
   printf("FTRUNCATE: %d\n", status);

   status = unlink("file");
   printf("UNLINK: %d\n", status);

   status = mkdir("dir", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
   printf("MKDIR: %d\n", status);

   sync();

   status = write(file_fd, "Test data!", 10);
   printf("WRITE: %d\n", status);

   status = fdatasync(file_fd); // everything is fine if using fsync() 
instead...
   printf("FDATASYNC: %d\n", status);
}
// file system is unmountable after crash

// `mount` output:
// mount.nilfs2: Error while mounting /dev/vdb on /mnt/fstest: Stale 
file handle

// `dmesg` output:
// [   29.941736] NILFS (vdb): mounting unchecked fs
// [   29.953605] NILFS (vdb): error -116 recovering data block (ino=11, 
block-offset=0)
// [   29.953609] NILFS (vdb): error -116 roll-forwarding partial 
segment at blocknr = 26
```

Steps:

1. Create and mount new NILFS2 file system in default configuration.
2. Change directory to root of the file system and run the compiled test.
3. Cause hard system crash (e.g. QEMU `system_reset` command).
4. Remount file system after crash.
5. Observe that mount fails.

