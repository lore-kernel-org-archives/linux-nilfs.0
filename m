From: Waiman Long <longman@redhat.com>
Subject: [PATCH v6 0/2] blktrace: Fix deadlock problem
Date: Mon, 18 Sep 2017 14:53:49 -0400
Message-ID: <1505760831-7747-1-git-send-email-longman@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Waiman Long <longman@redhat.com>

 v6:
  - Add a second patch to rename the bd_fsfreeze_mutex to
    bd_fsfreeze_blktrace_mutex.

 v5:
  - Overload the bd_fsfreeze_mutex in block_device structure for
    blktrace protection.

 v4:
  - Use blktrace_mutex in blk_trace_ioctl() as well.

 v3:
  - Use a global blktrace_mutex to serialize sysfs attribute accesses
    instead of the bd_mutex.

 v2:
  - Use READ_ONCE() and smp_store_mb() to read and write bd_deleting.
  - Check for signal in the mutex_trylock loops.
  - Use usleep() instead of schedule() for RT tasks.

This patchset fixes a potential blktrace deadlock problem between
block device deletion and sysfs operations.

Waiman Long (2):
  blktrace: Fix potentail deadlock between delete & sysfs ops
  block_dev: Rename bd_fsfreeze_mutex

 fs/block_dev.c          | 14 +++++++-------
 fs/gfs2/ops_fstype.c    |  6 +++---
 fs/nilfs2/super.c       |  6 +++---
 fs/super.c              |  6 +++---
 include/linux/fs.h      |  5 +++--
 kernel/trace/blktrace.c | 26 ++++++++++++++++++++------
 6 files changed, 39 insertions(+), 24 deletions(-)

-- 
1.8.3.1

