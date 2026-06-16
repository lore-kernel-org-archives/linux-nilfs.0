Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE0A3D6CB2
	for <linux-nilfs@vger.kernel.org>; Tue, 16 Jun 2026 05:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781589303; cv=none; b=JqdKqrAPFp29umf4Lt5H5ckUTmLqlMk9pFf2ETeN2rCcji/ue4LtX4mMRPhLk4R63s93KXRjloS0Iu40ySNWZocUCdu7ARlwl4GoLeXH3la8rsvmMX7ZKQb1H0wvTD334JlmuJEMJReEe9XPokU5Ccd8Vze4v7N3yWJnvZB3Twg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781589303; c=relaxed/simple;
	bh=bUF0WWM/m3OaIUFsDDSwWLaisMG6lHQGDTvC/M/rkrk=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=PTky6d2lfG7TMykfJhEy1eExNYZk2uhCx1IzFDmHZ3HYuxuOtpUdF1FRUtMJrCEVuGqVp1tkOJrdn+q9DrHI68TtOmwH9iAM6cHaNe0j6ORmPkdPXH4xePrGhTu3Ikn9Ybf83PdhZlpTa96rinPjA5cBux5TpBS1RUKWYZJqe/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=XPgMjkKU; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="XPgMjkKU"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-396aacc5bcfso37572871fa.3
        for <linux-nilfs@vger.kernel.org>; Mon, 15 Jun 2026 22:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1781589299; x=1782194099; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt:date:cc
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AqgXefFuOd3LpRQqkqqqOZeyN+jGArCTQFfTEtCT6Rs=;
        b=XPgMjkKU1IpIOfZL78Du1QJKWtgSlT1Nhi/mNDT7s+tMKqwSgZXHzI32kCLhDwpRWk
         JS2Pw5LRDT9d8ByZn+N6dGnAwFqRTPY/U1WNjESTAiovGH1tHhGjNFPllehGFFNDpHmo
         5B0aFO4hMSUEfB3iWZ85GlWLm0djtuMvldkuZWY1j37LpSlxjXX4B9NKgzlrzP+HwCRV
         iNSVq4CN+37lKPQ1wYqCDCdg4WJidJL5OSIuO+3Ge3ZclariEoyzXBQlY8LiqnFmOBdB
         +Ju5YRcHB6R2iG5OxR+suGp4C/x0Yi/Di5qO9y6JyIRNGQvrTDJA6g/ChiJMKcwwcBjw
         gHvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781589299; x=1782194099;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt:date:cc
         :to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AqgXefFuOd3LpRQqkqqqOZeyN+jGArCTQFfTEtCT6Rs=;
        b=E8NlzyHEnFZeZgt0wF07LLKd/PdRwk5tWfTK9Ogz4mTyCDG8L26usRe6iV+XETfbNa
         fJviqM4S34BXJo+lxr2azHfYbPF/ZXqCWwtD6mbq8rymu++2YXBIN1Wv8NBdLC5VBzYI
         DLkE1HH3bsh9A10B4lEUY8vYDbIF7QcrSDaV8hgrrBzIygAY+cU0Z1bdCyGzDdQHvM1R
         zeg/52nJgj0vkT7/olzP1h/GgPyi3hGPzMSiGl5FYhQ596CLhvA26+k3Cd5Ib0W8pm6Z
         2pPBXFT3rTQs5QlDuizOmUaXW8QUWmt7oGswVfHk3kjYWCYj97JhZ2CUVVECO0GB3FZc
         w6wQ==
X-Gm-Message-State: AOJu0YzlVnHsLPIYtmxItuecaV4rjkn3nIrFTxUGV22JxzKVKpI2mrSJ
	Itg9/sQztE7Kk5svq2LnlrxnypCxC6yBYHHqHHOMXtvutoLEt0fhqTp5o1PtF9VkfIg=
X-Gm-Gg: Acq92OHEGI6VQvtzIzcGGEXDHFSMurhrbktUf/lZlVLYrzppY0n1FSzo+nDThSUtiMW
	LVDg7MeYzBOi91pJ+w7MOduTiCLPMoiPlR+SCowDArigeEGtJuTYL6hN9aHviPJdswO1w5CRNcm
	ZklED0Thi0rlQoPuKW8CErsZEPFDJf0ljpWZA3yAVF3c0qU5+AEbuvQmHBWIeKk7WnQAI/SmJjm
	75wLIIqI7HXiy/OZAmp8ymVy7eHhl3KBTCSP1Vf2zLgGf9yr35gD7TLfL0YI3f3rO69VxZiSZbN
	b/PDU4abEzPOJkBXhJKx0UfK3J5YhgSR+pho4eYbmobwFFajfoWE9HpvcsFrS1KYyYnfBCMJo8k
	Lq3Q0PlRPKS/axW1k21T73cO+1n/C5PyZBWbd2imUpfUTNw7/yVk5Sy4YhLn2vcIHd+rLsRMepM
	j3q+WssGMErpWjIk+oATaeqS+LnOCfsvnL40H/o89ZJgKa15a+ab7X3CrpUnFvX2ehXBq+FcCqg
	LJc2GWoDJ5N6MCs6Frj
X-Received: by 2002:a2e:a80e:0:b0:396:6bd5:a9c7 with SMTP id 38308e7fff4ca-3995c85103dmr5860411fa.19.1781589299019;
        Mon, 15 Jun 2026 22:54:59 -0700 (PDT)
Received: from [192.168.3.148] ([31.23.24.48])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3995c1918a1sm4087581fa.19.2026.06.15.22.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:54:58 -0700 (PDT)
Message-ID: <6865b4242f6352ef0b2b40a9cf7a85d12464279e.camel@dubeyko.com>
Subject: [GIT PULL] nilfs2 changes for 7.2-rc1
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: torvalds@linux-foundation.org
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, konishi.ryusuke@gmail.com,
 kartikey406@gmail.com, 	shuangpeng.kernel@gmail.com,
 zenghongling@kylinos.cn, Slava.Dubeyko@ibm.com
Date: Mon, 15 Jun 2026 22:54:56 -0700
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello Linus,

This pull request contains fixes of syzbot reported issue and
various small fixes in NILFS2 functionality.

Deepanshu Kartikey has fixed syzbot reported issue of a hung
task in nilfs_transaction_begin(). The root cause is that
user-supplied segment numbers are not validated before
nilfs_clean_segments() begins doing work; the range check on
each segnum is performed deep inside the call chain by
nilfs_sufile_updatev(), which emits a nilfs_warn() per invalid entry
while still holding the segctor lock and the sufile mi_sem.
Fix it by validating the contents of kbufs[4] in nilfs_clean_segments()
immediately after acquiring ns_segctor_sem via
nilfs_transaction_lock().

Hongling Zeng has fixed a smatch warning in nilfs_mkdir() warn.
The patch corrects a semantic issue related to the use of the ERR_PTR
macro that arose from a recent VFS change.

Shuangpeng Bai has fixed a backing_dev_info reference leak.
The setup_bdev_super() already initializes sb->s_bdev and takes a
reference on the block device backing_dev_info when assigning sb-
>s_bdi.
nilfs_fill_super() takes another reference to the same
backing_dev_info and stores it in sb->s_bdi again. The extra
reference is not paired with a matching bdi_put(), since
generic_shutdown_super() releases sb->s_bdi only once.
Drop the redundant bdi_get() in nilfs_fill_super(). The single
reference taken by setup_bdev_super() is enough and is released
during superblock shutdown.

The following changes since commit
254f49634ee16a731174d2ae34bc50bd5f45e731:

  Linux 7.1-rc1 (2026-04-26 14:19:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git
tags/nilfs2-v7.2-tag1

for you to fetch changes up to
e5925f33e4fa9ee313d481557607adce8e30ed2e:

  nilfs2: Fix return in nilfs_mkdir (2026-05-20 11:20:56 -0700)

----------------------------------------------------------------
nilfs2 updates for v7.2

- nilfs2: Fix return in nilfs_mkdir
- nilfs2: fix backing_dev_info reference leak
- nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range segment numbers

----------------------------------------------------------------
Deepanshu Kartikey (1):
      nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range segment
numbers

Hongling Zeng (1):
      nilfs2: Fix return in nilfs_mkdir

Shuangpeng Bai (1):
      nilfs2: fix backing_dev_info reference leak

 fs/nilfs2/namei.c   |  2 +-
 fs/nilfs2/segment.c | 22 ++++++++++++++++++++++
 fs/nilfs2/super.c   |  2 --
 3 files changed, 23 insertions(+), 3 deletions(-)
