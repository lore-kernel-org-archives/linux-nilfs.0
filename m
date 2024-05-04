Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5301CFAF
	for <linux-nilfs@vger.kernel.org>; Sat,  4 May 2024 11:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714823868; cv=none; b=X0C2KZ2OEzTRiqw8TaUs5ZNdxOQiIg7ZyGMv3k7vgaraESSBQXstrYj+apBhLusX3OA9XewEZ33jxU3Dvwv5QEEsIhqD52e4RQcYtT/DK7BAPQs7Sl122ZeShp5X+yzLL6pgiF2h4IcCenQXvbqwfA0yCAGKfEbeF5lMeNT/Lh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714823868; c=relaxed/simple;
	bh=6G26L4Ggy88lgmx7QULL3upmSLzbmCFExJvwWlyMfTQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=G8TWJQJ25e/mJVCtFrR52C18lL58/G3+wCnI8wEHB7vnTWTFf91yN/QaOHqGSqrMGfll2aMlxCpm2UgZTe4aFmhk85Q58jN96f4N14CNlbila3ASd6dX5CnyYpGaFarTcrvxgVi5UowDRdRaU+IN0h0aGCgn2m+8LKjDCuCPMxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hce/Qrqc; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hce/Qrqc"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-61bed5ce32fso4899537b3.2
        for <linux-nilfs@vger.kernel.org>; Sat, 04 May 2024 04:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714823866; x=1715428666; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6G26L4Ggy88lgmx7QULL3upmSLzbmCFExJvwWlyMfTQ=;
        b=hce/QrqcQkK4YbpZBBjgyzmZLVsQfs6b9ogsp+67shavxNC6vEruGAAhj1ByY6sgXl
         G/IlzxfTphZ/S9aClAe3CXPjEf7le55621s9EpXAhOoMJIM42kpHpGQmscHVdevq6+Rf
         6gH9SZEXR3v60VYR0nP9dRssfEGLu4E3pFThoZXpRRWQB49V71u0Q58mOdrihiz428/X
         niD54zc60IfUVqKJsD6P8oN2xQaF/s4/drJiUSvuK7vKDh1rkwSOKjN0PuOVWRB+vuaJ
         lojuuf5N8BkG69VdzIRqTG5fEMAU1nUO0+shi6yTyqNUo44DYduYKL2MmOar29ET3tNb
         VeGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714823866; x=1715428666;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6G26L4Ggy88lgmx7QULL3upmSLzbmCFExJvwWlyMfTQ=;
        b=FtJUuAERqVMqmLrPOY0RiSuOUrFw2XQR1lKrataeDNPMD0NDZtb2/9PstNJoRZQK3Z
         R7p5G9stNjIlA4MUyut6izygxsyBrmqSGTs4whq2LNOvg1EeDBK32BYVHKJKefh/COJ4
         uGvAF5m5DpMmmjR4YC19HFm5GBVsgg9D4t4vvNgfEDYXblvbMNtZcpogB77zhTvf/xUj
         W5RvRmqCvOXZsOY0iwktOF1Rm9cHXT/J9u7p6HYvfamVZirx+cn/LPNZh8Olv1ifPTqf
         h1hjc7E5oXyRGZquKzre0nSZbzpeeVprXMQKW3UMS4PDN6O7fv7iEES3koXIjSPaGk/t
         dHvA==
X-Gm-Message-State: AOJu0YxhbIbpSll8XKxv8uPNxdKencaTWh4L6SBUIGNmaqnBWcRbuxxg
	LHtEqrOIgXPh5RlKwgnD+tc29oC394SUvuzpUq7tQ1NNR4M+hqA1o01OSC3EAa0d9Xjb1BJxEyL
	7sStfVZokhRn3L4LyApBt/xYxBQkbiwj/
X-Google-Smtp-Source: AGHT+IGMdkWQbKU8nc5znTiiDytF0lXMtoTjVkIraKVz5b+Ww/DhKWMYHEL24ymcNgtCSu8F3fnttn/WKQDP4Pm7CV0=
X-Received: by 2002:a81:a14a:0:b0:61b:3484:316b with SMTP id
 y71-20020a81a14a000000b0061b3484316bmr5397199ywg.14.1714823865927; Sat, 04
 May 2024 04:57:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: dexen deVries <dexen.devries@gmail.com>
Date: Sat, 4 May 2024 13:57:35 +0200
Message-ID: <CAJUT6o6xhy+o=iiWv-h-8UeVx1WCvEmu2NVAb3X6xTvQt8XKBQ@mail.gmail.com>
Subject: Creating up a snapshot and mounting after filesystem error on NILFS2
To: linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A forced reboot left filesystem in inconsistent state (possibly
consumer grade SSD issue). It would mount r/w but exhibited runtime
errors: some recently modified were malformed; attempted writes were
rejected:
>NILFS (sdb2): vblocknr = 101945318 has abnormal lifetime: start cno (= 534472) > current cno (= 534431)
>NILFS error (device sdb2): nilfs_bmap_propagate: broken bmap (inode number=4)
>Remounting filesystem read-only

I tried creating a snapshot from recent checkpoint to read recent good
verison of files, but that was also rejected with the above error
message, and the snapshot reverted to checkpoint upon subsequent
mount. Turns out there's a short (~5 seconds) window after "chcp ss
..." when the snapshot can be mounted - about 5 seconds, before the fs
driver attempts to create a new checkpoint, ending up in error
condition.

$ umount /dev/sdb2; mount /dev/sdb2 /mnt/test # to clear out error condition
$ chcp ss /dev/sdb2 534430; mount /dev/sdb2 -o ro,cp=534430
/mnt/recover # set up snapshot and immediately mount

Hope this helps somebody, maybe even me, in the future.

Thanks,
--
dx
