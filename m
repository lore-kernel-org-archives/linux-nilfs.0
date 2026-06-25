Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA93A3769EF
	for <linux-nilfs@vger.kernel.org>; Thu, 25 Jun 2026 09:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782380944; cv=none; b=fhpl4OP+WjAiDzPinfUKX5Xaw1K7oBVg8s8cANqcPksmZohWLt5ffGvpToNSUvINGURp+6yZTJvFMOkw5NcvgZN2Z2KUhp0neI585X9T0UksAF21UzWT/JyKVICJctYdnoqr+vVYLjVv9k5x411VEXe2LjO4x0mcneUzSWl+dno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782380944; c=relaxed/simple;
	bh=BXbIQG/QXjnUkq26Tiw7+SOliZLbHNceg8UX45FQkmY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=D5If7Bgbg3fxL0YiPg7K4opPrkAiFC06WyQgi4SiF6jrMj5KcuwJKbWU5Mi+zDZ0HYPyz+sl879M3sq7tcescB6QVHuYBMTBhnADm4jezjMuqPHEYd/Is+qAC8HXaryTYNUeIXzKKFOo3oqXr3Sl/EODnelNMJoCZeNK48d/4uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-69e887d70dbso1217833eaf.0
        for <linux-nilfs@vger.kernel.org>; Thu, 25 Jun 2026 02:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782380942; x=1782985742;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ILUleABfnKpatSC0NM41FoxmSlxdKcDh8vwIhGsBt9g=;
        b=FJ+yAYmtulDvc42H0a/CtwtljeMEt/pGRaEhH7FtcwHs2nriRI+ZDbge8jMMI1TU3S
         j3wFpAv8/kplLgM17UKI3Y0wcX5fRA8WttFLppdxCaB896hiIgvmBMZuTEte92lGZ2I5
         3TVfc4Ar8zzxk6hAcDT3wRa9RelG8WmDgmSaFcxM97tvmKZGoEKpKTc9BdXBQkbuIiUp
         8IaOtDSl72v5Ql9iHHCtfUcfw1fmAQU625wJ8uiwHCzQFye3ayspXMqvruukh7UMHsXb
         YL6vZ0l/C3a0HBlbDTJfAW3YsuHluf1PVPoDEAc4R3EQxAYNLuMFppaIGrMArow8Rnbh
         yg7w==
X-Forwarded-Encrypted: i=1; AFNElJ97U2e9Lzxj1IwLcQEm7vBH+v8auTnDu9xJY/k/HKbq/f8nBO5GvNinYx/ZkP+VJZZYh5m8n2J23b6p5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFPZf93nZAyKqxN42XYRY7Yzeu8p4XhhwnRjPTFL3uBzNHHtzj
	09lkEm7303FNU8FUWyhghoYUkxIZ2xTLZqc2TohXNuRCuuu4iCrai1yPBLpRJd2dROQSxYP8/7a
	rKErnGAI6UsmvgfT3871Wth+KUuzmssA7/x+iuaO9/XDcklzf81k0hW1cXuo=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3083:b0:6a1:10b3:3565 with SMTP id
 006d021491bc7-6a1351ce240mr1787150eaf.24.1782380941994; Thu, 25 Jun 2026
 02:49:01 -0700 (PDT)
Date: Thu, 25 Jun 2026 02:49:01 -0700
In-Reply-To: <20260625091400.270398-1-wuyankun@uniontech.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3cf98d.ac7367b4.6675.0000.GAE@google.com>
Subject: Re: [syzbot] [nilfs?] BUG: corrupted list in nilfs_lookup_dirty_data_buffers
From: syzbot <syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com, wuyankun@uniontech.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com
Tested-by: syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com

Tested on:

commit:         ab9de95c Merge tag 'rust-7.2-2' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=134eecde580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c3d59be33cf7e9a
dashboard link: https://syzkaller.appspot.com/bug?extid=c37bed40868932d790e9
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17c5db7a580000

Note: testing is done by a robot and is best-effort only.
