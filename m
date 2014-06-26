From: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs_clean_segments: segment construction failed. (err=-2)
Date: Thu, 26 Jun 2014 10:30:35 +0530
Message-ID: <53ABA8F3.3010606@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        bh=dzVNbXCWl9jjzHhUpRl3EptErTjIXDikHUiFziVyQlI=;
        b=UteAas9LzNYOwvIFLgYNtvu0coBAvImU1XKuqXFHekQ2sgc5x8eKUhqdmd+SpZFAIH
         Ig4ObnRxuI/JoBCUkDrCnxq/BGNB0yhnQXTtGdgBVsFL9cz0nEF2ZT0U2bPyTlIScXng
         ZNMZUCa707xyLnlv9ot2QSblxQsMGbfFl6QhGjXmFU5wJA7fPM60USEL+6/TtBUucWMC
         iF2eUsbbv89OHgPUmqn0R5mJzRSJ1buBa8uLlh2esH0EBQ/Si6q9rABC0HUFcWt+go+1
         dKASGoqIO1VeGD/XBzVB9oT/KHhwTghi5e1odGtWwJtnXu9yaJOH07r9NPosyabPEQU3
         8RuA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi!

I'm using nilfs on thumb drives to sync Bitcoin wallets and it's forks.

Sometimes, when I quit the bitcoin-qt application, this is what happens 
(in dmesg)

[159141.505498] nilfs_btree_propagate: key = 10, level == 0
[159141.715622] nilfs_btree_propagate: key = 10, level == 0
[159141.716134] NILFS warning (device dm-0): nilfs_clean_segments: 
segment construction failed. (err=-2)
[159146.715145] nilfs_btree_propagate: key = 10, level == 0
[159146.715152] NILFS warning (device dm-0): nilfs_clean_segments: 
segment construction failed. (err=-2)
[159151.715018] nilfs_btree_propagate: key = 10, level == 0
[159151.715026] NILFS warning (device dm-0): nilfs_clean_segments: 
segment construction failed. (err=-2)
[159156.714892] nilfs_btree_propagate: key = 10, level == 0
...
...
...
[160276.691089] nilfs_btree_propagate: key = 10, level == 0
[160276.691096] NILFS warning (device dm-0): nilfs_clean_segments: 
segment construction failed. (err=-2)
[160281.690959] nilfs_btree_propagate: key = 10, level == 0
[160281.690967] NILFS warning (device dm-0): nilfs_clean_segments: 
segment construction failed. (err=-2)

I can still access the thumbdrive and it's contents. In the mean time 
many processes remain at D state and I have to force restart.

The devices used are perfectly fine. I've 3 of them, 2 of them are used 
as a single LVM volume and another one uses the whole device as a nilfs 
FS (no partition table).
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
