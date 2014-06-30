From: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: deadlock-like issue with order=strict mounts
Date: Mon, 30 Jun 2014 12:46:37 -0400
Message-ID: <53B1946D.5020507@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        bh=zdz/uBGvk4eAB3d9zCeb80nge99+JmVQZDE1fLt9kZg=;
        b=nskOGMQ5BPHPXZEAKMqOkyQ93spGePvCBq9ix+w34m2r1kfw5dOMY81G8zPW0hpS9a
         jDzI0mKB3YyYNselGuEd7tlRQYInR+e81/rol6gDdB0G8ZXlJol95lCYOemTwd0GeqDY
         KPsdGQ+l+Qxf5ufy3RR/8nmGauF37o42/0VzhumbgVnLAveIqNDTJRM+mhhHbPmDKq4K
         s4YiGYNF9pPDQray7RF36z1DgIDVoOCuleg94ur4c5oNx06vVHyARIhsCI74RCqjH9Rv
         lmzHOUfDj0LnIfM2Fm0kndmkFyZ0Q/Vs1TI4P3INNBot3qYlHAtfY1p7DA+Z3bdd8R5R
         Uk9g==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

Hi!  With debugging being discussed here, I wanted to pass on an issue 
that has no error message associated with it.  This will be one of those 
error reports that Vyacheslav will find not too informative.  He's 
been trying to help with those moments where NILFS2 will stop responding 
for no visible reason, but whatever issue has 100% reproducibility on 
my PC has no reproducibility on his PC.  This is a new test; maybe this 
test will work.

With NILFS2 '-o order=strict' mounts, at least, there is a repeatable 
deadlock-like behavior between segctord and a process that syncs.  
Usually, that process is lilo, but other programs can cause this behavior 
at random.  After this issue is reached, clean shutdowns are almost 
impossible.  At least here on an old Pentium III--512 MB RAM, Slackware 
14.1, kernel 3.16.0-rc2, debug kernel config, old IDE drives--this script 
reproduces the issue:

# ==== script ====
#!/bin/bash
hdparm -W 0 /dev/hdc # write cache off
mkfs.nilfs2 -f /dev/hdc4
mount -t nilfs2 -o order=strict /dev/hdc4 /mnt/tmp
cd /mnt/tmp
while true; do
	fs_mark -D 4 -t 4 -n 50 -s 512 -L 5 -d todelete
	rm -r todelete
	sync
	sleep 1
done
# ==== end of script ====

Should your PC be too fast to make a deadlock happen, increase any or 
all of the numbers in the fs_mark command line.  On this PC, it goes 
through the loop exactly once.

After forcing a crash and collecting the core dump, I see this using 
the crash 7.0.4 program:

crash> bt 274
PID: 274    TASK: dd9caac0  CPU: 0   COMMAND: "segctord"
 #0 [c0063d48] __schedule at c1641357
 #1 [c0063dc8] schedule at c1641a7e
 #2 [c0063dd0] inode_wait at c11467c8
 #3 [c0063dd8] __wait_on_bit at c1642133
 #4 [c0063df0] __inode_wait_for_writeback at c1156d98
 #5 [c0063e24] inode_wait_for_writeback at c1159fff
 #6 [c0063e34] evict at c11475de
 #7 [c0063e48] iput at c11482ef
 #8 [c0063e60] nilfs_dispose_list at c12f104a
 #9 [c0063ecc] nilfs_transaction_unlock at c12f14e9
#10 [c0063edc] nilfs_segctor_thread at c12f3fa1
#11 [c0063f28] kthread at c105fb56
#12 [c0063fb0] ret_from_kernel_thread at c164729e

crash> bt 301
PID: 301    TASK: dd9cc020  CPU: 0   COMMAND: "sync"
 #0 [de9e1dac] __schedule at c1641357
 #1 [de9e1e2c] schedule at c1641a7e
 #2 [de9e1e34] schedule_timeout at c1640a80
 #3 [de9e1ea8] wait_for_completion at c1642436
 #4 [de9e1ed4] sync_inodes_sb at c115ae12
 #5 [de9e1f7c] sync_inodes_one_sb at c115e620
 #6 [de9e1f84] iterate_supers at c112d1e8
 #7 [de9e1fa0] sys_sync at c115e85c
 #8 [de9e1fb0] ia32_sysenter_target at c164736b
    EAX: 00000024  EBX: bf8b1954  ECX: 00000000  EDX: b775517c 
    DS:  007b      ESI: 00000001  ES:  007b      EDI: 00000000
    SS:  007b      ESP: bf8b187c  EBP: bf8b18b8  GS:  0000
    CS:  0073      EIP: b776da8c  ERR: 00000024  EFLAGS: 00000246 

The behavior seems to happen more easily on new filesystems, or on a 
filesystem whose old checkpoints have all been removed by rmcp and 
nilfs-clean.  It gets better once the filesystem is full again and 
nilfs_cleanerd has had a chance to run automatically.

If the issue can be reproduced with an order=relaxed mount, I have not 
tested it sufficiently.  Spot-tests seem OK.

The full core dump is available, should you need it.

Thanks!

Michael

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
