From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] NILFS utils 2.2.1 release
Date: Sat, 23 Aug 2014 19:21:37 +0900 (JST)
Message-ID: <20140823.192137.821837081271199027.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:subject:from:mime-version:content-type
         :content-transfer-encoding;
        bh=DVhK0u3LHnioaj8kWVufXibW5koOYpXbFKZVwqKMCgY=;
        b=VFSTI63DWCWlyuiDqzcYLCN0k0brggg+RC2NAndJMSO0T6z5INdFdqFhszbUkZRkqL
         2JuPrjQAzvdsEzLGWwa/VV9UKW2uuMUlzRGt+zINzpSVsBsS0HMF+IxmT+KmqDLyGe/P
         KUtgZvRQ0gcKBF9HcUotnxVJ22oQxVvRpVvNTksrm/yK+ikv14ySIn10d1kdbv8xk6TP
         5YhO7guifdZ6QD0JEFOBWWTTLwUeCxbb8ibQFSxPw0m2SPP0FDglwgv4npg+GcLfCQeQ
         beDArb3kZ0J65SeE/Z+5GQDm+NE+wyQ1bxYoQ2LQoNnUN32c11t1LBk5+48QEt3leX4f
         u1Mg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs-utils-2.2.1 was released on:

 http://nilfs.sourceforge.net/en/download.html

Changes from nilfs-utils-2.2.0 are as follows:

 * Cleanerd related changes:
   - nilfs-clean: do not override min_reclaimable_blocks if -m option
     is not used.
   - nilfs_cleanerd.conf: try to use set_suinfo ioctl by default
   - nilfs_cleanerd.conf: set min_reclaimable_blocks parameter to 10
     percent to more reduce relocation of static data.
 * Build related changes:
   - mkfs.nilfs2: fix gcc warning "array subscript is above array bounds"
   - install nilfs-* executables to /usr/sbin to resolve warnings of
     adequate (Debian package quality testing tool).
   - nilfs_cleanerd: link libraries statically to make nilfs_cleanerd
     self-contained in /sbin directory.
 * Fix bugs related to error messages of tools:
   - libnilfs: set errno when device doesn't contain valid NILFS data
   - bin/*: improve error message on failure of nilfs_open()
 * Fix typos in messages, manpages, source files, and ChangeLog file.

Please see the following changelog for details:

 http://nilfs.sourceforge.net/download/ChangeLog-utils-v2


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
