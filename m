Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBBE40D574;
	Wed,  1 Jul 2026 01:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782870854; cv=none; b=cVJVctQ5jyAPHnAgYfxkVdEWT5NEe9rXzICS12U6FiEYDbx3ePV7UuwTiY/4QzxoWEwAL1jKmWkNJ7lH6V4UbakPGvDSSwkYFKWUwCaKc00oztolyYaQR7vG6g95ksD6qFs2H2+AZJjH38TYLDhd43YeIayoVRHpt3i5X5cOJTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782870854; c=relaxed/simple;
	bh=BIOqsPGQCvayLCeKlSTWaFtZw7q1oLWki08D5HMCWeA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BPyETa1FYXW0NpQfZ0BPhNCwbqL3emMD/mHtMQirIeDn3EH7j4QZlyP/6gL93YL+u3Vupg7URWjfWWQhf1TDdmAY5iBZRIgAEJMLL6dJE0UN9yJvyiKItAeMiEMxKnratqpv7hhHQelqQ3inUfqrmaoJzbqsce+NpqGhaJv3L2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Y7Gh2Rj2; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Y7Gh2Rj2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782870804;
	bh=sw2k2+7CqopSkda2wguNtx1pNBLBcyT7y6YRFs9aCYc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Y7Gh2Rj2cQJK9IkJifdHVxmEl/nsekt1WsV7T7YNyF4iuWZBJcDYSz+s5DsH9GfyK
	 3lO2FpgQUln2ynCS9kTDMkt3paFwFquf89LL5wfertHC1IpKFGFZhrZvwrZuT2AEGV
	 Npxndgc0mnAZSsElNkBUcD1aK/mGL6x9JX1AEAWw=
X-QQ-mid: esmtpsz20t1782870787t405d38e2
X-QQ-Originating-IP: Zwhbe/SmZQw4Ewur99zckmBV0s8i4kmQW7pFouGcBrs=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 01 Jul 2026 09:53:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1077355903454823753
EX-QQ-RecipientCnt: 7
From: wuyankun <wuyankun@uniontech.com>
To: konishi.ryusuke@gmail.com
Cc: linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com,
	syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	wuyankun@uniontech.com
Subject: Re: [PATCH] nilfs2: prevent double insertion of b_assoc_buffers in dirty buffer lookup
Date: Wed,  1 Jul 2026 09:53:05 +0800
Message-Id: <20260701015305.970002-1-wuyankun@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CAKFNMonk0BDe3PcNdu7ZvSitO1U1TFEvj9mLXAdBK96fCnBScQ@mail.gmail.com>
References: <CAKFNMonk0BDe3PcNdu7ZvSitO1U1TFEvj9mLXAdBK96fCnBScQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: MD5XEDocxEOL9wP0kXehm5V4n/dr6CyOsC/JSnGrWnPqXd73aJaGgrLs
	wD72XRjV8xrRhFqRq/oufYWPTsGihvIfbQ7mv63x0d/4EyGRiSMqTqidRBwJDHoodZEMErp
	cBTtI0rmDRbfSqgiUZpjnJ6fYLt71e2Wdr7KT5jBj1M4eajFFUBKYDAM+th4TiIEB3V3oV6
	WhUTWgKQm73DzR3RXBwE6shA4xgdQDNMi8Cd6X/wdoO0HuGpM/RAbpkDeuOqhvi7jLrz/SK
	Zw4ajkQA3stNRDTbdae0dVOXdDabks6GZzAgbPOVeZ9PDi4I8yJQLYUuntxHsTxcYwPX+wY
	RdUNdKBemc7nt09brrwHzAVwaX/9VzAZ0qonkeKCoELBpdq8zf6snG4ssRGGb7pOlY9YLo/
	RiKCLpjZ4eAlUU7JJTkHo1k4m3Kk4VGgqUeloJL6XMp+cvTuVukKQ1j60c7nAwfzRO2keHu
	hBoalrT1OzbpT32Nh83ton3Qza5pf0xxb7cFF6BlJlY5PY+tBbpZg6QUKpsJYp7/9AaBWdq
	hL712iqUEJU6oln3p4Ai3Vl5T8RZr53y93llmOQWloeKjoTrE6ZPoJ0zWhtXY0+zL0R5PzZ
	9bSILs2RNuclZEZ8B7cPby5jHw06O8K8sgr9apA2S5yT3CHAmZCBLpnJuPFaJN5SLLiuo1v
	hC8s75gFXX8leUhoAm483yIm4uksGr33qFyFLtaToNSsyfg03rYxHhTeIQTXXmSeHsF7E/2
	bJfAxmU9c68lGKSabNeCfj2x3svoaoJfP1BL2GCRmL6SHXmsgVESVG2TcP7rJ/pW9toX5+m
	lpnFjEwlJ1DSZqwU9HFkL3yo7XDSk+o956yHvJcIO5EG+Rtm/g29+VFV290qhQn+0ALSr88
	tYIHpbQYA7I2LqWJPU8ymLEcHzkJlNCiAI7mCH4B5fjxsxMkdh5WwF5Me8YwK+ucEUJ9nJ9
	PFOBJ7rrJ7QJSLrhsConRchM1Nk1Nxf7r1hu1/72D9ZOUC5SYkysNnXO7wtFPZ0f9Q7UEx2
	yPkcaIBD63JrAPH7iK
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Thanks a lot for the detailed investigation and for clarifying the actual root cause. 
That explanation makes sense, and I agree that the proper fix should be a bounds check 
in nilfs_ioctl_move_inode_block() rather than masking it in nilfs_lookup_dirty_data_buffers().

Please go ahead and handle the fix patch on your side. 
I appreciate the help and the clear breakdown of the issue.
