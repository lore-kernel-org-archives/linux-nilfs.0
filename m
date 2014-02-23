From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/3] nilfs2 additional updates
Date: Mon, 24 Feb 2014 01:58:38 +0900
Message-ID: <1393174721-27246-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Hi Andrew,

Please queue this patchset for the next merge window.

Andreas's two patches will add FITRIM ioctl support to nilfs.  The
original cover letter can be seen at:

 [1] http://marc.info/?l=linux-nilfs&m=139314496625648
     "[PATCH v4 0/2] nilfs2: add support for FITRIM ioctl"

My patch adds missing range checks of metadata sizes read from disk,
and prevents potential memory access violations due to invalid sizes.
This is for the issue pointed out in the following comment.

 [2] http://marc.info/?l=linux-nilfs&m=139153213412866
     "Re: [PATCH 3/4] nilfs2: add nilfs_sufile_set_suinfo to update
     segment usage"

Thanks in advance,
Ryusuke Konishi
--
Andreas Rohner (2):
      nilfs2: add nilfs_sufile_trim_fs to trim clean segs
      nilfs2: add FITRIM ioctl support for nilfs2

Ryusuke Konishi (1):
      nilfs2: verify metadata sizes read from disk

 fs/nilfs2/cpfile.c        |   12 ++++
 fs/nilfs2/dat.c           |   12 ++++
 fs/nilfs2/ioctl.c         |   45 +++++++++++++
 fs/nilfs2/sufile.c        |  164 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h        |    1 +
 fs/nilfs2/the_nilfs.c     |   10 +++
 include/linux/nilfs2_fs.h |    8 +++
 7 files changed, 252 insertions(+)

