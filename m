From: Tim Benham <tim.j.benham-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs_cleanerd wont run after 3.7.2 upgrade
Date: Sun, 20 Jan 2013 16:51:36 +1000
Message-ID: <CACc=JvH81x9hUqGmn7b-sYuu0UhQpVBnOCSOjtZfDNhK0s-F8Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:date:message-id:subject:from:to
         :content-type;
        bh=DAdbdj2s1h/pJYryC/i1OxQfZiK0XiTSiRi7Tydq6X4=;
        b=VDdJh9Y3htlC/2+uhFXW+4gtLL5e+Zlj0jESfEkKXXO0494yWje20Wp+hn8UsarjQo
         dnQ1CWDaBxJ9BDGdtis46znjwDX4Qv0tEvLw9rFTtGVWWCZki09D2QAprieBFRIZEl0w
         y5mFLOgXK4SCvG5t+CZ+I0aNp7azZUn57dkcTkmDn1LQUawNEqQfGHEQwbx7CJQ41Ces
         hQFaFRu1h09Hv35KJbzn+SMkgNj51vo4nRfduBGKTtqFLKkJ4kPNjsIb4YkPTFbHokDk
         snzpXCI6MLmzjSeeCaDgZHQlXW9YpIdXIjdnDuqtLyv1jbfikmPFQObB+LP2T7IPxJmo
         OwAg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

After upgrading from the 3.5.0 to the 3.7.2 kernel I cannot get
nilfs_cleanerd to start. Trying to start it causes the following lines
to be appended to the system log.

Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: start
Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: cannot open nilfs on
(null): No such file or directory
Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: cannot create cleanerd
on (null): No such file or directory
Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: shutdown

My root file system is nilfs2. Cleanerd has never started on mount. I
worked around this by creating a local.d script that starts it. Then
this stopped working. I was able to get it going again by modifying my
script to create a /dev/root symlink. Now I cannot get it to start at
all. Giving it the root device explicitly doesn't work either


# nilfs_cleanerd /dev/sda2
Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: start
Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: cannot open nilfs on
/dev/sda2: No such file or directory
Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: cannot create cleanerd
on /dev/sda2: No such file or directory
Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: shutdown
 # ls -l /dev/sda2
brw-rw---- 1 root disk 8, 2 Jan 20 16:18 /dev/sda2

mount -t nilfs2 -o remount /dev/sda2 / produces an identical set of messages.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
