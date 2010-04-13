From: Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: crashing real time kernel
Date: Tue, 13 Apr 2010 21:16:24 +0200
Message-ID: <t2kee5afd761004131216ke44d82f2g1f9d9d21d5e757e6@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:date:received:message-id
         :subject:from:to:content-type;
        bh=O6P/FA4NoBNa7hY0TzO/tMNGR+L2RKVzVHHWtDwqyV0=;
        b=FopxeD9YeTp3OehibUIePuBxT+7VBxYrzq18RxXKINfQWDgKh5FpooTYoz/XH31YQI
         DmFqPAjzSKIGzh4wEBp9frUwYzUnQnMOH1nGkV5xjoH9scBjLwuQXEC9qF/VML+EnyXw
         D5B8GErgWg/jbIc/yORGa1vHKH6D2Lm8JoiQY=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Sorry here is the NILFS version:

jan@debianLenny:~/NilFsMaster/nilfs2-module$ git log
commit d26b512fa141768902ea8c78bf97a880f0de36ce
Author: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Date:   Sun Jan 31 12:39:50 2010 +0900

    nilfs2: fix potential leak of dirty data on umount

    This fixes incorrect usage of nilfs_segctor_confirm() test function in
    nilfs_segctor_destroy(); nilfs_segctor_confirm() returns zero if the
    filesystem is not clean, so its use in nilfs_segctor_destroy() needs
    inversion.

    Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>


jan@debianLenny:~/NilFsMaster/nilfs2-utils$ git log
commit 8b376d75f8dcff5fea121cbc66e7e3b01ede9cc6
Author: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Sat Feb 13 12:34:30 2010 -0600

    nilfs2-utils: fix build against newer glibc

    Changes in recent glibc were breaking the build on Rawhide;
    we need to explicitly include sys/stat.h to get S_ISREG etc.

    See also https://bugzilla.redhat.com/show_bug.cgi?id=564788

    Signed-off-by: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>


Jan de Kruyf.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
