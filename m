Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693924A02;
	Wed, 18 Mar 2026 00:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773792501; cv=none; b=hOV3UNa6IitTtpzqVPaptcnKAyAyclOv161CZ8O07c1gqMdA0jNFFYQTcxo1JLP+ZWsoVgHJ2DQIw3eQ33HlS5m91S/PjKqPCGYPDKTOmeLfZfAfcxrHj/KhwXPepCJP7Gknk/2ucmrw5PRjH87N/sBaDvVp73zKrNcWGnGHRpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773792501; c=relaxed/simple;
	bh=MtPtpmIVVpwXOdo42k3ie8SLa4ixpRinkBAhURnRhQo=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=SQxz6YUVEJwvH/sYnoJTZjoTzbR4AeVJcpplsIXLiXtCGRSWX0nbSWY466ljFAci7AlXFlt91I50cjhpWRmJZnLZnJJ5uuHahgRRefG1yVkt0vXiVBKoh5J1SYl510evn7vWpZKEZEn9knUMWH0VvpSePa97SZ0l8UuJqv9yAkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=YlumeJHx; arc=none smtp.client-ip=203.205.221.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="YlumeJHx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1773792489; bh=JxZvfVKZqeBh7+t3Z/hFEvvQIBGcJLvTufak4aVnUmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlumeJHx9u3RR7zsjuAktnoqVdsX92JLXIs0Vnqg2QwaVoVGbxSrTtOHrRGvFFknx
	 d56noGcQC3yBIP5jWJ01NQQEr0KowRh3UCowDW6uEIA7dTRTSo3PNB4v0HIUMYlD+p
	 sxuHMxQZfsOedIwT3d22HUOMlpWbNwlWJFC5yAzk=
Received: from lxu-ped-host.. ([111.198.231.89])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 205B5A2D; Wed, 18 Mar 2026 08:08:05 +0800
X-QQ-mid: xmsmtpt1773792485tk0diucj7
Message-ID: <tencent_AA7BBBBA338F9ECD1B794B4A1BBE2523BA08@qq.com>
X-QQ-XMAILINFO: OTdDBJCpIhk9Uju0vHz4N53jwTdRDirex7dadNQj1/licQvi+MAnGMpHAK4R0y
	 JHGxGMBgOJAvwOcIrOlXrN0UIfLhn+/cr3xg72PCsLYML2WgL/jOXpe+8aM7ntLbSluD662Hlnp+
	 KZ26ZOL/uHP8YFwle12qQ1fIPDBgXn1LuDjYORQ4cemokR5keCUyjcXU0BHf1ikTJczZfflcgCOa
	 Lb0BG4T6uVxritergORfwbrdjTLrCbbJn0R+dAz2sM/yyXJSx7iptZJ/TRau0aMDAdQ01dbyoEd+
	 rtZEZphqyHy2/5Fy2ka8WQsEkcv40RRE8CbtsTXpoKoMulROOC46jgxI0lpfm1ZODx4xpzq4njRs
	 Z6wQlKfnNexFEyJSKpkJU03MkGkkI7WsbVJT1gBaR+CJ1jskMBQ6EKX2Ile+P13QVy8MU5tBLSru
	 Uw0awymRkL29KZyWUrCkfRuTN+RMD8u4jL2DN53yM04p1ANmgWdJFkuBiqioTCNM8QXu8UtgGnS7
	 NT5kOUHE9LjBPVj8aCY2RA2e7gGi3eCSRtCqdv1N0p55+K1lRC8kuv1S6Q01P8WCTuAjv2/Oe3Hi
	 YS8c9qg+EGuTR+dKzlUXK0VwEbyIFCWcaRgRyQmmv8bRmY2a8/hH3uO+MOz8yZRebOBMeN/TWkmf
	 pLiCar1X6H+KDquNbz6mVYok1zwo5X8ZTMKUmY2wcO+v8W/xY1vJHdtHHI2FkI4N5DXCSm8o4Lqm
	 6QsuTKaOzu/n/5lnstvdCK925qyk7LDmnx1wTiL1Gs3lXXoaDCKVowXwApAW6O9Fxae9Lzl3XEEX
	 oz4NiktSIxC3Wf7w7Qe3bfWMswXkMBA4ItMdMyVNPHUN4OL7/z6A5XdH0ZDT/JGTmLgY0G7mUyIj
	 M78wqVAajYaL5ym9bZqMYGMuKFfoGKPqv22HUJCd3NZ3v+b/hRTXNDsBOeg2u41cjbTZMdfGzt1t
	 LwOtXM0ryHbxqF0qM1HCbYktg+gmYKVmTmf7yavPhDC8awPJ8EcIkRH6G3wb/W
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Edward Adam Davis <eadavis@qq.com>
To: konishi.ryusuke@gmail.com
Cc: eadavis@qq.com,
	kartikey406@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com,
	syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] nilfs2: no longer save to shadow map if the num of members is too small
Date: Wed, 18 Mar 2026 08:08:05 +0800
X-OQ-MSGID: <20260318000804.205687-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAKFNMomDpMC7VrWzoLEm_5wGzjV5v82tQCWtRy3oif1Q-=9dPg@mail.gmail.com>
References: <CAKFNMomDpMC7VrWzoLEm_5wGzjV5v82tQCWtRy3oif1Q-=9dPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Have you been following the path below? If the argv0.v_nmembs value
passed from userspace is greater than 0, everything will function normally.

nilfs_ioctl_clean_segments()->
  nilfs_ioctl_move_blocks()->
    nilfs_iget_for_gc()->
      nilfs_init_gcinode()->
        nilfs_attach_btree_node_cache()

Causing the mount to fail solely because the dat B-tree wasn't initialized
is an excessive fix.

BR,
Edward

