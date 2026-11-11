Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794381214;
	b=BB5j8qIQ/S+V3NcU46TfAKyrsLfCEanAtJlW6RFPZinMonpvsQ9V6XMvVEVmtQ3sew8t
	 lh3EdVvOppmBAl+4yUd8EpR+aHsrbm9ZmNVwevU2yjPRnO5EeJvlDeqHjtTDoMnJ+t4eM
	 3Y0cuiTq/AeVdQDa3UidID21lnytDmTXYT8c5fFXhWt/1zHLvo7/roDrZzxK0GxCZkp5P
	 60nPdU0/A/tiPf37GK06HmGXev1qG0nwfY2Uxz26AL9tkMgYHkA3Tn7a2qhjbhHEk1af6
	 CrUtnCZg+PKv4DEvcQ/i+C5rqkBJcFh9EyqjW0unTjhIF7Y0VyFNnS8GbCe5GRUPSxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794381214;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=XODJD59FFZyBHFi1nMxZLbWlyiBiM9n7HI3pze1LCe0=;
	b=OaLsZRD1s/nAxmw/TkyIbTI3uRNhnFq8IyZgPc1zxGoKqpmLbHg0hhGMvysr0zfOJ2X5
	 LGfPvUBK5APK7ryS0/6WVAAbKYBXpkprfeM7CLc6RULRu6VajECshm89CnAYdCc7Ek4SD
	 0ITVKXcRkJHpiQLxTO10nBFsJZPg9FZdArhNOtDttQ5Jtfug+PV2eveLdI2qYF0cyI0sJ
	 5uu8pRw3jv6THir4ZWMVdsX4Z63eFWox4qS4/9eJgdqn8UiT2N6emEp6WkBs8l7eP9oFi
	 tY5xnCxITMWjwfeC8ADcOCTzhvkHNs6+hVhN4QH9L2HvUbZfUYoA2AD4agbhnQhtYVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tj17Xqg7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.64
Received: from mail-lr2-f0.google.com (mail-lr2-f0.google.com [74.125.230.64])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF84606A320
	for <linux-nilfs@vger.kernel.org>; Wed, 11 Nov 2026 07:13:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DF84606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tj17Xqg7
Received: by mail-lr2-f0.google.com with SMTP id 38308e7fff4ca-3ab1cf59ff4so20058101fa.0
        for <linux-nilfs@vger.kernel.org>; Tue, 10 Nov 2026 23:13:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794381212; cv=none;
        d=google.com; s=arc-20260327;
        b=XdCMMmDhdV9jFK/feYHOBLuaDSbTlmn1TZuByxmthX0oJ0ZpDCbLWTxPLw7hzwGEyS
         ZOOANWDja18djWfTOEb0BXj8cv1S7TbMe6UQkAKy/rXbYgHsQ3xqK82tEKejOcZ1ACCj
         YDpHgRsgr7fRKHoQtk6YDhFZxa1Kp0SwYybtOFrnzT+cPYhmr3PLKkL3Ij4TV9kZFkcp
         k2RK2leHndT3Y6GXp0fc5gNAbL0ukqWgTI91Qah7gSSAVCOnD2a9zmb333/8BLRP6Xzn
         qkfTdSzZSHw3ny/PbM4Ljb/YP1w1RhOGN4DVNW+4qxSrM/l+8FjTEFgj5LSA7Blnc1FF
         GAew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=XODJD59FFZyBHFi1nMxZLbWlyiBiM9n7HI3pze1LCe0=;
        fh=tUCernNhtS7rcv7jZ4ghIvagR14nyjuad4tK7ifN49c=;
        b=cKam6Tmv1rbUmcEeWJhH2iJIUdBCi8c66ed7ZDz3j+2Qn0l49pYnQtjDOphokGIGuc
         pagb1Zfsmc/wQ4gK+IBIRbDqUvWGds1EJVHbtA+JusWdGrvr5tuMOT7mXZJKpOUvPgJj
         LwrEe/ggINqYWreWQ3sKysa195b0ge7CnqKKckpWMHhpPWQvtjKy+BSA6hm+kXamBa9W
         ltZdDpTHMKDSHAA6+4I8lB3Jn3oj1YHeKa7XTeIbrRobVfWRLGh3WXSo9nB9W+haZR9r
         9ESqHnDhuUdK7vai5BM5vGwgCtKV/+XWyYe1YrbRpEYTPjRJUr4CUFTWFj2r4VgL0/2t
         YYEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794381212; x=1794986012; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XODJD59FFZyBHFi1nMxZLbWlyiBiM9n7HI3pze1LCe0=;
        b=tj17Xqg7eru0Be2RCQJMzkbTr6FV8I9PKryQ473/vSYhLN1pzuJZq/1r3FkN3PtSit
         MaNNHoAxnHyzzUpieTgW7NZNt1+Oz3zVeecSnMh/HfENVlB4yre48aRiWsYKGARKfpQx
         bo4PYrbvC+x2tCG+GLo/yrkKLR6bOL1WZucoaYVq/PqqC+LlnDrZkeHJFJMh3KNuFPrj
         LtgixFU2WZS2j8lp/87ZGZt+ZlibonBKm9fhwpL3/VIT7pccIW/bzl7G16Q8kpOXNyQh
         SpHhkw1r9eWAFLF1XNOhpi9NSOSNEzJbJ2pOU4+Cvav+gtSXEQGYNicuNiPCvRkz3tV7
         n1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794381212; x=1794986012;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XODJD59FFZyBHFi1nMxZLbWlyiBiM9n7HI3pze1LCe0=;
        b=jYlSrAFycu26he6slb/BEbQWiBOPcfCDd04PXNT3Eb8VgoMLdyRSX+WNPcHy813NxL
         npU4+xBJRYKe8Kncbjzyvbu7QRYDWrZHGGTxYWdwfqVh/pt2Mcw7rAJKSvfPSL8ht8Me
         SXvliskAn0iUcYCEn70WH1v23mNlvgpKIQsiid+TUdEVW7z5rfrg6pAOObozgv9rfBkg
         UHRFgl7MyRBPtgSo3aY4UtvShBztpVy/SxNPsvkkD49JBn2EzYC7H7n0/QOT1+FQrfZL
         qsmxIV1PhmjoibaD65Inm4qvK9qmgZ4x0lSKk/AQjGtLJ866sf3yGomKNiNZ2OBR8cGk
         x6wg==
X-Forwarded-Encrypted: i=1; AL+hErHMIpzqazR1SCfErT7r8R4gXYxesL1VvyHCBTnN3yFZ/Lhs+Tfelwv7htgq3Dtz6bgghapCNjlyrQCPuw==@vger.kernel.org
X-Gm-Message-State: APuU4Z8Sbr8kNQfbdO/sSz5gQfzvXgymG/2B/Ii3mPBrqblHzQQksXJD
	Vp1mHGvTYtEh5X0CGrYHDz/DNq5J1MpmGq+r1sA/cHOF0jwfYhpoRk+R0/oo2KY8R5pFDcaPKH/
	ZJOWfszfQk7wzVtL9CrxoQ63tohoOuH8=
X-Gm-Gg: AYBFou1Gqy7KNsieBMuivS90fJjA+R9U0refUqblZzf8yj8LUeILK5U1ftAvU8sIqEq
	ZIPd1IOBr8o/STp1qAD+2ErGcCaW4M6kWpAROlHAlZzCOkNfrKfxs8BE8JFNeFhsiv4ju0AuG8q
	oafP01O05bMN6LL8CsFtKQVQ46dZ8t9/qmPzo/blMd8qRuTdIx6Iz5BsUTo5ZeCGViktne6MUaZ
	eKv9v5b8HszTDP79iHShboNZZ1U26P+yGRCr1/1CLEtAKcOEfaCYOreeqsVG2Bg+y/adXT7ZDTO
	H8N1bSS6sc1P0T2OEt41MLknEuBhj7Q1DuSq/ZR1OSG7oB/py+3JSPRoRCxJRQuRwovjA/NjbMH
	Cyluw0rS/pFFdIRDmXl1Djgd+79gckltFeMOsM1eeiiAtPqMas2m+pngMVyoS/HjEJmucBIs9Dv
	p0dG3Au3QVNs9lYWs=
X-Received: by 2002:a05:651c:41c6:b0:3ab:2bd8:41b6 with SMTP id
 38308e7fff4ca-3ae125cd6e2mr2801391fa.2.1794381211882; Tue, 10 Nov 2026
 23:13:31 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?6ZOu?= <fengaojigui88@gmail.com>
Date: Wed, 11 Nov 2026 15:13:18 +0800
X-Gm-Features: AclHuK-f2eMwfErEfJLrseJEG_i5om0J7gq83OoLHQsn1r11Xlpkbi31zgpwVC0
Message-ID: <CAO-4RZ2=4okHYZ-xCkpV-ekj-aSqKLnYGOsRM9A2dD8R4Ozzeg@mail.gmail.com>
Subject: [BUG] nilfs2: "VFS: Busy inodes after unmount" -> kernel BUG at
 fs/super.c:731 (v7.4-rc2)
To: konishi.ryusuke@gmail.com
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ryusuke, Slava,

We found a reproducible nilfs2 unmount failure on v7.4-rc2 with syzkaller:

  NILFS (loop5): disposed unprocessed dirty file(s) when stopping log write=
r
  VFS: Busy inodes after unmount of loop5 (nilfs2)
  ------------[ cut here ]------------
  kernel BUG at fs/super.c:731!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  CPU: 3 UID: 0 PID: 10340 Comm: syz-executor Not tainted
7.4.0-rc2-kernsight-kasan #1 PREEMPT(full)
  RIP: 0010:generic_shutdown_super+0x305/0x3a0 fs/super.c:731
  Call Trace:
   kill_block_super+0x49/0x130 fs/super.c:1852
   deactivate_locked_super+0xc0/0x130 fs/super.c:558
   deactivate_super+0xb9/0xd0 fs/super.c:582
   cleanup_mnt+0xbc/0x160 fs/namespace.c:1396

The CHECK_DATA_CORRUPTION() "VFS: Busy inodes after unmount of %s (%s)"
check in generic_shutdown_super() fires. In the original syzkaller  crash l=
og,
it is immediately preceded by the nilfs2 log writer reporting it disposed
unprocessed dirty files while stopping ("NILFS (loop5): disposed
unprocessed dirty file(s) when stopping log writer"); the two messages
appear in this order, but the causal relation between them is not yet
confirmed. Inodes are still on sb->s_inodes at unmount time =E2=80=94 a pot=
ential
use-after-free risk for the subsequently freed superblock/inodes (which is
why syzkaller titles the report with "(use-after-free)"); a use-after-free
itself has not been observed in these runs.

Kernel/config: 7.4.0-rc2-kernsight-kasan #1, built from v7.4-rc2 with
CONFIG_KASAN=3Dy, CONFIG_PROVE_LOCKING=3Dy, CONFIG_BUG_ON_DATA_CORRUPTION=
=3Dy,
CONFIG_NILFS2_FS=3Dy, booted with oops=3Dpanic (and panic_on_warn=3D1).

Two verified reproducers are provided (timings below are seconds after
guest boot; each was verified with a single fresh-VM attempt, 1/1
successes; the stable success rate over multiple runs has not been
measured yet):

C reproducer (verified):

  # on a suitable Linux build host:
  gcc -x c -O1 -static -o repro reproducer/repro.cprog
  # copy the `repro` binary into the guest, then run as root:
  ./repro

Verified on a fresh VM: kernel BUG at fs/super.c:731 fires 113.9 s after
guest boot. The syzkaller reproducer pipeline independently confirmed the
C reproducer as well.

syz reproducer:

  # in the guest, as root:
  syz-execprog -procs=3D1 -threaded -repeat=3D0 -executor ./syz-executor re=
pro.prog

Verified on a fresh VM: kernel BUG at fs/super.c:731 fires 244.6 s after
guest boot.

The syzkaller build used is commit 853b104bb454141a5b0fc0e4218ec78e9f34ffb1
(see environment.txt in the repository). The two reproducers trigger the
same crash but their call sequences are not identical.

A full write-up, both reproducers and the verified console logs are
available at:

  https://github.com/Zheng-zheng-codes/nilfs2-busy-inodes-after-unmount

Repository contents:
  - README.md                      full bug report: phenomenon, stack trace=
,
                                   mechanism status, reproduction steps, ti=
mings
  - reproducer/repro.cprog         C reproducer (verified; compile with
                                   `gcc -x c -O1 -static -o repro
                                   reproducer/repro.cprog` in a Linux build
                                   environment, copy the binary into the
                                   guest and run it as root)
  - reproducer/repro.prog          syzkaller reproducer (minimised, 5 calls=
)
  - reproducer/repro.kernsight.prog
                                   full state-reconstruction program set fr=
om
                                   our fuzzing pipeline (ordered)
  - reproducer/repro.priming.prog  state-priming program set (pipeline reci=
pe)
  - kernel.config                  kernel configuration used
  - environment.txt                kernel image info (sha256), QEMU command
                                   line, syzkaller commit, reproducer comma=
nds
  - logs/log-*.txt, logs/report-*.txt
                                   original syzkaller execution logs and cr=
ash
                                   reports from the fuzzing pipeline
  - logs/machineInfo-*.txt, logs/title-stat.json
                                   guest environment info and title statist=
ics
  - logs/crash-serial-excerpt.txt  console tail of a verified crash
  - logs/verification-serial.log   full serial console of an independent
                                   verification run on a fresh VM
  - logs/c-verification/           C reproducer verification artifacts
                                   (serial console of the C-run crash and
                                   pipeline reproducer report/statistics)

Happy to provide the kernel image, extra crash instances or anything else
if useful.

Best regards,
Zheng Zheng
