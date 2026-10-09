Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A17B38736F
	for <linux-nilfs@vger.kernel.org>; Fri,  9 Oct 2026 14:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555008; cv=none; b=d6b6AiTJ2BSiSHoX78UFkTAFXGob+orfp2w0DGPFq0rddNtXqlb1hk8cTrIlrpu3QkZgxjqnSAciMU5ZIwtxEAMyvZxaBOCkz0kOkbohW3Dq+E+5yvbTGa2Hp/tJThvwO2iUtDnleCYLVxEgADLnlOUnTZYD92O3tt/8xC2ftG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555008; c=relaxed/simple;
	bh=/wYwIrIQK4xiLW7OvS3VyX36IIyt93+83vMJBDyZoPE=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=PxF/J8+mfSkajCvv57b1AUWy98+qLPS7TxGeweTqJSMmV1YiewojbXTQBaq6szv0m6Y99piJCIwYmMCBIUUgvlE36PGtfQg+PkMdpsisi/wd4xIrJTCg9n3f4pj6x8G8A2IMXNSOMEWbu582swq7tVmn1oLDXxGomm/kZ5UlViA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmpcfIhO; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmpcfIhO"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3a60cb94b80so37951831fa.2
        for <linux-nilfs@vger.kernel.org>; Fri, 09 Oct 2026 07:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791554999; x=1792159799; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VcCKhy+ULTce1/sRIbiZhrqW/+l3/hqpSg51rQi2k5A=;
        b=jmpcfIhOl0FWaUzgoqv1N/bnKnJbtE2H1bdbW/QicIi5lw6iN9C7UX3bJLOkRiMRVv
         gLBpTUAiFEYvJ8kKLOC+XE2c+CWZxFGeA0XX7VjXKTXZXXs8uLA8QaH4ydQEgpqRzKT8
         MgttbfQ6BE641uVnCWthuT1L5yR27m/IaJ/+yebpEpzYm112uS1oyp01uibtv6igh9Lx
         /w8jOJk33G3w7xo0KQFcU4bDw5VATIJaFiQvo1TtmrLGgOvplrhng5NL8vhl6Vy49aDZ
         t9JuiX0/9OoS4CSjy65P+T4nxRwNFisfk/zDXENg0g5weGTW7K0mFdgn/usTKoEJ1JAL
         YcAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791554999; x=1792159799;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VcCKhy+ULTce1/sRIbiZhrqW/+l3/hqpSg51rQi2k5A=;
        b=jgKRsdan/6HsDTvt0PDhBxgPanCG20h5zT3wy0/56csOYTDBufsZJJVXym5nia6m4x
         2Kmf3NRqDyV5FAGPwAtfiuqf5rFwykWEZ77bmd1a/gWLsvisBD3jimRa+7KlsE/Vh0XG
         0rCwRD8oyMa7bGGD9sCoaxLjexu9rXUxAnY7xhvdia52Us9dqllc0BuhnbiR5G5P8s5u
         zpFrXtKWlbF7mhWv0gWg5on2yVknnTuP1tGs2rFUvo6aPo9+gBHtMs+tjxj+CEk65Vkx
         CHoycqPKp2aRbP+/yAxOMz2XQr7o4dsE/tcTHOTA0BhoXOegfVQO4A92B8doke3eOaUs
         1Gyw==
X-Gm-Message-State: AFq9FYK3nsX0mLkA5TuepG34qXGoQavyHOFNnXhMZVDpzge2KWHLucpd
	OyOd4MuWzk/Nhe8JXuNBJ0W08SRwx+taiSM1RxMTom6U+/R0hdPZIt2u
X-Gm-Gg: AYBFou1xYDwGsM6FTe/I/c6KOKv2XQDatnT1Oi1y57Y0/5VHSZqux0UugQgjD3dHgii
	DolT0UgAU7HPz3Hv4gASWeD2E2wQXiW+R7JiwUVxz9y40PpEU68Y/tYCUjj7uWRUpz4laFQ/f6Q
	A8oZZIfzqFFuWC7WSeLaKtvDtBpWTy7zDWcu0JM5Bi42lbXApfzjoWukIytcF6Fx/NPLBY76yXv
	L3VmyphjiQoMhZsWT/1TGqLdo9z9aqjZztEqsBjKABJ2Xvie9Xu1FLXD8v6+XzMGz6BxfiJDDhD
	Ky6m/77bCOnYoMroyaNrS6KeDSQyFDHRVvzedWs9oE+AiWGyvZAm+vadUISxZmbouPltbqBLoWK
	lBxXe0TQl3yvfdBg5V/ch5C0zHIAY/Q0HGx9HT7Cw02y5ftQ76UNNz7Opwm92cyaqhWTC0lcae9
	aK81nY0gcz7guUWWLJFfldLM5j/k0PN+701bkUPB5k19U5fwXig3AsWXCqfL/JImJg1s3r1Kx+3
	pdbPU2Uf1XrlZDdKlauu/mIErTYOg8Z
X-Received: by 2002:a05:6512:3da7:b0:5ba:4408:7801 with SMTP id 2adb3069b0e04-5bcde8c9b10mr811066e87.53.1791554998613;
        Fri, 09 Oct 2026 07:09:58 -0700 (PDT)
Received: from [10.128.170.180] ([77.234.210.12])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bcdde913d0sm689165e87.26.2026.10.09.07.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 07:09:58 -0700 (PDT)
Message-ID: <47d7da4a-5029-4c56-a5ac-3e4c526cc569@gmail.com>
Date: Fri, 9 Oct 2026 17:09:57 +0300
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
Subject: System writes out modified portions of the last memory mapped page
 beyond file end if file is resized
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Detailed description
====================

Hello, there seems to be an issue with NILFS2:

1. Create a file, truncate it to some size that is not multiple of OS 
page size (which is usually 4096).
2. Open the file.
3. Create a new shared mapping (MAP_SHARED) using `mmap` from 0 to some 
point beyond file end (but still on the same OS page as the file end, 
otherwise next steps will fail).
4. Write some data beyond file end using the mapping.
5. Resize file (e.g. using `truncate`) so the file end is now after the 
mapping range.
6. Observe that bytes written beyond file end (using the mapping) were 
also written to backing file after resizing.

The last bit violates the POSIX specification, extract from `mmap` 
documentation at 
<https://pubs.opengroup.org/onlinepubs/9799919799/functions/mmap.html>:

 > The system shall always zero-fill any partial page at the end of an 
object. Further, __the system shall never write out any modified 
portions of the last page of an object which are beyond its end__.

Linux manual <https://man7.org/linux/man-pages/man2/mmap.2.html>:

 > For a file that is not a multiple of the page size, the remaining 
bytes in the partial page at the end of the mapping are zeroed when 
mapped, and __modifications to that region are not written out to the 
file__.

For reference: `ext4` / `btrfs` / `xfs` do not write the data to file 
after resizing, as

The exact same issue was recently reported for ZFS: 
<https://github.com/openzfs/zfs/issues/19220>


System info
===========

Linux version 7.0.0-34-generic (Ubuntu 26.04.1 LTS)
nilfs-tools version 2.2.11


How to reproduce
================

```
#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define WRITE_OFF 10
#define WRITE_SIZE 10
#define WRITE_DATA "Test data!"
#define MMAP_SIZE WRITE_SIZE + WRITE_OFF
#define FILE_SIZE_INI 10
#define FILE_SIZE_END 32

int main() {
   char buffer[FILE_SIZE_END + 1] = {};
   int status;
   int fd;
   void *addr;

   status = creat("file", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
   printf("CREAT: %d\n", status);
   close(status);

   status = truncate("file", FILE_SIZE_INI);
   printf("TRUNCATE: %d\n", status);

   status = open("file", O_RDWR);
   printf("OPEN: %d\n", status);
   fd = status;

   addr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
   if (addr == MAP_FAILED) {
     printf("MMAP: FAILED\n");
     return EXIT_FAILURE;
   }
   printf("MMAP: OK\n");
   close(fd);

   memcpy(((char *)addr) + WRITE_OFF, WRITE_DATA, WRITE_SIZE);

   status = munmap(addr, MMAP_SIZE);
   printf("MUNMAP: %d\n", status);

   status = truncate("file", FILE_SIZE_END);
   printf("TRUNCATE: %d\n", status);

   status = open("file", O_RDONLY);
   printf("OPEN: %d\n", status);
   fd = status;

   status = read(fd, buffer, FILE_SIZE_END);
   printf("READ: %d\n", status);
   printf("BYTES: ");
   for (int i = 0; i < status; i++) {
     printf("%02x ", buffer[i]);
   }
   printf("\n");
}

// ::Expected::
// CREAT: 3
// TRUNCATE: 0
// OPEN: 3
// MMAP: OK
// MUNMAP: 0
// TRUNCATE: 0
// OPEN: 3
// READ: 32
// BYTES: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00

// ::Actual::
// CREAT: 3
// TRUNCATE: 0
// OPEN: 3
// MMAP: OK
// MUNMAP: 0
// TRUNCATE: 0
// OPEN: 3
// READ: 32
// BYTES: 00 00 00 00 00 00 00 00 00 00 54 65 73 74 20 64 61 74 61 21 00 
00 00 00 00 00 00 00 00 00 00 00
```

Steps:

1. Create and mount new NILFS2 filesystem in default configuration.
2. Change directory to root of the filesystem and run the compiled test.
3. Observe that last operation returns unexpected value.
