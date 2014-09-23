From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/1] nilfs2: improve the performance of fdatasync()
Date: Tue, 23 Sep 2014 19:18:49 +0900
Message-ID: <1411467530-5949-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=XUlyTXh72x+OYFDO/IGBkNMedBEsqoBUso2JGpnrKdg=;
        b=T6JBOGUHZ8SAahEnywcx8mYHIXJd2EdHCEOH6psxSFhn09c47bJtT9LiC3Y5rSL5/O
         DbPJy2gs4btooPYdbawwYsZBx4iBIWjn5N3FucnQMZbZI2xcN7Wmpmeos88ZEu0qHX3n
         4vFXKwRd5MZd4HKll+nNCdqjuOajbLFwTX/1Xy9Dlcz8n73CbkZ3OAWj/7TsZy03yKrq
         /QFuB5gzJuMApD4xw8hIbAL8MMky5lpC7mnNWXNrrsI5SFNxzIJKhw/Hg9SCAYlJY/Wf
         9OZvun5tRtzXB3vJmjXEfBSUu8Tf32I6f708wmKJiPETnp9cVtF2AbnswC0UEg+gWC2j
         Ux1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Andreas Rohner <andreas.rohner@gmx.net>

Hi Andrew,

Please add the following patch to the queue for the next merge window.

It fixes a longstanding issue of fdatasync() implementation of NILFS2
where fdatasync() will fall back to a full sync most of the time.  The
fallback is only necessary for a change of the file size and not for a
change of the various timestamps.  Andreas Rohner fixed this issue by
discerning these situations properly.

Thanks,
Ryusuke Konishi
--
Andreas Rohner (1):
      nilfs2: improve the performance of fdatasync()

 fs/nilfs2/inode.c   |   13 +++++++------
 fs/nilfs2/nilfs.h   |   14 +++++++++++---
 fs/nilfs2/segment.c |    4 ++--
 3 files changed, 20 insertions(+), 11 deletions(-)
