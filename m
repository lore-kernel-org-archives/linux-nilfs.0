Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CC53EF0DC
	for <linux-nilfs@vger.kernel.org>; Tue, 24 Mar 2026 12:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774353667; cv=none; b=AGo/mkjRGFHFHOxhTZ1AXfn6ovZX4wSnRpmrkzWK41eECd3J5gZBwr2uSrdKHmSXaDB3WdpfpKiDMH8/YmKNXl+KG9jjgxOk+DkfS+9TezMYwjSXXSZE0/nQJ/oGIYIujj2s+JWk3N2chMiLgLsVos3xBbhyZB+j7CTl2OowfZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774353667; c=relaxed/simple;
	bh=NZdgAdznHpDbsb0SoRtymRAclQN4M4YzjI0NpfykQW8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=rt8bZ3Txd4a5Dtpv8JWQzOkDvB24f87Ib1bGTuVJASa3BrkjEr967iPmo0HjqCXbsvWlMDVfr4VbwyZHEGKKWWL3riFHPYtFOolTzOBxgAgstFZZWtd0AwnHtmpPfy7kq8u0kug8d81YO3Mvqp8VoBXIxPUnldiefcHtu1Ho9Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-467e8aaa943so15028636b6e.0
        for <linux-nilfs@vger.kernel.org>; Tue, 24 Mar 2026 05:01:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774353663; x=1774958463;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eq+NSgDd45IxmtwonKl+qVks/DSrzpVI0yR9kUnzlGs=;
        b=B7oBg+hLnOY4T0kRMkdzwb16HoJUqu5PyVGZZbevFWlAF7CSiESnNyNH2rG2f/T4IN
         8xmcAw6Q1SLMv8eNE/08wv37GtnRccfe8oHr5WSK7bdLWElPEBDfTpMsaxtZPgE/OMr0
         kBd/n3/+aoRsraLjd8oWQVKsuiyK7nDupI4KEU9Q5jamHfG8Y8JgafKfEDDsu2rIM4A1
         BatcuH0hNybImkS1V+jDspF4aCzGg1Q4LAdoWenGa/yfy2i2c46fLKc9wJr4wbxD+SYT
         cEKBK+l6+8puAmDzqSVknUt9xV1xbsgVOJ+M2e15J3p6WzHg77LcKE9QSnZOAfnLxT8x
         +Y/g==
X-Forwarded-Encrypted: i=1; AJvYcCW34haUqTqsdqfAlubt/9JlzWwILkmYxLYNdJ0dsPGl9aevFzDY8Ss52BqdkSme5t1oBkmgAyfhEMEOWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbHVGJq07HyejVMNQi1AijSm+1ea95EwN/kpCJbMv6CrbYAvsJ
	nbYdmaciK4CWWLjKKJLlTxcBLEvXovouvyaY9lR8BAAUKaRpgVU8GC3CF6goDjXQAxaS44RzVB5
	UG+LwRTG2HM28mLeiBxtBa8/pLZFp7Y022mV6HTXkJ/3MQnhvxcINyJrypvA=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1a07:b0:67d:e505:cf5f with SMTP id
 006d021491bc7-67de505d224mr6123511eaf.1.1774353662909; Tue, 24 Mar 2026
 05:01:02 -0700 (PDT)
Date: Tue, 24 Mar 2026 05:01:02 -0700
In-Reply-To: <f75eb907cfe0944a5cc3bd02d137fce8.junjie.cao@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c27cfe.a70a0220.59f55.0006.GAE@google.com>
Subject: Re: [syzbot] [nilfs?] WARNING in nilfs_ioctl_prepare_clean_segments
From: syzbot <syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com>
To: junjie.cao@linux.dev, konishi.ryusuke@gmail.com, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	stable@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com
Tested-by: syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com

Tested on:

commit:         ebd34541 nilfs2: skip blocks with no bmap entry in nil..
git tree:       https://github.com/Lukaaa525/linux-kernel.git nilfs2-mark-blocks-dirty-fix-syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=1100d6da580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1eff8566a28238e
dashboard link: https://syzkaller.appspot.com/bug?extid=466a45fcfb0562f5b9a0
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
