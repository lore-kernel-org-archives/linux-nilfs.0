From: Zavi Zavi <zavi05-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: NILFS2 under stress
Date: Fri, 15 Jun 2012 12:07:23 +0300
Message-ID: <CAPLqH6x7OCXS95w7-J+DLdiVkKAuKm=-8ofGwL-rcC19Z679bw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=En2NdDlAu59MGh5gNE2limqRcyMMb7rzPqcc3PiuCW8=;
        b=yPUGw/qN14HWAjtZe0s8/M1R1LVT/hcqlMXVbzWJxLIQ4ekJhlFdvWw5OsAw8hFokn
         v9AUvsh4TktEob1WuOcHNTt1v2L1/Wq29ygOzbP73w6E1y7WEY/2JYu1cTAucpxvpbVB
         JJhQhWRFnV4IncVmx5IcD+3ymQ8bzOLfSZXqQTbxMEEdoFJt1ZKfFDJH14VlLo5YJPz3
         GwlFAMb8wdxomb5kBko8NpKdbVdgBmdx5QLd1yzNxhZFx1C4ckiJ0c0xuLNroebNJtOr
         Phv2bggfm9vbquC4ahynedtZPAthvdE0tdHDPoWm5gatP7g8+URswsH4NQNh9f4gOFq6
         +piw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I've been experimenting with NILFS2 on a 8GB USB stick.
I repeatedly created and deleted a 128MB file. After about 60 attempts, the
disk got 100% full, and would not respond anymore.

So I tried repeating this setup after changing the GC settings to be much
more agressive GC policy
protection_period       0
min_clean_segments      10%
max_clean_segments      20%
clean_check_interval    1
nsegments_per_clean     20
mc_nsegments_per_clean  40
cleaning_interval       1
mc_cleaning_interval    1
retry_interval          3

This time I was able to do the above even for 80 times, and indeed saw that
the free space on the device was periodically decreased

So I continued with filling up the file system to about half of its
capacity (3.5GB) with large 128MB files.
I then tried running a small 60 seconds fileserver benchmark of FileBench,
which uses 1.5GB.
I was able to run it twice, but then the system got 100% full again, and
non-responsive.
I tried running nilfs_cleanerd manually, tried remounting. nothing worked.

Is NILFS known to be sensitive to stress tests? Is this expected?
Or am I doing something wrong?

Thank you
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
