From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/1] NILFS2: support NFSv2 export
Date: Wed, 27 May 2015 14:22:32 +0900
Message-ID: <1432704153-18897-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=fpwcvroqITdfTMJL6cWfMDq6LScEh6CVjlKET9rQzrU=;
        b=buTUO4IJmh3AQva/udKuf1l1b06J/4c04EducRNF/JntGG16TunL0OUH8be5tFpC4U
         oxpTwEVn8vwWVuM27noDftamYYwSUZTzKMpUYXu4cDexdUM1SO94JFR9g0k/8xh1rxVc
         z5/v6QAnOWDHuk09SgDznKanu4oJNqWOaV1peethx2iJz393m823/8NGSi7xHlzVyuyj
         /c09KrGOw7IJ9QDU/9JBdVydAO3dcHnEZNf8iCAu+6fo7NdFHfH+Kn3oPZl14yK/JdBP
         sihXsieJFVcNYjdi2/QC/bvZ3M7kQVHQoyx6bKLVr17g68CuydVnDbpWyjJLNmy299pw
         xS2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org

Hi Andrew,

please queue the following patch for the next merge window.  It fixes
an NFSv2 related issue reported in:

[1] http://marc.info/?l=linux-fsdevel&m=143104630128997
    "[PATCH 0/3] make BTRFS, UDF, NILFS2 work with NFSv2."

Thanks,
Ryusuke Konishi
--
NeilBrown (1):
      NILFS2: support NFSv2 export

 fs/nilfs2/namei.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

