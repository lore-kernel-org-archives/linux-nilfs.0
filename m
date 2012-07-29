From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC] fsck.nilfs2 command line options preliminary vision
Date: Sun, 29 Jul 2012 19:48:17 +0400
Message-ID: <C4F7E33A-E274-4385-9CA1-EF8926C472CA@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=p1LgSmtkIhJs32hK54B6PGSKQbrm1NJJkmlDN6+IUOk=;
	b=M+JGNZWVRSWjCKoXE7csDsg7EFRCSl3SBBqfLOgjYP+uvB47Nf6nvbCoJ+EMQtcnmWK020wwjG/0aSfYdcrZfFCVrJPAiFRM/JF8/bkrFww5QWC90UsfZcQZi/DyjBcd;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi All,

I have such vision of fsck.nilfs2's command line options:

-V
Print version information only. (IMPLEMENTED)

-v level
Set verbosity level [silence | info | debug]. (IMPLEMENTED)

-C [fd]
Display completion/progress bar. (PLANNED but has very low priority in implementation)

-T
Don't show the title on startup. (PLANNED)

-n
Avoid attempting to repair any problems, but simply report such problems to stdout. (PLANNED)

-N
Don't execute, just show what would be done. (PLANNED)

-p
Automatically repair the file system without any questions. (PLANNED)

-r
Interactively repair the file system (ask for confirmation). (PLANNED)

-y
Always attempt to fix any detected file system corruptions automatically. (PLANNED)

-f
Force checking even if the file system seems clean. (PLANNED)

-b superblock
Instead of using the normal superblock use an alternative superblock. (PLANNED)

-B blocksize
Try to use block size during locating superblock. (PLANNED)

-s snapshot
Check snapshot consistence. (NEED TO DISCUSS)

--last-valid-snapshot
Try to find last valid snapshot. (NEED TO DISCUSS)

-d error_code
Dump block(s) related to error code. Error code can encode segment number, log offset number inside segment, metadata identification code (ifile, sufile and so on). So, it is possible to dump in file corrupted file system's blocks. (NEED TO DISCUSS)

--dump-all-corruptions=file
Dump all found corrupted metadata blocks in file. (NEED TO DISCUSS)

--recover-from-dump=file
Try to recover file system by means of writing corrected blocks from dump file on the placement of corrupted blocks in the case of impossibility to repair file system automatically. (NEED TO DISCUSS)

--try-extract-file=inode_id
Try to extract raw blocks of file's content with inode_id in the case of impossibility to recover file system. (NEED TO DISCUSS)

Any comments, objections or additions? :-)

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
