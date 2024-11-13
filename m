Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F51916BE0B
	for <linux-nilfs@vger.kernel.org>; Wed, 13 Nov 2024 03:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731468246; cv=none; b=W/LujT3boeMl8QZ/0Y5g9K6rhaVSvuYIwvhch7elo17NKs17kONJwIS2/cIgOZI+N3fN+jtkHwODqYT5xmbwWVV48oB2nf89cCuTJWuiXY0uxuhIWQELA2CnDknLvTFq/hHtfDE6X1NAn52AFCN6pIyxe5dqVRgTTVLDYt0qGV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731468246; c=relaxed/simple;
	bh=uoXUQvL+voe2BXfiNcHQ7JcNqzm8pU1Hl/H6jGCeW/E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NGr1YsxBWE2sdQu9XgWgIbkh4TtjkgYfzBmssruSSlCRSRKray2Qz9Qz4wDZ2HB2k9X6xZQ53P0lFcw4WzbaCkpZRPuo4GmuAX7hPG7lW2Whe8pUKcYZgAXdl6GwmPGfv7+xIo8rzLYh60RnlVGjAEqlf0eF6CD3BH1X5p2o24o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3b506c87cso80390135ab.1
        for <linux-nilfs@vger.kernel.org>; Tue, 12 Nov 2024 19:24:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731468244; x=1732073044;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J8endzVnlVtBMxDaxFxSUROkn9xiEPXwSq8voUGBPm8=;
        b=jIM1EPhnXTOueO+luXf255MVfVhxhnPnl6aWnQtWSNTRmq6dRSu2OMjWos6WT4NvgR
         2xTXLg5xrGl8coToR3EP4ohIUZenorjVLjs40uZMjbrFzkp3shIsup1I8WRmWv/Eg7In
         S+Pi+dd5c9kRa8lDgtl6elpmtDqh8wTRCUVLJ7wBtu+grFSDyVCc5S+nlnPii3Uh0i2i
         TFhxeCVxi+RaNhmfkcpi3FOlCTqX2WS55Sb8mpOZs9721l4Ihn2o7DSUGLWRUruftE5s
         ZQa210RoyCiv8P1j9VV9pWRLbTyEpO3BF6LR2p4xwI2+oaG2FqZLMHGTauAB8TBBfmU9
         nm5w==
X-Forwarded-Encrypted: i=1; AJvYcCV50stD4E18EafZR4CtbrZPpOK5Rb6y934eQKENy99ofoa/1aWleClP3md05YFTBxWCNIJuuh8xshuMmg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUMrB5+li25w1jbwTtIjgA6GRcOVhhtzeS+bYaOhNlVGTFm2gs
	xXrGSOXeJ2aiBT4iNcALfvg91d4vbP2B1yYSvGwQDB6Hb6EZ123S3FNbRxsfEdRW5GxqkupmlJW
	psDnniiYSXP2rK6GEsXhz5X7nG3qJNsG9lwwJcHxREka1875IRzMOFjI=
X-Google-Smtp-Source: AGHT+IGzyhjyVJhB43FFws0PG/tZKlTDvFBkWagHkCFnw6jxQjPpF/H3tfWnxkb6iQf+/8BawXI0NIMy77MJbCM04WSWfcYJmaTV
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1706:b0:3a6:acdf:1a19 with SMTP id
 e9e14a558f8ab-3a6f1a22195mr198754015ab.18.1731468244414; Tue, 12 Nov 2024
 19:24:04 -0800 (PST)
Date: Tue, 12 Nov 2024 19:24:04 -0800
In-Reply-To: <20241113.120420.319092919822964048.konishi.ryusuke@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67341bd4.050a0220.1324f8.0001.GAE@google.com>
Subject: Re: [syzbot] [nilfs?] KASAN: use-after-free Read in nilfs_find_entry
From: syzbot <syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Tested-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com

Tested on:

commit:         f1b785f4 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=121ba4c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=96d5d14c47d97015c624
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11464ce8580000

Note: testing is done by a robot and is best-effort only.
