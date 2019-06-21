From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v4 0/7] vfs: make immutable files actually
	immutable
Date: Fri, 21 Jun 2019 16:56:50 -0700
Message-ID: <156116141046.1664939.11424021489724835645.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2018-07-02;
 bh=v9lHOQqdxa+gAds53trZvNGGeCq3LsiSw99vIS/icPw=;
 b=HqOarHwQf9xE+TOQIND/rtHRtjoq3gvg9gfnLhmt2HyNf+oWAFMGsGZbJzBrSw3dWyZw
 fVOaKkjP/7aYmS1zCgaWTvwrV+wJeGC4+LKr+Cai7/VJqO3oj7x+Q9oscdVIO7btnTUg
 Lw6CQrJXwH4qPz79KQ72Mr3MNI3JJg4fIW1jHfeMmvkEqPW3S+Ff+iczGkIqRu7W6/+O
 i3cXIIJ8Y4HSjzwSn5EZt5VfKNnqE0xY8663jgp6Gxq1upIi7n5kslH8+KevZ81v8oGB
 wWTUrjhVu8EUjaRHgadQ6AsTN8nNDwUuAIP0jjRnMw3AxO+G+YcKPMPlgIyC8g+Ip+lb xA== 
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, darrick.wong@oracle.com, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org
Cc: linux-efi@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, devel@lists.orangefs.org

Hi all,

The chattr(1) manpage has this to say about the immutable bit that
system administrators can set on files:

"A file with the 'i' attribute cannot be modified: it cannot be deleted
or renamed, no link can be created to this file, most of the file's
metadata can not be modified, and the file can not be opened in write
mode."

Given the clause about how the file 'cannot be modified', it is
surprising that programs holding writable file descriptors can continue
to write to and truncate files after the immutable flag has been set,
but they cannot call other things such as utimes, fallocate, unlink,
link, setxattr, or reflink.

Since the immutable flag is only settable by administrators, resolve
this inconsistent behavior in favor of the documented behavior -- once
the flag is set, the file cannot be modified, period.  We presume that
administrators must be trusted to know what they're doing, and that
cutting off programs with writable fds will probably break them.

Therefore, add immutability checks to the relevant VFS functions, then
refactor the SETFLAGS and FSSETXATTR implementations to use common
argument checking functions so that we can then force pagefaults on all
the file data when setting immutability.

Note that various distro manpages points out the inconsistent behavior
of the various Linux filesystems w.r.t. immutable.  This fixes all that.

I also discovered that userspace programs can write and create writable
memory mappings to active swap files.  This is extremely bad because
this allows anyone with write privileges to corrupt system memory.  The
final patch in this series closes off that hole, at least for swap
files.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=immutable-files

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=immutable-files
