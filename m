Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AA43CA4B5
	for <linux-nilfs@vger.kernel.org>; Tue,  6 Oct 2026 08:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791273785; cv=none; b=XzJ5MTGF8LqzZs5lZ6uA2x1ZuqdZc5v222qtRRp60I9EksnnvosCfkk7PiLQ2pJddVaU3u3MYcQtA/Zn4JMArsGCE1fXaj428cgUlC1S/MkVk95+4Ow6S4RWb8tCV869E/tQf4aXT+s2kvgRdWjZjX6WX5IxMDxzsPizczVrC6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791273785; c=relaxed/simple;
	bh=soAKbJKVAKYVonBGciMChKUxFZIXhCTdAHOIPEOkLrU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=DG8KHoIthv8KS3t/PCMJgn6l0vRJQbUjddr23vtFDoJPOD/teE3y+BT2AVzsvlmBwWDek3OtV23GjQabf1aDGNSWPG/Ec34X0NI6R1xBdPccuoGKea+UYaF90CHiQRepK+3alwts9jIdWyK1U19+bxaK9MZyabPxh6rB2ZcgAqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-823dbf1a5d5so3006250a34.0
        for <linux-nilfs@vger.kernel.org>; Tue, 06 Oct 2026 01:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791273782; x=1791878582;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dXRJKeg1gO2KuyLvXLXMHRwzpKbpiXcV1AZwuafnO58=;
        b=pumWScieGNFlZkRaAe0ZxMuwOsDn9ekbN2oKPPz092lAUB9bAGg7fTzNbvAXjDcndL
         iuVq4twev7yDfO0CRMj9TPF1FKzvhIFkCvh34BE0QZU3RNM7KhjrYZglPzNvA4Gso9Z5
         iPI7nP9Ow5C65BFYyubQSNCZmxUNMYAaV4o6s2341CUbnU8cK1Eg8unsmqIGD85EmuMO
         IkoNJf1x90p7+l1Mf426wOpDBti+jDTFr/iAAALSuhbdYeq5gAN2+9BT0eR3Tgyzq4Sl
         11nGRCV1ipNrIUXj5V6WqpLVTDvi9D315HlGUEdWVuYMtls0FLxcJ3sy6JeFxMkrpJg2
         NM4A==
X-Forwarded-Encrypted: i=1; AKwUvByy0y+66AZzC+50wS5IevqP1lO97zoP6htyR3ASW8vo4VnaBKgFV6JXTIVJHF9WzYGMdrH4mnWM10NAQA==@vger.kernel.org
X-Gm-Message-State: AFuF++lNNfRWUU+NIb7eGQ0lBMBYK/JoqgpeSmDu9cdye/1QTphUlshA
	anGoU/mAj3/SPwyosAJQ6E8g7svgmtiWu08daPps6th8qq4bGYdFYV3954vh8Sou5Nh/LdIminT
	7dc8mmiBznkh7H4EXa/lt4gXwONvbGaQqLqR3TnqT55ZkhtmVN3N/YBfukHY=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1302:b0:4ca:8d6f:4258 with SMTP id
 5614622812f47-4fb4047d3abmr572277b6e.37.1791273782246; Tue, 06 Oct 2026
 01:03:02 -0700 (PDT)
Date: Tue, 06 Oct 2026 01:03:02 -0700
In-Reply-To: <20261006.164626.1711564426255042769.konishi.ryusuke@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac4ab36.592976d7.257d.0000.GAE@google.com>
Subject: Re: [syzbot] [nilfs?] WARNING in nilfs_rmdir (3)
From: syzbot <syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com
Tested-by: syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com

Tested on:

commit:         a90ee430 Linux 7.3-rc6
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=14b801c9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=341a98f91c13ec9
dashboard link: https://syzkaller.appspot.com/bug?extid=c388db0347b7fc88fa7a
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=162b1ff5580000

Note: testing is done by a robot and is best-effort only.
