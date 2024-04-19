Received: from smtp2.inetstar.ru (smtp2.inetstar.ru [213.219.228.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFBB77F13
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Apr 2024 16:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.219.228.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713542921; cv=none; b=TtzdD2x+2mxSxTzPWpGCA+UvEAWhyGxeXx4vnKVj7OolVHJo6Yil58SdApWp3RV4efwAa4vlqAbYduKsG/6ncIfhP1ojw5nBG1ccMNtt++N9mw+YQWCT0k2+HsgeaZnEksyvRPKlVKEl6yG4VERmUIRkJe4CpLXZqQ0EdCDzoXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713542921; c=relaxed/simple;
	bh=2eMTEgCEs2w4UcQdgmR9WMCdUoYLrrq0OGp5FcCayqo=;
	h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type; b=GA4JWsAuS2GqLNXTe2IgDwVeMNCJtAvjyXfdoH1wvF/JHqo4/o+0EeiLf4wnaySuV0DvFwPGXQrYgK/9c50ln4oLAzkoTxOK/1M9Kcksxy3ca96DD9gX7g35OhQJ/u84/uzAtC5b7dAvfRm8m9NTSC75qmwYyE7N04jKvc+VvFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inetstar.ru; spf=pass smtp.mailfrom=inetstar.ru; arc=none smtp.client-ip=213.219.228.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inetstar.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inetstar.ru
Received: from [10.0.0.2] ([193.107.193.43])
  (AUTH: LOGIN work2017, SSL: TLS1.2,128bits,ECDHE_RSA_AES_128_GCM_SHA256)
  by smtp2.inetstar.ru with ESMTPSA; Fri, 19 Apr 2024 19:03:27 +0300
  id 0000000000A68403.00000000662295CF.00001732
To: linux-nilfs@vger.kernel.org
From: Veter Kamenev <nilfs19@inetstar.ru>
Subject: I'm trying NILFS2 in kernels 6.6.12, 6.7.12, 6.8.4
Message-ID: <bbac8195-cf8d-1685-9038-9d45cb9865d7@inetstar.ru>
Date: Fri, 19 Apr 2024 19:02:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US

Hi folks!

I learned about Nilfs2 many years ago and was impressed by its capabilities. The idea is brilliant!

But due to glitches, I returned back to reiserfs3, which works like a charm, although it will be removed from the kernel in 2025.

Now, after several years, I decided to return to Nilfs2, hoping that the bugs have been corrected.

To my greatest regret, I received errors in all kernels and the system went into read-only state.
Luckily I didn't lose any data.

The texts of the errors will be below in the letter. In this regard, I have 2 questions:

1. What is the reason that after so many years, Nilfs2 still cannot work stably?

2. Are the errors I sent corrected? If fixed, then starting with what version of the kernel?

Bugs:

Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty page: offset=2579136512, ino=3
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=0, size=4096
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty page: offset=4329472, ino=6
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81375872, size=4096
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty page: offset=5189632, ino=1593910
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=0, size=4096
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty page: offset=45056, ino=33745
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81477095, size=4096
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty page: offset=0, ino=1594060
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=0, size=4096
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty page: offset=2580111360, ino=3
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=0, size=4096
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty page: offset=6815744, ino=6
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81370706, size=4096
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty page: offset=2580316160, ino=3
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=0, size=4096
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty page: offset=7106560, ino=6
Apr 14 15:10:10 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=5320006, size=4096
Apr 14 15:10:15 MainPC kernel: NILFS (dm-5): discard dirty page: offset=7139328, ino=6
Apr 14 15:10:15 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=5320014, size=4096
Apr 14 15:10:15 MainPC kernel: NILFS (dm-5): discard dirty page: offset=45056, ino=33745
Apr 14 15:10:15 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81477095, size=4096
Apr 14 15:10:15 MainPC kernel: NILFS (dm-5): discard dirty page: offset=7282688, ino=6
Apr 14 15:10:15 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=80559629, size=4096
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty page: offset=2580275200, ino=3
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=0, size=4096
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty page: offset=12890112, ino=6
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81369152, size=4096
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty page: offset=0, ino=54311
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=0, size=4096
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty page: offset=5189632, ino=1593910
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81477110, size=4096
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty page: offset=45056, ino=33745
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81477095, size=4096
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty page: offset=20029440, ino=6
Apr 14 15:10:20 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81370709, size=4096
--
Apr 14 15:10:24 MainPC kernel: NILFS (dm-5): nilfs_get_block (ino=55694): a race condition while inserting a data block at offset=0
Apr 14 15:10:24 MainPC kernel: NILFS (dm-5): nilfs_get_block (ino=55694): a race condition while inserting a data block at offset=0
Apr 14 15:10:24 MainPC kernel: NILFS (dm-5): nilfs_get_block (ino=55694): a race condition while inserting a data block at offset=0
Apr 14 15:10:25 MainPC kernel: NILFS (dm-5): discard dirty page: offset=20369408, ino=6
Apr 14 15:10:25 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81375846, size=4096
Apr 14 15:10:25 MainPC kernel: NILFS (dm-5): discard dirty page: offset=45056, ino=33745
Apr 14 15:10:25 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81477095, size=4096
Apr 14 15:10:25 MainPC kernel: NILFS (dm-5): discard dirty page: offset=0, ino=55694
Apr 14 15:10:25 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=0, size=4096
Apr 14 15:10:25 MainPC kernel: NILFS (dm-5): discard dirty page: offset=22556672, ino=6
Apr 14 15:10:25 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81370389, size=4096
--
Apr 14 15:10:30 MainPC kernel: NILFS (dm-5): discard dirty page: offset=84746240, ino=6
Apr 14 15:10:30 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=58879578, size=4096
Apr 14 15:10:30 MainPC kernel: NILFS (dm-5): discard dirty page: offset=45056, ino=33745
Apr 14 15:10:30 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81477095, size=4096
Apr 14 15:10:30 MainPC kernel: NILFS (dm-5): discard dirty page: offset=201527296, ino=6
Apr 14 15:10:30 MainPC kernel: NILFS (dm-5): discard dirty block: blocknr=81375118, size=4096


Sincerely yours,
Veter Kamenev

