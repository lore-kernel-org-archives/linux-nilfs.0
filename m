Received: from out203-205-221-191.mail.qq.com (out203-205-221-191.mail.qq.com [203.205.221.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3662223D7F5;
	Wed, 18 Mar 2026 01:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773796577; cv=none; b=JEKu+9DuUNytAimhqBBs/g90ZnNp596wDVnAGFBGJt//NDYpJE2olqyDu/EdywPe61+9fDjqWr1/FMd1GsOk5kepyi7IHIU0CS7l7e2FLRQszy4Z4XXiSlfuY04fszC5nH9MhLqk8/5fdUh7xGpX8XTaBsbKwS65onepaLZYGjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773796577; c=relaxed/simple;
	bh=sslQ9piJpglnmlV5nlzNzSOB9KwZE1kbPU7Plv7dG6U=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=BQkgiVXpbCtJ+Y5kMVgmpH8EvAX4nEGpP+3RHft0fyIeHWCp3C/wDIlPFkyYC/DwYkROfIlgI0AO5w40JmBm9DvQOWrzahKr6opeKCPv1XBfhAYrrjqs7JwUzAebRz2WKcMW9l6E4GZUAVPowD1QoHchT+8Fwdf77Zv4p3n/Skw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=HDh7buDf; arc=none smtp.client-ip=203.205.221.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="HDh7buDf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1773796565; bh=sslQ9piJpglnmlV5nlzNzSOB9KwZE1kbPU7Plv7dG6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HDh7buDfvq1wKYK58G+L/g3L9YyjhCyZrdqeGgdyIOX9sa/uFv4HVQ7HkBDpP6dNE
	 EtPOJo1PVF3+hHwex8hwCHzpnYdFfcql+lg+2EfTiidmcdIR+WFFMjsP2vQV4EJTMx
	 cSe01nud6RagrYz0yWYmcei+yyLAePHQ6xGBqw2U=
Received: from lxu-ped-host.. ([111.198.231.89])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 4020BA0D; Wed, 18 Mar 2026 09:16:02 +0800
X-QQ-mid: xmsmtpt1773796562t4o3uw1m5
Message-ID: <tencent_B0BF4B501BC025DCBAEFBB7033EB9E041B08@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNznxpCmW3QjH4uezzWl3N4V6/BII0DGRpBEchk+iMsi4Eh2GN1Elc
	 +/Yk+gR5W5PRtUjVXdZv/3X1XGX4CNkyUB+q4QSLh0KIyJFzSDtNpLVad5Q1KGgSrDK6bl7oxt1U
	 ov4bIFwMcWlszKGxxHEqQJWVmu7C1k6WZf6e1BreKUQncAmmKRX8ijtY7TXFWkhgAWzM4ZQxGQq4
	 5Eutdjs2rPsRTqUTv/AA9Fzp0iRGPG/88Ut7ZpC0DoNOvSK2UNtNpQK0hoDAuUT/NWiUYVZ0SQ5C
	 VwDBJ5agVDFMivPi3pHxzrYUGF2MoGFY7lxiXOboTKKZNjKVlianP30Dw23ydTKH+ISFAfgEbZ+y
	 2hFHaa3t/PafFWDq0gZ1/DMhkv4l59hc6cGXqxrymZnkWFDqw0TFD2FqGIANAnkq2nXhOXam82IW
	 CqOtYa9gLY4nR28M4fzP1MZ3a9NcVTN+ePaJl8cXSK2HdAYLfgPiMOBuYHL17vCLVFgIBKridfia
	 BVS9G35gTwm7XRpZ21apzwXGJXjsYcP+e1wOfSEjjatJz0RKkwZ2TJZoDYSwf3T/NPkph869l8wI
	 ZOWYxXpjeUj2GBlrdAuSezrurN7MqzLdceED/E30eYPIrBDXXA8pu+JvIFui9twC/EARj9hpuQDu
	 XWNT4NibCc8ChsvC+S6Mvm2LwJsEVAn58J4mnf4+RHZEWRMWGH4AqYGFgrAtrAeI5BTwHOACKV4y
	 yW7JZGxslcAvmWvL6fpQ1XDIAX+0EpI4iLYmIDGEJ3miAWMmheYHBvyqPfODYydwX9e4F54BHmOF
	 unG0En8VnPmB+ZOC/nVqxG8HrKOf+lKxlE6+HD8lFO7/+7Q0+HuJeK3ePGWCoQ8onoY3NpfXTXcN
	 r5Y6wxOVAFVuhb7UVQeixzoScX0yJ5hMhJNpN2VtgV0NVQr8xQj3zfHNH+hirHbU0QWJY/0YfZx0
	 zIOc1/TcMiAPOHtqdYEIbf2F030EDU8ccvv2lwqEdG4AToGRmvrEdD40Pnd469aGEos3nJ5a1P4Z
	 N5aWgRLwQr6MQ65IsQ
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
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
Date: Wed, 18 Mar 2026 09:16:03 +0800
X-OQ-MSGID: <20260318011602.209709-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAKFNMo=NgRCP2nbgvDQyyy2ik1Qr7XQLrY-aUSUnGYiAu=yWwA@mail.gmail.com>
References: <CAKFNMo=NgRCP2nbgvDQyyy2ik1Qr7XQLrY-aUSUnGYiAu=yWwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 18 Mar 2026 09:54:12 +0900, Ryusuke Konishi wrote:
> Are you perhaps confusing the regular inode's GC cache (gc inode) with
> the DAT's shadow mapping inode?
My fault.

