Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005A21FEFC7
	for <linux-nilfs@vger.kernel.org>; Tue, 12 Nov 2024 14:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731421928; cv=none; b=GGjKggH9+AB24JP5HifS0I59EzrKzCVyWxWVPzrbZdjnENiXQYLEiqs9eSWGym5NW1kBlsd6/y/19hd/mY7tCZC3Our0JG0FPlrFt/QVSBRqPPEt9pvAOEBwJ2NHxx8SS38R+f7wPZFWbUQ7cIsdOcZmmD53ukOirJxWZ8Vb4UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731421928; c=relaxed/simple;
	bh=fAR7NsHOFHIqrJXvbMl4qc0UVdjQmpaMiqyavC+tHJ4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MwTEt8bzxzachfbn3TPblv6v2YSG3eVf5NzgHl58ZsGTvSvBbm39h32bzqnDdJlOESopah0ScCrHnsME/P8cxH7uiRMVHDtXPiXtjLPrnQ4+O5X123Mt3eWlppKQ8rLdECuu5oqjeuT/3aMBiDMlT8/kxBIQ5mRGCu3LMd162GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a5b2ec15a9so62055465ab.3
        for <linux-nilfs@vger.kernel.org>; Tue, 12 Nov 2024 06:32:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731421926; x=1732026726;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nBWs2Zd4T8e9v0oYYaH0pBxxLwc7TOyhEeIoWtbFK8Q=;
        b=veYhJBi4WirLbFM6YzLyVpHr/CPtswwQznuTI7dPMVqIHKeMLZX36s2PCcvyw/c6RI
         ovLlQtpzreJ+xfBQOPBzzQ+5YgkYTwJGHsOhGt1XgYgyAzrNmBDeNNW3JMySI56r2fIC
         QgglTrW0AlcWc0ra5yd+gwe2cULxMWFUuWe9O2MtN64MlPB6sOZ7UedzZzI3zmgyYDhV
         s1gprDRf0FJW+u4Q9JRu6FGynqSZMofcVJZU9VrFIPsRvfk+7Hhwdc87+orVfq8Yx9g2
         PIwFKjgBbUkUR53QtawmMkTNhZaReFHa4MWGzGAifsSpPCYzEV/OdKcpM0fVkW3XW+1b
         FyIA==
X-Forwarded-Encrypted: i=1; AJvYcCVGv59V+Nrn/DK634OXEAdkf3RlBpkEGBqF2K7KY2vStUA96wUegGSGGH0m+dyc8y73odheExB4ISiotQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEQA/LIfCvtSusSq0GoxHc1e/btojsYd8A4ZgDuQIR4sBKsEp+
	cdcC1//K+r+vCaXPihdfIqioDOlko2ybdvYIo8sYi9CyRO2TaNtUUeaiavWGeC5QXdwR8NY6tEH
	56ui8VF4qtvEj3+s1Df1cNrdS1tXQ9QTrR8DsoPjkPpxUmDdYqmY6RCs=
X-Google-Smtp-Source: AGHT+IH+odsalTFOJKKKW5uexg6WaA9g4d0Qrx20qSXJsuWc8jFUFFgObR0N2apLEnR9cuwGy55QGSNpcSZOkcSZ/64ixYTgB++E
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3a87:b0:3a4:e8cc:2aaa with SMTP id
 e9e14a558f8ab-3a6f1a07897mr183506185ab.10.1731421925894; Tue, 12 Nov 2024
 06:32:05 -0800 (PST)
Date: Tue, 12 Nov 2024 06:32:05 -0800
In-Reply-To: <20241112.231215.1262254749077533950.konishi.ryusuke@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673366e5.050a0220.5d845.0005.GAE@google.com>
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

commit:         2d5404ca Linux 6.12-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13600130580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=96d5d14c47d97015c624
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16d201a7980000

Note: testing is done by a robot and is best-effort only.
