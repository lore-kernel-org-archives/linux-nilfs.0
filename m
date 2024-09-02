Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F359F13AD18
	for <linux-nilfs@vger.kernel.org>; Mon,  2 Sep 2024 10:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271684; cv=none; b=qEca9IZ09y/mzVDJWr+N3B6KOdAzCiMJ99W0x++CwgXL29ud5safF8dK8MfokIItrCVgOhs7r1tynkFpjX6GVi/RBtUqzacYfADz9Sad4crtIuHWQo2zA6z+ozIeE4AADgcjKbnNLVgt9BDyco+v4JF9FXLuAiR6QUaTdtmSEXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271684; c=relaxed/simple;
	bh=dz+y38FjFkmz7PztH6vb+3wA8b1++1ZfWQ9hV9dueT8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=T8zYiBaE8qkV9DwwL7cFacmJzkfQ07nftx8vj8hjZDaJuJB5DqIK2JzK+Xl4zVJ09O7/Yw6HGnVaI7g34w+NxmCuXDDvzaqVMqK1azhqooP8T4Ye3/objwpE/iUTY67ZwPDIzsj4q4SDsMVpvYKA0vrfcS6ltynhqrmu1Dvkwzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-39f510b3f81so15836805ab.0
        for <linux-nilfs@vger.kernel.org>; Mon, 02 Sep 2024 03:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725271682; x=1725876482;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1ZI8Z1mNTH3uczMmGtu5HRADTUqD8qSIuklYf+UieE=;
        b=AjfKZwQcKojZFoRxWNrO145TgxG3ZgZcmvHuhcMwnU0UCqc75CWbLN2/OiXxoHcQ7p
         lIk8HBnZUj290p17c0fhOoosnhQcOIFjLnGwKfnM/rdFBIegbET6AA1sxXHHEdcmS9N6
         Daw8Y3Uyr/ZeA4Dnb3NQgOCr8cMh97KJLwR6O3uezAuLMJUd6YV/TM+jV1IxWNocK/pj
         7eCjUWPHZCt1EIfJXeaG4XC52eIYwrYfi7bjpJzffOIEHMSbKH5mIOOnFxQjz6ShwQz8
         OlS9AE4SMLCSmQftF2c7spVNcY2ieoPShvv3hgJ9j2cpdQpcXP8uPM1wfq8LC3VoSRth
         rcgA==
X-Forwarded-Encrypted: i=1; AJvYcCWWtvZPhntdxjXhbN90B7Nf+XwrLwhCLMx7wqZH6IePDyYHhd6860DHeAejZF1bLjF2Wlzxa2ub+SsLmg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQw1xczeLR9wXTOiFLhevZV2n5mjd4MZvBGcSs9gSWdy2hbpm9
	aM9Wm5fZnxhUjTytVwU4Mc7AWOmx4wzm8fQB7m14nO5P1kFKd7KZbJEmKgs4EP5oUTmT6TX34bt
	gFuQ7W2jWNnNA1L3FwQsbWMSHEZo2ImbIfWMOiYebrSCUV9qylMG3EiI=
X-Google-Smtp-Source: AGHT+IHEB10cbUaE1wUmk6yLQKuHBOE6EUNcUriJs2vNedp2BXIXZ5tEof05zrXQUZZhQ/xMGP9SpJRhKO+w73CHkYHi0zoJyeLp
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca4:b0:396:256a:2e01 with SMTP id
 e9e14a558f8ab-39f413707f2mr6320285ab.1.1725271682119; Mon, 02 Sep 2024
 03:08:02 -0700 (PDT)
Date: Mon, 02 Sep 2024 03:08:02 -0700
In-Reply-To: <20240902084101.138971-1-lizhi.xu@windriver.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c106810621201ddb@google.com>
Subject: Re: [syzbot] [nilfs?] general protection fault in nilfs_btree_insert (2)
From: syzbot <syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, lizhi.xu@windriver.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com
Tested-by: syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com

Tested on:

commit:         67784a74 Merge tag 'ata-6.11-rc7' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1752cf2b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94f4a91e4d2a2d49
dashboard link: https://syzkaller.appspot.com/bug?extid=9bff4c7b992038a7409f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1012cf2b980000

Note: testing is done by a robot and is best-effort only.
