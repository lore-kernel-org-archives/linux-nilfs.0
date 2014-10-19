From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 0/1] improve inode allocation
Date: Sun, 19 Oct 2014 19:17:10 +0200
Message-ID: <1413739031-13347-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

The following patch is a very simplified version of the the one I sent 
in a week ago. My benchmarks showed, that the aligned allocation of 
directories create too much overhead.

I used a very simple C program that creates millions of inodes as a 
benchmark. I uploaded the source code to github:

https://github.com/zeitgeist87/inodetest

Here are the results:

1.) One process, 20 million inodes:
    a) Normal Nilfs
        $ time inodetest 1000 1000 20
        real    3m50.431s
        user    0m5.647s
        sys     2m50.760s

        $ time find ./ > /dev/null
        real    5m49.021s
        user    0m27.917s
        sys     1m14.197s
    b) Improved Nilfs
        $ time inodetest 1000 1000 20
        real    2m31.857s
        user    0m5.950s
        sys     1m29.707s

        $ time find ./ > /dev/null
        real    5m49.060s
        user    0m27.787s
        sys     1m13.673s
2.) Three processes in parallel, total of 60 million inodes
    a) Normal Nilfs
        $ time inodetest 1000 1000 20 &
        $ time inodetest 1000 1000 20 &
        $ time inodetest 1000 1000 20 &
        real    20m21.914s
        user    0m5.603s
        sys     17m43.987s

        $ time find ./ > /dev/null
        real    28m10.340s
        user    1m38.477s
        sys     5m9.133s
    b) Improved Nilfs
        $ time inodetest 1000 1000 20 &
        $ time inodetest 1000 1000 20 &
        $ time inodetest 1000 1000 20 &
        real    6m21.609s
        user    0m5.970s
        sys     3m8.100s

        $ time find ./ > /dev/null
        real    30m35.320s
        user    1m40.577s
        sys     5m14.580s

There is a significant improvement in runtime for both the single and 
multiple process case. It is also notable, that the improved version 
scales much better for parallel processes.

"find ./ > /dev/null" is virtually identical for the benchmark 1.a and 
1.b, but 2.b is consitently slower by 2 minutes, which I cannot 
currently explain.

I repeated the benchmarks several times and there were only tiny 
variations in the results. 

Best regards
Andreas Rohner  

Andreas Rohner (1):
  nilfs2: improve inode allocation

 fs/nilfs2/ifile.c   | 31 +++++++++++++++++++++++++++++--
 fs/nilfs2/ifile.h   |  1 +
 fs/nilfs2/segment.c |  5 ++++-
 3 files changed, 34 insertions(+), 3 deletions(-)

-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
