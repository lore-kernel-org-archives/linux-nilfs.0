From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/1] improve inode allocation
Date: Tue, 21 Oct 2014 20:22:04 +0200
Message-ID: <5446A44C.9040002@gmx.net>
References: <1413739031-13347-1-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413739031-13347-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

I extended the inode test to delete a certain number of inodes.

https://github.com/zeitgeist87/inodetest

This should make the benchmark a little bit more realistic, but the
results are essentially the same as before. For the following tests
about 10% of the inodes were continuously deleted:

1.) One process, 20 million inodes, 2 million deleted:
    a) Normal Nilfs
        $ time inodetest 1000 1000 20 100
        real    3m49.793s
        user    0m6.323s
        sys     2m47.947s

        $ time find ./ > /dev/null
        real    5m21.020s
        user    0m25.440s
        sys     1m6.633s
    b) Improved Nilfs
        $ time inodetest 1000 1000 20 100
        real    2m35.011s
        user    0m6.847s
        sys     1m33.093s

        $ time find ./ > /dev/null
        real    5m18.922s
        user    0m25.323s
        sys     1m6.877s
2.) Three processes in parallel, 60 million inodes, 6 million deleted
    a) Normal Nilfs
        $ time inodetest 1000 1000 20 100 &
        $ time inodetest 1000 1000 20 100 &
        $ time inodetest 1000 1000 20 100 &
        real    19m18.135s
        user    0m7.973s
        sys     16m16.833s

        $ time find ./ > /dev/null
        real    29m38.577s
        user    1m32.763s
        sys     4m44.140s
    b) Improved Nilfs
        $ time inodetest 1000 1000 20 100 &
        $ time inodetest 1000 1000 20 100 &
        $ time inodetest 1000 1000 20 100 &
        real    6m30.458s
        user    0m6.697s
        sys     3m10.213s

        $ time find ./ > /dev/null
        real    28m50.304s
        user    1m30.133s
        sys     4m40.770s


So the performance improved 32% for a single process and 66% for
multiple processes.

All benchmarks were run on an AMD Phenom II X6 1090T processor with 6
cores and 8 GB of RAM.

Best regards
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
