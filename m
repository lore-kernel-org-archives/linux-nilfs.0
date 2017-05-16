From: Rodrigo Severo <rodrigo-sUXncmUOihszlUgHzu1iJkEOCMrvLtNR@public.gmane.org>
Subject: nilfs_cleanerd high CPU usage
Date: Tue, 16 May 2017 16:16:39 -0300
Message-ID: <CAOdi6iZv-GSZfGmGbASpaXn26g8F2_F2J-ycDwJ421jcg+9iBA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fabricadeideias-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=WS2IiNsde7dqCGHZtAtqKOv9YYrb2TV1sXd6vRd5YOg=;
        b=sK2bYHMfPZdzJWbwXEHVQ28IePTMPcr96M9lSLSxIsw8U73hSOGsevOK88SFUXRu5n
         BcY0o3IgJYk4MyCjZ/QM6HaYZEBV1v7dS6IojPSlkS9BBTpoaC8EPKNnWPeFpW6VD5JM
         MG1d7snCg10MnqET/8G7Ztu0q0c7JaAscjR7HnK/z2kkm0AOCacYgykV9QoYLcN1djo/
         ylAeo+SLk19MngIUg+06ynEB1Qt5noTVT5Y6bnOQdUbKmMyd1oKs0dB9yLWDN6iSdUPL
         y4OLAzVGrGRkgGo2j8wTE51MbTglToiupq9ui4radrCUC/nGmZtZQpe89NFPd77Mmuor
         b0tw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,


I currently have 7 disks formatted as nilfs, each one a 8 TB HD:

---------------------------------------------
# df -h -t nilfs2
Filesystem      Size  Used Avail Use% Mounted on
/dev/sde1       7.3T  362G  6.6T   6% /empauta/arquivo_06
/dev/sdc1       7.3T  6.3T  709G  90% /empauta/arquivo_03
/dev/sdg1       7.3T  6.2T  740G  90% /empauta/arquivo_01
/dev/sdh1       7.3T  5.8T  1.2T  84% /empauta/arquivo_02
/dev/sdi1       7.3T  5.9T  1.1T  85% /empauta/arquivo_04
/dev/sdf1       7.3T  1.8T  5.2T  26% /empauta/arquivo_05
/dev/sdj1       7.3T  5.7T  1.3T  83% /mnt/velho
---------------------------------------------

The cleanerd for the ones that got full enough are using what seems to
me as an excessive amount of CPU:

---------------------------------------------
# ps auxww | grep nilfs
root      1134  0.0  0.0  10716   124 ?        S    May13   0:00
/sbin/nilfs_cleanerd /dev/sde1 /empauta/arquivo_06
root      1147 13.4  0.1  40608 27316 ?        D    May13 614:40
/sbin/nilfs_cleanerd /dev/sdc1 /empauta/arquivo_03
root      7666  0.5  0.1  39704 27128 ?        D    May13  25:54
/sbin/nilfs_cleanerd /dev/sdg1 /empauta/arquivo_01
root      7679  4.7  0.1  39792 27368 ?        S    May13 217:54
/sbin/nilfs_cleanerd /dev/sdh1 /empauta/arquivo_02
root      7694 14.5  0.1  39792 27384 ?        S    May13 662:24
/sbin/nilfs_cleanerd /dev/sdi1 /empauta/arquivo_04
root      7705  0.0  0.0  10716   128 ?        S    May13   0:00
/sbin/nilfs_cleanerd /dev/sdf1 /empauta/arquivo_05
root     13579  0.0  0.0  10716   128 ?        S    May15   0:00
/sbin/nilfs_cleanerd /dev/sdj1 /mnt/velho
---------------------------------------------

I seeing nilfs_cleanerd processes with more than 25% CPU usage most of
the time and sometimes getting up to 40% CPU on a AMD FX 8320.

I'm using the ubuntu defaults on /etc/nilfs_cleanerd.conf:

---------------------------------------------
# cat /etc/nilfs_cleanerd.conf
# nilfs_cleanerd.conf - configuration file of NILFS cleaner daemon.
#
# This file contains GC parameters that are loaded when cleaner gets
# started.  You can force them to be reloaded by sending a HUP signal
# to the cleaner process.
#
# Each parameter is declared with a keyword-value pair or a directive
# with no argument.  Lines beginning with "#" are ignored.  For
# details, see the man page of nilfs_cleanerd.conf(5).

# Protection period in second.
protection_period       3600

# Minimum number of clean segments
#   0 = continuous cleaning
# > 0 = pause cleaning until less segments are available
min_clean_segments      10%

# Maximum number of clean segments
max_clean_segments      20%

# The argument of min_clean_segments and max_clean_segments can be
# followed by a percent sign (%) or one of the following
# multiplicative suffixes: K 1024, MB 1000*1000, M 1024*1024, GB
# 1000*1000*1000, G 1024*1024*1024, and so on for T, P, E.
#
# If the argument is followed by "%", it represents a disk capacity
# ratio.

# Clean segment check interval in seconds
clean_check_interval    10

# Segment selection policy.
# In NILFS version 2.0.0, only the timestamp policy is supported.
selection_policy        timestamp       # timestamp in ascend order

# The maximum number of segments to be cleaned at a time.
nsegments_per_clean     2

# The maximum number of segments to be cleaned at a time
# if clean segments < min_clean_segments
mc_nsegments_per_clean  4

# Cleaning interval in seconds.
cleaning_interval       5

# Cleaning interval in seconds
# if clean segments < min_clean_segments
mc_cleaning_interval    1

# Retry interval in seconds.
retry_interval          60

# Specify the minimum number of reclaimable blocks in a segment
# before it can be cleaned.
min_reclaimable_blocks  10%

# Specify the minimum number of reclaimable blocks in a segment
# before it can be cleaned.
# if clean segments < min_clean_segments
mc_min_reclaimable_blocks       1%

# The argument of min_reclaimable_blocks and mc_min_reclaimable_blocks
# can be followed by a percent sign (%) or one of the following
# multiplicative suffixes similar to min_clean_segments.
#
# If the argument is followed by "%", it represents a ratio for the
# number of blocks per segment.

# enable set_suinfo ioctl if supported
# (needed for min_reclaimable_blocks)
use_set_suinfo

# Use mmap when reading segments if supported.
use_mmap

# Log priority.
# Supported priorities are emerg, alert, crit, err, warning, notice, info, and
# debug.
log_priority            info
---------------------------------------------

Is this normal? Is the clean operation such a high CPU usage one?

Is there a way to lower nilfs_cleanerd CPU usage without impacting the
cleaning process?


Regards,

Rodrigo Severo
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
